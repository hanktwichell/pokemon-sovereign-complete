# Bringing HeartGold's scripts into the engine (step 3)

How HeartGold's map scripts and text (`.cache/pokeheartgold`, pinned in `HEARTGOLD_COMMIT`) become Sovereign
Complete's. Maps, events and flags are in `docs/MapConversion.md`.

## The pipeline

1. `tools/complete/import_hgss_text.py`: HeartGold's 428 message banks that maps and scripts use, as
   `res/text/hgss_msg_NNNN.json` (`TEXT_BANK_HGSS_MSG_NNNN`).
2. `tools/complete/translate_hgss_scripts.py --install [STEM ...]`: translates HeartGold's script files into
   `res/field/scripts/scripts_hgss_NNNN.s` (map scripts) and `scripts_init_hgss_NNNN.s` (map-load scripts), command
   by command through `tools/complete/hgss_script_table.py`. Without `--install` it writes to a folder and reports
   coverage: what is left is written as a `@ HGSS:` comment and counted.
3. `tools/complete/import_hgss_headers.py`: points each map at its translated scripts and its text bank.
4. `tools/complete/import_hgss_events.py`: maps with translated scripts get their people's, signs' and step-on
   triggers' script numbers (HeartGold's own numbering, 1 on); the others keep script 0.

The first maps through it are New Bark Town's eight.

## Size

- 965 script files (`files/fielddata/script/scr_seq/scr_seq_*.s`): 77,976 command lines, 818 different commands.
- 181 of those commands have a Platinum command of the same name (`decomp/asm/macros/scrcmd.inc`, `movement.inc`),
  62% of the lines: `End`, `GoTo`, `SetFlag`, `ApplyMovement`, the walking movements...
- The other 637 are skewed: the 25 most used cover 80% of their lines, 100 cover 94%, 200 cover 97%. The long tail is
  mostly HeartGold's own features (Pokégear calls, Apricorns, the Bug-Catching Contest, Safari Zone, the Pokéathlon,
  which is skipped, following Pokémon in scenes), which need engine work as well as translation.

## Commands

Both games write scripts as assembler macros over numbered commands (`.short` opcode, then arguments). The opcodes
drift apart after the shared core from Diamond and Pearl: HeartGold's 41 is `SetVar`, Platinum's 41 is
`SetVarFromVar`; HeartGold's `NPCMsg` (45) is Platinum's `Message`. So the translation goes by meaning, command by
command, not by number. Most control flow carries over directly: HeartGold's `Compare` then `GoToIfNe label` is
Platinum's `CompareVar` then `GoToIf` with the same condition.

## The translator

- Each command goes through `COMMANDS` in `tools/complete/hgss_script_table.py`, or is kept when Platinum has a
  command of the same name taking the same arguments. Coverage of all 965 files: 95.7% of the command lines, more
  than half kept as they are. What's left is mostly HeartGold's own features (the photographer Cameron, the Battle
  Frontier, phone rematches, Voltorb Flip) and trainer battles (step 4).
- Sacred Gold's scripts (`docs/SacredGold.md`) now: 98.2% of 83,001 lines. Besides trainers, gifts, trades and marts,
  about 50 more of HeartGold's commands turned out to be Platinum's under another name, checked against both games'
  code: money and coins (`AddMoney` is `GiveMoney`, `CheckCoinsImmediate` `HasCoinsFromValue`...), the party
  (friendship, ribbons, which are numbered alike, moves, egg counts), fossils, the National Dex, the starter, the
  saving icon, `Random`, the hour, a Pokémon's picture in a window (HeartGold's unnamed 452 and 453), score events (by
  meaning: their numbers differ), the party menus for trades and for choosing a Pokémon.
- Menus: HeartGold's standard menu (`MenuInitStdGmm`, 108 of them) takes its entries from its own menu strings (its
  bank 191), and they number past 255. `CompleteInitHGSSMenu` (`src/complete_scrcmd.c`) is Platinum's global text
  menu reading that bank, and the entries are added with the 16-bit `AddMenuEntry`. Until now these menus showed
  Platinum's menu strings at HeartGold's numbers.
