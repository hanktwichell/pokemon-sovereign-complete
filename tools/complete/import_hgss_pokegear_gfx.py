#!/usr/bin/env python3
"""Copy HeartGold's Pokégear graphics that the bottom screen's Pokégear uses (src/applications/complete_pokegear/)
into decomp/res/graphics/complete_pokegear/, from the HeartGold source (.cache/pokeheartgold, tools/complete/
build_heartgold.sh), its first skin only:

- app_bar.png / app_bar.NSCR: the app switch bar (its pgear_gra 48 and 54): Settings, Radio, Map, Phone and the exit
  button, lit in rows 0-3 and dimmed in rows 4-7.
- phone.png / phone.NSCR: the phone's contact list frame with its scroll arrows (its pgphone_gra 28 and 34).
- pokegear.pal: one set of 16 palettes, the phone's 0-13 (pgphone_gra 10) and the app bar's 14-15 (pgear_gra 30), as
  HeartGold loads them. Its palettes are compressed (PMCP), which Platinum's loaders don't unpack, so they're plain
  here.
- map.png / map_tilemap.bin / map.pal: the map app's map of Johto and Kanto (its pgmap_gra 10 and 11 with palette 20,
  the 48 by 20 tiles of the map itself), made 16-colour (HeartGold's is 256-colour, too big for the bottom screen's
  32 KB beside the app bar): each tile takes one of a few 15-colour palettes, and tiles that are the same, flipped or
  not, are kept once. map.pal holds those palettes from 0, the place name's colours in 12 (the phone's list colours)
  and the app bar's in 14-15. The tilemap is the 48 by 20 entries, a row after another.
- marker.png / marker.pal: the Pokégear's sprites, each four tiles of a 16 by 16 sprite: the map app's player markers
  (pgmap_gra 1's tiles 8-15: Ethan's head, then Lyra's) and the radio's tuning cursor (pgradio_gra 1's first); their
  palettes (pgmap_gra 0's first, then pgradio_gra 0's first).
- radio.png / radio.NSCR / radio.pal: the radio app's screen (its pgradio_gra 16 and 22: the band for the show's
  title, the globe the cursor tunes in, the four channel buttons and, below, the buttons' lit state) and its palettes
  (pgradio_gra 10's 0-13), with the text's colours in 12 (the phone's list colours) and the app bar's in 14-15.

From the repo root:
    python3 tools/complete/import_hgss_pokegear_gfx.py
"""
import os
import shutil
import struct

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
HG = os.path.join(ROOT, '.cache', 'pokeheartgold', 'files', 'application', 'pokegear')
OUT = os.path.join(ROOT, 'decomp', 'res', 'graphics', 'complete_pokegear')


def palettes(path):
    """The palettes of a compressed NCLR: {index: [16 BGR555 colours]}"""
    b = open(path, 'rb').read()
    i = b.find(b'TTLP')
    size, off = struct.unpack('<II', b[i + 16:i + 24])
    data = b[i + 8 + off:i + 8 + off + size]
    colours = struct.unpack(f'<{len(data) // 2}H', data)
    j = b.find(b'PMCP')
    count, = struct.unpack('<H', b[j + 8:j + 10])
    index_off, = struct.unpack('<I', b[j + 12:j + 16])
    indices = struct.unpack(f'<{count}H', b[j + 8 + index_off:j + 8 + index_off + 2 * count])
    return {n: colours[k * 16:k * 16 + 16] for k, n in enumerate(indices)}


def nclr_colours(path):
    """The colours of an NCLR's palette data, in order"""
    b = open(path, 'rb').read()
    i = b.find(b'TTLP')
    size, off = struct.unpack('<II', b[i + 16:i + 24])
    data = b[i + 8 + off:i + 8 + off + size]
    return struct.unpack(f'<{len(data) // 2}H', data)


