# Sample data and bag conventions

## Shared drive

**Root URL:** `TODO:SHARED_DRIVE_URL`

Expected layout on the drive (create folders to match):

```
roam-geomatics-data/
  cp1/
    imu_raw/                 # rosbag2 with sensor_msgs/Imu
  cp2/
    imu_static/              # long static IMU log for Allan variance
    gnss_raw/                # NMEA or UBX log (+ optional bag)
    kalibr_cam_imu/          # Kalibr-ready sequences
    autoware_localize/       # bag + map for localization smoke
  cp3/
    examples/                # optional reference run (not a substitute for your collect)
  README.txt                 # mirror of bag naming + contact for access
```

Download helper (after the URL is set):

```bash
./scripts/download_sample_data.sh
# data lands under ./data/ (gitignored)
```

## Bag naming

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

## Checkpoint inputs

| Checkpoint | Expected local path after download | Notes |
|------------|--------------------------------------|-------|
| CP1 | `data/cp1/imu_raw` | Raw IMU; topic name often `/imu/data` (override via param) |
| CP2 Allan | `data/cp2/imu_static` | Prefer long static log |
| CP2 GNSS | `data/cp2/gnss_raw` | CSV/NMEA/UBX as documented in CP2 README |
| CP2 Kalibr | `data/cp2/kalibr_cam_imu` | Follow Kalibr bag layout |
| CP2 Autoware | `data/cp2/autoware_localize` | Bag + PCD/Lanelet as provided |
| CP3 | Your field bag under `data/cp3/<your_run>/` | Must follow [field-checklist.md](field-checklist.md) |

## Gitignore

`data/` is ignored except optional tiny fixtures under each checkpoint's `reference/`.
