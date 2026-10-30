#!/usr/bin/env python3
"""Bring in HeartGold's Headbutt trees, Rock Smash finds and Headbutt tutor list (src/overlay006/complete_field_encounters.c),
as decomp/include/data/hgss_field_encounters.h:

- Headbutt trees (HeartGold's files/arc/headbutt.json; Sacred Gold's archive, a/2/5/2, is the same): for each map, its
  trees' tiles (a tree is up to six), which of them are secret trees, and the six Pokémon of its common, rare and secret
  trees. HeartGold's version-only species take HeartGold's.
- Rock Smash finds (Sacred Gold's a/2/5/3, the same as HeartGold's): the maps where a smashed rock can hold an item, the
  odds and which of HeartGold's three item lists (its src/field/rock_smash_item.c, HeartGold's version).
- The Headbutt tutor (Ilex Forest): which species can learn Headbutt from him, by HeartGold's tutor list
  (files/fielddata/wazaoshie/waza_oshie.json); species HeartGold doesn't have count when they learn Headbutt by level
  or as an egg move in Sovereign's data.

Usage: python3 tools/complete/import_hgss_field_encounters.py [--rom .cache/sacredgold.nds]
"""
import argparse
import glob
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402

OUT = os.path.join(DECOMP, 'include', 'data', 'hgss_field_encounters.h')
SLOTS = 6
# HeartGold's rock smash item lists (src/field/rock_smash_item.c, HEARTGOLD): default, Ruins of Alph, Cliff Cave
ROCK_SMASH_ITEMS = [
    ['ITEM_MAX_ETHER', 'ITEM_REVIVE', 'ITEM_HEART_SCALE', 'ITEM_RED_SHARD', 'ITEM_BLUE_SHARD', 'ITEM_GREEN_SHARD',
     'ITEM_YELLOW_SHARD', 'ITEM_STAR_PIECE'],
    ['ITEM_RED_SHARD', 'ITEM_YELLOW_SHARD', 'ITEM_HELIX_FOSSIL', 'ITEM_MAX_ETHER', 'ITEM_BLUE_SHARD',
     'ITEM_GREEN_SHARD', 'ITEM_OLD_AMBER', 'ITEM_MAX_REVIVE'],
    ['ITEM_MAX_ETHER', 'ITEM_PEARL', 'ITEM_BIG_PEARL', 'ITEM_RED_SHARD', 'ITEM_YELLOW_SHARD', 'ITEM_CLAW_FOSSIL',
     'ITEM_CLAW_FOSSIL', 'ITEM_RARE_BONE'],
]


def hg_maps():
    """HeartGold's map numbers and codes (MAP_R01) -> its names (MAP_ROUTE_1)."""
    by_number, by_code = {}, {}
    for name, number, code in re.findall(r'#define (MAP_\w+)\s+(\d+)\s*// (MAP_\w+)',
                                         open(os.path.join(HG, 'include', 'constants', 'maps.h')).read()):
        by_number[int(number)] = name
        by_code[code[len('MAP_'):]] = name
    return by_number, by_code


def header(hg_name):
    return 'MAP_HEADER_HGSS_' + hg_name[len('MAP_'):]


def species_name(value, known):
    name = value['gold'] if isinstance(value, dict) else value
    if name not in known:
        raise SystemExit(f'{name}: not one of the engine\'s species')
    return name


def headbutt(by_code, known):
    tables = json.load(open(os.path.join(HG, 'files', 'arc', 'headbutt.json')))['tables']
    rows, tiles = [], []
    for table in tables:
        if not table['Trees'] and not table['SecretTrees']:
            continue
        first = len(tiles)
        for secret, trees in ((0, table['Trees']), (1, table['SecretTrees'])):
            for i, tree in enumerate(trees):
                tiles += [(c['x'], c['y'], i, secret) for c in tree]
        slots = {kind: [(species_name(s['species'], known), s['minLevel'], s['maxLevel']) for s in table[kind]]
                 for kind in ('CommonMons', 'RareMons', 'SecretMons')}
        for kind, mons in slots.items():
            if mons and len(mons) != SLOTS:
                raise SystemExit(f'{table["Map"]}: {len(mons)} {kind}')
            slots[kind] = mons or [('SPECIES_NONE', 0, 0)] * SLOTS
        rows.append((header(by_code[table['Map']]), len(table['Trees']), len(table['SecretTrees']), first,
                     len(tiles) - first, slots))
    return rows, tiles


