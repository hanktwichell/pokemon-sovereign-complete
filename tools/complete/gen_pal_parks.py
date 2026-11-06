#!/usr/bin/env python3
"""The two Pal Parks (the owner's call, Nov 6, 2026): Sinnoh's, Sovereign's Regional Forms Park on Route 221, with
Hisui's and Paldea's forms, and Kanto's, HeartGold's Pal Park by Fuchsia City, with Alola's and Galar's.

From data/complete/pal_parks.yaml this writes:
- decomp/include/data/complete_pal_parks.h: each park's zones (a quadrant of its map each), read by
  src/overlay006/wild_encounters.c in place of Sovereign's include/data/regional_forms_park.h;
- docs/PalParks.md: each zone's Pokémon, odds and levels;
- decomp/res/field/encounters/sovereign_regional_forms_park.json: Sinnoh's park's species on the Pokédex's area map,
  at Route 221's spot (Sovereign's tools/engine/gen_regional_forms_park.py writes it from Sovereign's park);
- Sinnoh's park's texts that name where each region's forms are (the worker, the zones' signs, the lobby's welcome
  and the keeper's log), in Sovereign's decomp/res/text/pal_park.json and pal_park_lobby.json. JSON can't hold a
  comment: this script is the record of those edits; rerun it if a sync clashes on them.

Kanto's park's own lines are Complete's (common_strings.json, CommonScript_CompletePalPark* in scripts_common.s,
called from the Fuchsia lobby's and the park's scripts by tools/complete/translate_hgss_scripts.py's inserts).

Usage: python3 tools/complete/gen_pal_parks.py
"""
import json
import os
import sys

import yaml

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'engine'))
import gen_forms  # noqa: E402

DATA = os.path.join(ROOT, 'data', 'complete', 'pal_parks.yaml')
OUT = os.path.join(DECOMP, 'include', 'data', 'complete_pal_parks.h')
DOC = os.path.join(ROOT, 'docs', 'PalParks.md')
ENC = os.path.join(DECOMP, 'res', 'field', 'encounters')
AREA_OUT = os.path.join(ENC, 'sovereign_regional_forms_park.json')
AREA_ENCOUNTERS = os.path.join(ENC, 'encounters_route_221.json')
QUADRANTS = 4

# Sinnoh's park's lines that say where the forms are (Sovereign's message IDs: the signs keep their old regions'
# names, by the quadrant each stands in; Alola's and Galar's log pages are no longer in its menu)
SINNOH_TEXTS = {
    'pal_park.json': {
        'PalPark_Text_SovereignWorker': ['Hisui’s forms are in the forest and\n', 'on the mountain, Paldea’s in the\f',
                                         'field and out at sea.\r', 'Would you like to leave the park?'],
        'PalPark_Text_SovereignSignAlola': ['Paldea Zone\n', 'The field: tall grass'],
        'PalPark_Text_SovereignSignGalar': ['Hisui Zone\n', 'The forest: tall grass'],
        'PalPark_Text_SovereignSignHisui': ['Hisui Zone\n', 'The mountain and its lake'],
        'PalPark_Text_SovereignSignPaldea': ['Paldea Zone\n', 'The sea: Surf and fish'],
    },
    'pal_park_lobby.json': {
        'PalParkLobby_Text_SovereignZones': ['Each region’s forms keep to their\n', 'own part of the park.\r',
                                             'Hisui’s are in the forest and on\n', 'the mountain, Paldea’s in the\f',
                                             'field and out at sea.\r', 'Bring your own Poké Balls. Enjoy!\r'],
        'PalParkLobby_Text_SovereignLogHisui': ['“HISUI: in the forest and on the\n', 'mountain, to the north.\r',
                                                'A Growlithe with a mane of stone.\n',
                                                'A Qwilfish bristling with dark spikes.\r',
                                                'Hisui is no faraway land. It is Sinnoh,\n',
                                                'long ago. These came from the past.”\r'],
        'PalParkLobby_Text_SovereignLogPaldea': ['“PALDEA: in the field and out at\n', 'sea, to the south.\r',
                                                 'A brown Wooper that stings. A Tauros\n',
                                                 'that charged out of the waves.\r',
                                                 'It shook off the water and stood\n',
                                                 'there, as if it had always lived here.”\r'],
    },
}


