#!/usr/bin/env python3
"""Write the progress page (tools/complete/progress_page.html filled in), published as a claude.ai artifact.

The page's tabs: the whole game (the roadmap's steps and where each stands, what's next, what waits on the owner),
since yesterday (the latest entries of docs/Progress.md, summarized here), Sinnoh (what joins it to Johto and Kanto, and
the provisional integration under way), maps and routes (every Johto and Kanto map, grouped into places by its location
label: its people, trainers, items, wild Pokémon, and the story test's parts that walk through it, with the overworld
drawn block by block), the story test (its parts, and how far a run from the bedroom has got), and the timeline (each
day's log entries, decisions and commits, which roadmap steps they were for, and the plan ahead).

What it reads: decomp/include/data/map_headers.h (each map's location label, scripts, wild Pokémon and music), the maps'
events (tools/test/talk_to_objects.py's event_maps), the overworld matrix (map_matrix_hgss_0000), the story test's
parts (tools/complete/test_hgss_opening.py's PARTS) and its logs in .cache (a part's maps are the ones its lines name,
counted only for a part that passed). The status of the roadmap's steps, the next steps, the open decisions and the
summary of recent work, Sinnoh's status, the steps each log entry was for and the plan ahead are kept below by hand
(STEPS, NEXT, WAITING, RECENT, SINNOH_IN, SINNOH_PLAN, ENTRY_STEPS, MILESTONES, AHEAD): update them with
docs/Progress.md. The roadmap's decisions are read from docs/Roadmap.md, and the commits from git.

Usage: python3 tools/complete/progress_page.py [OUT]   (default .cache/progress/index.html)
"""
import collections
import datetime
import glob
import json
import os
import re
import subprocess
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
     'Canalave City. Sinnoh\'s side is next, with a provisional integration of Claude\'s own (your Nov 1 go-ahead).'),
    (8, 'Automated testing', 'active', 'In progress',
     'Sovereign\'s tests run on Johto and Kanto (trainers, wild tables, gifts, triggers, talk); the story test plays '
     'the game through.'),
    (9, 'Your playthrough', 'ready', 'Ready for you',
     'Johto and Kanto are playable from a new game; it can start whenever you like.'),
    (10, 'Release', 'later', 'Later', 'Final fixes, then the .xdelta patches.'),
]

NEXT = [
    'Finish the single uninterrupted run of the story test from the bedroom (under way).',
    'Sinnoh\'s provisional integration (your Nov 1 go-ahead): arriving in Canalave City, Sinnoh\'s levels after Kanto, '
    'level caps for all three regions. Each choice in one place, so it can change.',
    'Megas in Johto and Kanto: the Mega Ring and stones within reach, and Megas for their bosses.',
    'The story test on through Sinnoh to Spear Pillar, then a full test of the game and a highlight video.',
]

