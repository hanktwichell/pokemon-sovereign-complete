#!/usr/bin/env python3
"""Add HeartGold's items that Sovereign lacks to its item list (step 3; docs/ScriptConversion.md).

Sovereign keeps one JSON file per item (decomp/res/items/data/<name>.json: name, description, price, pocket, effects,
icon), an icon as a 32x32 indexed PNG and a palette (res/items/icons, listed in its meson.build and in
res/items/item_icon.order), and the item's name in generated/items.txt, before MAX_ITEMS. Sovereign's numbers past
Platinum's are later games' items, so HeartGold's items get new numbers and scripts name them (ITEM_RED_APRICORN).

From HeartGold (.cache/pokeheartgold): the data (files/itemtool/itemdata/item_data.csv), the names, plurals, articles
and descriptions (msg_0222, msg_0224, msg_0223, msg_0221) and the icons (src/item.c names each item's NCGR and NCLR in
files/itemtool/itemdata/item_icon/, converted with nitrogfx; they convert back byte for byte).

The items: the S.S. Ticket (Platinum's item at its number is the Tea) and HeartGold's own from the Apricorn Box on,
except the Pokéathlon's 27 data cards (the Pokéathlon is skipped) and the ones Sovereign has (the Silver and
Rainbow Wings, the Red and Blue Orbs). Kurt's balls are in the Poké Balls pocket but can't be thrown until their
catch rules and graphics come (step 5); the Apricorn Box, Berry Pots, Dowsing Machine, Unown Report and GB Sounds
are key items with no use until their features come.

Sacred Gold's own items follow (step 4; docs/SacredGold.md): six items it put in slots HeartGold doesn't use (the
Journal, Seal Bag, Works Key, Old Charm, Member Card and Secret Key), each used from the bag like an evolution stone
in place of a trade or a place (src/complete_evolutions.c): the Covenant Orb, Voltaic Ore, Woodland Ore, Chilled Ore,
Aubade Orb and Serenade Orb. Their data, names, descriptions and icons come from Sacred Gold's ROM; their plurals are
made from the names, as Sacred Gold kept the old items'.

Usage: python3 tools/complete/import_hgss_items.py [SACRED_GOLD_ROM]   (reruns replace the earlier entries)
"""
import csv
import json
import os
import re
import struct
import subprocess
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402
from sacred_gold import SG_ITEMS as SACRED_GOLD, USE_EVO_STONE  # noqa: E402

ITEMS_DIR = os.path.join(DECOMP, 'res/items')
NITROGFX = os.path.join(DECOMP, 'build/tools/nitrogfx/nitrogfx')
HG_ICONS = os.path.join(HG, 'files/itemtool/itemdata/item_icon')
RENAMED = {'ITEM_S_S__TICKET': 'ITEM_SS_TICKET'}
SOVEREIGN_HAS = ['ITEM_SILVER_WING', 'ITEM_RAINBOW_WING', 'ITEM_RED_ORB', 'ITEM_BLUE_ORB']
PNG_MARK = ("    # Sovereign Complete: HeartGold's items (tools/complete/import_hgss_items.py)\n",
            "    # end of HeartGold's items\n")


def hg_item_numbers():
    numbers = {}
    for line in open(os.path.join(HG, 'include/constants/items.h')):
        m = re.match(r'#define\s+(ITEM_\w+)\s+(\d+)\s*$', line)
        if m:
            numbers[m.group(1)] = int(m.group(2))
    return numbers


def wanted(numbers):
    """[(HeartGold's number, its name, the engine's name)] for the items to add."""
    return [(n, name, RENAMED.get(name, name)) for name, n in sorted(numbers.items(), key=lambda kv: kv[1])
            if (n == 456 or n >= 468) and not name.startswith('ITEM_DATA_CARD_') and name not in SOVEREIGN_HAS]


def messages(bank):
    path = os.path.join(HG, f'files/msgdata/msg/msg_{bank}.json')
    return [m.get('en_US') for m in json.load(open(path, encoding='utf-8'))['messages']]


def icon_indices():
    """{HeartGold's item: (its icon's NCGR, its NCLR, its data file)}, from src/item.c (Sacred Gold's are the same)."""
    text = open(os.path.join(HG, 'src/item.c')).read()
    return {m.group(1): (int(m.group(3)), int(m.group(4)), int(m.group(2))) for m in re.finditer(
        r'\[(ITEM_\w+)\]\s*=\s*\{\s*NARC_item_data_(\d+)_bin,\s*NARC_item_icon_item_icon_(\d+)_NCGR,'
        r'\s*NARC_item_icon_item_icon_(\d+)_NCLR', text)}


