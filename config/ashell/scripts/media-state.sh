#!/usr/bin/env bash
# Tell ashell whether any media player is loaded, as a listen_cmd JSON stream.
#
# Why this exists: the three transport buttons (prev / play-pause / next) are
# CustomModule type Button, and a Button always renders its icon. ashell only
# collapses a module to zero width when it is type Text, so a Button cannot be
# hidden by emitting nothing. What it can do is swap the icon by regex, and
# when no regex matches it falls back to StaticIcon::None, whose glyph string is
# literally "". So the buttons disappear by having no icon to draw, which is
# close enough to hidden: what is left is ashell's own 1-unit horizontal padding
# on the icon container, a couple of pixels, and that padding is hardcoded in
# custom_module.rs with no config to reach it.
#
# Emits one JSON object per line, forever, because listen_cmd subscribes to a
# stream rather than running once:
#
#   {"alt": "playing", "text": null}   a player is loaded  -> icons show
#   {"alt": "",      "text": null}     nothing loaded      -> icons vanish
#
# "playing" is used for both Playing and Paused on purpose. Paused still means
# there is something to skip back to or forward from, and hiding the controls
# the moment you pause would make resuming need a click on the title first.
set -u

# A player is "loaded" when one is on the bus at all. playerctl status is not
# used for the test on its own: it has been seen answering "Playing" while
# `playerctl metadata` found no player at all, which would leave the buttons
# stuck on with nothing to control.
while true; do
    if playerctl -l 2>/dev/null | grep -q .; then
        printf '{"alt": "playing", "text": null}\n'
    else
        printf '{"alt": "", "text": null}\n'
    fi
    sleep 1
done
