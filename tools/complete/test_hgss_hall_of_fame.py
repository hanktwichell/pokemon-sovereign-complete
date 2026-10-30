#!/usr/bin/env python3
"""Check Johto's Hall of Fame in the test build (HeartGold's HOFCredits, translated as src/clear_game.c's
ClearGame_Johto), from the bedroom state: the player walks into the Indigo Plateau's Hall of Fame, Lance's scene and
Platinum's Hall of Fame machine play, the team goes into the Hall of Fame and the game saves, then the game starts
over; at the title, Continue wakes the player in their room in New Bark Town. The test presses A throughout (the
scene's messages, the title, Continue) and passes when the field is idle on that map.

Results: 'ok' or what went wrong, and screenshots every SHOT_FRAMES frames in OUT_DIR (shot_NNNNN.png).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_hall_of_fame.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp  # noqa: E402
from test_map_warp import walkable_tile  # noqa: E402

HALL = 'MAP_HEADER_HGSS_POKEMON_LEAGUE_HALL_OF_FAME'
HOME = 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_2F'
LIMIT = 40000
STEP = 30
PRESS_EVERY = 60
SHOT_FRAMES = 600
SYMBOLS = tuple(set(TALK_SYMBOLS))


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    d.load_state(state)
    d.run(30)

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    start_warp(d, sym, names.index(HALL), *walkable_tile(HALL), 0)  # the scene starts as the player arrives
    frames, idle, problem = 0, 0, 'not home within the time limit'
    while frames < LIMIT:
        before = u32(sym['gSovereignTestIdleFrames'])
        d.run(STEP)
        frames += STEP
        if frames % SHOT_FRAMES < STEP:
            d.screenshot().save(os.path.join(out, f'shot_{frames:05d}.png'))
        if u32(sym['gSovereignTestIdleFrames']) > before:
            idle += 1
            if idle >= 2 and u16(sym['gSovereignTestIdleMapHeaderID']) == names.index(HOME):
                problem = ''
                break
        else:
            idle = 0
        if idle == 0 and frames % PRESS_EVERY < STEP:
            d.press('A', frames=4, after=4)
    d.screenshot().save(os.path.join(out, 'end.png'))
    print(f'hall of fame: {problem or "ok"} ({frames} frames)')
    sys.exit(1 if problem else 0)


if __name__ == '__main__':
    main()
