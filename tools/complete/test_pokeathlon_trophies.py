#!/usr/bin/env python3
"""Check the Pokéathlon Dome's trophies screen (HeartGold's ScrCmd_712 3, its overlay 99's fourth app;
src/applications/complete_pokeathlon_records/trophies.c), in the test build, from the bedroom state.

1. The player warps into the Friendship Room twice (the first visit has the owner's welcome), below the player's
   statue (7, 8), turns to it and presses A: the room's script fades out and opens the screen
   (gCompleteTestPokeathlonRecordScreen: 4 for this screen, the trophies earned in all, the Friendship Trophies). A new
   game has none: no result counts as reaching a goal.
2. The test fills the screen's copy of the Pokéathlon save (gCompleteTestPokeathlonSaveCopy): each course's record
   650 points, Hurdle Dash's record 80.0 s (its Potential Trophy goal) with 432 course points, and all five medals for
   the first 12 species, then asks the screen to sum up again (the marker's fourth byte). HeartGold's rules give
   10 Collective Trophies (two a course, from 420 and 450 points), 4 Trust (12 medalists: 1, 2, 5, 10), 1 Potential and
   6 Friendship (3,250 + 432 + 60 = 3,742 points: from 3,000 to 3,600): 21 in all; both screens change.
3. B closes it and the field comes back in the room; it opens again and a touch on Return closes it.
4. A girl player (the save's gender set to female): the screen's picture is Dawn's (Complete's girl), not HeartGold's
   Lyra: her front picture's pixels where it isn't see-through, and not the boy's picture.

Results: a line per check, screenshots in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_trophies.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

from PIL import Image, ImageChops

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, header_names, symbols, u32, warp  # noqa: E402

ROOM = 'MAP_HEADER_HGSS_POKEATHLON_DOME_INTERIOR_B1F_FRIENDSHIP_ROOM'
STAND = (7, 9)  # below the player's statue (7, 8), the trophies screen's background event
FACE_DOWN = 2  # warp's dir (enum FaceDirection + 1): away from the statue, so the warp's play-out can't read it
SCREEN_TROPHIES = 4  # gCompleteTestPokeathlonRecordScreen[0]: 1 + ScrCmd_712's number
RETURN_BUTTON = (224, 176)
COURSE_POINTS, HURDLE_FRAMES, HURDLE_POINTS, MEDALISTS = 650, 80 * 30, 432, 12
WANT_TROPHIES, WANT_FRIENDSHIP = 10 + 4 + 1 + 6, 6
OPEN_LIMIT = 1500  # frames from the A press to the screen
PICTURE = (176, 192, 256, 272)  # the player's picture on the bottom screen (its sprite at (216, 40), 80x80)
DAWN = os.path.join(DECOMP, 'res', 'trainers', 'classes', 'player_female', 'front.png')
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
GENDER = 4 + 24  # PlayerSave: Options, SovereignOptions, then TrainerInfo (name[8], id, money, gender)
FEMALE = 1


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def dawn_match(shot):
    """The share of Dawn's front picture's visible pixels the screen's picture shows (each colour to 5 bits)."""
    dawn = Image.open(DAWN)
    rgb, seen, same = dawn.convert('RGB'), 0, 0
    screen = shot.crop(PICTURE)
    for y in range(80):
        for x in range(80):
            if dawn.getpixel((x, y)) == 0:
                continue
            seen += 1
            same += all(a >> 3 == b >> 3 for a, b in zip(rgb.getpixel((x, y)), screen.getpixel((x, y))))
    return same / seen


