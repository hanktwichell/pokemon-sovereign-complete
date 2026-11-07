#!/usr/bin/env python3
"""Bring in HeartGold's songs for Johto and Kanto (docs/Music.md, step 6).

The songs: every one HeartGold's map headers name, its scripts play (Sacred Gold's, which are the game's; a scene's
song too, TempBGM), its field music code picks (surfing, cycling, the trainers' encounter themes, and the songs a
flag puts on a map, as in the Bug-Catching Contest), and its battle and victory themes; and the fanfares its scripts
play (SEQ_ME_*: an item, a badge, a Pokémon caught), and Voltorb Flip's (its code plays them); and the Pokégear
radio's songs (its shows' code plays them: the March, the Lullaby, the Poké Flute...), the Magnet Train ride's jingle,
and Ho-Oh's and Arceus's themes in their cinematics. Sacred Gold leaves HeartGold's sound archive as it is.

And HeartGold's own sound effects (SEQ_SE_GS_*): the ones Sacred Gold's scripts play and the ones Complete's ports of
HeartGold's code and Complete's own scripts name (decomp/src and decomp/res/field/scripts, where a Platinum sound
stood in), each with a bank of its own as a song has, its
waves in WAVE_ARC_GS too. They are too big to keep loaded (113 KB of waves Platinum lacks): one is loaded as it plays
and freed after (src/complete_sound.c, CompleteSound_LoadOwnEffect).

HeartGold's sound archive (its pret decomp's prebuilt files/data/sound/gs_sound_data.sdat) is unpacked into
.cache/hgss_sound with the decomp's nitrosfx. Each song keeps HeartGold's sequence file byte for byte, and gets a bank
of its own: HeartGold's instruments the song plays, at their numbers (the others empty), with each wave a note can
play: a wave Platinum keeps loaded (WAVE_ARC_BASIC after tools/complete/split_sound_basic.py) is used from there, any
other from WAVE_ARC_GS, one archive of all of them, which loads wave by wave (NitroSystem's single load), so a song
loads only its own. A key split or drum region the song never plays points at Platinum's first loaded wave.

Banks alike are written once, and the songs and effects with them share it (each bank stays in sound memory as its
info, about 32 bytes, and the title screen's song needs nearly all there is).

Written to decomp/res/sound/complete/hgss/: the banks (BANK/), the sequences (SEQ/), the waves (WAVE_ARC_GS/), the
archive entries to add after Platinum's (hgss_sound.json, which tools/complete/split_sound_basic.py adds to the
archive it writes), and meson.build. Also HeartGold's tables of which song plays when (decomp/include/data/
hgss_sound.h, for src/complete_sound.c): its trainers' encounter themes (src/field_bgm.c's, Johto's column: the two
differ only for Scientists), and its battle themes by trainer class and wild species with the table they index
(asm/unk_020517A4.s). Running it again changes nothing; run split_sound_basic.py after it.

Usage: python3 tools/complete/import_hgss_sound.py (after a build: it needs the decomp's nitrosfx)
"""
import glob
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from gen_pokeathlon_sounds import course_sound_names  # noqa: E402
from split_sound_basic import (BASIC, ROOT, SOUND, Bank, nitrosfx, played, resident_waves,  # noqa: E402
                               sseq_notes, write_if_changed)

HG = os.path.join(ROOT, '.cache', 'pokeheartgold')
SACRED_SCRIPTS = os.path.join(ROOT, '.cache', 'sacredgold', 'scr_seq')
CACHE = os.path.join(ROOT, '.cache', 'hgss_sound')
OUT = os.path.join(SOUND, 'complete', 'hgss')
GS_ARCHIVE = 'WAVE_ARC_GS'
EFFECT_SLACK = 4096  # bytes of waves a merged effects' bank may load over its largest member's own
MUSIC_PLAYERS = ('PLAYER_BGM', 'PLAYER_FIELD', 'PLAYER_ME')  # songs, and fanfares (SEQ_ME_*)
# The battle and victory themes (the Frontier Brains' too), and surfing and cycling, which HeartGold picks by number or
# in code; and the Magnet Train ride's jingle (its overlay 104 plays it) and Ho-Oh's and Arceus's themes (its overlay
# 106)
OTHER_SONGS = r'SEQ_GS_(VS_(?!.*_PHC)\w+|WIN\w*|BA_BRAIN|BICYCLE|NAMINORI|E_LINEAR|E_HOUOU|E_ARCEUS)'


