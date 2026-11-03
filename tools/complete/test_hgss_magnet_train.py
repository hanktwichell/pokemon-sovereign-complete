#!/usr/bin/env python3
"""Check HeartGold's Magnet Train ride (src/applications/complete_magnet_train/magnet_train.c) in the test build, from
the bedroom state:

1. **Goldenrod City to Saffron City, by day:** with the train boarding (VAR_HGSS_UNK_411E 1, as Goldenrod's attendant
   sets it), the player arrives on Goldenrod's empty platform: its scene walks them aboard, the ride plays its three
   cuts with HeartGold's day models for the player (the first cut's model, member 0), and the player gets off at
   Saffron City's station, where the attendant welcomes them and they go down to its 1F, free there.
2. **Saffron City to Goldenrod City, at night:** the same the other way at 10 p.m. (VAR_HGSS_UNK_411F 1,
   gSovereignTestClock), with the night models (member 36).

Each ride must play all three cuts to the end, for at least MIN_FRAMES frames (HeartGold's cuts are 91, 301 and 205
frames long), and leave the player free in the other station. Screenshots of each as it plays go to OUT_DIR (the
ride's frame in each name). Results: a line per part.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_magnet_train.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import SYMBOLS, header_names, start_warp, symbols, var_ids  # noqa: E402

NORTH = 1  # the test warp's facing: enum FaceDirection + 1
MIN_FRAMES = 597
SHOTS = (45, 250, 500, 580)  # the ride's frames to screenshot: each cut, and the last as the train pulls in
WAIT = 2000  # frames for the ride to begin and end
LIMIT = 6000
# (part, the empty platform, the tile the player arrives on, the var set, the hour, the first cut's model, the station
# the ride ends at: its 2F platform, where the attendant's welcome walks the player down to 1F, as in HeartGold)
PARTS = [('Goldenrod City to Saffron City, by day', 'MAP_HEADER_HGSS_GOLDENROD_MAGNET_TRAIN_STATION_2F_EMPTY', (10, 14),
          'VAR_HGSS_UNK_411E', 12, 0, 'MAP_HEADER_HGSS_SAFFRON_MAGNET_TRAIN_STATION_'),
         ('Saffron City to Goldenrod City, at night', 'MAP_HEADER_HGSS_SAFFRON_MAGNET_TRAIN_STATION_2F_EMPTY', (21, 14),
          'VAR_HGSS_UNK_411F', 22, 36, 'MAP_HEADER_HGSS_GOLDENROD_MAGNET_TRAIN_STATION_')]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestMagnetTrain',))
    variables = var_ids()
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory

    def train():
        """(cuts played, the first cut's model, the ride's frames, whether it ended, its first light's color, its diffuse
        color, the main screen's layers, its brightness)"""
        at = sym['gCompleteTestMagnetTrain']
        return struct.unpack('<8H', bytes(mem.unsigned[at:at + 16]))

    def u32(name):
        return struct.unpack('<I', bytes(mem.unsigned[sym[name]:sym[name] + 4]))[0]

    def off_at(station):
        """Whether the player stands free in the station (a map whose name starts so) within LIMIT frames: the field
        idle there for a while, with A through the attendant's welcome as the player arrives."""
        frames, calm, busy = 0, 0, 0
        while frames < LIMIT:
            before = u32('gSovereignTestIdleFrames')
            d.run(10)
            frames += 10
            if u32('gSovereignTestIdleFrames') - before >= 3:
                busy = 0
                idle = u32('gSovereignTestIdleMapHeaderID') & 0xFFFF
                calm = calm + 1 if idle < len(names) and names[idle].startswith(station) else 0
                if calm >= 6:
                    return True
            else:
                calm, busy = 0, busy + 1
                if busy % 3 == 0:
                    d.press('A', frames=2, after=0)
        return False

    results = []
    for name, platform, (x, z), var, hour, model, station in PARTS:
        d.load_state(state)
        mem.write_byte(sym['gSovereignTestClock'], hour + 1)
        d.run(30)  # the game reads the clock every 11 frames
        mem.write_short(sym['gSovereignTestVar'] + 8, variables[var])
        mem.write_short(sym['gSovereignTestVar'] + 10, 1)
        for i in range(4):
            mem.write_short(sym['gCompleteTestMagnetTrain'] + 2 * i, 0)
        mem.write_short(sym['gSovereignTestScripts'], 0)
        start_warp(d, sym, names.index(platform), x, z, NORTH)

        stem = name.split(',')[0].replace(' ', '_')
        shots, seen = list(SHOTS), None
        for _ in range(WAIT // 5):
            d.run(5)
            cuts, first, frames, ended = train()[:4]
            if shots and frames >= shots[0]:
                d.screenshot().save(os.path.join(out, f'{stem}_{shots.pop(0):03d}.png'))
                seen = train()[4:]
            if ended:
                break
        arrived = off_at(station)
        d.screenshot().save(os.path.join(out, f'{stem}_end.png'))
        cuts, first, frames, ended = train()[:4]
        problem = ''
        if not ended:
            problem = f'the ride didn\'t end ({cuts} cuts, {frames} frames)'
        elif not arrived:
            idle = u32('gSovereignTestIdleMapHeaderID') & 0xFFFF
            problem = f'the player isn\'t free in {station}* after the ride (idle on {names[idle] if idle < len(names) else idle})'
        elif cuts != 3:
            problem = f'{cuts} cuts played'
        elif first != model:
            problem = f'the first cut\'s model is {first}, not {model}'
        elif frames < MIN_FRAMES:
            problem = f'the ride ran {frames} frames'
        light = ' (light 0x%04X, diffuse 0x%04X, DISPCNT 0x%04X, brightness 0x%04X)' % seen if seen else ''
        results.append(f'{name}: {problem or "ok"} ({frames} frames){light}')
        print(results[-1], flush=True)

    ok = sum(': ok' in r for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
