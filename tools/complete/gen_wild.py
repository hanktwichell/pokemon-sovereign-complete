#!/usr/bin/env python3
"""Johto's, Kanto's and Sinnoh's wild Pokémon: each map's own table as HeartGold/SoulSilver and Platinum have it, with
the Pokémon those tables don't have mixed in evenly over the three regions (the owner's call, Nov 1, 2026;
docs/Features.md, "Wild Pokémon").

The originals:
- Johto and Kanto: HeartGold's and SoulSilver's tables (pokeheartgold's files/fielddata/encountdata/gs_enc_data.json,
  in .cache/pokeheartgold from tools/complete/build_heartgold.sh), one table for both versions: HeartGold's, and each
  species SoulSilver's table has and HeartGold's lacks (at that time of day) in a slot where the versions differ and
  HeartGold's species is in another slot too, so it stays. Headbutt trees, the Safari Zone and the Bug-Catching
  Contest already use HeartGold's own tables (their importers).
- Sinnoh: Platinum's tables, as pret's decompilation has them (Sovereign's first commit, VANILLA_REF, which this
  fetches into .cache/sovereign as tools/complete/sync_sovereign.sh fetches Sovereign). Encounter files Platinum
  doesn't have, and the Honey Trees (Sovereign's own per-tree tables), stay as Sovereign has them.

The Pokémon mixed in: every regular species (data/species.csv: not legendary, mythical, an Ultra Beast or a Paradox
Pokémon) of a family that no original table has, so it can't be caught or evolved from a catch (Sovereign's Gen V-IX
and the older families neither game has in the wild), but for starters, which Sovereign gives at Pokémon Centers.
Each family goes to one region, the regions taking turns, so each gets a third of them; each species of it goes to one
slot there that the original table has twice (the original species keeps its other slot, so every original species
stays where it was), where the area's habitat suits its types and the area's levels reach the level it evolves at:
the earliest such area first, stronger species in rarer slots, and spread over the region's areas
(tools/design/gen_encounters.py's habitats, type weights, evolution levels and rarity, Sovereign's own rules). A
species no slot in its family's region takes goes to another region's; babies go last, where slots are left.

To change it: PIN (a species to a region or an area), AREA_TAGS (Johto's and Kanto's habitats, by place; Sinnoh's
are Sovereign's), FREE_LAND and FREE_WATER (how many of a table's slots may take a new species), REGION_ORDER.

Writes decomp/res/field/encounters/encounters_*.json (Sinnoh's), decomp/res/field/encounters/hgss/
encounters_hgss_NNN.json (Johto's and Kanto's, the layout tools/complete/import_hgss_encounters.py wrote) and
docs/WildPokemon.md (each area's tables, the new species marked, and each region's count). Re-running gives the same.

Usage: python3 tools/complete/gen_wild.py
"""
import collections
import json
import os
import re
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'design'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'engine'))
from gen_encounters import (AMPHIBIOUS_OK, FISH, STARTER_BASES, TAG_TYPES, area_tags,  # noqa: E402
                            build_level_gates, load_species, rarity)
from gen_wild_encounters import AREA_FILES, species_constant  # noqa: E402

ENC = os.path.join(ROOT, 'decomp', 'res', 'field', 'encounters')
HG_ENC = os.path.join(ROOT, '.cache', 'pokeheartgold', 'files', 'fielddata', 'encountdata', 'gs_enc_data.json')
HG_ARC = os.path.join(ROOT, '.cache', 'pokeheartgold', 'files', 'arc')
SOVEREIGN_REPO = 'https://github.com/hanktwichell/pokemon-imperial-platinum'
SOVEREIGN_CACHE = os.path.join(ROOT, '.cache', 'sovereign')
VANILLA_REF = '22fddfd4c8d3ce161f1e1a47f1c81634b396f240'  # "Add pret/pokeplatinum decompilation as decomp/"
MAP_HEADERS = os.path.join(ROOT, 'decomp', 'include', 'data', 'map_headers.h')

