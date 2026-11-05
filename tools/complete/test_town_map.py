#!/usr/bin/env python3
"""Check the three-region Town Map (src/applications/town_map/complete_town_map.c) and Fly on it, in the test build,
from the bedroom state, as a player would: Fly from the party menu (the start menu, POKéMON, the lead, FLY; the test
save's HM02 in the bag offers it), with every badge (gSovereignTestBadges, gCompleteTestHGSSBadges).

1. The player visits New Bark Town, Cherrygrove City and Violet City (Johto), Vermilion City (Kanto) and the Indigo
   Plateau (between them) with the test warp, each onto its Fly point, and ends in Violet City.
2. Fly in Violet City opens the Town Map on Johto and Kanto, its cursor on Violet City (gCompleteTownMap: the view and
   the cursor's cell on HeartGold's map), with Johto's Fly points and the Indigo Plateau's, not Vermilion's.
3. The cursor walks to Vermilion City: A doesn't fly there (Kanto, from Johto); then to the Indigo Plateau, and A flies
   there.
4. From the Indigo Plateau, Fly to Vermilion City (Kanto's) does go.
5. From Vermilion City: R turns the view to Sinnoh (the cursor at Canalave City, the ferry's harbour); A doesn't fly;
   LEFT off Sinnoh's west edge goes back over to Johto and Kanto, onto a place (not the sea); B closes the map and the
   player stays.
6. The player warps to Twinleaf Town and Jubilife City (Sinnoh). Fly opens on Sinnoh, as Platinum's map, the cursor on
   Jubilife City; L turns the view to Johto and Kanto, the cursor on Goldenrod City, where no Fly point shows (none
   from Sinnoh), and A doesn't fly; the cursor walks to the Battle Frontier (a place off the overworld, named from
   its map's world map position);
   R back, the cursor to Twinleaf Town, and A flies there.

Results: a line per check, screenshots of each view in OUT_DIR (both screens), and the count of problems.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_town_map.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import json
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from talk_to_objects import DECOMP, HOUR, SYMBOLS, header_names, play_out, symbols, warp  # noqa: E402
from test_hgss_fly import fly_points, spawn_ids  # noqa: E402

HGSS_TOWNS = ['NEW_BARK', 'CHERRYGROVE', 'VERMILION', 'INDIGO_PLATEAU', 'VIOLET']  # visited in this order
SINNOH_TOWNS = [('TWINLEAF_TOWN', 0x74, 0x376), ('JUBILIFE_CITY', 0xB4, 0x309)]  # Platinum's Fly points
FRONTIER = (7, 7)  # the Battle Frontier's cell on HeartGold's map (its world map position; sea on the overworld)
CANALAVE = (1, 22)  # Sinnoh's cursor's first place from Johto or Kanto (src/applications/town_map/context.c)
SINNOH, HGSS = 0, 1  # gCompleteTownMap.viewRegion
# gCompleteTownMap: playerRegion, playerX, playerY, viewRegion, viewX, viewY, (padding), flyPoints
INFO = struct.Struct('<6B2xI')
FLY_FRAMES = 4000
SPAWN_FIRST = 21  # SPAWN_HGSS_FIRST


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTownMap', 'gSovereignTestBadges', 'gCompleteTestHGSSBadges'))
    spawns = spawn_ids()
    ids = header_names()
    points = fly_points()
    matrix = json.load(open(os.path.join(DECOMP, 'res', 'field', 'matrices', 'map_matrix_hgss_0000.json')))['headers']
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
        return struct.unpack('<H', bytes(mem.unsigned[sym['gSovereignTestIdleMapHeaderID']:
                                                      sym['gSovereignTestIdleMapHeaderID'] + 2]))[0]

    def cell(town):
        _, x, z = points[town]
        return x // 32, z // 32

    def points_shown(fly):
        """The towns whose HeartGold Fly point the map shows (gCompleteTownMap.flyPoints)"""
        return {name for name, n in spawns.items()
                if name not in ('FIRST', 'COUNT') and n >= SPAWN_FIRST and fly & 1 << (n - SPAWN_FIRST)}

    def shot(name):
        d.screenshot().save(os.path.join(out, name + '.png'))

    menu_opened = [False]

    def open_fly():
        """The start menu, POKéMON, the lead, FLY: the Town Map. The start menu keeps its cursor on POKéMON after the
        first time."""
        at = sym['gCompleteTownMap']
        mem.write_byte(at + 3, 0xFF)  # viewRegion: set again as the map starts
        d.press('X', after=40)
        if not menu_opened[0]:
            d.press('DOWN', after=20)
            menu_opened[0] = True
        d.press('A', after=90)  # the party
        d.press('A', after=40)  # the lead's menu: SUMMARY first, then its field moves
        d.press('DOWN', after=20)
        d.press('A', after=150)  # FLY: the Town Map, faded in
        return info()[3] != 0xFF

    def walk_to(x, y):
        """The cursor a step at a time to cell (x, y) of the region in view."""
        for _ in range(80):
            _, _, _, _, cx, cy, _ = info()
            if (cx, cy) == (x, y):
                return True
            key = 'RIGHT' if cx < x else 'LEFT' if cx > x else 'DOWN' if cy < y else 'UP'
            d.press(key, frames=4, after=14)
        return False

    def fly_here(town_header):
        d.press('A', frames=4, after=0)
        result, frames = play_out(d, sym, FLY_FRAMES, press_a=False)
        return result, frames, where() == ids.index(town_header)

    def no_fly():
        """A on a place Fly can't go: the map stays open (the view still noted after a second)."""
        d.press('A', frames=4, after=60)
        mem.write_byte(sym['gCompleteTownMap'] + 3, 0xFF)
        d.press('UP', frames=4, after=20)  # any input notes the view again while the map runs
        d.press('DOWN', frames=4, after=20)
        return info()[3] != 0xFF

    def close_map(stay_header):
        d.press('B', after=120)
        result, frames = play_out(d, sym, 600, press_a=False)
        d.press('B', after=60)  # the party menu, if it comes back, and the start menu
        d.press('B', after=60)
        return where() == ids.index(stay_header)

    # 1. The places visited, every badge
    mem.write_byte(sym['gSovereignTestClock'], HOUR + 1)
    mem.write_byte(sym['gSovereignTestBadges'], 0xFF)
    mem.write_short(sym['gCompleteTestHGSSBadges'], 0xFFFF)
    d.run(30)
    for town in HGSS_TOWNS:
        _, x, z = points[town]
        result, frames = warp(d, sym, ids.index(f'MAP_HEADER_HGSS_{town}'), x, z, 0)
        check(f'arrived in {town} ({result} {frames})', result == 'ok')

    # 2. Fly in Violet City
    check('Fly opens the Town Map in Violet City', open_fly())
    player_region, px, py, view, vx, vy, fly = info()
    shot('johto')
    check(f'it opens on Johto and Kanto, the cursor on Violet City (view {view}, cell {vx, vy}, '
          f'Violet {cell("VIOLET")})', view == HGSS and (vx, vy) == cell('VIOLET'))
    shown = points_shown(fly)
    check(f'Fly points shown: {sorted(shown)}', {'NEW_BARK', 'CHERRYGROVE', 'VIOLET', 'INDIGO'} <= shown
          and 'VERMILION' not in shown)

    # 3. Not to Vermilion City; to the Indigo Plateau
    check('the cursor walks to Vermilion City', walk_to(*cell('VERMILION')))
    shot('kanto_from_johto')
    check('A on Vermilion City from Johto doesn\'t fly', no_fly())
    check('the cursor walks to the Indigo Plateau', walk_to(*cell('INDIGO_PLATEAU')))
    shot('indigo')
    result, frames, there = fly_here('MAP_HEADER_HGSS_INDIGO_PLATEAU')
    check(f'A flies to the Indigo Plateau ({result} {frames}; on {ids[where()]})', there)
    shot('landed_indigo')

    # 4. From the Indigo Plateau to Vermilion City
    check('Fly opens the Town Map at the Indigo Plateau', open_fly())
    shown = points_shown(info()[6])
    check(f'Fly points shown there: {sorted(shown)}', 'VERMILION' in shown)
    check('the cursor walks to Vermilion City', walk_to(*cell('VERMILION')))
    shot('vermilion')
    result, frames, there = fly_here('MAP_HEADER_HGSS_VERMILION')
    check(f'A flies to Vermilion City ({result} {frames}; on {ids[where()]})', there)

    # 5. Over to Sinnoh and back, from Kanto
    check('Fly opens the Town Map in Vermilion City', open_fly())
    shown = points_shown(info()[6])
    check(f'Kanto\'s Fly points: {sorted(shown)}', 'VERMILION' in shown and 'CHERRYGROVE' not in shown)
    d.press('R', after=60)
    view, vx, vy = info()[3:6]
    shot('sinnoh_from_kanto')
    check(f'R turns the view to Sinnoh, the cursor at Canalave City (view {view}, cell {vx, vy})',
          view == SINNOH and (vx, vy) == CANALAVE)
    check('A in Sinnoh from Kanto doesn\'t fly', no_fly())
    walk_to(1, CANALAVE[1])
    d.press('LEFT', frames=4, after=60)
    view, vx, vy = info()[3:6]
    shot('crossed_to_johto')
    check(f'LEFT off Sinnoh\'s west edge goes over to a place in Johto and Kanto (view {view}, cell {vx, vy}: '
          f'{matrix[vy][vx] if view == HGSS else None})', view == HGSS and matrix[vy][vx] != 'MAP_HEADER_HGSS_EVERYWHERE')
    check('B closes the map; the player stays in Vermilion City', close_map('MAP_HEADER_HGSS_VERMILION'))

    # 6. From Sinnoh
    for name, x, z in SINNOH_TOWNS:
        result, frames = warp(d, sym, ids.index(f'MAP_HEADER_{name}'), x, z, 0)
        check(f'arrived in {name} ({result} {frames})', result == 'ok')
    check('Fly opens the Town Map in Jubilife City', open_fly())
    view, vx, vy, fly = info()[3], info()[4], info()[5], info()[6]
    shot('sinnoh')
    check(f'it opens on Sinnoh, the cursor on Jubilife City (view {view}, cell {vx, vy})',
          view == SINNOH and (vx, vy) == (0xB4 // 32, 0x309 // 32))
    check(f'no HeartGold Fly point from Sinnoh (points {fly:#x})', fly == 0)
    d.press('L', after=60)
    view, vx, vy = info()[3:6]
    shot('johto_from_sinnoh')
    check(f'L turns the view to Johto and Kanto, the cursor on Goldenrod City (view {view}, cell {vx, vy})',
          view == HGSS and (vx, vy) == cell('GOLDENROD'))
    check('A in Johto from Sinnoh doesn\'t fly', no_fly())
    check('the cursor walks to the Battle Frontier (off the overworld: its name from its world map place)',
          walk_to(*FRONTIER))
    shot('battle_frontier')
    d.press('R', after=60)
    check('R turns it back to Sinnoh', info()[3] == SINNOH)
    check('the cursor walks to Twinleaf Town', walk_to(0x74 // 32, 0x376 // 32))
    result, frames, there = fly_here('MAP_HEADER_TWINLEAF_TOWN')
    check(f'A flies to Twinleaf Town ({result} {frames}; on {ids[where()]})', there)
    shot('landed_twinleaf')

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
