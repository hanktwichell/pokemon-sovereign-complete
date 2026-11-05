#!/usr/bin/env python3
"""Make the three-region Town Map's graphics: one 512x512 map the Town Map scrolls across, Sinnoh at its top right as
Platinum's top screen shows it, Johto and Kanto below to the left (HeartGold's map, the Pokégear's), sea between.

Its layers on the Town Map's top screen (src/applications/town_map/complete_town_map.c):
- Sinnoh: Platinum's two map layers (the land under the routes) drawn together and cut into tiles again, each in
  one of up to SINNOH_PALETTES 15-colour palettes its colours fit (tiles that repeat, flipped or not, kept once),
  at character base 0x10000; with a patch for each hidden place (Fullmoon and Newmoon Islands, the Spring and
  Seabreak Paths) drawn as Platinum's ShowHiddenLocation draws it.
- Johto and Kanto: HeartGold's map's own tiles and palettes (the Pokégear's 16-colour ones), at character base 0x18000,
  with the sea around both regions.
- The frame: Platinum's own frame (its borders and the bar at the bottom) with the map's window left clear, in front.

Out: decomp/res/prebuilt/graphic/complete_town_map/town_map.narc (members in MEMBERS' order) and
include/data/complete_town_map.h (where each region sits).

Usage: python3 tools/complete/import_town_map.py
"""
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from narc import write_narc  # noqa: E402
from render_region_maps import TOWN_MAP, POKEGEAR, jasc, nscr, tile_sheet  # noqa: E402

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
DECOMP = os.path.join(ROOT, 'decomp')
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'graphic', 'complete_town_map', 'town_map.narc')
HEADER = os.path.join(DECOMP, 'include', 'data', 'complete_town_map.h')
MEMBERS = ['sinnoh_tiles', 'sinnoh_palettes', 'sinnoh_tilemap', 'hidden_fullmoon', 'hidden_newmoon', 'hidden_spring',
           'hidden_seabreak', 'hgss_tiles', 'hgss_palettes', 'hgss_tilemap', 'frame_tilemap']
CANVAS = 64  # tiles a side
VIEW_X, VIEW_Y, VIEW_W, VIEW_H = 2, 0, 28, 21  # the map's window on the top screen, in tiles (inside the frame)
SINNOH_X, SINNOH_Y = CANVAS - VIEW_W, 0  # where Sinnoh's window sits on the canvas
HGSS_X, HGSS_Y = 0, 23  # where HeartGold's 48x20 map sits
SINNOH_PALETTE, SINNOH_PALETTES = 2, 6  # the main screen's palettes for each: 2-7 and 8-12
HGSS_PALETTE, HGSS_PALETTES = 8, 5
SEA_TILE = (0, 19)  # a tile of HeartGold's sea, in its map
# Platinum's ShowHiddenLocation: each place's rect on the land layer and on the routes layer (src, dest, size)
HIDDEN = [
    (((5, 0), (3, 1), (2, 3)), ((5, 3), (3, 2), (2, 2))),
    (((0, 0), (6, 1), (2, 3)), ((0, 3), (6, 2), (2, 2))),
    (None, ((4, 5), (22, 13), (3, 3))),
    (((2, 0), (26, 0), (3, 3)), ((2, 3), (27, 0), (2, 9))),
]


def bgr555(rgb):
    r, g, b = (v >> 3 for v in rgb[:3])
    return r | g << 5 | b << 10


def draw_rgb(tiles, palette, entries, width, height, base=None):
    """A tilemap's pixels as RGB rows (None where transparent), over base's"""
    px = base or [[None] * (width * 8) for _ in range(height * 8)]
    for ty in range(height):
        for tx in range(width):
            e = entries[ty * width + tx]
            tile, hflip, vflip, pal = e & 0x3ff, e >> 10 & 1, e >> 11 & 1, e >> 12
            for y in range(8):
                for x in range(8):
                    v = tiles[tile][7 - y if vflip else y][7 - x if hflip else x]
                    if v or base is None:
                        px[ty * 8 + y][tx * 8 + x] = palette[pal * 16 + v][:3]
    return px


