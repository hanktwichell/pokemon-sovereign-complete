#!/usr/bin/env python3
"""Bring in the models of HeartGold's 3D gimmick objects: the map objects its sprite table points at BABYBOY1's art
and draws as models from its field effects archive (a/1/0/3; its FieldEffect_InitRenderObject, overlay 1's
ov01_02208E30, gives each sprite its member). They are its doors (the lighthouse light room's, Goldenrod Tunnel's,
the Radio Tower's and the Rocket Hideout's locked ones, the Elite Four rooms'), Goldenrod Tunnel's shutters, the
warehouse's boxes, the Rocket Hideout's present-shaped trap switches and the Ruins of Alph chambers' walls and holes.

Each becomes OBJ_EVENT_GFX_HGSS_<NAME> = 1024 + its HeartGold number (as HeartGold's people do,
tools/complete/gen_hgss_people_sprites.py), drawn as Platinum's 3D objects are (its book, its Elite Four door, the
wall before Rotom's room: src/overlay005/object_event_gfx_data.c's three tables, between "HeartGold's gimmicks"
markers), with its model from decomp/res/prebuilt/fielddata/complete_gimmicks/gimmicks.narc
(NARC_INDEX_FIELDDATA__COMPLETE__GIMMICKS) in GIMMICKS' order, loaded the first time a map draws one
(CompleteGimmick_ModelMember, src/overlay005/ov5_021F10E8.c). The events importer (import_hgss_events.py) maps the
sprites to these IDs (data/complete/hgss_gimmicks.json).

Usage: python3 tools/complete/import_hgss_gimmicks.py
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402

ROOT = os.path.join(DECOMP, '..')
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'fielddata', 'complete_gimmicks', 'gimmicks.narc')
MAPPING = os.path.join(ROOT, 'data', 'complete', 'hgss_gimmicks.json')
HGSS_BASE = 1024  # as gen_hgss_people_sprites.py's
# HeartGold's sprite, its field effect member (ov01_02208E30) and the model's name there. Its book (BABYBOY1_2,
# member 0x54) is Platinum's book.
GIMMICKS = [
    ('BABYBOY1_8', 0x6B, 'door3'),   # the lighthouse light room's door, Goldenrod Tunnel B1F's
    ('BABYBOY1_9', 0x6C, 'door4'),   # the locked doors: the Radio Tower's, the warehouse's, the Rocket Hideout's
    ('BABYBOY1_5', 0x6D, 'box'),     # the warehouse's boxes
    ('GATE_RIGHT', 0x6E, 'rshutter'),  # Goldenrod Tunnel's shutters, by the way each opens
    ('GATE_LEFT', 0x6F, 'lshutter'),
    ('GATE_TOP', 0x70, 'ushutter'),
    ('GATE_BOTTOM', 0x71, 'dshutter'),
    ('BABYBOY1_10', 0x72, 'm_present01_00_0'),  # the Rocket Hideout B1F's
    ('BABYBOY1_11', 0x75, 'leag_door1'),  # the Elite Four rooms' doors
    ('BABYBOY1_12', 0x74, 'alfu_door'),  # the Ruins of Alph chambers' walls that open
    ('BABYBOY1_13', 0x73, 'alfu_hole'),  # and the holes behind them
]
GFX_DATA = os.path.join(DECOMP, 'src', 'overlay005', 'object_event_gfx_data.c')
GFX_LIST = os.path.join(DECOMP, 'generated', 'object_events_gfx.txt')
MARK = "Sovereign Complete: HeartGold's gimmicks (tools/complete/import_hgss_gimmicks.py)"


def model_name(b):
    """The first model's name in an NSBMD"""
    mdl0 = b.find(b'MDL0')
    _, num, _, _, ofs_entry = struct.unpack_from('<BBHHH', b, mdl0 + 8)
    entry = mdl0 + 8 + ofs_entry
    unit, _ = struct.unpack_from('<HH', b, entry)
    names = entry + 4 + num * unit
    return b[names:names + 16].rstrip(b'\0').decode()


def hgss_sprites():
    path = os.path.join(HG, 'include', 'constants', 'sprites.h')
    return {m.group(1): int(m.group(2)) for m in re.finditer(r'#define SPRITE_(\w+)\s+(\d+)', open(path).read())}


