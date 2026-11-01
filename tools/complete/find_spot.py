#!/usr/bin/env python3
"""Find spots on a map for a Totem or a legendary to stand (data/complete/placed.yaml): tiles the player can reach
without Rock Climb or Waterfall (a Totem's or a legendary's gate can come before the player has either: HeartGold's
HM08 comes from Oak late in Kanto), with nobody, no warp and no trigger on them and nobody or no sign beside them (so nobody is talked to from there), that
leave every other tile reachable while something stands there (so it never blocks the way), with a free tile beside
them to talk from. Nooks and corners far from the way in come first.

Usage: python3 tools/complete/find_spot.py MAP_HEADER [COUNT]
"""
import collections
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
from check_object_tiles import DIRS, Maps, explore, walkable  # noqa: E402

WATER = None
CLIMBS = {0x4b, 0x4c, 0x13}  # TILE_BEHAVIOR_ROCK_CLIMB_N_S, _E_W and TILE_BEHAVIOR_WATERFALL


def header_info(header):
    src = open(os.path.join(DECOMP, 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    m = re.search(r'\[' + header + r'\]\s*=\s*\{(.*?)\}', src, re.S)
    return (re.search(r'eventsArchiveID = (\w+)', m.group(1)).group(1),
            re.search(r'mapMatrixID = (\w+)', m.group(1)).group(1))


def box_of(matrix, header):
    """The map's tiles' bounds: the matrix chunks that are this header's (the overworld), or the whole matrix."""
    data = json.load(open(os.path.join(DECOMP, 'res', 'field', 'matrices', matrix + '.json'), encoding='utf-8'))
    grid = data.get('headers')
    chunks = [(r, c) for r, row in enumerate(grid or []) for c, h in enumerate(row) if h == header]
    if not chunks:
        rows, cols = len(data['maps']), len(data['maps'][0])
        return 0, 0, cols * 32 - 1, rows * 32 - 1
    rs, cs = [r for r, _ in chunks], [c for _, c in chunks]
    return min(cs) * 32, min(rs) * 32, max(cs) * 32 + 31, max(rs) * 32 + 31


def spots(header, count=8):
    events_name, matrix = header_info(header)
    ev = json.load(open(os.path.join(DECOMP, 'res', 'field', 'events', events_name + '.json'), encoding='utf-8'))
    maps = Maps(DECOMP)
    box = box_of(matrix, header)
    x0, z0, x1, z1 = box
    warps = {(w['x'], w['z']) for w in ev.get('warp_events', [])}
    people = {(o['x'], o['z']) for o in ev.get('object_events', [])}
    triggers = {(c['x'] + i, c['z'] + j) for c in ev.get('coord_events', [])
                for i in range(c['width']) for j in range(c['length'])}
    signs = {(b['x'], b['z']) for b in ev.get('bg_events', [])}
    edge = [(x, z) for x in range(x0, x1 + 1) for z in (z0, z1)] + [(x, z) for z in range(z0, z1 + 1) for x in (x0, x1)]
    # Rock Climb walls and waterfalls count as walls (Sovereign Complete: Totem Marowak was put behind Rock Tunnel's)
    climbs = {(x, z) for x in range(x0, x1 + 1) for z in range(z0, z1 + 1)
              if (maps.tile(matrix, x, z) or 0) & 0xff in CLIMBS}
    seen = explore(maps, matrix, box, edge, warps, people | climbs)
    flat = {(x, z) for x, z, e in seen if not e}
    # distance from the ways in (warps and the map's edges)
    dist, queue = {}, collections.deque()
    for p in list(warps & flat) + [p for p in edge if p in flat]:
        dist[p] = 0
        queue.append(p)
    while queue:
        x, z = queue.popleft()
        for dx, dz in DIRS:
            n = (x + dx, z + dz)
            if n in flat and n not in dist:
                dist[n] = dist[(x, z)] + 1
                queue.append(n)
    out = []
    for p in sorted(flat):
        x, z = p
        t = maps.tile(matrix, x, z)
        if p in warps or p in triggers or p in signs or p in people or not walkable(t) or (t & 0xff) == 0x02:
            continue  # not on a warp, a trigger, a sign, tall grass
        if any((x + dx, z + dz) in people | signs for dx, dz in DIRS):
            continue  # nor where someone or a sign is talked to from
        talk = [(x + dx, z + dz) for dx, dz in DIRS if (x + dx, z + dz) in flat]
        if not talk:
            continue
        reached = explore(maps, matrix, box, edge, warps, people | climbs | {p})
        if len({(a, b) for a, b, e in reached if not e}) < len(flat) - 1:
            continue  # it would cut the way
        walls = 4 - len(talk)
        out.append((-(walls * 6 + min(dist.get(p, 0), 30)), p, walls, dist.get(p, 0)))
    out.sort()
    return [(p, walls, d) for _, p, walls, d in out[:count]]


def main():
    header = sys.argv[1]
    count = int(sys.argv[2]) if len(sys.argv) > 2 else 8
    for p, walls, d in spots(header, count):
        print(f'{header} ({p[0]}, {p[1]}): {walls} sides walled, {d} steps from the way in')


if __name__ == '__main__':
    main()