def paste(entries, width, src, src_width, src_xy, dest_xy, size):
    entries = list(entries)
    (sx, sy), (dx, dy), (w, h) = src_xy, dest_xy, size
    for y in range(h):
        for x in range(w):
            entries[(dy + y) * width + dx + x] = src[(sy + y) * src_width + sx + x]
    return entries


class Tiler:
    """Cuts pictures into 4bpp tiles: palettes of 15 colours (index 0 clear) shared by tiles whose colours fit, and
    each tile kept once (with flips)."""

    def __init__(self, palettes):
        self.max_palettes = palettes
        self.palettes = []  # lists of colours
        self.tiles = [bytes(32)]  # tile 0: clear
        self.seen = {bytes(32): (0, 0, 0)}

    def palette_for(self, colours):
        best = None
        for i, pal in enumerate(self.palettes):
            grow = len(colours - set(pal))
            if len(pal) + grow <= 15 and (best is None or grow < best[1]):
                best = (i, grow)
        if best is None:
            assert len(self.palettes) < self.max_palettes, 'too many palettes'
            self.palettes.append([])
            best = (len(self.palettes) - 1, len(colours))
        pal = self.palettes[best[0]]
        pal += sorted(colours - set(pal))
        return best[0]

    def entry(self, pixels):
        """The tilemap entry for one 8x8 tile of RGB rows"""
        colours = {c for row in pixels for c in row}
        p = self.palette_for(colours)
        pal = self.palettes[p]
        idx = [[pal.index(c) + 1 for c in row] for row in pixels]
        for hf in (0, 1):
            for vf in (0, 1):
                rows = idx[::-1] if vf else idx
                rows = [r[::-1] for r in rows] if hf else rows
                data = bytes(rows[y][x] | rows[y][x + 1] << 4 for y in range(8) for x in range(0, 8, 2))
                key = (p, data)
                if key in self.seen:
                    t = self.seen[key]
                    return t | hf << 10 | vf << 11 | p << 12
        data = bytes(idx[y][x] | idx[y][x + 1] << 4 for y in range(8) for x in range(0, 8, 2))
        self.tiles.append(data)
        self.seen[(p, data)] = len(self.tiles) - 1
        assert len(self.tiles) <= 1024, 'too many tiles'
        return (len(self.tiles) - 1) | p << 12


def sinnoh_layers():
    tiles = tile_sheet(os.path.join(TOWN_MAP, 'top_screen_map_tiles.png'))
    palette = jasc(os.path.join(TOWN_MAP, 'top_screen_map.pal'))
    palette += [(0, 0, 0)] * (256 - len(palette))
    _, _, land = nscr(os.path.join(TOWN_MAP, 'top_screen_region_bg_tilemap.NSCR'))
    _, _, routes = nscr(os.path.join(TOWN_MAP, 'top_screen_region_map_tilemap.NSCR'))
    hw, _, hidden = nscr(os.path.join(TOWN_MAP, 'hidden_locations_top_screen.NSCR'))
    return tiles, palette, land, routes, hidden, hw


