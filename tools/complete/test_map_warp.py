#!/usr/bin/env python3
"""Warp into a converted HeartGold map and walk on it (test build).

Starts a new game on the test build, then warps through gSovereignTestWarpTarget to MAP_HEADER_HGSS_<NAME>
(tools/complete/import_hgss_headers.py) on a walkable tile of one of its blocks, and checks:
- the player arrives on that tile and the field runs (gSovereignTestIdleFrames keeps rising): the map loaded;
- the top screen is drawn (many colours) and isn't the bedroom it left;
- the player can walk on it (at least two of the four directions move), and the lead Pokémon follows;
- walking into the map's first door (warp) leads to the map the warp names;
Screenshots go to OUT_DIR (default .cache/test-map) for a look by eye.

Usage: python3 tools/complete/test_map_warp.py NAME [OUT_DIR] [ROM]   (HeartGold's map name, e.g. OLIVINE)
"""
import json
import os
import re
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from drive import Driver  # noqa: E402
from test_follower import NO_FOLLOWER, Check, follower, settle, symbol  # noqa: E402

FACE = {'UP': 0, 'DOWN': 1, 'LEFT': 2, 'RIGHT': 3}
COLLISION = 0x8000
FLOORS = ('NONE', 'TALL_GRASS', 'CAVE_FLOOR', 'OLD_CHATEAU_FLOOR', 'MOUNTAIN_FLOOR', 'SAND', 'SNOW_SHALLOW',
          'SNOW_WITH_SHADOWS', 'PUDDLE', 'PUDDLE_NO_SPLASHING', 'SHALLOW_WATER', 'REFLECTIVE', 'BRIDGE',
          'BRIDGE_OVER_CAVE', 'BRIDGE_OVER_WATER', 'BRIDGE_OVER_SAND', 'BRIDGE_OVER_SNOW')


def tile_behaviors():
    """{name: number} for TILE_BEHAVIOR_* (include/constants/field/map_tile_behaviors.h, an enum counting up)."""
    text = open(os.path.join(ROOT, 'decomp/include/constants/field/map_tile_behaviors.h')).read()
    values, n = {}, -1
    for name, value in re.findall(r'^\s*TILE_BEHAVIOR_(\w+)(?:\s*=\s*(\w+))?,', text, re.M):
        n = int(value, 0) if value else n + 1
        values[name] = n
    return values


FLOOR_BEHAVIORS = {tile_behaviors()[name] for name in FLOORS}  # tiles a player can stand on without Surf


def header_id(name):
    """MAP_HEADER_<name>'s value: its place in generated/map_headers.txt (names count up from 0)."""
    n = 0
    for line in open(os.path.join(ROOT, 'decomp/generated/map_headers.txt')):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if line == f'MAP_HEADER_{name}':
            return n
        n += 1
    sys.exit(f'MAP_HEADER_{name} is not in generated/map_headers.txt')


def matrix_of(header):
    """The map header's matrix name, from include/data/map_headers.h."""
    text = open(os.path.join(ROOT, 'decomp/include/data/map_headers.h')).read()
    entry = re.search(rf'\[{header}\] = \{{(.*?)\n    \}}', text, re.S).group(1)
    return re.search(r'\.mapMatrixID = (\w+),', entry).group(1)


def events_of(header):
    """The map header's events file, from include/data/map_headers.h."""
    text = open(os.path.join(ROOT, 'decomp/include/data/map_headers.h')).read()
    entry = re.search(rf'\[{header}\] = \{{(.*?)\n    \}}', text, re.S).group(1)
    name = re.search(r'\.eventsArchiveID = (\w+),', entry).group(1)
    return json.load(open(os.path.join(ROOT, f'decomp/res/field/events/{name}.json')))


