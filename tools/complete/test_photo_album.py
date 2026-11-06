#!/usr/bin/env python3
"""HeartGold's photo album (include/complete_photo.h), in the test build, from the bedroom state, as a player would.

1. Cameron on Route 1 (there on Mondays): beside him, talk, yes. His photo: the map loads again at photo spot 72
   with only the player and the party, the viewfinder, the shutter; the album has the photo (gCompleteTestPhotoCount),
   and the player is back where his script walked them, the script ending as it does.
2. The PC in Cherrygrove City's Pokémon Center, walked up to: Player's PC, PHOTO ALBUM (there with a photo); in the
   album, A on the first photo and A on VIEW: the photo shows (gCompleteTestViewState: the field task looking at it),
   its caption on the bottom screen; B back to the album, B out of it, and the PC's menus backed out of, the player
   where they stood.

Results: a line per check, screenshots in OUT_DIR (every SHOT frames of the photo with SHOTS=1), and the count of
problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_photo_album.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from gift_pokemon import talk_and_answer  # noqa: E402
from battle_all_trainers import DECOMP, TEST_BUILD  # noqa: E402
from talk_to_objects import SYMBOLS, header_names, symbols, warp  # noqa: E402

SOUTH = 2  # the test warp's facing: enum FaceDirection + 1
CLOCK_WEEKDAY = 2  # offsetof(struct SovereignTestClock, weekday)
ROUTE_1 = 'MAP_HEADER_HGSS_ROUTE_1'
BESIDE_CAMERON = (1036, 319)  # north of him at (1036, 320)
PHOTO_SPOT = (1036, 316)  # spot 72: his script walks the player there
MONDAY, NOON = 1, 12
LIMIT = 6000
SHOT = 30
PC_MAP = 'MAP_HEADER_HGSS_CHERRYGROVE_POKECENTER_1F'
BELOW_PC = (11, 13)  # the PC at (11, 12), used facing north
WALK_TO_PC = 2  # steps up to it from the test warp
NORTH = 1
PLAYERS_PC, PHOTO_ALBUM = 1, 2  # their entries in the PC's menus
VIEW_WAIT, VIEW_LOOK = 1, 6  # complete_photo.c's enum ViewAlbumState
NO_VIEW = 0xFF


def data_symbol(name):
    """The address of an initialised (.data) symbol, from the test build's map; symbols() reads .bss ones."""
    xmap = open(os.path.join(DECOMP, TEST_BUILD, 'main.nef.xMAP'), encoding='utf-8', errors='replace').read()
    return int(re.search(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.data\s+' + name + r'\b', xmap, re.M).group(1), 16)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestMenu', 'gSovereignTestClock', 'gCompleteTestPhotoCount'))
    sym['gCompleteTestViewState'] = data_symbol('gCompleteTestViewState')
    ids = header_names()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    d.load_state(state)
    d.run(30)
    mem.write_byte(sym['gSovereignTestClock'], NOON + 1)
    mem.write_byte(sym['gSovereignTestClock'] + CLOCK_WEEKDAY, MONDAY + 1)
    d.run(30)
    arrived, _ = warp(d, sym, ids.index(ROUTE_1), *BESIDE_CAMERON, 0)
    if arrived == 'ok':
        arrived, _ = warp(d, sym, ids.index(ROUTE_1), *BESIDE_CAMERON, SOUTH)
    check(f'beside Cameron on Route 1 ({arrived})', arrived == 'ok')
    if arrived != 'ok':
        print(f'{len(problems)} problems')
        sys.exit(1)
    d.screenshot().save(os.path.join(out, 'cameron.png'))
    before = mem.unsigned[sym['gCompleteTestPhotoCount']]

    if os.environ.get('SHOTS'):
        real_run, count = d.run, [0]

        def run(n):
            for _ in range(n):
                real_run(1)
                count[0] += 1
                if count[0] % SHOT == 0:
                    d.screenshot().save(os.path.join(out, f'photo_{count[0]:05d}.png'))
        d.run = run

    result, frames = talk_and_answer(d, sym, [True], LIMIT)
    check(f'his photo plays out ({result}, {frames} frames)', result == 'ok')
    d.screenshot().save(os.path.join(out, 'after.png'))
    after = mem.unsigned[sym['gCompleteTestPhotoCount']]
    check(f'the album has the photo ({before} -> {after})', after == before + 1)
    check(f'back on the photo spot {PHOTO_SPOT} (at {d.pos()})', tuple(d.pos()) == PHOTO_SPOT)
    d.run = real_run if os.environ.get('SHOTS') else d.run

    # 2. The album from the PC, and the photo looked at
    def view_state():
        return mem.unsigned[sym['gCompleteTestViewState']]

    def wait_for(state, limit=2400):
        for frames in range(0, limit, 10):
            if view_state() == state:
                return frames
            d.run(10)
        return None

    # two steps south of it, walked up: the way back must be where the player stands, not where they came in
    arrived, _ = warp(d, sym, ids.index(PC_MAP), BELOW_PC[0], BELOW_PC[1] + WALK_TO_PC, 0)
    if arrived == 'ok':
        arrived, _ = warp(d, sym, ids.index(PC_MAP), BELOW_PC[0], BELOW_PC[1] + WALK_TO_PC, NORTH)
    for _ in range(WALK_TO_PC):
        d.press('UP', frames=8, after=16)
    check(f'below the PC in Cherrygrove\'s Pokémon Center ({arrived}, at {d.pos()})',
          arrived == 'ok' and tuple(d.pos()) == BELOW_PC)
    result, frames = talk_and_answer(d, sym, [PLAYERS_PC, PHOTO_ALBUM], LIMIT, done=lambda: view_state() != NO_VIEW)
    opened = wait_for(VIEW_WAIT)
    check(f'Player\'s PC, PHOTO ALBUM: the album opens ({result}, {opened})', opened is not None)
    d.run(90)
    d.screenshot().save(os.path.join(out, 'album.png'))
    d.press('A', frames=4, after=40)
    d.screenshot().save(os.path.join(out, 'album_menu.png'))
    d.press('A', frames=4, after=10)
    looking = wait_for(VIEW_LOOK)
    check(f'VIEW: the photo shows ({looking} frames)', looking is not None)
    d.run(90)
    d.screenshot().save(os.path.join(out, 'viewing.png'))
    d.press('B', frames=4, after=10)
    back = wait_for(VIEW_WAIT)
    check(f'B: back in the album ({back} frames)', back is not None)
    d.run(90)
    d.screenshot().save(os.path.join(out, 'album_again.png'))
    d.press('B', frames=4, after=10)
    closed = wait_for(NO_VIEW)
    check(f'B: out of the album ({closed} frames)', closed is not None)
    result, frames = talk_and_answer(d, sym, [None, None], LIMIT, press_a=False)
    d.screenshot().save(os.path.join(out, 'pc_after.png'))
    check(f'the PC\'s menus backed out of ({result}, {frames} frames)', result == 'ok')
    check(f'below the PC still (at {d.pos()})', tuple(d.pos()) == BELOW_PC)
    check(f'the album still has the photo ({mem.unsigned[sym["gCompleteTestPhotoCount"]]})',
          mem.unsigned[sym['gCompleteTestPhotoCount']] == before + 1)

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
