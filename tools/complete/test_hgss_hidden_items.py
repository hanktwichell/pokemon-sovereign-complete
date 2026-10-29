#!/usr/bin/env python3
"""Pick up Johto's and Kanto's hidden items in the test build (step 4; docs/SacredGold.md).

For each hidden item on a Johto or Kanto map (a bg event with a hidden item's script, 8300 on:
tools/complete/import_hgss_field_items.py), this comes into the map as tools/test/talk_to_objects.py does, stands on
a tile next to the item facing it and presses A. Then it checks what the game did:
- ok: the item's own script ran to its end, and a second A press from the same tile starts nothing (its flag, the one
  the engine checks for that event, is set: Script_GetHiddenItemFlag);
- NOSCRIPT: nothing ran; OTHER and a script: another one ran instead; AGAIN: the item's script ran a second time;
- NOTILE: no tile next to it the player can reach; HANG, STUCK, HEAP and NOWARP as in talk_to_objects.py.

From the repo root, with the test build and a bedroom state (tools/test/new_game.sh):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_hidden_items.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [--part I/N] [EVENTS ...]
Each hidden item is a line in OUT_DIR/results.txt.
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from check_object_tiles import Maps  # noqa: E402
from talk_to_objects import (DECOMP, FRAME_LIMIT, SYMBOLS, arrive, event_maps, header_at, header_names,  # noqa: E402
                             parse_args, play_out, stand_next_to, symbols, u32, var_ids, warp, way_in_to)

HIDDEN_ITEM = 2  # BG_EVENT_TYPE_HIDDEN_ITEM
SCRIPTS = range(8300, 8800)  # Johto's and Kanto's (import_hgss_field_items.hidden_item_script)


def cases():
    """[(events, script, header ID, way in, x, z, facing or None)] for each Johto or Kanto hidden item."""
    maps = Maps(DECOMP)
    ids = header_names()
    out = []
    for events, headers_of, cur, grid in event_maps():
        if not events.startswith('events_hgss_'):
            continue
        matrix = headers_of[0][1]
        warps = [(w['x'], w['z']) for w in cur.get('warp_events', [])]
        taken = {(o['x'], o['z']) for o in cur.get('object_events', [])}
        for bg in cur.get('bg_events', []):
            if bg['type'] != HIDDEN_ITEM or bg['script'] not in SCRIPTS:
                continue
            x, z = bg['x'], bg['z']
            header = header_at(headers_of, grid, x, z)
            stand = stand_next_to(maps, matrix, grid, warps, taken, x, z)
            out.append((events, bg['script'], ids.index(header),
                        way_in_to(maps, matrix, grid, cur, header, taken, stand[:2])) + stand)
    return out


def pick_up(d, sym, header, script, x, z, face):
    """Press A facing the item, then again from the same tile. Returns (result, frames)."""
    d.emu.memory.write_short(sym['gSovereignTestScripts'], 0)
    result, frames = play_out(d, sym, FRAME_LIMIT)
    started = u32(d, sym['gSovereignTestScripts'])
    if result != 'ok':
        return result, frames
    if started >> 16 != script:
        return f'OTHER {started >> 16}', frames
    result, more = warp(d, sym, header, x, z, face + 1)
    if result != 'ok':
        return 'NOWARP ' + result, frames + more
    d.emu.memory.write_short(sym['gSovereignTestScripts'], 0)
    result, more = play_out(d, sym, FRAME_LIMIT)
    started = u32(d, sym['gSovereignTestScripts'])
    if result == 'NOSCRIPT' or not started & 0xffff:
        return 'ok', frames + more
    return ('AGAIN' if started >> 16 == script else f'OTHER {started >> 16} the second time'), frames + more


def main():
    from drive import Driver

    rom, state, out, only, part, parts = parse_args(sys.argv[1:])
    sym = symbols(SYMBOLS)
    variables = var_ids()
    chosen = [(i, c) for i, c in enumerate(cases()) if (not only or c[0] in only) and i % parts == part]
    d = Driver(rom, state)
    d.added, d.armed = [], False

    bad = 0
    with open(os.path.join(out, 'results.txt'), 'w') as f:
        for index, (events, script, header, way_in, x, z, face) in chosen:
            if face is None:
                result, frames = 'NOTILE', 0
            else:
                result, frames = arrive(d, sym, state, variables, events, header, way_in, x, z, face)
                if result == 'ok':
                    result, frames = pick_up(d, sym, header, script, x, z, face)
            if result != 'ok':
                bad += 1
                if face is not None:
                    d.screenshot().save(os.path.join(out, f'{index:03d}_{events}_{script}.png'))
            line = f'{index} {events} {script} ({x}, {z}): {result} {frames}'
            print(line, file=f, flush=True)
            print(line, flush=True)
        print(f'{len(chosen) - bad} of {len(chosen)} ok', file=f)
    print(f'{len(chosen) - bad} of {len(chosen)} ok')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