def save_offsets():
    """CompletePokeathlonSave's fields (include/complete_pokeathlon.h): magic, session, 5 course records (0x2C), the
    medals ((NATIONAL_DEX_COUNT + 3) & ~3 bytes), 10 Single event records (0x2C), 10 Link (0xA4), recordPoints[10]."""
    dex = consts('species.txt').index('SPECIES_BAD_EGG') - 2  # NATIONAL_DEX_COUNT
    courses = 8
    medals = courses + 5 * 0x2C
    solo = medals + ((dex + 3) & ~3)
    points = solo + 10 * 0x2C + 10 * 0xA4
    return courses, medals, solo, points


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPokeathlonRecordScreen', 'gCompleteTestPokeathlonSaveCopy',
                             'gSovereignTestClock', 'sSaveDataPtr'))
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
        d.run(30)
        im = d.screenshot().convert('RGB')
        im.save(os.path.join(out, name + '.png'))
        return im

    def changed(a, b, top):
        box = (0, 0, 256, 192) if top else (0, 192, 256, 384)
        return ImageChops.difference(a.crop(box), b.crop(box)).getbbox()

    def write16(addr, value):
        word = u32(d, addr & ~3)
        shift = 8 * (addr & 3)
        mem.write_long(addr & ~3, (word & ~(0xFFFF << shift)) | value << shift)

    def open_screen():
        for _ in range(2):  # the first visit's welcome walks the player; the second arrives where sent
            result, frames = warp(d, sym, ids.index(ROOM), *STAND, FACE_DOWN)
            if result != 'ok':
                return f'warp: {result} {frames}'
            if d.pos() == STAND:
                break
        d.press('UP', frames=2, after=20)  # turn to the statue
        d.press('A', after=30)
        for _ in range(OPEN_LIMIT // 30):
            if marker()[0] == SCREEN_TROPHIES:
                d.run(60)  # its fade in
                return ''
            d.press('A', after=24)  # through the room's message
        return f'no screen after {OPEN_LIMIT} frames (marker {marker()}, at {d.pos()})'

    def closed(how):
        for _ in range(30):
            d.run(30)
            if marker()[0] == 0:
                break
        idle = u32(d, sym['gSovereignTestIdleFrames'])
        d.run(60)
        here = ids[u32(d, sym['gSovereignTestIdleMapHeaderID'])]
        check(f'{how}: the screen closed (marker {marker()}) and the field runs again in the Friendship Room ({here})',
              marker()[0] == 0 and here == ROOM and u32(d, sym['gSovereignTestIdleFrames']) > idle)

    mem.write_byte(sym['gSovereignTestClock'], 12 + 1)  # noon (the clock takes the hour + 1)
    d.run(30)

    # 1. A new game's trophies: none
    problem = open_screen()
    check(f'the player\'s statue opens the trophies screen {problem}', not problem)
    if problem:
        d.screenshot().save(os.path.join(out, 'no_screen.png'))
        print(f'{len(problems)} problems')
        sys.exit(1)
    check(f'a new game has no trophies (marker {marker()})', marker()[:3] == (SCREEN_TROPHIES, 0, 0))
    save = u32(d, sym['gCompleteTestPokeathlonSaveCopy'])
    check(f'the screen\'s copy of the save is given to the test ({save:#x})', save >= 0x02000000)
    none = shot('no_trophies')

    # 2. Records and medals, then the sums again
    courses, medals, solo, points = save_offsets()
    for i in range(5):
        write16(save + courses + i * 0x2C + 6, COURSE_POINTS)  # CompletePokeathlonCourseRecord.total
    write16(save + solo, HURDLE_FRAMES)  # Hurdle Dash's best: recordsSolo[0].entries[0].result
    write16(save + points, HURDLE_POINTS)  # recordPoints[0]
    for species in range(1, MEDALISTS + 1):
        mem.write_byte(save + medals + species - 1, 0x1F)
    mem.write_byte(sym['gCompleteTestPokeathlonRecordScreen'] + 3, 1)
    seen = [marker()]
    for _ in range(60):  # until the request is taken and the counts are written (the same frame, in the game)
        d.run(5)
        seen.append(marker())
        if marker()[3] == 0 and marker()[1] != 0:
            break
    if os.environ.get('DEBUG'):
        print('markers after the request:', sorted(set(seen), key=seen.index), flush=True)
    check(f'the screen summed up again (marker {marker()})', marker()[3] == 0)
    check(f'{WANT_TROPHIES} trophies in all, {WANT_FRIENDSHIP} of them Friendship Trophies (marker {marker()})',
          marker()[1:3] == (WANT_TROPHIES, WANT_FRIENDSHIP))
    some = shot('trophies')
    check(f'the bottom screen\'s crowns and count changed ({changed(none, some, False)})',
          changed(none, some, False) is not None)
    check(f'the top screen\'s totals changed ({changed(none, some, True)})', changed(none, some, True) is not None)

    # 3. B; a touch on Return
    boy = None
    d.press('B', after=10)
    closed('B')
    problem = open_screen()
    check(f'the screen opens again {problem}', not problem)
    if not problem:
        boy = shot('return')
        d.touch(*RETURN_BUTTON, frames=4, after=10)
        closed('a touch on Return')

    # 4. A girl player: Dawn's picture
    base = u32(d, sym['sSaveDataPtr'])
    at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index('SAVE_TABLE_ENTRY_PLAYER') * 16 + 8
    gender = base + 20 + u32(d, at) + GENDER
    check(f'the save\'s player is a boy ({mem.unsigned[gender]})', mem.unsigned[gender] == 0)
    mem.write_byte(gender, FEMALE)
    problem = open_screen()
    check(f'the screen opens for a girl {problem}', not problem)
    if not problem:
        girl = shot('girl')
        share = dawn_match(girl)
        check(f'the girl\'s picture is Dawn\'s ({share:.0%} of her front picture\'s pixels)', share >= 0.95)
        if boy is not None:
            check(f'and not the boy\'s ({ImageChops.difference(boy.crop(PICTURE), girl.crop(PICTURE)).getbbox()})',
                  ImageChops.difference(boy.crop(PICTURE), girl.crop(PICTURE)).getbbox() is not None)
        d.press('B', after=10)
        closed('B (a girl)')

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
