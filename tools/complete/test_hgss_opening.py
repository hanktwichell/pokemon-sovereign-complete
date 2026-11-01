#!/usr/bin/env python3
"""Play the whole game's story in the test build, from a new game's own start, the player's room in New Bark Town
(src/location.c): Johto's story past its Hall of Fame, Kanto's eight gyms, the ferry to Sinnoh and Sinnoh's story to its
Hall of Fame, as a player would, without the test warp but across the Sinnoh puzzles listed below:

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
    Gold's), out on the route's other side, where a Rocket between two boulders does the same, and Route 48 to the
    Safari Zone Gate's Pokémon Center, whose nurse, across her counter, offers to heal the player's Pokémon: yes, and
    she's a Team Rocket grunt; their scene sends them to the gate, where a tag battle beside Riley at the gate's
    entrance beats them (Sacred Gold's VAR_HGSS_SG_6130 2), and the man at Olivine Gym leaves.
34. **Jasmine:** the same way back to Olivine City and into its gym: Jasmine's battle, the Mineral Badge and her TM
    (FLAG_HGSS_GOT_TM23_FROM_JASMINE).
35. **Mahogany Town:** north up Routes 39 and 38 and through the gatehouse to Ecruteak City, east through the Route 42
    gatehouse, and along Route 42 (on Surf where it has to) into Mahogany Town (its Fly point recorded) and its
    Pokémon Center.
36. **The red Gyarados:** north through the gatehouse and up Route 43 to the Lake of Rage, and on Surf to beside the
    red Gyarados, wherever it has wandered: its battle, and the Red Scale (FLAG_HGSS_GOT_RED_SCALE).
37. **Lance's request:** back to the shore, where Lance asks for help: yes, and he flies off to Mahogany
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
44. **Goldenrod, taken over:** back over the gym's ice and out into Mahogany Town, where the news of the Radio Tower
    comes (VAR_HGSS_SCENE_ROCKET_TAKEOVER 2) and Elm calls; west along Route 42, through Ecruteak City, down Routes 37
    and 36, through the National Park and down Route 35 into Goldenrod City and its Pokémon Center.
45. **The disguise:** into the underground from Goldenrod's north entrance and down to B1F, where Team Rocket's
    grunts put the player in a Rocket uniform (VAR_HGSS_SCENE_ROCKET_TAKEOVER 3).
46. **The Radio Tower:** back up and into the Radio Tower, where the grunt on 1F's stairs, talked to, steps aside, and
    on the stairs the rival's scene and battle play (VAR_HGSS_SCENE_ROCKET_TAKEOVER 4).
47. **The Basement Key:** up the tower's stairs to 5F, where the director, Petrel in disguise, gives the Basement Key
    (VAR_HGSS_UNK_40E7 2).
48. **The basement:** down the tower and back into the underground, through B1F's locked door with the Basement Key and
    down to B2F, where the rival's scene and battle play on the way west (VAR_HGSS_UNK_40A0).
49. **The warehouse:** B2F's three switches, each of which opens some of its shutters and shuts others, pressed until
    the way to the warehouse is open (the 'switches' action), and in the warehouse, the real director, who gives the
    Card Key (FLAG_HGSS_UNK_1C1).
50. **The Card Key:** up the warehouse's stairs into the Department Store's basement, by its elevator to 1F and out,
    back into the Radio Tower and up to 3F, where the Card Key opens the shutter in the way (FLAG_HGSS_UNK_090).
51. **Archer:** up to 5F and by the elevator to the observation deck, where Archer battles, and then (in Sacred Gold)
    Giovanni; the director thanks the player, and the Radio Tower is free (VAR_HGSS_SCENE_ROCKET_TAKEOVER 5).
52. **Back to Mahogany:** down the tower and back the way the player came, by Routes 35 and 36, the National Park, Route
    37, Ecruteak City and Route 42, to Mahogany Town's Pokémon Center.
53. **The Ice Path's boulder:** east along Route 44 (its trainers) into the Ice Path, over 1F's ice to HM07, down to
    B1F, and Strength's pushes of the first boulder into its hole (tools/complete/solve_story_puzzles.py;
    src/complete_map_info.c): it falls to B2F (FLAG_HGSS_HIDE_ICE_PATH_BOULDER_1_INIT), where it stops a slide over
    the ice; then down to B2F.
54. **Blackthorn City:** across B2F's ice, past the fallen boulder, down to B3F and back up by the far ladders to B1F
    and 1F, where a Kimono Girl the player slides into asks to be let by (yes) and goes, and out into Blackthorn City
    (its Fly point recorded) and its Pokémon Center.
55. **Clair:** into Blackthorn Gym, where the guide puts the follower in its Ball, and over the lava on the gym's
    three floors, each moved and turned by the buttons on it as the player steps on them (the fewest steps, from the
    gym's own data: tools/complete/solve_story_puzzles.py; src/complete_gyms.c), past its trainers to Clair: her
    battle (FLAG_HGSS_UNK_0D1), after which she sends the player to the Dragon's Den.
56. **The Rising Badge:** back to the gym's door on the pad beside Clair, on Surf over the pond behind the gym into the
    Dragon's Den, and across its lake and its whirlpool (Whirlpool, yes) to the shrine, where the elder's quiz plays as
    the player enters (answers he takes: one he doesn't, he asks again), and Clair, there too, gives the Rising Badge
    (FLAG_HGSS_UNK_0EA).
57. **Elm's lab, again:** back over the whirlpool and up out of the den, where Clair gives her TM, over Blackthorn's
    pond and down Routes 45 and 46 and Route 29 to New Bark Town and Elm's lab, where Elm's scene plays
    (VAR_HGSS_SCENE_ELMS_LAB 9); after it, the friend stops the player at the town's east exit until the Bell Tower.
58. **The Dance Theater:** west along Routes 29, 30 and 31, through Violet City and along Routes 36 and 37 to Ecruteak
    City's Dance Theater, where a scene plays at its door (VAR_HGSS_UNK_4079 4).
59. **The Clear Bell:** into the theater, where the Kimono Girls ask to see the player's strength (yes) and battle one
    after another (with Sacred Gold's Rockets between), and give the Clear Bell (FLAG_HGSS_UNK_103).
60. **Ho-Oh:** through the barrier station, whose sage steps aside for the Fog Badge, and the Bell Tower's grounds into
    the tower, up its ladders and over 7F to 9F's warp panels to 10F and the roof, where the Kimono Girls dance and
    Ho-Oh comes down; talked to, it battles, and after it the friend no longer stops the player at New Bark Town's east
    exit (VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT 3).
61. **Down the Bell Tower:** down from the roof by the ladders and warp panels, and out to Ecruteak City.
62. **New Bark Town, east:** back along Routes 37 and 36, through Violet City and along Routes 31, 30 and 29 to New
    Bark Town, and out of it east on Surf over Route 27's water into Tohjo Falls.
63. **Tohjo Falls:** up its first waterfall (Waterfall, yes), down the other (on Surf, as HeartGold lets a surfer go
    down one), and out onto Route 27 beyond.
64. **The League's gate:** along Route 27 (its trainers, on foot and on Surf) and up Route 26 to the Pokémon League's
    reception gate, where the guard checks the badges (VAR_HGSS_UNK_4110), and on into Victory Road.
65. **Victory Road:** 1F's boulder pushed out of the way; up to 3F, down one of its holes to 2F, 2F's boulder pushed
    aside, up to 3F again, down another hole to 2F, over its ledge and up to 3F's exit, where the rival battles
    (VAR_HGSS_UNK_40C5), and out to Indigo Plateau.
66. **Will:** into the Pokémon League, where the man at the inner door steps aside when talked to, and Will's room:
    his battle (FLAG_HGSS_DEFEATED_WILL).
67. **Koga:** Sacred Gold's Kadabra in each room teleports the player to another member's room (its doors stay shut):
    to Koga's, and his battle (FLAG_HGSS_DEFEATED_KOGA).
68. **Bruno:** by the teleport to Bruno's room, and his battle (FLAG_HGSS_DEFEATED_BRUNO).
69. **Karen:** by the teleport to Karen's room, and her battle (FLAG_HGSS_DEFEATED_KAREN).
70. **Lance:** by the teleport, offered once all four have lost, to Lance's room, where his scene and battle play,
    and on into the Hall of Fame: its scene, the game cleared and saved (FLAG_HGSS_GAME_CLEAR), the game started over
    (src/clear_game.c's ClearGame_Johto) and continued, in the player's room in New Bark Town.
71. **The S.S. Ticket:** downstairs (Mom has a word) and over to Elm's lab, where Elm gives the S.S. Ticket
    (FLAG_HGSS_GOT_SS_TICKET_FROM_ELM).
72. **Olivine's port:** west along Routes 29 to 31, through Violet City, along Route 36, where the Sudowoodo is back
    (the Hall of Fame brings back the Pokémon not caught) and battles again after the SquirtBottle, along Route 37,
    through Ecruteak City and along Routes 38 and 39 to Olivine City's port, where the sailor checks the ticket and
    lets the player by.
73. **The S.S. Aqua:** out to the gangway, whose sailor takes the player aboard; the ship sails. On board, the gentleman
    whose granddaughter is missing; a sailor's word on B1F; Sailor Stanly's battle in the southeast rooms; up B1F's
    far ladder to the captain's room, where the girl runs off; and on B1F, found, she takes the player to her
    grandfather, and the ship arrives (FLAG_HGSS_BOAT_ARRIVED).
74. **Vermilion City:** to the ship's door, whose sailor steps aside, and out through Vermilion's port, whose sailor
    lets the player through, into Vermilion City (its Fly point recorded).
75. **Diglett's Cave:** east to Diglett's Cave, whose door is on Vermilion's side of the Snorlax asleep on Route 11
    (Vermilion Gym's leader is away, and the gatehouses into Saffron and the Underground Path are shut until the Power
    Plant runs again), down its ladder, through it and up, out onto Route 2 and north into Pewter City.
76. **Brock:** into Pewter Gym, to Brock: his battle, the Boulder Badge and his TM (FLAG_HGSS_GOT_TM80_FROM_BROCK),
    which sends the scientist at Mt. Moon's door on his way.
77. **Mt. Moon:** east along Route 3 into Mt. Moon, where the rival waits and battles, through it and out onto Route 4,
    east into Cerulean City.
78. **The Power Plant:** east along Route 9 and down Route 10's river by Surf to the Power Plant, whose manager tells of
    the part stolen from its generator; on the way out, an officer brings word of a thief seen in Cerulean
    (VAR_HGSS_UNK_411C).
79. **Cerulean Gym's Rocket:** back up the river and west to Cerulean Gym, where a Rocket runs into the player and off,
    and Misty is out on a date (VAR_HGSS_SCENE_ROUTE_24_ROCKET).
80. **Route 24's Rocket:** north onto the Nugget Bridge, where he runs from the player, and his battle: the part is in
    Cerulean Gym's pool (VAR_HGSS_SCENE_ROUTE_24_ROCKET 3).
81. **The Machine Part:** back to Cerulean Gym, where it's found by the pool (VAR_HGSS_SCENE_ROUTE_24_ROCKET 4).
82. **Misty:** along Routes 24 and 25 to the cape, where the player cuts Misty's date short and she goes back to her
    gym; back to Cerulean Gym: her battle, the Cascade Badge and her TM (FLAG_HGSS_GOT_TM03_FROM_MISTY), which brings
    Vermilion Gym's leader back.
83. **The power restored:** down the river again with the part to the Power Plant's manager, who gets the generator
    running (FLAG_HGSS_RESTORED_POWER), which opens the gatehouses around Saffron and the Underground Path.
84. **Lt. Surge:** back up the river to Cerulean, south along Route 5, through the Underground Path to Route 6 and on
    into Vermilion Gym, where the two trash cans that hide its switches (placed as the player arrives, read from the
    save) are checked in turn, opening its two gates, to Lt. Surge: his battle, the Thunder Badge and his TM
    (FLAG_HGSS_GOT_TM34_FROM_LT_SURGE), which sends the man at Rock Tunnel's door on his way.
85. **Rock Tunnel:** back through the Underground Path and Cerulean, east along Route 9 into Rock Tunnel, down and up
    its ladders and out onto Route 10's south, on into Lavender Town (Saffron's gatehouses stay shut until Erika's
    badge, in Sacred Gold).
86. **Fuchsia City:** south down Route 12 (by Surf where its bridges break), along Routes 13 to 15 and through the
    gatehouse into Fuchsia City.
87. **Fuchsia's Shellder:** Sacred Gold's swarm of Shellder and Cloyster, which blocks the gym, the way west and the
    Pokémon Center: Janine asks for help, the player beats the leading Cloyster in the north of the town, the one in
    the east and the one in the Pokémon Center, and back with Janine, the swarm leaves (FLAG_HGSS_SG_3F63).
88. **Janine:** into Fuchsia Gym, past its disguised trainers, to Janine: her battle, the Soul Badge and her TM
    (FLAG_HGSS_GOT_TM84_FROM_JANINE), which opens Saffron Gym's door.
89. **The Cycling Road:** west onto Route 18, on the Bicycle (Mom's, from the start) into its gatehouse, whose guard
    lets only riders through, up the Cycling Road's slope (the key held, as the slope rolls a still bicycle back down),
    through Route 16's gatehouse and off the Bicycle, into Celadon City.
90. **Erika:** into Celadon Gym, to Erika: her battle, the Rainbow Badge and her TM (FLAG_HGSS_GOT_TM19_FROM_ERIKA),
    which opens Saffron's gatehouses.
91. **Sabrina:** east along Route 7, through its gatehouse into Saffron City and Saffron Gym, over four of its warp
    panels to Sabrina: her battle, the Marsh Badge and her TM (FLAG_HGSS_GOT_TM48_FROM_SABRINA), which sends Route 19's
    workmen and the man in Route 2's way home.
92. **Blaine:** back over the gym's panels, south through Route 6's gatehouse, through Diglett's Cave onto Route 2,
    south past where the man stood, through Viridian City and down Route 1 to Pallet Town, by sea down Route 21 to
    Cinnabar Island and along Route 20 to Seafoam Islands' east door (Route 19's sea reaches only its west door, and
    the cave's way from there to the gym takes several Strength boulders), where Blaine keeps his gym since Cinnabar's
    volcano erupted: past three of Sacred Gold's scientists, who step aside after their battles, to Blaine: his
    battle, the Volcano Badge and his TM (FLAG_HGSS_GOT_TM50_FROM_BLAINE).
93. **Cinnabar Island:** out of Seafoam Islands and west by sea to Cinnabar Island, where Blue talks with the player
    and flies home to open his gym (FLAG_HGSS_UNK_129).
94. **Blue:** north by sea along Route 21 to Pallet Town, up Route 1 and through its gatehouse into Viridian City, into
    Viridian Gym and along its arrows to Blue: his battle, the Earth Badge and his TM (FLAG_HGSS_GOT_TM92_FROM_BLUE).
95. **The ferry to Sinnoh:** north through Viridian Forest, whose gatehouses' guards let Earth Badge holders by, down
    Route 2 into Diglett's Cave and back to Vermilion City, through its port, whose sailor lets the player through any
    day, to the gangway.
96. **Twinleaf Town:** the gangway's sailor, with Kanto's eighth badge and Sinnoh's story not begun, offers Twinleaf
    Town, and the ship leaves the player in their room there, where the TV's program ends
    (VAR_PLAYER_HOUSE_SPECIAL_PROGRAM_STATE 1; docs/Features.md, "Sinnoh, the third region").
97-186. **Sinnoh:** Platinum's story as its scripts order it (drafted from them part by part; each part's comment says
    what it plays): Barry, Mom, Rowan's briefcase on Route 201 (the starter to the PC, the party being full), Lake
    Verity, the Pokédex, the Parcel, Jubilife and the Pokétch, Roark, the Valley Windworks, Eterna Forest, Gardenia (her
    gym's clock: floors_blocked), the Galactic building, Route 206, Mt. Coronet, Fantina (Hearthome Gym's doors:
    door), Maylene and the warehouse, Pastoria and Totem Lurantis, Crasher Wake and the chase over Route 213, the
    Psyduck, Celestic Town, the Tea, Canalave and Byron, the lakes, the Snowpoint Temple and Candice, the Galactic HQ,
    Totem Kommo-o, Spear Pillar, Sendoff Spring, Sunyshore, Totem Togedemaru and Volkner, Victory Road, the Elite Four,
    Cynthia and the Hall of Fame. The test warp ('warp') crosses the puzzles the walks don't solve yet, all of them
    Platinum's own and unchanged: Veilstone Gym's punching bags, Pastoria Gym's water levels, Canalave Gym's lifts,
    the Snowpoint Temple's floors, Snowpoint Gym's ice, the Galactic HQ's warp panels, Sunyshore Gym's gears; and the
    Distortion World, built in code, is a warp to Sendoff Spring with what its end sets (its battles aren't played).

The walks between places find their own way over the maps' walkable tiles (ledges one way, no climb or drop the map's
heights and lifts don't allow, so over a bridge or under it, sliding over ice and along Viridian Gym's arrows, around
the people where they stand now (read from the game, as trainers walk over and Mahogany Gym's ice blocks are pushed; a
walk never pushes one), and never onto a warp, or an armed cart trigger in Azalea Gym, twig in Ilex Forest or pit in
Ecruteak Gym, but the one they go to), and take it a step at a time, finding it again whenever a scene or a person moves
the player. A prompt on the way (the test save's Super Repel wearing off), each scene's text and a battle are paged
through with A, which also answers yes, and taps on a move and on a double battle's targets; the battles, trainers' and
wild Pokémon's, are in the test build's god mode (one hit wins, no PP used, no EXP prompts) and Set style, as the test
is about the story's way through, not the battles. A part passes when the field is free on the map it expects, its flag
is set or its var has moved on from 0 (or to a given value), the game's heaps are whole (tools/test/heap_check.py;
HEAP_STEPS=1 checks them after each action), and the following Pokémon (the test party's lead) is beside the player: at
most two steps away, as a scene can leave it diagonally (gCompleteTestFollowerTile; after the starter's scene it was
left by Elm's table before src/complete_follower.c brought it back).
Results: one line per part; a screenshot and a save state of each part's end in OUT_DIR.
VIDEO, a file name, records the run (both screens, every VIDEO_EVERY-th frame, 3 by default, an MPEG-TS file by
ffmpeg, which a stopped run leaves readable), with each part's and action's start in VIDEO.events, as frame numbers of
the recording, for tools/complete/highlights.py.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default); FROM, a part's name, starts there from the save state an earlier
run left in OUT_DIR, or, with JUMP=1, from STATE, warped to the part's start (PART_STARTS) with all sixteen badges:
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_opening.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR [FROM]
"""
import collections
import os
import re
import struct
import subprocess
import sys

