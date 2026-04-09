#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PYTHON_BIN="${PYTHON_BIN:-$HOME/.local/pipx/venvs/pymobiledevice3/bin/python}"
TARGET_ARCH="${TARGET_ARCH:-x86_64}"

if [[ ! -x "$PYTHON_BIN" ]]; then
  echo "ERROR: Python not found at $PYTHON_BIN"
  exit 1
fi

run_python() {
  if [[ "$TARGET_ARCH" == "x86_64" ]] && [[ "$(uname -m)" == "arm64" ]]; then
    /usr/bin/arch -x86_64 "$PYTHON_BIN" "$@"
  else
    "$PYTHON_BIN" "$@"
  fi
}

echo "[INFO] Using Python: $PYTHON_BIN"
run_python -m PyInstaller --noconfirm --clean \
  --distpath "$ROOT_DIR/bundled" \
  --workpath "$ROOT_DIR/build/pyinstaller" \
  "$ROOT_DIR/pymobiledevice3.spec"

if [[ ! -x "$ROOT_DIR/bundled/pymobiledevice3-bundle/pymobiledevice3" ]]; then
  echo "ERROR: Failed to build bundled pymobiledevice3 onedir bundle"
  exit 1
fi

BUILT_ARCH="$(/usr/bin/file -b "$ROOT_DIR/bundled/pymobiledevice3-bundle/pymobiledevice3")"
if [[ "$BUILT_ARCH" != *"$TARGET_ARCH"* ]]; then
  echo "ERROR: Built pymobiledevice3 bundle is not $TARGET_ARCH: $BUILT_ARCH"
  exit 1
fi

echo "[INFO] Built bundled/pymobiledevice3-bundle/pymobiledevice3"
