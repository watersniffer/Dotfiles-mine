#!/usr/bin/env bash
# Media progress for ashell's listen_cmd: "position / length" as text.
#
# Polls playerctl once a second and emits a JSON line only when the text
# changes, so the indicator tracks playback without spamming. Emits an empty
# text when nothing is playing, so the module collapses.
#
# playerctl position is seconds (float); mpris:length is microseconds.

last=""
while true; do
    pos=$(playerctl position 2>/dev/null)
    len=$(playerctl metadata mpris:length 2>/dev/null)

    fmt() {
        local s=$1
        s=${s%.*}
        [ -z "$s" ] && { echo ""; return; }
        local h=$((s/3600)) m=$(((s%3600)/60)) sec=$((s%60))
        if [ "$h" -gt 0 ]; then printf '%d:%02d:%02d' "$h" "$m" "$sec"
        else printf '%d:%02d' "$m" "$sec"; fi
    }

    if [ -n "$pos" ] && [ -n "$len" ]; then
        out="$(fmt "$pos") / $(fmt "$((len / 1000000))")"
    else
        out=""
    fi

    if [ "$out" != "$last" ]; then
        printf '{"text": "%s", "alt": ""}\n' "$out"
        last="$out"
    fi
    sleep 1
done