def screen_entries(path):
    b = open(path, 'rb').read()
    i = b.find(b'NRCS')
    width, height = struct.unpack('<HH', b[i + 8:i + 12])
    size, = struct.unpack('<I', b[i + 16:i + 20])
    return width // 8, struct.unpack(f'<{size // 2}H', b[i + 20:i + 20 + size])


MAP_WIDTH, MAP_HEIGHT = 48, 20  # the map's tiles in its sheet
SKINS = 6  # HeartGold's Pokégear skins, each app's graphics in six variants in a row


def build_map():
    """HeartGold's map, 16-colour, the same for every skin: (tile pixels, the tilemap, palettes as sets of HeartGold's
    256-colour indices, which each skin's palette colours)"""
    from PIL import Image

    sheet = Image.open(os.path.join(HG, 'map', 'pgmap_gra', 'pgmap_gra_00000010.png'))
    px = sheet.load()
    per_row = sheet.width // 8
    width, entries = screen_entries(os.path.join(HG, 'map', 'pgmap_gra', 'pgmap_gra_00000011.NSCR'))

    def tile_indices(entry):
        t, hflip, vflip = entry & 0x3FF, entry >> 10 & 1, entry >> 11 & 1
        sx, sy = t % per_row * 8, t // per_row * 8
        return [[px[sx + (7 - x if hflip else x), sy + (7 - y if vflip else y)] for x in range(8)] for y in range(8)]

    tiles = [tile_indices(entries[y * width + x]) for y in range(MAP_HEIGHT) for x in range(MAP_WIDTH)]
    # palettes of 15 colours (0 is the backdrop's), each tile in the one its colours fit best
    palettes = []
    owner = [0] * len(tiles)
    order = sorted(range(len(tiles)), key=lambda k: -len({c for row in tiles[k] for c in row}))
    for k in order:
        need = {c for row in tiles[k] for c in row}
        best = None
        for n, palette in enumerate(palettes):
            grown = len(need - palette)
            if len(palette) + grown <= 15 and (best is None or grown < best[1]):
                best = (n, grown)
        if best is None:
            palettes.append(set())
            best = (len(palettes) - 1, len(need))
        palettes[best[0]] |= need
        owner[k] = best[0]
    palettes = [sorted(p) for p in palettes]
    assert len(palettes) <= 12, len(palettes)

    pixels, tilemap, seen = [], [], {}
    for k, tile in enumerate(tiles):
        palette = palettes[owner[k]]
        indices = tuple(tuple(palette.index(c) + 1 for c in row) for row in tile)
        flips = {(0, 0): indices, (1, 0): tuple(row[::-1] for row in indices), (0, 1): indices[::-1],
                 (1, 1): tuple(row[::-1] for row in indices[::-1])}
        for (hflip, vflip), shape in flips.items():
            if shape in seen:
                tilemap.append(seen[shape] | hflip << 10 | vflip << 11 | owner[k] << 12)
                break
        else:
            seen[indices] = len(pixels)
            tilemap.append(len(pixels) | owner[k] << 12)
            pixels.append(indices)
    return pixels, tilemap, palettes


