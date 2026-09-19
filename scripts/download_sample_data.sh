#!/usr/bin/env bash
# Download sample rosbags from the shared drive into ./data (gitignored).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${REPO_ROOT}/data"
# Fill after drive is created — must match docs/data.md
SHARED_DRIVE_URL="${SHARED_DRIVE_URL:-TODO:SHARED_DRIVE_URL}"

mkdir -p "${DATA_DIR}/cp1" "${DATA_DIR}/cp2" "${DATA_DIR}/cp3"

if [[ "${SHARED_DRIVE_URL}" == "TODO:SHARED_DRIVE_URL" || -z "${SHARED_DRIVE_URL}" ]]; then
  cat <<EOF
[WARN] SHARED_DRIVE_URL is not configured.

1. Set the drive root in docs/data.md (TODO:SHARED_DRIVE_URL)
2. Export SHARED_DRIVE_URL='https://...' or edit this script
3. Re-run: ./scripts/download_sample_data.sh

Creating empty layout under ${DATA_DIR} for local placeholders.
EOF
  mkdir -p \
    "${DATA_DIR}/cp1/imu_raw" \
    "${DATA_DIR}/cp2/imu_static" \
    "${DATA_DIR}/cp2/gnss_raw" \
    "${DATA_DIR}/cp2/kalibr_cam_imu" \
    "${DATA_DIR}/cp2/autoware_localize" \
    "${DATA_DIR}/cp3"
  echo "data/" > "${DATA_DIR}/.gitkeep_readme"
  echo "Place bags according to docs/data.md" > "${DATA_DIR}/README.txt"
  exit 0
fi

echo "Downloading from ${SHARED_DRIVE_URL} → ${DATA_DIR}"
# Prefer rclone if configured; else curl a manifest.
if command -v rclone >/dev/null 2>&1 && [[ -n "${RCLONE_REMOTE:-}" ]]; then
  rclone copy "${RCLONE_REMOTE}" "${DATA_DIR}" --progress
elif command -v curl >/dev/null 2>&1; then
  MANIFEST="${SHARED_DRIVE_URL%/}/manifest.txt"
  echo "[INFO] Attempting manifest at ${MANIFEST}"
  echo "[WARN] Implement concrete curl/wget lines once the drive hosts a manifest."
  exit 1
else
  echo "[FAIL] Need rclone or curl to download"
  exit 1
fi

echo "Done. Bags under ${DATA_DIR}"
