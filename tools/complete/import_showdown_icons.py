#!/usr/bin/env python3
"""Box, PC and party icons from Pokémon Showdown for every Pokémon (the owner's call, Nov 6, 2026: "why can't we just
use Showdown's box sprite for every Pokémon").

Showdown's icon sheet (https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png: 40x30 cells, 12 to a row, a
species' cell at its National Pokédex number; the forms' cells are named in battle-dex-data.js's
BattlePokemonIconIndexes) is converted to the game's icons as Sovereign's placeholders were
(tools/sprites/make_placeholder_icons.py): each icon cropped to its art, scaled down only if wider or taller than 30
pixels, set bottom-centre in a 32x32 frame, and drawn in whichever of the three shared icon palettes
(res/pokemon/.shared/pl_poke_icon.pal) matches it best; the second frame is the first a pixel higher (the bounce), and
the PNG is 4-bit, as the icon NARC needs.

This writes decomp/res/pokemon/<species>/icon.png and the palette number in its data.json ("icon_palette") for
#1-1025; the forms' own icons come later (the forms show their species' icon). The data files are Sovereign's, which
JSON can't mark with a comment: this script is the record; a sync's three-way patch keeps the edits, but rerun it if a
sync clashes on those lines. The two downloads are kept in .cache/showdown.

Usage: python3 tools/complete/import_showdown_icons.py [DEX ...]
"""
import os
import re
import subprocess
import sys

from PIL import Image

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'sprites'))
from make_placeholder_icons import FRAME, fit, load_palettes, quantise  # noqa: E402

DECOMP = os.path.join(ROOT, 'decomp')
CACHE = os.path.join(ROOT, '.cache', 'showdown')
SHEET_URL = 'https://play.pokemonshowdown.com/sprites/pokemonicons-sheet.png'
DATA_URL = 'https://play.pokemonshowdown.com/js/battle-dex-data.js'
CELL_W, CELL_H, PER_ROW = 40, 30, 12
LAST_DEX = 1025


def download(url, name):
    path = os.path.join(CACHE, name)
    if not os.path.exists(path):
        os.makedirs(CACHE, exist_ok=True)
        subprocess.run(['curl', '-sSfL', '-o', path, url], check=True)
    return path


def cell(sheet, index):
    """The icon at a cell of the sheet, its background made transparent."""
    x, y = (index % PER_ROW) * CELL_W, (index // PER_ROW) * CELL_H
    im = sheet.crop((x, y, x + CELL_W, y + CELL_H)).convert('RGBA')
    return im if im.getbbox() else None


def to_icon(art, palettes):
    """(the 32x64 two-frame 4-bit icon, its palette number)"""
    frame = fit(art, True)
    best = min(range(len(palettes)), key=lambda k: quantise(frame, palettes[k])[1])
    indices, _ = quantise(frame, palettes[best])
    first = Image.new('P', (FRAME, FRAME))
    first.putdata(indices)
    icon = Image.new('P', (FRAME, FRAME * 2), 0)
    icon.paste(first, (0, 0))
    icon.paste(first, (0, FRAME - 1))  # the second frame: a pixel higher
    flat = [c for colour in palettes[best] for c in colour]
    icon.putpalette(flat + [0] * (48 - len(flat)))
    return icon, best


def main():
    wanted = {int(a) for a in sys.argv[1:]}
    sheet = Image.open(download(SHEET_URL, 'pokemonicons-sheet.png')).convert('RGBA')
    palettes = load_palettes()
    species = open(os.path.join(DECOMP, 'generated', 'species.txt')).read().split()
    done, missing = 0, []
    for dex in range(1, LAST_DEX + 1):
        if wanted and dex not in wanted:
            continue
        folder = os.path.join(DECOMP, 'res', 'pokemon', species[dex][len('SPECIES_'):].lower())
        art = cell(sheet, dex)
        if art is None or not os.path.isdir(folder):
            missing.append(dex)
            continue
        icon, palette = to_icon(art, palettes)
        icon.save(os.path.join(folder, 'icon.png'), bits=4)
        data = os.path.join(folder, 'data.json')
        text = open(data, encoding='utf-8').read()
        new = re.sub(r'("icon_palette": )\d+', rf'\g<1>{palette}', text, count=1)
        if new != text:
            open(data, 'w', encoding='utf-8').write(new)
        done += 1
    print(f'{done} icons from Showdown' + (f'; none for {missing}' if missing else ''))


if __name__ == '__main__':
    main()