def unpack():
    """HeartGold's archive, unpacked once: its files, its JSON, its banks as text and its waves as WAVs."""
    archive = os.path.join(HG, 'files', 'data', 'sound', 'gs_sound_data.sdat')
    files = os.path.join(CACHE, 'files')
    index = os.path.join(CACHE, 'gs_sound_data.json')
    tool = nitrosfx()
    if not os.path.exists(index):
        os.makedirs(files, exist_ok=True)
        subprocess.run([tool, archive, files, index], check=True, capture_output=True)
    return json.load(open(index, encoding='utf-8'))


def bank_text(name):
    path = os.path.join(CACHE, 'txt', f'{name}.txt')
    if not os.path.exists(path):
        os.makedirs(os.path.dirname(path), exist_ok=True)
        subprocess.run([nitrosfx(), os.path.join(CACHE, 'files', f'{name}.sbnk'), path], check=True,
                       capture_output=True)
    return open(path, encoding='utf-8', newline='').readlines()


def wave_file(archive, wave):
    """A HeartGold wave as a WAV (as Platinum keeps its own: nitrosfx's swav to wav, the same encoding)."""
    folder = os.path.join(CACHE, 'wav', archive)
    path = os.path.join(folder, f'{wave:03d}.wav')
    if not os.path.exists(path):
        os.makedirs(folder, exist_ok=True)
        tool = nitrosfx()
        swavs = os.path.join(CACHE, 'swav', archive)
        if not os.path.exists(swavs):
            os.makedirs(swavs)
            subprocess.run([tool, os.path.join(CACHE, 'files', f'{archive}.swar'), swavs], check=True,
                           capture_output=True)
        subprocess.run([tool, os.path.join(swavs, f'{wave:03d}.swav'), path, '-same'], check=True,
                       capture_output=True)
    return path


def needed_songs(seqs):
    headers = open(os.path.join(HG, 'src', 'data', 'map_headers.h')).read()
    names = set(re.findall(r'(?:day|night)MusicId = (SEQ_\w+)', headers))
    for path in glob.glob(os.path.join(SACRED_SCRIPTS, '*.s')):
        names |= set(re.findall(r'(?:PlayBGM|PlayFanfare|TempBGM) (SEQ_\w+)', open(path, errors='replace').read()))
    names |= set(re.findall(r'SEQ_GS_\w+', open(os.path.join(HG, 'src/field_bgm.c')).read()))
    names |= set(re.findall(r'SEQ_GS_\w+', open(os.path.join(HG, 'src/sys_flags.c')).read()))  # its music overrides
    for path in glob.glob(os.path.join(HG, 'src', 'voltorb_flip', '*.c')):  # Voltorb Flip's fanfares
        names |= set(re.findall(r'SEQ_ME_\w+', open(path).read()))
    for path in glob.glob(os.path.join(HG, 'src', 'application', 'pokegear', 'radio', '**', '*.c'), recursive=True):
        names |= set(re.findall(r'SEQ_GS_\w+', open(path).read()))  # the Pokégear radio's shows' songs and its jingle
    names |= {n for n in seqs if re.fullmatch(OTHER_SONGS, n)}
    names |= course_sound_names()  # the Pokéathlon's own songs and fanfare (its course's assembly plays them)
    return sorted(n for n in names if n.startswith(('SEQ_GS_', 'SEQ_ME_')) and n in seqs
                  and seqs[n]['player'] in MUSIC_PLAYERS)


