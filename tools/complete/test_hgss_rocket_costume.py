#!/usr/bin/env python3
"""Check HeartGold's Rocket uniform (src/player_avatar.c, src/complete_scrcmd.c's CompleteRocketCostume_IsOn) in the
test build, from the bedroom state:

1. **Without it:** on Goldenrod City's Radio Tower 1F the player walks as Platinum's player (gCompleteTestPlayerGfx).
2. **In it:** with FLAG_HGSS_SYS_ROCKET_COSTUME set (as Goldenrod Tunnel's scene sets it, by HeartGold's
   RocketCostumeFlagAction) the player arrives and walks in HeartGold's Rocket uniform (OBJ_EVENT_GFX_HGSS_RHERO, or
   RHEROINE), and keeps it walking about.
3. **Taken off:** with the flag clear again (the Radio Tower's director takes it back), the next map has the player
   as before.
4. **No Bicycle in it:** in the uniform outside the Radio Tower, Y with the Bicycle registered
   (src/item_use_functions.c's check, as HeartGold's ItemCheckUseFunc_Bicycle) leaves the player walking, with
   Platinum's message for an item that can't be used ("Rowan's words echoed..."), which A closes.
5. **The Bicycle without it:** out of it, the same Y gets them on the Bicycle there.

Results: a line per part, and screenshots in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_rocket_costume.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP, SYMBOLS, header_names, symbols, var_ids, warp  # noqa: E402

PLACE = ('MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_1F', 6, 9)
OUTSIDE = ('MAP_HEADER_HGSS_GOLDENROD', 342, 350)  # below the Radio Tower's door
SOUTH = 0
WALK = ['UP', 'UP', 'LEFT', 'DOWN']
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
# the Bag in the save: its pockets of BagItems (u16 item, u16 quantity), then the item registered to Y (include/bag.h)
BAG_REGISTERED = 4 * sum(int(n) for n in re.findall(r'#define \w+_POCKET_SIZE\s+(\d+)',
                                                     open(os.path.join(DECOMP, 'include', 'bag.h')).read()))
PLAYER_STATE = 0x90  # FIELD_PLAYER_STATE's playerState: walking 0, cycling 1 (include/constants/player_avatar.h)
BICYCLE = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split().index('ITEM_BICYCLE')


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def gfx_ids():
    """{name: number} of the overworld graphics (generated/object_events_gfx.txt: names, or name = number)."""
    ids, n = {}, 0
    for line in open(os.path.join(DECOMP, 'generated', 'object_events_gfx.txt')):
        line = line.strip()
        if not line:
            continue
        if '=' in line:
            name, value = (p.strip() for p in line.split('='))
            n = int(value, 0)
        else:
            name = line
        ids[name] = n
        n += 1
    return ids


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestPlayerGfx', 'sSaveDataPtr'))
    variables = var_ids()
    names = header_names()
    gfx = gfx_ids()
    plain = {gfx['OBJ_EVENT_GFX_PLAYER_M'], gfx['OBJ_EVENT_GFX_PLAYER_F']}
    uniform = {gfx['OBJ_EVENT_GFX_HGSS_RHERO'], gfx['OBJ_EVENT_GFX_HGSS_RHEROINE']}
    d = Driver(rom, state)
    mem = d.emu.memory

    def player_gfx():
        at = sym['gCompleteTestPlayerGfx']
        return struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]

    def u32(at):
        return struct.unpack('<I', bytes(mem.unsigned[at:at + 4]))[0]

    def save_block(entry):
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index(entry) * 16 + 8
        return base + 20 + u32(at)

    def to_place(costume, place=PLACE):
        mem.write_short(sym['gSovereignTestVar'] + 8, variables['FLAG_HGSS_SYS_ROCKET_COSTUME'])
        mem.write_short(sym['gSovereignTestVar'] + 10, 1 if costume else 0)
        result, _ = warp(d, sym, names.index(place[0]), place[1], place[2], SOUTH)
        d.run(30)
        return result

    def busy(frames):
        """Whether the field stays busy (a message up) for the frames."""
        before = u32(sym['gSovereignTestIdleFrames'])
        d.run(frames)
        return u32(sym['gSovereignTestIdleFrames']) - before < 3

    def bicycle():
        """Y with the Bicycle registered to it (the bag's Register, written into the save): the player's state after,
        and whether a message held the field."""
        mem.write_long(save_block('SAVE_TABLE_ENTRY_BAG') + BAG_REGISTERED, BICYCLE)
        d.press('Y', frames=4, after=40)
        held = busy(30)
        return u32(save_block('SAVE_TABLE_ENTRY_FIELD_PLAYER_STATE') + PLAYER_STATE), held

    results = []

    def report(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    d.load_state(state)
    d.run(30)
    result = to_place(False)
    problem = f'warp {result}' if result != 'ok' else '' if player_gfx() in plain else f'the player is {player_gfx()}'
    d.screenshot().save(os.path.join(out, 'plain.png'))
    report('without it', problem)

    result = to_place(True)
    problem = f'warp {result}' if result != 'ok' else '' if player_gfx() in uniform else f'the player is {player_gfx()}'
    if not problem:
        for key in WALK:
            d.press(key, frames=10, after=12)
            if player_gfx() not in uniform:
                problem = f'walking {key}, the player is {player_gfx()}'
                break
    d.screenshot().save(os.path.join(out, 'uniform.png'))
    report('in it', problem)

    result = to_place(False)
    problem = f'warp {result}' if result != 'ok' else '' if player_gfx() in plain else f'the player is {player_gfx()}'
    d.screenshot().save(os.path.join(out, 'taken_off.png'))
    report('taken off', problem)

    result = to_place(True, OUTSIDE)
    problem = f'warp {result}' if result != 'ok' else ''
    if not problem:
        state, held = bicycle()
        d.screenshot().save(os.path.join(out, 'no_bicycle.png'))
        if state != 0:
            problem = f'the player\'s state is {state} after Y'
        elif not held:
            problem = 'no message after Y'
        else:
            for _ in range(15):  # Platinum's "Rowan's words echoed..." runs over a few boxes
                d.press('A', frames=4, after=30)
                if not busy(20):
                    break
            else:
                problem = 'the message never closed'
    report('no Bicycle in it', problem)

    result = to_place(False, OUTSIDE)
    problem = f'warp {result}' if result != 'ok' else ''
    if not problem:
        state, _ = bicycle()
        d.screenshot().save(os.path.join(out, 'bicycle.png'))
        if state != 1:
            problem = f'the player\'s state is {state} after Y'
    report('the Bicycle without it', problem)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
