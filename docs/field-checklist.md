# Field checklist (Tier 3 / CP3)

Print or keep on phone. **Do not start recording until Pre-run is complete.**

## Pre-run

- [ ] Platform assigned; power budget OK for planned duration
- [ ] Sensors mounted per team drawing; fasteners torque-checked
- [ ] Antenna lever arm measured/recorded in metadata YAML
- [ ] Intrinsics / extrinsics / time offsets current (date of last Kalibr or team calib)
- [ ] Quick calib sanity: IMU streams, camera frames, LiDAR spinning, GNSS fix quality acceptable
- [ ] Clocks: understand hardware vs software time for this platform; NTP/PTP note if used
- [ ] Topic list reviewed (record only what CP3/SLAM needs + GT)
- [ ] Storage: free space ≥ planned bag size × 1.5
- [ ] Bag naming scheme agreed ([data.md](data.md))
- [ ] RTK / NTRIP: base or mountpoint configured; fix mode confirmed
- [ ] Operator roles: driver / payload / notes

## During run

- [ ] Start record **after** sensors warm / GNSS stable
- [ ] Log start time (UTC) and site in notes
- [ ] Drive profile: include loops / revisits if evaluating loop closure
- [ ] Avoid known failure zones unless intentional (glass tunnels, etc.) — note if entered
- [ ] Watch disk and CPU; abort cleanly if dropping too many messages
- [ ] Mark events (bumps, GNSS outage) with timestamps in a text log

## Post-run

- [ ] Stop record cleanly; confirm bag playable (`ros2 bag info`)
- [ ] Copy bag + metadata YAML + event log off the robot **before** wiping
- [ ] Checksum or size note for transfer integrity
- [ ] Keep a local copy of bag + metadata + event log; share with your reviewer by the team’s usual file transfer — **not** git
- [ ] Fill CP3 report header (platform, site, weather, issues)
- [ ] Do **not** commit the bag to git

## Metadata reminder

Sidecar `YYYYMMDD_HHMMSS_...yaml` must include `platform`, `site`, `purpose`, `operator`, `sensors`, `ros_distro`, `rtk` (true/false), and notes.
