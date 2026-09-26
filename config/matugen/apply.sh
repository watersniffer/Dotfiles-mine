#!/usr/bin/env bash
# Backwards-compatible entry point. The real work lives in
# local/bin/matugen-theme, which is what Matuwall's on_apply hook calls.
# Kept because the README documents this path.
set -uo pipefail
exec "$HOME/.local/bin/matugen-theme" "$@"
