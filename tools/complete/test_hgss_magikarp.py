#!/usr/bin/env python3
"""Check the Lake of Rage's Magikarp record in the test build (HeartGold's size record: src/complete_scrcmd.c,
CompleteScrCmd_SizeRecordCompare and the rest, on src/overlay005/size_contest.c), from the bedroom state. The fishing
guru's house, with Team Rocket's hideout cleared (FLAG_HGSS_ROCKET_HIDEOUT_CLEARED) and a Magikarp in the party (after
Garchomp and Turtwig):

1. **New game:** the record starts at HeartGold's 3'6" (VAR_HGSS_MAGIKARP_SIZE_RECORD 56150).
2. **A record:** with the record set to the smallest size (0), the guru measures the Magikarp (picked on the party
   screen). Passes when the Magikarp is the new record: the var holds its size, not 0.
3. **The same size:** shown the same Magikarp again, the guru has nothing new. Passes when the record stays.

Results: a line per part. Screenshots of each talk's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_magikarp.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import battle_mechanics as bm  # noqa: E402
from gift_pokemon import note_party, talk_and_answer  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, var_ids, warp  # noqa: E402
from test_hgss_loan import names, place  # noqa: E402

SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gSovereignTestMenu', 'gSovereignTestParty', 'gSovereignTestPartyKeep',
                                     'gSovereignTestPartyAdd', 'gSovereignTestVar', 'gSovereignTestWatch'})
GURU = ('events_hgss_266', 'obj_T29R0201_fishing_2')  # the Lake of Rage's fishing guru
KEEP = 2
MAGIKARP_LEVEL = 20
NEW_GAME_RECORD = 56150  # 3'6"
LIMIT = 9000


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    species = names('species')
    variables = var_ids()
    record_var = variables['VAR_HGSS_MAGIKARP_SIZE_RECORD']
    d = Driver(rom, state)
    mem = d.emu.memory
    d.load_state(state)
    d.run(30)
    mem.write_byte(sym['gSovereignTestPartyKeep'], KEEP)
    mem.write_short(sym['gSovereignTestPartyAdd'], species.index('SPECIES_MAGIKARP'))
    mem.write_byte(sym['gSovereignTestPartyAdd'] + 3, MAGIKARP_LEVEL)
    mem.write_short(sym['gSovereignTestWatch'], record_var)

    def record():
        d.run(4)
        at = sym['gSovereignTestWatch'] + 2
        return struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]

    def set_on_warp(i, name, value):
        mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[name])
        mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)

    def visit(answers, shot):
        header, x, z, face = place(*GURU)
        arrived, _ = warp(d, sym, header, x, z, face + 1)
        if arrived != 'ok':
            return f'warp {arrived}'
        result, _ = talk_and_answer(d, sym, answers, LIMIT)
        d.screenshot().save(os.path.join(out, shot))
        return '' if result == 'ok' else f'the talk: {result}'

    results = []

    def report(part, problem):
        results.append(f'{part}: {problem or "ok"}')
        print(results[-1], f'(record {record()})', flush=True)

    # 1. The new game's record, read on the first free frame
    d.run(60)
    report('new game', '' if record() == NEW_GAME_RECORD else f'the record is {record()}, not {NEW_GAME_RECORD}')

    # 2. A new record
    set_on_warp(0, 'FLAG_HGSS_ROCKET_HIDEOUT_CLEARED', 1)
    set_on_warp(1, 'VAR_HGSS_MAGIKARP_SIZE_RECORD', 0)
    slot = KEEP  # the Magikarp joins after the first two
    problem = visit([('party', slot)], 'record.png')
    party = note_party(d, sym)
    if not problem:
        if len(party) <= slot or species[party[slot][0]] != 'SPECIES_MAGIKARP':
            problem = f'no Magikarp in slot {slot}'
        elif record() == 0:
            problem = 'the Magikarp did not become the record'
    report('record', problem)
    first = record()

    # 3. The same Magikarp again
    problem = visit([('party', slot)], 'same.png') if not problem else 'skipped'
    if not problem and record() != first:
        problem = f'the record changed from {first} to {record()}'
    report('same size', problem)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok')
    sys.exit(0 if ok == len(results) == 3 else 1)


if __name__ == '__main__':
    main()