def main():
    data = yaml.safe_load(open(DATA, encoding='utf-8'))
    forms = {f['ident']: f for f in gen_forms.load_rows() if 'ident' in f}
    tables, parks, doc = [], [], [DOC_INTRO]
    seen = {}
    for p, park in enumerate(data['parks']):
        zones = park['zones']
        if len(zones) != QUADRANTS:
            sys.exit(f"{park['name']}: {len(zones)} zones, want one per quadrant ({QUADRANTS})")
        rows = []
        doc.append(f"\n## {park['name']}'s Pal Park\n")
        for q, zone in enumerate(zones):
            refs = []
            doc.append(f"\n### {zone['name']}: {zone['place']}\n")
            for terrain, label in (('grass', 'Tall grass'), ('water', 'Surfing and fishing')):
                entries = zone[terrain] or []
                if not entries:
                    refs.append('NULL, 0')
                    continue
                key = json.dumps(entries)
                if key not in seen:  # a list two zones share is one table
                    name = f"sCompletePalPark{park['name']}{zone['name']}{terrain.capitalize()}{q}"
                    lines = []
                    for ident, weight, lo, hi in entries:
                        if ident not in forms:
                            sys.exit(f"{park['name']} {zone['name']} {terrain}: {ident} isn't a form gen_forms.py builds")
                        if not (1 <= weight <= 255 and 1 <= lo <= hi <= 100):
                            sys.exit(f"{park['name']} {zone['name']} {terrain}: {ident} has a bad weight or level range")
                        f = forms[ident]
                        lines.append(f"    {{ {f['species']}, {f['number']}, {weight}, {lo}, {hi} }}, // {f['name']}\n")
                    tables.append(f"static const CompletePalParkEntry {name}[] = {{\n{''.join(lines)}}};\n")
                    seen[key] = name
                refs.append(f'{seen[key]}, NELEMS({seen[key]})')
                total = sum(e[1] for e in entries)
                doc.append(f'\n{label}:\n\n| Pokémon | Odds | Levels |\n|---|---|---|\n')
                for ident, weight, lo, hi in entries:
                    levels = f'{lo}' if lo == hi else f'{lo}–{hi}'
                    doc.append(f"| {forms[ident]['name'].removeprefix('Standard ')} | {100 * weight / total:.0f}% "
                               f'| {levels} |\n')
            rows.append(f"        {{ {refs[0]}, {refs[1]} }}, // {zone['name']}, {zone['place']}\n")
        parks.append(f"    {{ {park['map']}, {{\n{''.join(rows)}    }} }}, // {park['name']}\n")

    with open(OUT, 'w', encoding='utf-8') as out:
        out.write(f"""// Generated by tools/complete/gen_pal_parks.py from data/complete/pal_parks.yaml. Do not edit.
#ifndef POKEPLATINUM_DATA_COMPLETE_PAL_PARKS_H
#define POKEPLATINUM_DATA_COMPLETE_PAL_PARKS_H

#include "generated/map_headers.h"
#include "generated/species.h"

typedef struct CompletePalParkEntry {{
    u16 species;
    u8 form;
    u8 weight;
    u8 minLevel;
    u8 maxLevel;
}} CompletePalParkEntry;

typedef struct CompletePalParkZone {{
    const CompletePalParkEntry *grass;
    u8 grassCount;
    const CompletePalParkEntry *water;
    u8 waterCount;
}} CompletePalParkZone;

typedef struct CompletePalPark {{
    u16 mapHeaderID;
    // One zone per quadrant of the map: north-west, north-east, south-west, south-east
    CompletePalParkZone zones[{QUADRANTS}];
}} CompletePalPark;

{chr(10).join(tables)}
static const CompletePalPark sCompletePalParks[] = {{
{''.join(parks)}}};

#endif // POKEPLATINUM_DATA_COMPLETE_PAL_PARKS_H
""")

    sinnoh = next(p for p in data['parks'] if p['map'] == 'MAP_HEADER_PAL_PARK')
    category = json.load(open(AREA_ENCOUNTERS, encoding='utf-8'))['map_category']
    species = [forms[e[0]]['species'] for z in sinnoh['zones'] for t in ('grass', 'water') for e in z[t] or []]
    with open(AREA_OUT, 'w', encoding='utf-8') as out:
        json.dump({'generated': 'by tools/complete/gen_pal_parks.py from data/complete/pal_parks.yaml; do not edit',
                   'map_type': category['map_type'], 'map_number': category['map_number'],
                   'species': list(dict.fromkeys(species))}, out, indent=4, ensure_ascii=False)
        out.write('\n')

    for bank, texts in SINNOH_TEXTS.items():
        path = os.path.join(DECOMP, 'res', 'text', bank)
        raw = open(path, encoding='utf-8').read()
        indent = len(raw.split('\n')[1]) - len(raw.split('\n')[1].lstrip())  # the file's own layout
        text = json.loads(raw)
        ids = {m['id']: m for m in text['messages']}
        for key, lines in texts.items():
            ids[key]['en_US'] = lines
        with open(path, 'w', encoding='utf-8') as out:
            json.dump(text, out, indent=indent, ensure_ascii=False)
            out.write('\n')

    with open(DOC, 'w', encoding='utf-8') as out:
        out.write(''.join(doc))
    count = {p['name']: len({e[0] for z in p['zones'] for t in ('grass', 'water') for e in z[t] or []})
             for p in data['parks']}
    print(f'wrote {OUT}: ' + ', '.join(f'{n} forms in {k}\'s park' for k, n in count.items()))


DOC_INTRO = """# Pal Parks

Generated by `tools/complete/gen_pal_parks.py` from `data/complete/pal_parks.yaml`. Do not edit.

The regional forms live in two Pal Parks (the owner's call, Nov 6, 2026):
- **Sinnoh's**, Pal Park's grounds on Route 221: Sovereign's Regional Forms Park (`docs/RegionalFormsPark.md` has
  Sovereign's own lists), open after the Hall of Fame, with **Hisui's** forms in the forest and on the mountain and
  **Paldea's** in the field and at sea. Its levels move up with Sinnoh's (`data/complete/sinnoh.yaml`), to about 79–87.
- **Kanto's**, HeartGold's Pal Park by Fuchsia City, open as soon as the player gets there, with **Alola's** forms in
  the west's tall grass and **Galar's** in the east, its water forms in the pond and the lake. There's no Catching
  Show: the receptionist lets the player in, and they catch with their own Poké Balls. The worker by the gate, or
  stepping into the gate, takes them back out. Its levels are Sovereign's scaled down to fit Kanto (5/7: the
  Galarian birds at Lv. 50).

Each park's map is split into quadrants; an encounter in a quadrant's tall grass or water picks one of its Pokémon by
the odds below, at a random level in its range. Every regional form is in one of the parks.
"""


if __name__ == '__main__':
    main()
