#!/usr/bin/env python3
"""Check that every song fits in sound memory, in the test build (docs/Music.md; src/complete_test.c's
gCompleteTestSound, which notes each load into the sound heap):

1. **Songs:** on a map (the bedroom state's), each song of the archive's music players, played as the game plays it
   (a field song as a map's song, a cutscene's in its sound scene, any other as a script's PlayMusic): none of its
   loads fails, and it leaves some memory free. The songs that leave the least are listed.
2. **Battle:** a trainer battle (SELECT+R, the test build's own trainer) and the map's song after it: no load fails.
3. **Johto:** New Bark Town's own song (HeartGold's) loads as the player arrives, each of HeartGold's fanfares plays
   over it, and a trainer battle there plays HeartGold's trainer theme: no load fails.
4. **Flags:** the songs a flag puts on a map (src/complete_sound.c, sAltMusic): the player comes onto the National
   Park, a contest gatehouse and the Radio Tower with the flag set (gSovereignTestVar), and the song loads, with no
   load failing.

Results: one line per part, 'ok' or what went wrong; with --all, a line per song (its sequence, the bytes free after
it loads). --only PART runs that part alone (songs, battle, johto, flags).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_sound_heap.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [--all] [--only PART]
"""
import json
import os
import re
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import TEST_BUILD, fight  # noqa: E402
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS as TALK_SYMBOLS, header_names, var_ids, warp  # noqa: E402

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from test_map_warp import walkable_tile  # noqa: E402

SOUND = {'free': 0, 'minFree': 4, 'failures': 8, 'lastFailedID': 12, 'loads': 14, 'playSeq': 16, 'playScene': 18,
         'log': 20}  # CompleteTestSound
LOG_ENTRIES, LOG_SIZE = 8, 8  # COMPLETE_TEST_SOUND_LOG; CompleteTestSoundLoad
SCENE_SONGS = {'SEQ_BLD_ENDING_sseq': 14}  # songs only a cutscene plays, in its sound scene (enum SoundScene)
FANFARE = 0xFFFF  # playScene: as a fanfare (COMPLETE_TEST_SOUND_FANFARE)
FANFARE_FRAMES = 600  # a fanfare's length and more, so it ends and gives its memory back before the next
JOHTO = ('MAP_HEADER_HGSS_NEW_BARK', 695, 397, 'SEQ_GS_T_WAKABA_sseq')  # a tile outside the player's house
MUSIC_PLAYERS = ('PLAYER_BGM', 'PLAYER_FIELD')
FLAG_SONGS = [  # (map, the flag, its song), one of each of sAltMusic's songs
    ('MAP_HEADER_HGSS_NATIONAL_PARK', 'FLAG_HGSS_BUG_CONTEST_ACTIVE', 'SEQ_GS_TAIKAIMAE_D5_sseq'),
    ('MAP_HEADER_HGSS_ROUTE_36_NATIONAL_PARK_GATEHOUSE', 'FLAG_HGSS_BUG_CONTEST_ACTIVE', 'SEQ_GS_TAIKAIMAE_sseq'),
    ('MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_2F', 'FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE', 'SEQ_GS_SENKYO_sseq'),
]
SETTLE = 90  # frames for a song's loads (the next free field frame, then the load)
BATTLE_FRAMES = 40000
LEAST = 8  # the songs leaving the least memory, listed


def songs(players=MUSIC_PLAYERS, prefix='SEQ_'):
    """[(name, sequence ID)] of the archive's music (or other players'), from the build's archive (the split's,
    docs/Music.md)."""
    data = json.load(open(os.path.join(DECOMP, 'res', 'sound', 'complete', 'pl_sound_data.json'), encoding='utf-8'))
    naix = open(os.path.join(DECOMP, TEST_BUILD, 'res', 'sound', 'pl_sound_data.naix')).read()
    ids = {int(n): name for name, n in re.findall(r'#define (SEQ_\w+) (\d+)', naix)}
    out = [(ids[i], i) for i, s in enumerate(data['seqInfo'])
           if s.get('name') and s.get('player') in players and i in ids and ids[i].startswith(prefix)]
    return sorted(out, key=lambda song: song[0] in SCENE_SONGS)  # the cutscenes' last: they leave the field