def rock_smash(rom_path, by_number):
    import ndspy.narc
    import ndspy.rom
    rom = ndspy.rom.NintendoDSRom.fromFile(rom_path)
    rows = []
    for number, data in enumerate(ndspy.narc.NARC(rom.getFileByName('a/2/5/3')).files):
        odds, kind = int.from_bytes(data[0:2], 'little'), int.from_bytes(data[2:4], 'little')
        if odds:
            rows.append((header(by_number[number]), odds, kind))
    return rows


def headbutt_learners(known):
    """The engine's species numbers that can learn Headbutt from the tutor."""
    numbers = {name: i for i, name in enumerate(known)}
    learners = set()
    for entry in json.load(open(os.path.join(HG, 'files', 'fielddata', 'wazaoshie', 'waza_oshie.json')))['tutor']:
        if 'TUTOR_HEADBUTT' in entry['moves'] and entry['mon'] in numbers:
            learners.add(numbers[entry['mon']])
    hg_count = numbers['SPECIES_ARCEUS']
    for path in glob.glob(os.path.join(DECOMP, 'res', 'pokemon', '*', 'data.json')):
        data = json.load(open(path))
        name = 'SPECIES_' + os.path.basename(os.path.dirname(path)).upper()
        if name not in numbers or numbers[name] <= hg_count:
            continue
        learnset = data.get('learnset', {})
        if any(move == 'MOVE_HEADBUTT' for _, move in learnset.get('by_level', [])) or \
                'MOVE_HEADBUTT' in data.get('egg_moves', []) + learnset.get('egg_moves', []):
            learners.add(numbers[name])
    return learners


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--rom', default=os.path.join(ROOT, '.cache', 'sacredgold.nds'))
    args = parser.parse_args()
    known = [line.strip() for line in open(os.path.join(DECOMP, 'generated', 'species.txt')) if line.strip()]
    by_number, by_code = hg_maps()
    tables, tiles = headbutt(by_code, known)
    finds = rock_smash(args.rom, by_number)
    learners = headbutt_learners(known)

    out = ['// Generated by tools/complete/import_hgss_field_encounters.py: HeartGold\'s Headbutt trees, Rock Smash finds',
           '// and Headbutt tutor list (src/overlay006/complete_field_encounters.c). Do not edit.', '',
           '#ifndef POKEPLATINUM_DATA_HGSS_FIELD_ENCOUNTERS_H', '#define POKEPLATINUM_DATA_HGSS_FIELD_ENCOUNTERS_H', '',
           '// Every tree\'s tiles: x, z, the tree (in its map\'s regular or secret trees), whether it is a secret tree',
           'static const CompleteHeadbuttTile sHeadbuttTiles[] = {']
    out += [f'    {{ {x}, {z}, {tree}, {secret} }},' for x, z, tree, secret in tiles]
    out += ['};', '', 'static const CompleteHeadbuttTable sHeadbuttTables[] = {']
    for name, regular, secret, first, count, slots in tables:
        out.append(f'    {{ {name}, {regular}, {secret}, {first}, {count}, {{')
        for kind in ('CommonMons', 'RareMons', 'SecretMons'):
            out.append('        { ' + ', '.join(f'{{ {s}, {lo}, {hi} }}' for s, lo, hi in slots[kind]) + ' },')
        out.append('    } },')
    out += ['};', '', '// The maps where a smashed rock can hold an item: the odds (%) and the item list',
            'static const CompleteRockSmashFind sRockSmashFinds[] = {']
    out += [f'    {{ {name}, {odds}, {kind} }},' for name, odds, kind in finds]
    out += ['};', '', 'static const u16 sRockSmashItems[][8] = {']
    out += ['    { ' + ', '.join(items) + ' },' for items in ROCK_SMASH_ITEMS]
    out += ['};', '', '// The species that can learn Headbutt from Ilex Forest\'s tutor, a bit each',
            f'static const u8 sHeadbuttLearners[{(len(known) + 7) // 8}] = {{']
    bits = [sum(1 << b for b in range(8) if i * 8 + b in learners) for i in range((len(known) + 7) // 8)]
    out += ['    ' + ', '.join(f'0x{v:02X}' for v in bits[i:i + 16]) + ',' for i in range(0, len(bits), 16)]
    out += ['};', '', '#endif // POKEPLATINUM_DATA_HGSS_FIELD_ENCOUNTERS_H']
    open(OUT, 'w').write('\n'.join(out) + '\n')
    print(f'{len(tables)} maps with Headbutt trees ({len(tiles)} tiles), {len(finds)} with Rock Smash finds, '
          f'{len(learners)} species that can learn Headbutt')


if __name__ == '__main__':
    main()
