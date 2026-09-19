# Checkpoint 2 — Sensors, calibration, Autoware

From provided raw data, complete four deliverables. Thresholds are objective.

## Requirements

1. **Allan variance** on an IMU log → plot + extract noise density and random walk into YAML
2. **GNSS** parse → local ENU trajectory plot colored by fix quality
3. **Camera + camera–IMU calibration** (Kalibr) with reprojection error **≤ 0.5 px RMS**, plus a short write-up of what improved it
4. **Autoware sensor description** filled with calibrated extrinsics; stack launches and localizes on the provided bag

## Pass criteria

| Check | Pass when |
|-------|-----------|
| Scripts | `scripts/run_cp2.sh` runs end-to-end (skips missing optional stages with clear WARN) |
| Numbers | Within tolerance of [`reference/tolerances.yaml`](reference/tolerances.yaml) |
| Kalibr | RMS reprojection ≤ **0.5 px** |
| Autoware | Sensor kit launches; localization produces pose on sample bag |
| Oral | Explain each result — [rubric](../../docs/reviewer-rubric.md) |

## Layout

```
scripts/
  allan_variance.py
  gnss_to_enu.py
  check_tolerances.py
  run_cp2.sh
kalibr/
  README.md              # workflow + output paths
reference/
  tolerances.yaml
  imu_noise_reference.yaml
sensor_kit/              # Autoware description stubs (also under templates/)
```

## Data

See [docs/data.md](../../docs/data.md). Expected paths after download:

- `data/cp2/imu_static`
- `data/cp2/gnss_raw`
- `data/cp2/kalibr_cam_imu`
- `data/cp2/autoware_localize`

## Run

```bash
./checkpoints/cp2_sensors_calib/scripts/run_cp2.sh
```

Write-up: copy [`templates/checkpoint-report.md`](../../templates/checkpoint-report.md) → `checkpoints/cp2_sensors_calib/REPORT.md` (do not leave empty Kalibr section).
