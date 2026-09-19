# ROAM Geomatics Onboarding

Onboarding track for the ROAM geomatics team: foundations → sensors/calibration/Autoware → point clouds, data collection, and SLAM.

This repo holds **docs**, **checkpoint scaffolds**, and **templates**. Sample data is **not** in git — you download public datasets yourself ([docs/data.md](docs/data.md)) so you learn official install (curl, checksum, unpack).

The GitHub repo is **private**. Ask a lead to add you to the [Robotics-Operation-Autonomous-Mapping](https://github.com/Robotics-Operation-Autonomous-Mapping/) org before cloning.

## Quick start

1. Set up Ubuntu + ROS 2 (Humble on 22.04 or Jazzy on 24.04): [docs/00-setup.md](docs/00-setup.md)
2. Read the rules: [docs/rules.md](docs/rules.md)
3. Work through tiers in order; pass each checkpoint before moving on

```bash
git clone https://github.com/Robotics-Operation-Autonomous-Mapping/geomatics-dev-resources.git roam-onboarding
cd roam-onboarding
./scripts/verify_env.sh
./scripts/download_sample_data.sh          # KITTI GPS/IMU ~8 MB
```

SSH if you use keys:

```bash
git clone git@github.com:Robotics-Operation-Autonomous-Mapping/geomatics-dev-resources.git roam-onboarding
```

## Track map

| Stage | Docs | Checkpoint |
|-------|------|------------|
| Setup | [00-setup](docs/00-setup.md), [data](docs/data.md) | Environment verified |
| Tier 1 — Foundations | [01-tier1](docs/01-tier1-foundations.md) | [CP1 IMU attitude](checkpoints/cp1_imu_attitude/) |
| Tier 2 — Sensors & Autoware | [02-tier2](docs/02-tier2-sensors-autoware.md) | [CP2 sensors/calib](checkpoints/cp2_sensors_calib/) |
| Tier 3 — Clouds & SLAM | [03-tier3](docs/03-tier3-clouds-slam.md), [field checklist](docs/field-checklist.md) | [CP3 SLAM eval](checkpoints/cp3_slam_eval/) |

## Pass rules (every checkpoint)

1. **Objective:** auto-runnable test or fixed reference output matches within tolerance
2. **Oral:** a senior does a ~15 minute check — working code you cannot explain does **not** pass
3. **Git:** work lands via PR; **no direct pushes to `main`**; at least one review comment resolved (CP1+)

See [docs/rules.md](docs/rules.md) and [docs/reviewer-rubric.md](docs/reviewer-rubric.md).

## ROS / Autoware target

Supported developer laptops:

- **Ubuntu 22.04 + ROS 2 Humble**, or
- **Ubuntu 24.04 + ROS 2 Jazzy**

Match Autoware Docker tags to your distro (`universe-humble` / `universe-jazzy`). Maintainers: re-verify Autoware support before major doc updates — see the checklist in [docs/00-setup.md](docs/00-setup.md).

## Leads: private repo

- Add new members to the GitHub org so they can clone.
- Protect `main` (PR required; no direct pushes).
- Do not vendor datasets in this repo; point people at [docs/data.md](docs/data.md).

## License

Internal ROAM training material. Ask leads before redistributing outside the team. Public datasets you download keep their original licenses — cite them.
