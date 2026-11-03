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


def rgb(c):
    return (c & 31) * 255 // 31, (c >> 5 & 31) * 255 // 31, (c >> 10 & 31) * 255 // 31


def main():
    os.makedirs(OUT, exist_ok=True)
    for src, dst in (('pgear_gra/pgear_gra_00000048.png', 'app_bar.png'),
                     ('pgear_gra/pgear_gra_00000054.NSCR', 'app_bar.NSCR'),
                     ('phone/pgphone_gra/pgphone_gra_00000028.png', 'phone.png'),
                     ('phone/pgphone_gra/pgphone_gra_00000034.NSCR', 'phone.NSCR')):
        shutil.copyfile(os.path.join(HG, src), os.path.join(OUT, dst))

    phone = palettes(os.path.join(HG, 'phone', 'pgphone_gra', 'pgphone_gra_00000010.NCLR'))
    gear = palettes(os.path.join(HG, 'pgear_gra', 'pgear_gra_00000030.NCLR'))
    rows = [phone[n] if n < 14 else gear[n] for n in range(16)]
    lines = ['JASC-PAL', '0100', '256'] + [' '.join(map(str, rgb(c))) for row in rows for c in row]
    open(os.path.join(OUT, 'pokegear.pal'), 'w', newline='\r\n').write('\n'.join(lines) + '\n')  # JASC: CRLF
    print(f'{OUT}: app bar, phone frame, 16 palettes')


if __name__ == '__main__':
    main()
