#!/usr/bin/env python3
"""Bring in HeartGold's message banks that its maps and scripts use, as the engine's text banks (step 3).

HeartGold's banks (.cache/pokeheartgold/files/msgdata/msg/msg_NNNN*.json) have Platinum's layout and control codes
(docs/ScriptConversion.md), so they are copied as they are: bank NNNN becomes res/text/hgss_msg_NNNN.json and
TEXT_BANK_HGSS_MSG_NNNN, appended to generated/text_banks.txt (a bank's number is its line there). The message IDs
stay HeartGold's (msg_0604_T26_00000), so translated scripts name them unchanged.

The banks: each map header's, each one a script includes or names a message from, the four shared banks scripts
open by number (GetStdMsgNaix), the shared menu entries (msg_0191), the Safari Zone's names (msg_0428, msg_0430),
Elm's lines in the starter choice (msg_0190), and the naming screen's prompts and default names (msg_0249, msg_0254).
generated/text_banks.txt takes no comments, so a rerun recognises its earlier entries by their TEXT_BANK_HGSS_ prefix.

With --rom ROM (Sacred Gold's: .cache/sacredgold.nds), the text comes from that ROM's message archive (a/0/2/7),
decoded with the engine's msgenc (decomp/build/tools/msgenc; decoding HeartGold's own ROM so gives back all of its
sources' text). The names and keys stay HeartGold's; a message a bank gained gets the next name in its bank's pattern
(msg_0047_D01R0101_00019). --scripts DIR reads the scripts from DIR (Sacred Gold's, disassembled by
tools/complete/disasm_hgss_scripts.py) to find the banks they name.

Usage: python3 tools/complete/import_hgss_text.py [--rom ROM] [--scripts DIR]
"""
import collections
import glob
import json
import os
import re
import struct
import subprocess
import sys
import tempfile

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402

MSGENC = os.path.join(DECOMP, 'build/tools/msgenc')

PREFIX = 'TEXT_BANK_HGSS_MSG_'
# GetStdMsgNaix's four banks, the menu entries, the Safari Zone's area and object names (src/complete_safari.c), Elm's
# lines in the starter choice (src/choose_starter/choose_starter_app.c), and the naming screen's prompts and default
# names, for Johto's rival (src/applications/naming_screen.c); the phone's (src/complete_phone.c): its own lines
# (msg_0271), the callers' greetings (msg_0640) and each contact's bank (msg_0641 to msg_0716, all but msg_0668); the
# Ruins of Alph puzzles' (msg_0002, src/applications/complete_alph_puzzle.c); and the following Pokémon's talk
# (msg_0265, src/overlay006/complete_follower_talk.c)
SHARED = ['0752', '0211', '0030', '0435', '0191', '0428', '0430', '0190', '0249', '0254', '0271', '0640'] + \
    [f'{n:04d}' for n in range(641, 717) if n != 668] + ['0002', '0265']
# Sacred Gold's lines too long for Platinum's message box (tools/test/check_message_box_lines.py): its own text, with
# the line breaks moved (or, where a box is narrower, the words)
TEXT_FIXES = {
    'msg_0584_T25R0201_00048': ['Woah! Isn’t that item you have there\n', 'what they call the Enigma Stone?\r',
                                'I heard about Steven’s excavation\n', 'of that!\r', 'Can I please take\n',
                                'a look at it!? {YESNO 0}'],
    'msg_0047_D01R0101_00016': ['Brock: Thank you!\n', 'I have been looking for Bonsly!\r',
                                'The Rhyperior I gave you knows\n', 'the move Fissure!\r',
                                'It rarely learns that move!\r', 'I’m so proud of it, because it can\n',
                                'take down loads of Pokémon that\f', 'are usually a tough matchup.\r',
                                'Take good care of it for me!'],
    'msg_0047_D01R0101_00017': ['Brock: The Rhyperior I gave you\n', 'knows the move Fissure!\r',
                                'It rarely learns that move!\r', 'I’m so proud of it, because it can\n',
                                'take down loads of Pokémon that\f', 'are usually a tough matchup.\r',
                                'Take good care of it for me!\n', '\n'],
    'msg_0574_T24GYM0101_00015': ['Chuck: I bet you’d make a great\n', 'training partner!\r',
                                  'Here, take my number!\r', '... ... ...\r'],
    'msg_0590_T25R0801_00014': ['That was enjoyable...\n', 'I like battling with you...\r', 'Just a tiny bit.'],
    # Elm's questions in Platinum's starter scene, whose yes/no box covers the end of a long first line: without his
    # name, as Platinum's own questions there are
    'msg_0190_00001': ['So, you like {COLOR 3}Chikorita{COLOR 0},\n', 'the Grass-type Pokémon?'],
    'msg_0190_00002': ['You’ll take {COLOR 1}Cyndaquil{COLOR 0},\n', 'the Fire-type Pokémon?'],
    'msg_0190_00003': ['Do you want {COLOR 2}Totodile{COLOR 0},\n', 'the Water-type Pokémon?'],
}


