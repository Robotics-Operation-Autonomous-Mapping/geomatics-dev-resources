#!/usr/bin/env bash
# End-to-end CP2 entrypoint. Stages skip with WARN if data missing.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$(cd "${ROOT}/../.." && pwd)"
OUT="${ROOT}/output"
PYTHON="$(command -v python3 || command -v python)"
mkdir -p "${OUT}"

echo "=== CP2 run ==="

IMU_IN="${REPO}/data/cp2/imu_static"
GNSS_IN="${REPO}/data/cp2/gnss_raw"
# Prefer a file if present, else directory
GNSS_FILE="${GNSS_IN}"
if [[ -d "${GNSS_IN}" ]]; then
  GNSS_FILE="$(find "${GNSS_IN}" -type f \( -name '*.csv' -o -name '*.nmea' -o -name '*.txt' -o -name '*.ubx' \) | head -n1 || true)"
fi

"${PYTHON}" "${ROOT}/scripts/allan_variance.py" --help-schema >/dev/null
"${PYTHON}" "${ROOT}/scripts/gnss_to_enu.py" --help >/dev/null

if [[ -e "${IMU_IN}" ]]; then
  "${PYTHON}" "${ROOT}/scripts/allan_variance.py" \
    --input "${IMU_IN}" \
    --output-yaml "${OUT}/imu_noise.yaml" \
    --output-plot "${OUT}/allan_plot.png"
else
  echo "[WARN] missing ${IMU_IN}"
fi

if [[ -n "${GNSS_FILE}" && -e "${GNSS_FILE}" ]]; then
  "${PYTHON}" "${ROOT}/scripts/gnss_to_enu.py" \
    --input "${GNSS_FILE}" \
    --output-plot "${OUT}/gnss_enu.png" \
    --output-csv "${OUT}/gnss_enu.csv"
else
  echo "[WARN] missing GNSS input under ${GNSS_IN}"
fi

echo "[INFO] Kalibr: follow ${ROOT}/kalibr/README.md (threshold <= 0.5 px RMS)"
echo "[INFO] Autoware sensor kit: fill ${ROOT}/sensor_kit/ then launch per that README"

if [[ -f "${OUT}/imu_noise.yaml" ]]; then
  "${PYTHON}" "${ROOT}/scripts/check_tolerances.py" \
    --student "${OUT}/imu_noise.yaml" \
    --reference "${ROOT}/reference/imu_noise_reference.yaml" \
    --tolerances "${ROOT}/reference/tolerances.yaml" || echo "[WARN] tolerance check failed (expected until implemented)"
fi

echo "=== CP2 run finished ==="
