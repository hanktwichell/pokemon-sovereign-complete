#!/usr/bin/env python3
"""Check Sacred Gold's special encounters (its Special Event Guide: Rotom, Spiritomb, the pseudo-legends, the
legendaries) in the test build, from the bedroom state: each one's script starts its battle with the Pokémon, level
and shininess the guide gives, and not before what it waits for.

Each case is a run from the save state. What its script asks for is set on the way in: Johto's and Kanto's badges up
to the one it needs (gCompleteTestHGSSBadges), the story's flags and vars (gSovereignTestVar), an item in the bag
(gSovereignTestBagItem, one per warp), Pokémon in the party (gSovereignTestPartyAdd, Lv. 50, the party cut to its lead
first), the hour and the weekday (gSovereignTestClock). A Pokémon standing on the map is kept shown
(gCompleteTestKeepFlagClear, its hide flag), as the story would show it by then. The player arrives beside it, facing
it, and talks (A), or presses A at a spot (a TV, the well's top, Ilex Forest's shrine), or steps onto a trigger tile
(the bed, Route 3's meteorites), and the script plays out with the answers given (gift_pokemon.talk_and_answer: yes
to each question, a list menu's entry), its battle in god mode (one hit knocks the foe out).

The battle is the one the test build records as a scripted wild battle starts (gCompleteTestScriptedWild, made in
CreateWildMon_Scripted): its species, level and whether it's shiny. A case without what its script waits for must
start none. A case can also name flags its script must leave set or clear (the nightmare shows Cresselia), and items
it must leave in the bag or take (the Lavender Town woman's Azure Flute for the Magma Stone): the steps that open the
way to an encounter.

Not here: Ho-Oh's and Lugia's (tools/complete/test_hgss_legend_cutscenes.py), Arceus's
(tools/complete/test_hgss_sinjoh.py), the roamers (tools/complete/test_hgss_roamers.py), the Snorlax (the radio's Poké
Flute, tools/complete/test_hgss_radio.py), the story's (Sudowoodo, the red Gyarados, the Rocket Hideout's Electrode:
tools/complete/test_hgss_opening.py) and the gifts (tools/complete/test_hgss_gifts.py).

Mew teleports about Viridian Forest three times before it battles: the player talks to it, then walks to each spot it
went to (a warp would load the map again, and Mew with it, off the map) and talks again.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_special_events.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [NAME ...]
"""
import os
import re
import struct
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'complete'))
from check_object_tiles import Maps, walkable  # noqa: E402
from find_spot import header_info  # noqa: E402
from gift_pokemon import names, talk_and_answer  # noqa: E402
from talk_to_objects import (DECOMP, SYMBOLS, arrive, cases as talk_cases, hidden_flag, header_names,  # noqa: E402
                             symbols, var_ids)
from test_hgss_opening import KEYS as STEP_KEYS, route  # noqa: E402
from test_hgss_togepi import SAVE_PAGES, SAVE_SECTOR, save_entry_index  # noqa: E402

TEST_VARS = 2  # gSovereignTestVar's entries from here on (arrive() may use [0] and [1])
LIMIT = 30000
KEYS = ('UP', 'DOWN', 'LEFT', 'RIGHT')  # enum FaceDirection
STEPS = ((0, -1), (0, 1), (-1, 0), (1, 0))
LATE_NIGHT, FRIDAY = 1, 5  # an hour of TIMEOFDAY_LATE_NIGHT (0 to 3), and Friday (Sunday is 0)

