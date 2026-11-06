#!/usr/bin/env python3
"""The HMs as the owner set them (Nov 6, 2026): Whirlpool is HM05, as in HeartGold, and Defog a new HM09, found where
Platinum has its HM05 (the Solaceon Ruins). An HM move can be forgotten like any other, as Sovereign already has it
(SOVEREIGN_HMS_FORGETTABLE).

This rewrites the data, in place:
- decomp/res/items/data/hm05.json: HeartGold's HM05 (Whirlpool: its description, the Water TM palette);
- decomp/res/items/data/hm09.json: the HM05 it was (Defog), as HM09; generated/items.txt lists ITEM_HM09 last, so no
  item's number moves (saves keep their bags). Its code is in src/item.c (Item_MoveForTMHM, Item_TMHMNumber,
  Item_IsHMMove: it's machine number NUM_TMHMS, after HM08) and speciesproc reads "HM09";
- each species' (and form's) by_tm list: HM05 becomes HM09 (Defog's learners), and HM05 is Whirlpool's learners:
  HeartGold's own HM05 list for its 493 species (files/poketool/personal/personal.json in .cache/pokeheartgold), and
  for the later species and the forms, each one that learns Surf (HM03) or Whirlpool by level (on HeartGold's list
  that rule misses none, and adds seven).

The species' and items' data files are Sovereign's, which JSON can't mark with a comment, so this script is the record:
a sync's three-way patch keeps the edits, but rerun this if a sync clashes on those lines. It's idempotent.

Usage: python3 tools/complete/hm_moves.py
"""
import glob
import json
import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')
HG_PERSONAL = os.path.join(ROOT, '.cache', 'pokeheartgold', 'files', 'poketool', 'personal', 'personal.json')
HG_SPECIES = 493
WHIRLPOOL_DESCRIPTION = ['Traps foes in a violent swirling\n', 'whirlpool. It can also be used to\n',
                         'traverse whirlpools.']


def machine_key(entry):
    return (entry[:2] == 'HM', int(entry[2:]))


def main():
    hg = json.load(open(HG_PERSONAL))['baseStats']
    species = open(os.path.join(DECOMP, 'generated', 'species.txt')).read().split()
    hg_learners = {species[i] for i in range(1, HG_SPECIES + 1) if 5 in hg[i]['hms']}
    done = os.path.join(DECOMP, 'res', 'items', 'data', 'hm09.json')
    first_run = not os.path.exists(done)
    counts = {'defog': 0, 'whirlpool': 0, 'files': 0}
    for path in sorted(glob.glob(os.path.join(DECOMP, 'res', 'pokemon', '**', 'data.json'), recursive=True)):
        text = open(path, encoding='utf-8').read()
        data = json.loads(text)
        learnset = data.get('learnset') or {}
        tms = learnset.get('by_tm') or []
        rel = os.path.relpath(path, os.path.join(DECOMP, 'res', 'pokemon')).split(os.sep)
        constant = 'SPECIES_' + rel[0].upper()
        if len(rel) == 2 and constant in species and species.index(constant) <= HG_SPECIES:
            whirlpool = constant in hg_learners
        else:  # a later species, or a form
            by_level = [move for _, move in learnset.get('by_level') or []]
            whirlpool = 'HM03' in tms or 'MOVE_WHIRLPOOL' in by_level
        # On the first run, HM05 is Defog; afterwards HM09 is
        defog = ('HM05' in tms) if first_run else ('HM09' in tms)
        m = re.search(r'("by_tm": \[)(.*?)(\n(\s*)\])', text, re.S)
        if m is None:
            continue
        entries = re.findall(r'"([TH]M\d+)"', m.group(2))
        new = sorted([e for e in entries if e not in ('HM05', 'HM09')] + (['HM09'] if defog else []) +
                     (['HM05'] if whirlpool else []), key=machine_key)
        counts['defog'] += defog
        counts['whirlpool'] += whirlpool
        if new == entries:
            continue
        indent = re.search(r'\n(\s*)"', m.group(2)).group(1) if entries else m.group(4) + '    '
        text = text[:m.start(2)] + ','.join(f'\n{indent}"{e}"' for e in new) + text[m.end(2):]
        assert re.findall(r'"([TH]M\d+)"', json.dumps(json.loads(text)['learnset']['by_tm'])) == new, path
        open(path, 'w', encoding='utf-8').write(text)
        counts['files'] += 1

    items = os.path.join(DECOMP, 'res', 'items', 'data')
    hm05 = os.path.join(items, 'hm05.json')
    text = open(hm05, encoding='utf-8').read()
    end = '\n' if text.endswith('\n') else ''
    if first_run:  # HM05 as it was is HM09
        hm09 = json.loads(text)
        hm09.update(name='HM09', plural='HM09s', gbaID='GBA_ITEM_NONE')
        open(done, 'w', encoding='utf-8').write(json.dumps(hm09, indent=2, ensure_ascii=False) + end)
    data = json.loads(text)
    data.update(description=WHIRLPOOL_DESCRIPTION, teachesMove='MOVE_WHIRLPOOL')
    data['icon']['palette'] = 'tm_water_NCLR'
    open(hm05, 'w', encoding='utf-8').write(json.dumps(data, indent=2, ensure_ascii=False) + end)

    listing = os.path.join(DECOMP, 'generated', 'items.txt')
    names = open(listing).read().split('\n')
    if 'ITEM_HM09' not in names:
        names.insert(names.index('MAX_ITEMS'), 'ITEM_HM09')
        open(listing, 'w').write('\n'.join(names))
    print(f'{counts["files"]} species files rewritten; {counts["whirlpool"]} learn Whirlpool (HM05), '
          f'{counts["defog"]} Defog (HM09)')


if __name__ == '__main__':
    main()
