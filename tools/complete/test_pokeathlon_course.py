#!/usr/bin/env python3
"""Run HeartGold's Pokéathlon course (its overlay 96 and the overlays 97 and 98 it loads, its assembly as it is in the
overlay complete_pokeathlon_course: decomp/asm/complete_hgss/, src/applications/complete_pokeathlon/) in the test
build, from the bedroom state, as far as it goes, and say how far that was. Nothing in the game starts a course yet;
the test build's hook does (gCompleteTestPokeathlonCourse, include/complete_test.h: open = the course + 1, supreme;
the marker records the course's step, its state each frame, its event, the heap and its results).

1. The course starts: the field closes, the course makes its heap (0x72000 from the application heap) and runs.
2. Its choice of three Pokémon (overlay 97) comes up: the party's first three are dragged in by touch, then YES.
3. From there on the test presses A now and then and taps the bottom screen (its middle, and the event screens'
   start button), as a player playing along roughly would, and notes each state the course reaches (its state
   function's index, and that of what it runs) and each event, with a screenshot of each, until the course ends and
   the field runs again, or nothing has changed for STALL frames.

Results: each state and event reached, then a line per check (the course ended, its heap came back whole, its
results), screenshots in OUT_DIR. COURSE (0-4, default 0, Speed) and SUPREME (1) pick the course; MINUTES (default
30) is how long the test plays at most; STALL (default 8000 frames: an event's play runs over a minute) how long it
waits on a state that doesn't change; SAVE_STALL=FILE saves an emulator state there when it stalls, to look into it.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_course.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
from talk_to_objects import SYMBOLS, symbols, u32  # noqa: E402

HEAP_SIZE = 0x72000  # the course's heap (HeartGold's)
HEAP_BOOKKEEPING = 0x100  # what a heap keeps for itself: more missing after the exit is a leak
STEP_COURSE = 2
# The choice screen's bottom screen (touch coordinates, as tools/complete/test_pokeathlon_select.py): the party's
# icons, the three slots, YES on the prompt
ICONS = [(18, 40), (42, 40), (66, 40)]
SLOTS = [(212, 48), (212, 88), (212, 128)]
YES = (222, 138)
# Where the play-along taps: the middle of the bottom screen (an event's Pokémon), and the event screens' start button
# (its bottom right corner: HeartGold's ov96_0221BA20, 192-255 by 152-183)
TAPS = [(128, 96), (224, 168), (128, 140), (224, 168)]
# CompleteTestPokeathlonCourse (include/complete_test.h): u8 open, supreme, step, runs, state, eventState, eventIndex,
# event; u32 frames, appFree, heapFree, heapLeft; HgssPokeathlonCourseArgs (16 bytes: the save, the mode, then
# HeartGold's results: u16 points, u16 score, u8 course, medal, result, supreme); the course's data
SIZE = 44
# HeartGold's event numbers (the courses' rows in ov96_0221A934: Speed 0, 1, 6; Power 3, 2, 9; Skill 8, 9, 1;
# Stamina 7, 6, 3; Jump 5, 4, 0)
EVENTS = ['Hurdle Dash', 'Pennant Capture', 'Circle Push', 'Block Smash', 'Disc Catch', 'Lamp Jump', 'Relay Run',
          'Ring Drop', 'Snow Throw', 'Goal Roll']


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    course = int(os.environ.get('COURSE', '0'))
    supreme = int(os.environ.get('SUPREME', '0'))
    minutes = float(os.environ.get('MINUTES', '30'))
    stall = int(os.environ.get('STALL', '8000'))
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPokeathlonCourse',))
    d = Driver(rom, state)
    mem = d.emu.memory
    at = sym['gCompleteTestPokeathlonCourse']
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def marker():
        b = bytes(mem.unsigned[at:at + SIZE])
        frames, app_free, heap_free, heap_left = struct.unpack_from('<4I', b, 8)
        points, score = struct.unpack_from('<2H', b, 24 + 8)
        return {'open': b[0], 'step': b[2], 'runs': b[3], 'state': b[4], 'eventState': b[5], 'eventIndex': b[6],
                'event': b[7], 'frames': frames, 'appFree': app_free, 'heapFree': heap_free, 'heapLeft': heap_left,
                'points': points, 'score': score, 'course': b[24 + 12], 'medal': b[24 + 13], 'result': b[24 + 14],
                'data': struct.unpack_from('<I', b, 40)[0]}

    def shot(name):
        d.screenshot().convert('RGB').save(os.path.join(out, name + '.png'))

    def drag(start, end):
        (x1, y1), (x2, y2) = start, end
        for i in range(13):
            d.emu.input.touch_set_pos(round(x1 + (x2 - x1) * i / 12), round(y1 + (y2 - y1) * i / 12))
            d.run(3)
        d.run(6)
        d.emu.input.touch_release()
        d.run(70)

    d.run(30)
    runs = marker()['runs']
    mem.write_byte(at + 1, supreme)
    mem.write_byte(at + 0, course + 1)
    for _ in range(40):
        d.run(30)
        if marker()['step'] == STEP_COURSE and marker()['frames'] > 0:
            break
    m = marker()
    check(f'the course starts (step {m["step"]}, {m["frames"]} frames, state {m["state"]})', m['step'] == STEP_COURSE
          and m['frames'] > 0)
    if m['step'] != STEP_COURSE:
        shot('no_course')
        print(f'{len(problems)} problems')
        sys.exit(1)
    check(f'the application heap had room for the course\'s ({m["appFree"]:#x} free, {HEAP_SIZE:#x} needed)',
          m['appFree'] >= HEAP_SIZE)

    # the choice screen: wait for its fade in, drag three in, YES
    d.run(240)
    shot('choose')
    for icon, slot in zip(ICONS, SLOTS):
        drag(icon, slot)
    shot('chosen')
    d.touch(*YES, frames=6, after=60)

    # then play along: A every so often, a tap on the bottom screen, and note each state and event reached
    seen, last_change, frame = set(), 0, 0
    last = None
    while frame < minutes * 60 * 60:
        d.run(10)
        frame += 10
        m = marker()
        if m['step'] != STEP_COURSE:
            break
        key = (m['state'], m['eventState'], m['eventIndex'], m['event'])
        if key != last:
            last, last_change = key, frame
            if key not in seen:
                seen.add(key)
                # A course has three events: index 3 is past them (its closing and results)
                if m['eventIndex'] >= 3:
                    event = 'after the events'
                else:
                    event = EVENTS[m['event']] if m['event'] < len(EVENTS) else m['event']
                print(f'  frame {m["frames"]}: state {m["state"]} ({m["eventState"]}), event index {m["eventIndex"]} '
                      f'({event}), heap low {m["heapFree"]:#x}', flush=True)
                shot(f'state_{m["state"]:02d}_{m["eventState"]:02d}_event_{m["eventIndex"]}_{m["event"]}')
        if frame - last_change > stall:
            frames = m['frames']
            d.run(60)
            print(f'  nothing changed for {stall} frames (state {m["state"]} ({m["eventState"]}); the course\'s frame '
                  f'{"still runs" if marker()["frames"] > frames else "has stopped"}, its data at {m["data"]:#x})',
                  flush=True)
            shot('stalled')
            if os.environ.get('SAVE_STALL'):
                d.emu.savestate.save_file(os.environ['SAVE_STALL'])
            break
        if frame % 120 == 0:
            d.press('A', frames=4, after=4)
        elif frame % 120 in (40, 80):
            d.touch(*TAPS[frame // 120 % len(TAPS)], frames=4, after=4)

    for _ in range(60):
        m = marker()
        if m['step'] == 0:
            break
        d.run(30)
    m = marker()
    check(f'the course ended and the field runs again (step {m["step"]}, runs {m["runs"]}, the last state '
          f'{m["state"]} ({m["eventState"]}))', m['step'] == 0 and m['runs'] == runs + 1)
    if m['step'] == 0:
        idle = u32(d, sym['gSovereignTestIdleFrames'])
        d.run(90)
        check('the field takes input again', u32(d, sym['gSovereignTestIdleFrames']) > idle)
        shot('field_after')
        check(f'the course used its heap and gave it all back (lowest free {m["heapFree"]:#x}, at its end '
              f'{m["heapLeft"]:#x} of {HEAP_SIZE:#x})', m['heapFree'] < HEAP_SIZE
              and m['heapLeft'] >= HEAP_SIZE - HEAP_BOOKKEEPING)
        print(f'  results: points {m["points"]}, score {m["score"]}, course {m["course"]}, medal {m["medal"]}, '
              f'result {m["result"]}')
    print(f'{len(seen)} states and events seen; {len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
