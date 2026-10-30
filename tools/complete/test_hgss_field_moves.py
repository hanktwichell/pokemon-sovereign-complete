#!/usr/bin/env python3
"""Check that Johto's and Kanto's badges allow the field moves (src/complete_badges.c), in the test build, from the
bedroom state. Platinum's field-move scripts ask Sinnoh's badges (Cut: the Forest Badge...); HeartGold's badge for the
same move does as well now (Cut: the Hive Badge, Rock Smash: the Zephyr Badge, Strength: the Plain Badge). Each part
puts the move's HM in the bag (Sovereign lets the HM in the bag do), gives the player the badges it names
(gCompleteTestHGSSBadges) and talks to a cut tree, a rock or a boulder on a Johto map: with the badge, the script asks
whether to use the move (a yes/no menu, gSovereignTestMenu), which the test answers; without it, it only says what the
move could do.

Results: one line per part, 'ok' or what went wrong, and a screenshot of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_field_moves.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, play_out, warp  # noqa: E402

NORTH, WEST, EAST = 1, 3, 4  # the test warp's facing: enum FaceDirection + 1
ZEPHYR, HIVE, PLAIN = 0, 1, 2  # include/constants/hgss_badges.h
# (part, map, the tile next to the obstacle (from the talk test) and facing it, Johto's badges given, the HM put in the
# bag, whether the script should offer the move)
PARTS = [('Cut, no badge', 'MAP_HEADER_HGSS_ILEX_FOREST', (16, 63), NORTH, 0, 'ITEM_HM01', False),
         ('Cut, Hive Badge', 'MAP_HEADER_HGSS_ILEX_FOREST', (16, 63), NORTH, 1 << HIVE, 'ITEM_HM01', True),
         ('Rock Smash, Zephyr Badge', 'MAP_HEADER_HGSS_BURNED_TOWER_1F', (6, 22), WEST, 1 << ZEPHYR, 'ITEM_HM06', True),
         ('Strength, Plain Badge', 'MAP_HEADER_HGSS_VICTORY_ROAD_1F', (42, 52), EAST, 1 << PLAIN, 'ITEM_HM04', True)]
LIMIT = 3000
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gCompleteTestHGSSBadges', 'gSovereignTestMenu'})


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    items = consts('items.txt')
    d = Driver(rom, state)
    mem = d.emu.memory

    def menus():
        return struct.unpack('<I', bytes(mem.unsigned[sym['gSovereignTestMenu']:sym['gSovereignTestMenu'] + 4]))[0]

    results = []
    for name, map_name, (x, z), face, badges, hm, offered in PARTS:
        d.load_state(state)
        d.run(30)
        mem.write_short(sym['gCompleteTestHGSSBadges'], badges)
        mem.write_short(sym['gSovereignTestBagItem'], items.index(hm))
        problem = ''
        arrived, _ = warp(d, sym, names.index(map_name), x, z, 0)
        if arrived == 'ok':  # again on the same map, which turns the player to face the obstacle
            arrived, _ = warp(d, sym, names.index(map_name), x, z, face)
        if arrived != 'ok':
            problem = f'warp {arrived}'
        if not problem:
            before = menus()
            result, frames = play_out(d, sym, LIMIT)
            asked = menus() > before
            if result != 'ok':
                problem = f'{result} after {frames} frames'
            elif asked != offered:
                problem = 'offered the move' if asked else 'did not offer the move'
        d.screenshot().save(os.path.join(out, f'{name.replace(" ", "_").replace(",", "")}.png'))
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(results)} parts ok')
    sys.exit(0 if all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
