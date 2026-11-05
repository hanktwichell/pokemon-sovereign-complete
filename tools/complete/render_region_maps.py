#!/usr/bin/env python3
"""Draw the games' own region maps as pictures, with where each place is on them: Platinum's Town Map of Sinnoh (its
top screen: the frame layer under the map layer) and HeartGold's map of Johto and Kanto (the Pokégear's, as the
importer made it 16-colour), for the progress page's gallery and the three-region Town Map.

Each map's places: the overworld blocks each location name owns, on the map's grid (Sinnoh's Town Map: a cell of 7
pixels a block, offset by 25 and -34 as TOWN_MAP_GRID_X/Y place its cursor; HeartGold's: 8 pixels a block, two rows
down, as the Pokégear's MapPosition does), and for places off the overworld the cell their map header's world map
position gives.

Out: .cache/maps/sinnoh.png, johto_kanto.png and places.json ({map: {place key: [[x, y, w, h], ...]}}, the keys as
tools/complete/gallery_shots.py's).

Usage: python3 tools/complete/render_region_maps.py
"""
import json
import os
import re
import struct
import sys

from PIL import Image

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
DECOMP = os.path.join(ROOT, 'decomp')
OUT = os.path.join(ROOT, '.cache', 'maps')
TOWN_MAP = os.path.join(DECOMP, 'res', 'graphics', 'town_map')
POKEGEAR = os.path.join(DECOMP, 'res', 'graphics', 'complete_pokegear')
SINNOH_CELL, SINNOH_X, SINNOH_Y = 7, 25, -34
HGSS_CELL, HGSS_ROWS_DOWN = 8, 2


def jasc(path):
    lines = open(path).read().split('\n')
    count = int(lines[2])
    return [tuple(int(v) for v in line.split()) for line in lines[3:3 + count]]


def nscr(path):
    b = open(path, 'rb').read()
    i = b.find(b'NRCS')
    w, h = struct.unpack_from('<HH', b, i + 8)
    return w // 8, h // 8, struct.unpack_from(f'<{(w // 8) * (h // 8)}H', b, i + 0x14)


def draw(tiles, tiles_per_row, palette, entries, width, height, out=None, transparent=False):
    """A tilemap drawn: tiles a 2D list of 8x8 index rows by tile number, entries NSCR's (tile, flips, palette)."""
    im = out or Image.new('RGBA', (width * 8, height * 8), (0, 0, 0, 0))
    px = im.load()
    for ty in range(height):
        for tx in range(width):
            e = entries[ty * width + tx]
            tile, hflip, vflip, pal = e & 0x3ff, e >> 10 & 1, e >> 11 & 1, e >> 12
            if tile >= len(tiles):
                continue
            for y in range(8):
                for x in range(8):
                    v = tiles[tile][7 - y if vflip else y][7 - x if hflip else x]
                    if v == 0 and transparent:
                        continue
                    r, g, b = palette[pal * 16 + v][:3]
                    px[tx * 8 + x, ty * 8 + y] = (r, g, b, 255)
    return im


def tile_sheet(path):
    """8x8 tiles of colour indices, row by row: an indexed PNG's own indices, or a greyscale one's (the decomp's
    greyscale sheets store index 15 - value / 17: white is index 0)."""
    im = Image.open(path)
    data = im.load()
    w, h = im.size
    index = (lambda v: 15 - v // 17) if im.mode == 'L' else (lambda v: v)
    tiles = []
    for ty in range(h // 8):
        for tx in range(w // 8):
            tiles.append([[index(data[tx * 8 + x, ty * 8 + y]) for x in range(8)] for y in range(8)])
    return tiles


def headers():
    src = open(os.path.join(DECOMP, 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    out = {}
    for name, block in re.findall(r'\[(MAP_HEADER_\w+)\] = \{(.*?)\n    \},', src, re.S):
        fields = dict(re.findall(r'\.(\w+) = (\w+)', block))
        out[name] = (fields.get('mapLabelTextID', '').replace('LocationNames_Text_', '') or None,
                     fields.get('mapMatrixID'))
    return out


def place_key(header, label):
    return ('sinnoh' if not header.startswith('MAP_HEADER_HGSS_') else 'hgss') + '_' + (label or 'none')


def places_on(matrix_name, cell, x0, y0, info):
    grid = json.load(open(os.path.join(DECOMP, 'res', 'field', 'matrices', matrix_name + '.json')))['headers']
    out = {}
    for row, line in enumerate(grid):
        for col, header in enumerate(line):
            if header in info and info[header][0]:
                out.setdefault(place_key(header, info[header][0]), []).append(
                    [col * cell + x0, row * cell + y0, cell, cell])
    return out


def main():
    os.makedirs(OUT, exist_ok=True)
    info = headers()

    # Sinnoh: the frame layer, then the map layer over it (Platinum's top screen, layers 3 and 2)
    tiles = tile_sheet(os.path.join(TOWN_MAP, 'top_screen_map_tiles.png'))
    palette = jasc(os.path.join(TOWN_MAP, 'top_screen_map.pal'))
    palette += [(0, 0, 0)] * (256 - len(palette))
    w, h, bg = nscr(os.path.join(TOWN_MAP, 'top_screen_region_bg_tilemap.NSCR'))
    sinnoh = draw(tiles, 64, palette, bg, w, h)
    _, _, fg = nscr(os.path.join(TOWN_MAP, 'top_screen_region_map_tilemap.NSCR'))
    draw(tiles, 64, palette, fg, w, h, out=sinnoh, transparent=True)
    sinnoh.convert('RGB').save(os.path.join(OUT, 'sinnoh.png'))

    # Johto and Kanto: the Pokégear's map, its first skin's palettes
    tiles = tile_sheet(os.path.join(POKEGEAR, 'map.png'))
    palette = jasc(os.path.join(POKEGEAR, 'map_0.pal'))
    entries = struct.unpack('<960H', open(os.path.join(POKEGEAR, 'map_tilemap.bin'), 'rb').read())
    johto_kanto = draw(tiles, 32, palette, entries, 48, 20)
    johto_kanto.convert('RGB').save(os.path.join(OUT, 'johto_kanto.png'))

    sinnoh_matrix = info['MAP_HEADER_TWINLEAF_TOWN'][1]
    places = {'sinnoh': places_on(sinnoh_matrix, SINNOH_CELL, SINNOH_X - SINNOH_CELL // 2, SINNOH_Y - SINNOH_CELL // 2,
                                  info),
              'johto_kanto': places_on('map_matrix_hgss_0000', HGSS_CELL, 0, HGSS_ROWS_DOWN * HGSS_CELL, info)}
    json.dump(places, open(os.path.join(OUT, 'places.json'), 'w'))
    print(f'{OUT}: sinnoh.png {sinnoh.size}, johto_kanto.png {johto_kanto.size}, '
          f'{len(places["sinnoh"])} + {len(places["johto_kanto"])} places')


if __name__ == '__main__':
    main()
