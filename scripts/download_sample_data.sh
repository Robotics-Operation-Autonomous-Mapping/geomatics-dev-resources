#!/usr/bin/env bash
# Fetch public datasets into ./data (gitignored).
#
# Goal: you run the same commands you would type by hand (curl, checksum,
# unzip/convert) so you learn how to install datasets from official sources.
# There is no team shared drive and no TRITON2 URL.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${REPO_ROOT}/data"
CACHE_DIR="${DATA_DIR}/.cache"
PYTHON="$(command -v python3 || command -v python || true)"

KITTI_URL="https://s3.eu-central-1.amazonaws.com/avg-kitti/data_tracking_oxts.zip"
KITTI_PAGE="https://www.cvlibs.net/datasets/kitti/eval_tracking.php"
KITTI_SHA256="0b93e47a01d9479b7aeffcad50c0a08566f723119b6dfb7a11da3466acaf02de"
KITTI_ZIP="${CACHE_DIR}/data_tracking_oxts.zip"
KITTI_SEQUENCE="${KITTI_SEQUENCE:-0009}"

KALIBR_PAGE="https://github.com/ethz-asl/kalibr/wiki/Downloads"

AUTOWARE_DOCS="https://autowarefoundation.github.io/autoware-documentation/main/demos/rosbag-replay-simulation/"
AW_MAP_URL="https://autoware-files.s3.us-west-2.amazonaws.com/maps/demos/sample-map-rosbag.zip"
AW_MAP_SHA256="07e2da0b0bf12e2324f7083c2ce5556fb8044c50cef1da6428ab9084c3903bc8"
AW_BAG_URL="https://autoware-files.s3.us-west-2.amazonaws.com/recordings/bags/demos/sample-rosbag.zip"
AW_BAG_SHA256="5f9d36353393b3d249212153c19049822b1298db56512aa045b4f7f6fc37cf88"

PRINT_ONLY=0
TARGET="${1:-core}"