def needed_effects(seqs, taken=frozenset()):
    """HeartGold's own sound effects that Sacred Gold's scripts play or Complete's C code or own scripts name: its
    SEQ_SE_GS_*, and the Diamond and Pearl effects it kept that Platinum dropped (SEQ_SE_DP_* not among Platinum's
    names, taken: the Olivine Lighthouse's lamp's)."""
    names = set()
    for path in glob.glob(os.path.join(SACRED_SCRIPTS, '*.s')):
        names |= set(re.findall(r'SEQ_SE_GS_\w+', open(path, errors='replace').read()))
    engine = glob.glob(os.path.join(ROOT, 'decomp', 'src', '**', '*.c'), recursive=True)
    engine += glob.glob(os.path.join(ROOT, 'decomp', 'res', 'field', 'scripts', '*.s'))  # the engine's own scripts
    for path in engine:  # by the engine's name
        text = open(path, errors='replace').read()
        names |= {re.sub(r'_sseq$', '', n) for n in re.findall(r'SEQ_SE_GS_\w+', text)}
        names |= {n for n in (re.sub(r'_sseq$', '', m) for m in re.findall(r'SEQ_SE_DP_\w+', text)) if n not in taken}
    # and the Pokéathlon's: its course's assembly plays them by HeartGold's number (gen_pokeathlon_sounds.py maps them)
    names |= {n for n in course_sound_names() if n.startswith('SEQ_SE_GS_')
              or (n.startswith('SEQ_SE_DP_') and n not in taken)}
    return sorted(n for n in names if n in seqs and seqs[n]['player'].startswith('PLAYER_SE'))


def merge_same_banks(banks, entries):
    """Banks alike are one bank, the first by name: every bank in the archive stays in sound memory as its info and
    its file's place (about 32 bytes; the title screen's song needs nearly all the memory there is), so a song or an
    effect whose bank is like another's takes that one. The banks left; the entries are changed to match."""
    first = {}
    for name in sorted(banks):
        first.setdefault(banks[name], name)
    keep = {name: first[text] for name, text in banks.items()}
    for seq in entries['seqInfo']:
        seq['bank'] = keep[seq['bank']]
    entries['bankInfo'] = [b for b in entries['bankInfo'] if keep[b['name']] == b['name']]
    return {name: text for name, text in banks.items() if keep[name] == name}


def bank_instruments(text):
    """A bank's instruments by number (each its lines' text), and the WAVE_ARC_GS waves they play."""
    instruments, waves, number = {}, set(), None
    for line in text.splitlines(keepends=True):
        f = line.strip().split(', ')
        if not line.startswith('\t'):
            number = None if f[1] == 'NULL' else int(f[0])
            if number is None:
                continue
            instruments[number] = line
        elif number is None:
            continue
        else:
            instruments[number] += line
        if line.startswith('\t') and f[0] == '1':
            wave, slot = int(f[1]), int(f[2])
        elif not line.startswith('\t') and f[1] == 'Single':
            wave, slot = int(f[2]), int(f[3])
        else:
            continue
        if slot == 1:
            waves.add(wave)
    return instruments, waves


