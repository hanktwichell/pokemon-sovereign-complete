#!/usr/bin/env python3
"""HeartGold's Dowsing Machine (include/complete_dowsing.h), in the test build, from the bedroom state, as a player
would use it.

The bag gets the Dowsing Machine (registered to Y), the player Mom's Running Shoes, and warps next to one of Johto's hidden items, facing
it. Then:

1. **Y turns it on:** the bottom screen becomes the radar (its overlay loaded), the A button reading CHECK (the player
   faces the hidden item).
2. **Holding the radar:** the nearest hidden item is the one in front (one tile away: level 4), the needles strengthen,
   the dots light, the beep plays, and the first needle points from the touch toward the item. Let go: the needles and
   dots fade out.
3. **Further away:** from tiles 10, 15 and 20 tiles from the item, the radar's level is the one HeartGold's gives for
   the nearest hidden item there (3 within 12 tiles, 2 within 17, 0 with none in range).
4. **The A button:** touched, it presses A: the hidden item's script runs (the label reads NEXT while its message
   shows), the item goes in the bag, and the radar no longer finds it.
5. **The running shoes:** touched, they're on (in the save), and the player runs with no B held: a step takes half
   the frames; touched again, off.
6. **EXIT:** the radar goes, and the bottom screen is back. **From the bag:** the Start menu's Bag, the Key Items, the
   Dowsing Machine, USE: back on the field with the radar on. It stays on through a map change.

Results: a line per check, screenshots in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_dowsing.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import math
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from check_object_tiles import Maps, walkable  # noqa: E402
from talk_to_objects import (DECOMP, FRAME_LIMIT, SYMBOLS, TEST_BUILD, event_maps, header_at, header_names,  # noqa: E402
                             play_out, symbols, warp)

SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
KEY_POCKET = 165  # the Bag's Key Items, after its 165 Items (include/bag.h)
REGISTERED = (165 + 100 + 100 + 12 + 40 + 64 + 30 + 30) * 4  # Bag.registeredItem
RUNNING_SHOES = 142  # FieldOverworldState.playerData.runningShoes (include/field_overworld_state.h; its save entry is SAVE_TABLE_ENTRY_FIELD_PLAYER_STATE)
HIDDEN_ITEM = 2  # BG_EVENT_TYPE_HIDDEN_ITEM
HIDDEN_SCRIPTS = range(8000, 8800)  # SCRIPT_ID_OFFSET_HIDDEN_ITEMS to SCRIPT_ID_OFFSET_SAFARI_GAME
RADAR = (84, 100)  # the radar's centre on the bottom screen
TOUCH = (114, 100)  # where the test holds it: 30 pixels right of the centre
A_BUTTON, SHOES, EXIT = (200, 165), (215, 110), (224, 20)
FACING = {0: (0, -1), 1: (0, 1), 2: (-1, 0), 3: (1, 0)}  # enum FaceDirection
# gCompleteTestDowsing's fields (include/complete_dowsing.h)
ON, LEVEL, NEAREST_X, NEAREST_Z, FOUND, STRENGTH, MODE, TOUCHING, ANGLE, DOTS, PITCH, SHOES_ON = range(12)
MODE_CHECK, MODE_NEXT = 2, 4


def s16(v):
    return v - 0x10000 if v & 0x8000 else v


def level_of(nearest):
    """HeartGold's ov28_0225E1A4: the radar's level for the nearest hidden item (dx, dz), or None."""
    if nearest is None:
        return 0
    ax, az = abs(nearest[0]), abs(nearest[1])
    if ax <= 8 and az <= 8:
        return 4
    if ax <= 12 and az <= 12:
        return 3
    if ax <= 17 and az <= 17:
        return 2
    return 1


def nearest_from(items, x, z):
    """HeartGold's AllocAndFetchNearbyHiddenItems and ov28_0225DD58: the first of the nearest within 17 tiles."""
    best = None
    for ix, iz in items:
        dx, dz = ix - x, iz - z
        if abs(dx) <= 17 and abs(dz) <= 17 and (best is None or abs(dx) + abs(dz) < abs(best[0]) + abs(best[1])):
            best = (dx, dz)
    return best


