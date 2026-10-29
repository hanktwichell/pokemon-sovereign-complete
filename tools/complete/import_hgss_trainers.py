#!/usr/bin/env python3
"""Bring in Sacred Gold's trainers as Sovereign trainers (step 4).

From Sacred Gold's ROM (.cache/sacredgold.nds; HeartGold's own layout, docs/ScriptConversion.md): the trainers
(a/0/5/5: class, items, AI, single or double), their parties (a/0/5/6), their names (text bank 729) and lines (bank 728,
with a/0/5/7 saying whose and which kind each line is). Each of HeartGold's 737 trainers becomes
res/trainers/data/hgss_<name>.json, TRAINER_HGSS_<name> in generated/trainers.txt (HeartGold's names, before
MAX_TRAINERS, in HeartGold's order), so scripts and events name them as HeartGold does.

- Party: species, form, level, held item and moves as Sacred Gold has them, by name into Sovereign's lists; its
  difficulty is the IV scale and its ball capsule the ball seal. Where Sacred Gold picks a Pokémon's first or second
  ability, the ability is written out from Sacred Gold's own species data (it changed many), and a set gender too.
- AI: the same flags in both games (bit n is the nth flag of generated/ai_flags.txt).
- Lines: the same kinds in both games, numbered the same, but for the win line (20 in HeartGold, 100 here).
- Class: HeartGold's own (TRAINER_CLASS_HGSS_*) or the Sovereign class it is
  (tools/complete/import_hgss_trainer_classes.py, run first); without those, Sovereign's nearest (CLASSES).
- Defeated flags: HeartGold's own (its flag 0x550 + trainer, FLAG_HGSS_* in the save; src/complete_trainers.c), not
  Sinnoh's block, which Sinnoh's system flags follow.

Usage: python3 tools/complete/import_hgss_trainers.py [ROM]
"""
import json
import os
import re
import struct
import subprocess
import sys
import tempfile

import ndspy.narc
import ndspy.rom

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, ROOT  # noqa: E402
from import_hgss_text import repair_bank, usual_arg_counts, MSGENC  # noqa: E402

PREFIX = 'TRAINER_HGSS_'
HG_WIN_MESSAGE = 20
# HeartGold's classes Sovereign has under another name, and stand-ins for the ones it lacks (until HeartGold's own
# classes come in)
CLASSES = {
    'PKMN_TRAINER_ETHAN': 'PLAYER_MALE', 'PKMN_TRAINER_LYRA': 'PLAYER_FEMALE', 'PKMN_BREEDER_M': 'BREEDER_MALE',
    'PKMN_BREEDER_F': 'BREEDER_FEMALE', 'POKEFAN_M': 'POKEFAN_MALE', 'POKEFAN': 'POKEFAN_FEMALE',
    'PKMN_RANGER_M': 'RANGER_MALE', 'PKMN_RANGER_F': 'RANGER_FEMALE', 'KIMONO_GIRL': 'LADY', 'JUGGLER': 'CLOWN',
    'ACE_TRAINER_M_GS': 'ACE_TRAINER_MALE', 'ACE_TRAINER_F_GS': 'ACE_TRAINER_FEMALE',
    'TEAM_ROCKET': 'GALACTIC_GRUNT_MALE', 'TEAM_ROCKET_F': 'GALACTIC_GRUNT_FEMALE', 'SKIER': 'SKIER_MALE',
    'BURGLAR': 'ROUGHNECK', 'FIREBREATHER': 'ROUGHNECK', 'BIKER': 'ROUGHNECK', 'POKE_MANIAC': 'COLLECTOR',
    'BIRD_KEEPER_GS': 'BIRD_KEEPER', 'TEACHER': 'LADY', 'SUPER_NERD': 'SCIENTIST', 'SAGE': 'VETERAN',
    'MEDIUM': 'PSYCHIC_FEMALE', 'CHAMPION': 'CHAMPION_CYNTHIA', 'ELITE_FOUR_WILL': 'ELITE_FOUR_LUCIAN',
    'ELITE_FOUR_KAREN': 'ELITE_FOUR_BERTHA', 'ELITE_FOUR_KOGA': 'ELITE_FOUR_AARON',
    'ELITE_FOUR_BRUNO': 'ELITE_FOUR_FLINT', 'PKMN_TRAINER_CHERYL': 'TRAINER_CHERYL',
    'PKMN_TRAINER_RILEY': 'TRAINER_RILEY', 'PKMN_TRAINER_BUCK': 'TRAINER_BUCK', 'PKMN_TRAINER_MIRA': 'TRAINER_MIRA',
    'PKMN_TRAINER_MARLEY': 'TRAINER_MARLEY', 'PKMN_TRAINER_FTR_LUCAS': 'DP_PLAYER_MALE',
    'PKMN_TRAINER_FTR_DAWN': 'DP_PLAYER_FEMALE', 'PKMN_TRAINER_LUCAS_DP': 'DP_PLAYER_MALE_2',
    'PKMN_TRAINER_DAWN_DP': 'DP_PLAYER_FEMALE_2', 'PKMN_TRAINER_LUCAS_PT': 'PLAYER_MALE',
    'PKMN_TRAINER_DAWN_PT': 'PLAYER_FEMALE', 'PKMN_TRAINER_RED': 'PLAYER_MALE', 'ELDER': 'VETERAN',
    'SCIENTIST_GS': 'SCIENTIST', 'EXECUTIVE_ARIANA': 'COMMANDER_MARS', 'EXECUTIVE_ARCHER': 'COMMANDER_SATURN',
    'EXECUTIVE_PROTON': 'COMMANDER_JUPITER', 'EXECUTIVE_PETREL': 'COMMANDER_SATURN', 'BOARDER': 'SKIER_MALE',
    'PASSERBY': 'WORKER', 'MYSTERY_MAN': 'PI', 'PKMN_TRAINER_LANCE': 'CHAMPION_CYNTHIA',
    'ROCKET_BOSS': 'GALACTIC_BOSS', 'LEADER_BLUE': 'LEADER_VOLKNER',
}
LEADER_STAND_IN = 'LEADER_ROARK'  # Johto's and Kanto's Gym Leaders


