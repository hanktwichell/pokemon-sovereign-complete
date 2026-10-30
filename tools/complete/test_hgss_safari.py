#!/usr/bin/env python3
"""Check the Johto Safari Zone in the test build (src/complete_safari.c; docs/Features.md), from the bedroom state:

1. **Entry:** talking to the gate's receptionist and answering yes, the player pays and goes out onto the Safari Zone
   with a Safari game running and 30 Safari Balls (gCompleteTestSafari).
2. **Areas:** the six arranged areas are six different ones of HeartGold's twelve, and each cell of the outside map
   has that area's block.
3. **Encounters:** in each area with tall grass, a survey (wild_forms.py's) of SAMPLES Pokémon, all from that area's
   ten land slots at noon (no objects placed: no bonus Pokémon), at those slots' levels.
4. **Objects:** with Baoba's objects given (the save's unlock level), A facing open ground asks to place one, the
   list menu's first object goes there (saved in its area, and its tile blocks the way), and A facing it takes it
   away again. A screenshot of the placed object, from a tile back, is kept (objects.png).
5. **Leaving:** walking back in through the outside map's door ends the Safari game.
6. **Arrangement:** at Baoba's console in the gate (after his second test), the first cell gets an area that isn't
   arranged, then the second cell gets that one too, which swaps the two.

Results: one line per part, 'ok' or what went wrong, and a screenshot of a part that failed.

From the repo root, with the test build and a bedroom state (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_safari.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from talk_to_objects import (DECOMP, SYMBOLS as TALK_SYMBOLS, arrive, cases, header_names, u32,  # noqa: E402
                             var_ids, warp)
from wild_forms import MON_SIZE, SURVEY, run_survey  # noqa: E402

GATE = ('events_hgss_167', 'obj_D47R0101_counterm_3')  # the receptionist
OUTSIDE = 'MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_EXTERIOR'
INSIDE = 'MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_INTERIOR'
DOOR = (79, 101)  # the outside map's door back in (the receptionist's warp lands at 79, 100)
CONSOLE = (9, 6)  # the gate's area arrangement (a sign, read facing north)
NORTH = 1  # warp's dir: FACE_UP + 1
AREA_TILES, COLS = 32, 3
LAND_DATA = 666 + 652  # HeartGold's first area block, as the engine numbers land data (src/complete_safari.c)
TALL_GRASS = 2
NOON = 1  # the land slots' time: morning, day, night (the harness's clock reads 12:00)
BALLS = 30
SAFARI = {'areas': 0, 'active': 6, 'balls': 8, 'objectCounts': 10, 'save': 16}  # struct CompleteTestSafari
UNLOCK_LEVEL = 6 * (2 + 30 * 4) + 12 + 1  # SafariZoneSave's objectUnlockLevel (include/complete_safari.h)
MAX_UNLOCK_LEVEL = 4
PARTS = 6
SYMBOLS = tuple(set(TALK_SYMBOLS) | set(bm.SYMBOLS) | {
    'gSovereignTestParty', 'gSovereignTestMenu', 'gSovereignTestWildSurvey', 'gSovereignTestPlayerTile',
    'gCompleteTestSafari'})


def land_tiles(area):
    """The area block's 32x32 tile attributes."""
    path = os.path.join(DECOMP, 'res', 'field', 'maps', 'data', f'map_data_{LAND_DATA + area:04d}.bin')
    data = open(path, 'rb').read()
    return struct.unpack('<1024H', data[16:16 + 2048])


def open_ground(tiles):
    """Tiles (x, z) of a block where the player can face north onto open ground with room for a 2x2 object."""
    for z in range(3, 32):
        for x in range(1, 30):
            if all(tiles[(z + dz) * 32 + x + dx] & 0x80ff == 0 for dx in range(-1, 3) for dz in range(-3, 1)):
                yield x, z


def land_slots():
    """{area: [(species, level)] * 10} at noon, from the engine's table."""
    text = open(os.path.join(DECOMP, 'include', 'data', 'complete_safari.h')).read()
    out = {}
    for area, block in re.findall(r'\[SAFARI_ZONE_AREA_(\w+)\] = \{(.*?)\n    \},', text, re.S):
        land = block.split('.base = {', 1)[1].split('},\n            },', 1)[0]
        rows = re.findall(r'\{ ((?:\{ SPECIES_\w+, \d+ \}(?:, )?)+) \}', land)
        out[area] = re.findall(r'(SPECIES_\w+), (\d+)', rows[NOON])
    return out


