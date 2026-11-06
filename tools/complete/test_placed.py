#!/usr/bin/env python3
"""Test the Totem trials and legendaries placed on other maps than Sovereign put them (data/complete/placed.yaml,
src/complete_placed.c), each in the test build from a bedroom state:

1. **Not yet:** without what its gates ask for, nobody stands on its spot (A there runs no script).
2. **Its encounter:** with it, set on the test warp (badges: gCompleteTestHGSSBadges; vars and flags:
   gSovereignTestVar; an item: gSovereignTestBagItem; Pokémon in the party: gSovereignTestPartyAdd, the party cut to
   its lead first; others caught: gSovereignTestCaughtAllBut, everyone but it; the night: gSovereignTestClock), the
   player arrives beside it, facing it, and A runs CommonScript_CompletePlaced, which plays Sovereign's trial or
   legendary battle out (the test build's god mode: one hit wins; a legendary is knocked out, not caught). A Totem's
   trial is done (its FLAG_SOVEREIGN_TOTEM_TRIAL_* flag), and it's gone: A on its spot runs nothing.

The moved objects' old spots in Sinnoh are left to tools/test/talk_to_objects.py (they aren't there to talk to).

From the repo root, with the test build and a bedroom state from it (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_placed.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [NAME ...]
"""
import os
import re
import struct
import sys

import yaml

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'complete'))
from check_object_tiles import Maps, walkable  # noqa: E402
from find_spot import header_info  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, header_names, play_out, symbols, var_ids, warp  # noqa: E402
from test_hgss_togepi import SAVE_PAGES, SAVE_SECTOR, save_entry_index  # noqa: E402

LIMIT = 40000
SCRIPT_PLACED = 2074  # CommonScript_CompletePlaced (SCRIPT_ID(COMMON_SCRIPTS, 74))
# the tile beside the spot to stand on, and the way to face it (enum FaceDirection: up, down, left, right), which the
# test warp turns the player to (a scene on the way in may turn them again: a press that way turns them back)
SIDES = (((0, 1), 0), ((0, -1), 1), ((1, 0), 2), ((-1, 0), 3))
KEYS = ('UP', 'DOWN', 'LEFT', 'RIGHT')
RAM, RAM_SIZE = 0x02000000, 0x400000


