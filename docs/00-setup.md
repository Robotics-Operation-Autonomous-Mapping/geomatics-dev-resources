# Setup (before Tier 1)

Goal: a laptop that can build ROS 2 packages, play bags, and (later) run Autoware Docker images — **without** requiring the robot.

## Choose your Ubuntu / ROS pair

| Laptop OS | ROS 2 | Autoware Docker tag family |
|-----------|-------|----------------------------|
| Ubuntu **22.04** | **Humble** | `universe-humble` / `universe-cuda-humble` |
| Ubuntu **24.04** | **Jazzy** | `universe-jazzy` / `universe-cuda-jazzy` |

Use whichever matches the machine. Do not mix (e.g. Humble packages on 24.04).

Autoware currently supports both during the Humble→Jazzy transition. Timeline and policy: [Humble to Jazzy](https://autowarefoundation.github.io/autoware-documentation/main/home/roadmap/timelines/humble-jazzy/). Humble EOL is May 2027; prefer staying current with team Autoware images.

### Maintainer: verify before publish

Before onboarding a new cohort, check:

1. [Autoware Docker installation](https://autowarefoundation.github.io/autoware-documentation/main/installation/autoware/docker-installation/) — which tags are current
2. Humble→Jazzy timeline page above — soft-freeze / exclusive dates
3. Update this table if the team standardizes on one distro

## Native install (preferred)

### 1. Base tools

```bash
sudo apt update
sudo apt install -y git curl build-essential tmux python3-pip python3-venv
```

### 2. ROS 2

Follow the official guide for your distro (do not copy outdated one-liners from blogs):

- Humble: [docs.ros.org — Humble Ubuntu install](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html)
- Jazzy: [docs.ros.org — Jazzy Ubuntu install](https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html)

Also install developer tools:

```bash
# Replace ${ROS_DISTRO} with humble or jazzy
sudo apt install -y \
  ros-${ROS_DISTRO}-desktop \
  ros-${ROS_DISTRO}-rosbag2 \
  ros-${ROS_DISTRO}-tf2-ros \
  ros-${ROS_DISTRO}-tf2-tools \
  python3-colcon-common-extensions \
  python3-rosdep
sudo rosdep init    # once per machine
rosdep update
```

Shell setup (add to `~/.bashrc`):

```bash
source /opt/ros/${ROS_DISTRO}/setup.bash
```

### 3. Verify

```bash
cd /path/to/roam-onboarding
./scripts/verify_env.sh
```

Expected: reports `ROS_DISTRO`, `ros2` on PATH, `colcon` available, and basic package imports.

## Docker fallback

If native install is blocked (Windows host, locked laptop, etc.):

1. Install [Docker Engine](https://docs.docker.com/engine/install/ubuntu/) (or Docker Desktop with WSL2 + Ubuntu guest).
2. Prefer an official ROS image matching your target distro, e.g. `osrf/ros:humble-desktop` or `osrf/ros:jazzy-desktop`.
3. For Autoware later, use the foundation images documented here: [Autoware Docker installation](https://autowarefoundation.github.io/autoware-documentation/main/installation/autoware/docker-installation/).

Mount this repo into the container and run `verify_env.sh` inside.

**Note:** GPU, RViz, and GUI forwarding need extra flags (`xhost`, `--gpus`, etc.). Ask a senior if stuck; Tier 1 can often use RViz on a machine with a display.

## Clone this repo

The repo is **private**. You must be a member of
[Robotics-Operation-Autonomous-Mapping](https://github.com/Robotics-Operation-Autonomous-Mapping/).
If `git clone` returns 404, you are not logged in as an account that has access.

```bash
git clone https://github.com/Robotics-Operation-Autonomous-Mapping/geomatics-dev-resources.git roam-onboarding
cd roam-onboarding
git checkout -b setup/<yourname>
```

SSH:

```bash
git clone git@github.com:Robotics-Operation-Autonomous-Mapping/geomatics-dev-resources.git roam-onboarding
```

If the team adds submodules later:

```bash
git submodule update --init --recursive
```

## Sample data

You pull **public** datasets yourself (curl + checksum). There is no shared drive.

```bash
./scripts/download_sample_data.sh                 # KITTI GPS/IMU ~8 MB
./scripts/download_sample_data.sh --print-commands core   # read the curl first
```

Details and later Kalibr / Autoware downloads: [data.md](data.md).

Optional, so CP1 can `ros2 bag play` a converted KITTI IMU bag:

```bash
python3 -m pip install --user rosbags
./scripts/download_sample_data.sh    # re-run if the bag step was skipped
```

## Next

- [rules.md](rules.md)
- [01-tier1-foundations.md](01-tier1-foundations.md)
