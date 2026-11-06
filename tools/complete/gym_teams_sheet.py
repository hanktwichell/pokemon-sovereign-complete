#!/usr/bin/env python3
"""The gym teams page (gym_teams_page.py) as a spreadsheet, for the owner's Google Sheet: one tab per section, one row
per Pokémon, each team's first battle and rematch. The sprite column is an IMAGE formula on PokeAPI's sprite of the
species' National Dex number (a Google Sheet shows it; other programs may not).

Usage: python3 tools/complete/gym_teams_sheet.py [OUT]   (default .cache/gym_teams/gym_teams.xlsx)
"""
import json
import os
import sys

from openpyxl import Workbook
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

sys.path.insert(0, os.path.dirname(__file__))
import gym_teams_page as page  # noqa: E402

SPRITE_URL = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/{}.png'
HEADERS = (['Battle no. (story order)', 'Trainer', 'Where', 'Team', 'Slot', 'Sprite', 'Pokémon', 'Level', 'Ability', 'Item', 'Nature',
            'Move 1', 'Move 2', 'Move 3', 'Move 4']
           + [f'IV {label}' for _, label in page.STATS] + [f'EV {label}' for _, label in page.STATS] + ['Notes'])
WIDTHS = [10, 14, 24, 13, 5, 9, 15, 5, 15, 17, 9, 15, 15, 15, 15] + [6] * 12 + [34]
FILLS = [PatternFill('solid', fgColor='FFFFFF'), PatternFill('solid', fgColor='F3EFE6')]
HEAD_FILL = PatternFill('solid', fgColor='1E1C19')
REMATCH_FILL = [PatternFill('solid', fgColor='EEF3FB'), PatternFill('solid', fgColor='E2EAF6')]
THICK = Side(style='medium', color='8A8378')


def rows_for(trainer_file, battle, where, order, name=None):
    data = json.load(open(os.path.join(page.TRAINERS, trainer_file + '.json'), encoding='utf-8'))
    for slot, mon in enumerate(data['party'], 1):
        m = page.build_mon(trainer_file, data, mon)
        notes = []
        if m['evolved']:
            notes.append(f'Lv. {m["from_level"]} {m["from"]} in the data')
        if not m['nature_set']:
            notes.append('nature seeded')
        if not m['moves_set']:
            notes.append('level-up moves')
        if m['mega']:
            notes.append('Mega Evolves')
        if m['shiny']:
            notes.append('shiny')
        moves = [page.move_info(x)[0] for x in m['moves']] + [''] * 4
        yield ([order, name or data['name'], where, battle, slot, f'=IMAGE("{SPRITE_URL.format(page.SPECIES[m["species"]])}")',
                m['name'], m['level'], m['ability'], page.item_name(m['item']) if m['item'] else '', m['nature']]
               + moves[:4] + [m['ivs'][k] for k, _ in page.STATS] + [m['evs'][k] for k, _ in page.STATS]
               + ['; '.join(notes)])


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(page.ROOT, '.cache', 'gym_teams', 'gym_teams.xlsx')
    wb = Workbook()
    wb.remove(wb.active)
    order = 0
    for _, title, trainers in page.SECTIONS:
        ws = wb.create_sheet(title)
        ws.append(HEADERS)
        for c in ws[1]:
            c.font = Font(bold=True, color='FFFFFF')
            c.fill = HEAD_FILL
            c.alignment = Alignment(horizontal='center', vertical='center', wrap_text=True)
        ws.row_dimensions[1].height = 30
        ws.freeze_panes = 'H2'
        for i, w in enumerate(WIDTHS, 1):
            ws.column_dimensions[get_column_letter(i)].width = w
        band = 0
        for entry in trainers:
            order += 1
            battles = []
            for label, stem in entry['tabs']:
                if not os.path.exists(os.path.join(page.TRAINERS, stem + '.json')):
                    continue
                data = json.load(open(os.path.join(page.TRAINERS, stem + '.json'), encoding='utf-8'))
                if label is None:
                    label = (page.species_name(page.starter_line(data)) + ' (rival\u2019s starter)'
                             if entry.get('starter_tabs') else data['name'])
                battles.append((stem, label))
            for b, (f, label) in enumerate(battles):
                start = ws.max_row + 1
                rematch = 'ematch' in label
                for row in rows_for(f, label, entry['where'], order, entry.get('name')):
                    ws.append(row)
                    r = ws.max_row
                    ws.row_dimensions[r].height = 48
                    fill = (REMATCH_FILL if rematch else FILLS)[band % 2]
                    for c in ws[r]:
                        c.fill = fill
                        c.alignment = Alignment(vertical='center', wrap_text=c.column in (3, len(HEADERS)))
                    for col in (1, 5, 8) + tuple(range(16, 28)):
                        ws.cell(r, col).alignment = Alignment(horizontal='center', vertical='center')
                    ws.cell(r, 7).font = Font(bold=True)
                    ws.cell(r, 8).font = Font(bold=True, size=12, color='C0392B')
                    ws.cell(r, 1).font = Font(color='8A8378')
                    if r == start:
                        ws.cell(r, 2).font = Font(bold=True, size=12)
                if b == 0:
                    for c in ws[start]:
                        c.border = Border(top=THICK)
            band += 1
    os.makedirs(os.path.dirname(out), exist_ok=True)
    wb.save(out)
    print(out)


if __name__ == '__main__':
    main()
