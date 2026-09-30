#!/usr/bin/env bash
# Feed catloop.sh frames to ashell's listen_cmd as JSON lines.
#
# catloop.sh emits one frame letter per line (A-E awake, G-N sleeping) and
# runs forever; ashell's listen_cmd wants compact JSON on stdout. This is a
# thin adapter: it adds nothing to the animation, it only re-frames each line.
#
# The frame letter is a Waycat glyph, so the bar must use the merged
# WaycatMono font (see config/ashell/scripts/merge-waycat-font.py) for the
# letter to render as the cat rather than a plain character.

bash ~/.config/waybar/scripts/catloop.sh | while IFS= read -r frame; do
    printf '{"text": "%s", "alt": ""}\n' "$frame"
done
