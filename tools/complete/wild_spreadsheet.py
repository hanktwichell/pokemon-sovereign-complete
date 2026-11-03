#!/usr/bin/env python3
"""Write the wild Pokémon spreadsheet (docs/WildPokemon.xlsx): every place in Johto, Kanto and Sinnoh, each way a
Pokémon is met there and its odds, from the game's own data.

Two sheets:
- By Location: region, place, area or floor, method, time of day, Pokémon, National Dex number, levels, odds, notes,
  and whether the Pokémon is one tools/complete/gen_wild.py mixed in. In story order by region.
- By Pokémon: the same encounters by National Dex number, with Johto, Kanto and Sinnoh flags for where each Pokémon
  can be met (formulas over the first sheet), and a row for each Pokémon met nowhere in the wild (how it's had
  instead, from data/species.csv).

The odds are the engine's slot odds (src/overlay006/wild_encounters.c): walking 20/20/10/10/10/10/5/5/4/4/1/1, surfing
and the Old Rod 60/30/5/4/1, the Good and Super Rods 40/40/15/4/1, Rock Smash 80/20, Headbutt 50/15/15/10/5/5, the
Safari Zone's ten slots alike, the Bug-Catching Contest's own (src/complete_bug_contest.c). A Pokémon in several slots
of a table has their odds added. Special encounters replace slots of the walking table when they're on: Platinum's
swarm (slots 0-1), the Poké Radar (4, 5, 10, 11), the Trophy Garden's and the Great Marsh's daily Pokémon (6-7), a
Game Boy Advance game in the DS (8-9) and HeartGold's outbreaks (walking 0-1, surfing 0, the Old Rod 2, the Good Rod
0, 2 and 3, every Super Rod slot); their rows give those slots' odds, with what turns them on in the notes. In Johto
and Kanto the Good Rod's slot 3 and the Super Rod's slot 1 have the map's night species at night (HeartGold's night
fishing), so those rods have a row for the morning and day and one for the night. Static encounters, gifts and trades aren't listed (the legendaries are
moving between the regions).

Usage: python3 tools/complete/wild_spreadsheet.py [OUT]   (default docs/WildPokemon.xlsx)
"""
import collections
import csv
import glob
import json
import os
import re
import sys

import yaml
from openpyxl import Workbook
from openpyxl.formatting.rule import FormulaRule
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.utils import get_column_letter

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
ENC = os.path.join(DECOMP, 'res', 'field', 'encounters')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'engine'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'complete'))
from gen_wild_encounters import AREA_FILES  # noqa: E402

