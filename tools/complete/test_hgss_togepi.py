#!/usr/bin/env python3
"""Hatch Elm's Togepi Egg in the test build and check what follows, as in HeartGold: as it hatches, the flag Elm's
lab script asks for (FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG) and Elm's call about it (CALL_TRIGGER_ELM_EGG_HATCHED) are set
(src/complete_phone.c's CompletePhone_EggHatched); then Elm, shown the Togepi, gives the Everstone
(FLAG_HGSS_GOT_EVERSTONE_FROM_ELM) and calls his call off.

1. The Egg, from Elm's aide in Violet City's Poké Mart, as tools/complete/test_hgss_gifts.py gets it (the party cut to
   its lead first).
2. gCompleteTestHatchEggs: the Egg hatches by Platinum's hatch scene, from the script a step starts when an Egg is
   due; B gets past its messages and turns the nickname down. The party's second Pokémon must be a Togepi, no longer an
   Egg, and the flag and the call trigger must be set.
3. From there (a save state in OUT_DIR), the player comes into Elm's lab (VAR_HGSS_SCENE_ELMS_LAB 5, past its opening
   scenes) with a Togepi leading (gCompleteTestLeadSpecies) and talks to Elm.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_togepi.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from gift_pokemon import names, note_party, talk_and_answer  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, arrive, cases as talk_cases, symbols, var_ids  # noqa: E402

SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
PHONE_CALL_TRIGGERS = 400  # CompletePhoneSave's callTriggerFlags (include/complete_phone.h)
CALL_TRIGGER_ELM_EGG_HATCHED = 0
TEST_VARS = 2  # gSovereignTestVar's entries from here on (arrive() may use [0] and [1])
AIDE = ('events_hgss_152', 'obj_T22FS0101_assistantm', {'FLAG_HGSS_HIDE_VIOLET_SHOP_LAB_AIDE': 0})
ELM = ('events_hgss_058', 'obj_T20R0101_doctor', {'VAR_HGSS_SCENE_ELMS_LAB': 5})


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestMenu', 'gSovereignTestPartyKeep', 'gSovereignTestParty', 'sSaveDataPtr',
                             'gCompleteTestLeadSpecies', 'gCompleteTestHatchEggs'))
    variables = var_ids()
    species_names = names('species')
    places = {(c[0], c[1]): c for c in talk_cases()}
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def save_entry(name):
        """Where a save table entry is in the save data in memory."""
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        return base + 20 + u32(page_info + save_entry_index(name) * 16 + 8)

    def flag(name):
        """Whether a flag is set: VarsFlags is the vars, then the flags' bits."""
        addr = save_entry('SAVE_TABLE_ENTRY_VARS_FLAGS') + (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        return bool(mem.unsigned[addr + n // 8] & (1 << (n % 8)))

    def call_trigger(n):
        return bool(mem.unsigned[save_entry('SAVE_TABLE_ENTRY_COMPLETE_PHONE') + PHONE_CALL_TRIGGERS + n // 8]
                    & (1 << (n % 8)))

    def go_to(events, oid, flags, lead=None, keep=0):
        """In by the map's way in, to the person's side (gSovereignTestVar sets the flags and vars on the way; keep cuts
        the party to its first Pokémon)."""
        def setup():
            if keep:
                mem.write_byte(sym['gSovereignTestPartyKeep'], keep)
            if lead:
                mem.write_short(sym['gCompleteTestLeadSpecies'], species_names.index(lead))
            for i, (name, value) in enumerate(flags.items(), TEST_VARS):
                mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[name])
                mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)
        _, _, header, way_in, x, z, face = places[(events, oid)]
        return arrive(d, sym, d.state, variables, events, header, way_in, x, z, face, setup=setup)

    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)
            d.screenshot().save(os.path.join(out, f'{len(problems)}.png'))

    # 1. The Egg
    d.state = state
    result, frames = go_to(*AIDE, keep=1)
    if result == 'ok':
        result, frames = talk_and_answer(d, sym, [True])
    party = note_party(d, sym) if result == 'ok' else []
    check(f'the aide gives the Egg ({result} {frames})',
          len(party) == 2 and species_names[party[1][0]] == 'SPECIES_TOGEPI' and party[1][7])

    # 2. The hatch: the field stops while the hatch scene runs, then goes on once it's over
    if not problems:
        mem.write_byte(sym['gCompleteTestHatchEggs'], 1)
        started, idle_presses, frames = False, 0, 0
        while frames < 6000 and idle_presses < 4:
            before = u32(sym['gSovereignTestIdleFrames'])
            d.press('B')
            frames += 26
            idle = u32(sym['gSovereignTestIdleFrames']) - before
            started = started or idle == 0
            idle_presses = idle_presses + 1 if started and idle >= 8 else 0
        party = note_party(d, sym)
        check(f'the Egg hatches into a Togepi ({frames} frames)',
              len(party) == 2 and species_names[party[1][0]] == 'SPECIES_TOGEPI' and not party[1][7])
        check('FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG is set', flag('FLAG_HGSS_SYS_HATCHED_TOGEPI_EGG'))
        check("Elm's call about it is due", call_trigger(CALL_TRIGGER_ELM_EGG_HATCHED))
        d.state = os.path.join(out, 'hatched.state')
        d.emu.savestate.save_file(d.state)

    # 3. Elm, shown the Togepi
    if not problems:
        result, frames = go_to(*ELM, lead='SPECIES_TOGEPI')
        if result == 'ok':
            result, frames = talk_and_answer(d, sym, [])
        check(f'Elm gives the Everstone ({result} {frames})',
              result == 'ok' and flag('FLAG_HGSS_GOT_EVERSTONE_FROM_ELM'))
        check("Elm's call is called off", not call_trigger(CALL_TRIGGER_ELM_EGG_HATCHED))

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
