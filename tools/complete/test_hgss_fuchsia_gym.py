#!/usr/bin/env python3
"""Check Fuchsia Gym's invisible walls in the test build (HeartGold's fuchsia.c; src/complete_gyms.c): bumping into
one flashes it, HeartGold's model for that piece of wall playing its animations where the wall is.

From the bedroom state, the player warps in at the gym's door (its script sets the gym's features up, as HeartGold's
InitFuchsiaGym does), then onto the tile below the first row of walls, and presses up into the wall: a flash must
start (gCompleteTestFuchsiaFlashes), the player must stay put, and the field must be free again. Pressing up again
while it flashes doesn't start another. Screenshots: the wall flashing (flash.png) and the end (end.png).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_fuchsia_gym.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import SYMBOLS, header_names, symbols, warp  # noqa: E402

GYM = 'MAP_HEADER_HGSS_FUCHSIA_GYM'
WAY_IN = (7, 24)
BELOW_WALL = (6, 21)  # the wall is on (6, 20), in HeartGold's table of the gym's walls
NORTH = 1  # the test warp's facing: FACE_UP + 1
FLASH_FRAMES = 10  # the frames after the bump at which the screenshot catches the flash


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestFuchsiaFlashes',))
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

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
    arrived, frames = warp(d, sym, names.index(GYM), *BELOW_WALL, NORTH)
    check(f'below the wall ({arrived} {frames}; on {d.pos()})', arrived == 'ok' and d.pos() == BELOW_WALL)
    before = u16(sym['gCompleteTestFuchsiaFlashes'])
    d.press('UP', frames=6, after=0)
    d.run(FLASH_FRAMES)
    d.screenshot().save(os.path.join(out, 'flash.png'))
    check(f'the wall flashes ({u16(sym["gCompleteTestFuchsiaFlashes"]) - before} started)',
          u16(sym['gCompleteTestFuchsiaFlashes']) == before + 1)
    d.press('UP', frames=6, after=10)
    check(f'a second bump while it flashes starts none ({u16(sym["gCompleteTestFuchsiaFlashes"]) - before} started)',
          u16(sym['gCompleteTestFuchsiaFlashes']) == before + 1)
    d.run(120)
    idle = u32(sym['gSovereignTestIdleFrames'])
    d.run(60)
    idle = u32(sym['gSovereignTestIdleFrames']) - idle  # a free field updates at 30 Hz
    check(f'the player stays put and the field is free (on {d.pos()}, {idle} idle frames of 60)',
          d.pos() == BELOW_WALL and idle >= 20)
    d.screenshot().save(os.path.join(out, 'end.png'))
    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
