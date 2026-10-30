#!/usr/bin/env python3
"""Check the S.S. Aqua between Olivine City and Vermilion City in the test build (HeartGold's ship, whose sailing scene
is Platinum's boat scene: HeartGold's ScrCmd_723, translated as PlayBoatCutscene), from the bedroom state:

1. **Board at Olivine:** the player talks to the sailor at the gangway in Olivine's port, the ship sails, and the player
   is aboard, on the S.S. Aqua's deck at its door.
2. **Board at Vermilion:** the same at Vermilion's port.
3. **Arrive at Vermilion:** on a trip from Olivine (VAR_HGSS_BOAT_DIRECTION 1), once the ship has arrived
   (FLAG_HGSS_BOAT_ARRIVED, the first trip's scenes seen: VAR_HGSS_SCENE_SS_AQUA 7 and VAR_HGSS_UNK_40DC 1, the
   scene as the player boards), the player talks to the sailor at the ship's door, who steps aside, walks out and
   comes out in Vermilion's port, where the sailor's scene plays.
4. **Arrive at Olivine:** the same on a trip from Vermilion (direction 2), out in Olivine's port.

A part passes when the field is idle again on the map it expects. Results: one line per part, 'ok' or what
went wrong, and a screenshot of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_ferry.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [PART]
PART (a part's name, or part of it, e.g. Olivine) runs only those parts.
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, play_out, var_ids, warp  # noqa: E402

OLIVINE = 'MAP_HEADER_HGSS_SS_AQUA_OLIVINE_PORT_EXTERIOR'
VERMILION = 'MAP_HEADER_HGSS_SS_AQUA_VERMILION_PORT_EXTERIOR'
SHIP = 'MAP_HEADER_HGSS_SS_AQUA_1F'
SOUTH, EAST = 2, 4  # the test warp's facing: enum FaceDirection + 1
ARRIVED = [('FLAG_HGSS_BOAT_ARRIVED', 1), ('VAR_HGSS_SCENE_SS_AQUA', 7), ('VAR_HGSS_UNK_40DC', 1)]
# (part, the map, the tile and facing to start from (next to the sailor to talk to), flags and vars set on the way in,
# whether the player then walks south out of the ship's door, the map the part ends on). Aboard, the boarding scene
# walks the player in from the door.
PARTS = [('board at Olivine', OLIVINE, (26, 22), EAST, [], False, SHIP),
         ('board at Vermilion', VERMILION, (22, 19), EAST, [], False, SHIP),
         ('arrive at Vermilion', SHIP, (24, 16), SOUTH, ARRIVED + [('VAR_HGSS_BOAT_DIRECTION', 1)], True, VERMILION),
         ('arrive at Olivine', SHIP, (24, 16), SOUTH, ARRIVED + [('VAR_HGSS_BOAT_DIRECTION', 2)], True, OLIVINE)]
WALK_OUT = 5  # tiles from the sailor's to the door mat, the press that takes it, and one for a prompt on the way
LIMIT = 6000
SYMBOLS = tuple(TALK_SYMBOLS)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    only = sys.argv[4] if len(sys.argv) > 4 else ''  # a part's name, or part of it, to run only those
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    results = []
    for name, start_map, (x, z), face, setup, walk_out, end_map in PARTS:
        if only not in name:
            continue
        d.load_state(state)
        d.run(30)
        for i, (var, value) in enumerate(setup):
            mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[var])
            mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)
        problem = ''
        arrived, _ = warp(d, sym, names.index(start_map), x, z, 0)
        if arrived == 'ok':  # again on the same map, which turns the player to face (as talk_to_objects.py's arrive)
            arrived, _ = warp(d, sym, names.index(start_map), x, z, face)
        if arrived != 'ok':
            problem = f'warp {arrived}'
        if not problem:
            result, frames = play_out(d, sym, LIMIT, None if walk_out else names.index(end_map))
            for _ in range(WALK_OUT if walk_out and result == 'ok' else 0):
                # a step at a time: a prompt on the way (the test save's Super Repel wearing off) is played out first
                mem.write_short(sym['gSovereignTestScripts'], 0)
                d.press('DOWN', frames=16, after=0)
                result, frames = play_out(d, sym, LIMIT, names.index(end_map), press_a=False)
                if result != 'NOSCRIPT':
                    break
            here = u16(sym['gSovereignTestIdleMapHeaderID'])
            if result != 'ok':
                problem = f'{result} after {frames} frames, on {names[here] if here < len(names) else here}'
            elif here != names.index(end_map):
                problem = f'ended on {names[here] if here < len(names) else here}, not {end_map}'
        d.screenshot().save(os.path.join(out, f'{name.replace(" ", "_")}.png'))
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(results)} parts ok')
    sys.exit(0 if all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
