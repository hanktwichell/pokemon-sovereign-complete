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

UPDATED = 'Nov 6, 2026'

# The roadmap's steps (docs/Roadmap.md) and where each stands: status is one of done, mostly, active, waiting, ready,
# later
STEPS = [
    (0, 'Before starting', 'done', 'Done',
     'You answered all 23 open questions on Nov 6 (the Questions tab has each answer and where it stands). Sovereign '
     'Platinum is still being finished; its new work comes in by the sync script (none newer than Oct 29 so far).'),
    (1, 'Groundwork', 'done', 'Done',
     'The project builds and boots with the bigger save (2,250 more story markers), and the conversion tools work.'),
    (2, 'Maps', 'done', 'Done',
     'All 540 Johto and Kanto maps are in, with collision, connections, props and animations; every one loads in the '
     'visit-every-map test. Your new map art comes later (answer 19).'),
    (3, 'Events and scripts', 'done', 'Done',
     'HeartGold\'s and Sacred Gold\'s scripts are translated; the talk test ran all 5,865 people and signs to their end, '
     'and the step-on triggers pass.'),
    (4, 'Sacred Gold\'s content', 'done', 'Done',
     '737 trainers, wild Pokémon by time of day, items, hidden items, gifts, trades and marts, rebuilt on Sovereign\'s '
     '1025 Pokémon.'),
    (5, 'HeartGold features', 'active', 'In progress',
     'In: the phone, Mom\'s savings, Apricorn Balls, the Bug-Catching Contest, the Safari Zone, roamers, gym puzzles, '
     'the Johto Pokédex, Voltorb Flip, Johto\'s Battle Frontier, the Pokégear (phone, map, radio), the Magnet Train, '
     'the legendaries\' cutscenes, the photo album, the Berry Pots, the Unown Report. Following Pokémon are built but '
     'turned off (your call). Still to port (answers 8, 9): the Pokéathlon and the Dowsing Machine; link play '
     'later.'),
    (6, 'Music', 'done', 'Done', 'Johto\'s and Kanto\'s songs play on their maps, in the sound memory that was full, '
     'and HeartGold\'s own sound effects play in its scenes and scripts.'),
    (7, 'Joining the world', 'active', 'In progress',
     'Done: a new game plays from New Bark Town through Johto, Kanto and Sinnoh to the Hall of Fame; one Town Map of '
     'three regions; Sinnoh\'s levels after Kanto; Totems, legendaries and Megas in all three regions; Ally Switch. '
     'Done Nov 6 from your answers: the player is Ethan (or Dawn); the Indigo Plateau\'s two-and-two Elite Four; '
     'trade evolutions from the bag; Whirlpool HM05 and Defog HM09; Sinnoh entered at Canalave City (Rowan and his '
     'starter); the Town Map from Cherrygrove; Mega Stones from Sinnoh\'s HM givers; no following Pokémon; '
     'Showdown\'s icons. To do: people where Sinnoh\'s HMs held the player back, the Rapid Ferry, Fly to the Sinjoh '
     'Ruins, the Pal Parks\' regional forms, 24 badges on the Trainer Card, the starters\' Pledge tutor.'),
    (8, 'Automated testing', 'active', 'In progress',
     'Complete\'s 40 feature tests and 8 long ones (the story test plays the whole game), and Sovereign\'s own suites, '
     'rerun Nov 6: battle mechanics 526 of 526 plus Ally Switch\'s 2, gifts 45 of 45, rare wild Pokémon 26 of 26, '
     'roamers by region.'),
    (9, 'Your playthrough', 'active', 'Under way',
     'You started on Nov 5 with the playtest patch (an .xdelta for a clean Platinum). Your notes go to the playtest '
     'session, which keeps docs/PlaytestIssues.md: 6 fixed so far, 10 open.'),
    (10, 'Release', 'later', 'Later', 'Final fixes after your playthrough, then the .xdelta patch (the playtest '
     'patch already works this way).'),
]

