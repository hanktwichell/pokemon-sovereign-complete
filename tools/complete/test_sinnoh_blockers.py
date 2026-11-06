#!/usr/bin/env python3
"""The people where Sinnoh's HMs held the player back (tools/complete/sinnoh_blockers.py, src/complete_blockers.c), in
the test build, from the bedroom state.

For each group: warped beside one of them, facing them, before what lifts the group, the player can't step onto their
tile, and talking to them plays their words; then, with what lifts it set (a flag or a var through gSovereignTestVar,
a badge through gSovereignTestBadges) and the map loaded again, the player steps onto that tile.

Results: a line per check, a screenshot of each group before and after in OUT_DIR, and the count of problems.
    TEST_BUILD=build_test3 SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_sinnoh_blockers.py \\
        decomp/build_test3/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from talk_to_objects import SYMBOLS, header_names, play_out, symbols, var_ids, warp  # noqa: E402

NORTH, SOUTH, WEST, EAST = 1, 2, 3, 4  # the test warp's facing: enum FaceDirection + 1
KEYS = {NORTH: 'UP', SOUTH: 'DOWN', WEST: 'LEFT', EAST: 'RIGHT'}
STEP = {NORTH: (0, -1), SOUTH: (0, 1), WEST: (-1, 0), EAST: (1, 0)}
BADGES = ['COAL', 'FOREST', 'COBBLE', 'FEN', 'RELIC', 'MINE', 'ICICLE', 'BEACON']
# (group, map, the tile beside one of them, facing them, what lifts it: ('flag'|'var', name, value) or ('badge', name))
CASES = [
    ('Spear Pillar\'s climb', 'MAP_HEADER_MT_CORONET_1F_SOUTH', (25, 5), NORTH,
     ('flag', 'FLAG_FREED_GALACTIC_HQ_POKEMON', 1)),
    ('Lake Acuity', 'MAP_HEADER_ACUITY_LAKEFRONT', (308, 231), NORTH, ('badge', 'ICICLE')),
    ('Eterna Forest from Route 205', 'MAP_HEADER_ROUTE_205_SOUTH', (206, 583), NORTH,
     ('var', 'VAR_VALLEY_WINDWORKS_STATE', 2)),
    ('the Ravaged Path\'s rocks', 'MAP_HEADER_RAVAGED_PATH', (20, 43), EAST, ('badge', 'COAL')),
    ('Mt. Coronet\'s boulder to Celestic', 'MAP_HEADER_MT_CORONET_1F_NORTH_ROOM_1', (16, 39), EAST,
     ('flag', 'FLAG_USED_SECRETPOTION', 1)),
    ('the Pal Park lobby (Route 221\'s workers)', 'MAP_HEADER_ROUTE_221', (306, 913), NORTH, ('badge', 'FEN')),
]
LIMIT = 3000


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('gSovereignTestBadges',))
    ids = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    d.added, d.armed = [], False
    mem = d.emu.memory
    problems = []

    def check(what, ok):
        print(f'{what}: {"ok" if ok else "WRONG"}', flush=True)
        if not ok:
            problems.append(what)

    def arrive(header, tile, face, lift=None):
        d.load_state(state)
        d.run(30)
        if lift and lift[0] == 'badge':
            mem.write_byte(sym['gSovereignTestBadges'], 1 << BADGES.index(lift[1]))
        elif lift:
            mem.write_short(sym['gSovereignTestVar'], variables[lift[1]])
            mem.write_short(sym['gSovereignTestVar'] + 2, lift[2])
        result, _ = warp(d, sym, ids.index(header), *tile, 0)
        if result == 'ok':  # again on the same map, which turns the player to face
            result, _ = warp(d, sym, ids.index(header), *tile, face)
        return result

    def step(face):
        mem.write_short(sym['gSovereignTestScripts'], 0)
        d.press(KEYS[face], frames=16, after=30)
        return d.pos()

    for name, header, tile, face, lift in CASES:
        slug = ''.join(c if c.isalnum() else '_' for c in name.lower()).strip('_')
        target = (tile[0] + STEP[face][0], tile[1] + STEP[face][1])
        result = arrive(header, tile, face)
        check(f'{name}: arrived beside them at {tile} ({result})', result == 'ok')
        if result != 'ok':
            continue
        d.screenshot().save(os.path.join(out, f'{slug}_before.png'))
        check(f'{name}: before, the player can\'t step onto {target} (at {d.pos()})', step(face) == tile)
        talked, frames = play_out(d, sym, LIMIT)
        check(f'{name}: talking to them plays their words ({talked} {frames})', talked == 'ok')
        result = arrive(header, tile, face, lift)
        check(f'{name}: with {lift[1]}, arrived again ({result})', result == 'ok')
        if result != 'ok':
            continue
        moved = step(face)
        d.screenshot().save(os.path.join(out, f'{slug}_after.png'))
        dx, dz = STEP[face]  # onto the tile or past it (a held key may take the player a tile further)
        past = (moved[0] - target[0]) * dx >= 0 and (moved[1] - target[1]) * dz >= 0 and moved != tile
        check(f'{name}: after, the player steps onto {target} or past it (at {moved})', past)

    print(f'{len(problems)} problems')
    sys.exit(1 if problems else 0)


if __name__ == '__main__':
    main()
