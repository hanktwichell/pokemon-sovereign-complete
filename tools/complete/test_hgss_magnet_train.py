#!/usr/bin/env python3
"""Check the Magnet Train between Goldenrod City and Saffron City in the test build (HeartGold's ScrCmd_722, translated
as a fade and a warp; HeartGold's ride scene isn't ported), from the bedroom state:

1. **Goldenrod to Saffron:** past Goldenrod's ticket gate (VAR_HGSS_UNK_411E 1, as the gate leaves it with the Pass),
   the player comes up onto the platform, whose scene walks them aboard; the train leaves, and they arrive in Saffron's
   station, whose own scene walks them off the train and down through the ticket gate.
2. **Saffron to Goldenrod:** the same from Saffron's platform (VAR_HGSS_UNK_411F 1).

A part passes when the field is idle again on the other city's station's ground floor. Results: one line per part, and a screenshot
of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_magnet_train.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, play_out, start_warp, var_ids  # noqa: E402

SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gSovereignTestVar'})
LIMIT = 6000
UP = 1  # the test warp's facing (enum FaceDirection + 1)
# (name, the platform, the tile the stairs bring the player to, the var the gate sets, where they end up)
PARTS = [
    ('Goldenrod to Saffron', 'MAP_HEADER_HGSS_GOLDENROD_MAGNET_TRAIN_STATION_2F_EMPTY', (10, 14),
     'VAR_HGSS_UNK_411E', 'MAP_HEADER_HGSS_SAFFRON_MAGNET_TRAIN_STATION_1F'),
    ('Saffron to Goldenrod', 'MAP_HEADER_HGSS_SAFFRON_MAGNET_TRAIN_STATION_2F_EMPTY', (21, 14),
     'VAR_HGSS_UNK_411F', 'MAP_HEADER_HGSS_GOLDENROD_MAGNET_TRAIN_STATION_1F'),
]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    results = []
    for name, platform, (x, z), var, station in PARTS:
        d.load_state(state)
        d.run(30)
        mem.write_short(sym['gSovereignTestVar'], variables[var])
        mem.write_short(sym['gSovereignTestVar'] + 2, 1)
        mem.write_short(sym['gSovereignTestScripts'], 0)
        start_warp(d, sym, names.index(platform), x, z, UP)
        # the warp, the platform's scene (after a moment idle on the platform), the station's: each played out in turn
        result, frames = play_out(d, sym, LIMIT, None, press_a=False, wait_for_script=True)
        while result == 'ok' and frames < LIMIT:
            result, more = play_out(d, sym, LIMIT - frames, None, press_a=False)
            frames += more
        result = 'ok' if result == 'NOSCRIPT' else result  # nothing more started
        here = u16(sym['gSovereignTestIdleMapHeaderID'])
        if result != 'ok':
            problem = f'{result} after {frames} frames, on {names[here] if here < len(names) else here}'
        elif here != names.index(station):
            problem = f'ended on {names[here] if here < len(names) else here}, not {station}'
        else:
            problem = ''
        d.screenshot().save(os.path.join(out, f'{name.replace(" ", "_")}.png'))
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(results)} parts ok')
    sys.exit(0 if all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