class Harness:
    """The emulator, the test build's symbols, and gCompleteTestSound's fields."""

    def __init__(self, rom, state, out):
        from drive import Driver
        self.sym = bm.symbols(tuple(set(TALK_SYMBOLS) | {'gCompleteTestSound', 'gSovereignTestGodMode',
                                                          'gSovereignTestBattleTrainer'}))
        self.d = Driver(rom, state)
        self.mem = self.d.emu.memory
        self.base = self.sym['gCompleteTestSound']
        self.state, self.out, self.results = state, out, []

    def read(self, field, size=4):
        at = self.base + SOUND[field]
        return int.from_bytes(bytes(self.mem.unsigned[at:at + size]), 'little')

    def read_log(self, i):  # a logged load's file
        at = self.base + SOUND['log'] + i * LOG_SIZE
        return int.from_bytes(bytes(self.mem.unsigned[at:at + 2]), 'little')

    def start(self):
        """The bedroom state, with minFree reset; the failures so far."""
        self.d.load_state(self.state)
        self.d.run(60)
        self.mem.write_long(self.base + SOUND['minFree'], 0xFFFFFFFF)
        return self.read('failures')

    def play(self, seq, scene=0, frames=SETTLE):
        self.mem.write_short(self.base + SOUND['playScene'], scene)
        self.mem.write_short(self.base + SOUND['playSeq'], seq)
        self.d.run(frames)

    def battle(self):
        """A trainer battle (SELECT+R) played out: fight()'s result."""
        self.mem.write_byte(self.sym['gSovereignTestGodMode'], 1)
        self.d.press('SELECT+R')
        result, _ = fight(self.d, self.sym, BATTLE_FRAMES)
        self.d.run(SETTLE)
        return result

    def failed_since(self, failures):
        if self.read('failures') == failures:
            return ''
        return f'{self.read("failures") - failures} loads failed (file {self.read("lastFailedID", 2)})'

    def part(self, name, problem):
        self.results.append(f'{name}: {problem or "ok"}')
        print(self.results[-1], flush=True)
        if problem:
            self.d.screenshot().save(os.path.join(self.out, f'{name}.png'))


def songs_part(h, show_all):
    """1. Each song on a map, as the game plays it."""
    h.start()
    failed, left = [], []
    for name, seq in songs():
        failures = h.read('failures')
        h.mem.write_long(h.base + SOUND['minFree'], 0xFFFFFFFF)
        h.play(seq, SCENE_SONGS.get(name, 0))
        if h.read('playSeq', 2):
            failed.append(f'{name} never played')
            continue
        if h.read('failures') != failures:
            failed.append(f'{name} (file {h.read("lastFailedID", 2)})')
        left.append((h.read('minFree'), name))
        if show_all:
            print(f'{name} {h.read("minFree")}', flush=True)
    left.sort()
    h.part('songs', f'{len(failed)} of {len(left)} failed to load: {", ".join(failed[:10])}' if failed else '')
    print('least memory left: ' + ', '.join(f'{n} {free // 1024} KB' for free, n in left[:LEAST]), flush=True)


def battle_part(h):
    """2. A trainer battle, and the map's song after it."""
    failures = h.start()
    result = h.battle()
    h.part('battle', result if result != 'ok' else h.failed_since(failures))
    print(f'battle: least memory left {h.read("minFree") // 1024} KB', flush=True)


def johto_part(h):
    """3. New Bark Town's song as the player arrives, HeartGold's fanfares over it, and a battle there."""
    failures = h.start()
    header, x, z, song = JOHTO
    arrived, _ = warp(h.d, h.sym, header_names().index(header), x, z, 0)
    loaded = {h.read_log(i) for i in range(LOG_ENTRIES)}
    problem = f'warp {arrived}' if arrived != 'ok' else '' if dict(songs())[song] in loaded else f'{song} never loaded'
    fanfares = songs(('PLAYER_ME',), 'SEQ_ME_')  # HeartGold's (Platinum's are SEQ_FANFA*, SEQ_BADGE...)
    for name, seq in fanfares if not problem else []:
        h.play(seq, FANFARE, FANFARE_FRAMES)
        if h.read('failures') != failures:
            problem = f'the fanfare {name}: ' + h.failed_since(failures)
            break
    if not problem:
        result = h.battle()
        problem = f'battle {result}' if result != 'ok' else h.failed_since(failures)
    h.part('johto', problem)
    print(f'johto: {len(fanfares)} fanfares; least memory left {h.read("minFree") // 1024} KB', flush=True)


def flags_part(h):
    """4. The songs a flag puts on a map: each one's map, come onto with its flag set, plays it."""
    variables = var_ids()
    problem = ''
    for header, flag, song in FLAG_SONGS:
        failures = h.start()
        h.mem.write_short(h.sym['gSovereignTestVar'], variables[flag])  # set as the warp goes
        h.mem.write_short(h.sym['gSovereignTestVar'] + 2, 1)
        arrived, _ = warp(h.d, h.sym, header_names().index(header), *walkable_tile(header), 0)
        loaded = {h.read_log(i) for i in range(LOG_ENTRIES)}
        if arrived != 'ok':
            problem = f'{header}: warp {arrived}'
        elif dict(songs())[song] not in loaded:
            problem = f'{header}: {song} never loaded'
        elif h.read('failures') != failures:
            problem = f'{header}: ' + h.failed_since(failures)
        if problem:
            break
    h.part('flags', problem)


def main():
    rom, state, out = sys.argv[1:4]
    only = sys.argv[sys.argv.index('--only') + 1] if '--only' in sys.argv else None
    os.makedirs(out, exist_ok=True)
    h = Harness(rom, state, out)
    parts = {'songs': lambda: songs_part(h, '--all' in sys.argv), 'battle': lambda: battle_part(h),
             'johto': lambda: johto_part(h), 'flags': lambda: flags_part(h)}
    for name, run in parts.items():
        if only in (None, name):
            run()
    count = len(parts) if only is None else 1
    print(f'{sum(r.endswith(": ok") for r in h.results)} of {count} parts ok')
    sys.exit(0 if len(h.results) == count and all(r.endswith(': ok') for r in h.results) else 1)


if __name__ == '__main__':
    main()
