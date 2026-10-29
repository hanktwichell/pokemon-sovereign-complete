#!/usr/bin/env python3
"""Warp into every Johto and Kanto map (MAP_HEADER_HGSS_*) and check that the field runs there (test build).

For each map, from a save state in the bedroom, this warps (gSovereignTestWarpTarget, SELECT+L+R) to the free floor
tile that tools/complete/test_map_warp.py picks (beside the map's first person, else its first warp), then waits until
the field is idle on that map (gSovereignTestIdleFrames counts up and gSovereignTestIdleMapHeaderID is the map). Then:
- ok: idle, with the heaps' block lists whole (tools/test/heap_check.py);
- HEAP: idle, but a heap's block lists are broken (a bad free during the load);
- FAIL: not idle within the time limit (a crash, a hang, or a scene on entry);
- SKIP: no free floor tile to warp to (maps HeartGold never shows, such as MAP_HEADER_HGSS_NOTHING).
Each map's last screen is saved to OUT_DIR as NNN_<map>_<result>.png.

Maps run in HeartGold's order; --shard K/N runs every Nth map from the Kth, so N processes can share the list.

Needs the test build (tools/test/build_test_rom.sh) and a bedroom save state made with it (tools/test/new_game.sh).
From the repo root:
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/visit_hgss_maps.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [--shard K/N] [NAME ...]
"""
import os
import re
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
from heap_check import heap_info_address, heap_problems  # noqa: E402
from test_map_warp import ROOT, header_id, walkable_tile  # noqa: E402

LIMIT = 2400  # frames to wait for the field to be idle


def hgss_headers():
    names = [line.strip() for line in open(os.path.join(ROOT, 'decomp/generated/map_headers.txt'))
             if line.strip().startswith('MAP_HEADER_HGSS_')]
    return [name[len('MAP_HEADER_'):] for name in names]


def symbol(name):
    xmap = open(os.path.join(ROOT, 'decomp/build_test/main.nef.xMAP'), encoding='utf-8', errors='replace').read()
    return int(re.search(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.bss\s+' + name + r'\b', xmap, re.M).group(1), 16)


def main():
    from drive import Driver

    args = sys.argv[1:]
    shard = (0, 1)
    if '--shard' in args:
        k, n = args[args.index('--shard') + 1].split('/')
        shard = (int(k), int(n))
        del args[args.index('--shard'):args.index('--shard') + 2]
    rom, state, out = args[:3]
    only = {a.upper() for a in args[3:]}
    os.makedirs(out, exist_ok=True)
    os.chdir(ROOT)
    target, idle_addr, map_addr = (symbol(s) for s in ('gSovereignTestWarpTarget', 'gSovereignTestIdleFrames',
                                                       'gSovereignTestIdleMapHeaderID'))
    heaps = heap_info_address()
    d = Driver(rom, state)

    def u32(addr):
        return struct.unpack('<I', bytes(d.emu.memory.unsigned[addr:addr + 4]))[0]

    counts, failures = {}, []
    for i, name in enumerate(hgss_headers()):
        if i % shard[1] != shard[0] or (only and name[len('HGSS_'):] not in only and name not in only):
            continue
        header = header_id(name)
        try:
            x, z = walkable_tile(f'MAP_HEADER_{name}')
        except SystemExit:
            result, frames, problems = 'SKIP', 0, []
        else:
            d.load_state(state)
            d.run(30)
            for offset, value in ((0, header), (2, x), (4, z), (6, 2)):  # facing down
                d.emu.memory.write_short(target + offset, value)
            d.press('SELECT+L+R', frames=8, after=0)
            frames, idle = 0, 0
            while frames < LIMIT and idle < 2:
                before = u32(idle_addr)
                d.run(30)
                frames += 30
                idle = idle + 1 if u32(idle_addr) > before and u32(map_addr) == header else 0
                if idle == 0 and frames % 120 == 0:
                    d.press('B', frames=4, after=4)
            problems = heap_problems(d.emu.memory, heaps) if idle >= 2 else []
            result = 'FAIL' if idle < 2 else 'HEAP' if problems else 'ok'
            d.screenshot().save(os.path.join(out, f'{i:03d}_{name}_{result}.png'))
        counts[result] = counts.get(result, 0) + 1
        print(i, name, result, frames, *([f'on {u32(map_addr)}'] if result == 'FAIL' else []),
              *(problems if result == 'HEAP' else []), flush=True)
        if result in ('FAIL', 'HEAP'):
            failures.append(f'{i} {name}')
    print('results:', ', '.join(f'{v} {k}' for k, v in sorted(counts.items())))
    print('failures:', '; '.join(failures) or 'none')
    sys.exit(1 if failures else 0)


if __name__ == '__main__':
    main()
