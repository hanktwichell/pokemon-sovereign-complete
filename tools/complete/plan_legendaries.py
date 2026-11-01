#!/usr/bin/env python3
"""Plan Sovereign's legendaries' moves to Johto and Kanto (data/complete/placed.yaml): for each in MOVES, its level, its
object on Sovereign's map and what shows it there, read from Sovereign's scripts, and a spot on its new map
(tools/complete/find_spot.py), clear of the plan's other spots. Writes the plan's legendary entries (between its
"# legendaries" markers), which can then be edited by hand.

What shows a legendary (its map's OnTransition block between SetFlag FLAG_MAP_LOCAL_HIDE_LEGENDARY* and its ClearFlag):
the Chronicle (VAR_SOVEREIGN_CHRONICLE at least n), flags set or clear, an item in the bag, Pokémon in the party,
others caught first, the night. Its own catch hides it, as Sovereign's do (src/complete_placed.c checks that itself).

Usage: python3 tools/complete/plan_legendaries.py
"""
import glob
import json
import os
import re
import sys

import yaml

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
PLAN = os.path.join(ROOT, 'data', 'complete', 'placed.yaml')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'complete'))
from find_spot import spots  # noqa: E402

# The owner's call (Nov 1, 2026), Claude's split: the Unova and Kalos Chronicles' legendaries to Johto, Alola's and
# Galar's to Kanto; Paldea's stay in Sinnoh, and so do those whose quests run through Sinnoh's places (Meloetta's
# composer, Genesect's and Type: Null's lab, Cosmog's and Necrozma's scenes)
MOVES = {
    # Unova -> Johto
    'VIRIZION': 'MAP_HEADER_HGSS_ILEX_FOREST',
    'COBALION': 'MAP_HEADER_HGSS_MOUNT_MORTAR_B1F',
    'TERRAKION': 'MAP_HEADER_HGSS_DARK_CAVE_ROUTE_45_SIDE',
    'KELDEO': 'MAP_HEADER_HGSS_LAKE_OF_RAGE',
    'VICTINI': 'MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_5F',
    'RESHIRAM': 'MAP_HEADER_HGSS_BURNED_TOWER_B1F',
    'ZEKROM': 'MAP_HEADER_HGSS_DRAGONS_DEN',
    'KYUREM': 'MAP_HEADER_HGSS_ICE_PATH_B3F',
    'LANDORUS': 'MAP_HEADER_HGSS_ROUTE_46',
    'ENAMORUS': 'MAP_HEADER_HGSS_ROUTE_43',
    # Kalos -> Johto
    'XERNEAS': 'MAP_HEADER_HGSS_ROUTE_37',
    'YVELTAL': 'MAP_HEADER_HGSS_ROUTE_45',
    'ZYGARDE': 'MAP_HEADER_HGSS_UNION_CAVE_B2F',
    'DIANCIE': 'MAP_HEADER_HGSS_CLIFF_CAVE',
    'HOOPA': 'MAP_HEADER_HGSS_RUINS_OF_ALPH',
    'VOLCANION': 'MAP_HEADER_HGSS_ROUTE_47',
    # Alola -> Kanto
    'TAPU_KOKO': 'MAP_HEADER_HGSS_ROUTE_10',
    'TAPU_LELE': 'MAP_HEADER_HGSS_LAVENDER',
    'TAPU_BULU': 'MAP_HEADER_HGSS_VIRIDIAN_FOREST',
    'TAPU_FINI': 'MAP_HEADER_HGSS_ROUTE_19',
    'MAGEARNA': 'MAP_HEADER_HGSS_SAFFRON_SILPH_CO_HQ',
    'MARSHADOW': 'MAP_HEADER_HGSS_ROCK_TUNNEL_1F',
    'MELTAN': 'MAP_HEADER_HGSS_MOUNT_MOON',
    'MELMETAL': 'MAP_HEADER_HGSS_MOUNT_MOON',
    # Galar -> Kanto
    'ZACIAN': 'MAP_HEADER_HGSS_ROUTE_2',
    'ZAMAZENTA': 'MAP_HEADER_HGSS_ROUTE_2',
    'ETERNATUS': 'MAP_HEADER_HGSS_VICTORY_ROAD_3F',
    'KUBFU': 'MAP_HEADER_HGSS_SAFFRON_FIGHTING_DOJO',
    'ZARUDE': 'MAP_HEADER_HGSS_ROUTE_14',
    'REGIELEKI': 'MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_REPAIRED',
    'REGIDRAGO': 'MAP_HEADER_HGSS_ROUTE_28',
    'CALYREX': 'MAP_HEADER_HGSS_ROUTE_22',
}


