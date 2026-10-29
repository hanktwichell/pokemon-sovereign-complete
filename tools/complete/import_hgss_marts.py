#!/usr/bin/env python3
"""Bring in Johto's and Kanto's Poké Mart stock (step 4; docs/SacredGold.md).

A HeartGold clerk sets VAR_SPECIAL_x8004 and calls the common mart (std_pokemart: the stock every mart has, by badges,
the same table as Platinum's) or a special mart (std_special_mart: list x8004 of the 30 in its code, _0210FA3C in
src/scrcmd_mart.c). Sacred Gold edited 14 of those lists in place (TMs, evolution stones, its Mahogany TMs...), so they
are read from its ROM where HeartGold's build puts them. Each becomes a Platinum specialty mart after Platinum's,
MART_SPECIALTIES_ID_HGSS_00 to _29 (generated/mart_specialties_id.txt, include/data/mart_items.h, with the maps whose
clerks use it), and the script translation calls it with HeartGold's number past MART_SPECIALTIES_ID_HGSS_00
(tools/complete/hgss_script_table.py).

Usage: python3 tools/complete/import_hgss_marts.py [SACRED_GOLD_ROM]   (reruns replace the earlier entries)
"""
import collections
import glob
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402

IDS = os.path.join(DECOMP, 'generated/mart_specialties_id.txt')
ITEMS = os.path.join(DECOMP, 'include/data/mart_items.h')
ID_MARK = ('# Sovereign Complete: Johto\'s and Kanto\'s special marts (tools/complete/import_hgss_marts.py)\n',
           '# end of Johto\'s and Kanto\'s special marts\n')
LIST_MARK = ('// Sovereign Complete: Johto\'s and Kanto\'s special marts (tools/complete/import_hgss_marts.py)\n',
             '// end of Johto\'s and Kanto\'s special marts\n')
TABLE_MARK = ('    // Sovereign Complete: Johto\'s and Kanto\'s\n', '    // end of Johto\'s and Kanto\'s\n')


def mart_lists(rom_path):
    """[[item number]] for HeartGold's special marts, from the ROM's copy of its table."""
    import ndspy.rom
    xmap = open(os.path.join(HG, 'build/heartgold.us/main.nef.xMAP')).read()
    address, size = (int(v, 16) for v in re.search(r'^\s+([0-9A-F]{8}) ([0-9A-F]{8}) \.\w+\s+_0210FA3C\b',
                                                    xmap, re.M).groups())
    arm9 = ndspy.rom.NintendoDSRom.fromFile(rom_path).loadArm9()

    def read(at, length):
        section = next(s for s in arm9.sections if s.ramAddress <= at and at + length <= s.ramAddress + len(s.data))
        return section.data[at - section.ramAddress:at - section.ramAddress + length]

    out = []
    for pointer in struct.unpack(f'<{size // 4}I', read(address, size)):
        items = []
        while (item := struct.unpack('<H', read(pointer + 2 * len(items), 2))[0]) != 0xFFFF:
            items.append(item)
        out.append(items)
    return out


def users():
    """{special mart: [the maps whose clerks call it]}, from Sacred Gold's disassembled scripts."""
    from import_hgss_headers import camel, hg_headers
    by_scripts = {}
    for name, fields in hg_headers():
        by_scripts.setdefault(re.match(r'scr_seq_(\d{4})', fields['scriptsBank']).group(1), camel(name[len('MAP_'):]))
    out = collections.defaultdict(list)
    for path in sorted(glob.glob(os.path.join(ROOT, '.cache/sacredgold/scr_seq/scr_seq_*.s'))):
        text = open(path).read()
        for n in re.findall(r'SetVar VAR_SPECIAL_x8004, (\d+)\n(?:\t.*\n){0,2}?\tCallStd std_special_mart\b', text):
            where = by_scripts.get(re.match(r'scr_seq_(\d{4})', os.path.basename(path)).group(1), 'Common')
            if where not in out[int(n)]:
                out[int(n)].append(where)
    return out


def between(text, begin, end, block, anchor):
    if begin in text:
        return text[:text.index(begin)] + begin + block + end + text[text.index(end) + len(end):]
    at = text.index(anchor)
    return text[:at] + begin + block + end + text[at:]


def main():
    from import_hgss_trainers import Lookup
    from sacred_gold import SG_ITEMS

    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache/sacredgold.nds')
    lookup = Lookup()
    lists = mart_lists(rom_path)
    used = users()
    names = [f'MART_SPECIALTIES_ID_HGSS_{n:02d}' for n in range(len(lists))]

    text = open(IDS).read()
    if ID_MARK[0] in text:
        text = text[:text.index(ID_MARK[0])] + text[text.index(ID_MARK[1]) + len(ID_MARK[1]):]
    open(IDS, 'w').write(text.rstrip('\n') + '\n' + ID_MARK[0] + ''.join(f'{n}\n' for n in names) + ID_MARK[1])

    blocks = []
    for n, items in enumerate(lists):
        where = ', '.join(used.get(n, [])) or 'no clerk'
        blocks.append(f'// {where}\nconst u16 HGSSMartSpecialties_{n:02d}[] = {{\n' +
                      ''.join(f'    {SG_ITEMS.get(i) or lookup("ITEM_", i)},\n' for i in items) +
                      '    SHOP_ITEM_END\n};\n\n')
    text = open(ITEMS).read()
    text = between(text, *LIST_MARK, '\n' + ''.join(blocks), 'const u16 *PokeMartSpecialties[] = {')
    start = text.index('const u16 *PokeMartSpecialties[] = {')
    close = text.index('\n};\n', start) + 1
    table = text[start:close]
    if TABLE_MARK[0] in table:
        table = table[:table.index(TABLE_MARK[0])] + table[table.index(TABLE_MARK[1]) + len(TABLE_MARK[1]):]
    last = table.rstrip('\n').splitlines()[-1]
    if not last.rstrip().endswith(','):
        table = table.replace(last + '\n', last + ',\n')
    table += TABLE_MARK[0] + ''.join(f'    [{name}] = HGSSMartSpecialties_{n:02d},\n' for n, name in enumerate(names)) \
        + TABLE_MARK[1]
    open(ITEMS, 'w').write(text[:start] + table + text[close:])
    print(f'{len(lists)} special marts ({sum(1 for n in range(len(lists)) if n in used)} with a clerk)')
    if lookup.missing:
        print('not in Sovereign\'s lists:', ' '.join(sorted(lookup.missing)))


if __name__ == '__main__':
    main()
