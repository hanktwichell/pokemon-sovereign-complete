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

UPDATED = 'Nov 3, 2026'

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
     'gym puzzles, the Johto Pokédex, Voltorb Flip, Johto\'s Battle Frontier and the Pokégear beside the Pokétch '
     '(its phone, its map, its radio and the switch) are in.'),
    (6, 'Music', 'done', 'Done', 'Johto\'s and Kanto\'s songs play on their maps, in the sound memory that was full.'),
    (7, 'Joining the world', 'active', 'In progress',
     'A new game plays from New Bark Town through Johto, the League and Kanto\'s eight gyms to the first ship to '
     'Sinnoh, which lands in Twinleaf Town for Platinum\'s opening. Sinnoh\'s levels follow Kanto\'s; Totems, '
     'legendaries and Megas are spread over all three regions. The story test has played every part from New Bark '
     'Town to Sinnoh\'s Hall of Fame.'),
    (8, 'Automated testing', 'active', 'In progress',
     'Sovereign\'s tests run on Johto and Kanto (trainers, wild tables, gifts, triggers, talk); the story test plays '
     'the game through; one command runs all 31 of Complete\'s feature tests (the latest sweep: 28 passed, and two '
     'of the other three were tests behind the game, now updated).'),
    (9, 'Your playthrough', 'ready', 'Ready for you',
     'Johto and Kanto are playable from a new game; it can start whenever you like.'),
    (10, 'Release', 'later', 'Later', 'Final fixes, then the .xdelta patches.'),
]

NEXT = [
    'A new full story run (all 186 parts, New Bark Town to Sinnoh\'s Hall of Fame) is going on the newest build: the '
    'legendary cutscenes, Fly on the Pokégear\'s map and the Magnet Train\'s ride. The last run stopped at Bugsy\'s '
    'gym, where the test flipped a cart switch twice; the test presses it once now.',
    'The long checks pass on the latest build (every Totem and legendary placement, every boss Mega, every tile '
    'behavior, the sound memory on every map). The talk test over all 5,865 people and signs is running.',
    'HeartGold\'s sprites are in: its people, all 566 walking Pokémon (every species to #493 follows you now), its still '
    'objects and its Apricorn trees. Custom or missing Pokémon sprites (#494 on) are yours, later.',
]

WAITING = [
    ('Sinnoh\'s integration', 'A provisional one of Claude\'s is in (the Sinnoh tab): the first ship lands in '
     'Twinleaf Town for Platinum\'s opening, and Sinnoh\'s levels follow Kanto\'s, from one table '
     '(data/complete/sinnoh.yaml). Change any of it whenever you like.'),
    ('Cynthia', 'Her Lv. 96 team beat a Lv. 100 team in all six real battles. Keep her that hard, or not.'),
    ('Art', 'Who draws the three-region Town Map and the walking sprites for #494 to #1025.'),
    ('HeartGold\'s key items', 'Proposed: port the Berry Pots (about a day) and the Unown Report (half a day); the '
     'Dowsing Machine stays with the Pokétch\'s Dowsing app. Yes or no?'),
    ('Trade items from the bag', 'Proposed: as in Sacred Gold, the trade-evolution items (Metal Coat, King\'s Rock and '
     'the rest) evolve a Pokémon from the bag, in all three regions, with trading still working. Yes or no?'),
    ('The Pokéathlon Dome', 'With the Pokéathlon skipped: the building open (its people, no events) or closed?'),
    ('The photo album', 'Cameron takes photos on 59 maps, but there\'s no album to keep them in. Port it, or leave '
     'him out?'),
]

