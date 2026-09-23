#!/bin/bash
# Apply some settings based on currently running compositor.
# Example: if we're running mango, setup waybar to use mango specific configs

IS_MANGO=0 # Assume we're on hyprland

if [[ "$MANGO_INSTANCE_SIGNATURE" ]]; then
    IS_MANGO=1
fi

cd ~/.config/waybar

if [[ $IS_MANGO == 1 ]]; then
    TARGET="modules.mango.jsonc"
else
    TARGET="modules.hyprland.jsonc"
fi

# Only link when the module file actually exists: this repo ships a single
# config.jsonc, and a dangling modules.jsonc would just be cruft.
if [[ -f "$TARGET" ]]; then
    ln -fs "$TARGET" modules.jsonc
fi