#!/usr/bin/env python3
"""Check where the player comes back after blacking out in Johto (HeartGold's spawn points, after Platinum's in
src/spawn_locations.c: tools/complete/import_hgss_spawns.py), in the test build, from the bedroom state:

1. **Pokémon Center:** after visiting Cherrygrove City's Pokémon Center, the player loses a battle on Route 30 and comes
   back in front of its nurse, who heals the party (Platinum's Pokémon Center recovery, with HeartGold's nurse).
2. **Home:** after visiting the player's house in New Bark Town, the player loses a battle on Route 29 and comes back
   there, where Mom heals the party (Platinum's home recovery).

The party is cut to its lead, which becomes a Magikarp at Lv. 2 with 1% of its HP (gSovereignTestLead), and the battle
is the test build's wild battle (SELECT) with a Garchomp at Lv. 100 (gSovereignTestWild): a lost wild battle blacks out
on its own, where the test build's trainer battle leaves that to the script that started it. A part passes when the
field is idle again on that map, on its spawn tile, once the recovery scene has played out.

Results: one line per part, 'ok' or what went wrong, and a screenshot of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_blackout.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from battle_all_trainers import fight  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, play_out, warp  # noqa: E402
from test_map_warp import walkable_tile  # noqa: E402

# (part, the spawn map visited first, the map the battle is on, the spawn tile: HeartGold's sSpawnMaps)
PARTS = [('pokecenter', 'MAP_HEADER_HGSS_CHERRYGROVE_POKECENTER_1F', 'MAP_HEADER_HGSS_ROUTE_30', (8, 13)),
         ('home', 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_1F', 'MAP_HEADER_HGSS_ROUTE_29', (6, 8))]
MAGIKARP, LEVEL, HP_PERCENT = 129, 2, 1
LEAD = {'species': 0, 'level': 3, 'hp': 15}  # struct SovereignTestLead
WILD_SPECIES, WILD_LEVEL = 445, 100  # Garchomp
WILD = {'species': 0, 'level': 3}  # struct SovereignTestWild
BATTLE_FRAMES = 6000
RECOVER_FRAMES = 6000
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'gSovereignTestLead', 'gSovereignTestWild', 'gSovereignTestGodMode',
                                     'gSovereignTestPlayerTile', 'gSovereignTestPartyKeep'})


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory
    results = []
    for name, spawn_map, battle_map, back_tile in PARTS:
        d.load_state(state)
        d.run(30)
        mem.write_byte(sym['gSovereignTestPartyKeep'], 1)
        problem = ''
        arrived, _ = warp(d, sym, names.index(spawn_map), *walkable_tile(spawn_map), 0)  # entering sets the spawn point
        if arrived == 'ok':
            arrived, _ = warp(d, sym, names.index(battle_map), *walkable_tile(battle_map), 0)
        if arrived != 'ok':
            problem = f'warp {arrived}'
        if not problem:
            lead = sym['gSovereignTestLead']
            mem.write_short(lead + LEAD['species'], MAGIKARP)
            mem.write_byte(lead + LEAD['level'], LEVEL)
            mem.write_byte(lead + LEAD['hp'], HP_PERCENT)
            mem.write_byte(sym['gSovereignTestGodMode'], 0)
            mem.write_short(sym['gSovereignTestWild'] + WILD['species'], WILD_SPECIES)
            mem.write_byte(sym['gSovereignTestWild'] + WILD['level'], WILD_LEVEL)
            d.press('SELECT', frames=8, after=0)
            result, frames = fight(d, sym, BATTLE_FRAMES)
            print(f'{name}: the battle: {result} after {frames} frames', flush=True)
            if result not in ('ok', 'STUCK'):  # the field takes a while to come back after a loss: played out below
                problem = f'battle {result}'
        if not problem:
            result, _ = play_out(d, sym, RECOVER_FRAMES, names.index(spawn_map), press_a=False)
            here = struct.unpack('<H', bytes(mem.unsigned[sym['gSovereignTestIdleMapHeaderID']:
                                                          sym['gSovereignTestIdleMapHeaderID'] + 2]))[0]
            tile = struct.unpack('<HH', bytes(mem.unsigned[sym['gSovereignTestPlayerTile']:
                                                          sym['gSovereignTestPlayerTile'] + 4]))
            if result not in ('ok', 'NOSCRIPT'):  # NOSCRIPT: the battle's A presses played the recovery out already
                problem = f'after the battle: {result}'
            elif here != names.index(spawn_map):
                problem = f'came back on {names[here] if here < len(names) else here}, not {spawn_map}'
            elif tile != back_tile:
                problem = f'came back on tile {tile}, not {back_tile}'
        d.screenshot().save(os.path.join(out, f'{name}.png'))
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(PARTS)} parts ok')
    sys.exit(0 if all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
