#!/usr/bin/env bash
# Feed catloop.sh frames to ashell's listen_cmd as JSON lines.
#
# catloop.sh emits one frame letter per line (A-E awake, G-N sleeping) and
# runs forever; ashell's listen_cmd wants compact JSON on stdout.
#
# The frame letter is mapped onto a Private Use Area codepoint (U+E000+)
# because the bar's font (WaycatMono) carries the cat glyphs there. Putting
# them over A-L instead would turn every A-L letter in every menu (calendar,
# WiFi, Bluetooth, ...) into a cat, which is exactly the bug this avoids.

bash ~/.config/waybar/scripts/catloop.sh | while IFS= read -r frame; do
    case "$frame" in
        A) printf '{"text": "", "alt": ""}\n' ;;
        B) printf '{"text": "", "alt": ""}\n' ;;
        C) printf '{"text": "", "alt": ""}\n' ;;
        D) printf '{"text": "", "alt": ""}\n' ;;
        E) printf '{"text": "", "alt": ""}\n' ;;
        F) printf '{"text": "", "alt": ""}\n' ;;
        G) printf '{"text": "", "alt": ""}\n' ;;
        H) printf '{"text": "", "alt": ""}\n' ;;
        I) printf '{"text": "", "alt": ""}\n' ;;
        J) printf '{"text": "", "alt": ""}\n' ;;
        K) printf '{"text": "", "alt": ""}\n' ;;
        L) printf '{"text": "", "alt": ""}\n' ;;
    esac
done
