#!/usr/bin/env python3
"""Regenerate config-hypr.jsonc from config-niri.jsonc.

The Hyprland bar should be the niri bar, not a lookalike: hand-editing the two
apart is how they drift. This makes the copy and applies only the two changes
the different workspace module actually requires.
"""
import pathlib
import sys

HERE = pathlib.Path(__file__).parent
SRC = HERE / "config-niri.jsonc"
DST = HERE / "config-hypr.jsonc"

HEADER = '''// Waybar for the Hyprland session. Generated from config-niri.jsonc -- do not
// edit by hand, or the two bars drift apart. The only two changes from the niri
// version are marked below; everything else is byte-identical so the bar looks
// and behaves the same in both sessions.
//
// 1. niri/workspaces -> hyprland/workspaces: a different module.
// 2. the workspace format is {id}, not {value}. {value} is a niri-only
//    placeholder -- the Hyprland module has {id} and {name} and no {value}, so
//    carrying it across renders the label empty and the numbers do not appear.
//
// Regenerate with: config/waybar/make-config-hypr.py
'''

OLD_BLOCK = '''  "hyprland/workspaces": {
    "format": "{value}"
  },'''
NEW_BLOCK = '''  "hyprland/workspaces": {
    // {id} is the workspace number, {name} whatever it is called. There is no
    // {value} in this module -- that is niri/workspaces, and the two modules do
    // not share a placeholder set, so carrying it over rendered nothing.
    "format": "{id}"
  },'''


def main() -> int:
    if not SRC.is_file():
        print(f"missing {SRC}", file=sys.stderr)
        return 1
    body = SRC.read_text(encoding="utf-8").replace('"niri/workspaces"', '"hyprland/workspaces"')
    if OLD_BLOCK in body:
        body = body.replace(OLD_BLOCK, NEW_BLOCK)
    elif NEW_BLOCK not in body:
        print("warning: workspace block not found; copied without the format fix",
              file=sys.stderr)
    DST.write_text(HEADER + body, encoding="utf-8")
    print(f"wrote {DST}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