def needle_angle(dx, dz, tx, ty):
    """HeartGold's ov28_0225E0F4: within 8 tiles, the first needle's angle, from the touch toward the item."""
    ix, iz = dx * 8 + RADAR[0], dz * 8 + RADAR[1]
    return int(math.degrees(math.atan2(iz - ty, ix - tx)) % 360)


def open_stretch(headers_of, cur, grid, header, item, length=12):
    """The west end of a row of plain ground near the item (no grass, no objects, the same map), to walk east on."""
    maps = Maps(DECOMP)
    matrix = headers_of[0][1]
    taken = {(o['x'], o['z']) for o in cur.get('object_events', [])}
    for r in range(1, 20):
        for z in range(item[1] - r, item[1] + r + 1):
            for x in range(item[0] - r - length, item[0] + r + 1):
                row = [(x + i, z) for i in range(length)]
                if all(p not in taken and walkable(maps.tile(matrix, *p)) and maps.tile(matrix, *p) & 0xff == 0
                       and header_at(headers_of, grid, *p) == header for p in row):
                    return x, z
    return None


def choose_case():
    """A Johto hidden item with a tile to stand on in front of it, on an outdoor map with room to back off from it."""
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import test_hgss_hidden_items as hidden  # noqa: E402

    ids = header_names()
    by_events = {events: (headers_of, cur, grid) for events, headers_of, cur, grid in event_maps()}
    for events, script, header, _, x, z, face in hidden.cases():
        if face is None or hidden.UNDER.get((events, script)):
            continue
        headers_of, cur, grid = by_events[events]
        if len(headers_of) < 1 or grid is None:
            continue
        items = [(bg['x'], bg['z']) for bg in cur.get('bg_events', [])
                 if bg['type'] == HIDDEN_ITEM and bg['script'] in HIDDEN_SCRIPTS
                 and header_at(headers_of, grid, bg['x'], bg['z']) == ids[header]]
        fx, fz = FACING[face]
        item = (x + fx, z + fz)
        if nearest_from(items, x, z) != (fx, fz):
            continue
        backs = {}
        for far, want in ((10, 3), (15, 2), (20, 0)):
            for ox, oz in ((-far, 0), (far, 0), (0, -far), (0, far)):
                bx, bz = item[0] + ox, item[1] + oz
                try:
                    same = header_at(headers_of, grid, bx, bz) == ids[header]
                except (IndexError, KeyError, TypeError):
                    same = False
                if same and level_of(nearest_from(items, bx, bz)) == want:
                    backs[want] = (bx, bz, nearest_from(items, bx, bz))
                    break
        stretch = open_stretch(headers_of, cur, grid, ids[header], item)
        if len(backs) == 3 and stretch:
            return events, script, header, x, z, face, item, items, backs, stretch
    raise SystemExit('no hidden item to test from')


