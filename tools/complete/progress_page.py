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

UPDATED = 'Nov 5, 2026'

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
     'gym puzzles, the Johto Pokédex, Voltorb Flip, Johto\'s Battle Frontier, the Pokégear beside the Pokétch (its '
     'phone, its map, its radio and the switch), the Magnet Train\'s ride and the legendaries\' cutscenes and '
     'cinematics are in. What\'s left waits on your calls (the photo album, the Pokéathlon Dome, the key items).'),
    (6, 'Music', 'done', 'Done', 'Johto\'s and Kanto\'s songs play on their maps, in the sound memory that was full, '
     'and HeartGold\'s own sound effects play in its scenes and scripts.'),
    (7, 'Joining the world', 'active', 'In progress',
     'A new game plays from New Bark Town through Johto, the League and Kanto\'s eight gyms to the first ship to '
     'Sinnoh, which lands in Twinleaf Town for Platinum\'s opening. One Town Map shows all three regions, and Fly '
     'stays within the region you\'re in. Sinnoh\'s levels follow Kanto\'s; Totems, '
     'legendaries and Megas are spread over all three regions. The story test has played every part from New Bark '
     'Town to Sinnoh\'s Hall of Fame.'),
    (8, 'Automated testing', 'active', 'In progress',
     'Sovereign\'s tests run on Johto and Kanto (trainers, wild tables, gifts, triggers, talk); the story test plays '
     'the game through; one command runs Complete\'s 36 feature tests (the latest sweep: 34 of 36, the two others '
     'changed during it for the next build, where they pass) and 8 long ones.'),
    (9, 'Your playthrough', 'ready', 'Ready for you',
     'Johto and Kanto are playable from a new game; it can start whenever you like.'),
    (10, 'Release', 'later', 'Later', 'Final fixes, then the .xdelta patches.'),
]

NEXT = [
    'Your final boss team against Cynthia, recorded, to show Mega Evolution working.',
    'Sovereign\'s Elite Four format (two single battles, two double battles) at the Indigo Plateau and in Sinnoh; '
    'Champion Lance a single battle, Champion Cynthia a double battle.',
    'The Trainer Card with all 24 badges (a preview for you), then your Nov 6 answers in turn (the Questions tab has '
    'each one\'s status).',
]

WAITING = [
    ('Sinnoh\'s integration', 'A provisional one of Claude\'s is in (the Sinnoh tab): the first ship lands in '
     'Twinleaf Town for Platinum\'s opening, and Sinnoh\'s levels follow Kanto\'s, from one table '
     '(data/complete/sinnoh.yaml). Change any of it whenever you like.'),
    ('Cynthia', 'Her Lv. 96 team beat a Lv. 100 team in all six real battles. Keep her that hard, or not.'),
    ('Art', 'Who draws the walking sprites for #494 to #1025. The Town Map of three regions is in, made from the '
     'two games\' own maps (the Gallery tab has screenshots); new art for it is welcome but not needed.'),
    ('HeartGold\'s key items', 'Proposed: port the Berry Pots (about a day) and the Unown Report (half a day); the '
     'Dowsing Machine stays with the Pokétch\'s Dowsing app. Yes or no?'),
    ('Trade items from the bag', 'Proposed: as in Sacred Gold, the trade-evolution items (Metal Coat, King\'s Rock and '
     'the rest) evolve a Pokémon from the bag, in all three regions, with trading still working. Yes or no?'),
    ('The Pokéathlon Dome', 'With the Pokéathlon skipped: the building open (its people, no events) or closed?'),
    ('The photo album', 'Cameron takes photos on 59 maps, but there\'s no album to keep them in. Port it, or leave '
     'him out?'),
    ('The Town Map in Johto', 'Fly opens the one Town Map everywhere, but the bag\'s Town Map is only given in Sinnoh '
     '(Jubilife\'s Trainers\' School), so a new game has none until then. Proposed: the Cherrygrove City guide, who '
     'gives the Pokégear\'s Map Card, gives the Town Map with it, and Sinnoh\'s gift is skipped if you have it. Yes or '
     'no?'),
]

