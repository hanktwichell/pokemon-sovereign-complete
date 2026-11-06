#!/usr/bin/env python3
"""The two Pal Parks (tools/complete/gen_pal_parks.py, data/complete/pal_parks.yaml), in the test build, from the
bedroom state.

Kanto's park, as a player visits it: talking to Fuchsia's receptionist and saying yes walks the player into the park
(HeartGold's Pal Park), with no Catching Show; stepping into the gate and saying yes takes them back to the lobby,
where they walk out from the counter; saying no to the receptionist keeps them in the lobby.

Then each quadrant of both parks: the test warps onto a walkable tile in it and surveys its encounters
(gSovereignTestWildSurvey, as tools/test/wild_forms.py does): the tall grass where the zone has a grass list, surfing
and the Good Rod where it has a water list. Each Pokémon must be one of the zone's, in its form, at a level in its
range (moved up by Sinnoh's levels, data/complete/sinnoh.yaml, in Sinnoh's park). A zone with no list for a terrain
isn't surveyed for it (it has the park table's own Pokémon, as Sovereign's park does).

Results: a line per check, the forms seen in each park, and screenshots in OUT_DIR.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pal_parks.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import collections
import os
import struct
import sys

import yaml

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, os.path.join(HERE, '..', 'engine'))
import gen_forms  # noqa: E402
from check_object_tiles import Maps  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, arrive, event_maps, header_names, play_out, symbols, var_ids, warp  # noqa: E402
from test_hgss_togepi import SAVE_PAGES, SAVE_SECTOR, save_entry_index  # noqa: E402
import wild_forms  # noqa: E402
from wild_forms import MON_SIZE, SURVEY, TERRAINS, events_of, quadrant_tiles, run_survey, species_names  # noqa: E402

# A park's encounter takes about 12 frames here, so a survey of the most Pokémon it records (SOVEREIGN_TEST_SURVEY_MAX)
# needs more than wild_forms.py's wait
wild_forms.SAMPLES = 64
wild_forms.SURVEY_FRAMES = 2400

ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
LOBBY = 'MAP_HEADER_HGSS_FUCHSIA_PAL_PARK_ENTRANCE'
KANTO_PARK = 'MAP_HEADER_HGSS_PAL_PARK'
COUNTER = (7, 12)  # the tile before the receptionist (7, 11)
NORTH = 1  # the test warp's facing: enum FaceDirection + 1
PARK_STATE = 'VAR_HGSS_UNK_4124'  # 0 in the lobby, 1 in the park, 2 on the way out
LIMIT = 6000
QUADRANTS = ('north-west', 'north-east', 'south-west', 'south-east')


def sinnoh_level(level):
    """CompleteSinnoh_Level (src/complete_sinnoh.c) from data/complete/sinnoh.yaml's points."""
    points = yaml.safe_load(open(os.path.join(ROOT, 'data', 'complete', 'sinnoh.yaml'), encoding='utf-8'))['levels']
    for (a, b), (c, e) in zip(points, points[1:]):
        if a <= level <= c:
            return b + ((level - a) * (e - b) * 2 + (c - a)) // ((c - a) * 2)
    return min(level, 100)


