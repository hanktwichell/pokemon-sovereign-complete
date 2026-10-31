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
11. **Lyra's lesson:** the player sets out west again, and on Route 29 the friend shows how to catch a Pokémon
    (VAR_HGSS_UNK_408B from 1 back to 0).
12. **Violet City:** the player walks on through Cherrygrove City and up Routes 30 and 31, through the gatehouse into
    Violet City (its Fly point recorded), and into its Pokémon Center.
13. **Sprout Tower:** the player goes into Sprout Tower and up by its ladders (1F, 2F, back down to 1F, 2F again, 3F),
    battling the sages who see them, past the rival leaving, to Elder Li: his battle, then Sacred Gold's choice of an
    evolution item (the first, the Water Stone) and his TM (FLAG_HGSS_HIDE_VIOLET_GYM_GYM_GUY_AFTER_SPROUT).
14. **Falkner:** back down the ladders and out, to Violet Gym, onto its lift (its step-on trigger raises it to the
    upper floor), and Falkner's battle: the Zephyr Badge (VAR_HGSS_SCENE_VIOLET_CITY_OW 1).
15. **The Mystery Egg:** back down the lift and out, where Elm calls to ask for his aide's Egg to be fetched; in
    Violet City's Poké Mart the aide gives it (FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT). The aide wants room in the
    party, so the test party is cut to its lead first (gSovereignTestPartyKeep, by the test warp onto the player's
    own tile), as a player would leave some in the PC. Without the Egg, the man on Route 32 sends the player back.
16. **Azalea Town:** south down Route 32, through Union Cave and along Route 33 into Azalea Town (its Fly point
    recorded) and its Pokémon Center.
17. **The Slowpoke Well:** the player talks to Kurt at home, who hurries off to the well, follows him in and down,
    battles the Team Rocket grunts who see them, and Proton (FLAG_HGSS_BEAT_AZALEA_ROCKETS); the scene after takes
    the player back to Kurt's house, where his question is answered yes.
