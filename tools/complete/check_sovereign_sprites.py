#!/usr/bin/env python3
"""Every sprite in Sovereign Platinum is in Sovereign Complete (the owner's to-do, Nov 6, 2026).

Compares every image (.png and .pal) under Sovereign's decomp/ and assets/ (the checkout tools/complete/sync_sovereign.sh
keeps in .cache/sovereign) with Complete's: each must be there, the same, except the Pokémon's box icons, which
Complete takes from Pokémon Showdown (tools/complete/import_showdown_icons.py, the owner's call), and the Totems on the
map, drawn as overworld Pokémon (tools/complete/make_totem_overworld.py, the owner's call).

Usage: python3 tools/complete/check_sovereign_sprites.py [SOVEREIGN_CHECKOUT]   (exits 1 on a missing or changed one)
"""
import os
import sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
REPLACED = ('icon.png',)  # under res/pokemon/: Showdown's icons
TOTEMS = 'res/graphics/field_sprites/pokemon/totem_'  # tools/complete/make_totem_overworld.py


def images(root):
    out = {}
    for path, dirs, names in os.walk(root):
        dirs[:] = [d for d in dirs if d not in ('.git', 'subprojects') and not d.startswith('build')]
        for name in names:
            if name.endswith(('.png', '.pal')):
                full = os.path.join(path, name)
                out[os.path.relpath(full, root)] = full
    return out


def main():
    sovereign = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache', 'sovereign')
    problems, checked, replaced = [], 0, 0
    for part in ('decomp', 'assets'):
        ours = images(os.path.join(ROOT, part))
        for rel, theirs in sorted(images(os.path.join(sovereign, part)).items()):
            checked += 1
            if rel not in ours:
                problems.append(f'missing: {part}/{rel}')
            elif open(theirs, 'rb').read() != open(ours[rel], 'rb').read():
                if rel.startswith('res/pokemon/') and os.path.basename(rel) in REPLACED or rel.startswith(TOTEMS):
                    replaced += 1
                else:
                    problems.append(f'changed: {part}/{rel}')
    print(f'{checked} of Sovereign\'s images: {checked - len(problems) - replaced} the same, {replaced} redrawn by '
          f'Complete (Showdown\'s icons, the Totems), {len(problems)} missing or changed')
    for p in problems:
        print(f'  {p}')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
