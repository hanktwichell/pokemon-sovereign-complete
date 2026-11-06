#!/usr/bin/env python3
"""List every way to meet each legendary and mythical Pokémon in the game: the scripts' battles and gifts (Sinnoh's
Sovereign and Platinum scripts, Johto's and Kanto's HeartGold and Sacred Gold ones), the roamers, and Sovereign's
legendaries placed on other maps (data/complete/placed.yaml). For docs/Legendaries.md: one table per species, and the
species met more than once.

A script's encounter: a battle (StartLegendaryBattle, CompleteStartWildBattle, StartWildBattle, Sovereign's common
legendary encounter after SetVar VAR_0x8004), a gift (GivePokemon, GiveEgg) or a roamer released
(ActivateRoamingPokemon), naming the species. Its map is the map whose scripts the file is, and its region Johto, Kanto
or Sinnoh (KANTO below names Kanto's HeartGold maps). A Sinnoh object listed in placed.yaml's `moved` is off its map.

Usage: python3 tools/complete/list_legendaries.py [--markdown]
"""
import collections
import glob
import os
import re
import sys

import yaml

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')

LEGENDARY = '''ARTICUNO ZAPDOS MOLTRES MEWTWO MEW RAIKOU ENTEI SUICUNE LUGIA HO_OH CELEBI REGIROCK REGICE REGISTEEL LATIAS
LATIOS KYOGRE GROUDON RAYQUAZA JIRACHI DEOXYS UXIE MESPRIT AZELF DIALGA PALKIA HEATRAN REGIGIGAS GIRATINA CRESSELIA
PHIONE MANAPHY DARKRAI SHAYMIN ARCEUS VICTINI COBALION TERRAKION VIRIZION TORNADUS THUNDURUS RESHIRAM ZEKROM LANDORUS
KYUREM KELDEO MELOETTA GENESECT XERNEAS YVELTAL ZYGARDE DIANCIE HOOPA VOLCANION TYPE_NULL SILVALLY TAPU_KOKO TAPU_LELE
TAPU_BULU TAPU_FINI COSMOG COSMOEM SOLGALEO LUNALA NECROZMA MAGEARNA MARSHADOW ZERAORA MELTAN MELMETAL ZACIAN ZAMAZENTA
ETERNATUS KUBFU URSHIFU ZARUDE REGIELEKI REGIDRAGO GLASTRIER SPECTRIER CALYREX ENAMORUS WO_CHIEN CHIEN_PAO TING_LU
CHI_YU KORAIDON MIRAIDON OKIDOGI MUNKIDORI FEZANDIPITI OGERPON TERAPAGOS PECHARUNT'''.split()
SPECIES = re.compile(r'SPECIES_(' + '|'.join(sorted(LEGENDARY, key=len, reverse=True)) + r')\b')
BATTLE = re.compile(r'^\s*(StartLegendaryBattle|StartFatefulEncounter|StartGiratinaOriginBattle|CompleteStartWildBattle|StartWildBattle|GivePokemon|GiveEgg)\b')
# Kanto's HeartGold maps (the rest of HeartGold's are Johto's)
KANTO = re.compile(r'MAP_HEADER_HGSS_(PALLET|VIRIDIAN|PEWTER|CERULEAN|VERMILION|LAVENDER|CELADON|FUCHSIA|SAFFRON|'
                   r'CINNABAR|INDIGO|ROUTE_([1-9]|1[0-9]|2[0-5]|28)(_|$)|MOUNT_MOON|ROCK_TUNNEL|DIGLETTS|SEAFOAM|'
                   r'POWER_PLANT|CERULEAN_CAVE|VICTORY_ROAD|POKEMON_LEAGUE|KANTO|SILPH|SS_AQUA_VERMILION)')


