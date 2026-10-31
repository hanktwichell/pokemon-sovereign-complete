#!/usr/bin/env python3
"""Check Fly over Johto and Kanto in the test build: arriving in a town records its Fly point, as in HeartGold
(FLAG_HGSS_SYS_FLYPOINT_*, from its spawn points: src/spawn_locations.c), and Fly's list of the places reached, which
stands in for the Town Map there (CommonScript_CompleteFly), flies to the one chosen.

1. From the bedroom state, the player warps to New Bark Town, Cherrygrove City and Violet City (the test warp, which
   arrives as any warp does): each town's Fly point flag must be set, and a town not visited (Azalea Town) must not.
2. In Violet City, gCompleteTestFly starts the list, as Fly from the party menu does on a Johto or Kanto map. B closes
   it: the player stays in Violet City.
3. Again, and A picks the first place, New Bark Town (the list goes in HeartGold's order and leaves out the town the
   player is in): the player must land in New Bark Town, on its Fly point.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_fly.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from talk_to_objects import DECOMP, HOUR, SYMBOLS, header_names, play_out, symbols, var_ids, warp  # noqa: E402
from test_hgss_togepi import SAVE_PAGES, SAVE_SECTOR, save_entry_index  # noqa: E402

TOWNS = ['NEW_BARK', 'CHERRYGROVE', 'VIOLET']  # visited in this order (their headers are MAP_HEADER_HGSS_<town>)
NOT_VISITED = 'AZALEA'


def fly_points():
    """{town: (Fly point flag number, x, z)} from the generated spawn points (include/data/hgss_spawn_locations.h)."""
    rows = open(os.path.join(DECOMP, 'include', 'data', 'hgss_spawn_locations.h'), encoding='utf-8').read()
    out = {}
    for fly_map, x, z, unlock, point in re.findall(
            r'\{ \w+, \w+, \w+, MAP_HEADER_HGSS_(\w+), (\w+), (\w+), \w+, (\w+), (\w+) \}', rows):
        if int(unlock, 0):
            out[fly_map] = (int(point, 0), int(x, 0), int(z, 0))
    return out


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gCompleteTestFly'))
    variables = var_ids()
    ids = header_names()
    points = fly_points()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def flag(n):
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        addr = base + 20 + u32(page_info + save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS') * 16 + 8)
        addr += (variables['VARS_END'] - variables['VARS_START']) * 2
        return bool(mem.unsigned[addr + n // 8] & (1 << (n % 8)))

    def visited(town):
        return flag(variables['FLAG_HGSS_SYS_FLYPOINT_PALLET'] + points[town][0])

    def where():
        return struct.unpack('<H', bytes(mem.unsigned[sym['gSovereignTestIdleMapHeaderID']:
                                                      sym['gSovereignTestIdleMapHeaderID'] + 2]))[0]

    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)
            d.screenshot().save(os.path.join(out, f'{len(problems)}.png'))

    mem.write_byte(sym['gSovereignTestClock'], HOUR + 1)
    d.run(30)
    for town in TOWNS:
        _, x, z = points[town]
        result, frames = warp(d, sym, ids.index(f'MAP_HEADER_HGSS_{town}'), x, z, 0)  # onto its Fly point
        check(f'arrived in {town} ({result} {frames})', result == 'ok')
        check(f'{town}\'s Fly point is recorded', visited(town))
    check(f'{NOT_VISITED}\'s isn\'t', not visited(NOT_VISITED))

    def open_list():
        mem.write_byte(sym['gCompleteTestFly'], 1)
        d.run(90)  # the list on screen
        d.screenshot().save(os.path.join(out, 'list.png'))

    open_list()
    d.press('B')
    d.run(60)
    before = u32(sym['gSovereignTestIdleFrames'])
    d.run(60)
    idle = u32(sym['gSovereignTestIdleFrames']) - before  # a busy map runs the field every other frame
    check(f'B closes the list and the player stays ({idle} idle frames of 60)',
          idle >= 25 and where() == ids.index('MAP_HEADER_HGSS_VIOLET'))

    open_list()
    d.press('A')
    result, frames = play_out(d, sym, 4000, press_a=False)
    check(f'A flies to New Bark Town ({result} {frames}; on {ids[where()]})',
          result == 'ok' and where() == ids.index('MAP_HEADER_HGSS_NEW_BARK'))
    d.screenshot().save(os.path.join(out, 'landed.png'))

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
