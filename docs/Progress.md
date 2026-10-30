# Progress log

Newest entries at the bottom. Each entry says what was done, how it was checked, and what comes next.

## Oct 29, 2026: step 1 starts

The owner gave the go-ahead to start while Sovereign Platinum is still being finished. Sovereign's engine is done
except two move effects another session is finishing (the Pledges and Ally Switch); what's left there is content, art
and the owner's playthrough, and it comes in through the sync script.

**Sovereign's engine is in.** `decomp/`, `tools/`, `data/`, `assets/` and `CITATIONS.md` from Sovereign Platinum at
`448a6a41` (`SOVEREIGN_COMMIT`), pushed in three commits. Each folder's git tree is identical to Sovereign's at that
commit. Two things the first copy dropped and that are now fixed: `.gitignore`'s `build/` also matched `tools/build/`
(now `/build/`), and the Pokétch stopwatch graphic is force-added, as in Sovereign, because the decomp ignores `*.lz`.

**`tools/complete/sync_sovereign.sh`** brings in Sovereign's later changes as a three-way patch. Tested in a scratch
worktree:
- rolled back to Sovereign `5d912e1f` and synced to `448a6a41` (6,738 files): all four trees came out identical to
  Sovereign's;
- with our own edit to `tools/test/drive.py` on an older Sovereign, the sync kept the edit and took Sovereign's change
  too.

**The engine builds and boots.** `make -C decomp rom` builds `pokeplatinum.us.nds` with no errors, and the headless
boot test (`tools/test/boot_smoke.py`) passes: the opening plays through to Professor Rowan's introduction. Since the
source trees are identical to Sovereign's at `448a6a41`, this is Sovereign Platinum's build.

**HeartGold and Sacred Gold.** `tools/complete/build_heartgold.sh` builds HeartGold from pret/pokeheartgold at
`ce27b413` (`HEARTGOLD_COMMIT`) into `.cache/` and applies Drayano's Sacred Gold (Complete) patch.
- HeartGold: SHA-1 `4fcded0e…`, the retail US ROM.
- Drayano's patches turned out to be in the XDelta 1 format (`%XDZ004%`), which xdelta3 can't read: the script uses
  XDelta 1.1.3 (apt package `xdelta`).
- His readme's CRC32 (`FFD28F00`) and the patch's source MD5 (`ae2a483d…`) belong to a different dump of HeartGold, the
  same 128 MB; ours is `c180a0e9` / `258cea3a…`. The bytes that differ are ones the patch never reads: Sacred Gold comes
  out with exactly the MD5 the patch records for its output, `50f6ff3e…` (131,037,664 bytes; SHA-1 `ddb83b93…`). So it
  is byte-for-byte Drayano's Sacred Gold, and the script now checks that instead of the input's CRC32.

**Build environment.** The network proxy refuses GitHub's source-archive downloads; the wrapdb mirror the build
falls back to is allowed (see `CLAUDE.md`, Building). The toolchain download (Metroskrew) and the git subprojects work.

**Next:**
1. The following-Pokémon prototype (the owner's requirement): the lead Pokémon walks behind the player on every map,
   starting from Platinum's Amity Square follower (a variable-sprite object switched to `MOVEMENT_TYPE_FOLLOW_PLAYER`)
   and HeartGold's `src/follow_mon.c` rules and sprites.
2. Room in the save for Johto and Kanto's story markers.
3. The first converter: one Johto map into Platinum's format.

## Oct 29, 2026: following Pokémon, first version

**The lead Pokémon walks behind the player.** On every map entry, and on continuing a save, the first party Pokémon
(not an Egg, not fainted, with a walking sprite) is placed as a map object with `MOVEMENT_TYPE_FOLLOW_PLAYER`, the
movement Platinum uses for Amity Square's walking Pokémon and for partner trainers. It is persistent
(`MAP_OBJ_STATUS_PERSISTENT`), so it stays through zone changes on the overworld; warps and continuing remake it. Nobody
follows while the player cycles or surfs, or while a partner trainer walks along (partners use the same movement).
Code: `decomp/src/complete_follower.c`, hooked into `FieldMapChange_CreateObjects` and `_LoadObjects`
(`src/field_map_change.c`).

**HeartGold's walking sprites.** `tools/complete/gen_follower_sprites.py` converts them and registers them as
`OBJ_EVENT_GFX_FOLLOWER_<SPECIES>`. What the comparison found:
- Both games store overworld sprites as BTX0 textures, 32x32 (64x64 for the biggest), 16 colours.
- HeartGold's have 8 frames, two per direction (up, down, left, right), and two palettes (normal, shiny). Platinum's
  walking sprites have 16, four per direction in the same order, and loop through them, so each pair becomes A, B, A, B
  with Platinum's own `BILLBOARD_FRAME_SEQ_GENERIC_WALK`.
- First set: Garchomp, Turtwig, Starly, Gallade (the test party) and Pikachu. All five are 32x32.
- Talking to the follower runs script 0, Platinum's dummy script file: harmless until it gets its own script.

**Tested.** `tools/complete/test_follower.py` on the test build: a new game, through Barry's opening scene (which plays
normally with the follower out), 7 steps in the bedroom, the test warp to Veilstone Store 2F, and 7 steps there. After
every step the follower stood one tile behind the player (also on double steps), and it was back after the warp:
PASS, 14 of 14 steps. The regular build boots (`boot_smoke.py`).

**ROM space** (`tools/test/rom_space.py`): 132.1 of 134.2 MB in use, 2.0 MiB free, almost all of it from Sovereign's own
growth since Oct 27 (the 96x96 fronts); the five sprites take about 40 KB. The new species' cries won't fit in 128 MB,
so the cartridge moves to 256 MB on its own when they come, as the plan expected.

**Not done yet:**
- The full set: 627 HeartGold sprites (with female and form variants). Four table entries per sprite in the field
  overlay would cost RAM, so the full set needs a range-based lookup instead.
- Sprites for #494–1025 and the newer forms; shiny palettes; talking to the follower.
- Updating the follower mid-map: getting on the bike, surfing, changing the lead in the party menu, a battle.
- Rules for where big Pokémon may follow (HeartGold keeps them out of small rooms), and every Sinnoh cutscene checked
  with a follower out.

**Next:**
1. The full HeartGold sprite set with a compact lookup.
2. Refresh the follower when the lead, the bike or surfing changes.
3. Room in the save for Johto and Kanto's story markers, then the first map converter.

## Oct 29, 2026: room in the save

**4,096 more flags and 512 more vars for Johto and Kanto**, without moving any of Sinnoh's:
- Flags (bits in `VarsFlags`): `NUM_FLAGS` 2912 -> 7008. The new IDs start at `COMPLETE_FLAGS_START` (2912), right
  after the daily flags; flag IDs run up to 16383, so there was room in the numbering, only not in the save.
- Vars: `VAR_COMPLETE_000` to `_1FF` after Sinnoh's last var (var IDs run 0x4000 to 0x7FFF).
- The normal save block outgrew its 13 sectors, so `SAVE_PAGE_MAX` is 33 (was 32); the extra saves (Hall of Fame,
  Battle Hall, recordings) move up one sector and still end at sector 45 of each copy's 64. `HEAP_SIZE_SAVE` grows by
  the same 4 KB.
- Sovereign Complete has its own save signature (`0x20261029`), so a Sovereign Platinum save loads as "no save data".

