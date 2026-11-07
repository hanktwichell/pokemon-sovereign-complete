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
| 16-19   | the player's picture on the trophies screen (two cells, two palettes: Ethan's, then the girl's)  |
| 20-23   | the total's digits on the medal and its sparkles                                                 |
| 28, 29  | blank tiles for a Pokémon icon (two frames, one), replaced by the icon                           |
| 30-41   | the bottom screen's palette, background and panel (30-32, 36-38) and the top screen's (33-35,     |
|         | 39-41)                                                                                           |
| 62-73   | the courses' pages: the medal's tiles (62) and a map for each course (63-67) on the bottom      |
|         | screen, the ribbon's (68, 69-73) on the top                                                     |

Complete's girl is Dawn, not Lyra: the girl's half of the player's picture (members 16 and 17: her palette, the
second, and her cell's tiles, from tile 100) becomes Dawn's front picture (decomp/res/trainers/classes/player_female/
front.png, the same 80x80 as HeartGold's), cut to the cell's six OAMs as HeartGold's is.

Its text is HeartGold's message banks 313 and 314 (tools/complete/import_hgss_text.py); the Pokémon's pictures and
icons are Complete's own.

Usage, after tools/complete/build_heartgold.sh:
    python3 tools/complete/import_hgss_pokeathlon_records.py
"""
import os
import sys

import ndspy.lz10
from PIL import Image

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_legend_cinematic import lz11_decompress  # noqa: E402
from import_hgss_maps import DECOMP, hg_narc  # noqa: E402
from narc import write_narc  # noqa: E402

RECORDS = 'a/1/7/7'
MEMBERS = 74
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'graphic', 'complete_pokeathlon_records')
PLAYER_PLTT, PLAYER_CHAR = 16, 17
DAWN = os.path.join(DECOMP, 'res', 'trainers', 'classes', 'player_female', 'front.png')
# The girl's cell (HeartGold's cell 1, "trwoman"): each OAM's place in the 80x80 picture, its size and its first tile
# (CharName in two-tile units: 1D 64K mapping)
GIRL_OAMS = [(-40, -40, 64, 64, 50), (24, -40, 16, 32, 82), (24, -8, 16, 32, 86), (-40, 24, 32, 16, 90),
             (-8, 24, 32, 16, 94), (24, 24, 16, 16, 98)]
TILES = 0x30  # an NCGR's tiles start here (RGCN header, then RAHC's)
COLORS = 0x28  # an NCLR's colors (RLCN header, then TTLP's)


def dawn_picture(pltt, char):
    """HeartGold's player picture (palette, compressed tiles) with Dawn in the girl's place."""
    im = Image.open(DAWN)
    if im.size != (80, 80) or im.mode != 'P':
        sys.exit(f'{DAWN}: not an 80x80 indexed picture')
    tiles = bytearray(lz11_decompress(char))
    if tiles[:4] != b'RGCN' or len(tiles) != TILES + 200 * 32:
        sys.exit('the player picture\'s tiles are not two 80x80 cells')
    pixels = im.load()
    for x0, y0, w, h, char_name in GIRL_OAMS:
        at = TILES + char_name * 2 * 32
        for ty in range(h // 8):
            for tx in range(w // 8):
                for y in range(8):
                    for x in range(0, 8, 2):
                        px, py = x0 + 40 + tx * 8 + x, y0 + 40 + ty * 8 + y
                        tiles[at] = (pixels[px, py] & 0xF) | (pixels[px + 1, py] & 0xF) << 4
                        at += 1
    pltt = bytearray(pltt)
    if pltt[:4] != b'RLCN':
        sys.exit('the player picture\'s palette is not an NCLR')
    rgb = im.getpalette()[:48]
    for i in range(16):
        r, g, b = rgb[3 * i:3 * i + 3]
        pltt[COLORS + 32 + 2 * i:COLORS + 32 + 2 * i + 2] = (r >> 3 | (g >> 3) << 5 | (b >> 3) << 10).to_bytes(2, 'little')
    return bytes(pltt), ndspy.lz10.compress(bytes(tiles))


def main():
    members = hg_narc(RECORDS)
    if len(members) != MEMBERS:
        sys.exit(f'{RECORDS} has {len(members)} members, not {MEMBERS}')
    if members[30][:4] != b'RLCN' or members[33][:4] != b'RLCN':
        sys.exit(f'{RECORDS} members 30 and 33 are not palettes')
    members[PLAYER_PLTT], members[PLAYER_CHAR] = dawn_picture(members[PLAYER_PLTT], members[PLAYER_CHAR])
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'pokeathlon_records.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w') as f:
        f.write("# Sovereign Complete: HeartGold's Pokéathlon record screens\n"
                "# (tools/complete/import_hgss_pokeathlon_records.py, src/applications/complete_pokeathlon_records/)\n"
                "nitrofs_files += fs.copyfile('pokeathlon_records.narc')\n")
    print(f'{len(members)} members -> {os.path.relpath(OUT, os.path.dirname(DECOMP))}/pokeathlon_records.narc')


if __name__ == '__main__':
    main()
