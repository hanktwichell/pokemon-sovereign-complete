#!/usr/bin/env python3
"""Bring in HeartGold's songs for Johto and Kanto (docs/Music.md, step 6).

The songs: every one HeartGold's map headers name, its scripts play (Sacred Gold's, which are the game's; a scene's
song too, TempBGM), its field music code picks (surfing, cycling, the trainers' encounter themes, and the songs a
flag puts on a map, as in the Bug-Catching Contest), and its battle and victory themes; and the fanfares its scripts
play (SEQ_ME_*: an item, a badge, a Pokémon caught). Sacred Gold leaves HeartGold's sound archive as it is.

HeartGold's sound archive (its pret decomp's prebuilt files/data/sound/gs_sound_data.sdat) is unpacked into
.cache/hgss_sound with the decomp's nitrosfx. Each song keeps HeartGold's sequence file byte for byte, and gets a bank
of its own: HeartGold's instruments the song plays, at their numbers (the others empty), with each wave a note can
play: a wave Platinum keeps loaded (WAVE_ARC_BASIC after tools/complete/split_sound_basic.py) is used from there, any
other from WAVE_ARC_GS, one archive of all of them, which loads wave by wave (NitroSystem's single load), so a song
loads only its own. A key split or drum region the song never plays points at Platinum's first loaded wave.

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
from split_sound_basic import (BASIC, ROOT, SOUND, Bank, nitrosfx, played, resident_waves,  # noqa: E402
                               sseq_notes, write_if_changed)

HG = os.path.join(ROOT, '.cache', 'pokeheartgold')
SACRED_SCRIPTS = os.path.join(ROOT, '.cache', 'sacredgold', 'scr_seq')
CACHE = os.path.join(ROOT, '.cache', 'hgss_sound')
OUT = os.path.join(SOUND, 'complete', 'hgss')
GS_ARCHIVE = 'WAVE_ARC_GS'
MUSIC_PLAYERS = ('PLAYER_BGM', 'PLAYER_FIELD', 'PLAYER_ME')  # songs, and fanfares (SEQ_ME_*)
# The battle and victory themes (the Frontier Brains' too), and surfing and cycling, which HeartGold picks by number or
# in code
OTHER_SONGS = r'SEQ_GS_(VS_(?!.*_PHC)\w+|WIN\w*|BA_BRAIN|BICYCLE|NAMINORI)'


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
    names |= {n for n in seqs if re.fullmatch(OTHER_SONGS, n)}
    return sorted(n for n in names if n.startswith(('SEQ_GS_', 'SEQ_ME_')) and n in seqs
                  and seqs[n]['player'] in MUSIC_PLAYERS)


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
    banks, entries = {}, {'seqInfo': [], 'bankInfo': [], 'wavarcInfo': []}
    songs = needed_songs(seqs)
    for name in songs:
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

    # Written out: anything this run no longer makes goes
    changed = False
    wanted = set()
    for bank_name, text in banks.items():
        path = os.path.join(OUT, 'BANK', f'{bank_name}.txt')
        wanted.add(path)
        changed |= write_if_changed(path, text)
    for name in songs:
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
    changed |= write_if_changed(os.path.join(OUT, 'meson.build'), meson(sorted(banks), songs, len(gs_waves)))
    changed |= write_if_changed(os.path.join(ROOT, 'decomp', 'include', 'data', 'hgss_sound.h'), music_tables())

    size = sum(os.path.getsize(p) for p in gs_waves)
    print(f'{len(songs)} of HeartGold\'s songs, {len(gs_waves)} waves of their own ({size // 1024} KB); '
          + ('written' if changed else 'unchanged'))


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