def merge_compatible_banks(banks, entries, wave_sizes, plays):
    """Banks that never give one instrument number two meanings are one bank too, where that loads no more of
    WAVE_ARC_GS than before: a song's with another song's that plays the same waves of its own; an effect's with other
    effects' while the union's waves are no more than the largest member's own and EFFECT_SLACK (an effect loads its
    bank's waves as it starts: a few KB more than the largest of them did, well under what a song leaves). Never an instrument a member plays and has none at (plays:
    each sequence's programs), so nothing silent starts to sound. Each bank left in the archive is about 32 bytes of sound
    memory for good. The merged bank takes its first member's name; the entries are changed to match."""
    players = {}
    for seq in entries['seqInfo']:
        players.setdefault(seq['bank'], set()).add('effect' if seq['player'].startswith('PLAYER_SE') else 'song')
    parsed = {name: bank_instruments(text) for name, text in banks.items()}
    programs = {}
    for seq in entries['seqInfo']:
        programs.setdefault(seq['bank'], set()).update(plays[seq['name']])
    weight = lambda waves: sum(wave_sizes[w] for w in waves)  # noqa: E731
    keep = {}
    for kind in ('song', 'effect'):
        groups = []
        members = [b for b in sorted(banks) if players.get(b) == {kind}]
        for name in sorted(members, key=lambda b: (-weight(parsed[b][1]), b)):
            instruments, waves = parsed[name]
            for group in groups:
                if any(group['instruments'].get(n, text) != text for n, text in instruments.items()):
                    continue
                if (set(instruments) - set(group['instruments'])) & group['programs'] or \
                        (set(group['instruments']) - set(instruments)) & programs[name]:
                    continue
                union = group['waves'] | waves
                if kind == 'song' and not (union == group['waves'] == waves):
                    continue
                if kind == 'effect' and weight(union) > max(weight(group['waves']), weight(waves)) + EFFECT_SLACK:
                    continue
                group['instruments'].update(instruments)
                group['waves'] = union
                group['programs'] |= programs[name]
                group['names'].append(name)
                break
            else:
                groups.append({'instruments': dict(instruments), 'waves': set(waves), 'names': [name],
                               'programs': set(programs[name])})
        for group in groups:
            first = min(group['names'])
            for name in group['names']:
                keep[name] = first
            top = max(group['instruments'])
            banks[first] = ''.join(group['instruments'].get(i, f'{i}, NULL\r\n') for i in range(top + 1))
    for seq in entries['seqInfo']:
        seq['bank'] = keep.get(seq['bank'], seq['bank'])
    entries['bankInfo'] = [b for b in entries['bankInfo'] if keep.get(b['name'], b['name']) == b['name']]
    return {name: text for name, text in banks.items() if keep.get(name, name) == name}


def expand_same(lines):
    """A bank's lines with each 'SameAsAbove' instrument written out as the one above it."""
    out, last = [], []
    for line in lines:
        f = line.strip().split(', ')
        if not line.startswith('\t') and len(f) == 2 and f[1] == 'SameAsAbove':
            body = [last[0].replace(last[0].split(', ')[0], f[0], 1)] + last[1:]
            out += body
            last = body
            continue
        if not line.startswith('\t'):
            last = [line]
        else:
            last.append(line)
        out.append(line)
    return out


