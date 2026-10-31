#!/usr/bin/env python3
"""Bring in HeartGold's 3D effects for its gyms' floors (src/complete_gyms.c), as archives the engine loads:

- Viridian Gym's arrow tiles light up as the player steps onto them: HeartGold's a/2/5/5 (its viridian.c), four
  models (members 4-7, one for each arrow's direction) and their texture animations (members 0-3), packed as they are
  into decomp/res/prebuilt/fielddata/complete_gym_effects/viridian_gym.narc
  (NARC_INDEX_FIELDDATA__COMPLETE__VIRIDIAN_GYM).

Usage: python3 tools/complete/import_hgss_gym_effects.py
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402

OUT = os.path.join(DECOMP, 'res/prebuilt/fielddata/complete_gym_effects')
ARCHIVES = {'viridian_gym.narc': 'files/a/2/5/5'}


def main():
    os.makedirs(OUT, exist_ok=True)
    for name, source in ARCHIVES.items():
        members = read_narc(os.path.join(HG, source))
        write_narc(os.path.join(OUT, name), members)
        print(f'{name}: {len(members)} files from {source}')


if __name__ == '__main__':
    main()
