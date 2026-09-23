#!/usr/bin/env bash
# Regenerate the theme from a wallpaper and reload waybar.
# MANUAL ONLY: nothing calls this automatically anymore (Matuwall has no hooks).
# Usage: apply.sh <path>
set -uo pipefail

WALLPAPER="${1:-}"

if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER="$HOME/Pictures/Wallpapers/$(ls -1 "$HOME/Pictures/Wallpapers" 2>/dev/null | head -n1)"
fi

if [[ ! -f "$WALLPAPER" ]]; then
    echo "no wallpaper found ($WALLPAPER)" >&2
    exit 1
fi

matugen image "$WALLPAPER" --prefer=value

# SDDM: publish theme.conf + wallpaper into the theme dir (greeter runs as sddm).
# The dir is owned by water so this works without a TTY/sudo prompt.
SDDM_THEME="/usr/share/sddm/themes/gruvbox-minimal-sddm"
if [[ -d "$SDDM_THEME" && -f ~/.cache/matugen-sddm/theme.conf ]]; then
    install -m 644 -D ~/.cache/matugen-sddm/theme.conf "$SDDM_THEME/theme.conf" 2>/dev/null
    install -m 644 "$WALLPAPER" "$SDDM_THEME/painting.jpg" 2>/dev/null
fi

pkill -x waybar && sleep 0.2
setsid waybar >/dev/null 2>&1 &
