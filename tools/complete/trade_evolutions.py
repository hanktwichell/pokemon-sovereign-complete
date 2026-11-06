#!/usr/bin/env python3
"""The trade-evolution items used from the bag like a stone (the owner's call, Nov 6, 2026: "trade items work like
stones; trade evolutions with no item become level-up evolutions"). Link play is out of the build.

The evolutions themselves are in code (include/complete_evolutions.h): a trade with a held item (Onix's Metal Coat,
Clamperl's DeepSeaTooth and DeepSeaScale, Poliwhirl's and Slowpoke's King's Rock, Porygon's Up-Grade, Porygon2's
Dubious Disc, Rhydon's Protector, Electabuzz's Electirizer, Magmar's Magmarizer, Dusclops's Reaper Cloth, Seadra's
Dragon Scale, Scyther's Metal Coat) evolves it when that item is used on it (CompleteEvolution_ByItem), and a plain
trade (Kadabra, Machoke, Graveler and Alolan Graveler, Haunter) is also a level-up evolution at Lv. 37
(COMPLETE_TRADE_EVOLUTION_LEVEL). The species' data stay Sovereign's.

This gives each item named by a species' EVO_TRADE_WITH_HELD_ITEM the stones' field use (ITEM_USE_FUNC_EVO_STONE),
so the bag offers "Use"; the items keep their held effects. The items' data files are Sovereign's
(decomp/res/items/data/*.json), which JSON can't mark with a comment, so this script is the record: a sync's three-way
patch keeps the edit, but rerun this if a sync clashes on those lines. It only rewrites the item-use lines, in place.

Usage: python3 tools/complete/trade_evolutions.py
"""
import glob
import json
import os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')


def main():
    items = set()
    for path in glob.glob(os.path.join(DECOMP, 'res', 'pokemon', '**', 'data.json'), recursive=True):
        for evo in json.load(open(path, encoding='utf-8')).get('evolutions') or []:
            if evo[0] == 'EVO_TRADE_WITH_HELD_ITEM':
                items.add(evo[1])
    names = {}
    for path in glob.glob(os.path.join(DECOMP, 'res', 'items', 'data', '*.json')):
        names['ITEM_' + os.path.splitext(os.path.basename(path))[0].upper()] = path
    for item in sorted(items):
        path = names[item]
        text = open(path, encoding='utf-8').read()
        new = text.replace('"fieldUseFunc": "ITEM_USE_FUNC_NONE"', '"fieldUseFunc": "ITEM_USE_FUNC_EVO_STONE"')
        new = new.replace('"itemUseParams": null', '"itemUseParams": {}')
        assert json.loads(new)['fieldUseFunc'] == 'ITEM_USE_FUNC_EVO_STONE', item
        open(path, 'w', encoding='utf-8').write(new)
    print(f'{len(items)} items used like stones: {" ".join(sorted(items))}')


if __name__ == '__main__':
    main()
