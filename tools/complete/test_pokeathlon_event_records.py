#!/usr/bin/env python3
"""Check the Pokéathlon Dome's event record screen (HeartGold's ScrCmd_712 2, its overlay 99's PokeathlonEventRecord;
src/applications/complete_pokeathlon_records/event_record.c), in the test build, from the bedroom state.

1. The player warps into the Potential Room, below its board (6-8, 11), turns to it and presses A: the room's script
   fades out and opens the screen (gCompleteTestPokeathlonRecordScreen: 3 for this screen, 1 + the event shown, the
   cursor, a test's request, Link mode) in Single mode on Hurdle Dash. A new game has only HeartGold's default record
   (Chikorita, Cyndaquil and Totodile) in each event.
2. The test fills the open screen's copy of the Single records (gCompleteTestPokeathlonEventRecords): Hurdle Dash
   in 80.0 s (beating the default 100 s; lower is better there) by Pikachu, Marill and a Sylveon past HeartGold's 493,
   joined 7 times, its course points 432; Relay Run 15.5 laps (beating 12); and asks the screen to redraw (the
   marker's fourth byte). Hurdle Dash's page changes on both screens.
3. The cursor: RIGHT to Pennant Capture, DOWN to Relay Run (the panels are 5 by 2), UP twice to the Single/Link
   button, A switches to Link mode and back.
4. DOWN from the button to its column's event, DOWN twice to Return, A closes the screen and the field comes back in
   the Potential Room. The screen opens again: a touch on the last panel picks Goal Roll, B closes it; and once more,
   a touch on Return closes it.

Results: a line per check, screenshots in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_event_records.py \\
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

ROOM = 'MAP_HEADER_HGSS_POKEATHLON_DOME_INTERIOR_B1F_POTENTIAL_ROOM'
STAND = (7, 12)  # below the board's middle (7, 11)
FACE_DOWN = 2  # warp's dir (enum FaceDirection + 1): away from the board, so the warp's play-out can't read it
SCREEN_EVENTS = 3  # gCompleteTestPokeathlonRecordScreen[0]: 1 + ScrCmd_712's number
MODE, RETURN = 255, 10  # the cursor on the Single/Link button (-1 as a byte) and on Return
HURDLE_DASH, PENNANT_CAPTURE, RELAY_RUN, GOAL_ROLL = 0, 1, 6, 9
# CompletePokeathlonSave from its Single records: 10 x RecordsSolo (5 x {u16 result; u16 mons[3]}, u32 timesJoined),
# 10 x RecordsLink (0xA4), then u16 recordPoints[10]
SOLO_SIZE, LINK_SIZE, TIMES_JOINED = 0x2C, 0xA4, 0x28
RECORD_POINTS = 10 * SOLO_SIZE + 10 * LINK_SIZE
LAST_PANEL, RETURN_BUTTON = (224, 136), (224, 176)  # the bottom screen's
OPEN_LIMIT = 1500  # frames from the A press to the screen


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPokeathlonRecordScreen', 'gCompleteTestPokeathlonEventRecords',
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
        return tuple(mem.unsigned[at:at + 5])

    def shot(name):
        d.run(40)  # the next frame's redraw and the icons' hop
        im = d.screenshot().convert('RGB')
        im.save(os.path.join(out, name + '.png'))
        return im

    def changed(a, b, top):
        box = (0, 0, 256, 192) if top else (0, 192, 256, 384)
        return ImageChops.difference(a.crop(box), b.crop(box)).getbbox()

    def press(key):
        d.press(key, frames=2, after=16)

    def open_screen():
        result, frames = warp(d, sym, ids.index(ROOM), *STAND, FACE_DOWN)
        if result != 'ok':
            return f'warp: {result} {frames}'
        d.press('UP', frames=2, after=20)  # turn to the board
        d.press('A', after=30)
        for _ in range(OPEN_LIMIT // 30):
            if marker()[0] == SCREEN_EVENTS:
                d.run(60)  # its fade in
                return ''
            d.press('A', after=24)  # through the room's message
        return f'no screen after {OPEN_LIMIT} frames (marker {marker()})'

    def closed(how):
        for _ in range(30):
            d.run(30)
            if marker()[0] == 0:
                break
        idle = u32(d, sym['gSovereignTestIdleFrames'])
        d.run(60)
        here = ids[u32(d, sym['gSovereignTestIdleMapHeaderID'])]
        check(f'{how}: the screen closed (marker {marker()}) and the field runs again in the Potential Room ({here})',
              marker()[0] == 0 and here == ROOM and u32(d, sym['gSovereignTestIdleFrames']) > idle)

    def write_record(base, event, result, mons):
        at = base + event * SOLO_SIZE
        words = [result] + [species_ids.index(s) | form << 11 for s, form in mons]
        data = struct.pack('<4H', *words)
        for i in range(0, 8, 4):
            mem.write_long(at + i, struct.unpack_from('<I', data, i)[0])

    mem.write_byte(sym['gSovereignTestClock'], 12 + 1)  # noon (the clock takes the hour + 1)
    d.run(30)

    # 1. The screen, with the default records
    problem = open_screen()
    check(f'the Potential Room\'s board opens the event record screen {problem}', not problem)
    if problem:
        d.screenshot().save(os.path.join(out, 'no_screen.png'))
        print(f'{len(problems)} problems')
        sys.exit(1)
    check(f'it opens in Single mode, the cursor on Hurdle Dash (marker {marker()})',
          marker()[0] == SCREEN_EVENTS and marker()[2] == HURDLE_DASH and marker()[4] == 0)
    records = u32(d, sym['gCompleteTestPokeathlonEventRecords'])
    check(f'the open screen\'s records are given to the test ({records:#x})', records >= 0x02000000)
    default = shot('hurdle_dash_default')

    # 2. The player's records, then the redraw
    write_record(records, HURDLE_DASH, 80 * 30, [('SPECIES_PIKACHU', 0), ('SPECIES_MARILL', 0), ('SPECIES_SYLVEON', 0)])
    mem.write_long(records + HURDLE_DASH * SOLO_SIZE + TIMES_JOINED, 7)
    write_record(records, RELAY_RUN, 15 << 10 | 512, [('SPECIES_TOGEPI', 0), ('SPECIES_VULPIX', 1), ('SPECIES_EEVEE', 0)])
    mem.write_long(records + RELAY_RUN * SOLO_SIZE + TIMES_JOINED, 3)
    points = records + RECORD_POINTS + 2 * HURDLE_DASH
    mem.write_long(points & ~3, (u32(d, points & ~3) & ~(0xFFFF << 8 * (points & 3))) | 432 << 8 * (points & 3))
    mem.write_byte(sym['gCompleteTestPokeathlonRecordScreen'] + 3, 1)
    for _ in range(20):
        d.run(10)
        if marker()[3] == 0:
            break
    check(f'the screen took the records (marker {marker()})', marker()[3] == 0)
    hurdle = shot('hurdle_dash_record')
    check(f'Hurdle Dash\'s page shows the new record on the top screen ({changed(default, hurdle, True)})',
          changed(default, hurdle, True) is not None)
    check(f'and its panel on the bottom screen ({changed(default, hurdle, False)})',
          changed(default, hurdle, False) is not None)

    # 3. The cursor and the modes
    press('RIGHT')
    d.run(10)
    check(f'RIGHT: Pennant Capture (marker {marker()})', marker()[1:3] == (1 + PENNANT_CAPTURE, PENNANT_CAPTURE))
    pennant = shot('pennant_capture')
    check(f'its page differs ({changed(hurdle, pennant, True)})', changed(hurdle, pennant, True) is not None)
    press('DOWN')
    d.run(10)
    check(f'DOWN: Relay Run (marker {marker()})', marker()[1:3] == (1 + RELAY_RUN, RELAY_RUN))
    shot('relay_run')
    press('UP')
    press('UP')
    check(f'UP twice: the Single/Link button (marker {marker()})', marker()[2] == MODE)
    d.press('A', after=30)
    check(f'A: Link mode (marker {marker()})', marker()[4] == 1)
    link = shot('link_mode')
    check(f'the screen changed for Link mode ({changed(pennant, link, False)})', changed(pennant, link, False) is not None)
    d.press('A', after=30)
    check(f'A again: Single mode (marker {marker()})', marker()[4] == 0)

    # 4. Return, A; a touch and B; a touch on Return
    press('DOWN')
    check(f'DOWN from the button: its column\'s event (marker {marker()})', marker()[2] == PENNANT_CAPTURE)
    press('DOWN')
    press('DOWN')
    check(f'DOWN twice more: Return (marker {marker()})', marker()[2] == RETURN)
    d.press('A', after=10)
    closed('A on Return')
    problem = open_screen()
    check(f'the screen opens again {problem}', not problem)
    if not problem:
        d.touch(*LAST_PANEL, frames=4, after=20)
        check(f'a touch on the last panel: Goal Roll (marker {marker()})', marker()[2] == GOAL_ROLL)
        shot('goal_roll')
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
