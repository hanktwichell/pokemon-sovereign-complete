#!/usr/bin/env python3
"""Check Johto's Battle Frontier (its lobbies run Platinum's facilities: tools/complete/hgss_script_table.py, the
Battle Frontier's commands) in the test build, from the bedroom state, with the test build's god mode on:

1. **Factory, a round:** the player talks to the Battle Factory's Single Battle attendant and takes a Level 50 single
   challenge (A through the menus and the save). Passes when Platinum's challenge starts
   (ScrCmd_LaunchBattleFrontierScene runs), the rental screen comes up and three Pokémon are rented, the first battle
   is won, and RETIRE on the menu after it brings the player back to Johto's Factory, its lobby's state cleared
   (VAR_BATTLE_FACTORY_LOBBY_LOAD_ACTION 0) and the field running.
2. **Tower, Hall, Castle, Arcade:** the same attendant at each, A through its menus (the test party passes their
   rules; on the party screen it picks the first Pokémon, or the first three).
   Passes when Platinum's challenge for it starts.

FACTORY_ONLY=1 runs the first part alone.

Results: a line per part, 'ok' or what went wrong, and screenshots (each challenge as it starts, the Factory's
rentals, battle and lobby after) in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_frontier.py \\
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
NORTH, WEST = 1, 3  # the test warp's facing: enum FaceDirection + 1
# Each facility: its lobby, the tile in front of its Single Battle attendant, the way to face, and how many Pokémon a
# single challenge enters
FACILITIES = [
    ('Factory', 'MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_FACTORY', 21, 7, NORTH, 0),
    ('Tower', 'MAP_HEADER_HGSS_BATTLE_TOWER', 15, 6, NORTH, 3),
    ('Hall', 'MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_HALL', 7, 9, WEST, 1),
    ('Castle', 'MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_CASTLE', 6, 9, WEST, 3),
    ('Arcade', 'MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_ARCADE', 14, 6, NORTH, 3),
]
PARTY_PROBE = ((10, 232), (104, 120, 160))  # the party screen's background, on the touch screen
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
VARS_START = 0x4000
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'gSovereignTestGodMode'})
RENTAL_PROBES = {(128, 128): (200, 232, 240), (128, 140): (112, 152, 152)}  # the rental screen's conveyor
MENU_PROBES = {(245, 72): (248, 248, 248), (252, 72): (72, 96, 120)}  # CONTINUE / RECORD / REST / RETIRE


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def text_address(name):
    xmap = open(os.path.join(DECOMP, os.environ.get('TEST_BUILD', 'build_test'), 'main.nef.xMAP'),
                errors='replace').read()
    return int(re.search(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.text\s+' + name + r'\b', xmap, re.M).group(1), 16)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory
    scenes = []
    mem.register_exec(text_address('ScrCmd_LaunchBattleFrontierScene'), lambda addr, size: scenes.append(1) or 0)

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def var(name):
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        entry = base + 20 + u32(page_info + save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS') * 16 + 8)
        at = entry + (variables[name] - VARS_START) * 2
        return struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]

    def shows(probes):
        im = d.screenshot().convert('RGB')
        return all(im.getpixel(p) == colour for p, colour in probes.items())

    def field_idle_on(header, frames=120):
        before = u32(sym['gSovereignTestIdleFrames'])
        d.run(frames)
        return u32(sym['gSovereignTestIdleFrames']) - before > frames // 3 and \
            names[u32(sym['gSovereignTestIdleMapHeaderID'])] == header

    def until(test, key='A', limit=200, after=40):
        for _ in range(limit):
            if test():
                return True
            if key:
                d.press(key, frames=4, after=after)
            else:
                d.run(after)
        return test()

    def start(header, x, z, face):
        d.load_state(state)
        d.run(30)
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        start_warp(d, sym, names.index(header), x, z, face)
        d.run(400)
        scenes.clear()

    results = []

    # 1. The Factory: a round, its first battle won, then RETIRE
    name, header, x, z, face, _ = FACILITIES[0]
    start(header, x, z, face)
    problem = '' if until(lambda: scenes, after=40, limit=400) else 'no challenge started'
    if not problem:
        d.screenshot().save(os.path.join(out, 'factory_start.png'))
        if not until(lambda: shows(RENTAL_PROBES), limit=100):
            problem = 'no rental screen'
    if not problem:
        d.run(120)
        for i in range(3):  # each Pokémon: A, then RENT (below SUMMARY), then the next ball
            d.press('A', frames=4, after=30)
            d.press('DOWN', frames=4, after=20)
            d.press('A', frames=4, after=90)
            if i < 2:
                d.press('RIGHT', frames=4, after=30)
        d.screenshot().save(os.path.join(out, 'factory_rented.png'))
        d.press('A', frames=4, after=200)  # yes, these three
        if not until(lambda: shows(MENU_PROBES), limit=150, after=100):  # A through the battle (god mode)
            problem = 'the first battle never ended'
    if not problem:
        d.run(90)  # the menu takes keys once its line has printed
        for _ in range(3):
            d.press('DOWN', frames=4, after=30)
        d.screenshot().save(os.path.join(out, 'factory_after_battle.png'))
        d.press('A', frames=4, after=450)  # RETIRE: its question's cursor starts on NO
        d.press('UP', frames=4, after=30)
        d.screenshot().save(os.path.join(out, 'factory_retire.png'))
        d.press('A', frames=4, after=100)  # YES
        if not until(lambda: field_idle_on(header), limit=60, after=60):
            problem = 'never back in the lobby'
        d.screenshot().save(os.path.join(out, 'factory_lobby_after.png'))
    if not problem and var('VAR_BATTLE_FACTORY_LOBBY_LOAD_ACTION') != 0:
        problem = f'the lobby\'s state is {var("VAR_BATTLE_FACTORY_LOBBY_LOAD_ACTION")}'
    results.append(f'{name}: {problem or "ok"}')
    print(results[-1], flush=True)

    # 2. The other four: the challenge starts
    for name, header, x, z, face, entries in FACILITIES[1:] if not os.environ.get('FACTORY_ONLY') else []:
        start(header, x, z, face)
        picked = False
        for _ in range(300):  # A through the menus
            if scenes:
                break
            if not picked and d.screenshot().convert('RGB').getpixel(PARTY_PROBE[0]) == PARTY_PROBE[1]:
                # the party screen: each pick is A, A (ENTER); after the last the cursor moves to CONFIRM
                d.run(60)
                keys = ['A', 'A'] + (['RIGHT', 'A', 'A', 'DOWN', 'LEFT', 'A', 'A'] if entries == 3 else [])
                for key in keys:
                    d.press(key, frames=4, after=40)
                d.run(60)
                d.screenshot().save(os.path.join(out, f'{name.lower()}_party.png'))
                picked = True
            d.press('A', frames=4, after=40)
        problem = '' if scenes else 'no challenge started'
        d.run(300)
        d.screenshot().save(os.path.join(out, f'{name.lower()}_start.png'))
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)


if __name__ == '__main__':
    main()