def main():
    from drive import KEYS, Driver, keymask

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gCompleteTestDowsing'))
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    xmap = open(os.path.join(DECOMP, TEST_BUILD, 'main.nef.xMAP'), encoding='utf-8', errors='replace').read()
    loaded = int(re.search(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.bss\s+Unk_021BF370\b', xmap, re.M).group(1), 16)
    overlay_names = re.findall(r'^Overlay (\S+)', open(os.path.join(DECOMP, 'platinum.us', 'main.lsf')).read(), re.M)
    events, script, header, sx, sz, face, item, hidden_items, backs, stretch = choose_case()
    print(f'{events}: the hidden item {script} at {item}, from {(sx, sz)} facing {face}; plain ground from {stretch}',
          flush=True)
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

    def marker(i):
        at = sym['gCompleteTestDowsing'] + 2 * i
        return struct.unpack('<H', bytes(mem.unsigned[at:at + 2]))[0]

    def save_block(entry):
        text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
        index = re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', text[text.index('enum SaveTableEntryID'):], re.M).index(entry)
        base = u32(sym['sSaveDataPtr'])
        return base + 20 + u32(base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + index * 16 + 8)

    def overlays():
        return [overlay_names[u32(loaded + 8 * i)] for i in range(24) if u32(loaded + 8 * i + 4)]

    def wait_on(on, frames=600):
        for _ in range(frames // 10):
            d.run(10)
            if bool(marker(ON)) == on and (('complete_dowsing' in overlays()) == on):
                d.run(40)  # the bottom screen's fade in
                return True
        return False

    def hold(x, y, frames):
        d.emu.input.touch_set_pos(x, y)
        d.run(frames)

    def release(after=0):
        d.emu.input.touch_release()
        d.run(after)

    def steps_in(frames):
        """Tiles walked right in so many frames, holding only RIGHT."""
        x0 = d.pos()[0]
        mem.write_short(sym['gSovereignTestScripts'], 0)
        d.emu.input.keypad_add_key(keymask(KEYS['RIGHT']))
        d.run(frames)
        d.emu.input.keypad_rm_key(keymask(KEYS['RIGHT']))
        d.run(30)
        moved = d.pos()[0] - x0
        settle()
        return moved

    def settle():
        """Play out a script the walk or warp started (a Repel wearing off), which hides the shoes and EXIT."""
        d.run(10)
        if u32(sym['gSovereignTestScripts']) & 0xFFFF or marker(MODE) == MODE_NEXT:
            play_out(d, sym, FRAME_LIMIT, press_a=False)

    d.run(30)
    bag = save_block('SAVE_TABLE_ENTRY_BAG')
    mem.write_long(bag + KEY_POCKET * 4, items.index('ITEM_DOWSING_MCHN') | 1 << 16)
    mem.write_long(bag + REGISTERED, items.index('ITEM_DOWSING_MCHN'))
    mem.write_short(save_block('SAVE_TABLE_ENTRY_FIELD_PLAYER_STATE') + RUNNING_SHOES, 1)  # Mom's, from downstairs
    result, _ = warp(d, sym, header, sx, sz, face + 1)
    check(f'warped next to the hidden item ({result})', result == 'ok' and d.pos() == (sx, sz))
    d.run(30)
    shot('field')
    check('the Dowsing Machine is off to begin with', not marker(ON) and 'complete_dowsing' not in overlays())

    # 1. Y turns it on
    d.press('Y', frames=6, after=0)
    check('Y turns it on: the radar on the bottom screen', wait_on(True))
    shot('radar')
    check(f'the A button reads CHECK, facing the hidden item (mode {marker(MODE)})', marker(MODE) == MODE_CHECK)

    # 2. Holding the radar
    hold(*TOUCH, 90)
    dx, dz = item[0] - sx, item[1] - sz
    found = (marker(FOUND), s16(marker(NEAREST_X)), s16(marker(NEAREST_Z)))
    check(f'held: the nearest hidden item is the one in front ({found})', found == (1, dx, dz))
    check(f'level 4 within 8 tiles (level {marker(LEVEL)})', marker(LEVEL) == 4)
    check(f'the needles strengthen ({marker(STRENGTH)})', marker(STRENGTH) > 100)
    check(f'the dots light ({marker(DOTS)})', marker(DOTS) > 0)
    want = needle_angle(dx, dz, *TOUCH)
    angle = marker(ANGLE) % 360
    check(f'the first needle points from the touch to the item ({angle}, {want})', min(abs(angle - want), 360 - abs(angle - want)) <= 2)
    check(f'the beep plays, higher near the item (pitch {s16(marker(PITCH))})', s16(marker(PITCH)) > 0)
    shot('radar_held')
    hold(RADAR[0] - 40, RADAR[1] + 30, 30)
    shot('radar_held_elsewhere')
    release(10)
    check('let go: the radar is no longer held', not marker(TOUCHING))
    shot('radar_fading')
    d.run(400)  # the field runs at 30 frames a second: the strongest fade over 159 of its frames
    check(f'the needles and dots fade out ({marker(STRENGTH)}, {marker(DOTS)})', marker(STRENGTH) == 0 and marker(DOTS) == 0)

    # 3. Further away
    for want_level, (bx, bz, nearest) in sorted(backs.items(), reverse=True):
        result, _ = warp(d, sym, header, bx, bz, face + 1)
        d.run(30)
        hold(*TOUCH, 40)
        got = (marker(LEVEL), marker(FOUND), s16(marker(NEAREST_X)), s16(marker(NEAREST_Z)))
        want = (want_level, int(nearest is not None)) + (nearest if nearest else (got[2], got[3]))
        check(f'from {(bx, bz)}: level {want_level}, nearest {nearest} (got {got}; warp {result}; still on: {marker(ON)})',
              result == 'ok' and got == want and marker(ON) == 1)
        shot(f'radar_level_{want_level}')
        release(200)

    # 4. The A button presses A: the hidden item
    result, _ = warp(d, sym, header, sx, sz, face + 1)
    d.run(30)
    mem.write_short(sym['gSovereignTestScripts'], 0)
    hold(*A_BUTTON, 8)
    release(0)
    started = 0
    for _ in range(60):
        d.run(5)
        started = u32(sym['gSovereignTestScripts'])
        if started & 0xFFFF:
            break
    check(f'touching the A button presses A: the hidden item\'s script runs ({started >> 16})', started >> 16 == script)
    for _ in range(60):
        d.run(5)
        if marker(MODE) == MODE_NEXT:
            break
    check(f'the A button reads NEXT while the message shows (mode {marker(MODE)})', marker(MODE) == MODE_NEXT)
    shot('a_button_found_item')
    result, _ = play_out(d, sym, FRAME_LIMIT, press_a=False)
    check(f'the item\'s script plays out ({result})', result == 'ok')
    shot('after_item')
    hold(*TOUCH, 40)
    nearest_now = nearest_from([i for i in hidden_items if i != item], sx, sz)
    got = (marker(FOUND), s16(marker(NEAREST_X)), s16(marker(NEAREST_Z)))
    check(f'the radar no longer finds it (nearest now {nearest_now}, got {got})',
          got[0] == int(nearest_now is not None) and (nearest_now is None or got[1:] == nearest_now))
    release(200)

    # 5. The running shoes, on a row of plain ground
    mem.write_short(sym['gSovereignTestScripts'], 0)
    warp(d, sym, header, stretch[0], stretch[1], 4)
    d.run(30)
    settle()
    walked = steps_in(64)
    hold(*SHOES, 6)
    release(20)
    check('the running shoes are on', marker(SHOES_ON) == 1)
    shot('shoes_on')
    warp(d, sym, header, stretch[0], stretch[1], 4)
    d.run(30)
    ran = steps_in(64)
    check(f'with them on, the player runs without B ({ran} tiles in 64 frames, walking {walked})', walked > 0 and ran >= 2 * walked - 1)
    hold(*SHOES, 6)
    release(20)
    check('touched again, they\'re off', marker(SHOES_ON) == 0)
    shot('shoes_off')

    # 6. EXIT; from the bag; through a map change
    hold(*EXIT, 8)
    release(0)
    check('EXIT turns it off: the bottom screen is back', wait_on(False))
    shot('exit')
    for key, after in [('X', 40), ('DOWN', 20), ('DOWN', 20), ('A', 120), ('LEFT', 60)]:
        d.press(key, frames=6, after=after)
    shot('bag_key_items')
    d.press('A', frames=6, after=40)
    shot('bag_item_menu')
    d.press('A', frames=6, after=0)
    check('USE in the bag: back on the field with the radar on', wait_on(True, 1200) and 'bag' not in overlays())
    shot('radar_from_bag')
    result, _ = warp(d, sym, header, backs[0][0], backs[0][1], face + 1)
    d.run(120)
    check(f'it stays on through a warp ({result})', marker(ON) == 1 and 'complete_dowsing' in overlays())
    shot('radar_after_warp')
    hold(*EXIT, 8)
    release(0)
    check('EXIT again', wait_on(False))
    shot('field_end')
    print(f'{len(problems)} problems: {problems}' if problems else '0 problems')


if __name__ == '__main__':
    main()