**Tested** with `tools/complete/test_save.py` (test build): new flags and vars set through a test hook
(`src/complete_test.c`), saved with `FieldSystem_Save`, the battery booted again and CONTINUEd: the four set flags and
both vars came back, an unset new flag stayed clear, Sinnoh's last var kept its value. PASS. The regular build boots and
the follower test still passes.

## Oct 29, 2026: HeartGold's map assets are in

`tools/complete/import_hgss_maps.py` brings in all of Johto and Kanto's terrain, textures and buildings, at fixed
offsets after Platinum's (`docs/MapConversion.md` has the formats and the numbers): 676 land data blocks, 106 map
texture sets, 562 building models, 104 building lists with their textures, 106 areas, and HeartGold's entries in the
building material/shape table.

- Tile behaviours: every number HeartGold's blocks use is checked. Reflective water and magma swap numbers to fit
  Platinum's; the ladders move to 0x0D-0x0F because Platinum's own maps use 0x3C-0x3E; headbutt trees, whirlpools and
  stop-sliding keep numbers Platinum never uses (`include/constants/field/complete_tile_behaviors.h`). They act as
  plain ground until the engine gives them their HeartGold behaviour.
- The ROM builds and boots with them: 159.1 MB on a 256 MB cartridge (104.3 MiB free); the build chose 256 MB by
  itself.

**Next:** Olivine City as a test map (`tools/complete/hgss_test_map.py`, `test_map_warp.py`): its 2x2 blocks, area
and an empty events file under `MAP_HEADER_COMPLETE_OLIVINE_CITY`, reached with the test warp.

## Oct 29, 2026: Olivine City in the engine

The first Johto map loads and walks in Sovereign's engine. `tools/complete/hgss_test_map.py MAP_OLIVINE OLIVINE_CITY`
makes `MAP_HEADER_COMPLETE_OLIVINE_CITY` from the converted assets: Olivine's 2x2 blocks from HeartGold's overworld
matrix (land data 724-727), its area (`area_data_082`), an empty events file and Platinum's empty scripts; music and
the name popup are Twinleaf's for now. `generated/maps.txt` gained `MAP_666` to `MAP_1341`, so matrices can name the
imported land data.

**Tested** with `tools/complete/test_map_warp.py OLIVINE_CITY` (test build): a new game, the test warp to the middle of
Olivine, then a step each way. The field runs, the player lands on the target tile, the top screen draws Olivine
(Gym, houses, lamp posts, flags: 411 colours), all four steps move and the lead Pokémon follows one tile behind:
PASS. Screenshots in `.cache/test-map/`.

**Next:** every Johto and Kanto map header and matrix (540 headers), with tables from HeartGold's values to Platinum's
(`docs/MapConversion.md`), then their events.

## Oct 29, 2026: every Johto and Kanto map is in

**540 map headers, 280 matrices, 491 events files.** `tools/complete/import_hgss_headers.py` brings in all of
HeartGold's map headers as `MAP_HEADER_HGSS_*`, in HeartGold's order (HeartGold map n is header 593 + n), with their
matrices and HeartGold's values translated (`docs/MapConversion.md`); `tools/complete/import_hgss_events.py` brings
in their warps, people and things, signs and hidden items. The Olivine-only test map is gone; Olivine is now
`MAP_HEADER_HGSS_OLIVINE`, part of Johto and Kanto's one overworld matrix.

What came with it:
- **HeartGold's 17 cameras** (`CAMERA_TYPE_HGSS_*`): its outdoor camera looks down at 48.7° where Platinum's looks at
  59.1°, so Johto and Kanto keep their look.
- **Place names**: HeartGold's 109 Johto and Kanto names follow Sinnoh's 126 with HeartGold's own numbers, so the name
  popup shows "Olivine City" and Pokémon caught in HeartGold or SoulSilver show where they were met.
- **The overworld matrix** is 47x17, wider than Sinnoh's 30 but within the engine's 900 cells. The matrix ID went
  from 8 to 16 bits: HeartGold's matrices run to 578, and number 512 would have read as Sinnoh's overworld.
- **Escape Rope, Dig and the Vs. Seeker** count Johto and Kanto's overworld as an overworld (`MapHeader_IsOnOverworldMatrix`).
- **HeartGold's 2,113 named flags** as `FLAG_HGSS_*` (HeartGold flag f is 2912 + f), so the hide flags work.
- **People**: Platinum's sprite of the same kind until HeartGold's own come in with the art (Rocket grunts appear as
  Galactic grunts, Johto's gym leaders as Sinnoh's); Sovereign's overworld legendaries stand in for Suicune, Lugia
  and Ho-Oh. Until step 3 everyone runs a do-nothing script, trainers don't battle, and the 195 step-on scenes are
  left out.
- **Following Pokémon follow HeartGold's rules**: on some maps nobody follows, and in most buildings only Pokémon that
  aren't too tall (HeartGold's own flag, 31 forms such as Steelix, Lugia and Wailord); Sinnoh's buildings use the same
  rule. HeartGold's other per-map data (region, the Pokégear's map position, calls, radio) is in a side table
  (`src/complete_map_info.c`) for step 5.

