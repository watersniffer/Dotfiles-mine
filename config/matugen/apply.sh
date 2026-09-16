#!/usr/bin/env bash
# Regenerate the theme from a wallpaper and reload waybar.
WALLPAPER="$1"

if [[ -z "$WALLPAPER" ]]; then
    WALLPAPER=$(sweetbg query --json 2>/dev/null | jq -r '.. | .image? // empty' | head -n1)
    if [[ "$WALLPAPER" == null || -z "$WALLPAPER" ]]; then
        WALLPAPER="$HOME/Pictures/Wallpapers/dark-forest-backiee-HD.jpg"
    fi
fi

if [[ ! -f "$WALLPAPER" ]]; then
    echo "no wallpaper found ($WALLPAPER)" >&2
    exit 1
fi

matugen image "$WALLPAPER" --prefer=value

# SDDM: publish theme.conf + wallpaper into the theme dir (greeter runs as sddm)
SDDM_THEME="/usr/share/sddm/themes/gruvbox-minimal-sddm"
if [[ -d "$SDDM_THEME" && -f ~/.cache/matugen-sddm/theme.conf ]]; then
    sudo install -m 644 -D ~/.cache/matugen-sddm/theme.conf "$SDDM_THEME/theme.conf" 2>/dev/null
    sudo install -m 644 "$WALLPAPER" "$SDDM_THEME/painting.jpg" 2>/dev/null
fi

pkill -x waybar && sleep 0.2
setsid waybar >/dev/null 2>&1 &