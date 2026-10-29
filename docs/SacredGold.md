# Sacred Gold's content (step 4)

Johto and Kanto follow Drayano's Sacred Gold (Complete version), with his okay. Sacred Gold is a binary hack of
HeartGold: its changes exist only in its ROM, which `tools/complete/build_heartgold.sh` builds into
`.cache/sacredgold.nds` from pokeheartgold and Drayano's patch. The tools below read that ROM; HeartGold's sources
(pokeheartgold) give the names.

## What Sacred Gold changes

Compared with HeartGold's ROM, file by file:

| What | Changed | Comes in |
|---|---|---|
| Scripts (a/0/1/2) | 203 of 965 files, some to twice their size: gifts, trades, rematches, item givers | Disassembled, then translated as HeartGold's |
| Map events (a/0/3/2) | 145 of 491 files, 201 more people | The events importer reads Sacred Gold's |
| Text (a/0/2/7) | 533 of 829 banks: Pokémon names in plain case, its new lines | Decoded from its ROM |
| Trainers (a/0/5/5, a/0/5/6) | 316 headers, 677 parties | `import_hgss_trainers.py` |
| Trainer pictures (a/0/5/8) | 33 of 645 files | `import_hgss_trainer_classes.py` |
| Wild Pokémon (a/0/3/7) | 130 of 142 tables | `import_hgss_encounters.py` |
| Trades (a/1/1/2) | 9 of 13 | `import_hgss_trades.py` |
| Items (a/0/1/7, a/0/1/8, names) | 6 new items in unused slots; 11 trade items made usable | `import_hgss_items.py` (the 6) |
| Item balls (script file 141) | 19 of 255, 15 more placed or moved | `import_hgss_field_items.py` |
| Hidden items (a table in its code) | None; 2 more placed | `import_hgss_field_items.py` |
| Poké Mart stock (tables in its code) | 14 of 30 special marts | `import_hgss_marts.py` |
| Pokémon data, moves, learnsets, evolutions | Most | Not taken: Sovereign has its own (1025 Pokémon); its new evolution items are |
| Map headers | None | |

## Scripts

`tools/complete/disasm_hgss_scripts.py` turns the compiled scripts back into pokeheartgold's script language, so
`tools/complete/translate_hgss_scripts.py --install --from .cache/sacredgold/scr_seq` translates them as it does
HeartGold's sources (`docs/ScriptConversion.md`):

- Commands by opcode from pokeheartgold's macros; movement lists where a command points to one; labels and entry
  names as pokeheartgold's sources have them; HeartGold's shorthand rebuilt (`GoToIfSet`, `Compare` / `GoToIfEq`,
  `Switch` / `Case`, `GiveItemNoCheck`, `SimpleNPCMsg`, the signs); arguments named as the sources name the same
  argument of the same command (flags, vars, items, species, moves, messages, people, sounds, maps, trainers).
- Sacred Gold's own habits: movement lists packed back to back with only the 2-byte end code, some not aligned (the
  translation aligns every movement list), and a few stretches no script reaches (left as comments).
- **Checked**: all 965 of HeartGold's files and all 965 of Sacred Gold's reassemble with pokeheartgold's own
  toolchain to the same bytes. On HeartGold, 909 files come out as its sources' exact commands; the others differ only
  in how a value is written (`ITEM_POKE_BALL` where the source wrote 4), and translating them gives the same scripts
  as translating the sources.

Sacred Gold's scripts have 83,001 command lines (HeartGold's 77,988); 98.1% translate. What's left is HeartGold's own
features (the photographer, phone calls and rematches, the Pokéathlon and Battle Frontier menus...), for step 5.

## Text

`tools/complete/import_hgss_text.py --rom .cache/sacredgold.nds --scripts .cache/sacredgold/scr_seq` decodes the banks
with the engine's msgenc (decoding HeartGold's own ROM so gives back all of its sources' text) and keeps HeartGold's
message names; a message a bank gained gets the next name in its bank's pattern. Two of Sacred Gold's banks have a
control code with its argument count left out or wrong, which stops msgenc: the count is put back from the code's
usual count in HeartGold's text (the Moomoo Farm milk menu's `{ALN_CENTER}`). One script shows a message its bank
lacks (bank 121, message 24); it is added empty.

## Flags and vars past HeartGold's

