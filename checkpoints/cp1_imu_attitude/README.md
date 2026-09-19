# Checkpoint 1 — IMU roll/pitch + tf2

Build a ROS 2 package that estimates roll and pitch from accelerometer data in a rosbag, publishes the result, and broadcasts a tf2 transform.

## Requirements

Given a rosbag with raw IMU data, your package must:

1. Subscribe to the IMU topic (parameterized name)
2. Compute **roll** and **pitch** from the accelerometer (gravity / stationary assumption)
3. Publish the result (e.g. `geometry_msgs/msg/Vector3` on `~/attitude` with x=roll, y=pitch, z=unused/nan)
4. Publish a **tf2** transform (e.g. `base_link` → `imu_attitude`) that tilts with the estimate
5. Ship a **launch file** and a **parameter** for the IMU topic name
6. Land via a **PR** with at least one review comment **resolved**

## Pass criteria

| Check | Pass when |
|-------|-----------|
| Build | `colcon build --packages-select cp1_imu_attitude` is clean |
| RViz | Frame tilts correctly while playing the sample bag |
| Fresh clone | Reviewer follows this README from a clean clone |
| Git | PR review comment resolved; no direct push to `main` |
| Oral | ~15 min — see [reviewer-rubric](../../docs/reviewer-rubric.md) |

## Layout (scaffolded)

```
cp1_imu_attitude/          # ROS package root (ament_python)
  cp1_imu_attitude/
    attitude_node.py       # STUB — implement math here
  launch/attitude.launch.py
  config/params.yaml
  package.xml
  setup.py
  setup.cfg
  resource/cp1_imu_attitude
scripts/check_cp1.sh       # smoke check against sample bag
```

## How to build and run

```bash
# from repo root
mkdir -p ~/roam_ws/src
ln -s "$(pwd)/checkpoints/cp1_imu_attitude" ~/roam_ws/src/cp1_imu_attitude
cd ~/roam_ws
source /opt/ros/$ROS_DISTRO/setup.bash
colcon build --packages-select cp1_imu_attitude
source install/setup.bash

# play bag (after ./scripts/download_sample_data.sh)
ros2 bag play ../../roam-onboarding/data/cp1/imu_raw --clock &
ros2 launch cp1_imu_attitude attitude.launch.py
# RViz2: add TF; set Fixed Frame to base_link (or as documented in your PR)
```

Override topic:

```bash
ros2 launch cp1_imu_attitude attitude.launch.py imu_topic:=/imu/data
```

## Smoke test

```bash
./checkpoints/cp1_imu_attitude/scripts/check_cp1.sh
```

The smoke script checks that the package is importable / launch file exists. Full bag playback checks are manual or CI when data is present.

## What you implement

Fill in `NotImplementedError` sections in `attitude_node.py`. Do not commit large bags.
