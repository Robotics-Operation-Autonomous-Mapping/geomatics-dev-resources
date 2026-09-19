# Track rules

Applies to every tier and checkpoint.

## Git

- **No direct pushes to `main`.** Branch → PR → review → merge.
- Use meaningful branch names: `cp1/<name>-imu-attitude`, `cp2/<name>-allan`, etc.
- Resolve **at least one** review comment before asking for merge (Checkpoint 1+).
- Keep `.gitignore` honest; do not commit large bags, secrets, or generated maps.
- Prefer rebase onto `main` before final review; resolve conflicts locally.

PR template: [.github/PULL_REQUEST_TEMPLATE.md](../.github/PULL_REQUEST_TEMPLATE.md).

## How you pass a checkpoint

| Gate | Requirement |
|------|-------------|
| Objective | Checkpoint script/test exits 0 against the reference bag or tolerance YAML |
| Fresh clone | Reviewer can clone, follow the checkpoint README, and reproduce |
| Oral (~15 min) | You explain what you built, failure modes, and key numbers — see [reviewer-rubric.md](reviewer-rubric.md) |

Working code you cannot explain **does not pass**.

## Docs style for contributors

Tier docs stay short: reading list + exercises. Link official docs (ROS 2, Kalibr, Autoware, CloudCompare) instead of rewriting them.

## Data

- Download public sample data yourself for CP1–CP2 ([data.md](data.md)); do not expect bags in git.
- CP3 requires a real collection run following [field-checklist.md](field-checklist.md).
- Never commit full rosbags to this repo; only tiny fixtures under `reference/` if needed.