def hg_defines(header, prefix):
    out = {}
    for name, value in re.findall(rf'#define\s+({prefix}\w+)\s+(\d+)\b', open(os.path.join(HG, header)).read()):
        out.setdefault(int(value), name)
    return out


def ours(generated):
    norm = lambda name: name.replace('_', '')  # noqa: E731
    return {norm(line.strip()): line.strip() for line in open(os.path.join(DECOMP, 'generated', generated))
            if line.strip()}


class Lookup:
    """HeartGold's numbers to Sovereign's names, by name (ignoring underscores)."""

    def __init__(self):
        self.tables = {}
        for kind, header, generated in (('ITEM_', 'items.h', 'items.txt'), ('SPECIES_', 'species.h', 'species.txt'),
                                        ('MOVE_', 'moves.h', 'moves.txt'), ('ABILITY_', 'abilities.h',
                                                                            'abilities.txt')):
            hg = hg_defines(f'include/constants/{header}', kind)
            mine = ours(generated)
            self.tables[kind] = {n: mine.get(name.replace('_', ''), kind + 'NONE') for n, name in hg.items()}
        self.missing = set()

    def __call__(self, kind, n):
        out = self.tables[kind].get(n, kind + 'NONE')
        if out.endswith('_NONE') and n:
            self.missing.add(f'{kind}{n}')
        return out


def decode_bank(data, usual):
    data, _ = repair_bank(data, usual)
    with tempfile.TemporaryDirectory() as tmp:
        open(os.path.join(tmp, 'bank.bin'), 'wb').write(data)
        subprocess.run([os.path.join(MSGENC, 'msgenc'), '-d', '--json', '-c', os.path.join(MSGENC, 'charmap.txt'),
                        os.path.join(tmp, 'bank.json'), os.path.join(tmp, 'bank.bin')], check=True, capture_output=True)
        return json.load(open(os.path.join(tmp, 'bank.json'), encoding='utf-8'))['messages']


def lines_of(message):
    text = message.get('en_US', '')
    return text if isinstance(text, list) else [text]


def class_name(hg_class, our_classes):
    """HeartGold's class (tools/complete/import_hgss_trainer_classes.py): its own TRAINER_CLASS_HGSS_*, or the Sovereign
    class it is; before those are in, Sovereign's nearest (CLASSES)."""
    name = hg_class[len('TRAINERCLASS_'):]
    if 'TRAINER_CLASS_HGSS_' + name in our_classes:
        return 'TRAINER_CLASS_HGSS_' + name
    same = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'hgss_trainer_classes_same.json')
    if os.path.exists(same) and name in json.load(open(same)):
        return json.load(open(same))[name]
    mapped = CLASSES.get(name, LEADER_STAND_IN if name.startswith('LEADER_') else name)
    mapped = re.sub(r'_M$', '_MALE', re.sub(r'_F$', '_FEMALE', mapped))
    out = 'TRAINER_CLASS_' + mapped
    assert out in our_classes, (hg_class, out)
    return out


