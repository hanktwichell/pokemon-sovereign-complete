# HeartGold's features (step 5)

The features the owner kept (`docs/Roadmap.md`, "HeartGold features"), as they work here, and what's left of each.

## Kurt's Apricorn Balls

Kurt in Azalea Town makes Poké Balls from Apricorns, which grow on 31 trees across Johto and Kanto, one a day each.

- **Trees.** HeartGold's Apricorn trees are people on the map running its `std_apricorn_tree` script, with the tree's
  number in their first parameter (HeartGold's `sTreeApricorns`, `src/apricorn_tree_sys.c`, gives each its colour).
  `tools/complete/import_hgss_events.py` gives them `CommonScript_CompleteApricornTree`
  (`res/field/scripts/scripts_common.s`, common script 0x80F) and HeartGold's tree sprite: with its Apricorn's colour
  of fruit until it's picked that day, bare after (`CompleteApricorns_TreeGfx`, `src/complete_apricorns.c`, as each
  tree's object is made). The script is HeartGold's with its text (in `common_strings.json`): a tree gives its
  Apricorn once a day to a player with the Apricorn Box. A picked tree's flag (`COMPLETE_APRICORN_TREE_FLAGS_START`,
  past HeartGold's and Sacred Gold's flags) is cleared with the daily flags.
- **Apricorns** are bag items (the Items pocket), where HeartGold keeps them in the Apricorn Box. The box is still the
  key item Kurt gives, which lets the player pick them, as in HeartGold.
- **Kurt.** Where HeartGold opens its Apricorn Box, the bag opens on the Items pocket: Kurt takes all of the kind of
  Apricorn the player picks (up to 99) and has as many Balls of its kind the next day (Red: Level, Yellow: Moon,
  Blue: Lure, Green: Friend, Pink: Love, White: Fast, Black: Heavy). He keeps them in two vars, on the two Sacred Gold
  left unused (`VAR_COMPLETE_KURT_BALL`, `VAR_COMPLETE_KURT_QUANTITY`). The commands are in
  `src/complete_apricorns.c`.
- **Daily flags.** HeartGold's 192 daily flags (Kurt making Balls, the haircut brothers, Union Cave's Lapras on
  Fridays, Buena's password, the Trainer House, the Bug-Catching Contest) weren't cleared each day; they are now, with
  Sinnoh's (`FieldSystem_ClearDailyFlags`).

- **The Balls in battle.** The seven are battle items: they are thrown from the bag's Poké Balls pocket, each with
  HeartGold's catch rule (`BattleScript_CalcCatchShakes`, `src/battle/battle_script.c`): Fast ×4 for a base Speed of
  100 or more; Level ×2, ×4 or ×8 as the player's Pokémon's level is over the wild one's, twice it or four times it;
  Lure ×3 on a Pokémon hooked with a rod (battles now know it: `isFishing`); Heavy +20, +30 or +40 from 204.8,
  307.2 and 409.6 kg, and −20 below (the catch rate stays at least 1); Love ×8 for the same species and the other
  gender; Moon ×4 for the Moon Stone's lines; the Sport Ball ×1.5. A Friend Ball's catch starts at 200 friendship.
  The catch rate is capped at 255 after them, as in HeartGold.
- **Keeping the Ball.** A Pokémon keeps HeartGold's Balls (Fast to Park) as HeartGold keeps them: its Ball number
  (17-25) in the byte after Platinum's (`MON_DATA_POKEBALL`, `src/pokemon.c`), with a Poké Ball in Platinum's, so the
  engine's Ball is still an item.
- **Drawing the Ball.** Wherever a Pokémon's Ball is drawn (sending out, the capture, the capsule, the summary, the
  trade room), `Pokemon_BallToDraw` gives the Ball graphics' tables Platinum's 16 as their items and HeartGold's own
  as HeartGold numbers them (`BALL_DRAW_HGSS_FIRST` 17, Fast, to `BALL_DRAW_HGSS_LAST` 25, Park, in `pokemon.h`), and
  each table has HeartGold's rows for them:
  - **Thrown and sent out** (`src/battle_anim/ov12_02235E94.c`): the throw's tiles and palette are HeartGold's
    (`tools/complete/import_hgss_balls.py` takes them from its battle sprites, `a/0/0/8`, members 309 + 3n and 99 + n,
    into `res/graphics/battle/ball_throws/hgss/`, at the end of `sprites.order`; the build compresses the tiles as
    Platinum's are). Their cells and animations are the Poké Ball's, as in HeartGold, and so are their open and catch
    particles (HeartGold's are copies of its Poké Ball's). The new rows come after the special throws' (Pal Park's,
    the Safari Zone's mud and bait, 0xFF + 17 to 20), at `BALL_ROW_HGSS_FIRST`, so no caller changes. The Park
    Ball's tiles are Platinum's own Park Ball's; its palette is HeartGold's.
  - **The flash** as the Pokémon comes out or goes in (`sFadeColors`, `src/battle/battle_display.c`): HeartGold's
    colours, the Poké Ball's pink for Fast to Sport and white for the Park Ball.
  - **The summary screen's icon** (`PokemonSummaryScreen_SetCaughtBallGfx`): HeartGold's icons and their palettes
    (`a/1/6/2`, members 41-48 and 53-60, Fast to Sport) at the end of `pl_pst_gra` (`balls/hgss/`). HeartGold has no
    Park Ball icon (its summary screen reads a palette there), so the Park Ball shows a Poké Ball.
  - **The trade room's cards** have Platinum's 16 Balls' animations, in a prebuilt archive; HeartGold's show a Poké
    Ball there.
  - The catch's own throw (`BattleScript_CatchMonTask`'s `SEQ_CATCH_MON_START`) goes through `Pokemon_BallToDraw` too,
    so the Bug-Catching Contest's Sport Ball is thrown as itself.
- **Test:** `tools/complete/test_hgss_balls.py` throws each at a wild Pokémon in the test build: all seven catch, the
  Pokémon keeps that Ball, and a Friend Ball's starts at 200 friendship.

Kurt calls about his Balls on the Pokégear's phone ("The Pokégear phone"). Left: the Apricorn juice stand, which is
the skipped Pokéathlon's.

## Bug-Catching Contest

National Park's contest, Tuesdays, Thursdays and Saturdays: 20 Sport Balls, 20 real-time minutes, one Pokémon kept,
judged against five of ten Bug Catchers. HeartGold's own parts, and where each went:

- **The contest** (HeartGold's `src/overlay_bug_contest.c` and helpers in `src/unk_0206D494.c`) is
  `src/complete_bug_contest.c`. It is never saved: it lives on the field's heap from the gate (the party is put away
  but for its first Pokémon that can battle) to the judging (the party comes back, and the caught Pokémon joins it or
  a box). The ten contestants' entries (one picked each by weekday and National Dex), the four encounter sets (no
  National Dex, then Tuesday, Thursday, Saturday) and the score (species 60-100, level, IVs, HP) are HeartGold's
  (`include/data/complete_bug_contest.h`, from `tools/complete/import_hgss_bug_contest.py`; Sacred Gold's are the
  same). Prizes: Sun Stone (with the National Dex, one of ten stones), Everstone, Sitrus Berry, Shed Shell. The 20
  minutes are counted from the console clock.