# Since yesterday: the latest work, from docs/Progress.md (Nov 2-3)
RECENT = [
    ('Your Nov 3 calls, done', [
        'Voltorb Flip is in both Game Corners: HeartGold\'s own game, its board, memos, levels, coins and fanfares. '
        'In the emulator a round won paid 24 coins and moved on to level 2, a round quit paid what was found, and '
        'Quit brought you back to the Game Corner.',
        'The Johto Pokédex is the regional one until Sinnoh\'s story begins (HeartGold\'s list and numbers, under a '
        'JOHTO POKéDEX banner); Sinnoh\'s after.',
        'Red waits on Mt. Silver until Sinnoh\'s League is won. The credits roll once, at the end of the whole game.',
        'Johto\'s Battle Frontier is open: its five facilities run Platinum\'s own challenges from their Johto lobbies. In '
        'the emulator a Factory challenge rented three Pokémon, won its first battle and retired back to Johto\'s lobby, '
        'and the Tower, Hall, Castle and Arcade each started theirs. Battle Points, streaks and prints are shared with '
        'Sinnoh\'s Frontier. Its three move tutors teach HeartGold\'s 51 moves for Battle Points, at HeartGold\'s '
        'prices (checked in the emulator: Fury Cutter for 32 BP).',
        'The Pokégear, first part: you can call the people in your phone book. Each says what they say in '
        'HeartGold when you call: Mom asks about saving money, Elm has news, Oak rates your Johto or National Pokédex '
        '(with his menu and fanfare), Bill counts the room in your boxes, the Day-Care couple say how your Pokémon are '
        'doing, Lyra or Ethan tells a story about where you are, Kurt says how his Balls are coming, and the Gym '
        'Leaders agree to rematches at the Fighting Dojo after all sixteen badges. Where HeartGold had no signal '
        '(the Elite Four\'s rooms, the Safari Zone, Lugia\'s cave) the number is "out of the area". All 12 calls the '
        'emulator test places pass.',
        'The Pokégear is on the bottom screen, in HeartGold\'s own look: its phone\'s contact list (names and titles '
        'such as Pokémon Professor or Youngster) and its app bar. It comes up when Mom gives it to you. Tap a contact '
        'to call them; the arrows scroll. Once you also have the Pokétch, a blue button under the Pokétch\'s red side '
        'button switches to the Pokégear, and the Pokégear\'s last app bar button switches back; your choice is '
        'saved. All 6 parts of its emulator test pass (getting it, a call, scrolling, the switch both ways, a warp, '
        'a battle).',
        'The Pokégear\'s Settings: HeartGold\'s six skins (blue, pink, black, wood, gold, teal); tap one and the '
        'whole Pokégear changes to it.',
        'Calls ring now, as in HeartGold: the Pokégear\'s Phone button flashes and the ring sounds as you walk; tap '
        'Phone to answer. Left unanswered, a call stops after 59 seconds. A few (the Bike Shop, Bill, Baoba) still '
        'come straight through, as in HeartGold.',
        'The Pokégear\'s Map: HeartGold\'s map of Johto and Kanto with your head where you are and the place\'s name; '
        'drag it to see the rest. Checked in the emulator in your room and on Route 30.',
        'The Pokégear\'s Radio: HeartGold\'s globe and all twelve of its shows, with their music and text. Drag the '
        'cursor or tap a button beside the globe: DJ Ben\'s Pokémon Music (the March brings more wild Pokémon, the '
        'Lullaby fewer, Hoenn\'s and Sinnoh\'s sounds bring their Pokémon), Professor Oak\'s Pokémon Talk (it names '
        'today\'s outbreak), Trainer Profiles, That Town, These People, the Search Party, the Serial Radio Drama and '
        'Buena\'s Password (her quiz in the Radio Tower now asks for the password her show gave), with commercials. In '
        'Kanto the Poké Flute wakes Snorlax; the Unown\'s broadcast plays in the Ruins of Alph and a strange signal '
        'around Mahogany. Its music plays in the field while the page shows a station. Sinnoh has no signal. All 11 '
        'parts of its emulator test pass.',
    ]),
    ('More of HeartGold', [
        'The Rocket Hideout\'s traps go off under you before their battles (sparks, a gas cloud, falling rocks), and '
        'its Persian statues\' alarm turns the screen red, as in HeartGold.',
        'The Magnet Train\'s ride between Goldenrod and Saffron is HeartGold\'s own now: the train pulling in, waiting '
        'at the platform and racing across the country, with HeartGold\'s models for the time of day and for you, and '
        'its jingle as it arrives.',
        'The Bell Tower\'s Ho-Oh scene and the Whirl Islands\' Lugia scene are HeartGold\'s own now: the Clear Bell '
        'rises and shimmers with the corner bells, leaves blow over the roof (waves in the cave), the camera pans up '
        'to the sky, and Ho-Oh flaps down onto the roof.',
        'Fly over Johto and Kanto uses HeartGold\'s fly map on the Pokégear\'s Map instead of a list: its red cursor on '
        'the towns you\'ve reached; the D-pad or a tap moves it, A or a second tap flies there, B backs out. With the '
        'Pokétch on the bottom screen the list is still there.',
        'HeartGold\'s fishing outbreaks and night fishing are in (Staryu bites on the Super Rod in Cherrygrove at '
        'night).',
    ]),
    ('Following Pokémon', [
        'Your Pokémon never stands on your tile any more. It comes out beside you (behind you, or to a side, never '
        'where you\'re heading), and when you come out of a door it appears in the doorway behind you as you step '
        'off. You walk through it and swap places, as in HeartGold.',
        'A shiny lead follows in its shiny colours (HeartGold\'s shiny palettes for all 566).',
    ]),
    ('Battle preview', [
        'Videos of Mega Charizard Y against Cynthia in her room, from her own scene: one real battle (Charizard takes '
        'three of her six before Garchomp\'s Outrage, and her Lv. 96 team wins) and one in the test build\'s '
        'one-sided mode, where Charizard sweeps.',
        'In real battles her team beat a Lv. 100 team six times out of six. She\'s hard; whether she should be this '
        'hard is your call.',
    ]),
    ('HeartGold\'s sprites', [
        'All 566 of HeartGold\'s walking Pokémon are in, so every species up to Arceus follows you (forms and female '
        'variants included), and the Pokémon standing about on the maps use them too.',
        'HeartGold\'s still objects: the Snorlax on Routes 11 and 12, the League\'s doors, signs, medals and statues. '
        'Its Apricorn trees show their fruit until you pick it.',
        'Its 3D objects (books, locked doors, the Elite Four rooms\' doors) use Platinum\'s 3D objects of the same kind.',
        'Johto\'s and Kanto\'s people use HeartGold\'s own sprites: the 16 gym leaders, Silver, Team Rocket and its '
        'executives, Kurt, Bill, Eusine, Lance, Giovanni, Red, Elm, the Kimono Girls and the townsfolk. 1,449 people '
        'on 381 maps changed; Misty and Whitney no longer look like Crasher Wake.',
        'Your childhood friend is Lyra (or Ethan), not Dawn or Lucas.',
        'Scripts that change someone\'s look in a scene (Mom, Whitney, the friend, Silver\'s starter) named the wrong '
        'sprites; they use the right ones now.',
    ]),
    ('The story test reaches the end', [
        'The full recorded run played all 186 parts in one game, from New Bark Town to Sinnoh\'s Hall of Fame (resumed '
        'from the failing part after each fix), and the highlight video is cut from it.',
        'Every part from New Bark Town to Sinnoh\'s Hall of Fame has passed: the Elite Four (their lifts, Bertha\'s '
        'format question), Cynthia, the Hall of Fame, the credits and the reset back to Twinleaf.',
        'Sinnoh\'s middle and north: Canalave, Byron, Lake Valor, Acuity, the Snowpoint Temple, the Galactic HQ, Spear '
        'Pillar, the Distortion World and Victory Road.',
        'The walks cut trees, smash rocks, push boulders, ride the Cycling Road and climb waterfalls and Rock Climb '
        'walls, but keep off Rock Climb walls until a badge allows it (one on Route 5 stopped the recorded run).',
    ]),
    ('Bugs the tests found and fixed', [
        'Since the wild Pokémon became the original games\' own, the outbreaks are HeartGold\'s (Yanma on Route 35, not '
        'Sacred Gold\'s Illumise). The Ruins of Alph\'s halls are Unown-only again (a Gothita and three others had '
        'been mixed in; they live elsewhere in Johto now). HeartGold\'s fishing outbreaks and its night fishing are in '
        '(Staryu on the Super Rod in Cherrygrove at night), and Mawile, whose only wild spot needed a Game Boy Advance '
        'game in the DS, is in a Johto cave.',
        'A sweep of all 31 feature tests found two that had fallen behind the game (the first ship to Sinnoh now '
        'lands in Twinleaf Town; Voltorb Flip\'s menu takes a touch once its line has printed); they\'re updated.',
        'A tap on the Pokégear during a cutscene could queue a phone call that rang in once the scene ended (the story '
        'test hit it in Sprout Tower); the Pokégear\'s contacts only beep during scenes and warps now.',
        'Totems Marowak (Rock Tunnel) and Salazzle (Cinnabar) stood on Rock Climb ledges nobody could reach that early; '
        'both are moved.',
        'Entering Burned Tower B1F, Dragon\'s Den or the Ruins of Alph froze the game; Rowan\'s briefcase froze it '
        'too (the field heap ran out). Both fixed.',
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
    ('Arriving in Sinnoh', 'The first ship to Sinnoh sails to Twinleaf Town and leaves the player in their room, where '
     'Platinum\'s opening plays (tested); Rowan\'s starter goes to the PC when the party is full.', 'done'),
    ('Sinnoh\'s levels', 'Sinnoh\'s trainers, wild Pokémon and gifts moved up to follow Kanto (Roark\'s ace Lv. 72, '
     'Cynthia\'s 96), from one table of levels, with trainers\' teams evolved to match.', 'done'),
    ('Level caps', 'Sovereign\'s optional caps for all three regions\' gyms and Leagues, in story order.', 'done'),
    ('Totems and legendaries in three regions', 'Eight Totem trials asked for by Johto\'s and Kanto\'s leaders, 32 '
     'Chronicle legendaries moved to Johto and Kanto; each placement tested in the emulator.', 'done'),
    ('Sovereign\'s newer work', 'Sovereign\'s commits since Oct 29 (tall battle sprites fitted to the screen) are '
     'in, by the sync script; Sovereign has none newer (checked Nov 3).', 'done'),
    ('Megas everywhere', 'Whitney gives the Mega Ring, 23 item balls hold Mega Stones, and 50 of Johto\'s and '
     'Kanto\'s 63 later bosses Mega Evolve, each checked in battle.', 'done'),
    ('Sinnoh\'s scenes with a follower', 'Platinum\'s cutscenes were written without one; the story test plays every '
     'one with a follower out, and the follower comes out beside the player, never on their tile.', 'done'),
    ('The story test through Sinnoh', 'The playthrough test carries on from Twinleaf Town through Sinnoh\'s story to '
     'the Hall of Fame. It found a freeze at Rowan\'s briefcase (the field heap ran out with the following Pokémon on '
     'screen), now fixed; every part passes, Cynthia and the Hall of Fame included.', 'done'),
    ('A full test, and a highlight video', 'Every test on the finished game (placements 40 of 40, Megas 50 of 50, '
     'Cyrus and Giratina pass), the playthrough from New Bark Town to Sinnoh\'s Hall of Fame (all 186 parts pass), '
     'and a 2 minute video of it.', 'done'),
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
    ('Nov 1', 'Done: Sinnoh\'s arrival, levels and caps; Totems and legendaries spread; Megas in Johto and Kanto.',
     'Claude', 'done'),
    ('Nov 2', 'Done: the story test through Sinnoh to the Hall of Fame, with a follower out in every scene; a full test '
     'of the game, and the highlight video from its playthrough.', 'Claude', 'done'),
    ('Any time', 'Your playthrough (step 9): Johto and Kanto are playable now; about 40 to 60 days at 2 hours a day '
     'for all three regions.', 'You', 'waiting'),
    ('Nov 3', 'Your Nov 3 calls: Voltorb Flip, the Johto Pokédex, Red and the credits, Johto\'s Battle Frontier '
     'and the Pokégear beside the Pokétch (its phone, calls you place, its map, its radio, the switch) are done.',
     'Claude', 'done'),
    ('Your call', 'The art for the Town Map and sprites, Cynthia\'s difficulty, and any of the provisional Sinnoh '
     'choices to change.', 'You', 'waiting'),
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


FINAL_LOGS = sorted(glob.glob(os.path.join(ROOT, '.cache', 'final2', 'run*.log')),
                    key=lambda path: int(re.search(r'run(\d+)', path).group(1)))


def story_maps():
    """The maps each passing part of the story test walked through, from the logs in .cache, and the latest single
    run's passed parts (the final recorded run from the bedroom: .cache/final2/run*.log, one log for each resume)."""
    parts = [p[0] for p in test_hgss_opening.PARTS]
    walked = collections.defaultdict(set)
    passed = set()
    for path in sorted(glob.glob(os.path.join(ROOT, '.cache', '*.log')) + FINAL_LOGS):
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
    for path in FINAL_LOGS:
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
