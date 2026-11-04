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
9. **The Bike Shop's call:** from the bedroom state again, with the Bike Shop's number in the phone and 1,023 steps
   biked (CompletePhone_CountBikeStep), the player gets on the Bicycle (Y, with it registered) on Route 30 and rides a
   step. Passes when the steps reach 1,024 and the Bike Shop's call trigger is set (HeartGold's
   CALL_TRIGGER_BIKE_SHOP_STEPS), a step on foot first having counted nothing.
10. **The Day-Care Man's calls:** past the Day-Care couple's numbers (VAR_HGSS_UNK_408E 3), with an Egg waiting (written
   into the Day-Care's save), the player talks to the Day-Care Man on Route 34 and says no to the Egg twice: HeartGold's
   lines for his first Egg, then his question about calling, yes. Passes when the state is 4, his egg-call flag is set
   (FLAG_HGSS_SYS_TRIGGER_EGG_CALL: past the first, he calls only when asked to) and so is the yes
   (FLAG_HGSS_SYS_SUBSCRIBED_TO_EGG_CALLS); and when, talked to again with nothing in his care, he asks again and a
   no clears it.

11. **Baoba's calls:** from the bedroom state again, five hours played and Baoba's time stamp at none, past his first
   test (VAR_HGSS_UNK_4057 3), a map load sets his next-test call's trigger (src/complete_safari.c); with the ten
   minutes since the last call gone (sMinutesSinceCall), a step brings the call, which sets the var to 4. Then past his
   second (6), with the National Dex, the objects' call gives the first group (the Safari Zone's unlock level 1, his
   stamp the play time, the var 7). Then his call about the areas whose Pokémon changed, two of them written into the
   phone's save (gCompleteTestPhoneCaller: his call at the next step). Passes when each call's script ran to its end
   and did that.

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
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp, var_ids, warp  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
MAP = 'MAP_HEADER_HGSS_ROUTE_30'
STAND, EAST = (552, 332), 4  # west of Joey (553, 332), who looks west; the test warp's facing: enum FaceDirection + 1
JOEY = 10  # PHONE_CONTACT_JOEY
SOUTH = 2
MOM_CALL_TILE = (553, 291)  # north of the call's tile (553, 292), Route 30's coord event 5
MART, DELIVERYMAN, WEST = 'MAP_HEADER_HGSS_CHERRYGROVE_POKEMART', (4, 8), 3  # east of Mom's deliveryman (3, 8)
HOME, MOM = 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_1F', (5, 7)  # west of Mom (6, 7)
INCOMING_CALL = 2000 + 0x814 - 0x7D0  # SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_INCOMING_CALL)
REPEL_WORE_OFF = 2000 + 0x7F0 - 0x7D0  # CommonScript_RepelsEffectWoreOff
PARTS = 11
HIDE_FLAG = 'FLAG_HGSS_HIDE_ROUTE_30_YOUNGSTER_JOEY'
GIFT = 'ITEM_NUGGET'
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
REMATCHES = 76  # offsetof(CompletePhoneSave, rematches)
SAVINGS, GIFTS, TRIGGERS, BOUGHT = 376, 380, 400, 410  # offsetof(CompletePhoneSave, ...): momsSavings to momGiftsBought
MOM_TRIGGER = 12  # CALL_TRIGGER_MOM_BOUGHT_SOMETHING
BIKE_STEPS, BIKE_SHOP_TRIGGER, BIKE_SHOP = 414, 2, 15  # offsetof(CompletePhoneSave, bikeSteps); the trigger; contact
BIKE_SHOP_CALL_STEPS = 1024
BAOBA = 24  # PHONE_CONTACT_BAOBA
BAOBA_TRIGGERS = range(7, 12)  # CALL_TRIGGER_BAOBA_NEXT_TEST to CALL_TRIGGER_BAOBA_MEMORY_LOSS
SAFARI_AREAS, SAFARI_AREA_COUNT = 416, 422  # offsetof(CompletePhoneSave, safariAreas), safariAreaCount
SAFARI_UNLOCK, SAFARI_STAMP = 745, 748  # offsetof(SafariZoneSave, objectUnlockLevel), baobaStampMinutes
PLAY_HOURS = 38  # offsetof(PlayerSave, playTime): two options' words, then a 32-byte TrainerInfo and the coins
NATIONAL_DEX_FROM_END = 9  # Pokedex.nationalDexObtained: the save part's size less a u32 and two bytes, and padding
DAYCARE_EGG = 472  # offsetof(Daycare, offspringPersonality): two DaycareMons of 236 bytes (a BoxPokemon, its mail, steps)
WEST_FACING = 3  # the test warp's facing for west: enum FaceDirection + 1
# the Bag in the save: its pockets of BagItems (u16 item, u16 quantity), then the item registered to Y (include/bag.h)
BAG_REGISTERED = 4 * sum(int(n) for n in re.findall(r'#define \w+_POCKET_SIZE\s+(\d+)',
                                                     open(os.path.join(DECOMP, 'include', 'bag.h')).read()))
