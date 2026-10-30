#!/usr/bin/env python3
"""Check HeartGold's Headbutt trees and Rock Smash finds (src/overlay006/complete_field_encounters.c) in the test build,
from the bedroom state, with god mode on (gSovereignTestGodMode) so a battle ends at the first hit:

1. **Headbutt:** with a Bidoof at Lv. 13 in the party (it knows Headbutt), the player faces Route 29's trees one after
   another and says yes to Headbutt, until one has a Pokémon fall out (a tree's kind goes by the trainer ID's last
   digit, and one tree in five of each row has none). Passes when a wild battle starts with one of the map's tree
   Pokémon (gCompleteTestFieldEncounter).
2. **Rock Smash:** with HM06 in the bag and the Zephyr Badge, the player smashes a rock in Dark Cave (Route 31's side:
   a Pokémon at 50%, else an item at 50%), from a fresh start each time with the random numbers seeded differently
   (sLCRNGState). Passes once both a wild battle and an item have come.

The test save's Super Repel is ended first (gCompleteTestNoRepel), and the party is cut to its lead to make room.

Results: one line per part, 'ok' or what went wrong, and a screenshot of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_headbutt.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from check_trainer_party import consts  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, play_out, warp  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
TABLES = os.path.join(DECOMP, 'include', 'data', 'hgss_field_encounters.h')
NORTH, SOUTH, WEST, EAST = 1, 2, 3, 4  # the test warp's facing: enum FaceDirection + 1
TREE_MAP = 'MAP_HEADER_HGSS_ROUTE_29'
TREES_TRIED = 5  # the first five trees (each row of five has one with no Pokémon)
HEADBUTTER = ('SPECIES_BIDOOF', 13)
ROCK_MAP, ROCK_TILE, ROCK_FACING = 'MAP_HEADER_HGSS_DARK_CAVE_ROUTE_31_SIDE', (16, 17), EAST  # the rock at (17, 17)
ROCK_TRIES = 12
ZEPHYR = 0
LIMIT = 6000
FIELD_ENCOUNTER = {'count': 0, 'species': 2, 'level': 4, 'items': 6, 'item': 8}  # struct CompleteTestFieldEncounter
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gCompleteTestFieldEncounter', 'gCompleteTestHGSSBadges', 'gCompleteTestNoRepel',
                                     'gSovereignTestMenu', 'sLCRNGState'})


def tree_tiles(map_name):
    """[(x, z, tree)] of the map's regular trees, from the generated tables."""
    text = open(TABLES).read()
    tiles = [tuple(map(int, t)) for t in re.findall(r'^    \{ (\d+), (\d+), (\d+), (\d+) \},$', text, re.M)]
    first, count = map(int, re.search(rf'\{{ {map_name}, \d+, \d+, (\d+), (\d+), \{{', text).groups())
    return [(x, z, tree) for x, z, tree, secret in tiles[first:first + count] if not secret]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    species, items = consts('species.txt'), consts('items.txt')
    d = Driver(rom, state)
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def encounter(field):
        return u16(sym['gCompleteTestFieldEncounter'] + FIELD_ENCOUNTER[field])

    def menus():
        return struct.unpack('<I', bytes(mem.unsigned[sym['gSovereignTestMenu']:sym['gSovereignTestMenu'] + 4]))[0]

    def start(map_name, tile, facing, setup):
        d.load_state(state)
        d.run(30)
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        mem.write_byte(sym['gCompleteTestNoRepel'], 1)  # the test save's Super Repel would keep them away
        setup()
        arrived, _ = warp(d, sym, names.index(map_name), *tile, 0)
        if arrived == 'ok':  # again on the same map, which turns the player
            arrived, _ = warp(d, sym, names.index(map_name), *tile, facing)
        return arrived

    results = []

    # 1. Headbutt
    def add_headbutter():
        mem.write_byte(sym['gSovereignTestPartyKeep'], 1)  # room in the party
        mem.write_short(sym['gSovereignTestPartyAdd'], species.index(HEADBUTTER[0]))
        mem.write_byte(sym['gSovereignTestPartyAdd'] + 3, HEADBUTTER[1])

    problem, tried = 'no tree had a Pokémon', 0
    sides = [((0, 1), NORTH), ((0, -1), SOUTH), ((-1, 0), EAST), ((1, 0), WEST)]
    tiles = tree_tiles(TREE_MAP)
    for tree in range(TREES_TRIED):
        for x, z, _ in [t for t in tiles if t[2] == tree][:1]:
            for (dx, dz), facing in sides:
                if (x + dx, z + dz, tree) in tiles:
                    continue
                arrived = start(TREE_MAP, (x + dx, z + dz), facing, add_headbutter)
                if arrived != 'ok':
                    continue
                before, asked = encounter('count'), menus()
                result, frames = play_out(d, sym, LIMIT)
                if menus() == asked:  # not a tree from this side
                    continue
                tried += 1
                if encounter('count') > before:
                    problem = '' if result == 'ok' else f'the battle: {result} after {frames} frames'
                    print(f'tree {tree}: {species[encounter("species")]} Lv. {encounter("level")}', flush=True)
                break
            if not problem:
                break
        if not problem:
            break
    d.screenshot().save(os.path.join(out, 'headbutt.png'))
    results.append(f'Headbutt: {problem or "ok"} ({tried} trees tried)')
    print(results[-1], flush=True)

    # 2. Rock Smash
    def give_rock_smash():
        mem.write_short(sym['gCompleteTestHGSSBadges'], 1 << ZEPHYR)
        mem.write_short(sym['gSovereignTestBagItem'], items.index('ITEM_HM06'))

    battles, found, problem = 0, 0, ''
    for attempt in range(ROCK_TRIES):
        arrived = start(ROCK_MAP, ROCK_TILE, ROCK_FACING, give_rock_smash)
        if arrived != 'ok':
            problem = f'warp {arrived}'
            break
        mem.write_long(sym['sLCRNGState'], 0x9E3779B9 * (attempt + 1) & 0xFFFFFFFF)  # different random numbers each time
        before, items_before = encounter('count'), encounter('items')
        result, frames = play_out(d, sym, LIMIT)
        if result != 'ok':
            problem = f'{result} after {frames} frames'
            break
        if encounter('count') > before:
            battles += 1
            print(f'rock {attempt}: {species[encounter("species")]} Lv. {encounter("level")}', flush=True)
        elif encounter('items') > items_before:
            found += 1
            print(f'rock {attempt}: {items[encounter("item")]}', flush=True)
        else:
            print(f'rock {attempt}: nothing', flush=True)
        if battles and found:
            break
    if not problem and not (battles and found):
        problem = f'{battles} battles and {found} items in {ROCK_TRIES} rocks'
    d.screenshot().save(os.path.join(out, 'rock_smash.png'))
    results.append(f'Rock Smash: {problem or "ok"}')
    print(results[-1], flush=True)

    print(f'{sum(r.split(" (")[0].endswith(": ok") for r in results)} of {len(results)} parts ok')
    sys.exit(0 if all(r.split(' (')[0].endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
