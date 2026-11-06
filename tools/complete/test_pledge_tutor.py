#!/usr/bin/env python3
"""The Pledge tutor in Elm's lab (CommonScript_CompletePledgeTutor, tools/complete/pledges.py), in the test build, from
the bedroom state, as a player would: beside the tutor, talk, yes, pick the Pokémon from the party, yes.

1. The test save's Turtwig (a starter, the party's second) learns Grass Pledge.
2. Its Garchomp (not a starter, the first) is refused, and learns nothing.

Results: a line per case, a screenshot of each in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pledge_tutor.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from gift_pokemon import note_party, talk_and_answer  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, header_names, symbols, warp  # noqa: E402

LAB = 'MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_1F'
BESIDE = (10, 13)  # west of the tutor at (11, 13)
EAST = 4  # the test warp's facing: enum FaceDirection + 1
# (case, party slot, the move it must know after, or None: it's refused)
CASES = [('Turtwig learns Grass Pledge', 1, 'MOVE_GRASS_PLEDGE'), ('Garchomp is refused', 0, None)]
LIMIT = 6000


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestMenu', 'gSovereignTestParty'))
    ids = header_names()
    moves = open(os.path.join(DECOMP, 'generated', 'moves.txt')).read().split()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    problems = []

    for name, slot, move in CASES:
        d.load_state(state)
        d.run(30)
        arrived, _ = warp(d, sym, ids.index(LAB), *BESIDE, 0)
        if arrived == 'ok':
            arrived, _ = warp(d, sym, ids.index(LAB), *BESIDE, EAST)
        before = note_party(d, sym)
        answers = [True, ('party', slot)] + ([True] if move else [])
        result, frames = talk_and_answer(d, sym, answers, LIMIT) if arrived == 'ok' else (f'warp {arrived}', 0)
        d.screenshot().save(os.path.join(out, name.split()[0].lower() + '.png'))
        after = note_party(d, sym)
        known = [moves[m] for m in after[slot][3] if m]
        if result != 'ok':
            problem = f'{result} after {frames} frames'
        elif move and move not in known:
            problem = f'knows {known}, not {move}'
        elif not move and after[slot][3] != before[slot][3]:
            problem = f'its moves changed: {known}'
        else:
            problem = ''
        line = f'{name}: {problem or "ok"} ({known})'
        print(line, flush=True)
        if problem:
            problems.append(line)

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
