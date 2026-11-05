#!/usr/bin/env python3
"""Screenshots for the progress page's gallery: dozens of each town, route and place in all three regions, and battle
shots of every gym leader, Elite Four member and champion (test build).

Places are the map headers grouped by their location name (mapLabelTextID), as the page groups them. In each one the
test warp takes the player to walkable tiles spread over its maps (check_object_tiles.py's tiles): on outdoor maps
and caves the middle of each quarter of each 32x32 block, indoors the middle of the room, and the top screen is kept
once the field has settled, at 1 p.m. (gSovereignTestClock). A warp that starts a scene still gets its shot (scenes
are worth seeing); the bedroom state is loaded again after any that doesn't come back to the field.

For a boss, the player is warped into their gym or room first, so the battle has its background, and the test
build's trainer battle (gSovereignTestBattleTrainer, SELECT+R, god mode) is played through, both screens kept every
few seconds (different frames only).

Out: .cache/gallery/shots/<place key>/NN.jpg and .cache/gallery/battles/<boss>/NN.jpg, with index.json in each
folder (the map, tile and label of each shot).

Usage: TEST_BUILD=build_test2 python3 tools/complete/gallery_shots.py ROM STATE [--worker K/N] [--battles] [PLACE ...]
"""
import json
import os
import re
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.join(HERE, '..', '..')
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from PIL import Image, ImageChops  # noqa: E402

from check_object_tiles import Maps, walkable  # noqa: E402
from drive import Driver  # noqa: E402
from talk_to_objects import SYMBOLS, event_maps, header_names, symbols, var_ids, warp  # noqa: E402

