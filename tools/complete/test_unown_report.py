#!/usr/bin/env python3
"""HeartGold's Unown Report (include/complete_unown_report.h), in the test build, from the bedroom state, as a player
would read it.

The bag gets the Unown Report (registered to Y); the Pokédex has seen 16 Unown forms (A to P, in a jumbled order), and
the research center's report level is 8 (every report). Then:

1. **Y opens the report** on its cover: 9 pages (the cover, 2 of Unown, 6 of reports).
2. **DOWN turns the pages** one by one to the last, and DOWN there does nothing; **UP** turns one back.
3. **The touch screen:** the upper arrow turns back a page, the lower one on.
4. **CANCEL** (touched) closes it, back on the field where the player was; then Y again and B closes it.
5. **A lower report level:** at level 2, the report has 2 report pages (the cover, 2 of Unown, 2 of reports).

Results: a line per check, screenshots in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_unown_report.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP, SYMBOLS, TEST_BUILD, symbols  # noqa: E402

SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
KEY_POCKET = 165  # the Bag's Key Items, after its 165 Items (include/bag.h)
REGISTERED = (165 + 100 + 100 + 12 + 40 + 64 + 30 + 30) * 4  # Bag.registeredItem
FORMS_SEEN = [3, 0, 7, 1, 15, 2, 9, 4, 5, 6, 8, 10, 11, 12, 13, 14]  # D, A, H, B, P, C... (16: two Unown pages)


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def unown_forms_offset():
    """Pokedex.unownFormsSeen: after the magic, four arrays of DEX_SIZE_U32 words, Spinda's form and four bytes."""
    species = [line.strip() for line in open(os.path.join(DECOMP, 'generated', 'species.txt')) if line.strip()]
    national = species.index('SPECIES_BAD_EGG') - 2  # NATIONAL_DEX_COUNT
    words = (national - 1) // 32 + 1  # DEX_SIZE_U32
    return 4 + 4 * 4 * words + 4 + 4


def var_id(name):
    text = open(os.path.join(DECOMP, TEST_BUILD, 'generated', 'vars_flags.py'), encoding='utf-8').read()
    return int(re.search(r'^\s*' + name + r'\s*=\s*(\d+)', text, re.M).group(1))


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gCompleteTestUnownReportPage'))
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    xmap = open(os.path.join(DECOMP, TEST_BUILD, 'main.nef.xMAP'), encoding='utf-8', errors='replace').read()
    loaded = int(re.search(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.bss\s+Unk_021BF370\b', xmap, re.M).group(1), 16)
    overlay_names = re.findall(r'^Overlay (\S+)', open(os.path.join(DECOMP, 'platinum.us', 'main.lsf')).read(), re.M)
    level_var = var_id('VAR_HGSS_UNOWN_REPORT_LEVEL')
    d = Driver(rom, state)
    mem = d.emu.memory
    problems = []
    shots = [0]

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def shot(name):
        shots[0] += 1
        d.screenshot().save(os.path.join(out, f'{shots[0]:02d}_{name}.png'))

    def u32(at):
        return struct.unpack('<I', bytes(mem.unsigned[at:at + 4]))[0]

    def save_block(entry):
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index(entry) * 16 + 8
        return base + 20 + u32(at)

    def overlays():
        return [overlay_names[u32(loaded + 8 * i)] for i in range(24) if u32(loaded + 8 * i + 4)]

    def page():
        return mem.unsigned[sym['gCompleteTestUnownReportPage']]

    def set_level(level):
        at = save_block('SAVE_TABLE_ENTRY_VARS_FLAGS') + (level_var - 0x4000) * 2
        mem.write_byte(at, level)
        mem.write_byte(at + 1, 0)

    def open_report(name):
        mem.write_byte(sym['gCompleteTestUnownReportPage'], 0)
        d.press('Y', frames=6, after=10)
        for _ in range(40):
            d.run(10)
            if 'complete_unown_report' in overlays() and page() == 1:
                d.run(60)  # the fade in
                shot(name)
                return True
        shot(name)
        return False

    def turn(key, name):
        d.press(key, frames=6, after=90)  # the page wipes out and in
        shot(name)
        return page()

    def touch(x, y, name):
        d.touch(x, y, frames=6, after=90)
        shot(name)
        return page()

    def closed():
        for _ in range(40):
            d.run(10)
            if 'complete_unown_report' not in overlays():
                d.run(150)  # the field's fade in
                return True
        return False

    d.run(30)
    bag = save_block('SAVE_TABLE_ENTRY_BAG')
    mem.write_long(bag + KEY_POCKET * 4, items.index('ITEM_UNOWN_REPORT') | 1 << 16)
    mem.write_long(bag + REGISTERED, items.index('ITEM_UNOWN_REPORT'))
    dex = save_block('SAVE_TABLE_ENTRY_POKEDEX') + unown_forms_offset()
    for i in range(28):
        mem.write_byte(dex + i, FORMS_SEEN[i] if i < len(FORMS_SEEN) else 0xFF)
    set_level(8)
    d.run(10)
    start = d.pos()
    shot('field')

    # 1. Y opens the report on its cover
    check('Y opens the report on its cover', open_report('cover'))

    # 2. DOWN to the last page, and no further; UP one back
    pages = [page()]
    for n in range(2, 10):
        pages.append(turn('DOWN', f'page_{n}'))
    check(f'DOWN turns the pages 1 to 9 (saw {pages})', pages == list(range(1, 10)))
    check('DOWN on the last page stays there', turn('DOWN', 'past_the_end') == 9)
    check('UP turns back a page', turn('UP', 'back_one') == 8)

    # 3. The touch screen's arrows
    check('the upper arrow turns back a page', touch(236, 26, 'touch_up') == 7)
    check('the lower arrow turns on a page', touch(236, 130, 'touch_down') == 8)

    # 4. CANCEL, then Y and B
    d.touch(224, 176, frames=6, after=0)
    check('CANCEL closes the report', closed())
    shot('field_after_cancel')
    check('back on the field where the player was', d.pos() == start and 'complete_unown_report' not in overlays())
    check('Y opens it again', open_report('cover_again'))
    d.press('B', frames=6, after=0)
    check('B closes it', closed())

    # 5. Report level 2: two report pages
    set_level(2)
    check('at report level 2, Y opens it', open_report('level_2_cover'))
    seen = [page()]
    for n in range(2, 7):
        seen.append(turn('DOWN', f'level_2_page_{n}'))
    check(f'at level 2: 5 pages (saw {seen})', seen == [1, 2, 3, 4, 5, 5])
    d.press('B', frames=6, after=0)
    check('B closes it', closed())
    shot('field_end')
    check('on the field at the end', d.pos() == start)
    print(f'{len(problems)} problems: {problems}' if problems else '0 problems')


if __name__ == '__main__':
    main()