LAND_RATES = [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
WATER_RATES = [60, 30, 5, 4, 1]
TIMES = ('morning', 'day', 'night')
# The slots a new species may take, in the order they're offered (a 10% slot first, as Sovereign frees them), and how
# many of a table's slots may go
LAND_ORDER = [3, 5, 7, 9, 11, 2, 4, 6, 8, 10, 1, 0]
WATER_ORDER = [3, 2, 4, 1]
FREE_LAND = 4
FREE_WATER = 2
REGION_ORDER = ('johto', 'kanto', 'sinnoh')
# Gen I-IV starters, which the stories give (Sovereign's STARTER_BASES are Gen V-IX's)
OLD_STARTERS = {'Bulbasaur', 'Charmander', 'Squirtle', 'Chikorita', 'Cyndaquil', 'Totodile', 'Treecko', 'Torchic',
                'Mudkip', 'Turtwig', 'Chimchar', 'Piplup', 'Pikachu', 'Eevee'}
# Hand placements: species name -> region, or (region, area name as docs/WildPokemon.md lists it)
PIN = {}

# Johto's and Kanto's habitats, by the place's location label (TAG_TYPES' tags)
AREA_TAGS = {
    'NewBarkTown': 'sea', 'Route29': 'field', 'CherrygroveCity': 'sea', 'Route30': 'field forest',
    'Route31': 'field river', 'VioletCity': 'city lake', 'SproutTower': 'ghost', 'Route32': 'field marsh',
    'RuinsOfAlph': 'ruins', 'UnionCave': 'cave', 'Route33': 'field rain', 'SlowpokeWell': 'cave lake',
    'IlexForest': 'forest', 'Route34': 'field', 'Route35': 'field lake', 'NationalPark': 'flower field',
    'Route36': 'field forest', 'Route37': 'forest', 'EcruteakCity': 'city', 'BurnedTower': 'ghost fire',
    'BellTower': 'ruins ghost', 'Route38': 'field', 'Route39': 'field', 'OlivineCity': 'sea city',
    'Route40': 'sea beach', 'Route41': 'sea', 'WhirlIslands': 'cave sea', 'CianwoodCity': 'sea beach',
    'Route42': 'mountain lake', 'MtMortar': 'cave mountain fighting', 'Route43': 'field forest', 'LakeOfRage': 'lake',
    'Route44': 'field lake', 'IcePath': 'cave snow', 'BlackthornCity': 'lake dragon', 'DragonsDen': 'dragon lake',
    'Route45': 'mountain', 'Route46': 'mountain', 'DarkCave': 'cave', 'Route47': 'sea mountain',
    'Route48': 'field desert', 'CliffEdgeGate': 'cave sea', 'CliffCave': 'cave', 'SafariZone': 'field marsh',
    'MtMoon': 'cave fairy', 'SeafoamIslands': 'cave snow sea', 'MtSilver': 'peak mountain',
    'MtSilverCave': 'cave mountain dragon', 'Route12': 'sea', 'Route19': 'sea beach', 'Route20': 'sea',
    'PalletTown': 'sea', 'ViridianCity': 'lake city', 'CeruleanCity': 'lake city', 'VermilionCity': 'sea city',
    'CeladonCity': 'city', 'FuchsiaCity': 'lake city', 'CinnabarIsland': 'sea volcano', 'Route26': 'mountain sea',
    'Route27': 'field sea', 'Route28': 'mountain', 'RockTunnel': 'cave', 'VictoryRoadJk': 'cave dragon fighting',
    'Route1': 'field', 'Route2': 'forest field', 'Route3': 'mountain', 'Route4': 'field mountain',
    'Route5': 'field city', 'Route6': 'field river', 'Route7': 'city field', 'Route8': 'field ghost',
    'Route9': 'mountain river', 'Route10': 'electric river', 'Route11': 'field', 'Route13': 'field sea',
    'Route14': 'field forest', 'Route15': 'field', 'Route16': 'city field', 'Route17': 'sea beach',
    'Route18': 'sea beach', 'Route21': 'sea', 'Route22': 'field lake', 'Route24': 'field river', 'Route25': 'field',
    'TohjoFalls': 'cave lake', 'DiglettsCave': 'cave', 'ViridianForest': 'forest', 'CeruleanCave': 'cave psychic',
}
TAG_TYPES = dict(TAG_TYPES, fairy={'Fairy': 3, 'Normal': 1}, psychic={'Psychic': 4, 'Dark': 1})
KANTO = {'PalletTown', 'ViridianCity', 'CeruleanCity', 'VermilionCity', 'CeladonCity', 'FuchsiaCity', 'CinnabarIsland',
         'MtMoon', 'RockTunnel', 'SeafoamIslands', 'DiglettsCave', 'ViridianForest', 'CeruleanCave', 'VictoryRoadJk',
         'Route26', 'Route27', 'Route28', 'TohjoFalls'} | {f'Route{n}' for n in range(1, 26)}
SPECIES_FIXES = {}


def git(*args):
    return subprocess.run(['git', '-C', SOVEREIGN_CACHE, *args], capture_output=True, text=True, check=True).stdout


def platinum_tables():
    """{file name: Platinum's table} from pret's decompilation, as Sovereign imported it."""
    if not os.path.isdir(os.path.join(SOVEREIGN_CACHE, '.git')):
        subprocess.run(['git', 'init', '-q', SOVEREIGN_CACHE], check=True)
        git('remote', 'add', 'origin', SOVEREIGN_REPO)
    try:
        git('cat-file', '-e', VANILLA_REF)
    except subprocess.CalledProcessError:
        git('fetch', '-q', '--depth=1', 'origin', VANILLA_REF)
    out = {}
    for path in git('ls-tree', '--name-only', VANILLA_REF, 'decomp/res/field/encounters/').split():
        name = os.path.basename(path)
        # the Honey Trees are Sovereign's own, and the Great Marsh's lookout keeps its daily list (another layout)
        if name.startswith('encounters_') and name.endswith('.json') and name not in (
                'encounters_honey_tree.json', 'encounters_great_marsh_lookout.json'):
            out[name] = json.loads(git('show', f'{VANILLA_REF}:{path}'))
    return out


def version(value, which):
    return value[which] if isinstance(value, dict) and 'HEARTGOLD' in value else value


def merge_versions(slots, key, times):
    """HeartGold's species in each slot and time, then each SoulSilver species missing at a time put where the versions
    differ and HeartGold's species there is in another slot too."""
    hg = [{t: version(s[key][t] if times else s[key], 'HEARTGOLD') for t in times or ('all',)} for s in slots]
    ss = [{t: version(s[key][t] if times else s[key], 'SOULSILVER') for t in times or ('all',)} for s in slots]
    merged = [dict(h) for h in hg]
    for t in times or ('all',):
        for i, s in enumerate(ss):
            want = s[t]
            if want in {m[t] for m in merged}:
                continue
            spots = [j for j in range(len(slots)) if ss[j][t] == want and hg[j][t] != want] + list(range(len(slots)))
            for j in spots:
                if sum(m[t] == merged[j][t] for m in merged) > 1:
                    merged[j][t] = want
                    break
    return merged


def hgss_tables():
    """Johto's and Kanto's tables, by bank, in import_hgss_encounters.py's layout, both versions merged."""
    out = []
    for e in json.load(open(HG_ENC, encoding='utf-8'))['encounters']:
        mons = e['land']['mons']
        land = merge_versions(mons, 'species', ('morn', 'day', 'nite')) if mons else []
        slots = [{'level': version(m['level'], 'HEARTGOLD'), 'morning': s['morn'], 'day': s['day'],
                  'night': s['nite']} for m, s in zip(mons, land)]
        slots += [{'level': 0, 'morning': 'SPECIES_NONE', 'day': 'SPECIES_NONE', 'night': 'SPECIES_NONE'}] * (
            12 - len(slots))

        def water(table, count):
            mons = table['mons']
            species = merge_versions(mons, 'species', None) if mons else []
            got = [{'level_min': version(m['level']['min'], 'HEARTGOLD'),
                    'level_max': version(m['level']['max'], 'HEARTGOLD'), 'species': s['all']}
                   for m, s in zip(mons, species)]
            got += [{'level_min': 0, 'level_max': 0, 'species': 'SPECIES_NONE'}] * (count - len(got))
            return {'rate': table['rate'], 'slots': got}

        def pair(values):
            values = [version(v, 'HEARTGOLD') for v in version(values, 'HEARTGOLD')] + ['SPECIES_NONE'] * 2
            return values[:2]

        out.append({'map': e['map'], 'land': {'rate': e['land']['rate'], 'slots': slots},
                    'surf': water(e['surf'], 5), 'rock_smash': water(e['rock_smash'], 2),
                    'old_rod': water(e['fishing']['old_rod'], 5), 'good_rod': water(e['fishing']['good_rod'], 5),
                    'super_rod': water(e['fishing']['super_rod'], 5),
                    'radio_hoenn': pair(e['hoenn']), 'radio_sinnoh': pair(e['sinnoh']),
                    'swarm': {key: version(e.get(name, 'SPECIES_NONE'), 'HEARTGOLD') for key, name in
                              (('land', 'landSwarm'), ('surf', 'surfSwarm'), ('night_fishing', 'nightFish'),
                               ('fishing', 'fishSwarm'))}})
    return out


def hgss_places():
    """{bank: the location label of the maps that use it}."""
    src = open(MAP_HEADERS, encoding='utf-8').read()
    out = {}
    for m in re.finditer(r'\[MAP_HEADER_HGSS_\w+\]\s*=\s*\{(.*?)\}', src, re.S):
        bank = re.search(r'wildEncountersArchiveID = encounters_hgss_(\d+)', m.group(1))
        label = re.search(r'mapLabelTextID = LocationNames_Text_(\w+)', m.group(1))
        if bank and label:
            out.setdefault(int(bank.group(1)), label.group(1))
    return out


class Area:
    """One encounter table's place in the plan: its name, region, habitat, and the tables a new species can go in."""

    def __init__(self, name, region, tags, order):
        self.name, self.region, self.tags, self.order = name, region, tags, order
        self.tables = {}  # kind -> (levels (low, high), [free slot entries])
        self.new = 0


def free_land(slots, times):
    """The slots (by LAND_ORDER) whose species at every time is in another slot too, at most FREE_LAND."""
    count = {t: collections.Counter(s[t] for s in slots) for t in times}
    free = []
    for i in LAND_ORDER:
        if len(free) == FREE_LAND:
            break
        if slots[i]['level'] and all(slots[i][t] != 'SPECIES_NONE' and count[t][slots[i][t]] > 1 for t in times):
            for t in times:
                count[t][slots[i][t]] -= 1
            free.append(i)
    return free


def free_water(slots):
    count = collections.Counter(s['species'] for s in slots)
    free = []
    for i in WATER_ORDER:
        if len(free) == FREE_WATER:
            break
        if slots[i]['level_max'] and slots[i]['species'] != 'SPECIES_NONE' and count[slots[i]['species']] > 1:
            count[slots[i]['species']] -= 1
            free.append(i)
    return free


def main():
    rows, by_name = load_species()
    known = [line.strip() for line in open(os.path.join(ROOT, 'decomp', 'generated', 'species.txt')) if line.strip()]
    const = {r['name']: species_constant(r['name'], set(known)) for r in rows}
    name_of = {c: n for n, c in const.items()}
    gate = build_level_gates(rows, by_name)

    hgss = hgss_tables()
    places = hgss_places()
    platinum = platinum_tables()

    # what the originals have, every table (radio, swarms, Poké Radar, the dual slots), headbutt and the Safari Zone
    original = set(re.findall(r'SPECIES_\w+', json.dumps(hgss) + json.dumps(platinum) +
                              open(os.path.join(HG_ARC, 'headbutt.json')).read() +
                              open(os.path.join(HG_ARC, 'safari_enc.json')).read()))
    original |= set(re.findall(r'SPECIES_\w+', open(os.path.join(ENC, 'sovereign_honey_trees.json')).read()))
    families_had = {by_name[name_of[c]]['family_id'] for c in original if c in name_of}
    starters = {by_name[n]['family_id'] for n in STARTER_BASES | OLD_STARTERS}
    todo = [r for r in rows if r['category'] == 'regular' and r['family_id'] not in families_had
            and r['family_id'] not in starters]

    # the areas and their free slots
    areas = []
    sinnoh_name = {stem: area for area, stems in AREA_FILES.items() for stem in stems}
    for bank, table in enumerate(hgss):
        label = places.get(bank)
        if not label:
            continue
        a = Area(f'{re.sub(r"(?<=[a-z])(?=[A-Z0-9])", " ", label)} ({table["map"]})',
                 'kanto' if label in KANTO else 'johto', AREA_TAGS.get(label, 'field').split(), bank)
        a.data, a.kind = table, 'hgss'
        land = table['land']['slots']
        if table['land']['rate']:
            levels = [s['level'] for s in land if s['level']]
            a.tables['land'] = ((min(levels), max(levels)), free_land(land, TIMES))
        for kind in ('surf', 'old_rod', 'good_rod', 'super_rod'):
            if table[kind]['rate']:
                s = table[kind]['slots']
                a.tables[kind] = ((min(x['level_min'] for x in s if x['level_max']), max(x['level_max'] for x in s)),
                                  free_water(s))
        areas.append(a)
    for i, (name, table) in enumerate(sorted(platinum.items())):
        stem = name[len('encounters_'):-len('.json')]
        plan_name = sinnoh_name.get(stem)
        a = Area(plan_name or stem.replace('_', ' ').title(), 'sinnoh',
                 area_tags(plan_name) if plan_name else area_tags(stem.replace('_', ' ').title()), i)
        a.data, a.kind, a.file = table, 'platinum', name
        if table['land_rate']:
            land = [{'level': s['level'], **{t: s['species'] for t in TIMES}} for s in table['land_encounters']]
            # slots 2 and 3 change by day and at night: they stay Platinum's
            free = [j for j in free_land(land, TIMES) if j not in (2, 3)]
            levels = [s['level'] for s in land if s['level']]
            a.tables['land'] = ((min(levels), max(levels)), free)
        for kind in ('surf', 'old_rod', 'good_rod', 'super_rod'):
            if table[f'{kind}_rate']:
                s = table[f'{kind}_encounters']
                a.tables[kind] = ((min(x['level_min'] for x in s if x['level_max']), max(x['level_max'] for x in s)),
                                  free_water(s))
        areas.append(a)

    def score(r, a, kind, slot):
        low, high = a.tables[kind][0]
        g = gate[r['name']]
        if high < g:
            return None
        types = r['types'].split('/')
        water = 'Water' in types
        if kind == 'land':
            if water and not set(types) & AMPHIBIOUS_OK and not set(a.tags) & {'marsh', 'beach', 'lake', 'rain',
                                                                                'river'}:
                return None
            if r['name'] in FISH:
                return None
        elif r['name'] in FISH:
            if kind == 'surf':
                return None
        elif not water or (kind != 'surf' and types[0] != 'Water'):
            return None
        s = sum(TAG_TYPES.get(tag, {}).get(ty, 0) for tag in a.tags for ty in types)
        if kind == 'land' and s == 0:
            return None
        if kind != 'land' and r['name'] in FISH:
            s += 3
        s -= max(0, low - g) / 15.0
        rate = (LAND_RATES if kind == 'land' else WATER_RATES)[slot]
        s -= abs(rarity(r) - (0 if rate >= 10 else 1 if rate >= 4 else 2)) * 1.5
        return s - a.new * 0.6

    used = set()

    def best_spot(r, regions):
        best, best_s = None, None
        pin = PIN.get(r['name'])
        for a in areas:
            if a.region not in regions or (isinstance(pin, tuple) and a.name != pin[1]):
                continue
            for kind, (_, free) in a.tables.items():
                for slot in free:
                    if (id(a), kind, slot) in used:
                        continue
                    s = score(r, a, kind, slot)
                    if s is not None and (best_s is None or s > best_s):
                        best, best_s = (a, kind, slot), s
        return best

    placed, unplaced = {}, []
    region_count = collections.Counter()
    families = collections.defaultdict(list)
    for r in todo:
        families[r['family_id']].append(r)
    order = sorted(families.values(), key=lambda f: (all(r['is_baby'] == '1' for r in f),
                                                    min(gate[r['name']] for r in f), int(f[0]['dex'])))

    def put(r, spot):
        a, kind, slot = spot
        used.add((id(a), kind, slot))
        a.new += 1
        region_count[a.region] += 1
        placed[r['name']] = (a, kind, slot)

    for family in order:
        family.sort(key=lambda r: (r['is_baby'] != '1', int(r['stage']), int(r['dex'])))
        pinned = {PIN[r['name']] if isinstance(PIN.get(r['name']), str) else PIN[r['name']][0]
                  for r in family if r['name'] in PIN}
        # the region with the fewest new species so far that has a place for the family's first species
        candidates = sorted(REGION_ORDER, key=lambda g: (region_count[g], REGION_ORDER.index(g)))
        region = next(iter(pinned), None) or next(
            (g for g in candidates if best_spot(family[0], {g})), candidates[0])
        for r in family:
            if r['is_baby'] == '1' and r['is_final'] == '0' and len(family) > 1:
                continue  # placed after every family, where slots are left
            spot = best_spot(r, {region}) or best_spot(r, set(REGION_ORDER))
            if spot:
                put(r, spot)
            else:
                unplaced.append(r['name'])
    for family in order:
        for r in family:
            if r['name'] not in placed and r['name'] not in unplaced:
                spot = best_spot(r, set(REGION_ORDER))
                if spot:
                    put(r, spot)
                else:
                    unplaced.append(r['name'])

    # write the tables
    for r_name, (a, kind, slot) in placed.items():
        c = const[r_name]
        if a.kind == 'hgss':
            if kind == 'land':
                for t in TIMES:
                    a.data['land']['slots'][slot][t] = c
            else:
                a.data[kind]['slots'][slot]['species'] = c
        else:
            if kind == 'land':
                a.data['land_encounters'][slot]['species'] = c
            else:
                a.data[f'{kind}_encounters'][slot]['species'] = c
    for bank, table in enumerate(hgss):
        path = os.path.join(ENC, 'hgss', f'encounters_hgss_{bank:03d}.json')
        if os.path.exists(path):
            with open(path, 'w', encoding='utf-8') as f:
                f.write(json.dumps(table, indent=4) + '\n')
    for name, table in platinum.items():
        path = os.path.join(ENC, name)
        if os.path.exists(path):
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(table, f, indent=4, ensure_ascii=False)
                f.write('\n')
    write_doc(areas, placed, unplaced, region_count, name_of, todo)
    print(f'{len(todo)} species to mix in: {len(placed)} placed ({dict(region_count)}), {len(unplaced)} not placed')


def write_doc(areas, placed, unplaced, region_count, name_of, todo):
    new = {name for name in placed}
    lines = ['# Wild Pokémon', '',
             'Generated by `tools/complete/gen_wild.py`; change the generator (its PIN, AREA_TAGS and slot settings) and '
             'run it again rather than editing this.', '',
             'Each map has its own table from HeartGold/SoulSilver (Johto, Kanto) or Platinum (Sinnoh), with the '
             'Pokémon those games don\'t have mixed in, marked ★: the families none of their tables has, spread evenly '
             'over the three regions.', '',
             '| Region | New species placed |', '|---|---|']
    lines += [f'| {g.title()} | {region_count[g]} |' for g in REGION_ORDER]
    lines += ['', f'{len(todo)} species to place; {len(placed)} placed.', '']
    star = lambda c: f'**{name_of.get(c, c)}**★' if name_of.get(c) in new else name_of.get(c, c)  # noqa: E731
    for region in REGION_ORDER:
        lines += [f'## {region.title()}', '']
        for a in sorted((a for a in areas if a.region == region), key=lambda a: a.order):
            if not a.tables:
                continue
            lines += [f'### {a.name}', '', f'_{", ".join(a.tags)}_', '', '| Table | Pokémon |', '|---|---|']
            for kind in a.tables:
                if a.kind == 'hgss':
                    if kind == 'land':
                        for t in TIMES:
                            rates = collections.Counter()
                            for s, rate in zip(a.data['land']['slots'], LAND_RATES):
                                rates[s[t]] += rate
                            lines.append(f'| {t.title()} | ' + ', '.join(f'{star(c)} ({p}%)' for c, p in
                                                                        rates.most_common()) + ' |')
                        continue
                    slots = a.data[kind]['slots']
                else:
                    slots = a.data['land_encounters' if kind == 'land' else f'{kind}_encounters']
                rates = collections.Counter()
                for s, rate in zip(slots, LAND_RATES if kind == 'land' else WATER_RATES):
                    rates[s['species']] += rate
                lines.append(f'| {kind.replace("_", " ").title()} | ' + ', '.join(
                    f'{star(c)} ({p}%)' for c, p in rates.most_common()) + ' |')
            lines.append('')
    if unplaced:
        lines += ['## Not placed', '', 'No slot suited these (they evolve from a placed species, or hatch):', '',
                  ', '.join(unplaced), '']
    with open(os.path.join(ROOT, 'docs', 'WildPokemon.md'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))


if __name__ == '__main__':
    main()