def main():
    data = unpack()
    seqs = {s['name']: s for s in data['seqInfo'] if s.get('name')}
    hg_banks = {b['name']: b for b in data['bankInfo'] if b.get('name')}
    platinum = json.load(open(os.path.join(SOUND, 'pl_sound_data.json'), encoding='utf-8'))
    taken = {e.get('name') for key in ('seqInfo', 'bankInfo', 'wavarcInfo') for e in platinum[key]}

    # Platinum's waves that stay loaded, by their bytes
    loaded = {hashlib.sha1(open(os.path.join(SOUND, 'WAVARC', BASIC, f), 'rb').read()).hexdigest(): i
              for i, f in enumerate(resident_waves())}

    gs_waves, gs_index = [], {}  # the archive's WAVs in order, and their hashes' places
    plays = {}  # each sequence's programs
    banks, entries = {}, {'seqInfo': [], 'bankInfo': [], 'wavarcInfo': []}
    songs = needed_songs(seqs)
    effects = needed_effects(seqs, taken)
    for name in songs + effects:
        if name in taken:
            sys.exit(f'{name} is already a Platinum sequence')
        seq = seqs[name]
        hg_bank = hg_banks[seq['bank']]
        lines = expand_same(bank_text(hg_bank['name']))
        bank = Bank(hg_bank['name'], hg_bank['waves'], lines)
        notes = sseq_notes(os.path.join(CACHE, 'files', seq['fileName']))
        used = played(bank, notes)
        programs = {p for p, _ in notes[0]} | set(notes[1])
        if notes[2]:
            programs = set(bank.instruments())
        plays[name] = programs

        # The song's bank: its instruments, the rest empty, each wave from Platinum's loaded ones or WAVE_ARC_GS
        out, keep = [], False
        top = max(programs | {0})
        for line in lines:
            f = line.rstrip('\r\n').split(', ')
            ending = line[len(line.rstrip('\r\n')):]
            if not line.startswith('\t'):
                keep = int(f[0]) in programs
                if int(f[0]) > top:
                    keep = False
                    continue
                if not keep:
                    out.append(f'{f[0]}, NULL{ending}')
                    continue
            elif not keep:
                continue
            if (line.startswith('\t') and f[0].strip() == '1') or (not line.startswith('\t') and f[1] == 'Single'):
                wave_field, slot_field = (1, 2) if line.startswith('\t') else (2, 3)
                archive, wave = hg_bank['waves'][int(f[slot_field])], int(f[wave_field])
                if (archive, wave) not in used:
                    slot, index = 0, 0  # never played
                else:
                    digest = hashlib.sha1(open(wave_file(archive, wave), 'rb').read()).hexdigest()
                    if digest in loaded:
                        slot, index = 0, loaded[digest]
                    else:
                        if digest not in gs_index:
                            gs_index[digest] = len(gs_waves)
                            gs_waves.append(wave_file(archive, wave))
                        slot, index = 1, gs_index[digest]
                f[wave_field], f[slot_field] = str(index), str(slot)
            out.append(', '.join(f) + ending)
        # instruments up to the highest the song plays, numbered without gaps and in order (nitrosfx needs both)
        instruments = {}
        for line in out:
            if line.startswith('\t'):
                instruments[number].append(line)
            else:
                number = int(line.split(', ')[0])
                instruments[number] = [line]
        bank_name = 'BANK_' + name[len('SEQ_'):]
        banks[bank_name] = ''.join(''.join(instruments.get(i, [f'{i}, NULL\r\n'])) for i in range(top + 1))
        entries['bankInfo'].append({'name': bank_name, 'fileName': f'{bank_name}.sbnk',
                                    'waves': [BASIC, GS_ARCHIVE, '', '']})
        entries['seqInfo'].append(dict(seq, fileName=f'{name}.sseq', bank=bank_name))
    entries['wavarcInfo'].append({'name': GS_ARCHIVE, 'fileName': f'{GS_ARCHIVE}.swar', 'singleLoad': True})
    banks = merge_same_banks(banks, entries)
    banks = merge_compatible_banks(banks, entries, [os.path.getsize(p) for p in gs_waves], plays)

    # Written out: anything this run no longer makes goes
    changed = False
    wanted = set()
    for bank_name, text in banks.items():
        path = os.path.join(OUT, 'BANK', f'{bank_name}.txt')
        wanted.add(path)
        changed |= write_if_changed(path, text)
    for name in songs + effects:
        path = os.path.join(OUT, 'SEQ', f'{name}.sseq')
        wanted.add(path)
        source = os.path.join(CACHE, 'files', seqs[name]['fileName'])
        if not os.path.exists(path) or open(path, 'rb').read() != open(source, 'rb').read():
            os.makedirs(os.path.dirname(path), exist_ok=True)
            shutil.copyfile(source, path)
            changed = True
    for i, source in enumerate(gs_waves):
        path = os.path.join(OUT, GS_ARCHIVE, f'{i:03d}.wav')
        wanted.add(path)
        if not os.path.exists(path) or open(path, 'rb').read() != open(source, 'rb').read():
            os.makedirs(os.path.dirname(path), exist_ok=True)
            shutil.copyfile(source, path)
            changed = True
    for folder in ('BANK', 'SEQ', GS_ARCHIVE):
        for path in glob.glob(os.path.join(OUT, folder, '*')):
            if path not in wanted:
                os.remove(path)
                changed = True
    changed |= write_if_changed(os.path.join(OUT, 'hgss_sound.json'), json.dumps(entries, indent=1) + '\n')
    changed |= write_if_changed(os.path.join(OUT, 'meson.build'), meson(sorted(banks), songs + effects, len(gs_waves)))
    changed |= write_if_changed(os.path.join(ROOT, 'decomp', 'include', 'data', 'hgss_sound.h'), music_tables())

    size = sum(os.path.getsize(p) for p in gs_waves)
    print(f'{len(songs)} of HeartGold\'s songs and {len(effects)} sound effects, {len(gs_waves)} waves of their own '
          f'({size // 1024} KB); ' + ('written' if changed else 'unchanged'))


