#!/usr/bin/env python3
"""Compare Platinum's and HeartGold's tile behaviour numbers.

Each map tile's permission entry carries a behaviour number (tall grass, water, ledge, warp...). Both games number
them in an enum; this parses both and reports which numbers mean the same thing, which moved, and which exist in
only one game, so the land data converter knows what to translate.

Usage: python3 tools/complete/compare_tile_behaviors.py [--list]
"""
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
PLATINUM = os.path.join(ROOT, 'decomp/include/constants/field/map_tile_behaviors.h')
HGSS = os.path.join(ROOT, '.cache/pokeheartgold/include/constants/metatile_behavior.h')


def parse_enum(path):
    """{value: name} for the TileBehavior enum: implicit values count up, explicit ones reset the count."""
    text = open(path).read()
    body = re.search(r'enum\s+\w+\s*\{(.*?)\};', text, re.S).group(1)
    values, n = {}, 0
    for line in body.splitlines():
        line = line.split('//')[0].strip().rstrip(',')
        if not line:
            continue
        m = re.match(r'(\w+)\s*(?:=\s*(\w+))?$', line)
        if not m:
            continue
        if m.group(2):
            n = int(m.group(2), 0)
        values[n] = m.group(1)
        n += 1
    return values


def key(name):
    """A name without its prefix, and without the placeholder suffixes the two decomps use for unnamed values."""
    name = re.sub(r'^(TILE_BEHAVIOR_|MB_)', '', name)
    return None if re.match(r'^(\d+|UNUSED_X?[0-9A-F]+|\d+_UNUSED|NONE)$', name, re.I) else name


def main():
    pt, hg = parse_enum(PLATINUM), parse_enum(HGSS)
    pt_by_key = {key(n): v for v, n in pt.items() if key(n)}
    hg_by_key = {key(n): v for v, n in hg.items() if key(n)}
    same = [k for k in hg_by_key if k in pt_by_key and pt_by_key[k] == hg_by_key[k]]
    moved = [k for k in hg_by_key if k in pt_by_key and pt_by_key[k] != hg_by_key[k]]
    hg_only = [k for k in hg_by_key if k not in pt_by_key]
    print(f'Platinum: {len(pt)} values, {len(pt_by_key)} named; HeartGold: {len(hg)} values, {len(hg_by_key)} named')
    print(f'same name and number: {len(same)}; same name, other number: {len(moved)}; HeartGold only: {len(hg_only)}')
    if '--list' in sys.argv:
        for k in moved:
            print(f'  moved   {k}: HeartGold 0x{hg_by_key[k]:02X} -> Platinum 0x{pt_by_key[k]:02X}')
        for k in hg_only:
            print(f'  HG only {k}: 0x{hg_by_key[k]:02X}')


if __name__ == '__main__':
    main()
