#!/usr/bin/env bash
set -euo pipefail

# Build script: compile Python DVT location stream into a standalone binary
# Output binary: bundled/dvt-location-stream

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

PYTHON_BIN="${PYTHON_BIN:-$HOME/.local/pipx/venvs/pymobiledevice3/bin/python}"
TARGET_ARCH="${TARGET_ARCH:-x86_64}"
if [ ! -x "$PYTHON_BIN" ]; then
  PYTHON_BIN="python3"
fi
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1 && [ ! -x "$PYTHON_BIN" ]; then
  echo "ERROR: python3 is not installed."; exit 1
fi
run_python() {
  if [ "$TARGET_ARCH" = "x86_64" ] && [ "$(uname -m)" = "arm64" ]; then
    /usr/bin/arch -x86_64 "$PYTHON_BIN" "$@"
  else
    "$PYTHON_BIN" "$@"
  fi
}

PY_VER=$(run_python -c 'import sys; print("%d.%d" % (sys.version_info.major, sys.version_info.minor))')
MINOR=${PY_VER#*.}
MAJOR=$(echo "$PY_VER" | cut -d. -f1)
if [ "$MAJOR" -lt 3 ] || { [ "$MAJOR" -eq 3 ] && [ "${MINOR%%.*}" -lt 10 ]; }; then
  echo "ERROR: Python 3.10+ is required. Found Python $PY_VER"; exit 1
fi

# PyInstaller check
if ! run_python -m PyInstaller --version >/dev/null 2>&1; then
  echo "ERROR: PyInstaller is not installed for this Python."; exit 1
fi

echo "[INFO] Checking pymobiledevice3 availability..."
if ! run_python -c 'import pymobiledevice3' >/dev/null 2>&1; then
  echo "ERROR: pymobiledevice3 Python package is not installed in the environment."; exit 1
fi

echo "[INFO] Using Python: $PYTHON_BIN"
echo "[INFO] Building dvt-location-stream with PyInstaller..."
pushd "$ROOT_DIR" >/dev/null
run_python -m PyInstaller --onefile --name dvt-location-stream scripts/dvt_location_stream.py
popd >/dev/null

DIST_DIR="$ROOT_DIR/dist"
BUNDLED_DIR="$ROOT_DIR/bundled"
mkdir -p "$BUNDLED_DIR"
cp "$DIST_DIR/dvt-location-stream" "$BUNDLED_DIR/dvt-location-stream"
chmod +x "$BUNDLED_DIR/dvt-location-stream"

BUILT_ARCH="$(/usr/bin/file -b "$BUNDLED_DIR/dvt-location-stream")"
if [[ "$BUILT_ARCH" != *"$TARGET_ARCH"* ]]; then
  echo "ERROR: Built dvt-location-stream is not $TARGET_ARCH: $BUILT_ARCH"; exit 1
fi

# Cleanup
rm -rf "$ROOT_DIR/dist" "$ROOT_DIR/build" "$ROOT_DIR/*.spec" 2>/dev/null || true

echo "[INFO] Built and placed at: $BUNDLED_DIR/dvt-location-stream"
