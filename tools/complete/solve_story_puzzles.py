#!/usr/bin/env python3
"""Find the ways through four of Johto's puzzles that tools/complete/test_hgss_opening.py plays, from the game's own
data, so the test's steps can be found again if a map or a script changes:

- **Azalea Gym** (src/complete_gyms.c): four Spinarak carts ride between twelve stops along routes the two switches
  choose. A breadth-first search over (where the player stands, the stop each cart waits at, the switches) finds the
  fewest rides and switch flips from the gym's door to Bugsy, and back out from in front of him. A ride starts as the
  player steps onto its trigger, the tile south of a stop whose cart rides forward, or the stop's own tile; the walks
  between never cross another trigger (the gym's coord events, all armed).
- **Ilex Forest's Farfetch'd** (Sacred Gold has two): what each one does when talked to, or when the player steps on
  a twig, is a small state machine in the forest's script (scripts_hgss_0092.s): where it stands, the side the player
  talks from, and vars the twigs set. A small interpreter for the commands that script uses plays each talk and twig
  over the states, and a breadth-first search finds the way to catching both. Walks never cross an armed twig.
- **Mahogany Gym's rooms** (src/complete_gyms.c, HeartGold's ice blocks): the player slides over the ice and pushes
  the blocks, which slide until stopped and join whoever they hit. A breadth-first search over (where the player
  stands, where each block is and whether it can still be pushed) finds the fewest steps across each of the three
  rooms; the test walks to where each push starts (its walks never push a block) and takes the push's step.
- **Ice Path B1F's boulders** (src/complete_map_info.c, HeartGold's boulder holes): a boulder pushed onto its own hole
  falls through to B2F, where it stops a slide over the ice; the first one is enough to cross. A breadth-first search
  over (where the player stands, where the boulder is) finds the fewest steps and Strength's pushes to put it in its
  hole and go on to the ladder down; the player never steps onto a hole, which would drop them to B2F.

Prints each way as the steps the test takes. From the repo root:
    python3 tools/complete/solve_story_puzzles.py
"""
import collections
import json
import os
import re
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from check_object_tiles import Maps, walkable  # noqa: E402
from talk_to_objects import DECOMP  # noqa: E402
from test_hgss_opening import ICE, route  # noqa: E402

KEYS = ('UP', 'DOWN', 'LEFT', 'RIGHT')  # the facing for each of Platinum's directions, north, south, west and east
SIDES = ((0, 1), (0, -1), (1, 0), (-1, 0))  # where the player stands to face a tile that way
WALKS = {'North': (0, -1), 'South': (0, 1), 'West': (-1, 0), 'East': (1, 0)}

# Azalea Gym, from src/complete_gyms.c: the stops, the routes ([stop][switches]: the stop a cart goes to, or None),
# the stops whose carts ride backwards, the switches' tiles (bg events), the first carts and the gym's tiles
AZALEA_MATRIX = 'map_matrix_hgss_0105'
AZALEA_STOPS = [(3, 31), (9, 31), (15, 31), (3, 24), (9, 24), (15, 24), (3, 16), (9, 16), (15, 16), (3, 9), (9, 9),
                (15, 9)]
AZALEA_ROUTES = [[4] * 4, [5] * 4, [3] * 4, [2] * 4, [0] * 4, [1] * 4, [None, 9, None, 10], [9, 11, 10, 11], [None] * 4,
                 [7, 6, None, None], [None, None, 7, 6], [None, 7, None, 7]]
AZALEA_BACKWARDS = {3, 4, 5, 9, 10, 11}
AZALEA_SWITCHES = {0: [(4, 7), (11, 8), (11, 18)], 1: [(2, 18)]}
AZALEA_CARTS = (0, 1, 2, 7)
AZALEA_DOOR, AZALEA_BUGSY = (9, 36), (9, 6)

ILEX_MATRIX = 'map_matrix_hgss_0056'
ILEX_SCRIPT = 'res/field/scripts/scripts_hgss_0092.s'
ILEX_EVENTS = 'res/field/events/events_hgss_114.json'
ILEX_FARFETCHD = {'obj_D36R0101_tsure_poke_static_farfetchd': 'first',
                  'obj_D36R0101_tsure_poke_static_farfetchd_2': 'second'}
