#!/usr/bin/env python3
# Sovereign Complete: one of Johto's or Kanto's wild Pokémon tables (res/field/encounters/hgss/*.json,
# tools/complete/import_hgss_encounters.py) into HeartGold's binary layout (EncounterData, 0xC4 bytes), which
# src/complete_encounters.c reads.
import json
import pathlib
import struct
import sys

from generated import species


def as_species(s: str) -> int:
    return species.Species[s].value


def slots(table: dict, count: int) -> bytes:
    return b''.join(struct.pack('<BBH', s['level_min'], s['level_max'], as_species(s['species']))
                    for s in table['slots'][:count])


input_path = pathlib.Path(sys.argv[1])
output_path = pathlib.Path(sys.argv[2])
data = json.load(open(input_path, 'r', encoding='utf-8'))

land = data['land']['slots']
out = bytearray()
out += bytes([data['land']['rate'], data['surf']['rate'], data['rock_smash']['rate'], data['old_rod']['rate'],
              data['good_rod']['rate'], data['super_rod']['rate'], 0, 0])
out += bytes(s['level'] for s in land)
for time in ('morning', 'day', 'night'):
    out += struct.pack('<12H', *(as_species(s[time]) for s in land))
out += struct.pack('<2H', *(as_species(s) for s in data['radio_hoenn']))
out += struct.pack('<2H', *(as_species(s) for s in data['radio_sinnoh']))
out += slots(data['surf'], 5) + slots(data['rock_smash'], 2)
out += slots(data['old_rod'], 5) + slots(data['good_rod'], 5) + slots(data['super_rod'], 5)
swarm = data['swarm']
out += struct.pack('<4H', *(as_species(swarm[k]) for k in ('land', 'surf', 'night_fishing', 'fishing')))
assert len(out) == 0xC4, len(out)

with open(output_path, 'wb') as output_file:
    output_file.write(out)
