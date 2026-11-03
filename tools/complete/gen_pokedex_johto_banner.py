#!/usr/bin/env python3
"""Make the Pokédex's "JOHTO POKéDEX" banner (src/complete_pokedex.c: Johto's is the regional Pokédex until Sinnoh's
story begins): a copy of the Pokédex list's tile sheet, decomp/res/graphics/pokedex/scroll_main_background.png, with its
"SINNOH POKéDEX" banner redrawn in the same pixel font and palette as "JOHTO POKéDEX", in the same tiles, so the
banner's tilemap (search_sinnoh.NSCR) shows it as it is. O and H come from SINNOH, T from the NATIONAL POKéDEX banner
below it, and J is drawn in the same style (2-pixel strokes, 9 rows). The Pokédex loads this sheet in Johto's mode.

Usage: python3 tools/complete/gen_pokedex_johto_banner.py
"""
import os

from PIL import Image

POKEDEX = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp', 'res', 'graphics', 'pokedex')
SRC = os.path.join(POKEDEX, 'scroll_main_background.png')
OUT = os.path.join(POKEDEX, 'scroll_main_background_johto.png')

RED, WHITE, DARK = 0xA, 0xC, 0xD  # the Sinnoh banner's background, letters and their box
TEXT = (136, 214)  # the columns "SINNOH POKéDEX" spans, its box's outline included
ROWS = (5, 15)  # the box's top and bottom outline rows; the letters are rows 6-14
POKEDEX_WORD = (173, 214)  # "POKéDEX" with its box
SINNOH_GLYPHS = {'O': 160, 'H': 166}  # the left column of each letter in SINNOH, 5 wide
NATIONAL_T = (144, 30)  # the T of NATIONAL POKéDEX: its left column and top row, 6 wide
J = ['...##',
     '...##',
     '...##',
     '...##',
     '...##',
     '...##',
     '##.##',
     '##.##',
     '#####']


def glyph(px, x0, y0, width):
    return [''.join('#' if px[x, y] == WHITE else '.' for x in range(x0, x0 + width)) for y in range(y0, y0 + 9)]


def main():
    im = Image.open(SRC)
    px = im.load()
    letters = [J, glyph(px, SINNOH_GLYPHS['O'], 6, 5), glyph(px, SINNOH_GLYPHS['H'], 6, 5),
               glyph(px, NATIONAL_T[0], NATIONAL_T[1], 6), glyph(px, SINNOH_GLYPHS['O'], 6, 5)]
    word = [ROWS[0], ROWS[1]]
    pokedex = {(x - POKEDEX_WORD[0], y): px[x, y] for x in range(POKEDEX_WORD[0], POKEDEX_WORD[1] + 1)
               for y in range(word[0], word[1] + 1)}
    johto_width = 1 + sum(len(g[0]) + 1 for g in letters)  # the outline column before each letter and after the last
    total = johto_width + 1 + (POKEDEX_WORD[1] - POKEDEX_WORD[0] + 1)
    left = TEXT[0] + (TEXT[1] - TEXT[0] + 1 - total) // 2

    out = im.copy()
    opx = out.load()
    for x in range(TEXT[0], TEXT[1] + 1):  # the banner without its text
        for y in range(word[0], word[1] + 1):
            opx[x, y] = RED
    for x in range(left, left + johto_width):  # JOHTO's box, then its letters
        for y in range(word[0], word[1] + 1):
            opx[x, y] = DARK
    x = left + 1
    for g in letters:
        for row, line in enumerate(g):
            for dx, c in enumerate(line):
                if c == '#':
                    opx[x + dx, 6 + row] = WHITE
        x += len(g[0]) + 1
    start = left + johto_width + 1
    for (dx, y), v in pokedex.items():
        opx[start + dx, y] = v
    out.save(OUT)
    print(f'{OUT}: JOHTO from column {left}, POKéDEX from {start}')


if __name__ == '__main__':
    main()
