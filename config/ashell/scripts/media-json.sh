#!/usr/bin/env bash
# Poll media-title.sh and emit a JSON line only when the text changes.
#
# media-title.sh prints "<artist> - <title>" while something is playing and
# nothing when idle. ashell's listen_cmd wants compact JSON, and an empty
# Text module renders as zero-width, so emitting "" when idle makes the
# module collapse -- the same "hide when empty" behaviour waybar gets from
# "hide-empty-text": true.
#
# The script is polled rather than event-driven because media-title.sh is a
# one-shot query; the 2s interval matches waybar's.

last=""
while true; do
    out=$(bash ~/.config/waybar/scripts/media-title.sh)
    if [ "$out" != "$last" ]; then
        # Escape for JSON: titles can contain quotes and backslashes.
        out=${out//\\/\\\\}
        out=${out//\"/\\\"}
        printf '{"text": "%s", "alt": ""}\n' "$out"
        last="$out"
    fi
    sleep 2
done
