#!/usr/bin/env python3
"""Bring in HeartGold's field cut-in graphics (its archive a/0/9/3, which pokeheartgold calls
files/application/choose_starter/choose_starter_sub_res): the Fly take-off's riders, the boy (members 17 to 19), the
girl (20 to 22) and Lance on his Dragonite (23 to 25: tiles, cells, animations), with their palettes (6, 7 and 8), as
HeartGold's ScrCmd_775 (ov02_022494C4) plays Lance's take-off from the Lake of Rage. Platinum's own cut-in archive
(data/field_cutin) has only its two players, so src/overlay006/hm_cut_in.c takes Lance's from this one. The archive
is packed as it is, in order, into decomp/res/prebuilt/fielddata/complete_field_cutin/field_cutin.narc
(NARC_INDEX_FIELDDATA__COMPLETE__FIELD_CUTIN): HeartGold's member n is member n here.

Usage: python3 tools/complete/import_hgss_field_cutin.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import write_narc  # noqa: E402

SOURCE = os.path.join(HG, 'files', 'application', 'choose_starter', 'choose_starter_sub_res')
PREFIX = 'choose_starter_sub_res_'
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'fielddata', 'complete_field_cutin')


def main():
    names = [f for f in os.listdir(SOURCE) if f.startswith(PREFIX)]
    by_number = {int(f[len(PREFIX):len(PREFIX) + 8]): f for f in names}
    last = max(by_number)
    members = [open(os.path.join(SOURCE, by_number[n]), 'rb').read() for n in range(last + 1)]
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'field_cutin.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w', encoding='utf-8') as f:
        f.write("# Sovereign Complete: HeartGold's field cut-in graphics, Lance's take-off among them\n"
                "# (tools/complete/import_hgss_field_cutin.py, src/overlay006/hm_cut_in.c)\n"
                "nitrofs_files += fs.copyfile('field_cutin.narc')\n")
    size = os.path.getsize(os.path.join(OUT, 'field_cutin.narc'))
    print(f'field_cutin.narc: {len(members)} files ({size // 1024} KB) from {SOURCE}')


if __name__ == '__main__':
    main()
