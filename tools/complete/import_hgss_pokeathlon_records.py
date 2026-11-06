#!/usr/bin/env python3
"""Bring in the graphics of HeartGold's Pokéathlon record screens (include/complete_pokeathlon_records.h,
src/applications/complete_pokeathlon_records/), packed into
decomp/res/prebuilt/graphic/complete_pokeathlon_records/pokeathlon_records.narc
(NARC_INDEX_GRAPHIC__COMPLETE__POKEATHLON_RECORDS): HeartGold's a/1/7/7 (its NARC 177), member n is member n.

HeartGold's overlay 99 (the four record screens) and overlay 98 (their shared parts) load its members by number; the
ports load them from here in the same way. What the course record screen uses:

| members | what                                                                                             |
|---------|--------------------------------------------------------------------------------------------------|
| 0-3     | the cursor and the courses' crowns (sprites: palette, tiles, cells, animations)                   |
| 4-7     | the five course buttons (five palettes)                                                          |
| 8-11    | the total's digits on the top screen                                                             |
| 20-23   | the total's digits on the medal and its sparkles                                                 |
| 28, 29  | blank tiles for a Pokémon icon (two frames, one), replaced by the icon                           |
| 30-41   | the bottom screen's palette, background and panel (30-32, 36-38) and the top screen's (33-35,     |
|         | 39-41)                                                                                           |
| 62-73   | the courses' pages: the medal's tiles (62) and a map for each course (63-67) on the bottom      |
|         | screen, the ribbon's (68, 69-73) on the top                                                     |

Its text is HeartGold's message banks 313 and 314 (tools/complete/import_hgss_text.py); the Pokémon's pictures and
icons are Complete's own.

Usage, after tools/complete/build_heartgold.sh:
    python3 tools/complete/import_hgss_pokeathlon_records.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, hg_narc  # noqa: E402
from narc import write_narc  # noqa: E402

RECORDS = 'a/1/7/7'
MEMBERS = 74
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'graphic', 'complete_pokeathlon_records')


def main():
    members = hg_narc(RECORDS)
    if len(members) != MEMBERS:
        sys.exit(f'{RECORDS} has {len(members)} members, not {MEMBERS}')
    if members[30][:4] != b'RLCN' or members[33][:4] != b'RLCN':
        sys.exit(f'{RECORDS} members 30 and 33 are not palettes')
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'pokeathlon_records.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w') as f:
        f.write("# Sovereign Complete: HeartGold's Pokéathlon record screens\n"
                "# (tools/complete/import_hgss_pokeathlon_records.py, src/applications/complete_pokeathlon_records/)\n"
                "nitrofs_files += fs.copyfile('pokeathlon_records.narc')\n")
    print(f'{len(members)} members -> {os.path.relpath(OUT, os.path.dirname(DECOMP))}/pokeathlon_records.narc')


if __name__ == '__main__':
    main()
