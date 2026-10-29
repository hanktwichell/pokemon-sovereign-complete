#!/usr/bin/env python3
"""Bring HeartGold's map assets into the engine: land data, map textures, building models and textures, building
lists, area data and the building material/shape table.

Everything comes from the HeartGold source built by tools/complete/build_heartgold.sh (.cache/pokeheartgold) and is
appended after Platinum's own, at fixed offsets, so renumbering is arithmetic (docs/MapConversion.md):

| HeartGold                                   | Engine                                        |
|---------------------------------------------|-----------------------------------------------|
| land data block k (a/0/6/5)                 | map_data_{666 + k}.bin                        |
| map texture set i (a/0/4/4)                 | map_texture_set_{074 + i}.nsbtx               |
| outdoor building model k (a/0/4/0)          | prop_model_{590 + k}.nsbmd                    |
| indoor building model k (a/1/4/8)           | prop_model_{930 + k}.nsbmd                    |
| building list i (a/0/4/3)                   | prop_model_set_{071 + i}.json                 |
| building texture set i (a/0/7/0)            | prop_texture_set_{071 + i}.nsbtx              |
| area i (a/0/4/2)                            | area_data_{075 + i}.json                      |

- A land data block loses HeartGold's background sound section (marker 0x1234 and its size); tile behaviours are
  translated where the games differ (TRANSLATE below); each prop's model number gets the outdoor or indoor offset of
  the areas that use the block. Every behaviour actually used in HeartGold's blocks is checked: it must mean the same
  in both games, be unused in Platinum, or be translated.
- A building list's models get the offset of the areas that use it (outdoor or indoor).
- HeartGold's ten placeholder building texture sets (4 bytes) become Platinum's smallest real set, since Platinum
  always loads one; textures bind to models by name, so nothing binds wrongly.
- The material/shape table (res/prebuilt/fielddata/build_model/build_model_matshp.dat) gets HeartGold's outdoor then
  indoor entries appended after Platinum's 590.
- Order files and meson.build lists get the new files between "Sovereign Complete: HeartGold maps" markers; a rerun
  replaces them, so the script is safe to run again.

Map headers, matrices, events and scripts come in a later step (they need the new map header IDs).

Usage: python3 tools/complete/import_hgss_maps.py
"""
import json
import os
import re
import shutil
import struct
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from compare_tile_behaviors import HGSS as HGSS_BEHAVIORS, PLATINUM as PLATINUM_BEHAVIORS, key, parse_enum  # noqa
from narc import read_narc  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
HG = os.path.join(ROOT, '.cache', 'pokeheartgold')

LAND_DATA_BASE = 666
MAP_TEXTURE_BASE = 74
PROP_MODEL_OUTDOOR_BASE = 590
PROP_MODEL_INDOOR_BASE = 590 + 340
PROP_SET_BASE = 71
AREA_BASE = 75
PLATINUM_MATSHP = (590, 1009)  # locators, material/shape pairs in Sovereign's table

# HeartGold behaviour -> Platinum behaviour, where the same number means different things.
# The HeartGold-only ones get numbers Platinum's maps never use (decomp/include/constants/field/
# complete_tile_behaviors.h).
TRANSLATE = {
    0x2D: 0x2C,  # reflective water (Platinum's reflective is 0x2C; its 0x2D forbids the Explorer Kit)
    0x2C: 0x2B,  # magma: Platinum's 0x2C is reflective; 0x2B is unused
    0x3C: 0x0D,  # ladder north: Platinum's maps use 0x3C-0x3E for something of their own
    0x3D: 0x0E,  # ladder south
    0x3E: 0x0F,  # ladder down
}

# Same behaviour, same number, different names in the two decomps.
SAME_MEANING = {
    0x40, 0x41, 0x42, 0x43,  # slides east, west, north, south (Platinum: SLIDE_EASTWARD...)
    0x4B, 0x4C,  # Rock Climb north-south, east-west (Platinum: ROCK_CLIMB_N_S, _E_W)
    0xA8,  # snow (Platinum: SNOW_SHALLOW)
    0xE4,  # trash can (HeartGold: EMPTY_TRASH_CAN)
}

MARK = 'Sovereign Complete: HeartGold maps (tools/complete/import_hgss_maps.py)'
MARK_END = 'Sovereign Complete: end of HeartGold maps'