# Every question waiting on the owner, numbered, for the "Your questions" tab: (group, [(question, what the game does
# now, the options, Claude's proposal or None)]). Kept in step with docs/Roadmap.md's "Still open".
QUESTIONS = [
    ('Reminder: waiting on you', [
        ('What should Sinnoh\'s HM givers give now? (your answer 1)',
         'Every HM can be earned in Johto and Kanto before Sinnoh (Whirlpool as HM05), so Sinnoh\'s HM givers are free. '
         'Defog stays where Platinum has it, as the new HM09. Every Mega Stone is also sold in Sovereign\'s Mega Stone '
         'shops (Hearthome, Pastoria, Snowpoint, the Survival Area), so these would be early gifts.',
         ['Cynthia in Eterna City (was HM01 Cut): Garchompite Z',
          'The Galactic Warehouse\'s item ball in Veilstone City (HM02 Fly): Staraptite',
          'Cynthia\'s grandmother in Celestic Town (HM03 Surf): Galladite',
          'Riley on Iron Island (HM04 Strength): Lucarionite',
          'The Oreburgh Gate\'s hiker (HM06 Rock Smash): Excadrite',
          'Crasher Wake in Pastoria City (HM07 Waterfall): Sharpedonite',
          'Snowpoint Temple\'s last floor (HM08 Rock Climb): Froslassite',
          'Platinum\'s Defog item ball (HM05): HM09 Defog, as you said'],
         'The list above: each Mega Stone close to its giver (Cynthia\'s Garchomp, Riley\'s Lucario, Candice\'s town\'s '
         'Froslass, Wake\'s water, an Excadrill for the hiker who smashes rocks). Swap any for a TM if you prefer; '
         'say which.'),
    ]),
]

# The owner's answers of Nov 6, 2026, to the 23 questions (by their numbers), with who's on each and where it stands
ANSWERED = [
    (1, 'Platinum\'s opening', 'The first ship lands in Canalave City; Rowan meets you there and invites you to his lab, '
     'where you may choose a Sinnoh starter. The people blocking Canalave City from Jubilife City go. Sinnoh\'s HM '
     'givers give TMs or Mega Stones (the reminder above).', 'Claude, planned'),
    (2, 'The ways to Kanto and Sinnoh', 'The Rapid Ferry: a fast S.S. Aqua with no passengers to battle, Vermilion or '
     'Olivine to Canalave; Canalave\'s Iron Island boat also rushes you to Olivine or Vermilion; every Rapid Ferry '
     'trip uses the Iron Island boat\'s animation.', 'Claude, planned'),
    (3, 'The level curve', 'Keep it. Byron\'s gym may need lower levels now that Canalave City opens first.',
     'Kept; Byron next to check'),
    (4, 'Cynthia', 'Keep her hard; a good matchup wins.', 'Done'),
    (5, 'The land between', 'Keep it empty.', 'Done'),
    (6, 'Field moves', 'An HM earned in Johto works everywhere.', 'Works this way now'),
    (7, 'The photo album', 'Port it; every HeartGold feature gets ported, used or not.', 'Claude, planned'),
    (8, 'The Pokéathlon', 'Port it too.', 'Claude, planned (the biggest port)'),
    (9, 'HeartGold\'s key items', 'Port all three: the Berry Pots, the Unown Report, the Dowsing Machine.',
     'Claude, planned'),
    (10, 'Trade evolutions', 'Trade items work from the bag like stones; trade evolutions with no item become level-up '
     'evolutions.', 'Claude, planned'),
    (11, 'Whirlpool and Defog', 'Whirlpool is HM05; Defog is a new HM09 where Platinum has it; HMs can be forgotten '
     'without the Move Deleter.', 'Claude, planned'),
    (12, 'The Town Map', 'The Cherrygrove City guide gives it; Jubilife\'s Trainers\' School gives a Mega Stone '
     'instead. Fly to and from the Sinjoh Ruins, all over Sinnoh and Johto, once unlocked.', 'Claude, planned'),
    (13, 'The Pal Parks', 'Regional forms: Sinnoh\'s Paldea and Hisui, Kanto\'s Alola and Galar.', 'Claude, planned'),
    (14, 'Link play', 'Later, when nothing else is left; out of the build for now.', 'Later'),
    (15, 'Event-only encounters', 'As Sacred Gold has them.', 'Claude, planned'),
    (16, 'Following Pokémon', 'Turned off; the code stays.', 'Playtest session'),
    (17, 'A follower with no sprite', 'Moot.', 'Done'),
    (18, 'Badges on the Trainer Card', 'All 24, Johto, Kanto, Sinnoh, each in its own art; a preview for you.',
     'Claude, next'),
    (19, 'The Town Map\'s art', 'You\'ll draw new maps.', 'Yours'),
    (20, 'The Pledges', 'A tutor teaches them to the starters, with the combinations; Pokémon Champions\' rules and '
     'learnsets.', 'Claude, planned'),
    (21, 'The Pokégear\'s fly map', 'Fly is Platinum\'s; the Pokégear\'s fly map goes.', 'Claude, planned'),
    (22, 'Your playthrough', 'Started; bugs go to the playtest session (docs/PlaytestIssues.md).', 'Playtest session'),
    (23, 'The game to play', 'An .xdelta patch.', 'Done (playtest session)'),
]

