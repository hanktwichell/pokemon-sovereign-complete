#!/usr/bin/env python3
"""Check HeartGold's changes to the overworld's blocks as a map loads (src/complete_map_info.c,
CompleteMapInfo_LoadMatrix) in the test build, from the bedroom state. Each part warps to a tile next to one that
changes and steps onto it; the step goes through only when the tile is open:

1. **The antenna tree stands:** Mahogany Town, before Team Rocket's hideout is cleared. Passes when the tree blocks the
   step.
2. **The antenna tree gone:** the same, with the hideout cleared (VAR_HGSS_UNK_4036 as HeartGold's ScrCmd_530 0, 1
   leaves it). Passes when the step goes through.
3. **The lake low:** the Lake of Rage on a Wednesday, with the hideout cleared (FLAG_HGSS_ROCKET_HIDEOUT_CLEARED).
   Passes when the step onto what is water on other days goes through.
4. **The lake full:** the same on a Tuesday. Passes when the water stops the step.

Results: a line per part, and a screenshot of each in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_map_changes.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, var_ids, warp  # noqa: E402

SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gSovereignTestVar', 'gSovereignTestClock'})
WARP_DIR = {'UP': 1, 'DOWN': 2}  # warp's dir: enum FaceDirection + 1
DELTA = {'UP': -1, 'DOWN': 1}
CLOCK_WEEKDAY = 2  # offsetof(struct SovereignTestClock, weekday)
TUESDAY, WEDNESDAY = 2, 3
MAHOGANY, TREE = 'MAP_HEADER_HGSS_MAHOGANY', (531, 172)  # the antenna tree's west tile (HeartGold's land data 85),
# from the north
LAKE, SHORE = 'MAP_HEADER_HGSS_LAKE_OF_RAGE', (504, 38)  # water but on low Wednesdays (land data 89, 95 when low)
ANTENNA_REMOVED = 0x6208


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory

    def step_toward(part, header, target, key, test_vars, weekday=None):
        """From the tile before target, a step onto it (key UP or DOWN): (whether the player got there, a problem or
        '')."""
        d.load_state(state)
        d.run(30)
        if weekday is not None:
            mem.write_byte(sym['gSovereignTestClock'] + CLOCK_WEEKDAY, weekday + 1)
            d.run(30)  # the game reads the clock every 11 frames
        for i, (name, value) in enumerate(test_vars):
            mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[name])
            mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)
        x, z = target
        arrived, _ = warp(d, sym, names.index(header), x, z - DELTA[key], WARP_DIR[key])
        if arrived != 'ok':
            return False, f'warp {arrived}'
        d.press(key, frames=16, after=40)
        d.screenshot().save(os.path.join(out, part + '.png'))
        return d.pos() == (x, z), ''

    results = []

    def report(part, problem):
        results.append(f'{part}: {problem or "ok"}')
        print(results[-1], flush=True)

    moved, problem = step_toward('tree_stands', MAHOGANY, TREE, 'DOWN', [])
    report('tree stands', problem or ('the step went through the tree' if moved else ''))
    moved, problem = step_toward('tree_gone', MAHOGANY, TREE, 'DOWN', [('VAR_HGSS_UNK_4036', ANTENNA_REMOVED)])
    report('tree gone', problem or ('' if moved else 'the tree still blocks the step'))
    cleared = [('FLAG_HGSS_ROCKET_HIDEOUT_CLEARED', 1)]
    moved, problem = step_toward('lake_low', LAKE, SHORE, 'UP', cleared, WEDNESDAY)
    report('lake low', problem or ('' if moved else 'the lake is full on a Wednesday'))
    moved, problem = step_toward('lake_full', LAKE, SHORE, 'UP', cleared, TUESDAY)
    report('lake full', problem or ('the step went onto the water' if moved else ''))

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok')
    sys.exit(0 if ok == len(results) == 4 else 1)


if __name__ == '__main__':
    main()
