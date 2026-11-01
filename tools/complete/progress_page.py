#!/usr/bin/env python3
"""Write the progress page (tools/complete/progress_page.html filled in), published as a claude.ai artifact.

The page's tabs: the whole game (the roadmap's steps and where each stands, what's next, what waits on the owner),
since yesterday (the latest entries of docs/Progress.md, summarized here), maps and routes (every Johto and Kanto map,
grouped into places by its location label: its people, trainers, items, wild Pokémon, and the story test's parts that
walk through it, with the overworld drawn block by block), and the story test (its parts, and how far a run from the
bedroom has got).

What it reads: decomp/include/data/map_headers.h (each map's location label, scripts, wild Pokémon and music), the maps'
events (tools/test/talk_to_objects.py's event_maps), the overworld matrix (map_matrix_hgss_0000), the story test's
parts (tools/complete/test_hgss_opening.py's PARTS) and its logs in .cache (a part's maps are the ones its lines name,
counted only for a part that passed). The status of the roadmap's steps, the next steps, the open decisions and the
summary of recent work are kept below by hand (STEPS, NEXT, WAITING, RECENT): update them with docs/Progress.md.

Usage: python3 tools/complete/progress_page.py [OUT]   (default .cache/progress/index.html)
"""
import collections
import datetime
import glob
import json
import os
import re
import sys

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'test'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'complete'))
from talk_to_objects import event_maps  # noqa: E402
import test_hgss_opening  # noqa: E402

UPDATED = 'Nov 1, 2026'

# The roadmap's steps (docs/Roadmap.md) and where each stands: status is one of done, mostly, active, waiting, ready,
# later
STEPS = [
    (0, 'Before starting', 'waiting', 'Waiting on you',
     'Sovereign Platinum\'s release and the open decisions below. Sacred Gold\'s patches are in the repo.'),
    (1, 'Groundwork', 'done', 'Done',
     'The project builds and boots with the bigger save (2,250 more story markers), and the conversion tools work.'),
    (2, 'Maps', 'done', 'Done',
     'All 540 Johto and Kanto maps are in, with collision, connections, props and animations; every one loads in the '
     'visit-every-map test.'),
    (3, 'Events and scripts', 'done', 'Done',
     'HeartGold\'s and Sacred Gold\'s scripts are translated; the talk test ran all 5,865 people and signs to their end, '
     'and the step-on triggers pass.'),
    (4, 'Sacred Gold\'s content', 'done', 'Done',
     '737 trainers, wild Pokémon by time of day, items, hidden items, gifts, trades and marts, rebuilt on Sovereign\'s '
     '1025 Pokémon.'),
    (5, 'HeartGold features', 'mostly', 'Almost done',
     'Following Pokémon, the phone, Mom\'s savings, Apricorn Balls, the Bug-Catching Contest, the Safari Zone, roamers, '
     'gym puzzles and more are in. The radio waits on the Pokétch or Pokégear decision.'),
    (6, 'Music', 'done', 'Done', 'Johto\'s and Kanto\'s songs play on their maps, in the sound memory that was full.'),
    (7, 'Joining the world', 'active', 'In progress',
     'A new game now plays from New Bark Town through Johto, the League and Kanto\'s eight gyms to the ship to '
     'Canalave City. Sinnoh\'s side waits on Platinum\'s opening; the level curve on your call.'),
    (8, 'Automated testing', 'active', 'In progress',
     'Sovereign\'s tests run on Johto and Kanto (trainers, wild tables, gifts, triggers, talk); the story test plays '
     'the game through.'),
    (9, 'Your playthrough', 'ready', 'Ready for you',
     'Johto and Kanto are playable from a new game; it can start whenever you like.'),
    (10, 'Release', 'later', 'Later', 'Final fixes, then the .xdelta patches.'),
]

NEXT = [
    'Finish the single uninterrupted run of the story test from the bedroom (under way).',
    'Sinnoh after the ship: once Platinum\'s opening is decided, carry the story test on from Canalave City.',
    'The level curve and level caps across the 24 gyms and 2 Leagues, once you choose how far Johto and Kanto '
    'compress.',
    'The three-region Town Map (a list menu stands in for now), waiting on the art question.',
]

