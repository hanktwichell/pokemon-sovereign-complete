#!/usr/bin/env python3
"""Add the Pokéathlon's 27 data cards to the item list (the Pokéathlon, stage 1; docs/Roadmap.md).

HeartGold's Pokéathlon Dome sells them at its data card counter (ScrCmd_772): a card bought is a bit in the
Pokéathlon's save, never an item in the bag, but the counter lists each one by its item's name, description and icon.
So each card is an item here (ITEM_DATA_CARD_01 to _27, HeartGold's names, plurals, articles and descriptions), listed
after the HM09 that tools/complete/hm_moves.py adds last, so no earlier item's number moves (a save's bag keeps its
items). All 27 share HeartGold's one data card icon (data_card.png). tools/complete/import_hgss_items.py leaves them
where they are.

Usage: python3 tools/complete/import_hgss_data_cards.py   (reruns replace the earlier entries)
"""
import csv
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_items import (HG_ICONS, ITEMS_DIR, hg_item_numbers, icon_indices, item_json, messages,  # noqa: E402
                               write_icon)
from import_hgss_maps import DECOMP, HG  # noqa: E402

CARDS = 27
ICON = 'data_card'
MARK = ("    # Sovereign Complete: the Pokéathlon's data cards (tools/complete/import_hgss_data_cards.py)\n",
        "    # end of the data cards\n")


def replace_block(text, list_name, entries):
    """Put entries at the end of the meson list `list_name = files(...)`, between MARK's lines."""
    start = text.index(f'{list_name} = files(')
    end = text.index('\n)\n', start)
    body = text[start:end + 1]
    if MARK[0] in body:
        body = body[:body.index(MARK[0])] + body[body.index(MARK[1]) + len(MARK[1]):]
    body += MARK[0] + ''.join(f"    '{e}',\n" for e in entries) + MARK[1]
    return text[:start] + body.rstrip('\n') + text[end:]


def main():
    numbers = hg_item_numbers()
    first = numbers['ITEM_DATA_CARD_01']
    cards = [f'ITEM_DATA_CARD_{i:02}' for i in range(1, CARDS + 1)]
    if [numbers[c] for c in cards] != list(range(first, first + CARDS)):
        sys.exit("HeartGold's data cards aren't numbered in a row")

    rows = {r['item']: r for r in csv.DictReader(open(os.path.join(HG, 'files/itemtool/itemdata/item_data.csv')))}
    names, plurals, articles, descriptions = (messages(b) for b in ('0222', '0224', '0223', '0221'))
    icons = icon_indices()
    ncgr, nclr, _ = icons[cards[0]]
    if any(icons[c][:2] != (ncgr, nclr) for c in cards):
        sys.exit("HeartGold's data cards don't share one icon")
    write_icon(ICON, os.path.join(HG_ICONS, f'item_icon_{ncgr:03}.NCGR'), os.path.join(HG_ICONS, f'item_icon_{nclr:03}.NCLR'))

    for card in cards:
        n, row = numbers[card], rows[card]
        if row['holdEffect'] != 'HOLD_EFFECT_NONE' or row['fieldPocket'] != 'POCKET_ITEMS' or row['battlePocket'] != '0':
            sys.exit(f"{card}: HeartGold gives it effects the importer doesn't carry over")
        data = item_json(ICON, names[n], plurals[n], articles[n].split('{', 1)[0].strip(), descriptions[n],
                         int(row['price']), row['fieldPocket'], row['prevent_toss'] == 'true')
        stem = card[len('ITEM_'):].lower()
        with open(os.path.join(ITEMS_DIR, 'data', f'{stem}.json'), 'w', encoding='utf-8') as f:
            f.write(json.dumps(data, indent=2, ensure_ascii=False) + '\n')

    # after HM09, the list's last item, so every earlier item keeps its number
    items_txt = os.path.join(DECOMP, 'generated/items.txt')
    listed = [line for line in open(items_txt).read().splitlines() if line.strip() and line not in cards]
    if listed[-2:] != ['ITEM_HM09', 'MAX_ITEMS']:
        sys.exit(f'the item list ends with {listed[-2:]}, not HM09 (tools/complete/hm_moves.py)')
    open(items_txt, 'w').write('\n'.join(listed[:-1] + cards + listed[-1:]) + '\n')

    meson = os.path.join(ITEMS_DIR, 'icons/meson.build')
    text = open(meson).read()
    text = replace_block(text, 'item_icon_pngs', [f'{ICON}.png'])
    text = replace_block(text, 'item_icon_pals', [f'{ICON}.pal'])
    open(meson, 'w').write(text)

    order = os.path.join(ITEMS_DIR, 'item_icon.order')
    ours = [f'{ICON}.NCGR', f'{ICON}.NCLR']
    entries = [line for line in open(order).read().splitlines() if line and line not in ours]
    open(order, 'w').write('\n'.join(entries + ours) + '\n')
    print(f'{CARDS} data cards added after HM09')


if __name__ == '__main__':
    main()
