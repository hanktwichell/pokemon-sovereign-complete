#!/usr/bin/env python3
"""Check HeartGold's field effects from its demo/legend archive (src/overlay005/complete_legend_cutscene.c) in the test
build, from the bedroom state. On the Rocket Hideout's B1F (MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B1F):

1. **The electric trap** (13, 16), **the poison trap** (12, 17) and **the rock trap** (15, 16): stepped onto from the
   tile beside, each goes off under the player (HeartGold's ScrCmd_708: its model and animations played to their end)
   before its battle (a Voltorb, a Koffing, a Geodude), and the field is free after.
2. **The alarm** (44, 5, in front of the first Persian statue): its red screen pulses twice (ScrCmd_709), and the scene
   after plays out.

And the monks' wings (ShowLegendaryWing), each shining at the player's feet while the map's script 3 runs:

3. **The Rainbow Wing** on the Bell Tower's 1F: with FLAG_HGSS_UNK_093 set, the player steps onto the trigger before
   the stairs (8, 12), the monk shows the wing, and its scene after has him step aside (VAR_HGSS_UNK_40F3 1).
4. **The Silver Wing** on the Whirl Islands' B2F: with FLAG_HGSS_UNK_094 set, the player talks to the monk (36, 30).
5. **Lance's flight** at the Lake of Rage (ScrCmd_775): the player, on the water below him, talks to Lance and agrees
   to help: Fly's cut-in shows HeartGold's Lance and his Dragonite, the bird comes down for him, and his and the
   Dragonite's objects go (gCompleteTestLegend[2]: both hidden), the player's staying.

And the Ruins of Alph's four chambers (OpenAlphHiddenRoom):

6. **The walls' words:** in each chamber the player reads the north wall (6, 2) from the tile below: the stone tablet
   shows its word in the Unown's letters (ESCAPE, LIGHT, WATER, HO OH) until A is pressed.

Each part must start its effect, run it to the end (gCompleteTestLegend: the effects ended, the last one's kind) and
leave the field free. Screenshots of each effect as it plays go to OUT_DIR. Results: a line per part.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_field_effects.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import SYMBOLS, header_names, play_out, symbols, var_ids, warp  # noqa: E402

HIDEOUT = 'MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B1F'
BELL_TOWER = 'MAP_HEADER_HGSS_BELL_TOWER_1F'
WHIRL_ISLANDS = 'MAP_HEADER_HGSS_WHIRL_ISLANDS_B2F'
LAKE_OF_RAGE = 'MAP_HEADER_HGSS_LAKE_OF_RAGE'
ALPH = 'MAP_HEADER_HGSS_RUINS_OF_ALPH_{}_ENTRANCE_FIRST_ROOM'  # HeartGold's D24R0202 to D24R0208
ALPH_WALL = 0x600  # the walls' kind: 0x600 + the word
LANCE_FLIGHT, LANCE_RIDERS_HIDDEN = 0x400, 3  # gCompleteTestLegend[2]: a bit for each of Lance's and the Dragonite's
FACING = {'UP': 1, 'DOWN': 0, 'LEFT': 3, 'RIGHT': 4}  # the test warp's facing: enum FaceDirection + 1, 0 for down
SHOT_FRAMES = tuple(int(f) for f in os.environ['SHOTS'].split(',')) if os.environ.get('SHOTS') else (4, 24, 48, 120, 200)
START = 4000  # frames for the effect to start after the step (Lance talks a while first)
LIMIT = 20000
# (part, the map, the tile beside the trigger, the key that steps onto it (A: talks), the effect's kind: 0x100 + the
# trap, 0x200 the alarm, 0x300 + the wing, 0x400 Lance's flight, 0x600 + a wall's word, the flags and vars set on the
# way in)
PARTS = [('the electric trap', HIDEOUT, (14, 16), 'LEFT', 0x100, []),
         ('the poison trap', HIDEOUT, (12, 18), 'UP', 0x101, []),
         ('the rock trap', HIDEOUT, (14, 16), 'RIGHT', 0x102, []),
         ('the alarm', HIDEOUT, (44, 6), 'UP', 0x200, []),
         ('the Rainbow Wing', BELL_TOWER, (8, 13), 'UP', 0x300, [('FLAG_HGSS_UNK_093', 1)]),
         ('the Silver Wing', WHIRL_ISLANDS, (36, 31), 'A', 0x301, [('FLAG_HGSS_UNK_094', 1)]),
         ("Lance's flight", LAKE_OF_RAGE, (528, 84), 'A', 0x400, [('FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE', 0)])] + \
    [(f'the {word} wall', ALPH.format(chamber), (6, 3), 'A', ALPH_WALL + i, [])
     for i, (word, chamber) in enumerate([('ESCAPE', 'NORTHEAST'), ('LIGHT', 'SOUTHEAST'), ('WATER', 'SOUTHWEST'),
                                          ('HO OH', 'NORTHWEST')])]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gCompleteTestLegend',))
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory

    def legend():
        """(the effects ended, the last one's kind)"""
        return struct.unpack('<2H', bytes(mem.unsigned[sym['gCompleteTestLegend']:sym['gCompleteTestLegend'] + 4]))

    def riders_hidden():
        return struct.unpack('<H', bytes(mem.unsigned[sym['gCompleteTestLegend'] + 4:sym['gCompleteTestLegend'] + 6]))[0]

    results = []
    for name, header, (x, z), key, kind, setup in PARTS:
        if os.environ.get('ONLY') and os.environ['ONLY'] not in name:
            continue
        d.load_state(state)
        d.run(30)
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        for i, (var, value) in enumerate(setup, 2):
            mem.write_short(sym['gSovereignTestVar'] + 4 * i, variables[var])
            mem.write_short(sym['gSovereignTestVar'] + 4 * i + 2, value)
        problem = ''
        arrived, _ = warp(d, sym, names.index(header), x, z, FACING.get(key, 1))
        if arrived != 'ok':
            problem = f'warp {arrived}'
        if not problem:
            for i in range(5):
                mem.write_short(sym['gCompleteTestLegend'] + 2 * i, 0)
            mem.write_short(sym['gSovereignTestScripts'], 0)
            d.press(key, frames=8, after=0)
            stem = name.replace(' ', '_')
            started = False
            for i in range(START // 2):  # with A now and then through the lines before it (the monks')
                if legend()[1] == kind:
                    started = True
                    break
                if i % 10 == 9:
                    d.press('A', frames=4, after=0)  # long enough for a yes/no menu (Lance's)
                d.run(2)
            ran = 0
            for frames in SHOT_FRAMES:
                d.run(frames - ran)
                ran = frames
                d.screenshot().save(os.path.join(out, f'{stem}_{frames:02d}.png'))
            if kind & 0xFF00 == ALPH_WALL and started:  # the tablet stays till A
                if legend()[0]:
                    problem = 'the tablet closed before A was pressed'
                d.press('A', frames=4, after=10)
            result, frames = play_out(d, sym, LIMIT, names.index(header), press_a=False)
            d.screenshot().save(os.path.join(out, f'{stem}_end.png'))
            ended, last = legend()
            if problem:
                pass
            elif not started:
                problem = f'the effect didn\'t start within {START} frames'
            elif result == 'NOSCRIPT' and ended >= 1:
                pass  # the scene was over as the screenshots were taken (Lance's), the field free on the map
            elif result != 'ok':
                problem = f'{result} after {frames} frames (effects ended {ended}, last 0x{last:X})'
            elif last != kind:
                problem = f'the effect was 0x{last:X}, not 0x{kind:X}'
            elif ended < 1:
                problem = 'the effect never ended'
            elif kind == LANCE_FLIGHT and riders_hidden() != LANCE_RIDERS_HIDDEN:
                problem = f'the bird didn\'t take Lance and the Dragonite (hidden {riders_hidden():#x})'
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
