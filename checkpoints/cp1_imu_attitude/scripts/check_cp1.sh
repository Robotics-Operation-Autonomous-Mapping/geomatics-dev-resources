#!/usr/bin/env bash
# CP1 smoke check — structure + optional bag presence.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="$(cd "${ROOT}/../.." && pwd)"
fail=0
PYTHON="$(command -v python3 || command -v python || true)"

echo "=== CP1 smoke ==="

[[ -f "${ROOT}/package.xml" ]] || { echo "missing package.xml"; fail=1; }
[[ -f "${ROOT}/cp1_imu_attitude/attitude_node.py" ]] || { echo "missing attitude_node.py"; fail=1; }
[[ -f "${ROOT}/launch/attitude.launch.py" ]] || { echo "missing launch"; fail=1; }
[[ -f "${ROOT}/config/params.yaml" ]] || { echo "missing params"; fail=1; }

if [[ -z "${PYTHON}" ]]; then
  echo "[FAIL] python3/python not found"
  fail=1
elif (cd "${ROOT}" && "${PYTHON}" -c "import ast; ast.parse(open('cp1_imu_attitude/attitude_node.py', encoding='utf-8').read())"); then
  echo "[OK] attitude_node.py parses"
else
  echo "[FAIL] attitude_node.py syntax"
  fail=1
fi

BAG="${REPO_ROOT}/data/cp1/imu_raw"
if [[ -d "${BAG}" ]]; then
  echo "[OK] sample bag directory present: ${BAG}"
  if command -v ros2 >/dev/null 2>&1; then
    ros2 bag info "${BAG}" >/dev/null && echo "[OK] ros2 bag info succeeded" || echo "[WARN] ros2 bag info failed"
  fi
else
  echo "[WARN] no sample bag at ${BAG} — run ./scripts/download_sample_data.sh (and pip install rosbags if the bag step was skipped)"
fi

if [[ "${fail}" -ne 0 ]]; then
  echo "CP1 smoke FAILED"
  exit 1
fi
echo "CP1 smoke PASSED (implement node math before oral review)"
exit 0