DECOMP = os.path.join(ROOT, 'decomp')
OUT = os.path.join(ROOT, '.cache', 'gallery')
# Where a boss's battle starts when the middle of their gym won't do: Ecruteak Gym's dark floor drops the player, so
# Morty's starts on his platform, before him
BOSS_SPOTS = {'Morty': (10, 9)}
# A var a boss's room needs first (gSovereignTestVar, set by the warp): Ecruteak Gym stays shut until the Burned
# Tower's scene (VAR_HGSS_UNK_4079 2), its sage walking the player back out
BOSS_VARS = {'Morty': ('VAR_HGSS_UNK_4079', 2)}
MAX_SHOTS = 30  # a place's shots at most
INDOOR_SHOTS = 14  # of them, from its buildings at most
SETTLE = 50  # frames after a warp before the shot
HOUR = 13
SKIP_LABELS = {'MysteryZone', 'FightArea', None}
OUTDOOR = ('MAP_TYPE_OUTDOORS', 'MAP_TYPE_TOWN_CITY')
# each boss: its trainer and the map their battle is in
BOSSES = [
    ('Falkner', 'TRAINER_HGSS_LEADER_FALKNER_FALKNER', 'MAP_HEADER_HGSS_VIOLET_GYM'),
    ('Bugsy', 'TRAINER_HGSS_LEADER_BUGSY_BUGSY', 'MAP_HEADER_HGSS_AZALEA_GYM'),
    ('Whitney', 'TRAINER_HGSS_LEADER_WHITNEY', 'MAP_HEADER_HGSS_GOLDENROD_GYM'),
    ('Morty', 'TRAINER_HGSS_LEADER_MORTY_MORTY', 'MAP_HEADER_HGSS_ECRUTEAK_GYM'),
    ('Chuck', 'TRAINER_HGSS_LEADER_CHUCK_CHUCK', 'MAP_HEADER_HGSS_CIANWOOD_GYM'),
    ('Jasmine', 'TRAINER_HGSS_LEADER_JASMINE_JASMINE', 'MAP_HEADER_HGSS_OLIVINE_GYM'),
    ('Pryce', 'TRAINER_HGSS_LEADER_PRYCE_PRYCE', 'MAP_HEADER_HGSS_MAHOGANY_GYM_LEADER_ROOM'),
    ('Clair', 'TRAINER_HGSS_LEADER_CLAIR_CLAIR', 'MAP_HEADER_HGSS_BLACKTHORN_GYM'),
    ('Will', 'TRAINER_HGSS_ELITE_FOUR_WILL_WILL', 'MAP_HEADER_HGSS_POKEMON_LEAGUE_WILL_ROOM'),
    ('Koga', 'TRAINER_HGSS_ELITE_FOUR_KOGA_KOGA', 'MAP_HEADER_HGSS_POKEMON_LEAGUE_KOGA_ROOM'),
    ('Bruno', 'TRAINER_HGSS_ELITE_FOUR_BRUNO_BRUNO', 'MAP_HEADER_HGSS_POKEMON_LEAGUE_BRUNO_ROOM'),
    ('Karen', 'TRAINER_HGSS_ELITE_FOUR_KAREN_KAREN', 'MAP_HEADER_HGSS_POKEMON_LEAGUE_KAREN_ROOM'),
    ('Lance', 'TRAINER_HGSS_CHAMPION_LANCE', 'MAP_HEADER_HGSS_POKEMON_LEAGUE_LANCE_ROOM'),
    ('Brock', 'TRAINER_HGSS_LEADER_BROCK_BROCK', 'MAP_HEADER_HGSS_PEWTER_GYM'),
    ('Misty', 'TRAINER_HGSS_LEADER_MISTY_MISTY', 'MAP_HEADER_HGSS_CERULEAN_GYM'),
    ('Lt. Surge', 'TRAINER_HGSS_LEADER_LT_SURGE_LT__SURGE', 'MAP_HEADER_HGSS_VERMILION_GYM'),
    ('Erika', 'TRAINER_HGSS_LEADER_ERIKA_ERIKA', 'MAP_HEADER_HGSS_CELADON_GYM'),
    ('Janine', 'TRAINER_HGSS_LEADER_JANINE_JANINE', 'MAP_HEADER_HGSS_FUCHSIA_GYM'),
    ('Sabrina', 'TRAINER_HGSS_LEADER_SABRINA_SABRINA', 'MAP_HEADER_HGSS_SAFFRON_GYM'),
    ('Blaine', 'TRAINER_HGSS_LEADER_BLAINE_BLAINE', 'MAP_HEADER_HGSS_SEAFOAM_ISLANDS_CINNABAR_GYM'),
    ('Blue', 'TRAINER_HGSS_LEADER_BLUE_BLUE', 'MAP_HEADER_HGSS_VIRIDIAN_GYM'),
    ('Red', 'TRAINER_HGSS_PKMN_TRAINER_RED_RED', 'MAP_HEADER_HGSS_MOUNT_SILVER_CAVE_SUMMIT'),
    ('Roark', 'TRAINER_LEADER_ROARK', 'MAP_HEADER_OREBURGH_CITY_GYM'),
    ('Gardenia', 'TRAINER_LEADER_GARDENIA', 'MAP_HEADER_ETERNA_CITY_GYM'),
    ('Maylene', 'TRAINER_LEADER_MAYLENE', 'MAP_HEADER_VEILSTONE_CITY_GYM'),
    ('Crasher Wake', 'TRAINER_LEADER_WAKE', 'MAP_HEADER_PASTORIA_CITY_GYM'),
    ('Fantina', 'TRAINER_LEADER_FANTINA', 'MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM'),
    ('Byron', 'TRAINER_LEADER_BYRON', 'MAP_HEADER_CANALAVE_CITY_GYM'),
    ('Candice', 'TRAINER_LEADER_CANDICE', 'MAP_HEADER_SNOWPOINT_CITY_GYM'),
    ('Volkner', 'TRAINER_LEADER_VOLKNER', 'MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3'),
    ('Aaron', 'TRAINER_ELITE_FOUR_AARON', 'MAP_HEADER_POKEMON_LEAGUE_AARON_ROOM'),
    ('Bertha', 'TRAINER_ELITE_FOUR_BERTHA', 'MAP_HEADER_POKEMON_LEAGUE_BERTHA_ROOM'),
    ('Flint', 'TRAINER_ELITE_FOUR_FLINT', 'MAP_HEADER_POKEMON_LEAGUE_FLINT_ROOM'),
    ('Lucian', 'TRAINER_ELITE_FOUR_LUCIAN', 'MAP_HEADER_POKEMON_LEAGUE_LUCIAN_ROOM'),
    ('Cynthia', 'TRAINER_CHAMPION_CYNTHIA', 'MAP_HEADER_POKEMON_LEAGUE_CHAMPION_ROOM'),
]


