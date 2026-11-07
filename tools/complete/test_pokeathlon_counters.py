#!/usr/bin/env python3
"""The Pokéathlon Dome's two prize counters (src/overlay007/complete_pokeathlon_shop.c, on Platinum's shop), in the
test build, from the bedroom state, as a player would use them.

The player warps in front of each clerk in the Dome's lobby (HeartGold's D49R0101: the day's prizes, its script 1,
and the data cards, its script 2) and talks: the script's menu, then the counter. The Athlete Points come from the
test build's save probe (COMPLETE_TEST_SAVE_POKEATHLON_UNSAVED, 500 at a time, to the Pokéathlon's working copy), and
gCompleteTestPokeathlon (the points, the data cards' and the day's prizes' bits, as last read or written) says what
the counters stored.

1. **No points:** the first prize is refused ("You don't have enough points!"): nothing changes.
2. **The day's prizes:** with 3,000 points, the first prize (an Apricorn, 200 points) is bought: the points go down
   by its price, its slot's bit is set, and one more of it is in the bag. Bought again: refused ("You can't buy any
   more today!"), nothing changes.
3. **The data cards:** the first card (500 points) is bought: the points go down by 500 and its bit is set; the bag
   is unchanged. Bought again: refused ("You already have this!").
4. **The vending machine in Athlete Points** (HeartGold's points box, ScrCmd_116 2): the machine's second choice
   shows the points; the first drink (Fresh Water, 50 points) comes out: the points go down by 50 and the bag has
   one or two more (a bonus one, 1 in 64). Cancel closes the box.
5. **The Dome PC's Pokéathlon data** (HeartGold's ScrCmd_743): its first page shows over the field (a screenshot:
   the line the first data card unlocks reads a number, the others "???"), and A closes it: the PC's menu again.

Results: a line per check, screenshots in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_pokeathlon_counters.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP, SYMBOLS, event_maps, header_names, symbols, warp  # noqa: E402

LOBBY = 'MAP_HEADER_HGSS_POKEATHLON_DOME_INTERIOR_1F'
EVENTS = 'events_hgss_252'
PRIZE_CLERK, CARD_CLERK = 'obj_D49R0101_pcwoman1_3', 'obj_D49R0101_pcwoman1_4'
VENDING, DATA_PC = (5, 8), (26, 10)  # below the vending machine (5, 7) and the PC (26, 9), facing north (signs)
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
PROBE_UNSAVED = 4  # COMPLETE_TEST_SAVE_POKEATHLON_UNSAVED (include/complete_test.h)
POINTS, CARDS, PRIZES, SESSION, REFUSAL, BOUGHT = range(6)  # gCompleteTestPokeathlon (include/complete_pokeathlon.h)
# hgss_msg_0435's refusals: no more today, already have it, not enough points
NO_MORE_TODAY, ALREADY_HAVE, NOT_ENOUGH = 25, 26, 48
MENU_SHOWN = 0  # gSovereignTestMenu.shown
BAG_SLOTS = 165 + 100 + 100 + 12 + 40 + 64 + 30 + 30  # every pocket's slots (include/bag.h)
APRICORNS = ['ITEM_RED_APRICORN', 'ITEM_BLU_APRICORN', 'ITEM_YLW_APRICORN', 'ITEM_GRN_APRICORN', 'ITEM_PNK_APRICORN',
             'ITEM_WHT_APRICORN', 'ITEM_BLK_APRICORN']


def clerk_tiles():
    """{object id: (x, z)} where the player stands to talk to each clerk: below their counter, facing north (the
    data card clerk's script ignores a player talking from the side, as HeartGold's does)."""
    for events, headers_of, cur, grid in event_maps():
        if events == EVENTS:
            return {o['id']: (o['x'], o['z'] + 2) for o in cur['object_events'] if o['id'] in (PRIZE_CLERK, CARD_CLERK)}
    sys.exit(f'{EVENTS} not found')


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gCompleteTestPokeathlon', 'gCompleteTestSaveProbe', 'gSovereignTestMenu'))
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    names = header_names()
    tiles = clerk_tiles()
    print(f'clerks: {tiles}', flush=True)
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

    def noted(i):
        return u32(sym['gCompleteTestPokeathlon'] + 4 * i)

    def save_block(entry):
        text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
        index = re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', text[text.index('enum SaveTableEntryID'):], re.M).index(entry)
        base = u32(sym['sSaveDataPtr'])
        return base + 20 + u32(base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + index * 16 + 8)

    def bag_count(item):
        """The bag's count of the item, in whichever pocket (include/bag.h: the pockets' slots of item and quantity in a
        row: Items, Key Items, TMs and HMs, Mail, Medicine, Berries, Poké Balls, Battle Items)."""
        bag = save_block('SAVE_TABLE_ENTRY_BAG')
        for i in range(BAG_SLOTS):
            slot = u32(bag + 4 * i)
            if slot & 0xFFFF == items.index(item):
                return slot >> 16
        return 0

    def add_points(times):
        probe = sym['gCompleteTestSaveProbe']
        for _ in range(times):
            mem.write_long(probe + 4, 0)
            mem.write_long(probe, PROBE_UNSAVED)
            for _ in range(40):
                d.run(10)
                if u32(probe) == 0 and u32(probe + 4) == PROBE_UNSAVED:
                    break

    def press(*keys, after=20):
        for key in keys:
            d.press(key, frames=4, after=after)

    def face_and_talk(x, z, header=LOBBY):
        """Warp to (x, z) facing south (the warp's own play-out presses A, which would talk to what the player
        faces), turn north to what's there and press A. Returns the warp's result."""
        result, _ = warp(d, sym, names.index(header), x, z, 2)
        d.press('UP', frames=2, after=30)
        mem.write_short(sym['gSovereignTestScripts'], 0)
        press('A', after=60)
        return result

    def counter(clerk, name):
        """Talk to the clerk, through their lines to the script's menu, its first entry (the counter), the shop's Buy:
        the list."""
        x, z = tiles[clerk]
        menus = u32(sym['gSovereignTestMenu'] + MENU_SHOWN)
        result = face_and_talk(x, z)
        check(f'{name}: warped below the clerk ({x}, {z})', result == 'ok')
        for _ in range(100):  # the clerk's lines (the first time, the counter's long explanation) up to the menu
            if u32(sym['gSovereignTestMenu'] + MENU_SHOWN) != menus:
                break
            press('A', after=40)
        check(f'{name}: the clerk\'s menu', u32(sym['gSovereignTestMenu'] + MENU_SHOWN) != menus)
        d.run(30)
        shot(f'{name}_clerk_menu')
        press('A', after=120)  # the counter: the shop's Buy and SEE YA!
        shot(f'{name}_shop_menu')
        press('A', after=120)  # Buy: the camera pans to the list
        shot(f'{name}_list')

    def buy_first(name):
        """A on the list's first item: a refusal (A past it), or the question (Yes, then A past the thanks). Returns
        the refusal's text, or None."""
        refusal = noted(REFUSAL)
        mem.write_long(sym['gCompleteTestPokeathlon'] + 4 * REFUSAL, 0)
        menus = u32(sym['gSovereignTestMenu'] + MENU_SHOWN)
        press('A', after=60)
        for _ in range(20):  # until the refusal is printed or the question's Yes/No comes up (the save is read first)
            if noted(REFUSAL) or u32(sym['gSovereignTestMenu'] + MENU_SHOWN) != menus:
                break
            d.run(15)
        d.run(30)
        shot(f'{name}_question')
        refused = noted(REFUSAL) or None
        if refused is None:
            bought = noted(BOUGHT)
            press('A', after=60)  # Yes: the thanks, two pages; the purchase is made once they're printed
            for _ in range(10):
                if noted(BOUGHT) != bought:
                    break
                press('A', after=60)
            d.run(30)
            shot(f'{name}_thanks')
        press('A', after=60)  # past the refusal or the thanks: the list
        shot(f'{name}_list_again')
        if refused is None:
            mem.write_long(sym['gCompleteTestPokeathlon'] + 4 * REFUSAL, refusal)
        return refused

    def field_idle(frames=60):
        before = u32(sym['gSovereignTestIdleFrames'])
        d.run(frames)
        return u32(sym['gSovereignTestIdleFrames']) - before > frames // 3

    def leave():
        """B out of the list and the shop's menu, then through the shop's and the clerk's goodbyes, until the field
        runs again (B closes them all, and never talks to the clerk again)."""
        for _ in range(30):
            press('B', after=40)
            if field_idle():
                return True
        return False

    d.run(30)
    apricorn_before = {a: bag_count(a) for a in APRICORNS}

    # 1. No points: the first prize is refused
    counter(PRIZE_CLERK, 'prizes_no_points')
    before = (noted(POINTS), noted(PRIZES), noted(BOUGHT))
    refused = buy_first('prizes_no_points')
    check(f'no points: the prize is refused ("not enough points": {refused}), nothing stored (points {noted(POINTS)}, '
          f'prizes {noted(PRIZES):#x})', refused == NOT_ENOUGH and (noted(POINTS), noted(PRIZES), noted(BOUGHT)) == before
          and before[:2] == (0, 0))
    leave()

    # 2. The day's prizes, with 3,000 points
    add_points(6)
    check(f'the probe gave 3,000 points ({noted(POINTS)})', noted(POINTS) == 3000)
    counter(PRIZE_CLERK, 'prizes')
    shot('prizes_points_window')
    bought = noted(BOUGHT)
    refused = buy_first('prizes')
    gained = [a for a in APRICORNS if bag_count(a) == apricorn_before[a] + 1]
    check(f'the first prize bought: 200 points ({noted(POINTS)} left), its slot marked ({noted(PRIZES):#x}), '
          f'an Apricorn in the bag ({gained})', refused is None and noted(BOUGHT) == bought + 1 and noted(POINTS) == 2800
          and noted(PRIZES) == 1 and len(gained) == 1)
    refused = buy_first('prizes_again')
    check(f'bought again today: refused ("no more today": {refused}; {noted(POINTS)} points, prizes {noted(PRIZES):#x})',
          refused == NO_MORE_TODAY and noted(POINTS) == 2800 and noted(PRIZES) == 1 and noted(BOUGHT) == bought + 1)
    leave()

    # 3. The data cards
    bag_before = {a: bag_count(a) for a in APRICORNS}
    counter(CARD_CLERK, 'cards')
    bought = noted(BOUGHT)
    refused = buy_first('cards')
    check(f'the first data card bought: 500 points ({noted(POINTS)} left), its bit set ({noted(CARDS):#x}), '
          f'nothing in the bag', refused is None and noted(BOUGHT) == bought + 1 and noted(POINTS) == 2300
          and noted(CARDS) == 1 and bag_count('ITEM_DATA_CARD_01') == 0
          and {a: bag_count(a) for a in APRICORNS} == bag_before)
    refused = buy_first('cards_again')
    check(f'bought again: refused ("already have it": {refused}; {noted(POINTS)} points, cards {noted(CARDS):#x})',
          refused == ALREADY_HAVE and noted(POINTS) == 2300 and noted(CARDS) == 1 and noted(BOUGHT) == bought + 1)
    leave()

    def wait_menu(count, limit=20):
        """A through messages until the script has shown count menus."""
        for _ in range(limit):
            if u32(sym['gSovereignTestMenu'] + MENU_SHOWN) >= count:
                d.run(30)
                return True
            press('A', after=40)
        return False

    # 4. The vending machine, in Athlete Points
    water = bag_count('ITEM_FRESH_WATER')
    points = noted(POINTS)
    menus = u32(sym['gSovereignTestMenu'] + MENU_SHOWN)
    result = face_and_talk(*VENDING)
    check(f'vending machine: warped below it ({result})', result == 'ok')
    check('vending machine: money or points', wait_menu(menus + 1))
    press('DOWN', after=20)
    press('A', after=90)  # Athlete Points: the box, then the drinks
    check('vending machine: the drinks', wait_menu(menus + 2))
    shot('vending_points_box')
    press('A', after=150)  # the first drink
    shot('vending_drink')
    back = wait_menu(menus + 3)  # the drinks again, once it's in the bag
    check(f'a drink for 50 points ({points} to {noted(POINTS)}), one or two in the bag '
          f'({water} to {bag_count("ITEM_FRESH_WATER")})', back and noted(POINTS) == points - 50
          and bag_count('ITEM_FRESH_WATER') in (water + 1, water + 2))
    shot('vending_after')
    check('vending machine: B closes it, the box gone', leave())
    shot('vending_closed')

    # 5. The Dome PC's Pokéathlon data
    menus = u32(sym['gSovereignTestMenu'] + MENU_SHOWN)
    result = face_and_talk(*DATA_PC)
    check(f'Dome PC: warped below it ({result})', result == 'ok')
    check('Dome PC: its pages', wait_menu(menus + 1))
    press('A', after=240)  # the first page
    shot('records_page_0')
    press('A', after=60)  # closes it: the pages again
    check('Dome PC: A closes the records, the pages again', wait_menu(menus + 2, limit=6))
    check('Dome PC: B leaves it', leave())
    shot('after')

    bag = save_block('SAVE_TABLE_ENTRY_BAG')
    held = [(items[u32(bag + 4 * i) & 0xFFFF], u32(bag + 4 * i) >> 16) for i in range(165) if u32(bag + 4 * i)]
    print(f'the Items pocket: {held}', flush=True)
    print(f'{len(problems)} problems', flush=True)
    for p in problems:
        print(f'  {p}')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