def repack(png, screens):
    """A skin's tiles, those its screens use, each once (flipped or not): (tile pixels, each screen's NSCR file with
    its entries renumbered). HeartGold's sheets have room to spare (one of 1,024 tiles); these fit the 128 the
    bottom screen's Pokégear has for a page."""
    from PIL import Image

    sheet = Image.open(png)
    px = sheet.load()
    per_row = sheet.width // 8
    blank = tuple(tuple(0 for _ in range(8)) for _ in range(8))
    pixels, seen, out = [blank], {blank: 0}, []  # tile 0 blank, as the Pokégear's pages clear with it
    for path in screens:
        b = bytearray(open(path, 'rb').read())
        i = b.find(b'NRCS')
        size, = struct.unpack('<I', b[i + 16:i + 20])
        entries = list(struct.unpack(f'<{size // 2}H', b[i + 20:i + 20 + size]))
        for k, e in enumerate(entries):
            t, flip, pal = e & 0x3FF, e >> 10 & 3, e & 0xF000
            sx, sy = t % per_row * 8, t // per_row * 8
            if sy >= sheet.height:
                tile = tuple(tuple(0 for _ in range(8)) for _ in range(8))
            else:
                tile = tuple(tuple(px[sx + x, sy + y] for x in range(8)) for y in range(8))
            if flip & 1:
                tile = tuple(row[::-1] for row in tile)
            if flip & 2:
                tile = tile[::-1]
            flips = {0: tile, 1: tuple(row[::-1] for row in tile), 2: tile[::-1], 3: tuple(row[::-1] for row in tile[::-1])}
            for f, shape in flips.items():
                if shape in seen:
                    entries[k] = seen[shape] | f << 10 | pal
                    break
            else:
                seen[tile] = len(pixels)
                entries[k] = len(pixels) | pal
                pixels.append(tile)
        b[i + 20:i + 20 + size] = struct.pack(f'<{len(entries)}H', *entries)
        out.append(bytes(b))
    assert len(pixels) <= 128, (png, len(pixels))
    return pixels, out


