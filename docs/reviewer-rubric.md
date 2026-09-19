# Reviewer rubric (≈15 minutes oral)

Senior member: working demos are necessary but not sufficient. If the candidate cannot explain the work, **fail** and schedule a retry.

Use sample bags from [data.md](data.md) where applicable.

---

## Checkpoint 1 — IMU attitude

**Objective gate (before oral):** `colcon build` clean; smoke script or manual bag play shows attitude topic + tf; PR merged or approved with ≥1 resolved comment.

| Prompt | Expect |
|--------|--------|
| How do you get roll/pitch from accelerometer only? What do you assume? | Stationary / gravity-dominant; formulas; yaw not observable |
| What happens when the platform accelerates? | Attitude polluted; possible mitigations (gyro fusion — conceptual) |
| Where is the parameter for topic name? How does launch load it? | Points at launch/params |
| Show the TF tree / RViz frame | Frame tilts with bag motion |
| Walk through one review comment you resolved | Real PR evidence |

**Fail if:** cannot derive or justify the math; cannot run from a fresh clone with their README.

---

## Checkpoint 2 — Sensors / calib / Autoware

**Objective gate:** `scripts/run_cp2.sh` (or documented steps) completes; Allan YAML within tolerance of `reference/`; GNSS plot exists; Kalibr RMS ≤ **0.5 px**; Autoware sensor kit launches / localizes on provided bag.

| Prompt | Expect |
|--------|--------|
| Explain one Allan plot feature (angle random walk / bias instability) | Correct region / units |
| Why is the public KITTI OXTS log a weak Allan dataset? | Vehicle is moving; Allan wants a long **static** IMU |
| Why ENU origin choice matters | Relative traj; singularity / wrapping not the main issue — origin & lever arm |
| Good vs bad Kalibr result | Reprojection, consistency, time delay sanity |
| What is extrinsic vs intrinsic here? | Clear separation |
| Which frames did you put in the Autoware sensor description? | Matches their YAML |
| Camera / IMU stamps: header vs receive time? | Knows which clock the pipeline uses |

**Fail if:** numbers present but unexplained; cannot say what tolerance means; stack launch was copy-paste only.

---

## Checkpoint 3 — Dataset / SLAM / Autoware map

**Objective gate:** Field checklist followed; `scripts/run_cp3.sh` (or one documented command) produces metrics table; report submitted; map loads in Autoware.

| Prompt | Expect |
|--------|--------|
| What did preprocessing change in the bag? | Sync/filter steps they implemented |
| Why did backend A beat B (or vice versa) on ATE/RPE? | Data-specific, not vibes |
| One failure case you hit | Degeneracy, GT gaps, extrinsic, etc. |
| How did you align trajectories in evo? | Frame / sync / Umeyama awareness |
| How did the PCD get into Autoware localization? | Actual steps they ran |

**Fail if:** unreproducible pipeline; no GT comparison; report is screenshots only with no method.

---

## Scoring shorthand

- **Pass** — objective gate green + oral solid
- **Retry** — objective green but oral weak; or minor objective gaps with clear fix plan
- **Fail** — objective red or cannot explain core ideas
