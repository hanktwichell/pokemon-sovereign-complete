#!/usr/bin/env python3
"""Check that the Ruins of Alph's chamber walls open as in HeartGold (its alph_checks.c; CompleteAlph_CanOpenWall in
src/complete_scrcmd.c, asked by src/item_use_functions.c), in the test build, from the bedroom state.

Each part puts an item in the bag's first slot (its Items pocket), warps to the tile below the chamber's north wall
(6, 3) facing it, and uses the item from the bag as a player would (the start menu, Bag, the item, Use):

1. **An Escape Rope** in Kabuto's chamber (HeartGold's D24R0202);
2. **A Water Stone** in Aerodactyl's chamber (D24R0206).

Each must run the chamber's own script, which shakes the room and takes the wall away: its flag set
(FLAG_HGSS_OPENED_ALPH_*_SECRET_ROOM), the player still in the chamber (the Escape Rope doesn't take them out) and the
item still in the bag. Flash (Omanyte's chamber), which only a Pokémon that knows the move can use, isn't driven here;
its check is the same function's.

Results: a line per part, and a screenshot of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_alph_walls.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP, SYMBOLS, header_names, symbols, var_ids, warp  # noqa: E402

CHAMBER = 'MAP_HEADER_HGSS_RUINS_OF_ALPH_{}_ENTRANCE_FIRST_ROOM'
BELOW_WALL = (6, 3)
NORTH = 1  # the test warp's facing: enum FaceDirection + 1
# (part, the chamber, the item, the flag its script sets)
PARTS = [('an Escape Rope', 'NORTHEAST', 'ITEM_ESCAPE_ROPE', 'FLAG_HGSS_OPENED_ALPH_ESCAPE_ROPE_SECRET_ROOM'),
         ('a Water Stone', 'SOUTHWEST', 'ITEM_WATER_STONE', 'FLAG_HGSS_OPENED_ALPH_WATER_STONE_SECRET_ROOM')]
# The start menu (its cursor on the Pokédex), down twice to the Bag; the bag opens on the Items pocket, its first item
# picked; then Use
USE_FIRST_ITEM = [('X', 40), ('DOWN', 20), ('DOWN', 20), ('A', 90), ('A', 40), ('A', 40)]
SCRIPT_FRAMES = 600  # the shake, the player's start and the wall taken away
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr',))
    names = header_names()
    variables = var_ids()
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    d = Driver(rom, state)
    mem = d.emu.memory

    def u32(at):
        return struct.unpack('<I', bytes(mem.unsigned[at:at + 4]))[0]

    def save_block(entry):
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index(entry) * 16 + 8
        return base + 20 + u32(at)

    def flag(name):
        """Whether a flag is set: VarsFlags is the vars, then the flags' bits."""
        at = save_block('SAVE_TABLE_ENTRY_VARS_FLAGS') + (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        return bool(mem.unsigned[at + n // 8] & (1 << (n % 8)))

    results = []
    for name, chamber, item, wall_flag in PARTS:
        if os.environ.get('ONLY') and os.environ['ONLY'] not in name:
            continue
        d.load_state(state)
        d.run(30)
        header = names.index(CHAMBER.format(chamber))
        problem = ''
        arrived, _ = warp(d, sym, header, *BELOW_WALL, NORTH)
        if arrived != 'ok':
            problem = f'warp {arrived}'
        elif flag(wall_flag):
            problem = 'the wall was open before'
        if not problem:
            bag = save_block('SAVE_TABLE_ENTRY_BAG')  # its Items pocket's first slot: the item, then its count
            slot = items.index(item) | 1 << 16
            mem.write_long(bag, slot)
            d.run(30)
            for key, after in USE_FIRST_ITEM:
                d.press(key, frames=6, after=after)
            d.run(SCRIPT_FRAMES)
            d.screenshot().save(os.path.join(out, f'{chamber.lower()}_end.png'))
            if not flag(wall_flag):
                problem = f'the wall didn\'t open ({wall_flag} clear, at {d.pos()})'
            elif u32(save_block('SAVE_TABLE_ENTRY_BAG')) != slot:
                problem = f'the bag\'s first slot is {u32(save_block("SAVE_TABLE_ENTRY_BAG")):#x}, not {slot:#x}'
            elif d.pos() != BELOW_WALL:
                problem = f'the player is at {d.pos()}, not {BELOW_WALL}'
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
