#!/usr/bin/env python3
"""Bring in Johto's and Kanto's NPC trades (step 4; docs/SacredGold.md).

HeartGold keeps its 13 trades in a/1/1/2 (pokeheartgold's struct NPCTrade: the Pokémon offered, its IVs, an ability
the game doesn't use, OT ID, contest stats, personality, held item, OT gender, sheen, language and the Pokémon
asked for) and their nicknames and OT names in msg_0200 (the nicknames, then the OT names). Platinum's are the same
record but the last word (res/npc_trades/*.json, include/constants/npc_trades.h). Sacred Gold changed 9 of the 13.

From Sacred Gold's ROM, each becomes res/npc_trades/hgss_<nickname>_<species>.json and NPC_TRADE_HGSS_<NICKNAME>_<SPECIES>
in enum NPCTradeID after Platinum's, in HeartGold's order, which the script translation follows (LoadNPCTrade n;
tools/complete/hgss_script_table.py, trade_names).

Usage: python3 tools/complete/import_hgss_trades.py [SACRED_GOLD_ROM]   (reruns replace the earlier entries)
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, ROOT  # noqa: E402

TRADES = 13
ENUM = os.path.join(DECOMP, 'include/constants/npc_trades.h')
OUT = os.path.join(DECOMP, 'res/npc_trades')
MARK = ("    // Sovereign Complete: Johto's and Kanto's, in HeartGold's order (tools/complete/import_hgss_trades.py)\n",
        "    // end of Johto's and Kanto's\n")
LANGUAGES = ['LANGUAGE_NONE', 'LANGUAGE_JAPANESE', 'LANGUAGE_ENGLISH', 'LANGUAGE_FRENCH', 'LANGUAGE_ITALIAN',
             'LANGUAGE_GERMAN', 'LANGUAGE_UNUSED_6', 'LANGUAGE_SPANISH']


def trade_names():
    """The engine's names of HeartGold's trades, in HeartGold's order (LoadNPCTrade n is the nth)."""
    text = open(ENUM).read()
    return re.findall(r'^\s+(NPC_TRADE_HGSS_\w+),', text, re.M)


def main():
    import ndspy.narc
    import ndspy.rom
    from import_hgss_text import usual_arg_counts
    from import_hgss_trainers import Lookup, decode_bank

    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache/sacredgold.nds')
    rom = ndspy.rom.NintendoDSRom.fromFile(rom_path)
    hg_rom = ndspy.rom.NintendoDSRom.fromFile(os.path.join(ROOT, '.cache/heartgold.nds'))
    usual = usual_arg_counts([bytes(f) for f in ndspy.narc.NARC(hg_rom.getFileByName('a/0/2/7')).files])
    texts = decode_bank(bytes(ndspy.narc.NARC(rom.getFileByName('a/0/2/7')).files[200]), usual)
    records = [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName('a/1/1/2')).files]
    assert len(records) == TRADES and len(texts) >= 2 * TRADES
    lookup = Lookup()

    for f in os.listdir(OUT):
        if f.startswith('hgss_'):
            os.remove(os.path.join(OUT, f))
    names = []
    for n, record in enumerate(records):
        (species, hp, atk, defense, speed, sp_atk, sp_def, ability, ot_id, cool, beauty, cute, smart, tough,
         personality, item, ot_gender, sheen, language, requested, _) = struct.unpack('<21I', record)
        nickname, ot_name = texts[n]['en_US'], texts[n + TRADES]['en_US']
        species_name = lookup('SPECIES_', species)
        stem = f'hgss_{nickname}_{species_name[len("SPECIES_"):]}'.lower()
        names.append('NPC_TRADE_' + stem.upper())
        data = {
            'name': nickname,
            'otName': ot_name,
            'species': species_name,
            'hpIV': hp, 'atkIV': atk, 'defIV': defense, 'speedIV': speed, 'spAtkIV': sp_atk, 'spDefIV': sp_def,
            'unused1': ability,
            'otID': ot_id,
            'cool': cool, 'beauty': beauty, 'cute': cute, 'smart': smart, 'tough': tough,
            'personality': personality,
            'heldItem': lookup('ITEM_', item) if item else 'ITEM_NONE',
            'otGender': ['GENDER_MALE', 'GENDER_FEMALE'][ot_gender],
            'unused2': sheen,
            'language': LANGUAGES[language],
            'requestedSpecies': lookup('SPECIES_', requested),
        }
        with open(os.path.join(OUT, stem + '.json'), 'w', encoding='utf-8') as f:
            f.write(json.dumps(data, indent=4, ensure_ascii=False) + '\n')

    text = open(ENUM).read()
    if MARK[0] in text:
        text = text[:text.index(MARK[0])] + text[text.index(MARK[1]) + len(MARK[1]):]
    at = text.index('    MAX_NPC_TRADES,')
    text = text[:at] + MARK[0] + ''.join(f'    {name},\n' for name in names) + MARK[1] + text[at:]
    open(ENUM, 'w').write(text)
    print(f'{len(names)} trades: {" ".join(names)}')
    if lookup.missing:
        print('not in Sovereign\'s lists:', ' '.join(sorted(lookup.missing)))


if __name__ == '__main__':
    main()
