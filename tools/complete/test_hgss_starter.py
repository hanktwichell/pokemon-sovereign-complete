#!/usr/bin/env python3
"""Check the starter choice in Professor Elm's lab in the test build (HeartGold's ChooseStarter, translated as Platinum's
starter scene with Elm's three: src/choose_starter/choose_starter_app.c, src/complete_scrcmd.c), from the bedroom state:
the player stands at the table of Poké Balls, presses A, picks the Poké Ball the scene first points at, says no to a
nickname, and Elm's lines play out to the script's end. Then the party has one more Pokémon: Chikorita, Cyndaquil or
Totodile, at Lv. 5.

Results: 'ok' or what went wrong. Screenshots go to OUT_DIR: the table on arrival (table.png; two Poké Balls, as the
test build's party isn't empty), the scene every SHOT_FRAMES frames (scene_NNNNN.png) and its end (end.png).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_starter.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from gift_pokemon import note_party, talk_and_answer  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, warp  # noqa: E402

LAB = 'MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_1F'
TABLE = (8, 4)  # the table's sign (events_hgss_058), read facing north
NORTH = 1  # warp's dir: FACE_UP + 1
STARTERS = {152: 'Chikorita', 155: 'Cyndaquil', 158: 'Totodile'}
LEVEL = 5
LIMIT = 9000
SHOT_FRAMES = 200
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gSovereignTestMenu', 'gSovereignTestParty', 'gSovereignTestPartyKeep'})


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    d = Driver(rom, state)
    d.load_state(state)
    d.run(30)
    d.emu.memory.write_byte(sym['gSovereignTestPartyKeep'], 1)  # room for the starter
    arrived, _ = warp(d, sym, header_names().index(LAB), TABLE[0], TABLE[1] + 1, NORTH)
    problem = '' if arrived == 'ok' else f'warp {arrived}'
    before = len(note_party(d, sym)) if not problem else 0
    d.screenshot().save(os.path.join(out, 'table.png'))  # the Poké Balls on Elm's table
    if not problem:
        frames, run = [0], d.run

        def run_and_shoot(n):  # a screenshot every SHOT_FRAMES frames of the scene
            run(n)
            frames[0] += n
            if frames[0] % SHOT_FRAMES < n:
                d.screenshot().save(os.path.join(out, f'scene_{frames[0]:05d}.png'))

        d.run = run_and_shoot
        result, _ = talk_and_answer(d, sym, [False], LIMIT)  # no nickname
        d.run = run
        problem = '' if result == 'ok' else f'the scene: {result}'
    if not problem:
        party = note_party(d, sym)
        if len(party) != before + 1:
            problem = f'the party has {len(party)} Pokémon, not {before + 1}'
        elif party[-1][0] not in STARTERS or party[-1][5] != LEVEL:
            problem = f'the new Pokémon is species {party[-1][0]} at Lv. {party[-1][5]}'
        else:
            print(f'chose {STARTERS[party[-1][0]]}, Lv. {party[-1][5]}')
    d.screenshot().save(os.path.join(out, 'end.png'))
    print(f'starter: {problem or "ok"}')
    sys.exit(1 if problem else 0)


if __name__ == '__main__':
    main()