18. **Bugsy:** the player goes into Azalea Gym and through its puzzle (src/complete_gyms.c): four Spinarak carts ride
    between twelve stops, each ride starting as the player steps onto the tile beside a cart, and two switches set the
    points that decide where a cart goes. The way through (tools/complete/solve_story_puzzles.py, from the gym's data):
    ride from the first row to the second, from the third row's middle to the fourth row's west, flip the first switch,
    ride back down to the third row's west, flip the second switch, and ride from there to the fourth row's middle, in
    front of Bugsy. His battle, then his badge and TM (FLAG_HGSS_GOT_TM89_FROM_BUGSY).
19. **Ilex Forest:** back out of the gym by the carts (the first switch flipped back, the fourth row's middle to the
    third's, the second row's middle to the first's west) and its entrance hall, west through Azalea Town, where the
    rival steps out and battles, and the gatehouse into Ilex Forest, where the apprentice has lost the charcoal maker's
    two Farfetch'd (Sacred Gold has two). A Farfetch'd is caught by talking to it from behind; stepping on a twig makes
    it turn or run. The way (tools/complete/solve_story_puzzles.py, which plays the forest's script over its states):
    step on the twig south of the first and talk to it from the north; talk to the second from the south, so it runs
    east; step on the twig beyond it and talk to it from the west. With both back, the charcoal maker gives HM01
    (FLAG_HGSS_GOT_HM01).
20. **Goldenrod City:** the player cuts the tree in the forest's way north (Cut from the HM in the bag, with the Hive
    Badge: Sovereign's rule and src/complete_badges.c), and walks on to the gatehouse, where Sacred Gold has someone
    standing in the north doorway who gives the Odd Keystone when talked to and leaves, then up Route 34, where in front
    of the Day-Care the friend's grandparents' scene plays and takes the player inside (HeartGold's VAR_HGSS_UNK_408E),
    and out again into Goldenrod City (its Fly point recorded) and its Pokémon Center.
21. **Whitney:** first the Radio Tower, where the player takes the Radio Card quiz (yes, yes, no, yes, no) and Whitney,
    who was there, heads back to her gym, so the woman in its doorway steps aside (FLAG_HGSS_UNK_318); then into
    Goldenrod Gym and through its maze to Whitney: her battle, after which she cries; on the way back the player steps
    onto the trigger where the gym's lass comes over and takes them back to her, and Whitney, talked to again, gives the
    Plain Badge and her TM (FLAG_HGSS_GOT_TM45_FROM_WHITNEY).
22. **Sudowoodo:** out of the gym to the Flower Shop, whose owner gives the SquirtBottle now the player has the Plain
    Badge, then north through the gatehouse up Route 35, the National Park's south gatehouse, the park and its east
    gatehouse onto Route 36, to the odd tree in the way: the SquirtBottle, yes, and its battle; it's gone after
    (FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO), and the flower shop owner's sister by it goes home.
23. **Ecruteak City:** north up Route 37 into Ecruteak City (its Fly point recorded) and its Pokémon Center.
24. **The Burned Tower:** into the Burned Tower, where Eusine's scene plays on the way in, then the rival's trigger and
    his battle, down through the hole in the floor to the basement, and the legendary beasts' scene there, as they run
    off and Eusine talks (VAR_HGSS_UNK_40A1 1); the old man who kept the gym's door steps aside.
25. **Morty:** up the ladder and out, into Ecruteak Gym and along its dark path, never onto a pit (its step-on
    triggers, which drop the player back to the door), to Morty: his battle, the Fog Badge and his TM
    (FLAG_HGSS_GOT_TM30_FROM_MORTY).
26. **Surf:** out of the gym and into the Dance Theater, where a Team Rocket grunt bothers a Kimono Girl on the stage
    (its scene, on the way in); the grunt's battle, and as the player steps down from the stage the gentleman gives
    HM03 (FLAG_HGSS_GOT_HM03).
27. **Olivine City:** out of the theater and west through the gatehouse to Route 38 (its man sends tourists back to
    see Ecruteak until Morty is beaten: Sacred Gold's VAR_HGSS_SG_61A7; Steven gives the Iron Plate on the way out),
    along Routes 38 and 39 into Olivine City (its Fly point recorded) and its Pokémon Center.
28. **The Lighthouse:** up the Glitter Lighthouse: the stairs to 2F, ladders to 3F and 4F, out of 4F's opening, where
    the player falls to the balcony outside (its step-on trigger, HeartGold's), in again at 3F's door, and the ladders
    on its other side up to 4F, 5F and the light room, where Jasmine tends the sick Ampharos and asks for medicine
    (VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE).
29. **Cianwood City:** through the light room's door into the elevator, which takes the player down by itself, out of
    the lighthouse, and on Surf west across Routes 40 and 41 to Cianwood City (its Fly point recorded) and its Pokémon
    Center.
30. **Chuck:** into Cianwood Gym, where Chuck trains under a waterfall and doesn't notice the player; up to the winch at
    the top, turned (yes) so the waterfall stops, and Chuck's battle: the Storm Badge and his TM
    (FLAG_HGSS_GOT_TM01_FROM_CHUCK).
31. **The SecretPotion:** the pharmacist, across his counter, gives the medicine for Jasmine's Ampharos now that Chuck
    is beaten and Jasmine has asked for it (FLAG_HGSS_GOT_SECRETPOTION).
32. **The medicine:** back over the sea to the lighthouse, up by its elevator from 1F, and the SecretPotion given to
    Jasmine for the Ampharos, yes; the light shines again and Jasmine goes back to her gym
    (VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE 2). Sacred Gold now puts a man on Olivine Gym's door mat (his hide flag,
    FLAG_HGSS_SG_3FE8) until Team Rocket is beaten at the Safari Zone Gate.
33. **The Safari Zone Gate:** down by the elevator, on Surf to Cianwood City and west through the Cliff Edge Gate to
    Route 47, where Team Rocket has blocked Cliff Cave with a boulder that won't budge (Sacred Gold's) until a tag
    battle with the two grunts on the bridge beyond it (their step-on trigger), after which it shatters when inspected;
    through Cliff Cave (its ladder up, and a grunt in its far doorway who battles when talked to, then goes: Sacred
    Gold's), out on the route's other side, and Route 48 to the Safari Zone Gate's Pokémon Center, whose nurse, across
    her counter, offers to heal the player's Pokémon: yes, and she's a Team Rocket grunt; their scene sends them to the
    gate, where a tag battle beside Riley at the gate's entrance beats them (Sacred Gold's VAR_HGSS_SG_6130 2), and the
    man at Olivine Gym leaves.
34. **Jasmine:** the same way back to Olivine City and into its gym: Jasmine's battle, the Mineral Badge and her TM
    (FLAG_HGSS_GOT_TM23_FROM_JASMINE).
35. **Mahogany Town:** north up Routes 39 and 38 and through the gatehouse to Ecruteak City, east through the Route 42
    gatehouse, and along Route 42 (on Surf where it has to) into Mahogany Town (its Fly point recorded) and its
    Pokémon Center.
36. **The red Gyarados:** north through the gatehouse and up Route 43 to the Lake of Rage, and on Surf to beside the
    red Gyarados, wherever it has wandered: its battle, and the Red Scale (FLAG_HGSS_GOT_RED_SCALE).
37. **Lance:** back to the shore, where Lance asks for help: yes, and he flies off to Mahogany
    (FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE).
38. **The souvenir shop:** back down Route 43 into Mahogany's souvenir shop, where Lance unmasks the shop and its
    stairs open (VAR_HGSS_UNK_40A8 2).
39. **The passwords:** down the stairs into Team Rocket's hideout, across B1F (its Persian statues' alarms and the trap
    floor play out on the way), B2F's east stairs to B3F, where the two grunts who know the passwords are beaten, and
    back up by B3F's northeast stairs and along B2F's top corridor to B3F's west side, the floor change that sets the
    hideout's progress on (VAR_HGSS_UNK_40AC 2: HeartGold's "on transition" script, which runs only on a warp).
40. **Petrel:** the rival's scene on B3F, the door that opens to the passwords, and Petrel, as Giovanni, in the room
    beyond: his battle (VAR_HGSS_UNK_40AC 4).
41. **Ariana:** Petrel's Murkrow leads the player between the floors, a trigger at each step: B2F's top corridor, B3F's
    northeast stairs, B2F's southeast stairs, and the doors it opens, where Ariana and a grunt wait
    (VAR_HGSS_UNK_40AC 9).
42. **The Electrode:** the three Electrode that power the generator, each a battle; Lance shuts it down and the
    hideout is cleared (FLAG_HGSS_ROCKET_HIDEOUT_CLEARED), and the man in Mahogany Gym's doorway goes.
43. **Pryce:** out of the hideout and the shop, into Mahogany Gym and across its three rooms of ice, pushing its ice
    blocks where they make a way (tools/complete/solve_story_puzzles.py; src/complete_gyms.c), to Pryce: his battle,
    the Glacier Badge and his TM (FLAG_HGSS_GOT_TM07_FROM_PRYCE).

The walks between places find their own way over the maps' walkable tiles (ledges one way, no climb or drop the map's
heights and lifts don't allow, so over a bridge or under it, sliding over ice, around the people where they stand now
(read from the game, as trainers walk over and Mahogany Gym's ice blocks are pushed; a walk never pushes one), and never
onto a warp, or an armed cart trigger in Azalea Gym, twig in Ilex Forest or pit in Ecruteak Gym, but the one they go
to), and take it a step at a time, finding it again whenever a scene or a person moves the player. A prompt on the way
(the test save's Super Repel wearing off), each scene's text and a battle are paged through with A, which also answers
yes, and taps on a move and on a double battle's targets; the battles, trainers' and wild Pokémon's, are in the test
build's god mode (one hit wins, no PP used, no EXP prompts), as the test is about the story's way through, not the
battles. A part passes when the field is free on the map it expects, its flag is set or its var has moved on from 0 (or
to a given value), the game's heaps are whole (tools/test/heap_check.py; HEAP_STEPS=1 checks them after each action),
and the following Pokémon (the test party's lead) is beside the player: at most two steps away, as a scene can leave it
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
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import SWITCH_FRAMES, TAPS, heap_info  # noqa: E402
from check_object_tiles import DIRS, JUMPS, Maps, walkable  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from heap_check import heap_problems  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, WATER, event_maps, header_names, symbols, var_ids, warp  # noqa: E402
from test_hgss_togepi import SAVE_PAGES, SAVE_SECTOR, save_entry_index  # noqa: E402

LAB = 'MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_1F'
NEW_BARK = 'MAP_HEADER_HGSS_NEW_BARK'
AZALEA_GYM = 'MAP_HEADER_HGSS_AZALEA_GYM'
ILEX = 'MAP_HEADER_HGSS_ILEX_FOREST'
ECRUTEAK_GYM = 'MAP_HEADER_HGSS_ECRUTEAK_GYM'
# (part, its actions, the map it ends on, the var that must have moved on from 0 or the flag that must be set, (var,
# value) for a var that must have that value, ('fly', town) for the town's Fly point, or None). An action is a key to
# press, ('to', (x, z)): a walk to that tile on the map the player is on, ('surf', (x, z)): one that may cross water,
# ('ladder', (x, z), key): a walk onto a ladder, then the key toward it if the step didn't take it, ('talk', answers): A
# to talk to what the player faces, answering its menus (talk_and_answer's), ('meet', (x, z), answers): the same with
# whoever the map put on that tile, wherever they have wandered (by land or water), or ('keep', n): the party cut to
# its first n Pokémon (gSovereignTestPartyKeep, by the test warp onto the player's own tile). The stairs and doors warp
# as the player presses toward them from their tile.
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
         ('back to Elm', [('to', (684, 394)), 'UP'], LAB, ('VAR_HGSS_SCENE_ELMS_LAB', 4)),
         ('Lyra\'s lesson', [('to', (4, 14)), 'DOWN', ('to', (667, 399)), 'LEFT'], 'MAP_HEADER_HGSS_ROUTE_29',
          ('VAR_HGSS_UNK_408B', 0)),
         ('Violet City', [('to', (518, 269)), 'LEFT', ('to', (1, 7)), 'LEFT', ('to', (497, 272)), 'UP'],
          'MAP_HEADER_HGSS_VIOLET_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_VIOLET')),
         ('Sprout Tower', [('to', (8, 19)), 'DOWN', ('to', (487, 229)), 'UP', ('ladder', (10, 15), 'UP'),
                           ('ladder', (24, 9), 'UP'), ('ladder', (6, 16), 'UP'), ('ladder', (15, 27), 'UP'),
                           ('to', (12, 10)), 'UP', ('talk', [0])],
          'MAP_HEADER_HGSS_SPROUT_TOWER_3F', 'FLAG_HGSS_HIDE_VIOLET_GYM_GYM_GUY_AFTER_SPROUT'),
         ('Falkner', [('ladder', (15, 27), 'DOWN'), ('ladder', (6, 16), 'UP'), ('ladder', (24, 9), 'UP'),
                      ('ladder', (11, 14), 'UP'), ('to', (15, 28)), 'DOWN', ('to', (479, 258)), 'UP', ('to', (15, 21)),
                      'UP', ('to', (15, 5)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_VIOLET_GYM', ('VAR_HGSS_SCENE_VIOLET_CITY_OW', 1)),
         ('the Mystery Egg', [('to', (15, 19)), 'DOWN', ('to', (15, 28)), 'DOWN', ('keep', 1), ('to', (469, 258)), 'UP',
                              ('to', (6, 9)), 'UP', ('talk', [True]), ('to', (4, 11)), 'DOWN'],
          'MAP_HEADER_HGSS_VIOLET', 'FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT'),
         ('Azalea Town', [('to', (462, 431)), 'UP', ('to', (27, 93)), 'DOWN', ('to', (410, 461)), 'UP'],
          'MAP_HEADER_HGSS_AZALEA_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_AZALEA')),
         ('the Slowpoke Well', [('to', (8, 19)), 'DOWN', ('to', (399, 455)), 'UP', ('to', (4, 5)), 'UP', ('talk', []),
                                ('to', (4, 9)), 'DOWN', ('ladder', (433, 454), 'UP'), ('to', (11, 7)), 'UP',
                                ('to', (27, 4)), 'UP', ('talk', [True])],
          'MAP_HEADER_HGSS_AZALEA_KURT_HOUSE', 'FLAG_HGSS_BEAT_AZALEA_ROCKETS'),
         ('Bugsy', [('to', (4, 9)), 'DOWN', ('to', (405, 472)), 'UP', ('to', (7, 3)), 'UP',
                    ('to', (3, 33)), 'UP',  # the first row's west cart, to the second row's middle
                    ('to', (9, 18)), 'UP',  # the third row's middle cart, to the fourth row's west
                    ('to', (4, 8)), 'UP', ('talk', []),  # the first switch
                    ('to', (3, 8)), 'DOWN',  # back down to the third row's west
                    ('to', (2, 19)), 'UP', ('talk', []),  # the second switch
                    ('to', (3, 18)), 'UP',  # to the fourth row's middle
                    ('to', (9, 6)), 'UP', ('talk', [])],
          AZALEA_GYM, 'FLAG_HGSS_GOT_TM89_FROM_BUGSY'),
         ('Ilex Forest', [('to', (11, 7)), 'DOWN', ('talk', []),  # the first switch back
                          ('to', (9, 8)), 'DOWN',  # the fourth row's middle cart, to the third row's middle
                          ('to', (9, 23)), 'DOWN',  # the second row's middle cart, to the first row's west
                          ('to', (9, 37)), 'DOWN', ('to', (7, 11)), 'DOWN', ('to', (392, 462)), 'LEFT',
                          ('to', (1, 7)), 'LEFT',
                          ('to', (25, 67)),  # a twig: the first Farfetch'd hears it and turns
                          ('to', (25, 61)), 'DOWN', ('talk', []),  # caught from behind, and back to the apprentice
                          ('to', (41, 55)), 'UP', ('talk', []),  # the second runs east
                          ('to', (52, 53)),  # a twig beyond it
                          ('to', (48, 54)), 'RIGHT', ('talk', [])],  # caught; the charcoal maker's HM01
          ILEX, 'FLAG_HGSS_GOT_HM01'),
         ('Goldenrod City', [('to', (16, 63)), 'UP', ('talk', [True]), ('to', (12, 17)), 'UP',
                             ('to', (5, 4)), 'UP', ('talk', []),  # Sacred Gold's Odd Keystone, from the one in the way
                             ('to', (5, 2)), 'UP',
                             ('to', (366, 414)), 'UP',  # the scene in front of the Day-Care, which ends inside it
                             ('to', (3, 12)), 'DOWN', ('to', (352, 369)), 'UP'],
          'MAP_HEADER_HGSS_GOLDENROD_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_GOLDENROD')),
         ('Whitney', [('to', (8, 19)), 'DOWN', ('to', (342, 350)), 'UP', ('to', (13, 10)), 'DOWN',
                      ('talk', [True, True, True, False, True, False]),  # the Radio Card quiz, across the counter
                      ('to', (2, 14)), 'DOWN', ('to', (366, 335)), 'UP', ('to', (13, 5)), 'UP', ('talk', []),
                      ('to', (13, 10)), 'DOWN',  # the lass's trigger: a key onto it, as a walk would go back to it
                      ('to', (13, 5)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_GOLDENROD_GYM', 'FLAG_HGSS_GOT_TM45_FROM_WHITNEY'),
         ('Sudowoodo', [('to', (6, 25)), 'DOWN', ('to', (371, 333)), 'UP', ('to', (3, 6)), 'UP', ('talk', []),
                        ('to', (5, 9)), 'DOWN', ('to', (358, 325)), 'UP', ('to', (5, 2)), 'UP',
                        ('to', (362, 266)), 'UP', ('to', (25, 2)), 'UP', ('to', (75, 39)), 'RIGHT',
                        ('to', (10, 7)), 'RIGHT',
                        ('to', (415, 247)), 'UP', ('talk', [True])],
          'MAP_HEADER_HGSS_ROUTE_36', 'FLAG_HGSS_HIDE_ROUTE_36_SUDOWOODO'),
         ('Ecruteak City', [('to', (397, 184)), 'UP'],
          'MAP_HEADER_HGSS_ECRUTEAK_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_ECRUTEAK')),
         ('the Burned Tower', [('to', (8, 19)), 'DOWN', ('to', (376, 149)), 'UP',
                               ('to', (22, 20)), 'UP',  # the rival's trigger, past Eusine's on the way
                               ('to', (22, 16)),  # the hole in the floor, down to the basement
                               ('to', (21, 16)), 'LEFT'],  # the legendary beasts
          'MAP_HEADER_HGSS_BURNED_TOWER_B1F', ('VAR_HGSS_UNK_40A1', 1)),
         ('Morty', [('ladder', (23, 16), 'UP'), ('to', (15, 26)), 'DOWN', ('to', (376, 184)), 'UP',
                    ('to', (10, 9)), 'UP', ('talk', [])],
          ECRUTEAK_GYM, 'FLAG_HGSS_GOT_TM30_FROM_MORTY'),
         ('Surf', [('to', (16, 53)), 'DOWN', ('to', (397, 173)), 'UP',
                   ('to', (7, 7)), 'UP', ('talk', []),  # the grunt on the stage
                   ('to', (3, 7)), 'DOWN'],  # the step down from the stage: the gentleman and HM03
          'MAP_HEADER_HGSS_ECRUTEAK_DANCE_THEATER', 'FLAG_HGSS_GOT_HM03'),
         ('Olivine City', [('to', (7, 17)), 'DOWN', ('to', (358, 166)), 'LEFT', ('to', (1, 7)), 'LEFT',
                           ('to', (272, 258)), 'UP'],
          'MAP_HEADER_HGSS_OLIVINE_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_OLIVINE')),
         ('the Lighthouse', [('to', (8, 19)), 'DOWN', ('to', (301, 263)), 'UP', ('to', (2, 3)), 'RIGHT',
                             ('ladder', (13, 6), 'UP'), ('ladder', (10, 7), 'UP'),
                             ('to', (16, 9)),  # 4F's opening: the fall to the balcony
                             ('to', (8, 12)), 'UP',  # in at 3F's door
                             ('ladder', (6, 7), 'UP'), ('ladder', (3, 5), 'UP'), ('ladder', (10, 10), 'UP'),
                             ('to', (7, 9)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_LIGHT_ROOM', 'VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE'),
         ('Cianwood City', [('to', (8, 5)), 'UP', ('to', (3, 6)), 'DOWN', ('to', (8, 17)), 'DOWN',
                            ('surf', (187, 370)), 'UP'],
          'MAP_HEADER_HGSS_CIANWOOD_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_CIANWOOD')),
         ('Chuck', [('to', (8, 19)), 'DOWN', ('to', (172, 358)), 'UP',
                    ('to', (10, 3)), 'UP', ('talk', [True]),  # the winch: the waterfall stops
                    ('to', (13, 11)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_CIANWOOD_GYM', 'FLAG_HGSS_GOT_TM01_FROM_CHUCK'),
         ('the SecretPotion', [('to', (13, 19)), 'DOWN', ('to', (179, 371)), 'UP', ('to', (5, 7)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_CIANWOOD_PHARMACY', 'FLAG_HGSS_GOT_SECRETPOTION'),
         ('the medicine', [('to', (5, 9)), 'DOWN', ('surf', (301, 264)), 'UP',
                           ('to', (8, 5)), 'UP', ('to', (3, 6)), 'DOWN',  # the elevator up, by itself
                           ('to', (7, 9)), 'UP', ('talk', [True])],
          'MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_LIGHT_ROOM', ('VAR_HGSS_SCENE_LIGHTHOUSE_JASMINE', 2)),
         ('the Safari Zone Gate', [('to', (8, 5)), 'UP', ('to', (3, 6)), 'DOWN', ('to', (8, 17)), 'DOWN',
                                   ('surf', (171, 347)), 'LEFT', ('to', (18, 46)), 'DOWN',  # the Cliff Edge Gate
                                   ('to', (126, 389)), 'LEFT',  # a tag battle with the grunts on the bridge
                                   ('to', (130, 387)), 'UP', ('talk', []),  # their boulder shatters
                                   ('to', (130, 385)), 'UP', ('ladder', (4, 5), 'UP'),
                                   ('to', (6, 28)), 'DOWN', ('talk', []), ('to', (6, 29)), 'DOWN',  # the grunt
                                   ('to', (82, 303)), 'UP', ('to', (8, 13)), 'UP', ('talk', [True]),  # the nurse
                                   ('to', (8, 19)), 'DOWN', ('to', (88, 296)), 'UP'],  # the gate: the tag battle
          'MAP_HEADER_HGSS_SAFARI_ZONE_GATE', ('VAR_HGSS_SG_6130', 2)),
         ('Jasmine', [('to', (130, 381)), 'UP', ('to', (4, 22)), ('to', (6, 7)), 'DOWN',  # Cliff Cave, back
                      ('to', (149, 384)), 'UP', ('to', (40, 22)), 'RIGHT',  # the Cliff Edge Gate, back
                      ('surf', (269, 239)), 'UP', ('to', (6, 6)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_OLIVINE_GYM', 'FLAG_HGSS_GOT_TM23_FROM_JASMINE'),
         ('Mahogany Town', [('to', (6, 27)), 'DOWN', ('to', (351, 166)), 'RIGHT',  # Routes 39 and 38
                            ('to', (10, 7)), 'RIGHT', ('to', (415, 175)), 'RIGHT',  # Ecruteak City
                            ('to', (10, 7)), 'RIGHT', ('surf', (534, 183)), 'UP'],  # Route 42
          'MAP_HEADER_HGSS_MAHOGANY_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_MAHOGANY')),
         ('the red Gyarados', [('to', (8, 19)), 'DOWN', ('to', (524, 165)), 'UP', ('to', (5, 2)), 'UP',
                               ('to', (528, 86)),  # up Route 43 to the Lake of Rage, where its people are loaded
                               ('meet', (525, 71), [])],  # and on Surf to it
          'MAP_HEADER_HGSS_LAKE_OF_RAGE', 'FLAG_HGSS_GOT_RED_SCALE'),
         ('Lance', [('surf', (528, 84)), 'UP', ('talk', [True])], 'MAP_HEADER_HGSS_LAKE_OF_RAGE',
          'FLAG_HGSS_HIDE_LAKE_OF_RAGE_LANCE'),
         ('the souvenir shop', [('to', (524, 156)), 'DOWN', ('to', (5, 12)), 'DOWN', ('to', (528, 174))],
          'MAP_HEADER_HGSS_MAHOGANY_SOUVENIR_SHOP', ('VAR_HGSS_UNK_40A8', 2)),
         ('the passwords', [('ladder', (6, 3), 'RIGHT'), ('to', (10, 29)), 'LEFT',  # B1F
                            ('to', (51, 29)), 'RIGHT', ('meet', (38, 15), []), ('meet', (15, 25), []),  # B3F
                            ('to', (51, 4)), 'RIGHT', ('to', (10, 4)), 'LEFT'],  # by B2F to B3F's west side
          'MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B3F', ('VAR_HGSS_UNK_40AC', 2)),
         ('Petrel', [('to', (20, 18)), ('to', (23, 16)), 'UP', ('talk', []), ('to', (23, 12))],
          'MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B3F', ('VAR_HGSS_UNK_40AC', 4)),
         ('Ariana', [('to', (10, 4)), 'LEFT', ('to', (11, 4)), ('to', (51, 4)), 'RIGHT', ('to', (50, 4)),
                     ('to', (51, 29)), 'RIGHT', ('to', (50, 29)), ('to', (30, 27)), ('to', (30, 19))],
          'MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B2F', ('VAR_HGSS_UNK_40AC', 9)),
         ('the Electrode', [('meet', (21, 12), []), ('meet', (21, 14), []), ('meet', (21, 16), [])],
          'MAP_HEADER_HGSS_TEAM_ROCKET_HEADQUARTERS_B2F', 'FLAG_HGSS_ROCKET_HIDEOUT_CLEARED'),
         ('Pryce', [('to', (10, 29)), 'LEFT', ('ladder', (51, 4), 'RIGHT'), ('to', (5, 9)), 'DOWN',  # out
                    ('to', (523, 183)), 'UP',  # the ice (tools/complete/solve_story_puzzles.py)
                    ('to', (4, 16)), 'UP', ('to', (3, 2)), ('to', (2, 10)), 'RIGHT', ('to', (6, 2)),
                    ('to', (6, 17)), 'UP', ('to', (4, 9)), 'DOWN', ('to', (4, 12)), 'RIGHT', ('to', (7, 5)), 'UP',
                    ('talk', [])],
          'MAP_HEADER_HGSS_MAHOGANY_GYM_LEADER_ROOM', 'FLAG_HGSS_GOT_TM07_FROM_PRYCE')]
# armed step-on triggers (coord events whose var has their value) a walk never steps onto, but the one it goes to, by
# map and the start of their var's name: Azalea Gym's carts (src/complete_gyms.c), Ilex Forest's twigs, which scare a
# Farfetch'd, and Ecruteak Gym's pits
AVOIDED_TRIGGERS = {AZALEA_GYM: 'VAR_MAP_LOCAL_0x00', ILEX: 'VAR_HGSS_FARFETCHD', ECRUTEAK_GYM: 'VAR_HGSS_UNK_4109'}
# the tile behaviors that warp (include/constants/field/map_tile_behaviors.h: the stairs to the directional warps,
# doors among them) and HeartGold's ladders (Complete's 0x0D-0x0F): a warp event on another tile is part of a wider
# doorway, and a walk may cross it
WARP_TILES = set(range(0x5e, 0x70)) | {0x0d, 0x0e, 0x0f}
# water Surf doesn't cross: whirlpools (include/constants/field/complete_tile_behaviors.h) and waterfalls
OTHER_WATER = {0x11, 0x13}
ICE = 0x20  # TILE_BEHAVIOR_ICE: a step onto it slides on (Mahogany Gym, the Ice Path)
RAM, RAM_SIZE = 0x02000000, 0x400000  # the DS's main memory, where the map objects are
MAP_OBJECT_SIZE = 0x128  # sizeof(MapObject), src/map_object.c
PLAYER, FOLLOWER = 0xff, 0xf0  # their local IDs (include/complete_follower.h)
ICE_ROCK = open(os.path.join(DECOMP, 'generated', 'object_events_gfx.txt')).read().split().index(
    'OBJ_EVENT_GFX_ICE_ROCK')  # Mahogany Gym's ice blocks' graphics
SOUTH = 1  # Platinum's DIR_SOUTH: an ice block that faces it can be pushed
MEET_TRIES = 12  # walks to beside someone who wanders, before giving up
DOUBLES_TARGETS = ((64, 30), (190, 30))  # the foes' boxes on a double battle's target screen (bottom screen)
KEYS = {(1, 0): 'RIGHT', (-1, 0): 'LEFT', (0, 1): 'DOWN', (0, -1): 'UP'}
IDLE_RUN = 60  # frames to watch for a free field: it updates at 30 Hz, so a free second adds about 30
SHORT_RUN = 20  # a first, short look, so A isn't pressed into a field that is already free
SETTLE_FRAMES = 30000  # the longest a scene or a talk may take (Mr. Pokémon's and Oak's scene, at the test save's
# text speed; Bugsy's battle and lines)
WALK_STEPS = 600  # the most steps one walk takes
STEP_WAIT = 16  # frames more to wait for a step that hasn't started
FORGETS = 3  # how many times a walk forgets the steps that failed when they leave no way
MARGIN = 40  # tiles around the start and the goal a route may go through


def fly_points(variables):
    """{town: its Fly point's flag}, from HeartGold's spawn points: src/spawn_locations.c sets
    FLAG_HGSS_SYS_FLYPOINT_PALLET + the firstArrival of the row whose Fly lands in the town, and pokeheartgold names a
    few of those flags after the wrong town (tools/complete/import_hgss_spawns.py), so the test goes by the row."""
    rows = open(os.path.join(DECOMP, 'include', 'data', 'hgss_spawn_locations.h'), encoding='utf-8').read()
    return {town: variables['FLAG_HGSS_SYS_FLYPOINT_PALLET'] + int(first, 0)
            for town, unlock, first in re.findall(r'\{ \w+, \w+, \w+, (\w+), \w+, \w+, \w+, (\w+), (\w+) \}', rows)
            if int(unlock, 0)}


class Heights:
    """The maps' heights, from each map's BDHC as src/overlay005/bdhc.c reads it: the heights of the plates over a
    tile's centre, more than one where a bridge crosses a path (Goldenrod Gym's walkways over its floor)."""

    def __init__(self, maps):
        self.maps, self.plates, self.tiles = maps, {}, {}

    def load(self, name):
        """The map's BDHC: its points, normals, constants, plates, strips and access list."""
        path = os.path.join(self.maps.decomp, 'res', 'field', 'maps', 'data',
                            f'map_data_{self.maps.names.index(name):03d}.bin')
        data = open(path, 'rb').read()
        sizes = struct.unpack_from('<4I', data)
        at = 16 + sizes[0] + sizes[1] + sizes[2]
        counts = struct.unpack_from('<6H', data, at + 4)  # after the magic
        at += 16
        parts = []
        for count, size, fmt in zip(counts, (8, 12, 4, 8, 8, 2), ('<2i', '<3i', '<i', '<4H', '<iHH', '<H')):
            parts.append([struct.unpack_from(fmt, data, at + size * i) for i in range(count)])
            at += size * count
        return parts

    def at(self, matrix, x, z):
        """The heights over the tile's centre (empty without any)."""
        if (matrix, x, z) not in self.tiles:
            name = self.maps.matrix(matrix)[z // 32][x // 32]
            if name not in self.plates:
                self.plates[name] = self.load(name)
            points, normals, constants, plates, strips, access = self.plates[name]
            # the tile's centre, from the middle of its map, in fx32
            px, pz = (((x % 32) - 16) * 16 + 8) * 4096, (((z % 32) - 16) * 16 + 8) * 4096
            heights = []
            if strips:
                low, high, s = 0, len(strips) - 1, 0
                mid = high // 2
                while len(strips) > 1:  # bdhc.c's search for the strip
                    if strips[mid][0] > pz:
                        if high - 1 <= low:
                            s = mid
                            break
                        high, mid = mid, (low + mid) // 2
                    else:
                        if low + 1 >= high:
                            s = mid + 1
                            break
                        low, mid = mid, (mid + high) // 2
                _, count, first = strips[s]
                for i in range(count):
                    a, b, n, c = plates[access[first + i][0]]
                    (ax, az), (bx, bz) = points[a], points[b]
                    if min(ax, bx) <= px <= max(ax, bx) and min(az, bz) <= pz <= max(az, bz):
                        nx, ny, nz = normals[n]
                        heights.append(-(nx * px / 4096 + nz * pz / 4096 + constants[c][0]) / ny)
            self.tiles[(matrix, x, z)] = heights
        return self.tiles[(matrix, x, z)]


def route(maps, matrix, start, goal, blocked, steps=frozenset(), heights=None, height=0.0, surf=False, lifts=None,
          pushable=frozenset()):
    """The keys from start to goal over walkable land (a ledge one way), and water with surf, around the blocked tiles
    and without the steps ((tile, direction)) the player couldn't take, or None. With heights, from the player's height:
    a step takes the height nearest it at the next tile, and can't climb or drop 20 or more
    (src/terrain_collision_manager.c), so a bridge and the path under it are told apart. Lifts are the field's dynamic
    plates (a tile's height, as Violet Gym's lift), a height more to choose from at their tiles. Over ice the player
    slides; a slide that would stop at a pushable ice block (Mahogany Gym's) is never taken, as it would push it."""
    x0, x1 = min(start[0], goal[0]) - MARGIN, max(start[0], goal[0]) + MARGIN
    z0, z1 = min(start[1], goal[1]) - MARGIN, max(start[1], goal[1]) + MARGIN
    first = (start, round(height))
    came = {first: None}
    queue = collections.deque([(start, height)])
    end = None
    while queue and end is None:
        p, h = queue.popleft()
        for d in DIRS:
            if (p, d) in steps:
                continue
            n = (p[0] + d[0], p[1] + d[1])
            t = maps.tile(matrix, *n)
            jump = t is not None and (t & 0xff) in JUMPS
            if jump:
                jd, k = JUMPS[t & 0xff]
                if jd != d:
                    continue
                n = (n[0] + jd[0] * k, n[1] + jd[1] * k)
                t = maps.tile(matrix, *n)
            if t is None or not (x0 <= n[0] <= x1 and z0 <= n[1] <= z1):
                continue
            if n != goal and (n in blocked or not walkable(t)
                              or (t & 0xff) in WATER and (not surf or (t & 0xff) in OTHER_WATER)):
                continue
            while (t & 0xff) == ICE:  # on over the ice until off it or stopped (src/player_move.c)
                ahead = (n[0] + d[0], n[1] + d[1])
                t_ahead = maps.tile(matrix, *ahead)
                if t_ahead is None or ahead in blocked or not walkable(t_ahead) or (t_ahead & 0xff) in WATER:
                    break
                n, t = ahead, t_ahead
            if (t & 0xff) == ICE and (n[0] + d[0], n[1] + d[1]) in pushable:
                continue
            nh = h
            choices = (heights.at(matrix, *n) if heights is not None else []) \
                + ([lifts[n]] if n in (lifts or {}) else [])
            if heights is not None and choices:
                nh = min(choices, key=lambda v: abs(v - h))
                if not jump and abs(nh - h) >= 20:
                    continue
            if (n, round(nh)) in came:
                continue
            came[(n, round(nh))] = ((p, round(h)), d)
            queue.append((n, nh))
            if n == goal:
                end = (n, round(nh))
                break
    if end is None:
        return None
    keys, at = [], end
    while came[at]:
        at, d = came[at]
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
    towns = fly_points(variables)
    maps = Maps(DECOMP)
    heights = Heights(maps)
    heaps = heap_info()
    matrix_of, people_of, warps_of, triggers_of = {}, collections.defaultdict(set), collections.defaultdict(set), {}
    for _, headers_of, cur, _ in event_maps():
        for header, matrix in headers_of:
            matrix_of[header] = matrix
            people_of[matrix] |= {(o['x'], o['z']) for o in cur.get('object_events', [])}
            warps_of[matrix] |= {(w['x'], w['z']) for w in cur.get('warp_events', [])
                                 if (maps.tile(matrix, w['x'], w['z']) or 0) & 0xff in WARP_TILES}
            triggers_of[header] = [({(c['x'] + i, c['z'] + j) for i in range(c['width']) for j in range(c['length'])},
                                    c['var'], c['value']) for c in cur.get('coord_events', [])]
    first = [p[0] for p in PARTS].index(start) if start else 0
    if first:
        state = os.path.join(out, PARTS[first - 1][0].replace(' ', '_') + '.state')
    d = Driver(rom, state)
    mem = d.emu.memory
    mem.write_byte(sym['gSovereignTestGodMode'], 1)  # battles: one hit wins, no PP used, no EXP prompts

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def vars_flags():
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index('SAVE_TABLE_ENTRY_VARS_FLAGS') * 16 + 8
        return base + 20 + u32(at)

    def var(name):
        return u16(vars_flags() + (variables[name] - variables['VARS_START']) * 2)

    def flag(n):
        flags = vars_flags() + (variables['VARS_END'] - variables['VARS_START']) * 2
        return bool(mem.unsigned[flags + n // 8] & (1 << (n % 8)))

    def moved_on(name):
        """A flag is set, or a var isn't 0, or (var, value) has that value, or ('fly', town) the town's Fly point is
        recorded (VarsFlags: the vars, then the flags' bits)."""
        if isinstance(name, tuple) and name[0] == 'fly':
            return flag(towns[name[1]])
        if isinstance(name, tuple):
            return var(name[0]) == name[1]
        if name.startswith('VAR_'):
            return var(name) != 0
        return flag(variables[name])

    player_object = [None]  # the player's map object's address

    def height():
        """The player's height, from their map object (src/map_object.c's MapObject: the player's localID 0xFF, its
        tile and its position's y), found again when the map changes."""
        pos, at = d.pos(), player_object[0]
        if at is None or struct.unpack('<3i', bytes(mem.unsigned[at + 100:at + 112]))[::2] != pos:
            ram, at = bytes(mem.unsigned[RAM:RAM + RAM_SIZE]), None
            for found in re.finditer(rb'\xff\x00\x00\x00', ram):
                o = found.start() - 8  # the localID's offset
                if o >= 0 and o % 4 == 0 and struct.unpack_from('<I', ram, o)[0] \
                        and struct.unpack_from('<3i', ram, o + 100)[::2] == pos:
                    at = RAM + o
                    break
            player_object[0] = at
        return struct.unpack('<i', bytes(mem.unsigned[at + 116:at + 120]))[0] / 4096 if at else 0.0

    def lifts():
        """The field's dynamic plates (src/overlay005/dynamic_terrain_height.c), their tiles' heights: from the player's
        map object to its manager (MapObject's mapObjMan), the field system (MapObjectManager's fieldSystem) and its
        dynamicTerrainHeightMan."""
        height()
        if player_object[0] is None:
            return {}
        manager = u32(u32(u32(player_object[0] + 0xb4) + 0x128) + 0xa0)
        if not RAM <= manager < RAM + RAM_SIZE:
            return {}
        tiles = {}
        for i in range(u32(manager)):
            at = u32(manager + 4) + 24 * i
            x, z, w, length, y, valid = struct.unpack('<6i', bytes(mem.unsigned[at:at + 24]))
            if valid:
                tiles.update({(x + a, z + b): y / 4096 for a in range(w) for b in range(length)})
        return tiles

    def others():
        """The tiles of everyone and everything on the map now but the player and the follower (src/map_object.c: the
        player's map object's manager, MapObjectManager, and its objects, the active ones), as people move: a trainer
        walks over to battle, a scene moves people, and the player pushes Mahogany Gym's ice blocks; and the tiles of
        the ice blocks that can still be pushed (facing down). None, None if the player's map object isn't found."""
        height()
        if player_object[0] is None:
            return None, None
        manager = u32(player_object[0] + 0xb4)
        objects, tiles, pushable = u32(manager + 0x124), set(), set()
        for i in range(u32(manager + 4)):
            at = objects + MAP_OBJECT_SIZE * i
            status, _, local, _, gfx = struct.unpack('<5I', bytes(mem.unsigned[at:at + 20]))
            if status & 1 and local not in (PLAYER, FOLLOWER):
                tile = struct.unpack('<3i', bytes(mem.unsigned[at + 100:at + 112]))[::2]
                tiles.add(tile)
                if gfx == ICE_ROCK and u32(at + 40) == SOUTH:  # its facingDir
                    pushable.add(tile)
        return tiles, pushable

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
        frames, presses = 0, 0
        while frames < SETTLE_FRAMES:
            frames += SHORT_RUN
            if free(SHORT_RUN):
                frames += IDLE_RUN
                if free(IDLE_RUN):
                    return True
                continue  # something started meanwhile: look again before pressing anything
            presses += 1
            if presses % 6 == 5:  # on a naming screen (the officer asks the rival's name) START goes to OK, and the
                # A after it takes the name; in a scene or a battle it does nothing
                d.press('START', frames=2, after=8)
            elif presses % 3 == 0:  # A pages through text and answers yes
                d.press('A', frames=2, after=8)
            elif presses % 6 in (1, 4) and presses % 4 == 1:  # a double battle's target screen: a foe's box, the left
                # one or the right one (the cursor may sit on a foe that has fainted, where A does nothing; a tag
                # battle on Route 47 waited there for good)
                d.touch(*DOUBLES_TARGETS[presses // 4 % 2], frames=4, after=6)
            else:  # in a battle A would pick the first move, which may not hurt (Precipice Blades on a flier), so taps
                # on FIGHT and then on a damaging move (battle_all_trainers.py's), as talk_and_answer does
                d.touch(*TAPS[frames // SWITCH_FRAMES % len(TAPS)], frames=4, after=6)
            frames += 10
        return False

    def step(key):
        """Press key: a step, or the press that takes a door or a stairway. A press that only turned the player (they
        faced another way) is made again, while the player hasn't moved, the map is the same and nothing started."""
        for _ in range(3):
            pos, header = d.pos(), here()
            d.press(key, frames=8, after=16)
            if d.pos() != pos or here() != header or not free(SHORT_RUN):
                return

    def walk_to(goal, surf=False):
        """Walk to goal on the map the player is on, a step at a time, finding the way again after each, around the
        map's people if it can; a step the player can't take twice (a person in the way, or a drop between a bridge
        and the floor under it, as the map's heights decide) isn't tried again, unless that leaves no way (a trainer
        who stood in it after a battle may have gone). A goal that warps the player as they
        step onto it (a ladder) counts as reached. With surf the way may cross water: at the shore the player faces
        it and uses Surf (A, yes). Returns a problem, or ''."""
        header, matrix = here(), matrix_of[here()]
        failed = set()  # (tile, direction) steps the player couldn't take
        forgets = 0
        stuck, last = 0, False
        for n in range(WALK_STEPS):
            if n % 50 == 49:
                print(f'    ... {here()} {d.pos()}', flush=True)  # progress on a long walk
            if not free(SHORT_RUN) and not settle():  # a short look while nothing happens, so a step costs little
                return f'the field never came free on the way to {goal}, on {here()} at {d.pos()}'
            if matrix_of.get(here()) != matrix:
                return '' if last else f'left for {here()} on the way to {goal}'
            pos = d.pos()
            if pos == goal:
                return ''
            armed = [tiles for tiles, name, value in triggers_of.get(header, [])
                     if name.startswith(AVOIDED_TRIGGERS.get(header, '-')) and var(name) == value]
            avoid = (warps_of[matrix] | set().union(*armed)) - {goal}
            # around everyone where they are now (or where the map puts them), and if that fails, through them
            h, lift, (people, blocks) = height(), lifts(), others()
            people, blocks = (people_of[matrix], ()) if people is None else (people, blocks)
            keys = route(maps, matrix, pos, goal, (people | avoid) - {pos}, failed, heights, h, surf, lift, blocks) \
                or route(maps, matrix, pos, goal, avoid - {pos}, failed, heights, h, surf, lift, blocks)
            if not keys and failed and forgets < FORGETS:  # whoever was in the way may have moved since
                failed.clear()
                forgets += 1
                continue
            if not keys:
                return f'no way from {pos} to {goal} on {here()}'
            step = next(dd for dd, k in KEYS.items() if k == keys[0])
            ahead = maps.tile(matrix, pos[0] + step[0], pos[1] + step[1])
            if surf and ahead is not None and (ahead & 0xff) in WATER and (maps.tile(matrix, *pos) & 0xff) not in WATER:
                d.press(keys[0], frames=8, after=16)  # facing the water
                result, frames = talk_and_answer(d, sym, [True], SETTLE_FRAMES)  # Surf, yes
                if result != 'ok' or d.pos() == pos:
                    return f'Surf from {pos}: {result} after {frames} frames'
                continue
            last = len(keys) == 1
            d.press(keys[0], frames=8, after=16)
            if d.pos() == pos:
                d.run(STEP_WAIT)  # a step can start late, as the follower gets out of the way
            if d.pos() != pos:
                stuck = 0
                continue
            stuck += 1
            if stuck >= 2:
                failed.add((pos, step))
                stuck = 0
        return f'still not at {goal} after {WALK_STEPS} steps, on {here()} at {d.pos()}'

    def where(start):
        """The tile now of whoever the map put on start (their map object's first tile, MapObject's xInitial and
        zInitial), or None."""
        height()
        if player_object[0] is None:
            return None
        manager = u32(player_object[0] + 0xb4)
        for i in range(u32(manager + 4)):
            at = u32(manager + 0x124) + MAP_OBJECT_SIZE * i
            if u32(at) & 1 and struct.unpack('<3i', bytes(mem.unsigned[at + 76:at + 88]))[::2] == start:
                return struct.unpack('<3i', bytes(mem.unsigned[at + 100:at + 112]))[::2]
        return None

    def meet(start, answers):
        """Talk to whoever the map put on start, who wanders (the Lake of Rage's red Gyarados): to beside them,
        wherever they are now, by land or water, then facing them, the talk, answered. Returns a problem, or ''."""
        for _ in range(MEET_TRIES):
            at, pos = where(start), d.pos()
            if at is None:
                return f'nobody from {start} on {here()}'
            toward = (at[0] - pos[0], at[1] - pos[1])
            if toward in KEYS:
                d.press(KEYS[toward], frames=8, after=16)  # facing them
                if where(start) == at:
                    result, frames = talk_and_answer(d, sym, answers, SETTLE_FRAMES)
                    if result == 'ok':
                        return ''
                    if result != 'NOSCRIPT':  # (nobody: they stepped away as A went down, so again)
                        return f'the talk: {result} after {frames} frames, on {here()} at {pos}'
                continue
            matrix = matrix_of[here()]
            sides = [(at[0] + dx, at[1] + dz) for dx, dz in DIRS
                     if maps.tile(matrix, at[0] + dx, at[1] + dz) is not None
                     and walkable(maps.tile(matrix, at[0] + dx, at[1] + dz))]
            if not sides:
                return f'no tile beside {at}, where whoever started on {start} is'
            walk_to(min(sides, key=lambda p: abs(p[0] - pos[0]) + abs(p[1] - pos[1])), True)  # they may move on
        return f'never beside whoever started on {start}, on {here()} at {d.pos()}'

    results = []
    d.run(30)
    for name, actions, end_map, marker in PARTS[first:]:
        problem = ''
        for action in actions:
            if not settle():
                problem = f'the field never came free before {action}, on {here()} at {d.pos()}'
            elif isinstance(action, str):
                step(action)
            elif action[0] == 'keep':  # the hook applies on the test warp, here onto the player's own tile
                mem.write_byte(sym['gSovereignTestPartyKeep'], action[1])
                result, frames = warp(d, sym, names.index(here()), *d.pos(), 0)
                if result != 'ok':
                    problem = f'the party cut: the warp {result} after {frames} frames, on {here()} at {d.pos()}'
            elif action[0] == 'meet':
                problem = meet(action[1], action[2])
            elif action[0] in ('to', 'ladder', 'surf'):
                before = matrix_of.get(here())
                problem = walk_to(action[1], action[0] == 'surf')
                if not problem and action[0] == 'ladder' and matrix_of.get(here()) == before:
                    step(action[2])
            else:
                result, frames = talk_and_answer(d, sym, action[1], SETTLE_FRAMES)
                if result != 'ok':
                    problem = f'the talk: {result} after {frames} frames, on {here()} at {d.pos()}'
            print(f'  {action}: {here()} {d.pos()}', flush=True)
            if os.environ.get('HEAP_STEPS'):  # the heaps and the follower after each action, to find what breaks them
                follower = struct.unpack('<HH', bytes(mem.unsigned[sym['gCompleteTestFollowerTile']:
                                                                   sym['gCompleteTestFollowerTile'] + 4]))
                print(f'    heaps: {heap_problems(mem, heaps) or "ok"}; the follower on {follower}', flush=True)
            if problem:
                break
        if not problem and not settle():
            problem = f'the field never came free at the end, on {here()} at {d.pos()}'
        if not problem and heap_problems(mem, heaps):
            problem = f'the heaps are broken: {heap_problems(mem, heaps)}'
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