Sacred Gold uses flags 0x3F54-0x3FFF and vars 0x612E-0x61A9 for its own story (hide flags for its 201 new people,
step-on triggers, gifts). HeartGold has 2,912 flags and 368 vars and doesn't check the range in its release build, so
these land in save space HeartGold leaves unused. Here they get real places after HeartGold's
(`tools/complete/sacred_gold.py`): flags from 5824 (`FLAG_HGSS_SG_3F54`...), vars `VAR_COMPLETE_140`-`1FF`
(`VAR_HGSS_SG_612E`...). The save already has the room (`NUM_FLAGS` 7008, 512 new vars).

## Trainers

`tools/complete/import_hgss_trainers.py` makes each of HeartGold's 737 trainers a Sovereign trainer,
`TRAINER_HGSS_<HeartGold's name>` (`res/trainers/data/hgss_*.json`), in HeartGold's order after Sovereign's 1,040:

- Party as Sacred Gold has it: species, form, level, held item, moves, the difficulty as the IV scale, the ball seal.
  Where Sacred Gold picks a Pokémon's first or second ability, the ability is written out from Sacred Gold's species
  data (it changed many: Bulbasaur's second is Chlorophyll), and a set gender too.
- AI flags, names, and lines (the same kinds in both games, numbered the same but for the win line).
- **Defeated flags**: Sinnoh's trainers record a win in their block (`TRAINER_DEFEATED_FLAGS_START` + trainer), which
  Sinnoh's system flags follow. HeartGold's use HeartGold's own trainer flags (its flag 0x550 + its trainer number,
  `FLAG_HGSS_*` in the save): `Trainer_DefeatedFlag` in `include/complete_trainers.h`, used by the script commands and
  the level caps; trainerproc counts those flags too.
- **On the maps**: HeartGold's trainer types are Platinum's by number, so the events importer makes HeartGold's
  trainers real trainers (type, sight range, the trainer as the script; the second of a double battle by its 5000+
  script). In scripts, `TrainerBattle` is `StartTrainerBattle`, `MultiBattle` `StartTagBattle` and `TrainerMessage`
  `PrintTrainerDialogue`. HeartGold's flag for a battle the player may lose without blacking out has no Platinum
  argument yet.

- **Trainers with no lines** (37 of HeartGold's, most of them the second trainer of a double battle or a partner):
  after the battle, the engine looked for the defeat line through the whole trainer message table, a card read per
  entry, which held the game for seconds. `Trainer_LoadMessage` now stops at the end of the trainer's own lines, as
  `Trainer_HasMessageType` already did.

## Trainer classes

`tools/complete/import_hgss_trainer_classes.py` (run before the trainers) brings in HeartGold's 129 classes:

- 61 have a Sovereign class's picture, palette and name (the classes HeartGold took from Platinum, Kanto's classes
  Platinum also has, the Frontier Brains, Cheryl and the other partners): they are that class. HeartGold's Waitress
  slot holds Cynthia's picture, so a class must match both.
- The other 68 are new: `TRAINER_CLASS_HGSS_*` (Kimono Girl, Medium, Sage, Firebreather, Rocket grunts and
  executives, Johto's and Kanto's Gym Leaders, the Elite Four, Red...), with HeartGold's picture converted into
  Sovereign's class files (`res/trainers/classes/hgss_*`: the cells, animation and scanned picture convert back to the
  same bytes, the palette to the same 16 colors), its names with and without an article, gender and prize money.
- Music until HeartGold's comes in (step 6): each new class has a Sinnoh stand-in (`STAND_INS`) whose sighting music,
  encounter battle theme and victory music it plays (`CompleteTrainerClass_StandIn`, `src/complete_trainers.c`), so
  Johto's leaders get the Gym Leader theme. Their encounter keeps the plain cut-in, as Sinnoh's leader cut-ins show
  Sinnoh's leaders.

## Gifts and static encounters

`GiveMon` becomes `GivePokemon` (no gift in Sacred Gold sets a form or an ability); `WildBattle` becomes
`CompleteStartWildBattle`, which can make the Pokémon shiny (Sacred Gold's red Gyarados, as the Poké Radar makes a
shiny); `GetStaticEncounterOutcome` becomes `CompleteGetBattleResult`, since Platinum's battle results have HeartGold's
numbers, and `StaticWildWonOrCaughtCheck` (whether the Pokémon got away) `CompleteCheckStaticNotBeaten`. Its other
form, which reads a var HeartGold's engine sets after a battle (once, in the Ruins of Alph), waits.