def badge_mask(gates):
    names = open(os.path.join(DECOMP, 'include', 'constants', 'hgss_badges.h'), encoding='utf-8').read()
    mask = 0
    for gate in gates or []:
        if 'hgss_badge' in gate:
            n = int(names.split(gate['hgss_badge'])[1].split()[0])
            mask |= (1 << (n + 1)) - 1  # it, and the ones before it
    return mask


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    only = sys.argv[4:]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gSovereignTestMenu', 'gCompleteTestHGSSBadges',
                             'gSovereignTestPartyAdd', 'gSovereignTestCaughtAllBut', 'gSovereignTestPartyKeep'))
    names = header_names()
    variables = var_ids()
    maps = Maps(DECOMP)
    plan = yaml.safe_load(open(os.path.join(ROOT, 'data', 'complete', 'placed.yaml'), encoding='utf-8'))
    d = Driver(rom, state)
    mem = d.emu.memory

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def flag(name):
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS') * 16 + 8
        flags = base + 20 + u32(at) + (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        return bool(mem.unsigned[flags + n // 8] & (1 << (n % 8)))

    species_ids = [line.strip() for line in open(os.path.join(DECOMP, 'generated', 'species.txt')) if line.strip()]
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()

    def set_gates(p):
        """What a legendary's gates ask for, set for the next test warp."""
        slot, adds = 3, 0  # gSovereignTestVar's first three slots are the warp's own
        for gate in p.get('gates') or []:
            (key, arg), = gate.items()
            if key == 'var':
                mem.write_short(sym['gSovereignTestVar'] + 4 * slot, variables[arg[0]])
                mem.write_short(sym['gSovereignTestVar'] + 4 * slot + 2, arg[1])
                slot += 1
            elif key == 'flag':
                mem.write_short(sym['gSovereignTestVar'] + 4 * slot, variables[arg])
                mem.write_short(sym['gSovereignTestVar'] + 4 * slot + 2, 1)
                slot += 1
            elif key == 'item':
                mem.write_short(sym['gSovereignTestBagItem'], items.index(arg))
            elif key == 'party':
                mem.write_byte(sym['gSovereignTestPartyKeep'], 1)
                mem.write_short(sym['gSovereignTestPartyAdd'] + 4 * adds, species_ids.index(arg))
                mem.write_byte(sym['gSovereignTestPartyAdd'] + 4 * adds + 3, 50)
                adds += 1
            elif key == 'caught':
                mem.write_short(sym['gSovereignTestCaughtAllBut'], species_ids.index(p['legendary']))
            elif key == 'night':  # read with the game's clock, every few frames (rtc.c)
                mem.write_byte(sym['gSovereignTestClock'], 22 + 1)
                d.run(60)

    def arrive(header, x, z, badges, gates=None):
        """Beside (x, z), facing it: the side's tile and the result."""
        _, matrix = header_info(header)
        for (dx, dz), face in SIDES:
            if walkable(maps.tile(matrix, x + dx, z + dz)):
                d.load_state(state)
                d.run(30)
                mem.write_byte(sym['gSovereignTestGodMode'], 1)
                mem.write_short(sym['gCompleteTestHGSSBadges'], badges)
                if gates:
                    set_gates(gates)
                # the warp's facing is enum FaceDirection + 1
                result, _ = warp(d, sym, names.index(header), x + dx, z + dz, face + 1)
                if result == 'ok' and d.pos() != (x + dx, z + dz):  # a scene on the way in moved the player
                    result, _ = warp(d, sym, names.index(header), x + dx, z + dz, face + 1)
                if result == 'ok' and facing() not in (face, None):  # a press turns them, not a step: they don't
                    d.press(KEYS[face], frames=4, after=20)  # face that way
                if os.environ.get('DEBUG'):
                    print(f'  arrived on {d.pos()} for ({x + dx}, {z + dz}): {result}', flush=True)
                return result
        return 'no free side'

    def facing():
        """The way the player faces (src/map_object.c's MapObject: the player's localID 0xFF, its tile, its
        facingDir), or None if their map object isn't found."""
        ram, pos = bytes(mem.unsigned[RAM:RAM + RAM_SIZE]), d.pos()
        for found in re.finditer(rb'\xff\x00\x00\x00', ram):
            o = found.start() - 8  # the localID's offset
            if o >= 0 and o % 4 == 0 and struct.unpack_from('<I', ram, o)[0] \
                    and struct.unpack_from('<3i', ram, o + 100)[::2] == pos:
                return struct.unpack_from('<I', ram, o + 40)[0]
        return None

    def talk():
        mem.write_short(sym['gSovereignTestScripts'], 0)
        result, frames = talk_and_answer(d, sym, [], LIMIT)
        started = u32(sym['gSovereignTestScripts'])
        return result, frames, started >> 16 if started & 0xffff else None

    results = []
    for p in plan.get('placed') or []:
        name = p.get('totem') or p.get('legendary')
        if only and not any(o in name for o in only):
            continue
        header, (x, z) = p['map'], p['at']
        badges = badge_mask(p.get('gates'))
        problem = ''
        # 1. not out before its badges or gates (when it waits on some)
        if badges or p.get('gates'):
            arrived = arrive(header, x, z, 0)
            if arrived != 'ok':
                problem = f'warp {arrived}'
            else:
                result, frames, script = talk()
                if script is not None:
                    problem = f'out before its badges (script {script} ran)'
        # 2. its encounter, then gone
        if not problem:
            arrived = arrive(header, x, z, badges, p)
            if arrived != 'ok':
                problem = f'warp {arrived}'
            else:
                d.screenshot().save(os.path.join(out, f'{name}_before.png'))  # it standing there, facing the player
                result, frames, script = talk()
                if script != SCRIPT_PLACED:
                    problem = f'A ran {script}, not CommonScript_CompletePlaced'
                elif result != 'ok':
                    problem = f'the encounter: {result} after {frames} frames'
                elif 'totem' in p and not flag('FLAG_SOVEREIGN_TOTEM_TRIAL_' + name[len('TOTEM_TRIAL_'):]):
                    problem = 'the trial isn\'t done after the battle'
                else:
                    d.screenshot().save(os.path.join(out, f'{name}_after.png'))
                    result, frames, script = talk()
                    if script is not None and 'totem' in p:
                        problem = f'still there after its trial (script {script} ran)'
        d.screenshot().save(os.path.join(out, f'{name}.png'))
        results.append(f'{name} on {header} ({x}, {z}): {problem or "ok"}')
        print(results[-1], flush=True)
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(results)} ok')
    sys.exit(0 if all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