# (name, the target, what's set on the way in, the answers, the battle: (species, level, shiny) or None for none, and
# maybe {flag: value} the script must leave). The target is ('obj', events, object id), talked to from the tile the
# talk test stands on; ('bg', map header, x, z, the way the player faces it), A pressed from the tile beside it; or
# ('coord', map header, x, z, the way the player steps onto it). What's set: 'badges' (the last badge needed, and the
# ones before it), 'items', 'flags' ({flag or var: value}), 'party' (species), 'hour', 'weekday', and 'keep': False
# for an object whose hide flag the script sets (it's then left to the story's flags). A ('walk', events,
# object id, map header, [(x, z)...]) target talks to the object, then walks to each tile in turn and talks to what
# stands there.
NEW_BARK_1F, NEW_BARK_2F = 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_1F', 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_2F'
EVENTS = [
    ('Rotom', ('bg', NEW_BARK_1F, 5, 3, 0), {'badges': 'PLAIN'}, [True], ('SPECIES_ROTOM', 20, False)),
    ('Rotom before the Plain Badge', ('bg', NEW_BARK_1F, 5, 3, 0), {'badges': 'HIVE'}, [], None),
    ('Spiritomb', ('bg', 'MAP_HEADER_HGSS_AZALEA', 433, 454, None), {'items': ['ITEM_ODD_KEYSTONE']}, [True],
     ('SPECIES_SPIRITOMB', 20, False)),
    ('Spiritomb without a keystone', ('bg', 'MAP_HEADER_HGSS_AZALEA', 433, 454, None), {}, [], None),
    ('Dragonite (Sixteen Hours)', ('bg', 'MAP_HEADER_HGSS_TOHJO_FALLS_HIDDEN_ROOM', 7, 3, None), {'badges': 'EARTH'},
     [0], ('SPECIES_DRAGONITE', 60, True)),
    ('Garchomp (Jaws on Land)', ('bg', 'MAP_HEADER_HGSS_TOHJO_FALLS_HIDDEN_ROOM', 7, 3, None), {'badges': 'EARTH'},
     [4], ('SPECIES_GARCHOMP', 60, True)),
    ('the radio before the Earth Badge', ('bg', 'MAP_HEADER_HGSS_TOHJO_FALLS_HIDDEN_ROOM', 7, 3, None),
     {'badges': 'VOLCANO'}, [], None),
    ('Lapras (Friday)', ('obj', 'events_hgss_149', 'obj_D25R0103_rapurasu'), {'weekday': FRIDAY}, [],
     ('SPECIES_LAPRAS', 25, False)),
    ('Articuno', ('obj', 'events_hgss_411', 'obj_D11R0105_tsure_poke_static_articuno'), {}, [],
     ('SPECIES_ARTICUNO', 60, False)),
    ('Zapdos', ('obj', 'events_hgss_015', 'obj_R10_tsure_poke_static_zapdos'), {}, [], ('SPECIES_ZAPDOS', 60, False)),
    # Moltres takes Blaine's tile once Heatran is caught, which hides him and his gym's people
    ('Moltres (Cinnabar Gym)', ('obj', 'events_hgss_412', 'obj_D11R0106_8'),
     {'flags': {'FLAG_HGSS_HIDE_SEAFOAM_GYM_BLAINE': 1, 'FLAG_HGSS_SG_3FB6': 1}}, [], ('SPECIES_MOLTRES', 60, False)),
    ('Mewtwo', ('obj', 'events_hgss_406', 'obj_D03R0103_tsure_poke_static_mewtwo'), {}, [],
     ('SPECIES_MEWTWO', 75, False)),
    ('Celebi (Azure Flute)', ('bg', 'MAP_HEADER_HGSS_ILEX_FOREST', 16, 55, 0), {'items': ['ITEM_AZURE_FLUTE']}, [True],
     ('SPECIES_CELEBI', 45, False)),
    ('the shrine without the flute', ('bg', 'MAP_HEADER_HGSS_ILEX_FOREST', 16, 55, 0), {}, [], None),
    ('Regirock', ('obj', 'events_hgss_238', 'obj_D38R0104_7'), {}, [], ('SPECIES_REGIROCK', 40, False)),
    ('Regice', ('obj', 'events_hgss_224', 'obj_D39R0103_7'), {}, [], ('SPECIES_REGICE', 40, False)),
    ('Registeel', ('obj', 'events_hgss_120', 'obj_D42R0101_3'), {}, [], ('SPECIES_REGISTEEL', 40, False)),
    ('Regigigas', ('obj', 'events_hgss_416', 'obj_D41R0105_tsure_poke_static_moltres'), {}, [],
     ('SPECIES_REGIGIGAS', 75, False)),
    ('Latios (Soul Dew)', ('obj', 'events_hgss_051', 'obj_T06_20'), {'items': ['ITEM_SOUL_DEW']}, [True],
     ('SPECIES_LATIOS', 40, False)),
    ('Groudon', ('obj', 'events_hgss_476', 'obj_D52R0101_tsure_poke_static_groudon'), {}, [],
     ('SPECIES_GROUDON', 70, False)),
    ('Kyogre', ('obj', 'events_hgss_477', 'obj_D52R0102_tsure_poke_static_kyogre'), {}, [],
     ('SPECIES_KYOGRE', 70, False)),
    ('Rayquaza', ('obj', 'events_hgss_478', 'obj_D52R0103_tsure_poke_static_rayquaza'), {}, [],
     ('SPECIES_RAYQUAZA', 75, False)),
    ('Jirachi (a battle wished for)', ('obj', 'events_hgss_238', 'obj_D38R0104_8'), {'items': ['ITEM_AZURE_FLUTE']},
     [True, 3], ('SPECIES_JIRACHI', 45, False)),
    ('Deoxys (late at night)', ('coord', 'MAP_HEADER_HGSS_ROUTE_3', 1097, 117, 1),
     {'badges': 'EARTH', 'hour': LATE_NIGHT}, [], ('SPECIES_DEOXYS', 60, False)),
    ('the meteorites by day', ('coord', 'MAP_HEADER_HGSS_ROUTE_3', 1097, 117, 1), {'badges': 'EARTH'}, [], None),
    ('Uxie', ('obj', 'events_hgss_474', 'obj_D51R0201_1'), {'flags': {'FLAG_HGSS_SG_3FC6': 1}}, [],
     ('SPECIES_UXIE', 50, False)),
    ('Mesprit', ('obj', 'events_hgss_474', 'obj_D51R0201_2'), {'flags': {'FLAG_HGSS_SG_3FC4': 1}}, [],
     ('SPECIES_MESPRIT', 50, False)),
    ('Azelf', ('obj', 'events_hgss_474', 'obj_D51R0201_3'), {'flags': {'FLAG_HGSS_SG_3FC5': 1}}, [],
     ('SPECIES_AZELF', 50, False)),
    ('Dialga', ('obj', 'events_hgss_474', 'obj_D51R0201_5'), {'flags': {'FLAG_HGSS_SG_3FCE': 1}}, [],
     ('SPECIES_DIALGA', 70, False)),
    ('Palkia', ('obj', 'events_hgss_474', 'obj_D51R0201_6'), {'flags': {'FLAG_HGSS_SG_3FCC': 1}}, [],
     ('SPECIES_PALKIA', 70, False)),
    ('Giratina', ('obj', 'events_hgss_474', 'obj_D51R0201_7'), {'flags': {'FLAG_HGSS_SG_3FCD': 1}}, [],
     ('SPECIES_GIRATINA', 70, False)),
    ('Heatran', ('obj', 'events_hgss_054', 'obj_T09_3'), {}, [], ('SPECIES_HEATRAN', 70, False)),
    ('the nightmare (Earth Badge, no Lunar Wing)', ('coord', NEW_BARK_2F, 2, 9, None),
     {'badges': 'EARTH', 'flags': {'FLAG_HGSS_SG_3FBF': 1}}, [], None, {'FLAG_HGSS_SG_3FBF': 0}),
    ('Cresselia', ('obj', 'events_hgss_404', 'obj_D02R0103_1'), {}, [], ('SPECIES_CRESSELIA', 50, False)),
    ('Darkrai (Lunar Wing)', ('coord', NEW_BARK_2F, 2, 9, None), {'badges': 'EARTH', 'items': ['ITEM_LUNAR_WING']},
     [], ('SPECIES_DARKRAI', 50, False)),
    ('Shaymin (Azure Flute)', ('obj', 'events_hgss_093', 'obj_D22R0101_29'), {'items': ['ITEM_AZURE_FLUTE']}, [True],
     ('SPECIES_SHAYMIN', 45, False)),
    ('Shaymin without the flute', ('obj', 'events_hgss_093', 'obj_D22R0101_29'), {}, [], None),
    ("Regigigas's tablet (the three Regis along)", ('obj', 'events_hgss_119', 'obj_D41R0101_2'),
     {'party': ['SPECIES_REGIROCK', 'SPECIES_REGICE', 'SPECIES_REGISTEEL'], 'keep': False}, [], None,
     {'FLAG_HGSS_SG_3FB5': 1}),
    ('the tablet without them', ('obj', 'events_hgss_119', 'obj_D41R0101_2'), {'keep': False}, [], None,
     {'FLAG_HGSS_SG_3FB5': 0}),
    ('the Azure Flute for the Magma Stone', ('obj', 'events_hgss_391', 'obj_T05R0301_middlewoman1_2'),
     {'items': ['ITEM_MAGMA_STONE']}, [True], None, {'ITEM_AZURE_FLUTE': 1, 'ITEM_MAGMA_STONE': 0}),
    ("Heatran's Magma Stone (Heatran shows)", ('obj', 'events_hgss_054', 'obj_T09_monstarball'),
     {'flags': {'FLAG_HGSS_SG_3FC2': 1}}, [], None, {'FLAG_HGSS_SG_3FC2': 0, 'ITEM_MAGMA_STONE': 1}),
    ('Mew (after its three teleports)', ('walk', 'events_hgss_143', 'obj_D46R0101_12', 'MAP_HEADER_HGSS_VIRIDIAN_FOREST',
                                          [(33, 25), (41, 62), (26, 41)]), {}, [], ('SPECIES_MEW', 45, False)),
]
WALK_STEPS = 300


