#!/bin/sh

slurp_border_color="edbdb2"
slurp_background_color="00000080"
file_name="$(date | sed 's/ /-/g')"
capture_dir="$HOME/captures/$1/"

snip() {
    local name="$capture_dir$file_name.png"
    slurp -c $slurp_border_color -b $slurp_background_color \
        | xargs -I {} grim -g {} $name
    case $(dunstify \
        -A "open,Open the image" \
        -A "dir,View in directory" \
        "Screensnip taken!" "saved to '$name'"
    ) in
        "open") xdg-open $name ;;
        "dir") xdg-open $capture_dir ;;
    esac
}

shot() {
    local name="$capture_dir$file_name.png"
    [ "$(hyprctl monitors -j | jq 'length')" == "1" ] \
        && grim $name \
        || ( \
            slurp -c $slurp_border_color -b $slurp_background_color -o \
            | xargs -I {} grim -g {} $name \
        )
    case $(dunstify \
        -A "open,Open the image" \
        -A "dir,View in directory" \
        "Screenshot taken!" "saved to '$name'"
    ) in
        "open") xdg-open $name ;;
        "dir") xdg-open $capture_dir ;;
    esac
}

start_recording() {
    [ "$(hyprctl monitors -j | jq 'length')" == "1" ] \
        && wf-recorder -f $1 \
        || ( \
            slurp -c $slurp_border_color -b $slurp_background_color -o \
            | xargs -I {} wf-recorder -g {} -f $1
        )
}

record() {
    local name="$capture_dir$file_name.mkv"
    [ "$(ps ax | rg wf-recorder | sed '/rg wf-recorder/d')" == "" ] \
        && (notify-send -t 1000 "Recording started" ; start_recording $name) \
        || (
            pkill wf-recorder
            case $(dunstify \
                -A "open,Open the recording" \
                -A "dir,View in directory" \
                "Recording stopped!" "saved to '$name'"
            ) in
                "open") xdg-open $name ;;
                "dir") xdg-open $capture_dir ;;
            esac
        )
}

case $1 in
    "snip") snip ;;
    "shot") shot ;;
    "record") record ;;
    *) exit 1 ;;
esac
