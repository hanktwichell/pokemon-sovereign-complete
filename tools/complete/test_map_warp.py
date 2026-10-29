#!/usr/bin/env python3
"""Warp into a converted HeartGold test map and walk on it (test build).

Starts a new game on the test build, then warps through gSovereignTestWarpTarget to MAP_HEADER_COMPLETE_<NAME>
(made by tools/complete/hgss_test_map.py) on a walkable tile of its first block, and checks:
- the player arrives on that tile and the field runs (gSovereignTestIdleFrames keeps rising): the map loaded;
- the top screen is drawn (many colours) and isn't the bedroom it left;
- the player can walk on it (at least two of the four directions move), and the lead Pokémon follows;
Screenshots go to OUT_DIR (default .cache/test-map) for a look by eye.

Usage: python3 tools/complete/test_map_warp.py NAME [OUT_DIR] [ROM]   (e.g. OLIVINE_CITY)
"""
import json
import os
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

FACE_DOWN = 1
COLLISION = 0x8000


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


def walkable_tile(name):
    """A tile of the map's first block that is walkable with all four neighbours walkable, nearest the block's middle."""
    matrix = json.load(open(os.path.join(ROOT, f'decomp/res/field/matrices/map_matrix_complete_{name.lower()}.json')))
    block = next(c for row in matrix['maps'] for c in row if c != 'MAP_NONE')
    data = open(os.path.join(ROOT, f'decomp/res/field/maps/data/map_data_{int(block[4:]):03d}.bin'), 'rb').read()
    tiles = struct.unpack_from('<1024H', data, 16)
    free = lambda x, z: 0 <= x < 32 and 0 <= z < 32 and not tiles[z * 32 + x] & COLLISION  # noqa: E731
    candidates = [(x, z) for z in range(32) for x in range(32)
                  if all(free(x + dx, z + dz) for dx, dz in ((0, 0), (1, 0), (-1, 0), (0, 1), (0, -1)))]
    if not candidates:
        sys.exit(f'{block}: no open tile to warp to')
    return min(candidates, key=lambda t: (t[0] - 16) ** 2 + (t[1] - 16) ** 2)


def top_colours(d):
    shot = d.screenshot()
    return len(set(shot.crop((0, 0, 256, 192)).getdata())), shot


def main():
    name = sys.argv[1].upper()
    out = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, '.cache/test-map')
    rom = sys.argv[3] if len(sys.argv) > 3 else os.path.join(ROOT, 'decomp/build_test/pokeplatinum.us.nds')
    os.makedirs(out, exist_ok=True)
    warp = symbol(rom, 'gSovereignTestWarpTarget')
    idle_addr = symbol(rom, 'gSovereignTestIdleFrames')
    fol = symbol(rom, 'gCompleteTestFollowerTile')
    check = Check()
    target_id, (x, z) = header_id(f'COMPLETE_{name}'), walkable_tile(name)

    d = Driver(rom)
    for action in ['wait:600', 'A', 'wait:200', 'A', 'wait:200', 'A', 'wait:400'] + ['A', 'wait:60'] * 12 + ['wait:120']:
        d.do(action)
    settle(d, idle_addr)
    _, before = top_colours(d)

    for offset, value in ((0, target_id), (2, x), (4, z), (6, FACE_DOWN + 1)):
        d.emu.memory.write_short(warp + offset, value)
    d.press('SELECT+L+R', frames=8, after=300)
    check(settle(d, idle_addr), f'MAP_HEADER_COMPLETE_{name} ({target_id}): the field runs after the warp')
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

    print('PASS' if check.failures == 0 else f'FAIL ({check.failures})')
    sys.exit(check.failures != 0)


if __name__ == '__main__':
    main()
