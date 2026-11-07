#!/usr/bin/env python3
"""Compare each Elite Four member's and champion's first team with their rematch team, in both Leagues (the owner's
note, Nov 6, 2026: the rematch teams should be slightly better than the first ones), for the owner's review.

For each pair (Sinnoh's singles and doubles from Sovereign, the Indigo Plateau's singles from Sacred Gold and doubles
from Complete), from the trainer files (decomp/res/trainers/data/*.json, levels as stored: the game scales Sinnoh's
to the level plan, both teams alike): the levels, held items, Mega Stones, the base stat totals and the trainer's own
items, and each place the rematch is weaker on one of those (a lower level, a member holding nothing where the first
team's member in that place held something, no Mega where the first had one, a lower base stat total, fewer items).

Usage: python3 tools/complete/compare_e4_rematches.py [--markdown OUT.md]
"""
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DATA = os.path.join(ROOT, 'decomp', 'res', 'trainers', 'data')
PAIRS = [
    ('Sinnoh', 'Aaron', 'elite_four_aaron', 'elite_four_aaron_rematch'),
    ('Sinnoh', 'Bertha', 'elite_four_bertha', 'elite_four_bertha_rematch'),
    ('Sinnoh', 'Flint', 'elite_four_flint', 'elite_four_flint_rematch'),
    ('Sinnoh', 'Lucian', 'elite_four_lucian', 'elite_four_lucian_rematch'),
    ('Sinnoh', 'Cynthia', 'champion_cynthia', 'champion_cynthia_rematch'),
    ('Sinnoh doubles', 'Aaron', 'sovereign_elite_four_aaron_doubles', 'sovereign_elite_four_aaron_rematch_doubles'),
    ('Sinnoh doubles', 'Bertha', 'sovereign_elite_four_bertha_doubles', 'sovereign_elite_four_bertha_rematch_doubles'),
    ('Sinnoh doubles', 'Flint', 'sovereign_elite_four_flint_doubles', 'sovereign_elite_four_flint_rematch_doubles'),
    ('Sinnoh doubles', 'Lucian', 'sovereign_elite_four_lucian_doubles', 'sovereign_elite_four_lucian_rematch_doubles'),
    ('Sinnoh doubles', 'Cynthia', 'sovereign_champion_cynthia_doubles', 'sovereign_champion_cynthia_rematch_doubles'),
    ('Indigo', 'Will', 'hgss_elite_four_will_will', 'hgss_elite_four_will_will_2'),
    ('Indigo', 'Koga', 'hgss_elite_four_koga_koga', 'hgss_elite_four_koga_koga_2'),
    ('Indigo', 'Bruno', 'hgss_elite_four_bruno_bruno', 'hgss_elite_four_bruno_bruno_2'),
    ('Indigo', 'Karen', 'hgss_elite_four_karen_karen', 'hgss_elite_four_karen_karen_2'),
    ('Indigo', 'Lance', 'hgss_champion_lance', 'hgss_champion_lance_2'),
    ('Indigo doubles', 'Will', 'complete_indigo_will_doubles', 'complete_indigo_will_rematch_doubles'),
    ('Indigo doubles', 'Koga', 'complete_indigo_koga_doubles', 'complete_indigo_koga_rematch_doubles'),
    ('Indigo doubles', 'Bruno', 'complete_indigo_bruno_doubles', 'complete_indigo_bruno_rematch_doubles'),
    ('Indigo doubles', 'Karen', 'complete_indigo_karen_doubles', 'complete_indigo_karen_rematch_doubles'),
]


def base_total(species):
    path = os.path.join(ROOT, 'decomp', 'res', 'pokemon', species[len('SPECIES_'):].lower(), 'data.json')
    return sum(json.load(open(path))['base_stats'].values()) if os.path.exists(path) else 0


def summary(name):
    team = json.load(open(os.path.join(DATA, name + '.json')))
    party = team['party']
    held = [m.get('item', 'ITEM_NONE') for m in party]
    return {
        'levels': [m['level'] for m in party],
        'held': held,
        'megas': [h for h in held if h.endswith('ITE') or h.endswith('ITE_X') or h.endswith('ITE_Y') or 'ITE_Z' in h],
        'bst': [base_total(m['species']) for m in party],
        'items': len(team.get('items', [])),
        'species': [m['species'][len('SPECIES_'):].title() for m in party],
    }


def weaker(first, again):
    notes = []
    if max(again['levels']) < max(first['levels']) or sum(again['levels']) < sum(first['levels']):
        notes.append(f'lower levels ({min(again["levels"])}-{max(again["levels"])} against '
                     f'{min(first["levels"])}-{max(first["levels"])})')
    bare = [again['species'][i] for i in range(min(len(first['held']), len(again['held'])))
            if again['held'][i] == 'ITEM_NONE' and first['held'][i] != 'ITEM_NONE']
    if bare:
        notes.append(f'holding nothing where the first team\'s member held something: {", ".join(bare)}')
    if first['megas'] and not again['megas']:
        notes.append(f'no Mega Stone (the first team has {", ".join(first["megas"])})')
    if sum(again['bst']) / len(again['bst']) < sum(first['bst']) / len(first['bst']):
        notes.append(f'lower average base stat total ({sum(again["bst"]) // len(again["bst"])} against '
                     f'{sum(first["bst"]) // len(first["bst"])})')
    if again['items'] < first['items']:
        notes.append(f'fewer items of their own ({again["items"]} against {first["items"]})')
    if len(again['levels']) < len(first['levels']):
        notes.append(f'fewer Pokémon ({len(again["levels"])} against {len(first["levels"])})')
    return notes


def main():
    out = sys.argv[sys.argv.index('--markdown') + 1] if '--markdown' in sys.argv else None
    lines = ['| League | Trainer | First team | Rematch | Where the rematch is weaker |', '|---|---|---|---|---|']
    flagged = 0
    for league, who, first_name, again_name in PAIRS:
        first, again = summary(first_name), summary(again_name)
        notes = weaker(first, again)
        flagged += bool(notes)

        def cell(s):
            megas = f', Mega: {", ".join(m[len("ITEM_"):].title() for m in s["megas"])}' if s['megas'] else ''
            return (f'Lv. {min(s["levels"])}-{max(s["levels"])}, {sum(h != "ITEM_NONE" for h in s["held"])}/'
                    f'{len(s["held"])} holding{megas}; {", ".join(s["species"])}')
        lines.append(f'| {league} | {who} | {cell(first)} | {cell(again)} | {"; ".join(notes) or "—"} |')
    text = '\n'.join(lines) + f'\n\n{flagged} of {len(PAIRS)} rematch teams are weaker than the first on at least one count.\n'
    print(text)
    if out:
        open(out, 'w', encoding='utf-8').write(text)


if __name__ == '__main__':
    main()
