#!/usr/bin/env python3
"""Bring in what HeartGold's Berry Pots need (include/complete_berry_pots.h, src/applications/complete_berry_pots/),
packed into decomp/res/prebuilt/graphic/complete_berry_pots/berry_pots.narc (NARC_INDEX_GRAPHIC__COMPLETE__BERRY_POTS):

| members | from HeartGold's a/2/1/6, member n is member n                                              |
|---------|----------------------------------------------------------------------------------------------|
| 0-5     | the screens: the bottom screen's palette, tiles and map (0-2), the top screen's (3-5)       |
| 6-11    | the sprites: the pots' and buttons' palette, tiles, cells and animations; the plants' cells  |
|         | and animations (10, 11)                                                                      |
| 12-75   | each berry's plant palette (berry n at 11 + n)                                               |
| 76-139  | each berry's plant tiles (berry n at 75 + n)                                                 |

HeartGold's sprite lists for the app (its resdat 28-31 and 79) name members 6-15 and 76-79 of the archive; the port
loads them by number. The 64 berries are Gen IV's, numbered as both games number them (Cheri 1 to Rowap 64).

The app's text is HeartGold's message bank 248 (tools/complete/import_hgss_text.py brings it in). The Berry Pots'
use from the bag is set by tools/complete/import_hgss_items.py.

Usage, after tools/complete/build_heartgold.sh:
    python3 tools/complete/import_hgss_berry_pots.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, hg_narc  # noqa: E402
from narc import write_narc  # noqa: E402

POTS = 'a/2/1/6'
MEMBERS = 140
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'graphic', 'complete_berry_pots')


def main():
    members = hg_narc(POTS)
    if len(members) != MEMBERS:
        sys.exit(f'{POTS} has {len(members)} members, not {MEMBERS}')
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'berry_pots.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w') as f:
        f.write("# Sovereign Complete: HeartGold's Berry Pots (tools/complete/import_hgss_berry_pots.py,\n"
                "# src/applications/complete_berry_pots/)\n"
                "nitrofs_files += fs.copyfile('berry_pots.narc')\n")
    print(f'{len(members)} members -> {os.path.relpath(OUT, os.path.dirname(DECOMP))}/berry_pots.narc')


if __name__ == '__main__':
    main()
