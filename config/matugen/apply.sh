#!/usr/bin/env bash
# Optionally regenerate the application theme from a wallpaper and reload Waybar.
# MANUAL ONLY: nothing calls this automatically (Matuwall has no hooks).
# Usage: apply.sh <path>
set -euo pipefail

WALLPAPER="${1:-}"
WALLPAPER_DIR="${HOME}/Pictures/Wallpapers"

if [[ -z "$WALLPAPER" ]]; then
    mapfile -t wallpaper_candidates < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f -print 2>/dev/null | sort)
    WALLPAPER="${wallpaper_candidates[0]:-}"
fi

if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
    echo "no wallpaper found ($WALLPAPER)" >&2
    exit 1
fi

matugen image "$WALLPAPER" --prefer=value

if pgrep -x waybar >/dev/null 2>&1; then
    pkill -x waybar
    sleep 0.2
fi

waybar_config="${WAYBAR_CONFIG:-$HOME/.config/waybar/config-niri.jsonc}"
setsid waybar -c "$waybar_config" -s "$HOME/.config/waybar/style.css" >/dev/null 2>&1 &