def replace_block(text, tag, lines, comment, indent=''):
    """Put lines between the MARK [tag] markers, made before the end line (the first after them) the first time"""
    start, end = f'{indent}{comment} {MARK} [{tag}]', f'{indent}{comment} {MARK.split(" (")[0]}: end [{tag}]'
    block = '\n'.join([start] + lines + [end])
    if start in text:
        return re.sub(re.escape(start) + r'.*?' + re.escape(end), lambda _: block, text, count=1, flags=re.S)
    return None


def insert_before(text, anchor, tag, lines, comment, indent):
    replaced = replace_block(text, tag, lines, comment, indent)
    if replaced is not None:
        return replaced
    at = text.index(anchor)
    start, end = f'{indent}{comment} {MARK} [{tag}]', f'{indent}{comment} {MARK.split(" (")[0]}: end [{tag}]'
    return text[:at] + '\n'.join([start] + lines + [end]) + '\n' + text[at:]


def main():
    effects = read_narc(os.path.join(HG, 'files', 'a', '1', '0', '3'))
    numbers = hgss_sprites()
    members, mapping = [], {}
    for sprite, member, name in GIMMICKS:
        assert model_name(effects[member]) == name, (sprite, model_name(effects[member]))
        members.append(effects[member])
        mapping[sprite] = f'HGSS_{sprite}'
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    write_narc(OUT, members)
    with open(MAPPING, 'w') as f:
        json.dump(mapping, f, indent=1)
        f.write('\n')

    ids = [(f'OBJ_EVENT_GFX_HGSS_{s}', HGSS_BASE + numbers[s]) for s, _, _ in GIMMICKS]
    text = open(GFX_LIST).read()
    taken = {int(v) for v in re.findall(r'^\w+ = (\d+)$', text, re.M)}
    ours = re.search(re.escape(f'# {MARK} [list]') + r'.*?' + re.escape(f'# {MARK.split(" (")[0]}: end [list]'),
                     text, re.S)
    taken -= {int(v) for v in re.findall(r' = (\d+)$', ours.group(0), re.M)} if ours else set()
    assert not taken & {v for _, v in ids}, 'a gimmick graphics ID is taken'
    text = insert_before(text, '# Sovereign Complete: HeartGold\'s people (', 'list',
                         [f'{n} = {v}' for n, v in ids], '#', '')
    open(GFX_LIST, 'w').write(text)

    c = open(GFX_DATA).read()
    c = insert_before(c, "    { OBJ_EVENT_GFX_WALL_BLOCKING_ROTOMS_ROOM, &Unk_ov5_021FB000 },", 'renderers',
                      [f'    {{ {n}, &Unk_ov5_021FB000 }},' for n, _ in ids], '//', '    ')
    c = insert_before(c, '    { OBJ_EVENT_GFX_WALL_BLOCKING_ROTOMS_ROOM, MODEL_TYPE_3D,', 'model types',
                      [f'    {{ {n}, MODEL_TYPE_3D, .hasShadow = FALSE, TRACK_TYPE_NONE, .hasReflection = FALSE }},'
                       for n, _ in ids], '//', '    ')
    c = insert_before(c, '    {\n        OBJ_EVENT_GFX_WALL_BLOCKING_ROTOMS_ROOM,\n        VEC_FX32(0, 0, 0),', 'positions',
                      [f'    {{\n        {n},\n        VEC_FX32(0, 0, 0),\n    }},' for n, _ in ids], '//', '    ')
    open(GFX_DATA, 'w').write(c)

    header = os.path.join(DECOMP, 'include', 'data', 'hgss_gimmicks.h')
    lines = ['#ifndef POKEPLATINUM_DATA_HGSS_GIMMICKS_H', '#define POKEPLATINUM_DATA_HGSS_GIMMICKS_H', '',
             '// Sovereign Complete: HeartGold\'s 3D gimmick objects, each graphics ID with its model\'s member in',
             '// fielddata/complete/gimmicks.narc (tools/complete/import_hgss_gimmicks.py; src/overlay005/ov5_021F10E8.c)', '',
             'static const u16 sCompleteGimmickGfx[] = {']
    lines += [f'    {n}, // {name}' for (n, _), (_, _, name) in zip(ids, GIMMICKS)]
    lines += ['};', '', '#endif // POKEPLATINUM_DATA_HGSS_GIMMICKS_H', '']
    open(header, 'w').write('\n'.join(lines))
    print(f'{len(members)} models, {sum(map(len, members))} bytes: {os.path.relpath(OUT, ROOT)}')


if __name__ == '__main__':
    main()
