#!/usr/bin/env python3
"""Bring in HeartGold's legendary cinematics' models (the archives its overlay 106 loads, for its script command
Cinematic) for src/applications/complete_legend_cinematic/legend_cinematic.c:

- Ho-Oh's (HeartGold's NARC 245, files/a/2/4/3): two cuts of Ho-Oh flying in over the Bell Tower, each by time of day
  (the morning and the day, the evening, the night): the first cut's model and its four animations, the second's
  model and its three, for each of the three (27 files).
- Lugia's (HeartGold's NARC 246, files/a/2/4/4): Lugia rising from the Whirl Islands' water, its model and four
  animations, and the waterfall's model and its animation (7 files).

HeartGold keeps them LZ-compressed; they are packed here decompressed (Platinum's Easy3D loads members as they are), in
HeartGold's order, Ho-Oh's first, into decomp/res/prebuilt/demo/complete_legend_cinematic/legend_cinematic.narc
(NARC_INDEX_DEMO__COMPLETE__LEGEND_CINEMATIC): Ho-Oh's member n is n there, Lugia's LUGIA_FIRST + n.

Usage: python3 tools/complete/import_hgss_legend_cinematic.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402

SOURCES = [('Ho-Oh', os.path.join(HG, 'files', 'a', '2', '4', '3'), 27),
           ('Lugia', os.path.join(HG, 'files', 'a', '2', '4', '4'), 7)]
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'demo', 'complete_legend_cinematic')


def lz11_decompress(data):
    """The Nintendo DS's LZ77 variant with type byte 0x11 (the BIOS's and HeartGold's): a 24-bit size (or a 32-bit
    one after a zero), then groups of eight blocks, each flag bit set for a back-reference of 2, 3 or 4 bytes."""
    assert data[0] == 0x11, f'not LZ11 (type 0x{data[0]:02X})'
    size = int.from_bytes(data[1:4], 'little')
    pos = 4
    if size == 0:
        size = int.from_bytes(data[4:8], 'little')
        pos = 8
    out = bytearray()
    while len(out) < size:
        flags = data[pos]
        pos += 1
        for bit in range(8):
            if len(out) >= size:
                break
            if not flags & (0x80 >> bit):
                out.append(data[pos])
                pos += 1
                continue
            b0 = data[pos]
            kind = b0 >> 4
            if kind == 0:
                length = ((b0 & 0xF) << 4 | data[pos + 1] >> 4) + 0x11
                disp = ((data[pos + 1] & 0xF) << 8 | data[pos + 2]) + 1
                pos += 3
            elif kind == 1:
                length = ((b0 & 0xF) << 12 | data[pos + 1] << 4 | data[pos + 2] >> 4) + 0x111
                disp = ((data[pos + 2] & 0xF) << 8 | data[pos + 3]) + 1
                pos += 4
            else:
                length = kind + 1
                disp = ((b0 & 0xF) << 8 | data[pos + 1]) + 1
                pos += 2
            for _ in range(length):
                out.append(out[-disp])
    return bytes(out)


def main():
    members, firsts = [], {}
    for name, path, count in SOURCES:
        found = read_narc(path)
        if len(found) != count:
            sys.exit(f'{path}: {len(found)} members, not {count}')
        firsts[name] = len(members)
        for i, member in enumerate(found):
            data = lz11_decompress(member)
            if data[:4] not in (b'BMD0', b'BCA0', b'BTA0', b'BTP0', b'BMA0', b'BVA0'):
                sys.exit(f'{path} member {i}: not a model or an animation after decompressing ({data[:4]})')
            members.append(data)
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'legend_cinematic.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w', encoding='utf-8') as f:
        f.write('# Sovereign Complete: HeartGold\'s legendary cinematics\' models '
                '(tools/complete/import_hgss_legend_cinematic.py,\n'
                '# src/applications/complete_legend_cinematic/legend_cinematic.c)\n'
                "nitrofs_files += fs.copyfile('legend_cinematic.narc')\n")
    size = sum(len(m) for m in members)
    print(f'legend_cinematic.narc: {len(members)} files ({size // 1024} KB); '
          + ', '.join(f'{name} from {first}' for name, first in firsts.items()))


if __name__ == '__main__':
    main()
