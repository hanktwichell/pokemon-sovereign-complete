#!/usr/bin/env python3
"""Bring in Johto's and Kanto's item balls and hidden items (step 4; docs/SacredGold.md).

Item balls: HeartGold runs script 7000 + n for item ball n, which puts the item and count in VAR_SPECIAL_x8008 and
x8009 and goes to the giving script (scr_seq_0141). Sacred Gold's 255 (as tools/complete/disasm_hgss_scripts.py
writes them, in .cache/sacredgold/scr_seq) become entries of Platinum's res/field/scripts/scripts_visible_items.s after
its own, so ball n is script 7000 + ITEM_BALLS_START + n; each goes to Platinum's VisibleItems_TryGiveItem, which does
what HeartGold's giving script does. They are named after the first map with that ball (VisibleItems_HGSS_Route29_Potion),
or Unused.

Hidden items: HeartGold keeps its table in its code (sHiddenItemParam: item, count and script for each), read here from
Sacred Gold's ROM at the place HeartGold's build puts it (the same 231 items as HeartGold's). They become
include/data/field/hgss_hidden_items.h, entries of Platinum's gHiddenItems from script 8000 + HIDDEN_ITEMS_START (8300),
which keep HeartGold's own flags (its flag 800 + the item's number, FLAG_HGSS_HIDDENITEM_* in the save;
include/complete_items.h, Script_GetHiddenItemFlag).

tools/complete/import_hgss_events.py gives the maps' item balls and hidden items these scripts (item_ball_script,
hidden_item_script).

Usage: python3 tools/complete/import_hgss_field_items.py [SACRED_GOLD_ROM]   (reruns replace the earlier entries)
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402

ITEM_BALLS = 255
ITEM_BALLS_START = 328  # after Platinum's visible item scripts (7000-7327, VisibleItems_TryGiveItem the last)
OFF_MAP = 6666  # where Sacred Gold moves the item balls it takes away
HIDDEN_ITEMS_START = 300  # after Platinum's (include/complete_items.h, HGSS_HIDDEN_ITEMS_START)
SCRIPTS = os.path.join(DECOMP, 'res/field/scripts/scripts_visible_items.s')
HIDDEN_HEADER = os.path.join(DECOMP, 'include/data/field/hgss_hidden_items.h')
MARK = ("    // Sovereign Complete: Johto's and Kanto's item balls (tools/complete/import_hgss_field_items.py)\n",
        "    // end of Johto's and Kanto's item balls\n")
BODY_MARK = ("// Sovereign Complete: the scripts of Johto's and Kanto's item balls (their entries are above)\n",
             "// end of the scripts of Johto's and Kanto's item balls\n")


def item_ball_script(n):
    """The engine's script for HeartGold's item ball n (its script 7000 + n)."""
    return 7000 + ITEM_BALLS_START + n


def hidden_item_script(n):
    """The engine's script for HeartGold's hidden item n (its script 8000 + n)."""
    return 8000 + HIDDEN_ITEMS_START + n


def camel(name):
    words = name.split('_')
    return ''.join(w if re.fullmatch(r'(TM|HM)\d+', w) else w.capitalize() for w in words)


def item_balls(path):
    """[(item number, count)] for item balls 0-254, from the disassembled scr_seq_0141."""
    text = open(path).read()
    balls = re.findall(r'^scr_seq_0141_(\d{3}):\n\tSetVar VAR_SPECIAL_x8008, (\d+)\n\tSetVar VAR_SPECIAL_x8009, (\d+)\n',
                       text, re.M)
    assert [int(n) for n, _, _ in balls] == list(range(ITEM_BALLS)), 'scr_seq_0141 is not 255 item balls'
    return [(int(item), int(count)) for _, item, count in balls]


def hidden_items(rom_path):
    """[(item number, count, script number)] from the ROM's copy of HeartGold's sHiddenItemParam."""
    import ndspy.rom
    xmap = open(os.path.join(HG, 'build/heartgold.us/main.nef.xMAP')).read()
    address, size = (int(v, 16) for v in re.search(r'^\s+([0-9A-F]{8}) ([0-9A-F]{8}) \.rodata\s+sHiddenItemParam\b',
                                                    xmap, re.M).groups())
    arm9 = ndspy.rom.NintendoDSRom.fromFile(rom_path).loadArm9()
    section = next(s for s in arm9.sections if s.ramAddress <= address < s.ramAddress + len(s.data))
    table = section.data[address - section.ramAddress:address - section.ramAddress + size]
    entries = [struct.unpack_from('<HBBHH', table, i) for i in range(0, size, 8)]
    return [(item, count, script) for item, count, _, _, script in entries]


def ball_maps(rom_path):
    """{item ball: the name of the first map (in HeartGold's map order) with that ball}. Sacred Gold takes a ball off
    a map by moving it far outside (6666, 6666): those don't count."""
    import ndspy.narc
    import ndspy.rom
    from import_hgss_events import parse
    from import_hgss_headers import hg_headers
    rom = ndspy.rom.NintendoDSRom.fromFile(rom_path)
    events = [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName('a/0/3/2')).files]
    out = {}
    for name, fields in hg_headers():
        bank = int(re.fullmatch(r'NARC_zone_event_(\d{3})\w*_bin', fields['eventsBank']).group(1))
        for record in parse(events[bank])['objects']:
            if 7000 <= record[5] < 7000 + ITEM_BALLS and record[12] < OFF_MAP and record[13] < OFF_MAP:
                out.setdefault(record[5] - 7000, name[len('MAP_'):])
    return out


def std_names(prefix):
    """{number: HeartGold's std script name} for one kind (std_itemball_, std_hiddenitem_)."""
    text = open(os.path.join(HG, 'include/constants/std_script.h')).read()
    return {int(n): name for name, n in re.findall(rf'#define\s+({prefix}\w+)\s+(\d+)', text)}


def between(text, begin, end, block, anchor):
    """Replace the block between begin and end, or put it (with them) before anchor."""
    if begin in text:
        start = text.index(begin)
        return text[:start] + begin + block + end + text[text.index(end) + len(end):]
    at = text.index(anchor)
    return text[:at] + begin + block + end + text[at:]


def main():
    from import_hgss_trainers import Lookup
    from sacred_gold import SG_ITEMS

    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache/sacredgold.nds')
    lookup = Lookup()

    def item(n):
        return SG_ITEMS.get(n) or lookup('ITEM_', n)

    balls = item_balls(os.path.join(ROOT, '.cache/sacredgold/scr_seq/scr_seq_0141.s'))
    maps = ball_maps(rom_path)
    labels, bodies, seen = [], [], set()
    for n, (number, count) in enumerate(balls):
        if n == 56 and count == 436:  # Sacred Gold's Full Heal ball here gives 436: its count is a slip for 1
            count = 1
        name = item(number)
        label = f'VisibleItems_HGSS_{camel(maps[n]) if n in maps else f"Unused{item_ball_script(n)}"}_' \
                f'{camel(name[len("ITEM_"):])}'
        if label in seen:
            label += f'_{n}'
        seen.add(label)
        labels.append(f'    ScriptEntry {label}\n')
        bodies.append(f'{label}:\n    SetVar VAR_0x8008, {name}\n    SetVar VAR_0x8009, {count}\n'
                      f'    GoTo VisibleItems_TryGiveItem\n    End\n\n')

    text = open(SCRIPTS).read()
    platinum = text[:text.index(MARK[0])] if MARK[0] in text else text[:text.index('    ScriptEntryEnd\n')]
    assert platinum.count('    ScriptEntry ') == ITEM_BALLS_START, 'Platinum\'s visible item scripts changed in number'
    text = between(text, *MARK, ''.join(labels), '    ScriptEntryEnd\n')
    body = '\n' + ''.join(bodies).rstrip('\n') + '\n'
    if BODY_MARK[0] in text:
        text = between(text, *BODY_MARK, body, '')
    else:
        text = text.rstrip('\n') + '\n\n' + BODY_MARK[0] + body + BODY_MARK[1]
    open(SCRIPTS, 'w').write(text)

    hidden = hidden_items(rom_path)
    assert sorted(s for _, _, s in hidden) == list(range(len(hidden))), 'hidden items are not numbered 0..n-1'
    std = std_names('std_hiddenitem_')
    width = max(len(item(i)) for i, _, _ in hidden)
    lines = [f'    {{ .item = {item(i) + ",":<{width + 1}} .qty = {count}, .range = 2, .pad = 0, '
             f'.script = HGSS_HIDDEN_ITEMS_START + {script:3} }}, // {std.get(8000 + script, "")}\n'
             for i, count, script in sorted(hidden, key=lambda h: h[2])]
    with open(HIDDEN_HEADER, 'w') as f:
        f.write('// Sovereign Complete: Johto\'s and Kanto\'s hidden items, entries of gHiddenItems (HeartGold\'s, as '
                'Sacred Gold has them),\n// generated by tools/complete/import_hgss_field_items.py. The script is '
                'HeartGold\'s hidden item number past\n// HGSS_HIDDEN_ITEMS_START (include/complete_items.h); the '
                'comment is HeartGold\'s name for it.\n// clang-format off\n' + ''.join(lines) + '// clang-format on\n')
    print(f'{len(balls)} item balls (scripts {item_ball_script(0)}-{item_ball_script(len(balls) - 1)}), '
          f'{len(hidden)} hidden items (scripts {hidden_item_script(0)}-{hidden_item_script(len(hidden) - 1)})')
    if lookup.missing:
        print('not in Sovereign\'s lists:', ' '.join(sorted(lookup.missing)))


if __name__ == '__main__':
    main()