- **Scripts:** HeartGold's contest scripts (`scr_seq_0151`: the gate, time up, last Ball, retiring, the judging, the
  contestants' lines) are translated as they are (`scripts_hgss_0151.s`), at script IDs 11000 on (HeartGold's 10400
  on, which are Platinum's daily trainers here). Its six commands are `Complete*` commands, and HeartGold's
  flags held in a variable (the contestants' hide flags) have two of their own.
- **Encounters:** grass and Sweet Scent bring out the day's set while it runs (slots 20/20/10/10/10/10/5/5/5/5%); the
  map's own rate still decides when.
- **Battle:** a contest battle type (the lead still gains experience), where BALL (BAG's button) throws a Sport Ball
  (×1.5), as the Great Marsh's BALL throws a Safari Ball. The bottom screen is HeartGold's contest menu
  (`BattleSubscreen_DrawCompleteContest`, `src/battle/battle_subscreen.c`, from its `battle_input.c`): BALL in BAG's
  place, one party Ball (the contest's one Pokémon), and over the menu its bug net, a Sport Ball with the Balls left,
  and the Pokémon the contest keeps, with its icon, gender and level (the battle's contest Pokémon starts as a copy
  of it, `FieldBattleDTO_NewBugContest`). The net's and Ball's sprites are HeartGold's
  (`tools/complete/import_hgss_balls.py`, `res/graphics/battle/interface/hgss/`), and the contest's battles load
  HeartGold's bottom-screen sprite palettes in place of Platinum's: they're the same seven with the net's, Ball's and
  gender's colours added, and the bottom screen's sixteen palettes have no room for more. A catch gets no nickname and goes to the contest, not the party; with one
  already kept, the battle asks which to keep, where HeartGold has a screen of its own after the battle (an app still
  in assembly). The last Ball missing ends the battle and the contest; losing heals the party and ends it.
- **Field:** the time-up check runs each frame the field takes input, as HeartGold's; the start menu shows the Sport
  Balls left and Retire (HeartGold's retire script), with no Bag or saving.
- **The nickname** at the judging: Platinum's naming screen names a party Pokémon, so the caught one joins the
  contest's one-Pokémon party for it, and leaves after.

- **Test:** `tools/complete/test_hgss_bug_contest.py` enters at Route 36's gate on a Tuesday, surveys the contest's
  grass (every Pokémon is one of the day's ten, at its levels), catches one with Sport Balls (each thrown in its own
  colours; the contest keeps the Pokémon, with a Ball fewer for each thrown), checks that a second battle's menu shows
  the kept Pokémon and runs from it, and lets the time run out: the announcement, the National Park, the judging, and
  the party back with the caught Pokémon in its Sport Ball. All four parts pass.

The Sport Ball is thrown in its own graphics, and the contest's music plays in the National Park and its gatehouses
(docs/Music.md).

## Johto Safari Zone

West of Cianwood, through Route 48's gate: ₽500, 30 Safari Balls, no step limit or timer. Six of HeartGold's twelve
areas sit in a 3×2 grid the player arranges with Baoba, and objects the player places in an area bring out more
Pokémon as days pass. Sacred Gold leaves it as HeartGold has it (its encounter data, arrangements, apps and area
blocks are byte for byte HeartGold's), so its Pokémon are at HeartGold's levels (about Lv. 15-17). HeartGold's own
parts, and where each went:

- **The core** (HeartGold's `src/safari_zone.c`, `src/unk_02097268.c` and the Safari parts of its map matrix and
  encounter code) is `src/complete_safari.c`. HeartGold's tables (the ten default arrangements, each area's
  encounters, the object types and levels) are `include/data/complete_safari.h`, from
  `tools/complete/import_hgss_safari.py`.
- **Save:** a save block of its own (`SAVE_TABLE_ENTRY_COMPLETE_SAFARI`, 750 bytes): the six cells' areas and their
  objects (up to 30 each), each area's days, the objects Baoba has unlocked and when he last spoke. Link play's
  friend's Safari Zone is left out. The first visit picks one of HeartGold's ten arrangements.
- **Areas:** the outside map's matrix has six empty cells; on each map load they get the arranged areas' blocks
  (`map_data_1318`-`1329`, HeartGold's 652-663), as HeartGold's `PlaceSafariZoneAreas` does.
- **The Safari game:** the gate's receptionist (HeartGold's scripts, translated) starts it with 30 Safari Balls and the
  Great Marsh's Safari battles (Ball, Bait, Mud, Run); there is no step limit, the start menu shows the Balls and
  Retire, and running out of Balls or walking out ends it (HeartGold's end scripts, `scr_seq_0262`, at script IDs
  11100 on: HeartGold's 8800 is Platinum's Safari game's number).
- **Encounters:** grass, water, the three rods and Sweet Scent pick one of the area's ten slots for the time of day
  (morning, day, night), all alike, as HeartGold does. Bonus Pokémon take the first slots once the area's objects
  reach their levels: an object's level comes from its type and the area's days (tens of days), and days count only
  once Baoba has unlocked the objects (during a Safari game they wait for its end).
- **Objects:** A facing open ground asks to place one; A facing an object takes it away (HeartGold's
  `std_safari_place_object` and `std_safari_remove_object`). HeartGold's object screen (an app still in assembly) is
  a list menu of the objects Baoba has unlocked (four groups of six, one more group at a time, in an order the trainer
  ID's last digit picks); the object goes on the tile in front, growing away from the player. The map then loads
  again in place. As each area's block loads (all five of the engine's ways), its objects are added as props, with
  their tiles blocked (behavior 0x23, which A finds).
- **Baoba:** his tests (catch a Geodude, then a Sandshrew, in the Safari Zone) are HeartGold's scripts; the check is
  `CompleteSafariChallengeCompleted`. He calls on the Pokégear, as in HeartGold: three hours of play after the first
  test, about the second; three hours after the second, with the National Dex, about the objects, one more group a
  call every three hours (all of them at once if the play time has stopped counting). A map load sets the call's
  trigger (HeartGold's `sub_02092E54`: `Safari_BaobaCalls`), the call comes through at the next step after ten
  minutes since the last, and as it plays it does what it says (HeartGold's `PhoneCall_GetScriptId_Baoba`:
  `CompleteSafari_BaobaCall`). When days pass and an area's Pokémon change (its morning slots, all five ways of meeting
  them), he calls about the areas by name, as HeartGold's `SaveData_SafariZone_CheckAreasWithUpdatedEncounters` and
  `GearPhoneCall_Baoba` do (the areas are kept in the phone's save; that call rings until answered). His console in the
  gate (HeartGold's area screen, also in assembly) is two list menus, a cell then its area: an area in another cell
  swaps places with it, objects and all; a new one starts empty.

- **Test:** `tools/complete/test_hgss_safari.py` pays at the gate (a Safari game with 30 Balls, on the outside map),
  checks the six arranged areas, surveys each grassy area (every Pokémon one of its ten noon slots, at their levels),
  places an object with Baoba's objects given (saved in its area, its tile blocking the way) and takes it away, walks
  out (the game ends), and rearranges two cells at Baoba's console (a new area, then a swap). All six parts pass.

Left: the object and area screens as HeartGold has them (moving an object about before it is placed), and link play's
friend's Safari Zone. (Its gate and areas play HeartGold's Safari songs, as every Johto and Kanto map plays its own.)

## Badges

Johto's and Kanto's 16 badges are kept beside Sinnoh's eight, in the trainer info (`hgssBadgeMask`, in what was the
struct's padding, so the save keeps its layout; `src/complete_badges.c`). HeartGold's `GiveBadge` and `CheckBadge`
are `CompleteGiveBadge` and `CompleteCheckBadge` (`BADGE_ID_HGSS_*`, HeartGold's order).

- **Field moves:** a field move works with Sinnoh's badge for it or with HeartGold's (Cut: Forest or Hive; Fly: Cobble
  or Storm; Surf: Fen or Fog; Strength: Mine or Plain; Rock Smash: Coal or Zephyr; Waterfall: Beacon or Rising; Rock
  Climb: Icicle or Earth; Defog: Relic only, as HeartGold has no Defog). That covers the field-move scripts
  (`CompleteCheckFieldMoveBadge`, `res/field/scripts/scripts_field_moves.s`), the party menu and the Surf prompt.
  Until now Johto's Cut trees, rocks and boulders asked Sinnoh's badges, so a player in Johto couldn't use them.
- **Whirlpool** (HeartGold's own field move, on Route 27, Route 41 and in Dragon's Den, where its whirlpools are
  3×3 blocks of water that stop a surfer): facing one while surfing, with the Glacier Badge and Whirlpool, asks to use
  it, and the player surfs across (`CommonScript_CompleteWhirlpool`; HeartGold's own crossing scene is assembly, so
  this is a plain crossing). HeartGold's HM05 is Whirlpool, Platinum's is Defog, and Lance gives HM05 in Johto: for now
  HM05 in the bag also allows Whirlpool, as Sovereign lets an HM in the bag stand in for the move (`docs/Roadmap.md`,
  "Still open"). Test: `tools/complete/test_hgss_whirlpool.py` (Dragon's Den: surfing out, and across its whirlpool).
- **Counts:** every badge counts where Platinum counts badges: how high a traded Pokémon obeys, the money lost on
  blacking out (capped at eight, as its table is), the common Poké Mart's stock, the save and continue screens. Scripts
  that count Sinnoh's badges (`CountBadgesAcquired`) still count Sinnoh's.
- **Not yet:** the Trainer Card shows Sinnoh's badges only (Johto's and Kanto's need their art); Sovereign's level caps
  (an option, off by default) follow Sinnoh's fights only, so with the option on a player in Johto is held at Lv. 16
  until the level curve is decided (`docs/Roadmap.md`).

Test: `tools/complete/test_hgss_field_moves.py` (Ilex Forest's Cut tree with no badge and with the Hive Badge, Rock
Smash with the Zephyr Badge, Strength with the Plain Badge).

## Wild Pokémon

The owner's call (Nov 1, 2026): every map's wild Pokémon are the original games' own, with the Pokémon those games
don't have mixed in evenly over the three regions. `tools/complete/gen_wild.py` writes them; every table and each new
species' place is listed in `docs/WildPokemon.md`.

- **The originals.** Johto and Kanto: HeartGold's and SoulSilver's tables (pokeheartgold's `gs_enc_data.json`), one
  for both versions: HeartGold's, with each SoulSilver species HeartGold's table lacks at that time of day put in a
  slot where the versions differ and HeartGold's species is in another slot too (Route 37 has both Growlithe and
  Vulpix). Sinnoh: Platinum's (pret's decompilation, as Sovereign first imported it). Headbutt trees, the Safari Zone
  and the Bug-Catching Contest were HeartGold's already; the Honey Trees and the Great Marsh's lookout keep
  Sovereign's tables, and so do encounter files Platinum doesn't have.
- **The Pokémon mixed in:** 410 species, every regular one (not legendary, mythical, an Ultra Beast or a Paradox
  Pokémon) of a family no original table has, but for starters, which Sovereign gives at Pokémon Centers (Platinum's
  dual slots, which need a Game Boy Advance game in the DS, don't count: Mawile is in Ruby's only, so it's mixed in too,
  placed after the rest). Each family goes to one region, taking turns (135 in Johto, 134 in Kanto, 136 in Sinnoh), and
  each species to one slot that the original table had twice, so every original species stays where it was: where the
  habitat suits its types and the levels reach the level it evolves at, the earliest such area first, stronger species
  in rarer slots (Sovereign's rules, from `tools/design/gen_encounters.py`). At most four grass slots and two of each
  water table go to new species, none in the Ruins of Alph's halls (Unown's own) or in the two rod slots HeartGold's
  night fishing takes ("Mass outbreaks and night fishing"). Five final forms no table's levels reach (Hydreigon,
  Dragapult, Volcarona, Braviary, Kingambit) come by evolving.
- **The spreadsheet:** `docs/WildPokemon.xlsx` (`tools/complete/wild_spreadsheet.py`) lists every place's Pokémon, how
  each is met (walking by time of day, surfing, each rod, Rock Smash, Headbutt trees, swarms and outbreaks, the Poké
  Radar, the dual slots, the daily Trophy Garden and Great Marsh Pokémon, Honey Trees, the Safari Zone, the
  Bug-Catching Contest, roamers, Sovereign's Regional Forms Park and rare wild Pokémon) and the odds, by place and by
  Pokémon, with each Pokémon's regions flagged. Run it again after a change.
- **To change it:** `PIN` (a species to a region or area), `LATE` (a family placed after the rest), `AREA_TAGS` (Johto's
  and Kanto's habitats), `FREE_LAND` and `FREE_WATER`, then run the generator again. Sinnoh's tables are Complete's own
  now, so `tools/complete/sync_sovereign.sh` leaves Sovereign's changes to them out, and Sovereign's own
  `tools/engine/gen_wild_encounters.py` isn't run here.

## Totem trials and legendaries in three regions

The owner's call (Nov 1, 2026): Sovereign's Totem trials and its legendary encounters are spread over Johto, Kanto and
Sinnoh instead of all being in Sinnoh. One plan, `data/complete/placed.yaml`, says what moves where; nothing of
Sovereign's maps or scripts is edited for it:

- **How:** `tools/complete/gen_placed.py` turns the plan into a table (`include/data/complete_placed.h`), and
  `src/complete_placed.c` reads it as each map's events load (`MapHeaderData_Load`): Sovereign's objects that moved
  away are taken off their map, and those placed on it are put in once their gates hold (badges, flags, vars, items,
  the party, a catch, the night) and while they aren't done (a trial won, a legendary caught). Talking to one runs
  `CommonScript_CompletePlaced`, which plays Sovereign's own trial (`CommonScript_SovereignTotemTrial`) or legendary
  encounter (`CommonScript_SovereignLegendaryEncounter`); as the field comes back after the battle, the placed object
  is taken off (`CompletePlaced_OnLoad`, beside the map's OnLoad script), as Sovereign's maps do for theirs. A moved
  Totem has its own level (its helpers two below).
- **Spots:** `tools/complete/find_spot.py` lists a map's tiles where something can stand out of everyone's way: the
  player can reach it, nobody, no warp, no trigger, sign or person beside it, and the map stays connected with it
  there.
- **The Totem trials:** four in Johto, four in Kanto, three left in Sinnoh (Lurantis, Kommo-o, Togedemaru). As
  Sovereign puts each before a fight, here a Gym Leader sends the player to the trial first (the translator's
  `totem_first_insert`, `CommonScript_CompleteTotemFirst`), and each comes out with the badge before, at a level just
  under that leader's ace (Sacred Gold's):

  | Totem | Where | Out from | Level | Before |
  |---|---|---|---|---|
  | Gumshoos | Route 32 | Zephyr Badge | 19 | Bugsy |
  | Vikavolt | Ilex Forest | Hive Badge | 22 | Whitney |
  | Ribombee | National Park | Plain Badge | 27 | Morty |
  | Mimikyu | Burned Tower 1F | Fog Badge | 33 | Chuck |
  | Araquanid | Route 25 | Boulder Badge | 60 | Misty |
  | Alolan Marowak | Rock Tunnel B1F | Thunder Badge | 62 | Janine |
  | Alolan Raticate | Celadon City | Soul Badge | 63 | Erika |
  | Salazzle | Cinnabar Island | Marsh Badge | 66 | Blaine |

  Sinnoh's scenes that wait on the moved trials (Mars at Valley Windworks, Jupiter's door in Eterna...) are past by
  the time the player reaches Sinnoh, as the trials are done before Johto's and Kanto's gyms. The crown pieces and the
  Crown are Sovereign's as they were.
- **The legendaries:** Sovereign's Chronicles (its post-game legendaries, opened one after another by the Legend
  Archivist in Canalave Library after Sinnoh's Hall of Fame) spread by chapter: the Unova and Kalos Chronicles'
  sixteen to Johto, the Alola and Galar Chronicles' sixteen to Kanto, the Paldea Chronicle's left in Sinnoh with the
  few whose quests run through Sinnoh's places (Meloetta, Genesect, Type: Null, Cosmog, Necrozma) and the Gen I-IV
  legendaries Sovereign ported from Renegade Platinum. `tools/complete/plan_legendaries.py` reads each one's level and
  what shows it (the Chronicle, items, Pokémon in the party, others caught, the night) from its Sovereign map's
  scripts, and finds it a spot on its new map; its `MOVES` says where each goes. The Archivist's lines say where they
  are now (the plan's `texts`). The roamers follow: Tornadus and Thundurus roam Johto, Zeraora, Glastrier and
  Spectrier Kanto (`RoamerRegionRoutes`); Sinnoh Now's news tells only of those in Sinnoh, and the Pokétch's Marking
  Map shows only those on its map.
- **Tests:** `tools/complete/test_placed.py` (each placed encounter: not out before its badges, its battle with them,
  done and gone after) and the story test's Totem parts.

## Megas in Johto and Kanto

The owner's call (Nov 1, 2026): Megas in all three regions. Sovereign's Mega Evolution is as it was (a held Mega Stone,
the Mega Ring for the player, one Mega a battle for each trainer); what Johto and Kanto add:

- **The Mega Ring** from Whitney, after her TM, with Johto's third badge, as Fantina gives it with Sinnoh's third
  (`mega_ring_insert` in the translator; `CommonScript_CompleteMegaRingMessage` and `...Explain`). Fantina skips it
  once the player has it.
- **The bosses' Megas:** every boss fought after the Mega Ring (Gym Leaders from Morty on, the Elite Four, Lance, Team
  Rocket's executives, the rival, Kanto's leaders, Blue, Red, and their rematches) has its ace, or else its strongest
  Pokémon with a Mega, hold its Mega Stone (`tools/complete/gen_boss_megas.py`; 50 of 63, listed in
  `docs/BossMegas.md`; the other 13 have no Pokémon with a Mega).
- **Mega Stones to find:** 23 low-value item balls in Johto and Kanto hold a stone instead, near where its Pokémon
  lives (`MEGA_STONE_BALLS` in `tools/complete/import_hgss_field_items.py`): Pidgeotite on Route 29, Ampharosite on
  Route 32, Slowbronite in the Slowpoke Well, Steelixite in Union Cave, Gengarite in the Burned Tower, Gyaradosite on
  Route 42, Tyranitarite on Mt. Silver, the Kanto starters' stones in Kanto, Mewtwonite Y in Cerulean Cave, and more.
  Sinnoh's stones, item balls and stone sellers are Sovereign's.

## Sinnoh, the third region

The owner's call (Nov 1, 2026): a provisional Sinnoh integration of Claude's own, so the whole game can be played and
tested, each choice in one place so it can change later. The player starts in New Bark Town; Sinnoh comes after Kanto.

- **Levels:** Sinnoh's trainers and the wild Pokémon on Sinnoh's maps move up to follow Kanto (Blue's ace is Lv. 70,
  Red's 94). Sovereign's level becomes the level here straight between a few points in `data/complete/sinnoh.yaml`
  (`levels`): Lv. 1 → 66, Roark's 16 → 72, Cynthia's 78 → 96, her rematch's 89 → 100. `src/complete_sinnoh.c` does it
  as a trainer's party is read (`TrainerData_BuildParty`) and as a wild Pokémon is made on a Sinnoh map
  (`wild_encounters.c`, legendaries and Totems there included). Johto's and Kanto's keep Sacred Gold's levels.
- **Evolved to match:** a Sinnoh trainer's Pokémon evolves as far as its new level takes it: by its evolution level, or,
  for a stone, a trade, friendship and the like, from Lv. 36 (the first evolution) and Lv. 50 (the second)
  (`evolve_at`). Wild Pokémon keep their species (`evolve_wild: false`), so each stays catchable where it lives.
- **Post-game legendaries and roamers:** Sovereign's Chronicles open after Sinnoh's League, so the legendaries moved to
  Johto and Kanto (above) and Sovereign's roamers (Mesprit, Cresselia, the birds, the Forces of Nature and the rest)
  take Sinnoh's levels too (`CompletePlaced_Get`, `RoamingPokemon_ActivateSlot`). HeartGold's roamers keep theirs.
- **Level caps** (Sovereign's option): one list for all three regions in story order (`caps`): Johto's and Kanto's
  leaders and Lance at Sacred Gold's aces' levels, then Sovereign's Sinnoh list (`data/level_caps.yaml`) with its
  levels moved up. `tools/complete/gen_sinnoh.py` writes them, with the levels, into
  `include/data/complete_sinnoh.h`; `src/level_cap.c` reads them in place of Sovereign's.
- **The way there:** the first ship to Sinnoh, while Sinnoh's story hasn't begun (`VAR_PLAYER_HOUSE_SPECIAL_PROGRAM_STATE`
  0), sails to Twinleaf Town (the sailor's menu says so) and leaves the player in their room there, where Platinum's
  opening plays as a new game's would (`CommonScript_CompleteFerryToTwinleaf`); later ships go to Canalave City.
- **Gifts:** a Pokémon given on a Sinnoh map comes at Sinnoh's levels too (Rowan's starter at Lv. 67), and with the
  party full it goes to the PC, as a caught one does (`Pokemon_GiveMonFromScript`): the player reaches Sinnoh with a
  full team, and Rowan's briefcase doesn't check for room. In his lab, Rowan looks at the starter wherever it is (the
  party slot of it or what it evolved into, `CompleteFindStarterSlot`), not at the party's lead, and with it in the PC
  he only says so (`SandgemTownLab_CompleteStarterInPC`).

## Headbutt trees and Rock Smash

HeartGold's two field encounters Platinum doesn't have (`src/overlay006/complete_field_encounters.c`, with the tables
`tools/complete/import_hgss_field_encounters.py` writes; Sacred Gold's are HeartGold's):

- **Headbutt trees:** pressing A at a Headbutt tree (its HeartGold tile behaviour) with a Pokémon that knows Headbutt
  asks to use it (`CommonScript_CompleteHeadbutt`, HeartGold's lines); the tree shakes, and on a tree of a kind with
  Pokémon one falls out: as in HeartGold, a map's trees are common, rare or empty by the last digit of the trainer ID,
  and its secret trees always have their own. The battle is set up as Platinum's wild battles are (the lead's
  abilities, a Repel). 60 maps, 2,114 tree tiles. Headbutt is a move, not an HM, so no badge is needed; it isn't in
  the party menu's field moves yet.
- **Rock Smash:** after a rock breaks on a Johto or Kanto map, a Pokémon from the map's Rock Smash slots may come out
  at its rate (80% the first slot, 20% the second), or else, on the 17 maps with finds, an item from HeartGold's lists
  at the map's odds (Suction Cups, Magnet Pull and Keen Eye add 5%; Serene Grace and Super Luck favour the rarer
  items), as HeartGold's `RockSmashItemCheck` does.
- **Ilex Forest's Headbutt tutor** checks HeartGold's list of who can learn Headbutt; the species HeartGold doesn't
  have can when they learn it by level in Sovereign's data.

Test: `tools/complete/test_hgss_headbutt.py` (a battle from Route 29's trees; a battle and an item from Dark Cave's
rocks).

## The ferries

**The S.S. Aqua** between Olivine City and Vermilion City runs as in Sacred Gold, but with no weekly schedule: Sacred
Gold's sailors in the port buildings let the player through on the ship's days only (Olivine's on Mondays and Fridays,
Vermilion's on Sundays and Wednesdays), and here any day (the translator's `INSERTS`). HeartGold's sailing scene
(`ScrCmd_723`) is Platinum's boat scene (`PlayBoatCutscene`), sailing east from Olivine and west from Vermilion;
Platinum's scene, which first sails its own ship out of the dock when there is one beside the player, now starts at the
fade-out when there isn't (`src/cutscenes/boat_cutscene/boat_cutscene.c`), as at HeartGold's ports. The first trip's
scenes and the cabin's rest play as in Sacred Gold.

**The ferry network** (`docs/Roadmap.md`, "Ferry network") joins the three main ports: once the way to Sinnoh is open,
the sailor at Olivine's or Vermilion's gangway asks where to, the S.S. Aqua's port or Canalave City
(`CommonScript_CompleteFerry`; the question is added to Sacred Gold's scripts by the translator's `INSERTS`), and
Canalave's sailor offers Olivine City and Vermilion City after his islands. A ship to Canalave City is Platinum's boat
scene from the islands; a ship from it lands the player at the S.S. Aqua's door in the other port, where the S.S.
Aqua's arrival scene plays. For now the way to Sinnoh opens with Kanto's eighth badge, the Earth Badge, as proposed
(`CommonScript_CompleteFerryCheckSinnoh`, the one place to change it; `docs/Roadmap.md`, "Unlock points"); before it,
the gangways board the S.S. Aqua as in Sacred Gold, and Canalave's sailor has only his islands.

Test: `tools/complete/test_hgss_ferry.py` (the S.S. Aqua: boarding at each port, and arriving at each; the network:
Olivine and Vermilion to Canalave, Canalave to each, the S.S. Aqua and staying in port from the menu, and no question
before the badge).

## The Pokégear phone

HeartGold's phone, from its data (Sacred Gold's phone book and HeartGold's call tables,
`tools/complete/import_hgss_phone.py`; the 75 callers' text banks) and its code (`src/complete_phone.c`, the save;
`src/overlay006/complete_phone_calls.c`, the rest):

- **The phone book** is saved (`SAVE_TABLE_ENTRY_COMPLETE_PHONE`, 456 bytes: the contacts in the order registered, who
  wants a rematch, the gifts kept for the player, Mom's savings and the last random callers). Scripts register numbers
  and ask about them as HeartGold's do (`CompletePhoneRegister`, `CompletePhoneCheckRegistered`).
- **Phone trainers:** a trainer with a number asks for the player's after the first battle; talked to after that, they
  battle again when a call asked for a rematch (their next team, as HeartGold's rematch sets and their unlocks go), hand
  over a gift a call promised, or ask for the number again; a rematch won ends it, and some give an item for it
  (HeartGold's `scr_seq_0953`, in a marked block of Platinum's `scripts_battles.s`). Gym Leaders' rematches follow
  their own scripts, as in HeartGold.
- **Calls** show in the field's message box: the ring, the caller's greeting and lines (with HeartGold's text and
  its choices: a rematch, a gift, a word, a flag), any yes or no, and the click. Map scripts' calls (Elm's panic call,
  Mom's on Route 30 about saving money, Oak's, Baoba's) play where HeartGold plays them. **Incoming calls:** ten
  minutes after the last call, on a map with a signal, a step may bring a call: a call trigger's, or half the time a
  random caller from the phone book (HeartGold's three groups, not one on the same map or one who called lately).
- **Call triggers,** set where HeartGold sets them (`src/complete_phone.c`): Elm's when his Togepi Egg hatches (it
  also sets the flag his lab script asks for before he gives the Everstone; the Egg is told by its origin, Mr.
  Pokémon, where HeartGold saves its personality), and his Pokérus call when a nurse finds Pokérus; Bill's when the
  boxes are full and Oak's at each 50 caught he hasn't rated, after a wild battle; the Day-Care Man's when an Egg
  turns up (called off when he offers it); Mom's when she buys something; Baoba's about his tests, the Safari Zone's
  objects and its new Pokémon (the Safari Zone, above). Past his
  first Egg (taken or turned down), Johto's Day-Care Man asks whether to keep calling, as HeartGold's does (Platinum's
  script for him, `scripts_day_care_common.s`, has HeartGold's lines and question on Route 34), and asks again when
  he's talked to with nothing in his care; after the first, he calls about an Egg only with a yes. The Bike Shop
  calls after 1,024 steps on the bike, once (HeartGold's steps-biked count, here the phone's save:
  `CompletePhone_CountBikeStep`, at each step on the bike in `src/player_move.c`).
- **Calls the player places** (HeartGold's outgoing calls): what each caller says when the player calls, as HeartGold
  picks it (`OutgoingScript`): a trainer's call from their own list (and their "you're right here" call on their
  map), Mom's (her savings question), Elm's (where his research and the journey are), Oak's Pokédex rating (a menu:
  Johto's Pokédex, the National one or quit, then the seen and caught counts and his rating with its fanfare; the
  first complete one he sees ends the call there), Bill's word on the boxes' room, the Day-Care couple's news (levels
  grown, how well two Pokémon get along, an Egg), Buena's, Ethan's or Lyra's story about the place the player calls
  from (by the place's name, so a town's buildings count as the town), Kurt's Balls, Kenji's breaks on Route 45 (a
  call by day sets his rematch), Baoba's and Irwin's, and the Gym Leaders' rematches at the Fighting Dojo after all
  sixteen badges, on the leader's day and time (yes or no). The call starts once the player stands still on the field
  (`CompletePhone_RequestCall`, made by `CompletePhone_TryOutgoingCall` in `src/overlay005/field_control.c`): the
  dialing (HeartGold's "......"), then the call in the message box, or "That number is out of the area." where
  HeartGold's map header has no signal (the Elite Four's rooms, the Safari Zone's areas, Lugia's cave). Sinnoh's maps,
  which HeartGold never knew, all have a signal. Oak's menu is `CompletePhoneCallMenu` (HeartGold's phone app's
  choices from its bank 0271, B for quit). The player calls from the Pokégear's contact list ("The Pokégear and the
  Pokétch", below).
- **Ringing:** a call that comes in rings, as HeartGold's GearPhoneRingManager does: the ring sounds every so often as
  the player walks, and the Pokégear's Phone button flashes; a tap on it answers, and the call plays once the player
  stands still. Nobody answering, it stops after HeartGold's 59 seconds and the call timer starts over (the call is
  missed; a triggered one comes again later). HeartGold's forced calls (the Bike Shop's, Bill's about full boxes,
  Baoba's) come through at once, as do the story's calls from map scripts (Elm's, Mom's on Route 30). With the Pokétch
  on the bottom screen, the player switches to the Pokégear to answer. The call waits in the main module
  (`CompletePhone_StartRinging`, `src/complete_phone.c`), so a battle in between doesn't lose it.

## The Pokégear and the Pokétch

The owner's call (Nov 3, 2026): both, with a button to switch between them. HeartGold's Pokégear shows on the field's
bottom screen in the Pokétch's place (`src/applications/complete_pokegear/pokegear.c`, an overlay of its own, with
HeartGold's graphics: `tools/complete/import_hgss_pokegear_gfx.py`), with its Phone and its Map:

- **When:** once the player has it (Mom gives it in New Bark Town: `FLAG_HGSS_GOT_POKEGEAR`), the bottom screen
  switches to it at once; with no Pokétch yet it stays there. With both, the bottom screen shows the one the player
  last switched to (a bit in the Pokétch's save, `completePokegearShown`). A script that hides the Pokétch hides the
  Pokégear too. `include/complete_pokegear.h` decides; `src/overlay005/ov5_021EA714.c`, the bottom screen's start and
  end, starts and ends the one shown (marked blocks), and `src/overlay005/complete_bottom_screen.c` switches them as the
  field runs, with a fade, as Platinum does when the player gets the Pokétch. Getting the Pokétch in Jubilife while the
  Pokégear shows brings the Pokétch up, as in Platinum.
- **The cards:** as in HeartGold, the Map and the Radio come with their cards: the Map Card from Cherrygrove City's
  guide at the end of his tour (`VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW` 2 on), the Radio Card from the Radio Tower's quiz
  (`FLAG_HGSS_GOT_RADIO_CARD`); until then their buttons are dark and beep (`CompletePokegear_HasCard`; HeartGold's
  RegisterPokegearCard, where the flags carry it). The app bar lights a card as it's given. Without the Map Card, Fly
  over Johto and Kanto uses the list.
- **The phone:** HeartGold's contact list: each contact's name in the white box and their title in the blue one (a
  trainer's class, or HeartGold's titles: Pokémon Professor, Childhood Friend, Day Care...; `include/data/
  hgss_phone_contacts.h`, from `tools/complete/import_hgss_phone.py`), six rows at a time, with the arrows to scroll
  (held, they repeat). Tapping a contact calls them: the call plays in the field's message box once the player stands
  still ("The Pokégear phone", above). While a scene, a warp or another field task runs, a tap on a contact (or on the
  Phone button to answer a ringing call) only beeps, so a tap in a cutscene can't start a call after it.
- **The switch:** on the Pokégear, its app bar's last button (HeartGold's exit button, lit when there's a Pokétch to go
  to); on the Pokétch, a blue button under its side button, drawn from the side button's own edges in the Pokégear's
  blue (`src/applications/poketch/poketch_graphics.c` and `poketch_system.c`, marked blocks), shown once the player has
  the Pokégear.
- **The map:** the app bar's Map shows HeartGold's map of Johto and Kanto (its map app's, the 48 by 20 tiles of the map
  itself), with the player's head (Ethan's or Lyra's, HeartGold's own marker) where HeartGold's map app puts them:
  on the overworld, the block of 32 tiles they're on; off it, the place their map's header gives. The place's name
  shows in a strip over the sea, and dragging scrolls the map, which is half again as wide as the screen (it opens
  scrolled to the player). HeartGold's map is 256-colour, too big for the bottom screen's 32 KB beside the app bar,
  so the importer makes it 16-colour without changing a pixel: five 15-colour palettes, each tile in the one its
  colours fit, and tiles that repeat (flipped or not) kept once (593 tiles). In Sinnoh it shows the place's name, with
  no head. The Pokégear comes back to the page it was on (after a battle or a map change).
- **Fly:** Fly over Johto and Kanto (from the party menu) is HeartGold's fly map on the Map: HeartGold's red cursor
  (its map app's, flashing between its two frames) on the place reached nearest the player, its name below, and the
  field's message "Where do you want to fly?". The D-pad moves the cursor to the nearest place reached that way, a tap
  on a place moves it there; A, or a tap on the place picked, flies there, and B backs out to the page the Pokégear was
  on. The places are the list's (HeartGold's 25 Fly points reached, but the one the player is on:
  `CompleteMapInfo_FlyPoints`); the map scrolls to keep the cursor in view; the app bar waits meanwhile. With the
  Pokétch on the bottom screen (or before the Pokégear), Fly shows the list instead ("Stand-ins"). The field asks and
  waits (`CompleteStartFlyMap`, `CompleteWaitFlyMap` in `CommonScript_CompleteFly`) through a request kept in the main
  module (`CompletePokegear_GetFly`), as the Pokégear's overlay runs on its own.
- **The radio:** the app bar's Radio ("The Pokégear radio", below).
- **The skins:** the app bar's Settings shows HeartGold's six skins (its configure app: blue, pink, black, wood, gold,
  teal; all six from the start, as HeartGold's code has them), with its frame around the one in use. A tap on one
  dresses the whole Pokégear in it (the app bar, the phone, the map's colours, the radio, the settings), saved with the
  phone (`CompletePhoneSave.pokegearSkin`). The importer brings each graphic's six variants
  (`tools/complete/import_hgss_pokegear_gfx.py`), its tiles packed to fit the 128 a page has (HeartGold's gold skin
  spreads its screen over a sheet of 1,024), and the map's tiles made once for all six, by HeartGold's colour indices.
- **Left out** of the map: HeartGold's zoom, its marked places and its place-by-place descriptions, and its look for
  what the player hasn't reached (Kanto covered until Route 27 and the S.S. Aqua, `ScrCmd_804`; unvisited towns
  greyed): its patches need about 56 more tiles than the bottom screen has room for beside the app bar.

Test: `tools/complete/test_hgss_pokegear.py` (the Pokégear coming up as the player gets it; a tap on Mom calling her;
scrolling; the map with the head in the bedroom's place, then on Route 30's after a warp, dragging and back to the
phone; a call ringing, answered from the Phone button, and another left to stop after 59 seconds; the second skin
chosen on the Settings, saved and shown on the Phone, and the first back; the switch to the Pokétch and back; the
choice kept across a warp; the Pokégear back after a battle; all 11 parts pass), and for Fly
`tools/complete/test_hgss_fly.py` (the list without the Pokégear; with it, the fly map's cursor on Cherrygrove City from
New Bark Town, B backing out, UP to Violet City and a tap on it flying there).

## The Pokégear radio

HeartGold's radio (pokeheartgold's `src/application/pokegear/radio`), on the Pokégear's Radio page
(`src/applications/complete_pokegear/radio/`; its music and what the field asks of it in `src/complete_radio.c`):

- **The globe:** HeartGold's dial, where the cursor tunes the stations of where the player is. Dragging the cursor (a
  tap near it picks it up) tunes; inside a station's inner ring the signal is clear, in its outer ring the show's
  lines have static (letters lost to dots, as HeartGold's `String_RadioAddStatic`). The four buttons beside the
  globe put the cursor on each station's middle. The player's buttons walk the field, so the radio takes touches
  only (HeartGold also tunes with the + Control Pad). The cursor stays where it was left.
- **The stations,** as HeartGold's `Radio_GetAvailableChannels` gives them: Johto's four (Pokémon Music, Pokémon
  Talk, Trainer Profiles or That Town, These People by the hour, and the Search Party, the Serial Radio Drama or
  Buena's Password by the hour); Kanto's once the Power Plant runs again, with the fourth station and the Poké Flute
  (at the globe's top) once the player has the Expansion Card; only the Unown's broadcast in the Ruins of Alph's hall;
  only the strange signal around Mahogany Town before the Rocket Hideout is cleared; only Team Rocket's broadcast while
  they hold the Radio Tower. Places HeartGold's headers give no signal (caves and the like) have none, and Sinnoh has
  none (the owner's call: the radio is Johto's and Kanto's).
- **The shows:** HeartGold's twelve, each in its file under `shows/`, with their text (HeartGold's banks 0409 to 0420)
  and music. Pokémon Music plays the day's music until the day ends (the March on Mondays and Fridays, the Lullaby on
  Tuesdays and Saturdays, Hoenn's and Sinnoh's sounds on Wednesdays and Thursdays with the National Pokédex, an old
  Game Boy song on Sundays with the GB Sounds); Professor Oak's Pokémon Talk names today's outbreak and five places of
  the region with one of their Pokémon each (one not caught yet, more often than not); the talk shows end with
  their jingle, then a commercial (those for the region and station, more as the player gets on). Each line prints
  in a strip under the globe, one at a time (HeartGold shows two on the top screen, which here is the field's); the
  show's title and host share the band at the top.
- **The music** is the field's while the page shows a station (HeartGold's radio plays through the overworld too).
  Off a station, or off the page, the map's music comes back. A battle, a menu or a new map ends the page for a
  while; when it comes back it tunes in again where the cursor is (a show that was on picks its song up without
  restarting it).
- **What it does:** as in HeartGold, the March brings wild Pokémon more often and the Lullaby less often (here as the
  White and Black Flutes change Platinum's rates, `src/overlay006/wild_encounters.c`); Hoenn's and Sinnoh's sounds put
  the map's Hoenn or Sinnoh Pokémon in grass slots 2 to 5 (Sacred Gold's tables have them); the Unown's broadcast makes
  half the hall's Unown letters the Pokédex hasn't seen yet; the Poké Flute wakes Snorlax on Routes 11 and 12
  (`RadioMusicIsPlaying`, `CompleteScrCmd_RadioMusicIsPlaying`).
- **Buena's password:** a new one each day (HeartGold's `Save_VarsFlags_UpdateBuenasPasswordSet`, with the daily
  flags), which her show gives to players with the Blue Card and her quiz in the Radio Tower asks for, among three
  (`GetBuenasPassword`, `CompleteScrCmd_GetBuenasPassword`; until now the quiz's three words came from nothing).

Test: `tools/complete/test_hgss_radio.py` (the page in New Bark Town with the cursor on the fourth station's outer
ring; each button's station and show; Oak's show running; the cursor dragged off the stations; leaving the page and
coming back; Kanto's Poké Flute by Route 11's Snorlax, which then wakes; the Ruins of Alph's, Mahogany's and
Sinnoh's stations; all 11 parts pass).

## Mom's savings

HeartGold's (its `mom_gift.c`, the battle's money hand-back, and Mom's bank), in `src/complete_phone.c` and
`src/overlay006/complete_moms_savings.c`, with the balance and her shopping in the phone's save:

- **Her share:** with her savings on (her Route 30 call, or her at home), a quarter of the money a battle brings goes to
  her, to ¥999,999, and the prize message says so ("Sent some to Mom!", a marked block of Platinum's
  `subscript_battle_won.s`).
- **Her shopping:** HeartGold's list (a Super Potion at ¥900 saved, a Repel at ¥4,000, ... a Focus Sash at ¥50,000,
  each once), or five of a type-resist Berry each time her savings pass another ¥3,000; up to five things wait at a
  time. She calls about it (HeartGold's call trigger).
- **The deliveryman** in Johto's and Kanto's Marts shows as the Mart loads when she bought something, and hands it over,
  one thing a visit (Platinum's Mart script, with HeartGold's lines).
- **Her bank at home:** HeartGold's menu (withdraw, deposit, change the setting), with the savings and the wallet in a
  box. HeartGold takes the amount on the touch screen's number pad; here a window above the message box does: up and
  down change the digit under the cursor (red), left and right move it, A confirms and B gives up.

Tests: `tools/complete/test_hgss_phone.py` (Youngster Joey on Route 30: his number after the battle, a rematch, a gift;
his call; Mom's call on Route 30; her share of his rematch's prize and the Super Potion she buys; the Cherrygrove Mart's
deliveryman; a withdrawal at home) and `tools/complete/test_hgss_phone_outgoing.py` (calls placed from the bedroom to
Mom, Elm, Oak three times through his menu, Bill, the Day-Care couple, Kurt, Lyra and Falkner, each followed message by
message; and Mom from Lugia's cave, out of the area).

## The Ruins of Alph puzzles

HeartGold's sliding puzzles (its `alph_puzzle.c`), in `src/applications/complete_alph_puzzle.c` with HeartGold's
graphics (`res/graphics/alph_puzzle`, its `puzzle_gra` built the same way) and text:

- **The puzzles:** reading a chamber's slab opens its puzzle on the touch screen, the hint on the top one. A tap turns a
  loose panel a quarter, dragging moves it to a free square (not a corner); once every panel sits in the middle the
  right way up, the picture flashes and the puzzle's flag is set. Quit asks first, with Platinum's touch yes and no.
  Back in the field, HeartGold's script goes on: the floor gives way and the player drops into the underground hall.
  The sounds are HeartGold's own (a panel picked up and turned, the puzzle solved), loaded as they play.
- **The Unown:** the underground hall has no Pokémon until a puzzle is solved, and then only the letters each solved
  puzzle lets out (Kabuto's A to J, Aerodactyl's R to V, Omanyte's K to Q, Ho-Oh's W to Z); its entrance in the Sinjoh
  Ruins event has ! and ? (`src/complete_encounters.c`). While the radio plays the Unown's broadcast, half of them are
  letters the Pokédex hasn't seen yet, as in HeartGold ("The Pokégear radio").
- **The walls' words:** reading a chamber's north wall shows its words on a stone tablet over the field, in the
  Unown's letters, until A is pressed (HeartGold's OpenAlphHiddenRoom, `CompleteAlphWall` in
  `src/overlay005/complete_legend_cutscene.c`): ESCAPE in Kabuto's chamber, LIGHT in Omanyte's, WATER in
  Aerodactyl's, HO OH in Ho-Oh's. The tablet is HeartGold's (its `demo/legend` 15 to 17, on the field's BG1), the
  words its `msg_0198`.
- **The rooms behind** (four item balls each): used from the tile below the wall, facing it, an Escape Rope opens
  Kabuto's chamber's, Flash Omanyte's and a Water Stone Aerodactyl's, as HeartGold's `alph_checks.c` has it
  (`CompleteAlph_CanOpenWall`, asked by the Escape Rope's and the evolution stones' item use and by Flash's): the
  chamber's own script shakes the room and the wall is gone, and nothing is used up. Ho-Oh's opens when it's read
  with Ho-Oh in the party (its script).

Tests: `tools/complete/test_hgss_alph_puzzle.py` (the hall empty before any puzzle; Quit, yes; the Kabuto puzzle solved
by touch and the drop into the hall; the hall's Unown then), `tools/complete/test_hgss_field_effects.py` (each
chamber's wall read, its tablet up until A) and `tools/complete/test_hgss_alph_walls.py` (an Escape Rope and a Water
Stone used from the bag at their walls: each wall opens and the item stays; Flash, which only a Pokémon that knows it
can use, isn't driven).

## Talking to the following Pokémon

HeartGold's (its `scr_seq_0163` and the `Task_FollowMonInteract` of its overlay 2, which pret's decomp has only as
assembly), in `src/overlay006/complete_follower_talk.c` and `CommonScript_CompleteFollowerTalk`, with HeartGold's data
(four of its archives, packed by `tools/complete/import_hgss_follower_talk.py` into
`res/prebuilt/fielddata/complete_follower_talk/follower_talk.narc`) and text (msg_0265, msg_0040):

- **What it says:** talking to the follower picks one of HeartGold's interactions from its choices: 70 that can happen
  anywhere and up to 30 for each place, each asking about the moment (the Pokémon's HP, status, mood, friendship,
  nature, type, held item and kind; the tile it stands on, the time, the weather, the people and hidden items nearby,
  the map, a story flag) and with a chance. HeartGold tries 12 general ones, then the place's, then the rest; the first
  that fits is it. Sinnoh's places have the general ones, and the League's, a place both games share.
- **What it does:** up to five steps of hops, shakes and turns (HeartGold's keyframes, on the follower's sprite), its
  cry and its lines; a question's yes or no leads on to another interaction; some raise or lower its friendship and
  mood, and some have it find an accessory for the Fashion Case or a Shiny Leaf to wear.
- **The mood** is HeartGold's, kept where HeartGold keeps it (a spare byte of the Pokémon's data): up 40 with a level
  gained in battle or a TM learned, down 80 when it faints (100 against a foe 30 levels higher) and 50 when it survives
  poison in the field, HeartGold's changes for items (a Rare Candy +40, vitamins +8, X items +10, bitter herbal
  medicine down 20 to 40), and a step back toward 0 with each step the follower is out.
- **Shiny Leaves** are kept per Pokémon (another spare byte), and the crown Lyra or Ethan makes from all five in
  their room in New Bark Town works (HeartGold's `GetShinyLeafCount` and `TryGiveShinyLeafCrown`).
- **The emotes:** HeartGold's 14 bubbles over the follower (a heart, faces, "...", "!"...), its model and two-frame
  pictures (also in the archive), pop up as in HeartGold and play their frames, as a billboard of Platinum's field
  effects loaded from the archive (`FieldEffectManager_Load*FromNARC`). None on a bridge, as in HeartGold.
- **Not ported:** the few choices that ask about Pokéathlon performance never come up, as in a game without the
  Pokéathlon.

Test: `tools/complete/test_follower_talk.py` (a talk the tables choose in New Bark Town; a nudge, its emote, its
question and the yes; an accessory found; a Shiny Leaf, with the friendship and mood it brings).

## Mass outbreaks and night fishing

HeartGold's (its `encounter_check.c` and the map list in its `unk_02097F6C.c`), in `src/complete_encounters.c`, with
each map's outbreak and night species from its table (HeartGold's own: "Wild Pokémon"):

- **When:** from Oak's National Pokédex on (`EnableMassOutbreaks`, which sets `VAR_COMPLETE_OUTBREAKS`), each day one
  of HeartGold's 20 outbreak maps has one. The day's pick is Platinum's daily swarm value, which Sinnoh's outbreaks
  also pick from; HeartGold keeps a daily random value of its own.
- **What:** on a grass or cave day, the map's outbreak species takes the first two grass slots (two in five
  encounters), at any time of day: Poochyena (Route 1), Baltoy (Route 3), Sableye (Route 9), Chansey (Route 13),
  Buneary (Route 25), Ralts (Route 34), Yanma (Route 35), Snubbull (Route 38), Swablu (Route 45), Ditto (Route 47),
  Marill (Mt. Mortar), Dunsparce (Dark Cave) and Kricketot (Viridian Forest). On a water day it takes the first
  surfing slot: Clamperl (Route 19), Luvdisc (Route 27), Wingull (Vermilion City). On a fishing day it takes the Old
  Rod's third slot, the Good Rod's first, third and fourth and every Super Rod slot: Relicanth (Route 12), Qwilfish
  (Route 32), Remoraid (Route 44), Whiscash (Violet City). Where HeartGold and SoulSilver differ (Routes 3 and 9), the
  outbreak is HeartGold's.
- **Night fishing:** at night (8 p.m. to 4 a.m.) on every Johto and Kanto map, the Good Rod's fourth slot and the
  Super Rod's second have the map's night species (Staryu in Cherrygrove City, for example), as in HeartGold.
- **On the radio:** Professor Oak's Pokémon Talk says where today's outbreak is ("The Pokégear radio";
  `CompleteEncounters_TodaysOutbreak`), fishing days too.

Test: `tools/complete/test_hgss_outbreaks.py` (no outbreak species on Route 35 before the National Pokédex; it there
on its day; not on another map's day; Route 27's water on its day; Violet City's rods on its day and not another day;
Cherrygrove City's night species on the Super Rod at night and not by day).

## The Pokédex

The owner's call (Nov 3, 2026): HeartGold's Johto Pokédex is the regional one until Sinnoh's story begins, then
Sinnoh's, with the National Pokédex beside either once the player has it (Oak gives it at Olivine's port).

- **When:** Johto's is the regional Pokédex while `VAR_PLAYER_HOUSE_SPECIAL_PROGRAM_STATE` is 0, that is until the first
  ship to Sinnoh leaves the player in Twinleaf Town and Platinum's opening plays (`CompletePokedex_IsJohto`,
  `src/complete_pokedex.c`).
- **What changes:** the regional list is Johto's 256 in HeartGold's order, with HeartGold's numbers (Chansey is #222),
  and its seen and obtained counts are Johto's (`Pokemon_SinnohDexNumber` answers with the Johto number, and
  `pokedex_sort.c` builds the list from Johto's). The list's banner reads JOHTO POKéDEX: the list's tile sheet with
  its SINNOH banner redrawn in the same pixel font (`tools/complete/gen_pokedex_johto_banner.py`,
  `res/graphics/pokedex/scroll_main_background_johto.png`), loaded in Johto's place.
- **Completion:** the regional goal is 254 seen in Johto (Mew and Celebi, the event Pokémon at its end, don't count),
  in the regional "complete" checks and in the last tier of Oak's rating (`Pokedex_LocalDexCompleted`,
  `Pokedex_GetRatingMessageID_Local`). The Celadon Condominiums' game designer reads the same list.
- **The list's numbers:** `tools/complete/import_hgss_johto_dex.py` writes `include/data/hgss_johto_dex.h` from
  HeartGold's `poketool/johtozukan.narc`: the 256 in order and each species' Johto number.

## Red and the credits

The owner's calls (Nov 3, 2026): Red at Mt. Silver is post-game, after the end of the whole game, and the credits roll
once, at the end of the whole game.

- **Red:** as Mt. Silver's summit loads, Red stays away until Sinnoh's League is won (`FLAG_GAME_COMPLETED`), through
  his own hide flag (`FLAG_COMPLETE_HIDE_MT_SILVER_RED`, on a Sacred Gold flag its scripts never use) and the summit's
  own on-entry script (`CompleteMtSilverRed_OnTransition`, an insert in `tools/complete/translate_hgss_scripts.py`).
  Once he's been beaten he stays away until Johto's League is won again, as in HeartGold (`FLAG_HGSS_UNK_25F`).
  Sacred Gold's snow pile behind him, where the Sky Plate is, used Red's sprite (two Reds stood there); it's invisible
  now (`OBJECT_SPRITES` in `tools/complete/import_hgss_events.py`).
- **The credits:** they roll the first time Sinnoh's League is won (`src/clear_game.c`). Johto's League and Red record
  the team in the Hall of Fame and start the game over at home, without credits (`ClearGame_Johto`), and a later
  win at Sinnoh's League skips them.

## Johto's Battle Frontier

Johto's Battle Frontier is open, and its five facilities (the Battle Tower, Factory, Hall, Castle and Arcade) run
Platinum's own challenges from their Johto lobbies: Platinum's facility code, battle rooms and scenes, started by the
lobbies' HeartGold scripts. HeartGold built its Frontier on Platinum's, so its lobby scripts ask for the same things in
the same way:

- **Commands:** HeartGold's Frontier commands are Platinum's, renumbered in blocks (the Battle Tower's 408 on are
  Platinum's `InitBattleTower`, `CallBattleTowerFunction` and the rest; the other facilities' 627 on are
  `LaunchBattleFrontierScene` and each facility's lobby function, partner check, chosen slots and streak delete), with
  the same arguments, the same function numbers inside each lobby function and the same scene numbers
  (`tools/complete/hgss_script_table.py`). The few others are Platinum's too: the banned Pokémon the player has seen
  (`MessageSeenBanlistSpecies`), a form put back before a challenge (`TryRevertPokemonForm`, the Griseous Orb),
  Battle Points spent at the Exchange Service Corner, the Battle Hall's records, the IV judge, and the wireless
  multi battle's syncs.
- **Vars:** Platinum's facilities keep a lobby's state, a challenge's type and level and the prints won in Platinum's
  vars, which their own scripts set as a challenge ends; HeartGold's lobbies have the same vars, in the same order,
  under other numbers, so their scripts use Platinum's (`FRONTIER_VARS` in `tools/complete/translate_hgss_scripts.py`).
  Battle Points, streaks, records and prints are one set for both Frontiers: a streak begun in Johto is the same
  facility's streak in Sinnoh.
- **The move tutors:** the three in the Frontier Access's tutor house teach HeartGold's 51 moves for Battle Points, at
  HeartGold's prices (`src/overlay005/complete_move_tutor.c`, its script HeartGold's `scr_seq_0002`, at script 11200
  on). Each lists the moves the Pokémon picked can learn from him and doesn't know, six a page with NEXT, each with
  its price (HeartGold's list lines, in Platinum's script menu); then, as in HeartGold, a Pokémon with four moves
  forgets one, and the points come off. Who can learn what: for the 38 moves Platinum's tutors also teach, the
  engine's own tutor data (each species' `by_tutor`, as Platinum's shard tutors use it); for HeartGold's 13 others
  (Super Fang, Pain Split, String Shot, Tailwind, Gravity, Worry Seed, Magic Coat, Role Play, Heal Bell, Low Kick, Sky
  Attack, Block, Bug Bite), HeartGold's list up to Arceus and, after it, the species that learn the move by level or
  as an egg move, as for Ilex Forest's Headbutt (`include/data/hgss_frontier_tutors.h`, from
  `tools/complete/import_hgss_tutors.py`; forms go by their species). Draco Meteor and the starters' strongest moves stay
  with Blackthorn's tutor house, as in HeartGold.
- **Not ported:** HeartGold's scratch-off card script is on the map but nothing runs it, as in HeartGold.
- **Test:** `tools/complete/test_hgss_frontier_tutors.py` (the first tutor's list for the lead, with each move's price
  and QUIT; a move too dear with no Battle Points; with 500, the lead forgets a move, learns Fury Cutter and 32 come
  off; all three parts pass) and `tools/complete/test_hgss_frontier.py`: in the Factory a Level 50 single challenge starts, three Pokémon
  are rented, the first battle is won (the test build's god mode) and RETIRE brings the player back to Johto's
  Factory with its lobby cleared; at the Tower, Hall, Castle and Arcade the attendant's menus and the party screen
  lead into Platinum's challenge.

## Voltorb Flip

The Goldenrod and Celadon Game Corners' Voltorb Flip tables play HeartGold's Voltorb Flip, HeartGold's own code
(`src/applications/complete_voltorb_flip/`, the overlay `complete_voltorb_flip`) with its graphics
(`res/graphics/voltorb_flip/`), its text (`hgss_msg_0039`) and its two fanfares (`SEQ_ME_CARDGAME1` and `2`, brought
in by `tools/complete/import_hgss_sound.py`). The game is HeartGold's in full: the board's levels, the memos, the
coins paid into the Coin Case, Game Info's three pages.

- **Started by** `CompleteVoltorbFlip machine, city` (HeartGold's `CasinoGame`, `src/complete_scrcmd.c`), as the Alph
  puzzles are: the field gives way to the game and `ReturnToField` brings it back. HeartGold works out each machine's
  luck from the machine and the city, then doesn't pass it on, so the two are read and nothing more.
- **HeartGold's names:** the code keeps HeartGold's, and `include/applications/complete_voltorb_flip/hgss_compat.h`
  names Platinum's functions and types that way (the two games' engines are one engine under two sets of names). It
  turns on `require_prototypes`, so a HeartGold name nothing maps fails to compile instead of linking to nothing. A
  few calls differ and are rewritten in place: the sub screen's sprites sit 192 lines down as Platinum's sprite system
  puts them (HeartGold's moved its sub screen to 524), the graphics are kept uncompressed, HeartGold's font palette 9
  (which Platinum's font archive doesn't have) is in the code, and Voltorb Flip uses the diploma's heap (its app can't
  run at the same time).
- **The Quit question** is Platinum's touch Yes and No (`yes_no_touch_menu.c`, the buttons HeartGold's prompt draws
  too); HeartGold's also takes the buttons, its cursor on Yes, so A presses Yes and B presses No here.
- **Sounds:** HeartGold's own, the effects (the cards turning, the coins counting) and the fanfares; the menus'
  clicks are Platinum's, as they are HeartGold's.
- **The Japanese Game Corners** (HeartGold's `T25R1101` and `T07R0401`, with slot machines, unused outside Japan) are
  translated too, to the same command; no warp leads to them.
- **Test:** `tools/complete/test_hgss_voltorb_flip.py` (the test build reads the board from
  `gCompleteTestVoltorbFlipGame`): the Goldenrod table opens the game; a round won by flipping every 2 and 3 (touched)
  pays its product into the Coin Case (24 coins, then level 2); a round quit with the buttons pays what was found (the
  question answered Yes with A); Quit on the menu brings the field back. All four parts pass.

## The legendary cutscenes

HeartGold's (its `src/field/legend_cutscene_camera.c` and `camera_translation.c`), in
`src/overlay005/complete_legend_cutscene.c`, run by `CompleteLegendCutscene op, arg`, which HeartGold's 14
`LegendCutscene*` commands translate to (`tools/complete/hgss_script_table.py`):

- **The Bell Tower's roof:** as the Kimono Girls dance, the Clear Bell rises from the player's bag and shimmers, with
  the four corner bells at the camera's cuts; the leaves blow over the screen (HeartGold's two scrolling layers of
  leaves, on the field's free BG layers 2 and 3, their priorities and palette put back after); the camera pans up to
  the sky, and Ho-Oh flaps down onto the roof with a ring of light and its cry.
- **The Whirl Islands' cave:** the Tidal Bell and its two corner bells, the waves (a 3D model), the camera to the water
  as Lugia rises, the glint of its eye, and the camera back.
- **One game, both scenes:** HeartGold picks by its version (Ho-Oh's for HeartGold, Lugia's for SoulSilver); here the
  Bell Tower's roof plays HeartGold's and the Whirl Islands' SoulSilver's.
- **How:** the models and animations are HeartGold's (its `demo/legend`, packed as it is into
  `fielddata/complete/legend.narc` by `tools/complete/import_hgss_legend.py`), drawn by the field's 3D object tasks
  (`ov5_021D1A94`, HeartGold's Field3dObjectTask) as Platinum's Easy3D objects (HeartGold's Field3dObject), with
  HeartGold's camera points and its camera path, a step a frame, on Platinum's camera.
- **The cinematics** between the dance and the landing (HeartGold's `Cinematic`, its overlay 106, in assembly there,
  in C here: `src/applications/complete_legend_cinematic/legend_cinematic.c`, run by `CompleteLegendCinematic`): over
  the Bell Tower the Clear Bell's sound spreads in rings of light, then, to HeartGold's Ho-Oh theme, Ho-Oh flies in
  around the tower; in the Whirl Islands Lugia rises through the waterfall, cries and spreads its wings as the picture
  trails (the DS's display capture blending each frame with the last, as HeartGold does it). The models are
  HeartGold's (`tools/complete/import_hgss_legend_cinematic.py`), Ho-Oh's by HeartGold's three times of day (the
  morning and the day, the evening, the night), lit by the field's light at the time. As in HeartGold, the field map
  is left for the cinematic and comes back with the scene's people where the script put them.
- **The Sinjoh Ruins:** in Sacred Gold's event on the Mystri Stage (all 16 plates and the National Pokédex),
  HeartGold's Unown circle (its `UnownCircle`, `event_cutscene_sinjoh.c`, here `CompleteUnownCircle` in
  `src/overlay005/complete_legend_cutscene.c`): the screen flashes white, two rings of Unown spin up round the spot
  the following Pokémon was put away on and a light rises in them; then Arceus's cinematic (`Cinematic 2`), HeartGold's
  2D one, run by its own script of 513 steps (`include/data/hgss_arceus_cinematic.h`, read from its assembly by the
  importer): the dark orb in its white glow, Arceus's eye, the rune circle with Arceus in it over the sky, a city in
  the rain, the stars and the eclipse, and the egg it makes, the backgrounds faded and blended into each other, to
  HeartGold's Arceus theme. Arceus is drawn from HeartGold's own walking sprite: the lead's form and colors if the
  lead is Arceus, a plain one otherwise, as HeartGold does it. Then the battle with Arceus, as Sacred Gold has it.
- **Sounds:** HeartGold's own: the wings' flaps, Lugia's eyes, the Clear Bell's rings and the light, the falls fading
  in as Lugia's cinematic begins.
- **Left out:** HeartGold's own Arceus event at the Sinjoh Ruins (an egg of Dialga, Palkia or Giratina, with
  Cynthia), which needs a distributed Arceus, stays out of reach.

Tests: `tools/complete/test_hgss_legend_cutscenes.py` (both scenes from their trigger tile to their end, each with at
least 20 of the cutscene's commands run, nothing of it held after and the camera back at its distance, and its
cinematic played to its end, Lugia's with its trail; both pass) and `tools/complete/test_hgss_sinjoh.py` (the plates
event from the stage's middle: the circle, Arceus's cinematic to its end and the scene back on the field; 3 of 3).

## The Rocket Hideout's traps and alarms, the monks' wings, Lance's flight

- **The traps** (Mahogany Town's hideout, B1F's trapped floor): stepping on one, HeartGold's trap goes off under the
  player before its battle: sparks for a Voltorb, a cloud of gas for a Koffing, rocks for a Geodude (HeartGold's
  ScrCmd_708: its model and animations, played to their end).
- **The alarms:** as a Persian statue spots the player, the screen pulses red twice (HeartGold's ScrCmd_709: its red
  screen on the field's layer 2, blended over the field, a step a frame up to 12 of 31 and back), before the grunts
  come.
- **The wings:** the Bell Tower's monk shows the Rainbow Wing, the Whirl Islands' monk the Silver Wing (HeartGold's
  ShowLegendaryWing): it appears at the player's feet and shines while the map's next scene runs (the monk's lines and
  his step aside, which HeartGold starts from the wing, so they had been skipped), then fades.
- **How:** all come from the same archive as the legendary cutscenes (HeartGold's `demo/legend`, all of it now in
  `fielddata/complete/legend.narc`) and the same code (`src/overlay005/complete_legend_cutscene.c`,
  `CompleteHideoutTrap`, `CompleteHideoutAlarm`, `CompleteLegendaryWing`), with HeartGold's own sounds: the three
  traps', the Rocket Hideout's siren and the wing's chime.
- **Sacred Gold's Sinjoh Ruins** reuse the alarm (its siren and red screen) in the plates' event on the Mystri Stage,
  as Drayano wrote it.
- **Lance's flight** off the Lake of Rage (HeartGold's ScrCmd_775): HeartGold plays its Fly take-off with Lance and
  his Dragonite (in assembly there), and so does Complete: Platinum's Fly cut-in, the same code
  (`src/overlay006/hm_cut_in.c`, `CompleteHMCutIn_StartLanceTask`), with HeartGold's Lance as the rider, from its
  field cut-in archive (`tools/complete/import_hgss_field_cutin.py`; Platinum's has only its two players). Lance sends
  out his Dragonite in the cut-in, the bird swoops down for him on his tile, his and the Dragonite's objects go and he
  is carried off, the player staying, with no fade (`CompleteLanceFlight`).
- **The Rocket uniform:** the player changes into it in Goldenrod Tunnel before the Radio Tower, and walks in it, in
  HeartGold's own sprites for the boy and the girl, until the Radio Tower's director takes it back after the rescue
  (HeartGold's SetAvatarBits PLAYER_TRANSITION_ROCKET and RocketCostumeFlagAction: the flag the scenes set, read by
  `Player_GetSpriteFromStateAndGender` in `src/player_avatar.c`). As in HeartGold, in it the player can't Fly, Surf,
  Rock Climb, Teleport or Dig ("Can't use that here.") or use the Bicycle, a rod or an Escape Rope (Platinum's
  message for an item that can't be used now), next to Platinum's own checks for a partner along.

Test: `tools/complete/test_hgss_field_effects.py` (the three traps stepped on, the first statue's alarm, both wings and
Lance's flight, each effect started, played to its end and the field free after; all seven pass), and
`tools/complete/test_hgss_rocket_costume.py` for the uniform (its sprite, walking about in it, taken off, and the
Bicycle on Y refused in it and taken without it).

## The Magnet Train's ride

Between Goldenrod City and Saffron City, HeartGold's ride plays: three cuts of the train, from three cameras of their
own, the first two closing like a camera shutter and the last fading out as the train pulls in to HeartGold's jingle.

- **Which models:** HeartGold's own, chosen as it chooses them: by the way (Goldenrod to Saffron or back), by day
  (morning and day) or by night (the evening, the night and late at night), and by the player's gender in the first
  two cuts, where the player is aboard. The last cut takes its colors from the area's first light at the time of the
  ride, as HeartGold has it.
- **How:** HeartGold's overlay 104 (in assembly there) is C here, an app of its own
  (`src/applications/complete_magnet_train/magnet_train.c`, overlay `complete_magnet_train`) drawing HeartGold's
  models and their joint and texture animations as Platinum's Easy3D objects, with HeartGold's cameras, cut lengths
  (91, 301 and 205 frames) and fades. The archive is HeartGold's `a/2/3/3` as it is
  (`demo/complete/magnet_train.narc`, from `tools/complete/import_hgss_magnet_train.py`). HeartGold's ScrCmd_722 is
  `CompleteMagnetTrain`, in the order Platinum's own scenes return to the field (the Distortion World's warp): the
  screen fades out, the ride plays, `ReturnToField`, the warp to the other station, the screen fades in.
- **Sounds:** the station's song fades as the ride begins, and each cut has HeartGold's own sound of the train (the
  rails passing at its distance and side).

Test: `tools/complete/test_hgss_magnet_train.py` (both ways, by day and at night: the scene walks the player aboard,
all three cuts play with the right models, and the player gets off at the other station with the field free).

## Stand-ins

HeartGold features no one has decided to keep yet, or not ported yet, where Johto and Kanto's scripts reach them:

- **The photo album** (Cameron the photographer, 66 photos on 59 maps): he takes the photo, but there is no album to
  keep it in.
- **Fly over Johto and Kanto:** Platinum's Town Map shows only Sinnoh, so on a Johto or Kanto map Fly (from the party
  menu) is HeartGold's fly map on the Pokégear's Map ("The Pokégear and the Pokétch"), or, with the Pokétch on the
  bottom screen, a list of the places reached, by name, that flies to the one chosen. The places are HeartGold's 25
  Fly points, each recorded as the player first arrives, as HeartGold does (`FLAG_HGSS_SYS_FLYPOINT_*`, from its spawn
  points: `src/spawn_locations.c`). Both stay until the three-region Town Map (`docs/Roadmap.md`, "Art"). Until then
  the bag's Town Map (given in Sinnoh) shows Sinnoh's map wherever it's used; on a Johto or Kanto map its cursor
  starts on Twinleaf Town (checked in the emulator on Route 30).
- **The Berry Pots, the Unown Report and the Dowsing Machine** (key items Sacred Gold's scripts give) do nothing yet
  (`docs/Roadmap.md`, "Still open"); the Pokétch's Dowsing app finds Johto's and Kanto's hidden items.
