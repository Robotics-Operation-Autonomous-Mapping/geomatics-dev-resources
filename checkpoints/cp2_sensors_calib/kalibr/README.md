# Kalibr workflow (CP2)

Official docs: [ethz-asl/kalibr](https://github.com/ethz-asl/kalibr)

## Team threshold

**Reprojection error ≤ 0.5 px RMS** for the camera–IMU calibration used in Autoware extrinsics.

Leads may tighten later; record any change in this file and in [tolerances.yaml](../reference/tolerances.yaml).

## Inputs

Place bags under `data/cp2/kalibr_cam_imu/` (see [docs/data.md](../../../docs/data.md)).

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