ILEX_AFTER_ROCKETS = '_0C95'  # the forest's map script, the part for after the Slowpoke Well
ILEX_ENTRANCE = (15, 79)
ILEX_FOUND = {'FLAG_HGSS_FOUND_FIRST_FARFETCHD', 'FLAG_HGSS_FOUND_SECOND_FARFETCHD'}
ILEX_RETURN = (15, 65)  # where a Farfetch'd's catch warps the player, to the apprentice


def azalea_gym(maps, start, carts, switches, goal):
    """The rides and switch flips from start to goal, as the test's steps."""
    triggers = [(x, z) if i in AZALEA_BACKWARDS else (x, z + 1) for i, (x, z) in enumerate(AZALEA_STOPS)]

    def arrival(stop):
        x, z = AZALEA_STOPS[stop]
        return (x, z - 1) if stop in AZALEA_BACKWARDS else (x, z + 2)

    def path(a, b):
        return route(maps, AZALEA_MATRIX, a, b, set(triggers) - {a, b})

    first = (start, carts, switches)
    came = {first: None}
    queue = collections.deque([first])
    while queue:
        state = queue.popleft()
        pos, carts, switches = state
        if path(pos, goal) is not None:
            steps = []
            while came[state]:
                state, step = came[state]
                steps.append(step)
            return steps[::-1] + [f"('to', {goal})"]
        moves = []
        for number, tiles in AZALEA_SWITCHES.items():
            for (x, z), (dx, dz), key in ((t, s, k) for t in tiles for s, k in zip(SIDES, KEYS)):
                tile = (x + dx, z + dz)
                t = maps.tile(AZALEA_MATRIX, *tile)
                if t is not None and walkable(t) and tile not in triggers and path(pos, tile) is not None:
                    moves.append(((tile, carts, switches ^ (1 << number)),
                                  f"('to', {tile}), '{key}', ('talk', [])  # switch {number}"))
                    break
        for cart, stop in enumerate(carts):
            to = AZALEA_ROUTES[stop][switches]
            keys = path(pos, triggers[stop]) if to is not None else None
            if not keys:
                continue
            x, z = triggers[stop]
            step = {'UP': (0, 1), 'DOWN': (0, -1), 'LEFT': (1, 0), 'RIGHT': (-1, 0)}[keys[-1]]
            moved = carts[:cart] + (to,) + carts[cart + 1:]
            moves.append(((arrival(to), moved, switches),
                          f"('to', {(x + step[0], z + step[1])}), '{keys[-1]}'  # stop {stop} to {to}"))
        for new, step in moves:
            if new not in came:
                came[new] = (state, step)
                queue.append(new)
    return None