def item_json(stem, name, plural, article, description, price, pocket, prevent_toss=False, fling_power=0,
              field_use='ITEM_USE_FUNC_NONE'):
    return {
        'name': name,
        'plural': plural,
        'article': article,
        'description': description,
        'icon': {'sprite': f'{stem}_NCGR', 'palette': f'{stem}_NCLR'},
        'gbaID': 'GBA_ITEM_NONE',
        'price': price,
        'effectParam': 0,
        'holdEffect': 'HOLD_EFFECT_NONE',
        'pluckEffect': 'PLUCK_EFFECT_NONE',
        'flingEffect': 'FLING_EFFECT_NONE',
        'flingPower': fling_power,
        'naturalGiftPower': 0,
        'naturalGiftType': None,
        'preventToss': prevent_toss,
        'canRegister': False,  # the key items HeartGold registers have no use yet
        'fieldPocket': pocket,
        'battlePocket': 'BATTLE_POCKET_MASK_NONE',  # Kurt's balls: thrown from step 5
        'fieldUseFunc': field_use,
        'battleUseCategory': 'BATTLE_USE_CATEGORY_NONE',
        'itemUseParams': {} if field_use == 'ITEM_USE_FUNC_EVO_STONE' else None,
    }


def hg_item_json(stem, row, name, plural, article, description):
    ball = row['fieldPocket'] == 'POCKET_BALLS'
    if row['holdEffect'] != 'HOLD_EFFECT_NONE' or not (ball or row['battlePocket'] == '0'):
        sys.exit(f"{stem}: HeartGold gives it effects the importer doesn't carry over")
    return item_json(stem, name, plural, article, description, int(row['price']), row['fieldPocket'],
                     row['prevent_toss'] == 'true')


def sacred_gold_items(rom_path, icons):
    """[(engine name, item JSON, NCGR bytes, NCLR bytes)] for Sacred Gold's items, from its ROM."""
    import ndspy.narc
    import ndspy.rom
    from import_hgss_text import usual_arg_counts
    from import_hgss_trainers import decode_bank

    def archive(rom, path):
        return [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName(path)).files]

    rom = ndspy.rom.NintendoDSRom.fromFile(rom_path)
    hg_rom = ndspy.rom.NintendoDSRom.fromFile(os.path.join(ROOT, '.cache/heartgold.nds'))
    usual = usual_arg_counts(archive(hg_rom, 'a/0/2/7'))
    banks = archive(rom, 'a/0/2/7')
    names, articles, descriptions = (decode_bank(banks[b], usual) for b in (222, 223, 221))
    data, graphics = archive(rom, 'a/0/1/7'), archive(rom, 'a/0/1/8')
    hg_names = {n: name for name, n in hg_item_numbers().items()}
    out = []
    for n, name in SACRED_GOLD.items():
        ncgr, nclr, index = icons[hg_names[n]]
        price, hold_effect, _, _, _, fling_power = struct.unpack_from('<HBBBBB', data[index], 0)
        bits, field_use = struct.unpack_from('<HB', data[index], 8)
        if hold_effect or (bits >> 7) & 0xF or field_use != USE_EVO_STONE:
            sys.exit(f"{name}: Sacred Gold gives it effects the importer doesn't carry over")
        title = names[n]['en_US']
        text = descriptions[n]['en_US']
        stem = name[len('ITEM_'):].lower()
        out.append((name, item_json(stem, title, title + 's', articles[n]['en_US'].split('{', 1)[0].strip(),
                                    text if isinstance(text, list) else [text], price, 'POCKET_ITEMS',
                                    fling_power=fling_power, field_use='ITEM_USE_FUNC_EVO_STONE'),
                    graphics[ncgr], graphics[nclr]))
    return out


def write_icon(stem, ncgr, nclr):
    subprocess.run([NITROGFX, ncgr, os.path.join(ITEMS_DIR, 'icons', f'{stem}.png'), '-palette', nclr, '-width', '4'],
                   check=True)
    subprocess.run([NITROGFX, nclr, os.path.join(ITEMS_DIR, 'icons', f'{stem}.pal')], check=True)