def main():
    tiles, palette, land, routes, hidden, hw = sinnoh_layers()
    tiler = Tiler(SINNOH_PALETTES)

    def window_entries(land_entries, route_entries, rect=None):
        px = draw_rgb(tiles, palette, land_entries, 32, 24)
        px = draw_rgb(tiles, palette, route_entries, 32, 24, base=px)
        x0, y0, w, h = rect or (VIEW_X, VIEW_Y, VIEW_W, VIEW_H)
        out = {}
        for ty in range(y0, y0 + h):
            for tx in range(x0, x0 + w):
                if VIEW_X <= tx < VIEW_X + VIEW_W and VIEW_Y <= ty < VIEW_Y + VIEW_H:
                    out[(tx, ty)] = tiler.entry([row[tx * 8:tx * 8 + 8] for row in px[ty * 8:ty * 8 + 8]])
        return out

    base = window_entries(land, routes)
    sinnoh_map = [0] * (CANVAS * CANVAS)
    for (tx, ty), e in base.items():
        sinnoh_map[(SINNOH_Y + ty - VIEW_Y) * CANVAS + SINNOH_X + tx - VIEW_X] = e
    patches = []
    for land_rect, route_rect in HIDDEN:
        l2 = paste(land, 32, hidden, hw, *land_rect) if land_rect else land
        r2 = paste(routes, 32, hidden, hw, *route_rect)
        rects = [r for r in (land_rect, route_rect) if r]
        x0 = min(r[1][0] for r in rects)
        y0 = min(r[1][1] for r in rects)
        x1 = max(r[1][0] + r[2][0] for r in rects)
        y1 = max(r[1][1] + r[2][1] for r in rects)
        entries = window_entries(l2, r2, (x0, y0, x1 - x0, y1 - y0))
        cells = sorted(entries.items(), key=lambda kv: (kv[0][1], kv[0][0]))
        # x, y on the canvas, then each cell's (x, y, entry)
        patches.append(struct.pack('<H', len(cells)) + b''.join(
            struct.pack('<BBH', SINNOH_X + tx - VIEW_X, SINNOH_Y + ty - VIEW_Y, e) for (tx, ty), e in cells))
    sinnoh_pals = b''.join(struct.pack('<16H', 0, *[bgr555(c) for c in pal] + [0] * (15 - len(pal)))
                           for pal in tiler.palettes)
    sinnoh_map = [e if not (e & 0x3ff) else (e & 0xfff) | ((e >> 12) + SINNOH_PALETTE) << 12 for e in sinnoh_map]
    sinnoh_tiles = b''.join(tiler.tiles)
    patches = [p[:2] + b''.join(p[2 + i * 4:4 + i * 4] + struct.pack(
        '<H', (lambda e: (e & 0xfff) | ((e >> 12) + SINNOH_PALETTE) << 12)(struct.unpack_from('<H', p, 4 + i * 4)[0]))
        for i in range(struct.unpack_from('<H', p)[0])) for p in patches]

    # Johto and Kanto: HeartGold's map as the Pokégear has it, on the sea
    hg_tiles_png = os.path.join(POKEGEAR, 'map.png')
    from PIL import Image
    im = Image.open(hg_tiles_png)
    pxl = im.load()
    w, h = im.size
    hg_tiles = b''.join(bytes(pxl[tx * 8 + x, ty * 8 + y] | pxl[tx * 8 + x + 1, ty * 8 + y] << 4
                              for y in range(8) for x in range(0, 8, 2))
                        for ty in range(h // 8) for tx in range(w // 8))
    hg_pal = jasc(os.path.join(POKEGEAR, 'map_0.pal'))
    hg_pals = b''.join(struct.pack('<16H', *[bgr555(c) for c in hg_pal[p * 16:p * 16 + 16]]) for p in range(HGSS_PALETTES))
    hg_entries = struct.unpack('<960H', open(os.path.join(POKEGEAR, 'map_tilemap.bin'), 'rb').read())
    shift = lambda e: (e & 0xfff) | ((e >> 12) + HGSS_PALETTE) << 12  # noqa: E731
    sea = shift(hg_entries[SEA_TILE[1] * 48 + SEA_TILE[0]])
    hg_map = [sea] * (CANVAS * CANVAS)
    for y in range(20):
        for x in range(47):  # its last column is a green edge the Pokégear's map keeps out of view: sea here
            hg_map[(HGSS_Y + y) * CANVAS + HGSS_X + x] = shift(hg_entries[y * 48 + x])

    # the frame: Platinum's land layer outside the map's window
    frame = [0 if VIEW_X <= i % 32 < VIEW_X + VIEW_W and VIEW_Y <= i // 32 < VIEW_Y + VIEW_H else e
             for i, e in enumerate(land)] + [0] * (32 * 8)

    def screen(entries):
        """A 64x64 tilemap in the DS's order: four 32x32 screens, top left, top right, bottom left, bottom right"""
        out = []
        for sy in (0, 32):
            for sx in (0, 32):
                for y in range(32):
                    out += entries[(sy + y) * CANVAS + sx:(sy + y) * CANVAS + sx + 32]
        return struct.pack(f'<{len(out)}H', *out)

    members = {
        'sinnoh_tiles': sinnoh_tiles, 'sinnoh_palettes': sinnoh_pals, 'sinnoh_tilemap': screen(sinnoh_map),
        'hidden_fullmoon': patches[0], 'hidden_newmoon': patches[1], 'hidden_spring': patches[2],
        'hidden_seabreak': patches[3], 'hgss_tiles': hg_tiles, 'hgss_palettes': hg_pals,
        'hgss_tilemap': screen(hg_map), 'frame_tilemap': struct.pack(f'<{len(frame)}H', *frame),
    }
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    write_narc(OUT, [members[m] for m in MEMBERS])
    lines = ['#ifndef POKEPLATINUM_DATA_COMPLETE_TOWN_MAP_H', '#define POKEPLATINUM_DATA_COMPLETE_TOWN_MAP_H', '',
             '// Sovereign Complete: the three-region Town Map\'s canvas (tools/complete/import_town_map.py), in tiles', '',
             f'#define COMPLETE_TOWN_MAP_CANVAS {CANVAS}',
             f'#define COMPLETE_TOWN_MAP_VIEW_X {VIEW_X}', f'#define COMPLETE_TOWN_MAP_VIEW_Y {VIEW_Y}',
             f'#define COMPLETE_TOWN_MAP_VIEW_W {VIEW_W}', f'#define COMPLETE_TOWN_MAP_VIEW_H {VIEW_H}',
             f'#define COMPLETE_TOWN_MAP_SINNOH_X {SINNOH_X}', f'#define COMPLETE_TOWN_MAP_SINNOH_Y {SINNOH_Y}',
             f'#define COMPLETE_TOWN_MAP_HGSS_X {HGSS_X}', f'#define COMPLETE_TOWN_MAP_HGSS_Y {HGSS_Y}',
             f'#define COMPLETE_TOWN_MAP_SINNOH_PALETTE {SINNOH_PALETTE}',
             f'#define COMPLETE_TOWN_MAP_SINNOH_PALETTES {len(tiler.palettes)}',
             f'#define COMPLETE_TOWN_MAP_HGSS_PALETTE {HGSS_PALETTE}',
             f'#define COMPLETE_TOWN_MAP_HGSS_PALETTES {HGSS_PALETTES}', '',
             'enum CompleteTownMapMember {'] + [f'    COMPLETE_TOWN_MAP_MEMBER_{m.upper()},' for m in MEMBERS] + [
             '};', '', '#endif // POKEPLATINUM_DATA_COMPLETE_TOWN_MAP_H', '']
    open(HEADER, 'w').write('\n'.join(lines))
    print(f'Sinnoh: {len(tiler.tiles)} tiles, {len(tiler.palettes)} palettes; Johto and Kanto: {len(hg_tiles) // 32} '
          f'tiles; {os.path.relpath(OUT, ROOT)}')

    # a picture of the canvas, to check
    preview = Image.new('RGB', (CANVAS * 8, CANVAS * 8))
    all_pal = {}
    for i, pal in enumerate(tiler.palettes):
        for j, c in enumerate(pal):
            all_pal[(SINNOH_PALETTE + i) * 16 + j + 1] = c
    for p in range(HGSS_PALETTES):
        for j in range(16):
            all_pal[(HGSS_PALETTE + p) * 16 + j] = hg_pal[p * 16 + j][:3]
    pp = preview.load()
    for layer, tdata in ((hg_map, hg_tiles), (sinnoh_map, sinnoh_tiles)):
        for i, e in enumerate(layer):
            t, hf, vf, pal = e & 0x3ff, e >> 10 & 1, e >> 11 & 1, e >> 12
            if layer is sinnoh_map and t == 0:
                continue
            for y in range(8):
                for x in range(8):
                    sx, sy = 7 - x if hf else x, 7 - y if vf else y
                    b = tdata[t * 32 + sy * 4 + sx // 2]
                    v = b >> 4 if sx & 1 else b & 15
                    if v or layer is hg_map:
                        pp[(i % CANVAS) * 8 + x, (i // CANVAS) * 8 + y] = all_pal.get(pal * 16 + v, (255, 0, 255))
    os.makedirs(os.path.join(ROOT, '.cache', 'maps'), exist_ok=True)
    preview.save(os.path.join(ROOT, '.cache', 'maps', 'town_map_canvas.png'))


if __name__ == '__main__':
    main()
