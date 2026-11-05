#!/usr/bin/env python3
"""Check the Route 34 Day Care's yard (HeartGold's UpdateDaycareMonObjects; src/overlay005/complete_daycare.c), in the
test build, from the bedroom state: the Pokémon left at the Day Care stand in the yard beside the house, each as its
walking sprite, as in HeartGold.

1. The player warps into the Day Care house (inside its door): with nobody at the Day Care, the yard is empty.
2. The test build's breeding hook (gSovereignTestBreed: tools/test/battle_eggs.py) leaves a Pikachu and a Marill at the
   Day Care (it breeds them, and the Egg hatches into the party) before a test battle, which the test wins.
3. The player warps into the house again: the yard now shows the two, the yard's part of the screen changed from 1's.

Results: a line per check, screenshots before and after in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_daycare_yard.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import sys

from PIL import ImageChops

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import fight  # noqa: E402
from battle_eggs import BREED, FRAME_LIMIT  # noqa: E402
from battle_form_changes import FOE  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import HOUR, SYMBOLS, header_names, symbols, warp  # noqa: E402

HOUSE = 'MAP_HEADER_HGSS_ROUTE_34_DAYCARE'
INSIDE_DOOR = (3, 11)  # a step in from the house's door (3, 12)
PARENTS = ['SPECIES_PIKACHU', 'SPECIES_MARILL']
# On the top screen, with the player inside the door: the yard, east of the room, where HeartGold's (8, 5) and (10, 9)
# are (the room's west side changes too: the hatched Pokémon leads, and follows)
YARD = (150, 0, 256, 192)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestBreed', 'gSovereignTestWild', 'gSovereignTestGodMode', 'gSystem'))
    species_ids, moves = consts('species.txt'), consts('moves.txt')
    ids = header_names()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def visit(name):
        result, frames = warp(d, sym, ids.index(HOUSE), *INSIDE_DOOR, 0)
        check(f'into the Day Care house ({result} {frames})', result == 'ok')
        d.run(120)  # the yard's Pokémon look about
        im = d.screenshot()
        im.save(os.path.join(out, name + '.png'))
        return im

    mem.write_byte(sym['gSovereignTestClock'], HOUR + 1)
    d.run(30)
    before = visit('empty_yard')

    breed, wild = sym['gSovereignTestBreed'], sym['gSovereignTestWild']
    for i, species in enumerate(PARENTS):
        mem.write_short(breed + BREED['species'] + 2 * i, species_ids.index(species))
        mem.write_byte(breed + BREED['forms'] + i, 0)
        mem.write_byte(breed + BREED['genders'] + i, 1 + i)  # a male and a female
        mem.write_short(breed + BREED['items'] + 2 * i, 0)
    mem.write_short(breed + BREED['personality'], 0x1234)
    mem.write_byte(breed + BREED['breed'], 1)
    mem.write_short(wild, species_ids.index(FOE[0]))
    mem.write_byte(wild + 3, FOE[1])
    mem.write_short(wild + 4, moves.index(FOE[2]))
    mem.write_byte(sym['gSovereignTestGodMode'], 1)
    d.press('SELECT')
    result, frames = fight(d, sym, FRAME_LIMIT)
    check(f'the two left at the Day Care, and the battle won ({result} {frames})', result == 'ok')

    after = visit('yard')
    yard = ImageChops.difference(before.crop(YARD).convert('RGB'), after.crop(YARD).convert('RGB')).getbbox()
    check(f'the yard shows them (changed {yard})', yard is not None)

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
