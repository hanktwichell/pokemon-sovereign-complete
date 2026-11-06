#!/usr/bin/env python3
"""Check Sacred Gold's event at the Sinjoh Ruins' Mystri Stage, with HeartGold's Unown circle
(src/overlay005/complete_legend_cutscene.c, CompleteUnownCircle) and Arceus's cinematic
(src/applications/complete_legend_cinematic, CompleteLegendCinematic 2), in the test build, from the bedroom state.

With Sacred Gold's flags for the event set on the way in (gSovereignTestVar), the 16 plates in the bag and every
species caught in the National Pokédex (both written into the save), the player steps onto the stage's middle
(16, 12): the scene's lines and the alarm play, its question is answered yes, then

1. **The circle:** the Unown's circle spins up and ends (gCompleteTestLegend: begun, then one more effect ended);
2. **The cinematic:** Arceus's cinematic plays its script to its end (gCompleteTestLegendCinematic), for at least
   MIN_FRAMES frames;
3. **Back on the field:** the scene goes on there, the player hurrying south five steps to (16, 17).

Results: a line per part, and screenshots of the circle and of the cinematic as it plays in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_sinjoh.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import DECOMP, SYMBOLS, header_names, symbols, var_ids, warp  # noqa: E402

STAGE = 'MAP_HEADER_HGSS_SINJOH_RUINS_MYSTRI_STAGE'
BELOW_MIDDLE = (16, 13)  # the stage's middle (16, 12) is its trigger (scr_seq_D51R0201_014)
AFTER = (16, 17)  # where the scene walks the player after the cinematic
NORTH = 1  # the test warp's facing: enum FaceDirection + 1
FLAGS = ['FLAG_HGSS_SG_3FCE', 'FLAG_HGSS_SG_3FCD', 'FLAG_HGSS_SG_3FCC', 'FLAG_HGSS_SG_3FC6', 'FLAG_HGSS_SG_3FC5',
         'FLAG_HGSS_SG_3FC4', 'FLAG_HGSS_SG_3FC3', 'FLAG_HGSS_SG_3FC8', 'FLAG_HGSS_SG_3FB0', 'FLAG_HGSS_SG_3FAE',
         'FLAG_HGSS_SG_3F8C', 'FLAG_CAUGHT_DARKRAI', 'FLAG_HGSS_SG_3FBE']  # Sovereign's Darkrai
PLATES = ['FLAME', 'SPLASH', 'ZAP', 'MEADOW', 'ICICLE', 'FIST', 'TOXIC', 'EARTH', 'SKY', 'MIND', 'INSECT', 'STONE',
          'SPOOKY', 'DRACO', 'DREAD', 'IRON']
UNOWN_CIRCLE = 0x500  # gCompleteTestLegend[1] as it begins
ARCEUS_CINEMATIC = 0x102  # gCompleteTestLegendCinematic[0] as it begins
MIN_FRAMES = 1200  # the script's waits alone are 1260 frames
CIRCLE_LIMIT = 6000
CIRCLE_SHOT = 150  # frames into the circle for its screenshot
CINEMATIC_LIMIT = 10000  # emulated frames: the app steps about once every two
AFTER_LIMIT = 3000
SHOTS = (60, 300, 600, 900, 1200, 1500, 1800, 2100, 2350)  # the cinematic's frames to screenshot
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestLegend', 'gCompleteTestLegendCinematic', 'sSaveDataPtr'))
    variables = var_ids()
    names = header_names()
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    species = open(os.path.join(DECOMP, 'generated', 'species.txt')).read().split()
    dex_words = (species.index('SPECIES_BAD_EGG') - 2 - 1) // 32 + 1  # include/pokedex.h's DEX_SIZE_U32
    d = Driver(rom, state)
    mem = d.emu.memory

    def u32(at):
        return struct.unpack('<I', bytes(mem.unsigned[at:at + 4]))[0]

    def save_block(entry):
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index(entry) * 16 + 8
        return base + 20 + u32(at)

    def legend():
        return struct.unpack('<5H', bytes(mem.unsigned[sym['gCompleteTestLegend']:sym['gCompleteTestLegend'] + 10]))

    def cinematic():
        """(0x100 + the cinematic once begun, its step, frames drawn, models, blur, DISPCNT, MASTER_BRIGHT, ended)"""
        at = sym['gCompleteTestLegendCinematic']
        return struct.unpack('<8H', bytes(mem.unsigned[at:at + 16]))

    results = []

    def report(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    d.load_state(state)
    d.run(30)
    for i, flag in enumerate(FLAGS, 2):
        mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[flag])
        mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, 1)
    result, _ = warp(d, sym, names.index(STAGE), BELOW_MIDDLE[0], BELOW_MIDDLE[1], NORTH)
    if result != 'ok':
        report('the circle', f'warp {result}')
        sys.exit(1)

    # The plates in the bag's first slots (its Items pocket, include/bag.h) and the National Pokédex caught and seen
    # (include/pokedex.h: magic, then caughtPokemon and seenPokemon)
    bag = save_block('SAVE_TABLE_ENTRY_BAG')
    for i, plate in enumerate(PLATES):
        mem.write_long(bag + 4 * i, items.index(f'ITEM_{plate}_PLATE') | 1 << 16)
    dex = save_block('SAVE_TABLE_ENTRY_POKEDEX')
    for i in range(2 * dex_words):
        mem.write_long(dex + 4 + 4 * i, 0xFFFFFFFF)
    for i in range(5):
        mem.write_short(sym['gCompleteTestLegend'] + 2 * i, 0)
    for i in range(8):
        mem.write_short(sym['gCompleteTestLegendCinematic'] + 2 * i, 0)

    # Onto the middle, then A through the lines, the yes (the first answer) included, till the circle begins
    d.press('UP', frames=16, after=10)
    frames, problem = 0, ''
    while legend()[1] != UNOWN_CIRCLE and frames < CIRCLE_LIMIT:
        d.press('A', frames=4, after=26)
        frames += 30
    if legend()[1] != UNOWN_CIRCLE:
        problem = f'the circle never began ({frames} frames, at {d.pos()})'
        d.screenshot().save(os.path.join(out, 'no_circle.png'))
    else:
        ended, began, shot = legend()[0], frames, False
        while not cinematic()[0] and frames < 2 * CIRCLE_LIMIT:
            d.run(10)
            frames += 10
            if not shot and frames - began >= CIRCLE_SHOT:  # the light rising in the circle
                d.screenshot().save(os.path.join(out, 'circle.png'))
                shot = True
        if legend()[0] <= ended:
            problem = 'the circle never ended'
    report('the circle', problem)
    if problem:
        sys.exit(1)

    shots, frames, problem = list(SHOTS), 0, ''
    while not cinematic()[7] and frames < CINEMATIC_LIMIT:
        d.run(4)
        frames += 4
        begun, _, drawn, *_ = cinematic()
        if shots and drawn >= shots[0]:
            d.screenshot().save(os.path.join(out, f'cinematic_{shots.pop(0):04d}.png'))
    begun, step, drawn, _, _, dispcnt, bright, ended = cinematic()
    if begun != ARCEUS_CINEMATIC:
        problem = f'Arceus\'s cinematic never began ({begun:#x})'
    elif not ended:
        problem = f'it didn\'t end (step {step}, {drawn} frames)'
    elif drawn < MIN_FRAMES:
        problem = f'it ran {drawn} frames'
    report('the cinematic', problem)
    if problem:
        sys.exit(1)

    frames = 0
    while d.pos() != AFTER and frames < AFTER_LIMIT:
        d.run(10)
        frames += 10
    d.screenshot().save(os.path.join(out, 'after.png'))
    report('back on the field', '' if d.pos() == AFTER else f'the player is at {d.pos()}, not {AFTER}')

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
