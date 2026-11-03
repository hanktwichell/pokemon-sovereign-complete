#!/usr/bin/env python3
"""Check the Battle Frontier's move tutors (HeartGold's scr_seq_0002 at SCRIPT_ID_OFFSET_COMPLETE_FRONTIER_TUTORS,
src/overlay005/complete_move_tutor.c) in the test build, from the bedroom state, in the Frontier Access's tutor house:

1. **The list:** the first tutor (top left), A through his question (yes) and the party screen (the lead): the lead's
   moves to learn from him come up in a list of his moves with their prices (the test build's gCompleteTestTutor),
   with QUIT (and NEXT if there are more than seven).
2. **Not enough BP:** with no Battle Points, the first move in the list is too dear: no move learned, the points still
   0.
3. **A move learned:** with 500 Battle Points, the first move again: the lead learns it (A through its lines, and
   through forgetting its first move when it knows four), and its price comes off the points.

Results: a line per part, 'ok' or what went wrong, and screenshots in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_frontier_tutors.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
HOUSE = 'MAP_HEADER_HGSS_FRONTIER_ACCESS_MOVE_TUTOR_HOUSE'
FIRST_TUTOR_STAND, WEST = (6, 5), 3  # east of the top left tutor (5, 5), facing him
SAVE_PAGES = 33
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'gCompleteTestTutor'})
MOVES = re.findall(r'\{ (MOVE_\w+), (\d+), 0 \}', open(os.path.join(DECOMP, 'include', 'data',
                                                                      'hgss_frontier_tutors.h')).read())


def text_address(name):
    xmap = open(os.path.join(DECOMP, os.environ.get('TEST_BUILD', 'build_test'), 'main.nef.xMAP'),
                errors='replace').read()
    return int(re.search(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.text\s+' + name + r'\b', xmap, re.M).group(1), 16)


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def move_ids():
    text = open(os.path.join(DECOMP, os.environ.get('TEST_BUILD', 'build_test'), 'generated', 'moves.h'),
                errors='replace').read()
    return {name: int(n) for name, n in re.findall(r'^\s+(MOVE_\w+)\s*=\s*(\d+)', text, re.M)}


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    tutor_moves = {}
    try:
        ids = move_ids()
        tutor_moves = {ids[m]: int(c) for m, c in MOVES if m in ids}
    except (OSError, KeyError):
        pass

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def save_part(name):
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * 0x1000 + 4 + 8 + 4
        return base + 20 + u32(page_info + save_entry_index(name) * 16 + 8)

    # The Battle Points' record (WifiBattleTowerRecord, its first field the points), as the BP window reads it
    record = [None]

    def on_points(addr, size):
        record[0] = record[0] or mem.register_arm9.r0
        return 0

    mem.register_exec(text_address('WifiBattleTowerRecord_UpdateBattlePoints'), on_points)

    def bp():
        return struct.unpack('<H', bytes(mem.unsigned[record[0]:record[0] + 2]))[0] if record[0] else -1

    def set_bp(n):
        until(lambda: record[0] is not None, key=None, limit=60, after=10)  # the window shows them as the talk starts
        mem.write_short(record[0], n)

    def tutor():
        """(pages, entries, price, move)"""
        return struct.unpack('<4H', bytes(mem.unsigned[sym['gCompleteTestTutor']:sym['gCompleteTestTutor'] + 8]))

    def shot(name):
        d.screenshot().save(os.path.join(out, name + '.png'))

    def until(test, key='A', limit=60, after=30):
        for _ in range(limit):
            if test():
                return True
            if key:
                d.press(key, frames=4, after=after)
            else:
                d.run(after)
        return test()

    results = []

    def report(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(f'{results[-1]}  (tutor {tutor()}, BP {bp()})', flush=True)

    def to_list(points):
        """Talks to the first tutor with these points and A through to his list; whether it came up"""
        d.load_state(state)
        d.run(30)
        start_warp(d, sym, names.index(HOUSE), *FIRST_TUTOR_STAND, WEST)
        d.run(300)
        mem.write_short(sym['gCompleteTestTutor'], 0xFFFF)
        mem.write_short(sym['gCompleteTestTutor'] + 2, 0)
        d.press('A', frames=4, after=60)
        set_bp(points)
        listed = until(lambda: tutor()[1] != 0, limit=80, after=40)
        d.run(60)
        return listed

    # 1. The list
    problem = '' if to_list(0) else f'no list (pages {tutor()[0]})'
    shot('list')
    pages, entries = tutor()[:2]
    if not problem and pages == 0:
        problem = 'the lead has no move to learn'
    report('the list', problem)

    # 2. Not enough Battle Points
    if not problem:
        d.press('A', frames=4, after=60)  # the first move
        price, move = tutor()[2:]
        for _ in range(12):
            d.press('A', frames=4, after=40)
        shot('not_enough')
        problem = '' if price else 'no price asked'
        if not problem and tutor_moves and tutor_moves.get(move) != price:
            problem = f'move {move} priced {price}'
        if not problem and bp() != 0:
            problem = f'the points are {bp()}'
        report('not enough BP', problem)

    # 3. A move learned
    if not problem:
        to_list(500)
        d.press('A', frames=4, after=60)
        price, move = tutor()[2:]
        for i in range(40):  # A through the lines (and YES to forgetting a move, then its first move)
            if bp() == 500 - price:
                break
            d.press('A', frames=4, after=40)
            if i % 8 == 7:
                shot(f'learning_{i}')
        d.run(60)
        shot('learned')
        problem = '' if bp() == 500 - price else f'the points are {bp()}, not {500 - price}'
        report('a move learned', problem)


if __name__ == '__main__':
    main()