def hg_narc(path):
    return read_narc(os.path.join(HG, 'files', path))


def hg_map_headers():
    """[(map ID, areaDataBank, matrix file name)] from HeartGold's map header table."""
    ids = {}
    for line in open(os.path.join(HG, 'include/constants/maps.h')):
        m = re.match(r'#define (MAP_\w+)\s+(\d+)', line)
        if m:
            ids[m.group(1)] = int(m.group(2))
    text = open(os.path.join(HG, 'src/data/map_headers.h')).read()
    headers = []
    for m in re.finditer(r'\[(MAP_\w+)\]\s*=\s*\{(.*?)\n\s*\}', text, re.S):
        body = m.group(2)
        area = int(re.search(r'\.areaDataBank\s*=\s*(\d+)', body).group(1))
        matrix = re.search(r'\.matrixId\s*=\s*NARC_map_matrix_(\w+)_bin', body).group(1) + '.bin'
        headers.append((ids[m.group(1)], area, matrix))
    return headers


def hg_matrix(name):
    from hgss_matrix import read_matrix
    return read_matrix(os.path.join(HG, 'files/fielddata/mapmatrix/map_matrix', name))


def contexts(areas):
    """Which blocks and building lists are outdoor (True) or indoor (False), from the areas that use them."""
    block_ctx, list_ctx = defaultdict(set), defaultdict(set)
    for area in areas:
        list_ctx[area['list']].add(area['outdoor'])
    for map_id, area_index, matrix_name in hg_map_headers():
        outdoor = areas[area_index]['outdoor']
        m = hg_matrix(matrix_name)
        for i, block in enumerate(m['maps']):
            if block == 0xFFFF or (m['headers'] and m['headers'][i] != map_id):
                continue
            block_ctx[block].add(outdoor)
    return block_ctx, list_ctx


def convert_block(data, outdoor, used_behaviors):
    perm_size, prop_size, model_size, bdhc_size, marker, sound_size = struct.unpack_from('<4IHH', data, 0)
    assert marker == 0x1234, f'unexpected land data marker {marker:#x}'
    off = 0x14 + sound_size
    perms = bytearray(data[off:off + perm_size])
    off += perm_size
    props = bytearray(data[off:off + prop_size])
    off += prop_size
    rest = data[off:off + model_size + bdhc_size]
    for i in range(0, perm_size, 2):
        behavior = perms[i]
        used_behaviors.add(behavior)
        perms[i] = TRANSLATE.get(behavior, behavior)
    base = PROP_MODEL_OUTDOOR_BASE if outdoor else PROP_MODEL_INDOOR_BASE
    for i in range(0, prop_size, 48):
        model = struct.unpack_from('<I', props, i)[0]
        struct.pack_into('<I', props, i, model + base)
    return struct.pack('<4I', perm_size, prop_size, model_size, bdhc_size) + bytes(perms) + bytes(props) + rest


def check_behaviors(used):
    pt, hg = parse_enum(PLATINUM_BEHAVIORS), parse_enum(HGSS_BEHAVIORS)
    problems = []
    for b in sorted(used):
        if b in TRANSLATE or b in SAME_MEANING:
            continue
        hg_key, pt_key = key(hg.get(b, '')), key(pt.get(b, ''))
        if hg_key is None or pt_key is None or hg_key == pt_key:
            continue
        problems.append(f'0x{b:02X}: HeartGold {hg.get(b)}, Platinum {pt.get(b)}')
    return problems


def write(path, data):
    full = os.path.join(DECOMP, path)
    mode = 'wb' if isinstance(data, bytes) else 'w'
    with open(full, mode) as f:
        f.write(data)


def update_order(path, base_names, keep):
    """Keep the order file's first `keep` lines (Platinum's), then append base_names."""
    full = os.path.join(DECOMP, path)
    lines = open(full).read().splitlines()[:keep]
    open(full, 'w').write('\n'.join(lines + base_names) + '\n')