- Elevators (Goldenrod's and Celadon's department stores, the Radio Tower, Olivine's lighthouse, Silph Co., Celadon's
  condominiums): HeartGold's dynamic warp is Platinum's special location, and its floor window and elevator
  animation are Platinum's. HeartGold counts floors from the bottom and has a 6F, Platinum counts the floors above and
  stops at 5F, so `CompleteGetElevatorFloor` (HeartGold's floor table) and `CompleteBufferFloorName` (its floor names)
  keep HeartGold's scripts as they are.
- The follower: HeartGold's 600 puts it back in its ball before healing, a warp or a scene, and 606 brings it out
  beside the player, as its warps do at the end (`CompleteFollowerPutAway`, which hides it without HeartGold's
  animation, and `CompleteFollowerReturn`). The points box (116 to 118) is Platinum's coin or Battle Points window;
  the Pokéathlon's points stay out with it. `NopVar490` does nothing and `ScriptOverlayCmd` loads HeartGold's own
  code, so both are dropped. Ball seals are numbered alike; HeartGold's seal commands are Platinum's under other names.
- Gifts: `NicknameInput` is Platinum's `OpenPokemonNamingScreen` (but for the Bug-Catching Contest's catch, step 5),
  and HeartGold's Togepi Egg is `CompleteGiveTogepiEgg`: Platinum's egg gift with Extrasensory. HeartGold's gift places
  (where an egg came from) are Platinum's 13 and two more, Mr. Pokémon (the Togepi Egg) and Primo (his Mareep, Wooper
  and Slugma eggs), now added to `res/text/special_met_location_names.json` at HeartGold's numbers, so `GiveEgg`
  keeps them.
- The Johto Safari Zone (step 5): HeartGold's 716 (Baoba's area screen) and 717 (the object screen) open apps still in
  assembly, so here they are list menus (`CompleteSafariAddAreaEntries`, `CompleteSafariAddObjectEntries`), faded in
  over the black screen the script left for the app. 716 ends by closing the field, so the script's
  `RestoreOverworld` (`ReturnToField`) opens it again. 718 to 721, `CheckSafariZoneChallengeCompleted` and
  `UpdateSafariZoneIGT` are `CompleteSafari*` commands.
- Each translated file defines HeartGold's names for its people and script numbers (from its `event_*.h`), so
  clones (two objects sharing a local ID) keep HeartGold's exact numbers, and includes its text banks' headers.
- Names: flags and vars as in the events; `MAP_*` to `MAP_HEADER_HGSS_*`; items, species and moves to Sovereign's
  by name, ignoring underscores (HeartGold's `ITEM_S_S__TICKET`); `RGB_*` to Platinum's `COLOR_*`; HeartGold's
  follower (`obj_partner_poke`) to `LOCALID_COMPLETE_FOLLOWER`.
- Sounds: Diamond and Pearl's keep their names (Platinum adds `_sseq`); a few have other names in Platinum
  (`SOUNDS`: HeartGold's select sound is Platinum's `SE_CONFIRM_sseq_3`, its item fanfare `SEQ_FANFA4`); HeartGold's
  own sound effects are left out, with the wait that goes with them, and its fanfares play Platinum's; its music is
  its own (`tools/complete/import_hgss_sound.py`, `docs/Music.md`), with the map headers' stand-ins for a song the
  sound archive lacks.
- Commands Platinum lacks are added to the engine (`src/complete_scrcmd.c`, after Sovereign's own in
  `include/data/scripts/scrcmd.h`): `MessageGendered` (HeartGold's `GenderMsgBox`, a different line for a boy or a
  girl) and the following Pokémon's commands for scenes (`CompleteFollowerPause`, `CompleteFollowerWait`,
  `CompleteFollowerSetMovementType`, `CompleteFollowerCheckActive`). A scene unpauses the follower (pause 0), waits
  for its step to finish (HeartGold's `MapObject_IsMovementPaused` is Platinum's `LocalMapObj_CheckAnimationFinished`,
  despite its name), parks it, moves everyone, then pauses it again (1) and lets it follow before `ReleaseAll`.
- `ScreenShake` (30 scenes: the Ruins of Alph's puzzles, Lugia's cave, Route 36's Sudowoodo, the Sinjoh Ruins...) is
  `CompleteScreenShake`, ported from HeartGold's code: the camera sways on a sine wave, by up to its x and y, a number
  of times. HeartGold keeps the sway in 16 bits, so its one shake of 20 sways by 4; the port does the same.
  `ScrCmd_523`, the legendary Pokémon's sideways sway before their scenes (Suicune's chase, the three in the Burned
  Tower, Rayquaza), is `CompleteObjectSway`, from HeartGold's `sub_0205BED8`: the object's sprite moves on a sine, by
  its x and z pixels, a number of cycles.