NEXT = [
    'Now: HeartGold\'s ports (the album, the Berry Pots and the Unown Report are in; next the Dowsing Machine, then '
    'the Pokéathlon), and the Sinnoh story run, now past Lake Verity.',
    'Then: the Trainer Card with all 24 badges (waiting on your look at the preview), and taking the Pokégear\'s '
    'old Fly map out.',
]

WAITING = [
    ('The Town Map\'s art', 'You\'ll draw new maps (answer 19); the one in the game until then is made from the two '
     'games\' own maps.'),
    ('Your playtest notes', 'Keep sending them; the playtest session works through them (docs/PlaytestIssues.md), and '
     'some wait on you: which starter froze the game in Elm\'s lab, and your save from the S.S. Aqua\'s black screen.'),
    ('The Mega Evolution look', 'You said you\'ll redo the stone shown on screen; the animation and icon wait on that.'),
]

# Every question waiting on the owner, numbered, for the "Your questions" tab: (group, [(question, what the game does
# now, the options, Claude's proposal or None)]). Kept in step with docs/Roadmap.md's "Still open".
QUESTIONS = [
    ('From Nov 6 (pictures on the Gallery tab, "Your call")', [
        ('The Trainer Card with all 24 badges: is the preview\'s layout right?',
         'Platinum\'s card: the 8 Sinnoh leaders on its bottom screen.',
         ['Two pages, L and R between them: HeartGold\'s League Badges page (Johto and Kanto, as HeartGold shows it) '
          'and Platinum\'s Sinnoh page (the preview)',
          'Three pages, one per region',
          'Something else'],
         'Two pages, as in the preview: each game\'s own page, as its players know it.'),
        ('Box and party icons from Pokémon Showdown: go ahead?',
         'Placeholder icons for #494 to 1025 (PokeAPI\'s); forms show their base Pokémon\'s icon.',
         ['Showdown\'s for #494 to 1025 and every form, in the DS\'s three shared icon palettes (the sample\'s middle '
          'column)',
          'That, and more icon palettes so the colours stay true (more work: each screen that draws icons)',
          'Keep the placeholders'],
         'Showdown\'s for all of them now; more palettes later if the colours bother you.'),
        ('Jubilife\'s Trainers\' School: which Mega Stone does Barry\'s parcel hold, now that the Town Map comes from '
         'Cherrygrove City?',
         'Altarianite for now (Swablu is in Sinnoh, and no other gift or item ball has it; Bebe\'s shop sells it).',
         ['Altarianite', 'Heracronite, for Barry\'s Heracross (Ilex Forest already has one)', 'Another stone'],
         'Altarianite: a stone no other gift gives.'),
        ('The Pal Parks: Sinnoh\'s has 22 kinds (all of Hisui\'s and Paldea\'s forms), Kanto\'s 37 (Alola\'s and '
         'Galar\'s). Even them out?',
         'Every regional form is in one of the parks; Hisui and Paldea just have fewer forms.',
         ['Leave it', 'Add Hisui\'s new species to Sinnoh\'s park (Wyrdeer, Kleavor, Ursaluna, Sneasler, Overqwil, '
          'Basculegion: 28 kinds)', 'Something else'],
         'Leave it: the parks hold the forms, and Hisui\'s new species evolve from Pokémon found in the wild.'),
    ]),
]

