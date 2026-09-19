#!/usr/bin/env bash
# One-command CP3 pipeline: preprocess → two SLAMs → evo table.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$(cd "${ROOT}/../.." && pwd)"
OUT="${ROOT}/output"
PYTHON="$(command -v python3 || command -v python)"
mkdir -p "${OUT}"

BAG="${CP3_BAG:-}"
if [[ -z "${BAG}" ]]; then
  # try default data path
  if [[ -d "${REPO}/data/cp3" ]]; then
    BAG="$(find "${REPO}/data/cp3" -mindepth 1 -maxdepth 2 -type d | head -n1 || true)"
  fi
fi

if [[ -z "${BAG}" || ! -e "${BAG}" ]]; then
  echo "Set CP3_BAG to your field bag path (see README)."
  echo "Optional: CP3_GT=/path/to/gt_tum.txt"
  exit 2
fi

PRE="${OUT}/preprocessed_bag"
echo "=== CP3: preprocess ==="
"${PYTHON}" "${ROOT}/scripts/preprocess_bag.py" --input "${BAG}" --output "${PRE}" --copy-passthrough \
  || "${PYTHON}" "${ROOT}/scripts/preprocess_bag.py" --input "${BAG}" --output "${PRE}"

export CP3_PREPROCESSED_BAG="${PRE}"

echo "=== CP3: KISS-ICP ==="
bash "${ROOT}/scripts/run_kiss_icp.sh" "${PRE}"

echo "=== CP3: FAST-LIO2 ==="
bash "${ROOT}/scripts/run_fast_lio2.sh" "${PRE}"

echo "=== CP3: evo ==="
bash "${ROOT}/scripts/eval_evo.sh"

echo "=== CP3: map export (manual) ==="
echo "Export best PCD, clean in CloudCompare, load in Autoware — document steps in REPORT.md"
echo "See reference/metrics_schema.md"
echo "=== CP3 pipeline finished ==="
