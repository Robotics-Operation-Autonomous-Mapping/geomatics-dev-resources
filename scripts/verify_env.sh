#!/usr/bin/env bash
# Verify ROS 2 / tooling for ROAM geomatics onboarding.
set -euo pipefail

ok=0
warn=0
fail=0

pass() { echo "[OK]  $*"; ok=$((ok + 1)); }
note() { echo "[WARN] $*"; warn=$((warn + 1)); }
bad()  { echo "[FAIL] $*"; fail=$((fail + 1)); }

echo "=== ROAM geomatics env check ==="

if [[ -n "${ROS_DISTRO:-}" ]]; then
  case "${ROS_DISTRO}" in
    humble|jazzy) pass "ROS_DISTRO=${ROS_DISTRO}" ;;
    *) note "ROS_DISTRO=${ROS_DISTRO} (expected humble or jazzy)" ;;
  esac
else
  bad "ROS_DISTRO unset — source /opt/ros/<distro>/setup.bash"
fi

if command -v ros2 >/dev/null 2>&1; then
  pass "ros2 on PATH ($(command -v ros2))"
else
  bad "ros2 not found"
fi

if command -v colcon >/dev/null 2>&1; then
  pass "colcon on PATH"
else
  bad "colcon not found (install python3-colcon-common-extensions)"
fi

if command -v git >/dev/null 2>&1; then
  pass "git $(git --version | awk '{print $3}')"
else
  bad "git not found"
fi

if command -v tmux >/dev/null 2>&1; then
  pass "tmux available"
else
  note "tmux not found (recommended for bag + RViz sessions)"
fi

PYTHON="$(command -v python3 || command -v python || true)"
if [[ -n "${PYTHON}" ]]; then
  pass "python $($PYTHON --version 2>&1 | awk '{print $2}') ($PYTHON)"
else
  bad "python3/python not found"
fi

# Optional Python deps used later (do not fail setup)
if [[ -n "${PYTHON}" ]]; then
  "${PYTHON}" - <<'PY' 2>/dev/null && pass "numpy importable" || note "numpy missing (needed for CP1/CP2)"
import numpy
PY

  "${PYTHON}" - <<'PY' 2>/dev/null && pass "PyYAML importable" || note "PyYAML missing (needed for CP2 YAML write)"
import yaml
PY
fi

if [[ -n "${ROS_DISTRO:-}" ]] && command -v ros2 >/dev/null 2>&1; then
  if ros2 pkg list 2>/dev/null | grep -q '^tf2_ros$'; then
    pass "tf2_ros package visible"
  else
    note "tf2_ros not listed — install ros-${ROS_DISTRO}-tf2-ros"
  fi
fi

echo "=== summary: ok=${ok} warn=${warn} fail=${fail} ==="
if [[ "${fail}" -gt 0 ]]; then
  echo "Fix FAIL items before Tier 1."
  exit 1
fi
echo "Environment looks ready for Tier 1."
exit 0
