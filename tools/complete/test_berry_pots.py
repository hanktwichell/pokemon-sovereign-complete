#!/usr/bin/env python3
"""HeartGold's Berry Pots (include/complete_berry_pots.h), in the test build, from the bedroom state, as a player would.

The bag gets the Berry Pots (registered to Y), 5 Oran Berries and a Growth Mulch. The pots must start empty: a new
game leaves junk in their berry patches, which their first opening clears. Then:

1. **Y opens the pots:** HeartGold's screen, four empty pots.
2. **Mulch, then a Berry, in the first pot:** A on the pot, FERTILIZE, the bag (its Items pocket) and the Mulch; then
   A on the pot again, PLANT BERRY, the bag (its Berries pocket) and the Oran Berry. The pot (berry patch 124) holds an
   Oran Berry, planted, wet, with Growth Mulch; the bag has the Mulch and one Berry fewer.
3. **Time passes:** the screen closed, the pots' time set back, the screen opened again (HeartGold's rules: an Oran's
   stages are 3 hours, a quarter less with Growth Mulch, and its Berries stay 4 stages). Two hours on: still planted,
   the soil drier, and WATER wets it again. Sixteen hours on: Berries, and TAKE BERRIES puts them in the bag.
4. **Out:** B closes the screen, back on the field where the player was.
5. **From the bag:** the Start menu's Bag, the Key Items pocket, the Berry Pots, USE: the screen; B, and the bag is back.

Results: a line per check, screenshots in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_berry_pots.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import datetime
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP, SYMBOLS, TEST_BUILD, symbols  # noqa: E402

SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
POCKETS = {'items': (0, 165), 'key': (165, 100), 'berries': (165 + 100 + 100 + 12 + 40, 64)}  # the Bag's (include/bag.h)
REGISTERED = (165 + 100 + 100 + 12 + 40 + 64 + 30 + 30) * 4  # Bag.registeredItem
FIRST_POT, PATCH_SIZE = 124, 14  # COMPLETE_BERRY_POTS_FIRST_PATCH, sizeof(BerryPatch)
POTS_TIME = 456 - 5 - 28  # CompletePhoneSave.berryPotsTime: the phone save's 456 bytes end with it and 5 reserved
ORAN = 7  # the Oran Berry's berry ID (ITEM_ORAN_BERRY - ITEM_CHERI_BERRY + 1)
GROWTH_MULCH = 1  # MULCH_TYPE_GROWTH
STAGES = ['NONE', 'PLANTED', 'SPROUTED', 'GROWING', 'BLOOM', 'BERRIES']
# the manager's state * 16 (src/complete_berry_pots.c, gCompleteTestBerryPotsStep)
SCREEN, BAG = 0x10, 0x30


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gCompleteTestBerryPotsStep'))
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    xmap = open(os.path.join(DECOMP, TEST_BUILD, 'main.nef.xMAP'), encoding='utf-8', errors='replace').read()
    loaded = int(re.search(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.bss\s+Unk_021BF370\b', xmap, re.M).group(1), 16)
    overlay_names = re.findall(r'^Overlay (\S+)', open(os.path.join(DECOMP, 'platinum.us', 'main.lsf')).read(), re.M)
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

    def bag():
        return save_block('SAVE_TABLE_ENTRY_BAG')

    def put(pocket, slot, item, count):
        mem.write_long(bag() + (POCKETS[pocket][0] + slot) * 4, items.index(item) | count << 16)

    def quantity(pocket, item):
        first, size = POCKETS[pocket]
        slots = [u32(bag() + (first + i) * 4) for i in range(size)]
        return sum(s >> 16 for s in slots if s & 0xFFFF == items.index(item))

    def pot(i=0):
        at = save_block('SAVE_TABLE_ENTRY_MISC') + (FIRST_POT + i) * PATCH_SIZE
        f = struct.unpack('<BBHHBxHBBBB', bytes(mem.unsigned[at:at + PATCH_SIZE]))
        return dict(zip(('berry', 'stage', 'stageMinutes', 'dryMinutes', 'replants', 'yield', 'moisture', 'yieldRating',
                         'mulch', 'isGrowing'), f))

    def pots_time():
        return save_block('SAVE_TABLE_ENTRY_COMPLETE_PHONE') + POTS_TIME

    def step():
        return mem.unsigned[sym['gCompleteTestBerryPotsStep']]

    def overlays():
        return [overlay_names[u32(loaded + 8 * i)] for i in range(24) if u32(loaded + 8 * i + 4)]

    def wait_step(want, frames=600):
        for _ in range(frames // 10):
            d.run(10)
            if step() == want:
                d.run(120)  # the fade, and the screen's first message
                return True
        return False

    def press(key, name, after=90):
        d.press(key, frames=6, after=after)
        shot(name)

    def describe(p):
        return (f"berry {p['berry']}, {STAGES[p['stage']] if p['stage'] < len(STAGES) else p['stage']}, moisture "
                f"{p['moisture']}, mulch {p['mulch']}, yield {p['yield']}, yield rating {p['yieldRating']}")

    d.run(30)
    put('items', 0, 'ITEM_GROWTH_MULCH', 1)
    put('key', 0, 'ITEM_BERRY_POTS', 1)
    put('berries', 0, 'ITEM_ORAN_BERRY', 5)
    mem.write_long(bag() + REGISTERED, items.index('ITEM_BERRY_POTS'))
    new_game_pots = [pot(i) for i in range(4)]
    print('  the new game left in the pots:', '; '.join(describe(p) for p in new_game_pots))
    d.run(10)
    start = d.pos()
    shot('field')

    # 1. Y opens the pots
    d.press('Y', frames=6, after=10)
    check('Y opens the pots', wait_step(SCREEN) and 'complete_berry_pots' in overlays())
    shot('pots')
    check("the pots start empty (the new game's leftovers cleared)", all(pot(i)['berry'] == 0 and pot(i)['stage'] == 0
                                                                       for i in range(4)))

    # 2. Mulch, then a Berry, in the first pot
    press('A', 'pot_menu')
    press('A', 'fertilize', after=0)
    check('FERTILIZE opens the bag', wait_step(BAG) and 'bag' in overlays())
    shot('bag_items')
    press('A', 'mulch_chosen', after=0)
    check('back on the pots', wait_step(SCREEN))
    shot('mulch_laid')
    press('A', 'mulch_message')  # the message's end
    p = pot()
    print('  pot 1:', describe(p))
    check('the first pot has Growth Mulch', p['mulch'] == GROWTH_MULCH and p['berry'] == 0)
    check('the Mulch left the bag', quantity('items', 'ITEM_GROWTH_MULCH') == 0)
    press('A', 'pot_menu2')
    press('A', 'plant', after=0)
    check('PLANT BERRY opens the bag', wait_step(BAG))
    shot('bag_berries')
    d.emu.savestate.save_file(os.path.join(out, 'bag_berries.state'))  # for looking into a failure
    press('A', 'berry_chosen', after=0)
    check('back on the pots', wait_step(SCREEN))
    for i in range(3):
        d.run(60)
        shot(f'planted_{i}')
    d.emu.savestate.save_file(os.path.join(out, 'planted.state'))  # for looking into a failure
    p = pot()
    print('  pot 1:', describe(p))
    check('an Oran Berry planted in the first pot, wet, with the Mulch',
          p['berry'] == ORAN and p['stage'] == 1 and p['moisture'] == 100 and p['mulch'] == GROWTH_MULCH
          and not p['isGrowing'])
    check('one Oran Berry left the bag', quantity('berries', 'ITEM_ORAN_BERRY') == 4)
    check("the other pots are empty", all(pot(i)['berry'] == 0 for i in range(1, 4)))

    # 3. Time passes: out, the pots' time set back, in again
    def close():
        """B (again if a menu or message took the first) until the screen is gone: True if back on the field."""
        for _ in range(3):
            d.press('B', frames=6, after=0)
            for _ in range(30):
                d.run(10)
                if 'complete_berry_pots' not in overlays() and step() == 0x40:  # MANAGER_DONE
                    d.run(200)  # the field's fade in
                    return True
        return False

    def on_field():
        return 'complete_berry_pots' not in overlays() and 'bag' not in overlays() and d.pos() == start

    def time_back(hours):
        """The pots' time (an RTCDate and RTCTime, unaligned: byte by byte) set HOURS earlier."""
        at = pots_time()
        f = [int.from_bytes(bytes(mem.unsigned[at + 4 * i:at + 4 * i + 4]), 'little') for i in range(7)]
        when = datetime.datetime(2000 + f[0], f[1], f[2], f[4], f[5], f[6]) - datetime.timedelta(hours=hours)
        new = [when.year - 2000, when.month, when.day, (when.weekday() + 1) % 7, when.hour, when.minute, when.second]
        for i, v in enumerate(new):
            for j, b in enumerate(v.to_bytes(4, 'little')):
                mem.write_byte(at + 4 * i + j, b)
        return when

    def reopen(name):
        d.press('Y', frames=6, after=10)
        ok = wait_step(SCREEN)
        shot(name)
        return ok

    check('B closes the pots', close())
    shot('field_again')
    check('back on the field where the player was', on_field())
    at = pots_time()
    f = [int.from_bytes(bytes(mem.unsigned[at + 4 * i:at + 4 * i + 4]), 'little') for i in range(7)]
    print(f'  the pots last grew: 20{f[0]:02d}-{f[1]:02d}-{f[2]:02d} {f[4]:02d}:{f[5]:02d}')
    check("the pots' time is kept", 1 <= f[1] <= 12 and 1 <= f[2] <= 31 and f[4] < 24)

    # two hours: still planted (its stage is 3 hours less a quarter), the soil drier; WATER wets it again
    time_back(2)
    check('Y opens the pots again', reopen('two_hours_on'))
    p = pot()
    print('  pot 1:', describe(p))
    check('two hours on: still planted, the soil drier', p['berry'] == ORAN and p['stage'] == 1 and p['moisture'] < 100)
    press('A', 'water_menu')
    press('A', 'watering', after=120)
    press('A', 'watered', after=120)
    for i in range(2):
        d.run(60)
        shot(f'watered_{i}')
    p = pot()
    print('  pot 1:', describe(p))
    check('WATER wets the soil again', p['moisture'] == 100)
    check('B closes the pots', close())

    # sixteen hours: past four stages (9 hours with the Mulch), and the Berries stay four stages: Berries to pick
    time_back(16)
    check('Y opens the pots once more', reopen('sixteen_hours_on'))
    p = pot()
    print('  pot 1:', describe(p))
    check('sixteen hours on: the plant has its Berries', p['berry'] == ORAN and p['stage'] == 5)
    check('the Berries count is its yield (at least 2)', p['yield'] >= 2)
    berries = p['yield']
    before = quantity('berries', 'ITEM_ORAN_BERRY')
    press('A', 'take_menu')
    press('A', 'taking', after=120)
    for i in range(2):
        press('A', f'taken_{i}', after=90)
    p = pot()
    print('  pot 1:', describe(p))
    check('TAKE BERRIES: the pot is empty again', p['berry'] == 0 and p['stage'] == 0)
    check(f"the {berries} Oran Berries are in the bag", quantity('berries', 'ITEM_ORAN_BERRY') == before + berries)

    # 4. Out
    check('B closes the pots', close())
    shot('field_end')
    check('back on the field where the player was', on_field())
    d.press('A', frames=6, after=60)  # the field takes input: A faces nothing, the player stays
    check('the field runs on', on_field())

    # 5. From the bag: the Start menu (its cursor on the Pokédex), down twice to the Bag, which opens on the Items
    # pocket; LEFT to the Key Items, the Berry Pots first; its menu, USE. B closes the pots, and the bag is back.
    for key, after in [('X', 40), ('DOWN', 20), ('DOWN', 20), ('A', 120), ('LEFT', 60)]:
        d.press(key, frames=6, after=after)
    shot('bag_key_items')
    d.press('A', frames=6, after=40)
    shot('bag_item_menu')
    d.press('A', frames=6, after=0)
    check('USE in the bag opens the pots', wait_step(SCREEN) and 'complete_berry_pots' in overlays())
    shot('pots_from_bag')
    check('B closes the pots', close())
    shot('bag_again')
    check('back in the bag', 'bag' in overlays())
    for key in ('B', 'B'):
        d.press(key, frames=6, after=120)
    shot('field_after_bag')
    check('out of the bag and the menu, on the field', on_field())
    print(f'{len(problems)} problems: {problems}' if problems else '0 problems')


if __name__ == '__main__':
    main()
