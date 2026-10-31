#!/usr/bin/env python3
"""Play the opening in the test build from a new game's own start, the player's room in New Bark Town (src/location.c),
as a player would, without the test warp:

1. **Downstairs:** from the bedroom state, the player walks to the stairs and goes down; Mom's scene plays (HeartGold's
   first scene, VAR_HGSS_SCENE_PLAYERS_HOUSE_1F from 0) and ends with the field free on the house's 1F.
2. **Outside:** the player walks out of the front door into New Bark Town.
3. **Elm's greeting:** the player walks into Elm's lab and up to the step-on trigger a few rows in: Elm calls the
   player over and asks them to fetch Mr. Pokémon's find, taking one of his Pokémon along
   (FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE is set).
4. **The starter:** the player walks to the table of Poké Balls and reads it: Platinum's starter scene with Elm's three,
   the Pokémon given, a nickname turned down and Elm's lines, as tools/complete/test_hgss_starter.py plays it from the
   test warp (talk_and_answer); VAR_HGSS_SCENE_ELMS_LAB goes from 0 to 1.
5. **Leaving the lab:** on the way out the aide gives the Potions, and the player comes out into New Bark Town.
6. **The Pokégear:** the player goes home and talks to Mom, who gives the Pokégear (Sacred Gold's Mom gives it once
   the player has a Pokémon: FLAG_HGSS_GOT_POKEGEAR), and comes out again. Without it, the woman at the west exit
   sends the player back to ask Mom.
7. **Cherrygrove City:** the player walks west out of New Bark Town, where Elm runs out of his lab to give his phone
   number (VAR_HGSS_SCENE_NEW_BARK_WEST_EXIT from 0), then along Route 29 to Cherrygrove City, where the guide gent
   shows the player around (VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW from 0).
8. **Route 30:** the player walks north up Route 30 to Mr. Pokémon's door, where Sacred Gold's Eevee gift stands in
   the way: talked to, she gives the Eevee (no nickname) and leaves, and the player goes in, where Mr. Pokémon's scene
   plays: his Mystery Egg, and Professor Oak's Pokédex (FLAG_HGSS_GOT_POKEDEX).
9. **The rival:** the player walks back south to Cherrygrove City's east entrance, where the rival steps out and
   battles (VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW 4 after it).
10. **Back to Elm:** the player walks east along Route 29 to Elm's lab, where Elm and the police officer talk about
    the stolen Pokémon (VAR_HGSS_SCENE_ELMS_LAB 4 after it).

The walks between places find their own way over the maps' walkable tiles (ledges one way, around the people), and
take it a step at a time, finding it again whenever a scene or a person moves the player. A prompt on the way (the
test save's Super Repel wearing off), each scene's text and a battle are paged through with A, which also answers
yes. A part passes when the field is free on the map it expects, its flag is set or its var has moved on from 0 (or to
a given value), and
the following Pokémon (the test party's lead) is beside the player: at most two steps away, as a scene can leave it
diagonally (gCompleteTestFollowerTile; after the starter's scene it was left by Elm's table before
src/complete_follower.c brought it back).
Results: one line per part; a screenshot and a save state of each part's end in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default); FROM, a part's name, starts there from the save state an earlier
run left in OUT_DIR:
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_opening.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [FROM]
"""
import collections
import os
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from check_object_tiles import DIRS, JUMPS, Maps, walkable  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, WATER, event_maps, header_names, symbols, var_ids  # noqa: E402
from test_hgss_togepi import SAVE_PAGES, SAVE_SECTOR, save_entry_index  # noqa: E402

