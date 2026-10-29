#!/usr/bin/env python3
"""Bring in Sacred Gold's wild Pokémon (step 4; docs/SacredGold.md).

From Sacred Gold's ROM (.cache/sacredgold.nds, a/0/3/7: one table per HeartGold encounter bank, in HeartGold's layout,
pokeheartgold's include/wild_encounter.h; Sacred Gold's stop 4 bytes early, before the night-fishing and
fishing-swarm species, which read as none) into decomp/res/field/encounters/hgss/encounters_hgss_NNN.json, one per
bank, in the same layout with Sovereign's species names:

- land: the rate and twelve slots, each with its level and its species in the morning, by day and at night (HeartGold
  keeps all three; Platinum only swaps two slots);
- surfing, Rock Smash, the three rods: rate and slots (minimum and maximum level, species);
- the Pokégear radio's Hoenn and Sinnoh sounds (two species each) and the swarm species, for when those features come
  (step 5).

The build packs them into hgss_enc_data.narc (decomp/tools/jsoncnv/encounter_hgss.py), in HeartGold's binary layout;
the engine fills a Johto or Kanto map's table from it (src/complete_encounters.c). The map is named after
pokeheartgold's own list (files/fielddata/encountdata/gs_enc_data.json).

Usage: python3 tools/complete/import_hgss_encounters.py [ROM]
"""
import json
import os
import struct
import sys

import ndspy.narc
import ndspy.rom

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402
from import_hgss_trainers import Lookup  # noqa: E402

SIZE = 0xC4
OUT = os.path.join(DECOMP, 'res/field/encounters/hgss')


def table(data, species):
    data = data + bytes(SIZE - len(data))
    rates = data[0:6]
    levels = data[8:20]
    times = [struct.unpack_from('<12H', data, 20 + 24 * k) for k in range(3)]

    def slots(offset, count):
        return [{'level_min': data[offset + 4 * i], 'level_max': data[offset + 4 * i + 1],
                 'species': species(struct.unpack_from('<H', data, offset + 4 * i + 2)[0])} for i in range(count)]

    swarm = struct.unpack_from('<4H', data, 0xBC)
    return {
        'land': {'rate': rates[0], 'slots': [{'level': levels[i], 'morning': species(times[0][i]),
                                              'day': species(times[1][i]), 'night': species(times[2][i])}
                                             for i in range(12)]},
        'surf': {'rate': rates[1], 'slots': slots(0x64, 5)},
        'rock_smash': {'rate': rates[2], 'slots': slots(0x78, 2)},
        'old_rod': {'rate': rates[3], 'slots': slots(0x80, 5)},
        'good_rod': {'rate': rates[4], 'slots': slots(0x94, 5)},
        'super_rod': {'rate': rates[5], 'slots': slots(0xA8, 5)},
        'radio_hoenn': [species(n) for n in struct.unpack_from('<2H', data, 0x5C)],
        'radio_sinnoh': [species(n) for n in struct.unpack_from('<2H', data, 0x60)],
        'swarm': {'land': species(swarm[0]), 'surf': species(swarm[1]), 'night_fishing': species(swarm[2]),
                  'fishing': species(swarm[3])},
    }


def main():
    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache/sacredgold.nds')
    rom = ndspy.rom.NintendoDSRom.fromFile(rom_path)
    tables = [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName('a/0/3/7')).files]
    maps = [e['map'] for e in json.load(open(os.path.join(HG, 'files/fielddata/encountdata/gs_enc_data.json')))[
        'encounters']]
    assert len(maps) == len(tables), (len(maps), len(tables))
    lookup = Lookup()

    def species(n):
        return lookup('SPECIES_', n) if n else 'SPECIES_NONE'

    os.makedirs(OUT, exist_ok=True)
    for bank, data in enumerate(tables):
        out = {'map': maps[bank], **table(data, species)}
        with open(os.path.join(OUT, f'encounters_hgss_{bank:03d}.json'), 'w', encoding='utf-8') as f:
            f.write(json.dumps(out, indent=4) + '\n')
    print(f'{len(tables)} encounter tables from {os.path.basename(rom_path)} in {os.path.relpath(OUT, ROOT)}')
    if lookup.missing:
        print('not in Sovereign\'s lists:', ' '.join(sorted(lookup.missing)))


if __name__ == '__main__':
    main()
