#!/usr/bin/env python3
"""Check the Pokéathlon Dome's course record screen (HeartGold's ScrCmd_712 0, its overlay 99's first app;
src/applications/complete_pokeathlon_records/), in the test build, from the bedroom state.

1. The player warps into the Solidarity Room, below its medals (6-10, 8), turns to them and presses A: the room's
   script fades out and opens the screen on the first course (gCompleteTestPokeathlonRecordScreen: the screen, the page
   drawn, the cursor). A new game's records are empty.
2. The test fills the open screen's copy of two courses' records (gCompleteTestPokeathlonCourseRecords): the Power
   Course with 470 points (three events and the bonus) by a Pikachu, a shiny Marill and a Togepi, and the Skill Course
   by Pokémon past HeartGold's 493 (a Sylveon, a Rillaboom, an Alolan Vulpix). RIGHT turns to each: the page and cursor
   follow, and both screens' pictures change from the empty first page.
3. LEFT goes back a page; a touch on the fifth course's button goes there; RIGHT past it reaches Return; A on Return
   closes the screen, and the field comes back in the Solidarity Room.
4. The screen opens again, and B closes it; then a touch on Return closes it.

Results: a line per check, screenshots of each page in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_records.py \\
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

ROOM = 'MAP_HEADER_HGSS_POKEATHLON_DOME_INTERIOR_B1F_SOLIDARITY_ROOM'
STAND = (8, 9)  # below the middle medal (8, 8): the record screen's background event
FACE_DOWN = 2  # warp's dir (enum FaceDirection + 1): away from the medals, so the warp's play-out can't talk to them
SCREEN_COURSE_RECORD = 1  # gCompleteTestPokeathlonRecordScreen[0]: 1 + ScrCmd_712's number
RETURN = 5  # the cursor on Return
COURSE_BUTTONS = [(208, 16), (240, 48), (208, 80), (240, 112), (208, 144)]  # the bottom screen's (sHitTable)
RETURN_BUTTON = (224, 176)
RECORD_SIZE = 0x2C  # CompletePokeathlonCourseRecord: u16 eventPoints[3], total; 3 x (u32 bits, personality, unused)
POWER, SKILL = 1, 2
RECORDS = {
    POWER: ((140, 152, 136), 470, [('SPECIES_PIKACHU', 0, 1, False), ('SPECIES_MARILL', 0, 0, True),
                                   ('SPECIES_TOGEPI', 0, 1, False)]),
    SKILL: ((101, 99, 120), 335, [('SPECIES_SYLVEON', 0, 1, False), ('SPECIES_RILLABOOM', 0, 0, False),
                                  ('SPECIES_VULPIX', 1, 1, False)]),
}
OPEN_LIMIT = 1500  # frames from the A press to the screen


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPokeathlonRecordScreen', 'gCompleteTestPokeathlonCourseRecords',
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
        return tuple(mem.unsigned[at:at + 3])

    def shot(name):
        d.run(40)  # the page's slide
        im = d.screenshot().convert('RGB')
        im.save(os.path.join(out, name + '.png'))
        return im

    def changed(a, b, top):
        box = (0, 0, 256, 192) if top else (0, 192, 256, 384)
        return ImageChops.difference(a.crop(box), b.crop(box)).getbbox()

    def open_screen():
        result, frames = warp(d, sym, ids.index(ROOM), *STAND, FACE_DOWN)
        if result != 'ok':
            return f'warp: {result} {frames}'
        d.press('UP', frames=2, after=20)  # turn to the medals
        d.press('A', after=30)
        for _ in range(OPEN_LIMIT // 30):
            if marker()[0] == SCREEN_COURSE_RECORD:
                d.run(60)  # its fade in
                return ''
            d.press('A', after=24)  # through the room's message
        return f'no screen after {OPEN_LIMIT} frames (marker {marker()})'

    def closed(how):
        for _ in range(30):
            d.run(30)
            if marker()[0] == 0 and u32(d, sym['gSovereignTestIdleFrames']) > 0:
                break
        idle = u32(d, sym['gSovereignTestIdleFrames'])
        d.run(60)
        here = ids[u32(d, sym['gSovereignTestIdleMapHeaderID'])]
        check(f'{how}: the screen closed (marker {marker()}) and the field runs again in the Solidarity Room '
              f'({here}, idle frames {idle} then {u32(d, sym["gSovereignTestIdleFrames"])})',
              marker()[0] == 0 and here == ROOM and u32(d, sym['gSovereignTestIdleFrames']) > idle)

    def fill(course, events, total, mons):
        base = u32(d, sym['gCompleteTestPokeathlonCourseRecords']) + course * RECORD_SIZE
        data = struct.pack('<4H', *events, total)
        for i, (species, form, gender, shiny) in enumerate(mons):
            bits = species_ids.index(species) | form << 11 | gender << 16 | int(shiny) << 18
            data += struct.pack('<3I', bits, 0x1234567 * (i + 1) & 0xffffffff, 0)
        for i in range(0, len(data), 4):
            mem.write_long(base + i, struct.unpack_from('<I', data, i)[0])

    mem.write_byte(sym['gSovereignTestClock'], 12)  # noon
    d.run(30)

    # 1. The screen, on the first course
    problem = open_screen()
    check(f'the Solidarity Room\'s medals open the course record screen {problem}', not problem)
    if problem:
        d.screenshot().save(os.path.join(out, 'no_screen.png'))
        print(f'{len(problems)} problems')
        sys.exit(1)
    check(f'it opens on the first course, the cursor on it (marker {marker()})', marker() == (1, 1, 0))
    check('the open screen\'s course records are given to the test',
          u32(d, sym['gCompleteTestPokeathlonCourseRecords']) >= 0x02000000)
    empty = shot('speed_course_empty')

    # 2. Two courses' records
    for course, (events, total, mons) in RECORDS.items():
        fill(course, events, total, mons)
    d.press('RIGHT', frames=2, after=10)
    check(f'RIGHT: the Power Course (marker {marker()})', marker() == (1, 2, 1))
    power = shot('power_course')
    check(f'the Power Course\'s record shows on the top screen ({changed(empty, power, True)})',
          changed(empty, power, True) is not None)
    check(f'and on the bottom screen ({changed(empty, power, False)})', changed(empty, power, False) is not None)
    d.press('RIGHT', frames=2, after=10)
    check(f'RIGHT: the Skill Course (marker {marker()})', marker() == (1, 3, 2))
    skill = shot('skill_course')
    check(f'the Skill Course\'s record (Pokémon past 493) shows ({changed(empty, skill, True)})',
          changed(empty, skill, True) is not None and changed(power, skill, True) is not None)

    # 3. Back, a touch, Return
    d.press('LEFT', frames=2, after=10)
    check(f'LEFT: back to the Power Course (marker {marker()})', marker() == (1, 2, 1))
    shot('power_course_back')
    d.touch(*COURSE_BUTTONS[4], frames=4, after=10)
    check(f'a touch on the fifth button: the Jump Course (marker {marker()})', marker() == (1, 5, 4))
    shot('jump_course')
    d.press('RIGHT', frames=2, after=10)
    check(f'RIGHT past the fifth: Return (marker {marker()})', marker()[2] == RETURN)
    shot('return')
    d.press('RIGHT', frames=2, after=10)
    check(f'RIGHT on Return stays there (marker {marker()})', marker()[2] == RETURN)
    d.press('A', after=10)
    closed('A on Return')
    shot('field_after')

    # 4. B, and a touch on Return
    problem = open_screen()
    check(f'the screen opens again {problem}', not problem)
    if not problem:
        d.press('B', after=10)
        closed('B')
    problem = open_screen()
    check(f'and again {problem}', not problem)
    if not problem:
        d.touch(*RETURN_BUTTON, frames=4, after=10)
        closed('a touch on Return')

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
