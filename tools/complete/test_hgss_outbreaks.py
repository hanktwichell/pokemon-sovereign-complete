#!/usr/bin/env python3
"""Check HeartGold's mass outbreaks in Johto and Kanto (src/complete_encounters.c) in the test build, from the bedroom
state. Each part comes onto a map as tools/complete/test_hgss_encounters.py does and runs its survey (the game's own
encounter code, wild_forms.SAMPLES times, gSovereignTestWildSurvey):

1. **Off:** Route 35's grass with outbreaks off (a new game's): Illumise, its outbreak species, only as one of its
   usual Pokémon, in fewer than a quarter of the encounters (about one in fifty).
2. **Route 35:** outbreaks on (VAR_COMPLETE_OUTBREAKS, as Oak's National Pokédex sets it) and today's outbreak there
   (gCompleteTestOutbreakMap): Illumise in the first two grass slots, so in at least a quarter of the encounters
   (about two in five).
3. **Elsewhere:** outbreaks on, today's outbreak on Route 1: Route 35 as usual, Illumise under a quarter.
4. **Route 27's water:** outbreaks on, today's outbreak there: Feebas in the first surfing slot, at least a quarter.

Results: a line per part.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_outbreaks.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from talk_to_objects import SYMBOLS, arrive, symbols, var_ids  # noqa: E402
from test_hgss_encounters import cases  # noqa: E402
from wild_forms import MON_SIZE, SURVEY, TERRAINS, events_of, run_survey, species_names  # noqa: E402

ROUTE_35, ROUTE_27 = 'MAP_HEADER_HGSS_ROUTE_35', 'MAP_HEADER_HGSS_ROUTE_27'
# Entries of the outbreak table (src/complete_encounters.c, sOutbreakMaps), + 1 for gCompleteTestOutbreakMap
OUTBREAK_ROUTE_1, OUTBREAK_ROUTE_27, OUTBREAK_ROUTE_35 = 1, 9, 11
PARTS = [  # (name, map, terrain, outbreaks on, today's outbreak map entry + 1, the species, whether it should appear)
    ('off', ROUTE_35, 'land', 0, OUTBREAK_ROUTE_35, 'SPECIES_ILLUMISE', False),
    ('Route 35', ROUTE_35, 'land', 1, OUTBREAK_ROUTE_35, 'SPECIES_ILLUMISE', True),
    ('elsewhere', ROUTE_35, 'land', 1, OUTBREAK_ROUTE_1, 'SPECIES_ILLUMISE', False),
    ('Route 27 water', ROUTE_27, 'surf', 1, OUTBREAK_ROUTE_27, 'SPECIES_FEEBAS', True),
]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestWildSurvey', 'gCompleteTestOutbreakMap'))
    variables = var_ids()
    names = species_names()
    places = {header: (header_id, tile) for header, header_id, _, tile in cases()
              if header in (ROUTE_35, ROUTE_27)}
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    survey = sym['gSovereignTestWildSurvey']
    terrain_ids = [t for t, _ in TERRAINS]

    def setup(on, entry):
        def apply():
            mem.write_short(sym['gSovereignTestVar'] + 4, variables['VAR_COMPLETE_OUTBREAKS'])  # [1]; [0] is arrive's
            mem.write_short(sym['gSovereignTestVar'] + 6, on)
            mem.write_byte(sym['gCompleteTestOutbreakMap'], entry)
        return apply

    results = []
    for name, header, terrain, on, entry, species, wanted in PARTS:
        header_id, (x, z) = places[header]
        result, _ = arrive(d, sym, state, variables, events_of(header), header_id, (x, z), x, z, 1, setup(on, entry))
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
