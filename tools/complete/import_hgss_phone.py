#!/usr/bin/env python3
"""Bring in HeartGold's phone data (src/complete_phone.c), as decomp/include/data/hgss_phone.h and
decomp/include/constants/hgss_phone.h:

- The phone book (Sacred Gold's tel/pmtel_book.dat, HeartGold's layout): for each of the 75 contacts, the kind of
  caller, the greeting, the trainer, the map they're on (MAP_HEADER_HGSS_*), the gift they give after a rematch, the
  call they make when the player is on that map, the day and time of their rematch, how often they call (one of three
  groups: half of HeartGold's random calls come from the first, three in ten from the second), whether they're a
  Fisherman (who talk of what bites), and their text bank (TEXT_BANK_HGSS_MSG_*, HeartGold's GetPhoneMessageGmm).
- The rematch sets (HeartGold's sTrainerRematchSets, overlay 26): a trainer's base number, then their teams in order.
- The call scripts (HeartGold's gPhoneCallScriptDef, overlay 101; 455 of them): the message for a boy and for a girl
  in the caller's bank, and what the call does (sets or clears a flag, asks for a rematch, keeps a gift for the player,
  or picks a word).
- What each contact may say when they call or are called (HeartGold's sGenericPhoneCallHeaders): eight checks for an
  outgoing call and eight for an incoming one, the first that passes giving the call script.
- The greetings (HeartGold's sGreetingMsgIDs, in bank 640): by greeting kind, outgoing or incoming, time of day and
  the player's gender.

The tables come from HeartGold's source; Sacred Gold's overlays 26 and 101 hold the same bytes, which this checks.

Usage: python3 tools/complete/import_hgss_phone.py [--rom .cache/sacredgold.nds]
"""
import argparse
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from hgss_script_table import hg_map_header  # noqa: E402
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402
from translate_hgss_scripts import Names, defines  # noqa: E402

OUT = os.path.join(DECOMP, 'include', 'data', 'hgss_phone.h')
CONSTANTS = os.path.join(DECOMP, 'include', 'constants', 'hgss_phone.h')
PHONE = os.path.join(HG, 'src', 'application', 'pokegear', 'phone')
CONTACTS = 75


def hg_values(*headers):
    out = {}
    for header in headers:
        text = open(os.path.join(HG, header)).read()
        for name, value in re.findall(r'#define\s+(\w+)\s+(\d+|0x[0-9a-fA-F]+)\b', text):
            out.setdefault(name, int(value, 0))
    return out


def enum_values(path, first):
    """An enum's names and values, from its first name on (each one more than the last unless set)."""
    text = open(path).read()
    body = text[text.index(first):]
    body = body[:body.index('}')]
    out, n = {}, 0
    for name, value in re.findall(r'(\w+)\s*(?:=\s*(\d+))?\s*,', body):
        n = int(value) if value else n
        out[name] = n
        n += 1
    return out


def message_number(name):
    """msg_0716_00033 -> 33"""
    return int(re.match(r'msg_\d{4}_(\d+)$', name).group(1))


def script_defs(hg):
    text = open(os.path.join(PHONE, 'phone_script_defs.c')).read()
    text = text[text.index('gPhoneCallScriptDef[] = {'):]
    rows = [(0, 0, 0, 0, '0')]  # the empty one
    for m0, m1, kind, param0, param1 in re.findall(
            r'\{\s*\.msgIds = \{ (\w+), (\w+) \},\s*\.scriptType = (\w+),\s*\.param0 = (\w+),\s*\.param1 = (\w+),\s*\}',
            text):
        rows.append((message_number(m0), message_number(m1), hg[kind], int(param0, 0), param1))
    return rows


def generic_headers(hg, kinds):
    text = open(os.path.join(PHONE, 'phone_generic_headers.c')).read()
    text = text[text.index('sGenericPhoneCallHeaders[] = {'):]
    term = (kinds['PHONECALLGENERIC_NIL'], 100, 0, 0)
    null = (kinds['PHONECALLGENERIC_NONE'], 0, 0, 0)
    rows = []
    for t, kind, chance, script_type, script in re.findall(
            r'(PHONE_GENERIC_TERM|PHONE_GENERIC_NULL)|\{\s*\.type = (\w+),\s*\.chance = (\d+),\s*\.scriptType = (\d+),'
            r'\s*\.scriptID = (\w+),\s*\}', text):
        if t:
            rows.append(term if t == 'PHONE_GENERIC_TERM' else null)
        else:
            rows.append((kinds[kind], int(chance), int(script_type), hg[script]))
    assert len(rows) == CONTACTS * 16, len(rows)
    return rows


