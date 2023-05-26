#!/usr/bin/env bash
set -e
script_dir=$(dirname "$(realpath $0)")
project_root=$(dirname $(dirname "$script_dir"))
virtualenv_dir="$project_root/.venv"

if [ ! -d "$virtualenv_dir" ]; then
    python -m venv "$virtualenv_dir"
fi
source "$virtualenv_dir/bin/activate"
if [ ! -f "$virtualenv_dir/bin/tts" ]; then
    $virtualenv_dir/bin/pip install tts
fi
output_dir="$script_dir/generated"
temp_dir=$(mktemp -d -q)
trap 'rm -rf -- "$temp_dir"' EXIT
shopt -s nullglob
existing_files=("$output_dir"/*.ogg)

lines=$(cat "$script_dir/phrases.txt")
while read -r line; do
    IFS=: read -r speaker text <<< "$line"
    filename=$(echo "$speaker"_"$text" | tr ':/\\?*"|%<>' _)  # See https://docs.godotengine.org/en/stable/classes/class_string.html#class-string-method-validate-filename
    dest_file="$output_dir/$filename.ogg"
    if [ ! -f "$dest_file" ]; then
        echo "$speaker: $text"
        temp_file="$temp_dir/$filename.wav"
        tts --text "$text" --out_path "$temp_file" --model_name "tts_models/en/vctk/vits" --speaker_idx "$speaker" >/dev/null
        ffmpeg -nostdin -y -loglevel error -i "$temp_file" "$dest_file"
    else
        existing_files=("${existing_files[@]/$dest_file}")
    fi
done <<< "$lines"

for file in "${existing_files[@]}"
do
  if [ -n "$file" ]; then
    echo Removing unused "$file"
    rm "$file"
  fi
done

# Maybe useful later:
#     tts --text "$line" --out_path "$TEMP_FILE" --model_name "tts_models/en/ljspeech/tacotron2-DDC" --vocoder_name "vocoder_models/en/ljspeech/hifigan_v2" >/dev/null  # like reading a script
#     tts --text "$line" --out_path "$TEMP_FILE" --model_name "tts_models/en/ljspeech/tacotron2-DDC_ph" --vocoder_name "vocoder_models/en/ljspeech/multiband-melgan" >/dev/null  # like reading a script but slightly less monotoneous
#     tts --text "$line" --out_path "$TEMP_FILE" --model_name "tts_models/en/ljspeech/fast_pitch" --vocoder_name "vocoder_models/en/ljspeech/hifigan_v2" >/dev/null  # crisper voice somewhat robotic
#     tts --text "$line" --out_path "$TEMP_FILE" --model_name "tts_models/en/vctk/fast_pitch" --vocoder_name "vocoder_models/en/ljspeech/hifigan_v2" --speaker_idx "VCTK_p226" >/dev/null  # male whispering like radio chatter
#     tts --text "$line" --out_path "$TEMP_FILE" --model_name "tts_models/en/vctk/fast_pitch" --vocoder_name "vocoder_models/en/ljspeech/hifigan_v2" --speaker_idx "VCTK_p330" >/dev/null  # female suggestive somewhat robotic
#     tts --text "$line" --out_path "$TEMP_FILE" --model_name "tts_models/en/vctk/vits" --speaker_idx "p273" >/dev/null  # female matter of fact tone
#     tts --text "$line" --out_path "$TEMP_FILE" --model_name "tts_models/en/vctk/vits" --speaker_idx "p335" >/dev/null  # young female