MONEY = 24  # offsetof(PlayerSave, info) + offsetof(TrainerInfo, money)
LIMIT = 12000  # Joey's battle alone takes 3,000 frames
STEP = 20
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'gSovereignTestTrainerBattles', 'gCompleteTestKeepFlagClear',
                                     'gCompleteTestPhoneCaller', 'sMomsBank', 'gSovereignTestMenu'})
DAY_CARE_MAN = 'MAP_HEADER_HGSS_ROUTE_34', (365, 411), 1  # below him (365, 410), facing north (the warp's 1)


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

    # 9. The Bike Shop's call: 1,023 steps biked, a step on foot (nothing counted), then on the bike, a step
    d.load_state(state)
    d.run(30)
    from test_map_warp import floor
    plain = floor(MAP)[0]  # a free floor tile with two more west of it, off Joey's row, the nearest to him
    x, z = min(((x, z) for (x, z) in floor(MAP)[1] if z != STAND[1] and all(plain(x - i, z) for i in range(3))),
               key=lambda t: (t[0] - STAND[0]) ** 2 + (t[1] - STAND[1]) ** 2)
    arrived, _ = warp(d, sym, names.index(MAP), x, z, WEST_FACING)
    problem = f'warp {arrived}' if arrived != 'ok' else ''
    if not problem:
        contacts = phone()
        slot = next(i for i in range(75) if mem.unsigned[contacts + i] in (0xFF, BIKE_SHOP))
        mem.write_byte(contacts + slot, BIKE_SHOP)
        mem.write_short(phone() + BIKE_STEPS, BIKE_SHOP_CALL_STEPS - 1)
        d.press('LEFT', frames=16, after=20)
        walked = struct.unpack('<H', bytes(mem.unsigned[phone() + BIKE_STEPS:phone() + BIKE_STEPS + 2]))[0]
        mem.write_long(save_part(save_entry_index('SAVE_TABLE_ENTRY_BAG'))[0] + BAG_REGISTERED, items.index('ITEM_BICYCLE'))
        d.press('Y', frames=4, after=60)
        d.press('LEFT', frames=8, after=30)
        steps = struct.unpack('<H', bytes(mem.unsigned[phone() + BIKE_STEPS:phone() + BIKE_STEPS + 2]))[0]
        trigger = bool(mem.unsigned[phone() + TRIGGERS + BIKE_SHOP_TRIGGER // 8] & (1 << BIKE_SHOP_TRIGGER % 8))
        if walked != BIKE_SHOP_CALL_STEPS - 1:
            problem = f'a step on foot counted ({walked})'
        elif steps != BIKE_SHOP_CALL_STEPS or not trigger:
            problem = f'{steps} steps biked, the call\'s trigger {trigger} (at {d.pos()})'
    d.screenshot().save(os.path.join(out, 'bike_shop.png'))
    results.append(f'Bike Shop: {problem or "ok"}')
    print(results[-1], flush=True)

    # 10. The Day-Care Man's calls: no to the Egg twice, then yes to his question; then, with nothing, his question, no
    def set_flag(name, on):
        at = save_part(vars_flags_entry)[0] + (variables['VARS_END'] - variables['VARS_START']) * 2 + variables[name] // 8
        bit = 1 << variables[name] % 8
        mem.write_byte(at, mem.unsigned[at] | bit if on else mem.unsigned[at] & ~bit & 0xFF)

    def menus():
        return u32(sym['gSovereignTestMenu'])

    def talk(answers):
        """A to talk and through the lines; each menu as it shows gets its answer ('A' yes, 'B' no); then until idle."""
        d.press('A', frames=4, after=10)
        shown, frames = menus(), 0
        while answers and frames < LIMIT:
            d.run(STEP)
            frames += STEP
            if menus() != shown:
                shown = menus()
                d.run(10)
                d.press(answers.pop(0), frames=4, after=10)
            elif u32(sym['gSovereignTestIdleFrames']) == 0 or frames % (3 * STEP) == 0:
                d.press('A', frames=4, after=0)
        return answers, run_a()

    d.load_state(state)
    d.run(30)
    header, (x, z), facing = DAY_CARE_MAN
    mem.write_short(sym['gSovereignTestVar'] + 8, variables['VAR_HGSS_UNK_408E'])  # past the grandparents' scene as the
    mem.write_short(sym['gSovereignTestVar'] + 10, 3)  # map loads: the Day-Care Man outside
    arrived, _ = warp(d, sym, names.index(header), x, z, facing)
    problem = f'warp {arrived}' if arrived != 'ok' else ''
    if not problem:
        daycare, size = save_part(save_entry_index('SAVE_TABLE_ENTRY_DAYCARE'))
        set_var('VAR_HGSS_UNK_408E', 3)
        set_flag('FLAG_HGSS_SYS_TRIGGER_EGG_CALL', False)
        set_flag('FLAG_HGSS_SYS_SUBSCRIBED_TO_EGG_CALLS', False)
        mem.write_long(daycare + DAYCARE_EGG, 0x12345678)  # Daycare.offspringPersonality: an Egg waiting
        left, result = talk(['B', 'B', 'A'])
        at = save_part(vars_flags_entry)[0] + (variables['VAR_HGSS_UNK_408E'] - variables['VARS_START']) * 2
        state_408e = struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]
        if left or result != 'ok':
            problem = f'{len(left)} menus never came ({result})'
        elif state_408e != 4 or not flag('FLAG_HGSS_SYS_TRIGGER_EGG_CALL') or not flag('FLAG_HGSS_SYS_SUBSCRIBED_TO_EGG_CALLS'):
            problem = (f'his first Egg: state {state_408e}, his egg-call flag {flag("FLAG_HGSS_SYS_TRIGGER_EGG_CALL")}, '
                       f'the yes {flag("FLAG_HGSS_SYS_SUBSCRIBED_TO_EGG_CALLS")}')
        else:
            left, result = talk(['B'])
            if left or result != 'ok':
                problem = f'again, his question never came ({result})'
            elif flag('FLAG_HGSS_SYS_SUBSCRIBED_TO_EGG_CALLS'):
                problem = 'a no to his question kept the yes'
    d.screenshot().save(os.path.join(out, 'day_care_man.png'))
    results.append(f'Day-Care Man: {problem or "ok"}')
    print(results[-1], flush=True)

    # 11. Baoba's calls: his next test, the first objects, then the areas with new Pokémon
    import subprocess
    nef = os.path.join(os.path.dirname(rom), 'main.nef')
    statics = {line.split()[2]: int(line.split()[0], 16) for line in subprocess.run(
        ['arm-none-eabi-nm', nef], capture_output=True, text=True).stdout.splitlines() if len(line.split()) == 3}

    def triggered(trigger):
        return bool(mem.unsigned[phone() + TRIGGERS + trigger // 8] & (1 << trigger % 8))

    def var(name):
        at = save_part(vars_flags_entry)[0] + (variables[name] - variables['VARS_START']) * 2
        return struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]

    def baoba_call(step, caller=None):
        """A step that brings a call, run to its end: '' or what went wrong. A step whose script is the bedroom
        state's Super Repel wearing off is taken again."""
        for _ in range(3):
            mem.write_short(statics['sMinutesSinceCall'], 10)
            mem.write_short(sym['gSovereignTestScripts'], 0)
            mem.write_short(sym['gSovereignTestScripts'] + 2, 0)
            if caller is not None:
                mem.write_byte(sym['gCompleteTestPhoneCaller'], caller + 1)
            d.press(step, frames=16, after=8)
            result = run_a()
            scripts = sym['gSovereignTestScripts']
            count, first = struct.unpack('<HH', bytes(mem.unsigned[scripts:scripts + 4]))
            if result != 'ok' or first != REPEL_WORE_OFF:
                break
            step = 'RIGHT' if step == 'LEFT' else 'LEFT'
        return result if result != 'ok' else '' if count and first == INCOMING_CALL else f'no call ({count}, {first})'

    d.load_state(state)
    d.run(30)
    safari = save_part(save_entry_index('SAVE_TABLE_ENTRY_COMPLETE_SAFARI'))[0]
    mem.write_short(save_part(player_entry)[0] + PLAY_HOURS, 5)
    mem.write_short(safari + SAFARI_STAMP, 0)
    mem.write_byte(safari + SAFARI_UNLOCK, 0)
    set_var('VAR_HGSS_UNK_4057', 3)
    arrived, _ = warp(d, sym, names.index(MAP), x, z, WEST_FACING)  # part 9's tile: a map load
    problem = f'warp {arrived}' if arrived != 'ok' else ''
    if not problem and not triggered(BAOBA_TRIGGERS[0]):
        problem = 'the map load set no trigger for his next test'
    if not problem:
        problem = baoba_call('LEFT')
        if not problem and (var('VAR_HGSS_UNK_4057') != 4 or triggered(BAOBA_TRIGGERS[0])):
            problem = f'his next test: the var {var("VAR_HGSS_UNK_4057")}, the trigger {triggered(BAOBA_TRIGGERS[0])}'
    if not problem:
        pokedex, size = save_part(save_entry_index('SAVE_TABLE_ENTRY_POKEDEX'))
        mem.write_byte(pokedex + size - NATIONAL_DEX_FROM_END, 1)
        set_var('VAR_HGSS_UNK_4057', 6)
        arrived, _ = warp(d, sym, names.index(MAP), x, z, WEST_FACING)
        problem = f'warp {arrived}' if arrived != 'ok' else ''
        if not problem and not triggered(BAOBA_TRIGGERS[1]):
            problem = 'the map load set no trigger for the objects ' + str([t for t in BAOBA_TRIGGERS if triggered(t)])
        if not problem:
            problem = baoba_call('RIGHT')
            unlock = mem.unsigned[safari + SAFARI_UNLOCK]
            stamp = struct.unpack('<H', bytes(mem.unsigned[safari + SAFARI_STAMP:safari + SAFARI_STAMP + 2]))[0]
            if not problem and (unlock != 1 or var('VAR_HGSS_UNK_4057') != 7 or stamp < 5 * 60):
                problem = f'the objects: unlock level {unlock}, the var {var("VAR_HGSS_UNK_4057")}, stamp {stamp}'
    if not problem:
        for i, area in enumerate((0, 5)):
            mem.write_byte(phone() + SAFARI_AREAS + i, area)
        mem.write_byte(phone() + SAFARI_AREA_COUNT, 2)
        problem = baoba_call('LEFT', BAOBA)
        problem = problem and f'his areas call: {problem}'
    d.screenshot().save(os.path.join(out, 'baoba.png'))
    results.append(f'Baoba: {problem or "ok"}')
    print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {PARTS} parts ok')
    sys.exit(0 if ok == PARTS else 1)


if __name__ == '__main__':
    main()
