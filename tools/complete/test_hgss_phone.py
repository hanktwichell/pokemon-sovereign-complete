#!/usr/bin/env python3
"""Check HeartGold's phone (scripts_battles.s's phone block, src/overlay006/complete_phone_calls.c) in the test build,
from the bedroom state, with god mode on so a battle ends at the first hit. Youngster Joey on Route 30 (shown: his hide
flag cleared) is the trainer:

1. **Number:** the player arrives west of Joey, who spots them and battles; afterwards he asks for the player's number,
   and the test says yes. Passes when the phone book's first contact is Joey.
2. **Rematch:** with Joey wanting a rematch (as a call of his would leave it), the player talks to him. Passes when a
   battle starts and, once it's won, he no longer wants one.
3. **Gift:** with an item kept for the player (as a call of his would leave it), the player talks to him. Passes when
   he no longer keeps it, with no battle.
4. **His call:** a step away from him, Joey calls (gCompleteTestPhoneCaller: an incoming call at the next step).
   Passes when the call's script ran (CommonScript_CompletePhoneIncomingCall) to its end.
5. **Mom's call:** stepping south onto Route 30's call tile, with the call's scene var set, her map script calls about
   saving money; the test says yes. Passes when her savings flag and the flag her call sets are set.
6. **Her savings:** with ¥895 saved, Joey's rematch (src/complete_phone.c). Passes when she took a quarter of the prize
   (at least ¥1) and, past ¥900, bought a Super Potion with ¥600 of it and set her call's trigger.
7. **Her deliveryman:** at the Cherrygrove Mart's deliveryman (shown as the Mart loads). Passes when he handed the
   Super Potion over and her call's trigger is off.
8. **Her bank:** talking to her at home (past her first scene and Elm's lab's, as a game at Route 30 is), the test
   picks WITHDRAW and in the amount window (sMomsBank open) presses up once (the highest digit the amount can have)
   and A. Passes when as much left her savings as reached the wallet.

Every prompt is answered with A (yes). The phone's save and the flags are found from the save's page table
(sSaveDataPtr: its body, then the page table, whose entries give each part's place and size in the body).

Results: one line per part, 'ok' or what went wrong, and a screenshot of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_phone.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp, var_ids  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
MAP = 'MAP_HEADER_HGSS_ROUTE_30'
STAND, EAST = (552, 332), 4  # west of Joey (553, 332), who looks west; the test warp's facing: enum FaceDirection + 1
JOEY = 10  # PHONE_CONTACT_JOEY
SOUTH = 2
MOM_CALL_TILE = (553, 291)  # north of the call's tile (553, 292), Route 30's coord event 5
MART, DELIVERYMAN, WEST = 'MAP_HEADER_HGSS_CHERRYGROVE_POKEMART', (4, 8), 3  # east of Mom's deliveryman (3, 8)
HOME, MOM = 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_1F', (5, 7)  # west of Mom (6, 7)
INCOMING_CALL = 2000 + 0x814 - 0x7D0  # SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_INCOMING_CALL)
PARTS = 8
HIDE_FLAG = 'FLAG_HGSS_HIDE_ROUTE_30_YOUNGSTER_JOEY'
GIFT = 'ITEM_NUGGET'
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
REMATCHES = 76  # offsetof(CompletePhoneSave, rematches)
SAVINGS, GIFTS, TRIGGERS, BOUGHT = 376, 380, 400, 410  # offsetof(CompletePhoneSave, ...): momsSavings to momGiftsBought
MOM_TRIGGER = 12  # CALL_TRIGGER_MOM_BOUGHT_SOMETHING
MONEY = 24  # offsetof(PlayerSave, info) + offsetof(TrainerInfo, money)
LIMIT = 12000  # Joey's battle alone takes 3,000 frames
STEP = 20
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'gSovereignTestTrainerBattles', 'gCompleteTestKeepFlagClear',
                                     'gCompleteTestPhoneCaller', 'sMomsBank'})


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
    items = consts('items.txt')
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory
    phone_entry = save_entry_index('SAVE_TABLE_ENTRY_COMPLETE_PHONE')
    vars_flags_entry = save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS')
    player_entry = save_entry_index('SAVE_TABLE_ENTRY_PLAYER')

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def save_part(entry):
        """(address, size) of a save table entry's part of the save's body."""
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4  # SaveData: 5 words, the body, counters, offsets
        # SavePageInfo: page ID, size, place
        return base + 20 + u32(page_info + entry * 16 + 8), u32(page_info + entry * 16 + 4)

    def phone():
        """The phone's save, in the save's body."""
        return save_part(phone_entry)[0]

    def flag(name):
        """Whether a flag is set: VarsFlags is the vars, then the flags' bits (the save part's size is rounded up)."""
        addr = save_part(vars_flags_entry)[0] + (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        return bool(mem.unsigned[addr + n // 8] & (1 << (n % 8)))

    def set_var(name, value):
        """A var, in the save: VarsFlags starts with the vars."""
        mem.write_short(save_part(vars_flags_entry)[0] + (variables[name] - variables['VARS_START']) * 2, value)

    def rematch(field):
        """(seeking, giftItem) of Joey's rematch state, or its address with field."""
        addr = phone() + REMATCHES + JOEY * 4
        if field:
            return addr
        flags, item = struct.unpack('<HH', bytes(mem.unsigned[addr:addr + 4]))
        return flags & 1, item

    def battles():
        return u32(sym['gSovereignTestTrainerBattles'])

    def savings():
        return u32(phone() + SAVINGS)

    def wallet():
        return u32(save_part(player_entry)[0] + MONEY)

    def mom_gift():
        """(item, quantity) of the first thing Mom bought."""
        return struct.unpack('<HH', bytes(mem.unsigned[phone() + GIFTS:phone() + GIFTS + 4]))

    def mom_trigger():
        return bool(mem.unsigned[phone() + TRIGGERS + MOM_TRIGGER // 8] & (1 << MOM_TRIGGER % 8))

    def run_a(limit=LIMIT):
        """Press A while a script or battle runs (the field not idle at all), until the field has been idle a while.
        A step where the field is idle only part of the time gets no A: a script is just ending, and A then would talk
        to the person the player faces again."""
        frames, idle = 0, 0
        while frames < limit:
            before = u32(sym['gSovereignTestIdleFrames'])
            d.run(STEP)
            frames += STEP
            idle_frames = u32(sym['gSovereignTestIdleFrames']) - before
            if idle_frames >= STEP // 2 - 1:  # a busy outdoor map runs the field every other frame
                idle += 1
                if idle >= 6:
                    return 'ok'
            else:
                idle = 0
                if idle_frames == 0:
                    d.press('A', frames=4, after=0)
        return 'STUCK'

    def arrive():
        """From the bedroom straight to the tile west of Joey: he spots the player as they arrive."""
        d.load_state(state)
        d.run(30)
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        mem.write_short(sym['gSovereignTestVar'], variables[HIDE_FLAG])
        mem.write_short(sym['gSovereignTestVar'] + 2, 0)
        mem.write_short(sym['gCompleteTestKeepFlagClear'], variables[HIDE_FLAG])
        start_warp(d, sym, names.index(MAP), *STAND, EAST)

    results = []

    # 1. Number: Joey spots the player as they arrive
    problem = ''
    before = battles()
    arrive()
    if not problem:
        result = run_a()
        contacts = bytes(mem.unsigned[phone():phone() + 4])
        if result != 'ok':
            problem = f'{result} after the battle'
        elif battles() == before:
            problem = 'no battle'
        elif contacts[0] != JOEY:
            problem = f'the phone book starts {list(contacts)}, not Joey ({JOEY})'
    d.screenshot().save(os.path.join(out, 'number.png'))
    results.append(f'number: {problem or "ok"}')
    print(results[-1], flush=True)

    # 2. Rematch
    if not problem:
        addr = rematch(True)
        mem.write_short(addr, 1)  # seeking
        before = battles()
        d.press('A', frames=4, after=0)
        result = run_a()
        seeking, _ = rematch(False)
        if result != 'ok':
            problem = f'{result}'
        elif battles() == before:
            problem = 'no rematch'
        elif seeking:
            problem = 'still wants a rematch'
        d.screenshot().save(os.path.join(out, 'rematch.png'))
        results.append(f'rematch: {problem or "ok"}')
        print(results[-1], flush=True)

    # 3. Gift
    if not problem:
        mem.write_short(rematch(True) + 2, items.index(GIFT))
        before = battles()
        d.press('A', frames=4, after=0)
        result = run_a()
        _, item = rematch(False)
        if result != 'ok':
            problem = f'{result}'
        elif battles() != before:
            problem = 'a battle instead'
        elif item:
            problem = f'still keeps {items[item]}'
        d.screenshot().save(os.path.join(out, 'gift.png'))
        results.append(f'gift: {problem or "ok"}')
        print(results[-1], flush=True)

    # 4. Joey calls: at the next step, with the phone book holding his number
    if not problem:
        mem.write_short(sym['gSovereignTestScripts'], 0)
        mem.write_short(sym['gSovereignTestScripts'] + 2, 0)
        mem.write_byte(sym['gCompleteTestPhoneCaller'], JOEY + 1)
        d.press('LEFT', frames=16, after=8)  # a step away from Joey
        result = run_a()
        scripts = sym['gSovereignTestScripts']
        count, first = struct.unpack('<HH', bytes(mem.unsigned[scripts:scripts + 4]))
        if result != 'ok':
            problem = f'{result}'
        elif not count or first != INCOMING_CALL:
            problem = f'no call (scripts {count}, first {first})'
        d.screenshot().save(os.path.join(out, 'call.png'))
        results.append(f'call: {problem or "ok"}')
        print(results[-1], flush=True)

    # 5. Mom's call on Route 30, from its map script: saving money, yes
    if not problem:
        mem.write_short(sym['gSovereignTestVar'], variables['VAR_HGSS_SCENE_ROUTE_30_PHONE_CALL'])
        mem.write_short(sym['gSovereignTestVar'] + 2, 1)
        start_warp(d, sym, names.index(MAP), *MOM_CALL_TILE, SOUTH)
        run_a()  # the map's arrival scripts
        mem.write_short(sym['gSovereignTestScripts'], 0)
        d.press('DOWN', frames=16, after=8)  # onto the call's tile
        result = run_a()
        if result != 'ok':
            problem = f'{result}'
        elif not flag('FLAG_HGSS_SYS_MOMS_SAVINGS') or not flag('FLAG_HGSS_TALKED_TO_MOM_AFTER_NAMING_RIVAL'):
            problem = 'the call left the savings flag or her flag unset'
        d.screenshot().save(os.path.join(out, 'mom.png'))
        results.append(f'mom: {problem or "ok"}')
        print(results[-1], flush=True)

    # 6. Her savings: Joey's rematch, with ¥895 saved
    if not problem:
        mem.write_long(phone() + SAVINGS, 895)
        start_warp(d, sym, names.index(MAP), *STAND, EAST)
        run_a()
        mem.write_short(rematch(True), 1)  # seeking
        before, money = battles(), wallet()
        d.press('A', frames=4, after=0)
        result = run_a()
        share = savings() + 600 - 895
        if result != 'ok':
            problem = f'{result}'
        elif battles() == before:
            problem = 'no rematch'
        elif share <= 0:
            problem = f'her savings are ¥{savings()}'
        elif not 3 * share <= wallet() - money <= 3 * share + 3:
            problem = f'¥{wallet() - money} reached the wallet, ¥{share} her savings'
        elif mom_gift() != (items.index('ITEM_SUPER_POTION'), 1) or not mom_trigger():
            problem = f'her gifts start {mom_gift()}, her call\'s trigger {mom_trigger()}'
        d.screenshot().save(os.path.join(out, 'savings.png'))
        results.append(f'savings: {problem or "ok"}')
        print(results[-1], flush=True)

    # 7. Her deliveryman, in the Cherrygrove Mart
    if not problem:
        start_warp(d, sym, names.index(MART), *DELIVERYMAN, WEST)
        run_a()
        d.press('A', frames=4, after=0)
        result = run_a()
        if result != 'ok':
            problem = f'{result}'
        elif mom_gift()[1] or mom_trigger():
            problem = f'her gifts start {mom_gift()}, her call\'s trigger {mom_trigger()}'
        d.screenshot().save(os.path.join(out, 'deliveryman.png'))
        results.append(f'deliveryman: {problem or "ok"}')
        print(results[-1], flush=True)

    # 8. Her bank: WITHDRAW (the menu's first entry, which A picks), up once in the amount window, A
    if not problem:
        set_var('VAR_HGSS_SCENE_PLAYERS_HOUSE_1F', 1)  # her first scene is over
        set_var('VAR_HGSS_SCENE_ELMS_LAB', 4)  # and so is the starter's
        start_warp(d, sym, names.index(HOME), *MOM, EAST)
        run_a()
        saved, money = savings(), wallet()
        d.press('A', frames=4, after=0)
        for _ in range(LIMIT // STEP):
            d.run(STEP)
            if u32(sym['sMomsBank']):
                break
            d.press('A', frames=4, after=0)
        if not u32(sym['sMomsBank']):
            problem = 'no amount window'
        else:
            d.screenshot().save(os.path.join(out, 'bank_window.png'))
            d.press('UP', frames=4, after=8)
            d.press('A', frames=4, after=8)
            result = run_a()
            if result != 'ok':
                problem = f'{result}'
            elif saved - savings() <= 0 or saved - savings() != wallet() - money:
                problem = f'her savings went from ¥{saved} to ¥{savings()}, the wallet from ¥{money} to ¥{wallet()}'
        d.screenshot().save(os.path.join(out, 'bank.png'))
        results.append(f'bank: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {PARTS} parts ok')
    sys.exit(0 if ok == PARTS else 1)


if __name__ == '__main__':
    main()