def greetings():
    text = open(os.path.join(PHONE, 'phone_generic_headers.c')).read()
    text = text[text.index('sGreetingMsgIDs[][12] = {'):]
    text = text[:text.index('};')]
    return [[message_number(m) for m in re.findall(r'msg_\w+', row)] for row in re.findall(r'\{([^}]*)\}', text)]


def rematch_sets(hg_trainers):
    text = open(os.path.join(HG, 'src', 'overlay_26_022598C0.c')).read()
    text = text[text.index('sTrainerRematchSets'):]
    text = text[:text.index('};')]
    return [[hg_trainers[t] if t != 'TRAINER_NONE' else 0 for t in re.findall(r'TRAINER_\w+', row)]
            for row in re.findall(r'\{([^}]*)\}', text)]


def message_banks():
    text = open(os.path.join(HG, 'src', 'phonebook_dat.c')).read()
    return [m for m in re.findall(r'msg_(\d{4}), // PHONE_CONTACT_', text)]


def check_overlay(rom, overlay, blob, what):
    import ndspy.rom
    data = ndspy.rom.NintendoDSRom.fromFile(rom).loadArm9Overlays([overlay])[overlay].data
    if data.find(blob) < 0:
        raise SystemExit(f'{rom}: overlay {overlay} lacks HeartGold\'s {what}')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--rom', default=os.path.join(ROOT, '.cache', 'sacredgold.nds'))
    args = parser.parse_args()
    import ndspy.rom

    hg = hg_values('include/constants/phone_scripts.h', 'include/constants/items.h', 'include/constants/flags.h',
                   'include/constants/trainers.h', 'include/constants/trainer_class.h',
                   'include/constants/phone_constants.h')
    internal = os.path.join(HG, 'include', 'application', 'pokegear', 'phone', 'phone_internal.h')
    call_types = enum_values(internal, 'PHONECALLTYPE_GENERIC')
    generic_kinds = enum_values(internal, 'PHONECALLGENERIC_NIL')
    names = Names()
    hg_items = {v: k for k, v in defines(os.path.join(HG, 'include/constants/items.h'), 'ITEM_').items()}
    hg_flags = {v: k for k, v in names.hg_flags.items()}
    hg_trainer_names = {v: k for k, v in defines(os.path.join(HG, 'include/constants/trainers.h'), 'TRAINER_').items()}
    hg_trainers = {k: v for k, v in hg.items() if k.startswith('TRAINER_')}

    def item(n):
        return names.token(hg_items[n]) if n else 'ITEM_NONE'

    def trainer(n):
        return names.token(hg_trainer_names[n]) if n else 'TRAINER_NONE'

    defs = script_defs(hg)
    headers = generic_headers(hg, generic_kinds)
    sets = rematch_sets(hg_trainers)
    greeting_rows = greetings()
    banks = message_banks()
    assert len(banks) == CONTACTS

    # Sacred Gold's overlays hold HeartGold's tables
    def number(p1):
        return hg[p1] if p1 in hg else message_number(p1) if p1.startswith('msg_') else int(p1, 0)

    def_blob = b''.join(struct.pack('<BBHH', m0, m1, kind | p0 << 4, number(p1)) for m0, m1, kind, p0, p1 in defs)
    header_blob = b''.join(struct.pack('<BBHH', *row) for row in headers)
    set_blob = b''.join(struct.pack('<6H', *row) for row in sets)
    for rom in (os.path.join(ROOT, '.cache', 'heartgold.nds'), args.rom):
        check_overlay(rom, 101, def_blob, 'call scripts')
        check_overlay(rom, 101, header_blob, 'callers\' checks')
        check_overlay(rom, 26, set_blob, 'rematch sets')

    book = ndspy.rom.NintendoDSRom.fromFile(args.rom).getFileByName('tel/pmtel_book.dat')
    count = struct.unpack_from('<I', book)[0]
    assert count == CONTACTS, count
    contact_defines = re.findall(r'#define\s+(PHONE_CONTACT_\w+)\s+(\w+)',
                                 open(os.path.join(HG, 'include/constants/phone_contacts.h')).read())
    contacts = {int(v, 0): n for n, v in contact_defines if n not in ('PHONE_CONTACT_NONE', 'NUM_PHONE_CONTACTS')}

    def param1(kind, p1):
        if kind == hg['PHONESCRIPTTYPE_FLAG'] or kind == hg['PHONESCRIPTTYPE_UNK1']:
            return names.flag(p1) if p1.startswith('FLAG_') else (names.flag(hg_flags[int(p1, 0)]) or '0')
        if kind == hg['PHONESCRIPTTYPE_ITEM']:
            return names.token(p1) if p1.startswith('ITEM_') else item(int(p1, 0))
        return str(message_number(p1)) if p1.startswith('msg_') else p1

    out = ['// Generated by tools/complete/import_hgss_phone.py from Sacred Gold\'s phone book and HeartGold\'s phone',
           '// tables (src/complete_phone.c). Do not edit.', '',
           '#ifndef POKEPLATINUM_DATA_HGSS_PHONE_H', '#define POKEPLATINUM_DATA_HGSS_PHONE_H', '',
           '// type, greeting, rematch weekday, rematch time of day, call group, a Fisherman, trainer, map, gift, call',
           '// when on the same map, bank',
           'static const CompletePhoneBookEntry sPhoneBook[NUM_PHONE_CONTACTS] = {']
    for i in range(CONTACTS):
        (cid, ctype, _, trainer_class, trainer_id, map_id, gift, local, greet, weekday, time_of_day, group,
         *_) = struct.unpack_from('<BBBBHHHHBBBB4B', book, 4 + i * 20)
        assert cid == i, (cid, i)
        fishing = int(trainer_class == hg['TRAINERCLASS_FISHERMAN'])
        out.append(f'    [{contacts[i]}] = {{ {ctype}, {greet}, {weekday}, {time_of_day}, {group}, {fishing}, '
                   f'{trainer(trainer_id)}, {hg_map_header(str(map_id))}, {item(gift)}, {local}, '
                   f'TEXT_BANK_HGSS_MSG_{banks[i]} }},')
    out += ['};', '', '// A trainer\'s base number, then their teams in order (TRAINER_NONE: no more)',
            f'static const u16 sRematchSets[{len(sets)}][6] = {{']
    out += ['    { ' + ', '.join(trainer(t) for t in row) + ' },' for row in sets]
    out += ['};', '', '// The message for a boy and for a girl, the kind of call, and its two parameters',
            f'static const CompletePhoneScript sPhoneScripts[{len(defs)}] = {{']
    out += [f'    {{ {m0}, {m1}, {kind}, {p0}, {param1(kind, p1)} }},' for m0, m1, kind, p0, p1 in defs]
    out += ['};', '',
            '// Each contact\'s eight checks for an outgoing call, then eight for an incoming one: the kind of',
            '// check, the chance (%), the call\'s handler and the call script',
            f'static const CompletePhoneCheck sPhoneChecks[NUM_PHONE_CONTACTS * 16] = {{']
    out += [f'    {{ {kind}, {chance}, {script_type}, {script} }},' for kind, chance, script_type, script in headers]
    out += ['};', '',
            '// Bank 640\'s greetings: by greeting kind, outgoing then incoming, morning, day and night, a boy\'s',
            '// then a girl\'s',
            f'static const u8 sGreetings[{len(greeting_rows)}][12] = {{']
    out += ['    { ' + ', '.join(str(n) for n in row) + ' },' for row in greeting_rows]
    out += ['};', '', '#endif // POKEPLATINUM_DATA_HGSS_PHONE_H']
    open(OUT, 'w').write('\n'.join(out) + '\n')

    constants = ['// Generated by tools/complete/import_hgss_phone.py: HeartGold\'s phone contacts and kinds of call',
                 '// (src/complete_phone.c). Do not edit.', '',
                 '#ifndef POKEPLATINUM_CONSTANTS_HGSS_PHONE_H', '#define POKEPLATINUM_CONSTANTS_HGSS_PHONE_H', '']
    constants += [f'#define {name:<26} {n}' for n, name in sorted(contacts.items())]
    constants += [f'#define {"PHONE_CONTACT_NONE":<26} 0xFF', f'#define {"NUM_PHONE_CONTACTS":<26} {CONTACTS}', '']
    constants += [f'#define {name:<46} {n}' for name, n in call_types.items()]
    constants += ['']
    constants += [f'#define {name:<46} {n}' for name, n in generic_kinds.items()]
    constants += ['']
    constants += [f'#define {name:<46} {hg[name]}' for name in sorted(hg, key=hg.get)
                  if name.startswith('PHONESCRIPTTYPE_')]
    constants += ['', '// HeartGold\'s call triggers (src/overlay006/complete_phone_calls.c)']
    constants += [f'#define {name:<46} {hg[name]}' for name in sorted(hg, key=hg.get)
                  if name.startswith('CALL_TRIGGER_') or name == 'NUM_CALL_TRIGGERS']
    constants += ['', '#endif // POKEPLATINUM_CONSTANTS_HGSS_PHONE_H']
    open(CONSTANTS, 'w').write('\n'.join(constants) + '\n')
    print(f'{CONTACTS} contacts, {len(sets)} rematch sets, {len(defs)} call scripts, {len(headers)} checks, '
          f'{len(greeting_rows)} greeting kinds')


if __name__ == '__main__':
    main()
