#!/usr/bin/env python3
"""Compare student imu_noise.yaml to reference within tolerances."""

from __future__ import annotations

import argparse
import math
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    print('PyYAML required', file=sys.stderr)
    raise SystemExit(2)


def _get(d: dict, *keys: str) -> float:
    cur: object = d
    for k in keys:
        cur = cur[k]  # type: ignore[index]
    return float(cur)


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser()
    p.add_argument('--student', type=Path, required=True)
    p.add_argument('--reference', type=Path, required=True)
    p.add_argument('--tolerances', type=Path, required=True)
    args = p.parse_args(argv)

    student = yaml.safe_load(args.student.read_text(encoding='utf-8'))
    reference = yaml.safe_load(args.reference.read_text(encoding='utf-8'))
    tol = yaml.safe_load(args.tolerances.read_text(encoding='utf-8'))

    checks = [
        ('accelerometer', 'noise_density'),
        ('accelerometer', 'random_walk'),
        ('gyroscope', 'noise_density'),
        ('gyroscope', 'random_walk'),
    ]
    rel = float(tol.get('imu_noise_relative', 0.5))
    abs_floor = float(tol.get('imu_noise_abs_floor', 1e-6))

    failed = False
    for group, key in checks:
        s = _get(student, group, key)
        r = _get(reference, group, key)
        if math.isnan(s):
            print(f'[FAIL] {group}.{key} is NaN (implement allan_variance)')
            failed = True
            continue
        allow = max(abs(r) * rel, abs_floor)
        err = abs(s - r)
        status = 'OK' if err <= allow else 'FAIL'
        print(f'[{status}] {group}.{key}: student={s:.6g} ref={r:.6g} err={err:.6g} allow={allow:.6g}')
        if err > allow:
            failed = True

    kalibr_max = float(tol.get('kalibr_reprojection_rms_px', 0.5))
    print(f'[INFO] Kalibr RMS must be <= {kalibr_max} px (checked manually / REPORT.md)')
    return 1 if failed else 0


if __name__ == '__main__':
    raise SystemExit(main())
