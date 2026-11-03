#!/usr/bin/env python3
"""Check HeartGold's legendary cutscenes (src/overlay005/complete_legend_cutscene.c) in the test build, from the
bedroom state:

1. **The Bell Tower's roof:** the Kimono Girls shown and the dance's trigger set (VAR_HGSS_UNK_40FA 1), the player
   steps onto its tile: the Clear Bell rises and shimmers, the leaves blow, the camera pans up to the sky and Ho-Oh
   comes down. The scene must run to its end with the field free on the roof, its cutscene commands run (at least
   MIN_OPS of them, gCompleteTestLegend), nothing of it held after, and the camera back at its distance from before.
   On the way, HeartGold's cinematic of Ho-Oh flying in over the tower (src/applications/complete_legend_cinematic,
   gCompleteTestLegendCinematic) must play to its end, for at least MIN_CINEMATIC_FRAMES frames.
2. **The Whirl Islands' cave:** the same for the Tidal Bell, the waves and Lugia, whose cinematic must also trail
   (its motion blur on as Lugia cries).

Screenshots of each as it plays go to OUT_DIR. Results: a line per part.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_legend_cutscenes.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import SYMBOLS, header_names, play_out, symbols, var_ids, warp  # noqa: E402

NORTH = 1  # the test warp's facing: enum FaceDirection + 1
MIN_OPS = 20
SHOTS = 6  # screenshots as the scene plays, SHOT_FRAMES apart
MAX_SHOTS = 12
SHOT_FRAMES = 600
LIMIT = 20000
MIN_CINEMATIC_FRAMES = 200
CINEMATIC_SHOTS = (60, 160, 260)  # the cinematic's frames to screenshot
# (part, map, the tile below the trigger, the flags and vars set on the way in, its cinematic (enum
# CompleteLegendCinematic), and whether the cinematic trails)
PARTS = [('the Bell Tower\'s roof', 'MAP_HEADER_HGSS_BELL_TOWER_ROOF', (15, 21),
          [('VAR_HGSS_UNK_40FA', 1), ('FLAG_HGSS_UNK_10A', 1), ('FLAG_HGSS_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS', 0)],
          0, False),
         ('the Whirl Islands\' cave', 'MAP_HEADER_HGSS_WHIRL_ISLANDS_B3F_LUGIA_CAVE', (16, 37),
          [('VAR_HGSS_UNK_40FA', 1), ('FLAG_HGSS_UNK_10A', 1), ('FLAG_HGSS_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS', 0)],
          1, True)]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestLegend', 'gCompleteTestLegendCinematic'))
    variables = var_ids()
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory

    def legend():
        """(ops run, the last, a scene's camera held, the distance before, after)"""
        return struct.unpack('<5H', bytes(mem.unsigned[sym['gCompleteTestLegend']:sym['gCompleteTestLegend'] + 10]))

    def cinematic():
        """(0x100 + the cinematic once begun, its step, frames drawn, models loaded, the blur on, DISPCNT,
        MASTER_BRIGHT, ended)"""
        at = sym['gCompleteTestLegendCinematic']
        return struct.unpack('<8H', bytes(mem.unsigned[at:at + 16]))

    results = []
    for name, header, (x, z), setup, which, trails in PARTS:
        d.load_state(state)
        d.run(30)
        for i, (var, value) in enumerate(setup, 2):
            mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[var])
            mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)
        problem = ''
        arrived, _ = warp(d, sym, names.index(header), x, z, NORTH)
        if arrived != 'ok':
            problem = f'warp {arrived}'
        if not problem:
            for i in range(5):
                mem.write_short(sym['gCompleteTestLegend'] + 2 * i, 0)
            for i in range(8):
                mem.write_short(sym['gCompleteTestLegendCinematic'] + 2 * i, 0)
            d.press('UP', frames=16, after=10)
            stem = name.replace(' ', '_').replace('\'', '')
            shots, blurred, models = list(CINEMATIC_SHOTS), False, 0
            for shot in range(MAX_SHOTS):  # SHOTS, and more till the cinematic has ended
                if shot >= SHOTS and cinematic()[7]:
                    break
                for _ in range(SHOT_FRAMES // 60):
                    for _ in range(14):  # every 4 frames, for the cinematic's screenshots
                        d.run(4)
                        begun, _, drawn, loaded, blur, _, _, ended = cinematic()
                        if begun and not ended:
                            blurred, models = blurred or bool(blur), max(models, loaded)
                            if shots and drawn >= shots[0]:
                                d.screenshot().save(os.path.join(out, f'{stem}_cinematic_{shots.pop(0):03d}.png'))
                    d.press('A', frames=2, after=2)
                d.screenshot().save(os.path.join(out, f'{stem}_{shot}.png'))
            result, frames = play_out(d, sym, LIMIT, names.index(header), press_a=False)
            d.screenshot().save(os.path.join(out, f'{stem}_end.png'))
            ops, last, held, before, after = legend()
            if result != 'ok':
                problem = f'{result} after {frames} frames (op {last}, {ops} run)'
            elif ops < MIN_OPS:
                problem = f'only {ops} cutscene commands ran'
            elif held:
                problem = 'the scene\'s camera is still held'
            elif before != after:
                problem = f'the camera\'s distance was {before} and is {after}'
            else:
                begun, step, drawn, _, _, _, _, ended = cinematic()
                if begun != 0x100 + which:
                    problem = f'the cinematic never began ({begun:#x})'
                elif not ended:
                    problem = f'the cinematic didn\'t end (step {step}, {drawn} frames)'
                elif drawn < MIN_CINEMATIC_FRAMES:
                    problem = f'the cinematic ran {drawn} frames'
                elif not models:
                    problem = 'the cinematic loaded no models'
                elif trails and not blurred:
                    problem = 'the cinematic never trailed'
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
