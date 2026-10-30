#!/usr/bin/env python3
"""Check Whirlpool (CommonScript_CompleteWhirlpool) in the test build, from the bedroom state: in Dragon's Den, with
the Fog and Glacier Badges and HM03 and HM05 in the bag (Sovereign lets the HM in the bag do), the player surfs out from
the pond's west shore, surfs to the water north of the whirlpool (a 3×3 block at x 13-15, z 36-38), faces it and
says yes to Whirlpool. Passes when the player ends on the water south of it, across the whirlpool.

Results: 'ok' or what went wrong, and a screenshot in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_whirlpool.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, play_out, warp  # noqa: E402

MAP = 'MAP_HEADER_HGSS_DRAGONS_DEN'
SHORE, EAST = (8, 31), 4  # the test warp's facing: enum FaceDirection + 1
# after surfing onto (9, 31): east to (14, 31), south to (14, 35), facing the whirlpool
PATH = [('RIGHT', (14, 31)), ('DOWN', (14, 35))]
ACROSS = (14, 39)
FOG, GLACIER = 3, 6  # include/constants/hgss_badges.h
LIMIT = 3000
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gCompleteTestHGSSBadges', 'gSovereignTestPlayerTile'})


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    items = consts('items.txt')
    d = Driver(rom, state)
    mem = d.emu.memory

    def tile():
        return struct.unpack('<HH', bytes(mem.unsigned[sym['gSovereignTestPlayerTile']:
                                                      sym['gSovereignTestPlayerTile'] + 4]))

    def go(button, target):
        """Surf a tile at a time to target (surfing is faster than walking), playing out what starts on the way (a wild
        Pokémon, the test save's Super Repel wearing off)."""
        for _ in range(20):
            if tile() == target:
                return
            mem.write_short(sym['gSovereignTestScripts'], 0)
            d.press(button, frames=2, after=14)
            play_out(d, sym, LIMIT, press_a=False)

    d.load_state(state)
    d.run(30)
    mem.write_byte(sym['gSovereignTestGodMode'], 1)
    mem.write_short(sym['gCompleteTestHGSSBadges'], 1 << FOG | 1 << GLACIER)
    mem.write_short(sym['gSovereignTestBagItem'], items.index('ITEM_HM03'))
    problem = ''
    arrived, _ = warp(d, sym, names.index(MAP), *SHORE, 0)
    if arrived == 'ok':
        mem.write_short(sym['gSovereignTestBagItem'], items.index('ITEM_HM05'))
        arrived, _ = warp(d, sym, names.index(MAP), *SHORE, EAST)
    if arrived != 'ok':
        problem = f'warp {arrived}'
    if not problem:  # Surf, yes
        result, frames = play_out(d, sym, LIMIT)
        if result != 'ok' or tile() != (SHORE[0] + 1, SHORE[1]):
            problem = f'surfing out: {result}, on {tile()}'
    if not problem:
        for button, target in PATH:
            go(button, target)
        if tile() != (ACROSS[0], ACROSS[1] - 4):
            problem = f'surfed to {tile()}, not {(ACROSS[0], ACROSS[1] - 4)}'
    if not problem:  # Whirlpool, yes
        result, frames = play_out(d, sym, LIMIT)
        if result != 'ok':
            problem = f'{result} after {frames} frames'
        elif tile() != ACROSS:
            problem = f'ended on {tile()}, not {ACROSS}'
    d.screenshot().save(os.path.join(out, 'whirlpool.png'))
    print(f'whirlpool: {problem or "ok"}')
    sys.exit(1 if problem else 0)


if __name__ == '__main__':
    main()