def sovereign_scripts():
    """{species: (script file stem, level, the gates that show it)} from Sovereign's maps' scripts."""
    out = {}
    for path in glob.glob(os.path.join(DECOMP, 'res', 'field', 'scripts', 'scripts_*.s')):
        if 'hgss' in path:
            continue
        stem = os.path.basename(path)[len('scripts_'):-2]
        lines = open(path, encoding='utf-8').read().split('\n')
        levels = {}
        for i, line in enumerate(lines):
            m = re.match(r'\s+SetVar VAR_0x8004, SPECIES_(\w+)', line)
            if m and i + 2 < len(lines) and 'VAR_0x8005' in lines[i + 1] and 'LegendaryEncounter' in lines[i + 2]:
                levels[m.group(1)] = int(lines[i + 1].split(',')[1])
        for i, line in enumerate(lines):
            m = re.match(r'\s+SetFlag (FLAG_MAP_LOCAL_HIDE_LEGENDARY\w*)', line)
            if not m:
                continue
            body = []
            for line2 in lines[i + 1:i + 40]:
                if re.match(r'\s+ClearFlag ' + m.group(1) + r'\b', line2):
                    break
                body.append(line2.strip())
            # the legendary is the one whose catch hides it (the check followed by a jump past the ClearFlag on TRUE)
            own = [re.search(r'SPECIES_(\w+)', b).group(1) for b, after in zip(body, body[1:] + [''])
                   if 'SovereignCheckSpeciesCaught' in b and after.startswith('GoToIfEq VAR_RESULT, TRUE')]
            if not own or own[0] not in levels:
                continue
            species, gates, check = own[0], [], None
            for b in body:
                if b.startswith('GoToIfLt VAR_RESULT, TIMEOFDAY_NIGHT'):
                    gates.append({'night': True})
                elif b.startswith('GoToIfLt '):
                    var, value = b.split()[1].rstrip(','), b.split()[2].rstrip(',')
                    gates.append({'var': [var, int(value)]})
                elif b.startswith('GoToIfUnset '):
                    gates.append({'flag': b.split()[1].rstrip(',')})
                elif b.startswith('GoToIfSet '):
                    gates.append({'flag_clear': b.split()[1].rstrip(',')})
                elif b.startswith('CheckItem '):
                    check = {'item': b.split()[1].rstrip(',')}
                elif b.startswith('CheckPartyHasSpecies '):
                    check = {'party': b.split()[2]}
                elif b.startswith('SovereignCheckSpeciesCaught '):
                    other = b.split()[1].rstrip(',')
                    check = {'caught': other} if other != 'SPECIES_' + species else None
                elif b.startswith('GoToIfEq VAR_RESULT, FALSE') and check:
                    gates.append(check)
                    check = None
            out[species] = (stem, levels[species], gates)
    return out


def main():
    plan_text = open(PLAN, encoding='utf-8').read()
    plan = yaml.safe_load(plan_text)
    found = sovereign_scripts()
    headers = open(os.path.join(DECOMP, 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    taken = {}
    for p in plan.get('placed') or []:
        if 'totem' in p:
            taken.setdefault(p['map'], []).append(tuple(p['at']))
    moved, placed = [], []
    for species, target in MOVES.items():
        if species not in found:
            sys.exit(f'{species}: no legendary encounter of Sovereign\'s found')
        stem, level, gates = found[species]
        header = re.search(r'\[(MAP_HEADER_\w+)\]\s*=\s*\{[^}]*scriptsArchiveID = scripts_' + stem + r',', headers).group(1)
        events = re.search(r'\[' + header + r'\]\s*=\s*\{[^}]*eventsArchiveID = (\w+)', headers).group(1)
        objects = json.load(open(os.path.join(DECOMP, 'res', 'field', 'events', events + '.json')))['object_events']
        local = next((o['id'] for o in objects if o.get('graphics_id') == f'OBJ_EVENT_GFX_LEGENDARY_{species}'
                      or o.get('id') == f'LOCALID_LEGENDARY_{species}'), None)
        if not local:
            sys.exit(f'{species}: no object on {header}')
        near = taken.setdefault(target, [])
        spot = next((p for p, _, _ in spots(target, 30)
                     if all(abs(p[0] - q[0]) + abs(p[1] - q[1]) > 3 for q in near)), None)
        if not spot:
            sys.exit(f'{species}: no spot on {target}')
        near.append(spot)
        moved.append(f'  - [{header}, {local}]')
        gate_text = ', '.join(json.dumps(g).replace('"', '').replace('true', 'true') for g in gates)
        placed.append(f'  - {{legendary: SPECIES_{species}, level: {level}, map: {target}, at: [{spot[0]}, {spot[1]}],\n'
                      f'     gates: [{gate_text}]}}  # from {header}')
        print(f'{species}: {header} -> {target} {spot}, level {level}, gates {gates}', flush=True)
    block = ('  # legendaries (tools/complete/plan_legendaries.py)\n' + '\n'.join(placed) +
             '\n  # end legendaries\n')
    moved_block = ('  # legendaries (tools/complete/plan_legendaries.py)\n' + '\n'.join(moved) +
                   '\n  # end legendaries\n')
    text = re.sub(r'  # legendaries \(tools/complete/plan_legendaries.py\)\n.*?  # end legendaries\n', '', plan_text,
                  flags=re.S)
    text = text.replace('\nplaced:\n', '\n' + moved_block + '\nplaced:\n', 1)
    text = text.rstrip('\n') + '\n' + block
    open(PLAN, 'w', encoding='utf-8').write(text)


if __name__ == '__main__':
    main()
