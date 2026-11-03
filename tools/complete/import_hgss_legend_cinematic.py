#!/usr/bin/env python3
"""Bring in HeartGold's legendary cinematics' models (the archives its overlay 106 loads, for its script command
Cinematic) for src/applications/complete_legend_cinematic/legend_cinematic.c:

- Ho-Oh's (HeartGold's NARC 245, files/a/2/4/3): two cuts of Ho-Oh flying in over the Bell Tower, each by time of day
  (the morning and the day, the evening, the night): the first cut's model and its four animations, the second's
  model and its three, for each of the three (27 files).
- Lugia's (HeartGold's NARC 246, files/a/2/4/4): Lugia rising from the Whirl Islands' water, its model and four
  animations, and the waterfall's model and its animation (7 files).
- Arceus's (HeartGold's NARC 247, files/a/2/4/5): its 2D cinematic at the Sinjoh Ruins, 68 backgrounds (their
  tilemaps, members 0 to 67, their 256-color tiles, 68 on, and their palettes, 136 on) and the sprite Arceus's walking
  sprite is drawn into (204 to 207: its tiles, cells, animations and palette). After them (ARCEUS_SPRITES_FIRST on),
  HeartGold's walking sprites for each of Arceus's 18 forms (its data/mmodel files, eight frames each with a normal and
  a shiny palette), which the cinematic draws as HeartGold does: the lead's form if the lead is Arceus.

HeartGold keeps the models LZ-compressed; Ho-Oh's and Lugia's are packed here decompressed (Platinum's Easy3D loads
members as they are), in HeartGold's order, Ho-Oh's first, into
decomp/res/prebuilt/demo/complete_legend_cinematic/legend_cinematic.narc (NARC_INDEX_DEMO__COMPLETE__LEGEND_CINEMATIC):
Ho-Oh's member n is n there, Lugia's LUGIA_FIRST + n. Arceus's go as they are (Platinum's 2D loaders decompress them,
as HeartGold's do) into arceus_cinematic.narc beside it (NARC_INDEX_DEMO__COMPLETE__ARCEUS_CINEMATIC), member for
member. Arceus's cinematic is a script HeartGold's overlay runs (ov106_021E70E0, its steps' sizes ov106_021E7090): it
goes to decomp/include/data/hgss_arceus_cinematic.h, read from HeartGold's assembly.

Usage: python3 tools/complete/import_hgss_legend_cinematic.py
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from gen_follower_sprites import hgss_range  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402

SOURCES = [('Ho-Oh', os.path.join(HG, 'files', 'a', '2', '4', '3'), 27),
           ('Lugia', os.path.join(HG, 'files', 'a', '2', '4', '4'), 7)]
ARCEUS = os.path.join(HG, 'files', 'a', '2', '4', '5')
ARCEUS_MEMBERS = 208
ARCEUS_FORMS = 18
OVERLAY = os.path.join(HG, 'asm', 'overlay_106.s')
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'demo', 'complete_legend_cinematic')
SCRIPT_HEADER = os.path.join(DECOMP, 'include', 'data', 'hgss_arceus_cinematic.h')
# Arceus's script's steps (HeartGold's ov106_021E7044, its handlers, in order), as
# src/applications/complete_legend_cinematic names them
STEPS = ['WAIT', 'FADE_IN_BLACK', 'FADE_OUT_BLACK', 'FADE_IN_WHITE', 'FADE_OUT_WHITE', 'WAIT_FADE', 'LOAD_BG',
         'TOGGLE_BG', 'BG_PRIORITY', 'BLEND_PLANES', 'BLEND_TO', 'BLEND_OFF', 'SAVE_BGM', 'STOP_BGM', 'PLAY_BGM',
         'SPRITE_DRAW', 'SPRITE_POS', 'SPRITE_PRIORITY', 'MARK', 'END']


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


def overlay_words(label):
    """The 32-bit words of a data label in HeartGold's overlay 106 (its .byte lines up to the next label)."""
    text = open(OVERLAY).read()
    lines = text[text.index(f'\n{label}:'):].split('\n')[2:]
    data = bytearray()
    for line in lines:
        line = line.strip()
        if not line.startswith('.byte'):
            break
        data += bytes(int(b, 16) for b in re.findall(r'0x([0-9A-Fa-f]+)', line))
    return [int.from_bytes(data[i:i + 4], 'little', signed=True) for i in range(0, len(data), 4)]


