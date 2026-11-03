#!/usr/bin/env python3
"""Check HeartGold's Rocket Hideout effects (src/overlay005/complete_legend_cutscene.c) in the test build, from the
bedroom state, on the hideout's B1F (MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B1F):

1. **The electric trap** (13, 16), **the poison trap** (12, 17) and **the rock trap** (15, 16): stepped onto from the
   tile beside, each goes off under the player (HeartGold's ScrCmd_708: its model and animations played to their end)
   before its battle (a Voltorb, a Koffing, a Geodude), and the field is free after.
2. **The alarm** (44, 5, in front of the first Persian statue): its red screen pulses twice (ScrCmd_709), and the scene
   after plays out.

Each part must run its effect to the end (gCompleteTestLegend: the effects ended, the last one's kind) and leave the
field free. Screenshots of each effect as it plays go to OUT_DIR. Results: a line per part.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_hideout_effects.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import SYMBOLS, header_names, play_out, symbols, warp  # noqa: E402

HIDEOUT = 'MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B1F'
FACING = {'UP': 1, 'DOWN': 0, 'LEFT': 3, 'RIGHT': 4}  # the test warp's facing: enum FaceDirection + 1, 0 for down
SHOT_FRAMES = (4, 24, 48)  # after the effect starts, as it plays
START = 1200  # frames for the effect to start after the step
LIMIT = 20000
# (part, the tile beside the trigger, the key that steps onto it, the effect's kind: 0x100 + the trap, 0x200 the alarm)
PARTS = [('the electric trap', (14, 16), 'LEFT', 0x100),
         ('the poison trap', (12, 18), 'UP', 0x101),
         ('the rock trap', (14, 16), 'RIGHT', 0x102),
         ('the alarm', (44, 6), 'UP', 0x200)]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestLegend',))
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory

    def legend():
        """(the effects ended, the last one's kind)"""
        return struct.unpack('<2H', bytes(mem.unsigned[sym['gCompleteTestLegend']:sym['gCompleteTestLegend'] + 4]))

    results = []
    for name, (x, z), key, kind in PARTS:
        d.load_state(state)
        d.run(30)
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        problem = ''
        arrived, _ = warp(d, sym, names.index(HIDEOUT), x, z, FACING[key])
        if arrived != 'ok':
            problem = f'warp {arrived}'
        if not problem:
            for i in range(5):
                mem.write_short(sym['gCompleteTestLegend'] + 2 * i, 0)
            mem.write_short(sym['gSovereignTestScripts'], 0)
            d.press(key, frames=8, after=0)
            stem = name.replace(' ', '_')
            for _ in range(START // 2):
                if legend()[1] == kind:
                    break
                d.run(2)
            ran = 0
            for frames in SHOT_FRAMES:
                d.run(frames - ran)
                ran = frames
                d.screenshot().save(os.path.join(out, f'{stem}_{frames:02d}.png'))
            result, frames = play_out(d, sym, LIMIT, names.index(HIDEOUT), press_a=False)
            d.screenshot().save(os.path.join(out, f'{stem}_end.png'))
            ended, last = legend()
            if result != 'ok':
                problem = f'{result} after {frames} frames (effects ended {ended}, last 0x{last:X})'
            elif last != kind:
                problem = f'the effect was 0x{last:X}, not 0x{kind:X}'
            elif ended < 1:
                problem = 'the effect never ended'
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