class Script:
    """The commands of a translated HeartGold script that move its Farfetch'd, read as an interpreter for them."""

    def __init__(self, text):
        self.labels, self.code, self.entries = {}, [], []
        for line in text.split('\n'):
            line = line.split('@')[0].strip()
            if not line or line.startswith('#'):
                continue
            if line.startswith('ScriptEntry '):
                self.entries.append(line.split()[1])
            elif re.match(r'^[A-Za-z0-9_]+:$', line):
                self.labels[line[:-1]] = len(self.code)
            else:
                parts = line.replace(',', ' ').split()
                self.code.append((parts[0], parts[1:]))

    def movement(self, label):
        """How far a movement list walks its object."""
        at, dx, dz = self.labels[label], 0, 0
        while self.code[at][0] != 'EndMovement':
            command, args = self.code[at]
            walk = re.match(r'Walk(?:Fast|Normal)(North|South|West|East)$', command)
            if walk:
                n = int(args[0]) if args else 1
                dx, dz = dx + WALKS[walk.group(1)][0] * n, dz + WALKS[walk.group(1)][1] * n
            at += 1
        return dx, dz

    def run(self, label, state, facing):
        """Run from label with the player facing that way (0-3: north, south, west, east): the state after (vars,
        flags, the Farfetch'd's tiles) and whether it warped the player."""
        values, flags, tiles = dict(state[0]), set(state[1]), dict(state[2])
        at, result, calls, warped = self.labels[label], 0, [], False
        conditions = (lambda r: r < 0, lambda r: r == 0, lambda r: r > 0, lambda r: r <= 0, lambda r: r >= 0,
                      lambda r: r != 0)
        while True:
            command, a = self.code[at]
            at += 1
            if command == '.short' and a[0] == 'SCRCMD_UNUSED_06A':  # Platinum's object position command
                who, x, z = (self.code[at + i][1][0] for i in range(3))
                at += 3
                values[x], values[z] = tiles[ILEX_FARFETCHD[who]]
            elif command == 'CompareVar':
                result = (values.get(a[0], 0) > int(a[1])) - (values.get(a[0], 0) < int(a[1]))
            elif command in ('GoToIf', 'CallIf') and conditions[int(a[0])](result) \
                    or command in ('GoTo', 'Call') \
                    or command in ('GoToIfSet', 'CallIfSet') and a[0] in flags \
                    or command in ('GoToIfUnset', 'CallIfUnset') and a[0] not in flags:
                if command.startswith('Call'):
                    calls.append(at)
                at = self.labels[a[-1]]
            elif command == 'Return':
                at = calls.pop()
            elif command == 'SetVarFromValue':
                values[a[0]] = int(a[1])
            elif command == 'GetPlayerDir':
                values[a[0]] = facing
            elif command == 'ApplyMovement' and a[0] in ILEX_FARFETCHD:
                x, z = tiles[ILEX_FARFETCHD[a[0]]]
                dx, dz = self.movement(a[1])
                tiles[ILEX_FARFETCHD[a[0]]] = (x + dx, z + dz)
            elif command == 'SetFlag':
                flags.add(a[0])
            elif command == 'ClearFlag':
                flags.discard(a[0])
            elif command == 'Warp':
                warped = True
            elif command == 'End':
                return (frozenset(values.items()), frozenset(flags), frozenset(tiles.items())), warped


def ilex_forest(maps):
    """The talks and twigs that catch both Farfetch'd, as the test's steps."""
    script = Script(open(os.path.join(DECOMP, ILEX_SCRIPT), encoding='utf-8').read())
    events = json.load(open(os.path.join(DECOMP, ILEX_EVENTS), encoding='utf-8'))
    objects = {o['id']: o for o in events['object_events']}
    talks = {name: (script.entries[objects[who]['script'] - 1], objects[who]['hidden_flag'])
             for who, name in ILEX_FARFETCHD.items()}
    twigs = [(script.entries[c['script'] - 1], c['var'], c['value'],
              [(c['x'] + i, c['z'] + j) for i in range(c['width']) for j in range(c['length'])])
             for c in events['coord_events'] if 'FARFETCHD' in c['var']]
    people = {(o['x'], o['z']) for o in events['object_events'] if 'farfetchd' not in o['id']}
    # the vars as the Slowpoke Well's end leaves them, then the forest's map script
    state = (frozenset({'VAR_HGSS_FARFETCHD1_STICKS1': 1, 'VAR_HGSS_FARFETCHD1_STICKS2': 1,
                        'VAR_HGSS_FARFETCHD2_STICKS4': 1}.items()), frozenset(),
             frozenset((name, (objects[who]['x'], objects[who]['z'])) for who, name in ILEX_FARFETCHD.items()))
    state = script.run(ILEX_AFTER_ROCKETS, state, 0)[0]

    def path(state, a, b):
        values = dict(state[0])
        tiles = {dict(state[2])[name] for name, (_, hidden) in talks.items() if hidden not in state[1]}
        armed = {t for _, var, value, area in twigs if values.get(var, 0) == value for t in area}
        t = maps.tile(ILEX_MATRIX, *b)
        if t is None or not walkable(t) or b in tiles:
            return None
        return route(maps, ILEX_MATRIX, a, b, (armed | tiles | people) - {a, b})

    first = (state, ILEX_ENTRANCE)
    came = {first: None}
    queue = collections.deque([first])
    while queue:
        state, pos = queue.popleft()
        if ILEX_FOUND <= state[1]:
            steps, at = [], (state, pos)
            while came[at]:
                at, step = came[at]
                steps.append(step)
            return steps[::-1]
        moves = []
        for name, (entry, hidden) in talks.items():
            if hidden in state[1]:  # caught and gone
                continue
            x, z = dict(state[2])[name]
            for facing, (dx, dz) in enumerate(SIDES):
                if path(state, pos, (x + dx, z + dz)) is None:
                    continue
                after, warped = script.run(entry, state, facing)
                if warped:
                    after = script.run(ILEX_AFTER_ROCKETS, after, 0)[0]
                moves.append((after, ILEX_RETURN if warped else (x + dx, z + dz),
                              f"('to', {(x + dx, z + dz)}), '{KEYS[facing]}', ('talk', [])  # the {name}"))
        for entry, var, value, area in twigs:
            if dict(state[0]).get(var, 0) != value:
                continue
            tile = next((t for t in area if path(state, pos, t) is not None), None)
            if tile is not None:
                moves.append((script.run(entry, state, 0)[0], tile, f"('to', {tile})  # a twig"))
        for after, at, step in moves:
            if (after, at) not in came:
                came[(after, at)] = ((state, pos), step)
                queue.append((after, at))
    return None


