# Kalibr workflow (CP2)

Official docs: [ethz-asl/kalibr](https://github.com/ethz-asl/kalibr)

## Team threshold

**Reprojection error ≤ 0.5 px RMS** for the camera–IMU calibration used in Autoware extrinsics.

Leads may tighten later; record any change in this file and in [tolerances.yaml](../reference/tolerances.yaml).

## Inputs

Install the **ETH Zurich EuRoC** Kalibr example bags yourself (same files the
[Kalibr Downloads wiki](https://github.com/ethz-asl/kalibr/wiki/Downloads) lists):

- `cam_april.bag`
- `imu_april.bag`

Put them under `data/cp2/kalibr_cam_imu/` (gitignored). Do not commit the bags.

Configs in this folder (already in git):

- `april_6x6.yaml` — EuRoC Aprilgrid
- `imu_adis16448.yaml` — IMU noise priors + `/imu0`

Run Kalibr in its usual ROS1/Docker workflow on those bags.

## Expected outputs (commit paths in REPORT, not huge binaries)

```
output/kalibr/
  camchain-imucam.yaml
  report-imucam.pdf          # or html
  results-imucam.txt         # must include RMS reprojection
```

## Judging good vs bad

| Signal | Good | Bad |
|--------|------|-----|
| Reprojection RMS | ≤ 0.5 px | ≫ 0.5 px or unstable across runs |
| Time delay | Small, stable | Huge / flipping sign |
| Extrinsics | Repeatable | Jump when you re-run same bag |

## Write-up

In `REPORT.md`: what you changed to improve the result (motion, focus, filtering views, IMU noise priors, etc.).
