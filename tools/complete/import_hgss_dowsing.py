#!/usr/bin/env python3
"""Bring in what HeartGold's Dowsing Machine needs (include/complete_dowsing.h, src/applications/complete_dowsing/),
packed into decomp/res/prebuilt/graphic/complete_dowsing/dowsing.narc (NARC_INDEX_GRAPHIC__COMPLETE__DOWSING):

| members | from                                                                                              |
|---------|---------------------------------------------------------------------------------------------------|
| 0-7     | HeartGold's a/2/5/1 (its NARC 253), member n is member n: the frame's map (0) and the radar's      |
|         | dots' map (1), their tiles (2) and palette (3); the needles' tiles (4), cells (5), animations (6)  |
|         | and palette (7)                                                                                   |
| 8-11    | HeartGold's a/0/1/4 (its NARC 14), the field's touch-screen buttons (the A button, the running     |
|         | shoes, EXIT): its members 7 (palette), 68 (cells), 69 (animations) and 70 (tiles)                 |

HeartGold's overlay 28 loads these by number (its ov28_0225D6FC, ov28_0225DA74 and ov28_0225DB8C); the port loads
them from here in the same way. Its text is HeartGold's message bank 196 (tools/complete/import_hgss_text.py), and its
sound HeartGold's SEQ_SE_GS_DOWSING_SINGLE (tools/complete/import_hgss_sound.py).

Usage, after tools/complete/build_heartgold.sh:
    python3 tools/complete/import_hgss_dowsing.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, hg_narc  # noqa: E402
from narc import write_narc  # noqa: E402

DOWSING = 'a/2/5/1'
DOWSING_MEMBERS = 8
BUTTONS = 'a/0/1/4'
BUTTON_MEMBERS = [7, 68, 69, 70]  # palette, cells, animations, tiles
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'graphic', 'complete_dowsing')


def main():
    dowsing = hg_narc(DOWSING)
    if len(dowsing) != DOWSING_MEMBERS:
        sys.exit(f'{DOWSING} has {len(dowsing)} members, not {DOWSING_MEMBERS}')
    buttons = hg_narc(BUTTONS)
    if buttons[BUTTON_MEMBERS[0]][:4] != b'RLCN':
        sys.exit(f'{BUTTONS} member {BUTTON_MEMBERS[0]} is not a palette')
    members = dowsing + [buttons[i] for i in BUTTON_MEMBERS]
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'dowsing.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w') as f:
        f.write("# Sovereign Complete: HeartGold's Dowsing Machine (tools/complete/import_hgss_dowsing.py,\n"
                "# src/applications/complete_dowsing/)\n"
                "nitrofs_files += fs.copyfile('dowsing.narc')\n")
    print(f'{len(members)} members -> {os.path.relpath(OUT, os.path.dirname(DECOMP))}/dowsing.narc')


if __name__ == '__main__':
    main()