def ice_room(maps, header, start, goal):
    """A way across one of Mahogany Gym's rooms (src/complete_gyms.c, HeartGold's ice blocks): the keys from start to
    goal, the fewest, with the player sliding over ice as the game does and pushing the blocks. A step onto ice slides
    on until something stops the player; one that stops at a block that faces down (one never joined) pushes it, and it
    slides on that way until a wall or the end of the ice stops it, or someone, who it joins (another block too: both
    face up from then on, and can't be pushed). The people stand where the map puts them; the warps but the goal are
    walls."""
    from talk_to_objects import event_maps
    matrix, people, blocks, warps = None, set(), [], set()
    for _, headers_of, cur, _ in event_maps():
        for name, m in headers_of:
            if name == header:
                matrix = m
                for o in cur['object_events']:
                    if o['graphics_id'] == 'OBJ_EVENT_GFX_ICE_ROCK':
                        blocks.append((o['x'], o['z']))
                    else:
                        people.add((o['x'], o['z']))
                warps = {(w['x'], w['z']) for w in cur['warp_events']} - {goal}

    def ice(p):
        t = maps.tile(matrix, *p)
        return t is not None and t & 0xff == ICE

    def floor(p):
        t = maps.tile(matrix, *p)
        return p == goal or t is not None and walkable(t) and p not in warps

    def push(blocks, at, d):
        """The blocks after the one at at is pushed d."""
        rest, p = {b: free for b, free in blocks if b != at}, at
        while True:
            n = (p[0] + d[0], p[1] + d[1])
            if n in rest or n in people:  # it joins whoever it slides into, a block too
                if n in rest:
                    rest[n] = False
                rest[p] = False
                return frozenset(rest.items())
            if not floor(n) or not ice(n):
                rest[p] = True
                return frozenset(rest.items())
            p = n

    first = (start, frozenset((b, True) for b in blocks))
    came, queue = {first: None}, collections.deque([first])
    while queue:
        state = queue.popleft()
        pos, blocks_now = state
        if pos == goal:
            break
        pushable = {b for b, free in blocks_now if free}
        objects = people | {b for b, _ in blocks_now}
        for key, d in zip(KEYS, ((0, -1), (0, 1), (-1, 0), (1, 0))):
            p, after = pos, blocks_now
            n = (p[0] + d[0], p[1] + d[1])
            if floor(n) and n not in objects:
                p = n
                while ice(p) and p != goal:  # on over the ice until something stops the player
                    n = (p[0] + d[0], p[1] + d[1])
                    if not floor(n) or n in objects:
                        break
                    p = n
            pushed = ice(p) and n in pushable  # stopped by a block that faces down: it slides on
            if pushed:
                after = push(blocks_now, n, d)
            nxt = (p, after)
            if nxt not in came:
                came[nxt] = (state, key if pushed else None)
                queue.append(nxt)
    else:
        return None
    # the test's steps: a walk to where each push starts, its key, and a walk to the goal (the test's walks never
    # push a block)
    steps, at = [('to', goal)], state
    while came[at]:
        at, key = came[at]
        if key:
            steps[:0] = [('to', at[0]), key]
    return steps