def music_tables():
    """HeartGold's encounter and battle themes, as C tables in the engine's names."""
    classes = {line.strip() for line in open(os.path.join(ROOT, 'decomp', 'generated', 'trainer_classes.txt'))}

    def trainer_class(name):  # HeartGold's own classes are TRAINER_CLASS_HGSS_*, the shared ones Platinum's
        for ours in (f'TRAINER_CLASS_HGSS_{name}', f'TRAINER_CLASS_{name}'):
            if ours in classes:
                return ours
        sys.exit(f'HeartGold\'s TRAINERCLASS_{name} has no class here')

    field_bgm = open(os.path.join(HG, 'src', 'field_bgm.c')).read()
    eyes = re.findall(r'\{ TRAINERCLASS_(\w+), (SEQ_GS_\w+), SEQ_GS_\w+ \}', field_bgm)
    asm = open(os.path.join(HG, 'asm', 'unk_020517A4.s')).read()
    species = re.findall(r'\.short SPECIES_(\w+) \| \((\d+) << 10\)', asm)
    by_class = re.findall(r'\.short TRAINERCLASS_(\w+) \| \((\d+) << 10\)', asm)
    params = re.findall(r'\.short (?:\d+|0xFFFF), (SEQ_GS_\w+)\s+; (\d+)', asm)
    assert eyes and species and by_class and [int(i) for _, i in params] == list(range(len(params)))
    return ('// Generated by tools/complete/import_hgss_sound.py from HeartGold\'s src/field_bgm.c and\n'
            '// asm/unk_020517A4.s: which of its songs plays when (src/complete_sound.c)\n\n'
            'static const u16 sHGSSEncounterMusic[][2] = {\n'
            + ''.join(f'    {{ {trainer_class(c)}, {seq}_sseq }},\n' for c, seq in eyes) + '};\n\n'
            '// A trainer class\'s or a wild species\' row of sHGSSBattleMusic\n'
            'static const u16 sHGSSBattleMusicByClass[][2] = {\n'
            + ''.join(f'    {{ {trainer_class(c)}, {n} }},\n' for c, n in by_class) + '};\n\n'
            'static const u16 sHGSSBattleMusicBySpecies[][2] = {\n'
            + ''.join(f'    {{ SPECIES_{sp}, {n} }},\n' for sp, n in species) + '};\n\n'
            'static const u16 sHGSSBattleMusic[] = {\n'
            + ''.join(f'    {seq}_sseq, // {i}\n' for seq, i in params) + '};\n')


def meson(banks, songs, waves):
    return ('# Generated by tools/complete/import_hgss_sound.py: HeartGold\'s songs, their banks and waves.\n\n'
            'hgss_sound_bank_files = files([\n' + ''.join(f"    'BANK/{b}.txt',\n" for b in banks) + '])\n\n'
            'hgss_sound_sequence_files = files([\n' + ''.join(f"    'SEQ/{s}.sseq',\n" for s in songs) + '])\n\n'
            f"WAVE_ARC_GS = custom_target('{GS_ARCHIVE}.swar',\n"
            '    input: files([\n' + ''.join(f"        '{GS_ARCHIVE}/{i:03d}.wav',\n" for i in range(waves))
            + '    ]),\n'
            f"    output: '{GS_ARCHIVE}.swar',\n"
            f"    command: [nitrosfx_exe, meson.current_source_dir() / '{GS_ARCHIVE}', '@OUTPUT0@'],\n"
            ')\n')


if __name__ == '__main__':
    main()
