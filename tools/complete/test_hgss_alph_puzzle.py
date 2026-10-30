#!/usr/bin/env python3
"""Check the Ruins of Alph's Kabuto puzzle (src/applications/complete_alph_puzzle.c) and the Unown it lets out
(src/complete_encounters.c) in the test build, from the bedroom state:

1. **Closed:** in the underground hall before any puzzle is solved, the game's own encounter code (a survey,
   gSovereignTestWildSurvey) makes no Pokémon, as HeartGold's hall has none until then.
2. **Quit:** the player reads the puzzle's slab in its chamber, touches Quit and answers Yes. Passes when the puzzle
   closes, unsolved, with the player back in the chamber.
3. **Puzzle:** the slab again, and the test solves the puzzle on the touch screen as a player would: each loose panel
   is turned by tapping it (a quarter turn a tap) and dragged to its square of the picture. Passes when the puzzle's
   flag (FLAG_HGSS_SYS_ALPH_PUZZLE_KABUTO) is set and the chamber's floor gives way, dropping the player into the
   underground hall, as HeartGold's script goes on.
4. **Unown:** a survey in the hall now. Passes when it makes only Unown, and only the Kabuto puzzle's letters (A to
   J).

Results: a line per part, 'ok' or what went wrong, and screenshots (the puzzle as it opens, the quit question, the
puzzle solved, the hall) in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_alph_puzzle.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp, var_ids  # noqa: E402
from wild_forms import MON_SIZE, SURVEY, run_survey, species_names  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
CHAMBER = 'MAP_HEADER_HGSS_RUINS_OF_ALPH_NORTHEAST_ENTRANCE_FIRST_ROOM'  # HeartGold's D24R0202, the Kabuto chamber
HALL = 'MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL'
SLAB, NORTH = (6, 7), 1  # south of the slab (6, 6); the test warp's facing: enum FaceDirection + 1
FLAG = 'FLAG_HGSS_SYS_ALPH_PUZZLE_KABUTO'
# The Kabuto puzzle's loose panels: (square, quarter turns it starts with, its square in the picture). A panel's
# square in the picture is (n % 4 + 1, n // 4 + 1) for panel n, counted from 0.
PANELS = [((0, 1), 1, (2, 2)), ((5, 2), 2, (3, 3)), ((0, 4), 3, (2, 1)), ((4, 5), 1, (1, 3))]
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'gCompleteTestAlphPanels', 'gSovereignTestWildSurvey'})
QUIT_BUTTON, YES = (232, 180), (224, 96)  # the puzzle's Quit, and Yes in the question's touch menu (tiles 25, 10)
HALL_TILE = (25, 6)  # in the hall, where the drop lands (the chamber script's Warp)
KABUTO_FORMS = set(range(10))  # UNOWN_FORM_A to _J


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def square_center(x, y):
    """The touch screen point at the middle of a board square (the board starts 32 pixels in; squares are 32)."""
    return 32 + x * 32 + 16, y * 32 + 16


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory
    vars_flags_entry = save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS')

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def flag(name):
        """Whether a flag is set: VarsFlags is the vars, then the flags' bits."""
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        addr = base + 20 + u32(page_info + vars_flags_entry * 16 + 8)
        addr += (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        return bool(mem.unsigned[addr + n // 8] & (1 << (n % 8)))

    def settle(limit=3000):
        """Run until the field has been idle a while (a busy map runs the field every other frame)."""
        frames, idle = 0, 0
        while frames < limit:
            before = u32(sym['gSovereignTestIdleFrames'])
            d.run(20)
            frames += 20
            idle = idle + 1 if u32(sym['gSovereignTestIdleFrames']) - before >= 9 else 0
            if idle >= 6:
                return True
        return False

    def play_out(limit=6000):
        """Press A while a scene runs (the field not idle at all), until the field has been idle a while. A frame
        step where the field is idle only part of the time gets no A: a script is just ending, and A would talk to
        the person the player faces."""
        frames, idle = 0, 0
        while frames < limit:
            before = u32(sym['gSovereignTestIdleFrames'])
            d.run(20)
            frames += 20
            idle_frames = u32(sym['gSovereignTestIdleFrames']) - before
            if idle_frames >= 9:
                idle += 1
                if idle >= 6:
                    return True
            else:
                idle = 0
                if idle_frames == 0:
                    d.press('A', frames=4, after=0)
        return False

    def tap(x, y):
        """A touch let go at once: the panel turns. It lasts two frames, as the puzzle runs every other frame (a
        one-frame touch can fall between its frames), and a hold of three of its frames picks the panel up."""
        touch = d.emu.input
        touch.touch_set_pos(x, y)
        d.run(2)
        touch.touch_release()
        d.run(30)

    def drag(start, end):
        """Hold a panel, carry it over and let go on its square."""
        touch = d.emu.input
        touch.touch_set_pos(*start)
        d.run(8)
        for i in range(1, 9):
            touch.touch_set_pos(start[0] + (end[0] - start[0]) * i // 8, start[1] + (end[1] - start[1]) * i // 8)
            d.run(2)
        d.run(6)
        touch.touch_release()
        d.run(30)

    results = []
    species = species_names()

    def here():
        return names[u32(sym['gSovereignTestIdleMapHeaderID'])]

    def survey_hall():
        """The Pokémon a survey makes in the hall: [(species, form)], or None if it never ended."""
        count = run_survey(d, sym['gSovereignTestWildSurvey'], 0)
        if count < 0:
            return None
        mons = []
        for i in range(count):
            at = sym['gSovereignTestWildSurvey'] + SURVEY['mons'] + i * MON_SIZE
            mons.append((species[struct.unpack('<H', bytes(mem.unsigned[at + 4:at + 6]))[0]], mem.unsigned[at + 6]))
        return mons

    def open_puzzle():
        """From the bedroom state to the slab, and read it."""
        start_warp(d, sym, names.index(CHAMBER), *SLAB, NORTH)
        if not settle():
            return 'the chamber never settled'
        d.press('A', frames=4, after=0)
        d.run(240)  # the fade and the puzzle opening
        return ''

    d.load_state(state)
    d.run(30)

    # 1. The hall before any puzzle: no Pokémon
    start_warp(d, sym, names.index(HALL), *HALL_TILE, NORTH)
    problem = '' if settle() else 'the hall never settled'
    if not problem:
        mons = survey_hall()
        if mons is None:
            problem = 'the survey never ended'
        elif mons:
            problem = f'{len(mons)} Pokémon, such as {mons[0]}'
    results.append(f'closed: {problem or "ok"}')
    print(results[-1], flush=True)

    # 2. Quit, yes
    problem = open_puzzle()
    if not problem:
        d.screenshot().save(os.path.join(out, 'puzzle.png'))
        tap(*QUIT_BUTTON)
        d.run(150)  # the button's animation and the question
        d.screenshot().save(os.path.join(out, 'quit.png'))
        tap(*YES)
        d.run(120)
        settle()
        if flag(FLAG):
            problem = f'{FLAG} is set'
        elif here() != CHAMBER:
            problem = f'the player is on {here()}, not in the chamber'
    results.append(f'quit: {problem or "ok"}')
    print(results[-1], flush=True)

    # 3. Solve it
    if not problem:
        problem = open_puzzle()
    if not problem:
        for square, turns, target in PANELS:
            for _ in range((4 - turns) % 4):
                tap(*square_center(*square))
            drag(square_center(*square), square_center(*target))
        d.screenshot().save(os.path.join(out, 'solved.png'))
        panels = bytes(mem.unsigned[sym['gCompleteTestAlphPanels']:sym['gCompleteTestAlphPanels'] + 48])
        wrong = [(n, tuple(panels[n * 3:n * 3 + 3])) for n in range(16)
                 if tuple(panels[n * 3:n * 3 + 3]) != (n % 4 + 1, n // 4 + 1, 0)]
        d.run(120)  # the panels' flash and the fade out
        settle(4000)  # back in the field: the floor gives way and the player drops into the hall
        d.screenshot().save(os.path.join(out, 'hall.png'))
        if not flag(FLAG):
            problem = f'{FLAG} is unset' + (f' (panels off their squares, (x, y, turns): {wrong})' if wrong else '')
        elif here() != HALL:
            problem = f'the player is on {here()}, not in the underground hall'
    results.append(f'puzzle: {problem or "ok"}')
    print(results[-1], flush=True)

    # 4. The hall's Unown: the Kabuto puzzle's letters
    if not problem:
        play_out()  # the scientist's lines as the player lands
        mons = survey_hall()
        if mons is None:
            problem = 'the survey never ended'
        elif not mons:
            problem = 'no Pokémon'
        elif any(name != 'SPECIES_UNOWN' or form not in KABUTO_FORMS for name, form in mons):
            problem = f'not the Kabuto letters: {sorted(set(mons))}'
        else:
            print(f'     {len(mons)} Unown, forms {sorted(set(form for _, form in mons))}')
        results.append(f'unown: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of 4 parts ok')
    sys.exit(0 if ok == 4 else 1)


if __name__ == '__main__':
    main()
