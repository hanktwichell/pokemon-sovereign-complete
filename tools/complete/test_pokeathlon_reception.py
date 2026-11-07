#!/usr/bin/env python3
"""The Pokéathlon Dome's reception (HeartGold's standard scripts 9850 to 9852, here 11300 on: scripts_hgss_0167.s,
with CompletePokeathlon, src/overlay007/complete_pokeathlon_shop.c), in the test build, from the bedroom state.

The player warps below the first nurse's counter in the Dome's lobby (HeartGold's D49R0101, (23, 8): her script is
the reception's first) and talks: A through her lines to her menu, its first entry (to join), then the course menu's
first (the Speed Course) and Yes. The script walks the player in and starts the course; the test build's course
marker (gCompleteTestPokeathlonCourse: the course notes its frames whoever starts it) shows it running. CANCEL then
backs out of the course's choice of three Pokémon, and the course hands back to the script, which brings the field back.
With FULL set, the test plays the course instead (three Pokémon dragged in, then A and taps as
test_pokeathlon_course.py does, MINUTES at most) and reads the script's lines after it through (their screenshots
show the points it gives, "<player> received N points!").

Results: a line per check, screenshots in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_reception.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from talk_to_objects import SYMBOLS, header_names, symbols, warp  # noqa: E402

LOBBY = 'MAP_HEADER_HGSS_POKEATHLON_DOME_INTERIOR_1F'
NURSE = (23, 10)  # below the first nurse's counter (her tile (23, 8)), facing north
MENU_SHOWN = 0  # gSovereignTestMenu.shown
FRAMES = 8  # CompleteTestPokeathlonCourse.frames (include/complete_test.h)
CANCEL = (224, 176)  # the choice screen's CANCEL (test_pokeathlon_select.py)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPokeathlonCourse', 'gSovereignTestMenu'))
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    course = sym['gCompleteTestPokeathlonCourse']
    problems = []
    shots = [0]

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def shot(name):
        shots[0] += 1
        d.screenshot().save(os.path.join(out, f'{shots[0]:02d}_{name}.png'))

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def menus():
        return u32(sym['gSovereignTestMenu'] + MENU_SHOWN)

    def press(key, after=40, times=1):
        for _ in range(times):
            d.press(key, frames=4, after=after)

    def until_menu(limit=80):
        before = menus()
        for _ in range(limit):
            if menus() != before:
                break
            press('A', after=30)
        d.run(60)  # the menu is noted as it's made, before it takes input
        return menus() != before

    def drag(start, end):
        (x1, y1), (x2, y2) = start, end
        for i in range(13):
            d.emu.input.touch_set_pos(round(x1 + (x2 - x1) * i / 12), round(y1 + (y2 - y1) * i / 12))
            d.run(3)
        d.run(6)
        d.emu.input.touch_release()
        d.run(70)

    def field_idle(frames=60):
        before = u32(sym['gSovereignTestIdleFrames'])
        d.run(frames)
        return u32(sym['gSovereignTestIdleFrames']) - before > frames // 3

    d.run(30)
    result, _ = warp(d, sym, names.index(LOBBY), NURSE[0], NURSE[1], 2)
    check(f'warped below the reception {NURSE} ({result})', result == 'ok')
    d.press('UP', frames=2, after=30)
    mem.write_short(sym['gSovereignTestScripts'], 0)
    check('the nurse\'s menu', until_menu())
    shot('reception_menu')
    press('A', after=60)  # join
    check('the course menu', until_menu())
    shot('course_menu')
    press('A', after=60)  # the Speed Course
    check('the question', until_menu())
    shot('question')
    frames = u32(course + FRAMES)
    press('A', after=60)  # Yes
    for _ in range(120):  # the walk in, the door, the fanfare and lines, then the fade and the course
        if u32(course + FRAMES) != frames:
            break
        press('A', after=30)
    d.run(240)
    shot('course')
    check(f'the course runs (its frames {frames} to {u32(course + FRAMES)})', u32(course + FRAMES) > frames)

    if os.environ.get('FULL'):
        # The whole course: three Pokémon dragged in, YES, then play along (A and taps, as test_pokeathlon_course.py)
        # until the course stops and the script's lines after it are read through
        from test_pokeathlon_course import ICONS, SLOTS, YES, TAPS
        for icon, slot in zip(ICONS, SLOTS):
            drag(icon, slot)
        d.touch(*YES, frames=6, after=60)
        last, still, frame = u32(course + FRAMES), 0, 0
        while frame < float(os.environ.get('MINUTES', '30')) * 3600:
            d.run(10)
            frame += 10
            now = u32(course + FRAMES)
            still = still + 10 if now == last else 0
            last = now
            if still > 900:  # the course has ended
                break
            if frame % 120 == 0:
                d.press('A', frames=4, after=4)
            elif frame % 120 in (40, 80):
                d.touch(*TAPS[frame // 120 % len(TAPS)], frames=4, after=4)
            if frame % 3000 == 0:
                shot(f'course_{frame // 60}s')
        # (the marker's own results are the test hook's arguments, not these: the points show in the script's line)
        check(f'the course played and ended ({u32(course + FRAMES)} frames)', u32(course + FRAMES) > 1000)
        for _ in range(60):  # the script's lines after the course: the points, the records
            if field_idle():
                break
            press('A', after=40)
            if _ % 6 == 0:
                shot('after_course')
    else:
        # Back out of the choice of three Pokémon (its CANCEL, by touch: the screen is HeartGold's touch screen): the
        # course ends unplayed, the script brings the field back
        d.touch(*CANCEL, frames=6, after=120)
        d.run(300)
        shot('cancelled')
    for _ in range(40):
        if field_idle():
            break
        press('A', after=40)
    shot('back')
    check('the field runs again' if os.environ.get('FULL') else 'backed out: the field runs again', field_idle())

    print(f'{len(problems)} problems')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