def update_meson(path, last_original, names):
    """Put names after the line holding last_original, between markers (replacing an earlier block)."""
    full = os.path.join(DECOMP, path)
    text = open(full).read()
    text = re.sub(rf'\n    # {re.escape(MARK)}\n.*?    # {re.escape(MARK_END)}', '', text, flags=re.S)
    line_start = text.index(last_original)
    line_end = text.index('\n', line_start)
    line = text[line_start:line_end].rstrip()
    if not line.endswith(','):
        line += ','
    block = f'\n    # {MARK}\n' + ''.join(f"    '{n}',\n" for n in names) + f'    # {MARK_END}'
    text = text[:line_start] + line + block + text[line_end:]
    open(full, 'w').write(text)


def main():
    raw_areas = hg_narc('a/0/4/2')
    areas = []
    for rec in raw_areas:
        building_list, texture_set, anim, outdoor, light = struct.unpack('<3HBB', rec)
        areas.append({'list': building_list, 'texture': texture_set, 'anim': anim, 'outdoor': bool(outdoor),
                      'light': light})
    block_ctx, list_ctx = contexts(areas)
    conflicts = [b for b, c in block_ctx.items() if len(c) > 1] + [f'list {i}' for i, c in list_ctx.items() if len(c) > 1]

    # Land data.
    land = hg_narc('a/0/6/5')
    used = set()
    names = []
    unused_blocks = 0
    for k, block in enumerate(land):
        ctx = block_ctx.get(k)
        outdoor = True if not ctx else next(iter(ctx))
        unused_blocks += not ctx
        name = f'map_data_{LAND_DATA_BASE + k:03d}.bin'
        write(f'res/field/maps/data/{name}', convert_block(block, outdoor, used))
        names.append(name)
    update_order('res/field/maps/data/map_data.order', names, LAND_DATA_BASE)
    update_meson('res/field/maps/data/meson.build', "'map_data_665.bin'", names)
    # Matrices name land data MAP_<number> (generated/maps.txt, the MapID enum).
    path = os.path.join(DECOMP, 'generated/maps.txt')
    text = re.sub(rf'# {re.escape(MARK)}\n.*?# {re.escape(MARK_END)}\n', '', open(path).read(), flags=re.S)
    block = f'# {MARK}\n' + ''.join(f'MAP_{LAND_DATA_BASE + k}\n' for k in range(len(land))) + f'# {MARK_END}\n'
    assert '\nMAP_NONE = 65535' in text
    text = text.replace('\nMAP_NONE = 65535', '\n' + block.rstrip('\n') + '\nMAP_NONE = 65535', 1)
    open(path, 'w').write(text)

    # Map texture sets.
    names = []
    for i, tex in enumerate(hg_narc('a/0/4/4')):
        name = f'map_texture_set_{MAP_TEXTURE_BASE + i:03d}'
        write(f'res/field/maps/texture_sets/{name}.nsbtx', tex)
        names.append(name)
    update_order('res/field/maps/texture_sets/map_texture_sets.order', names, MAP_TEXTURE_BASE)
    update_meson('res/field/maps/texture_sets/meson.build', "'map_texture_set_073.nsbtx'", [n + '.nsbtx' for n in names])

    # Building models: outdoor, then indoor.
    names = []
    for base, archive in ((PROP_MODEL_OUTDOOR_BASE, 'a/0/4/0'), (PROP_MODEL_INDOOR_BASE, 'a/1/4/8')):
        for k, model in enumerate(hg_narc(archive)):
            name = f'prop_model_{base + k:03d}.nsbmd'
            write(f'res/field/props/models/{name}', model)
            names.append(name)
    update_order('res/field/props/models/map_prop_models.order', names, PROP_MODEL_OUTDOOR_BASE)
    update_meson('res/field/props/models/meson.build', "'prop_model_589.nsbmd'", names)

    # Building lists and their texture sets.
    smallest = open(os.path.join(DECOMP, 'res/field/props/texture_sets/prop_texture_set_046.nsbtx'), 'rb').read()
    set_names, tex_names, placeholders = [], [], 0
    textures = hg_narc('a/0/7/0')
    for i, rec in enumerate(hg_narc('a/0/4/3')):
        count = struct.unpack_from('<H', rec)[0] if len(rec) >= 2 else 0
        models = struct.unpack_from(f'<{count}H', rec, 2) if count else ()
        outdoor = next(iter(list_ctx.get(i, {True})))
        base = PROP_MODEL_OUTDOOR_BASE if outdoor else PROP_MODEL_INDOOR_BASE
        name = f'prop_model_set_{PROP_SET_BASE + i:03d}'
        write(f'res/field/props/model_sets/{name}.json',
              json.dumps({'mapPropModels': [f'prop_model_{base + m:03d}_nsbmd' for m in models]}, indent=4) + '\n')
        set_names.append(name)
        tex = textures[i] if i < len(textures) else b''
        if tex[:4] != b'BTX0':
            tex, placeholders = smallest, placeholders + 1
        tex_name = f'prop_texture_set_{PROP_SET_BASE + i:03d}'
        write(f'res/field/props/texture_sets/{tex_name}.nsbtx', tex)
        tex_names.append(tex_name + '.nsbtx')
    update_order('res/field/props/model_sets/prop_model_sets.order', set_names, PROP_SET_BASE)
    update_meson('res/field/props/model_sets/meson.build', "'prop_model_set_070.json'", [n + '.json' for n in set_names])
    update_order('res/field/props/texture_sets/prop_texture_sets.order', tex_names, PROP_SET_BASE)
    update_meson('res/field/props/texture_sets/meson.build', "'prop_texture_set_070.nsbtx'", tex_names)

    # Area data.
    names = []
    for i, area in enumerate(areas):
        name = f'area_data_{AREA_BASE + i:03d}'
        write(f'res/field/area_data/{name}.json', json.dumps({
            'mapPropSet': f'prop_model_set_{PROP_SET_BASE + area["list"]:03d}',
            'mapTextureSet': f'map_texture_set_{MAP_TEXTURE_BASE + area["texture"]:03d}',
            'lightingSet': 'lighting_set_000' if area['outdoor'] else 'lighting_set_001',
            'dummy': 0,
        }, indent=4) + '\n')
        names.append(name)
    update_order('res/field/area_data/area_data.order', names, AREA_BASE)
    update_meson('res/field/area_data/meson.build', "'area_data_074.json'", [n + '.json' for n in names])

    # Material/shape table: Platinum's 590 entries, then HeartGold's outdoor (340) and indoor (222).
    path = os.path.join(DECOMP, 'res/prebuilt/fielddata/build_model/build_model_matshp.dat')
    data = open(path, 'rb').read()
    locs, ids = struct.unpack_from('<HH', data)
    pt_locs, pt_ids = PLATINUM_MATSHP
    locators = [struct.unpack_from('<HH', data, 4 + 4 * i) for i in range(pt_locs)]
    pairs = [struct.unpack_from('<HH', data, 4 + 4 * locs + 4 * i) for i in range(pt_ids)]
    for name in ('bm_field_matshp.dat', 'bm_room_matshp.dat'):
        hg = open(os.path.join(HG, 'files/fielddata/build_model', name), 'rb').read()
        h_locs, h_ids = struct.unpack_from('<HH', hg)
        offset = len(pairs)
        # 0xFFFF marks a model with no entries; it stays as it is.
        locators += [(c, i if i == 0xFFFF else i + offset)
                     for c, i in (struct.unpack_from('<HH', hg, 4 + 4 * j) for j in range(h_locs))]
        pairs += [struct.unpack_from('<HH', hg, 4 + 4 * h_locs + 4 * j) for j in range(h_ids)]
    out = struct.pack('<HH', len(locators), len(pairs))
    out += b''.join(struct.pack('<HH', *x) for x in locators) + b''.join(struct.pack('<HH', *x) for x in pairs)
    open(path, 'wb').write(out)

    problems = check_behaviors(used)
    print(f'land data: {len(land)} blocks ({unused_blocks} used by no map header), map textures: '
          f'{len(hg_narc("a/0/4/4"))}, building models: 340 outdoor + 222 indoor, building lists: {len(set_names)} '
          f'({placeholders} placeholder texture sets), areas: {len(areas)}, material/shape: {len(locators)} entries')
    print(f'tile behaviours used: {len(used)}; translated: {sorted(hex(b) for b in used & set(TRANSLATE))}')
    if conflicts:
        print('used both outdoors and indoors (took the first):', conflicts)
    if problems:
        print('behaviours that mean different things and are not translated:')
        for p in problems:
            print('  ' + p)
        sys.exit(1)


if __name__ == '__main__':
    main()