def save_tiles(path, pixels):
    """Tiles in a sheet 32 tiles wide, their 4-bit indices as an indexed PNG's"""
    from PIL import Image

    rows = (len(pixels) + 31) // 32
    image = Image.new('P', (256, rows * 8))
    image.putpalette([v for n in range(16) for v in (n * 16, n * 16, n * 16)])
    out = image.load()
    for t, tile in enumerate(pixels):
        for y in range(8):
            for x in range(8):
                out[t % 32 * 8 + x, t // 32 * 8 + y] = tile[y][x]
    image.save(path)


def save_pal(path, rows):
    lines = ['JASC-PAL', '0100', str(len(rows) * 16)] + [' '.join(map(str, rgb(c))) for row in rows for c in row]
    open(path, 'w', newline='\r\n').write('\n'.join(lines) + '\n')  # JASC: CRLF


def rgb(c):
    return (c & 31) * 255 // 31, (c >> 5 & 31) * 255 // 31, (c >> 10 & 31) * 255 // 31


def main():
    os.makedirs(OUT, exist_ok=True)
    for old in ('app_bar.png', 'app_bar.NSCR', 'phone.png', 'phone.NSCR', 'pokegear.pal', 'map.pal', 'radio.png',
                'radio.NSCR', 'radio.pal'):  # the files of the first skin alone, before the others came
        if os.path.exists(os.path.join(OUT, old)):
            os.remove(os.path.join(OUT, old))
    pixels, tilemap, map_palettes = build_map()
    save_tiles(os.path.join(OUT, 'map.png'), pixels)
    open(os.path.join(OUT, 'map_tilemap.bin'), 'wb').write(struct.pack(f'<{len(tilemap)}H', *tilemap))

    def screens(name, png, nscrs):
        tiles, files = repack(os.path.join(HG, png), [os.path.join(HG, n) for n in nscrs])
        save_tiles(os.path.join(OUT, f'{name}.png'), tiles)
        return files

    for skin in range(SKINS):
        def gra(app, folder, n, ext):
            return f'{folder}/{app}_{n + skin:08d}.{ext}'

        bar, = screens(f'app_bar_{skin}', gra('pgear_gra', 'pgear_gra', 48, 'png'), [gra('pgear_gra', 'pgear_gra', 54, 'NSCR')])
        open(os.path.join(OUT, f'app_bar_{skin}.NSCR'), 'wb').write(bar)
        phone_screen, = screens(f'phone_{skin}', gra('pgphone_gra', 'phone/pgphone_gra', 28, 'png'),
                                [gra('pgphone_gra', 'phone/pgphone_gra', 34, 'NSCR')])
        open(os.path.join(OUT, f'phone_{skin}.NSCR'), 'wb').write(phone_screen)
        radio_screen, = screens(f'radio_{skin}', gra('pgradio_gra', 'radio/pgradio_gra', 16, 'png'),
                                [gra('pgradio_gra', 'radio/pgradio_gra', 22, 'NSCR')])
        open(os.path.join(OUT, f'radio_{skin}.NSCR'), 'wb').write(radio_screen)
        config_screen, config_frame = screens(f'config_{skin}', gra('pgconf_gra', 'configure/pgconf_gra', 10, 'png'),
                                              [gra('pgconf_gra', 'configure/pgconf_gra', 16, 'NSCR'),
                                               gra('pgconf_gra', 'configure/pgconf_gra', 22, 'NSCR')])
        open(os.path.join(OUT, f'config_{skin}.NSCR'), 'wb').write(config_screen)
        open(os.path.join(OUT, f'config_frame_{skin}.NSCR'), 'wb').write(config_frame)

        phone = palettes(os.path.join(HG, gra('pgphone_gra', 'phone/pgphone_gra', 10, 'NCLR')))
        gear = palettes(os.path.join(HG, gra('pgear_gra', 'pgear_gra', 30, 'NCLR')))
        save_pal(os.path.join(OUT, f'pokegear_{skin}.pal'), [phone[n] if n < 14 else gear[n] for n in range(16)])
        colours = nclr_colours(os.path.join(HG, gra('pgmap_gra', 'map/pgmap_gra', 20, 'NCLR')))
        map_rows = [[0] + [colours[c] for c in p] + [0] * (15 - len(p)) for p in map_palettes]
        map_rows += [[0] * 16] * (12 - len(map_rows)) + [phone[2], [0] * 16, gear[14], gear[15]]
        save_pal(os.path.join(OUT, f'map_{skin}.pal'), map_rows)
        radio = palettes(os.path.join(HG, gra('pgradio_gra', 'radio/pgradio_gra', 10, 'NCLR')))
        save_pal(os.path.join(OUT, f'radio_{skin}.pal'),
                 [radio[n] for n in range(12)] + [phone[2], radio[13], gear[14], gear[15]])
        config = palettes(os.path.join(HG, gra('pgconf_gra', 'configure/pgconf_gra', 4, 'NCLR')))
        save_pal(os.path.join(OUT, f'config_{skin}.pal'),
                 [config.get(n, [0] * 16) for n in range(14)] + [gear[14], gear[15]])

    # the player markers and the radio's cursor, the same for every skin
    from PIL import Image

    sheet = Image.open(os.path.join(HG, 'map', 'pgmap_gra', 'pgmap_gra_00000001.png'))
    cursor = Image.open(os.path.join(HG, 'radio', 'pgradio_gra', 'pgradio_gra_00000001.png'))
    sprites = Image.new('P', (8, 12 * 8))
    sprites.putpalette(sheet.getpalette())
    sprites.paste(sheet.crop((0, 8 * 8, 8, 16 * 8)), (0, 0))
    for t, (x, y) in enumerate(((0, 0), (8, 0), (0, 8), (8, 8))):  # the 16 by 16 cursor's tiles, in a sprite's order
        sprites.paste(cursor.crop((x, y, x + 8, y + 8)), (0, (8 + t) * 8))
    sprites.save(os.path.join(OUT, 'marker.png'))
    save_pal(os.path.join(OUT, 'marker.pal'), [
        nclr_colours(os.path.join(HG, 'map', 'pgmap_gra', 'pgmap_gra_00000000.NCLR'))[:16],
        nclr_colours(os.path.join(HG, 'radio', 'pgradio_gra', 'pgradio_gra_00000000.NCLR'))[:16]])
    print(f'{OUT}: {SKINS} skins of the app bar, phone, radio and settings; map {len(pixels)} tiles in '
          f'{len(map_palettes)} palettes')


if __name__ == '__main__':
    main()