def parks():
    """[(park name, map header, [(zone name, {terrain: {(species, form): (min, max)}})])], from the YAML."""
    forms = {f['ident']: f for f in gen_forms.load_rows() if 'ident' in f}
    data = yaml.safe_load(open(os.path.join(ROOT, 'data', 'complete', 'pal_parks.yaml'), encoding='utf-8'))
    out = []
    for park in data['parks']:
        moved = sinnoh_level if park['map'] == 'MAP_HEADER_PAL_PARK' else (lambda level: level)
        zones = []
        for zone in park['zones']:
            lists = {}
            for terrain, survey in (('grass', ('land',)), ('water', ('surf', 'good rod'))):
                entries = {(forms[i]['species'], int(forms[i]['number'])): (moved(lo), moved(hi))
                           for i, _, lo, hi in zone[terrain] or []}
                for t in survey if entries else ():
                    lists[t] = entries
            zones.append((zone['name'], lists))
        out.append((park['name'], park['map'], zones))
    return out


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestWildSurvey', 'gSovereignTestMenu', 'sSaveDataPtr'))
    names = header_names()
    variables = var_ids()
    species = species_names()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    results = []

    def say(line):
        results.append(line)
        print(line, flush=True)

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def read_var(name):
        base = struct.unpack('<I', bytes(mem.unsigned[sym['sSaveDataPtr']:sym['sSaveDataPtr'] + 4]))[0]
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        at = page_info + save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS') * 16 + 8
        vars_flags = base + 20 + struct.unpack('<I', bytes(mem.unsigned[at:at + 4]))[0]
        return u16(vars_flags + (variables[name] - variables['VARS_START']) * 2)

    def here():
        return names[u16(sym['gSovereignTestIdleMapHeaderID'])]

    def at_counter():
        d.load_state(state)
        d.run(30)
        arrived, _ = warp(d, sym, names.index(LOBBY), *COUNTER, 0)
        if arrived == 'ok':  # again on the same map, which turns the player to face
            arrived, _ = warp(d, sym, names.index(LOBBY), *COUNTER, NORTH)
        return arrived

    # Kanto's park: saying no, then in and back out through the gate
    arrived = at_counter()
    problem = '' if arrived == 'ok' else f'warp {arrived}'
    if not problem:
        d.press('A', frames=4, after=60)  # the welcome's first page, then its others
        d.screenshot().save(os.path.join(out, 'kanto_welcome_1.png'))
        for page in (2, 3):
            d.press('A', frames=4, after=50)
            d.screenshot().save(os.path.join(out, f'kanto_welcome_{page}.png'))
        result, frames = talk_and_answer(d, sym, [False], LIMIT, press_a=False)
        if result != 'ok':
            problem = f'{result} after {frames} frames'
        elif here() != LOBBY or read_var(PARK_STATE) != 0:
            problem = f'on {here()}, {PARK_STATE} {read_var(PARK_STATE)}'
    d.screenshot().save(os.path.join(out, 'kanto_no.png'))
    say(f'Kanto: the receptionist, saying no: {problem or "ok"}')

    arrived = at_counter()
    problem = '' if arrived == 'ok' else f'warp {arrived}'
    if not problem:
        result, frames = talk_and_answer(d, sym, [True], LIMIT)
        if result != 'ok':
            problem = f'{result} after {frames} frames'
        elif here() != KANTO_PARK or read_var(PARK_STATE) != 1:
            problem = f'on {here()}, {PARK_STATE} {read_var(PARK_STATE)}'
    d.screenshot().save(os.path.join(out, 'kanto_in.png'))
    say(f'Kanto: walking in: {problem or "ok"}')
    if not problem:  # the gate's step (z 48) asks; yes, and the lobby's frame script walks the player out
        mem.write_short(sym['gSovereignTestScripts'], 0)
        d.press('DOWN', frames=16, after=0)
        result, frames = talk_and_answer(d, sym, [True], LIMIT, press_a=False)
        for _ in range(30):
            if here() == LOBBY and read_var(PARK_STATE) == 0:
                break
            d.run(20)
        if result != 'ok':
            problem = f'{result} after {frames} frames'
        elif here() != LOBBY or read_var(PARK_STATE) != 0:
            problem = f'on {here()}, {PARK_STATE} {read_var(PARK_STATE)}'
        d.screenshot().save(os.path.join(out, 'kanto_out.png'))
        say(f'Kanto: leaving by the gate: {problem or "ok"}')

    def visiting(header):
        """In Sinnoh's park, VAR_PAL_PARK_STATE 3, as its lobby leaves it: at 0, Platinum's Catching Show would start
        (gSovereignTestVar[2]; arrive uses [0] and [1])."""
        if header == 'MAP_HEADER_PAL_PARK':
            mem.write_short(sym['gSovereignTestVar'] + 8, variables['VAR_PAL_PARK_STATE'])
            mem.write_short(sym['gSovereignTestVar'] + 10, 3)

    # Each quadrant of both parks
    maps = Maps(DECOMP)
    grids = {h: (headers_of[0][1], grid) for _, headers_of, _, grid in event_maps() for h, _ in headers_of}
    survey = sym['gSovereignTestWildSurvey']
    terrain_index = [t for t, _ in TERRAINS]
    for park, header, zones in parks():
        matrix, grid = grids[header]
        seen = collections.Counter()
        for (zone, lists), (x, z), quadrant in zip(zones, quadrant_tiles(maps, matrix, grid['maps']), QUADRANTS):
            where = f'{park} {quadrant} ({zone}, {x}, {z})'
            result, frames = arrive(d, sym, state, variables, events_of(header), names.index(header), (x, z), x, z, 1,
                                    setup=lambda: visiting(header))
            if result != 'ok':
                say(f'{where}: {result} after {frames} frames')
                continue
            d.screenshot().save(os.path.join(out, f'{park.lower()}_{quadrant}.png'))
            for terrain, allowed in lists.items():
                count = run_survey(d, survey, terrain_index.index(terrain))
                wrong = []
                for i in range(max(count, 0)):
                    at = survey + SURVEY['mons'] + i * MON_SIZE
                    _, s, form, level = struct.unpack('<IHBB', bytes(mem.unsigned[at:at + MON_SIZE]))
                    key = (species[s], form)
                    seen[key] += 1
                    if key not in allowed:
                        wrong.append(f'{species[s]} form {form}: not in the zone')
                    elif not allowed[key][0] <= level <= allowed[key][1]:
                        wrong.append(f'{species[s]} form {form} at Lv. {level}, not {allowed[key][0]}-{allowed[key][1]}')
                kinds = len({k for k in allowed if seen[k]})
                say(f'{where} {terrain}: {count} made, {kinds} of its {len(allowed)} kinds' +
                    (' NONE' if count == 0 else ' STUCK' if count < 0 else '') +
                    ''.join(f'\n    WRONG {w}' for w in sorted(set(wrong))))
        say(f'Seen in {park}\'s park: ' + ', '.join(f'{s[8:].lower()}/{f} {n}' for (s, f), n in sorted(seen.items())))

    bad = [r for r in results if 'WRONG' in r or 'NONE' in r or 'STUCK' in r or r.startswith('Kanto:') and
           not r.endswith(': ok') or ' after ' in r]
    say(f'{len(bad)} problems')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
