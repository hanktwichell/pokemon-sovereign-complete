#!/usr/bin/env python3
"""Bring in the HeartGold archives the Pokéathlon's HeartGold assembly loads by number (decomp/asm/complete_hgss/,
the shims in src/applications/complete_pokeathlon/hgss_compat*.c), packed one after another into one archive,
decomp/res/prebuilt/application/complete_pokeathlon/pokeathlon.narc (NARC_INDEX_APPLICATION__COMPLETE__POKEATHLON),
so that more of them cost the main module nothing (each archive of its own takes a path in src/narc.c).

decomp/include/data/complete_pokeathlon_archives.h, written here too, gives each HeartGold archive's first member in
the pack, its member count and the first of HeartGold's members packed (0 but for the walking models): the shims
move the member HeartGold asks for there. An archive's members keep their order, so HeartGold's member n of archive A
is member first(A) + n - base(A).

Overlay 97 (the course's choice of three Pokémon) and the picker it calls load 93 (the Pokémon's picture's frame),
151 (the picker's screens), 162 (the summary screen's performance stars) and 243 (the choice screen). The course
(overlay 96, its overlay 98) loads the rest: its screens, the events' graphics and data (ARCHIVES below), HeartGold's
walking Pokémon's models (81, data/mmodel/mmodel: the course draws its athletes from their textures, HeartGold's own,
whose frames Complete's converted follower sprites lay out otherwise; models 297 on) and their parameters (141,
fielddata/tsurepoke/tp_param), and the Pokémon's performance (169, poketool/personal/performance), which here is
Complete's, made from data/complete/pokeathlon_performance.json (tools/complete/import_hgss_performance.py): a member
of 20 bytes for each species from 0 to Complete's last, member n species n's (0 Bulbasaur's, as HeartGold's table
gives species 0), then each form HeartGold has for the species that have them, in HeartGold's member layout (the five
bases in the archive's order, Power, Speed, Jump, Stamina, Skill; four unused bytes; each one's lowest and highest;
one unused). decomp/include/data/complete_pokeathlon_performance.h gives each such species' first form's member.
Also written: decomp/include/data/complete_pokeathlon_models.h, HeartGold's tables of each species' walking model
(pret's src/follow_mon.c: its index, its forms, whether it has a female one), which the course's model lookups use.

The text is HeartGold's message banks (tools/complete/import_hgss_text.py); the Pokémon's pictures and icons are
Complete's own.

Usage, after tools/complete/build_heartgold.sh:
    python3 tools/complete/import_hgss_pokeathlon_archives.py
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import write_narc  # noqa: E402

ROOT = os.path.dirname(DECOMP)
ROM = os.path.join(os.path.dirname(HG), 'heartgold.nds')
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'application', 'complete_pokeathlon')
HEADER = os.path.join(DECOMP, 'include', 'data', 'complete_pokeathlon_archives.h')
PERFORMANCE_HEADER = os.path.join(DECOMP, 'include', 'data', 'complete_pokeathlon_performance.h')
MODELS_HEADER = os.path.join(DECOMP, 'include', 'data', 'complete_pokeathlon_models.h')
PERFORMANCE = os.path.join(ROOT, 'data', 'complete', 'pokeathlon_performance.json')

HG_PERFORMANCE = 169
ARCHIVE_ORDER = ['power', 'speed', 'jump', 'stamina', 'skill']  # the performance members' five slots
MMODEL_FOLLOWER_FIRST = 297  # HeartGold's MMODEL_FOLLOWER_MON_BULBASAUR

# HeartGold's archive number (pret's filesystem_files_def.h), its name in HeartGold's ROM (not always the number's
# digits: 243 is a/2/4/1), its member count, what some members must start with (a check that it's the archive meant;
# the others are compressed or raw data), the first member packed, and what loads it
ARCHIVES = [
    (93, 'a/0/9/3', 26, {6: b'RLCN', 9: b'RGCN', 10: b'RECN'}, 0, "the Pokémon's picture's frame (overlay 97)"),
    (151, 'a/1/5/1', 9, {0: b'RLCN', 5: b'RLCN'}, 0, "the party and box picker's screens"),
    (162, 'a/1/6/2', 79, {65: b'RLCN', 66: b'RGCN', 67: b'RECN', 68: b'RNAN'}, 0, "the summary screen's stars"),
    (243, 'a/2/4/1', 8, {0: b'RLCN', 4: b'RLCN'}, 0, "the course's choice screen"),
    (8, 'a/0/0/8', 346, {0: b'RLCN'}, 0, "overlay 98's sprites"),
    (49, 'a/0/4/9', 78, {0: b'RLCN'}, 0, 'the course'),
    (81, 'a/0/8/1', 863, {MMODEL_FOLLOWER_FIRST: b'BTX0', 862: b'BTX0'}, MMODEL_FOLLOWER_FIRST,
     "the walking Pokémon's models (pret's data/mmodel/mmodel), the course's athletes"),
    (141, 'a/1/4/1', 566, {}, 0, "the walking Pokémon's parameters (pret's fielddata/tsurepoke/tp_param)"),
    (149, 'a/1/4/9', 12, {0: b'RNAN'}, 0, 'the course'),
    (153, 'a/1/5/3', 38, {0: b'RLCN'}, 0, 'the course'),
    (154, 'a/1/5/4', 35, {0: b'RLCN'}, 0, 'the course'),
    (156, 'a/1/5/6', 33, {0: b'RLCN'}, 0, 'the course'),
    (160, 'a/1/6/0', 10, {0: b'RLCN'}, 0, 'the course'),
    (167, 'a/1/6/7', 33, {0: b'RLCN'}, 0, 'the course'),
    (168, 'a/1/6/8', 15, {0: b'RLCN'}, 0, 'the course'),
    (170, 'a/1/7/0', 20, {}, 0, 'the course'),
    (177, 'a/1/7/7', 74, {0: b'RLCN'}, 0, "overlay 98's sprites"),
    (178, 'a/1/7/8', 18, {0: b'RLCN'}, 0, 'the course'),
    (219, 'a/2/1/7', 22, {0: b'RLCN'}, 0, 'the course'),
    (221, 'a/2/1/9', 62, {0: b'RLCN'}, 0, 'the course'),
    (226, 'a/2/2/4', 18, {0: b'RLCN'}, 0, 'the course'),
    (227, 'a/2/2/5', 20, {}, 0, 'the course'),
    (228, 'a/2/2/6', 3, {}, 0, 'the course'),
    (229, 'a/2/2/7', 10, {}, 0, 'the course'),
    (234, 'a/2/3/2', 19, {0: b'RLCN'}, 0, 'the course'),
    (236, 'a/2/3/4', 20, {0: b'RLCN'}, 0, 'the course'),
    (237, 'a/2/3/5', 27, {0: b'RLCN'}, 0, 'the course'),
    (242, 'a/2/4/0', 25, {0: b'RLCN'}, 0, 'the course'),
    (260, 'a/2/5/8', 100, {}, 0, 'the course'),
]


def check_names():
    """Each archive's ROM name is pret's name's digits (a_2_4_1 is a/2/4/1), where pret has no other name for it."""
    enum = {int(m.group(2)): m.group(1) for m in re.finditer(
        r'NARC_(\w+) = (\d+)', open(os.path.join(HG, 'include', 'filesystem_files_def.h')).read())}
    for number, rom_name, *_ in ARCHIVES:
        m = re.match(r'a_(\d)_(\d)_(\d)$', enum[number])
        if m and 'a/' + '/'.join(m.groups()) != rom_name:
            sys.exit(f'{number}: pret calls it {enum[number]}, not {rom_name}')


