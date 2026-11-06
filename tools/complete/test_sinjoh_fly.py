#!/usr/bin/env python3
"""Fly to and from the Sinjoh Ruins (the owner's call, Nov 6, 2026; src/complete_map_info.c, SPAWN_HGSS_SINJOH_RUINS),
in the test build, from the bedroom state, as a player would: Fly from the party menu (the start menu, POKéMON, the
lead, FLY), with every badge.

1. Before the player has been there, the Ruins aren't a Fly point from Johto.
2. The player visits Violet City, Vermilion City, the Indigo Plateau, Jubilife City and the Sinjoh Ruins with the test
   warp (each onto its Fly point; the Ruins' unlocks as the player arrives).
3. From Jubilife City (Sinnoh), the Town Map's Johto and Kanto view shows the Ruins' Fly point (and no other), and A
   on it flies there.
4. From the Ruins, the map shows Johto's Fly points and the Indigo Plateau's, not Kanto's; R turns it to Sinnoh, and A
   on Jubilife City flies there.
5. From Vermilion City (Kanto), the Ruins aren't a Fly point; from the Indigo Plateau they are.
6. From Violet City (Johto), A on the Ruins flies there.

Results: a line per check, screenshots in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_sinjoh_fly.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from talk_to_objects import HOUR, SYMBOLS, header_names, play_out, symbols, warp  # noqa: E402
from hgss_fly_points import fly_points, spawn_ids  # noqa: E402
from test_town_map import FLY_FRAMES, HGSS, INFO, SINNOH, SPAWN_FIRST  # noqa: E402

SINJOH = 'MAP_HEADER_HGSS_SINJOH_RUINS_EXTERIOR'
SINJOH_CELL = (20, 1)  # its place on HeartGold's map (its header's world map position)
JUBILIFE = ('MAP_HEADER_JUBILIFE_CITY', 0xB4, 0x309)  # Platinum's Fly point


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTownMap', 'gSovereignTestBadges', 'gCompleteTestHGSSBadges'))
    spawns = spawn_ids()
    ids = header_names()
    points = fly_points()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)
            d.screenshot().save(os.path.join(out, f'problem_{len(problems)}.png'))

    def info():
        at = sym['gCompleteTownMap']
        return INFO.unpack(bytes(mem.unsigned[at:at + INFO.size]))

    def where():
        at = sym['gSovereignTestIdleMapHeaderID']
        return struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]

    def cell(town):
        _, x, z = points[town]
        return x // 32, z // 32

    def shown(fly):
        return {name for name, n in spawns.items()
                if name not in ('FIRST', 'COUNT') and n >= SPAWN_FIRST and fly & 1 << (n - SPAWN_FIRST)}

    def shot(name):
        d.screenshot().save(os.path.join(out, name + '.png'))

    menu_opened = [False]

    def open_fly():
        mem.write_byte(sym['gCompleteTownMap'] + 3, 0xFF)  # viewRegion: set again as the map starts
        d.press('X', after=40)
        if not menu_opened[0]:
            d.press('DOWN', after=20)
            menu_opened[0] = True
        d.press('A', after=90)  # the party
        d.press('A', after=40)  # the lead's menu
        d.press('DOWN', after=20)
        d.press('A', after=150)  # FLY: the Town Map
        return info()[3] != 0xFF

    def walk_to(x, y):
        for _ in range(80):
            cx, cy = info()[4:6]
            if (cx, cy) == (x, y):
                return True
            key = 'RIGHT' if cx < x else 'LEFT' if cx > x else 'DOWN' if cy < y else 'UP'
            d.press(key, frames=4, after=14)
        return False

    def fly_here(header):
        d.press('A', frames=4, after=0)
        result, frames = play_out(d, sym, FLY_FRAMES, press_a=False)
        return result, frames, where() == ids.index(header)

    def close_map():
        d.press('B', after=120)
        play_out(d, sym, 600, press_a=False)
        d.press('B', after=60)
        d.press('B', after=60)

    def go(header, x, z):
        result, frames = warp(d, sym, ids.index(header), x, z, 0)
        check(f'arrived at {header[11:]} ({result} {frames})', result == 'ok')

    mem.write_byte(sym['gSovereignTestClock'], HOUR + 1)
    mem.write_byte(sym['gSovereignTestBadges'], 0xFF)
    mem.write_short(sym['gCompleteTestHGSSBadges'], 0xFFFF)
    d.run(30)

    # 1. Not a Fly point before the player has been there
    _, x, z = points['VIOLET']
    go('MAP_HEADER_HGSS_VIOLET', x, z)
    check('Fly opens the Town Map in Violet City', open_fly())
    check(f'no Sinjoh Ruins before a visit ({sorted(shown(info()[6]))})', 'SINJOH_RUINS' not in shown(info()[6]))
    close_map()

    # 2. The places visited
    for town in ('VERMILION', 'INDIGO_PLATEAU'):
        _, x, z = points[town]
        go(f'MAP_HEADER_HGSS_{town}', x, z)
    go(*JUBILIFE)
    _, x, z = points['SINJOH_RUINS_EXTERIOR']
    go(SINJOH, x, z)
    shot('sinjoh_arrived')
    go(*JUBILIFE)

    # 3. From Jubilife City to the Ruins
    check('Fly opens the Town Map in Jubilife City', open_fly())
    fly = info()[6]
    check(f'from Sinnoh, the Ruins and no other HeartGold Fly point ({sorted(shown(fly))})',
          shown(fly) == {'SINJOH_RUINS'})
    d.press('L', after=60)
    check('L turns the view to Johto and Kanto', info()[3] == HGSS)
    check('the cursor walks to the Sinjoh Ruins', walk_to(*SINJOH_CELL))
    shot('sinjoh_from_sinnoh')
    result, frames, there = fly_here(SINJOH)
    check(f'A flies to the Sinjoh Ruins ({result} {frames}; on {ids[where()]})', there)
    shot('landed_sinjoh')

    # 4. From the Ruins to Johto's points and Sinnoh's
    check('Fly opens the Town Map at the Sinjoh Ruins', open_fly())
    fly = info()[6]
    check(f'from the Ruins: Violet City and the Indigo Plateau, not Vermilion City ({sorted(shown(fly))})',
          {'VIOLET', 'INDIGO'} <= shown(fly) and 'VERMILION' not in shown(fly))
    shot('map_from_sinjoh')
    d.press('R', after=60)
    check('R turns the view to Sinnoh', info()[3] == SINNOH)
    check('the cursor walks to Jubilife City', walk_to(JUBILIFE[1] // 32, JUBILIFE[2] // 32))
    shot('jubilife_from_sinjoh')
    result, frames, there = fly_here(JUBILIFE[0])
    check(f'A flies to Jubilife City ({result} {frames}; on {ids[where()]})', there)

    # 5. Not from Kanto; from the Indigo Plateau
    _, x, z = points['VERMILION']
    go('MAP_HEADER_HGSS_VERMILION', x, z)
    check('Fly opens the Town Map in Vermilion City', open_fly())
    check(f'from Kanto, no Sinjoh Ruins ({sorted(shown(info()[6]))})', 'SINJOH_RUINS' not in shown(info()[6]))
    close_map()
    _, x, z = points['INDIGO_PLATEAU']
    go('MAP_HEADER_HGSS_INDIGO_PLATEAU', x, z)
    check('Fly opens the Town Map at the Indigo Plateau', open_fly())
    check(f'from the Indigo Plateau, the Sinjoh Ruins ({sorted(shown(info()[6]))})', 'SINJOH_RUINS' in shown(info()[6]))
    close_map()

    # 6. From Johto to the Ruins
    _, x, z = points['VIOLET']
    go('MAP_HEADER_HGSS_VIOLET', x, z)
    check('Fly opens the Town Map in Violet City', open_fly())
    check('the cursor walks to the Sinjoh Ruins', walk_to(*SINJOH_CELL))
    result, frames, there = fly_here(SINJOH)
    check(f'A flies from Violet City to the Sinjoh Ruins ({result} {frames}; on {ids[where()]})', there)

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
