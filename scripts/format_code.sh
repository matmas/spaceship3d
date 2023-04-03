#!/usr/bin/env bash
set -e
script_dir=$(dirname "$(realpath $0)")
project_root=$(dirname "$script_dir")
virtualenv_dir="$project_root/.venv"

if [ ! -d "$virtualenv_dir" ]; then
    python -m venv "$virtualenv_dir"
fi
source "$virtualenv_dir/bin/activate"
if [ ! -f "$virtualenv_dir/bin/gdlint" ]; then
    $virtualenv_dir/bin/pip install "gdtoolkit==4.*"
fi

gdformat "$project_root" --line-length=200
