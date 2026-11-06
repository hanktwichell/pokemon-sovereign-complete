#!/usr/bin/env python3
"""Check the Pokéathlon Dome's medals screen (HeartGold's ScrCmd_712 1, its overlay 99's PokeathlonMedals;
src/applications/complete_pokeathlon_records/medals.c), in the test build, from the bedroom state.

1. The player warps into the Trust Room, below its record board (5-9, 9), turns to it and presses A: the room's script
   fades out and opens the screen (gCompleteTestPokeathlonRecordScreen: 2 for this screen, the page, the cursor). A
   new game has no medals: an empty page.
2. The test fills the open screen's copy of the medal bytes (gCompleteTestPokeathlonMedals: [species - 1], a bit a
   course) for the first 45 species, Pikachu and Bulbasaur with all five (medalists), and a Sylveon past HeartGold's
   493 with all five, then asks the screen to rebuild (the marker's fourth byte): 46 species, two pages, back on the
   first; both screens' pictures change from the empty page.
3. The cursor: DOWN four rows to Pikachu (place 24), its medals and the medalist banner on the top screen; RIGHT to
   the row's end, then RIGHT once more turns to the second page (the cursor at the row's start); LEFT turns back.
4. DOWN from the bottom row reaches Return (place 30); A closes the screen and the field comes back in the Trust Room.
   The screen opens again and B closes it.

Results: a line per check, screenshots in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_medals.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

from PIL import ImageChops

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import SYMBOLS, header_names, symbols, u32, warp  # noqa: E402

ROOM = 'MAP_HEADER_HGSS_POKEATHLON_DOME_INTERIOR_B1F_TRUST_ROOM'
STAND = (7, 10)  # below the record board's middle (7, 9)
FACE_DOWN = 2  # warp's dir (enum FaceDirection + 1): away from the board, so the warp's play-out can't read it
SCREEN_MEDALS = 2  # gCompleteTestPokeathlonRecordScreen[0]: 1 + ScrCmd_712's number
COLUMNS, PLACES, RETURN = 6, 30, 30
ALL_MEDALS = 0x1F
SPECIES_FILLED = 45  # the first 45 species get medals
OPEN_LIMIT = 1500  # frames from the A press to the screen


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPokeathlonRecordScreen', 'gCompleteTestPokeathlonMedals',
                             'gSovereignTestClock'))
    species_ids = consts('species.txt')
    ids = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def marker():
        at = sym['gCompleteTestPokeathlonRecordScreen']
        return tuple(mem.unsigned[at:at + 4])

    def shot(name):
        d.run(30)  # a page's slide (8 frames) and the top screen's redraw
        im = d.screenshot().convert('RGB')
        im.save(os.path.join(out, name + '.png'))
        return im

    def changed(a, b, top):
        box = (0, 0, 256, 192) if top else (0, 192, 256, 384)
        return ImageChops.difference(a.crop(box), b.crop(box)).getbbox()

    def press(key):
        d.press(key, frames=2, after=16)

    def open_screen():
        result, frames = warp(d, sym, ids.index(ROOM), *STAND, FACE_DOWN)
        if result != 'ok':
            return f'warp: {result} {frames}'
        d.press('UP', frames=2, after=20)  # turn to the board
        d.press('A', after=30)
        for _ in range(OPEN_LIMIT // 30):
            if marker()[0] == SCREEN_MEDALS:
                d.run(60)  # its fade in
                return ''
            d.press('A', after=24)  # through the room's message
        return f'no screen after {OPEN_LIMIT} frames (marker {marker()})'

    def closed(how):
        for _ in range(30):
            d.run(30)
            if marker()[0] == 0:
                break
        idle = u32(d, sym['gSovereignTestIdleFrames'])
        d.run(60)
        here = ids[u32(d, sym['gSovereignTestIdleMapHeaderID'])]
        check(f'{how}: the screen closed (marker {marker()}) and the field runs again in the Trust Room ({here})',
              marker()[0] == 0 and here == ROOM and u32(d, sym['gSovereignTestIdleFrames']) > idle)

    mem.write_byte(sym['gSovereignTestClock'], 12 + 1)  # noon (the clock takes the hour + 1)
    d.run(30)

    # 1. The screen, empty
    problem = open_screen()
    check(f'the Trust Room\'s board opens the medals screen {problem}', not problem)
    if problem:
        d.screenshot().save(os.path.join(out, 'no_screen.png'))
        print(f'{len(problems)} problems')
        sys.exit(1)
    check(f'it opens on the first page, the cursor on its first place (marker {marker()})',
          marker()[:3] == (SCREEN_MEDALS, 1, 0))
    medals = u32(d, sym['gCompleteTestPokeathlonMedals'])
    check(f'the open screen\'s medals are given to the test ({medals:#x})', medals >= 0x02000000)
    empty = shot('empty')

    # 2. Medals for 46 species, then the rebuild
    pikachu, bulbasaur, sylveon = (species_ids.index(s) for s in ('SPECIES_PIKACHU', 'SPECIES_BULBASAUR',
                                                                   'SPECIES_SYLVEON'))
    for species in range(1, SPECIES_FILLED + 1):
        mem.write_byte(medals + species - 1, ALL_MEDALS if species in (pikachu, bulbasaur) else 1 << species % 5)
    mem.write_byte(medals + sylveon - 1, ALL_MEDALS)
    mem.write_byte(sym['gCompleteTestPokeathlonRecordScreen'] + 3, 1)
    for _ in range(20):
        d.run(10)
        if marker()[3] == 0:
            break
    check(f'the screen rebuilt its list (marker {marker()})', marker() == (SCREEN_MEDALS, 1, 0, 0))
    first = shot('page_1_bulbasaur')
    check(f'the first page shows the Pokémon (bottom screen {changed(empty, first, False)})',
          changed(empty, first, False) is not None)
    check(f'and Bulbasaur\'s medals on the top screen ({changed(empty, first, True)})',
          changed(empty, first, True) is not None)

    # 3. The cursor and the pages
    for _ in range(4):
        press('DOWN')
    check(f'DOWN four rows: Pikachu, place {pikachu - 1} (marker {marker()})', marker()[2] == pikachu - 1)
    pika = shot('page_1_pikachu')
    for _ in range(COLUMNS - 1):
        press('RIGHT')
    check(f'RIGHT to the row\'s end (marker {marker()})', marker()[2] == (pikachu - 1) // COLUMNS * COLUMNS + 5)
    row_end = shot('page_1_row_end')
    check(f'another Pokémon\'s medals on the top screen ({changed(pika, row_end, True)})',
          changed(pika, row_end, True) is not None)
    press('RIGHT')
    d.run(20)
    check(f'RIGHT past it: the second page, the cursor at the row\'s start (marker {marker()})',
          marker()[1] == 2 and marker()[2] == (pikachu - 1) // COLUMNS * COLUMNS)
    second = shot('page_2')
    check(f'the second page differs ({changed(first, second, False)})', changed(first, second, False) is not None)
    press('UP')
    press('UP')
    press('UP')
    press('UP')
    check(f'UP to the second page\'s first place (marker {marker()})', marker()[1:3] == (2, 0))
    shot('page_2_first')
    press('LEFT')
    d.run(20)
    check(f'LEFT on the first column: back to the first page (marker {marker()})', marker()[1] == 1)
    shot('page_1_again')

    # 4. Return, A; then B
    for _ in range(PLACES // COLUMNS):
        press('DOWN')
    check(f'DOWN from the bottom row: Return (marker {marker()})', marker()[2] == RETURN)
    shot('return')
    d.press('A', after=10)
    closed('A on Return')
    problem = open_screen()
    check(f'the screen opens again {problem}', not problem)
    if not problem:
        d.press('B', after=10)
        closed('B')

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
