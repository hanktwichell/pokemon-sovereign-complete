#!/usr/bin/env python3
"""Check HeartGold's loan Pokémon in the test build (src/complete_scrcmd.c, CompleteScrCmd_GiveLoanMon and the rest),
from the bedroom state, with the party cut to two (Garchomp and Turtwig). In one go:

1. **Lent:** the man in Route 35's gatehouse lends Kenya (Sacred Gold's Dux), the Spearow with a letter for his friend
   on Route 31 (yes). Passes when the party has a Spearow more, holding Grass Mail, and VAR_HGSS_LOAN_SPEAROW is 1.
2. **The letter:** talked to again, he looks for his letter in the party and the PC's mailbox. Passes when he finds it
   (the var stays 1; without it he gives up on Kenya, 6).
3. **Delivered:** the friend on Route 31 is shown Kenya on the party screen: he checks the letter is his friend's
   (Kenya's mail against the one the gatehouse wrote), takes Kenya back and gives TM44. Passes when the Spearow has left
   the party and the var is past 1.
4. **Kirk's Shuckle:** Kirk in Cianwood City lends Shuckie (yes). Passes when the party has a Shuckle more, holding
   Berry Juice.

Results: a line per part. Screenshots of each talk's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_loan.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_object_tiles import Maps  # noqa: E402
from gift_pokemon import note_party, talk_and_answer  # noqa: E402
from talk_to_objects import (DECOMP, SYMBOLS as TALK_SYMBOLS, event_maps, header_at, header_names,  # noqa: E402
                             object_key, stand_next_to, var_ids, warp)

SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gSovereignTestMenu', 'gSovereignTestParty', 'gSovereignTestPartyKeep',
                                     'gSovereignTestWatch'})
GATEHOUSE = ('events_hgss_098', 'obj_R35R0101_counterm')  # Route 35's gatehouse, Kenya's Trainer
ROUTE_31 = ('events_hgss_032', 'obj_R31_gsbigman')  # his friend
KIRK = ('events_hgss_218', 'obj_T24R0201_gsman2')  # Cianwood City
KEEP = 2  # the party's first two stay
KENYA_SLOT = KEEP  # Kenya joins after them
LIMIT = 9000


def names(kind):
    return [line.strip() for line in open(os.path.join(DECOMP, 'generated', kind + '.txt')) if line.strip()]


def place(events, oid):
    """(header ID, x, z, facing) of a tile next to the object to talk to it from, as talk_to_objects.cases() finds."""
    maps = Maps(DECOMP)
    for name, headers_of, cur, grid in event_maps():
        if name != events:
            continue
        matrix = headers_of[0][1]
        objs = cur.get('object_events', [])
        warps = [(w['x'], w['z']) for w in cur.get('warp_events', [])]
        taken = {(o['x'], o['z']) for o in objs}
        o = next(o for o in objs if object_key(o) == oid)
        x, z, face = stand_next_to(maps, matrix, grid, warps, taken, o['x'], o['z'])
        return header_names().index(header_at(headers_of, grid, o['x'], o['z'])), x, z, face
    raise KeyError(events)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    species, items = names('species'), names('items')
    loan_var = var_ids()['VAR_HGSS_LOAN_SPEAROW']
    d = Driver(rom, state)
    mem = d.emu.memory
    d.load_state(state)
    d.run(30)
    mem.write_byte(sym['gSovereignTestPartyKeep'], KEEP)
    mem.write_short(sym['gSovereignTestWatch'], loan_var)

    def loan_state():
        d.run(4)
        return struct.unpack('<H', bytes(mem.unsigned[sym['gSovereignTestWatch'] + 2:sym['gSovereignTestWatch'] + 4]))[0]

    def visit(who, answers, shot):
        header, x, z, face = place(*who)
        arrived, _ = warp(d, sym, header, x, z, face + 1)
        if arrived != 'ok':
            return f'warp {arrived}'
        result, _ = talk_and_answer(d, sym, answers, LIMIT)
        d.screenshot().save(os.path.join(out, shot))
        return '' if result == 'ok' else f'the talk: {result}'

    def describe(party):
        return ', '.join(f'{species[mon[0]]} ({items[mon[2]]})' for mon in party)

    results = []

    def report(part, problem, party):
        results.append(f'{part}: {problem or "ok"}')
        print(results[-1], flush=True)
        print(f'     party: {describe(party)}; VAR_HGSS_LOAN_SPEAROW {loan_state()}', flush=True)

    # 1. Kenya, lent
    problem = visit(GATEHOUSE, [True], 'lent.png')
    party = note_party(d, sym)
    if not problem:
        if len(party) != KEEP + 1 or species[party[-1][0]] != 'SPECIES_SPEAROW':
            problem = 'no Spearow joined'
        elif items[party[-1][2]] != 'ITEM_GRASS_MAIL':
            problem = f'Kenya holds {items[party[-1][2]]}, not Grass Mail'
        elif loan_state() != 1:
            problem = f'VAR_HGSS_LOAN_SPEAROW {loan_state()}'
    report('lent', problem, party)

    # 2. The letter, found in the party
    problem = visit(GATEHOUSE, [], 'letter.png') if not problem else 'skipped'
    party = note_party(d, sym)
    if not problem and loan_state() != 1:
        problem = f'he didn\'t find his letter: VAR_HGSS_LOAN_SPEAROW {loan_state()}'
    report('letter', problem, party)

    # 3. Kenya, delivered
    problem = visit(ROUTE_31, [('party', KENYA_SLOT)], 'delivered.png') if not problem else 'skipped'
    party = note_party(d, sym)
    if not problem:
        if len(party) != KEEP or any(species[mon[0]] == 'SPECIES_SPEAROW' for mon in party):
            problem = 'Kenya is still in the party'
        elif loan_state() < 2:
            problem = f'VAR_HGSS_LOAN_SPEAROW {loan_state()}'
    report('delivered', problem, party)

    # 4. Kirk's Shuckle
    before = len(note_party(d, sym))
    problem = visit(KIRK, [True], 'shuckie.png')
    party = note_party(d, sym)
    if not problem:
        if len(party) != before + 1 or species[party[-1][0]] != 'SPECIES_SHUCKLE':
            problem = 'no Shuckle joined'
        elif items[party[-1][2]] != 'ITEM_BERRY_JUICE':
            problem = f'Shuckie holds {items[party[-1][2]]}, not Berry Juice'
    report('shuckie', problem, party)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok')
    sys.exit(0 if ok == len(results) == 4 else 1)


if __name__ == '__main__':
    main()