def performance_members():
    """Complete's performance, in HeartGold's member layout: [members], [(species, first form member, form count)]."""
    data = json.load(open(PERFORMANCE, encoding='utf-8'))
    species = [line.strip() for line in open(os.path.join(DECOMP, 'generated', 'species.txt')) if line.strip()]
    dex = species.index('SPECIES_BAD_EGG') - 2

    def member(entry):
        base = bytes(entry['base'][s] for s in ARCHIVE_ORDER)
        ranges = b''.join(bytes((entry['min'][s], entry['max'][s])) for s in ARCHIVE_ORDER)
        return base + b'\0' * 4 + ranges + b'\0'

    members = [member(data['species'][species[max(n, 1)]]) for n in range(dex + 1)]
    forms = []
    for name, entries in data['forms'].items():
        forms.append((name, len(members), len(entries)))
        members += [member(e) for e in entries]
    assert all(len(m) == 20 for m in members)
    return members, forms


def model_tables():
    """HeartGold's walking models (pret's follow_mon.c): each species' index (0-493), forms and female flag (1-493)."""
    consts = {m.group(1): int(m.group(2)) for m in re.finditer(
        r'#define\s+(FOLLOWER_MON_\w+)\s+(\d+)', open(os.path.join(HG, 'include', 'constants', 'follow_mon_idx.h')).read())}
    src = open(os.path.join(HG, 'src', 'follow_mon.c'), encoding='utf-8').read()

    def table(name):
        body = src[src.index(f'{name}[] = {{'):]
        body = body[body.index('{') + 1:body.index('};')]
        body = re.sub(r'//[^\n]*', '', body)
        values = []
        for item in (x.strip() for x in body.split(',')):
            if not item:
                continue
            values.append(consts[item] if item in consts else {'TRUE': 1, 'FALSE': 0}.get(item, None)
                          if item in ('TRUE', 'FALSE') else int(item, 0))
        return values
    return table('sModelIndexLUT'), table('sFormMaxLUT'), table('sFemaleFlagLUT')