- `GetShinyLeafCount` and `TryGiveShinyLeafCrown` (Lyra's or Ethan's crown for five Shiny Leaves) are
  `CompleteGetShinyLeafCount` and `CompleteGiveShinyLeafCrown`, on the leaves the follower's talk finds
  (`docs/Features.md`, "Talking to the following Pokémon").
- The loan Pokémon (`GiveLoanMon`, `CheckReturnLoanMon`, `ReturnLoanMon`, `KenyaCheck`, `KenyaCheckPartyOrMailbox`,
  `MonGiveMail`) are `CompleteGiveLoanMon` and the rest, ported from HeartGold: Kenya, the Spearow the man in Route 35's
  gatehouse lends with a letter for his friend on Route 31 (Sacred Gold's Dux), and Kirk's Shuckle in Cianwood City.
  Each is that NPC trade's Pokémon (`NPC_TRADE_HGSS_DUX_SPEAROW`, `_SHUCKIE_SHUCKLE`), met where it's lent, and Kenya
  carries HeartGold's letter, the same three Easy Chat lines; the friend checks the letter is that one, in the party
  or the PC's mailbox. Sacred Gold's Route 31 hands `MonGiveMail` slot 150 for a Pokémon with the letter that isn't
  Kenya, which in HeartGold reads past the party; here it leaves the party as it is.
- The Lake of Rage's Magikarp record (`SizeRecordCompare`, `SizeRecordUpdate`, `BufferRecordSize`, `BufferMonSize`)
  uses Platinum's size contest: the same sizes from a Pokémon's personality and IVs, in feet and inches. HeartGold keeps
  its record in a var of its own, `VAR_HGSS_MAGIKARP_SIZE_RECORD`, so Sinnoh's contest record stays apart; HeartGold's
  new game sets it to 3'6" in code, so `InitNewGame` does (the translator writes it with HeartGold's flags).
  `BufferMonSize` is Platinum's `BufferPartyPokemonSize`; the other three are `CompleteSizeRecordCompare` and the rest.
- `StaticWildWonOrCaughtCheck`'s second form and `LatiCaughtCheck` read the last battle's result as HeartGold keeps it
  in `VAR_BATTLE_RESULT` (its map scripts on returning from a battle run before the battle's script goes on, when the
  script's own result isn't reachable): `src/encounter.c` keeps it in `gCompleteLastBattleResult`, and
  `CompleteCheckLastBattleNotBeaten` reads it.