def write_script():
    """Arceus's script as C, a step a line, ending with its END."""
    sizes = overlay_words('ov106_021E7090')
    words = overlay_words('ov106_021E70E0')
    songs = {int(n): name for name, n in re.findall(r'#define (SEQ_\w+)\s+(\d+)',
                                                     open(os.path.join(HG, 'include', 'constants', 'sndseq.h')).read())}
    assert len(sizes) == len(STEPS), sizes
    lines, i = [], 0
    while True:
        step = words[i]
        args = [str(a) for a in words[i + 1:i + sizes[step]]]
        if STEPS[step] == 'PLAY_BGM' and words[i + 1] >= 0:  # HeartGold's song, by Complete's name for it
            args = [f'{songs[words[i + 1]]}_sseq']
        lines.append('    ' + ', '.join([f'ARCEUS_STEP_{STEPS[step]}'] + args) + ',')
        i += sizes[step]
        if STEPS[step] == 'END':
            break
    assert i == len(words), (i, len(words))
    head = ["// Sovereign Complete: HeartGold's Arceus cinematic's script (its overlay 106's ov106_021E70E0), each",
            "// step and its arguments, with each step's size in words (ov106_021E7090);",
            "// tools/complete/import_hgss_legend_cinematic.py writes it from HeartGold's assembly. The steps are",
            "// enum ArceusStep's (src/applications/complete_legend_cinematic/legend_cinematic.c).",
            '',
            '#ifndef POKEPLATINUM_DATA_HGSS_ARCEUS_CINEMATIC_H',
            '#define POKEPLATINUM_DATA_HGSS_ARCEUS_CINEMATIC_H',
            '',
            'static const u8 sArceusStepSizes[] = { ' + ', '.join(map(str, sizes)) + ' };',
            '',
            'static const s32 sArceusScript[] = {']
    with open(SCRIPT_HEADER, 'w', encoding='utf-8') as f:
        f.write('\n'.join(head + lines + ['};', '', '#endif', '']))
    return len(lines)


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
    arceus = read_narc(ARCEUS)
    if len(arceus) != ARCEUS_MEMBERS:
        sys.exit(f'{ARCEUS}: {len(arceus)} members, not {ARCEUS_MEMBERS}')
    sprites = [path for name, path in hgss_range() if name.startswith('ARCEUS')]
    if len(sprites) != ARCEUS_FORMS:
        sys.exit(f'{len(sprites)} walking sprites for Arceus, not {ARCEUS_FORMS}')
    arceus += [open(path, 'rb').read() for path in sprites]
    write_narc(os.path.join(OUT, 'arceus_cinematic.narc'), arceus)
    with open(os.path.join(OUT, 'meson.build'), 'w', encoding='utf-8') as f:
        f.write('# Sovereign Complete: HeartGold\'s legendary cinematics\' graphics '
                '(tools/complete/import_hgss_legend_cinematic.py,\n'
                '# src/applications/complete_legend_cinematic/legend_cinematic.c)\n'
                "nitrofs_files += fs.copyfile('legend_cinematic.narc')\n"
                "nitrofs_files += fs.copyfile('arceus_cinematic.narc')\n")
    steps = write_script()
    size = sum(len(m) for m in members)
    print(f'legend_cinematic.narc: {len(members)} files ({size // 1024} KB); '
          + ', '.join(f'{name} from {first}' for name, first in firsts.items())
          + f'; arceus_cinematic.narc: {len(arceus)} files ({sum(len(m) for m in arceus) // 1024} KB); '
          + f'Arceus\'s script: {steps} steps')


if __name__ == '__main__':
    main()
