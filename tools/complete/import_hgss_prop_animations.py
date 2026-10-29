#!/usr/bin/env python3
"""Bring in HeartGold's building and prop animations: doors, windmills, the gym puzzles' gates and carts.

HeartGold keeps them as Platinum does: the animation files (a/1/0/6: 273 BTA0, BCA0, BTP0 and BMA0 files, Platinum's
arc/bm_anime.narc) and, per building model, a list of up to four of them with its flags (a/1/0/7 for the outdoor
models, a/1/0/8 for the indoor ones; Platinum's arc/bm_anime_list.narc, one list for all its models). HeartGold's
list entry has one more word, which its code never reads. Sacred Gold doesn't change them.

The animations become res/field/props/animations/prop_animation_{098 + k} (after Platinum's 98, listed in its
meson.build and prop_animations.order), and the list (res/prebuilt/arc/bm_anime_list.narc) gets an entry for each of
HeartGold's models at the number tools/complete/import_hgss_maps.py gives it (outdoor k: 590 + k, indoor k: 930 + k),
pointing at those animations.

Usage: python3 tools/complete/import_hgss_prop_animations.py [HEARTGOLD_ROM]   (reruns replace the earlier entries)
"""
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, PROP_MODEL_INDOOR_BASE, PROP_MODEL_OUTDOOR_BASE, ROOT  # noqa: E402

ANIMATIONS = os.path.join(DECOMP, 'res/field/props/animations')
LIST = os.path.join(DECOMP, 'res/prebuilt/arc/bm_anime_list.narc')
PLATINUM_ANIMATIONS = 98
EXTENSIONS = {b'BTA0': 'nsbta', b'BCA0': 'nsbca', b'BTP0': 'nsbtp', b'BMA0': 'nsbma'}
MARK = ("    # Sovereign Complete: HeartGold's (tools/complete/import_hgss_prop_animations.py)\n",
        "    # end of HeartGold's\n")
NONE = -1


def entry(hg):
    """HeartGold's list entry (24 bytes) as Platinum's (20): the same flags and animations, after Platinum's."""
    has_animations, flags, bicycle_slope, filler, _unused = struct.unpack_from('<4BI', hg)
    ids = [i if i == NONE else PLATINUM_ANIMATIONS + i for i in struct.unpack_from('<4i', hg, 8)]
    return struct.pack('<4B4i', has_animations, flags, bicycle_slope, filler, *ids)


def main():
    import ndspy.narc
    import ndspy.rom

    rom = ndspy.rom.NintendoDSRom.fromFile(sys.argv[1] if len(sys.argv) > 1 else
                                           os.path.join(ROOT, '.cache/heartgold.nds'))

    def archive(path):
        return [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName(path)).files]

    animations, outdoor, indoor = archive('a/1/0/6'), archive('a/1/0/7'), archive('a/1/0/8')

    names = []
    for f in os.listdir(ANIMATIONS):
        stem = os.path.splitext(f)[0]
        if stem.startswith('prop_animation_') and int(stem[len('prop_animation_'):]) >= PLATINUM_ANIMATIONS:
            os.remove(os.path.join(ANIMATIONS, f))
    for k, data in enumerate(animations):
        name = f'prop_animation_{PLATINUM_ANIMATIONS + k:03d}.{EXTENSIONS[data[:4]]}'
        open(os.path.join(ANIMATIONS, name), 'wb').write(data)
        names.append(name)

    meson = os.path.join(ANIMATIONS, 'meson.build')
    text = open(meson).read()
    if MARK[0] in text:
        text = text[:text.index(MARK[0])] + text[text.index(MARK[1]) + len(MARK[1]):]
    last = text.index(f"    'prop_animation_{PLATINUM_ANIMATIONS - 1:03d}.")
    end = text.index('\n', last) + 1
    text = text[:end] + MARK[0] + ''.join(f"    '{n}',\n" for n in names) + MARK[1] + text[end:]
    open(meson, 'w').write(text)

    order = os.path.join(ANIMATIONS, 'prop_animations.order')
    lines = [line for line in open(order).read().splitlines()
             if line and int(line.split('.')[0][len('prop_animation_'):]) < PLATINUM_ANIMATIONS]
    assert len(lines) == PLATINUM_ANIMATIONS, 'Platinum\'s prop animations changed in number'
    open(order, 'w').write('\n'.join(lines + names) + '\n')

    lists = [bytes(f) for f in ndspy.narc.NARC(open(LIST, 'rb').read()).files][:PROP_MODEL_OUTDOOR_BASE]
    assert len(lists) == PROP_MODEL_OUTDOOR_BASE, 'Platinum\'s animation list is not 590 models'
    assert PROP_MODEL_OUTDOOR_BASE + len(outdoor) == PROP_MODEL_INDOOR_BASE
    lists += [entry(e) for e in outdoor] + [entry(e) for e in indoor]
    open(LIST, 'wb').write(ndspy.narc.NARC.fromFilesAndNames(lists).save())

    animated = sum(1 for e in outdoor + indoor if e[0] != 0xFF)
    print(f'{len(animations)} animations (prop_animation_{PLATINUM_ANIMATIONS:03d} on), {len(lists)} models in the '
          f'list, {animated} of HeartGold\'s animated')


if __name__ == '__main__':
    main()
