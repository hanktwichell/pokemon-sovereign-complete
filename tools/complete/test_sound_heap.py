#!/usr/bin/env python3
"""Check that every song fits in sound memory, in the test build (docs/Music.md; src/complete_test.c's
gCompleteTestSound, which notes each load into the sound heap):

1. **Songs:** on a map (the bedroom state's), each song of the archive's music players, played as the game plays it
   (a field song as a map's song, a cutscene's in its sound scene, any other as a script's PlayMusic): none of its
   loads fails, and it leaves some memory free. The songs that leave the least are listed.
2. **Battle:** a trainer battle (SELECT+R, the test build's own trainer) and the map's song after it: no load fails.
3. **Johto:** New Bark Town's own song (HeartGold's) loads as the player arrives, and a trainer battle there plays
   HeartGold's trainer theme: no load fails.

Results: one line per part, 'ok' or what went wrong; with --all, a line per song (its sequence, the bytes free after
it loads).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_sound_heap.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [--all]
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import TEST_BUILD, fight  # noqa: E402
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS as TALK_SYMBOLS, header_names, warp  # noqa: E402

SOUND = {'free': 0, 'minFree': 4, 'failures': 8, 'lastFailedID': 12, 'loads': 14, 'playSeq': 16, 'playScene': 18,
         'log': 20}  # CompleteTestSound
LOG_ENTRIES, LOG_SIZE = 8, 8  # COMPLETE_TEST_SOUND_LOG; CompleteTestSoundLoad
SCENE_SONGS = {'SEQ_BLD_ENDING_sseq': 14}  # songs only a cutscene plays, in its sound scene (enum SoundScene)
JOHTO = ('MAP_HEADER_HGSS_NEW_BARK', 695, 397, 'SEQ_GS_T_WAKABA_sseq')  # a tile outside the player's house
PARTS = 3
MUSIC_PLAYERS = ('PLAYER_BGM', 'PLAYER_FIELD')
SETTLE = 90  # frames for a song's loads (the next free field frame, then the load)
BATTLE_FRAMES = 40000
LEAST = 8  # the songs leaving the least memory, listed


def songs():
    """[(name, sequence ID)] of the archive's music, from the build's archive (the split's, docs/Music.md)."""
    data = json.load(open(os.path.join(DECOMP, 'res', 'sound', 'complete', 'pl_sound_data.json'), encoding='utf-8'))
    naix = open(os.path.join(DECOMP, TEST_BUILD, 'res', 'sound', 'pl_sound_data.naix')).read()
    ids = {int(n): name for name, n in re.findall(r'#define (SEQ_\w+) (\d+)', naix)}
    out = [(ids[i], i) for i, s in enumerate(data['seqInfo'])
           if s.get('name') and s.get('player') in MUSIC_PLAYERS and i in ids]
    return sorted(out, key=lambda song: song[0] in SCENE_SONGS)  # the cutscenes' last: they leave the field


def main():
    from drive import Driver
    rom, state, out = sys.argv[1:4]
    show_all = '--all' in sys.argv
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(tuple(set(TALK_SYMBOLS) | {'gCompleteTestSound', 'gSovereignTestGodMode',
                                                  'gSovereignTestBattleTrainer'}))
    d = Driver(rom, state)
    mem = d.emu.memory
    base = sym['gCompleteTestSound']
    results = []

    def read(field, size=4):
        at = base + SOUND[field]
        return int.from_bytes(bytes(mem.unsigned[at:at + size]), 'little')

    def read_log(i):  # a logged load's file
        at = base + SOUND['log'] + i * LOG_SIZE
        return int.from_bytes(bytes(mem.unsigned[at:at + 2]), 'little')

    def part(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
        if problem:
            d.screenshot().save(os.path.join(out, f'{name}.png'))

    # 1. Songs
    d.load_state(state)
    d.run(60)
    failed, left = [], []
    for name, seq in songs():
        failures = read('failures')
        mem.write_long(base + SOUND['minFree'], 0xFFFFFFFF)
        mem.write_short(base + SOUND['playScene'], SCENE_SONGS.get(name, 0))
        mem.write_short(base + SOUND['playSeq'], seq)
        d.run(SETTLE)
        if read('playSeq', 2):
            failed.append(f'{name} never played')
            continue
        if read('failures') != failures:
            failed.append(f'{name} (file {read("lastFailedID", 2)})')
        left.append((read('minFree'), name))
        if show_all:
            print(f'{name} {read("minFree")}', flush=True)
    left.sort()
    part('songs', f'{len(failed)} of {len(left)} failed to load: {", ".join(failed[:10])}' if failed else '')
    print('least memory left: ' + ', '.join(f'{n} {free // 1024} KB' for free, n in left[:LEAST]), flush=True)

    # 2. Battle, and the map's song after it
    d.load_state(state)
    d.run(60)
    failures = read('failures')
    mem.write_long(base + SOUND['minFree'], 0xFFFFFFFF)
    mem.write_byte(sym['gSovereignTestGodMode'], 1)
    d.press('SELECT+R')
    result, _ = fight(d, sym, BATTLE_FRAMES)
    d.run(SETTLE)
    part('battle', f'{result}' if result != 'ok' else f'{read("failures") - failures} loads failed (file '
         f'{read("lastFailedID", 2)})' if read('failures') != failures else '')
    print(f'battle: least memory left {read("minFree") // 1024} KB', flush=True)

    # 3. Johto: New Bark Town's song as the player arrives, and a battle there
    d.load_state(state)
    d.run(60)
    failures = read('failures')
    mem.write_long(base + SOUND['minFree'], 0xFFFFFFFF)
    header, x, z, song = JOHTO
    arrived, _ = warp(d, sym, header_names().index(header), x, z, 0)
    loaded = {read_log(i) for i in range(LOG_ENTRIES)}
    song_id = dict(songs())[song]
    problem = f'warp {arrived}' if arrived != 'ok' else '' if song_id in loaded else f'{song} never loaded'
    if not problem:
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        d.press('SELECT+R')
        result, _ = fight(d, sym, BATTLE_FRAMES)
        d.run(SETTLE)
        problem = f'battle {result}' if result != 'ok' else ''
    if not problem and read('failures') != failures:
        problem = f'{read("failures") - failures} loads failed (file {read("lastFailedID", 2)})'
    part('johto', problem)
    print(f'johto: least memory left {read("minFree") // 1024} KB', flush=True)

    print(f'{sum(r.endswith(": ok") for r in results)} of {PARTS} parts ok')
    sys.exit(0 if all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
