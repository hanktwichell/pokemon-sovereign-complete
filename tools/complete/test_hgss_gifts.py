#!/usr/bin/env python3
"""Receive Johto's and Kanto's Pokémon gifts and make their in-game trades (Sacred Gold's scripts) in the test build,
from the bedroom state, and check what arrives in the party, as tools/test/gift_pokemon.py does for Sovereign's own
gifts.

Each gift is a run from the save state: the party is cut to its lead (gSovereignTestPartyKeep), the story flags its
script asks for are set (or a giver's hide flag cleared) on the way in (gSovereignTestVar), the player comes in by the
map's way in and warps next to the giver (talk_to_objects.arrive), and talks. The script's questions get GIFTS's
answers (gift_pokemon.talk_and_answer: yes to taking it, no to a nickname). Then the party's last Pokémon must be the
gifts: each one's species, level, held item, and whether it's an Egg. The flags come from the script's own branches
to its gift command (a breadth-first search over its instructions, run when writing the table).

The starters' second and third choices go by the lead's species, which the test build sets (gCompleteTestLeadSpecies).
Not here: the National Park's Hoenn starters (the giver stands off the map until a scene brings them in), Lt.
Surge's Pikachu trade (he waits at the station only on a rematch day arranged by phone), Brock's, Jasmine's and
Steven's trades (they come with battles and story steps), the friendship Pikachu in Cianwood, the Game Corners'
prizes (coins), and the gifts that came by distribution (Primo's eggs).
Elm's starter is tools/complete/test_hgss_starter.py's, and the loan Pokémon tools/complete/test_hgss_loan.py's.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_gifts.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [NAME ...]
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from gift_pokemon import names, note_party, talk_and_answer  # noqa: E402
from talk_to_objects import SYMBOLS, arrive, cases as talk_cases, symbols, var_ids  # noqa: E402

TEST_VARS = 2  # gSovereignTestVar's entries from here on (arrive() may use [0] and [1])
# (name, events, giver, {flag or var: value} set on the way in, the answers, [(species, level, held item, Egg)], and
# maybe {'lead': the lead's species, for a giver who goes by it (gCompleteTestLeadSpecies), 'give': a Pokémon added to
# the party at Lv. 50 (gSovereignTestPartyAdd), for a trade})
GIFTS = [
    ('Eevee', 'events_hgss_031', 'obj_R30_15', {'FLAG_HGSS_SG_3F5C': 0}, [False],
     [('SPECIES_EEVEE', 5, 'ITEM_NONE', False)]),
    ('Tyrogue', 'events_hgss_238', 'obj_D38R0104_gsfighter', {'FLAG_HGSS_BEAT_KARATE_KING': 1}, [False],
     [('SPECIES_TYROGUE', 10, 'ITEM_FIST_PLATE', False)]),
    ('Dragonair', 'events_hgss_259', 'obj_D44R0103_chourou', {'FLAG_HGSS_GOT_TM59_FROM_CLAIR': 1}, [False],
     [('SPECIES_DRAGONAIR', 45, 'ITEM_DRACO_PLATE', False)]),
    ('Castform', 'events_hgss_196', 'obj_T25R0401_masaki', {'FLAG_HGSS_HIDE_GOLDENROD_BILL': 0}, [True, False],
     [('SPECIES_CASTFORM', 25, 'ITEM_MYSTIC_WATER', False)]),
    ('Riolu Egg', 'events_hgss_129', 'obj_T28R0201_gsfighter', {}, [],
     [('SPECIES_RIOLU', 1, 'ITEM_NONE', True)]),
    ('Togepi Egg', 'events_hgss_152', 'obj_T22FS0101_assistantm', {'FLAG_HGSS_HIDE_VIOLET_SHOP_LAB_AIDE': 0}, [True],
     [('SPECIES_TOGEPI', 1, 'ITEM_NONE', True)]),
    ('Manaphy Egg', 'events_hgss_091', 'obj_W40_8', {'FLAG_HGSS_SG_3FBC': 0, 'FLAG_HGSS_SG_3FBB': 1}, [True],
     [('SPECIES_MANAPHY', 1, 'ITEM_NONE', True)]),
    ('Johto starters', 'events_hgss_359', 'obj_T11R0701_3',  # the two the player didn't pick (Chikorita here)
     {'FLAG_HGSS_SG_3F9A': 0, 'VAR_HGSS_PLAYER_STARTER': 152}, [],
     [('SPECIES_CYNDAQUIL', 10, 'ITEM_ORAN_BERRY', False), ('SPECIES_TOTODILE', 10, 'ITEM_ORAN_BERRY', False)]),
    ('Kanto starters', 'events_hgss_485', 'obj_R12R0101_fishing_2', {'FLAG_HGSS_SG_3F99': 0}, [],
     [('SPECIES_CHARMANDER', 10, 'ITEM_ORAN_BERRY', False), ('SPECIES_SQUIRTLE', 10, 'ITEM_ORAN_BERRY', False)],
     {'lead': 'SPECIES_BULBASAUR'}),
    ('Hoenn starters', 'events_hgss_430', 'obj_T03R0601_gsoldman1', {'FLAG_HGSS_SG_3FBA': 0, 'FLAG_HGSS_SG_3FB9': 1},
     [], [('SPECIES_TORCHIC', 10, 'ITEM_ORAN_BERRY', False), ('SPECIES_MUDKIP', 10, 'ITEM_ORAN_BERRY', False)],
     {'lead': 'SPECIES_TREECKO'}),
    ('Sinnoh starters', 'events_hgss_175', 'obj_T25R0201_gsmiddleman1',
     {'FLAG_HGSS_SG_3FDA': 1, 'FLAG_HGSS_SG_3F9B': 0}, [],
     [('SPECIES_CHIMCHAR', 10, 'ITEM_ORAN_BERRY', False), ('SPECIES_PIPLUP', 10, 'ITEM_ORAN_BERRY', False)],
     {'lead': 'SPECIES_TURTWIG'}),
    # The Pokémon Centers' quizzes, passed (the first starter on each list)
    ('Violet quiz', 'events_hgss_153', 'obj_T22PC0101_10', {'FLAG_HGSS_SG_3FF8': 0, 'FLAG_HGSS_SG_3FF7': 1},
     [0, False],
     [('SPECIES_BULBASAUR', 10, 'ITEM_NONE', False)]),
    ('Azalea quiz', 'events_hgss_160', 'obj_T23PC0101_7', {'FLAG_HGSS_SG_3F92': 0, 'FLAG_HGSS_SG_3F91': 1},
     [0, False],
     [('SPECIES_TREECKO', 15, 'ITEM_NONE', False)]),
    ('Goldenrod quiz', 'events_hgss_178', 'obj_T25PC0101_7', {'FLAG_HGSS_SG_3FF3': 0, 'FLAG_HGSS_SG_3FF2': 1},
     [0, False],
     [('SPECIES_TURTWIG', 20, 'ITEM_NONE', False)]),
    # The trades: the Pokémon asked for (added to the party, Lv. 50) for the trader's, at its level
    ('Perry (Porygon2)', 'events_hgss_421', 'obj_R10R0201_gsassistantm_3', {}, [True, ('party', 1)],
     [('SPECIES_PORYGON2', 50, 'ITEM_DUBIOUS_DISC', False)], {'give': 'SPECIES_QUAGSIRE'}),
    ('Bexxi (Espeon)', 'events_hgss_428', 'obj_T03PC0101_gsmiddleman1', {}, [True, ('party', 1)],
     [('SPECIES_ESPEON', 50, 'ITEM_MICLE_BERRY', False)], {'give': 'SPECIES_CLEFABLE'}),
    ('Razor (Gligar)', 'events_hgss_156', 'obj_T22R0601_gsboy1', {}, [True, ('party', 1)],
     [('SPECIES_GLIGAR', 50, 'ITEM_WIDE_LENS', False)], {'give': 'SPECIES_RHYHORN'}),
    ('Robotnik (Beldum)', 'events_hgss_160', 'obj_T23PC0101_fishing_2', {}, [True, ('party', 1)],
     [('SPECIES_BELDUM', 50, 'ITEM_MOON_STONE', False)], {'give': 'SPECIES_GIBLE'}),
    ('Mimi (Chansey)', 'events_hgss_198', 'obj_T25R0801_gsbigman', {'FLAG_HGSS_SG_3FE7': 0}, [True, ('party', 1)],
     [('SPECIES_CHANSEY', 50, 'ITEM_OVAL_STONE', False)], {'give': 'SPECIES_MUNCHLAX'}),
    ('Squillaci (Torkoal)', 'events_hgss_188', 'obj_T25R1005_gsbigman', {}, [True, ('party', 1)],
     [('SPECIES_TORKOAL', 50, 'ITEM_NUGGET', False)], {'give': 'SPECIES_NOCTOWL'}),
    ('Moxxi (Skarmory)', 'events_hgss_214', 'obj_T26R0301_fishing_2', {}, [True, ('party', 1)],
     [('SPECIES_SKARMORY', 50, 'ITEM_METAL_COAT', False)], {'give': 'SPECIES_ELECTABUZZ'}),
    ('Lola (Smoochum)', 'events_hgss_082', 'obj_T27R0401_2', {}, [True, ('party', 1)],
     [('SPECIES_SMOOCHUM', 50, 'ITEM_SMOKE_BALL', False)], {'give': 'SPECIES_MIME_JR'}),
    ('Phione Eggs', 'events_hgss_048', 'obj_T03_gswoman3', {}, [],  # two, each time (no flag)
     [('SPECIES_PHIONE', 1, 'ITEM_NONE', True), ('SPECIES_PHIONE', 1, 'ITEM_NONE', True)]),
]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    only = sys.argv[4:]
    os.makedirs(out, exist_ok=True)
    chosen = [g for g in GIFTS if not only or g[0] in only]
    leads = ('gCompleteTestLeadSpecies',) if any(g[6:] and 'lead' in g[6] for g in chosen) else ()
    sym = symbols(SYMBOLS + ('gSovereignTestMenu', 'gSovereignTestPartyKeep', 'gSovereignTestParty',
                             'gSovereignTestPartyAdd') + leads)
    variables = var_ids()
    species_names, item_names = names('species'), names('items')
    places = {(c[0], c[1]): c for c in talk_cases()}
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory

    def setup(flags, opts):  # applied by the way-in warp (the lead's species on the first free field frame)
        mem.write_byte(sym['gSovereignTestPartyKeep'], 1)
        if 'lead' in opts:
            mem.write_short(sym['gCompleteTestLeadSpecies'], species_names.index(opts['lead']))
        if 'give' in opts:
            mem.write_short(sym['gSovereignTestPartyAdd'], species_names.index(opts['give']))
            mem.write_byte(sym['gSovereignTestPartyAdd'] + 2, 0)  # form
            mem.write_byte(sym['gSovereignTestPartyAdd'] + 3, 50)  # level
        for i, (name, value) in enumerate(flags.items(), TEST_VARS):
            mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[name])
            mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)

    bad = 0
    with open(os.path.join(out, 'results.txt'), 'w') as f:
        for name, events, giver, flags, answers, gifts, *opts in chosen:
            opts = opts[0] if opts else {}
            _, _, header, way_in, x, z, face = places[(events, giver)]
            result, frames = arrive(d, sym, state, variables, events, header, way_in, x, z, face,
                                    setup=lambda: setup(flags, opts))
            if result == 'ok':
                result, frames = talk_and_answer(d, sym, answers)
            wrong = []
            if result == 'ok':
                party = note_party(d, sym)
                if len(party) != 1 + len(gifts):
                    wrong.append(f'party size {len(party)} (want {1 + len(gifts)})')
                for got, (species, level, item, egg) in zip(party[1:], gifts):
                    got_species, _, got_item, _, _, got_level, _, got_egg = got
                    checks = [('species', species_names[got_species], species), ('level', got_level, level),
                              ('held item', item_names[got_item], item), ('Egg', bool(got_egg), egg)]
                    wrong += [f'{what} {g} (want {w})' for what, g, w in checks if g != w]
            if result != 'ok' or wrong:
                bad += 1
                d.screenshot().save(os.path.join(out, f'{name.replace(" ", "_")}.png'))
            line = f'{name}: {result} {frames}' + ''.join(f'\n    WRONG {w}' for w in wrong)
            print(line, file=f, flush=True)
            print(line, flush=True)
        print(f'{len(chosen) - bad} of {len(chosen)} gifts ok', file=f)
    print(f'{len(chosen) - bad} of {len(chosen)} gifts ok')
    sys.exit(1 if bad else 0)


if __name__ == '__main__':
    main()
