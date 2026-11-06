#!/usr/bin/env python3
"""Bring in what HeartGold's Unown Report needs (include/complete_unown_report.h,
src/applications/complete_unown_report/), packed into
decomp/res/prebuilt/graphic/complete_unown_report/unown_report.narc (NARC_INDEX_GRAPHIC__COMPLETE__UNOWN_REPORT):

| members | from HeartGold's a/2/3/9, member n is member n                                                   |
|---------|---------------------------------------------------------------------------------------------------|
| 0-3     | the sprites (the CANCEL button and the page arrows): palette, tiles, cells, animations           |
| 4, 5    | the top and bottom screens' palettes                                                              |
| 6-9     | the screens' backgrounds: the top's tiles and map (6, 8), the bottom's (7, 9)                    |
| 10-15   | the pages' frames, each a map: the cover's (10 top, 11 bottom), the Unown's (12, 13), the report's |
|         | (14, 15)                                                                                          |

HeartGold's sprite lists for the app (its resdat 4-7 and 73) name members 0-3, the port loads them by number. Its text
is HeartGold's message bank 1 (tools/complete/import_hgss_text.py brings it in); the Unown icons are Platinum's own.
The Unown Report's use from the bag is set by tools/complete/import_hgss_items.py.

Usage, after tools/complete/build_heartgold.sh:
    python3 tools/complete/import_hgss_unown_report.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, hg_narc  # noqa: E402
from narc import write_narc  # noqa: E402

REPORT = 'a/2/3/9'
MEMBERS = 16
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'graphic', 'complete_unown_report')


def main():
    members = hg_narc(REPORT)
    if len(members) != MEMBERS:
        sys.exit(f'{REPORT} has {len(members)} members, not {MEMBERS}')
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'unown_report.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w') as f:
        f.write("# Sovereign Complete: HeartGold's Unown Report (tools/complete/import_hgss_unown_report.py,\n"
                "# src/applications/complete_unown_report/)\n"
                "nitrofs_files += fs.copyfile('unown_report.narc')\n")
    print(f'{len(members)} members -> {os.path.relpath(OUT, os.path.dirname(DECOMP))}/unown_report.narc')


if __name__ == '__main__':
    main()
