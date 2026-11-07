#!/usr/bin/env python3
"""The Apricorn Box and the Aprijuice stand (HeartGold's overlays 58 and 59, include/complete_aprijuice.h), in the test
build, from the bedroom state.

1. **The box, as from the bag:** the test build's hook (gCompleteTestAprijuice: open = 1 + the mode, apricorns = how
   many of each Apricorn it puts in the bag first) opens it over the field. Its first-time help is read through (A),
   then the first Apricorn (Red) is put in the Apriblender (A on it, A on the blender): the bag has one Red Apricorn
   fewer. B closes the box and the field runs again.
2. **The box again:** the blender still holds the Apricorn (a screenshot), and the box closes.
3. **The stand:** the player warps to the Pokéathlon Dome's Aprijuice stand (HeartGold's D49, its script 19: the sign
   at (19, 24), talked to facing north). The first visit gives the Apriblender and asks for questions (UNDERSTOOD!:
   none); the next buys the juice of the day (CompleteAprijuiceOfTheDay: the weekday's, from
   HeartGold's five), gives it to the party's first Pokémon (CompleteAprijuiceStand: the party menu, then HeartGold's
   performance screen and its Use), and pays: the money goes down by the day's price.

Results: a line per check, screenshots in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_aprijuice.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import datetime
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP, SYMBOLS, header_names, symbols, warp  # noqa: E402

DOME = 'MAP_HEADER_HGSS_POKEATHLON_DOME'
STAND = (19, 25)  # below the stand's sign (19, 24), facing north
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
BAG_SLOTS = 165 + 100 + 100 + 12 + 40 + 64 + 30 + 30  # every pocket's slots (include/bag.h)
MONEY = 0x18  # PlayerSave: options, Sovereign's options, then TrainerInfo's name (8 characters), id, money
# CompleteTestAprijuice (include/complete_test.h): open, juice, step, runs; result; stage, innerState; appFree;
# subState; HgssApricornBoxArgs (28 bytes); apricorns
OPEN, STEP, RUNS, STAGE, SUBSTATE, APRICORNS = 0, 2, 3, 6, 12, 44
MODE_BAG = 1
# The stand's prices, by juice (src/overlay007/complete_pokeathlon_shop.c's sAprijuices: steps / 10 + 2 x richness,
# 100 at least): Holden's, Elaine's, Gilmore's, Krise's and Victor's
PRICES = [100, 100, 150, 100, 100]
MENU_SHOWN = 0  # gSovereignTestMenu.shown


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gCompleteTestAprijuice', 'gSovereignTestMenu'))
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    at = sym['gCompleteTestAprijuice']
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

    def save_block(entry):
        text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
        index = re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', text[text.index('enum SaveTableEntryID'):], re.M).index(entry)
        base = u32(sym['sSaveDataPtr'])
        return base + 20 + u32(base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + index * 16 + 8)

    def bag_count(item):
        bag = save_block('SAVE_TABLE_ENTRY_BAG')
        for i in range(BAG_SLOTS):
            slot = u32(bag + 4 * i)
            if slot & 0xFFFF == items.index(item):
                return slot >> 16
        return 0

    def money():
        return u32(save_block('SAVE_TABLE_ENTRY_PLAYER') + MONEY)

    def press(key, after=60, times=1):
        for _ in range(times):
            d.press(key, frames=4, after=after)

    def field_idle(frames=60):
        before = u32(sym['gSovereignTestIdleFrames'])
        d.run(frames)
        return u32(sym['gSovereignTestIdleFrames']) - before > frames // 3

    def open_box(apricorns):
        runs = mem.unsigned[at + RUNS]
        mem.write_byte(at + APRICORNS, apricorns)
        mem.write_byte(at + 1, 0)
        mem.write_byte(at + OPEN, 1 + MODE_BAG)
        for _ in range(60):
            d.run(10)
            if running():
                break
        d.run(120)
        return runs

    def running():
        # overlay 59's own app run by overlay 58, at its main state (its first-time help, 0x202, or past it)
        sub = u32(at + SUBSTATE)
        return sub != 0xFFFFFFFF and sub & 0xFF == 2 and sub >> 8 >= 2

    def close_box(runs):
        for _ in range(10):
            press('B', after=90)
            if mem.unsigned[at + RUNS] != runs:
                break
        d.run(60)
        return mem.unsigned[at + RUNS] != runs and mem.unsigned[at + STAGE] == 7

    d.run(30)

    # 1. The box from the bag: its help, then a Red Apricorn into the blender
    runs = open_box(5)
    check(f'box: opened (overlay 59 running, its state {u32(at + SUBSTATE):#x}: the help)', u32(at + SUBSTATE) == 0x202)
    shot('box_help')
    red = bag_count('ITEM_RED_APRICORN')
    check(f'box: 5 of each Apricorn in the bag (Red: {red})', red == 5)
    press('A', after=60, times=14)  # the first-time help, read through
    shot('box_after_help')
    press('A', after=60)  # the Red Apricorn
    press('A', after=120)  # into the Apriblender
    shot('box_blending')
    check(f'box: one Red Apricorn put in (the bag has {bag_count("ITEM_RED_APRICORN")})',
          bag_count('ITEM_RED_APRICORN') == 4)
    check('box: closed, the field back', close_box(runs) and field_idle())
    shot('field_after_box')

    # 2. The box again: the blender still holds it
    runs = open_box(0)
    check(f'box again: opened (its state {u32(at + SUBSTATE):#x})', running())
    shot('box_again')
    check('box again: closed', close_box(runs) and field_idle())

    # 3. The stand: the juice of the day, bought for the party's first Pokémon
    juice = (int(datetime.date.today().strftime('%w')) + 2 * 0) % 5  # the emulator's clock is the host's
    before = money()
    result, _ = warp(d, sym, names.index(DOME), STAND[0], STAND[1], 2)
    check(f'stand: warped below it {STAND} ({result})', result == 'ok')

    def talk_to_menu(name):
        """Face the stand, press A, then A through the clerk's lines until the script's menu shows."""
        d.press('UP', frames=2, after=30)
        mem.write_short(sym['gSovereignTestScripts'], 0)
        menus = u32(sym['gSovereignTestMenu'] + MENU_SHOWN)
        press('A', after=60)
        for _ in range(150):
            if u32(sym['gSovereignTestMenu'] + MENU_SHOWN) != menus:
                break
            press('A', after=30)
        check(f'stand: {name}', u32(sym['gSovereignTestMenu'] + MENU_SHOWN) != menus)

    # The first visit: the clerk gives the Apriblender, then asks for questions (UNDERSTOOD!, the third: none)
    talk_to_menu('the first visit\'s questions (the Apriblender given)')
    d.run(60)  # the menu is noted as it's made, before it takes input
    press('DOWN', after=30, times=2)
    shot('stand_questions')
    press('A', after=60)
    for _ in range(20):
        if field_idle():
            break
        press('A', after=40)
    check('stand: the first visit over, the field back', field_idle())
    # Then the juice of the day: its offer and the menu (buy, ask, cancel). The first visit walked the player to the
    # clerk (whose talk is the questions): back below the stand's sign first
    result, _ = warp(d, sym, names.index(DOME), STAND[0], STAND[1], 2)
    check(f'stand: back below it ({result})', result == 'ok')
    talk_to_menu('the juice\'s offer')
    d.run(60)
    d.run(30)
    shot('stand_offer')
    press('A', after=120)  # buy: "Thank you! Which Pokémon...", then the fade
    press('A', after=240)
    shot('stand_party')
    press('A', after=180)  # the party's first Pokémon
    shot('stand_performance')
    press('A', after=240)  # Use: it drinks
    for i in range(6):  # the stats' messages
        press('A', after=90)
    shot('stand_drank')
    for _ in range(20):  # back to the field: the thanks, then the goodbye
        press('A', after=60)
        if field_idle():
            break
    shot('stand_after')
    paid = before - money()
    check(f'stand: paid the day\'s price (juice {juice}: {PRICES[juice]}; paid {paid}, money {before} to {money()})',
          paid == PRICES[juice])
    check('stand: the field runs again', field_idle())

    print(f'{len(problems)} problems')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