WAITING = [
    ('Sinnoh\'s integration', 'Claude is putting in a provisional one at your request (the Sinnoh tab): Platinum\'s '
     'opening, the unlock point and the level curve. Change any of it whenever you like.'),
    ('Pokétch, Pokégear or both', 'The radio, the contact list and the Town Map\'s Johto and Kanto wait on it.'),
    ('Red at Mt. Silver', 'Before the player leaves for Sinnoh, or saved for the post-game. As in HeartGold for now.'),
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

# Sinnoh's side: what joins it to Johto and Kanto already, and the provisional integration the owner asked for on Nov 1
# ("devise your own Sinnoh integration for now so everything can be tested"), with its status (done, active, planned)
SINNOH_IN = [
    ('The whole region', 'Sovereign Platinum\'s Sinnoh as it is: its maps, story, trainers, wild Pokémon, Totem trials '
     'and features, in the same game as Johto and Kanto.'),
    ('The ferry', 'From Kanto\'s eighth badge, the sailors at Olivine\'s and Vermilion\'s gangways sail to Canalave City, '
     'and Canalave\'s sailor back to either (tested both ways). The story test\'s last part lands there.'),
    ('Badges and field moves', 'A field move works with either region\'s badge for it, so Johto\'s badges keep Surf, '
     'Strength and the rest working in Sinnoh.'),
    ('Following Pokémon', 'The lead Pokémon follows in Sinnoh too, kept out of buildings when it\'s too tall, and talks '
     'as in HeartGold.'),
    ('Fly and the Town Map', 'Sinnoh keeps Platinum\'s Town Map; Johto and Kanto have a list of places for now. Each '
     'region\'s Fly stays in that region, and the ferries join them.'),
    ('Sovereign\'s own tests', 'Run on this build: battle mechanics 526 of 526, gifts 45 of 45, rare wild Pokémon 52 of '
     '52, evolutions 255 of 255, wild forms on every Sinnoh map, roamers, and Sovereign\'s signs and triggers.'),
]
SINNOH_PLAN = [
    ('Arriving in Sinnoh', 'What the first landing in Canalave City starts: Platinum\'s opening, Rowan and a Sinnoh '
     'starter.', 'planned'),
    ('Sinnoh\'s levels', 'Sinnoh\'s trainers and wild Pokémon moved up to follow Kanto, from one table of levels, with '
     'teams evolved to match.', 'planned'),
    ('Level caps', 'Sovereign\'s optional caps for all three regions\' gyms and Leagues, in story order.', 'planned'),
    ('Sovereign\'s newer work', 'Four Sovereign commits since Oct 29 (tall battle sprites fitted to the screen) brought '
     'in by the sync script.', 'planned'),
    ('Megas everywhere', 'The Mega Ring and Mega Stones within reach in Johto and Kanto, and Megas for their bosses, as '
     'Sinnoh\'s big fights have.', 'planned'),
    ('Sinnoh\'s scenes with a follower', 'Platinum\'s cutscenes were written without one; each is played with a '
     'follower out.', 'planned'),
    ('The story test to Spear Pillar', 'The playthrough test carried on from Canalave City through Sinnoh\'s story.',
     'planned'),
    ('A full test, and a highlight video', 'Every test on the finished game, the playthrough from New Bark Town to '
     'Spear Pillar, and a 1 to 2 minute video of it.', 'planned'),
]

# The timeline: the roadmap steps each docs/Progress.md entry was for, by its title (the story test's entries are
# step 7's: a new game played through is its done-when)
ENTRY_STEPS = {
    'step 1 starts': (1,), 'following Pokémon, first version': (1, 5), 'room in the save': (1,),
    'HeartGold\'s map assets are in': (2,), 'Olivine City in the engine': (1, 2),
    'every Johto and Kanto map is in': (2,), 'step 3 under way, HeartGold\'s scripts in the game': (3,),
    'step 4 under way, Sacred Gold\'s content': (4,), 'step 3\'s tests, roamers, Kurt\'s Apricorn Balls': (3, 5),
    'HeartGold\'s Balls in battle, shared people, step 5 and 6 plans': (3, 5, 6), 'the Bug-Catching Contest': (5,),
    'the Johto Safari Zone, and Johto and Kanto\'s music': (5, 6),
    'the step 3 tests on the new build, and fixes from them': (3, 8), 'the Pokégear phone': (5,),
    'Mom\'s savings': (5,), 'the follower keeps up mid-map': (5,), 'the Ruins of Alph puzzles': (5,),
    'talking to the following Pokémon': (5,), 'loan Pokémon, the Magikarp record, and smaller ports': (5,),
    'mass outbreaks': (5,),
    'ladders, Viridian Gym\'s stop tiles, Ice Path\'s boulder holes and the Lake of Rage\'s sky': (2, 5),
    'songs a flag puts on a map': (6,), 'Johto\'s and Kanto\'s gifts tested': (4, 8),
    'what HeartGold\'s code set, and Sovereign\'s own tests': (5, 8),
    'a bigger bag, and screens the scripts skipped': (5,), 'Fly over Johto and Kanto': (7,),
    'a new game starts in New Bark Town': (7,), 'the ferry network': (7,),
    'Viridian Gym\'s arrows light up, Fuchsia Gym\'s walls flash': (5,), 'Mahogany Gym\'s ice blocks': (5, 7),
}
STORY_ENTRY = re.compile(r'story test|opening|leg ahead|double free')
# Work outside docs/Progress.md: (date, step, what)
MILESTONES = [
    ('2026-10-28', 0, 'The plan: the roadmap, its estimates and the open decisions.'),
    ('2026-11-01', 0, 'You asked for a provisional Sinnoh integration of Claude\'s own, Megas in all three regions, a '
     'full test of the game and a highlight video.'),
]
# Ahead, from today: (when, what, who, status: active, planned, waiting), Claude's estimates as of UPDATED
AHEAD = [
    ('Nov 1', 'The single story run from the bedroom to Canalave City finishes.', 'Claude', 'active'),
    ('Nov 1–2', 'Sovereign\'s four newer commits synced; Sinnoh\'s integration designed and written down.', 'Claude',
     'planned'),
    ('Nov 2–3', 'Arriving in Sinnoh, Sinnoh\'s levels after Kanto, level caps for all three regions.', 'Claude',
     'planned'),
    ('Nov 3', 'Megas in Johto and Kanto: the Mega Ring and stones, and their bosses\' Megas.', 'Claude', 'planned'),
    ('Nov 3–5', 'The story test on through Sinnoh to Spear Pillar, with a follower out in every scene.', 'Claude',
     'planned'),
    ('Nov 5–6', 'A full test of the game, and the highlight video from its playthrough.', 'Claude', 'planned'),
    ('Any time', 'Your playthrough (step 9): Johto and Kanto are playable now; about 40 to 60 days at 2 hours a day '
     'for all three regions.', 'You', 'waiting'),
    ('Your call', 'The Pokétch or Pokégear (the radio, the contact list), the art for the Town Map and sprites, '
     'Johto\'s Battle Frontier, Voltorb Flip, the credits; and any of the provisional Sinnoh choices to change.',
     'You', 'waiting'),
    ('After step 9', 'Release (step 10): final fixes, then the .xdelta patches, about 3 days.', 'Both', 'planned'),
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


MONTHS = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')


def iso(day, year):
    """'Oct 29', '2026' -> '2026-10-29'."""
    month, n = day.split()
    return f'{year}-{MONTHS.index(month) + 1:02}-{int(n):02}'


def log_entries():
    """docs/Progress.md's entries: their date, title, roadmap steps and items (bullets and paragraphs, as markdown)."""
    text = open(os.path.join(ROOT, 'docs', 'Progress.md'), encoding='utf-8').read()
    out = []
    for m in re.finditer(r'^## (\w+ \d+), (\d{4}): ([^\n]+)\n(.*?)(?=^## |\Z)', text, re.M | re.S):
        items, cur = [], None
        for line in m.group(4).split('\n'):
            if not line.strip():
                cur = None
            elif line.startswith('- ') or cur is None:
                cur = [line[2:] if line.startswith('- ') else line]
                items.append(cur)
            else:
                cur.append(line.strip())
        title = m.group(3)
        steps = ENTRY_STEPS.get(title, (7,) if STORY_ENTRY.search(title) else ())
        out.append({'date': iso(m.group(1), m.group(2)), 'title': title, 'steps': list(steps),
                    'items': [re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', ' '.join(i)) for i in items]})
    return out


def decisions():
    """The roadmap's decided points, with their dates: (date, what)."""
    text = open(os.path.join(ROOT, 'docs', 'Roadmap.md'), encoding='utf-8').read()
    out = []
    for m in re.finditer(r'^- \*\*(.+?) \((\w+ \d+)(?:–\d+)?, (\d{4})\)\.\*\* ([^\n]+)', text, re.M):
        out.append({'date': iso(m.group(2), m.group(3)), 'title': m.group(1), 'text': m.group(4)})
    return out


def commits():
    """{date (UTC): [each commit's subject, oldest first]}."""
    log = subprocess.run(['git', '-C', ROOT, 'log', '--reverse', '--format=%ad\t%s',
                          '--date=format-local:%Y-%m-%d'], capture_output=True, text=True,
                         env=dict(os.environ, TZ='UTC'), check=True).stdout
    out = collections.defaultdict(list)
    for line in log.splitlines():
        date, subject = line.split('\t', 1)
        out[date].append(subject)
    return out


def timeline():
    entries, decided, by_day = log_entries(), decisions(), commits()
    days = sorted({e['date'] for e in entries} | {d['date'] for d in decided} | set(by_day) |
                  {m[0] for m in MILESTONES})
    grid = collections.defaultdict(lambda: collections.defaultdict(int))
    for e in entries:
        for step in e['steps']:
            grid[step][e['date']] += 1
    for d in decided:
        grid[0][d['date']] += 1
    for date, step, _ in MILESTONES:
        grid[step][date] += 1
    return {'days': days, 'entries': entries, 'decisions': decided, 'commits': by_day,
            'milestones': [dict(zip(('date', 'step', 'text'), m)) for m in MILESTONES],
            'grid': {str(s): dict(v) for s, v in grid.items()},
            'ahead': [dict(zip(('when', 'what', 'who', 'status'), a)) for a in AHEAD]}


def sinnoh():
    src = open(os.path.join(ROOT, 'decomp', 'include', 'data', 'map_headers.h'), encoding='utf-8').read()
    maps = len(re.findall(r'^\s*\[MAP_HEADER_(?!HGSS_)\w+\]\s*=', src, re.M))
    scripts = len([f for f in os.listdir(os.path.join(ROOT, 'decomp', 'res', 'field', 'scripts'))
                   if f.endswith('.s') and 'hgss' not in f])
    synced = subprocess.run(['git', '-C', ROOT, 'log', '-1', '--format=%ad', '--date=format:%b %-d',
                             '--', 'SOVEREIGN_COMMIT'], capture_output=True, text=True).stdout.strip()
    return {'maps': maps, 'scripts': scripts, 'synced': synced,
            'in': [dict(zip(('title', 'detail'), s)) for s in SINNOH_IN],
            'plan': [dict(zip(('title', 'detail', 'status'), s)) for s in SINNOH_PLAN]}


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
        'regions': regions, 'overworld': overworld, 'story': story, 'timeline': timeline(), 'sinnoh': sinnoh(),
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
