#!/usr/bin/env python3
"""Check Viridian Gym's arrow tiles in the test build (HeartGold's viridian.c; src/complete_gyms.c): stepping onto
one lights it up, HeartGold's model for that arrow playing its animation on the tile.

From the bedroom state, the player warps in at the gym's door (its init script sets the gym's features up, as
HeartGold's InitViridianGym does), then onto the tile below the first arrow up the middle (a south arrow), and steps
up onto it: an arrow must light up (gCompleteTestViridianLit), the player slides back south off it (Platinum's slide
goes on to the row below), and the field must be free again. Screenshots: the arrow lit (lit.png) and the end (end.png).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_viridian_gym.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import SYMBOLS, header_names, symbols, warp  # noqa: E402

GYM = 'MAP_HEADER_HGSS_VIRIDIAN_GYM'
WAY_IN = (5, 46)
ARROW = (5, 41)  # a south arrow, the first up the middle
BELOW_ARROW = (5, 42)
NORTH = 1  # the test warp's facing: FACE_UP + 1
LIT_FRAMES = 12  # the frames after the step at which the screenshot catches the arrow lit
SLIDE_FRAMES = 120  # time enough to slide back off the arrow


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestViridianLit',))
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory

    def lit():
        return struct.unpack('<H', bytes(mem.unsigned[sym['gCompleteTestViridianLit']:
                                                     sym['gCompleteTestViridianLit'] + 2]))[0]

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    d.run(30)
    arrived, frames = warp(d, sym, names.index(GYM), *WAY_IN, 0)
    check(f'in at the door ({arrived} {frames})', arrived == 'ok')
    arrived, frames = warp(d, sym, names.index(GYM), *BELOW_ARROW, NORTH)
    check(f'below the arrow ({arrived} {frames}; on {d.pos()})', arrived == 'ok' and d.pos() == BELOW_ARROW)
    before = lit()
    d.press('UP', frames=6, after=0)
    d.run(LIT_FRAMES)
    d.screenshot().save(os.path.join(out, 'lit.png'))
    check(f'the arrow lights up ({lit() - before} lit)', lit() > before)
    d.run(SLIDE_FRAMES)
    idle = u32(sym['gSovereignTestIdleFrames'])
    d.run(60)
    idle = u32(sym['gSovereignTestIdleFrames']) - idle  # a free field updates at 30 Hz
    check(f'the player slides back off it and the field is free (on {d.pos()}, {idle} idle frames of 60)',
          d.pos()[0] == ARROW[0] and d.pos()[1] > ARROW[1] and idle >= 20)
    d.screenshot().save(os.path.join(out, 'end.png'))
    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