def main():
    import ndspy.narc
    import ndspy.rom
    check_names()
    rom = ndspy.rom.NintendoDSRom.fromFile(ROM)
    members, table = [], []
    for number, rom_name, count, magics, base, what in ARCHIVES:
        archive = ndspy.narc.NARC(rom.getFileByName(rom_name)).files
        if len(archive) != count:
            sys.exit(f'{rom_name} has {len(archive)} members, not {count}')
        for member, magic in magics.items():
            if archive[member][:4] != magic:
                sys.exit(f'{rom_name} member {member} starts {archive[member][:4]}, not {magic}')
        table.append((number, len(members), count - base, base, f'{rom_name}: {what}'))
        members += [bytes(m) for m in archive[base:]]
    perf, forms = performance_members()
    table.append((HG_PERFORMANCE, len(members), len(perf), 0,
                  "poketool/personal/performance: Complete's, from data/complete/pokeathlon_performance.json"))
    members += perf

    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'pokeathlon.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w') as f:
        f.write("# Sovereign Complete: HeartGold's archives for the Pokéathlon's HeartGold assembly\n"
                "# (tools/complete/import_hgss_pokeathlon_archives.py, src/applications/complete_pokeathlon/)\n"
                "nitrofs_files += fs.copyfile('pokeathlon.narc')\n")

    rows = '\n'.join(f'    {{ {n}, {first}, {count}, {base} }}, // {what}' for n, first, count, base, what in table)
    with open(HEADER, 'w') as f:
        f.write(f"""#ifndef POKEPLATINUM_DATA_COMPLETE_POKEATHLON_ARCHIVES_H
#define POKEPLATINUM_DATA_COMPLETE_POKEATHLON_ARCHIVES_H

// Sovereign Complete: generated by tools/complete/import_hgss_pokeathlon_archives.py. The HeartGold archives the
// Pokéathlon's HeartGold assembly loads by number, one after another in application/complete/pokeathlon.narc
// (NARC_INDEX_APPLICATION__COMPLETE__POKEATHLON): HeartGold's number, its first member there, its member count there
// and the first of HeartGold's members packed. HeartGold's member n of an archive is member first + n - that.

#define COMPLETE_POKEATHLON_ARCHIVES {len(table)}

static const u16 sCompletePokeathlonArchives[COMPLETE_POKEATHLON_ARCHIVES][4] = {{
{rows}
}};

#endif // POKEPLATINUM_DATA_COMPLETE_POKEATHLON_ARCHIVES_H
""")

    form_rows = '\n'.join(f'    {{ {name}, {first}, {count} }},' for name, first, count in forms)
    with open(PERFORMANCE_HEADER, 'w') as f:
        f.write(f"""#ifndef POKEPLATINUM_DATA_COMPLETE_POKEATHLON_PERFORMANCE_H
#define POKEPLATINUM_DATA_COMPLETE_POKEATHLON_PERFORMANCE_H

#include "generated/species.h"

// Sovereign Complete: generated by tools/complete/import_hgss_pokeathlon_archives.py from
// data/complete/pokeathlon_performance.json. Complete's Pokéathlon performance is HeartGold's archive 169 in
// application/complete/pokeathlon.narc: member n is species n's (its form 0's), from 0 to NATIONAL_DEX_COUNT; then
// the forms HeartGold has, for these species, from their first member here (HeartGold's member numbers), one a form.
// A form not here takes its species' member.

#define COMPLETE_POKEATHLON_PERFORMANCE_FORMS {len(forms)}

static const u16 sCompletePokeathlonPerformanceForms[COMPLETE_POKEATHLON_PERFORMANCE_FORMS][3] = {{
{form_rows}
}};

#endif // POKEPLATINUM_DATA_COMPLETE_POKEATHLON_PERFORMANCE_H
""")

    index, form_max, female = model_tables()
    if len(index) != 494 or len(form_max) != 493 or len(female) != 493:
        sys.exit(f'follow_mon.c: {len(index)}, {len(form_max)}, {len(female)} entries, not 494, 493, 493')

    def rows_of(values, per=20):
        return '\n'.join('    ' + ', '.join(str(v) for v in values[i:i + per]) + ','
                         for i in range(0, len(values), per))
    with open(MODELS_HEADER, 'w') as f:
        f.write(f"""#ifndef POKEPLATINUM_DATA_COMPLETE_POKEATHLON_MODELS_H
#define POKEPLATINUM_DATA_COMPLETE_POKEATHLON_MODELS_H

// Sovereign Complete: generated by tools/complete/import_hgss_pokeathlon_archives.py from pret's HeartGold
// (src/follow_mon.c): each species' walking model (HeartGold's model {MMODEL_FOLLOWER_FIRST} + this, for species 0
// to 493), how many forms it has beyond the first, and whether it has a female one (species 1 to 493)

static const u16 sHgssModelIndex[{len(index)}] = {{
{rows_of(index)}
}};

static const u8 sHgssModelForms[{len(form_max)}] = {{
{rows_of(form_max)}
}};

static const u8 sHgssModelFemale[{len(female)}] = {{
{rows_of(female)}
}};

#endif // POKEPLATINUM_DATA_COMPLETE_POKEATHLON_MODELS_H
""")
    size = os.path.getsize(os.path.join(OUT, 'pokeathlon.narc'))
    print(f'{len(table)} archives, {len(members)} members, {size} bytes -> '
          f'{os.path.relpath(OUT, os.path.dirname(DECOMP))}/pokeathlon.narc')
    for n, first, count, base, what in table:
        print(f'  HeartGold {n:3d}: members {first} to {first + count - 1} ({what})')


if __name__ == '__main__':
    main()
