#!/usr/bin/env python3
"""Turn a KITTI tracking OXTS log into CP1/CP2 CSV (and an optional rosbag2).

KITTI OXTS layout (30 columns, 10 Hz), from the raw-data development kit:

  lat lon alt roll pitch yaw  vn ve vf vl vu  ax ay az af al au
  wx wy wz wf wl wu  pos_accuracy vel_accuracy  navstat numsats
  posmode velmode orimode

This file is a converter, not a tutorial. The download script prints the curl
you just ran; read docs/data.md for why these datasets are used.
"""

from __future__ import annotations

import argparse
import csv
import math
import sys
import zipfile
from pathlib import Path

DT_S = 0.1  # KITTI tracking OXTS is provided at 10 Hz
IMU_TOPIC = "/imu/data"
IMU_FRAME = "imu"


def rpy_to_quat(roll: float, pitch: float, yaw: float) -> tuple[float, float, float, float]:
    cr, sr = math.cos(roll / 2.0), math.sin(roll / 2.0)
    cp, sp = math.cos(pitch / 2.0), math.sin(pitch / 2.0)
    cy, sy = math.cos(yaw / 2.0), math.sin(yaw / 2.0)
    w = cr * cp * cy + sr * sp * sy
    x = sr * cp * cy - cr * sp * sy
    y = cr * sp * cy + sr * cp * sy
    z = cr * cp * sy - sr * sp * cy
    return x, y, z, w


def load_oxts_rows(text: str) -> list[dict]:
    rows: list[dict] = []
    for i, line in enumerate(text.splitlines()):
        line = line.strip()
        if not line:
            continue
        c = line.split()
        if len(c) < 30:
            raise ValueError(f"expected 30 OXTS columns, got {len(c)} on line {i + 1}")
        t = i * DT_S
        rows.append(
            {
                "t": t,
                "lat": float(c[0]),
                "lon": float(c[1]),
                "alt": float(c[2]),
                "roll": float(c[3]),
                "pitch": float(c[4]),
                "yaw": float(c[5]),
                "ax": float(c[11]),
                "ay": float(c[12]),
                "az": float(c[13]),
                "gx": float(c[17]),
                "gy": float(c[18]),
                "gz": float(c[19]),
                "fix_quality": int(float(c[27])),  # posmode; KITTI has no NMEA quality
                "numsats": int(float(c[26])),
            }
        )
    if not rows:
        raise ValueError("OXTS file was empty")
    return rows


def read_oxts(zip_path: Path, sequence: str) -> str:
    inner = f"training/oxts/{sequence}.txt"
    with zipfile.ZipFile(zip_path) as zf:
        try:
            return zf.read(inner).decode("utf-8")
        except KeyError as e:
            names = [n for n in zf.namelist() if n.endswith(".txt")]
            raise FileNotFoundError(
                f"{inner} not in zip. Available sequences: {', '.join(names[:12])} ..."
            ) from e


def write_imu_csv(path: Path, rows: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["t", "ax", "ay", "az", "gx", "gy", "gz"])
        w.writeheader()
        for r in rows:
            w.writerow({k: r[k] for k in w.fieldnames})


def write_gnss_csv(path: Path, rows: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["t", "lat", "lon", "alt", "fix_quality", "numsats"])
        w.writeheader()
        for r in rows:
            w.writerow({k: r[k] for k in w.fieldnames})


def write_rosbag2(bag_dir: Path, rows: list[dict]) -> None:
    try:
        from rosbags.rosbag2 import Writer
        from rosbags.typesys import Stores, get_typestore
        import numpy as np
    except ImportError as e:
        raise ImportError(
            "rosbag2 export needs the 'rosbags' package.\n"
            "  python3 -m pip install --user rosbags\n"
            "then re-run this script (CSV files are already written)."
        ) from e

    if bag_dir.exists():
        import shutil

        shutil.rmtree(bag_dir)

    typestore = get_typestore(Stores.ROS2_HUMBLE)
    imu_type = "sensor_msgs/msg/Imu"
    Imu = typestore.types[imu_type]
    Header = typestore.types["std_msgs/msg/Header"]
    Time = typestore.types["builtin_interfaces/msg/Time"]
    Vector3 = typestore.types["geometry_msgs/msg/Vector3"]
    Quaternion = typestore.types["geometry_msgs/msg/Quaternion"]

    try:
        writer_cm = Writer(bag_dir, version=9)
    except TypeError:
        writer_cm = Writer(bag_dir)

    with writer_cm as writer:
        conn = writer.add_connection(IMU_TOPIC, imu_type, typestore=typestore)
        cov = np.zeros(9, dtype=np.float64)
        for r in rows:
            sec = int(r["t"])
            nsec = int(round((r["t"] - sec) * 1e9))
            qx, qy, qz, qw = rpy_to_quat(r["roll"], r["pitch"], r["yaw"])
            msg = Imu(
                header=Header(stamp=Time(sec=sec, nanosec=nsec), frame_id=IMU_FRAME),
                orientation=Quaternion(x=qx, y=qy, z=qz, w=qw),
                orientation_covariance=cov,
                angular_velocity=Vector3(x=r["gx"], y=r["gy"], z=r["gz"]),
                angular_velocity_covariance=cov,
                linear_acceleration=Vector3(x=r["ax"], y=r["ay"], z=r["az"]),
                linear_acceleration_covariance=cov,
            )
            ts_ns = sec * 1_000_000_000 + nsec
            writer.write(conn, ts_ns, typestore.serialize_cdr(msg, imu_type))


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--zip", type=Path, required=True, help="data_tracking_oxts.zip")
    p.add_argument("--sequence", default="0009", help="training sequence id, e.g. 0009")
    p.add_argument("--repo-root", type=Path, required=True)
    p.add_argument("--skip-bag", action="store_true")
    args = p.parse_args(argv)

    rows = load_oxts_rows(read_oxts(args.zip, args.sequence))
    data = args.repo_root / "data"
    imu_csv = data / "cp1" / "imu.csv"
    imu_static = data / "cp2" / "imu_static" / "imu.csv"
    gnss_csv = data / "cp2" / "gnss_raw" / "kitti_oxts.csv"
    bag_dir = data / "cp1" / "imu_raw"

    write_imu_csv(imu_csv, rows)
    write_imu_csv(imu_static, rows)
    write_gnss_csv(gnss_csv, rows)
    print(f"Wrote {imu_csv} ({len(rows)} samples @ 10 Hz)")
    print(f"Wrote {imu_static} (same log; KITTI is a moving car - poor Allan input)")
    print(f"Wrote {gnss_csv}")

    if args.skip_bag:
        return 0
    try:
        write_rosbag2(bag_dir, rows)
        print(f"Wrote rosbag2 {bag_dir}  topic {IMU_TOPIC}")
    except ImportError as e:
        print(f"[WARN] {e}")
        return 0
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
