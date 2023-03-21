#!/usr/bin/env bash
engine="Godot/G4 ORM"
scriptpath=$(realpath "$0")
scriptdir=$(dirname "$scriptpath")
output_path="$scriptdir/../generated"
input_files=*.ptex
material-maker --export-material --target "$engine" -o "$output_path" "$input_files"