def map_headers():
    """{header: (label, map type)}"""
    src = open(os.path.join(DECOMP, 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    out = {}
    for name, block in re.findall(r'\[(MAP_HEADER_\w+)\] = \{(.*?)\n    \},', src, re.S):
        fields = dict(re.findall(r'\.(\w+) = (\w+)', block))
        label = fields.get('mapLabelTextID', '').replace('LocationNames_Text_', '') or None
        out[name] = (label, fields.get('mapType'))
    return out


def place_key(header, label):
    return ('sinnoh' if not header.startswith('MAP_HEADER_HGSS_') else 'hgss') + '_' + (label or 'none')


def spots_of(maps, header, matrix, grid_json, indoor, events=None):
    """Walkable tiles spread over the header's blocks: each quarter's middle outdoors and in caves, the room's middle
    indoors (the middle of its doors, people and signs, as the space around a room has no collision either; the
    nearest walkable tile to each)."""
    grid = grid_json['maps']
    owners = grid_json.get('headers') or []
    blocks = [(r, c) for r, row in enumerate(grid) for c, m in enumerate(row) if m != 'MAP_NONE'
              and (not owners or (r < len(owners) and c < len(owners[r]) and owners[r][c] == header))]
    centres = []
    for r, c in blocks:
        if indoor:  # a room sits in a corner of its block, and the space around it has no collision either
            points = [(e['x'], e['z']) for kind in ('object_events', 'warp_events', 'bg_events')
                      for e in (events or {}).get(kind, []) if 'x' in e and 'z' in e
                      and c * 32 <= e['x'] < c * 32 + 32 and r * 32 <= e['z'] < r * 32 + 32]
            if points:
                xs, zs = sorted(x for x, _ in points), sorted(z for _, z in points)
                centres.append(((xs[0] + xs[-1]) // 2, (zs[0] + zs[-1]) // 2))
        else:
            centres += [(c * 32 + 8 + 16 * i, r * 32 + 8 + 16 * j) for j in (0, 1) for i in (0, 1)]
    spots = []
    for cx, cz in centres:
        best = None
        for radius in range(0, 9):
            for dx in range(-radius, radius + 1):
                for dz in (-radius, radius) if abs(dx) != radius else range(-radius, radius + 1):
                    t = maps.tile(matrix, cx + dx, cz + dz)
                    if walkable(t) and (t & 0xff) == 0:  # plain ground: not water, a door, a ledge or grass
                        best = (cx + dx, cz + dz)
                        break
                if best:
                    break
            if best:
                break
        if best and best not in spots:
            spots.append(best)
    return spots


def plan(only):
    """[(place key, label, [(header, x, z)])] for every place, its shots in order: outdoor and cave maps first."""
    info = map_headers()
    maps = Maps(DECOMP)
    places = {}
    for _, headers_of, events, grid_json in event_maps():
        for header, matrix in headers_of:
            label, kind = info.get(header, (None, None))
            if label in SKIP_LABELS or 'UNUSED' in header or header == 'MAP_HEADER_EVERYWHERE':
                continue
            key = place_key(header, label)
            if only and key not in only and label not in only:
                continue
            gj = json.load(open(os.path.join(DECOMP, 'res', 'field', 'matrices', matrix + '.json')))
            indoor = kind not in OUTDOOR and kind != 'MAP_TYPE_CAVE'
            spots = spots_of(maps, header, matrix, gj, indoor, events)
            places.setdefault(key, {'label': label, 'out': [], 'in': []})['in' if indoor else 'out'].append(
                (header, spots))
    out = []
    for key, p in sorted(places.items()):
        shots = []
        # outdoor and cave maps: round robin over the maps, so a place with several shows each
        pools = [[(h, x, z) for x, z in spots] for h, spots in p['out']]
        while pools and len(shots) < MAX_SHOTS - min(INDOOR_SHOTS, len(p['in'])):
            for pool in pools:
                if pool:
                    shots.append(pool.pop(0))
            pools = [pool for pool in pools if pool]
        rooms = sorted(p['in'], key=lambda hs: (0 if 'GYM' in hs[0] else 1 if 'POKECENTER_1F' in hs[0] else 2))
        for header, spots in rooms:
            if spots and len(shots) < MAX_SHOTS:
                shots.append((header, *spots[0]))
        if shots:
            out.append((key, p['label'], shots))
    return out


def blank(im):
    return max(im.convert('L').getextrema()) < 24


def shoot_places(d, sym, state, places, names):
    for key, label, shots in places:
        folder = os.path.join(OUT, 'shots', key)
        index_path = os.path.join(folder, 'index.json')
        if os.path.exists(index_path):
            continue  # done in an earlier run
        os.makedirs(folder, exist_ok=True)
        index = []
        for n, (header, x, z) in enumerate(shots):
            d.emu.memory.write_byte(sym['gSovereignTestClock'], HOUR + 1)
            result = warp(d, sym, names.index(header), x, z, 0)
            d.run(SETTLE)
            im = d.screenshot().crop((0, 0, 256, 192))
            if not blank(im):
                path = os.path.join(folder, f'{len(index):02d}.jpg')
                im.convert('RGB').save(path, quality=88)
                index.append({'file': os.path.basename(path), 'header': header, 'x': x, 'z': z,
                              'result': result[0]})
            if result[0] != 'ok':
                d.load_state(state)
                d.run(30)
        json.dump({'label': label, 'shots': index}, open(index_path, 'w'), indent=1)
        print(f'{key}: {len(index)} of {len(shots)} shots', flush=True)


def shoot_battles(d, sym, state, names):
    trainers = [line.strip() for line in open(os.path.join(DECOMP, 'generated', 'trainers.txt')) if line.strip()]
    maps = Maps(DECOMP)
    matrices = {h: (m, g, ev) for _, headers_of, ev, g in event_maps() for h, m in headers_of}
    for boss, trainer, header in BOSSES:
        folder = os.path.join(OUT, 'battles', re.sub(r'\W+', '_', boss).strip('_').lower())
        index_path = os.path.join(folder, 'index.json')
        if os.path.exists(index_path):
            continue
        os.makedirs(folder, exist_ok=True)
        d.load_state(state)
        d.run(30)
        index = []
        spot = BOSS_SPOTS.get(boss)
        if spot is None and header in matrices:
            matrix, gj, ev = matrices[header]
            spots = spots_of(maps, header, matrix, gj, True, ev)
            spot = spots[0] if spots else None
        if boss in BOSS_VARS:
            var, value = BOSS_VARS[boss]
            d.emu.memory.write_short(sym['gSovereignTestVar'], var_ids()[var])
            d.emu.memory.write_short(sym['gSovereignTestVar'] + 2, value)
        for _ in range(2):  # again if a script took the player out
            if spot is None:
                break
            warp(d, sym, names.index(header), *spot, 0)
            d.run(SETTLE)
            at = sym['gSovereignTestIdleMapHeaderID']
            if struct.unpack('<H', bytes(d.emu.memory.unsigned[at:at + 2]))[0] == names.index(header):
                break
        d.emu.memory.write_short(sym['gSovereignTestBattleTrainer'], trainers.index(trainer))
        d.emu.memory.write_byte(sym['gSovereignTestGodMode'], 1)
        d.press('SELECT+R')
        last, idle = None, 0
        for frame in range(0, 9000, 30):
            before = struct.unpack('<I', bytes(d.emu.memory.unsigned[sym['gSovereignTestIdleFrames']:
                                                                     sym['gSovereignTestIdleFrames'] + 4]))[0]
            if frame % 90 == 60:
                d.press('A', frames=4, after=0)
            d.run(26)
            if frame % 120 == 0 and frame >= 120:
                im = d.screenshot()
                if not blank(im.crop((0, 0, 256, 192))) and (
                        last is None or ImageChops.difference(im.convert('L'), last.convert('L')).getbbox()):
                    diff = 1.0 if last is None else sum(ImageChops.difference(im.convert('L'), last.convert(
                        'L')).point(lambda v: v > 24 and 255).histogram()[255:]) / (256 * 384)
                    if diff > 0.04:
                        path = os.path.join(folder, f'{len(index):02d}.jpg')
                        im.convert('RGB').save(path, quality=88)
                        index.append({'file': os.path.basename(path), 'frame': frame})
                        last = im
            after = struct.unpack('<I', bytes(d.emu.memory.unsigned[sym['gSovereignTestIdleFrames']:
                                                                    sym['gSovereignTestIdleFrames'] + 4]))[0]
            idle = idle + 1 if after != before else 0
            if frame > 600 and idle > 6:  # the field runs again: the battle is over
                break
        json.dump({'boss': boss, 'trainer': trainer, 'map': header, 'shots': index}, open(index_path, 'w'), indent=1)
        print(f'{boss}: {len(index)} shots', flush=True)


def main():
    args = sys.argv[1:]
    worker = None
    if '--worker' in args:
        i = args.index('--worker')
        worker = tuple(map(int, args[i + 1].split('/')))
        del args[i:i + 2]
    battles = '--battles' in args
    if battles:
        args.remove('--battles')
    rom, state = args[:2]
    only = set(args[2:])
    sym = symbols(SYMBOLS + ('gSovereignTestClock', 'gSovereignTestBattleTrainer', 'gSovereignTestGodMode'))
    names = header_names()
    d = Driver(rom, state)
    d.run(30)
    if battles:
        shoot_battles(d, sym, state, names)
        return
    places = plan(only)
    if worker:
        places = places[worker[0]::worker[1]]
    print(f'{len(places)} places, {sum(len(s) for _, _, s in places)} shots planned', flush=True)
    shoot_places(d, sym, state, places, names)


if __name__ == '__main__':
    main()