LAB = 'MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_1F'
NEW_BARK = 'MAP_HEADER_HGSS_NEW_BARK'
# (part, its actions, the map it ends on, the var that must have moved on from 0 or the flag that must be set, (var,
# value) for a var that must have that value, or None). An action is a key to press, ('to', (x, z)): a walk to that tile on the map the player is on, or ('talk',
# answers): A to talk to what the player faces, answering its menus (talk_and_answer's). The stairs and doors warp as
# the player presses toward them from their tile.
PARTS = [('downstairs', ['LEFT'] * 3 + ['UP'] * 2 + ['LEFT'], 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_1F',
          'VAR_HGSS_SCENE_PLAYERS_HOUSE_1F'),
         ('outside', ['DOWN'] * 8, NEW_BARK, None),
         ('Elm\'s greeting', ['LEFT'] * 11 + ['UP'] * 8, LAB, 'FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE'),
         ('the starter', ['RIGHT'] * 4 + ['UP'] * 2 + [('talk', [False])], LAB, 'VAR_HGSS_SCENE_ELMS_LAB'),
         ('leaving the lab', [('to', (4, 14)), 'DOWN'], NEW_BARK, None),
         ('the Pokégear', [('to', (695, 397)), 'UP', ('to', (6, 8)), 'UP', ('talk', [True]), ('to', (3, 10)), 'DOWN'],
          NEW_BARK, 'FLAG_HGSS_GOT_POKEGEAR'),
         ('Cherrygrove City', [('to', (675, 399)), ('to', (567, 398)), 'LEFT'], 'MAP_HEADER_HGSS_CHERRYGROVE',
          'VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW'),
         ('Route 30', [('to', (568, 296)), ('talk', [False]), 'UP', 'UP'], 'MAP_HEADER_HGSS_ROUTE_30_MR_POKEMON_HOUSE',
          'FLAG_HGSS_GOT_POKEDEX'),
         ('the rival', [('to', (4, 9)), 'DOWN', ('to', (576, 399)), 'LEFT'], 'MAP_HEADER_HGSS_CHERRYGROVE',
          ('VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW', 4)),
         ('back to Elm', [('to', (684, 394)), 'UP'], LAB, ('VAR_HGSS_SCENE_ELMS_LAB', 4))]
KEYS = {(1, 0): 'RIGHT', (-1, 0): 'LEFT', (0, 1): 'DOWN', (0, -1): 'UP'}
LIMIT = 9000
IDLE_RUN = 60  # frames to watch for a free field: it updates at 30 Hz, so a free second adds about 30
SHORT_RUN = 20  # a first, short look, so A isn't pressed into a field that is already free
SETTLE_FRAMES = 30000  # the longest a scene may take (Mr. Pokémon's and Oak's, at the test save's text speed)
WALK_STEPS = 600  # the most steps one walk takes
MARGIN = 40  # tiles around the start and the goal a route may go through