def floor(header):
    """The header's free floor tiles (FLOORS: ground, cave floor, sand, shallow snow, bridges...; no collision, nobody
    standing on it), as a test on matrix-wide tile coordinates, and its events."""
    matrix = json.load(open(os.path.join(ROOT, f'decomp/res/field/matrices/{matrix_of(header)}.json')))
    events = events_of(header)
    tiles, raw = {}, {}
    for cz, row in enumerate(matrix['maps']):
        for cx, block in enumerate(row):
            if block == 'MAP_NONE' or (matrix['headers'] and matrix['headers'][cz][cx] != header):
                continue
            data = open(os.path.join(ROOT, f'decomp/res/field/maps/data/map_data_{int(block[4:]):03d}.bin'), 'rb').read()
            block_tiles = struct.unpack_from('<1024H', data, 16)
            # HeartGold marks real floor with flags in bits 8-14 (the engine ignores them); in a block that uses
            # them, an all-zero tile is the empty space around a room.
            flagged = any(tile & 0x7F00 for tile in block_tiles)
            for i, tile in enumerate(block_tiles):
                raw[(cx * 32 + i % 32, cz * 32 + i // 32)] = tile
                tiles[(cx * 32 + i % 32, cz * 32 + i // 32)] = \
                    not tile & COLLISION and tile & 0xFF in FLOOR_BEHAVIORS and (tile != 0 or not flagged)
    if not tiles:
        sys.exit(f'{header}: no blocks')
    occupied = {(e['x'], e['z']) for e in events['object_events']}
    return (lambda x, z: tiles.get((x, z), False) and (x, z) not in occupied), tiles, events, raw


def walkable_tile(header):
    """A free floor tile with at least two free floor neighbours, nearest the map's first person or thing (they stand
    inside the room), else its first warp, else the middle of its first block."""
    plain, tiles, events, _ = floor(header)
    first = next(iter(tiles))
    goal = next(((e['x'], e['z']) for e in events['object_events'] + events['warp_events']),
                (first[0] + 16, first[1] + 16))
    candidates = [(x, z) for (x, z) in tiles
                  if plain(x, z) and sum(plain(x + dx, z + dz) for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1))) >= 2]
    if not candidates:
        sys.exit(f'{header}: no open tile to warp to')
    return min(candidates, key=lambda c: ((c[0] - goal[0]) ** 2 + (c[1] - goal[1]) ** 2, c))


def door(header):
    """(warp, the free floor tile next to it, the key that walks from there into it) for the first warp to another map
    that has a free floor tile beside it, or None. A warp tile that only works one way (stairs, doors, the warps
    named _EAST, _WEST, _NORTH or _SOUTH) is walked onto that way."""
    plain, _, events, raw = floor(header)
    names = {n: name for name, n in tile_behaviors().items()}
    approaches = ((0, 1, 'UP'), (0, -1, 'DOWN'), (1, 0, 'LEFT'), (-1, 0, 'RIGHT'))
    one_way = {'NORTH': 'UP', 'SOUTH': 'DOWN', 'WEST': 'LEFT', 'EAST': 'RIGHT', 'DOOR': 'UP'}
    for warp in events['warp_events']:
        if warp['dest_header_id'] == 'MAP_HEADER_DYNAMIC':
            continue
        behavior = names.get(raw.get((warp['x'], warp['z']), 0) & 0xFF, '')
        way = next((key for word, key in one_way.items() if behavior.startswith('WARP') and behavior.endswith(word)
                    or behavior == word), None)
        for dx, dz, key in approaches:
            if way and key != way:
                continue
            if plain(warp['x'] + dx, warp['z'] + dz):
                return warp, (warp['x'] + dx, warp['z'] + dz), key
    return None


def top_colours(d):
    shot = d.screenshot()
    return len(set(shot.crop((0, 0, 256, 192)).getdata())), shot


def test_warp(d, warp, header, x, z, facing):
    """Warp with the test build's warp (SELECT+L+R to gSovereignTestWarpTarget)."""
    for offset, value in ((0, header), (2, x), (4, z), (6, FACE[facing] + 1)):
        d.emu.memory.write_short(warp + offset, value)
    d.press('SELECT+L+R', frames=8, after=300)


def idle_header(d, addr):
    return struct.unpack('<I', bytes(d.emu.memory.unsigned[addr:addr + 4]))[0]


def main():
    name = sys.argv[1].upper()
    out = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, '.cache/test-map')
    rom = sys.argv[3] if len(sys.argv) > 3 else os.path.join(ROOT, 'decomp/build_test/pokeplatinum.us.nds')
    os.makedirs(out, exist_ok=True)
    warp = symbol(rom, 'gSovereignTestWarpTarget')
    idle_addr = symbol(rom, 'gSovereignTestIdleFrames')
    fol = symbol(rom, 'gCompleteTestFollowerTile')
    map_addr = symbol(rom, 'gSovereignTestIdleMapHeaderID')
    check = Check()
    target_id, (x, z) = header_id(f'HGSS_{name}'), walkable_tile(f'MAP_HEADER_HGSS_{name}')

    d = Driver(rom)
    for action in ['wait:600', 'A', 'wait:200', 'A', 'wait:200', 'A', 'wait:400'] + ['A', 'wait:60'] * 12 + ['wait:120']:
        d.do(action)
    settle(d, idle_addr)
    _, before = top_colours(d)

    test_warp(d, warp, target_id, x, z, 'DOWN')
    check(settle(d, idle_addr), f'MAP_HEADER_HGSS_{name} ({target_id}): the field runs after the warp')
    check(d.pos() == (x, z), f'the player is on the target tile: {d.pos()} (want {(x, z)})')
    colours, shot = top_colours(d)
    shot.save(os.path.join(out, f'{name.lower()}_arrival.png'))
    check(colours >= 20, f'the top screen is drawn: {colours} colours')
    check(list(shot.crop((0, 0, 256, 192)).getdata()) != list(before.crop((0, 0, 256, 192)).getdata()),
          'the top screen changed from the bedroom')
    check(follower(d, fol) != NO_FOLLOWER, f'the lead Pokémon follows here: {follower(d, fol)}')

    moved = 0
    for key in ('DOWN', 'RIGHT', 'UP', 'LEFT'):
        start = d.pos()
        d.press(key, frames=16, after=24)
        settle(d, idle_addr)
        moved += d.pos() != start
        print(f'     {key}: {start} -> {d.pos()}, follower {follower(d, fol)}', flush=True)
    d.screenshot().save(os.path.join(out, f'{name.lower()}_walked.png'))
    check(moved >= 2, f'the player walked: {moved} of 4 directions moved')

    # Through a door: from the tile beside the map's first warp, walk into it (twice for a mat, which warps on the
    # step off it), and the player must arrive on the warp's map.
    entrance = door(f'MAP_HEADER_HGSS_{name}')
    if entrance is None:
        print('     (no warp with a free tile beside it)')
    else:
        dest, (dx, dz), key = entrance
        dest_id = header_id(dest['dest_header_id'][len('MAP_HEADER_'):])
        test_warp(d, warp, target_id, dx, dz, key)
        settle(d, idle_addr)
        for _ in range(2):
            if idle_header(d, map_addr) == dest_id:
                break
            d.press(key, frames=16, after=60)
            settle(d, idle_addr)
        d.screenshot().save(os.path.join(out, f'{name.lower()}_door.png'))
        check(idle_header(d, map_addr) == dest_id,
              f'walking {key} from {(dx, dz)} into the warp at {(dest["x"], dest["z"])} leads to '
              f'{dest["dest_header_id"]} ({dest_id}): on {idle_header(d, map_addr)} at {d.pos()}')

    print('PASS' if check.failures == 0 else f'FAIL ({check.failures})')
    sys.exit(check.failures != 0)


if __name__ == '__main__':
    main()
