#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PYTHON_BIN="${PYTHON_BIN:-$HOME/.local/pipx/venvs/pymobiledevice3/bin/python}"

if [[ ! -x "$PYTHON_BIN" ]]; then
  echo "ERROR: Python not found at $PYTHON_BIN"
  exit 1
fi

echo "[INFO] Using Python: $PYTHON_BIN"
"$PYTHON_BIN" -m PyInstaller --noconfirm --clean \
  --distpath "$ROOT_DIR/bundled" \
  --workpath "$ROOT_DIR/build/pyinstaller" \
  "$ROOT_DIR/pymobiledevice3.spec"

if [[ ! -x "$ROOT_DIR/bundled/pymobiledevice3-bundle/pymobiledevice3" ]]; then
  echo "ERROR: Failed to build bundled pymobiledevice3 onedir bundle"
  exit 1
fi

echo "[INFO] Built bundled/pymobiledevice3-bundle/pymobiledevice3"