WAITING = [
    ('Platinum\'s opening', 'What happens to Twinleaf Town, Rowan\'s starters and Barry now that the game starts in '
     'Johto. Sinnoh\'s story waits on it.'),
    ('Unlock points', 'The ferry to Kanto after the League (as in HeartGold) and the way to Sinnoh after Kanto\'s eighth '
     'badge: proposed, and how it works for now.'),
    ('Level curve', 'How far Johto and Kanto compress so Sinnoh still ends at Spear Pillar by Lv. 100.'),
    ('Pokétch, Pokégear or both', 'The radio, the contact list and the Town Map\'s Johto and Kanto wait on it.'),
    ('Red at Mt. Silver', 'Before the player leaves for Sinnoh, or saved for the post-game.'),
    ('Johto\'s Battle Frontier and the Pokéathlon Dome', 'Keep them open or closed.'),
    ('Voltorb Flip', 'Port it, or keep Platinum\'s slots as the stand-in.'),
    ('The Hall of Fame and the credits', 'Proposed: the credits roll once, at the end of the story.'),
    ('Art', 'Who draws the three-region Town Map and the walking sprites for #494 to #1025.'),
]

# Since yesterday: the latest work, from docs/Progress.md (Oct 31 into Nov 1)
RECENT = [
    ('Kanto in the story test', [
        'Parts 75 to 95 follow Sacred Gold\'s Kanto order, worked out from its scripts: Diglett\'s Cave to Brock, '
        'Mt. Moon, the Power Plant\'s stolen part and Misty, Lt. Surge, Rock Tunnel, Fuchsia\'s Shellder swarm and '
        'Janine, the Cycling Road and Erika, Sabrina, Blaine in Seafoam Islands, Blue, and the ship to Canalave City.',
        'Every part from the bedroom to Canalave City has passed in a chain, each from where the one before ended.',
        'Seafoam Islands from its west door: three Strength pushes on B1F open the way to Blaine; played in the '
        'emulator.',
    ]),
    ('In the game', [
        'The ferries run any day: Sacred Gold\'s port sailors in Olivine and Vermilion let the player through only on '
        'the S.S. Aqua\'s days, which also held the ship to Canalave to them.',
    ]),
    ('In the story test', [
        'New actions: riding the Bicycle, and holding a key up the Cycling Road\'s slope through its bikers\' battles.',
        'The walks slide along Viridian Gym\'s arrows as the game moves the player.',
        'East, west and south warps take the player from their own tile with the key pressed; the gatehouse doors '
        'now do.',
        'Battles run in Set style, so Shift\'s switch question never comes.',
        'Walks to people and to Vermilion Gym\'s cans pick a side the player can reach; Cerulean Gym is crossed round '
        'its pool when a trainer stays in its narrow way.',
    ]),
]

KANTO = {'PalletTown', 'ViridianCity', 'PewterCity', 'CeruleanCity', 'VermilionCity', 'LavenderTown', 'CeladonCity',
         'FuchsiaCity', 'SaffronCity', 'CinnabarIsland', 'MtMoon', 'RockTunnel', 'SeafoamIslands', 'DiglettsCave',
         'ViridianForest', 'CeruleanCave', 'PowerPlant', 'PalPark', 'RotomsRoom', 'VictoryRoadJk', 'IndigoPlateau',
         'PokemonLeague', 'Route28'} | {f'Route{n}' for n in range(1, 26)}
UNUSED = {'FightArea', 'JubilifeCity', 'MysteryZone', None}
NAMES = {'MtMoon': 'Mt. Moon', 'MtSilver': 'Mt. Silver', 'MtSilverCave': 'Mt. Silver Cave', 'MtMortar': 'Mt. Mortar',
         'SsAqua': 'S.S. Aqua', 'VictoryRoadJk': 'Victory Road', 'TeamRocketHq': 'Team Rocket HQ',
         'DiglettsCave': 'Diglett\'s Cave', 'DragonsDen': 'Dragon\'s Den', 'RotomsRoom': 'Rotom\'s Room',
         'PokemonLeague': 'Pokémon League', 'PokeathlonDome': 'Pokéathlon Dome', 'LakeOfRage': 'Lake of Rage',
         'RuinsOfAlph': 'Ruins of Alph', 'MysteryZone': 'Special rooms', 'FightArea': 'Unused rooms',
         'JubilifeCity': 'Unused buildings', 'SafariZoneGate': 'Safari Zone Gate', None: 'No label'}
