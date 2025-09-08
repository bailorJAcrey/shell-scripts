#!/bin/sh

wpctl_out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo $wpctl_out | awk '{ print $2 * 100 }')

notify-send \
    -t 1000 \
    -h int:value:$volume \
    -r 1001 \
    "$(echo $wpctl_out | awk '{print ($1" "($2 * 100)"% "$3)}')"
