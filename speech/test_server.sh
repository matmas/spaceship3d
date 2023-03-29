#!/usr/bin/env bash
set -e
script_dir=$(dirname "$(realpath $0)")
virtualenv_dir="$script_dir/.venv"

if [ ! -d "$virtualenv_dir" ]; then
    python -m venv "$virtualenv_dir"
fi
source "$virtualenv_dir/bin/activate"
if [ ! -f "$virtualenv_dir/bin/tts" ]; then
    $virtualenv_dir/bin/pip install tts
fi
tts-server --model_name tts_models/en/vctk/vits