def badge_mask(last):
    """The badges up to last (a name after BADGE_ID_HGSS_), as gCompleteTestHGSSBadges takes them."""
    if not last:
        return 0
    text = open(os.path.join(DECOMP, 'include', 'constants', 'hgss_badges.h'), encoding='utf-8').read()
    n = int(text.split('BADGE_ID_HGSS_' + last)[1].split()[0])
    return (1 << (n + 1)) - 1


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    only = sys.argv[4:]
    os.makedirs(out, exist_ok=True)
    chosen = [e for e in EVENTS if not only or any(o in e[0] for o in only)]
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gSovereignTestMenu', 'gSovereignTestPartyKeep', 'gSovereignTestPartyAdd',
                             'gCompleteTestHGSSBadges', 'gCompleteTestKeepFlagClear', 'gCompleteTestScriptedWild'))
    variables = var_ids()
    headers = header_names()
    species_names, item_names = names('species'), names('items')
    places = {(c[0], c[1]): c for c in talk_cases()}
    maps = Maps(DECOMP)
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def flag(name):
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS') * 16 + 8
        flags = base + 20 + u32(at) + (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        return int(bool(mem.unsigned[flags + n // 8] & (1 << (n % 8))))

    bag_text = open(os.path.join(DECOMP, 'include', 'bag.h'), encoding='utf-8').read()
    bag_slots = sum(int(n) for n in re.findall(r'#define \w+_POCKET_SIZE\s+(\d+)', bag_text))

    def bag_count(item):
        """How many of the item the bag holds (include/bag.h: every pocket's BagItems, item and quantity)."""
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index('SAVE_TABLE_ENTRY_BAG') * 16 + 8
        bag = base + 20 + u32(at)
        want = item_names.index(item)
        slots = struct.unpack(f'<{2 * bag_slots}H', bytes(mem.unsigned[bag:bag + 4 * bag_slots]))
        return sum(slots[i + 1] for i in range(0, len(slots), 2) if slots[i] == want)

    def after_value(name):
        return min(bag_count(name), 1) if name.startswith('ITEM_') else flag(name)

    def wild():
        at = sym['gCompleteTestScriptedWild']
        return u16(at), u16(at + 2), u16(at + 4), u16(at + 6)

    def setup(gates, keep):
        """Applied by the way-in warp (the clock as the game next reads it)."""
        mem.write_short(sym['gCompleteTestHGSSBadges'], badge_mask(gates.get('badges')))
        mem.write_short(sym['gCompleteTestKeepFlagClear'], variables[keep] if keep else 0)
        flags = dict(gates.get('flags', {}))
        if keep:
            flags.setdefault(keep, 0)
        for i, (name, value) in enumerate(flags.items(), TEST_VARS):
            mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[name])
            mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)
        if gates.get('party'):
            mem.write_byte(sym['gSovereignTestPartyKeep'], 1)
            for i, species in enumerate(gates['party']):
                mem.write_short(sym['gSovereignTestPartyAdd'] + 4 * i, species_names.index(species))
                mem.write_byte(sym['gSovereignTestPartyAdd'] + 4 * i + 2, 0)  # form
                mem.write_byte(sym['gSovereignTestPartyAdd'] + 4 * i + 3, 50)  # level
        items = gates.get('items', [])
        if items:
            mem.write_short(sym['gSovereignTestBagItem'], item_names.index(items[0]))
        if 'hour' in gates:
            mem.write_byte(sym['gSovereignTestClock'], gates['hour'] + 1)
        if 'weekday' in gates:
            mem.write_byte(sym['gSovereignTestClock'] + 2, gates['weekday'] + 1)

    def stand(header, x, z, face):
        """The tile to stand on beside (x, z), and the way to face it: the given way, or the first side that's
        walkable."""
        _, matrix = header_info(header)
        for f in ([face] if face is not None else range(4)):
            sx, sz = x - STEPS[f][0], z - STEPS[f][1]
            if walkable(maps.tile(matrix, sx, sz)):
                return sx, sz, f
        return None

    def go(target, gates):
        """Arrive for the target: ('ok', frames, its header ID), or what went wrong."""
        kind = target[0]
        if kind == 'obj':
            _, events, oid = target
            _, _, header_id, way_in, x, z, face = places[(events, oid)]
            keep = hidden_flag(events, oid) if gates.get('keep', True) else None
        else:
            _, header, x, z, face = target
            header_id = headers.index(header)
            spot = stand(header, x, z, face)
            if spot is None:
                return 'no tile to stand on', 0, header_id
            x, z, face = spot
            way_in, keep, events = (x, z), None, None
        result, frames = arrive(d, sym, state, variables, events, header_id, way_in, x, z, face,
                                setup=lambda: setup(gates, keep))
        for item in gates.get('items', [])[1:]:  # one more item each warp
            if result == 'ok':
                mem.write_short(sym['gSovereignTestBagItem'], item_names.index(item))
                result, frames = arrive_again(header_id, x, z, face)
        if result == 'ok' and d.pos() != (x, z):  # a scene on the way in moved the player
            result, frames = arrive_again(header_id, x, z, face)
        return result, frames, header_id

    def arrive_again(header_id, x, z, face):
        from talk_to_objects import warp
        return warp(d, sym, header_id, x, z, face + 1)

    def walk_to(header, goal):
        """Walk to goal on the map, a step at a time, finding the way again after each; a script that starts on the
        way (a trainer who sees the player) is played out, and when the test save's Super Repel wears off, the
        question to use another is answered yes (the bag has two). Returns a problem, or ''."""
        _, matrix = header_info(header)
        failed = set()
        for _ in range(WALK_STEPS):
            pos = d.pos()
            if pos == goal:
                return ''
            keys = route(maps, matrix, pos, goal, set(), frozenset(failed))
            if not keys:
                return f'no way from {pos} to {goal}'
            d.press(keys[0], frames=8, after=16)
            if d.pos() == pos:  # it turned the player, someone is in the way, or a script started
                result, _ = talk_and_answer(d, sym, [True], LIMIT, press_a=False)
                if result not in ('ok', 'NOSCRIPT', 'MENU 1 answers left'):
                    return f'{result} on the way at {d.pos()}'
                if d.pos() == pos:
                    d.press(keys[0], frames=8, after=16)
                    if d.pos() == pos:
                        failed.add((pos, next(k for k, v in STEP_KEYS.items() if v == keys[0])))
        return f'still not at {goal} after {WALK_STEPS} steps, at {d.pos()}'

    def walk_and_talk(target, answers):
        """The talks of a 'walk' target after the first, the answers for the last: (result, frames)."""
        _, _, _, header, spots = target
        result, frames = 'ok', 0
        for i, (x, z) in enumerate(spots):
            sx, sz, face = stand(header, x, z, None)
            problem = walk_to(header, (sx, sz))
            if problem:
                return problem, frames
            d.press(KEYS[face], frames=2, after=8)  # facing it
            result, frames = talk_and_answer(d, sym, answers if i == len(spots) - 1 else [], LIMIT)
            if result != 'ok':
                return f'{result} at {(x, z)}', frames
        return result, frames

    bad = 0
    with open(os.path.join(out, 'results.txt'), 'w') as f:
        for name, target, gates, answers, want, *after in chosen:
            after = after[0] if after else {}
            result, frames, _ = go(target if target[0] != 'walk' else ('obj',) + target[1:3], gates)
            before = wild()
            if result == 'ok':
                if target[0] == 'walk':
                    result, frames = talk_and_answer(d, sym, [], LIMIT)
                    if result == 'ok':
                        result, frames = walk_and_talk(target, answers)
                elif target[0] == 'coord':
                    d.press(KEYS[target[4] if target[4] is not None else stand(*target[1:4], None)[2]],
                            frames=10, after=0)
                    result, frames = talk_and_answer(d, sym, answers, LIMIT, press_a=False)
                else:
                    result, frames = talk_and_answer(d, sym, answers, LIMIT)
                if result == 'NOSCRIPT' and want is None:
                    result = 'ok'
            got = wild()
            wrong = []
            if result == 'ok':
                if want is None and got[0] != before[0]:
                    wrong.append(f'a battle with {species_names[got[1]]} Lv. {got[2]} (want none)')
                elif want is not None and got[0] == before[0]:
                    wrong.append('no battle')
                elif want is not None:
                    species, level, shiny = want
                    checks = [('species', species_names[got[1]], species), ('level', got[2], level),
                              ('shiny', bool(got[3]), shiny)]
                    wrong += [f'{what} {g} (want {w})' for what, g, w in checks if g != w]
                wrong += [f'{key} {after_value(key)} after (want {value})' for key, value in after.items()
                          if after_value(key) != value]
            if result != 'ok' or wrong:
                bad += 1
            d.screenshot().save(os.path.join(out, f'{name.split(" (")[0].replace(" ", "_")}.png'))
            line = f'{name}: {result} {frames}' + ''.join(f'\n    WRONG {w}' for w in wrong)
            print(line, file=f, flush=True)
            print(line, flush=True)
        print(f'{len(chosen) - bad} of {len(chosen)} special events ok', file=f)
    print(f'{len(chosen) - bad} of {len(chosen)} special events ok')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
