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
- Sacred Gold's scripts (`docs/SacredGold.md`) now: 97.6% of 83,001 lines. Besides trainers, gifts, trades and marts,
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
  and HeartGold's Togepi Egg is `CompleteGiveTogepiEgg`: Platinum's egg gift with Extrasensory, met in Johto.
- Each translated file defines HeartGold's names for its people and script numbers (from its `event_*.h`), so
  clones (two objects sharing a local ID) keep HeartGold's exact numbers, and includes its text banks' headers.
- Names: flags and vars as in the events; `MAP_*` to `MAP_HEADER_HGSS_*`; items, species and moves to Sovereign's
  by name, ignoring underscores (HeartGold's `ITEM_S_S__TICKET`); `RGB_*` to Platinum's `COLOR_*`; HeartGold's
  follower (`obj_partner_poke`) to `LOCALID_COMPLETE_FOLLOWER`.
- Sounds: Diamond and Pearl's keep their names (Platinum adds `_sseq`); a few have other names in Platinum
  (`SOUNDS`: HeartGold's select sound is Platinum's `SE_CONFIRM_sseq_3`, its item fanfare `SEQ_FANFA4`); HeartGold's
  own sound effects are left out until its sound archive comes in (step 6), with the wait that goes with them; its
  music plays the same stand-ins as the map headers.
- Commands Platinum lacks are added to the engine (`src/complete_scrcmd.c`, after Sovereign's own in
  `include/data/scripts/scrcmd.h`): `MessageGendered` (HeartGold's `GenderMsgBox`, a different line for a boy or a
  girl) and the following Pokémon's commands for scenes (`CompleteFollowerPause`, `CompleteFollowerWait`,
  `CompleteFollowerSetMovementType`, `CompleteFollowerCheckActive`). A scene unpauses the follower (pause 0), waits
  for its step to finish (HeartGold's `MapObject_IsMovementPaused` is Platinum's `LocalMapObj_CheckAnimationFinished`,
  despite its name), parks it, moves everyone, then pauses it again (1) and lets it follow before `ReleaseAll`.
- Stand-ins until their feature comes: Johto and Kanto's badges aren't in the save yet, so `CheckBadge` answers no.

## Standard scripts

HeartGold's standard scripts (`CallStd`, `include/constants/std_script.h`, 679 of them) are numbered from 2000 like
Platinum's common scripts. The most used: the trainer battle script (390 uses), Rock Smash (103), item gifts (88 +
20), a full bag (75), Cut (48), marts (42 + 33 + 14), Apricorn trees (31), Strength (29), the Pokémon Center's
nurse and Wi-Fi counters (25 each, one per Pokémon Center), saving (18). They map to Platinum's common scripts by
meaning; the HeartGold-only ones (Apricorn trees, the deliverymen) are added.

## Text

HeartGold's message banks (`files/msgdata/msg/*.json`) have Platinum's layout (`key`, then `messages` with `id` and
`en_US` lines) and the same control codes (`{STRVAR_1 ...}`, `{COLOR ...}`, `{YESNO ...}`). Every code HeartGold
uses is in Platinum's text encoder (`decomp/tools/msgenc/charmap.txt`) except `TRNAME` (10 uses). Each map's bank
becomes a Platinum text bank, appended to `generated/text_banks.txt` (the bank number is its place in that list) as
`res/text/hgss_*.json`.

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