**Tested** (test build):
- `tools/complete/test_map_warp.py` on eight maps (Olivine, Vermilion, Olivine's Pokémon Center, Union Cave,
  Ecruteak Gym, the Radio Tower, Viridian Forest, the player's room in New Bark): each loads and draws, the player
  walks, the lead Pokémon follows, and walking into the first door leads to the right map (Olivine Gym, back out to
  Olivine through the Pokémon Center's mat, Route 32 from Union Cave, Ecruteak from its Gym...). Vermilion, in Kanto,
  sits past the 30th column of the matrix and works.
- The follower test still passes.
- `tools/complete/visit_hgss_maps.py` (new) warps into every Johto and Kanto map from the bedroom and checks that the
  field runs and the heaps' block lists are whole. Its first run found a real bug: the area loader keeps a slot per
  building model number, 768 in Platinum, and HeartGold's models run to 1151, so loading Routes 6, 7 and 11,
  Vermilion or Celadon wrote past that array into the next heap block. Now 1,152 slots. With that fixed, in four
  parallel runs: **518 maps ok, 0 failures**; the other 22 have no floor to stand on and are placeholders HeartGold
  never shows (the unused Fight Area and Battle Tower maps, `MAP_HEADER_HGSS_NOTHING`...).
- The regular build builds and boots.

**Step 2's test is passed:** every Johto and Kanto map loads. Still to come for step 2: the ferry ports' and the
Sinjoh Ruins' connections, which wait on the open decisions (unlock points, the land between).

**Next (step 3):** HeartGold's scripts and text. `docs/ScriptConversion.md` has the findings so far; a first
translator already covers 92% of HeartGold's script lines on paper, and the next piece is a few maps end to end (New
Bark Town, the player's house, Elm's lab): text banks, translated scripts and the events' script numbers, checked by
talking to people in the emulator.

## Oct 29, 2026: step 3 under way, HeartGold's scripts in the game

Johto and Kanto's people, signs and scenes now run HeartGold's own scripts and text, translated into the engine's
script language (`docs/ScriptConversion.md`):
- **904 script files** (each map's scripts and map-init scripts, `res/field/scripts/scripts_hgss_*.s`), translated by
  `tools/complete/translate_hgss_scripts.py` with the command table in `tools/complete/hgss_script_table.py`: 96% of
  the command lines. What's left is mostly HeartGold's own features (phone calls, the photographer, the Pokéathlon
  and Battle Frontier menus) and trainer battles, which come with step 4.
- **428 text banks** (`res/text/hgss_msg_*.json`, `tools/complete/import_hgss_text.py`), with HeartGold's message
  names.
- **Five new script commands** (`src/complete_scrcmd.c`): a message for a boy or a girl, and the following Pokémon's
  part in scenes (pause, wait for its step, park it, check it's out).
- **HeartGold's 39 items** Sovereign lacked (`tools/complete/import_hgss_items.py`): the S.S. Ticket, Apricorns, Kurt's
  balls and the key items, with their icons. The Pokéathlon's data cards are left out. Kurt's balls can't be thrown
  until step 5.
- The events run their own scripts again, and the step-on scenes are in.

**Tested so far** (test build): every map visited again with the scripts in: 489 ok, 22 placeholders, 29 maps
with a scene on entry and no heap errors. Replaying those scenes found a real bug: the follower's "wait" command
waited for the wrong thing, so Bill's scene in Ecruteak's Pokémon Center, the rival at Mt. Moon and others stopped
halfway. Fixed. New tools for this: `tools/complete/where_script.py` shows the script line a stuck scene is on (the
test build records the running command), and the visit test's `--scene` counts a scene that ends by sending the player
elsewhere (Ecruteak's Gym, closed until Morty is back). The full step 3 test (scenes, then talking to everyone on
every map) is running again on the fixed build. The regular build builds and boots.

**Sacred Gold's scripts:** Sacred Gold changes 203 script files, 145 events files and most of the text, and as a
binary hack it has them only in its ROM. `tools/complete/disasm_hgss_scripts.py` turns compiled scripts back into
HeartGold's script language: all 965 files of HeartGold and all 965 of Sacred Gold reassemble with pokeheartgold's own
toolchain to the same bytes, and on HeartGold the translation of its output matches the translation of the sources.
Next: Sacred Gold's events and text, then its scripts through the translator, so Johto and Kanto play as in Sacred Gold.

## Oct 29, 2026: step 4 under way, Sacred Gold's content

Johto and Kanto now follow Drayano's Sacred Gold, read from its ROM (`docs/SacredGold.md` has the details):
- **Scripts, events and text** are Sacred Gold's: its 965 script files disassembled byte for byte and translated, its
  145 changed events files (201 more people), its text, and its flags and vars past HeartGold's.
- **Trainers:** all 737 of HeartGold's as Sacred Gold has them, parties on Sovereign's 1025 Pokémon, with their lines,
  HeartGold's own defeated flags and its 68 trainer classes Platinum lacks (pictures converted, Sinnoh music
  stand-ins until step 6). The battle test found a post-battle stall for the 37 trainers with no lines: the game read
  the whole trainer message table, a card read per entry. Fixed in `Trainer_LoadMessage`.
- **Wild Pokémon by time of day:** HeartGold's tables (morning, day, night; surfing; rods) as Sacred Gold has them,
  read by the engine on Johto and Kanto maps (`src/complete_encounters.c`).
- **Gifts and static encounters** (Sacred Gold's red Gyarados is shiny), **item balls** (255) and **hidden items**
  (231, with HeartGold's flags), **trades** (13, Sacred Gold changed 9) and **Poké Marts** (30 special marts, 14
  changed by Sacred Gold).
- **Sacred Gold's six evolution items** (Covenant Orb in place of trades, Voltaic Ore for the magnetic field, and four
  for Eevee) are items, and evolve as Sacred Gold has them, beside Sovereign's own ways. Open for the owner: Sacred
  Gold's trade items used from the bag (`docs/Roadmap.md`).
- About 60 more HeartGold script commands turned out to be Platinum's under other names; 97.1% of Sacred Gold's
  83,001 script lines translate. HeartGold's standard menus (108) showed Platinum's menu strings at HeartGold's
  numbers; they now read HeartGold's own menu strings (`CompleteInitHGSSMenu`). The department store, Radio Tower,
  lighthouse and Silph Co. elevators translate too, with HeartGold's floor numbers and names (97.2%).

New tests: `tools/complete/test_hgss_hidden_items.py` (each hidden item found once and only once) and
`tools/complete/test_hgss_encounters.py` (each map's wild Pokémon match its table at 6:00, 12:00 and 22:00).

Test results on the new test build:
- **Trainers:** all 737 battle and end cleanly.
- **Wild Pokémon:** every Johto and Kanto table, by time of day (6:00, 12:00, 22:00), surfing and the three rods: 29,664
  Pokémon made by the game's own encounter code, every one of them a species and level its table allows.
- **Hidden items:** of 243, 234 are found once and only once. Seven lie under something (an item ball, a person,
  Articuno at Seafoam), so A talks to that first, as in HeartGold; two have no tile beside them the player can reach.
- **A hang the hidden-item test found:** 38 items on Route 3, Route 32, Route 34, Route 35 and most Kanto towns hung
  the game on the way in. Platinum shares a building model's animations across every copy of it on the map, and a
  HeartGold building with two or more animations playing linked one to itself in the second copy's list, so NNS
  looped forever. Fixed in Platinum's animation manager, which now also shows HeartGold's time-of-day windows (one
  animation for each time of day) as HeartGold does (`docs/MapConversion.md`). All 46 items on those maps pass now.
- **Gym puzzles:** Vermilion's trash cans, Violet's lift, Azalea's Spinarak carts, Cianwood's winch, Ecruteak's
  dark and Blackthorn's floors over the lava are ported (`docs/ScriptConversion.md`, "Gym puzzles").

## Oct 29, 2026: step 3's tests, roamers, Kurt's Apricorn Balls

- **Roamers:** Raikou and Entei roam Johto, Latias and Latios Kanto, as in HeartGold (four new roaming slots, each
  kept to its region's routes; `docs/SacredGold.md`, "Roamers"). New test: `tools/complete/test_hgss_roamers.py`.
- **The signs and triggers test** (`tools/test/signs_and_triggers.py`, every sign, hidden item and step-on trigger on
  the new maps) found:
  - **Ecruteak Gym crashed on the way in.** Its four spotlights carry 49 KB of textures each, the field heap ran out,
    and a file was then read into a NULL buffer over the interrupt handlers. Platinum binds a building to its area's
    texture set and never reads a model's own copy, which now goes once HeartGold's models are bound
    (`docs/MapConversion.md`).
  - **None of HeartGold's 56 doors opened**, and a scene that opens one (Mom coming out in New Bark) played an
    animation that was never loaded, writing through a NULL pointer. HeartGold's doors are now in Platinum's door
    lists, with their sounds, and a door animation that isn't loaded is skipped.
  - **HeartGold's new-game flags were never set**: its new-game script hides the people who come later in the story,
    and Sacred Gold's Mom hides its own in her first scene. Neither ran, so those people stood on their maps from the
    start, some on step-on triggers. Both sets (165 flags) are now in the engine's new game.
  - **Scenes crashed when someone in them wasn't on the map** (Lyra on Route 29, the rival in Cherrygrove and on
    Route 25, Vermilion): five of Platinum's object commands (lock, release, movement type, position, persistence)
    wrote through a NULL pointer for an object the map lacks, over the interrupt handlers. They now skip it, as
    `ApplyMovement` already did. HeartGold's movement-type command also set its follower to types past Platinum's
    table (Blackthorn Gym's entrance); the engine's follower code sets its own.
  - The test itself: a trainer who spots the player just after a warp, the first full save (which stops the vblank
    for a while), a prize counter's menu loop, Ecruteak Gym's kick-out scene and Sinjoh's choosing tiles each needed
    handling.
- **Script commands:** about 15 more of HeartGold's map to Platinum's (`GetGameVersion` answers HeartGold, doors in
  scenes, the Rotom room, Deoxys's form, the Unown count, game records); 98.2% of Sacred Gold's lines translate.
- **HeartGold's daily flags** weren't cleared each day (Kurt, the haircut brothers, Union Cave's Lapras, the Trainer
  House, the Bug-Catching Contest); they are now.
- **Kurt's Apricorn Balls** (step 5): the 31 Apricorn trees, the Apricorns as bag items and Kurt's Balls
  (`docs/Features.md`). The Balls can't be thrown yet: they need their battle graphics.
- **Sacred Gold's Pokémon** standing about (its lake trio at Sinjoh, Mew, the legendaries it adds) show the engine's
  sprite of that Pokémon where it has one, not a stand-in person.

## Oct 29, 2026: HeartGold's Balls in battle, shared people, step 5 and 6 plans

- **Kurt's Balls can be thrown.** The seven Apricorn Balls are battle items with HeartGold's catch rules (the Lure
  Ball needed battles to know a rod hooked the Pokémon), and a Pokémon keeps HeartGold's Balls in the byte HeartGold
  keeps them in, beside Platinum's (`docs/Features.md`). They are drawn as a Poké Ball until their graphics come in.
  New test: `tools/complete/test_hgss_balls.py`; all seven catch and stay the caught Pokémon's Ball, and a Friend
  Ball's catch starts at 200 friendship.
- **HeartGold's shared people** run Platinum's scripts that do the same: the Trainer Card attendant, the day-care
  couple, and the Marts' Mystery Gift deliveryman (shown by Platinum's flag as a Mart loads). Mom's gift deliveryman
  stays hidden. The Colosseum, Union Room and Wi-Fi Club attendants wait for link play: Platinum's walk the player
  through Platinum's rooms.
- **The import tools** only rewrite a file whose text changes, so a rerun no longer rebuilds the whole game.
- **Plans** for the Bug-Catching Contest and the Johto Safari Zone (`docs/Features.md`) and for Johto and Kanto's
  music (`docs/Music.md`). Sacred Gold changed neither the contest's data nor the Safari Zone. The music fits once
  Platinum's always-loaded instrument set is split (137 KB freed), and moves the cartridge to 256 MB.
- **Signs and triggers, first half on the new build:** 603 of 628 run to their end. The rest are known kinds:
  something standing on the tile (the Rotom room's appliances, hidden items under people or balls), tiles the test
  can't reach (Azalea Gym's cart track, Rocket HQ's Electrodes, the Ruins of Alph's hidden rooms, which have no way in
  but falling, water on Route 47), and the Global Terminal's Wi-Fi machine waiting for a connection.

## Oct 29, 2026: the Bug-Catching Contest

- **The Bug-Catching Contest** works as in HeartGold (`docs/Features.md`): the gate on contest days, 20 Sport Balls
  and 20 minutes, the day's Pokémon, five of ten Bug Catchers, the judging and its prizes, and the party back with
  the catch. HeartGold's contest scripts are translated as they are; its battle asks which Pokémon to keep where
  HeartGold opens a screen of its own. New test: `tools/complete/test_hgss_bug_contest.py`, all four parts pass (entry,
  encounters, a Sport Ball catch, time up and the judging). The Ball test still passes.
- **Test tools:** the test clock can set the weekday, a survey on the contest's grass writes its Pokémon down, and
  the harnesses can read another test build's symbols (`TEST_BUILD`).
- **Signs and triggers, second half:** of 628, 600 ran to their end at first. Looked into:
  - **Johto's Elite Four and Lance never started their battles.** Their classes are HeartGold's, which take the map's
    own cut-in, and the League rooms' terrains weren't in that choice (Platinum's own League has cut-ins of its own),
    so the effect index was left unset and the cut-in never ended. Those terrains now take the plain one
    (`CutInEffects_ForBattle`). Lance's scene now runs through his battle to its end.
  - The test, not the game: Violet Gym's lift has its gym guide on it until Sprout Tower is done (as in HeartGold;
    the test hides him first), Lance's room walks the player six tiles in on every entering (the test arrives that
    much further out), and Mt. Moon Square's Clefairy dance happens on Monday nights (the test sets the clock).
  - Left as test limits: two of Route 47's triggers are on a bridge the test reaches from the high side, and Sacred
    Gold moved three of Oak's lab's signs off the map. The rest are the known kinds (things on the tile, tiles the
    test can't reach).

## Oct 30, 2026: the Johto Safari Zone, and Johto and Kanto's music

- **The Johto Safari Zone** works as in HeartGold (`docs/Features.md`): the gate's ₽500 game with 30 Safari Balls and no
  step limit, six of the twelve areas on the outside map in the arrangement saved for the player, each area's Pokémon by
  time of day on land, water and the rods, and the objects: A on open ground places one of those Baoba has unlocked (a
  list menu where HeartGold has a screen of its own), A on one takes it away, and objects bring out their areas' bonus
  Pokémon as days pass. Baoba's tests are HeartGold's scripts; his calls happen when they would have rung until there is
  a Pokégear; his console rearranges the areas (two list menus). The objects are drawn as each area's block loads, with
  their tiles blocked. New test: `tools/complete/test_hgss_safari.py`, all six parts pass (entry, the arranged areas,
  each area's Pokémon, placing and taking away an object, leaving, and the console).
- **Talk to everyone, first of six stages on the new build:** 321 of 399 people ran to their end. The rest: 66 hidden at
  a new game (a later pass shows them first), 8 the test can't reach (Bugsy behind Azalea Gym's carts, the Battle
  Tower's partner room, an item ball on Victory Road, a bollard in Mt. Moon Square and a man in the Frontier Access),
  the Union Room's three waiting for link play, and Route 34's policeman waiting on a stand-in.
- **Johto and Kanto play HeartGold's music** (step 6, `docs/Music.md`): 116 of its songs, on their maps, in their
  scripts, for its trainers' encounters, battles and victories, and for surfing and cycling. To make room, Platinum's
  always-loaded basic waves are split: the 57 only music plays (143 KB) now load with the music banks, leaving 106
  loaded (301 KB) for sound effects, fanfares and cries, checked note by note against every sequence. HeartGold's songs
  keep its sequence files byte for byte, each with a bank of its own, and their waves load one by one, only those a song
  plays. New test: `tools/complete/test_sound_heap.py`, all three parts pass: every song loads (the credits' in their
  own scene), a battle leaves 5 KB, and New Bark Town's song and a battle there with HeartGold's trainer theme load (13
  KB to spare).
- **A bug in Sovereign's `nitrosfx`** wrote the sound archive's file table 28 bytes off whenever the file block's header
  didn't end on 32 bytes, which crashed the game at boot as soon as the archive grew; Sovereign's own archive happened
  to line up. Fixed here (`tools/nitrosfx/sdat.c`); Sovereign Platinum will meet it too if it adds to its sound archive.
- **HeartGold's Battle Frontier move tutors** (Frontier Access) called a standard script past the end of the
  Bug-Catching Contest's file, which the talk test caught as stuck: the translator now sizes each standard file by its
  scripts, so the tutors say nothing until their Battle Point teaching (HeartGold's own commands) comes in.
- **HeartGold's fanfares** (an item, a badge, a Pokémon caught: 23 its scripts play) are in too, each with its own bank;
  Platinum's fanfares play from its loaded instruments, so one of HeartGold's loads its own as it starts. The sound
  test's Johto part plays each of them over New Bark Town's song, then a battle: all load, 11 KB to spare at the least.

## Oct 30, 2026: the step 3 tests on the new build, and fixes from them

- **Talk to everyone, all six stages:** 2,387 people and things; 1,937 ran to their end, 390 were hidden at a new game
  (the next item), 29 had no tile the test could stand on, 12 were answered by someone else on their tile. The 19 that
  hung or got stuck: the Union Room's ten (they wait for link play; the test now leaves them out), the Dragon's Den
  elders' quiz (four; the test now sees the scene before it first, and they run), the Frontier Access move tutors
  (fixed: the translator now sizes each standard script file by its scripts, so a call can't land in the next file), the
  Battle Factory's receptionist (runs on this build, saving and all), and the Pokéathlon Dome's guide (a menu the test
  keeps reopening).
- **The hidden ones, shown** (`--unhide`, which clears each one's hidden flag): of 402, 188 ran, 11 were answered by
  someone else on their tile, one is Sacred Gold's Gym Leader rematch gauntlet in Saffron's Fighting Dojo (a dozen
  battles in a row, longer than the test waits), and 200 stayed hidden, because HeartGold's maps hide their people by
  setting those flags from the story as they load. In the test build no script may now set the flag of the person being
  tested until the player is there (`gCompleteTestKeepFlagClear`): of those 200, 158 now run to their end and 42 stay
  hidden some other way (scenes that place them, ten of Route 47's people, the Rock Smash rocks in Cliff Cave). None hung.
- **Pewter City's Latios crashed the game after its battle.** The cause is Sacred Gold's own script: the map script that
  runs when the field comes back after a battle there ends by jumping into the middle of the Lati's talk script
  (HeartGold has `End` there). It can't be reached in Sacred Gold, as the Pewter Lati only appears through a Mystery Gift
  (the Enigma Stone); HeartGold's check for that event wasn't translated, so here it could. It now reads as never
  received, so Pewter's Lati stays away; Sacred Gold gives the second Lati at Vermilion's plaque.
- **Visit every map, the scenes:** the maps whose scene on arrival didn't end now all do but one. The test's battles
  pressed A, which picks the test lead's Ground move, and a Flying foe (Route 2's and 3's trainers, Azalea Gym's) never
  went down; they now tap the trainer test's moves. Mt. Moon's rival battle takes 13,000 frames, over the old limit;
  the Frontier Access guide's facility menu needed B. Left: the Dragon's Den elders' quiz on arrival, which the test's
  answers keep failing.
- **More of HeartGold's commands translated:** Blackthorn's Move Maniac (Platinum's Move Reminder menu; untranslated, he
  took the Heart Scale and taught nothing), the Draco Meteor tutor and Sacred Gold's added tutor (Platinum's tutor menu),
  the Move Deleter's move pick, the follower's "too tall for this building" check (untranslated, every follower was put
  away at the Power Plant's door), and the Game Corners' machines, where Platinum's slot machine stands in for Voltorb
  Flip (`docs/Features.md`, "Stand-ins"). 98.3% of Sacred Gold's script lines now translate.
- **The starter in Elm's lab:** HeartGold's starter choice wasn't translated, so the player left with no Pokémon. It is
  now Platinum's starter scene (Rowan's briefcase) offering Chikorita, Cyndaquil and Totodile, with Elm's questions
  (HeartGold's own text), the pick given at Lv. 5; Johto's starter is kept in HeartGold's own variable, which Rival's
  teams follow, apart from Sinnoh's. The Poké Balls are back on Elm's machine (HeartGold's model, three, then two). New
  test: `tools/complete/test_hgss_starter.py` (passes: Chikorita, Lv. 5).
- **Johto's rival has a name of his own.** HeartGold's naming of the red-haired boy in Elm's lab wasn't translated, and
  its scripts buffered Platinum's rival's name (Barry's). He now gets Platinum's naming screen with HeartGold's prompt
  ("This boy's name?") and its default for a blank name (Soul), and the name is kept in eight of Sacred Gold's unused
  variables (`src/complete_rival.c`), so the save keeps its layout and Sinnoh's rival keeps his. Scripts and his
  battles use it ("You are challenged by Rival ..."); until he is named he is Silver, as his trainer data has it.
  Checked in the emulator through Elm's lab's police scene, with a name typed and with none.
- **Blacking out in Johto and Kanto sent the player back to Sinnoh.** Platinum's spawn table (where the player comes
  back, and where Fly lands) had only Sinnoh's places, so a Johto or Kanto Pokémon Center never became the place to come
  back to. HeartGold's 30 spawn points now follow Platinum's 20 (`tools/complete/import_hgss_spawns.py`), its Pokémon
  Centers and the player's house in New Bark Town among them, and blacking out after visiting home there plays
  Platinum's scene with Mom (its Mom is the same person number as Twinleaf's). HeartGold's SetSpawn (Mr. Pokémon's
  house) sets it too. Fly over Johto and Kanto waits for the three-region Town Map (step 7). New test:
  `tools/complete/test_hgss_blackout.py` (both parts pass: Cherrygrove City's Pokémon Center, and home). The test
  build's own battles now black out after a loss too, as the scripts that start battles in the game do; they used to
  leave the screen black.
- **Johto's Hall of Fame.** HeartGold's game clear after Lance (and after Red) wasn't translated, and the script went on
  to restart a field that was still running. It now plays Platinum's Hall of Fame machine and screen, records the team,
  saves and starts the game over; Continue wakes the player in their room in New Bark Town, with HeartGold's game clear
  flag set and Sinnoh's left alone (`ClearGame_Johto`, `src/clear_game.c`). No credits roll yet: which League rolls
  them is a question for the owner (`docs/Roadmap.md`). New test: `tools/complete/test_hgss_hall_of_fame.py` (passes).
- **Hidden items, Oak's Pokédex rating and the Global Terminal's check.** Three of HeartGold's standard scripts weren't
  translated: the fanfare for a hidden item (silent before; Platinum's common script plays the same fanfare by pocket),
  Professor Oak's rating in his lab in Pallet Town (Platinum's own Oak rating, of the National Pokédex; his
  completion scene follows it as in HeartGold), and the Global Terminal's message for a party that can't be taken
  (Platinum's Bad Egg check and message). Only the Battle Frontier's tutors are left among them, waiting on the
  Frontier question.
- **Johto's and Kanto's badges.** HeartGold's `GiveBadge` did nothing, and Johto's Cut trees, rocks and boulders ran
  Platinum's field-move scripts, which ask Sinnoh's badges: a player in Johto could never use Cut (Ilex Forest's tree
  stands in the story's way). The 16 badges are now in the trainer info beside Sinnoh's (in its padding, so the save
  keeps its layout), and a field move works with either region's badge for it, in the scripts, the party menu and the
  Surf prompt. They count wherever Platinum counts badges (obedience, the common Mart's stock, the blackout penalty,
  capped at eight there as its table is). Vermilion Gym's gates now follow the Thunder Badge itself. New test:
  `tools/complete/test_hgss_field_moves.py`. Sovereign's level caps (off by default) still follow Sinnoh's fights only;
  that waits on the level curve (`docs/Roadmap.md`).
- **The S.S. Aqua sails.** HeartGold's sailing scene wasn't translated, so the player walked up to the ship and stayed
  on the dock. It is Platinum's boat scene now (Platinum's scene, which sails its own ship out first when one is beside
  the player, starts at the fade-out at HeartGold's ports). HeartGold's rest scenes (the ship's cabin, Mom's house) now
  leave the field before coming back to it (`ScrCmd_436`, Platinum's `WaitForTransition`). New test:
  `tools/complete/test_hgss_ferry.py` (boarding and arriving at both ports: passes).
- **Smaller translations:** the Goldenrod Underground's haircuts raise Beauty and Sheen as well as friendship
  (`CompleteMonAddContestValue`), Route 3's meteorites check for a Deoxys in the party (they change its Forme), and Mom's
  money menu answers consistently until her savings are ported (`docs/Features.md`, "Stand-ins"). 98.4% of Sacred
  Gold's script lines translate.
- **Headbutt trees and Rock Smash finds.** HeartGold's Headbutt trees did nothing here (their tiles acted as plain
  ground), smashed rocks only broke, and Ilex Forest's Headbutt tutor said every Pokémon couldn't learn it. Now a
  Headbutt tree asks to use Headbutt and can drop one of the map's tree Pokémon (HeartGold's tables, with its common,
  rare and empty trees by trainer ID, and its secret trees), a smashed rock on a Johto or Kanto map can hold a wild
  Pokémon at the map's Rock Smash rate or an item from HeartGold's lists, and the tutor checks HeartGold's list
  (`src/overlay006/complete_field_encounters.c`, `tools/complete/import_hgss_field_encounters.py`). The battles are set
  up as Platinum's wild battles are. New test: `tools/complete/test_hgss_headbutt.py`.
- **Whirlpool.** HeartGold's whirlpools (3×3 blocks of water on Route 27, Route 41 and in Dragon's Den) stopped a
  surfer for good. Facing one while surfing now asks to use Whirlpool (the Glacier Badge, and a Pokémon that knows it
  or HM05 in the bag: Lance's HM05 is Platinum's Defog, `docs/Roadmap.md`), and the player surfs across. New test:
  `tools/complete/test_hgss_whirlpool.py`.
- **Snorlax, the lottery and smaller queries.** Kanto's Snorlax on Routes 11 and 12 asked the radio whether the Poké
  Flute played, which the translation always answered no: Kanto's way east was shut. Until the radio comes, the Poké
  Flute counts as playing once the player has the Expansion Card (`docs/Features.md`, "Stand-ins"). The Radio Tower's
  lottery is Platinum's Jubilife TV lottery (the same number of the day and search), the Hidden Power checker uses
  Platinum's calculation, and five of HeartGold's party queries are new commands in `src/complete_scrcmd.c`: how many
  of a species are in the party (Saffron's Rotom fan), whether Kyogre or Groudon is (Professor Oak), whether a party
  Pokémon came from another trainer, a Pokémon's effort total (Blackthorn's checker), and whether every Unown letter has
  been seen (the Ruins of Alph's researchers). 98.4% of Sacred Gold's script lines translate (1,320 left).
- **Follower and scene leftovers.** The follower now comes out beside the player when Elm hands over the starter, and in
  Route 3's scenes (HeartGold's `ScrCmd_605`, `CompleteFollowerPlace`; the Poké Ball effect as it comes out isn't
  ported). Scenes that move the player now also set where Escape Rope and Dig lead (HeartGold's `ScrCmd_582`,
  Platinum's exit location), and Celebi's time travel fades to white until its own scene is ported. Test:
  `tools/complete/test_hgss_starter.py` (passes; the follower stands east of the player after the gift).

## Oct 30, 2026: the Pokégear phone

- **The phone book and phone trainers.** HeartGold's phone was missing: its trainers never asked for the player's
  number, so Sacred Gold's rematches (63 trainers' teams, up to five each) could never be fought, and Gym Leaders'
  phone lines were left out. The phone book is now in the save (a new save entry of 456 bytes, in the room the normal
  block had: 1,900 bytes), with HeartGold's data (`tools/complete/import_hgss_phone.py`: Sacred Gold's phone book,
  HeartGold's call tables and rematch sets, which Sacred Gold's overlays hold unchanged, and the 75 callers' text
  banks). Johto's and Kanto's trainers go through Platinum's trainer script, which now takes HeartGold's phone steps
  (its `scr_seq_0953`): the number after the first battle, a rematch when a call asked for one, a promised gift, the
  number asked again, an item after some rematches.
- **Calls,** in the message box: map scripts' calls (Elm's panic call, Mom's on Route 30, Oak's, Baoba's; their text
  was lost before), and incoming calls as the player walks (call triggers, and random callers ten minutes after the
  last call, as HeartGold's ring manager picks them). Calls are answered at once, and calling someone waits for the
  Pokétch and Pokégear question (`docs/Features.md`, "The Pokégear phone").
- **The childhood friend's look.** HeartGold's `GetFriendSprite` (Lyra's look for a boy, Ethan's for a girl) wasn't
  translated, so in its nine scenes the friend wore the boy's player sprite whoever played. It now picks Platinum's
  player sprite of the other gender (`CompleteGetFriendSprite`; Lucas and Dawn stand in for Ethan and Lyra, as on the
  maps).
- 98.7% of Sacred Gold's script lines translate (1,082 left). New test: `tools/complete/test_hgss_phone.py` (Joey on
  Route 30: his number, his rematch, his promised gift, a random call from him, and Mom's call; all five pass).
- **Talk to everyone, again** on this morning's build (before the phone): 2,336 people and things, 1,923 ran to their
  end, none hung (the Union Room's people are left out now). Against the last run, 43 more ran and 16 fewer: those 16
  are people who wander about, whom the test reaches some runs and not others, and Cameron, who stands somewhere new
  each day. The one still stuck is in the Pokéathlon Dome (a menu the test keeps reopening), as before.

## Oct 30, 2026: Mom's savings

- **Her share, her shopping, her deliveryman and her bank** (`docs/Features.md`, "Mom's savings"): with her savings
  on, a quarter of what a battle brings goes to her (the prize message says so), she buys HeartGold's list of things and
  Berries with it and calls about them, the Marts' deliveryman hands them over, and at home she has HeartGold's bank
  menu, with the savings and the wallet in a box and an amount window where HeartGold has its touch screen's number
  pad. Her deliveryman was hidden for good before; the call triggers' names come from HeartGold now
  (`constants/hgss_phone.h`), and the script lines that clear one translate (Elm's after the Egg hatches, too).
- 98.7% of Sacred Gold's script lines translate (1,072 left). `tools/complete/test_hgss_phone.py` has three more parts:
  her share of Joey's rematch prize and the Super Potion she buys, the Cherrygrove Mart's deliveryman, and a withdrawal
  at home; all eight pass.

## Oct 30, 2026: the follower keeps up mid-map

- **The follower changes as HeartGold's does** without a map change: on each field frame the player has control, it's
  made again when it isn't the one the lead, the player and the map call for (`CompleteFollower_Update`). So it goes
  back in its ball when the player gets on the bike or starts surfing and comes out again after, becomes the new lead
  after a switch in the party menu (or when the lead faints or evolves), leaves on walking onto a map where nobody
  follows, and comes back out after a scene put it away. Before, all of this waited for the next warp.
- **HeartGold's touch-screen mark:** 695 of Johto's and Kanto's questions ended with `{YESNO 0}`, which drew
  HeartGold's "answer on the touch screen" icon at the end of the line; the text importer drops it now, as the yes or
  no is on the top screen.
- **Tested:** `tools/complete/test_follower.py` has two more checks, through test-build hooks: the party's first two
  Pokémon swap places and the follower becomes the new lead (Garchomp to Turtwig), and getting on the bike puts it away
  and getting off brings it back. It passes, walking checks included (the follower stays a tile behind, so it isn't
  made again every frame). `tools/complete/test_hgss_starter.py` passes (the follower comes out beside the player after
  Elm's gift).

## Oct 30, 2026: the Ruins of Alph puzzles

- **HeartGold's sliding puzzles** (`docs/Features.md`, "The Ruins of Alph puzzles"): its app ported to Platinum's
  libraries, in an overlay of its own (`complete_alph_puzzle`), with HeartGold's graphics archive built from its sources
  and its text. Before, reading a chamber's slab did nothing, so the underground hall, its Unown and the researchers'
  rewards for seeing letters were out of reach. Three things needed Platinum's own way: its sprite loader puts
  characters at the top of VRAM unless asked otherwise (out of reach of HeartGold's 1D 32K mapping), and gives each
  sprite an explicit palette (the panels pick theirs in their cells); and its touch yes and no buttons are bigger than
  HeartGold's, so their tiles go after the question's window.
- **The hall's Unown** follow HeartGold: none before a puzzle is solved, then the solved puzzles' letters.
- 98.7% of Sacred Gold's script lines translate (1,064 left). New test: `tools/complete/test_hgss_alph_puzzle.py`, all
  four parts pass (48 Unown from the hall after the Kabuto puzzle, every one A to J).

## Oct 30, 2026: talking to the following Pokémon

- **HeartGold's follower talk** (`docs/Features.md`, "Talking to the following Pokémon"): talking to the follower used
  to run Platinum's empty script. Now it does what HeartGold's does, ported from the assembly of its overlay 2 (pret's
  decomp hasn't turned that part into C): its choices pick one of its interactions for the moment (the Pokémon's HP,
  status, mood, friendship, nature, type, held item and kind; the tile, the time, the weather, the people and hidden
  items nearby, the map, a story flag; a chance), and the interaction plays: hops and turns, its cry, its lines, a yes
  or no leading on, changes to friendship and mood, an accessory or a Shiny Leaf found. HeartGold's four archives are
  packed into one (`tools/complete/import_hgss_follower_talk.py`, with HeartGold's maps, flags and tile behaviours
  translated), and its text is in (msg_0265).
- **HeartGold's mood** is kept in the byte HeartGold keeps it in; battles and walking change it as in HeartGold.
  **Shiny Leaves** are kept too, and Lyra's or Ethan's crown for five works (two script commands HeartGold's scripts
  needed). 98.7% of Sacred Gold's script lines translate (1,062 left).
- **The map visit test** stopped on routes where a trainer spots the player on arrival: since step 4's trainers, a
  battle starts, and the test only pressed B. It now fights it (as the trainer test does). Over all 540 Johto and Kanto
  maps: 517 ok, 22 placeholders with no floor, and Dragon's Den's shrine, whose elders' quiz on arrival the test's
  answers keep failing (as before).
- **Tested:** `tools/complete/test_follower_talk.py`, all five parts pass: the talk the tables chose in New Bark Town (a
  hop and a line), the nudge's question and its yes (three motions, the follow-up's line), an accessory found (a White
  Fluff in the Fashion Case), a Shiny Leaf (worn, mood 120) and a talk in Twinleaf Town, where only the general choices
  apply (Garchomp "is wandering", interaction 205). `tools/complete/test_follower.py` still passes. A file
  of an overlay has to be in `main.lsf.in`'s list for it, or it's linked outside the overlay and calls into it crash.
- **The emotes:** HeartGold's 14 bubbles over the follower (a heart, faces, "...", "!"...) pop up and play their two
  frames, as in HeartGold, in a billboard of Platinum's field effects whose model, frames and frame sequence come from
  the talk's archive. The test checks the nudge's heart, and the screenshots show the bubbles over the follower.
- **The rest of HeartGold's mood:** TMs, surviving poison, and its items (Rare Candy, vitamins, X items, the bitter
  herbal medicine) change it too, where Platinum changes friendship for them.
- **The legendary Pokémon's sway** before their scenes (HeartGold's `ScrCmd_523`: Suicune's chase, the three in the
  Burned Tower, Rayquaza) is `CompleteObjectSway`; the Burned Tower's step-on scene plays to its end in
  `tools/test/signs_and_triggers.py`. 98.8% of Sacred Gold's script lines translate (1,031 left: the Battle Frontier,
  the Pokéathlon, link rooms, the photo album and the radio, which wait on the owner's decisions).

## Oct 30, 2026: loan Pokémon, the Magikarp record, and smaller ports

- **Loan Pokémon** (HeartGold's `GiveLoanMon` and five more; `docs/ScriptConversion.md`): the man in Route 35's
  gatehouse lends Kenya (Sacred Gold's Dux), the Spearow with a letter for his friend on Route 31, who checks the letter
  is his friend's, takes Kenya back and gives TM44; Kirk in Cianwood City lends Shuckie, his Shuckle. Each is that NPC
  trade's Pokémon, met where it's lent; Kenya's letter is HeartGold's (three Easy Chat lines, Kenya's icon), and the
  gatehouse man finds it in the party or the PC's mailbox.
- **The Lake of Rage's Magikarp record:** the fishing guru measures a Magikarp with Platinum's size contest's sizes,
  against a record of its own (`VAR_HGSS_MAGIKARP_SIZE_RECORD`, 3'6" at a new game as in HeartGold), so Sinnoh's
  contest record stays apart.
- **Smaller ones:** the Celadon Condominiums' game designer checks HeartGold's Johto Pokédex
  (`tools/complete/import_hgss_johto_dex.py`; Mew and Celebi aside) and shows Platinum's National Pokédex diploma for
  the National one (the Johto certificate has no screen yet); Olivine City's seal gift puts three random seals in the
  Seal Case; the last battle's result is kept as HeartGold keeps it (`VAR_BATTLE_RESULT`), for the scripts that read
  it on returning from a battle (Team Rocket's hideout's Electrodes, whose talk-test runs end) and for Pewter City's
  Latias or Latios. 98.8% of Sacred Gold's script lines translate (1,005 left).
- **HeartGold's changes to the overworld's blocks** as a map loads (`CompleteMapInfo_LoadMatrix`): Mahogany Town's
  antenna tree is gone once Team Rocket's hideout is cleared (its script now records it as HeartGold's does), and the
  Lake of Rage is low on Wednesdays after that, seen from the lake or Route 43. More of HeartGold's small commands
  translate: an object's facing (get and set), a chance in 101, the map the player came from (as HeartGold numbers
  maps, which its scripts compare with), the Fashion Case's accessories and backdrops (Platinum's commands), and
  three empty ones. 977 of Sacred Gold's script lines left.
- **HeartGold's scene themes:** the songs HeartGold's standard scripts and `TempBGM` play are in (11 more: the
  friend's, Lyra's for a boy and Ethan's for a girl, the rival's two, the "follow me" two, Eusine's, the Kimono Girls'
  theme and dance, Lugia's arrival, the spiky-eared Pichu's), and the scenes play them where Sinnoh's themes stood in
  (Barry's, Dawn's or Lucas's, Platinum's "follow me") or nothing played (Eusine, Clair, the Kimono Girls). Every song
  still loads (`tools/complete/test_sound_heap.py`'s songs part), and Route 29's scene with Lyra plays to its end.
- **HeartGold's follower inhibit flag** (`SetFollowMonInhibitState`): Blackthorn Gym's guide and Viridian's Trainer
  House keep the follower in its ball for the rest of the visit, as HeartGold does; the next map change lets it out
  (HeartGold keeps the flag in the save, so a reset there doesn't). Before, the scene's put away and return around it
  brought the follower straight back onto the gym's floor puzzle. New test `tools/complete/test_follower_inhibit.py`
  (2 of 2: no follower after the guide's talk, nor after a few steps; back in Blackthorn City);
  `tools/complete/test_follower.py` still passes. 963 of Sacred Gold's script lines left.
- **The Magnet Train runs:** HeartGold's ride (`ScrCmd_722`) was left untranslated, so the player boarded and nothing
  happened. It is now a fade and a warp to the other city's station (HeartGold's ride scene isn't ported), whose scene
  walks the player off and down. New test `tools/complete/test_hgss_magnet_train.py`, both ways pass (Goldenrod to
  Saffron and back, ending on the other station's ground floor).
- **Goldenrod Tunnel's dress-up and lottery:** HeartGold's dressing room, its photo's title and the frames that show
  the photos are Platinum's own commands from Jubilife TV's gallery (HeartGold kept them, unnamed in both decomps);
  its accessory lottery (a random accessory of 39, then one of the first 14 backdrops the player lacks) is four new
  commands. Everyone there and every frame runs to its end (talk and trigger tests). 932 of Sacred Gold's script lines
  left.
- **Sovereign's static checks over the whole game, Johto and Kanto included, all pass:** every event and init script
  number of 1,035 map headers in range, 2,530 warps leading to warps that exist, 943 script files showing their own
  map's texts, 10,332 messages and signs fitting their boxes, 208 menus on screen, every one-byte text ID fitting, and
  no message closed twice (the check now knows the follower talk's step prints a line).
- **The test build** notes the party screen `SelectMoveTutorPokemon` opens as a menu, as the trade's already was, so a
  test can pick a Pokémon there (HeartGold's scripts pick one with it).
- **The talk test over every added person** (`tools/test/talk_to_objects.py`, 5,865 on this build) is running. Fixed
  in the test so far: a full save (the Wi-Fi Plaza attendant's) stalls in the card library's copies, which now count
  as saving; the Fight Area's arrival scene expects the player off the ferry, so it's marked seen (from the test's way
  in, Barry is unloaded mid-walk); border copies of the next map's objects are left out. The Battle Factory's rental
  pick, the Battle Tower's Easy Chat and a whole contest outlast the test's inputs, as before.
- **Tested:** `tools/complete/test_hgss_loan.py` (new), all four parts pass: Kenya lent (a Spearow holding Grass Mail),
  the letter found, Kenya delivered (gone from the party, TM44 given, the quest's var 3) and Shuckie lent (a Shuckle
  holding Berry Juice). `tools/complete/test_hgss_magikarp.py` (new), all three pass: the new game's record, a Magikarp
  beating a record of 0, and the same Magikarp again leaving it. `tools/complete/test_follower_talk.py`'s new Sinnoh
  part passes. `tools/complete/test_hgss_map_changes.py` (new), all four pass: the antenna tree blocks the way, then
  doesn't once the hideout is cleared; the lake's water stops a step on a Tuesday and is ground on a Wednesday.

## Oct 30, 2026: mass outbreaks

- **HeartGold's mass outbreaks** (`docs/Features.md`, "Mass outbreaks"): from Oak's National Pokédex on, each day one
  of HeartGold's 20 outbreak maps, which Sacred Gold keeps, has its outbreak species in the first two grass slots or
  the first surfing slot, as in HeartGold (16 maps; Sacred Gold's files have no fishing outbreaks, so its 4 fishing
  days have none). The day's pick is Platinum's daily swarm value. Before, Oak's `EnableMassOutbreaks` was left
  untranslated and no outbreak ever came. 928 of Sacred Gold's script lines left. Nothing tells the player where
  today's outbreak is until the Pokégear radio comes (HeartGold's Pokémon Talk).
- **Tested:** `tools/complete/test_hgss_outbreaks.py` (new), all four parts pass: on Route 35, Illumise is 1 of 48
  encounters before the National Pokédex and on another map's day (it's one of the route's own), and 22 of 48 on its
  day; Feebas is 22 of 48 surfing on Route 27 on its day.

## Oct 30, 2026: ladders, Viridian Gym's stop tiles, Ice Path's boulder holes and the Lake of Rage's sky

- **HeartGold's ladders didn't work.** Its three ladder tiles came over with numbers of their own but no behaviour, and
  Platinum only warps from its own warp tiles, so none of Johto's and Kanto's 250 ladders (on 74 maps: Sprout Tower,
  Slowpoke Well, the Burned Tower, the Lighthouse, Ice Path, Mt. Mortar, Victory Road...) took the player anywhere.
  Now a ladder up or down takes its warp when the player presses that way on it, and a ladder down when they step onto
  it, as in HeartGold, with Platinum's stairs sound and fade (`src/overlay005/field_control.c`). The player arrives
  facing north: Platinum's arrivals step a player facing south one tile on, as out of a door, which the test caught.
- **Viridian Gym's stop tiles** were plain floor, and Platinum's slides go on until a wall: stepping onto an arrow in
  the gym's first row would have slid the player back and forth for good. HeartGold's stop tile now ends a slide on
  it (`src/overlay005/ov5_021E1154.c`).
- **Ice Path B1F's boulder holes**, HeartGold's code rather than a tile: a boulder pushed onto its hole falls through
  and shows on B2F (`CompleteMapInfo_BoulderFell`). Before, the boulders just sat on the holes. Strength can't be used
  on B2F, as in HeartGold, so the fallen boulders can't be pushed off the ice puzzle (`src/field_move_tasks.c`).
- **The Lake of Rage's sky** clears on the days its water is low (HeartGold's map load does this too); it rained over
  the low lake before (not tested in the emulator). Not ported: the diamond dust HeartGold shows on Mt. Silver's summit
  on eight days of the year, as Platinum has no such weather (its number is a clear sky there).
- The test build's watch (`gSovereignTestWatch`) reads flags too.
- **Tested:** `tools/complete/test_hgss_tile_behaviors.py` (new): the first 62 of the 250 ladders taken all arrive where
  their warp leads (the rest of the run goes on); the Viridian Gym slide stops on the stop tile; Ice Path's third
  boulder, pushed along a 25-move plan into its hole, falls through (its flag set, its copy on B2F shown).
- Also checked: HeartGold's other warps on tiles Platinum doesn't warp from (Pal Park's exit, the Battle Frontier's
  doors, Mt. Moon Square's) are taken by scripts, in HeartGold too; the gifts' commands pass HeartGold's held items by
  number, which Sovereign's item list keeps, and no gift has a form.
