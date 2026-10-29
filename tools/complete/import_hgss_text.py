#!/usr/bin/env python3
"""Bring in HeartGold's message banks that its maps and scripts use, as the engine's text banks (step 3).

HeartGold's banks (.cache/pokeheartgold/files/msgdata/msg/msg_NNNN*.json) have Platinum's layout and control codes
(docs/ScriptConversion.md), so they are copied as they are: bank NNNN becomes res/text/hgss_msg_NNNN.json and
TEXT_BANK_HGSS_MSG_NNNN, appended to generated/text_banks.txt (a bank's number is its line there). The message IDs
stay HeartGold's (msg_0604_T26_00000), so translated scripts name them unchanged.

The banks: each map header's, each one a script includes or names a message from, the four shared banks scripts
open by number (GetStdMsgNaix) and the shared menu entries (msg_0191). generated/text_banks.txt takes no comments,
so a rerun recognises its earlier entries by their TEXT_BANK_HGSS_ prefix.

Usage: python3 tools/complete/import_hgss_text.py
"""
import glob
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402

PREFIX = 'TEXT_BANK_HGSS_MSG_'
SHARED = ['0752', '0211', '0030', '0435', '0191']  # GetStdMsgNaix's four banks and the menu entries


def wanted_banks():
    banks = set(SHARED)
    banks |= set(re.findall(r'\.msgBank\s*=\s*msg_(\d{4})', open(os.path.join(HG, 'src/data/map_headers.h')).read()))
    for path in glob.glob(os.path.join(HG, 'files/fielddata/script/scr_seq/scr_seq_*.s')):
        text = open(path, errors='replace').read()
        banks |= set(re.findall(r'#include "msgdata/msg/msg_(\d{4})', text))
        banks |= set(re.findall(r'\bmsg_(\d{4})\w*?_\d{5}\b', text))
    return sorted(banks)


def main():
    names = []
    for bank in wanted_banks():
        source = glob.glob(os.path.join(HG, f'files/msgdata/msg/msg_{bank}*.json'))
        if len(source) != 1:
            sys.exit(f'msg_{bank}: {len(source)} source files')
        data = json.load(open(source[0], encoding='utf-8'))
        with open(os.path.join(DECOMP, f'res/text/hgss_msg_{bank}.json'), 'w', encoding='utf-8') as f:
            f.write(json.dumps(data, indent=2, ensure_ascii=False) + '\n')
        names.append(f'{PREFIX}{bank}')

    path = os.path.join(DECOMP, 'generated/text_banks.txt')
    lines = [line for line in open(path).read().splitlines() if line and not line.startswith(PREFIX)]
    open(path, 'w').write('\n'.join(lines + names) + '\n')
    print(f'{len(names)} text banks (TEXT_BANK_HGSS_MSG_*), from {len(lines)} in the engine')


if __name__ == '__main__':
    main()
