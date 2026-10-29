#!/usr/bin/env python3
"""Bring in HeartGold's trainer classes (step 4): pictures, names, genders and prize money.

From Sacred Gold's ROM (.cache/sacredgold.nds): each class's five graphics files (a/0/5/8: picture, palette, cells,
animation, scanned picture; the same layout as Platinum's) and its name with and without an article (text banks 730
and 731); from pokeheartgold, the genders (src/trainer_data.c) and the prize money (sPrizeMoneyTbl,
asm/overlay_12_battle_command.s).

- A HeartGold class whose picture, palette and name are a Sovereign class's (61 of 129: the Kanto and Sinnoh classes
  HeartGold took from Platinum, the Frontier Brains...) is that class (SAME, checked byte for byte against the
  regular build's).
- The others become TRAINER_CLASS_HGSS_<name>, after Sovereign's in generated/trainer_classes.txt, with the files
  Sovereign keeps for a class in res/trainers/classes/hgss_<name>/ (front.png, front_cell.json, front_anim.json,
  front_scan.png and its key), converted with nitrogfx: the cells, animation and scanned picture convert back to the
  same bytes, the palette to the same 16 colors; the picture is the same picture (HeartGold's file also keeps bytes of
  tiles no cell shows).
- Their names, genders and prize money go after Sovereign's (res/text/trainer_class_names*.json,
  include/data/trainer_class_genders.h, trainer_class_prize_mul.h).
- Music and the encounter's battle theme come from a Sinnoh stand-in class (STAND_INS, include/data/hgss_trainer_classes.h,
  src/complete_trainers.c) until HeartGold's music comes in (step 6); the encounter's cut-in is the plain one.

Run before tools/complete/import_hgss_trainers.py, which gives each trainer its class from here. Needs the regular
build (decomp/build) for the comparison.

Usage: python3 tools/complete/import_hgss_trainer_classes.py [ROM]
"""
import json
import os
import re
import subprocess
import sys
import tempfile

import ndspy.narc
import ndspy.rom

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402
from import_hgss_trainers import decode_bank, lines_of  # noqa: E402
from import_hgss_text import usual_arg_counts  # noqa: E402

NITROGFX = os.path.join(DECOMP, 'build/tools/nitrogfx/nitrogfx')
BUILT = os.path.join(DECOMP, 'build/res/trainers/classes/trfgra.narc.p')
PREFIX = 'TRAINER_CLASS_HGSS_'
MARK = ('    // Sovereign Complete: HeartGold\'s classes (tools/complete/import_hgss_trainer_classes.py)\n',
        '    // end of HeartGold\'s classes\n')
# Sinnoh classes whose music HeartGold's play until HeartGold's own music comes in (step 6)
STAND_INS = {
    'PKMN_TRAINER_ETHAN': 'PLAYER_MALE', 'PKMN_TRAINER_LYRA': 'PLAYER_FEMALE', 'YOUNGSTER': 'YOUNGSTER',
    'LASS': 'LASS', 'BUG_CATCHER': 'BUG_CATCHER', 'TWINS': 'TWINS', 'BLACK_BELT': 'BLACK_BELT',
    'POKEFAN_M': 'POKEFAN_MALE', 'POKEFAN': 'POKEFAN_FEMALE', 'RIVAL': 'RIVAL', 'ACE_TRAINER_M': 'ACE_TRAINER_MALE',
    'ACE_TRAINER_F': 'ACE_TRAINER_FEMALE', 'WAITRESS': 'WAITRESS', 'VETERAN': 'VETERAN', 'JUGGLER': 'CLOWN',
    'GENTLEMAN': 'GENTLEMAN', 'BEAUTY': 'BEAUTY', 'SWIMMER_M': 'SWIMMER_MALE', 'SWIMMER_F': 'SWIMMER_FEMALE',
    'KIMONO_GIRL': 'LADY', 'PSYCHIC_M': 'PSYCHIC_MALE', 'TEAM_ROCKET': 'GALACTIC_GRUNT_MALE', 'SKIER': 'SKIER_MALE',
    'SCHOOL_KID_M': 'SCHOOL_KID_MALE', 'TEAM_ROCKET_F': 'GALACTIC_GRUNT_FEMALE', 'BURGLAR': 'ROUGHNECK',
    'FIREBREATHER': 'ROUGHNECK', 'BIKER': 'ROUGHNECK', 'POKE_MANIAC': 'COLLECTOR', 'BIRD_KEEPER_GS': 'BIRD_KEEPER',
    'TEACHER': 'LADY', 'SUPER_NERD': 'SCIENTIST', 'SAGE': 'VETERAN', 'MEDIUM': 'PSYCHIC_FEMALE',
    'CHAMPION': 'CHAMPION_CYNTHIA', 'ELITE_FOUR_WILL': 'ELITE_FOUR_LUCIAN', 'ELITE_FOUR_KAREN': 'ELITE_FOUR_BERTHA',
    'ELITE_FOUR_KOGA': 'ELITE_FOUR_AARON', 'ELITE_FOUR_BRUNO': 'ELITE_FOUR_FLINT', 'PKMN_TRAINER_RED': 'PLAYER_MALE',
    'LEADER_BLUE': 'LEADER_VOLKNER', 'ELDER': 'VETERAN', 'SCIENTIST_GS': 'SCIENTIST',
    'EXECUTIVE_ARIANA': 'COMMANDER_MARS', 'EXECUTIVE_ARCHER': 'COMMANDER_SATURN', 'EXECUTIVE_PROTON': 'COMMANDER_JUPITER',
    'EXECUTIVE_PETREL': 'COMMANDER_SATURN', 'BOARDER': 'SKIER_MALE', 'PASSERBY': 'WORKER', 'MYSTERY_MAN': 'PI',
    'DOUBLE_TEAM': 'DOUBLE_TEAM', 'YOUNG_COUPLE': 'YOUNG_COUPLE', 'PKMN_TRAINER_LANCE': 'CHAMPION_CYNTHIA',
    'ROCKET_BOSS': 'GALACTIC_BOSS', 'LEADER_BROCK': 'LEADER_ROARK',
}
LEADER_STAND_IN = 'LEADER_ROARK'  # Johto's and Kanto's other Gym Leaders
GENDERS = {'TRAINER_MALE': 'GENDER_MALE', 'TRAINER_FEMALE': 'GENDER_FEMALE', 'TRAINER_DOUBLE': 'GENDER_NONE'}