LAND = [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
RODS = {'surf': [60, 30, 5, 4, 1], 'old_rod': [60, 30, 5, 4, 1], 'good_rod': [40, 40, 15, 4, 1],
        'super_rod': [40, 40, 15, 4, 1]}
# HeartGold's night fishing and fishing outbreaks (src/complete_encounters.c, CompleteEncounters_FishingSpecies): the
# slot the night species takes, and the slots the outbreak species takes
NIGHT_FISHING = {'good_rod': 3, 'super_rod': 1}
OUTBREAK_RODS = {'old_rod': (2,), 'good_rod': (0, 2, 3), 'super_rod': (0, 1, 2, 3, 4)}
WATER_NAMES = {'surf': 'Surfing', 'old_rod': 'Old Rod', 'good_rod': 'Good Rod', 'super_rod': 'Super Rod'}
HEADBUTT = [50, 15, 15, 10, 5, 5]
TIMES = ('Morning', 'Day', 'Night')
REGIONS = ('Johto', 'Kanto', 'Sinnoh')
FILLS = {'Johto': 'F2E2B3', 'Kanto': 'F4CFCB', 'Sinnoh': 'D9E2F5'}
KANTO = {'PalletTown', 'ViridianCity', 'PewterCity', 'CeruleanCity', 'VermilionCity', 'LavenderTown', 'CeladonCity',
         'FuchsiaCity', 'SaffronCity', 'CinnabarIsland', 'MtMoon', 'RockTunnel', 'SeafoamIslands', 'DiglettsCave',
         'ViridianForest', 'CeruleanCave', 'PowerPlant', 'VictoryRoadJk', 'IndigoPlateau', 'Route26', 'Route27',
         'Route28', 'TohjoFalls'} | {f'Route{n}' for n in range(1, 26)}
GBA = {'ruby': 'Ruby', 'sapphire': 'Sapphire', 'emerald': 'Emerald', 'firered': 'FireRed', 'leafgreen': 'LeafGreen'}


def words(name):
    """'UNION_CAVE_B1F' or 'UnionCave' -> 'Union Cave B1F'."""
    if '_' in name or name.isupper():
        return ' '.join(w if re.match(r'^(B?\d+F|[A-Z]?\d+[A-Z]?)$', w) else w.title() for w in name.split('_'))
    return re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', name).replace('Mt ', 'Mt. ').replace('Jk', '')


def headers():
    """[(header name, wild table name or None, location label)] for every map."""
    src = open(os.path.join(DECOMP, 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    out = []
    for m in re.finditer(r'\[MAP_HEADER_(\w+)\]\s*=\s*\{(.*?)\}', src, re.S):
        wild = re.search(r'wildEncountersArchiveID = (\w+)', m.group(2)).group(1)
        label = re.search(r'mapLabelTextID = LocationNames_Text_(\w+)', m.group(2))
        out.append((m.group(1), None if 'NONE' in wild.upper() else wild, label.group(1) if label else 'Unknown'))
    return out


class Sheet:
    def __init__(self):
        self.rows = []
        self.bank_where = {}  # a Johto or Kanto map header -> its (region, place, area) and table
        self.sinnoh_where = {}  # a Sinnoh map header -> its (region, place, area)

    def add(self, region, place, area, method, time, species, levels, odds, notes='', order=0):
        if species in (None, 'SPECIES_NONE', 0):
            return
        self.rows.append({'region': region, 'place': place, 'area': area, 'method': method, 'time': time,
                          'species': species, 'levels': levels, 'odds': odds, 'notes': notes, 'order': order})


def area_name(place, areas):
    """The rooms or floors of a place that share a table, without the place's name: 'Union Cave 1F' -> '1F'."""
    if len(areas) >= 6:
        return f'{len(areas)} rooms'
    out = []
    for a in areas:
        short = a[len(place):].strip() if a.startswith(place) else a
        if place.startswith(short) or short == place:
            short = ''
        out.append(short)
    return ', '.join(x for x in dict.fromkeys(out) if x)


def level_text(low, high):
    return str(low) if low == high else f'{low}–{high}'


def table_rows(sheet, where, method, time, slots, rates, notes='', only=None):
    """One row per Pokémon in these slots: [(species, low, high)], their odds added."""
    odds, low, high = collections.Counter(), {}, {}
    for i, ((species, lo, hi), rate) in enumerate(zip(slots, rates)):
        if only is not None and i not in only:
            continue
        if species and species != 'SPECIES_NONE' and (lo or hi):
            odds[species] += rate
            low[species] = min(low.get(species, 999), lo)
            high[species] = max(high.get(species, 0), hi)
    for species, p in odds.items():
        sheet.add(*where, method, time, species, level_text(low[species], high[species]), p / 100, notes)


def johto_kanto(sheet, maps):
    """HeartGold's tables (gen_wild.py's), outbreaks, Headbutt trees, the Safari Zone, the Bug-Catching Contest."""
    by_bank = collections.defaultdict(list)
    for header, wild, label in maps:
        if header.startswith('HGSS_') and wild:
            by_bank[wild].append((header[5:], label))
    for path in sorted(glob.glob(os.path.join(ENC, 'hgss', 'encounters_hgss_*.json'))):
        bank = os.path.basename(path)[:-5]
        if bank not in by_bank:
            continue
        t = json.load(open(path, encoding='utf-8'))
        label = by_bank[bank][0][1]
        place = words(label)
        areas = [words(h) for h, _ in by_bank[bank]]
        region = 'Kanto' if label in KANTO else 'Johto'
        where = (region, place, area_name(place, areas))
        if t['land']['rate']:
            for key, time in zip(('morning', 'day', 'night'), TIMES):
                table_rows(sheet, where, 'Walking (grass, cave floor)', time,
                           [(s[key], s['level'], s['level']) for s in t['land']['slots']], LAND)
        for kind, rates in RODS.items():
            if t[kind]['rate']:
                slots = [(s['species'], s['level_min'], s['level_max']) for s in t[kind]['slots']]
                night = t['swarm']['night_fishing']
                if kind in NIGHT_FISHING and night not in ('SPECIES_NONE', slots[NIGHT_FISHING[kind]][0]):
                    # HeartGold's night fishing: at night one slot has the map's night species
                    at_night = list(slots)
                    at_night[NIGHT_FISHING[kind]] = (night, *slots[NIGHT_FISHING[kind]][1:])
                    table_rows(sheet, where, WATER_NAMES[kind], 'Morning, Day', slots, rates)
                    table_rows(sheet, where, WATER_NAMES[kind], 'Night', at_night, rates)
                else:
                    table_rows(sheet, where, WATER_NAMES[kind], 'Any', slots, rates)
        if t['rock_smash']['rate']:
            table_rows(sheet, where, 'Rock Smash', 'Any',
                       [(s['species'], s['level_min'], s['level_max']) for s in t['rock_smash']['slots']], [80, 20],
                       f'A smashed rock holds a Pokémon {t["rock_smash"]["rate"]}% of the time')
        for header, _ in by_bank[bank]:
            sheet.bank_where[header] = (where, t)

    # HeartGold's outbreaks (src/complete_encounters.c's sOutbreakMaps)
    src = open(os.path.join(DECOMP, 'src', 'complete_encounters.c'), encoding='utf-8').read()
    for header, terrain in re.findall(r'\{ MAP_HEADER_HGSS_(\w+), OUTBREAK_(\w+) \}', src):
        where, t = sheet.bank_where.get(header, (None, None))
        if not where:
            continue
        note = 'On the day the news reports an outbreak here, from Oak\'s National Pokédex on'
        if terrain == 'LAND' and t['swarm']['land'] != 'SPECIES_NONE':
            lv = [s['level'] for s in t['land']['slots'][:2]]
            sheet.add(*where, 'Mass outbreak (walking)', 'Any', t['swarm']['land'], level_text(min(lv), max(lv)), 0.4,
                      note)
        elif terrain == 'SURF' and t['swarm']['surf'] != 'SPECIES_NONE':
            s = t['surf']['slots'][0]
            sheet.add(*where, 'Mass outbreak (surfing)', 'Any', t['swarm']['surf'],
                      level_text(s['level_min'], s['level_max']), 0.6, note)
        elif terrain == 'FISHING' and t['swarm']['fishing'] != 'SPECIES_NONE':
            for kind, slots in OUTBREAK_RODS.items():
                if t[kind]['rate']:
                    got = [t[kind]['slots'][i] for i in slots]
                    sheet.add(*where, f'Mass outbreak ({WATER_NAMES[kind]})', 'Any', t['swarm']['fishing'],
                              level_text(min(x['level_min'] for x in got), max(x['level_max'] for x in got)),
                              sum(RODS[kind][i] for i in slots) / 100, note)

    # Headbutt trees (include/data/hgss_field_encounters.h)
    src = open(os.path.join(DECOMP, 'include', 'data', 'hgss_field_encounters.h'), encoding='utf-8').read()
    for m in re.finditer(r'\{ MAP_HEADER_HGSS_(\w+), (\d+), (\d+), \d+, \d+, \{\n(.*?)\n    \} \}', src, re.S):
        where, _ = sheet.bank_where.get(m.group(1), (None, None))
        if not where:
            label = 'Unknown'
            for header, wild, lab in maps:
                if header == 'HGSS_' + m.group(1):
                    label = lab
            region = 'Kanto' if label in KANTO else 'Johto'
            where = (region, words(label), area_name(words(label), [words(m.group(1))]))
        kinds = re.findall(r'\{ (\{ SPECIES.*?\}) \}', m.group(4))
        for kind, name in zip(kinds, ('common trees', 'rare trees', 'secret trees')):
            slots = [(s, int(lo), int(hi)) for s, lo, hi in re.findall(r'\{ (SPECIES_\w+), (\d+), (\d+) \}', kind)]
            note = 'Which trees are rare goes by the player\'s Trainer ID' if name == 'rare trees' else ''
            if name == 'secret trees':
                note = 'Trees off the usual rows (HeartGold\'s secret trees)'
            table_rows(sheet, where, f'Headbutt ({name})', 'Any', slots, HEADBUTT, note)

    # the Safari Zone (include/data/complete_safari.h): the ten base slots of each area, then the bonus Pokémon
    src = open(os.path.join(DECOMP, 'include', 'data', 'complete_safari.h'), encoding='utf-8').read()
    body = src[src.index('sSafariEncounters'):src.index('sSafariDefaultAreaSets')]
    for m in re.finditer(r'\[SAFARI_ZONE_AREA_(\w+)\] = \{(.*?)\n    \},', body, re.S):
        area = m.group(1).replace('_', ' ').title()
        types = re.split(r'\n        \{\n', m.group(2))[1:]
        for kind, block in zip(('Walking (grass)', 'Surfing', 'Old Rod', 'Good Rod', 'Super Rod'), types):
            base = re.search(r'\.base = \{(.*?)\n            \},', block, re.S)
            if base:
                for time, line in zip(TIMES, re.findall(r'\{ (\{ SPECIES.*?\}) \},?\n', base.group(1))):
                    slots = [(s, int(lv), int(lv)) for s, lv in re.findall(r'\{ (SPECIES_\w+), (\d+) \}', line)]
                    table_rows(sheet, ('Johto', 'Safari Zone', area), f'Safari Zone: {kind}', time, slots, [10] * 10,
                               'Each area\'s table as HeartGold has it; objects placed bring out the bonus Pokémon')
            for mons, needs in re.findall(r'\{ \{ (\{ SPECIES.*?\}) \}, \{ (\{ SAFARI.*?\}) \} \}', block):
                need = ', '.join(f'{n} {o.replace("SAFARI_ZONE_OBJECT_TYPE_", "").title()} objects' for o, n in
                                 re.findall(r'\{ (SAFARI_ZONE_OBJECT_TYPE_\w+), (\d+) \}', needs) if 'NONE' not in o)
                for time, (s, lv) in zip(TIMES, re.findall(r'\{ (SPECIES_\w+), (\d+) \}', mons)):
                    sheet.add('Johto', 'Safari Zone', area, f'Safari Zone bonus: {kind}', time, s, lv, None,
                              f'Takes one of the first slots (10% each) once the area has {need}')

    # the Bug-Catching Contest (include/data/complete_bug_contest.h): cumulative thresholds
    src = open(os.path.join(DECOMP, 'include', 'data', 'complete_bug_contest.h'), encoding='utf-8').read()
    sets = re.findall(r'\{\n((?:\s+\{ SPECIES_\w+, \d+, \d+, \d+, \d+ \},\n)+)\s+\}', src)
    for name, block in zip(('before the National Pokédex', 'Tuesdays', 'Thursdays', 'Saturdays'), sets):
        last = 100
        for s, lo, hi, threshold, _ in re.findall(r'\{ (SPECIES_\w+), (\d+), (\d+), (\d+), (\d+) \}', block):
            sheet.add('Johto', 'National Park', f'Contest: {name}', 'Bug-Catching Contest', 'Any', s,
                      level_text(int(lo), int(hi)),
                      (last - int(threshold)) / 100,
                      f'Tuesdays, Thursdays and Saturdays; this set: {name}' if name.startswith('before') else
                      f'With the National Pokédex, on {name}')
            last = int(threshold)

    for species, region, level, note in (('SPECIES_RAIKOU', 'Johto', '40', 'Released in Burned Tower B1F'),
                                         ('SPECIES_ENTEI', 'Johto', '40', 'Released in Burned Tower B1F'),
                                         ('SPECIES_LATIAS', 'Kanto', '35', 'Released by Steven in Vermilion City')):
        sheet.add(region, f'{region}\'s routes', '', 'Roaming', 'Any', species, level, None, note)


def sinnoh(sheet, maps):
    """Platinum's tables (gen_wild.py's) and its special encounters, Sovereign's Honey Trees, park and rare wild."""
    by_table = collections.defaultdict(list)
    for header, wild, label in maps:
        if not header.startswith('HGSS_') and wild:
            by_table[wild].append((header, label))
    story = [stem for stems in AREA_FILES.values() for stem in stems]
    swarm_src = open(os.path.join(DECOMP, 'src', 'overlay006', 'swarm.c'), encoding='utf-8').read()
    swarm_maps = set(re.findall(r'MAP_HEADER_(\w+)', swarm_src[swarm_src.index('sSwarmMapIdTable'):]))
    stems = sorted((os.path.basename(p)[len('encounters_'):-5] for p in glob.glob(os.path.join(ENC, 'encounters_*.json'))),
                   key=lambda s: (story.index(s) if s in story else len(story), s))
    for stem in stems:
        users = by_table.get(f'encounters_{stem}')
        if not users:
            continue
        t = json.load(open(os.path.join(ENC, f'encounters_{stem}.json'), encoding='utf-8'))
        if 'land_rate' not in t:
            continue
        label = users[0][1]
        place = words(label)
        areas = [words(h) for h, _ in users]
        where = ('Sinnoh', place, area_name(place, areas))
        for header, _ in users:
            sheet.sinnoh_where[header] = where
        if t['land_rate']:
            base = [(s['species'], s['level'], s['level']) for s in t['land_encounters']]
            for time, swap in zip(TIMES, (None, t['day'], t['night'])):
                slots = list(base)
                if swap:
                    for i in (2, 3):
                        slots[i] = (swap[i - 2], base[i][1], base[i][2])
                table_rows(sheet, where, 'Walking (grass, cave floor)', time, slots, LAND)

            def special(method, species, slots, note):
                if [s for s in species] == [base[i][0] for i in slots]:
                    return  # the same Pokémon as the slots it replaces
                table_rows(sheet, where, method, 'Any',
                           [(s, base[i][1], base[i][2]) for s, i in zip(species, slots)], [LAND[i] for i in slots],
                           note)

            if any(h in swarm_maps for h, _ in users):
                special('Swarm', t['swarms'], (0, 1), 'On the day TV news reports a swarm here')
            special('Poké Radar', t['radar'], (4, 5, 10, 11), 'In the grass the Poké Radar shakes')
            for key, game in GBA.items():
                special(f'Dual-slot ({game})', t[key], (8, 9),
                        f'With Pokémon {game} in the DS\'s Game Boy Advance slot (DS and DS Lite only)')
        for kind, rates in RODS.items():
            if t[f'{kind}_rate']:
                table_rows(sheet, where, WATER_NAMES[kind], 'Any',
                           [(s['species'], s['level_min'], s['level_max']) for s in t[f'{kind}_encounters']], rates)

    # the Trophy Garden's and the Great Marsh's daily Pokémon (slots 6 and 7, 5% each)
    tg = json.load(open(os.path.join(ENC, 'encounters_trophy_garden.json'), encoding='utf-8'))
    garden = sheet.sinnoh_where.get('TROPHY_GARDEN', ('Sinnoh', 'Trophy Garden', ''))
    for key in ('daily_encounters',):
        if isinstance(tg.get(key), list):
            for s in dict.fromkeys(tg[key]):
                sheet.add(*garden, 'Daily Pokémon (Mr. Backlot)', 'Any', s, '', 0.05,
                          'Two of these each day, after talking to Mr. Backlot; 5% each')
    marsh = json.load(open(os.path.join(ENC, 'encounters_great_marsh_lookout.json'), encoding='utf-8'))
    for key, when in (('before_national_dex', 'before the National Pokédex'),
                      ('after_national_dex', 'with the National Pokédex')):
        for s in dict.fromkeys(marsh[key]):
            sheet.add('Sinnoh', 'Great Marsh', 'Any area', 'Daily Pokémon (binoculars)', 'Any', s, '', 0.1,
                      f'One of these each day ({when}), seen through the lookout\'s binoculars; slots 6 and 7')

    # Sovereign's Honey Trees (include/data/sovereign_honey_trees.h)
    src = open(os.path.join(DECOMP, 'include', 'data', 'sovereign_honey_trees.h'), encoding='utf-8').read()
    for level, entries, header, name in re.findall(
            r'\{ (\d+), \d+, \{ (.*?) \} \}, // MAP_HEADER_(\w+) \((.*?)\)', src):
        where = sheet.sinnoh_where.get(header, ('Sinnoh', words(name.split(' ~ ')[0]), ''))
        for s, p in re.findall(r'\{ (SPECIES_\w+), (\d+) \}', entries):
            sheet.add(*where, 'Honey Tree', 'Any', s, level, int(p) / 100, 'Slather Honey, come back 6 hours later')

    # Sovereign's roamers (src/roaming_pokemon.c), released by the Legend Archivist in Canalave Library
    for species, level, note in (('ZERAORA', 50, 'the Alola Chronicle'), ('TORNADUS', 65, 'the Unova Chronicle'),
                                 ('THUNDURUS', 65, 'the Unova Chronicle'), ('OKIDOGI', 65, 'the Paldea Chronicle'),
                                 ('MUNKIDORI', 65, 'the Paldea Chronicle'), ('FEZANDIPITI', 65, 'the Paldea Chronicle'),
                                 ('GLASTRIER', 70, 'the Galar Chronicle, after Calyrex'),
                                 ('SPECTRIER', 70, 'the Galar Chronicle, after Calyrex')):
        sheet.add('Sinnoh', 'Sinnoh\'s routes', '', 'Roaming', 'Any', f'SPECIES_{species}', str(level), None,
                  f'Released by the Legend Archivist in Canalave Library ({note}, after the Hall of Fame)')

    # Sovereign's Regional Forms Park and rare wild Pokémon
    forms = {r['identifier']: r for r in csv.DictReader(open(os.path.join(ROOT, 'data', 'forms.csv'), encoding='utf-8'))}
    park = yaml.safe_load(open(os.path.join(ROOT, 'data', 'regional_forms_park.yaml'), encoding='utf-8'))
    for zone in park['zones']:
        for terrain in ('grass', 'water'):
            entries = zone.get(terrain) or []
            total = sum(e[1] for e in entries)
            for ident, weight, lo, hi in entries:
                form = forms.get(ident, {})
                sheet.add('Sinnoh', 'Regional Forms Park', f'{zone["name"]} zone',
                          'Walking (grass)' if terrain == 'grass' else 'Surfing', 'Any',
                          ('FORM', form.get('form', ident), int(form.get('dex', 0) or 0)), level_text(lo, hi),
                          weight / total, 'Pal Park\'s grounds at the end of Route 221 (Sovereign)')
    rare = yaml.safe_load(open(os.path.join(ROOT, 'data', 'sovereign_rare_wild.yaml'), encoding='utf-8'))
    for e in rare['encounters']:
        level = e['level'] if isinstance(e['level'], int) else level_text(*e['level'])
        for header in e['maps']:
            where = sheet.sinnoh_where.get(header, ('Sinnoh', words(header), ''))
            sheet.add(*where, 'Rare wild (walking)' if e['terrain'] == 'land' else 'Rare wild (surfing)', 'Any',
                      f'SPECIES_{e["species"]}', level, e['rate'] / 100,
                      f'After {rare["gates"][e["gate"]]["text"]}' if e.get('gate') in rare['gates'] else '')


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'docs', 'WildPokemon.xlsx')
    rows = list(csv.DictReader(open(os.path.join(ROOT, 'data', 'species.csv'), encoding='utf-8')))
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'engine'))
    from gen_wild_encounters import species_constant
    known = {line.strip() for line in open(os.path.join(DECOMP, 'generated', 'species.txt')) if line.strip()}
    by_const = {species_constant(r['name'], known): r for r in rows}
    placed = set(re.findall(r'\*\*([^*]+)\*\*★', open(os.path.join(ROOT, 'docs', 'WildPokemon.md'), encoding='utf-8').read()))

    maps = headers()
    sheet = Sheet()
    johto_kanto(sheet, maps)
    sinnoh(sheet, maps)

    def name_and_dex(species):
        if isinstance(species, tuple):
            return species[1], species[2]
        r = by_const.get(species)
        return (r['name'], int(r['dex'])) if r else (words(species[8:]), 0)

    for i, row in enumerate(sheet.rows):
        row['name'], row['dex'] = name_and_dex(row['species'])
        row['new'] = 'Mixed in' if row['name'] in placed else ''
        row['seq'] = i

    wb = Workbook()
    ws = wb.active
    ws.title = 'By Location'
    cols = ['Region', 'Location', 'Area / floor', 'Method', 'Time of day', 'Pokémon', 'Dex #', 'Levels', 'Odds',
            'Notes', 'New to the wild']
    ws.append(cols)
    # by region, the places in story order, each table where it was read, the likeliest Pokémon first
    loc_rows = sorted(sheet.rows, key=lambda r: (REGIONS.index(r['region']), first_seq(sheet.rows, r),
                                                 -(r['odds'] or 0), r['seq']))
    for r in loc_rows:
        ws.append([r['region'], r['place'], r['area'], r['method'], r['time'], r['name'], r['dex'] or None,
                   r['levels'], r['odds'], r['notes'], r['new']])
    n_loc = len(loc_rows) + 1
    style(ws, cols, [9, 22, 26, 28, 11, 18, 7, 9, 8, 60, 13], n_loc)
    for row in ws.iter_rows(min_row=2, min_col=9, max_col=9):
        row[0].number_format = '0%;;-'

    ws2 = wb.create_sheet('By Pokémon')
    cols2 = ['Dex #', 'Pokémon', 'Johto', 'Kanto', 'Sinnoh', 'Region', 'Location', 'Area / floor', 'Method',
             'Time of day', 'Levels', 'Odds', 'Notes']
    ws2.append(cols2)
    seen = set()
    mon_rows = sorted(sheet.rows, key=lambda r: (r['dex'] or 9999, r['name'], REGIONS.index(r['region']), r['seq']))
    out_rows = []
    for r in mon_rows:
        out_rows.append([r['dex'] or None, r['name'], None, None, None, r['region'], r['place'], r['area'],
                         r['method'], r['time'], r['levels'], r['odds'], r['notes']])
        seen.add(r['name'])
    for r in rows:
        if r['name'] not in seen:
            how = {'legendary': 'Legendary: a one-time encounter', 'mythical': 'Mythical: a one-time encounter',
                   'paradox': 'Paradox: from the Oreburgh Mining Museum\'s dealers',
                   'ultra_beast': 'Ultra Beast'}.get(r['category'])
            if not how:
                how = f'Evolve {r["evolves_from"]} ({r["evolution_method"]})' if r['evolves_from'] else \
                    'A gift, a trade or an Egg'
            out_rows.append([int(r['dex']), r['name'], None, None, None, '', '', '', 'Not met in the wild', '', '',
                             None, how])
    out_rows.sort(key=lambda x: (x[0] or 9999, x[1]))
    first = {}
    for i, values in enumerate(out_rows, start=2):
        name = values[1]
        if name not in first:
            first[name] = i
            for c, region in zip(('C', 'D', 'E'), REGIONS):
                values[2 + 'CDE'.index(c)] = (f'=IF(COUNTIFS(\'By Location\'!$F$2:$F${n_loc},$B{i},'
                                              f'\'By Location\'!$A$2:$A${n_loc},"{region}")>0,"✓","")')
        else:
            for c in 'CDE':
                values[2 + 'CDE'.index(c)] = f'={c}{first[name]}'
        ws2.append(values)
    style(ws2, cols2, [7, 18, 7, 7, 7, 9, 22, 26, 28, 11, 9, 8, 60], len(out_rows) + 1)
    for row in ws2.iter_rows(min_row=2, min_col=12, max_col=12):
        row[0].number_format = '0%;;-'
    for row in ws2.iter_rows(min_row=2, min_col=3, max_col=5):
        for cell in row:
            cell.alignment = Alignment(horizontal='center')
    # each region's flag and region cells in its colour
    for ws_, region_col, flag_cols, last in ((ws, 'A', (), n_loc), (ws2, 'F', ('C', 'D', 'E'), len(out_rows) + 1)):
        for region in REGIONS:
            fill = PatternFill('solid', start_color=FILLS[region], end_color=FILLS[region])
            ws_.conditional_formatting.add(f'{region_col}2:{region_col}{last}',
                                           FormulaRule(formula=[f'${region_col}2="{region}"'], fill=fill))
        for c, region in zip(flag_cols, REGIONS):
            fill = PatternFill('solid', start_color=FILLS[region], end_color=FILLS[region])
            ws_.conditional_formatting.add(f'{c}2:{c}{last}', FormulaRule(formula=[f'{c}2="✓"'], fill=fill))
    os.makedirs(os.path.dirname(out), exist_ok=True)
    wb.save(out)
    regions = collections.defaultdict(set)
    for r in sheet.rows:
        regions[r['name']].add(r['region'])
    print(f'{out}: {len(loc_rows)} encounters in {len({(r["region"], r["place"], r["area"]) for r in loc_rows})} '
          f'places; {len(regions)} Pokémon met in the wild, '
          + ', '.join(f'{g} {sum(g in v for v in regions.values())}' for g in REGIONS))


def first_seq(rows, r, _cache={}):
    """The table a row belongs to keeps its place: the first row of the same place, area, method and time."""
    key = (r['region'], r['place'], r['area'], r['method'], r['time'])
    if not _cache:
        for x in rows:
            _cache.setdefault((x['region'], x['place'], x['area'], x['method'], x['time']), x['seq'])
    return _cache[key]


def style(ws, cols, widths, last):
    font = Font(name='Arial', size=10)
    bold = Font(name='Arial', size=10, bold=True, color='FFFFFF')
    head = PatternFill('solid', start_color='2B4FA3', end_color='2B4FA3')
    for row in ws.iter_rows(min_row=1, max_row=last):
        for cell in row:
            cell.font = font
    for cell in ws[1]:
        cell.font = bold
        cell.fill = head
        cell.alignment = Alignment(vertical='center')
    for i, w in enumerate(widths, start=1):
        ws.column_dimensions[get_column_letter(i)].width = w
    ws.freeze_panes = 'A2'
    ws.auto_filter.ref = f'A1:{get_column_letter(len(cols))}{last}'


if __name__ == '__main__':
    main()
