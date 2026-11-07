#!/usr/bin/env python3
"""Check the Pokéathlon course's first screen, choosing three Pokémon (HeartGold's overlay 97, its assembly as it is in
the overlay complete_pokeathlon_select: decomp/asm/complete_hgss/, src/applications/complete_pokeathlon/), in the test
build, from the bedroom state. Nothing in the game opens it yet; the test build's hook does
(gCompleteTestPokeathlonSelect, include/complete_test.h: open = the course + 1, supreme; the marker records the
screen's step, its runs, the picks, the heap and HeartGold's own answer).

1. The Speed Course: the field closes and the screen opens on the party (its top screen shows the lead's stars); the
   application heap had room for the screen's 0x72000 with the field closed.
2. The first three party Pokémon are dragged into the three slots by touch, as in HeartGold; "Are these three OK?"
   comes up; YES ends it: three chosen (cancelled 0), the party's slots 0 to 2, HeartGold's entrants the same species
   as the party's first three, the screen's heap back whole (nothing leaked), the field running again.
3. The Supreme Cup's Jump Course: the screen opens again with that course's name, and CANCEL ends it at once
   (cancelled 1), the field running again.

Results: a line per check, screenshots in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_select.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

from PIL import ImageChops

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
from gift_pokemon import MON, PARTY  # noqa: E402
from talk_to_objects import SYMBOLS, symbols, u32  # noqa: E402

SPEED, JUMP = 0, 4  # the courses: Speed, Power, Skill, Stamina, Jump
HEAP_SIZE = 0x72000  # the screen's heap (HeartGold's course heap)
HEAP_BOOKKEEPING = 0x100  # what a heap keeps for itself: more missing after the exit is a leak
PARTY_BOX = 18  # picks' box for the party
STEP_SCREEN = 2
# The bottom screen (touch coordinates): the party's icons, the three slots, YES on the prompt, CANCEL
ICONS = [(18, 40), (42, 40), (66, 40)]
SLOTS = [(212, 48), (212, 88), (212, 128)]
YES, CANCEL = (222, 138), (224, 176)
# CompleteTestPokeathlonSelect (include/complete_test.h): u8 open, supreme, step, runs, picks[3][2]; u16; u32 appFree,
# heapFree, heapLeft; HgssPokeathlonCourseArgs (16 bytes); HgssPokeathlonSelectArgs: courseArgs, cancelled, unk[4],
# entrants[3] (0x28 bytes: u16 species, form; ...), course
ARGS = 40
ENTRANT_SIZE = 0x28


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPokeathlonSelect', 'gSovereignTestParty'))
    d = Driver(rom, state)
    mem = d.emu.memory
    at = sym['gCompleteTestPokeathlonSelect']
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def marker():
        b = bytes(mem.unsigned[at:at + ARGS + 12 + 3 * ENTRANT_SIZE])
        app_free, heap_free, heap_left = struct.unpack_from('<3I', b, 12)
        return {'open': b[0], 'step': b[2], 'runs': b[3], 'picks': [tuple(b[4 + 2 * i:6 + 2 * i]) for i in range(3)],
                'appFree': app_free, 'heapFree': heap_free, 'heapLeft': heap_left,
                'cancelled': struct.unpack_from('<I', b, ARGS + 4)[0],
                'species': [struct.unpack_from('<H', b, ARGS + 12 + ENTRANT_SIZE * i)[0] for i in range(3)]}

    def party_species():
        party = sym['gSovereignTestParty']
        mem.write_byte(party + PARTY['wanted'], 1)
        for _ in range(60):
            d.run(2)
            if mem.unsigned[party + PARTY['wanted']] == 0:
                break
        size = struct.calcsize(MON)
        return [struct.unpack(MON, bytes(mem.unsigned[party + PARTY['mons'] + i * size:party + PARTY['mons'] + (i + 1) * size]))[0]
                for i in range(mem.unsigned[party + PARTY['count']])]

    def open_screen(course, supreme):
        runs = marker()['runs']
        mem.write_byte(at + 1, int(supreme))
        mem.write_byte(at + 0, course + 1)
        for _ in range(40):
            d.run(30)
            if marker()['step'] == STEP_SCREEN:
                d.run(90)  # its fade in
                return True
        return marker()['runs'] != runs and False

    def back_on_field(what, runs):
        for _ in range(40):
            d.run(30)
            m = marker()
            if m['open'] == 0 and m['step'] == 0:
                break
        idle = u32(d, sym['gSovereignTestIdleFrames'])
        d.run(90)
        m = marker()
        check(f'{what}: the screen ended and the field runs again (marker open {m["open"]}, step {m["step"]}, runs '
              f'{m["runs"]})', m['open'] == 0 and m['step'] == 0 and m['runs'] == runs + 1
              and u32(d, sym['gSovereignTestIdleFrames']) > idle)

    def drag(start, end):
        (x1, y1), (x2, y2) = start, end
        for i in range(13):
            d.emu.input.touch_set_pos(round(x1 + (x2 - x1) * i / 12), round(y1 + (y2 - y1) * i / 12))
            d.run(3)
        d.run(6)
        d.emu.input.touch_release()
        d.run(70)

    def shot(name):
        im = d.screenshot().convert('RGB')
        im.save(os.path.join(out, name + '.png'))
        return im

    d.run(30)
    party = party_species()
    check(f'the bedroom state\'s party has three Pokémon or more ({party})', len(party) >= 3)

    # 1. The Speed Course
    opened = open_screen(SPEED, False)
    m = marker()
    check(f'the Speed Course\'s screen opens (step {m["step"]})', opened)
    if not opened:
        shot('no_screen')
        print(f'{len(problems)} problems')
        sys.exit(1)
    check(f'the application heap had room for the screen\'s ({m["appFree"]:#x} free, {HEAP_SIZE:#x} needed)',
          m['appFree'] >= HEAP_SIZE)
    first = shot('speed_course')

    # 2. Three dragged in, YES
    for i, (icon, slot) in enumerate(zip(ICONS, SLOTS)):
        drag(icon, slot)
        shot(f'picked_{i + 1}')
    prompt = shot('are_these_three_ok')
    check(f'the prompt comes up on the bottom screen ({ImageChops.difference(first.crop((0, 192, 256, 384)), prompt.crop((0, 192, 256, 384))).getbbox()})',
          ImageChops.difference(first.crop((0, 192, 256, 384)), prompt.crop((0, 192, 256, 384))).getbbox() is not None)
    runs = marker()['runs']
    d.touch(*YES, frames=6, after=40)
    m = marker()
    check(f'YES: three chosen (cancelled {m["cancelled"]})', m['cancelled'] == 0)
    check(f'the party\'s first three slots ({m["picks"]})', m['picks'] == [(PARTY_BOX, 0), (PARTY_BOX, 1), (PARTY_BOX, 2)])
    check(f'HeartGold\'s entrants are the party\'s first three ({m["species"]} against {party[:3]})', m['species'] == party[:3])
    check(f'the screen used its heap and gave it all back (lowest free {m["heapFree"]:#x}, after {m["heapLeft"]:#x} of '
          f'{HEAP_SIZE:#x})', m['heapFree'] < HEAP_SIZE and m['heapLeft'] >= HEAP_SIZE - HEAP_BOOKKEEPING)
    back_on_field('YES', runs)
    shot('field_after')

    # 3. The Supreme Cup's Jump Course, CANCEL
    runs = marker()['runs']
    opened = open_screen(JUMP, True)
    check(f'the Supreme Cup\'s Jump Course opens (step {marker()["step"]})', opened)
    if opened:
        jump = shot('supreme_jump_course')
        check(f'its top screen differs from the Speed Course\'s ({ImageChops.difference(first.crop((0, 0, 256, 24)), jump.crop((0, 0, 256, 24))).getbbox()})',
              ImageChops.difference(first.crop((0, 0, 256, 24)), jump.crop((0, 0, 256, 24))).getbbox() is not None)
        d.touch(*CANCEL, frames=6, after=40)
        check(f'CANCEL: none chosen (cancelled {marker()["cancelled"]})', marker()['cancelled'] == 1)
        back_on_field('CANCEL', runs)

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