# Since yesterday: the latest work, from docs/Progress.md (Nov 2-3)
RECENT = [
    ('Your Nov 6 question: the Pledges and Ally Switch', [
        'Ally Switch works now. It did nothing (Splash\'s effect); in a double battle the user and its ally now trade '
        'places, each taking its own HP, stats and effects along, and the foes\' moves hit whoever stands where they '
        'aimed. Screenshots and an animation: Gallery tab, "New in the game". Used twice in a row it may fail, as in '
        'the newest games.',
        'The Pledge moves are plain hits that nothing learns: your call on the Questions tab.',
    ]),
    ('Sovereign\'s own tests, rerun', [
        'The gifts (45 of 45) and the rare wild Pokémon (26 of 26) pass, with Sinnoh\'s levels after Kanto. A Paradox '
        'Pokémon from the Mining Museum now comes at the level of the one you show, not moved up to Sinnoh\'s.',
        'The battle mechanics suite: two test-build changes of ours had thrown off 57 of its 526 battles (none in the '
        'game itself); both fixed, and those battles are being replayed.',
        'Five of Sovereign\'s roamers roam Johto and Kanto since Nov 1, so Complete\'s roamers test now looks for them '
        'there.',
    ]),
    ('Your Nov 5 calls, done', [
        'One Town Map for all three regions: Sinnoh as Platinum shows it, and Johto and Kanto from HeartGold\'s map '
        'beside it on one map you scroll across. L and R switch regions; the D-pad crosses over at the edges. Fly '
        'from the party menu opens it everywhere and only flies within the region you\'re in (Johto and Kanto both '
        'reach the Indigo Plateau and Mt. Silver). Its emulator test flies around Johto, Kanto and Sinnoh as a player '
        'would: 33 of 33 checks pass. Screenshots: Gallery tab, "New in the game".',
        'The Gallery tab: click a town or route on the region maps to see its photos, and every gym leader, Elite '
        'Four member and champion has a battle (all 35, 34 to 55 shots each), and all 230 places in the three '
        'regions have their photos, up to 30 each.',
        'The Sinjoh Ruins: yes, Sacred Gold\'s plates event plays (the Unown circle, Arceus\'s cinematic, the '
        'battle), and its test passes. HeartGold\'s Arceus egg for Cynthia was an event distribution, so it\'s out.',
    ]),
    ('Fixes', [
        'A crash right after choosing your starter from Rowan\'s briefcase on Route 201 is fixed: the Pokégear\'s phone '
        'list was taking 15 KB of the memory the map needs as it comes back, so a sprite didn\'t fit and the game '
        'crashed. The Pokégear keeps its list in its own memory now.',
        'HeartGold\'s doors, shutters and boxes look like HeartGold\'s: the door at the top of Olivine Lighthouse (a '
        'big black box hid Jasmine and Amphy there), the locked doors in the Radio Tower, the warehouse and the Rocket '
        'Hideout, Goldenrod Tunnel\'s shutters, the Elite Four\'s doors and the Ruins of Alph\'s walls.',
    ]),
    ('More of HeartGold', [
        'The Route 34 Day Care\'s yard: the Pokémon you leave there stand in the yard beside the house, as in '
        'HeartGold, and leave when you take them back.',
        'The lamp at the top of Olivine Lighthouse comes back on once Amphy has had the SecretPotion: HeartGold\'s '
        'scene, its lamp turning and shining to a rising hum, the screen white, and back.',
        'Cerulean Gym\'s pool and the Lugia cave keep their own music while you surf, as in HeartGold; Mystery Gift '
        'unlocks with the Pokédex at Mr. Pokémon\'s; the Ruins of Alph\'s Unown line shows; Flash at the Omanyte '
        'wall shows your Pokémon\'s cut-in.',
        'All sixteen of Arceus\'s plates can be found: a test takes each one from its giver, pile or spot. On the way, '
        'Sacred Gold\'s hidden piles were fixed: Pewter City had a Cynthia standing where the Stone Plate\'s dirt pile '
        'should be, the Sinjoh Ruins a Snorlax for its snow pile, and the Kanto Snorlax three little boys around it. '
        'They\'re mounds of dirt and snow now, as in Sacred Gold.',
        'Every one-time Pokémon in Sacred Gold\'s event guide works: a new test meets each one (Rotom, Spiritomb, the '
        'shiny pseudo-legends, Lapras on Fridays, Kanto\'s birds, Mewtwo, Mew after its three teleports, Celebi, '
        'Jirachi and Shaymin with the Azure Flute, the Regis and Regigigas, Latios, Groudon, Kyogre and Rayquaza, '
        'Deoxys late at night, the lake and creation trios, Heatran, Cresselia and Darkrai) and checks its level, that '
        'none comes before its time, and the steps that open the way (the nightmare, the Regis\' tablet, the Azure '
        'Flute trade, the Magma Stone). 42 of 42 pass; nothing needed fixing.',
        'The Pokégear sounds like HeartGold\'s: its own clicks for the app bar, the cursor, picking and backing out, '
        'the map, and the phone\'s ring, dialing tone and hang-up.',
        'Baoba calls on the Pokégear about the Safari Zone, as in HeartGold: his next test, the objects you can place '
        '(a group at a time), and which areas have new Pokémon, by name.',
        'The Bug-Catching Contest\'s battles have HeartGold\'s own bottom screen: a BALL button that throws a Sport '
        'Ball, and above the menu the bug net, the Sport Balls left and the Pokémon you\'ve kept so far (its icon, '
        'gender and level).',
        'HeartGold\'s own Balls look like themselves now: the seven Apricorn Balls (and the contest\'s Sport Ball) fly '
        'in their own colours when thrown or sent out, and the summary screen shows each one\'s own icon, as in '
        'HeartGold. They had all looked like Poké Balls.',
        'HeartGold\'s own sound effects play in Johto and Kanto: the Clear Bell\'s rings, Ho-Oh\'s and Lugia\'s wings, '
        'the Whirl Islands\' falls, the Rocket Hideout\'s traps and siren, the Magnet Train on its rails, Voltorb '
        'Flip\'s cards and coins, the Ruins of Alph\'s panels, Mahogany\'s sliding ice, and the 185 sounds Sacred '
        'Gold\'s scripts play. Each loads as it plays and frees its memory when it ends.',
        'The Ruins of Alph\'s walls: reading a chamber\'s north wall shows its Unown words on HeartGold\'s stone tablet '
        '(ESCAPE, LIGHT, WATER, HO OH), and the rooms behind open as in HeartGold: an Escape Rope, Flash or a Water '
        'Stone used facing the wall, or reading Ho-Oh\'s with Ho-Oh in your party. Each room holds four items that '
        'couldn\'t be reached before.',
        'Lance takes off from the Lake of Rage as in HeartGold: in Fly\'s cut-in he sends out his Dragonite, then the '
        'bird swoops down and carries him off, using HeartGold\'s own graphics of Lance riding.',
        'The Bike Shop calls once you\'ve ridden 1,024 steps on the bike, as in HeartGold.',
        'The Day-Care Man asks, after his first Egg, whether he should keep calling about Eggs, as in HeartGold (he had '
        'been calling about every one).',
        'The Sinjoh Ruins\' event (all 16 plates and the National Pokédex) plays as in HeartGold: the Unown\'s circle '
        'spins up on the Mystri Stage, then HeartGold\'s Arceus cinematic, half a minute of its own art and music, '
        'with your Arceus in its own form if it leads your party.',
        'Ho-Oh and Lugia have HeartGold\'s own cinematics now: the Clear Bell\'s rings of light, then Ho-Oh flying in '
        'around the Bell Tower to its theme; and Lugia rising through the Whirl Islands\' waterfall, the picture '
        'trailing as it cries.',
        'In the Radio Tower takeover you wear HeartGold\'s Rocket uniform, from Goldenrod Tunnel until the director '
        'takes it back, and as in HeartGold you can\'t Fly, Surf, ride the Bicycle, fish or use an Escape Rope in it.',
        'The Pokégear\'s Map and Radio come with their cards, as in HeartGold: the Map Card from Cherrygrove\'s guide, '
        'the Radio Card from the Radio Tower\'s quiz.',
        'The Rocket Hideout\'s traps go off under you before their battles (sparks, a gas cloud, falling rocks), and '
        'its Persian statues\' alarm turns the screen red, as in HeartGold. The monks in the Bell Tower and the Whirl '
        'Islands show their wings again, and their scenes after the wing play now. Lance takes off from the Lake of '
        'Rage with his Dragonite in a cut-in.',
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
    ('Fly and the Town Map', 'One Town Map shows Sinnoh, Johto and Kanto; scroll from one to the others. Fly stays in '
     'the region you\'re in (Johto and Kanto both reach the Indigo Plateau and Mt. Silver), and the ferries join them.'),
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


GALLERY = os.path.join(ROOT, '.cache', 'gallery')
GALLERY_OUT = 'gallery'  # beside the page: the sheets and maps it shows
SHEET_COLS = 6
SINNOH_NAMES = {'TwinleafTown': 'Twinleaf Town', 'MtCoronet': 'Mt. Coronet', 'PokemonLeague': 'Pokémon League',
                'GreatMarsh': 'Great Marsh', 'SpearPillar': 'Spear Pillar', 'ValleyWindworks': 'Valley Windworks'}


def sheet(files, size, out):
    """The shots side by side in one image, SHEET_COLS a row (rebuilt when a shot is newer)."""
    from PIL import Image
    if os.path.exists(out) and os.path.getmtime(out) >= max(os.path.getmtime(f) for f in files):
        return
    rows = (len(files) + SHEET_COLS - 1) // SHEET_COLS
    im = Image.new('RGB', (SHEET_COLS * size[0], rows * size[1]))
    for i, f in enumerate(files):
        im.paste(Image.open(f).convert('RGB').resize(size), ((i % SHEET_COLS) * size[0], (i // SHEET_COLS) * size[1]))
    im.save(out, quality=82, optimize=True)


def gallery(out_dir):
    """The gallery tab's data: each region map with its places, each place's and boss's sheet of shots (from
    tools/complete/gallery_shots.py and render_region_maps.py), the sheets and maps written beside the page."""
    import shutil
    import gallery_shots
    dest = os.path.join(out_dir, GALLERY_OUT)
    os.makedirs(dest, exist_ok=True)
    maps_dir = os.path.join(ROOT, '.cache', 'maps')
    regions = json.load(open(os.path.join(maps_dir, 'places.json'))) if os.path.exists(
        os.path.join(maps_dir, 'places.json')) else {}
    maps_out = {}
    for name in regions:
        shutil.copyfile(os.path.join(maps_dir, name + '.png'), os.path.join(dest, name + '.png'))
        from PIL import Image
        w, h = Image.open(os.path.join(maps_dir, name + '.png')).size
        maps_out[name] = {'img': f'{GALLERY_OUT}/{name}.png', 'w': w, 'h': h, 'places': regions[name]}
    places = {}
    for folder in sorted(glob.glob(os.path.join(GALLERY, 'shots', '*', 'index.json'))):
        key = os.path.basename(os.path.dirname(folder))
        index = json.load(open(folder))
        label = index['label']
        files = [os.path.join(os.path.dirname(folder), s['file']) for s in index['shots']]
        if not files:
            continue
        sheet(files, (256, 192), os.path.join(dest, key + '.jpg'))
        hg = key.startswith('hgss_')
        places[key] = {'name': place_name(label) if hg else SINNOH_NAMES.get(label, place_name(label)),
                       'region': ('kanto' if label in KANTO else 'johto') if hg else 'sinnoh',
                       'kind': kind_of(label), 'sheet': f'{GALLERY_OUT}/{key}.jpg', 'count': len(files),
                       'maps': [s['header'].replace('MAP_HEADER_', '').replace('HGSS_', '').replace('_', ' ').title()
                                for s in index['shots']]}
    bosses = []
    info = gallery_shots.map_headers()
    for boss, trainer, header in gallery_shots.BOSSES:
        slug = re.sub(r'\W+', '_', boss).strip('_').lower()
        index_path = os.path.join(GALLERY, 'battles', slug, 'index.json')
        label = info.get(header, (None,))[0]
        hg = header.startswith('MAP_HEADER_HGSS_')
        entry = {'name': boss, 'region': ('kanto' if label in KANTO else 'johto') if hg else 'sinnoh',
                 'place': gallery_shots.place_key(header, label), 'count': 0}
        if os.path.exists(index_path):
            shots = json.load(open(index_path))['shots']
            files = [os.path.join(os.path.dirname(index_path), s['file']) for s in shots]
            if files:
                sheet(files, (256, 384), os.path.join(dest, 'battle_' + slug + '.jpg'))
                entry.update(sheet=f'{GALLERY_OUT}/battle_{slug}.jpg', count=len(files))
        bosses.append(entry)
    # New features, from their emulator tests' screenshots (both screens), each with a caption
    features = []
    for index_path in glob.glob(os.path.join(GALLERY, 'features', '*', 'index.json')):
        index = json.load(open(index_path))
        slug = os.path.basename(os.path.dirname(index_path))
        files = [os.path.join(os.path.dirname(index_path), s['file']) for s in index['shots']]
        sheet(files, (256, 384), os.path.join(dest, 'feature_' + slug + '.jpg'))
        feature = {'name': index['name'], 'order': index.get('order', 99), 'count': len(files),
                   'sheet': f'{GALLERY_OUT}/feature_{slug}.jpg', 'caps': [s['caption'] for s in index['shots']]}
        if index.get('anim'):  # an animation of it, shown as it is
            shutil.copyfile(os.path.join(os.path.dirname(index_path), index['anim']),
                            os.path.join(dest, f'feature_{slug}.gif'))
            feature.update(anim=f'{GALLERY_OUT}/feature_{slug}.gif', animCaption=index.get('anim_caption', ''))
        features.append(feature)
    features.sort(key=lambda f: f['order'])
    return {'maps': maps_out, 'places': places, 'bosses': bosses, 'features': features, 'cols': SHEET_COLS}


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
        'answered': [dict(zip(('n', 'q', 'answer', 'status'), a)) for a in ANSWERED],
        'questions': [{'group': g, 'items': [dict(zip(('q', 'now', 'options', 'proposal'), q)) for q in qs]}
                      for g, qs in QUESTIONS],
        'recent': [{'title': t, 'items': items} for t, items in RECENT],
        'places': sorted(places.values(), key=lambda p: (p['region'], p['kind'] != 'town', p['name'])),
        'regions': regions, 'overworld': overworld, 'story': story, 'timeline': timeline(), 'sinnoh': sinnoh(),
        'gallery': gallery(os.path.dirname(os.path.abspath(out))),
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