def boulder_hole(maps, header, start, boulder, hole, goal):
    """A way through Ice Path B1F (src/complete_map_info.c, HeartGold's boulder holes): Strength's pushes of the boulder
    on boulder into its hole, through which it falls to B2F, and the walk on to goal, the fewest steps and pushes. A
    push moves the boulder a tile the way the player faces, onto floor no one stands on, and leaves the player where
    they were; the player never steps onto a hole (they would fall through) or a warp but the goal. The other boulders
    and the people stand where the map puts them. The test's steps: the talk that starts Strength, facing the boulder
    for the first push, then a walk to where each push starts and the push."""
    from talk_to_objects import event_maps
    matrix, objects, warps, holes = None, set(), set(), set()
    for _, headers_of, cur, _ in event_maps():
        for name, m in headers_of:
            if name == header:
                matrix = m
                objects = {(o['x'], o['z']) for o in cur['object_events']} - {boulder}
                warps = {(w['x'], w['z']) for w in cur['warp_events']} - {goal}
                holes = {(c['x'], c['z']) for c in cur['coord_events']}

    def floor(p):
        t = maps.tile(matrix, *p)
        return p == goal or t is not None and walkable(t) and p not in warps and p not in objects

    first = (start, boulder)
    came, queue = {first: None}, collections.deque([first])
    while queue:
        state = queue.popleft()
        pos, rock = state
        if pos == goal and rock is None:
            break
        for key, d in zip(KEYS, ((0, -1), (0, 1), (-1, 0), (1, 0))):
            n = (pos[0] + d[0], pos[1] + d[1])
            if n == rock:
                beyond = (n[0] + d[0], n[1] + d[1])
                if not floor(beyond) or beyond == goal:
                    continue
                nxt, push = (pos, None if beyond == hole else beyond), key
            elif floor(n) and n not in holes:
                nxt, push = (n, rock), None
            else:
                continue
            if nxt not in came:
                came[nxt] = (state, push)
                queue.append(nxt)
    else:
        return None
    steps, at, last = [('to', goal)], state, None
    while came[at]:
        at, key = came[at]
        if key:
            steps[:0] = [('to', at[0]), ('push', key)]
            last = key
    return [steps[0], last, ('talk', [True])] + steps[1:]


