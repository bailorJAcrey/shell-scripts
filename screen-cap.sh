#!/bin/sh

slurp_border_color="edbdb2"
slurp_background_color="00000080"
file_name="$(date | sed 's/ /-/g')"
capture_dir="$HOME/captures/$1/"

snip() {
    slurp -c $slurp_border_color -b $slurp_background_color \
        | xargs -I {} grim -g {} "$capture_dir$file_name.png"
}

case $1 in
    "snip") snip ;;
    *) exit 1 ;;
esac
