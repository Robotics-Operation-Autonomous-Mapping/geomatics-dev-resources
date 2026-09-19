# Sample data — download it yourself

This repo does **not** ship rosbags and there is **no shared drive**. You install
public datasets the same way you will later install anything else: official page
→ `curl` → checksum → unpack → convert into the paths the checkpoints expect.

```bash
# from repo root — ~8 MB, IMU + GNSS for CP1 and most of CP2
./scripts/download_sample_data.sh

# print the curl lines without downloading (read these)
./scripts/download_sample_data.sh --print-commands core

# Autoware sample map + bag when you reach that exercise
./scripts/download_sample_data.sh cp2-autoware
```

**Kalibr (CP2):** install the ETH Zurich EuRoC example bags yourself from the
[Kalibr Downloads wiki](https://github.com/ethz-asl/kalibr/wiki/Downloads)
(`cam_april.bag`, `imu_april.bag`). Put them in `data/cp2/kalibr_cam_imu/`.

Files land under `data/` (gitignored). After a download, `git status` must **not**
show bags you are about to commit.

## What you download

| Target | Source (official) | Size | Used for |
|--------|-------------------|------|----------|
| `core` | [KITTI tracking GPS/IMU](https://www.cvlibs.net/datasets/kitti/eval_tracking.php) (`data_tracking_oxts.zip`) | ~8 MB | CP1 IMU bag/CSV, CP2 GNSS ENU, CP2 Allan **pipeline** |
| `cp2-autoware` | [Autoware rosbag-replay demo](https://autowarefoundation.github.io/autoware-documentation/main/demos/rosbag-replay-simulation/) S3 artifacts | ~3 MB map + ~202 MB bag | CP2 localization smoke |
| *(manual)* Kalibr | [Kalibr Downloads](https://github.com/ethz-asl/kalibr/wiki/Downloads) — ETH Zurich EuRoC `cam_april.bag` / `imu_april.bag` | large | CP2 cam–IMU calibration |

Cite the authors if you publish (KITTI: Geiger et al.; EuRoC: Burri et al.; Autoware sample: TIER IV / Autoware Foundation).

## Learn the mechanics (do this once)

1. Open the official page. Confirm it is the **dataset site**, not a random mirror.
2. Copy the file URL. Fetch with curl (the script prints the exact line):

   ```bash
   mkdir -p data/.cache
   curl -L --fail --progress-bar -o data/.cache/data_tracking_oxts.zip \
     https://s3.eu-central-1.amazonaws.com/avg-kitti/data_tracking_oxts.zip
   ```

3. Check the hash (the script does this for KITTI and Autoware):

   ```bash
   python3 -c "import hashlib,pathlib; p=pathlib.Path('data/.cache/data_tracking_oxts.zip'); print(hashlib.sha256(p.read_bytes()).hexdigest())"
   # expect 0b93e47a01d9479b7aeffcad50c0a08566f723119b6dfb7a11da3466acaf02de
   ```

4. Convert OXTS → CSV / rosbag2:

   ```bash
   python3 -m pip install --user rosbags    # needed to write a rosbag2 for ros2 bag play
   python3 scripts/kitti_oxts_prepare.py \
     --zip data/.cache/data_tracking_oxts.zip \
     --sequence 0009 \
     --repo-root .
   ```

Default sequence `0009` is ~80 s at 10 Hz. Override with `KITTI_SEQUENCE=0000` (shorter) if you want.

## Checkpoint paths

| Checkpoint | Local path | Notes |
|------------|------------|-------|
| CP1 | `data/cp1/imu_raw` | rosbag2, topic `/imu/data`. CSV also at `data/cp1/imu.csv` |
| CP2 Allan | `data/cp2/imu_static/imu.csv` | **KITTI is a moving car**, not a static IMU. Use it to wire the script; explain in oral why the Allan curve is not datasheet-like. Record a real static log when you have hardware. |
| CP2 GNSS | `data/cp2/gnss_raw/kitti_oxts.csv` | columns `t,lat,lon,alt,fix_quality,numsats` (`fix_quality` = KITTI `posmode`) |
| CP2 Kalibr | `data/cp2/kalibr_cam_imu/*.bag` | Download ETH Zurich EuRoC bags from the Kalibr wiki yourself. Target yaml: `checkpoints/cp2_sensors_calib/kalibr/april_6x6.yaml` |
| CP2 Autoware | `data/cp2/autoware_localize/` | `sample-map-rosbag/` + `sample-rosbag/` after `cp2-autoware` |
| CP3 | `data/cp3/<your_run>/` | **Your** field bag. Public sets are for dry-runs only — see below. |

## CP3

Pass requires a real collect following [field-checklist.md](field-checklist.md). Do not commit the bag.

Optional dry-run before field day: run KISS-ICP on a public LiDAR bag from that project's README (or the Autoware sample bag). That does **not** replace the collect.

## Bag naming (your recordings)

```
YYYYMMDD_HHMMSS_<platform>_<site>_<purpose>.mcap
```

Examples:

- `20260919_143022_rover1_lotA_imu_static.mcap`
- `20260920_091500_rover1_lotA_slam_loop.mcap`

Sidecar metadata (same basename, `.yaml`):

```yaml
date: "2026-09-19"
platform: rover1
site: lotA
purpose: imu_static
operator: alice
sensors: [imu0, gnss0, cam0, lidar0]
ros_distro: humble   # or jazzy
notes: "Static capture for Allan; 30 min"
rtk: false
```

## Gitignore

`data/` is ignored except `data/README.txt`. Never commit full rosbags.
