# Tier 2 — Sensors, calibration, and Autoware

Reading list + exercises. Complete [Checkpoint 2](../checkpoints/cp2_sensors_calib/) to pass.

## Frames and math

### Read

- Rotation matrices, quaternions, SE(3): [ROS tf2 overview](https://docs.ros.org/en/humble/Concepts/Intermediate/About-Tf2.html) and a solid spatial-math primer of your choice (e.g. modern robotics chapters on SO(3)/SE(3))
- Intrinsics vs extrinsics: OpenCV camera calibration docs — [Camera Calibration and 3D Reconstruction](https://docs.opencv.org/4.x/d9/d0c/group__calib3d.html)
- ECEF / LLA / ENU: skim [WGS84](https://en.wikipedia.org/wiki/World_Geodetic_System) + pymap3d or similar library docs for conversions

### Exercises

1. Given a quaternion, convert to roll/pitch/yaw and back; check round-trip error.
2. Hand-compose an extrinsic \(T_{\mathrm{base}}^{\mathrm{cam}}\) and transform a point; verify with `tf2`.
3. Convert a lat/lon/alt fix to ENU relative to a chosen origin; plot 2D.

## Time sync

### Read

- Hardware vs software timestamps: Autoware / sensor driver docs for your stack; ROS clock and `use_sim_time`
- Why time offsets wreck fusion: Kalibr cam-IMU papers/docs discuss delay estimation — start at [Kalibr](https://github.com/ethz-asl/kalibr)

### Exercises

1. From a bag, compare `header.stamp` vs receive time for IMU vs camera (or use `ros2 bag info` + a small echo script). Write three sentences on what you saw.

## IMU

### Read

- Noise density, bias, scale factor; Allan variance: [IEEE Std 952](https://standards.ieee.org/) (skim concepts) or open Allan-variance explainers used by Kalibr/imu_utils communities
- Practical scripts: follow CP2 `allan_variance.py` stub comments

### Exercises

1. Run (or complete) Allan variance on `data/cp2/imu_static`; extract noise density and random walk into YAML.
2. Explain in one paragraph what happens to integration if bias is wrong by a fixed amount.

## Cameras

### Read

- Pinhole + distortion: OpenCV calib3d (link above)
- Intrinsic calibration with a target; reprojection error meaning
- **Event cameras / Triton2:** read your team pipeline — `TODO:TRITON2_PIPELINE_URL` — plus a short intro such as [Metavision concepts](https://docs.prophesee.ai/stable/concepts.html) (or equivalent for your sensor)

### Exercises

1. Calibrate a pinhole camera with a printed target; report RMS reprojection error.
2. For Triton2: list which topics/files the team pipeline expects and where timestamps come from (link the pipeline doc).

## Camera–IMU extrinsics and time offset

### Read

- [Kalibr wiki / README](https://github.com/ethz-asl/kalibr) — multi-camera and cam-IMU workflows
- How to spot bad results: high reprojection error, unstable extrinsics across runs, huge time delays

### Pass threshold (team)

**Reprojection error ≤ 0.5 px RMS** for the cam-IMU calibration used in CP2. Tighten later only by lead decision; document any change in the CP2 README.

### Exercises

1. Run Kalibr on the provided sequence; save results under the paths described in CP2.
2. Write ≤½ page: what you changed to improve the result (exposure, target motion, filtering bad views, etc.).

## GNSS

### Read

- Constellations overview (GPS/Galileo/GLONASS/BeiDou)
- NMEA vs UBX: u-blox interface docs (skim)
- RTK vs standalone; base station + NTRIP concepts
- Antenna lever arm: why it matters for localization

### Exercises

1. Parse the CP2 GNSS log; convert to local ENU; plot trajectory colored by fix quality.
2. Compute lever-arm effect: 10 cm arm error → approximate lateral error at a given heading (order-of-magnitude).

## Autoware

### Read

- [Autoware documentation home](https://autowarefoundation.github.io/autoware-documentation/main/)
- Architecture / component overview (docs site)
- Sensor kit & vehicle description conventions in Autoware Universe
- Map formats (point cloud map, Lanelet2) — docs under localization / map components
- Running from a bag; NDT scan matcher; localization inputs

### Exercises

1. Fill the sensor description template in CP2 using your calibrated extrinsics.
2. Launch the provided localization smoke (Docker OK) on the CP2 bag; confirm pose output.

## Checkpoint 2

See [`checkpoints/cp2_sensors_calib/`](../checkpoints/cp2_sensors_calib/). Oral prompts: [reviewer-rubric.md](reviewer-rubric.md).