def hg_classes():
    text = open(os.path.join(HG, 'include/constants/trainer_class.h')).read()
    return {int(v): n[len('TRAINERCLASS_'):] for n, v in re.findall(r'#define\s+(TRAINERCLASS_\w+)\s+(\d+)', text)
            if int(v) < 200}


def nitrogfx(*args):
    subprocess.run([NITROGFX, *args], check=True, capture_output=True)


def convert(files, out_dir):
    """A class's five HeartGold files into Sovereign's class files; checks that they convert back."""
    ncgr, nclr, ncer, nanr, scan = files
    os.makedirs(out_dir, exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        for name, data in (('f.NCGR', ncgr), ('f.NCLR', nclr), ('f.NCER', ncer), ('f.NANR', nanr), ('s.NCGR', scan)):
            open(os.path.join(tmp, name), 'wb').write(data)
        t = lambda name: os.path.join(tmp, name)  # noqa: E731
        o = lambda name: os.path.join(out_dir, name)  # noqa: E731
        nitrogfx(t('f.NCER'), o('front_cell.json'))
        nitrogfx(t('f.NANR'), o('front_anim.json'))
        nitrogfx(t('f.NCGR'), o('front.png'), '-palette', t('f.NCLR'), '-cell', o('front_cell.json'))
        nitrogfx(t('s.NCGR'), o('front_scan.png'), '-palette', t('f.NCLR'), '-scanfronttoback', '-width', '20')
        nitrogfx(o('front_cell.json'), t('b.NCER'))
        nitrogfx(o('front_anim.json'), t('b.NANR'))
        nitrogfx(o('front.png'), t('b.NCLR'), '-bitdepth', '4')
        nitrogfx(o('front_scan.png'), t('b.NCGR'), '-encodefronttoback', '-scan')
        for back, original in (('b.NCER', ncer), ('b.NANR', nanr), ('b.NCGR', scan)):
            assert open(t(back), 'rb').read() == original, (out_dir, back)
        # the palette: its 16 colors (some of HeartGold's files carry more, which a 16-color picture doesn't use,
        # and the Veteran's has only the 16, stored shorter)
        assert open(t('b.NCLR'), 'rb').read()[40:72] == nclr[40:72], (out_dir, 'b.NCLR')


def replace_block(path, entries, end_marker):
    """Put entries (lines) between MARK's lines, just before end_marker (the table's closing line)."""
    text = open(path).read()
    if MARK[0] in text:
        text = text[:text.index(MARK[0])] + text[text.index(MARK[1]) + len(MARK[1]):]
    at = text.index(end_marker)
    open(path, 'w').write(text[:at] + MARK[0] + ''.join(entries) + MARK[1] + text[at:])


def main():
    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache/sacredgold.nds')
    rom = ndspy.rom.NintendoDSRom.fromFile(rom_path)
    graphics = [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName('a/0/5/8')).files]
    banks = [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName('a/0/2/7')).files]
    usual = usual_arg_counts([bytes(f) for f in ndspy.narc.NARC(ndspy.rom.NintendoDSRom.fromFile(
        os.path.join(ROOT, '.cache/heartgold.nds')).getFileByName('a/0/2/7')).files])
    names = [''.join(lines_of(m)) for m in decode_bank(banks[730], usual)]
    with_articles = [''.join(lines_of(m)) for m in decode_bank(banks[731], usual)]
    classes = hg_classes()

    # Sovereign's classes: their built picture and palette, and their names
    class_list = [line.strip() for line in open(os.path.join(DECOMP, 'generated/trainer_classes.txt'))
                  if line.strip() and not line.startswith(PREFIX)]
    our_names = json.load(open(os.path.join(DECOMP, 'res/text/trainer_class_names.json'), encoding='utf-8'))
    ours = {}
    for i, cls in enumerate(class_list):
        built = os.path.join(BUILT, cls[len('TRAINER_CLASS_'):].lower())
        if os.path.exists(os.path.join(built, 'front.NCGR')):
            key = (open(os.path.join(built, 'front.NCGR'), 'rb').read(), open(os.path.join(built, 'front.NCLR'),
                                                                               'rb').read(),
                   our_names['messages'][i]['en_US'])
            ours.setdefault(key, cls)

    genders = re.findall(r'\b(TRAINER_MALE|TRAINER_FEMALE|TRAINER_DOUBLE),\s*//\s*TRAINERCLASS_(\w+)',
                         open(os.path.join(HG, 'src/trainer_data.c')).read())
    genders = {name: GENDERS[g] for g, name in genders}
    prizes = {name: int(n) for name, n in re.findall(r'\.short\s+TRAINERCLASS_(\w+),\s*(\d+)', open(os.path.join(
        HG, 'asm/overlay_12_battle_command.s')).read())}

    new, same = [], {}
    for c in sorted(classes):
        name = classes[c]
        files = graphics[5 * c:5 * c + 5]
        match = ours.get((files[0], files[1], names[c]))
        if match:
            same[name] = match
            continue
        directory = os.path.join(DECOMP, 'res/trainers/classes', 'hgss_' + name.lower())
        convert(files, directory)
        new.append((c, name))

    # the class list, names, genders, prize money
    path = os.path.join(DECOMP, 'generated/trainer_classes.txt')
    open(path, 'w').write('\n'.join(class_list + [PREFIX + name for _, name in new]) + '\n')
    for bank, texts in (('trainer_class_names.json', names), ('trainer_class_names_with_articles.json',
                                                              with_articles)):
        p = os.path.join(DECOMP, 'res/text', bank)
        data = json.load(open(p, encoding='utf-8'))
        kept = data['messages'][:len(class_list)]
        prefix = re.sub(r'_\d{5}$', '', kept[0]['id'])
        data['messages'] = kept + [{'id': f'{prefix}_{len(kept) + i:05}', 'en_US': texts[c]}
                                   for i, (c, _) in enumerate(new)]
        open(p, 'w', encoding='utf-8').write(json.dumps(data, indent=4, ensure_ascii=False) + '\n')
    width = max(len(PREFIX + name) for _, name in new) + 3
    replace_block(os.path.join(DECOMP, 'include/data/trainer_class_genders.h'),
                  [f'    {("[" + PREFIX + name + "]").ljust(width)}= {genders.get(name, "GENDER_FEMALE")},\n'
                   for _, name in new], '};\n')
    replace_block(os.path.join(DECOMP, 'include/data/trainer_class_prize_mul.h'),
                  [f'    {("[" + PREFIX + name + "]").ljust(width)}= {prizes[name]},\n' for _, name in new], '};\n')

    # the stand-ins for music, and the classes HeartGold shares with Sovereign, for the trainer importer
    def stand_in(name):
        return 'TRAINER_CLASS_' + STAND_INS.get(name, LEADER_STAND_IN if name.startswith('LEADER_') else name)

    our_classes = set(class_list)
    lines = ['#ifndef POKEPLATINUM_DATA_HGSS_TRAINER_CLASSES_H', '#define POKEPLATINUM_DATA_HGSS_TRAINER_CLASSES_H', '',
             '#include "generated/trainer_classes.h"', '',
             '// Sovereign Complete: HeartGold\'s classes (tools/complete/import_hgss_trainer_classes.py). Generated.',
             f'#define TRAINER_CLASS_HGSS_FIRST {PREFIX}{new[0][1]}', f'#define TRAINER_CLASS_HGSS_LAST  {PREFIX}{new[-1][1]}',
             '', '// The Sinnoh class whose music each plays until HeartGold\'s music comes in (step 6).',
             'static const u8 sHGSSTrainerClassStandIns[] = {']
    for _, name in new:
        assert stand_in(name) in our_classes, name
        lines.append(f'    [{PREFIX}{name} - TRAINER_CLASS_HGSS_FIRST] = {stand_in(name)},')
    lines += ['};', '', '#endif // POKEPLATINUM_DATA_HGSS_TRAINER_CLASSES_H', '']
    open(os.path.join(DECOMP, 'include/data/hgss_trainer_classes.h'), 'w').write('\n'.join(lines))
    json.dump(same, open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'hgss_trainer_classes_same.json'),
                         'w'), indent=4, sort_keys=True)
    print(f'{len(new)} classes as {PREFIX}*, {len(same)} the same as Sovereign\'s')


if __name__ == '__main__':
    main()
