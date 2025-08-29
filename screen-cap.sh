#!/bin/sh

slurp_border_color="edbdb2"
slurp_background_color="00000080"
file_name="$(date | sed 's/ /-/g')"
capture_dir="$HOME/captures/$1/"

snip() {
    local name="$capture_dir$file_name.png"
    slurp -c $slurp_border_color -b $slurp_background_color \
        | xargs -I {} grim -g {} $name
}

shot() {
    local name="$capture_dir$file_name.png"
    [ "$(hyprctl monitors -j | jq 'length')" == "1" ] \
        && grim $name \
        || ( \
            slurp -c $slurp_border_color -b $slurp_background_color -o \
            | xargs -I {} grim -g {} $name \
        )
}

start_recording() {
    local name="$capture_dir$file_name.mkv"
    [ "$(hyprctl monitors -j | jq 'length')" == "1" ] \
        && wf-recorder -f $name \
        || ( \
            slurp -c $slurp_border_color -b $slurp_background_color -o \
            | xargs -I {} wf-recorder -g {} -f $name
        )
}

record() {
    [ "$(ps ax | rg wf-recorder | sed '/rg wf-recorder/d')" == "" ] \
        && start_recording \
        || pkill wf-recorder
}

case $1 in
    "snip") snip ;;
    "shot") shot ;;
    "record") record ;;
    *) exit 1 ;;
esac
