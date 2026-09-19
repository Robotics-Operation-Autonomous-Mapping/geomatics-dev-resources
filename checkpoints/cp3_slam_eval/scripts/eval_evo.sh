#!/usr/bin/env bash
# Evaluate SLAM trajectories vs GT with evo; write comparison table.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${ROOT}/output"
GT="${CP3_GT:-${OUT}/gt_tum.txt}"
KISS="${OUT}/kiss_icp/traj_tum.txt"
FAST="${OUT}/fast_lio2/traj_tum.txt"
TABLE="${OUT}/comparison.md"

mkdir -p "${OUT}"

if ! command -v evo_ape >/dev/null 2>&1; then
  echo "[WARN] evo not installed — pip install evo  (https://github.com/MichaelGrupp/evo)"
fi

{
  echo "# CP3 SLAM comparison"
  echo
  echo "| Backend | ATE RMSE | RPE |"
  echo "|---------|----------|-----|"
} > "${TABLE}"

run_one() {
  local name="$1"
  local traj="$2"
  if [[ ! -s "${traj}" ]]; then
    echo "| ${name} | (missing traj) | (missing) |" >> "${TABLE}"
    return
  fi
  if [[ ! -s "${GT}" ]]; then
    echo "| ${name} | (missing GT) | (missing GT) |" >> "${TABLE}"
    return
  fi
  if command -v evo_ape >/dev/null 2>&1; then
    local ape
    ape="$(evo_ape tum "${GT}" "${traj}" -a --no-warnings 2>/dev/null | tr '\n' ' ' | sed 's/|/\\|/g' || echo "see evo log")"
    echo "| ${name} | ${ape} | (run evo_rpe similarly) |" >> "${TABLE}"
  else
    echo "| ${name} | (install evo) | (install evo) |" >> "${TABLE}"
  fi
}

run_one "KISS-ICP" "${KISS}"
run_one "FAST-LIO2" "${FAST}"

echo "[INFO] Wrote ${TABLE}"
cat "${TABLE}"
