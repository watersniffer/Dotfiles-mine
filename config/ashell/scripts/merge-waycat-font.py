#!/usr/bin/env python3
"""Merge Waycat's A-L cat glyphs into JetBrainsMono Nerd Font.

ashell renders all bar text with a single global font, so the CPU cat
(drawn with Waycat's A-L glyphs) cannot be given its own font the way
waybar's per-module CSS does. This builds one real font family that has
Waycat's cat glyphs for A-L and JetBrainsMono Nerd Font for everything
else, so the cat animates and the rest of the bar keeps its font.
"""
import sys

from fontTools.misc.transform import Transform
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.pens.transformPen import TransformPen
from fontTools.ttLib import TTFont

BASE_PATH = "/usr/share/fonts/TTF/JetBrainsMonoNerdFont-Regular.ttf"
WAYCAT_PATH = "/home/water/.local/share/fonts/Waycat.ttf"
OUT_PATH = sys.argv[1] if len(sys.argv) > 1 else "/tmp/WaycatMono.ttf"
CAT_CHARS = "ABCDEFGHIJKL"
NEW_FAMILY = "WaycatMono"

base = TTFont(BASE_PATH)
waycat = TTFont(WAYCAT_PATH)

base_upem = base["head"].unitsPerEm
waycat_upem = waycat["head"].unitsPerEm
scale = base_upem / waycat_upem

waycat_cmap = waycat.getBestCmap()
base_cmap = base.getBestCmap()
base_glyf = base["glyf"]
base_hmtx = base["hmtx"]
waycat_hmtx = waycat["hmtx"]
waycat_glyphset = waycat.getGlyphSet()

glyph_order = base.getGlyphOrder()

for char in CAT_CHARS:
    wc_name = waycat_cmap[ord(char)]
    # Draw Waycat's glyph into a new TTGlyph, scaled to the base upem.
    pen = TTGlyphPen(base_glyf)
    tpen = TransformPen(pen, Transform(scale, 0, 0, scale, 0, 0))
    waycat_glyphset[wc_name].draw(tpen)
    glyph = pen.glyph()

    new_name = f"waycat{char}"
    # __setitem__ appends new_name to glyf.glyphOrder (== glyph_order) for us.
    base_glyf[new_name] = glyph
    base_cmap[ord(char)] = new_name
    aw, lsb = waycat_hmtx[wc_name]
    base_hmtx[new_name] = (round(aw * scale), round(lsb * scale))

base.setGlyphOrder(glyph_order)
base["maxp"].numGlyphs = len(glyph_order)

# post 3.0 stores no glyph names, so the new glyphs need no post table entry.
base["post"].formatType = 3.0

# Rename the family so fontconfig/fontdb treat this as its own family.
# name ID 16/17 (typographic family/subfamily) take precedence over 1/2 in
# fontconfig, so they must be changed too.
name = base["name"]
for nid, value in ((1, NEW_FAMILY), (3, f"{NEW_FAMILY}-merged"),
                   (4, NEW_FAMILY), (6, f"{NEW_FAMILY}-Regular"),
                   (16, NEW_FAMILY), (17, "Regular")):
    name.setName(value, nid, 3, 1, 0x409)
    name.setName(value, nid, 1, 0, 0)

base.save(OUT_PATH)
print(f"wrote {OUT_PATH}")