def route(maps, matrix, start, goal, blocked):
    """The keys from start to goal over walkable land (a ledge one way), around the blocked tiles, or None."""
    x0, x1 = min(start[0], goal[0]) - MARGIN, max(start[0], goal[0]) + MARGIN
    z0, z1 = min(start[1], goal[1]) - MARGIN, max(start[1], goal[1]) + MARGIN
    came = {start: None}
    queue = collections.deque([start])
    while queue and goal not in came:
        p = queue.popleft()
        for d in DIRS:
            n = (p[0] + d[0], p[1] + d[1])
            t = maps.tile(matrix, *n)
            if t is not None and (t & 0xff) in JUMPS:
                jd, k = JUMPS[t & 0xff]
                if jd != d:
                    continue
                n = (n[0] + jd[0] * k, n[1] + jd[1] * k)
                t = maps.tile(matrix, *n)
            if t is None or n in came or not (x0 <= n[0] <= x1 and z0 <= n[1] <= z1):
                continue
            if n != goal and (n in blocked or not walkable(t) or (t & 0xff) in WATER):
                continue
            came[n] = (p, d)
            queue.append(n)
    if goal not in came:
        return None
    keys, p = [], goal
    while came[p]:
        p, d = came[p]
        keys.append(KEYS[d])
    return keys[::-1]


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    start = sys.argv[4] if len(sys.argv) > 4 else None
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gSovereignTestMenu', 'gCompleteTestFollowerTile'))
    names = header_names()
    variables = var_ids()
    maps = Maps(DECOMP)
    matrix_of, people_of = {}, collections.defaultdict(set)
    for _, headers_of, cur, _ in event_maps():
        for header, matrix in headers_of:
            matrix_of[header] = matrix
            people_of[matrix] |= {(o['x'], o['z']) for o in cur.get('object_events', [])}
    first = [p[0] for p in PARTS].index(start) if start else 0
    if first:
        state = os.path.join(out, PARTS[first - 1][0].replace(' ', '_') + '.state')
    d = Driver(rom, state)
    mem = d.emu.memory

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def vars_flags():
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS') * 16 + 8
        return base + 20 + u32(at)

    def moved_on(name):
        """A flag is set, or a var isn't 0, or (var, value) has that value (VarsFlags: the vars, then the flags'
        bits)."""
        if isinstance(name, tuple):
            return u16(vars_flags() + (variables[name[0]] - variables['VARS_START']) * 2) == name[1]
        if name.startswith('VAR_'):
            return u16(vars_flags() + (variables[name] - variables['VARS_START']) * 2) != 0
        n = variables[name]
        flags = vars_flags() + (variables['VARS_END'] - variables['VARS_START']) * 2
        return bool(mem.unsigned[flags + n // 8] & (1 << (n % 8)))

    def here():
        n = u16(sym['gSovereignTestIdleMapHeaderID'])
        return names[n] if n < len(names) else n

    def free(frames):
        """Whether the field runs free for most of the next frames (it updates at 30 Hz)."""
        before = u32(sym['gSovereignTestIdleFrames'])
        d.run(frames)
        return u32(sym['gSovereignTestIdleFrames']) - before >= frames // 3

    def settle():
        """A through whatever runs (a prompt, a scene's text, a battle) until the field is free. A is pressed only
        while the field isn't free, so it never talks to whoever the player faces once a scene is over. False if the
        field never comes free."""
        frames = 0
        while frames < SETTLE_FRAMES:
            frames += SHORT_RUN
            if free(SHORT_RUN):
                frames += IDLE_RUN
                if free(IDLE_RUN):
                    return True
                continue  # something started meanwhile: look again before pressing anything
            d.press('A', frames=2, after=8)
            frames += 10
        return False

    def walk_to(goal):
        """Walk to goal on the map the player is on, a step at a time, finding the way again after each; a tile the
        player can't step onto twice (a person in the way) is walked around. Returns a problem, or ''."""
        matrix = matrix_of[here()]
        blocked = set(people_of[matrix])
        stuck = 0
        for _ in range(WALK_STEPS):
            if not free(SHORT_RUN) and not settle():  # a short look while nothing happens, so a step costs little
                return f'the field never came free on the way to {goal}, on {here()} at {d.pos()}'
            if matrix_of.get(here()) != matrix:
                return f'left for {here()} on the way to {goal}'
            pos = d.pos()
            if pos == goal:
                return ''
            keys = route(maps, matrix, pos, goal, blocked - {pos})
            if not keys:
                return f'no way from {pos} to {goal} on {here()}'
            d.press(keys[0], frames=8, after=16)
            if d.pos() != pos:
                stuck = 0
                continue
            stuck += 1
            if stuck >= 2:
                step = next(dd for dd, k in KEYS.items() if k == keys[0])
                blocked.add((pos[0] + step[0], pos[1] + step[1]))
                stuck = 0
        return f'still not at {goal} after {WALK_STEPS} steps, on {here()} at {d.pos()}'

    results = []
    d.run(30)
    for name, actions, end_map, marker in PARTS[first:]:
        problem = ''
        for action in actions:
            if not settle():
                problem = f'the field never came free before {action}, on {here()} at {d.pos()}'
            elif isinstance(action, str):
                d.press(action, frames=8, after=16)
            elif action[0] == 'to':
                problem = walk_to(action[1])
            else:
                result, frames = talk_and_answer(d, sym, action[1], LIMIT)
                if result != 'ok':
                    problem = f'the talk: {result} after {frames} frames, on {here()} at {d.pos()}'
            print(f'  {action}: {here()} {d.pos()}', flush=True)
            if problem:
                break
        if not problem and not settle():
            problem = f'the field never came free at the end, on {here()} at {d.pos()}'
        if not problem and here() != end_map:
            problem = f'ended on {here()} at {d.pos()}, not {end_map}'
        if not problem and marker and not moved_on(marker):
            problem = f'{marker} isn\'t so' if isinstance(marker, tuple) else \
                f'{marker} is still {"0" if marker.startswith("VAR_") else "clear"}'
        follower = struct.unpack('<HH', bytes(mem.unsigned[sym['gCompleteTestFollowerTile']:
                                                           sym['gCompleteTestFollowerTile'] + 4]))
        player = d.pos()
        if not problem and follower != (0xFFFF, 0xFFFF) \
                and abs(follower[0] - player[0]) + abs(follower[1] - player[1]) > 2:
            problem = f'the follower is on {follower}, away from the player on {player}'
        d.screenshot().save(os.path.join(out, f'{name.replace(" ", "_")}.png'))
        d.emu.savestate.save_file(os.path.join(out, f'{name.replace(" ", "_")}.state'))  # to start a later part from
        results.append(f'{name}: {problem or "ok"}')
        print(results[-1], flush=True)
        if problem:
            break
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(PARTS) - first} parts ok')
    sys.exit(0 if len(results) == len(PARTS) - first and all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