usage() {
  cat <<EOF
Usage: $0 [--print-commands] [target]

Targets
  core           KITTI tracking GPS/IMU (~8 MB) → CP1 bag/CSV + CP2 GNSS/IMU
  cp1            same as core (CP1 is produced from the KITTI OXTS log)
  cp2            core + reminder for Kalibr (ETH) and Autoware
  cp2-autoware   Autoware sample map (~3 MB) + sample rosbag (~202 MB), sha256-checked
  all            core + Autoware (Kalibr/ETH: install yourself — see docs/data.md)
  list           print catalog and exit

Flags
  --print-commands   print the curl lines only (no download)

Env
  KITTI_SEQUENCE     training sequence in the zip (default: 0009)

Read docs/data.md before you run this. Cite the dataset authors if you publish.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi
if [[ "${1:-}" == "--print-commands" ]]; then
  PRINT_ONLY=1
  TARGET="${2:-core}"
fi

if [[ -z "${PYTHON}" ]]; then
  echo "[FAIL] need python3 (or python) to checksum / convert"
  exit 1
fi

mkdir -p "${DATA_DIR}/cp1" "${DATA_DIR}/cp2" "${DATA_DIR}/cp3" "${CACHE_DIR}"

sha256_of() {
  "${PYTHON}" - "$1" <<'PY'
import hashlib, sys
from pathlib import Path
print(hashlib.sha256(Path(sys.argv[1]).read_bytes()).hexdigest())
PY
}

extract_zip() {
  local zip_path="$1"
  local dest="$2"
  "${PYTHON}" - "$zip_path" "$dest" <<'PY'
import sys, zipfile
from pathlib import Path
z, dest = Path(sys.argv[1]), Path(sys.argv[2])
dest.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(z) as zf:
    zf.extractall(dest)
PY
}

fetch() {
  local url="$1"
  local dest="$2"
  local sha="${3:-}"
  echo
  echo "  official file: ${url}"
  echo "  curl -L --fail --progress-bar -o ${dest} \\"
  echo "    ${url}"
  if [[ "${PRINT_ONLY}" -eq 1 ]]; then
    return 0
  fi
  if [[ -f "${dest}" && -n "${sha}" ]]; then
    local got
    got="$(sha256_of "${dest}")"
    if [[ "${got}" == "${sha}" ]]; then
      echo "  [skip] already downloaded and sha256 matches"
      return 0
    fi
    echo "  [info] local file hash mismatch — re-downloading"
  fi
  command -v curl >/dev/null 2>&1 || { echo "[FAIL] install curl"; exit 1; }
  mkdir -p "$(dirname "${dest}")"
  curl -L --fail --progress-bar -o "${dest}" "${url}"
  if [[ -n "${sha}" ]]; then
    local got
    got="$(sha256_of "${dest}")"
    if [[ "${got}" != "${sha}" ]]; then
      echo "[FAIL] sha256 mismatch for ${dest}"
      echo "  expected ${sha}"
      echo "  got      ${got}"
      exit 1
    fi
    echo "  [ok] sha256 ${sha}"
  fi
}

write_sources() {
  cat > "${DATA_DIR}/SOURCES.txt" <<EOF
Local sample data (gitignored). Do not commit bags.

KITTI tracking GPS/IMU
  page: ${KITTI_PAGE}
  file: ${KITTI_URL}
  sequence: training/oxts/${KITTI_SEQUENCE}.txt
  cite: Geiger, Lenz, Stiller, Urtasun — KITTI Vision Benchmark Suite

Kalibr / EuRoC (ETH Zurich) — install yourself from:
  ${KALIBR_PAGE}
  put bags under data/cp2/kalibr_cam_imu/

Autoware sample map + rosbag (if downloaded)
  docs: ${AUTOWARE_DOCS}
  map:  ${AW_MAP_URL}
  bag:  ${AW_BAG_URL}
EOF
}

download_kitti() {
  echo "==> KITTI tracking GPS/IMU (OXTS only, no cameras)"
  echo "    Why: small official file (~8 MB) with IMU + lat/lon — you practice curl + checksum."
  echo "    Page: ${KITTI_PAGE}"
  fetch "${KITTI_URL}" "${KITTI_ZIP}" "${KITTI_SHA256}"
  if [[ "${PRINT_ONLY}" -eq 1 ]]; then
    echo "    then: ${PYTHON} ${REPO_ROOT}/scripts/kitti_oxts_prepare.py --zip ${KITTI_ZIP} --sequence ${KITTI_SEQUENCE} --repo-root ${REPO_ROOT}"
    return 0
  fi
  "${PYTHON}" "${REPO_ROOT}/scripts/kitti_oxts_prepare.py" \
    --zip "${KITTI_ZIP}" \
    --sequence "${KITTI_SEQUENCE}" \
    --repo-root "${REPO_ROOT}"
}

download_autoware() {
  echo "==> Autoware sample map + rosbag (official S3 artifacts)"
  echo "    Why: same files the Autoware rosbag-replay demo downloads; we checksum them."
  echo "    Docs: ${AUTOWARE_DOCS}"
  local dest="${DATA_DIR}/cp2/autoware_localize"
  mkdir -p "${dest}"
  fetch "${AW_MAP_URL}" "${CACHE_DIR}/sample-map-rosbag.zip" "${AW_MAP_SHA256}"
  fetch "${AW_BAG_URL}" "${CACHE_DIR}/sample-rosbag.zip" "${AW_BAG_SHA256}"
  if [[ "${PRINT_ONLY}" -eq 1 ]]; then
    return 0
  fi
  extract_zip "${CACHE_DIR}/sample-map-rosbag.zip" "${dest}"
  extract_zip "${CACHE_DIR}/sample-rosbag.zip" "${dest}"
  echo "    extracted under ${dest}"
  echo "    (map dir sample-map-rosbag/, bag dir sample-rosbag/)"
}

case "${TARGET}" in
  list)
    usage
    exit 0
    ;;
  core|cp1|cp2)
    download_kitti
    if [[ "${TARGET}" == "cp2" ]]; then
      echo
      echo "CP2 GNSS/IMU CSV is ready. Still:"
      echo "  Kalibr: install ETH Zurich EuRoC example bags yourself → ${KALIBR_PAGE}"
      echo "          put them in data/cp2/kalibr_cam_imu/  (see docs/data.md)"
      echo "  Autoware: $0 cp2-autoware"
    fi
    ;;
  cp2-autoware)
    download_autoware
    ;;
  all)
    download_kitti
    download_autoware
    echo
    echo "Kalibr/ETH: not fetched by this script — install from ${KALIBR_PAGE}"
    ;;
  *)
    echo "Unknown target: ${TARGET}"
    usage
    exit 1
    ;;
esac

if [[ "${PRINT_ONLY}" -eq 0 ]]; then
  write_sources
  echo
  echo "Done. Layout: docs/data.md     files: ${DATA_DIR}"
  echo "Never git-add data/. Confirm with:  git status --short data"
fi
