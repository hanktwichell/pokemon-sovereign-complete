#!/usr/bin/env python3
"""Split Platinum's basic wave archive in two, so HeartGold's songs have room in sound memory (docs/Music.md, step 6).

WAVE_ARC_BASIC (163 waves, about 458 KB) is loaded at boot and stays loaded the whole game, but only its sound
effects, fanfares and cries need it there. The waves only music plays move to WAVE_ARC_BGM_BASIC, which the music
banks load with their own waves, so the field has that much more room for a song whose bank doesn't use them
(HeartGold's). Sinnoh's songs load the same waves as before, in two archives.

Which waves stay: every wave a note of a sound effect, fanfare or cry can play (each sequence's notes by program and
key, from its MIDI and from the sequence built from it, through its bank's instruments: key splits and drum kits count
only the keys it plays), and those of the songs that play without loading anything (src: Sound_PlayBasicBGM, and
Sound_PlayFanfare from code and scripts). A sequence with random or variable notes counts each instrument it uses
whole.

What changes, all written to decomp/res/sound/complete/ (which decomp/res/sound/meson.build uses in place of
Sovereign's files, so Sovereign's own stay as they are for syncs):
- the banks (BANK/*.txt): each wave number in the new archives; the music banks (BANK_BGM_*) take
  WAVE_ARC_BGM_BASIC as one more wave archive; a sound effect bank's instruments that only music plays point at the
  first wave that stays (they never sound);
- a new bank, BANK_BGM_BASIC: BANK_BASIC's instruments for the songs on BANK_BASIC that load their bank (the
  trainers' encounter themes, cutscenes), which move to it;
- pl_sound_data.json: the new bank and wave archive after Sovereign's, the music banks' wave archives, those songs'
  bank;
- meson.build files that gather each archive's WAVs (Sovereign's own files) into the build and pack them, and the
  list of what the archive packs from here (complete_sound_inputs).

HeartGold's songs (tools/complete/import_hgss_sound.py, which writes complete/hgss/) are added after Platinum's.

Before writing, it checks that every note of every sequence (and of the field songs on BANK_BASIC, which play with
the map's bank too: src/sound_playback.c) plays the same WAV file as before, and that no sound effect, fanfare or
cry needs WAVE_ARC_BGM_BASIC. Running it again changes nothing; tools/complete/sync_sovereign.sh runs it after a sync.

Usage: python3 tools/complete/split_sound_basic.py (after a build: it needs the decomp's nitrosfx)
"""
import collections
import glob
import json
import os
import re
import struct
import subprocess
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'audio'))
import cjson_format  # noqa: E402

DECOMP = os.path.join(ROOT, 'decomp')
SOUND = os.path.join(DECOMP, 'res', 'sound')
OUT = os.path.join(SOUND, 'complete')
BASIC, BGM_BASIC = 'WAVE_ARC_BASIC', 'WAVE_ARC_BGM_BASIC'
BASIC_BANK, BGM_BASIC_BANK = 'BANK_BASIC', 'BANK_BGM_BASIC'
MUSIC_PLAYERS = ('PLAYER_BGM', 'PLAYER_FIELD')
FIELD_BANKS = ('BANK_BGM_FIELD', 'BANK_BGM_DUNGEON')  # what a field song on BANK_BASIC may also play with
SSEQ_RANDOM_COMMANDS = (0xA0, 0xA1, 0xA2)  # random, variable, if: nitrosfx keeps them as MIDI markers
SSEQ_PROGRAM = 0x81
MIDI_TRANSPOSE = 13  # nitrosfx's controller for SSEQ's transpose