def blackthorn_gym(maps, start, goal, floors=None):
    """A way across Blackthorn Gym (src/complete_gyms.c, HeartGold's blackthorn.c): its three floors over the lava
    move and turn as the player steps onto their buttons, and the player rides them; the lava is walkable only where a
    floor is. A move goes the floor's width that way if every tile its leading edge passes over is lava (no wall, no
    ground); otherwise it goes nowhere. A turn goes a quarter turn if the tiles around the floor and those its corners
    sweep are lava (the game's own tables say which tiles stop a turn part way, BlackthornGym_TurnExtent); otherwise
    it goes back. A breadth-first search over (where the player stands, where each floor is and how it is turned)
    finds the fewest steps from start to goal, with the floors where the gym starts them or where floors has them. The
    test walks to the tile before each button (its walks never step
    onto one, nor onto the lava, nor the pads that send the player back to the door) and takes the step onto it."""
    from talk_to_objects import event_maps
    from test_hgss_opening import BLACKTHORN_GYM, COLLISION, MAGMA, blackthorn_floor
    source = open(os.path.join(DECOMP, 'src', 'complete_gyms.c'), encoding='utf-8').read()
    extents = {name: [int(n) for n in re.findall(r'\d+', values)]
               for name, values in re.findall(r'sBlackthorn(\w+Extents_\w+)\[\] = \{([^}]*)\}', source)}
    floors = floors or tuple((int(x), int(z), int(r)) for _, x, _, z, _, r in re.findall(
        r'data->x\[(\d)\] = (\d+);\s+data->z\[(\d)\] = (\d+);\s+data->rotation\[(\d)\] = (\d+);', source))
    for _, headers_of, cur, _ in event_maps():
        for name, m in headers_of:
            if name == BLACKTHORN_GYM:
                matrix = m
                people = {(o['x'], o['z']) for o in cur['object_events']}
                pads = {(c['x'], c['z']) for c in cur['coord_events'] if c['var'] == 'VAR_HGSS_UNK_4111'}

    def clear(p):  # lava a floor can go over
        t = maps.tile(matrix, *p)
        return t is not None and not t & COLLISION and t & 0xff == MAGMA

    def act(state, i, button):
        """The floors after floor i's button is stepped on, and how far the player rides it."""
        x, z, r = state[i]
        tiles, width, height = blackthorn_floor(i, r, x, z)
        wide = 'Wide' if i != 1 else 'Long'
        if button == 'turn':
            sides = tiles['bottom wall'] + tiles['top wall'] + tiles['left wall'] + tiles['right wall'][:width - 1]
            stops = [(p, e) for p, e in zip(tiles['turn check'], extents['TurnExtents_' + wide])] \
                + [(p, e) for p, e in zip(tiles['edge'], extents['EdgeExtents_' + wide])]
            if all(clear(p) for p in sides) and all(clear(p) or e >= 64 for p, e in stops):
                return state[:i] + ((x, z, (r + 1) % 4),) + state[i + 1:], (0, 0)
            return state, (0, 0)
        d = [(1, 0), (0, 1), (-1, 0), (0, -1)][((0 if button == 'move right' else 2) + r) % 4]
        lead = tiles['right wall' if button == 'move right' else 'left wall']
        if all(clear((p[0] + k * d[0], p[1] + k * d[1])) for k in range(width) for p in lead):
            return state[:i] + ((x + width * d[0], z + width * d[1], r),) + state[i + 1:], (width * d[0], width * d[1])
        return state, (0, 0)

    def layout(state):
        """The floors' walkable tiles, and their buttons: {tile: (floor, button)}."""
        walk, buttons = set(), {}
        for i, (x, z, r) in enumerate(state):
            tiles, _, _ = blackthorn_floor(i, r, x, z)
            walk |= set(tiles['floor'])
            for button in ('turn', 'move right', 'move left'):
                buttons[tiles[button][0]] = (i, button)
        return walk, buttons

    first = (start, floors)
    came, queue = {first: None}, collections.deque([first])
    while queue:
        state = queue.popleft()
        pos, now = state
        if pos == goal:
            break
        walk, buttons = layout(now)
        for key, d in zip(KEYS, ((0, -1), (0, 1), (-1, 0), (1, 0))):
            n = (pos[0] + d[0], pos[1] + d[1])
            t = maps.tile(matrix, *n)
            if n in buttons:
                after, (dx, dz) = act(now, *buttons[n])
                nxt, pressed = ((n[0] + dx, n[1] + dz), after), key
            elif t is not None and walkable(t) and (t & 0xff != MAGMA or n in walk) and n not in people | pads:
                nxt, pressed = (n, now), None
            else:
                continue
            if nxt not in came:
                came[nxt] = (state, pressed)
                queue.append(nxt)
    else:
        return None
    steps, at = [('to', goal)], state
    while came[at]:
        at, key = came[at]
        if key:
            steps[:0] = [('to', at[0]), key]
    blackthorn_gym.floors = state[1]  # where the floors end up
    return steps


def main():
    maps = Maps(DECOMP)
    for name, steps in [('Azalea Gym, to Bugsy', azalea_gym(maps, AZALEA_DOOR, AZALEA_CARTS, 0, AZALEA_BUGSY)),
                        ('Azalea Gym, back out', azalea_gym(maps, (9, 8), (4, 1, 2, 10), 3, AZALEA_DOOR)),
                        ('Ilex Forest\'s Farfetch\'d', ilex_forest(maps)),
                        ('Mahogany Gym, the first room', ice_room(maps, 'MAP_HEADER_HGSS_MAHOGANY_GYM_ROOM_1', (4, 18),
                                                                  (3, 2))),
                        ('Mahogany Gym, the second room', ice_room(maps, 'MAP_HEADER_HGSS_MAHOGANY_GYM_ROOM_2', (6, 14),
                                                                   (6, 2))),
                        ('Mahogany Gym, to Pryce', ice_room(maps, 'MAP_HEADER_HGSS_MAHOGANY_GYM_LEADER_ROOM', (5, 18),
                                                            (7, 5))),
                        ('Blackthorn Gym, to Clair', blackthorn_gym(maps, (13, 86), (12, 4))),
                        ('Ice Path B1F, the first boulder', boulder_hole(maps, 'MAP_HEADER_HGSS_ICE_PATH_B1F', (6, 21),
                                                                         (10, 13), (11, 10), (25, 8)))]:
        print(f'{name}:')
        for step in steps or ['no way found']:
            print(f'    {step}')


if __name__ == '__main__':
    main()