- `ScrCmd_530 0, 1` (Team Rocket's hideout cleared) sets `VAR_HGSS_UNK_4036` as HeartGold does, and the map loads
  (`src/complete_map_info.c`) leave Mahogany Town's antenna tree out, as HeartGold's `RemoveMahoganyTownAntennaTree`.
  `ScrCmd_445` (the map the player came from) is Platinum's `GetPreviousMapID` less `MAP_HEADER_HGSS_EVERYWHERE`, as
  HeartGold's map n is that header + n and its scripts compare the var with HeartGold's numbers.
- `RocketTrapBattle` (Team Rocket's traps and Azalea's Spiritomb) is HeartGold's wild battle without the legendary
  flag, so `CompleteStartWildBattle` too. `FollowerPokeIsEventTrigger` asks whether a party Pokémon is a distributed
  event one (HeartGold's spiky-eared Pichu, Arceus and Celebi events, read from its met data); Sacred Gold gives these
  through its own events instead (the Azure Flute, the Plates), so the answer is no.
- `GetGameVersion` answers HeartGold (7): Sacred Gold is HeartGold, and its scripts branch on it for version-only
  scenes and Pokémon (Latias rather than Latios roams Kanto). Platinum's answer (12) took SoulSilver's branches wherever
  a script asked "is this HeartGold?". HeartGold's and Platinum's unnamed `ScrCmd_258` are no longer matched by name:
  the numbers mean different commands (HeartGold's clears link flags for the Battle Tower). Unnamed ones in HeartGold's
  decomp are matched by what their code does: doors in scenes (307-311), the time of day (379), the free camera (102,
  103), Deoxys's form (518), the Unown letters (545: HeartGold counts those caught, Platinum keeps only those seen, so
  the Ruins of Alph's rewards count seen letters), and game records (420) by meaning, as their numbers differ.
- **A new game** sets HeartGold's starting flags too: its new-game script (`scr_seq_0149`, Sacred Gold's version)
  hides the people who come later in the story (Elm's lab officer, the Olivine rival, Route 12's Snorlax...), and
  Sacred Gold's Mom hides its own added people in her first scene. Neither ran here, so those people stood on their
  maps from the start (on Ecruteak's and Sinjoh's step-on triggers, among others). The translator now writes both sets
  of flags (165) into the engine's `InitNewGame` (`res/field/scripts/scripts_init_new_game.s`, between markers).
- **Badges:** HeartGold's `GiveBadge` and `CheckBadge` are `CompleteGiveBadge` and `CompleteCheckBadge`, on Johto's and
  Kanto's badges, which the trainer info keeps beside Sinnoh's (`src/complete_badges.c`; `docs/Features.md`, "Badges").
- **The phone:** HeartGold's `RegisterGearNumber`, `CheckRegisteredPhoneNumber`, `GetPhoneBookRematch` and
  `ScrCmd_462` (the rematch is fought) are `CompletePhoneRegister`, `CompletePhoneCheckRegistered`,
  `CompletePhoneGetRematch` and `CompletePhoneEndRematch` (`src/overlay006/complete_phone_calls.c`). Its phone
  trainers' shared script (`scr_seq_0953`, where HeartGold's trainers start) isn't translated: Johto's and Kanto's
  trainers use Platinum's (`scripts_battles.s`), with HeartGold's phone steps added in a marked block there
  (`docs/Features.md`, "The Pokégear phone").

## Gym puzzles

HeartGold keeps each gym's puzzle in a "gymmick": 32 bytes of saved state that the gym's script sets up on the way
in, and code the map's loading runs. Platinum has the same thing as its dynamic map features (Pastoria's water,
Canalave's platforms): the same 32 bytes (`PersistedMapFeatures`), with an init, free and collision function for each
feature (`src/dynamic_map_features.c`). `src/complete_gyms.c` ports HeartGold's (`src/field/gymmick/*.c`) as six new
features, each with the script commands its gym uses:
- **Vermilion** (`CompleteVermilionGymInit`, `...CanCheck`, `...LockAction`, `...ResampleCans`): the two switches in
  the fifteen trash cans, the second next to the first; the stops step aside and the gate's sparks stop. With the
  Thunder Badge both gates stay open, as in HeartGold.
- **Violet** (`CompleteVioletGymInit`, `CompleteVioletGymLift`): the lift to Falkner's floor, which is Platinum's
  platform lift with HeartGold's model, place and speed. The following Pokémon rides along, as in HeartGold.
- **Azalea** (`CompleteAzaleaGymInit`, `...Ride`, `...Switch`): four Spinarak carts between twelve stops; the two
  switches set the points, which decide each cart's route. The rider and the follower move with the cart, and the
  camera jolts when it stops.
- **Cianwood** (`CompleteCianwoodGymInit`, `...TurnWinch`): after Chuck's battle the winch stops his waterfall, with
  the camera panning to it.
- **Blackthorn** (`CompleteBlackthornGymInit`, and a check on every step, as for Canalave's platforms): three floors
  over the lava, moved and turned by the buttons on them, stopping at walls and ground; the floors are walkable and
  the rest of the lava isn't. Until now the lava was plain ground.
- **Ecruteak** (`CompleteEcruteakGymInit`): the dark, which hides the path between the gym's pits (black fog at its
  thickest; people don't take it, as in HeartGold), and the sages' candles, which go out as each loses. HeartGold binds
  a candle to its sage from its common trainer script, which Platinum's trainers don't use, so a task keeps each
  candle on its sage and puts it out once the sage's trainer flag is set. A sage beaten before keeps their candle out
  (HeartGold lit them all again).

HeartGold's gyms find the parts that move among the map's own buildings, which Platinum keeps per loaded map chunk;
`FindMapProp` looks there. HeartGold's own sound effects for these (the cart, the floors) wait for step 6; the floors
use Platinum's lift sound meanwhile.

Still to port: two touches on top of gyms that already play through: Fuchsia's invisible walls flashing when bumped
(the walls are in the map's collision) and Viridian's arrow tiles lighting up (they are slide tiles, which Platinum's
engine already has). Their init commands are left out until then.

## Standard scripts

HeartGold's standard scripts (`CallStd`, `include/constants/std_script.h`, 679 of them) are numbered from 2000 like
Platinum's common scripts. The most used: the trainer battle script (390 uses), Rock Smash (103), item gifts (88 +
20), a full bag (75), Cut (48), marts (42 + 33 + 14), Apricorn trees (31), Strength (29), the Pokémon Center's
nurse and Wi-Fi counters (25 each, one per Pokémon Center), saving (18). They map to Platinum's common scripts by
meaning; the HeartGold-only ones (Apricorn trees) are added.

Shared people work the same way: a person whose script is a standard one gets Platinum's that does the same
(`STD_PEOPLE`, `tools/complete/import_hgss_events.py`). The two games number these ranges alike. The Trainer Card
attendant, the day-care couple on Route 34 and the Marts' Mystery Gift deliveryman (shown by Platinum's flag, from
Platinum's script as each Mart loads) are in, and Mom's gift deliveryman next to him (a script added to Platinum's, which
shows him too when Mom bought something). Platinum's Colosseum, Union Room and Wi-Fi Club attendants walk the player through Platinum's
rooms, with their doors at fixed tiles, so HeartGold's still do nothing; they come with link play.

Two of HeartGold's standard script files are translated as they are, as map script files are, and get script IDs of
their own (`STD_FILES`): the Bug-Catching Contest's (`scr_seq_0151`, HeartGold's 10400 on, here 11000 on) and the
Johto Safari Zone's (`scr_seq_0262`, HeartGold's 8800 on, here 11100 on); HeartGold's numbers are Platinum's daily
trainers and Safari game there. A `CallStd` to one of them becomes a `CallCommonScript` to its new number.