def replace_block(text, list_name, entries):
    """Put entries at the end of the meson list `list_name = files(...)`, between PNG_MARK's lines."""
    start = text.index(f'{list_name} = files(')
    end = text.index('\n)\n', start)
    body = text[start:end + 1]
    if PNG_MARK[0] in body:
        body = body[:body.index(PNG_MARK[0])] + body[body.index(PNG_MARK[1]) + len(PNG_MARK[1]):]
    body += PNG_MARK[0] + ''.join(f"    '{e}',\n" for e in entries) + PNG_MARK[1]
    return text[:start] + body.rstrip('\n') + text[end:]


def main():
    items_txt = os.path.join(DECOMP, 'generated/items.txt')
    numbers = hg_item_numbers()
    items = wanted(numbers)
    ours_names = {name for _, _, name in items} | set(SACRED_GOLD.values())
    norm = lambda name: name.replace('_', '')  # noqa: E731
    # a rerun replaces this importer's earlier entries
    ours = [line for line in open(items_txt).read().splitlines() if line.strip() and line not in ours_names]
    if missing := [name for name in SOVEREIGN_HAS if name not in ours]:
        sys.exit(f'not in Sovereign\'s list any more: {missing}')
    if clashes := [name for name in ours_names if norm(name) in {norm(o) for o in ours}]:
        sys.exit(f'already in Sovereign\'s list (add them to SOVEREIGN_HAS): {clashes}')

    rows = {r['item']: r for r in csv.DictReader(open(os.path.join(HG, 'files/itemtool/itemdata/item_data.csv')))}
    names, plurals, articles, descriptions = (messages(b) for b in ('0222', '0224', '0223', '0221'))
    icons = icon_indices()
    new_names, stems = [], []
    for n, hg_name, name in items:
        stem = name[len('ITEM_'):].lower()
        article = articles[n].split('{', 1)[0].strip()
        data = hg_item_json(stem, rows[hg_name], names[n], plurals[n], article, descriptions[n])
        with open(os.path.join(ITEMS_DIR, 'data', f'{stem}.json'), 'w', encoding='utf-8') as f:
            f.write(json.dumps(data, indent=2, ensure_ascii=False) + '\n')
        ncgr, nclr, _ = icons[hg_name]
        write_icon(stem, os.path.join(HG_ICONS, f'item_icon_{ncgr:03}.NCGR'),
                   os.path.join(HG_ICONS, f'item_icon_{nclr:03}.NCLR'))
        new_names.append(name)
        stems.append(stem)

    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache/sacredgold.nds')
    with tempfile.TemporaryDirectory() as tmp:
        for name, data, ncgr, nclr in sacred_gold_items(rom_path, icons):
            stem = name[len('ITEM_'):].lower()
            with open(os.path.join(ITEMS_DIR, 'data', f'{stem}.json'), 'w', encoding='utf-8') as f:
                f.write(json.dumps(data, indent=2, ensure_ascii=False) + '\n')
            for suffix, content in (('NCGR', ncgr), ('NCLR', nclr)):
                open(os.path.join(tmp, f'{stem}.{suffix}'), 'wb').write(content)
            write_icon(stem, os.path.join(tmp, f'{stem}.NCGR'), os.path.join(tmp, f'{stem}.NCLR'))
            new_names.append(name)
            stems.append(stem)

    max_at = ours.index('MAX_ITEMS')
    open(items_txt, 'w').write('\n'.join(ours[:max_at] + new_names + ours[max_at:]) + '\n')

    meson = os.path.join(ITEMS_DIR, 'icons/meson.build')
    text = open(meson).read()
    text = replace_block(text, 'item_icon_pngs', [f'{s}.png' for s in stems])
    text = replace_block(text, 'item_icon_pals', [f'{s}.pal' for s in stems])
    open(meson, 'w').write(text)

    order = os.path.join(ITEMS_DIR, 'item_icon.order')
    old = {f'{s}.{kind}' for s in stems for kind in ('NCGR', 'NCLR')}
    entries = [line for line in open(order).read().splitlines() if line and line not in old]
    entries += [f'{s}.{kind}' for s in stems for kind in ('NCGR', 'NCLR')]
    open(order, 'w').write('\n'.join(entries) + '\n')
    print(f'{len(new_names)} items added before MAX_ITEMS: {" ".join(new_names)}')


if __name__ == '__main__':
    main()