KIND_TOWN = re.compile(r'(Town|City|Island)$')


def place_name(label):
    if label in NAMES:
        return NAMES[label]
    return re.sub(r'(?<=[a-z])(?=[A-Z0-9])', ' ', label)


def kind_of(label):
    if label is None or label in UNUSED:
        return 'other'
    if label.startswith('Route'):
        return 'route'
    if KIND_TOWN.search(label) or label in ('IndigoPlateau',):
        return 'town'
    return 'place'


def headers():
    """Each HeartGold map: its location label, wild table, music."""
    src = open(os.path.join(ROOT, 'decomp', 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    out = {}
    for m in re.finditer(r'\[MAP_HEADER_HGSS_(\w+)\]\s*=\s*\{(.*?)\}', src, re.S):
        body = m.group(2)
        label = re.search(r'mapLabelTextID = (\w+)', body)
        out[m.group(1)] = {
            'label': label.group(1).replace('LocationNames_Text_', '') if label else None,
            'wild': 'ENCOUNTERS_NONE' not in re.search(r'wildEncountersArchiveID = (\w+)', body).group(1),
            'music': '_GS_' in re.search(r'dayMusicID = (\w+)', body).group(1),
        }
    return out


def older_name(part, seen):
    """A part's name as it is now, for one in a log from before a rename: the Lake of Rage's Lance was 'Lance' too."""
    return "Lance's request" if part == 'Lance' and 'LAKE_OF_RAGE' in seen else part


def story_maps():
    """The maps each passing part of the story test walked through, from the logs in .cache, and the latest single
    run's passed parts (story-full3*)."""
    parts = [p[0] for p in test_hgss_opening.PARTS]
    walked = collections.defaultdict(set)
    passed = set()
    for path in sorted(glob.glob(os.path.join(ROOT, '.cache', '*.log'))):
        seen = set()
        for line in open(path, encoding='utf-8', errors='replace'):
            for name in re.findall(r'MAP_HEADER_HGSS_(\w+)', line):
                seen.add(name)
            m = re.match(r'^(.+): (ok|.+)$', line.rstrip('\n'))
            part = m and older_name(m.group(1), seen)
            if part in parts and not line.startswith(' '):
                if m.group(2) == 'ok':
                    passed.add(part)
                    for name in seen:
                        walked[name].add(part)
                seen = set()
    single, seen = [], set()
    for path in sorted(glob.glob(os.path.join(ROOT, '.cache', 'story-full3*.log'))):
        for line in open(path, encoding='utf-8', errors='replace'):
            for name in re.findall(r'MAP_HEADER_HGSS_(\w+)', line):
                seen.add(name)
            m = re.match(r'^(.+): ok$', line.rstrip('\n'))
            part = m and older_name(m.group(1), seen)
            if part in parts and part not in single:
                single.append(part)
            if m:
                seen = set()
    return walked, passed, single


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, '.cache', 'progress', 'index.html')
    info = headers()
    walked, passed, single = story_maps()
    parts = [p[0] for p in test_hgss_opening.PARTS]
    events, matrix_of = {}, {}
    for _, headers_of, cur, _ in event_maps():
        for header, matrix in headers_of:
            if header.startswith('MAP_HEADER_HGSS_'):
                events[header[16:]] = cur
                matrix_of[header[16:]] = matrix
    places = {}
    for name, h in info.items():
        label = h['label']
        region = 'other' if label in UNUSED or 'UNUSED' in name else 'kanto' if label in KANTO else 'johto'
        key = 'Unused' if 'UNUSED' in name else label
        place = places.setdefault(key, {
            'name': 'Unused maps' if key == 'Unused' else place_name(label), 'region': region,
            'kind': 'other' if key == 'Unused' else kind_of(label), 'maps': [], 'trainers': 0, 'people': 0,
            'items': 0, 'wild': 0, 'parts': set()})
        ev = events.get(name, {})
        objects = ev.get('object_events', [])
        trainers = sum(1 for o in objects if str(o.get('script', '')).startswith('TRAINER_'))
        items = sum(1 for o in objects if o.get('graphics_id', '').endswith('POKEBALL'))
        place['trainers'] += trainers
        place['items'] += items
        place['people'] += len(objects) - trainers - items
        place['wild'] += h['wild']
        place['parts'] |= walked.get(name, set())
        place['maps'].append({'name': name, 'walked': sorted(walked.get(name, ()), key=parts.index),
                              'trainers': trainers, 'items': items, 'wild': h['wild'], 'music': h['music']})
    for place in places.values():
        place['parts'] = sorted(place['parts'], key=parts.index)
        place['walkedMaps'] = sum(1 for m in place['maps'] if m['walked'])
    # the overworld, block by block: each 32x32 block's map, and so its place
    grid = json.load(open(os.path.join(ROOT, 'decomp', 'res', 'field', 'matrices', 'map_matrix_hgss_0000.json')))
    place_of = {}
    for key, place in places.items():
        for m in place['maps']:
            place_of[m['name']] = key
    overworld = []
    for row in grid['headers']:
        overworld.append([None if h in ('MAP_HEADER_EVERYWHERE', 'MAP_NONE', None) else
                          [h[16:], place_of.get(h[16:]), bool(walked.get(h[16:]))] for h in row])
    regions = []
    for region in ('johto', 'kanto'):
        ps = [p for p in places.values() if p['region'] == region]
        maps = [m for p in ps for m in p['maps']]
        regions.append({'region': region, 'places': len(ps), 'maps': len(maps),
                        'walked': sum(1 for m in maps if m['walked']),
                        'trainers': sum(p['trainers'] for p in ps), 'items': sum(p['items'] for p in ps),
                        'wild': sum(1 for m in maps if m['wild']),
                        'placesWalked': sum(1 for p in ps if p['parts'])})
    story = []
    for i, (name, actions, end_map, marker) in enumerate(test_hgss_opening.PARTS):
        story.append({'n': i + 1, 'name': name, 'passed': name in passed, 'single': name in single,
                      'end': place_name(info.get(end_map[16:], {}).get('label')) if end_map.startswith(
                          'MAP_HEADER_HGSS_') else end_map.replace('MAP_HEADER_', '').replace('_', ' ').title()})
    data = {
        'updated': UPDATED, 'generated': datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%d %H:%M UTC'),
        'steps': [dict(zip(('n', 'name', 'status', 'label', 'detail'), s)) for s in STEPS],
        'next': NEXT, 'waiting': [dict(zip(('topic', 'detail'), w)) for w in WAITING],
        'recent': [{'title': t, 'items': items} for t, items in RECENT],
        'places': sorted(places.values(), key=lambda p: (p['region'], p['kind'] != 'town', p['name'])),
        'regions': regions, 'overworld': overworld, 'story': story,
        'totals': {'maps': len(info), 'walked': sum(1 for n in info if walked.get(n)),
                   'parts': len(parts), 'passed': sum(s['passed'] for s in story),
                   'single': sum(s['single'] for s in story),
                   'trainers': sum(p['trainers'] for p in places.values()),
                   'wild': sum(1 for h in info.values() if h['wild']),
                   'music': sum(1 for h in info.values() if h['music'])},
    }
    template = open(os.path.join(ROOT, 'tools', 'complete', 'progress_page.html'), encoding='utf-8').read()
    page = template.replace('/*DATA*/null', json.dumps(data, ensure_ascii=False, separators=(',', ':')))
    os.makedirs(os.path.dirname(os.path.abspath(out)), exist_ok=True)
    open(out, 'w', encoding='utf-8').write(page)
    print(f'{out}: {len(page)} bytes; {data["totals"]}')


if __name__ == '__main__':
    main()