def main():
    from drive import Driver
    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    species = consts('species.txt')
    headers = header_names()
    variables = var_ids()
    _, _, header, way_in, x, z, face = next(c for c in cases() if c[:2] == GATE)
    area_names = ['PLAINS', 'MEADOW', 'SAVANNAH', 'PEAK', 'ROCKY_BEACH', 'WETLAND', 'FOREST', 'SWAMP', 'MARSHLAND',
                  'WASTELAND', 'MOUNTAIN', 'DESERT']  # enum SafariZoneArea
    slots = land_slots()
    d = Driver(rom, state)
    mem = d.emu.memory
    results = []

    def part(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
        if problem:
            d.screenshot().save(os.path.join(out, f'{name}.png'))
        return not problem

    def safari(field, size=1, index=0):
        at = sym['gCompleteTestSafari'] + SAFARI[field] + index
        return int.from_bytes(bytes(mem.unsigned[at:at + size]), 'little')

    def tile():
        return struct.unpack('<HH', bytes(mem.unsigned[sym['gSovereignTestPlayerTile']:
                                                       sym['gSovereignTestPlayerTile'] + 4]))

    def where():
        return headers[u32(d, sym['gSovereignTestIdleMapHeaderID'])]

    # 1. Entry
    arrived, _ = arrive(d, sym, state, variables, GATE[0], header, way_in, x, z, face)
    problem = '' if arrived == 'ok' else arrived
    if not problem:
        result, _ = talk_and_answer(d, sym, [True])
        if result != 'ok':
            problem = f'the receptionist\'s script: {result}'
        elif where() != OUTSIDE:
            problem = f'on {where()}'
        elif not safari('active') or safari('balls', 2) != BALLS:
            problem = f'Safari game {safari("active")}, {safari("balls", 2)} Balls'
    if not part('entry', problem):
        return finish(results)

    # 2. Areas
    areas = [mem.unsigned[sym['gCompleteTestSafari'] + i] for i in range(6)]
    part('areas', '' if len(set(areas)) == 6 and max(areas) < 12 else f'arranged {areas}')

    # 3. Encounters
    survey = sym['gSovereignTestWildSurvey']
    wrong = []
    for cell, area in enumerate(areas):
        tiles = land_tiles(area)
        grass = [(i % 32, i // 32) for i, t in enumerate(tiles) if t & 0xff == TALL_GRASS and not t & 0x8000]
        if not grass:
            continue
        gx, gz = grass[len(grass) // 2]
        col, row = cell % COLS, cell // COLS
        arrived, _ = warp(d, sym, headers.index(OUTSIDE), AREA_TILES * (col + 1) + gx, AREA_TILES * (row + 1) + gz, 0)
        if arrived != 'ok':
            wrong.append(f'{area_names[area]}: warp {arrived}')
            continue
        allowed = {(species.index(s), int(lv)) for s, lv in slots[area_names[area]]}
        count = run_survey(d, survey, 0)
        seen = [struct.unpack('<IHBB', bytes(mem.unsigned[survey + SURVEY['mons'] + i * MON_SIZE:
                                                          survey + SURVEY['mons'] + (i + 1) * MON_SIZE]))
                for i in range(max(count, 0))]
        off = [(species[s], lv) for _, s, _, lv in seen if (s, lv) not in allowed]
        if count <= 0 or off:
            wrong.append(f'{area_names[area]}: survey {count}, not its own {off[:4]}')
    part('encounters', '; '.join(wrong))

    # 4. Objects
    mem.write_byte(safari('save', 4) + UNLOCK_LEVEL, MAX_UNLOCK_LEVEL)
    spot = next(((cell, x, z) for cell, area in enumerate(areas) for x, z in open_ground(land_tiles(area))), None)
    problem = '' if spot else 'no open ground in any area'
    if spot:
        cell, x, z = spot
        col, row = cell % COLS, cell // COLS
        ox, oz = AREA_TILES * (col + 1) + x, AREA_TILES * (row + 1) + z
        arrived, _ = warp(d, sym, headers.index(OUTSIDE), ox, oz, NORTH)
        result, _ = talk_and_answer(d, sym, [True, 0]) if arrived == 'ok' else (f'warp {arrived}', 0)
        if result != 'ok' or safari('objectCounts', index=cell) != 1:
            problem = f'placing: {result}, {safari("objectCounts", index=cell)} objects in {area_names[areas[cell]]}'
        else:
            at = tile()
            d.press('UP', frames=20, after=10)
            if tile() != at:
                problem = f'the object\'s tile let the player through ({at} to {tile()})'
            else:  # from a tile back for the screenshot (the player's sprite hides the tile in front), and back
                warp(d, sym, headers.index(OUTSIDE), ox, oz + 1, NORTH)
                d.screenshot().save(os.path.join(out, 'objects.png'))
                warp(d, sym, headers.index(OUTSIDE), ox, oz, NORTH)
            if not problem and tile() != at:
                problem = f'back at the object: on {tile()}, not {at}'
            elif not problem:
                result, _ = talk_and_answer(d, sym, [True])
                if result != 'ok' or safari('objectCounts', index=cell) != 0:
                    problem = f'taking it away: {result}, {safari("objectCounts", index=cell)} objects left'
    part('objects', problem)

    # 5. Leaving
    arrived, _ = warp(d, sym, headers.index(OUTSIDE), DOOR[0], DOOR[1] - 1, 0)
    if arrived == 'ok':
        d.press('DOWN', frames=20, after=0)
        result, _ = talk_and_answer(d, sym, [], press_a=False)
    part('leaving', f'warp {arrived}' if arrived != 'ok' else '' if where() == INSIDE and not safari('active')
         else f'on {where()}, Safari game {safari("active")}')

    # 6. Arrangement: Baoba's console works once he has given his second test (VAR 4057 at 5)
    before = [safari('areas', index=i) for i in range(6)]
    new = next(a for a in range(12) if a not in before)
    mem.write_short(sym['gSovereignTestVar'] + 16, variables['VAR_HGSS_UNK_4057'])
    mem.write_short(sym['gSovereignTestVar'] + 18, 5)
    arrived, _ = warp(d, sym, headers.index(INSIDE), CONSOLE[0], CONSOLE[1] + 1, NORTH)
    result, _ = talk_and_answer(d, sym, [0, new, 1, new, None]) if arrived == 'ok' else (f'warp {arrived}', 0)
    after = [safari('areas', index=i) for i in range(6)]
    expected = [before[1], new] + before[2:]
    part('arrangement', f'{result}' if result != 'ok' else '' if after == expected
         else f'{[area_names[a] for a in after]}, not {[area_names[a] for a in expected]}')
    finish(results)


def finish(results):
    print(f'{sum(r.endswith(": ok") for r in results)} of {PARTS} parts ok')
    sys.exit(0 if len(results) == PARTS and all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