## Text

HeartGold's message banks (`files/msgdata/msg/*.json`) have Platinum's layout (`key`, then `messages` with `id` and
`en_US` lines) and the same control codes (`{STRVAR_1 ...}`, `{COLOR ...}`, `{YESNO ...}`). Every code HeartGold
uses is in Platinum's text encoder (`decomp/tools/msgenc/charmap.txt`) except `TRNAME` (10 uses). Each map's bank
becomes a Platinum text bank, appended to `generated/text_banks.txt` (the bank number is its place in that list) as
`res/text/hgss_*.json`. HeartGold ends 695 questions with `{YESNO 0}`, its mark for "answer on the touch screen"
(Platinum's screen indicator, which draws it); here the yes or no is on the top screen, so the importer drops the mark.

## Numbers in scripts

- Flags and vars: as for events (`docs/MapConversion.md`): HeartGold's per-map, object-sprite and script vars keep
  their numbers; the rest move to `FLAG_HGSS_*` (2912 + f) and `VAR_COMPLETE_*` (0x4030 on).
- People: the `LOCALID` constants are HeartGold's object names, from the converted events files.
- Items, species, moves: by name, through Sovereign's lists. HeartGold's own items are added to Sovereign's list
  (`tools/complete/import_hgss_items.py`: data, names, descriptions and icons from HeartGold, the icons converted
  with nitrogfx, which turns them back into the same bytes). Sovereign's numbers past Platinum's are later games'
  items, so HeartGold's come after Sovereign's with new numbers. 39 items: the S.S. Ticket (Platinum's item at its
  number is the Tea), the seven Apricorns, Kurt's nine balls (Fast, Level, Lure, Heavy, Love, Friend, Moon, Sport,
  Park), the Red Scale, SquirtBottle, Card Key, Pass, Machine Part, Mystery Egg, Jade Orb, Lock Capsule, Enigma Stone
  and the other key items. Left out: the Pokéathlon's 27 data cards (the Pokéathlon is skipped) and the four Sovereign
  has (the Silver and Rainbow Wings, the Red and Blue Orbs).
- For now Kurt's balls sit in the Poké Balls pocket but can't be thrown (their catch rules, their graphics and the
  Pokémon's record of its ball come in step 5), and the Apricorn Box, Berry Pots, Dowsing Machine, Unown Report and
  GB Sounds are key items without a use until their features come. The bag's Poké Balls pocket has 15 slots (25
  kinds of ball now) and the key items pocket 50 (Sinnoh's and Johto's together are more): the bag's sizes are part
  of the save, so they grow with step 5's save work.

## Sacred Gold's versions

The scripts the game uses are Sacred Gold's, disassembled from its ROM and translated as above: `docs/SacredGold.md`.