# The owner's notes to remember (things they asked to have written down), shown on the Questions tab
OWNER_NOTES = [
    ('Nov 6', 'People where Sinnoh\'s HMs would have blocked the way: the player brings every HM from Johto and '
     'Kanto, so each Cut tree, rock, water, boulder, cliff and waterfall that kept Platinum\'s story in order needs '
     'someone standing in the way until the story gets there. On Claude\'s list: first a list of every such place.'),
    ('Nov 6', 'The Elite Four\'s rematch teams should be slightly better than their first teams (both Leagues). '
     'Not done yet; on the list for when the teams are reviewed.'),
    ('Nov 6', 'Make sure every sprite in Sovereign Platinum has been ported to Sovereign Complete (Pokémon fronts, '
     'backs and forms, icons, trainers, overworld). On Claude\'s list.'),
    ('Nov 6', 'Sinnoh\'s top levels: with Roark\'s ace at Lv. 72, Cynthia\'s first ace about 88 to 90, her '
     'rematch\'s 96; aces a level over their teams, but the Elite Four\'s rematches and Sovereign\'s trainer flat. '
     'Done: Roark 71 (ace 72), Cynthia 88 (ace 89), her rematch 95 (ace 96), the Elite Four 86 to 88, their rematches '
     'flat at 93 to 95.'),
    ('Nov 6', 'The player: Ethan or Dawn. The boy is HeartGold\'s Ethan (overworld, battle back, front picture), the '
     'girl stays Platinum\'s Dawn. Rowan\'s assistant stays Lucas or Dawn; Johto\'s friend stays Lyra or Ethan. '
     'In progress.'),
    ('Nov 6', 'The Totems\' overworld sprites should look like the other overworld Pokémon (Dialga, Palkia, Uxie), not '
     'shrunk battle sprites as now, and stay large to show their size. Not done yet.'),
    ('Nov 6', 'Box, PC and party icons from Pokémon Showdown\'s collection: to replace the placeholder icons '
     '(#494 to 1025) and fill in forms. A sample sheet first, for you to look at.'),
]

