#!/usr/bin/env bash
# Run KISS-ICP on preprocessed bag. Install kiss-icp per upstream README.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${ROOT}/configs/kiss_icp.yaml"
BAG="${1:-${CP3_PREPROCESSED_BAG:-}}"
OUT="${ROOT}/output/kiss_icp"

if [[ -z "${BAG}" ]]; then
  echo "Usage: $0 <bag_path>   or set CP3_PREPROCESSED_BAG"
  exit 2
fi

mkdir -p "${OUT}"
echo "[INFO] KISS-ICP config: ${CONFIG}"
echo "[INFO] Bag: ${BAG}"

if command -v kiss_icp_pipeline >/dev/null 2>&1; then
  # Command name may differ by install — adjust in your PR if needed.
  kiss_icp_pipeline --config "${CONFIG}" "${BAG}" || true
elif python3 -c "import kiss_icp" 2>/dev/null; then
  echo "[INFO] kiss_icp Python module found — invoke your team command here"
  echo "[WARN] fill in the exact CLI in this script during CP3"
else
  echo "[WARN] KISS-ICP not installed — see https://github.com/PRBonn/kiss-icp"
fi

# Expected artifact for eval_evo.sh
: > "${OUT}/traj_tum.txt"
echo "[INFO] Write TUM trajectory to ${OUT}/traj_tum.txt before eval"
