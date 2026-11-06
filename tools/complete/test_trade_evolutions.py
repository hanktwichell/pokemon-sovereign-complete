#!/usr/bin/env python3
"""Trade evolutions without trading (include/complete_evolutions.h), in the test build, from the bedroom state, used
from the bag as a player would.

Each case makes the party's lead the Pokémon (a test battle against a wild Chansey sets it: gSovereignTestLead,
knowing only Moonblast, so a move it learns as it evolves needs no answer), empties the bag's pocket, puts the one item
in it, and uses it on the lead (the start menu, Bag, the item, Use, the lead), answering the evolution's messages with
A while the evolution's heap is there. Then it reads the party (gSovereignTestParty) and the pocket:
- a trade's held item (Onix's Metal Coat...) evolves it as a stone does, and is used up;
- a Rare Candy that takes Kadabra, Machoke, Graveler (and Alolan Graveler) or Haunter to Lv. 37 evolves it, and one
  that takes it to Lv. 36 doesn't;
- Sacred Gold's Covenant Orb still evolves those at any level;
- an item the species doesn't evolve by is refused, and stays in the bag.

Results: a line per case, and a screenshot of each failing case's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks the test
build's folder:
    TEST_BUILD=build_test2 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_trade_evolutions.py \\
        decomp/build_test2/pokeplatinum.us.nds STATE OUT_DIR [SPECIES ...]
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import fight  # noqa: E402
from battle_form_changes import FOE, LEAD  # noqa: E402
from gift_pokemon import note_party  # noqa: E402
from heap_check import heap_free, heap_info_address  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, symbols  # noqa: E402

LEVEL = 37  # COMPLETE_TRADE_EVOLUTION_LEVEL
NO_MOVE = 0xFFFF  # SOVEREIGN_TEST_NO_MOVE
# (species, form, level, item, what it must become (species, form, level), or None: the item is refused)
CASES = [
    ('ONIX', 0, 30, 'METAL_COAT', ('STEELIX', 0, 30)),
    ('SCYTHER', 0, 30, 'METAL_COAT', ('SCIZOR', 0, 30)),
    ('CLAMPERL', 0, 30, 'DEEPSEATOOTH', ('HUNTAIL', 0, 30)),
    ('CLAMPERL', 0, 30, 'DEEPSEASCALE', ('GOREBYSS', 0, 30)),
    ('POLIWHIRL', 0, 30, 'KINGS_ROCK', ('POLITOED', 0, 30)),
    ('SLOWPOKE', 0, 30, 'KINGS_ROCK', ('SLOWKING', 0, 30)),
    ('PORYGON', 0, 30, 'UPGRADE', ('PORYGON2', 0, 30)),
    ('PORYGON2', 0, 30, 'DUBIOUS_DISC', ('PORYGON_Z', 0, 30)),
    ('RHYDON', 0, 45, 'PROTECTOR', ('RHYPERIOR', 0, 45)),
    ('ELECTABUZZ', 0, 30, 'ELECTIRIZER', ('ELECTIVIRE', 0, 30)),
    ('MAGMAR', 0, 30, 'MAGMARIZER', ('MAGMORTAR', 0, 30)),
    ('DUSCLOPS', 0, 40, 'REAPER_CLOTH', ('DUSKNOIR', 0, 40)),
    ('SEADRA', 0, 32, 'DRAGON_SCALE', ('KINGDRA', 0, 32)),
    ('ONIX', 0, 30, 'DEEPSEATOOTH', None),
    ('KADABRA', 0, LEVEL - 1, 'RARE_CANDY', ('ALAKAZAM', 0, LEVEL)),
    ('MACHOKE', 0, LEVEL - 1, 'RARE_CANDY', ('MACHAMP', 0, LEVEL)),
    ('GRAVELER', 0, LEVEL - 1, 'RARE_CANDY', ('GOLEM', 0, LEVEL)),
    ('GRAVELER', 1, LEVEL - 1, 'RARE_CANDY', ('GOLEM', 1, LEVEL)),  # Alolan
    ('HAUNTER', 0, LEVEL - 1, 'RARE_CANDY', ('GENGAR', 0, LEVEL)),
    ('KADABRA', 0, LEVEL - 2, 'RARE_CANDY', ('KADABRA', 0, LEVEL - 1)),
    ('HAUNTER', 0, 25, 'COVENANT_ORB', ('GENGAR', 0, 25)),
    ('MACHOKE', 0, 25, 'COVENANT_ORB', ('MACHAMP', 0, 25)),
]
FRAME_LIMIT = 6400  # the battle that sets the lead
# The start menu (its cursor on the Pokédex), down twice to the Bag; the bag opens on the Items pocket, its first item
# picked; RIGHT once more for the Medicine pocket; then the item's menu, Use, and the lead in the party menu
OPEN_BAG = [('X', 40), ('DOWN', 20), ('DOWN', 20), ('A', 90)]
USE_ON_LEAD = [('A', 40), ('A', 90), ('A', 60)]
POCKETS = [('items', 165), ('keyItems', 100), ('tmHms', 100), ('mail', 12), ('medicine', 40)]  # struct Bag
EVOLVE_LIMIT = 3000
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE


def enum_value(header, enum, name):
    text = open(os.path.join(DECOMP, 'include', header)).read()
    body = text[text.index(f'enum {enum}'):]
    body = body[:body.index('};')]
    value = -1
    for entry in re.findall(r'^\s+(\w+)(?:\s*=\s*([^,]+))?,', body, re.M):
        value = int(entry[1], 0) if entry[1] else value + 1
        if entry[0] == name:
            return value
    raise KeyError(name)


def pocket_offset(pocket):
    at = 0
    for name, size in POCKETS:
        if name == pocket:
            return at
        at += size * 4
    raise KeyError(pocket)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    only = {s.upper() for s in sys.argv[4:]}
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gSovereignTestLead', 'gSovereignTestWild', 'gSovereignTestParty'))
    species_ids = open(os.path.join(DECOMP, 'generated', 'species.txt')).read().split()
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    moves = open(os.path.join(DECOMP, 'generated', 'moves.txt')).read().split()
    save_index = enum_value('constants/savedata/save_table.h', 'SaveTableEntryID', 'SAVE_TABLE_ENTRY_BAG')
    evolution_heap = enum_value('constants/heap.h', 'HeapID', 'HEAP_ID_EVOLUTION')
    heaps = heap_info_address()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory

    def u32(at):
        return struct.unpack('<I', bytes(mem.unsigned[at:at + 4]))[0]

    def bag():
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_index * 16 + 8
        return base + 20 + u32(at)

    def idle():
        """The field runs free (no script, menu or app) for a while."""
        for _ in range(3):
            before = u32(sym['gSovereignTestIdleFrames'])
            d.run(10)
            if u32(sym['gSovereignTestIdleFrames']) == before:
                return False
        return True

    results = []
    for species, form, level, item, want in CASES:
        if only and species not in only:
            continue
        name = f'{species.lower()}{" (Alolan)" if form else ""} Lv. {level} + {item.lower()}'
        d.load_state(state)
        d.run(30)
        lead, wild = sym['gSovereignTestLead'], sym['gSovereignTestWild']
        mem.write_short(lead + LEAD['species'], species_ids.index('SPECIES_' + species))
        mem.write_byte(lead + LEAD['form'], form)
        mem.write_byte(lead + LEAD['level'], level)
        mem.write_short(lead + LEAD['item'], 0)
        mem.write_short(lead + LEAD['moves'], moves.index('MOVE_MOONBLAST'))
        for i in range(1, 4):
            mem.write_short(lead + LEAD['moves'] + 2 * i, NO_MOVE)
        mem.write_short(wild, species_ids.index(FOE[0]))
        mem.write_byte(wild + 3, FOE[1])
        mem.write_short(wild + 4, moves.index(FOE[2]))
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        d.press('SELECT')
        result, _ = fight(d, sym, FRAME_LIMIT)
        problem = '' if result == 'ok' else f'the battle: {result}'
        party = note_party(d, sym) if not problem else []
        if party and (species_ids[party[0][0]], party[0][4], party[0][5]) != ('SPECIES_' + species, form, level):
            problem = f'the lead is {species_ids[party[0][0]]} form {party[0][4]} Lv. {party[0][5]}'
        pocket = 'medicine' if item == 'RARE_CANDY' else 'items'
        slot_at = bag() + pocket_offset(pocket)
        if not problem:
            for i in range(dict(POCKETS)[pocket]):  # the pocket holds the one item
                mem.write_long(slot_at + 4 * i, 0)
            mem.write_long(slot_at, items.index('ITEM_' + item) | 1 << 16)
            d.run(30)
            for key, after in OPEN_BAG + ([('RIGHT', 40)] if pocket == 'medicine' else []) + USE_ON_LEAD:
                d.press(key, frames=6, after=after)
            evolved, frames = False, 0
            while frames < EVOLVE_LIMIT:  # the level-up's and the evolution's messages
                if evolution_heap in heap_free(mem, heaps):
                    evolved = True
                elif evolved or ((want is None or want[0] == species) and frames >= 600):
                    break
                d.press('A', frames=4, after=26)
                frames += 30
            for _ in range(8):  # out of the bag and the start menu
                if idle():
                    break
                d.press('B', frames=4, after=40)
            if not idle():
                problem = f'not back on the field ({"evolved" if evolved else "no evolution"})'
        if not problem:
            party = note_party(d, sym)
            got = (species_ids[party[0][0]][len('SPECIES_'):], party[0][4], party[0][5])
            left = u32(slot_at)
            if want is None:
                if got != (species, form, level):
                    problem = f'became {got}'
                elif left != items.index('ITEM_' + item) | 1 << 16:
                    problem = f'the item was used (pocket slot {left:#x})'
            elif got != want:
                problem = f'became {got}, want {want}'
            elif left != 0:
                problem = f'the item is still in the bag (pocket slot {left:#x})'
            elif evolved != (want[0] != species):
                problem = 'the evolution screen ' + ('ran' if evolved else 'didn\'t run')
        if problem:
            d.screenshot().save(os.path.join(out, f'{len(results):02d}_{species.lower()}_{item.lower()}.png'))
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} cases ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
