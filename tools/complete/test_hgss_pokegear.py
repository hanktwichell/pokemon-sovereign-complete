#!/usr/bin/env python3
"""Check the Pokégear on the bottom screen and its switch with the Pokétch (include/complete_pokegear.h,
src/applications/complete_pokegear/pokegear.c) in the test build, from the bedroom state:

1. **Getting it:** the player has no Pokétch; with HeartGold's flag for the Pokégear set (as Mom's script sets it) and
   eight numbers in the phone book, the bottom screen switches to the Pokégear as the field runs. Passes when the
   Pokégear runs and is the bottom screen in use.
2. **A call:** tapping the first contact's row (Mom) calls her: the outgoing call's script runs and the call is
   Mom's. A goes through it.
3. **Scrolling:** a tap on the down arrow, then on the first row, calls the second contact (Elm).
4. **The Map:** a tap on the app bar's Map shows the map, with the player's head where HeartGold's map app puts the
   bedroom (its header's world map place, block 21, 12: pixel 172, 116) and the map scrolled to show it.
5. **The Map on Route 30:** after a warp to Route 30 the Pokégear comes back on the Map, the head at the player's
   block of the overworld (17, 10: pixel 140, 100); dragging left scrolls the map; the app bar's Phone shows the list
   again.
6. **The Pokétch:** with the Pokétch enabled (the test build's hook, at the next map's bottom screen) and the player
   on Route 30, the Pokétch shows, with the Pokégear button under its side button. Tapping that button switches to
   the Pokégear; tapping the Pokégear's last app bar button switches back to the Pokétch.
7. **Kept:** switched to the Pokégear again, a warp keeps it on the bottom screen (the choice is saved).
8. **After a battle:** a wild battle (the test build's SELECT, with god mode on) ends the bottom screen; once it's
   won, the Pokégear is back.

Results: a line per part, 'ok' or what went wrong, and screenshots (both screens) in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_pokegear.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp, var_ids  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
CONTACTS = {name: int(n) for name, n in re.findall(r'#define PHONE_CONTACT_(\w+)\s+(\d+)', open(
    os.path.join(DECOMP, 'include', 'constants', 'hgss_phone.h')).read())}
BOOK = ['MOTHER', 'PROF__ELM', 'PROF__OAK', 'LYRA', 'JOEY', 'FALKNER', 'BILL', 'KURT']
BOOK_SIZE, NONE = 75, 0xFF
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000
OUTGOING_CALL = 2000 + 0x81E - 0x7D0  # SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_OUTGOING_CALL)
UNAVAILABLE, POKETCH, POKEGEAR = 0, 1, 2  # enum CompleteBottomScreen
ROUTE, STAND, EAST = 'MAP_HEADER_HGSS_ROUTE_30', (552, 332), 4
FIRST_ROW, DOWN_ARROW = (60, 18), (243, 116)  # the list's first row; the down arrow
POKEGEAR_BUTTON, EXIT_BUTTON = (240, 175), (232, 176)  # on the Pokétch; the Pokégear's last app bar button
MAP_BUTTON, PHONE_BUTTON = (128, 176), (176, 176)  # the app bar's Map and Phone
BEDROOM_PLACE, ROUTE_30_PLACE = (172, 116), (140, 100)  # the head's place on the map
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'sCall', 'gCompleteTestPokegear', 'sActiveBottomScreen',
                                     'gCompleteTestPokegearMap',
                                     'gSovereignTestPoketchApp', 'gSovereignTestGodMode'})
CONTACT_OFFSET = 12  # offsetof(CompletePhoneCall, contact)


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def save_part(name):
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        return base + 20 + u32(page_info + save_entry_index(name) * 16 + 8)

    def set_flag(name):
        addr = save_part('SAVE_TABLE_ENTRY_VARS_FLAGS') + (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        mem.write_byte(addr + n // 8, mem.unsigned[addr + n // 8] | 1 << n % 8)

    def screen():
        return mem.unsigned[sym['sActiveBottomScreen']]

    def gear():
        return u32(sym['gCompleteTestPokegear']) != 0

    def shot(name):
        d.screenshot().save(os.path.join(out, name + '.png'))

    def until(test, frames=600):
        for _ in range(frames // 10):
            if test():
                return True
            d.run(10)
        return test()

    def call_of_tap(x, y):
        """Taps there; the contact whose call starts (None for none), after A through the call."""
        scripts = sym['gSovereignTestScripts']
        mem.write_short(scripts, 0)
        mem.write_byte(sym['sCall'] + CONTACT_OFFSET, NONE)
        d.touch(x, y, frames=6, after=10)
        contact = None
        for _ in range(150):
            d.run(10)
            c = mem.unsigned[sym['sCall'] + CONTACT_OFFSET]
            if c != NONE:
                contact = c
                break
        if contact is None:
            return None, 0
        shot(f'call_{contact}')
        for _ in range(60):  # A through the call, to its end
            if mem.unsigned[sym['sCall'] + CONTACT_OFFSET] == NONE:
                break
            d.press('A', frames=4, after=26)
        d.run(60)
        first = struct.unpack('<H', bytes(mem.unsigned[scripts + 2:scripts + 4]))[0]
        return contact, first

    results = []

    def report(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    # 1. The Pokégear comes as the player gets it
    d.load_state(state)
    d.run(30)
    problem = '' if screen() == UNAVAILABLE else f'the bottom screen was {screen()} at the start'
    phone = save_part('SAVE_TABLE_ENTRY_COMPLETE_PHONE')
    for i in range(BOOK_SIZE):
        mem.write_byte(phone + i, CONTACTS[BOOK[i]] if i < len(BOOK) else NONE)
    set_flag('FLAG_HGSS_GOT_POKEGEAR')
    if not problem and not until(lambda: gear() and screen() == POKEGEAR):
        problem = f'no Pokégear (bottom screen {screen()})'
    d.run(120)
    shot('pokegear')
    report('getting it', problem)

    # 2. Tapping Mom calls her
    if not problem:
        contact, first = call_of_tap(*FIRST_ROW)
        if contact != CONTACTS['MOTHER']:
            problem = f'the call was {contact}'
        elif first != OUTGOING_CALL:
            problem = f'the script was {first}'
        report('a call', problem)

    # 3. Down a row, then the first row is Elm
    if not problem:
        d.touch(*DOWN_ARROW, frames=6, after=30)
        shot('scrolled')
        contact, _ = call_of_tap(*FIRST_ROW)
        if contact != CONTACTS['PROF__ELM']:
            problem = f'the call was {contact}'
        report('scrolling', problem)

    def map_state():
        """(page, the head's x, y, the map's scroll)"""
        return struct.unpack('<4H', bytes(mem.unsigned[sym['gCompleteTestPokegearMap']:sym['gCompleteTestPokegearMap'] + 8]))

    # 4. The Map in the bedroom
    if not problem:
        d.touch(*MAP_BUTTON, frames=6, after=60)
        page, x, y, scroll = map_state()
        if page != 1:
            problem = f'the page is {page}'
        elif (x, y) != BEDROOM_PLACE:
            problem = f'the head is at {(x, y)}'
        elif not scroll <= x - 8 < scroll + 256 - 16:
            problem = f'the map is scrolled to {scroll}, away from the head'
        shot('map_bedroom')
        report('the map', problem)

    # 5. The Map on Route 30: kept, followed, dragged; then the Phone
    if not problem:
        start_warp(d, sym, names.index(ROUTE), *STAND, EAST)
        d.run(400)
        until(lambda: gear() and map_state()[0] == 1)
        d.run(60)
        page, x, y, scroll = map_state()
        if page != 1:
            problem = f'after the warp the page is {page}'
        elif (x, y) != ROUTE_30_PLACE:
            problem = f'the head is at {(x, y)}'
        shot('map_route_30')
    if not problem:
        before = map_state()[3]
        d.emu.input.touch_set_pos(200, 80)
        d.run(4)
        for tx in range(200, 80, -6):
            d.emu.input.touch_set_pos(tx, 80)
            d.run(1)
        d.emu.input.touch_release()
        d.run(30)
        after = map_state()[3]
        if after <= before:
            problem = f'dragging left left the scroll at {after} (from {before})'
        shot('map_dragged')
    if not problem:
        d.touch(*PHONE_BUTTON, frames=6, after=60)
        if map_state()[0] != 0:
            problem = f'the Phone button left the page at {map_state()[0]}'
        shot('phone_again')
    if results[-1].startswith('the map: ok'):
        report('the map on Route 30', problem)

    # 6. The Pokétch, and the switch both ways
    switch_ran = not problem
    if not problem:
        mem.write_byte(sym['gSovereignTestPoketchApp'], 1)  # the digital watch, at the next bottom screen
        start_warp(d, sym, names.index(ROUTE), *STAND, EAST)
        d.run(400)
        if not until(lambda: screen() == POKETCH):
            problem = f'no Pokétch after the warp (bottom screen {screen()})'
        shot('poketch')
    if not problem:
        d.touch(*POKEGEAR_BUTTON, frames=6, after=10)
        if not until(lambda: gear() and screen() == POKEGEAR):
            problem = f'the Pokétch\'s button didn\'t switch (bottom screen {screen()})'
        d.run(60)
        shot('switched_to_pokegear')
    if not problem:
        d.touch(*EXIT_BUTTON, frames=6, after=10)
        if not until(lambda: not gear() and screen() == POKETCH):
            problem = f'the Pokégear\'s button didn\'t switch back (bottom screen {screen()})'
        d.run(60)
        shot('switched_to_poketch')
    if switch_ran:
        report('the switch', problem)

    # 7. The choice is kept across a warp
    if not problem:
        d.touch(*POKEGEAR_BUTTON, frames=6, after=10)
        until(lambda: gear())
        start_warp(d, sym, names.index(ROUTE), STAND[0], STAND[1] + 1, EAST)
        d.run(400)
        if not until(lambda: gear() and screen() == POKEGEAR):
            problem = f'after the warp the bottom screen was {screen()}'
        shot('kept')
        report('kept', problem)

    # 8. A battle and back
    if not problem:
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        d.press('SELECT', frames=4, after=200)
        left = until(lambda: not gear(), frames=300)
        for _ in range(150):  # A through the battle
            if gear() and screen() == POKEGEAR:
                break
            d.press('A', frames=4, after=36)
        d.run(120)
        if not left:
            problem = 'the battle never ended the bottom screen'
        elif not (gear() and screen() == POKEGEAR):
            problem = f'after the battle the bottom screen was {screen()}'
        shot('after_battle')
        report('after a battle', problem)


if __name__ == '__main__':
    main()
