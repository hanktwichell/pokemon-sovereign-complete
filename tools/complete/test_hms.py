#!/usr/bin/env python3
"""The HMs (tools/complete/hm_moves.py): HM05 teaches Whirlpool and the new HM09 Defog, in the test build, from the
bedroom state, taught from the bag as a player would.

Each case makes the party's lead the Pokémon (a test battle against a wild Chansey sets it: gSovereignTestLead,
knowing only Moonblast), empties the bag's TMs & HMs pocket, puts the HM in it, and uses it (the start menu, Bag, the
pocket, the HM, Use, yes, the lead). Then it reads the party (gSovereignTestParty) and the pocket: the lead knows the
HM's move, or (a Pokémon that can't learn it) doesn't, and the HM is still in the bag either way.

Results: a line per case, and a screenshot of each case's bag and end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks the test
build's folder:
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hms.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import fight  # noqa: E402
from battle_form_changes import FOE, LEAD  # noqa: E402
from gift_pokemon import note_party  # noqa: E402
from heap_check import heap_free, heap_info_address  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, symbols  # noqa: E402
from test_trade_evolutions import NO_MOVE, SAVE_PAGES, SAVE_SECTOR, enum_value  # noqa: E402

TMHMS_AT, TMHMS_SIZE = (165 + 100) * 4, 100  # struct Bag: the TMs & HMs pocket after the items and the key items
# (species, the HM, the move it must learn, or None: it can't)
CASES = [
    ('LAPRAS', 'HM05', 'MOVE_WHIRLPOOL'),
    ('GRENINJA', 'HM05', 'MOVE_WHIRLPOOL'),  # a later species: by the Surf rule
    ('PIDGEOT', 'HM09', 'MOVE_DEFOG'),
    ('CORVIKNIGHT', 'HM09', 'MOVE_DEFOG'),
    ('PIDGEOT', 'HM05', None),
    ('LAPRAS', 'HM09', None),
]
FRAME_LIMIT = 6400
# The start menu (its cursor on the Pokédex), down twice to the Bag (it opens on the Items pocket), right three times
# to the TMs & HMs, the HM's menu, Use; "Booted up an HM..." and yes; the lead in the party menu
TEACH = [('X', 40), ('DOWN', 20), ('DOWN', 20), ('A', 90), ('RIGHT', 30), ('RIGHT', 30), ('RIGHT', 40), ('A', 40)]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gSovereignTestLead', 'gSovereignTestWild', 'gSovereignTestParty'))
    species_ids = open(os.path.join(DECOMP, 'generated', 'species.txt')).read().split()
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    moves = open(os.path.join(DECOMP, 'generated', 'moves.txt')).read().split()
    save_index = enum_value('constants/savedata/save_table.h', 'SaveTableEntryID', 'SAVE_TABLE_ENTRY_BAG')
    party_heap = enum_value('constants/heap.h', 'HeapID', 'HEAP_ID_PARTY_MENU')
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

    def party_menu():
        return party_heap in heap_free(mem, heaps)

    def idle():
        for _ in range(3):
            before = u32(sym['gSovereignTestIdleFrames'])
            d.run(10)
            if u32(sym['gSovereignTestIdleFrames']) == before:
                return False
        return True

    results = []
    for n, (species, hm, move) in enumerate(CASES):
        name = f'{species.lower()} + {hm}'
        d.load_state(state)
        d.run(30)
        lead, wild = sym['gSovereignTestLead'], sym['gSovereignTestWild']
        mem.write_short(lead + LEAD['species'], species_ids.index('SPECIES_' + species))
        mem.write_byte(lead + LEAD['form'], 0)
        mem.write_byte(lead + LEAD['level'], 50)
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
        slot_at = bag() + TMHMS_AT
        slot = items.index('ITEM_' + hm) | 1 << 16
        if not problem:
            for i in range(TMHMS_SIZE):
                mem.write_long(slot_at + 4 * i, 0)
            mem.write_long(slot_at, slot)
            d.run(30)
            for key, after in TEACH:
                d.press(key, frames=6, after=after)
            d.screenshot().save(os.path.join(out, f'{n:02d}_{species.lower()}_{hm.lower()}_bag.png'))
            for _ in range(10):  # Use, "Booted up an HM...", yes: until the party menu is up
                if party_menu():
                    break
                d.press('A', frames=4, after=50)
            d.run(60)
            d.press('A', frames=4, after=60)  # the lead
            for _ in range(8):  # "learned ..." (then the bag), or "can't learn ..."
                if not party_menu():
                    break
                d.screenshot().save(os.path.join(out, f'{n:02d}_{species.lower()}_{hm.lower()}_end.png'))
                d.press('A', frames=4, after=50)
            for _ in range(10):  # out of the party menu, the bag and the start menu
                if idle():
                    break
                d.press('B', frames=4, after=40)
            if not idle():
                problem = 'not back on the field'
        if not problem:
            party = note_party(d, sym)
            known = [moves[m] for m in party[0][3] if m]
            if move and move not in known:
                problem = f'knows {known}, not {move}'
            elif not move and known != ['MOVE_MOONBLAST']:
                problem = f'learned something: {known}'
            elif u32(slot_at) != slot:
                problem = f'the HM is gone from the bag (pocket slot {u32(slot_at):#x})'
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} cases ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