## Items and evolutions

Sacred Gold put six items of its own in the numbers of HeartGold items it doesn't use (the Journal, Seal Bag, Works
Key, Old Charm, Member Card and Secret Key, which are Platinum's items too). Each is used from the bag like an
evolution stone, in place of a trade or a place:

| Item | Evolves |
|---|---|
| Covenant Orb | What evolves by trading with no held item: Kadabra, Machoke, Graveler, Haunter (and Sovereign's Boldore, Gurdurr, Phantump, Pumpkaboo) |
| Voltaic Ore | What evolves in Mt. Coronet's magnetic field: Magneton, Nosepass |
| Woodland Ore, Chilled Ore | Eevee into Leafeon, Glaceon (the Moss and Ice Rocks) |
| Aubade Orb, Serenade Orb | Eevee into Espeon, Umbreon (friendship by day, by night) |

`tools/complete/import_hgss_items.py` adds them from Sacred Gold's ROM (data, names, descriptions, icons), and
`src/complete_evolutions.c` lets each one evolve the species whose own evolutions use that method, so Sovereign's own
ways still work and a regional form evolves as it would. In Sacred Gold's scripts and data their numbers are named as
its items (`sacred_gold.rom_items`: the disassembler recognises Sacred Gold's ROM by its Covenant Orb's data), so the
Sprout Tower sage, the trades and the item balls give them. Every in-game trade gives a Covenant Orb, as in Sacred Gold.

Sacred Gold also makes the trade items (Metal Coat, King's Rock, Dragon Scale, Up-Grade, Dubious Disc, Protector,
Electirizer, Magmarizer, Reaper Cloth, DeepSeaTooth and DeepSeaScale) usable from the bag; those are Sovereign's items
in all three regions, so that waits for the owner (`docs/Roadmap.md`, still open).

## Item balls and hidden items

`tools/complete/import_hgss_field_items.py`:
- **Item balls:** HeartGold's item ball n runs script 7000 + n (the item and count, then a common giving script).
  Sacred Gold's 255 become entries of Platinum's `scripts_visible_items.s` after its own (7328 + n), each going to
  Platinum's `VisibleItems_TryGiveItem`, and named after the map with the ball (`VisibleItems_HGSS_IlexForest_WoodlandOre`).
  Sacred Gold takes a ball off a map by moving it to (6666, 6666) and places it elsewhere (its Chilled Ore went from
  Ilex Forest to Ice Path). One of its balls gives 436 Full Heals, a slip for 1.
- **Hidden items:** HeartGold keeps its 231 in its code (`sHiddenItemParam`); they're read from Sacred Gold's ROM where
  HeartGold's build puts the table (the same as HeartGold's) into `include/data/field/hgss_hidden_items.h`, entries of
  Platinum's `gHiddenItems` from script 8300. They keep HeartGold's flags (its flag 800 + the item's number,
  `FLAG_HGSS_HIDDENITEM_*`): `Script_GetHiddenItemFlag` and `include/complete_items.h`.
