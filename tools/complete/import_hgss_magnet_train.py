#!/usr/bin/env python3
"""Bring in HeartGold's Magnet Train ride's graphics (its files/a/2/3/3, which its overlay 104 loads: the ride between
Goldenrod City and Saffron City) for src/applications/complete_magnet_train/magnet_train.c. The archive's 60 members
(each cut's model, its joint animation and its texture animation: three cuts each way, by day or night and the
player's gender) are packed as they are, in order, into
decomp/res/prebuilt/demo/complete_magnet_train/magnet_train.narc (NARC_INDEX_DEMO__COMPLETE__MAGNET_TRAIN), so
HeartGold's member numbers are the same there.

Usage: python3 tools/complete/import_hgss_magnet_train.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402

SOURCE = os.path.join(HG, 'files', 'a', '2', '3', '3')
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'demo', 'complete_magnet_train')
MEMBERS = 60


def main():
    members = read_narc(SOURCE)
    if len(members) != MEMBERS:
        sys.exit(f'{SOURCE}: {len(members)} members, not {MEMBERS}')
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'magnet_train.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w', encoding='utf-8') as f:
        f.write('# Sovereign Complete: HeartGold\'s Magnet Train ride\'s graphics (tools/complete/import_hgss_magnet_train.py,\n'
                '# src/applications/complete_magnet_train/magnet_train.c)\n'
                "nitrofs_files += fs.copyfile('magnet_train.narc')\n")
    size = sum(len(m) for m in members)
    print(f'magnet_train.narc: {len(members)} files ({size // 1024} KB) from {SOURCE}')


if __name__ == '__main__':
    main()
