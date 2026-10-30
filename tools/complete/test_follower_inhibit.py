#!/usr/bin/env python3
"""Check HeartGold's follower inhibit flag (CompleteFollowerInhibit, src/complete_follower.c) in the test build, from
the bedroom state, whose lead, Garchomp, follows:

1. **Kept away:** in Blackthorn Gym the guide's talk puts the follower in its ball and inhibits it, then lets it out
   again, as HeartGold's script does. Passes when no follower is out after the talk, nor after a few steps.
2. **Back:** a warp to Blackthorn City clears the flag. Passes when the follower is out there.

Results: a line per part, and a screenshot of each in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_follower_inhibit.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import battle_mechanics as bm  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, warp  # noqa: E402
from test_hgss_loan import place  # noqa: E402
from test_map_warp import walkable_tile  # noqa: E402

SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gSovereignTestMenu', 'gCompleteTestFollowerTile'})
GUIDE = ('events_hgss_137', 'obj_T30GYM0101_sunglasses')  # Blackthorn Gym's guide
CITY = 'MAP_HEADER_HGSS_BLACKTHORN'
NO_FOLLOWER = (0xFFFF, 0xFFFF)
DOWN = 0  # the test warp's facing (enum FaceDirection + 1, or 0 for down)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory

    def follower():
        at = sym['gCompleteTestFollowerTile']
        return struct.unpack('<HH', bytes(mem.unsigned[at:at + 4]))

    results = []

    def report(part, problem):
        results.append(f'{part}: {problem or "ok"}')
        print(results[-1], f'(follower {follower()})', flush=True)

    d.load_state(state)
    d.run(30)
    header, x, z, face = place(*GUIDE)
    arrived, _ = warp(d, sym, header, x, z, face + 1)
    problem = '' if arrived == 'ok' else f'warp {arrived}'
    if not problem and follower() == NO_FOLLOWER:
        problem = 'no follower before the talk'
    if not problem:
        result, _ = talk_and_answer(d, sym, [], 6000)
        problem = '' if result == 'ok' else f'the talk: {result}'
    if not problem:
        for key in ('DOWN', 'UP'):  # a step away and back: the field frames the follower would come back on
            d.press(key, frames=16, after=24)
        d.run(60)
        if follower() != NO_FOLLOWER:
            problem = f'the follower is out on {follower()}'
    d.screenshot().save(os.path.join(out, 'gym.png'))
    report('kept away', problem)

    x, z = walkable_tile(CITY)
    arrived, _ = warp(d, sym, names.index(CITY), x, z, DOWN)
    problem = '' if arrived == 'ok' else f'warp {arrived}'
    d.run(60)
    if not problem and follower() == NO_FOLLOWER:
        problem = 'no follower in the city'
    d.screenshot().save(os.path.join(out, 'city.png'))
    report('back', problem)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok')
    sys.exit(0 if ok == len(results) == 2 else 1)


if __name__ == '__main__':
    main()