def wanted_banks(scripts):
    banks = set(SHARED)
    banks |= set(re.findall(r'\.msgBank\s*=\s*msg_(\d{4})', open(os.path.join(HG, 'src/data/map_headers.h')).read()))
    for path in glob.glob(os.path.join(scripts, 'scr_seq_*.s')):
        text = open(path, errors='replace').read()
        banks |= set(re.findall(r'#include "msgdata/msg/msg_(\d{4})', text))
        banks |= set(re.findall(r'\bmsg_(\d{4})\w*?_\d{5}\b', text))
    return sorted(banks)


def read_bank(data):
    """(key, [message as a list of 16-bit codes]) from an encrypted bank (msgenc's scheme,
    tools/msgenc/MessagesConverter.h)."""
    count, key = struct.unpack_from('<HH', data, 0)
    messages = []
    for i in range(1, count + 1):
        alloc_key = (765 * i * key) & 0xFFFF
        alloc_key |= alloc_key << 16
        offset, length = (v ^ alloc_key for v in struct.unpack_from('<II', data, 4 + 8 * (i - 1)))
        seed, codes = (i * 596947) & 0xFFFF, []
        for j in range(length):
            codes.append(struct.unpack_from('<H', data, offset + 2 * j)[0] ^ seed)
            seed = (seed + 18749) & 0xFFFF
        messages.append(codes)
    return key, messages


def write_bank(key, messages):
    out = bytearray(struct.pack('<HH', len(messages), key))
    offset = 4 + 8 * len(messages)
    body = bytearray()
    for i, codes in enumerate(messages, 1):
        alloc_key = (765 * i * key) & 0xFFFF
        alloc_key |= alloc_key << 16
        out += struct.pack('<II', (offset + len(body)) ^ alloc_key, len(codes) ^ alloc_key)
        seed = (i * 596947) & 0xFFFF
        for c in codes:
            body += struct.pack('<H', c ^ seed)
            seed = (seed + 18749) & 0xFFFF
    return bytes(out + body)


def usual_arg_counts(banks):
    """{control code: the number of arguments it has most often} over a ROM's banks."""
    counts = collections.defaultdict(collections.Counter)
    for data in banks:
        for codes in read_bank(data)[1]:
            j = 0
            while j + 2 < len(codes):
                if codes[j] == 0xFFFE:
                    counts[codes[j + 1]][codes[j + 2]] += 1
                    j += 3 + codes[j + 2]
                else:
                    j += 1
    return {code: c.most_common(1)[0][0] for code, c in counts.items()}


def repair_bank(data, usual):
    """data with each control code whose argument count runs past the message's end given its usual count (Sacred
    Gold's editor left out a {ALN_CENTER}'s 0 and wrote a stray count once, which stop msgenc), and what was
    repaired."""
    key, messages = read_bank(data)
    repaired = []
    for i, codes in enumerate(messages):
        j = 0
        while j + 1 < len(codes):
            if codes[j] != 0xFFFE:
                j += 1
                continue
            command = codes[j + 1]
            if j + 2 >= len(codes) or j + 3 + codes[j + 2] > len(codes):
                if usual.get(command) == 0:
                    codes.insert(j + 2, 0)  # the count was left out
                elif command in usual:
                    codes[j + 2] = usual[command]
                else:
                    codes[j:] = [0xFFFF] * (len(codes) - j)
                repaired.append(i)
            j += 3 + codes[j + 2] if j + 2 < len(codes) else len(codes)
    return (write_bank(key, messages) if repaired else data), repaired