def write_if_changed(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if os.path.exists(path) and open(path, encoding='utf-8', newline='').read() == text:
        return False
    with open(path, 'w', encoding='utf-8', newline='') as f:
        f.write(text)
    return True


class Bank:
    """A bank's text (nitrosfx's): an instrument per line, 'index, Single, wave, archive slot, ...',
    'index, PSG1, ...', 'index, NULL', or a key split or drum kit followed by its tab-indented PCM regions
    ('1, wave, archive slot, ...')."""

    def __init__(self, name, waves, lines):
        self.name, self.waves, self.lines = name, list(waves), lines

    def references(self):
        """[(line number, field holding the wave, the archive slot's field)] of each PCM wave."""
        out = []
        for i, line in enumerate(self.lines):
            f = line.strip().split(', ')
            if line.startswith('\t') and f[0] == '1':
                out.append((i, 1, 2))
            elif not line.startswith('\t') and len(f) > 3 and f[1] == 'Single':
                out.append((i, 2, 3))
        return out

    def instruments(self):
        """{program: [(low key, high key, archive, wave)]}."""
        out, cur, keys = {}, None, []
        for line in self.lines:
            f = line.strip().split(', ')
            if len(f) < 2:
                continue
            if line.startswith('\t'):
                low, high = keys.pop(0)
                if f[0] == '1':
                    out[cur].append((low, high, self.waves[int(f[2])], int(f[1])))
                continue
            cur, keys = int(f[0]), []
            out[cur] = []
            if f[1] == 'Single':
                out[cur].append((0, 127, self.waves[int(f[3])], int(f[2])))
            elif f[1] == 'Drums':
                keys = [(k, k) for k in range(int(f[2]), int(f[3]) + 1)]
            elif f[1] == 'Keysplit':
                low = 0
                for high in (int(x) for x in f[2:10]):
                    if high:
                        keys.append((low, high))
                        low = high + 1
        return out

    def text(self):
        return ''.join(self.lines)


def read_varlen(d, t):
    n = 0
    while d[t] & 0x80:
        n = (n << 7) | (d[t] & 0x7f)
        t += 1
    return (n << 7) | d[t], t + 1


def midi_notes(path):
    """The (program, key) of each note a sequence's MIDI plays (with SSEQ's transpose), the programs whose notes a
    random or variable command may change, and whether one may change a program."""
    d = open(path, 'rb').read()
    pos = 8 + struct.unpack('>I', d[4:8])[0]
    notes, fuzzy, any_program = set(), set(), False
    while pos < len(d):
        kind, size = d[pos:pos + 4], struct.unpack('>I', d[pos + 4:pos + 8])[0]
        t, end = pos + 8, pos + 8 + size
        pos = end
        if kind != b'MTrk':
            continue
        program, transpose = collections.defaultdict(int), collections.defaultdict(int)
        status, random_next = 0, False
        while t < end:
            _, t = read_varlen(d, t)
            if d[t] & 0x80:
                status = d[t]
                t += 1
            if status == 0xFF:
                meta = d[t]
                n, t = read_varlen(d, t + 1)
                body = d[t:t + n]
                t += n
                if meta == 0x06 and body and body[0] in SSEQ_RANDOM_COMMANDS:  # a marker holding an SSEQ command
                    any_program |= len(body) > 1 and body[1] == SSEQ_PROGRAM
                    random_next = True
            elif status in (0xF0, 0xF7):
                n, t = read_varlen(d, t)
                t += n
            else:
                channel, event = status & 0xf, status >> 4
                if event == 0xC:
                    program[channel] = d[t]
                    t += 1
                elif event == 0xD:
                    t += 1
                else:
                    a, b = d[t], d[t + 1]
                    t += 2
                    if event == 0xB and a == MIDI_TRANSPOSE:
                        transpose[channel] = b - 64
                    elif event == 0x9 and b > 0:
                        notes.add((program[channel], a + transpose[channel]))
                        if random_next:
                            fuzzy.add(program[channel])
                    if event == 0x9:
                        random_next = False
    return notes, fuzzy, any_program


SSEQ_ONE_BYTE_ARGS = set(range(0xC0, 0xD8))  # pan, volume, transpose ... mute
SSEQ_TWO_BYTE_ARGS = {0xE0, 0xE1, 0xE3}  # modulation delay, tempo, sweep pitch
SSEQ_MAX_CALLS = 3  # the sequence player's call stack


def sseq_args_end(d, p, cmd, replaced=None):
    """Where a command's arguments end; with replaced, its last argument is that many bytes instead (after a random
    or variable prefix)."""
    if cmd < 0x80:  # a note: velocity, then duration
        p += 1
        return p + replaced if replaced is not None else read_sseq_varlen(d, p)[1]
    if cmd in (0x80, 0x81):  # rest, program
        return p + replaced if replaced is not None else read_sseq_varlen(d, p)[1]
    if 0xB0 <= cmd <= 0xBD:  # variable operations: the variable, then a 16-bit value
        return p + 1 + (replaced if replaced is not None else 2)
    if cmd in SSEQ_ONE_BYTE_ARGS:
        return p + (replaced if replaced is not None else 1)
    if cmd in SSEQ_TWO_BYTE_ARGS or cmd == 0xFE:
        return p + (replaced if replaced is not None else 2)
    if cmd == 0x93:  # open track: the track, then its 24-bit offset
        return p + 1 + (replaced if replaced is not None else 3)
    if cmd in (0x94, 0x95):  # jump, call
        return p + (replaced if replaced is not None else 3)
    if cmd in (0xFC, 0xFD, 0xFF):  # loop end, return, end
        return p
    raise ValueError(f'unknown SSEQ command {cmd:#x}')


def read_sseq_varlen(d, p):
    n = 0
    while d[p] & 0x80:
        n = (n << 7) | (d[p] & 0x7f)
        p += 1
    return (n << 7) | d[p], p + 1


def sseq_notes(path):
    """As midi_notes, from a built sequence, following each track through its jumps and calls (in both a call's
    state and the caller's, so the notes a called block plays under each program are all counted)."""
    d = open(path, 'rb').read()
    data = d[struct.unpack('<I', d[24:28])[0]:]
    notes, fuzzy, any_program = set(), set(), False
    starts, seen = [0], set()
    while starts:
        paths = [(starts.pop(), 0, 0, False, ())]  # position, program, transpose, transpose unknown, call stack
        while paths:
            p, program, transpose, unknown, calls = paths.pop()
            while p < len(data) and (p, program, transpose, unknown, calls) not in seen:
                seen.add((p, program, transpose, unknown, calls))
                cmd = data[p]
                p += 1
                if cmd in (0xA0, 0xA1):  # random, variable: the next command's last argument comes from elsewhere
                    sub = data[p]
                    any_program |= sub == SSEQ_PROGRAM
                    unknown |= sub == 0xC3
                    if sub < 0x80:
                        notes.add((program, sub + transpose))
                        fuzzy.add(program)
                    p = sseq_args_end(data, p + 1, sub, 4 if cmd == 0xA0 else 1)
                    continue
                if cmd == 0xA2:  # if: the next command may run
                    continue
                if cmd < 0x80:
                    notes.add((program, cmd + transpose))
                    if unknown:
                        fuzzy.add(program)
                elif cmd == SSEQ_PROGRAM:
                    program = read_sseq_varlen(data, p)[0]
                elif cmd == 0xC3:
                    transpose = struct.unpack('b', data[p:p + 1])[0]
                elif cmd == 0x93:
                    starts.append(int.from_bytes(data[p + 1:p + 4], 'little'))
                elif cmd == 0x94:
                    p = int.from_bytes(data[p:p + 3], 'little')
                    continue
                elif cmd == 0x95 and len(calls) < SSEQ_MAX_CALLS:
                    paths.append((int.from_bytes(data[p:p + 3], 'little'), program, transpose, unknown,
                                  calls + (p + 3,)))
                elif cmd == 0xFD:
                    if not calls:
                        break
                    p, calls = calls[-1], calls[:-1]
                    continue
                elif cmd == 0xFF:
                    break
                p = sseq_args_end(data, p, cmd)
    return notes, fuzzy, any_program


def sequence_notes(name, midi):
    """A sequence's notes, read both from its MIDI and from the sequence nitrosfx builds from it (into
    .cache/sound_sseq): nitrosfx keeps jumps and calls in the MIDI as markers, so the MIDI alone reads a called
    block under the program before it."""
    built = os.path.join(ROOT, '.cache', 'sound_sseq', f'{name}.sseq')
    if not os.path.exists(built) or os.path.getmtime(built) < os.path.getmtime(midi):
        os.makedirs(os.path.dirname(built), exist_ok=True)
        subprocess.run([nitrosfx(), midi, built], check=True, capture_output=True)
    a, b = midi_notes(midi), sseq_notes(built)
    return a[0] | b[0], a[1] | b[1], a[2] or b[2]


def nitrosfx():
    """The decomp's nitrosfx, from a build (make -C decomp builds it)."""
    for build in ('build', 'build_test'):
        path = os.path.join(DECOMP, build, 'tools', 'nitrosfx', 'nitrosfx')
        if os.path.exists(path):
            return path
    sys.exit('Build the decomp first (make -C decomp): this needs its nitrosfx.')


def played(bank, notes):
    """The (archive, wave) each note plays through the bank's instruments."""
    notes, fuzzy, any_program = notes
    inst = bank.instruments()
    if any_program:
        return {(a, w) for regions in inst.values() for _, _, a, w in regions}
    return {(a, w) for p, k in notes for low, high, a, w in inst.get(p, [])
            if p in fuzzy or low <= k <= high}


def played_without_loading():
    """Sequences the game plays without loading their waves: Sound_PlayBasicBGM's, and Sound_PlayFanfare's (which
    loads the sequence and bank only), in code and scripts."""
    names = set()
    for path in glob.glob(os.path.join(DECOMP, 'src', '**', '*.c'), recursive=True):
        text = open(path, errors='replace').read()
        names |= set(re.findall(r'Sound_Play(?:Fanfare|BasicBGM)\((SEQ_\w+?)_sseq\)', text))
    for path in glob.glob(os.path.join(DECOMP, 'res', '**', '*.s'), recursive=True):
        names |= set(re.findall(r'PlayFanfare (SEQ_\w+?)_sseq', open(path, errors='replace').read()))
    return names


def wave_files(archive):
    folder = os.path.join(SOUND, 'WAVARC', archive)
    return sorted(f for f in os.listdir(folder) if f.endswith('.wav'))


def resident_waves():
    """The WAVs of WAVE_ARC_BASIC that stay loaded, in the archive's order (as the last run wrote them)."""
    prefix = f"'../../WAVARC/{BASIC}/"
    return [line.strip()[len(prefix):-2] for line in open(os.path.join(OUT, BASIC, 'meson.build'))
            if line.strip().startswith(prefix)]


def bank_meson(names, hgss):
    """complete_sound_inputs: what res/sound/meson.build packs in place of Sovereign's banks and basic waves, with
    HeartGold's songs (tools/complete/import_hgss_sound.py) when they're in."""
    inputs = ['sbnk_gen.process(complete_sound_bank_files)', 'copy_gen.process(COMPLETE_WAVE_ARC_BASIC)',
              f'copy_gen.process({BGM_BASIC})']
    if hgss:
        inputs += ['sbnk_gen.process(hgss_sound_bank_files)', 'copy_gen.process(hgss_sound_sequence_files)',
                   'copy_gen.process(WAVE_ARC_GS)']
    return ('# Generated by tools/complete/split_sound_basic.py: Sovereign Complete\'s sound archive files, packed in\n'
            '# place of res/sound\'s banks and basic waves (res/sound/meson.build).\n\n'
            "sh_exe = find_program('sh')\n\n"
            'complete_sound_bank_files = files([\n' + ''.join(f"    'BANK/{n}.txt',\n" for n in names) + '])\n\n'
            "subdir('WAVE_ARC_BASIC')\nsubdir('WAVE_ARC_BGM_BASIC')\n" + ("subdir('hgss')\n" if hgss else '')
            + '\ncomplete_sound_inputs = [\n' + ''.join(f'    {i},\n' for i in inputs) + ']\n')


def archive_meson(archive, files):
    source = f"'../../WAVARC/{BASIC}/"
    return (f'# Generated by tools/complete/split_sound_basic.py: {archive}, from {BASIC}\'s WAVs. The copy clears\n'
            '# the folder first, so a WAV the split no longer puts here is not packed.\n\n'
            f'{archive}_waves = custom_target(\'{archive}_waves\',\n'
            '    input: files([\n' + ''.join(f"        {source}{f}',\n" for f in files) + '    ]),\n'
            '    output: [\n' + ''.join(f"        '{f}',\n" for f in files) + '    ],\n'
            "    command: [sh_exe, '-c', 'rm -f \"$0\"/*.wav && cp \"$@\" \"$0\"', '@OUTDIR@', '@INPUT@'],\n"
            ')\n\n'
            f"{'COMPLETE_' + archive if archive == BASIC else archive} = custom_target('{archive}.swar',\n"
            f'    input: {archive}_waves,\n'
            f"    output: '{archive}.swar',\n"
            "    command: [nitrosfx_exe, '@OUTDIR@', '@OUTPUT0@'],\n"
            ')\n')


def main():
    data = json.load(open(os.path.join(SOUND, 'pl_sound_data.json'), encoding='utf-8'))
    banks = {}
    for info in data['bankInfo']:
        path = os.path.join(SOUND, 'BANK', f"{info.get('name')}.txt")
        if info.get('name') and os.path.exists(path):
            # the banks' lines end in CRLF, which nitrosfx expects
            lines = open(path, encoding='utf-8', newline='').readlines()
            banks[info['name']] = Bank(info['name'], info['waves'], lines)
    seqs = [s for s in data['seqInfo'] if s.get('name') and s.get('bank') in banks]
    notes = {s['name']: sequence_notes(s['name'], os.path.join(SOUND, 'SEQ', s['fileName'].replace('.sseq', '.mid')))
             for s in seqs}
    unloaded = played_without_loading()

    def plays_with(s):
        """The banks a sequence plays with: its own, and for a field song (surfing, cycling) started while the map's
        song is the field song, the map's (Sound_Impl_PlayFieldBGM)."""
        if s['player'] == 'PLAYER_FIELD':
            return [banks[s['bank']]] + [banks[b] for b in FIELD_BANKS if b != s['bank']]
        return [banks[s['bank']]]

    def stays(s):
        return s['player'] not in MUSIC_PLAYERS or s['name'] in unloaded

    basic_files = wave_files(BASIC)
    resident = sorted({w for s in seqs if stays(s) for b in plays_with(s)
                       for a, w in played(b, notes[s['name']]) if a == BASIC})
    moved = sorted(set(range(len(basic_files))) - set(resident))
    new_index = {w: (BASIC, i) for i, w in enumerate(resident)}
    new_index.update({w: (BGM_BASIC, i) for i, w in enumerate(moved)})

    # The banks, rewritten
    new_banks, silenced = {}, collections.Counter()
    sources = list(banks.values()) + [Bank(BGM_BASIC_BANK, [BASIC, '', '', ''], banks[BASIC_BANK].lines)]
    for bank in sources:
        music = bank.name.startswith('BANK_BGM_')
        lines, waves = list(bank.lines), list(bank.waves)
        for i, wave_field, slot_field in bank.references():
            body = lines[i].rstrip('\r\n')
            f = body.split(', ')
            if waves[int(f[slot_field])] != BASIC:
                continue
            archive, index = new_index[int(f[wave_field])]
            if archive == BGM_BASIC and not music:
                archive, index = BASIC, 0
                silenced[bank.name] += 1
            if archive not in waves:
                waves[waves.index('')] = archive
            f[wave_field], f[slot_field] = str(index), str(waves.index(archive))
            lines[i] = ', '.join(f) + lines[i][len(body):]
        new_banks[bank.name] = Bank(bank.name, waves, lines)

    # The check: every note plays the same WAV, and nothing that stays loaded needs the music's waves
    files = {BASIC: [basic_files[w] for w in resident], BGM_BASIC: [basic_files[w] for w in moved]}

    def wav(archive, wave):
        return (BASIC, files[archive][wave]) if archive in files else (archive, wave)

    def old_wav(archive, wave):
        return (BASIC, basic_files[wave]) if archive == BASIC else (archive, wave)

    moved_bank = {}
    for s in seqs:
        moved_bank[s['name']] = BGM_BASIC_BANK if s['bank'] == BASIC_BANK and not stays(s) else s['bank']
        olds = plays_with(s)
        news = [new_banks[moved_bank[s['name']]]] + [new_banks[b.name] for b in olds[1:]]
        for old, new in zip(olds, news):
            before = sorted(old_wav(*x) for x in played(old, notes[s['name']]))
            after = sorted(wav(*x) for x in played(new, notes[s['name']]))
            if before != after:
                sys.exit(f"{s['name']} on {new.name}: its notes would play other waves")
            if stays(s) and any(a == BGM_BASIC for a, _ in played(new, notes[s['name']])):
                sys.exit(f"{s['name']} stays loaded but would need {BGM_BASIC}")

    # pl_sound_data.json: the new bank and archive after Sovereign's, the music banks' archives, the songs' bank
    out = json.loads(json.dumps(data))
    for info in out['bankInfo']:
        if info.get('name') in new_banks:
            info['waves'] = new_banks[info['name']].waves
    out['bankInfo'].append({'name': BGM_BASIC_BANK, 'fileName': f'{BGM_BASIC_BANK}.sbnk',
                            'waves': new_banks[BGM_BASIC_BANK].waves})
    out['wavarcInfo'].append({'name': BGM_BASIC, 'fileName': f'{BGM_BASIC}.swar'})
    for info in out['seqInfo']:
        if info.get('name') in moved_bank:
            info['bank'] = moved_bank[info['name']]
    hgss = os.path.join(OUT, 'hgss', 'hgss_sound.json')
    if os.path.exists(hgss):  # HeartGold's songs, after Platinum's (tools/complete/import_hgss_sound.py)
        for key, added in json.load(open(hgss, encoding='utf-8')).items():
            out[key] += added

    changed = write_if_changed(os.path.join(OUT, 'pl_sound_data.json'), cjson_format.dumps(out) + '\n')
    for name, bank in new_banks.items():
        changed |= write_if_changed(os.path.join(OUT, 'BANK', f'{name}.txt'), bank.text())
    changed |= write_if_changed(os.path.join(OUT, 'meson.build'), bank_meson(sorted(new_banks), os.path.exists(hgss)))
    for archive in (BASIC, BGM_BASIC):
        changed |= write_if_changed(os.path.join(OUT, archive, 'meson.build'), archive_meson(archive, files[archive]))

    def size(names):
        total = 0
        for n in names:
            d = open(os.path.join(SOUND, 'WAVARC', BASIC, n), 'rb').read()
            total += struct.unpack('<I', d[d.index(b'data') + 4:d.index(b'data') + 8])[0]
        return total

    songs = sum(1 for s in seqs if moved_bank[s['name']] != s['bank'])
    print(f'{BASIC}: {len(resident)} waves stay loaded ({size(files[BASIC]) // 1024} KB), {len(moved)} move to '
          f'{BGM_BASIC} ({size(files[BGM_BASIC]) // 1024} KB); {songs} songs move to {BGM_BASIC_BANK}; '
          f'{sum(silenced.values())} sound effect bank regions only music plays point at wave 0; '
          + ('written' if changed else 'unchanged'))


if __name__ == '__main__':
    main()
