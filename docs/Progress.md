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