def main():
    rom_path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache/sacredgold.nds')
    rom = ndspy.rom.NintendoDSRom.fromFile(rom_path)
    narc = lambda path: [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName(path)).files]  # noqa: E731
    trdata, trpoke, personal = narc('a/0/5/5'), narc('a/0/5/6'), narc('a/0/0/2')
    owners = narc('a/0/5/7')[0]
    banks = narc('a/0/2/7')
    usual = usual_arg_counts([bytes(f) for f in ndspy.narc.NARC(ndspy.rom.NintendoDSRom.fromFile(
        os.path.join(ROOT, '.cache/heartgold.nds')).getFileByName('a/0/2/7')).files])
    names, lines = decode_bank(banks[729], usual), decode_bank(banks[728], usual)

    hg_trainers = hg_defines('include/constants/trainers.h', 'TRAINER_')
    hg_classes = hg_defines('include/constants/trainer_class.h', 'TRAINERCLASS_')
    our_classes = {line.strip() for line in open(os.path.join(DECOMP, 'generated/trainer_classes.txt')) if line.strip()}
    ai_flags = [line.strip() for line in open(os.path.join(DECOMP, 'generated/ai_flags.txt')) if line.strip()][1:]
    message_types = [line.split('=')[0].strip() for line in open(os.path.join(DECOMP,
                                                                              'generated/trainer_message_types.txt'))]
    lookup = Lookup()

    messages = {}
    for index in range(len(owners) // 4):
        trainer, kind = struct.unpack_from('<HH', owners, index * 4)
        kind_name = 'TRMSG_WIN' if kind == HG_WIN_MESSAGE else message_types[kind]
        messages.setdefault(trainer, []).append({'type': kind_name, 'en_US': lines_of(lines[index])})

    stems = []
    for t in range(1, len(trdata)):
        hdr, party_data = trdata[t], trpoke[t]
        kind, cls, _, count = hdr[:4]
        items = struct.unpack_from('<4H', hdr, 4)
        ai, double = struct.unpack_from('<II', hdr, 12)
        size = 8 + (2 if kind & 2 else 0) + (8 if kind & 1 else 0)
        party = []
        for k in range(count):
            b = party_data[k * size:(k + 1) * size]
            difficulty, gender_ability, level, species_form = struct.unpack_from('<BBHH', b, 0)
            species, form = species_form & 0x3FF, species_form >> 10
            off = 6
            mon = {'species': lookup('SPECIES_', species), 'form': form, 'level': level, 'item': None, 'moves': None}
            if kind & 2:
                item = struct.unpack_from('<H', b, off)[0]
                off += 2
                mon['item'] = lookup('ITEM_', item)  # ITEM_NONE for one holding nothing, as trainerproc wants
            if kind & 1:
                mon['moves'] = [lookup('MOVE_', m) for m in struct.unpack_from('<4H', b, off)]
                off += 8
            mon['iv_scale'] = difficulty
            mon['ball_seal'] = struct.unpack_from('<H', b, off)[0]
            slot = gender_ability >> 4
            if slot in (1, 2):
                mon['ability'] = lookup('ABILITY_', personal[species][22 + slot - 1] or personal[species][22])
            if gender_ability & 0xF in (1, 2):
                mon['gender'] = 'male' if gender_ability & 0xF == 1 else 'female'
            # no held item or moveset: left out (Sovereign's own fields, gender and ability, don't take null)
            party.append({k: v for k, v in mon.items() if v is not None})
        name = ''.join(lines_of(names[t])).replace('{TRNAME}', '')
        data = {
            'name': name,
            'class': class_name(hg_classes[cls], our_classes),
            'items': [lookup('ITEM_', i) for i in items if i],
            'ai_flags': [flag for bit, flag in enumerate(ai_flags) if ai & (1 << bit)],
            'double_battle': bool(double),
            'party': party,
            'messages': messages.get(t, []),
        }
        stem = 'hgss_' + hg_trainers[t][len('TRAINER_'):].lower()
        with open(os.path.join(DECOMP, 'res/trainers/data', f'{stem}.json'), 'w', encoding='utf-8') as f:
            f.write(json.dumps(data, indent=4, ensure_ascii=False) + '\n')
        stems.append(stem)

    path = os.path.join(DECOMP, 'generated/trainers.txt')
    current = [line.strip() for line in open(path) if line.strip() and not line.startswith(PREFIX)]
    at = current.index('MAX_TRAINERS')
    open(path, 'w').write('\n'.join(current[:at] + [stem.upper().replace('HGSS_', PREFIX, 1) for stem in stems]
                                    + current[at:]) + '\n')
    names_ = [stem.upper().replace('HGSS_', PREFIX, 1) for stem in stems]
    with open(os.path.join(DECOMP, 'include/data/hgss_trainers.h'), 'w') as f:
        f.write('#ifndef POKEPLATINUM_DATA_HGSS_TRAINERS_H\n#define POKEPLATINUM_DATA_HGSS_TRAINERS_H\n\n'
                '// Sovereign Complete: HeartGold\'s trainers, in HeartGold\'s order (tools/complete/import_hgss_trainers.py;\n'
                '// the first is HeartGold\'s trainer 1). Generated.\n'
                f'#define TRAINER_HGSS_FIRST {names_[0]}\n#define TRAINER_HGSS_LAST  {names_[-1]}\n\n'
                '#endif // POKEPLATINUM_DATA_HGSS_TRAINERS_H\n')
    print(f'{len(stems)} trainers from {os.path.basename(rom_path)} as {PREFIX}*, after {at} in the engine')
    if lookup.missing:
        print('not in Sovereign\'s lists (_NONE):', ' '.join(sorted(lookup.missing)))


if __name__ == '__main__':
    main()
