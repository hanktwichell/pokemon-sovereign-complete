#!/usr/bin/env python3
"""Check the following-Pokémon prototype in the emulator (test build).

Starts a new game on the test build, whose lead is Garchomp (it has a walking sprite), then:
- a follower exists once the player can move;
- after each step the follower stands on the tile the player just left;
- after the test warp (SELECT+L+R, the next stop in sSovereignTestWarps) the follower is there again and keeps
  trailing.

The positions come from the test build's gSovereignTestPlayerTile and gCompleteTestFollowerTile (src/field_system.c,
src/complete_follower.c), found in the symbol map next to the ROM.

Usage: python3 tools/complete/test_follower.py [ROM]   (defaults to decomp/build_test/pokeplatinum.us.nds)
"""
import os
import re
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from drive import Driver  # noqa: E402

NO_FOLLOWER = (0xFFFF, 0xFFFF)
STEPS = ['DOWN', 'DOWN', 'LEFT', 'LEFT', 'UP', 'RIGHT', 'RIGHT']


def symbol(rom, name):
    xmap = os.path.join(os.path.dirname(os.path.abspath(rom)), 'main.nef.xMAP')
    with open(xmap, encoding='utf-8', errors='replace') as f:
        m = re.search(rf'^\s*([0-9A-F]{{8}}) [0-9A-F]{{8}} \.bss\s+{name}\b', f.read(), re.M)
    if not m:
        sys.exit(f'{name} is not in {xmap}: build the test ROM (tools/test/build_test_rom.sh)')
    return int(m.group(1), 16)


class Check:
    def __init__(self):
        self.failures = 0

    def __call__(self, ok, what):
        print(('ok   ' if ok else 'FAIL ') + what, flush=True)
        self.failures += not ok


def follower(d, addr):
    return struct.unpack('<HH', bytes(d.emu.memory.unsigned[addr:addr + 4]))


def walk(d, addr, check, where):
    """Take each step; a step that moves the player must leave the follower on the tile the player left."""
    moved = 0
    for key in STEPS:
        before = d.pos()
        d.press(key, frames=16, after=24)
        after, f = d.pos(), follower(d, addr)
        if after == before:
            print(f'     {key}: blocked at {before}, follower {f}', flush=True)
            continue
        moved += 1
        check(f == before, f'{where}: {key} {before} -> {after}, follower on {f} (the tile left)')
    check(moved >= 3, f'{where}: the player moved {moved} of {len(STEPS)} steps')


def main():
    rom = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, '..', '..', 'decomp/build_test/pokeplatinum.us.nds')
    addr = symbol(rom, 'gCompleteTestFollowerTile')
    check = Check()
    d = Driver(rom)

    # Title -> NEW GAME (the test build skips the intro) -> the bedroom TV program -> free to move (tools/test/new_game.sh).
    for action in ['wait:600', 'A', 'wait:200', 'A', 'wait:200', 'A', 'wait:400'] + ['A', 'wait:60'] * 12 + ['wait:120']:
        d.do(action)
    f = follower(d, addr)
    check(f != NO_FOLLOWER, f'bedroom: a follower exists, on {f} (player on {d.pos()})')
    walk(d, addr, check, 'bedroom')

    d.press('SELECT+L+R', frames=8, after=240)
    f = follower(d, addr)
    check(f != NO_FOLLOWER, f'after the test warp: a follower exists, on {f} (player on {d.pos()})')
    walk(d, addr, check, 'after the warp')

    print('PASS' if check.failures == 0 else f'FAIL ({check.failures})')
    sys.exit(check.failures != 0)


if __name__ == '__main__':
    main()
