#!/usr/bin/env bash
# Run FAST-LIO2 on preprocessed bag. Follow upstream ROS launch for your distro.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${ROOT}/configs/fast_lio2.yaml"
BAG="${1:-${CP3_PREPROCESSED_BAG:-}}"
OUT="${ROOT}/output/fast_lio2"

if [[ -z "${BAG}" ]]; then
  echo "Usage: $0 <bag_path>   or set CP3_PREPROCESSED_BAG"
  exit 2
fi

mkdir -p "${OUT}"
echo "[INFO] FAST-LIO2 config hints: ${CONFIG}"
echo "[INFO] Bag: ${BAG}"
echo "[WARN] Launch FAST-LIO2 per https://github.com/hku-mars/FAST_LIO — record odom to TUM"
echo "[INFO] Expected output: ${OUT}/traj_tum.txt"
: > "${OUT}/traj_tum.txt"
