#!/usr/bin/env python3
"""Check HeartGold's own tile behaviours on Johto's and Kanto's maps in the test build, from the bedroom state
(include/constants/field/complete_tile_behaviors.h): every ladder, and a slide in Viridian Gym; and a boulder pushed
through its hole in Ice Path.

Ladders (src/overlay005/field_control.c) are warps on one of HeartGold's three ladder tiles:

- **up** (HeartGold's ladder north): the player warps onto it facing north and holds up;
- **down** (its ladder south): the same facing south, holding down;
- **hole** (its ladder down): the player warps next to it, facing it, and steps onto it.

The slide (src/overlay005/ov5_021E1154.c): in Viridian Gym the player steps south onto the arrow at the west end of
the row by the entrance (x 1, z 43), slides east and stops on HeartGold's stop tile in the middle (x 5).

The boulder hole (src/complete_map_info.c, CompleteMapInfo_BoulderFell): on Ice Path B1F, with HM04 in the bag and
the Plain Badge, the player talks to the third boulder and says yes to Strength, then walks and pushes it along
BOULDER_PLAN into its hole. Passes when the boulder's flag is set and its fallen copy's (on B2F) cleared
(gSovereignTestWatch).

A case passes when the field, once busy, is next idle on the warp's map (gSovereignTestIdleMapHeaderID) and on its
arrival warp's tile (gSovereignTestPlayerTile; some ladders lead to another floor of the same map), or for the slide on
the stop tile. Results: a line per case in OUT_DIR/results.txt (ok; NOMOVE: nothing started, or never ended; NOWARP:
the test warp there failed; NOTILE: no tile to step onto a hole from; or the map and tile it ended on, with a
screenshot), and a count.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default); --part I/N runs every Nth case from the Ith, to split the run; --kind K[,K...] only those kinds (up, down, hole,
slide, boulder):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_tile_behaviors.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [--part I/N] [--kind K]
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from talk_to_objects import (DECOMP, FRAME_LIMIT, SYMBOLS as TALK_SYMBOLS, Maps, event_maps, header_at,  # noqa: E402
                             header_names, play_out, stand_next_to, u32, var_ids, warp)

LADDERS = {0x0D: 'up', 0x0E: 'down', 0x0F: 'hole'}  # TILE_BEHAVIOR_COMPLETE_LADDER_NORTH, _SOUTH, _DOWN
NORTH, SOUTH = 0, 1  # enum FaceDirection
KEYS = ['UP', 'DOWN', 'LEFT', 'RIGHT']  # by enum FaceDirection
LIMIT = 900  # frames for the climb and the fades
VIRIDIAN_GYM = 'MAP_HEADER_HGSS_VIRIDIAN_GYM'
SLIDE = ('events_hgss_448', VIRIDIAN_GYM, 'slide', 1, 43, (1, 42, SOUTH), VIRIDIAN_GYM, (5, 43))
ICE_PATH_B1F = 'MAP_HEADER_HGSS_ICE_PATH_B1F'
BOULDER = ('events_hgss_223', ICE_PATH_B1F, 'boulder', 18, 12, (18, 13, NORTH), ICE_PATH_B1F, (18, 7))
BOULDER_FLAGS = ('FLAG_HGSS_HIDE_ICE_PATH_BOULDER_3_INIT', 'FLAG_HGSS_HIDE_ICE_PATH_BOULDER_3_FALLEN')
PLAIN = 2  # include/constants/hgss_badges.h
# The shortest way to push the third boulder (18, 12) into its hole (18, 7) from below it (a breadth-first search over
# the map's tiles, the player keeping off the holes): each a step, or a push of the boulder the player faces.
BOULDER_PLAN = ['push UP', 'UP', 'push UP', 'UP', 'LEFT', 'UP', 'push RIGHT', 'RIGHT', 'push RIGHT', 'DOWN', 'DOWN',
                'RIGHT', 'RIGHT', 'UP', 'push UP', 'UP', 'push UP', 'UP', 'push UP', 'UP', 'RIGHT', 'UP', 'push LEFT',
                'LEFT', 'push LEFT']
STEPS = {'UP': (0, -1), 'DOWN': (0, 1), 'LEFT': (-1, 0), 'RIGHT': (1, 0)}


def cases():
    """[(events, header, kind, x, z, where the player stands (x, z, facing, or None), the map it leads to, the tile
    there)]: the ladders, then the slide."""
    maps = Maps(DECOMP)
    out, warps_of = [], {}
    for events, headers_of, cur, grid in event_maps():
        for header, _ in headers_of:
            warps_of[header] = cur.get('warp_events', [])
        if not events.startswith('events_hgss'):
            continue
        matrix = headers_of[0][1]
        warps = [(w['x'], w['z']) for w in cur.get('warp_events', [])]
        taken = {(o['x'], o['z']) for o in cur.get('object_events', [])}
        for w in cur.get('warp_events', []):
            tile = maps.tile(matrix, w['x'], w['z'])
            if tile is None or tile & 0xff not in LADDERS:
                continue
            kind = LADDERS[tile & 0xff]
            if kind == 'hole':
                stand = stand_next_to(maps, matrix, grid, warps, taken, w['x'], w['z'], enter=True)
            else:
                stand = (w['x'], w['z'], NORTH if kind == 'up' else SOUTH)
            out.append((events, header_at(headers_of, grid, w['x'], w['z']), kind, w['x'], w['z'], stand,
                        w['dest_header_id'], w['dest_warp_id']))
    return [case[:-1] + ((warps_of[case[6]][case[7]]['x'], warps_of[case[6]][case[7]]['z']),) for case in out] + [SLIDE, BOULDER]


def main():
    from drive import Driver

    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    part, parts = 0, 1
    if '--part' in sys.argv:
        part, parts = map(int, sys.argv[sys.argv.index('--part') + 1].split('/'))
        args.remove(f'{part}/{parts}')
    kinds = None
    if '--kind' in sys.argv:
        kinds = sys.argv[sys.argv.index('--kind') + 1]
        args.remove(kinds)
        kinds = kinds.split(',')
    rom, state, out = args[:3]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(tuple(set(TALK_SYMBOLS) | {'gSovereignTestPlayerTile', 'gSovereignTestMenu', 'gSovereignTestWatch',
                                                 'gSovereignTestBagItem', 'gCompleteTestHGSSBadges'}))
    names = header_names()
    variables = var_ids()
    items = consts('items.txt')
    d = Driver(rom, state)
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def tile():
        return u16(sym['gSovereignTestPlayerTile']), u16(sym['gSovereignTestPlayerTile'] + 2)

    def busy(frames=6):
        """Whether the field is busy (a warp, a push, a battle): its idle count stays put. A busy map runs the field
        every other frame, so an idle one counts up at least every other frame."""
        before = u32(d, sym['gSovereignTestIdleFrames'])
        d.run(frames)
        return u32(d, sym['gSovereignTestIdleFrames']) == before

    def settle():
        """Let the field come back to idle, playing out what started (a wild Pokémon on the way)."""
        if busy():
            play_out(d, sym, FRAME_LIMIT, press_a=False)

    def step(button):
        """A step: a tap turns the player first, so tap until they are on the next tile."""
        target = (tile()[0] + STEPS[button][0], tile()[1] + STEPS[button][1])
        for _ in range(4):
            d.press(button, frames=2, after=14)
            settle()
            if tile() == target:
                return True
        return False

    def push(button):
        """Push the boulder ahead: tap until the push starts (the field runs it as a task), then wait for it."""
        for _ in range(4):
            d.press(button, frames=2, after=0)
            if any(busy(4) for _ in range(4)):
                settle()
                return True
        return False

    def take(header, x, z, face, dest, arrival):
        """Warp to (x, z) facing face, hold that way, and see where the player is once the field is idle again."""
        for _ in range(3):  # again if a scene on entering the map moved the player (Mt. Moon's)
            arrived, _ = warp(d, sym, names.index(header), x, z, face + 1)
            if arrived != 'ok':
                return f'NOWARP {arrived}'
            if tile() == (x, z):
                break
        else:
            return f'NOWARP on {tile()}'
        d.press(KEYS[face], frames=12, after=0)
        frames, started = 0, False
        while frames < LIMIT:
            frames += 6
            if busy():
                started = True
            elif started:
                here = u16(sym['gSovereignTestIdleMapHeaderID'])
                if (here, tile()) == (names.index(dest), arrival):
                    return 'ok'
                return f'on {names[here] if here < len(names) else here} {tile()}, not {arrival}'
        return 'NOMOVE'

    def boulder():
        mem.write_short(sym['gCompleteTestHGSSBadges'], 1 << PLAIN)
        mem.write_short(sym['gSovereignTestBagItem'], items.index('ITEM_HM04'))
        for i, flag in enumerate(BOULDER_FLAGS):
            mem.write_short(sym['gSovereignTestWatch'] + 4 * i, variables[flag])
        arrived, _ = warp(d, sym, names.index(ICE_PATH_B1F), 18, 13, NORTH + 1)
        if arrived != 'ok':
            return f'NOWARP {arrived}'
        result, _ = talk_and_answer(d, sym, [True])  # Strength, yes
        if result != 'ok':
            return f'Strength: {result}'
        for n, move in enumerate(BOULDER_PLAN):
            if not (push(move.split()[1]) if move.startswith('push') else step(move)):
                return f'move {n} ({move}) failed on {tile()}'
        settle()
        hidden, fallen_hidden = (u16(sym['gSovereignTestWatch'] + 4 * i + 2) for i in range(2))
        return 'ok' if (hidden, fallen_hidden) == (1, 0) else f'flags {hidden} {fallen_hidden}, not 1 0'

    todo = [case for case in cases() if kinds is None or case[2] in kinds][part::parts]
    results = []
    with open(os.path.join(out, 'results.txt'), 'w') as log:
        for i, (events, header, kind, x, z, (sx, sz, face), dest, arrival) in enumerate(todo):
            if face is None:
                result = 'NOTILE'
            else:
                d.load_state(state)
                d.run(30)
                mem.write_byte(sym['gSovereignTestGodMode'], 1)
                result = boulder() if kind == 'boulder' else take(header, sx, sz, face, dest, arrival)
                if result != 'ok':
                    d.screenshot().save(os.path.join(out, f'{events}_{x}_{z}.png'))
            results.append(result)
            line = f'{i} {events} {kind} ({x}, {z}) to {dest}: {result}'
            print(line, flush=True)
            log.write(line + '\n')
            log.flush()
    ok = results.count('ok')
    print(f'{ok} of {len(results)} ok')
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