# Anything that looked off in Claude's tests or screenshots, logged for the owner to look at, even when it may be
# nothing (the owner's rule, Nov 6, 2026): (date, where, what Claude saw, a screenshot in .cache/gallery/issues or
# None, status: new, looking, fixed, explained, yours)
POSSIBLE_ISSUES = [
    ('Nov 6', 'Kanto\'s Pal Park: the Galarian birds\' level',
     'Kanto\'s park keeps Sovereign\'s levels (40-55, 60, and 70 for the Galarian birds, 1% each). With Kanto\'s caps '
     'at 61-70, a Galarian bird caught there is above the cap until Blue. Maybe nothing (the cap stops experience, not '
     'catching); say if Kanto\'s park should have levels of its own.', None, 'yours'),
    ('Nov 6', 'Rowan\'s lab: a corner of Sandgem Town',
     'In the lab, the top-right corner of the screen shows a strip of Sandgem Town outside (a sign and a house\'s '
     'wall) where the rest of the room\'s edge is black. It was there in the Nov 5 story run too, before today\'s '
     'changes. To look into: the lab map\'s camera bounds, or Platinum\'s own.', 'rowan_lab_corner.jpg', 'looking'),
    ('Nov 6', 'Battles with Johto\'s and Kanto\'s trainers',
     'Every trainer class that\'s only in HeartGold (68 of them: Falkner, Whitney, Lance, Brock and the rest) was drawn '
     'as dots in battle. It shows in Claude\'s own gallery shots from Nov 5, which Claude published without seeing it; '
     'you found it in your playtest. The playtest session fixed it (the pictures were 4-bit PNGs the build read as '
     '8-bit). Claude is checking all 68 again on today\'s build, and retaking the gallery\'s boss battles.',
     'trainer_dots.jpg', 'fixed'),
    ('Nov 6', 'The player in Johto and Kanto',
     'The player is Platinum\'s Lucas (or Dawn) everywhere, in Johto\'s battles too, not HeartGold\'s Ethan or Lyra. '
     'Your call (Nov 6): the boy becomes Ethan, the girl stays Dawn. Done for the field (every pose), battles (his back '
     'and throw), Fly\'s rider and the Hall of Fame: Gallery tab, "The player: Ethan". Still Lucas: the Trainer Card, '
     'the intro\'s pictures and the Town Map\'s head (next).', 'trainer_dots.jpg', 'fixed'),
    ('Nov 6', 'The following Pokémon over the player',
     'In the shots of Ethan running, the following Pokémon (the test party\'s Garchomp) is drawn over the player for a '
     'few steps when he turns while running, hiding him. Moot once the following Pokémon are turned off (your call; '
     'the playtest session\'s issue 1).', 'follower_over_player.jpg', 'explained'),
    ('Nov 6', 'The walk test: steps refused inside buildings',
     'The walk test (all of Johto\'s and Kanto\'s maps, 79 of 518 so far) logged steps the game refused onto tiles the '
     'map says are open, on 24 maps, mostly in Pokémon Centers and houses. In every shot of one the following Pokémon '
     'stands beside the player, and people walk about, so they may be what blocked the step; being checked tile by '
     'tile. No hangs so far.', 'walk_refused_steps.jpg', 'looking'),
    ('Nov 6', 'Celadon Condominiums\' right elevator',
     'The walk test\'s warp into it left the player at (4, -32), outside the map, where the left elevator\'s put them '
     'on its floor. To look into: the map\'s arrival point may be wrong.', None, 'looking'),
    ('Nov 6', 'The player\'s name at a battle\'s end',
     'In the recording of your team against Cynthia, the win reads "Player defeated Champion Cynthia!" but the prize '
     'reads "A got $31200 for winning!": two names for the player (the test save\'s is A). Checked: "Player '
     'defeated" is Platinum\'s own line (BattleStrings_Text_PlayerDefeatedLinkTr reads "Player defeated {trainer}!" '
     'in the game\'s text), not the player\'s name; HeartGold says the same. Say if you\'d like the player\'s name '
     'there instead.', None, 'explained'),
    ('Nov 6', 'Your team against Cynthia, recorded',
     'Mega Evolution works: Charizardite Y reacts to the Mega Ring on turn 1, Drought brings the sun, Heat Wave takes '
     'Roserade and Spiritomb; Cynthia\'s double battle won in 6 turns (her Garchomp\'s Stone Edge took Mega Charizard). '
     'Nothing else looked off.', None, 'explained'),
    ('Nov 6', 'Mega Charizard Y\'s back sprite',
     'In the recording of your team against Cynthia, Claude thought Charizard kept its normal back sprite after Mega '
     'Evolving, and was about to call it a bug. You checked: it is the Mega\'s own back (the two are close: the Mega '
     'has a spikier crest). Not an issue; Claude misread the screenshot.', None, 'explained'),
    ('Nov 6', 'Sinnoh\'s aces level with their teams',
     'Sovereign gives each boss\'s ace a level more than the rest; the level plan\'s top end made the two land on the '
     'same level (Cynthia\'s six all Lv. 89). Your call: aces a level over their teams everywhere but the Sinnoh '
     'Elite Four\'s rematches and Sovereign\'s trainer, which are flat. Done: Roark 71 with his ace 72, Cynthia 88 '
     'and 89, her rematch 95 and 96, the Elite Four\'s rematches all at one level (93 to 95).', None, 'fixed'),
    ('Nov 6', 'Falkner\'s six Poké Balls',
     'The battle\'s ball indicator shows six for Falkner: Sacred Gold gives him six Pokémon. As Sacred Gold has it; '
     'listed in case it looks wrong to you.', None, 'explained'),
]