- The events importer gives the maps' balls and hidden items these scripts, on every map. Sacred Gold's Route 47 has a
  second DeepSeaTooth whose event has a sign's kind (it could be picked up again and again): an event with a hidden
  item's script is a hidden item. Two of its events have a hidden item's kind but run a map script (a man in Azalea
  who gives TM46, an Insect Plate in the Bug-Catching Contest's park): they become plain script events, found from any
  side, as the engine would work out a hidden item flag from the script number.

## Trades

`tools/complete/import_hgss_trades.py` makes HeartGold's 13 trades, as Sacred Gold has them (a Gligar for a Rhyhorn,
a Torkoal for a Noctowl...), Platinum trades (`res/npc_trades/hgss_*.json`, `NPC_TRADE_HGSS_*` after Platinum's four):
the records are the same but for one word. The scripts' trade commands are Platinum's in the same order
(`LoadNPCTrade` → `InitNPCTrade`...), and the party menus for a trade and for choosing a Pokémon are Platinum's of the
same kinds. HeartGold's lent Shuckle and Kenya's mail Spearow use commands of their own (two scripts each): step 5.

## Poké Marts

A HeartGold clerk calls the common mart (the stock every mart has, by badges: the same table as Platinum's) or one of
30 special marts, lists in its code that Sacred Gold edited in place (14 of them: the Goldenrod and Celadon TM
counters, Mahogany's weather TMs, evolution stones in Goldenrod and Blackthorn...). `tools/complete/import_hgss_marts.py`
reads the lists from Sacred Gold's ROM into Platinum specialty marts (`MART_SPECIALTIES_ID_HGSS_00` to `_29`,
`include/data/mart_items.h`, each with the maps whose clerks use it), and the translation turns HeartGold's calls into
Platinum's `PokeMartCommon` and `PokeMartSpecialties` (its number past `MART_SPECIALTIES_ID_HGSS_00`), which run the
same buy and sell menu.

## Wild Pokémon

HeartGold keeps a table per area with all twelve grass slots for each time of day (morning, day, night), surfing,
Rock Smash and the three rods, the Pokégear radio's Hoenn and Sinnoh sounds and the swarm species. Platinum's tables
keep one set of grass slots and swap two of them by day and by night. So Johto and Kanto keep HeartGold's layout:

- `tools/complete/import_hgss_encounters.py` writes Sacred Gold's 142 tables as JSON
  (`res/field/encounters/hgss/encounters_hgss_NNN.json`, named by the map in pokeheartgold's list), with Sovereign's
  species names. `tools/jsoncnv/encounter_hgss.py` packs them back into HeartGold's binary layout for
  `hgss_enc_data.narc` (all 142 convert back to Sacred Gold's bytes; its files stop 4 bytes early, before two swarm
  species, which read as none). The 135 Johto and Kanto maps with wild Pokémon name their table
  (`encounters_hgss_NNN`, from HeartGold's `ENCDATA_<map>`).
- `src/complete_encounters.c`: on a Johto or Kanto map, the engine's table is filled from HeartGold's (grass as in the
  morning, surfing, rods; Platinum's own swaps get the slots they replace, so they change nothing), and at each
  encounter the twelve grass slots are those of the time of day (HeartGold's morning 4-10, day 10-20, night 20-4;
  Platinum's twilight counts as day).
- For step 5: Rock Smash encounters (Platinum's Rock Smash only breaks the rock), the radio's Hoenn and Sinnoh
  sounds, swarms (Platinum's swarms are Sinnoh's), headbutt trees.

## Roamers

HeartGold's four roamers are Platinum roaming slots after Sovereign's 13 (`generated/roaming_slots.txt`): Raikou and
Entei (Lv. 40) roam Johto from the Burned Tower scene, Latias (Lv. 35) roams Kanto once Steven tells of it in Vermilion
(Sacred Gold, like HeartGold, gives Latias; Latios is the one met at the Vermilion plaque, so its slot is only there for
HeartGold's `CreateRoamer 3`). Sacred Gold keeps HeartGold's roamers as they are.
- `src/roaming_pokemon.c` has HeartGold's 41 roaming routes after Sinnoh's 29, Johto's 16 then Kanto's 25, with
  HeartGold's neighbours (`sRoamerAdjacencyTable`; up to six, so a route's list grows by one). A roamer's random moves
  stay in its own region, as in HeartGold (Sinnoh's for Sovereign's own roamers); its moves to a route nearby stay
  there anyway.
- Sinnoh Now's roamer news flash names Sinnoh's routes and roamers only.
- The save grows by 84 bytes (four roamers and their route numbers), which the normal block has room for.
- HeartGold keeps no state for its roamers, so they have no state var as Sovereign's do. Its `CreateRoamer n` is
  `ActivateRoamingPokemon` with the slot.
- `tools/complete/test_hgss_roamers.py` releases the four and flies between Johto's and Kanto's routes: each must
  start with its species, level and HP in its region, move to another route of its region on every flight, and be met
  in surveys on its route. Battles, catching and walking are Sovereign's `tools/test/roamers.py`, the same code for
  every slot, which keeps to Sovereign's roamers.

## Still to come in this step

- The tests: every trainer battled, the wild Pokémon surveyed by time of day (`tools/complete/test_hgss_encounters.py`),
  the item balls and hidden items picked up.
