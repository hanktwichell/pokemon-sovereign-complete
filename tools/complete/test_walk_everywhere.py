#!/usr/bin/env python3
"""Walk every map, onto every tile a player can reach on foot, as a player exploring would (the owner's call, Nov 6,
2026: the story test walks only the story's way).

For each map (Johto's and Kanto's, Sinnoh's, or both), from the bedroom state: the test warp to an open tile
(test_map_warp.py's walkable_tile), then a tour of every tile reachable from there on foot (the map's collision and
tile behaviors, check_object_tiles.py's walkable; ledges one way), around the map's warps, its step-on triggers, its
people where the map puts them, water, ice, arrows, deep mud and Rock Climb walls. The tour walks to the nearest tile
not yet walked on, a step at a time (the story test's route, flat), until every one is walked or the map's step budget
is spent. Along the way it notes, for the owner's "Possible issues" tab:
- **refused steps:** a step the game didn't take onto a tile the map data says is open (an invisible wall, a person who
  wandered there, or a bridge's height; a tile with two heights is marked so);
- **what started:** a script, a battle (god mode: one hit wins) or a scene that started on the way, played out, with
  a screenshot;
- **a map change:** the walk ended up on another map (and goes back);
- **a hang:** the frame counter stopped.
A screenshot of both screens every SHOT_EVERY steps goes to OUT_DIR/MAP/ for review.

From the repo root, with a test build and its bedroom state (tools/test/new_game.sh):
    TEST_BUILD=build_test4 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_walk_everywhere.py \\
        decomp/build_test4/pokeplatinum.us.nds STATE OUT_DIR [--region hgss|sinnoh|all] [--part I/N] [MAP_HEADER ...]
Each map's result is a line in OUT_DIR/results.txt and an entry in OUT_DIR/results.json.
"""
import collections
import json
import os
import struct
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'complete'))
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from battle_all_trainers import HANG_FRAMES, VBLANK_COUNTER  # noqa: E402
from check_object_tiles import DIRS, JUMPS, Maps, walkable  # noqa: E402
from talk_to_objects import (FRAME_LIMIT, HOUR, SYMBOLS, WATER, event_maps, header_names, play_out, symbols,  # noqa: E402
                             u32, warp)
from test_hgss_opening import (DEEP_MUD, ICE, KEYS, MAGMA, ROCK_CLIMB, SLIDES, WARP_TILES, Heights,  # noqa: E402
                               route)
from test_map_warp import walkable_tile  # noqa: E402

SHOT_EVERY = 60  # steps between screenshots
STEP_BUDGET = 4  # steps a map may take, per tile to walk
MAX_STEPS = 6000  # and at most this many
AVOID_BEHAVIORS = WATER | {ICE, MAGMA} | ROCK_CLIMB | DEEP_MUD | set(SLIDES) | WARP_TILES


def reachable(maps, matrix, start, blocked):
    """The tiles a player on foot reaches from start: open floor (ledges one way), around blocked."""
    seen, queue = {start}, collections.deque([start])
    while queue:
        p = queue.popleft()
        for d in DIRS:
            n = (p[0] + d[0], p[1] + d[1])
            t = maps.tile(matrix, *n)
            if t is not None and (t & 0xff) in JUMPS:
                jd, k = JUMPS[t & 0xff]
                if jd != d:
                    continue
                n = (n[0] + jd[0] * k, n[1] + jd[1] * k)
                t = maps.tile(matrix, *n)
            if t is None or n in seen or n in blocked or not walkable(t) or (t & 0xff) in AVOID_BEHAVIORS:
                continue
            seen.add(n)
            queue.append(n)
    return seen


def nearest(maps, matrix, start, todo, blocked, failed):
    """The nearest tile still to walk from start, by steps on foot (a flat search), or None."""
    seen, queue = {start}, collections.deque([start])
    while queue:
        p = queue.popleft()
        if p in todo and p != start:
            return p
        for d in DIRS:
            if (p, d) in failed:
                continue
            n = (p[0] + d[0], p[1] + d[1])
            t = maps.tile(matrix, *n)
            if t is not None and (t & 0xff) in JUMPS:
                jd, k = JUMPS[t & 0xff]
                if jd != d:
                    continue
                n = (n[0] + jd[0] * k, n[1] + jd[1] * k)
                t = maps.tile(matrix, *n)
            if t is None or n in seen or n in blocked or not walkable(t) or (t & 0xff) in AVOID_BEHAVIORS:
                continue
            seen.add(n)
            queue.append(n)
    return None


