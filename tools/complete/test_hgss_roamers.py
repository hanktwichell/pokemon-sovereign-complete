#!/usr/bin/env python3
"""Check HeartGold's roamers in the test build: Raikou and Entei roam Johto, Latias and Latios Kanto
(src/roaming_pokemon.c; docs/SacredGold.md), as tools/test/roamers.py checks Sovereign's own.

From the new game's save, this releases the four slots (gSovereignTestRoamerRelease, which calls
RoamingPokemon_ActivateSlot as the script command does) and reads each slot as the field writes it down
(gSovereignTestRoamers). Then:
- **Release:** each roams with its species and level (Raikou and Entei 40, Latias and Latios 35) and its HP, on a
  route of its own region. No other slot roams.
- **Flying:** it flies (the test warp) between Johto's and Kanto's roaming routes, as a player would. Each flight moves
  every roamer to a random route of its own region (RoamingPokemon_RandomizeAllLocations): not the one it was on, and
  not the one the player left.
- **Meeting:** after each flight with roamers on the player's route, it runs wild_forms.py's survey there (SAMPLES
  encounters, no battle) with the roamers in it (gSovereignTestSurveyRoamers): about half the encounters must be a
  roamer on the route (between MEET_SHARE of them), each that roamer itself (its species, level and personality), and
  no roamer from elsewhere. It flies until each has been met in MEET_TIMES surveys (at most FLIGHTS_MAX flights).
Battles, catching and walking are tools/test/roamers.py's, the same code for every slot.

From the repo root, with the test build and a bedroom state (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_roamers.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from roamers import FLIGHTS_MAX, MEET_SHARE, MEET_TIMES, read_roamers, routes, slot_names, slot_species  # noqa: E402
from talk_to_objects import HOUR, SYMBOLS, header_names, symbols, warp  # noqa: E402
from test_hgss_encounters import cases  # noqa: E402
from wild_forms import MON_SIZE, SURVEY, TERRAINS, run_survey, species_names  # noqa: E402

REGIONS = {'ROAMING_SLOT_RAIKOU': 'johto', 'ROAMING_SLOT_ENTEI': 'johto',
           'ROAMING_SLOT_LATIAS': 'kanto', 'ROAMING_SLOT_LATIOS': 'kanto'}


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestWildSurvey', 'gSovereignTestRoamers', 'gSovereignTestRoamerRelease',
                             'gSovereignTestSurveyRoamers'))
    names, ids, species = slot_names(), header_names(), species_names()
    expected = slot_species()
    slots = [names.index(s) for s in REGIONS]
    route_headers, _ = routes()
    route_ids = [ids.index(h) for h in route_headers]
    # Johto's routes come first in RoamingPokemonRoutes, then Kanto's (HeartGold's order: Routes 29 to 46, 1 to 28)
    johto_start = route_headers.index('MAP_HEADER_HGSS_ROUTE_29')
    kanto_start = route_headers.index('MAP_HEADER_HGSS_ROUTE_1')
    region_of = {route_ids[i]: 'johto' if i < kanto_start else 'kanto' for i in range(johto_start, len(route_ids))}
    places = {}
    for header, header_id, table, tile in cases():
        if header in route_headers:
            places[header] = (header_id, tile, 'land' if table['land']['rate'] else 'surf')
    flights = [h for h in route_headers[johto_start:] if h in places]
    terrain_index = [t for t, _ in TERRAINS]
    survey = sym['gSovereignTestWildSurvey']
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory

    bad = 0
    with open(os.path.join(out, 'results.txt'), 'w') as f:
        def say(line, problem=False):
            nonlocal bad
            bad += problem
            print(line, file=f, flush=True)
            print(line, flush=True)

        def name(slot):
            return names[slot][len('ROAMING_SLOT_'):].lower()

        def where(map_id):
            return ids[map_id][len('MAP_HEADER_'):].lower() if map_id < len(ids) else hex(map_id)

        missing = [h for h in route_headers[johto_start:] if h not in places]
        if missing:
            say(f'NOPLACE: no tile on {missing}', True)

        d.load_state(state)
        mem.write_byte(sym['gSovereignTestClock'], HOUR + 1)
        d.run(30)  # the game reads the clock every 11 frames
        mem.write_byte(sym['gSovereignTestGodMode'], 1)  # a battle that starts on the way ends at once
        mem.write_long(sym['gSovereignTestRoamerRelease'], sum(1 << s for s in slots))

        # Release, and the first flight.
        header_id, (x, z), _ = places[flights[0]]
        result, frames = warp(d, sym, header_id, x, z, 0)
        if result != 'ok':
            say(f'first flight to {flights[0]}: {result} {frames}', True)
            sys.exit(1)
        roamers = read_roamers(d, sym)
        for slot in range(len(roamers)):
            map_id, index, level, kind, hp, _ = roamers[slot]
            if slot not in slots:
                if map_id:
                    say(f'release: {name(slot)} roams ({where(map_id)}), though it wasn\'t released', True)
                continue
            want = expected[names[slot]]
            if (species[kind], level) != want or not hp or region_of.get(map_id) != REGIONS[names[slot]] \
                    or route_ids[index] != map_id:
                say(f'release: {name(slot)} BAD: {species[kind]} Lv. {level}, HP {hp}, on {where(map_id)} '
                    f'(route {index}); want {want[0]} Lv. {want[1]} in {REGIONS[names[slot]].title()}', True)
        say(f'release: {", ".join(f"{name(s)} on {where(roamers[s][0])}" for s in slots)}')

        flight = {'flown': 0, 'moves': 0, 'left': header_id}
        met = {slot: 0 for slot in slots}
        surveys = 0
        while flight['flown'] < FLIGHTS_MAX and min(met.values()) < MEET_TIMES:
            # The next route: each in turn, spread out (7 is prime to the 41 routes)
            header = flights[(flight['flown'] * 7 + 1) % len(flights)]
            header_id, (x, z), terrain = places[header]
            if header_id == flight['left']:
                header = flights[(flight['flown'] * 7 + 2) % len(flights)]
                header_id, (x, z), terrain = places[header]
            before = read_roamers(d, sym)
            result, frames = warp(d, sym, header_id, x, z, 0)
            flight['flown'] += 1
            if result != 'ok':
                say(f'flight {flight["flown"]} to {header}: {result} {frames}', True)
                break
            roamers = read_roamers(d, sym)
            for slot in slots:
                old, new = before[slot][0], roamers[slot][0]
                flight['moves'] += 1
                if region_of.get(new) != REGIONS[names[slot]] or route_ids[roamers[slot][1]] != new or new == old \
                        or new == flight['left']:
                    say(f'flight {flight["flown"]} to {where(header_id)} from {where(flight["left"])}: {name(slot)} '
                        f'went from {where(old)} to {where(new)} (route {roamers[slot][1]})', True)
            flight['left'] = header_id

            here = [slot for slot in slots if roamers[slot][0] == header_id]
            if not here:
                continue
            mem.write_byte(sym['gSovereignTestSurveyRoamers'], 1)
            count = run_survey(d, survey, terrain_index.index(terrain))
            mem.write_byte(sym['gSovereignTestSurveyRoamers'], 0)
            surveys += 1
            if count <= 0:
                say(f'meeting on {where(header_id)}: the survey made {count}', True)
                continue
            made = [struct.unpack('<IHBB', bytes(mem.unsigned[survey + SURVEY['mons'] + i * MON_SIZE:
                                                              survey + SURVEY['mons'] + (i + 1) * MON_SIZE]))
                    for i in range(count)]
            roaming_species = {roamers[slot][3] for slot in slots}
            mine = {(roamers[slot][3], roamers[slot][2], roamers[slot][5]): slot for slot in here}
            seen = [m for m in made if m[1] in roaming_species]
            wrong = [m for m in seen if (m[1], m[3], m[0]) not in mine or m[2] != 0]
            for slot in {mine[(m[1], m[3], m[0])] for m in seen if (m[1], m[3], m[0]) in mine}:
                met[slot] += 1
            share = len(seen) / count
            if wrong or not MEET_SHARE[0] <= share <= MEET_SHARE[1]:
                say(f'meeting on {where(header_id)} ({", ".join(name(s) for s in here)}): {len(seen)} of {count} '
                    f'roamers' + (f'; WRONG {[(species[m[1]], m[2], m[3], hex(m[0])) for m in wrong[:4]]}'
                                  if wrong else ''), True)
        say(f'flying: {flight["flown"]} flights, {flight["moves"]} moves; {surveys} surveys with roamers on the route; '
            f'the surveys each was met in: ' + ', '.join(f'{name(s)} {met[s]}' for s in slots))
        for slot in slots:
            if met[slot] < MEET_TIMES:
                say(f'meeting: {name(slot)} met in {met[slot]} surveys in {flight["flown"]} flights', True)
        say(f'{bad} problems')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
