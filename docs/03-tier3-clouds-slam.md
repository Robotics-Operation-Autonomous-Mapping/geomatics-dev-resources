# Tier 3 — Point clouds, data collection, and SLAM

Reading list + exercises. Pass via [Checkpoint 3](../checkpoints/cp3_slam_eval/) after a real field collect.

## CloudCompare (and scripted equivalents)

### Read

- [CloudCompare wiki](https://www.cloudcompare.org/doc/wiki/index.php?title=Main_Page) — import/export, crop, subsample, ICP, C2C distance, scalar fields, segmentation
- [Open3D tutorial](https://www.open3d.org/docs/release/tutorial/geometry/pointcloud.html) and/or [PCL tutorials](https://pcl.readthedocs.io/) for scripted versions of the same ops

### Exercises

1. In CloudCompare: load a sample cloud, crop, subsample, run ICP against a second cloud, color by C2C distance.
2. Reproduce crop + voxel downsample in Open3D or PCL; save PCD/PLY.

## Data collection

### Read

- Team process: [field-checklist.md](field-checklist.md) (mandatory before your CP3 run)
- Bag naming & metadata: [data.md](data.md)
- Calibration check before a run; record only needed topics; RTK ground truth when available

### Exercises

1. Dry-run the field checklist with a senior (no vehicle required for the walkthrough).
2. Propose a topic list for a SLAM + GT bag on your platform; get it reviewed before collect day.

## SLAM

### Read

- Concepts: odometry, loop closure, pose graph (any solid SLAM survey chapter; keep it conceptual)
- Hands-on (pick docs for the libraries you will run):
  - [KISS-ICP](https://github.com/PRBonn/kiss-icp)
  - [FAST-LIO2](https://github.com/hku-mars/FAST_LIO)
  - [LIO-SAM](https://github.com/TixiaoShan/LIO-SAM) (optional third backend)
- Config tuning and common failure modes: library READMEs + CP3 notes

### Exercises

1. Run KISS-ICP and FAST-LIO2 on the same bag with team starter configs under CP3.
   (Dry-run on a public LiDAR bag from those projects' READMEs is fine; the checkpoint still needs your field collect.)
2. For each: list one failure mode you observed or would expect (degeneracy, motion distortion, bad extrinsic, etc.).

## Evaluation

### Read

- [evo](https://github.com/MichaelGrupp/evo) — ATE/RPE, alignment, plotting

### Exercises

1. Align SLAM trajectory to GNSS/RTK GT with evo; produce ATE/RPE numbers.
2. Build a comparison table for two backends (CP3 script helps).

## Feeding results back to Autoware

### Read

- Export PCD map; clean in CloudCompare
- Autoware localization map loading / point cloud map docs on the [Autoware documentation](https://autowarefoundation.github.io/autoware-documentation/main/) site

### Exercises

1. Export the better map, clean outliers, load into Autoware, and localize on a segment of your bag.

## Checkpoint 3

See [`checkpoints/cp3_slam_eval/`](../checkpoints/cp3_slam_eval/). One-command pipeline + short report required. Oral: [reviewer-rubric.md](reviewer-rubric.md).