# The owner's answers of Nov 6, 2026, to the 23 questions (by their numbers), with who's on each and where it stands
ANSWERED = [
    (1, 'Platinum\'s opening', 'The first ship lands in Canalave City; Rowan meets you there and invites you to his lab, '
     'where you may choose a Sinnoh starter. The people blocking Canalave City from Jubilife City go. Sinnoh\'s HM '
     'givers give Mega Stones (confirmed): Cynthia in Eterna Garchompite Z, the Galactic Warehouse Staraptite, '
     'Celestic Town\'s elder Galladite, Riley Lucarionite, the Oreburgh Gate hiker Excadrite, Crasher Wake '
     'Sharpedonite, Snowpoint Temple Froslassite; Defog stays as HM09.', 'Claude, planned'),
    (2, 'The ways to Kanto and Sinnoh', 'The Rapid Ferry: a fast S.S. Aqua with no passengers to battle, Vermilion or '
     'Olivine to Canalave; Canalave\'s Iron Island boat also rushes you to Olivine or Vermilion; every Rapid Ferry '
     'trip uses the Iron Island boat\'s animation.', 'Claude, planned'),
    (3, 'The level curve', 'Keep it. Byron\'s gym may need lower levels now that Canalave City opens first.',
     'Kept; Byron next to check'),
    (4, 'Cynthia', 'Keep her hard; a good matchup wins.', 'Done'),
    (5, 'The land between', 'Keep it empty.', 'Done'),
    (6, 'Field moves', 'An HM earned in Johto works everywhere.', 'Works this way now'),
    (7, 'The photo album', 'Port it; every HeartGold feature gets ported, used or not.', 'Done'),
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
    ('HeartGold\'s Unown Report (your answer 7)', [
        'The Unown Report the researchers give in the Ruins of Alph now opens (from the bag or on Y): HeartGold\'s book '
        'across both screens, its cover, the Unown you\'ve seen with their icons and words, and the researchers\' '
        'reports, one more each time they find something. HeartGold\'s code for it was never decompiled, so it was '
        'written in C from its machine code. Tested in the emulator: 0 problems. Pictures: Gallery tab.',
        'On the way: HeartGold\'s centred and right-aligned text now shows that way (Platinum\'s text printer didn\'t '
        'know those codes), so Voltorb Flip\'s headings and the report\'s cover are centred as in HeartGold.',
        'Also fixed: in Sinnoh, Mars at Lake Verity could never be reached (a step of Platinum\'s opening was left '
        'unmarked when Sinnoh\'s opening moved to Canalave). The story test now gets past it.',
    ]),
    ('HeartGold\'s Berry Pots (your answer 7)', [
        'The Berry Pots the girl on Route 36 gives now work: from the bag or on Y, HeartGold\'s screen of four pots. '
        'FERTILIZE and PLANT BERRY open the bag at its Items or Berries pocket; WATER (the watering can) and TAKE '
        'BERRIES work too. They grow by HeartGold\'s rules, by the time since you last looked. Old saves still load. '
        'Tested in the emulator: 0 problems (Mulch and an Oran Berry planted, watered, grown to Berries, picked). '
        'Pictures: Gallery tab.',
        'Found and fixed on the way: the screen froze the game as it closed (a sprite cleanup freed memory it never '
        'had, which overwrote the system\'s interrupt handler), the soil drew black (a palette setting the two games '
        'treat differently), and a new game left junk Berries in the pots\' save space (an old Platinum overrun; the '
        'pots now empty themselves the first time).',
    ]),
    ('HeartGold\'s photo album (your answer 7)', [
        'Cameron the photographer takes your photo at HeartGold\'s 66 spots: the place with only you and your '
        'party in it, the viewfinder, the shutter. The Pokémon Center\'s PC has a PHOTO ALBUM (under your PC) with '
        'HeartGold\'s album: view, move or delete a photo; a photo viewed shows the place again as it was, at the hour '
        'it was taken, with its caption on the bottom screen. Old saves still load (the album has its own space). '
        'Tested in the emulator: 0 problems. Pictures: Gallery tab.',
        'Found and fixed on the way: a crash as a photo showed (a font the field never loads), the PC\'s entry '
        'reading "RULES", coming back at the Pokémon Center\'s door instead of the PC, and a sprite setting with '
        'different meanings in the two games (also in Voltorb Flip and Arceus\'s cinematic).',
        'The Sinnoh story test had stopped at Canalave: its check still expected the gate policeman\'s Tea from '
        'before Canalave opened first. Fixed; the run is going again.',
    ]),
    ('Your Nov 6 calls, done', [
        'Trade evolutions without trading: Metal Coat and the other trade items work like stones from the bag; '
        'Kadabra, Machoke, Graveler and Haunter also evolve at Lv. 37; Sacred Gold\'s Covenant Orb still works. Tested '
        'through the bag\'s menus: 22 of 22.',
        'HM05 is Whirlpool (HeartGold\'s list of who learns it), Defog a new HM09 where Platinum had its HM05. HM moves '
        'were already forgettable. Tested: 6 of 6.',
        'Sinnoh begins in Canalave City: Rowan and his assistant meet you on the dock; his briefcase is in the Sandgem '
        'lab; nothing blocks the way to Jubilife; Barry\'s Parcel comes from Rowan. Tested by the ferry test (16 of 16) '
        'and the story test through Roark\'s mine. Pictures: Gallery tab.',
        'The Town Map from Cherrygrove\'s Guide Gent; Barry\'s parcel holds Altarianite (your call: Questions tab).',
        'Sinnoh\'s HM givers give your Mega Stones. Found on the way: Snowpoint\'s Regigigas story counted HM08 in '
        'the bag as Candice being done, so the HM08 you bring from Kanto skipped it; fixed.',
        'No following Pokémon: off, the code kept.',
        'Showdown\'s box icons for all 1025 species, and each of the 383 forms its own.',
        'The Rapid Ferry: the trips other than the S.S. Aqua\'s cruise.',
        'The Pal Parks: Kanto\'s by Fuchsia City (open from the start, no Catching Show: walk in and catch) has '
        'Alola\'s forms in the west and Galar\'s in the east, its water forms in the pond and lake; Sinnoh\'s, on '
        'Route 221, has Hisui\'s in the north and Paldea\'s in the south. Every regional form is in one of them.',
        'Fly to the Sinjoh Ruins once you\'ve been there, from anywhere in Sinnoh or Johto (Mt. Silver and the '
        'Indigo Plateau too), and from the Ruins to Johto or Sinnoh.',
        'Your note: people now stand where Johto\'s HMs would let you skip Sinnoh\'s story (Spear Pillar\'s climb, '
        'Lake Acuity, Eterna Forest by Surf, the Ravaged Path, Mt. Coronet\'s boulder to Celestic), each until the '
        'point Platinum would have let you through. Pictures: Gallery tab.',
        'The Pledges: a tutor in Elm\'s lab teaches every starter (Gen I to IX, every stage) its type\'s Pledge; in '
        'a double battle two different Pledges become one 150-power move that leaves a sea of fire, a rainbow or a '
        'swamp for 4 turns, as in the newer games. Pictures: Gallery tab.',
    ]),
    ('Your Nov 6 call: the Indigo Plateau\'s Elite Four', [
        'Sovereign\'s format at the Indigo Plateau: Will and Koga each ask single or double battle; if both got the '
        'same, Bruno and Karen get the other and Koga tells you so after his battle; otherwise Bruno asks and Karen '
        'takes what\'s left. Lance is always a single battle. With the rematch teams Will first offers all singles, '
        'all doubles, or two and two. One Pokémon able to fight? A double battle warns you first.',
        'Each member\'s double-battle team is their own six, with the doubles AI, and they keep the Elite Four\'s '
        'music in a double battle.',
        'Tested in the emulator: eight full runs through the five rooms, every way the menus can go (singles or '
        'doubles first, the rematch menu\'s three choices, a lone Pokémon answering no), each battle with the right '
        'member, format and team, and won.',
    ]),
    ('Your Nov 6 calls: Ethan, the icons, the Totems', [
        'The boy is now HeartGold\'s Ethan, in every pose the field draws him in: walking, running, the bike, '
        'surfing, fishing, saving and the Pokémon Center\'s counter are HeartGold\'s own art; HeartGold never drew '
        'him raising a Poké Ball, with the Pokétch, watering or with the VS Seeker, so those take Lucas\'s arm and '
        'item onto Ethan. The girl stays Dawn. Rowan\'s assistant keeps Lucas\'s look. In battle Ethan throws with '
        'his own back, and the Hall of Fame shows his picture. Lance and Silver, your partners in HeartGold\'s tag '
        'battles, have their own backs now (they stood there as Lucas). Fly\'s take-off and landing carry HeartGold\'s '
        'own rider for him. Still to do: the intro\'s pictures, the Trainer Card and the Town Map\'s head. Every '
        'texture and shot: Gallery tab, "The player: Ethan".',
        'Pokémon Showdown\'s box and party icons: a sample of 20 is on its way to you. They\'re far better than the '
        'placeholders for Gen 8 and 9, and there are real icons for regional forms and Megas; the DS\'s three shared '
        'icon palettes are what limits the colours.',
        'Your note on the Totems\' overworld sprites is written down (Your notes, on the Questions tab).',
    ]),
    ('Your answers, all 23', [
        'Recorded with who does each: the playtest session takes your playtest notes (and turning the following '
        'Pokémon off); Claude takes the rest. The Questions tab lists every answer with its status; the Mega Stone '
        'gifts for Sinnoh\'s former HM givers are confirmed.',
        'Sinnoh\'s Elite Four already plays Sovereign\'s two-and-two format, Cynthia a double battle; the Indigo '
        'Plateau gets it next, with Lance a single battle.',
        'The plan ahead, with days, is on the Timeline tab.',
    ]),
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
    ('Following Pokémon', 'Built for all three regions, and being turned off (your call, Nov 6); the code stays.'),
    ('The Elite Four', 'Sovereign\'s format: two single and two double battles, picked as you go; Cynthia a double '
     'battle.'),
    ('Fly and the Town Map', 'One Town Map shows Sinnoh, Johto and Kanto; scroll from one to the others. Fly stays in '
     'the region you\'re in (Johto and Kanto both reach the Indigo Plateau and Mt. Silver), and the ferries join them.'),
    ('Sovereign\'s own tests', 'Rerun Nov 6: battle mechanics 526 of 526 (and Ally Switch\'s 2), gifts 45 of 45, rare '
     'wild Pokémon 26 of 26, roamers by region; earlier: evolutions 255 of 255, wild forms on every Sinnoh map, signs '
     'and triggers.'),
]
SINNOH_PLAN = [
    ('Arriving in Sinnoh', 'The first ship to Sinnoh sails to Twinleaf Town and leaves the player in their room, where '
     'Platinum\'s opening plays (tested); Rowan\'s starter goes to the PC when the party is full.', 'done'),
    ('Sinnoh\'s levels', 'Sinnoh\'s trainers, wild Pokémon and gifts moved up to follow Kanto (Roark\'s ace Lv. 72, '
     'Cynthia\'s 89, her rematch 96: your call, Nov 6), from one table of levels, with trainers\' teams evolved to '
     'match.', 'done'),
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
    ('Arriving in Canalave City (your answer 1)', 'The first ship lands in Canalave City; Rowan meets you there and '
     'invites you to his lab, with a Sinnoh starter to choose; the people between Canalave and Jubilife go.',
     'planned'),
    ('The Rapid Ferry (answer 2)', 'Straight from Olivine or Vermilion to Canalave, no passengers to battle, on the '
     'Iron Island boat\'s animation; Canalave\'s Iron Island boat rushes you to Olivine or Vermilion too.', 'planned'),
    ('Mega Stones from the HM givers', 'Cynthia Garchompite Z, the Galactic Warehouse Staraptite, Celestic Town '
     'Galladite, Riley Lucarionite, the Oreburgh Gate Excadrite, Crasher Wake Sharpedonite, Snowpoint Temple '
     'Froslassite; Defog becomes HM09 where Platinum has it (you confirmed).', 'planned'),
    ('Byron\'s levels', 'Checked, and lowered if nothing in the story holds his gym back now that Canalave City is '
     'the way in.', 'planned'),
    ('The Pal Park\'s regional forms', 'Paldea\'s and Hisui\'s forms in Sinnoh\'s Pal Park.', 'planned'),
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
    'Ally Switch, Sovereign\'s tests rerun, and the owner\'s answers': (5, 7, 8),
}
STORY_ENTRY = re.compile(r'story test|opening|leg ahead|double free')
# Work outside docs/Progress.md: (date, step, what)
MILESTONES = [
    ('2026-10-28', 0, 'The plan: the roadmap, its estimates and the open decisions.'),
    ('2026-11-01', 0, 'You asked for a provisional Sinnoh integration of Claude\'s own, Megas in all three regions, a '
     'full test of the game and a highlight video.'),
    ('2026-11-05', 0, 'Your Nov 5 calls: the gallery, one Town Map of three regions, Fly within a region.'),
    ('2026-11-06', 0, 'Your answers to all 23 questions; your playthrough starts on the playtest patch.'),
]
# Ahead, from today: (when, what, who, status: active, planned, waiting), Claude's estimates as of UPDATED
AHEAD = [
    ('Nov 5', 'Done: the gallery, one Town Map of three regions, the Day Care\'s yard; the playtest patch (the '
     'playtest session).', 'Claude', 'done'),
    ('Nov 6', 'Done: Ally Switch, Sovereign\'s suites rerun and their fixes (the Paradox Pokémon\'s level), your '
     'answers recorded.', 'Claude', 'done'),
    ('Nov 6', 'Done: your final boss team against Cynthia (video); the player as Ethan (every pose, his back, Fly); '
     'the Indigo Plateau\'s two-and-two Elite Four.', 'Claude', 'done'),
    ('Nov 7', 'The Trainer Card\'s 24 badges (a preview first), Ethan on it; Showdown\'s icons if you want them.',
     'Claude', 'active'),
    ('Nov 7 to 8', 'Trade evolutions from the bag, Whirlpool HM05 and Defog HM09 (HMs forgettable), the Mega Stone '
     'gifts, the Town Map from Cherrygrove, Fly to the Sinjoh Ruins: about 2 days.', 'Claude', 'planned'),
    ('Nov 9 to 11', 'Sinnoh from Canalave City: Rowan meets you, his lab\'s starter, the way to Jubilife opened, '
     'Byron\'s levels; the Rapid Ferry: about 3 days.', 'Claude', 'planned'),
    ('Nov 12 to 13', 'The Pal Parks\' regional forms; the starters\' Pledge tutor with the combinations: about 2 '
     'days.', 'Claude', 'planned'),
    ('Nov 14 to 18', 'HeartGold\'s Berry Pots, Unown Report, Dowsing Machine and photo album: about 4 days.',
     'Claude', 'planned'),
    ('Nov 19 to 29', 'The Pokéathlon, HeartGold\'s biggest remaining port (its own screens and minigames): about 10 '
     'days.', 'Claude', 'planned'),
    ('All along', 'Your playthrough; the playtest session fixes what you find and sends new patches.', 'You', 'active'),
    ('Your call', 'The new Town Map art; the Mega stone\'s look.', 'You', 'waiting'),
    ('Later', 'Link play (answer 14), when nothing else is left.', 'Claude', 'planned'),
    ('After your playthrough', 'Release (step 10): final fixes, then the .xdelta patch, about 3 days.', 'Both',
     'planned'),
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
    # The possible issues' screenshots, as they are (.cache/gallery/issues)
    os.makedirs(os.path.join(dest, 'issues'), exist_ok=True)
    for shot in glob.glob(os.path.join(GALLERY, 'issues', '*')):
        shutil.copyfile(shot, os.path.join(dest, 'issues', os.path.basename(shot)))
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
        'issues': [dict(zip(('date', 'where', 'what', 'shot', 'status'), i)) for i in POSSIBLE_ISSUES],
        'notes': [dict(zip(('date', 'note'), n)) for n in OWNER_NOTES],
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