import yaml

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
from battle_all_trainers import SWITCH_FRAMES, TAPS, heap_info  # noqa: E402
from check_object_tiles import DIRS, JUMPS, Maps, walkable  # noqa: E402
from drive import KEYS as DRIVE_KEYS, keymask  # noqa: E402
from gift_pokemon import talk_and_answer  # noqa: E402
from heap_check import heap_problems  # noqa: E402
from talk_to_objects import DECOMP, SYMBOLS, WATER, event_maps, header_names, symbols, var_ids, warp  # noqa: E402
from test_hgss_togepi import SAVE_PAGES, SAVE_SECTOR, save_entry_index  # noqa: E402

LAB = 'MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_1F'
NEW_BARK = 'MAP_HEADER_HGSS_NEW_BARK'
AZALEA_GYM = 'MAP_HEADER_HGSS_AZALEA_GYM'
ILEX = 'MAP_HEADER_HGSS_ILEX_FOREST'
ECRUTEAK_GYM = 'MAP_HEADER_HGSS_ECRUTEAK_GYM'
BLACKTHORN_GYM = 'MAP_HEADER_HGSS_BLACKTHORN_GYM'
# Canalave Gym's lifts (Platinum's), as keys: up its floors to Byron, and back down (worked out by a search over the
# gym's collision and its lifts' platforms)
BYRON_WAY_IN = (['UP'] * 8 + ['LEFT'] * 8 + ['UP'] * 3 + ['RIGHT'] * 10 + ['UP'] * 2 + ['RIGHT'] * 2 + ['UP'] +
                ['RIGHT'] * 4 + ['DOWN'] * 2 + ['RIGHT'] * 5 + ['DOWN'] * 11 + ['LEFT'] * 3 + ['UP'] + ['LEFT'] * 4 +
                ['UP'] * 3 + ['LEFT'] * 6 + ['UP'] + ['LEFT'] * 7 + ['DOWN'] * 5 + ['RIGHT'] * 3 + ['UP'] * 2 +
                ['LEFT'] * 3 + ['UP'] * 9 + ['RIGHT'] * 2 + ['UP'] * 8 + ['RIGHT'] * 13 + ['DOWN'] * 2 +
                ['RIGHT'] * 2 + ['DOWN'] * 12 + ['RIGHT'] * 3 + ['UP'] * 14 + ['LEFT'] * 3 + ['DOWN'] +
                ['LEFT'] * 3 + ['DOWN'] * 4 + ['RIGHT'] * 2 + ['LEFT'] * 9 + ['UP'] * 5)  # 186 keys, door (16,27)
# to (16,4) on floor 3, below Byron (16,3); rides platforms 4, 8, 5, 10, 9, 16, 12, 13, 17, 18, 11, 6, 0 (red, to 30)
BYRON_WAY_OUT = (['RIGHT'] * 5 + ['DOWN'] + ['RIGHT'] + ['DOWN'] * 5 + ['LEFT'] * 5 + ['UP'] + ['LEFT'] +
                 ['UP'] * 5 + ['RIGHT'] * 5 + ['DOWN'] * 17 + ['RIGHT'] * 9)  # 55 keys from (16,4), platforms as left
# by the way in, Byron's tile blocked; ends at (16,26), then 'DOWN' onto the door