def main():
    from drive import Driver

    args = sys.argv[1:]
    option = lambda name, default: args[args.index(name) + 1] if name in args else default  # noqa: E731
    rom, state, out = args[:3]
    region = option('--region', 'hgss')
    part, parts = (int(v) for v in option('--part', '0/1').split('/'))
    only = [a for a in args[3:] if a.startswith('MAP_HEADER_')]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS)
    names = header_names()
    maps = Maps(os.path.join(ROOT, 'decomp'))
    heights = Heights(maps)

    plans = []
    for _, headers_of, events, _ in event_maps():
        for header, matrix in headers_of:
            hgss = header.startswith('MAP_HEADER_HGSS_')
            if only and header not in only or not only and (region == 'hgss' and not hgss or region == 'sinnoh' and hgss):
                continue
            plans.append((header, matrix, events))
    plans.sort()
    plans = [p for i, p in enumerate(plans) if i % parts == part]

    d = Driver(rom, state)
    mem = d.emu.memory
    results = {}
    results_path = os.path.join(out, f'results_{part}.json' if parts > 1 else 'results.json')
    lines = open(os.path.join(out, f'results_{part}.txt' if parts > 1 else 'results.txt'), 'w')

    def say(line):
        print(line, flush=True)
        print(line, file=lines, flush=True)

    def here():
        return u32(d, sym['gSovereignTestIdleMapHeaderID'])

    def shot(folder, name):
        os.makedirs(folder, exist_ok=True)
        d.screenshot().convert('RGB').save(os.path.join(folder, name + '.jpg'), quality=80)

    for header, matrix, events in plans:
        folder = os.path.join(out, header[len('MAP_HEADER_'):].lower())
        entry = {'refused': [], 'started': [], 'left': [], 'hang': None}
        try:
            start = walkable_tile(header)
        except SystemExit as e:
            entry['skipped'] = str(e)
            results[header] = entry
            say(f'{header}: SKIPPED ({e})')
            continue
        if maps.tile(matrix, *start) is None:
            entry['skipped'] = 'no tile data'
            results[header] = entry
            say(f'{header}: SKIPPED (no tile data at {start})')
            continue
        people = {(o['x'], o['z']) for o in events.get('object_events', [])}
        warps = {(w['x'], w['z']) for w in events.get('warp_events', [])}
        triggers = {(c['x'] + i, c['z'] + j) for c in events.get('coord_events', [])
                    for i in range(c['width']) for j in range(c['length'])}
        blocked = people | warps | triggers
        # Where a walk starts: beside each of the map's warps (where a player comes in), then the open tile; each
        # area reachable from one of them is walked from there
        starts = []
        for wx, wz in sorted(warps):
            for dx, dz in DIRS:
                t = maps.tile(matrix, wx + dx, wz + dz)
                if t is not None and walkable(t) and (t & 0xff) not in AVOID_BEHAVIORS \
                        and (wx + dx, wz + dz) not in blocked:
                    starts.append((wx + dx, wz + dz))
        starts.append(start)
        areas, todo = [], set()
        for first in starts:
            if first in todo or first in blocked and first != start:
                continue
            area = reachable(maps, matrix, first, blocked - {first})
            todo |= area
            areas.append((first, area))
        entry['reachable'], entry['areas'] = len(todo), len(areas)

        d.load_state(state)
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        mem.write_byte(sym['gSovereignTestClock'], HOUR + 1)
        d.run(30)
        walked, failed, skipped = set(), set(), set()
        steps, budget = 0, min(MAX_STEPS, STEP_BUDGET * len(todo) + 50 * len(areas))
        vblank, stalled = u32(d, sym['gSystem'] + VBLANK_COUNTER), 0
        header_id = names.index(header)
        for start, area in areas:
            result, frames = warp(d, sym, header_id, start[0], start[1], 0)
            if result == 'ok' and d.pos() != start and tuple(d.pos()) in area:
                start = tuple(d.pos())  # the map's own scene moved the player on arrival, within the area: walk from there
            if result != 'ok' or d.pos() != start:
                entry.setdefault('unreached_areas', []).append({'start': list(start), 'size': len(area),
                                                               'warp': f'{result} at {list(d.pos())}'})
                continue
            header_id = here()
            walked.add(start)
            shot(folder, f'start_{start[0]}_{start[1]}')
            while steps < budget:
                pos = d.pos()
                goal = nearest(maps, matrix, pos, area - walked - skipped, blocked, failed)
                if goal is None:
                    break
                keys = route(maps, matrix, pos, goal, blocked - {goal}, failed)
                if not keys:
                    skipped.add(goal)
                    continue
                for key in keys:
                    step = next(dd for dd, k in KEYS.items() if k == key)
                    pos = d.pos()
                    ahead = (pos[0] + step[0], pos[1] + step[1])
                    idle = u32(d, sym['gSovereignTestIdleFrames'])
                    d.press(key, frames=8, after=16)
                    steps += 1
                    if d.pos() == pos:
                        d.run(16)
                    if d.pos() == pos:  # once more: a press that only turned the player
                        d.press(key, frames=8, after=16)
                        steps += 1
                    now = u32(d, sym['gSystem'] + VBLANK_COUNTER)
                    stalled = stalled + 1 if now == vblank else 0
                    vblank = now
                    if stalled >= 3:
                        entry['hang'] = f'at {pos}, stepping {key}'
                        shot(folder, f'hang_{steps:05d}')
                        break
                    started = u32(d, sym['gSovereignTestIdleFrames']) - idle < 8  # the field isn't free
                    if started:  # something started: played out, then the way found again from where the player is
                        shot(folder, f'started_{steps:05d}_{pos[0]}_{pos[1]}')
                        result, frames = play_out(d, sym, FRAME_LIMIT, None, press_a=False)
                        entry['started'].append({'at': list(pos), 'key': key, 'result': result})
                        if result == 'HANG':
                            entry['hang'] = f'after what started at {pos}'
                            break
                    if here() != header_id:
                        entry['left'].append({'at': list(pos), 'key': key, 'to': names[here()] if here() < len(names)
                                              else hex(here())})
                        shot(folder, f'left_{steps:05d}')
                        warp(d, sym, header_id, pos[0], pos[1], 0)
                        failed.add((pos, step))
                        break
                    if started:
                        walked.add(d.pos())
                        break
                    if d.pos() == pos:
                        failed.add((pos, step))
                        t = maps.tile(matrix, *ahead)
                        bridge = len(heights.at(matrix, *ahead)) > 1 or len(heights.at(matrix, *pos)) > 1
                        entry['refused'].append({'at': list(pos), 'key': key, 'to': list(ahead),
                                                 'behavior': (t or 0) & 0xff, 'bridge': bridge})
                        if len(entry['refused']) <= 12:
                            shot(folder, f'refused_{steps:05d}_{ahead[0]}_{ahead[1]}')
                        break
                    walked.add(d.pos())
                    if steps % SHOT_EVERY == 0:
                        shot(folder, f'step_{steps:05d}')
                if entry['hang']:
                    break
        entry.update(walked=len(walked & todo), steps=steps, skipped_tiles=len(skipped))
        results[header] = entry
        real = [r for r in entry['refused'] if not r['bridge']]
        say(f'{header}: walked {entry["walked"]} of {entry["reachable"]} tiles in {steps} steps; '
            f'{len(real)} refused steps ({len(entry["refused"]) - len(real)} on bridges), {len(entry["started"])} '
            f'things started, {len(entry["left"])} map changes' + (f'; HANG {entry["hang"]}' if entry['hang'] else ''))
        json.dump(results, open(results_path, 'w'), indent=1)
    say(f'{len(results)} maps')


if __name__ == '__main__':
    main()
