#!/usr/bin/env python3
"""Check Johto's and Kanto's wild Pokémon in the test build: the game makes what Sacred Gold's tables say, by time of
day (step 4; docs/SacredGold.md).

For each Johto or Kanto map with wild Pokémon (encounters_hgss_NNN, res/field/encounters/hgss), this warps onto the
map as tools/test/wild_forms.py does and runs its surveys (gSovereignTestWildSurvey: the game's own encounter code,
SAMPLES times, with no encounter roll and no battle): the grass at 6:00, 12:00 and 22:00 (HeartGold's morning, day and
night; gSovereignTestClock), and surfing and the three rods where the table has them. Each Pokémon made must be one of
that terrain's slots: for the grass, a species of that time of day at its slot's level; on the water, a species of the
terrain within its slot's levels.

From the repo root, with the test build and a bedroom state (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_encounters.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [--part I/N] [MAP_HEADER ...]
Each survey is a line in OUT_DIR/results.txt.
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from check_object_tiles import Maps  # noqa: E402
from talk_to_objects import (DECOMP, SYMBOLS, arrive, event_maps, header_names, parse_args, symbols,  # noqa: E402
                             var_ids, way_in_to)
from wild_forms import MON_SIZE, SURVEY, TERRAINS, events_of, run_survey, species_names, tile_on  # noqa: E402

TIMES = (('morning', 6), ('day', 12), ('night', 22))
CLOCK_HOUR = 0  # offsetof(struct SovereignTestClock, hour): the hour + 1
WATER = (('surf', 'surf'), ('old rod', 'old_rod'), ('good rod', 'good_rod'), ('super rod', 'super_rod'))


def cases():
    """[(header, header ID, its table, (x, z))] for the Johto and Kanto maps with wild Pokémon."""
    maps = Maps(DECOMP)
    ids = header_names()
    text = open(os.path.join(DECOMP, 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    tables = {}
    for name, block in re.findall(r'\[(MAP_HEADER_HGSS_\w+)\] = \{(.*?)\n    \},', text, re.S):
        archive = dict(re.findall(r'\.(\w+) = (\w+)', block)).get('wildEncountersArchiveID', '')
        if archive.startswith('encounters_hgss_'):
            tables[name] = archive
    out = []
    for events, headers_of, cur, grid in event_maps():
        matrix = headers_of[0][1]
        taken = {(o['x'], o['z']) for o in cur.get('object_events', [])}
        for header, _ in headers_of:
            if header not in tables:
                continue
            table = json.load(open(os.path.join(DECOMP, 'res', 'field', 'encounters', 'hgss', tables[header] + '.json')))
            tile = way_in_to(maps, matrix, grid, cur, header, taken, None) or tile_on(maps, matrix, grid, header)
            if tile is not None:
                out.append((header, ids.index(header), table, tile))
    return out


def main():
    from drive import Driver

    rom, state, out, only, part, parts = parse_args(sys.argv[1:])
    sym = symbols(SYMBOLS + ('gSovereignTestWildSurvey',))
    variables = var_ids()
    names = species_names()
    chosen = [(i, c) for i, c in enumerate(cases()) if (not only or c[0] in only) and i % parts == part]
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    survey = sym['gSovereignTestWildSurvey']
    terrain_ids = [t for t, _ in TERRAINS]

    bad = made = 0
    with open(os.path.join(out, 'results.txt'), 'w') as f:
        def say(line):
            print(line, file=f, flush=True)
            print(line, flush=True)

        for index, (header, header_id, table, (x, z)) in chosen:
            result, frames = arrive(d, sym, state, variables, events_of(header), header_id, (x, z), x, z, 1)
            if result != 'ok':
                bad += 1
                say(f'{index} {header}: {result} {frames}')
                continue
            surveys = []
            if table['land']['rate']:
                surveys += [(f'land {time}', 'land', hour, {(s[time], s['level'], s['level'])
                                                            for s in table['land']['slots']}) for time, hour in TIMES]
            surveys += [(terrain, terrain, 12, {(s['species'], s['level_min'], s['level_max'])
                                                for s in table[key]['slots']})
                        for terrain, key in WATER if table[key]['rate']]
            for label, terrain, hour, allowed in surveys:
                mem.write_byte(sym['gSovereignTestClock'] + CLOCK_HOUR, hour + 1)
                d.run(30)  # the game reads the clock every 11 frames
                count = run_survey(d, survey, terrain_ids.index(terrain))
                wrong = []
                for i in range(max(count, 0)):
                    at = survey + SURVEY['mons'] + i * MON_SIZE
                    _, species, form, level = struct.unpack('<IHBB', bytes(mem.unsigned[at:at + MON_SIZE]))
                    if not any(names[species] == s and lo <= level <= hi for s, lo, hi in allowed):
                        wrong.append(f'{names[species]} Lv. {level}')
                made += max(count, 0)
                if wrong or count <= 0:
                    bad += 1
                say(f'{index} {header} {label}: {count} made' + (', NONE' if count == 0 else '') +
                    (', STUCK (the survey never ended)' if count < 0 else '') +
                    (f'; NOT IN THE TABLE: {", ".join(sorted(set(wrong)))}' if wrong else ''))
        say(f'{made} Pokémon made; {bad} problems')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
