#!/bin/bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

PYTHON="${PYTHON:-python3.12}"
if ! command -v "$PYTHON" >/dev/null 2>&1; then
    echo "Installa Python 3.12 per Apple Silicon (es. brew install python@3.12)."
    echo "Puoi scegliere un interprete con PYTHON=/percorso/python3.12."
    exit 1
fi
"$PYTHON" -c '
import platform, sys
if platform.system() != "Darwin" or platform.machine() != "arm64":
    sys.exit("Usa Python nativo arm64 su macOS, non Terminale/Python sotto Rosetta.")
if sys.version_info[:2] != (3, 12):
    sys.exit("Questo launcher richiede Python 3.12.")
'

VENV_PY="$PWD/.venv-local/bin/python"
if [[ ! -x "$VENV_PY" ]]; then
    "$PYTHON" -m venv "$PWD/.venv-local"
fi
"$VENV_PY" -c '
import platform, sys
if platform.machine() != "arm64" or sys.version_info[:2] != (3, 12):
    sys.exit("Ricrea .venv-local con Python 3.12 arm64.")
'
if ! "$VENV_PY" -c "import cv2, mediapipe, numpy, pyvirtualcam, pygame" >/dev/null 2>&1; then
    "$VENV_PY" -m pip install -r "$PWD/requirements.txt"
fi

# Local preview needs no OBS; explicit CLI flags can enable virtual output.
exec "$VENV_PY" "$PWD/vanish_cam.py" --no-virtual-camera "$@"