# Where each roamer roams (docs/Features.md: HeartGold's in their own region, Sovereign's moved ones by RoamerRegionRoutes)
ROAMS_IN = {'RAIKOU': 'Johto', 'ENTEI': 'Johto', 'LATIAS': 'Kanto', 'LATIOS': 'Kanto', 'TORNADUS': 'Johto',
            'THUNDURUS': 'Johto', 'ZERAORA': 'Kanto', 'GLASTRIER': 'Kanto', 'SPECTRIER': 'Kanto', 'OKIDOGI': 'Sinnoh',
            'MUNKIDORI': 'Sinnoh', 'FEZANDIPITI': 'Sinnoh', 'MESPRIT': 'Sinnoh', 'CRESSELIA': 'Sinnoh'}
# HeartGold's battles whose species is in a var (the legendary cutscenes' scripts)
VAR_SPECIES = [('HO_OH', 'MAP_HEADER_HGSS_BELL_TOWER_ROOF', 'scripts_hgss_0021.s (the legendary cutscene)'),
               ('LUGIA', 'MAP_HEADER_HGSS_WHIRL_ISLANDS_B3F_LUGIA_CAVE', 'scripts_hgss_0104.s (the legendary cutscene)')]
# Copies switched off by script or moved off their maps (the owner's call, Nov 6, 2026: one of each; docs/Legendaries.md),
# by (species, map header): Sinnoh's where a script stops short of it, and Sacred Gold's moved to (6666, 6666) or skipped
OFF = {('CELEBI', 'MAP_HEADER_ETERNA_FOREST'), ('MEW', 'MAP_HEADER_ROUTE_201'), ('DEOXYS', 'MAP_HEADER_VEILSTONE_CITY'),
       ('LATIOS', 'MAP_HEADER_FULLMOON_ISLAND_FOREST'), ('LATIAS', 'MAP_HEADER_FULLMOON_ISLAND_FOREST'),
       ('REGIROCK', 'MAP_HEADER_ROCK_PEAK_RUINS'), ('REGICE', 'MAP_HEADER_ICEBERG_RUINS'),
       ('REGISTEEL', 'MAP_HEADER_IRON_RUINS'), ('ARCEUS', 'MAP_HEADER_HALL_OF_ORIGIN'),
       ('JIRACHI', 'MAP_HEADER_HGSS_MOUNT_MORTAR_B1F'), ('SHAYMIN', 'MAP_HEADER_HGSS_NATIONAL_PARK'),
       ('MANAPHY', 'MAP_HEADER_HGSS_ROUTE_40'), ('HEATRAN', 'MAP_HEADER_HGSS_CINNABAR_ISLAND'),
       ('REGIGIGAS', 'MAP_HEADER_HGSS_MOUNT_SILVER_CAVE_MOLTRES_CHAMBER'),
       ('MOLTRES', 'MAP_HEADER_HGSS_CINNABAR_ISLAND'),  # a leftover script of Sacred Gold's no object on the map runs
       ('CRESSELIA', 'MAP_HEADER_HGSS_MOUNT_MOON_SQUARE'), ('DARKRAI', 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_2F')} | {
    (sp, 'MAP_HEADER_HGSS_SINJOH_RUINS_MYSTRI_STAGE') for sp in ('UXIE', 'MESPRIT', 'AZELF', 'DIALGA', 'PALKIA', 'GIRATINA')}
# Met only by evolving another
EVOLVED = {'SILVALLY': 'TYPE_NULL', 'COSMOEM': 'COSMOG', 'SOLGALEO': 'COSMOG', 'LUNALA': 'COSMOG',
           'URSHIFU': 'KUBFU'}


def region(header):
    if not header.startswith('MAP_HEADER_HGSS_'):
        return 'Sinnoh'
    return 'Kanto' if KANTO.match(header) else 'Johto'


def script_maps():
    """{scripts file stem: [map headers]}"""
    src = open(os.path.join(DECOMP, 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    out = collections.defaultdict(list)
    for m in re.finditer(r'\[(MAP_HEADER_\w+)\]\s*=\s*\{(.*?)\}', src, re.S):
        s = re.search(r'scriptsArchiveID = (\w+)', m.group(2))
        if s:
            out[s.group(1)].append(m.group(1))
    return out


def label_of(lines, i):
    for j in range(i, -1, -1):
        if re.match(r'^\w+:', lines[j]):
            return lines[j].rstrip(':\n')
    return ''


def encounters():
    maps = script_maps()
    plan = yaml.safe_load(open(os.path.join(ROOT, 'data', 'complete', 'placed.yaml'), encoding='utf-8'))
    moved = {local for _, local in plan.get('moved') or []}
    found = []
    for path in sorted(glob.glob(os.path.join(DECOMP, 'res', 'field', 'scripts', 'scripts_*.s'))):
        stem = os.path.basename(path)[:-2]
        lines = open(path, encoding='utf-8').readlines()
        headers = maps.get(stem) or ['(common scripts)' if stem == 'scripts_common' else '(' + stem + ')']
        source = 'HeartGold/Sacred Gold' if stem.startswith('scripts_hgss') else 'Sovereign/Platinum'
        for i, line in enumerate(lines):
            r = re.match(r'^\s*ActivateRoamingPokemon ROAMING_SLOT_(\w+)', line)
            if r and r.group(1) in LEGENDARY:
                found.append({'species': r.group(1), 'kind': 'roamer', 'map': headers[0],
                              'region': ROAMS_IN.get(r.group(1), region(headers[0])),
                              'script': f'{stem}.s: {label_of(lines, i)}', 'line': i + 1, 'off': False,
                              'source': source})
                continue
            m = SPECIES.search(line)
            if not m:
                continue
            kind = None
            b = BATTLE.match(line)
            if b:
                kind = {'GivePokemon': 'gift', 'GiveEgg': 'egg'}.get(b.group(1), 'battle')
            elif re.match(r'^\s*SetVar VAR_0x8004, SPECIES_', line) and any(
                    'Common_SovereignLegendaryEncounter' in x for x in lines[i + 1:i + 4]):
                kind = 'battle'
            if not kind:
                continue
            label = label_of(lines, i)
            local = 'LOCALID_LEGENDARY_' + m.group(1)
            off = local in moved and re.search(r'Legendary' + m.group(1).replace('_', '').title()[:4], label, re.I)
            found.append({'species': m.group(1), 'kind': kind, 'map': headers[0], 'region': region(headers[0]),
                          'script': f'{stem}.s: {label}', 'line': i + 1, 'off': bool(off),
                          'source': 'HeartGold/Sacred Gold' if stem.startswith('scripts_hgss') else 'Sovereign/Platinum'})
    for sp, header, script in VAR_SPECIES:
        found.append({'species': sp, 'kind': 'battle', 'map': header, 'region': region(header), 'script': script,
                      'line': 0, 'off': False, 'source': 'HeartGold/Sacred Gold'})
    for p in plan.get('placed') or []:
        if p.get('legendary'):
            sp = p['legendary'][len('SPECIES_'):]
            found.append({'species': sp, 'kind': 'battle', 'map': p['map'], 'region': region(p['map']),
                          'script': 'placed.yaml (moved from Sinnoh)', 'line': 0, 'off': False,
                          'source': 'Sovereign (placed)', 'level': p.get('level')})
    return found


def main():
    rows = [e for e in encounters() if not e['off'] and (e['species'], e['map']) not in OFF]
    by = collections.defaultdict(list)
    for e in rows:
        by[e['species']].append(e)
    if '--markdown' in sys.argv:
        for sp in LEGENDARY:
            for e in by.get(sp, []):
                print(f"| {sp.replace('_', ' ').title()} | {e['region']} | {e['map'][11:]} | {e['kind']} | "
                      f"{e['source']} | `{e['script']}` |")
        return
    for sp in LEGENDARY:
        es = by.get(sp, [])
        if not es and sp in EVOLVED:
            print(f'{sp:12s} {"":7s} evolves from {EVOLVED[sp]}')
            continue
        tag = 'MISSING' if not es else ('DUP' if len({(e['map'], e['kind']) for e in es}) > 1 else '')
        print(f'{sp:12s} {tag:7s}', '; '.join(f"{e['region']}:{e['map'][11:]}({e['kind']},{e['source'][:3]})"
                                             for e in es))


if __name__ == '__main__':
    main()
