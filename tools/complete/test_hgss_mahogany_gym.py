#!/usr/bin/env python3
"""Check Mahogany Gym's ice blocks in the test build (HeartGold's unk_0206D494.c; src/complete_gyms.c): the player
slides into one over the ice, and it slides on until it meets the other and joins it.

From the bedroom state, the player warps into the gym's second room, west of its two blocks, (5, 10) and (8, 10), and
steps east onto the ice: the player slides to the first block and stops, and it slides on to (7, 10), against the
second (gCompleteTestIceBlockPushes counts the push), where both turn to face up, joined. Sliding east again, the
player stops against the joined blocks at (6, 10), without pushing them; north from there the ice carries the player
to (6, 5), the way on to Pryce, which the room has no other way to. The field must be free and the heaps whole at the
end. Screenshots: the blocks joined (joined.png) and the end (end.png).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_mahogany_gym.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import heap_info  # noqa: E402
from heap_check import heap_problems  # noqa: E402
from talk_to_objects import SYMBOLS, header_names, symbols, warp  # noqa: E402

ROOM = 'MAP_HEADER_HGSS_MAHOGANY_GYM_ROOM_2'
START = (2, 10)  # the floor west of the ice, in line with the blocks
EAST = 4  # the test warp's facing: FACE_RIGHT + 1
BLOCKS = ((5, 10), (8, 10))
JOINED = ((7, 10), (8, 10))
NORTH, SOUTH = 0, 1  # Platinum's DIR_NORTH and DIR_SOUTH
WAY_ON = (6, 5)
SETTLE = 240  # frames for a slide and a block's slide to end


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestIceBlockPushes',))
    d = Driver(rom, state)
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def blocks():
        """The ice blocks' tiles and facings ({tile: dir}), from the map object manager's objects (src/map_object.c),
        found from the player's map object (localID 0xFF on the player's tile)."""
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        from test_hgss_opening import ICE_ROCK, MAP_OBJECT_SIZE, RAM, RAM_SIZE
        ram, pos = bytes(mem.unsigned[RAM:RAM + RAM_SIZE]), d.pos()
        for at in range(0, RAM_SIZE - MAP_OBJECT_SIZE, 4):
            if ram[at + 8:at + 12] == b'\xff\x00\x00\x00' and struct.unpack_from('<I', ram, at)[0] & 1 \
                    and struct.unpack_from('<3i', ram, at + 100)[::2] == pos:
                manager = u32(RAM + at + 0xb4)
                break
        found = {}
        for i in range(u32(manager + 4)):
            at = u32(manager + 0x124) + MAP_OBJECT_SIZE * i
            if u32(at) & 1 and u32(at + 16) == ICE_ROCK:
                found[struct.unpack('<3i', bytes(mem.unsigned[at + 100:at + 112]))[::2]] = u32(at + 40)
        return found

    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    d.run(30)
    arrived, frames = warp(d, sym, header_names().index(ROOM), *START, EAST)
    check(f'in the room ({arrived} {frames}; on {d.pos()})', arrived == 'ok' and d.pos() == START)
    check(f'the blocks where the map puts them, pushable ({blocks()})', blocks() == {b: SOUTH for b in BLOCKS})
    pushes = u16(sym['gCompleteTestIceBlockPushes'])
    d.press('RIGHT', frames=8, after=0)
    d.run(SETTLE)
    check(f'the player stops against the first block (on {d.pos()})', d.pos() == (4, 10))
    check(f'one push ({u16(sym["gCompleteTestIceBlockPushes"]) - pushes})',
          u16(sym['gCompleteTestIceBlockPushes']) == pushes + 1)
    check(f'it slid on and joined the second, both facing up ({blocks()})', blocks() == {b: NORTH for b in JOINED})
    d.screenshot().save(os.path.join(out, 'joined.png'))
    d.press('RIGHT', frames=8, after=0)
    d.run(SETTLE)
    check(f'sliding on, the player stops against the joined blocks (on {d.pos()}; {blocks()})',
          d.pos() == (6, 10) and blocks() == {b: NORTH for b in JOINED}
          and u16(sym['gCompleteTestIceBlockPushes']) == pushes + 1)
    d.press('UP', frames=8, after=0)
    d.run(SETTLE)
    check(f'north over the ice to the way on (on {d.pos()})', d.pos() == WAY_ON)
    idle = u32(sym['gSovereignTestIdleFrames'])
    d.run(60)
    idle = u32(sym['gSovereignTestIdleFrames']) - idle  # a free field updates at 30 Hz
    check(f'the field is free ({idle} idle frames of 60) and the heaps whole', idle >= 20
          and not heap_problems(mem, heap_info()))
    d.screenshot().save(os.path.join(out, 'end.png'))
    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
