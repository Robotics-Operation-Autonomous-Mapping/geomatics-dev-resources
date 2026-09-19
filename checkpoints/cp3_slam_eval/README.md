# Checkpoint 3 — Collect, SLAM, evaluate, Autoware map

Collect a real dataset, preprocess it, run **two** SLAM backends, evaluate with evo against GNSS/RTK, export/clean the best map, and localize in Autoware.

## Requirements

1. Collect following [field-checklist.md](../../docs/field-checklist.md)
2. Preprocess: sync, filter, prepare bag (`scripts/preprocess_bag.py`)
3. Run **KISS-ICP** and **FAST-LIO2** (LIO-SAM optional third)
4. Evaluate both vs GT with **evo**; produce a comparison table
5. Export best map → clean in CloudCompare → load in Autoware localization
6. Short report a new member could follow

## Pass criteria

| Check | Pass when |
|-------|-----------|
| One command | `scripts/run_cp3.sh` (or documented single entry) reproduces bag→metrics |
| Table | ATE/RPE for both backends in `output/comparison.md` |
| Map | Cleaned PCD loads; localization runs on a bag segment |
| Report | `REPORT.md` includes failure cases |
| Oral | [rubric](../../docs/reviewer-rubric.md) |

## Layout

```
scripts/
  preprocess_bag.py
  run_kiss_icp.sh
  run_fast_lio2.sh
  eval_evo.sh
  run_cp3.sh
configs/
  kiss_icp.yaml
  fast_lio2.yaml
reference/
  metrics_schema.md
```

## Run

```bash
export CP3_BAG=/path/to/your/bag   # or data/cp3/<your_run>
export CP3_GT=/path/to/gt_tum.txt  # TUM trajectory from GNSS/RTK
./checkpoints/cp3_slam_eval/scripts/run_cp3.sh
```

Do **not** commit full bags. Commit configs, scripts, metrics, and report only. Keep the bag under `data/cp3/<your_run>/` (gitignored) and share it with your reviewer outside git.
