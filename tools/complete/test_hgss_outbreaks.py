#!/usr/bin/env python3
"""Check HeartGold's mass outbreaks and night fishing in Johto and Kanto (src/complete_encounters.c) in the test build,
from the bedroom state. Each part comes onto a map as tools/complete/test_hgss_encounters.py does and runs its survey
(the game's own encounter code, wild_forms.SAMPLES times, gSovereignTestWildSurvey). Each map's outbreak and night
species are its table's (res/field/encounters/hgss, HeartGold's own: Yanma on Route 35):

1. **Off:** Route 35's grass with outbreaks off (a new game's): its outbreak species only as one of its usual Pokémon,
   in fewer than a quarter of the encounters.
2. **Route 35:** outbreaks on (VAR_COMPLETE_OUTBREAKS, as Oak's National Pokédex sets it) and today's outbreak there
   (gCompleteTestOutbreakMap): the species in the first two grass slots, so in at least a quarter of the encounters
   (about two in five).
3. **Elsewhere:** outbreaks on, today's outbreak on Route 1: Route 35 as usual, the species under a quarter.
4. **Route 27's water:** outbreaks on, today's outbreak there: its species in the first surfing slot, at least a
   quarter.
5. **Violet City's rods:** outbreaks on, today's outbreak there (a fishing one): the Super Rod's every slot has its
   species.
6. **Violet City, another day:** today's outbreak on Route 1: the Super Rod as usual, without it.
7. **Night fishing:** Cherrygrove City's Super Rod at 10 p.m. (gSovereignTestClock): the night species in its second
   slot, at least a quarter.
8. **By day:** the same at 1 p.m.: none.

Results: a line per part.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_outbreaks.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from talk_to_objects import SYMBOLS, arrive, symbols, var_ids  # noqa: E402
from test_hgss_encounters import cases  # noqa: E402
from wild_forms import MON_SIZE, SURVEY, TERRAINS, events_of, run_survey, species_names  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
ROUTE_35, ROUTE_27 = 'MAP_HEADER_HGSS_ROUTE_35', 'MAP_HEADER_HGSS_ROUTE_27'
VIOLET, CHERRYGROVE, ROUTE_1 = 'MAP_HEADER_HGSS_VIOLET', 'MAP_HEADER_HGSS_CHERRYGROVE', 'MAP_HEADER_HGSS_ROUTE_1'
PARTS = [  # (name, map, terrain, outbreaks on, today's outbreak map, the table's species, whether it should appear,
    #         the hour or None)
    ('off', ROUTE_35, 'land', 0, ROUTE_35, 'land', False, None),
    ('Route 35', ROUTE_35, 'land', 1, ROUTE_35, 'land', True, None),
    ('elsewhere', ROUTE_35, 'land', 1, ROUTE_1, 'land', False, None),
    ('Route 27 water', ROUTE_27, 'surf', 1, ROUTE_27, 'surf', True, None),
    ('Violet City rods', VIOLET, 'super rod', 1, VIOLET, 'fishing', True, 13),
    ('Violet City, another day', VIOLET, 'super rod', 1, ROUTE_1, 'fishing', False, 13),
    ('night fishing', CHERRYGROVE, 'super rod', 0, ROUTE_1, 'night_fishing', True, 22),
    ('by day', CHERRYGROVE, 'super rod', 0, ROUTE_1, 'night_fishing', False, 13),
]


def outbreak_entries():
    """{map header: its entry in sOutbreakMaps + 1, as gCompleteTestOutbreakMap takes it}"""
    text = open(os.path.join(DECOMP, 'src', 'complete_encounters.c')).read()
    body = text[text.index('sOutbreakMaps[] = {'):]
    body = body[:body.index('};')]
    return {name: i + 1 for i, name in enumerate(re.findall(r'\{ (MAP_HEADER_\w+), OUTBREAK_\w+ \}', body))}


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestWildSurvey', 'gCompleteTestOutbreakMap', 'gSovereignTestClock'))
    variables = var_ids()
    names = species_names()
    entries = outbreak_entries()
    places = {header: (header_id, tile, table) for header, header_id, table, tile in cases()
              if header in {part[1] for part in PARTS}}
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    survey = sym['gSovereignTestWildSurvey']
    terrain_ids = [t for t, _ in TERRAINS]

    def setup(on, entry, hour):
        def apply():
            mem.write_short(sym['gSovereignTestVar'] + 4, variables['VAR_COMPLETE_OUTBREAKS'])  # [1]; [0] is arrive's
            mem.write_short(sym['gSovereignTestVar'] + 6, on)
            mem.write_byte(sym['gCompleteTestOutbreakMap'], entry)
            mem.write_byte(sym['gSovereignTestClock'], 0 if hour is None else hour + 1)
        return apply

    results = []
    for name, header, terrain, on, today, kind, wanted, hour in PARTS:
        header_id, (x, z), table = places[header]
        species = table['swarm'][kind]  # the map's outbreak and night species
        result, _ = arrive(d, sym, state, variables, events_of(header), header_id, (x, z), x, z, 1,
                           setup(on, entries[today], hour))
        d.run(30)  # the game reads the clock every 11 frames (UpdateRTC)
        problem = '' if result == 'ok' else f'arrive {result}'
        seen = 0
        if not problem:
            count = run_survey(d, survey, terrain_ids.index(terrain))
            for i in range(max(count, 0)):
                at = survey + SURVEY['mons'] + i * MON_SIZE
                seen += names[struct.unpack('<IHBB', bytes(mem.unsigned[at:at + MON_SIZE]))[1]] == species
            if count <= 0:
                problem = 'the survey made nothing'
            elif (seen * 4 >= count) != wanted:
                problem = f'{seen} {species} in {count}'
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], f'({seen} {species})', flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok')
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
