#!/usr/bin/env python3
"""Sum up test_walk_everywhere.py's results for review (the owner's "Possible issues" tab).

Reads every results*.json in OUT_DIR and prints, worst first:
- hangs (the frame counter stopped);
- maps not walked at all, or areas the walk couldn't start in (with where the warp put the player);
- maps walked under 90% of their reachable tiles;
- refused steps onto tiles the map data says are open, grouped by map and by the tile's behavior (a bridge's are
  listed apart: its height can refuse a step there and be right);
- map changes (the walk stepped onto another map: a connection or a warp the map data doesn't show).

Usage: python3 tools/complete/walk_review.py OUT_DIR [--md]
"""
import collections
import glob
import json
import os
import sys


def main():
    out = sys.argv[1]
    md = '--md' in sys.argv
    results = {}
    for path in sorted(glob.glob(os.path.join(out, 'results*.json'))):
        results.update(json.load(open(path)))
    bullet = '- ' if md else '  '
    hangs, unwalked, partial, refused, left, skipped = [], [], [], [], [], []
    for header, r in sorted(results.items()):
        name = header[len('MAP_HEADER_'):]
        if r.get('skipped'):
            skipped.append(f'{name}: {r["skipped"]}')
            continue
        if r.get('hang'):
            hangs.append(f'{name}: {r["hang"]}')
        for area in r.get('unreached_areas', []):
            unwalked.append(f'{name}: an area of {area["size"]} tiles from {tuple(area["start"])} '
                            f'(the warp: {area["warp"]})')
        reach, walked = r.get('reachable', 0), r.get('walked', 0)
        if reach and walked < 0.9 * reach and not r.get('unreached_areas'):
            partial.append(f'{name}: {walked} of {reach} tiles')
        if r.get('refused'):
            spots = {(tuple(x['to']), x['behavior'], x['bridge']) for x in r['refused']}
            plain = [s for s in spots if not s[2]]
            if plain:
                behaviors = collections.Counter(b for _, b, _ in plain)
                refused.append(f'{name}: {len(plain)} tiles ({", ".join(f"behavior {b}: {n}" for b, n in sorted(behaviors.items()))}): '
                               + ', '.join(str(t) for t, _, _ in sorted(plain)[:8]) + (' ...' if len(plain) > 8 else ''))
        if r.get('left'):
            where = collections.Counter(x['to'] for x in r['left'])
            left.append(f'{name}: ' + ', '.join(f'{to[len("MAP_HEADER_"):]} x{n}' for to, n in where.items()))
    total = len(results)
    print(f'{total} maps; {len(hangs)} hangs, {len(unwalked)} areas not walked, {len(partial)} maps under 90%, '
          f'{len(refused)} maps with refused steps, {len(left)} maps the walk left, {len(skipped)} skipped')
    for title, items in (('Hangs', hangs), ('Not walked', unwalked), ('Under 90% walked', partial),
                         ('Refused steps (not on bridges)', refused), ('Left the map', left), ('Skipped', skipped)):
        if items:
            print(f'\n{"### " if md else ""}{title} ({len(items)})')
            for item in items:
                print(bullet + item)


if __name__ == '__main__':
    main()