# (part, its actions, the map it ends on, the var that must have moved on from 0 or the flag that must be set, (var,
# value) for a var that must have that value, ('fly', town) for the town's Fly point, or None). An action is a key to
# press, ('to', (x, z)): a walk to that tile on the map the player is on, ('surf', (x, z)): one that may cross water,
# ('ladder', (x, z), key): a walk onto a ladder, then the key toward it if the step didn't take it, ('talk', answers): A
# to talk to what the player faces, answering its menus (talk_and_answer's), ('meet', (x, z), answers): the same with
# whoever the map put on that tile, wherever they have wandered (by land or water), ('switches', [(x, z), ...], (x,
# z)): the switches below those tiles pressed until their shutters leave a way to the last tile, then the walk there,
# ('push', key): Strength's push of the boulder the player faces that way, ('cans', [(x, z), ...]): Vermilion Gym's
# trash cans that hide its switches, checked (the tiles of its cans by number), ('bike',): onto the Bicycle or off it,
# ('ride', key, n): up the Cycling Road's slope that way, till the player's row (or column) is n, ('slope', key, n):
# up a muddy slope (Route 207's) that way on the Bicycle in 4th gear, from a run-up, till the row is n, ('scene', key,
# answers): a step that starts a scene (into a map whose scene starts as the player arrives), its menus answered as
# talk's are, ('keep', n): the party cut to its first n Pokémon (gSovereignTestPartyKeep, by the test warp onto the
# player's own tile), ('door', [(x, z), ...]): Hearthome Gym's trainer room left by its right door (read from the save),
# ('out', (x, z), key, map): a walk to that tile and the key, unless map comes first (the Great Marsh's game ending on
# the way), or ('warp', (x, z), key[, map[, [(var or flag, value), ...]]]): the test warp to that tile on the map the player is on
# (or that map), facing that way, setting those vars and flags, across a Sinnoh gym or dungeon puzzle of Platinum's the
# walks don't solve yet (Sovereign's own, unchanged here). The stairs and doors warp
# as the player presses toward them from their tile.
PARTS = [('downstairs', [('to', (4, 4)), 'LEFT'], 'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_1F',  # beside the stairs (3,4)
         # (a bedroom state's start can be a tile off, as the TV program ends)
          'VAR_HGSS_SCENE_PLAYERS_HOUSE_1F'),
         ('outside', ['DOWN'] * 8, NEW_BARK, None),
         ('Elm\'s greeting', [('to', (684, 394)), 'UP', ('to', (4, 11)), 'UP'],  # the lab's door (684,393), and up
          # onto the step-on trigger's row (3-6,10)
          LAB, 'FLAG_HGSS_ELMS_LAB_PREVENT_PLAYER_ESCAPE'),
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
         ('Totem Gumshoos', [('to', (450, 361)), 'UP', ('talk', [])],  # Route 32's Totem trial, before Bugsy
          'MAP_HEADER_HGSS_ROUTE_32', 'FLAG_SOVEREIGN_TOTEM_TRIAL_GUMSHOOS'),
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
         ('Totem Vikavolt', [('to', (16, 63)), 'UP', ('talk', [True]),  # the tree cut,
                             ('to', (40, 30)), 'RIGHT', ('talk', [])],  # Ilex Forest's Totem trial, before Whitney
          ILEX, 'FLAG_SOVEREIGN_TOTEM_TRIAL_VIKAVOLT'),
         ('Goldenrod City', [('to', (12, 17)), 'UP',
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
         ('Totem Ribombee', [('to', (6, 25)), 'DOWN', ('to', (371, 333)), 'UP', ('to', (3, 6)), 'UP', ('talk', []),
                             ('to', (5, 9)), 'DOWN', ('to', (358, 325)), 'UP', ('to', (5, 2)), 'UP',
                             ('to', (362, 266)), 'UP', ('to', (25, 2)), 'UP',
                             ('to', (66, 77)), 'UP', ('talk', [])],  # National Park's Totem trial, before Morty
          'MAP_HEADER_HGSS_NATIONAL_PARK', 'FLAG_SOVEREIGN_TOTEM_TRIAL_RIBOMBEE'),
         ('Sudowoodo', [('to', (75, 39)), 'RIGHT',
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
         ('Totem Mimikyu', [('to', (16, 53)), 'DOWN', ('to', (376, 149)), 'UP',
                            ('to', (19, 25)), 'DOWN', ('talk', [])],  # the Burned Tower's Totem trial, before Chuck
          'MAP_HEADER_HGSS_BURNED_TOWER_1F', 'FLAG_SOVEREIGN_TOTEM_TRIAL_MIMIKYU'),
         ('Surf', [('to', (15, 26)), 'DOWN', ('to', (397, 173)), 'UP',
                   ('to', (7, 7)), 'UP', ('talk', []),  # the grunt on the stage
                   ('to', (3, 7)), 'DOWN'],  # the step down from the stage: the gentleman and HM03
          'MAP_HEADER_HGSS_ECRUTEAK_DANCE_THEATER', 'FLAG_HGSS_GOT_HM03'),
         ('Olivine City', [('to', (7, 17)), 'DOWN', ('to', (358, 166)), 'LEFT',
                           ('to', (1, 7)), ('to', (1, 7)), 'LEFT',  # again if Sacred Gold's gentleman, giving his
                           ('to', (272, 258)), 'UP'],  # Iron Plate at the gatehouse's door, walked the player back
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
                                   ('to', (104, 369)), 'UP', ('talk', []),  # the Rocket between the boulders
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
         ("Lance's request", [('surf', (528, 84)), 'UP', ('talk', [True])], 'MAP_HEADER_HGSS_LAKE_OF_RAGE',
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
          'MAP_HEADER_HGSS_MAHOGANY_GYM_LEADER_ROOM', 'FLAG_HGSS_GOT_TM07_FROM_PRYCE'),
         ('Goldenrod, taken over', [('to', (5, 19)), 'DOWN', ('to', (6, 15)), 'DOWN', ('to', (4, 19)), 'DOWN',
                                    ('surf', (422, 175)), 'LEFT', ('to', (1, 7)), 'LEFT',  # Route 42, back
                                    ('to', (374, 238)), 'LEFT', ('to', (1, 7)), 'LEFT',  # Routes 37 and 36
                                    ('to', (40, 86)), 'DOWN', ('to', (25, 11)), 'DOWN',  # the National Park
                                    ('to', (358, 316)), 'DOWN', ('to', (5, 12)), 'DOWN', ('to', (352, 368)), 'UP'],
          'MAP_HEADER_HGSS_GOLDENROD_POKECENTER_1F', ('VAR_HGSS_SCENE_ROCKET_TAKEOVER', 2)),
         ('the disguise', [('to', (8, 19)), 'DOWN', ('to', (347, 334)), 'UP', ('ladder', (8, 4), 'RIGHT'),
                           ('to', (17, 10))],
          'MAP_HEADER_HGSS_GOLDENROD_TUNNEL_B1F', ('VAR_HGSS_SCENE_ROCKET_TAKEOVER', 3)),
         ('the Radio Tower', [('ladder', (4, 4), 'LEFT'), ('to', (5, 9)), 'DOWN', ('to', (342, 349)), 'UP',
                              ('to', (23, 6)), 'UP', ('talk', []), ('to', (23, 5))],  # the grunt steps aside
          'MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_1F', ('VAR_HGSS_SCENE_ROCKET_TAKEOVER', 4)),
         ('the Basement Key', ['RIGHT', ('ladder', (3, 5), 'LEFT'), ('ladder', (12, 5), 'RIGHT'),
                               ('ladder', (3, 5), 'LEFT'), ('meet', (5, 13), [])],
          'MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_5F', ('VAR_HGSS_UNK_40E7', 2)),
         ('the basement', [('ladder', (3, 5), 'LEFT'), ('ladder', (12, 5), 'RIGHT'), ('ladder', (3, 5), 'LEFT'),
                           ('ladder', (23, 5), 'RIGHT'), ('to', (2, 14)), 'DOWN', ('to', (347, 334)), 'UP',
                           ('ladder', (8, 4), 'RIGHT'), ('to', (25, 31)), 'UP', ('talk', []),  # the locked door
                           ('to', (25, 30)), ('ladder', (25, 3), 'LEFT'), ('to', (17, 5))],
          'MAP_HEADER_HGSS_GOLDENROD_TUNNEL_B2F', 'VAR_HGSS_UNK_40A0'),
         ('the warehouse', [('switches', [(8, 9), (9, 9), (10, 9)], (26, 14)), ('to', (20, 14)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_GOLDENROD_TUNNEL_WAREHOUSE', 'FLAG_HGSS_UNK_1C1'),
         ('the Card Key', [('ladder', (28, 4), 'RIGHT'), ('to', (18, 7)), 'UP',  # the Department Store's elevator
                           ('to', (2, 6)), 'LEFT', ('talk', [5]), ('to', (3, 6)), 'DOWN', ('to', (12, 11)), 'DOWN',
                           ('to', (342, 349)), 'UP', ('to', (23, 5)), 'RIGHT', ('ladder', (3, 5), 'LEFT'),
                           ('to', (22, 12)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_3F', 'FLAG_HGSS_UNK_090'),
         ('Archer', [('ladder', (19, 5), 'LEFT'), ('ladder', (23, 5), 'RIGHT'), ('to', (13, 3)), 'UP',
                     ('to', (3, 6)), 'DOWN', ('to', (8, 4)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_OBSERVATION_DECK', ('VAR_HGSS_SCENE_ROCKET_TAKEOVER', 5)),
         ('back to Mahogany', [('to', (8, 13)), 'UP', ('to', (3, 6)), 'DOWN',  # the elevator
                               ('ladder', (19, 5), 'RIGHT'), ('ladder', (19, 5), 'LEFT'),  # 4F's east side
                               ('ladder', (3, 5), 'LEFT'), ('ladder', (23, 5), 'RIGHT'), ('to', (2, 14)), 'DOWN',
                               ('to', (358, 325)), 'UP', ('to', (5, 2)), 'UP',  # Route 35
                               ('to', (362, 266)), 'UP', ('to', (25, 2)), 'UP',  # the National Park
                               ('to', (75, 39)), 'RIGHT', ('to', (10, 7)), 'RIGHT',  # Route 36
                               ('to', (415, 175)), 'RIGHT', ('to', (10, 7)), 'RIGHT',  # Route 37, Ecruteak City
                               ('surf', (534, 183)), 'UP'],  # Route 42
          'MAP_HEADER_HGSS_MAHOGANY_POKECENTER_1F', None),
         ('the Ice Path\'s boulder', [('to', (8, 19)), 'DOWN', ('to', (633, 169)), 'UP',  # Route 44
                                      ('to', (46, 10)), 'RIGHT', ('talk', []),  # HM07, over the ice
                                      ('to', (55, 7)),  # the ladder down to B1F
                                      ('to', (10, 14)), 'UP', ('talk', [True]), ('push', 'UP'), ('to', (10, 13)),
                                      ('push', 'UP'), ('to', (10, 12)), ('push', 'UP'), ('to', (10, 11)), ('push', 'UP'),
                                      ('to', (9, 9)), ('push', 'RIGHT'), ('to', (11, 8)), ('push', 'DOWN'),  # its hole
                                      ('to', (25, 8))],
          'MAP_HEADER_HGSS_ICE_PATH_B2F', 'FLAG_HGSS_HIDE_ICE_PATH_BOULDER_1_INIT'),
         ('Blackthorn City', [('to', (16, 17)), ('ladder', (24, 12), 'UP'), ('ladder', (43, 22), 'UP'),
                              ('ladder', (6, 42), 'UP'), ('to', (55, 28)), 'DOWN', ('talk', [True]),  # the Kimono Girl
                              ('to', (55, 40)), 'DOWN', ('to', (674, 176)), 'UP'],
          'MAP_HEADER_HGSS_BLACKTHORN_POKECENTER_1F', ('fly', 'MAP_HEADER_HGSS_BLACKTHORN')),
         ('Clair', [('to', (8, 19)), 'DOWN', ('to', (668, 152)), 'UP',  # the gym; its floors:
                    ('to', (13, 76)), 'UP', ('to', (13, 75)), 'LEFT', ('to', (7, 75)), 'RIGHT', ('to', (8, 75)),
                    'DOWN', ('to', (8, 76)), 'UP', ('to', (8, 75)), 'RIGHT', ('to', (8, 57)), 'RIGHT',
                    ('to', (9, 53)), 'DOWN', ('to', (9, 54)), 'RIGHT', ('to', (14, 54)), 'LEFT', ('to', (12, 54)),
                    'RIGHT', ('to', (13, 54)), 'RIGHT', ('to', (14, 33)), 'UP', ('to', (14, 32)), 'LEFT',
                    ('to', (8, 32)), 'RIGHT', ('to', (9, 32)), 'UP', ('to', (9, 31)), 'DOWN', ('to', (9, 32)),
                    'RIGHT', ('to', (15, 32)), 'LEFT', ('to', (14, 32)), 'UP', ('to', (14, 26)), 'DOWN',
                    ('to', (14, 27)), 'UP', ('to', (14, 21)), 'DOWN', ('to', (14, 22)), 'UP', ('to', (14, 16)),
                    'DOWN', ('to', (14, 17)), 'RIGHT', ('to', (20, 17)), 'LEFT', ('to', (19, 17)), 'UP',
                    ('to', (19, 11)), 'DOWN', ('to', (19, 12)), 'UP', ('to', (12, 4)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_BLACKTHORN_GYM', 'FLAG_HGSS_UNK_0D1'),
         ('the Rising Badge', [('to', (5, 9)),  # the pad by Clair, back to the gym's door
                               ('to', (13, 87)), 'DOWN', ('surf', (672, 133)), 'UP',  # over the pond to the Dragon's Den
                               ('to', (6, 5)), ('surf', (14, 35)), 'DOWN', ('talk', [True]),  # its whirlpool, yes
                               ('surf', (28, 51)), ('scene', 'UP', [0, 0, 1, 0, 1])],  # the shrine: the quiz
          'MAP_HEADER_HGSS_DRAGONS_DEN_SHRINE', 'FLAG_HGSS_UNK_0EA'),
         ('Elm\'s lab, again', [('to', (6, 19)), 'DOWN', ('surf', (14, 39)), 'UP', ('talk', [True]),  # the whirlpool
                               ('surf', (28, 7)), ('ladder', (28, 6), 'UP'),  # Clair's scene on the way
                               ('to', (6, 9)), 'DOWN', ('surf', (626, 380)), 'DOWN',  # Routes 45 and 46
                               ('to', (5, 12)), 'DOWN', ('to', (684, 394)), 'UP'],  # Route 29, New Bark Town
          'MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_1F', ('VAR_HGSS_SCENE_ELMS_LAB', 9)),
         ('the Dance Theater', [('to', (4, 14)), 'DOWN', ('to', (518, 269)), 'LEFT',  # Routes 29, 30 and 31
                                ('to', (1, 7)), 'LEFT', ('to', (454, 246)), 'LEFT', ('to', (1, 7)), 'LEFT',  # Violet
                                ('to', (397, 174))],  # Routes 36 and 37 to Ecruteak City's theater
          'MAP_HEADER_HGSS_ECRUTEAK', ('VAR_HGSS_UNK_4079', 4)),
         ('the Clear Bell', [('scene', 'UP', [True])],  # into the theater: the Kimono Girls' battles, yes
          'MAP_HEADER_HGSS_ECRUTEAK_DANCE_THEATER', 'FLAG_HGSS_UNK_103'),
         ('Ho-Oh', [('to', (7, 17)), 'DOWN', ('to', (392, 154)), 'UP',  # the Bell Tower's barrier station
                    ('to', (15, 8)), 'UP', ('talk', []), ('ladder', (15, 3), 'RIGHT'),  # its sage steps aside
                    ('to', (6, 3)), 'RIGHT', ('to', (37, 16)), 'UP',  # the tower's grounds
                    ('ladder', (9, 8), 'UP'), ('ladder', (15, 25), 'UP'), ('ladder', (24, 8), 'UP'),  # 1F to 4F
                    ('ladder', (6, 8), 'UP'), ('ladder', (13, 25), 'UP'), ('ladder', (6, 19), 'UP'),  # to 7F
                    ('to', (15, 26)), ('to', (7, 20)), ('to', (6, 12)), ('to', (16, 9)),  # 7F to 9F's warp panels
                    ('ladder', (12, 17), 'UP'), ('ladder', (15, 25), 'UP'), ('to', (15, 20)),  # 10F, the roof
                    ('meet', (15, 16), [])],  # the Kimono Girls' dance, and Ho-Oh
          'MAP_HEADER_HGSS_BELL_TOWER_ROOF', ('VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT', 3)),
         ('down the Bell Tower', [('to', (15, 24)), ('to', (11, 17)),  # the roof's ladder, 10F's
                                  ('to', (18, 15)), ('to', (23, 17)), ('to', (20, 7)), ('to', (7, 12)),  # the panels
                                  ('to', (6, 19)), ('to', (13, 25)), ('to', (6, 25)), ('to', (24, 8)),  # 7F to 4F
                                  ('to', (15, 25)), ('to', (9, 8)), ('to', (15, 26)), 'DOWN',  # 3F to 1F, out
                                  ('to', (9, 9)), 'LEFT', ('to', (3, 19)), 'LEFT', ('to', (9, 11)), 'DOWN'],
          'MAP_HEADER_HGSS_ECRUTEAK', None),
         ('New Bark Town, east', [('to', (447, 246)), 'RIGHT', ('to', (10, 7)), 'RIGHT',  # Routes 37, 36, Violet
                                  ('to', (511, 269)), 'RIGHT', ('to', (10, 7)), 'RIGHT',  # Routes 31, 30 and 29
                                  ('surf', (740, 397)), 'UP'],  # out of New Bark Town east, Route 27's water
          'MAP_HEADER_HGSS_TOHJO_FALLS', None),
         ('Tohjo Falls', [('surf', (27, 14)), 'UP', ('talk', [True]),  # up its waterfall: Waterfall, yes
                          ('surf', (38, 12)), 'DOWN', ('surf', (45, 20)), 'DOWN'],  # down the other, surfing
          'MAP_HEADER_HGSS_ROUTE_27', None),
         ('the League\'s gate', [('surf', (909, 297)), 'UP', ('to', (11, 3)), 'UP'],  # Routes 27, 26; the badge check
          'MAP_HEADER_HGSS_VICTORY_ROAD_1F', 'VAR_HGSS_UNK_4110'),
         ('Victory Road', [('to', (43, 53)), 'UP', ('talk', [True]), ('push', 'UP'), ('ladder', (19, 7), 'UP'),  # 1F
                           ('ladder', (51, 39), 'UP'), ('to', (55, 42)),  # 2F, 3F, and its hole down to 2F
                           ('to', (51, 28)), 'LEFT', ('talk', [True]), ('push', 'LEFT'), ('to', (50, 28)),
                           ('push', 'LEFT'), ('ladder', (56, 22), 'UP'),  # 2F's boulder out of the way, 3F again
                           ('to', (26, 38)), ('ladder', (27, 45), 'UP'),  # another hole, 2F's ledge, 3F
                           ('to', (38, 14)), 'UP'],  # the rival, and out to Indigo Plateau
          'MAP_HEADER_HGSS_INDIGO_PLATEAU', 'VAR_HGSS_UNK_40C5'),
         ('Will', [('to', (912, 201)), 'UP', ('to', (11, 9)), 'UP', ('talk', []),  # the man at the door steps aside
                   ('to', (11, 8)), 'UP', ('to', (6, 11)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_POKEMON_LEAGUE_WILL_ROOM', 'FLAG_HGSS_DEFEATED_WILL'),
         ('Koga', [('to', (6, 5)), 'UP', ('talk', [0]),  # the Kadabra's teleport, to League Room 2
                   ('to', (6, 12)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_POKEMON_LEAGUE_KOGA_ROOM', 'FLAG_HGSS_DEFEATED_KOGA'),
         ('Bruno', [('to', (6, 5)), 'UP', ('talk', [1]), ('to', (6, 11)), 'UP', ('talk', [])],  # to Room 3
          'MAP_HEADER_HGSS_POKEMON_LEAGUE_BRUNO_ROOM', 'FLAG_HGSS_DEFEATED_BRUNO'),
         ('Karen', [('to', (6, 5)), 'UP', ('talk', [2]), ('to', (6, 11)), 'UP', ('talk', [])],  # to Room 4
          'MAP_HEADER_HGSS_POKEMON_LEAGUE_KAREN_ROOM', 'FLAG_HGSS_DEFEATED_KAREN'),
         ('Lance', [('to', (6, 5)), 'UP', ('talk', [3]), ('to', (6, 10))],  # to Lance's room; his scene
          'MAP_HEADER_HGSS_NEW_BARK_PLAYER_HOUSE_2F', 'FLAG_HGSS_GAME_CLEAR'),  # the Hall of Fame; the game over again
         ('the S.S. Ticket', [('ladder', (3, 4), 'LEFT'), ('to', (3, 10)), 'DOWN',  # downstairs (Mom), out
                              ('to', (684, 394)), 'UP', ('meet', (6, 5), [])],  # Elm's lab: Elm
          'MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_1F', 'FLAG_HGSS_GOT_SS_TICKET_FROM_ELM'),
         ('Olivine\'s port', [('to', (4, 14)), 'DOWN', ('to', (518, 269)), 'LEFT',  # Routes 29, 30 and 31
                              ('to', (1, 7)), 'LEFT', ('to', (454, 246)), 'LEFT', ('to', (1, 7)), 'LEFT',  # Violet
                              ('meet', (415, 246), [True]),  # Route 36's Sudowoodo, back: the SquirtBottle, yes
                              ('to', (358, 166)), 'LEFT', ('to', (1, 7)), 'LEFT',  # Routes 36, 37, Ecruteak City
                              ('to', (279, 276)), 'DOWN', ('to', (7, 8)), 'DOWN', ('talk', [])],  # 38, 39, the sailor
          'MAP_HEADER_HGSS_SS_AQUA_OLIVINE_PORT_INTERIOR', ('VAR_HGSS_BOAT_DIRECTION', 1)),
         ('the S.S. Aqua', [('to', (7, 11)), 'DOWN', ('to', (26, 22)), 'RIGHT', ('talk', []),  # aboard; it sails
                            ('to', (24, 14)),  # the gentleman's granddaughter is missing
                            ('ladder', (24, 3), 'LEFT'), ('to', (37, 17)), 'RIGHT',  # B1F: a sailor's word
                            ('ladder', (24, 3), 'RIGHT'), ('to', (30, 14)), 'DOWN', ('meet', (7, 10), []),  # Stanly
                            ('to', (9, 2)), 'UP', ('ladder', (24, 3), 'LEFT'), ('ladder', (42, 9), 'UP'),
                            ('to', (49, 16)), 'UP', ('meet', (10, 4), []),  # the captain's room: she runs off
                            ('to', (9, 11)), 'DOWN', ('to', (42, 9)), ('meet', (1, 13), [])],  # B1F: found
          'MAP_HEADER_HGSS_SS_AQUA_1F_NORTHWEST_ROOMS', 'FLAG_HGSS_BOAT_ARRIVED'),
         ('Vermilion City', [('to', (9, 11)), 'DOWN', ('to', (24, 16)), 'DOWN', ('talk', []),  # the door's sailor
                             ('to', (24, 19)), 'DOWN', ('to', (12, 12)), 'UP', 'UP',  # into the port's building
                             ('talk', []), ('to', (7, 2)), 'UP'],  # its sailor lets the player through
          'MAP_HEADER_HGSS_VERMILION', ('fly', 'MAP_HEADER_HGSS_VERMILION')),
         ("Diglett's Cave", [('to', (1354, 303)), 'UP',  # its door, west of Route 11's Snorlax
                             ('to', (4, 4)), ('to', (10, 38)), 'UP',  # down its ladder, through, and up
                             ('to', (37, 10)), 'DOWN', ('to', (1048, 107))],  # out onto Route 2, north to Pewter
          'MAP_HEADER_HGSS_PEWTER', ('fly', 'MAP_HEADER_HGSS_PEWTER')),
         ('Brock', [('to', (1047, 93)), 'UP', ('to', (7, 5)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_PEWTER_GYM', 'FLAG_HGSS_GOT_TM80_FROM_BROCK'),
         ('Mt. Moon', [('to', (7, 27)), 'DOWN', ('to', (1172, 103)), 'UP',  # the rival, as the player comes in
                       ('to', (22, 23)), 'DOWN', ('to', (1309, 132))],  # out onto Route 4, east to Cerulean
          'MAP_HEADER_HGSS_CERULEAN', ('fly', 'MAP_HEADER_HGSS_CERULEAN')),
         ('the Power Plant', [('surf', (1423, 185)), 'UP',  # down Route 10's river to its door
                              ('to', (13, 7)), 'DOWN', ('talk', []),  # the manager's story
                              ('to', (14, 16))],  # and the officer's news, on the way out
          'MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_BROKEN', ('VAR_HGSS_UNK_411C', 1)),
         ("Cerulean Gym's Rocket", [('to', (7, 20)), 'DOWN', ('surf', (1318, 135)), 'UP'],  # his scene, coming in
          'MAP_HEADER_HGSS_CERULEAN_GYM', ('VAR_HGSS_SCENE_ROUTE_24_ROCKET', 1)),
         ("Route 24's Rocket", [('to', (10, 25)), 'DOWN', ('to', (1326, 86)), 'UP',  # onto the bridge; he runs
                                ('meet', (1328, 81), [])],  # and his battle
          'MAP_HEADER_HGSS_ROUTE_24', ('VAR_HGSS_SCENE_ROUTE_24_ROCKET', 3)),
         ('the Machine Part', [('to', (1318, 135)), 'UP', ('to', (3, 9)), 'DOWN', ('talk', [])],
          'MAP_HEADER_HGSS_CERULEAN_GYM', ('VAR_HGSS_SCENE_ROUTE_24_ROCKET', 4)),
         ('Totem Araquanid', [('to', (10, 25)), 'DOWN',
                              ('to', (1411, 53)), 'RIGHT', ('talk', [])],  # Route 25's Totem trial, before Misty
          'MAP_HEADER_HGSS_ROUTE_25', 'FLAG_SOVEREIGN_TOTEM_TRIAL_ARAQUANID'),
         ('Misty', [('to', (1418, 41)),  # her date on Route 25, cut short
                    ('to', (1318, 135)), 'UP',  # back in the gym, its trainers out; one who comes down its narrow
                    ('surf', (10, 2)), 'UP', ('talk', [])],  # way to battle may stay in it, so round by the pool
          'MAP_HEADER_HGSS_CERULEAN_GYM', 'FLAG_HGSS_GOT_TM03_FROM_MISTY'),
         ('the power restored', [('surf', (10, 25)), 'DOWN', ('surf', (1423, 185)), 'UP',  # out round the pool too
                                 ('to', (13, 7)), 'DOWN', ('talk', [])],  # the Machine Part, back to the manager
          'MAP_HEADER_HGSS_ROUTE_10_POWER_PLANT_REPAIRED', 'FLAG_HGSS_RESTORED_POWER'),  # the plant, powered
         ('Lt. Surge', [('to', (7, 20)), 'DOWN', ('surf', (1309, 132)),  # back to Cerulean,
                        ('to', (1306, 186)), 'UP',  # south on Route 5
                        ('ladder', (8, 4), 'RIGHT'), ('ladder', (4, 57), 'LEFT'),  # under Saffron
                        ('to', (5, 9)), 'DOWN', ('to', (1295, 320)), 'UP',  # Vermilion Gym; its switches, in two
                        ('cans', [(x, z) for z in (13, 15, 17) for x in (2, 4, 6, 8, 10)]),  # of its trash cans
                        ('to', (6, 5)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_VERMILION_GYM', 'FLAG_HGSS_GOT_TM34_FROM_LT_SURGE'),
         ('Totem Marowak', [('to', (6, 22)), 'DOWN', ('to', (1309, 266)), 'UP',  # back under Saffron,
                          ('ladder', (8, 4), 'RIGHT'), ('ladder', (4, 4), 'LEFT'), ('to', (5, 9)), 'DOWN',
                          ('to', (1309, 132)), ('to', (1419, 164)), 'UP',  # through Cerulean, to Rock Tunnel
                          ('to', (37, 17)), ('to', (8, 7)), 'UP', ('to', (10, 18)),
                          ('to', (35, 27)), 'UP', ('talk', [])],  # Rock Tunnel's Totem trial, before Janine
          'MAP_HEADER_HGSS_ROCK_TUNNEL_B1F', 'FLAG_SOVEREIGN_TOTEM_TRIAL_MAROWAK'),
         ('Lavender Town', [('to', (8, 34)), 'UP',
                            ('to', (23, 36)), 'DOWN', ('to', (1424, 244))],  # up its ladders, to Lavender
          'MAP_HEADER_HGSS_LAVENDER', ('fly', 'MAP_HEADER_HGSS_LAVENDER')),
         ('Fuchsia City', [('surf', (1428, 350)), ('surf', (1380, 370)),  # down Route 12, over its water
                           ('to', (1350, 420)), ('to', (1248, 422)), 'LEFT',  # Routes 13 to 15
                           ('to', (1, 7)), 'LEFT', ('to', (1230, 422))],  # through the gatehouse
          'MAP_HEADER_HGSS_FUCHSIA', ('fly', 'MAP_HEADER_HGSS_FUCHSIA')),
         ("Fuchsia's Shellder", [('to', (1214, 407)), 'UP', ('talk', []),  # Janine asks for help
                                 ('to', (1207, 412)), 'UP', ('talk', []),  # a leading Cloyster in the north,
                                 ('to', (1232, 411)), 'DOWN', ('talk', []),  # one in the east,
                                 ('to', (1209, 440)), 'UP', ('to', (8, 13)), 'UP', ('talk', [True]),  # one in the
                                 ('to', (8, 19)), 'DOWN', ('to', (1214, 407)), 'UP', ('talk', [])],  # Center
          'MAP_HEADER_HGSS_FUCHSIA', 'FLAG_HGSS_SG_3F63'),
         ('Janine', [('to', (1195, 440)), 'UP', ('to', (7, 17)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_FUCHSIA_GYM', 'FLAG_HGSS_GOT_TM84_FROM_JANINE'),
         ('the Cycling Road', [('to', (7, 25)), 'DOWN', ('to', (1162, 426)), 'LEFT',  # Route 18's gatehouse,
                               ('bike',), ('to', (1, 7)), 'LEFT',  # whose guard wants the Bicycle
                               ('to', (1132, 416)), ('ride', 'UP', 299),  # up the Cycling Road
                               ('to', (1151, 276)), 'RIGHT', ('to', (10, 7)), 'RIGHT',  # Route 16's gatehouse
                               ('bike',), ('to', (1190, 258))],  # off the Bicycle, into Celadon
          'MAP_HEADER_HGSS_CELADON', ('fly', 'MAP_HEADER_HGSS_CELADON')),
         ('Totem Raticate', [('to', (1216, 228)), 'DOWN', ('talk', [])],  # Celadon's Totem trial, before Erika
          'MAP_HEADER_HGSS_CELADON', 'FLAG_SOVEREIGN_TOTEM_TRIAL_RATICATE'),
         ('Erika', [('to', (1201, 267)), 'UP', ('to', (7, 4)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_CELADON_GYM', 'FLAG_HGSS_GOT_TM19_FROM_ERIKA'),
         ('Sabrina', [('to', (7, 46)), 'DOWN', ('to', (1273, 240)), 'RIGHT',  # east along Route 7,
                      ('to', (10, 7)), 'RIGHT', ('to', (1328, 205)), 'UP',  # through its gatehouse into Saffron
                      ('to', (18, 22)), ('to', (22, 22)), ('to', (22, 7)), ('to', (2, 7)),  # Saffron Gym's panels
                      ('to', (15, 14)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_SAFFRON_GYM', 'FLAG_HGSS_GOT_TM48_FROM_SABRINA'),
         ('Totem Salazzle', [('to', (18, 17)), ('to', (2, 4)), ('to', (28, 4)), ('to', (28, 25)),  # the panels back
                     ('to', (15, 28)), 'DOWN', ('to', (1300, 253)), 'DOWN', ('to', (5, 12)), 'DOWN',  # Route 6
                     ('to', (1354, 303)), 'UP', ('to', (4, 4)), ('to', (10, 38)), 'UP',  # Diglett's Cave,
                     ('to', (37, 10)), 'DOWN', ('to', (1050, 183)), 'DOWN',  # Route 2, south past the man Sabrina's
                     ('to', (5, 12)), 'DOWN', ('to', (1036, 280)), 'DOWN',  # badge sends home, Viridian City,
                     ('to', (5, 12)), 'DOWN', ('to', (1040, 370)), ('surf', (1036, 495)),  # Pallet Town, Cinnabar,
                     ('to', (1030, 496)), 'LEFT', ('talk', [])],  # and Cinnabar's Totem trial, before Blaine
          'MAP_HEADER_HGSS_CINNABAR_ISLAND', 'FLAG_SOVEREIGN_TOTEM_TRIAL_SALAZZLE'),
         ('Blaine', [('surf', (1127, 502)), 'UP',  # along Route 20 to Seafoam Islands' east door
                     ('to', (55, 24)), 'UP',  # down to its gym, where Sacred Gold's scientists step aside after
                     ('meet', (15, 17), []), ('meet', (20, 14), []), ('meet', (9, 12), []),  # their battles (the
                     # one at (17, 11) steps west into the way, unless talked to from his west)
                     ('to', (13, 13)), 'UP', ('talk', [])],
          'MAP_HEADER_HGSS_SEAFOAM_ISLANDS_CINNABAR_GYM', 'FLAG_HGSS_GOT_TM50_FROM_BLAINE'),
         ('Cinnabar Island', [('to', (14, 25)), ('to', (55, 28)), 'DOWN',  # up and out of Seafoam Islands
                              ('surf', (1036, 495)), 'UP', ('talk', [])],  # west to Cinnabar, where Blue waits
          'MAP_HEADER_HGSS_CINNABAR_ISLAND', 'FLAG_HGSS_UNK_129'),
         ('Blue', [('surf', (1040, 370)), ('to', (1036, 289)), 'UP',  # north by sea to Pallet Town, up Route 1
                   ('to', (5, 2)), 'UP', ('to', (1045, 240)), 'UP',  # into Viridian City and its gym
                   ('to', (5, 5)), 'UP', ('talk', [])],  # along its arrows to Blue
          'MAP_HEADER_HGSS_VIRIDIAN_GYM', 'FLAG_HGSS_GOT_TM92_FROM_BLUE'),
         ('the ferry to Sinnoh', [('to', (5, 47)), 'DOWN', ('to', (1034, 193)), 'UP',  # Route 2's gatehouse, whose
                                  ('to', (5, 2)), 'UP', ('to', (12, 15)), 'UP',  # guard lets Earth Badge holders by,
                                  ('to', (5, 2)), 'UP', ('to', (1048, 138)), 'UP',  # through Viridian Forest
                                  ('to', (43, 6)), ('to', (34, 86)), 'UP', ('to', (4, 6)), 'DOWN',  # Diglett's Cave
                                  ('to', (1309, 340)), 'DOWN', ('to', (7, 8)), 'DOWN', ('talk', []),  # Vermilion's port
                                  ('to', (7, 11)), 'DOWN', ('to', (22, 19))],  # to the gangway's sailor
          'MAP_HEADER_HGSS_SS_AQUA_VERMILION_PORT_EXTERIOR', None),
         # Sinnoh (docs/Features.md, "Sinnoh, the third region")
         ('Twinleaf Town', ['RIGHT', ('talk', [1])],  # the first ship to Sinnoh calls at Twinleaf Town, where the TV's program
          'MAP_HEADER_TWINLEAF_TOWN_PLAYER_HOUSE_2F', ('VAR_PLAYER_HOUSE_SPECIAL_PROGRAM_STATE', 1)),  # ends
         # Sinnoh, stretch A: Platinum's opening, from the end of the TV program to Eterna City
         ('Barry', ['UP'],  # one step off (4, 6) onto his north trigger (4, 5); he rushes in, then leaves
          'MAP_HEADER_TWINLEAF_TOWN_PLAYER_HOUSE_2F', 'VAR_PLAYER_HOUSE_RIVAL_STATE'),
         ('Mom', [('to', (8, 4)), 'RIGHT',  # the stairs (WARP_STAIRS_EAST): downstairs, Mom's "he already left" (OnFrame)
                  ('to', (6, 10)), 'DOWN'],  # the door mat is also her "don't go into tall grass" trigger
          'MAP_HEADER_TWINLEAF_TOWN', ('VAR_PLAYER_HOUSE_STATE', 2)),
         ('Barry\'s house', [('to', (105, 877)), ('scene', 'UP', []),  # the thud at his door pushes the player back
                             ('to', (105, 876)), 'UP', ('to', (2, 3)), 'RIGHT',  # in and up his stairs: he leaves for Route 201
                             ('to', (3, 4)), 'LEFT', ('to', (6, 10)), 'DOWN'],  # (opens the guitarist's way north)
          'MAP_HEADER_TWINLEAF_TOWN', 'FLAG_RIVAL_LEFT_HOME'),
         ('the briefcase', [('to', (111, 858)), ('scene', 'UP', [True, True]),  # Route 201: Barry, the grass, Rowan:
                            ('to', (113, 854)), 'LEFT', ('talk', [True])],  # "love Pokemon?" yes x2; the briefcase,
          # the starter (to the PC if the party is full), Barry's battle (yes), home: Running Shoes and Mom's Bicycle
          'MAP_HEADER_TWINLEAF_TOWN_PLAYER_HOUSE_1F', ('VAR_PLAYER_HOUSE_STATE', 4)),
         ('Lake Verity', [('to', (6, 10)), 'DOWN', ('to', (111, 857)),  # Barry's second trigger: he follows
                          ('to', (80, 844))],  # Verity Lakefront: into the lake; Cyrus, Mesprit's cry, Barry runs off
          'MAP_HEADER_LAKE_VERITY_LOW_WATER', 'VAR_VISITED_LAKE_VERITY_WITH_RIVAL'),
         ('the Pokedex', ['DOWN', 'DOWN', ('to', (163, 845)),  # out of the lake (a turn, then the step)
                          ('scene', 'RIGHT', [False, True])],  # Sandgem: the counterpart leads the player into the
          # lab; Rowan looks at the starter (the test party's own Turtwig, as the new one went to the PC): nickname? no;
          # "record all Pokemon?" yes
          'MAP_HEADER_SANDGEM_TOWN_POKEMON_RESEARCH_LAB', 'VAR_SANDGEM_TOWN_LAB_STATE'),
         ('Sandgem Town', [('to', (7, 15)), 'DOWN'],  # out: Rowan's Poke Radar and Repels, the counterpart's tour
          'MAP_HEADER_SANDGEM_TOWN', ('VAR_SANDGEM_TOWN_STATE', 2)),
         ('the Parcel', [('to', (116, 886)), 'UP', ('to', (7, 9)), 'UP', ('talk', [])],  # home: Mom's rest, the
          'MAP_HEADER_TWINLEAF_TOWN_PLAYER_HOUSE_1F', 'FLAG_RECEIVED_PARCEL'),  # Journal, Barry's mom's Parcel
         ('Route 202', [('to', (6, 10)), 'DOWN', ('to', (180, 827))],  # the counterpart's trigger column (x 180):
          'MAP_HEADER_ROUTE_202', 'VAR_ROUTE_202_STATE'),  # Sovereign's battle in place of the tutorial, 30 Poke Balls
         ('Jubilife City', [('to', (174, 797)), ('scene', 'UP', [True])],  # the counterpart, Looker (any answer), the
          'MAP_HEADER_JUBILIFE_CITY', ('VAR_JUBILIFE_CITY_STATE', 1)),  # VS Recorder, the Trainers' School pointed out
         ('the Trainers\' School', [('to', (168, 776)), 'UP',  # its doorway is a WARP_NORTH tile, not a door
                                    ('to', (6, 4)), 'UP', ('talk', [])],  # Barry: the Parcel for the Town Map
          'MAP_HEADER_TRAINERS_SCHOOL', 'FLAG_TALKED_TO_TRAINERS_SCHOOL_RIVAL'),
         ('the Poketch', [('to', (7, 11)), 'DOWN', ('to', (174, 776))],  # the president's trigger: Sovereign gives
          'MAP_HEADER_JUBILIFE_CITY', 'FLAG_RECEIVED_POKETCH'),  # it at once, no clowns (opens Looker's way east)
         ('Route 203', [('to', (196, 758))],  # Barry's trigger column (x 196): his battle, Sovereign's Exp. Share
          'MAP_HEADER_ROUTE_203', 'VAR_ROUTE_203_RIVAL_STATE'),
         ('Oreburgh City', [('to', (246, 749)), 'RIGHT',  # Oreburgh Gate: the hiker's HM06 (Ravaged Path's rock)
                            ('meet', (7, 20), []), ('to', (27, 22)), 'RIGHT', ('to', (265, 749)), ('scene', 'RIGHT', [])],  # the guide:
          'MAP_HEADER_OREBURGH_CITY', ('VAR_OREBURGH_CITY_STATE', 1)),  # Oval Stone, walked to the gym; Barry blocks it
         ('Roark at the mine', [('to', (302, 795)), 'DOWN', ('to', (12, 21)), 'DOWN',  # Oreburgh Mine B1F, B2F
                                ('to', (18, 29)), 'UP', ('talk', [0])],  # Roark smashes a rock; Sovereign's stone
          'MAP_HEADER_OREBURGH_MINE_B2F', 'FLAG_ROARK_RETURNED_TO_OREBURGH_GYM'),  # list menu (Water Stone)
         ('Roark', [('to', (15, 1)), 'UP', ('to', (12, 1)), 'UP',  # up and out of the mine
                    ('to', (282, 757)), 'UP', ('to', (5, 4)), 'UP', ('talk', [])],  # the gym (Barry has gone)
          'MAP_HEADER_OREBURGH_CITY_GYM', 'FLAG_RECEIVED_ROARK_TM76'),  # Coal Badge, TM76
         ('Barry in Oreburgh', [('to', (5, 24)), 'DOWN', ('to', (263, 749)), ('scene', 'LEFT', [])],  # he runs into
          'MAP_HEADER_OREBURGH_CITY', ('VAR_OREBURGH_CITY_STATE', 3)),  # the player (x 262): Eterna next
         ('Team Galactic in Jubilife', [('to', (258, 749)), 'LEFT', ('to', (4, 22)), 'LEFT',  # back through the gate
                                        ('to', (188, 758)),  # Looker's Pal Pad trigger (x 188) as Jubilife starts
                                        ('to', (174, 744)), ('scene', 'UP', [])],  # the grunts and Rowan: a tag battle
          'MAP_HEADER_JUBILIFE_CITY', ('VAR_JUBILIFE_CITY_STATE', 4)),  # with the counterpart; the Fashion Case
         ('Floaroma Town', [('to', (171, 705)), 'UP',  # Route 204 South into Ravaged Path (WARP_NORTH)
                            ('to', (21, 43)), 'RIGHT', ('talk', [True]),  # Rock Smash on the rock at (22, 43)
                            ('to', (28, 44)), 'DOWN',  # out onto Route 204 North
                            ('to', (176, 667)), 'UP'],  # through Floaroma into its Pokemon Center
          'MAP_HEADER_FLOAROMA_TOWN_POKECENTER_1F', 'FLAG_FIRST_ARRIVAL_FLOAROMA_TOWN'),
         ('the little girl', [('to', (8, 12)), 'DOWN', ('to', (211, 660))],  # Route 205 South: her trigger (x 211);
          'MAP_HEADER_ROUTE_205_SOUTH', ('VAR_VALLEY_WINDWORKS_STATE', 1)),  # Floaroma's grunts go to the meadow
         ('the Works Key', [('to', (162, 641)), 'UP',  # Floaroma Meadow (where Floaroma's two grunts stood)
                            ('to', (12, 48)),  # the grunts' trigger: two battles, the Works Key, Honey
                            ('to', (12, 54)), 'DOWN'],
          'MAP_HEADER_FLOAROMA_TOWN', 'FLAG_OBTAINED_FLOAROMA_MEADOW_WORKS_KEY'),
         ('the Valley Windworks', [('to', (243, 656)), 'UP', ('talk', []),  # the grunt at its door (needs
                   # FLAG_SOVEREIGN_TOTEM_TRIAL_GUMSHOOS, from Johto): his battle, he locks himself in
                   ('to', (243, 655)), 'UP', ('talk', [True]), 'UP',  # the door: use the Works Key? yes; in
                   ('to', (19, 7))],  # past the grunts to Mars's trigger: her battle, the father and daughter
          'MAP_HEADER_VALLEY_WINDWORKS_BUILDING', ('VAR_VALLEY_WINDWORKS_STATE', 2)),
         ('Eterna Forest', [('to', (12, 16)), 'DOWN',  # Looker's scene outside (OnFrame)
                            ('to', (206, 581)), 'UP',  # north over Route 205 South's bridge (its grunts gone)
                            ('to', (28, 85)),  # Cheryl's trigger: Sovereign's battle with her, then she follows
                            ('to', (82, 36))],  # her trigger by the east exit: she leaves, TM27
          'MAP_HEADER_ETERNA_FOREST', 'FLAG_TRAVELED_WITH_CHERYL'),
         ('Eterna City', [('to', (86, 36)), 'RIGHT', ('to', (305, 531)), 'UP'],  # Route 205 North, Eterna's Center
          'MAP_HEADER_ETERNA_CITY_POKECENTER_1F', 'FLAG_FIRST_ARRIVAL_ETERNA_CITY'),
         # Sinnoh, stretch B (Eterna City to Celestic Town)
         ('Cyrus at the statue', [('to', (8, 12)), 'DOWN',  # out of the Pokémon Center
                                  ('to', (303, 524)),  # the rival runs into the player; Cyrus at the statue
                          ('to', (305, 522))],  # Cynthia's HM01 (her trigger: (304-306,522), (304,523-525))
          'MAP_HEADER_ETERNA_CITY', ('VAR_ETERNA_CITY_STATE', 2)),
         ('Gardenia', [('to', (312, 564)), 'UP', ('talk', []),  # she stands in the doorway, then goes in
                       ('to', (312, 563)), 'UP',
                       ('to', (13, 22)), 'RIGHT', ('talk', []),  # Lass Caroline: the clock turns (state 1)
                       ('to', (11, 19)), 'UP',  # over the hour hand (jump tile (11,18)) to (11,17)
                       ('to', (11, 13)), ('to', (17, 13)), ('to', (20, 16)), 'DOWN', ('talk', []),  # Jenna (state 2)
                       ('to', (20, 13)), ('to', (7, 13)), 'LEFT',  # over the hour hand (6,13) to (5,13)
                       ('to', (2, 8)), 'UP', ('talk', []),  # Angela (state 3)
                       ('to', (11, 13)), ('to', (11, 9)), 'UP',  # over the hour hand (11,8) to (11,7)
                       ('to', (11, 4)), 'UP', ('talk', [])],  # Gardenia: the Forest Badge, TM86
          'MAP_HEADER_ETERNA_CITY_GYM', 'FLAG_RECEIVED_GARDENIA_TM86'),
         ('the Galactic building', [('to', (11, 7)), 'DOWN', ('to', (11, 27)), 'DOWN',  # over (11,8) to (11,9), out
                                    ('to', (305, 522)), 'UP', ('talk', [True]),  # Cut the middle tree
                                    'UP', ('talk', []),  # Sovereign's door grunt: battle (Forest Badge), he leaves
                                    'UP', 'UP',  # into 1F: Looker's OnFrame scene
                                    ('ladder', (20, 6), 'LEFT'),  # 1F's east stairs (the west ones lead to a dead end)
                                    ('ladder', (14, 3), 'LEFT'),  # 2F to 3F's west side
                                    ('ladder', (14, 3), 'LEFT'),  # 3F to 4F's west side
                                    ('to', (14, 7)), 'UP', ('talk', [])],  # Jupiter; the hostages freed
          'MAP_HEADER_TEAM_GALACTIC_ETERNA_BUILDING_4F', 'FLAG_TEAM_GALACTIC_LEFT_ETERNA_BUILDING'),
         ('the cycle shop', [('ladder', (3, 3), 'RIGHT'), ('ladder', (2, 3), 'RIGHT'),  # 4F, 3F down
                             ('ladder', (8, 3), 'RIGHT'), ('to', (11, 15)), 'DOWN',  # 2F down, out of 1F
                             ('keep', 5),  # room for Cynthia's Egg (refused, her triggers keep the shop shut); the
                             # test warp it takes reloads the map, so before the Cut
                             ('talk', [True]),  # the trees grew back (map-local flags): Cut the one in front again
                             ('to', (307, 542)), ('scene', 'RIGHT', [True]),  # Cynthia's Togepi Egg, yes
                             ('to', (310, 540)), 'UP', ('to', (3, 6)), 'UP', ('talk', [])],  # Sovereign's Dawn Stone
          'MAP_HEADER_CYCLE_SHOP', 'FLAG_SOVEREIGN_RECEIVED_CYCLE_SHOP_DAWN_STONE'),
         ('the Explorer Kit', [('to', (7, 11)), 'DOWN', ('to', (310, 531)), 'UP',  # the Underground Man's house
                               ('meet', (6, 5), [False]),  # the Explorer Kit; his mentoring: no
                               ('to', (4, 8)), 'DOWN'],  # back out: Eterna's exits open again (OnTransition)
          'MAP_HEADER_ETERNA_CITY', 'FLAG_RECEIVED_EXPLORER_KIT'),
         ('Route 206', [('to', (304, 569)), 'DOWN', ('bike',),  # the north gate (its mat): riders only
                               ('to', (7, 12)), 'DOWN', ('to', (302, 681)), 'DOWN',  # down Route 206's bridge
                               ('to', (7, 12)), 'DOWN', ('bike',),  # the south gate, off the Bicycle
                               ('to', (340, 712))],  # Route 207: Sovereign's counterpart battle, Vs. Seeker
          'MAP_HEADER_ROUTE_207', 'VAR_ROUTE_207_COUNTERPART_TRIGGER_STATE'),
         ('Mt. Coronet', [('to', (341, 712)), 'RIGHT', ('to', (14, 23)),  # Cyrus's scene on the only way
                          ('to', (27, 20)), 'RIGHT'],  # out onto Route 208
          'MAP_HEADER_ROUTE_208', 'VAR_MT_CORONET_1F_SOUTH_STATE'),
         ('Hearthome City', [('to', (447, 726)), 'RIGHT', ('to', (10, 7)), 'RIGHT',  # the gate: Aaron (yes), TM81
                             ('to', (465, 698)), 'UP'],  # Keira's Buneary on the way (x 461), the Pokémon Center
          'MAP_HEADER_HEARTHOME_CITY_POKECENTER_1F', 'VAR_HEARTHOME_CITY_STATE'),
         ('Fantina in the Contest Hall', [('to', (8, 12)), 'DOWN', ('to', (479, 692)), 'UP',  # Keira, Mom (OnFrame)
                                          ('to', (22, 10)), 'UP', ('talk', [])],  # she heads to the gym
          'MAP_HEADER_CONTEST_HALL_LOBBY', 'FLAG_HIDE_HEARTHOME_CITY_GYM_GUIDE'),
         ('Fantina', [('to', (16, 13)), 'DOWN', ('to', (499, 698)), 'UP',  # the guide's first-visit scene
                      ('to', (4, 3)), 'UP',  # into trainer room 1
                      ('door', [(4, 2), (8, 2), (12, 2)]),  # NEW: the right door, read from the save
                      ('door', [(4, 2), (9, 2), (14, 2), (19, 2), (24, 2)]),  # room 2's
                      ('to', (4, 11)), 'UP', ('talk', [])],  # the Relic Badge, TM30 (no Mega Ring: had)
          'MAP_HEADER_HEARTHOME_CITY_GYM_LEADER_ROOM', 'FLAG_RECEIVED_FANTINA_TM65'),
         ('the Route 209 gate', [('to', (14, 3)),  # the panel back to the entrance room
                                 ('to', (4, 8)), 'DOWN', ('to', (505, 726)), 'RIGHT',
                                 ('to', (10, 7)), 'RIGHT'],  # the rival's battle (x 5), the maid: the siege starts
          'MAP_HEADER_ROUTE_209', ('VAR_ROUTE_209_GATE_TO_HEARTHOME_CITY_STATE', 2)),
         ('Solaceon Town', [('to', (560, 669)),  # the rival's news of the ruins
                            ('to', (566, 657)), 'UP'],
          'MAP_HEADER_SOLACEON_TOWN_POKECENTER_1F', 'VAR_SOLACEON_TOWN_STATE'),
         ('Veilstone City', [('to', (8, 12)), 'DOWN', ('to', (671, 598)), 'RIGHT',  # Routes 210 and 215
                             ('to', (10, 7)), 'RIGHT',  # the gate
                             ('to', (684, 616))],  # the counterpart and Crasher Wake at the gym
          'MAP_HEADER_VEILSTONE_CITY', 'VAR_VEILSTONE_CITY_CRASHER_WAKE_STATE'),
         ('Maylene', [('to', (684, 612)), 'UP',
                      ('warp', (12, 5), 'UP'), ('talk', [])],  # across the punching bags; the Cobble Badge, TM60
          'MAP_HEADER_VEILSTONE_CITY_GYM', 'FLAG_RECEIVED_MAYLENE_TM60'),
         ('the Galactic warehouse', [('warp', (12, 30), 'DOWN'), 'DOWN',  # back across the bags, out: the
                                     # counterpart asks for help (OnFrame)
                                     ('to', (695, 596)), 'RIGHT', ('talk', [True])],  # team up: the tag battle,
                                     # Looker, into the warehouse with him (OnFrame): HM02's spot, Pastoria next
          'MAP_HEADER_VEILSTONE_CITY_GALACTIC_WAREHOUSE', ('VAR_VEILSTONE_CITY_GALACTIC_WAREHOUSE_STATE', 2)),
         ('Pastoria City', [('to', (8, 11)), 'DOWN', ('to', (718, 638)), 'DOWN',  # the Route 214 gate
                            ('to', (5, 12)), 'DOWN', ('to', (706, 813)), 'DOWN',  # Route 214, Valor Lakefront, the
                            ('to', (8, 11)), 'DOWN',  # Hotel Grand Lake's lobby through to Route 213's beach
                            ('to', (646, 812)), 'LEFT', ('to', (1, 7)), 'LEFT',  # the Pastoria gate
                            ('to', (589, 828))],  # the gym's doormat: the rival's battle
          'MAP_HEADER_PASTORIA_CITY', ('VAR_PASTORIA_CITY_STATE', 2)),
         ('Totem Lurantis', [('to', (610, 809)), 'UP',  # the Great Marsh's gate
                             ('to', (5, 7)), ('scene', 'UP', [True]),  # a Safari Game, yes (x 4 or 5 only)
                             ('to', (54, 85)), 'UP', ('talk', [])],  # Great Marsh 3's Totem trial, after Maylene
          'MAP_HEADER_GREAT_MARSH_3', 'FLAG_SOVEREIGN_TOTEM_TRIAL_LURANTIS'),
         ('Crasher Wake', [('out', (68, 118), 'DOWN', 'MAP_HEADER_PASTORIA_CITY_OBSERVATORY_GATE_1F'),  # out of
                           # the marsh, or its game ends on the way and the player is taken out
                           ('to', (5, 11)), 'DOWN', ('to', (589, 828)), 'UP',
                           ('warp', (13, 5), 'UP'), ('talk', [])],  # across the water levels; the Fen Badge, HM07
          'MAP_HEADER_PASTORIA_CITY_GYM', 'FLAG_RECEIVED_WAKE_TM55'),
         ('the bomb', [('warp', (13, 42), 'DOWN'), 'DOWN',  # back across the water, out: the rival and Wake
                       # outside (OnFrame, STATE 3 -> 4)
                       ('to', (610, 811)), ('scene', 'UP', [])],  # the explosion in the marsh: the grunt runs
                       # east (STATE 5; the tile then pushes the player back, so it's stepped on once)
          'MAP_HEADER_PASTORIA_CITY', ('VAR_PASTORIA_CITY_STATE', 5)),
         ('Route 213', [('to', (636, 812)), 'RIGHT', ('talk', []),  # the grunt (637,812) runs to Route 213
                        ('to', (639, 812)), 'RIGHT', ('to', (10, 7)), 'RIGHT',  # the gate
                        ('to', (653, 812)), 'RIGHT', ('talk', []),  # he runs on to (683,833)
                        ('to', (682, 833)), 'RIGHT', ('talk', [])],  # he runs; Looker's scene
          'MAP_HEADER_ROUTE_213', 'FLAG_ROUTE_213_GRUNT_M_LEFT'),
         ('Valor Lakefront', [('to', (706, 819)), 'UP', ('to', (8, 2)), 'UP',  # through the hotel's lobby
                              ('to', (716, 792)),  # north into Valor Lakefront
                              ('meet', (719, 790), []),  # the grunt runs north to (723,769)
                              ('to', (723, 770)), 'UP', ('talk', [True])],  # his battle; Cynthia, the rival;
                              # yes; the SecretPotion
          'MAP_HEADER_VALOR_LAKEFRONT', ('VAR_PASTORIA_CITY_STATE', 6)),
         ('the Psyduck', [('to', (718, 645)), 'UP', ('to', (5, 2)), 'UP',  # Route 214's gate to Veilstone
                          ('to', (678, 598)), 'LEFT', ('to', (1, 7)), 'LEFT',  # the Route 215 gate
                          ('to', (560, 588)), 'UP', ('talk', [True, True])],  # SecretPotion yes; Cynthia's Old
                          # Charm yes (her scene places her by x 560/561 only)
          'MAP_HEADER_ROUTE_210_SOUTH', 'FLAG_HIDE_ROUTE_210_SOUTH_PSYDUCK'),
         ('Route 210', [('to', (480, 530))],  # north through the fog: Sovereign's counterpart battle
          'MAP_HEADER_ROUTE_210_NORTH', 'VAR_SOVEREIGN_ROUTE_210_COUNTERPART_STATE'),
         ('Celestic Town', [('to', (463, 523)), 'UP', ('talk', [True])],  # the grunt (needs the five trials),
                            # yes: his battle; the elder takes the Old Charm
          'MAP_HEADER_CELESTIC_TOWN', 'FLAG_DELIVERED_OLD_CHARM'),
         ('Cyrus', [('to', (463, 521)), 'UP',  # the cave
                    ('to', (10, 3)), 'UP', ('talk', [True])],  # the painting; Cyrus, yes: his battle; HM03 Surf
          'MAP_HEADER_CELESTIC_TOWN_CAVE', ('VAR_CELESTIC_TOWN_STATE', 1)),
         ('Cynthia in Celestic', [('to', (10, 20)), 'DOWN'],  # her OnFrame scene: Canalave's library next
          'MAP_HEADER_CELESTIC_TOWN', ('VAR_CELESTIC_TOWN_STATE', 2)),
         # --- stretch C: Canalave City to the Hall of Fame ---
         # (from Celestic Town's middle, where stretch B is assumed to end: east by Routes 210 and 209, Hearthome,
         # Route 208, Mt. Coronet 1F South, Route 207, Oreburgh, Oreburgh Gate, Route 203, Jubilife, Route 202,
         # Sandgem, by sea down Routes 219-220 to Route 221; planner waypoints)
         ('the Tea', [('surf', (513, 534)), ('surf', (562, 547)), ('surf', (562, 615)), ('surf', (562, 685)),
                      ('surf', (529, 722)), ('surf', (512, 725)), 'DOWN',  # Route 209's gate to Hearthome
                      ('to', (2, 7)), 'LEFT', ('to', (455, 726)), 'LEFT',  # Hearthome, Route 208's gate
                      ('to', (2, 7)), 'LEFT', ('to', (396, 724)), ('to', (393, 724)), 'LEFT',  # Mt. Coronet 1F South
                      ('surf', (4, 9)), 'UP',  # out onto Route 207
                      ('to', (297, 739)), ('to', (258, 750)), 'UP', ('to', (5, 22)), 'LEFT',  # Oreburgh Gate
                      ('surf', (183, 758)), ('surf', (184, 812)), ('surf', (177, 876)),  # Jubilife, Sandgem
                      ('surf', (219, 904)), ('surf', (280, 913)), ('surf', (306, 910)), 'UP',  # Route 221's lobby
                      ('to', (5, 5)), 'UP', ('talk', [True])],  # Darach (5,4): his battle, yes; the Tea
          'MAP_HEADER_PAL_PARK_LOBBY', 'FLAG_DEFEATED_TRAINER_SOVEREIGN_DARACH_PAL_PARK'),
         ('Canalave City', [('to', (7, 18)), 'DOWN',  # out of the lobby onto Route 221
                            ('surf', (240, 912)), ('surf', (178, 904)), ('surf', (184, 842)), ('surf', (187, 815)),
                            ('surf', (161, 771)), ('to', (128, 760)), 'UP',  # Jubilife's warp 12 (128,759) into
                            # Route 218's east gate (the planner's arrival side; check the mat's direction)
                            ('to', (2, 7)), 'LEFT',  # through it onto Route 218
                            ('surf', (71, 754)), 'LEFT',  # Route 218's west gate (warps 70,754/755)
                            ('to', (2, 7)), 'LEFT',  # the scientist's upgrade (x=7), the policeman takes the Tea (x=2)
                            ('to', (60, 754))],
          'MAP_HEADER_CANALAVE_CITY', ('VAR_ROUTE_218_GATE_TO_CANALAVE_CITY_STATE', 2)),
         ('Barry on the bridge', [('to', (47, 724))],  # the bridge's trigger (x=47, z 723-726): his battle
          'MAP_HEADER_CANALAVE_CITY', ('VAR_CANALAVE_CITY_STATE', 1)),
         ('Byron', [('to', (39, 732)), 'UP'] + BYRON_WAY_IN + [('talk', [])],  # up the lifts' floors
          'MAP_HEADER_CANALAVE_CITY_GYM', ('VAR_CANALAVE_CITY_STATE', 2)),  # also FLAG_RECEIVED_BYRON_TM91
         ('the Canalave Library', BYRON_WAY_OUT + ['DOWN',  # back down and out: Barry's OnFrame
                                   ('to', (37, 720)), 'UP', ('talk', []),  # Barry, with HM04 in the bag
                                   # (Johto's Strength), goes in first
                                   ('to', (37, 719)), 'UP',
                                   ('to', (12, 4)), 'LEFT',  # 1F's stairs (west stairs, 0x5f)
                                   ('to', (12, 4)), 'LEFT'],  # 2F's stairs: 3F's OnFrame scene, the explosion
          'MAP_HEADER_CANALAVE_LIBRARY_3F', 'FLAG_LAKE_VALOR_EXPLODED'),
         ('the explosion', [('to', (3, 3)), 'RIGHT',  # 3F's stairs down (4,3, east stairs)
                            ('to', (3, 4)), 'RIGHT',  # 2F's (4,4)
                            ('to', (11, 10)), 'DOWN'],  # out of 1F: Rowan, the sailor, "I need you at Lake Valor"
          'MAP_HEADER_CANALAVE_CITY', ('VAR_CANALAVE_CITY_STATE', 5)),
         ('Saturn', [('to', (62, 754)), 'RIGHT', ('to', (9, 7)), 'RIGHT',  # Route 218's west gate
                     ('surf', (120, 758)), 'RIGHT', ('to', (9, 7)), 'RIGHT',  # its east gate, into Jubilife
                     ('to', (199, 758)), ('to', (246, 750)), 'UP', ('to', (26, 22)), 'RIGHT',  # Oreburgh Gate
                     ('to', (302, 730)), ('to', (306, 725)), ('slope', 'UP', 716),  # Route 207's slope
                     ('to', (341, 713)), 'UP',  # into Mt. Coronet 1F South
                     ('surf', (27, 19)), 'DOWN',  # out onto Route 208
                     ('to', (444, 725)), ('to', (447, 725)), 'DOWN', ('to', (9, 7)), 'RIGHT',  # its gate, Hearthome
                     ('to', (458, 728)), 'DOWN', ('to', (5, 11)), 'DOWN',  # Route 212's gate, south
                     ('surf', (460, 799)), ('surf', (460, 855)), ('surf', (505, 850)), ('surf', (569, 856)),
                     ('surf', (598, 827)), ('surf', (638, 813)), 'RIGHT', ('to', (9, 7)), 'RIGHT',  # Pastoria, R213 gate
                     ('to', (688, 833)), ('to', (706, 819)), 'UP', ('to', (8, 3)), 'UP',  # through the hotel lobby
                     ('to', (719, 761)), ('to', (718, 761)), 'LEFT',  # Valor Lakefront, the drained lake
                     ('to', (32, 33)), 'UP',  # Valor Cavern (past three grunts' battles on the lake bed)
                     ('to', (14, 20)), 'UP', ('talk', [])],  # Saturn (14,19)
          'MAP_HEADER_VALOR_CAVERN', 'FLAG_DEFEATED_COMMANDER_SATURN_VALOR_CAVERN'),
         ('Mars at Lake Verity', [('to', (14, 28)), 'DOWN', ('to', (51, 11)), 'RIGHT',  # out of the cavern
                   ('to', (706, 811)), ('to', (706, 812)), 'DOWN', ('to', (8, 10)), 'DOWN',  # the hotel lobby
                   ('to', (670, 821)), ('to', (646, 814)), 'UP', ('to', (2, 7)), 'LEFT',  # R213's gate, Pastoria
                   ('surf', (604, 836)), ('surf', (554, 856)), ('surf', (490, 850)), ('surf', (460, 843)),
                   ('surf', (458, 777)), ('surf', (458, 737)), 'UP', ('to', (5, 3)), 'UP',  # R212, its gate
                   ('to', (454, 728)), 'UP', ('to', (2, 7)), 'LEFT',  # Hearthome, R208's gate
                   ('to', (396, 724)), ('to', (393, 724)), 'LEFT', ('surf', (4, 9)), 'UP',  # Mt. Coronet, R207
                   ('to', (297, 739)), ('to', (258, 750)), 'UP', ('to', (5, 22)), 'LEFT',  # Oreburgh Gate, R203
                   ('to', (183, 758)), ('to', (184, 812)), ('to', (145, 844)), ('to', (82, 846)),  # Route 201
                   ('to', (81, 844)), 'UP',  # Verity Lakefront into the lake: Rowan's OnFrame
                   ('to', (55, 39)), 'UP', ('talk', [])],  # Mars (55,38), past four grunts' battles
          'MAP_HEADER_LAKE_VERITY', 'FLAG_TEAM_GALACTIC_LEFT_LAKE_VERITY'),
         ('Acuity Lakefront', [('to', (47, 53)), 'DOWN',  # out of Lake Verity (46-47,54)
                               ('to', (142, 853)), ('to', (180, 829)), ('to', (177, 808)), ('to', (195, 760)),
                               ('to', (246, 750)), 'UP', ('to', (26, 22)), 'RIGHT',  # Route 201 to Oreburgh Gate
                               ('to', (302, 730)), ('to', (306, 725)), ('slope', 'UP', 716),  # Route 207's slope
                               # Route 206: the path under the Cycling Road ends at Wayward Cave's door, so up the
                               ('to', (302, 689)), ('bike',), 'UP',  # Cycling Road: on the Bicycle (no getting on
                               # indoors; the gate's step trigger (row 6) turns back anyone on foot) into its south gate,
                               ('to', (7, 2)),  # out at its top door, at the bridge's foot (302,681)
                               ('to', (305, 681)), ('ride', 'UP', 582),  # up its right lane (the bridge forks round
                               # a gap at rows 645-661; a biker stands in the left lane) to the flat top, the bikers
                               # who see the player battling on the way
                               ('to', (304, 576)), 'UP',  # the north gate (7,12)
                               ('to', (7, 2)), 'UP', ('bike',),  # out into Eterna (304,569), off the Bicycle
                               ('to', (325, 525)), ('to', (379, 532)), 'RIGHT',  # Route 211 West, Mt. Coronet 1F N 1
                               # 1F North Room 1 from Route 211 West's door (2,41): a rock (10,36), then Strength:
                               ('to', (17, 39)), 'RIGHT', ('talk', [True]),  # the boulder (18,39) twice to the right
                               ('push', 'RIGHT'), ('to', (18, 39)), ('push', 'RIGHT'),
                               ('to', (29, 31)), ('push', 'UP'), ('to', (29, 30)), ('push', 'UP'),  # (29,30) three
                               ('to', (29, 29)), ('push', 'UP'),  # times up, out of the narrow way north
                               ('to', (11, 11)), 'UP',  # the top corridor to B1F's stairs (11,10)
                               ('to', (8, 4)), 'UP', ('to', (2, 19)), 'UP',  # 1F North Room 2, out onto Route 216
                               ('to', (305, 402)), ('to', (302, 347)), ('to', (291, 288)),  # Routes 216, 217 (snow)
                               ('to', (310, 244))],  # Acuity Lakefront: Barry's trigger (310-311,244)
          'MAP_HEADER_ACUITY_LAKEFRONT', ('VAR_ACUITY_LAKEFRONT_STATE', 1)),
         ('the temple guards', [('to', (366, 235)), ('to', (366, 199)), 'UP', ('talk', [True])],  # Snowpoint's
          # tremor triggers on the way only shake the screen; Aran (366,198) and Nephenee: yes, their double battle
          'MAP_HEADER_SNOWPOINT_CITY', 'FLAG_DEFEATED_TRAINER_SOVEREIGN_ARAN_SNOWPOINT_TEMPLE'),
         ('the Snowpoint Temple', [('to', (366, 198)), 'UP',  # into the temple (warp 366,197); across its floors'
                                   # rocks, ice and boulder (Platinum's, unchanged) to B5F
                                   ('warp', (10, 15), 'RIGHT', 'MAP_HEADER_SNOWPOINT_TEMPLE_B5F'),
                                   ('to', (11, 15))],  # B5F's trigger: Maylene and Candice, Regigigas, HM08
          'MAP_HEADER_SNOWPOINT_TEMPLE_B5F', ('VAR_MAP_LOCAL_0x01', 1)),
         ('Candice', [('warp', (8, 13), 'DOWN', 'MAP_HEADER_SNOWPOINT_TEMPLE_1F'), 'DOWN',  # back up and out
                      ('to', (367, 223)), 'UP',  # the gym (the guide is gone from the door with HM08)
                      ('warp', (11, 4), 'UP'), ('talk', [])],  # across the ice and snowballs to Candice (11,3)
          'MAP_HEADER_SNOWPOINT_CITY_GYM', 'FLAG_RECEIVED_CANDICE_TM72'),
         ('Jupiter at Lake Acuity', [('warp', (11, 28), 'DOWN'), 'DOWN',  # back across the ice, out
                                     ('to', (321, 232)), ('to', (308, 230)), 'UP'],  # Acuity Lakefront, Rock Climb;
          # the lake's OnFrame: Jupiter leaves with Uxie, Barry
          'MAP_HEADER_LAKE_ACUITY', ('VAR_LAKE_ACUITY_STATE', 2)),
         ('the Storage Key', [('to', (15, 49)), 'DOWN',  # out of Lake Acuity (14-15,50)
                              ('to', (291, 280)), ('to', (304, 337)), ('to', (301, 398)), ('to', (368, 401)),
                              ('to', (375, 403)), 'RIGHT',  # Routes 217, 216, into Mt. Coronet 1F North Room 2
                              # (its door (375,403) faces east, past the signpost on 375,402)
                              ('to', (10, 26)), 'DOWN', ('to', (7, 60)), 'RIGHT',  # B1F (Rock Smash rocks), its east stairs (8,60) to 1F N 1
                              ('to', (29, 29)), 'DOWN', ('talk', [True]), ('push', 'DOWN'),  # Strength: the boulder
                              # (29,30) down a tile, out of the narrow way south
                              ('to', (29, 34)), 'DOWN',  # out onto Route 211 East
                              ('surf', (476, 539)), ('surf', (532, 531)), ('surf', (561, 568)),  # Celestic, R210 N,
                              ('surf', (596, 593)), ('surf', (642, 585)), ('surf', (671, 597)), 'DOWN',  # Route 215
                              ('to', (9, 7)), 'RIGHT',  # its gate into Veilstone
                              ('to', (721, 594)), 'UP', ('talk', [True])],  # the
          # grunt (721,593): he runs, Looker: "Will you enter the hideout?" yes
          'MAP_HEADER_VEILSTONE_CITY', ('VAR_VEILSTONE_CITY_GALACTIC_WAREHOUSE_STATE', 3)),
         ('Cyrus at the Galactic HQ', [('to', (701, 592)), 'UP',  # the warehouse
                                       ('to', (8, 8)),  # Looker's trigger (8-9,8): he opens the HQ door, goes in
                                       ('to', (13, 4)), 'UP',  # into HQ B2F (3,16), then across its floors:
                                       ('warp', (8, 12), 'UP', 'MAP_HEADER_GALACTIC_HQ_4F'), ('to', (8, 11))],
          'MAP_HEADER_GALACTIC_HQ_4F', ('VAR_GALACTIC_HQ_4F_STATE', 1)),  # Cyrus's trigger (8-9,11), the Master Ball
         ('Saturn at the Galactic HQ', [('warp', (36, 3), 'UP', 'MAP_HEADER_GALACTIC_HQ_LABORATORY'), 'UP',
                                       ('to', (8, 7)), 'UP', ('talk', []),  # Saturn (8,6): his battle, he steps aside
                                       'UP', ('talk', [True])],  # the button (bg 8,5): yes, the lake guardians freed
          'MAP_HEADER_GALACTIC_HQ_CONTROL_ROOM', 'FLAG_FREED_GALACTIC_HQ_POKEMON'),
         ('Totem Kommo-o', [('to', (8, 12)), 'DOWN',  # the control room's way down (8,13) to the lab
                            ('to', (1, 10)), 'DOWN',  # the lab's (1,11) to 4F; 4F's (21,17) down to 1F
                            ('to', (21, 16)), 'DOWN', ('to', (42, 21)), 'DOWN',  # out of the HQ (42,22)
                            ('to', (690, 608)), ('to', (678, 599)), 'LEFT', ('to', (2, 7)), 'LEFT',  # Route 215
                            ('to', (630, 584)), ('to', (572, 597)), ('to', (562, 657)), ('to', (550, 715)),
                            ('to', (512, 725)), 'DOWN', ('to', (2, 7)), 'LEFT',  # Routes 210 and 209, Hearthome
                            ('to', (455, 726)), 'LEFT', ('to', (2, 7)), 'LEFT', ('to', (396, 724)),
                            ('to', (393, 724)), 'LEFT',  # Route 208 into Mt. Coronet 1F South (27,20): Platinum's climb
                            # to Spear Pillar (1F North Room 1's way south from Route 211 East goes one way, the other
                            # way: its boulder (18,43) only goes up its narrow passage)
                            ('surf', (25, 3)), 'RIGHT',  # across 1F South's water to its stairs up (25,3)
                            ('to', (14, 44)), 'DOWN', ('talk', [True]),  # 2F (27,48): Strength, and the boulder
                            ('push', 'DOWN'), ('to', (14, 45)), ('push', 'DOWN'), ('to', (14, 46)),  # (14,45) down
                            ('push', 'DOWN'), ('to', (14, 47)), ('push', 'DOWN'), ('to', (14, 48)),  # its column
                            ('push', 'DOWN'),  # five times, past the way west (13,49)
                            ('to', (7, 24)), 'UP',  # 2F's way north (7,23) to its upper rooms (7,12)
                            ('to', (11, 4)), 'RIGHT',  # their stairs up (11,4) to 3F (14,26)
                            ('to', (3, 29)), 'DOWN',  # out (3,29) onto the snow, Outside South (12,35)
                            ('to', (11, 17)), 'UP',  # in at (11,17) to 4F (7,25), up its Rock Climb walls
                            ('to', (40, 10)), 'RIGHT',  # out (40,10) to Outside North (42,40)
                            ('to', (13, 19)), 'RIGHT',  # in at (13,19) to 4F Room 3 (2,3)
                            ('to', (18, 8)), 'RIGHT',  # its stairs (18,8) to 5F (21,7)
                            ('to', (13, 24)), 'LEFT',  # 5F's stairs (13,24) to 6F (10,24)
                            ('to', (5, 14)), 'UP', ('talk', [])],  # Mt. Coronet
          # 6F's Totem trial (5,13), before Spear Pillar
          'MAP_HEADER_MT_CORONET_6F', 'FLAG_SOVEREIGN_TOTEM_TRIAL_KOMMO_O'),
         ('Spear Pillar', [('to', (7, 6)), 'UP',  # 6F's way out (7,5)
                           ('to', (31, 49)), ('to', (31, 47)),  # the grunts' trigger (31,48): their double battle
                           ('to', (31, 33)), ('scene', 'UP', [True])],  # Mars and Jupiter's (30-32,32): the multi
          # battle with Barry, Cyrus, the warp to the distorted pillar, Cynthia: "Are you ready?" yes
          'MAP_HEADER_DISTORTION_WORLD_1F', ('VAR_SPEAR_PILLAR_STATE', 3)),
         # the Distortion World: its floors, people and triggers are built in code (gravity that turns, lift platforms),
         # which the walks don't drive yet, so its part is a stand-in: the test warp to Sendoff Spring with what its
         # end sets (Cyrus's and Giratina's battles there aren't played)
         ('the Distortion World', [('warp', (32, 17), 'DOWN', 'MAP_HEADER_SENDOFF_SPRING',
                                    [('VAR_DISTORTION_WORLD_PROGRESS', 14), ('VAR_EXITED_DISTORTION_WORLD_STATE', 1)])],
          'MAP_HEADER_SENDOFF_SPRING', ('VAR_EXITED_DISTORTION_WORLD_STATE', 2)),  # Cynthia's OnFrame there
         ('back to Rowan', [('surf', (12, 55)), 'DOWN',  # Spring Path down to Route 214
                            ('to', (726, 690)), ('to', (719, 646)), 'UP', ('to', (5, 3)), 'UP',  # Veilstone's gate
                            ('to', (684, 601)), ('to', (678, 599)), 'LEFT', ('to', (2, 7)), 'LEFT',  # Route 215
                            ('to', (630, 584)), ('to', (572, 597)), ('to', (562, 657)), ('to', (550, 715)),
                            ('to', (512, 725)), 'DOWN', ('to', (2, 7)), 'LEFT',  # Route 210, 209, Hearthome
                            ('to', (455, 726)), 'LEFT', ('to', (2, 7)), 'LEFT', ('to', (396, 724)),
                            ('to', (393, 724)), 'LEFT', ('surf', (4, 9)), 'UP',  # Route 208, Mt. Coronet, 207
                            ('to', (297, 739)), ('to', (258, 750)), 'UP', ('to', (5, 22)), 'LEFT',  # Oreburgh Gate
                            ('to', (183, 758)), ('to', (184, 812)), ('to', (168, 843)), 'UP'],  # Sandgem's lab:
          # Rowan's OnFrame opens Valor Lakefront's way to Sunyshore
          'MAP_HEADER_SANDGEM_TOWN_POKEMON_RESEARCH_LAB', ('VAR_VALOR_LAKEFRONT_BLOCK_SUNYSHORE_STATE', 1)),
         ('Sunyshore City', [('to', (7, 14)), 'DOWN',  # out of the lab
                             ('to', (175, 818)), ('to', (176, 775)), ('to', (229, 758)), ('to', (246, 750)), 'UP',
                             ('to', (26, 22)), 'RIGHT',  # Route 202, Jubilife, Route 203, Oreburgh Gate, Oreburgh
                             ('to', (302, 730)), ('to', (306, 725)), ('slope', 'UP', 716),  # Route 207's slope
                             ('to', (341, 713)), 'UP', ('surf', (27, 19)), 'DOWN',  # Mt. Coronet
                             ('to', (444, 725)), ('to', (447, 725)), 'DOWN', ('to', (9, 7)), 'RIGHT',  # R208, Hearthome
                             ('to', (458, 728)), 'DOWN', ('to', (5, 11)), 'DOWN',  # Route 212
                             ('surf', (460, 799)), ('surf', (460, 855)), ('surf', (505, 850)), ('surf', (569, 856)),
                             ('surf', (598, 827)), ('surf', (638, 813)), 'RIGHT', ('to', (9, 7)), 'RIGHT',  # Pastoria
                             ('to', (688, 833)), ('to', (706, 819)), 'UP', ('to', (8, 3)), 'UP',  # the hotel lobby
                             ('to', (755, 791)),  # Valor Lakefront's east side, its block lifted
                             ('to', (819, 787)), ('to', (825, 789)), 'DOWN',  # Route 222 (planner's key), its gate
                             ('to', (9, 7)), 'RIGHT'],  # into Sunyshore at z 790/791: Flint's OnFrame
          'MAP_HEADER_SUNYSHORE_CITY', ('VAR_SUNYSHORE_CITY_STATE', 1)),
         ('Totem Togedemaru', [('to', (886, 791)), 'UP',  # Vista Lighthouse's door (886,790): its lift's OnFrame
                               ('to', (6, 5)), 'UP', ('talk', []),  # Volkner (6,4): he goes back to his gym
                               ('to', (10, 8)), 'UP', ('talk', [])],  # the Totem (10,7), the last trial
          'MAP_HEADER_VISTA_LIGHTHOUSE', 'FLAG_SOVEREIGN_TOTEM_TRIAL_TOGEDEMARU'),
         ('Volkner', [('to', (6, 10)), 'DOWN',  # down the lift (6,9)
                      ('meet', (845, 748), []),  # Flint on the gym's door: TM50, he leaves
                      ('to', (845, 748)), 'UP',  # across the gears' three rooms
                      ('warp', (11, 4), 'UP', 'MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3'), ('talk', [])],
          'MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_3', ('VAR_SUNYSHORE_CITY_STATE', 2)),  # FLAG_RECEIVED_VOLKNER_TM57
         ('Jasmine in Sunyshore', [('warp', (8, 14), 'DOWN', 'MAP_HEADER_SUNYSHORE_CITY_GYM_ROOM_1'), 'DOWN',  # out
                      ('to', (855, 744)), ('to', (855, 743))],  # Barry and Jasmine's trigger
          'MAP_HEADER_SUNYSHORE_CITY', ('VAR_SUNYSHORE_CITY_STATE', 3)),  # (853-857,743): HM07
         ('Sinnoh\'s Victory Road', [('surf', (849, 694)), ('surf', (841, 642)),  # Route 223
                           ('surf', (849, 605)), 'UP', ('talk', [True]),  # up its waterfall (row 604): Waterfall, yes
                           ('surf', (851, 599)),
                           'UP', 'UP',  # past the guard's check (851,598: 8 badges, Togedemaru), into Victory Road
                           # (851,597)
                           ('to', (9, 42)), ('to', (45, 32)), 'DOWN',  # 1F, to the back rooms (45,33)
                           ('to', (21, 11)), 'UP', ('surf', (37, 39)), ('surf', (56, 14)), 'UP',
                           ('to', (28, 16)), 'RIGHT',  # out onto Route 224
                           ('to', (913, 526)), ('to', (908, 493)), 'UP', ('talk', []),  # Dawn/Lucas (908,492)
                           ('talk', [True])],  # again: yes, the battle
          'MAP_HEADER_ROUTE_224', 'FLAG_SOVEREIGN_ROUTE_224_COUNTERPART_MET'),  # see note: the real proof is a
         # FLAG_DEFEATED_TRAINER_SOVEREIGN_{DAWN,LUCAS}_ROUTE_224_{TURTWIG,CHIMCHAR,PIPLUP}
         ('the Pokémon League', [('to', (897, 533)), ('to', (878, 559)), 'DOWN',  # back into Victory Road
                                 ('to', (13, 16)), 'LEFT', ('surf', (37, 45)), ('surf', (3, 59)), 'UP',
                                 ('to', (5, 19)), 'DOWN', ('to', (34, 7)), 'UP',  # 1F's exit (34,5): the collector
                                 ('surf', (847, 560)), 'UP',  # is gone; the League's Pokémon Center
                                 ('to', (11, 4)),  # Barry's trigger (10-12,4): his battle
                                 'UP', ('talk', [])],  # the door guard (11,3) checks the badges, steps aside
          'MAP_HEADER_POKEMON_LEAGUE_NORTH_POKECENTER_1F', 'FLAG_POKEMON_LEAGUE_DOOR_GUARD_MOVED_AWAY'),
         ('Aaron', [('to', (11, 3)), 'UP',  # the door (11,2), the lift down to his room
                    ('to', (8, 6)), 'UP', ('talk', [0])],  # Aaron (8,5): the format, all singles (0)
          'MAP_HEADER_POKEMON_LEAGUE_AARON_ROOM', 'FLAG_DEFEATED_AARON'),
         ('Bertha', [('to', (8, 3)), 'UP',  # the far door (8,2); the lift (trigger 4,11) to her room
                     ('to', (8, 6)), 'UP', ('talk', [])],
          'MAP_HEADER_POKEMON_LEAGUE_BERTHA_ROOM', 'FLAG_DEFEATED_BERTHA'),
         ('Flint', [('to', (8, 3)), 'UP', ('to', (8, 6)), 'UP', ('talk', [])],
          'MAP_HEADER_POKEMON_LEAGUE_FLINT_ROOM', 'FLAG_DEFEATED_FLINT'),
         ('Lucian', [('to', (8, 3)), 'UP', ('to', (8, 6)), 'UP', ('talk', [])],
          'MAP_HEADER_POKEMON_LEAGUE_LUCIAN_ROOM', 'FLAG_DEFEATED_LUCIAN'),
         ('Cynthia', [('to', (8, 3)), 'UP'],  # the lift to her room, whose OnFrame starts her battle (format fixed)
          'MAP_HEADER_POKEMON_LEAGUE_CHAMPION_ROOM', 'FLAG_DEFEATED_CYNTHIA'),
         ('the Hall of Fame', [('to', (8, 3)), 'UP'],  # the hallway's OnFrame, the Hall's: ClearGame, the credits,
          # OS_ResetSystem; the test must take the title screen's Continue (see notes)
          'MAP_HEADER_TWINLEAF_TOWN_PLAYER_HOUSE_2F', 'FLAG_GAME_COMPLETED')]
# Where JUMP starts a part from the bedroom state, without the parts before it: the test warp's map, tile and facing
# (0 up, 1 down, 2 left, 3 right), with all sixteen of Johto's and Kanto's badges (gCompleteTestHGSSBadges) and their
# Totem trials done (JUMP_FLAGS: Sinnoh's people ask for some of them)
PART_STARTS = {'Twinleaf Town': ('MAP_HEADER_HGSS_SS_AQUA_VERMILION_PORT_EXTERIOR', 22, 19, 3)}
JUMP_FLAGS = ['FLAG_SOVEREIGN_TOTEM_TRIAL_' + p['totem'][len('TOTEM_TRIAL_'):]
              for p in yaml.safe_load(open(os.path.join(DECOMP, '..', 'data', 'complete', 'placed.yaml'),
                                           encoding='utf-8'))['placed'] if 'totem' in p]
# armed step-on triggers (coord events whose var has their value) a walk never steps onto, but the one it goes to, by
# map and the start of their var's name: Azalea Gym's carts (src/complete_gyms.c), Ilex Forest's twigs, which scare a
# Farfetch'd, Ecruteak Gym's pits, Ice Path B1F's holes, which drop the player to B2F, Blackthorn Gym's pads, which
# send the player back to its door, and Victory Road 3F's holes, which drop the player to 2F
AVOIDED_TRIGGERS = {AZALEA_GYM: 'VAR_MAP_LOCAL_0x00', ILEX: 'VAR_HGSS_FARFETCHD', ECRUTEAK_GYM: 'VAR_HGSS_UNK_4109',
                    'MAP_HEADER_HGSS_ICE_PATH_B1F': 'VAR_HGSS_UNK_40AA', BLACKTHORN_GYM: 'VAR_HGSS_UNK_4111',
                    'MAP_HEADER_HGSS_VICTORY_ROAD_3F': 'VAR_HGSS_UNK_40C9'}
# the tile behaviors that warp (include/constants/field/map_tile_behaviors.h: the stairs to the directional warps,
# doors among them) and HeartGold's ladders (Complete's 0x0D-0x0F): a warp event on another tile is part of a wider
# doorway, and a walk may cross it
WARP_TILES = set(range(0x5e, 0x70)) | {0x0d, 0x0e, 0x0f}
# the way each stair, entrance and warp mat is taken (include/constants/field/map_tile_behaviors.h)
MAT_KEYS = {0x5e: 'RIGHT', 0x5f: 'LEFT', 0x62: 'RIGHT', 0x63: 'LEFT', 0x64: 'UP', 0x65: 'DOWN',
            0x6c: 'RIGHT', 0x6d: 'LEFT', 0x6e: 'UP', 0x6f: 'DOWN'}
# water Surf doesn't cross: whirlpools (include/constants/field/complete_tile_behaviors.h) and waterfalls
OTHER_WATER = {0x11, 0x13}
ICE = 0x20  # TILE_BEHAVIOR_ICE: a step onto it slides on (Mahogany Gym, the Ice Path)
RAM, RAM_SIZE = 0x02000000, 0x400000  # the DS's main memory, where the map objects are
MAP_OBJECT_SIZE = 0x128  # sizeof(MapObject), src/map_object.c
PLAYER, FOLLOWER = 0xff, 0xf0  # their local IDs (include/complete_follower.h)
GFX = open(os.path.join(DECOMP, 'generated', 'object_events_gfx.txt')).read().split()
ICE_ROCK = GFX.index('OBJ_EVENT_GFX_ICE_ROCK')  # Mahogany Gym's ice blocks' graphics
CLEARABLE = {GFX.index('OBJ_EVENT_GFX_CUT_TREE'), GFX.index('OBJ_EVENT_GFX_ROCK_SMASH')}  # a walk's way cleared by Cut
# or Rock Smash (A at it, yes)
ROCK_CLIMB = {0x4b, 0x4c}  # TILE_BEHAVIOR_ROCK_CLIMB_N_S, ..._E_W: walls Rock Climb takes the player over (A, yes)
CLEARS = 8  # trees, rocks and Rock Climb walls one walk may clear or climb
SOUTH = 1  # Platinum's DIR_SOUTH: an ice block that faces it can be pushed
MEET_TRIES = 12  # walks to beside someone who wanders, before giving up
MOVE_FRAMES = 120  # a switch's shutters or a pushed boulder moving (two tiles at most)
DOUBLES_TARGETS = ((64, 30), (190, 30))  # the foes' boxes on a double battle's target screen (bottom screen)
KEYS = {(1, 0): 'RIGHT', (-1, 0): 'LEFT', (0, 1): 'DOWN', (0, -1): 'UP'}
IDLE_RUN = 60  # frames to watch for a free field: it updates at 30 Hz, so a free second adds about 30
SHORT_RUN = 20  # a first, short look, so A isn't pressed into a field that is already free
SCENE_FRAMES = 90000  # the longest a scene with battles in it may take (Spear Pillar's: Mars and Jupiter's multi
# battle, Cyrus, Dialga or Palkia, Giratina's shadow and Cynthia, about 35,000 frames)
SETTLE_FRAMES = 30000  # the longest a scene or a talk may take (Mr. Pokémon's and Oak's scene, at the test save's
# text speed; Bugsy's battle and lines)
WALK_STEPS = 600  # the most steps one walk takes
STEP_WAIT = 16  # frames more to wait for a step that hasn't started
FORGETS = 3  # how many times a walk forgets the steps that failed when they leave no way
MARGIN = 40  # tiles around the start and the goal a route may go through
MAGMA = 0x2b  # TILE_BEHAVIOR_COMPLETE_MAGMA: Blackthorn Gym's lava, walkable only where a floor is over it
SLIDES = {0x40: (1, 0), 0x41: (-1, 0), 0x42: (0, -1), 0x43: (0, 1)}  # TILE_BEHAVIOR_SLIDE_*: Viridian Gym's arrows
STOP_SLIDING = 0x4d  # TILE_BEHAVIOR_COMPLETE_STOP_SLIDING: a slide ends on it
COLLISION = 0x8000  # a tile's collision bit (src/terrain_collision_manager.c)
# Blackthorn Gym's floors in the save (MiscSaveBlock: 128 BerryPatches of 14 bytes, then PersistedMapFeatures: its ID,
# DYNAMIC_MAP_FEATURES_HGSS_BLACKTHORN_GYM, and BlackthornGymPersistedData: u16 x[3], u16 z[3], u8 rotation[3])
MISC_FEATURES, BLACKTHORN_FEATURE = 128 * 14, 15
ETERNA_GYM, ETERNA_FEATURE = 'MAP_HEADER_ETERNA_CITY_GYM', 8  # enum DynamicMapFeatureID
GREAT_MARSH, DEEP_MUD = 'map_matrix_240', {0xa5, 0xa7}  # TILE_BEHAVIOR_MUD_DEEP, ..._MUD_DEEP_WITH_GRASS
MUDDY = {GREAT_MARSH, 'map_matrix_000'}  # the matrices with deep mud: the Great Marsh's and Sinnoh's (Route 212 South)
HEARTHOME_FEATURE = 2


def eterna_clock():
    """Eterna Gym's turning clock (src/overlay008/gym_features.c): the tiles blocked in each of its states (by the
    trainers beaten), the clock's 13 by 13 from (5, 7) and the fountains' row 19 from x 1, which the map's own
    collision shows as floor."""
    src = open(os.path.join(DECOMP, 'src', 'overlay008', 'gym_features.c'), encoding='utf-8').read()
    out = []
    for table, width, x0, z0 in (('sEternaGymClockCollision', 13, 5, 7), ('sEternaGymFountainCollision', 21, 1, 19)):
        body = src.split(table + '[', 1)[1].split('};', 1)[0]
        for i, state in enumerate(re.findall(r'\]\s*=\s*\{([^}]*)\}', body)):
            cells = [int(c) for c in re.findall(r'\d', state)]
            if len(out) <= i:
                out.append(set())
            out[i] |= {(x0 + n % width, z0 + n // width) for n, c in enumerate(cells) if c}
    return out
VERMILION_FEATURE = 11  # DYNAMIC_MAP_FEATURES_HGSS_VERMILION_GYM: VermilionGymPersistedData, u8 switches[2], gates[2]
BICYCLE = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split().index('ITEM_BICYCLE')
# the Bag in the save: its pockets of BagItems (u16 item, u16 quantity), then the item registered to Y (include/bag.h)
BAG_REGISTERED = 4 * sum(int(n) for n in re.findall(r'#define \w+_POCKET_SIZE\s+(\d+)',
                                                     open(os.path.join(DECOMP, 'include', 'bag.h')).read()))
BATTLE_STYLE_SET = 1 << 6  # Options' battleStyle bit (after textSpeed's 4 and soundMode's 2): OPTIONS_BATTLE_STYLE_SET
# the Bicycle's gear in the save (FieldOverworldState's PlayerData, include/field_overworld_state.h: five Locations,
# bgm, weather, blackOutWarpId, cameraType, the map history, then cyclingGear): 1 is 4th gear, which climbs muddy slopes
CYCLING_GEAR = 0x8c
PLAYER_STATE = 0x90  # then its playerState: walking 0, cycling 1, surfing 2 (include/constants/player_avatar.h)
RIDE_FRAMES = 4000  # the longest one hold up the Cycling Road may take, battles aside
RIDE_STALL = 64  # frames a held key may leave the player where they are before the ride gives up
RIDE_TRIES = 20  # holds up the Cycling Road, one after each battle on the way (it has 11 bikers)


def blackthorn_floor(index, rotation, x, z):
    """One of Blackthorn Gym's floors (src/complete_gyms.c, BlackthornGym_InitFloor and BlackthornGym_TurnFloor),
    centred on its turn button (x, z) and turned rotation quarter turns: its buttons, the tiles around it its moves and
    turns check, and its walkable tiles, by name; and its width and height. 'move right' is the button beside the turn
    button that moves the floor right (as it points when not turned), 'move left' the other."""
    wide = index != 1
    width, height, right = (5, 7, 3) if wide else (4, 8, 2)
    tiles = {'turn': [(x, z)], 'move right': [(x + 1, z)], 'move left': [(x - 1, z)],
             'right wall': [(x + right, z - 2 + i) for i in range(height)],
             'left wall': [(x - 3, z - 2 + i) for i in range(height)],
             'bottom wall': [(x - 2 + i, z + (5 if wide else 6)) for i in range(width)],
             'top wall': [(x - 2 + i, z - 3) for i in range(width)],
             'edge': [(x + 3, z - 2 + i) for i in range(width)],
             'turn check': [(x - 4 - i, z + (4 if wide else 5) - j) for i in range(2 if wide else 3)
                            for j in range(height)],
             'floor': [(x - 1 + j, z - 1 + i) for i in range(6) for j in range(3)]}

    def turned(p):
        dx, dz = p[0] - x, p[1] - z
        return [p, (x - dz, z + dx), (x - dx, z - dz), (x + dz, z - dx)][rotation]

    return {name: [turned(p) for p in points] for name, points in tiles.items()}, width, height


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


def slide(maps, matrix, at, t, blocked):
    """Where a slide that starts on an arrow tile ends (src/overlay005/ov5_021E1154.c): on in the arrow's way, which
    each arrow passed over turns, over the plain floor too, till a stop tile or a tile it can't enter. Returns that
    tile and its attributes, or None, None for arrows that turn the player round for good."""
    way, seen = SLIDES[t & 0xff], set()
    while (at, way) not in seen:
        seen.add((at, way))
        ahead = (at[0] + way[0], at[1] + way[1])
        t_ahead = maps.tile(matrix, *ahead)
        if t_ahead is None or ahead in blocked or not walkable(t_ahead):
            return at, t
        at, t = ahead, t_ahead
        if (t & 0xff) in SLIDES:
            way = SLIDES[t & 0xff]
        elif (t & 0xff) == STOP_SLIDING:
            return at, t
    return None, None


def route(maps, matrix, start, goal, blocked, steps=frozenset(), heights=None, height=0.0, surf=False, lifts=None,
          pushable=frozenset()):
    """The keys from start to goal over walkable land (a ledge one way), and water with surf, around the blocked tiles
    and without the steps ((tile, direction)) the player couldn't take, or None. With heights, from the player's height:
    a step takes the height nearest it at the next tile, and can't climb or drop 20 or more
    (src/terrain_collision_manager.c), so a bridge and the path under it are told apart. Lifts are the field's dynamic
    plates (a tile's height, as Violet Gym's lift), a height more to choose from at their tiles. Over ice the player
    slides; a slide that would stop at a pushable ice block (Mahogany Gym's) is never taken, as it would push it. An
    arrow tile slides the player on (slide), as in Viridian Gym."""
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
            if (t & 0xff) in SLIDES:
                n, t = slide(maps, matrix, n, t, blocked)
                if n is None:
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


class Recorder:
    """The run on video (VIDEO): every EVERY-th frame the emulator runs, both screens, piped to ffmpeg, which encodes it
    at the game's speed; mark() notes the recording's frame number in PATH.events."""

    def __init__(self, d, path, every):
        # display_buffer_as_rgbx() is BGRX, the top screen above the bottom one
        self.ffmpeg = subprocess.Popen(['ffmpeg', '-loglevel', 'error', '-y', '-f', 'rawvideo', '-pix_fmt', 'bgr0',
                                        '-s', '256x384', '-r', str(60 / every), '-i', '-', '-c:v', 'libx264',
                                        '-preset', 'veryfast', '-crf', '24', '-pix_fmt', 'yuv420p', '-f', 'mpegts',
                                        path], stdin=subprocess.PIPE)
        self.events = open(path + '.events', 'w', encoding='utf-8')
        self.frames = self.ran = 0
        run = d.run

        def recorded(frames):
            for _ in range(frames):
                run(1)
                self.ran += 1
                if self.ran % every == 0:
                    self.ffmpeg.stdin.write(bytes(d.emu.display_buffer_as_rgbx()))
                    self.frames += 1
        d.run = recorded

    def mark(self, what):
        print(self.frames, what, file=self.events, flush=True)

    def close(self):
        self.ffmpeg.stdin.close()
        self.ffmpeg.wait()
        self.events.close()


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    start = sys.argv[4] if len(sys.argv) > 4 else None
    os.makedirs(out, exist_ok=True)
    sym = symbols(SYMBOLS + ('sSaveDataPtr', 'gSovereignTestMenu', 'gCompleteTestFollowerTile',
                             'gCompleteTestHGSSBadges', 'gSovereignTestBagItem'))
    items = open(os.path.join(DECOMP, 'generated', 'items.txt')).read().split()
    names = header_names()
    variables = var_ids()
    towns = fly_points(variables)
    maps = Maps(DECOMP)
    heights = Heights(maps)
    clock_blocked = eterna_clock()
    deep_mud = {}
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
    jump = os.environ.get('JUMP') and PART_STARTS[start]
    if first and not jump:
        state = os.path.join(out, PARTS[first - 1][0].replace(' ', '_') + '.state')
    d = Driver(rom, state)
    mem = d.emu.memory
    mem.write_byte(sym['gSovereignTestGodMode'], 1)  # battles: one hit wins, no PP used, no EXP prompts
    def set_flags(flags):
        """Set these flags on the next test warp (gSovereignTestVar's slots after the warp's own three)."""
        for slot, name in enumerate(flags, 3):
            mem.write_short(sym['gSovereignTestVar'] + 4 * slot, variables[name])
            mem.write_short(sym['gSovereignTestVar'] + 4 * slot + 2, 1)

    if jump:  # from the bedroom state straight to the part's start, with Johto's and Kanto's badges and trials
        d.run(30)
        mem.write_short(sym['gCompleteTestHGSSBadges'], 0xFFFF)
        set_flags(JUMP_FLAGS)
        mem.write_short(sym['gSovereignTestBagItem'], items.index('ITEM_HM04'))  # Johto's Strength, which Barry
        result, frames = warp(d, sym, names.index(jump[0]), jump[1], jump[2], jump[3])  # asks for in Canalave
        if result != 'ok':
            sys.exit(f'JUMP: the warp {result} after {frames} frames')
    elif os.environ.get('SET_FLAGS') or os.environ.get('SET_ITEM'):  # flags or an item a run that started with JUMP
        set_flags(os.environ.get('SET_FLAGS', '').split(',') if os.environ.get('SET_FLAGS') else [])  # before they
        if os.environ.get('SET_ITEM'):  # were in it lacks, given by a test warp onto the player's own tile
            mem.write_short(sym['gSovereignTestBagItem'], items.index(os.environ['SET_ITEM']))
    video = os.environ.get('VIDEO') and Recorder(d, os.environ['VIDEO'], int(os.environ.get('VIDEO_EVERY', 3)))

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def save_block(entry):
        base = u32(sym['sSaveDataPtr'])
        at = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4 + save_entry_index(entry) * 16 + 8
        return base + 20 + u32(at)

    def vars_flags():
        return save_block('SAVE_TABLE_ENTRY_VARS_FLAGS')

    gym = matrix_of.get(BLACKTHORN_GYM)
    gym_lava = {(x, z) for x in range(32) for z in range(96)
                if gym and (maps.tile(gym, x, z) or 0) & (COLLISION | 0xff) == MAGMA}  # lava a floor can be over

    def floors_blocked():
        """In Blackthorn Gym, the lava no floor is over and the floors' buttons, which a walk keeps off (the floors
        where the save has them now: blackthorn_floor); in Eterna Gym, the clock's and fountains' tiles blocked in the
        clock's state now (eterna_clock); in the Great Marsh and on Sinnoh's routes (Route 212 South's marsh), the
        deep mud. Elsewhere nothing."""
        if here() == ETERNA_GYM:
            at = save_block('SAVE_TABLE_ENTRY_MISC') + MISC_FEATURES
            return clock_blocked[u32(at + 4)] if u32(at) == ETERNA_FEATURE else set()
        matrix = matrix_of.get(here())
        if matrix in MUDDY:  # deep mud holds the player fast (src/overlay005's FieldTask_StuckInDeepMud)
            if matrix not in deep_mud:
                grid = maps.matrix(matrix)
                deep_mud[matrix] = {(x, z) for z in range(len(grid) * 32) for x in range(len(grid[0]) * 32)
                                    if (maps.tile(matrix, x, z) or 0) & 0xff in DEEP_MUD}
            return deep_mud[matrix]
        if here() != BLACKTHORN_GYM:
            return set()
        at = save_block('SAVE_TABLE_ENTRY_MISC') + MISC_FEATURES
        if u32(at) != BLACKTHORN_FEATURE:
            return set()
        x, z = [u16(at + 4 + 2 * i) for i in range(3)], [u16(at + 10 + 2 * i) for i in range(3)]
        walk, buttons = set(), set()
        for i in range(3):
            tiles, _, _ = blackthorn_floor(i, mem.unsigned[at + 16 + i], x[i], z[i])
            walk |= set(tiles['floor'])
            buttons |= set(tiles['turn'] + tiles['move right'] + tiles['move left'])
        return (gym_lava - walk) | buttons

    def door(doors):
        """Hearthome Gym: through the trainer room's right door, which the room picks as the player comes in (its
        number, counted over both rooms' doors, in the save: HearthomeGymPersistedFeatures), from the tile before it.
        Returns a problem, or ''."""
        at = save_block('SAVE_TABLE_ENTRY_MISC') + MISC_FEATURES
        if u32(at) != HEARTHOME_FEATURE:
            return f'no Hearthome Gym doors in the save, on {here()}'
        right = struct.unpack('<h', bytes(mem.unsigned[at + 6:at + 8]))[0]
        x, z = doors[right - 3 if right >= 3 and len(doors) == 5 else right]
        problem = walk_to((x, z + 1))
        if not problem:
            step('UP')
        return problem

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

    def clearable():
        """The tiles of the trees Cut clears and the rocks Rock Smash breaks on the map now (as others() reads them)."""
        if player_object[0] is None:
            return set()
        manager = u32(player_object[0] + 0xb4)
        objects, tiles = u32(manager + 0x124), set()
        for i in range(u32(manager + 4)):
            at = objects + MAP_OBJECT_SIZE * i
            status, _, local, _, gfx = struct.unpack('<5I', bytes(mem.unsigned[at:at + 20]))
            if status & 1 and local not in (PLAYER, FOLLOWER) and gfx in CLEARABLE:
                tiles.add(tuple(struct.unpack('<3i', bytes(mem.unsigned[at + 100:at + 112]))[::2]))
        return tiles

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
        teleports = warps_of[matrix] | {tile for tiles, name, _ in triggers_of.get(header, [])
                                        if name.startswith(AVOIDED_TRIGGERS.get(header, '-')) for tile in tiles}
        failed = set()  # (tile, direction) steps the player couldn't take
        forgets, clears = 0, 0
        stuck, last = 0, False
        before = None  # where the player was before the last step
        for n in range(WALK_STEPS):
            if n % 50 == 49:
                print(f'    ... {here()} {d.pos()}', flush=True)  # progress on a long walk
            if not free(SHORT_RUN) and not settle():  # a short look while nothing happens, so a step costs little
                return f'the field never came free on the way to {goal}, on {here()} at {d.pos()}'
            if matrix_of.get(here()) != matrix:
                return '' if last else f'left for {here()} on the way to {goal}'
            pos = d.pos()
            if pos == goal or last and goal in teleports and before is not None \
                    and abs(pos[0] - before[0]) + abs(pos[1] - before[1]) > 2:
                return ''  # there, or the last step took a warp to elsewhere on the same map (Cliff Cave's ladders,
                # Blackthorn Gym's pads); a scene that moved the player instead (Route 38's gatehouse) leaves the walk
                # to go on
            before = pos
            armed = [tiles for tiles, name, value in triggers_of.get(header, [])
                     if name.startswith(AVOIDED_TRIGGERS.get(header, '-')) and var(name) == value]
            avoid = (warps_of[matrix] | set().union(*armed) | floors_blocked()) - {goal}
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
            ahead = (pos[0] + step[0], pos[1] + step[1])
            if clears < CLEARS and (ahead in clearable() or (maps.tile(matrix, *ahead) or 0) & 0xff in ROCK_CLIMB):
                clears += 1  # a tree or a rock in the way, or a wall to climb: Cut, Rock Smash or Rock Climb, as a
                # player would (A at it, yes), and find the way again
                result, frames = talk_and_answer(d, sym, [True], SETTLE_FRAMES)
                if result != 'ok':
                    return f'clearing {ahead}: {result} after {frames} frames, on {here()} at {d.pos()}'
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
        """Talk to whoever the map put on start, who wanders (the Lake of Rage's red Gyarados): to beside them (the
        nearest side the player can reach), wherever they are now, by land or water, then facing them, the talk,
        answered. Returns a problem, or ''."""
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
            # the nearest side the player can reach (one nearer may be walled off: Seafoam Gym's scientists); they
            # may move on meanwhile
            for side in sorted(sides, key=lambda p: abs(p[0] - pos[0]) + abs(p[1] - pos[1])):
                if not walk_to(side, True).startswith('no way'):
                    break
        return f'never beside whoever started on {start}, on {here()} at {d.pos()}'

    def switches(tiles, goal):
        """Switches that move shutters (Goldenrod's underground, B2F): from the tile below each, facing it, A, once
        (talk_and_answer's A for text would press a switch again as its script ends), again only if nothing moved.
        Each press toggles its shutters, so the sets of switches flipped are tried a press at a time (a Gray code),
        until the shutters, where the game has them now, leave a way to goal; then the walk there. Returns a problem,
        or ''."""
        matrix = matrix_of[here()]
        for n in range(1 << len(tiles)):
            people, blocks = others()
            avoid = warps_of[matrix] - {goal}
            if route(maps, matrix, d.pos(), goal, ((people or set()) | avoid) - {d.pos()}, frozenset(), heights,
                     height(), False, lifts(), blocks or ()):
                return walk_to(goal)
            if n == (1 << len(tiles)) - 1:
                break
            flip = (n ^ (n >> 1) ^ (n + 1) ^ ((n + 1) >> 1)).bit_length() - 1  # the switch the next Gray code flips
            problem = walk_to(tiles[flip])
            if problem:
                return problem
            for _ in range(MEET_TRIES):
                d.press('UP', frames=8, after=16)
                before = others()[0]
                d.press('A', frames=4, after=0)  # once: a switch shows no text, and A again would press it again
                d.run(MOVE_FRAMES)
                if not free(IDLE_RUN):
                    return f'the field never came free after the switch at {tiles[flip]}'
                if others()[0] != before:
                    break
            else:
                return f'the switch at {tiles[flip]} moves nothing'
        return f'no set of the switches at {tiles} opens a way to {goal}, on {here()}'

    def switch_cans(tiles):
        """Vermilion Gym's trash cans (src/complete_gyms.c): the two that hide its switches, as the save has them
        (VermilionGymPersistedData; the gym places them as the player arrives), checked in turn from beside each, the
        first can's switch first; each opens one of the gates. tiles: each can's tile, by number. Returns a problem, or
        ''."""
        at = save_block('SAVE_TABLE_ENTRY_MISC') + MISC_FEATURES
        if u32(at) != VERMILION_FEATURE:
            return f'no trash can switches in the save, on {here()}'
        matrix = matrix_of[here()]
        for can in (mem.unsigned[at + 4], mem.unsigned[at + 5]):
            x, z = tiles[can]
            for _ in range(MEET_TRIES):  # a trainer who comes over to battle may stay on the side the walk was for
                sides = [(x - dx, z - dz) for dx, dz in DIRS if maps.tile(matrix, x - dx, z - dz) is not None
                         and walkable(maps.tile(matrix, x - dx, z - dz))
                         and (x - dx, z - dz) not in (others()[0] or ())]
                pos = d.pos()
                if pos in sides:
                    break
                for side in sorted(sides, key=lambda p: abs(p[0] - pos[0]) + abs(p[1] - pos[1])):
                    if not walk_to(side).startswith('no way'):
                        break
            side = d.pos()
            if side not in [(x - dx, z - dz) for dx, dz in DIRS]:
                return f'never beside the trash can at {(x, z)}, on {here()} at {side}'
            d.press(KEYS[(x - side[0], z - side[1])], frames=8, after=16)  # facing the can
            result, frames = talk_and_answer(d, sym, [], SETTLE_FRAMES)
            if result != 'ok':
                return f'the trash can at {(x, z)}: {result} after {frames} frames'
        return ''

    def push(key):
        """Strength's push of the boulder the player faces that way: key, again only if nothing moved (the press
        turned the player); the push runs as a field task and leaves the player where they were. Returns a problem,
        or ''."""
        for _ in range(3):
            before = others()[0]
            d.press(key, frames=8, after=0)
            d.run(MOVE_FRAMES)
            if not free(IDLE_RUN):
                return f'the field never came free after the push {key}, on {here()} at {d.pos()}'
            if others()[0] != before:
                return ''
        return f'the push {key} moved nothing, on {here()} at {d.pos()}'

    def bike():
        """On the Bicycle or off it: Y, with the Bicycle registered to it (the bag's Register, which a player does
        once; the test writes it into the save's Bag). Returns a problem, or ''."""
        at = save_block('SAVE_TABLE_ENTRY_BAG') + BAG_REGISTERED
        if u32(at) != BICYCLE:
            mem.write_long(at, BICYCLE)
        state = save_block('SAVE_TABLE_ENTRY_FIELD_PLAYER_STATE') + PLAYER_STATE
        before = u32(state)
        for _ in range(3):  # a Y the field misses (as a step ends) leaves the player as they were: again
            d.press('Y', frames=4, after=30)
            if not settle():
                return f'the field never came free after Y, on {here()} at {d.pos()}'
            if u32(state) != before:
                return ''
        return f'Y left the player as they were (state {before}), on {here()} at {d.pos()}'

    def ride(key, goal):
        """Up the Cycling Road's slope on the Bicycle: key held till the player's row (or column) is goal's, as between
        steps a bicycle on its bridge rolls back down (src/player_move.c's TILE_MOVE_CYCLING_ROAD_DOWN, whenever no key
        is held). Whatever starts on the way (a biker who sees the player, and his battle) is seen through with the key
        let go, and the ride goes on from wherever the slope left the player. Returns a problem, or ''."""
        axis = 0 if key in ('LEFT', 'RIGHT') else 1
        mask = keymask(DRIVE_KEYS[key])
        for _ in range(RIDE_TRIES):
            d.emu.input.keypad_add_key(mask)
            last, still, quiet, frames = d.pos(), 0, 0, 0
            while frames < RIDE_FRAMES and still < RIDE_STALL and d.pos()[axis] != goal:
                before = u32(sym['gSovereignTestIdleFrames'])
                d.run(4)
                frames += 4
                # the field runs at 30 Hz, and a busy map can skip an update, so only 16 frames without one mean
                # something started: a biker's battle
                quiet = quiet + 4 if u32(sym['gSovereignTestIdleFrames']) == before else 0
                if quiet >= 16:
                    break
                still = still + 4 if d.pos() == last else 0
                last = d.pos()
            d.emu.input.keypad_rm_key(mask)
            if d.pos()[axis] == goal:
                return ''
            if still >= RIDE_STALL:
                return f'the ride {key} stopped at {d.pos()}, on {here()}'
            if not settle():
                return f'the field never came free on the ride {key}, on {here()} at {d.pos()}'
        return f'the ride {key} never reached {goal}, on {here()} at {d.pos()}'

    results = []
    d.run(30)
    # battles in Set style: Shift's 'Will you switch Pokémon?' as a foe falls, which A answers yes, opens the party,
    # where the battle taps can pick the Pokémon already out and go round for good (the save's Options, the first u16
    # of its PlayerSave: include/game_options.h)
    options = save_block('SAVE_TABLE_ENTRY_PLAYER')
    mem.write_short(options, u16(options) | BATTLE_STYLE_SET)
    if (os.environ.get('SET_FLAGS') or os.environ.get('SET_ITEM')) and not jump:
        result, frames = warp(d, sym, names.index(here()), *d.pos(), 0)
        if result != 'ok':
            sys.exit(f'SET_FLAGS: the warp {result} after {frames} frames')
    for name, actions, end_map, marker in PARTS[first:]:
        problem = ''
        # again at each part: a Hall of Fame resets the DS (OS_ResetSystem), which clears the test build's settings, so
        # after Johto's the battles hurt again (Sailor Stanly's Kingdra knocked out the lead on the S.S. Aqua)
        mem.write_byte(sym['gSovereignTestGodMode'], 1)
        if video:
            video.mark(f'part {name}')
        for action in actions:
            if video:
                video.mark(f'action {action!r} {here()}')
            if not settle():
                problem = f'the field never came free before {action}, on {here()} at {d.pos()}'
            elif isinstance(action, str):
                before, start = here(), d.pos()
                step(action)
                for _ in range(3):  # a step onto a gate's or a door's mat (two deep at some gates), which a press
                    # its way takes (a key toward the gate may have stepped onto it from the side)
                    for _ in range(20):  # the map the field is on is noted only once it runs free: until then, after
                        if free(SHORT_RUN):  # a warp, here() is still the map before, and the new map's stairs under
                            break  # the player would read as the old map's mat (taken back up New Bark's stairs)
                    if here() != before or d.pos() not in warps_of[matrix_of.get(here())] \
                            or abs(d.pos()[0] - start[0]) + abs(d.pos()[1] - start[1]) > 2:  # or a warp to elsewhere
                        # on the same map (Mt. Coronet 2F's way north, onto a mat back): taken, so no more presses
                        break
                    step(MAT_KEYS.get((maps.tile(matrix_of[here()], *d.pos()) or 0) & 0xff, action))
            elif action[0] == 'keep':  # the hook applies on the test warp, here onto the player's own tile
                mem.write_byte(sym['gSovereignTestPartyKeep'], action[1])
                result, frames = warp(d, sym, names.index(here()), *d.pos(), 0)
                if result != 'ok':
                    problem = f'the party cut: the warp {result} after {frames} frames, on {here()} at {d.pos()}'
            elif action[0] == 'meet':
                problem = meet(action[1], action[2])
            elif action[0] == 'switches':
                problem = switches(action[1], action[2])
            elif action[0] == 'push':
                problem = push(action[1])
            elif action[0] == 'cans':
                problem = switch_cans(action[1])
            elif action[0] == 'bike':
                problem = bike()
            elif action[0] == 'door':
                problem = door(action[1])
            elif action[0] == 'out':  # a walk out to a map that may come first (the Great Marsh's game ends)
                if here() != action[3]:
                    problem = walk_to(action[1])
                    if problem.startswith('left for') and here() == action[3]:
                        problem = ''
                    elif not problem:
                        step(action[2])
            elif action[0] == 'warp':  # the test warp, across a Sinnoh gym or dungeon puzzle the walks don't solve yet
                face = ('UP', 'DOWN', 'LEFT', 'RIGHT').index(action[2]) + 1
                for slot, (name, value) in enumerate(action[4] if len(action) > 4 else [], 3):  # set on the warp
                    mem.write_short(sym['gSovereignTestVar'] + 4 * slot, variables[name])  # (the first three slots
                    mem.write_short(sym['gSovereignTestVar'] + 4 * slot + 2, value)  # are the warp's own)
                result, frames = warp(d, sym, names.index(action[3] if len(action) > 3 else here()), *action[1], face)
                if result != 'ok':
                    problem = f'the warp across: {result} after {frames} frames, on {here()} at {d.pos()}'
            elif action[0] == 'ride':
                problem = ride(action[1], action[2])
            elif action[0] == 'slope':  # on the Bicycle, into 4th gear (B), the ride up, and off again
                problem = bike()
                at = save_block('SAVE_TABLE_ENTRY_FIELD_PLAYER_STATE') + CYCLING_GEAR
                if not problem and u16(at) != 1:
                    d.press('B', frames=4, after=16)
                    if u16(at) != 1:
                        problem = f'B left the Bicycle in gear {u16(at)}, on {here()} at {d.pos()}'
                problem = problem or ride(action[1], action[2]) or bike()
            elif action[0] == 'scene':  # the step, then the scene it starts, its menus answered (not settle's A)
                step(action[1])
                result, frames = talk_and_answer(d, sym, action[2], SCENE_FRAMES, press_a=False)
                if result != 'ok':
                    problem = f'the scene: {result} after {frames} frames, on {here()} at {d.pos()}'
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
        if video:
            video.mark(f'end {name}: {problem or "ok"}')
        if problem:
            break
    print(f'{sum(r.endswith(": ok") for r in results)} of {len(PARTS) - first} parts ok')
    if video:
        video.close()
    sys.exit(0 if len(results) == len(PARTS) - first and all(r.endswith(': ok') for r in results) else 1)


if __name__ == '__main__':
    main()
