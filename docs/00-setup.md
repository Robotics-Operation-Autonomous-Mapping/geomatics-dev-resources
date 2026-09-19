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

```bash
git clone <TODO:REPO_URL> roam-onboarding
cd roam-onboarding
git checkout -b setup/<yourname>
```

If the team adds submodules later:

```bash
git submodule update --init --recursive
```

## Sample data

Configure `TODO:SHARED_DRIVE_URL` in [data.md](data.md), then:

```bash
./scripts/download_sample_data.sh
```

## Next

- [rules.md](rules.md)
- [01-tier1-foundations.md](01-tier1-foundations.md)