def rom_banks(rom_path):
    """The ROM's message banks, decoded: {bank number: messages}."""
    import ndspy.narc
    import ndspy.rom
    def banks(path):
        return ndspy.narc.NARC(ndspy.rom.NintendoDSRom.fromFile(path).getFileByName('a/0/2/7')).files

    usual = usual_arg_counts(banks(os.path.join(os.path.dirname(HG), 'heartgold.nds')))
    out = {}
    with tempfile.TemporaryDirectory() as tmp:
        for n, data in enumerate(banks(rom_path)):
            data, repaired = repair_bank(data, usual)
            if repaired:
                print(f'msg_{n:04}: messages {repaired}: a control code\'s argument count repaired')
            open(os.path.join(tmp, 'bank.bin'), 'wb').write(data)
            subprocess.run([os.path.join(MSGENC, 'msgenc'), '-d', '--json', '-c', os.path.join(MSGENC, 'charmap.txt'),
                            os.path.join(tmp, 'bank.json'), os.path.join(tmp, 'bank.bin')], check=True,
                           capture_output=True)
            out[n] = json.load(open(os.path.join(tmp, 'bank.json'), encoding='utf-8'))['messages']
    return out


def with_names(data, messages, bank):
    """messages under the HeartGold bank's names (data, its source JSON), one name more for each one it gained."""
    ids = [m['id'] for m in data['messages']]
    prefix = re.sub(r'_\d{5}$', '', ids[0]) if ids else f'msg_{bank}'
    out = []
    for i, m in enumerate(messages):
        m = dict(m)
        m['id'] = ids[i] if i < len(ids) else f'{prefix}_{i:05}'
        out.append(m)
    return dict(data, messages=out)


def without_touch_prompt(text):
    """HeartGold ends a question with {YESNO 0}, its "answer on the touch screen" mark (Platinum's screen indicator);
    the engine asks yes or no on the top screen, so the mark goes."""
    if isinstance(text, list):
        return [without_touch_prompt(line) for line in text]
    return re.sub(r' ?\{YESNO 0\}', '', text)


def highest_messages(scripts):
    """{bank: the highest message number a script names}."""
    out = {}
    for path in glob.glob(os.path.join(scripts, 'scr_seq_*.s')):
        for bank, n in re.findall(r'\bmsg_(\d{4})\w*?_(\d{5})\b', open(path, errors='replace').read()):
            out[bank] = max(out.get(bank, 0), int(n))
    return out


def main():
    args = sys.argv[1:]
    rom = args[args.index('--rom') + 1] if '--rom' in args else None
    scripts = args[args.index('--scripts') + 1] if '--scripts' in args else os.path.join(
        HG, 'files/fielddata/script/scr_seq')
    decoded = rom_banks(rom) if rom else None
    highest = highest_messages(scripts)
    names = []
    for bank in wanted_banks(scripts):
        source = glob.glob(os.path.join(HG, f'files/msgdata/msg/msg_{bank}*.json'))
        if len(source) != 1:
            sys.exit(f'msg_{bank}: {len(source)} source files')
        data = json.load(open(source[0], encoding='utf-8'))
        if decoded is not None:
            data = with_names(data, decoded[int(bank)], bank)
        # a message a script names that the bank lacks (Sacred Gold has one): empty, so the script assembles
        while len(data['messages']) <= highest.get(bank, -1):
            print(f'msg_{bank}: no message {len(data["messages"])}, which a script shows; left empty')
            data = with_names(data, data['messages'] + [{'en_US': ''}], bank)
        for m in data['messages']:
            if m['id'] in TEXT_FIXES:
                m['en_US'] = TEXT_FIXES[m['id']]
            if 'en_US' in m:
                m['en_US'] = without_touch_prompt(m['en_US'])
        with open(os.path.join(DECOMP, f'res/text/hgss_msg_{bank}.json'), 'w', encoding='utf-8') as f:
            f.write(json.dumps(data, indent=2, ensure_ascii=False) + '\n')
        names.append(f'{PREFIX}{bank}')

    path = os.path.join(DECOMP, 'generated/text_banks.txt')
    lines = [line for line in open(path).read().splitlines() if line and not line.startswith(PREFIX)]
    open(path, 'w').write('\n'.join(lines + names) + '\n')
    print(f'{len(names)} text banks (TEXT_BANK_HGSS_MSG_*) from {rom or "pokeheartgold"}, after {len(lines)} in the engine')


if __name__ == '__main__':
    main()
