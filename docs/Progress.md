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
- **Tested:** `tools/complete/test_hgss_tile_behaviors.py` (new), all 252 cases pass: each of the 250 ladders takes the
  player where its warp leads; the Viridian Gym slide stops on the stop tile; Ice Path's third boulder, pushed along a
  25-move plan into its hole, falls through (its flag set, its copy on B2F shown).
- Also checked: HeartGold's other warps on tiles Platinum doesn't warp from (Pal Park's exit, the Battle Frontier's
  doors, Mt. Moon Square's) are taken by scripts, in HeartGold too; the gifts' commands pass HeartGold's held items by
  number, which Sovereign's item list keeps, and no gift has a form.

## Oct 30, 2026: songs a flag puts on a map

- **HeartGold's flag songs** (its `sMusicOverrideMap`; `docs/Music.md`): the Bug-Catching Contest's theme plays in
  the National Park (its own version, now imported: 128 of HeartGold's songs) and the two contest gatehouses while
  the contest runs, and the occupation theme on every floor of the Radio Tower while Team Rocket holds it. Before,
  the maps' usual songs played. HeartGold's entries for Cerulean Gym, Route 24 and Pal Park wait on flags no script
  sets, in HeartGold too, and are left out.
- **Tested:** `tools/complete/test_sound_heap.py`'s new flags part passes: with the flag set, the National Park, a
  contest gatehouse and the Radio Tower's 2F each load their song, and no load fails. The whole test passes (4 of 4):
  every song loads, the tightest of Sinnoh's (the title screen's) leaving 7 KB, and a battle still 3 KB.

## Oct 30, 2026: Johto's and Kanto's gifts tested

- **New test `tools/complete/test_hgss_gifts.py`**, as `tools/test/gift_pokemon.py` does for Sovereign's own gifts:
  each giver is talked to with the story flags its script asks for set on the way in (found by a breadth-first
  search over the script's instructions to its gift command), and the party is checked for the gift's species,
  level, held item and Egg. All nine pass: Route 30's Eevee, the Karate King's Tyrogue (Fist Plate), the Dragon's Den
  elder's Dragonair (Draco Plate), Bill's Castform (Mystic Water), the Riolu, Togepi and Manaphy Eggs, the two Phione
  Eggs in Pewter City, and Silph Co.'s two Johto starters the player didn't pick. Not covered: the Kanto, Hoenn and
  Sinnoh starters' other choices (their givers go by the lead's species), the Game Corners' prizes, and Primo's
  distribution eggs; Elm's starter and the loan Pokémon have tests of their own.
- Sacred Gold's Pewter City woman gives her two Phione Eggs every time she's talked to (her script sets no flag), as
  in Sacred Gold.
- **Sovereign's own gift test** (`tools/test/gift_pokemon.py`) on this build: all 45 of Sovereign's gifts pass, as
  before Johto and Kanto came in.
- **The gift test covers trades and quizzes too:** eight of Sacred Gold's in-game trades (the Pokémon asked for added
  to the party; yes, and it's picked on the party screen; the trade scene plays) each give the trader's Pokémon at the
  given one's level with its held item: Perry's Porygon2, Bexxi's Espeon, Razor's Gligar, Robotnik's Beldum, Mimi's
  Chansey, Squillaci's Torkoal, Moxxi's Skarmory and Lola's Smoochum. The Pokémon Centers' quizzes, passed, give
  their starters (Violet's Bulbasaur, Azalea's Treecko, Goldenrod's Turtwig). Not covered: Lt. Surge's trade (he waits
  at the Magnet Train station only on a rematch day arranged by phone), and Brock's, Jasmine's and Steven's, which
  come with battles and story steps.
- **And the other regions' starters,** which go by the lead's species (the test build makes it Bulbasaur, Treecko or
  Turtwig: `gCompleteTestLeadSpecies`): Route 12's fisherman gives Charmander and Squirtle, the Hoenn gentleman Torchic
  and Mudkip, and Cynthia in Goldenrod's Bike Shop Chimchar and Piplup (once Mom's later scene has cleared Sacred
  Gold's flag for it). All pass.

## Oct 30, 2026: what HeartGold's code set, and Sovereign's own tests

- **A check for dead ends:** every HeartGold flag a script or an object reads, and every var a script compares, against
  everything that sets it (scripts, `RemoveObject`'s hide flags, item balls, C code). Of 307 flags read and never set,
  most are item balls (set as they're picked up) and people HeartGold never shows either. What HeartGold set from its
  own code, and Complete didn't:
  - **Elm's Togepi.** HeartGold sets a flag as his Togepi Egg hatches, and only then does Elm, shown the Togepi, give
    the Everstone; it also has him call. Both happen now (`CompletePhone_EggHatched`, from Platinum's hatch). The
    Egg is told by where it came from (Mr. Pokémon), as Complete's gift doesn't save its personality as HeartGold's
    does. New test `tools/complete/test_hgss_togepi.py`: the aide's Egg hatches by Platinum's hatch scene (the test
    build readies it: `gCompleteTestHatchEggs`), the flag and Elm's call are set, and Elm gives the Everstone and
    calls his call off. It passes.
  - **The phone's other call triggers** (`docs/Features.md`, "The Pokégear phone"): Bill's when the boxes are full and
    Oak's at each 50 caught he hasn't rated, after wild battles; the Day-Care Man's when an Egg turns up (called off
    when he offers it); Elm's when a nurse finds Pokérus. Only Mom's was set before. Left out: the Bike Shop's, which
    needs a count of steps on the bike.
  - **The roamers' status.** HeartGold marks a roamer knocked out (2) or caught (1), and its Hall of Fame sets a
    knocked-out one roaming again. Nothing set it, so a knocked-out Raikou, Entei, Latias or Latios was gone for good;
    it's set as Sovereign's roamers' states are now. `tools/complete/test_hgss_roamers.py` battles each once now: all
    four were knocked out (each is slower than the test party's lead) and marked 2. It no longer counts Route 16 as a
    problem: HeartGold's Route 16 has no wild Pokémon, so a roamer there is never met, in HeartGold too.
  - The rest wait on the owner (the Battle Frontier's progress, the radio's Buena, the Pokéathlon's) or HeartGold
    never sets them either.
- **Sovereign's own tests on Complete's build,** to show Johto and Kanto broke nothing of Sinnoh's: the battle
  mechanics suite (`tools/test/battle_mechanics.py`) matches all 526 of Sovereign's recorded cases; the rare wild
  Pokémon (`rare_wild.py`) pass 52 of 52; the roamers (`roamers.py`) pass, with the eight roamers Sovereign's scripts
  release, flights and walks, a battle with each, a catch and the Pokétch's marking map; the gifts pass 45 of 45
  (above); and the wild Pokémon's forms (`wild_forms.py`, every Sinnoh map with wild Pokémon, each terrain): 19,104
  Pokémon made, 634 species and forms, no problems. Two of Sovereign's tools read Complete's data wrongly, and now
  leave HeartGold's to the tests made for it:
  `roamers.py` counted names past the end of `enum RoamerRouteIndex` as routes, and `wild_forms.py` read HeartGold's
  encounter tables in Sovereign's format.
- **Sovereign's signs and triggers on Sinnoh's maps** (`signs_and_triggers.py`: the 893 signs, hidden items and
  triggers Sovereign added or changed): 847 run to their end, and none of the rest is Complete's doing. Something
  stands on the tile (Rotom's room's appliances; Barry on a Pastoria City trigger, as the story hides him first); the
  test can't reach the tile (Amity Square's walkway triggers, Pastoria Gym's walkway, where the test puts the player in
  the water beside it, and other NOTILEs); the Galactic HQ's people stand on sign tiles; Platinum's elevators can't be
  ridden by the test; a trainer or a scene starts first. The Old Chateau's hidden item passed when run again, and
  Spear Pillar's scene (Mars and Jupiter, Barry, Cyrus) ends on its own after 36,060 frames, past the test's 20,000.

## Oct 30, 2026: a bigger bag, and screens the scripts skipped

- **The bag's Key Items and Poké Balls pockets grow** (`include/bag.h`): Key Items from Platinum's 50 slots to 100,
  as the three regions have 92 key items, and Poké Balls from 15 to 30, for 25 kinds of Ball. A full pocket would
  have dropped the next key item a script gave, story items too. The bag grows by 260 bytes, inside the normal save
  block's last sector (1,440 bytes were free), so the save keeps its sectors; saves from before this change don't load
  right. `tools/complete/test_save.py` now also puts one of every key item and every Ball in the bag: all must fit and
  still be there after a save and CONTINUE.
- **HeartGold's screens before `ReturnToField`:** a script that opened one of HeartGold's screens and then brought the
  field back did nothing in between, as the screen's command wasn't translated. Now: Primo in Violet City's Pokémon
  Center takes his password on Platinum's Easy Chat screen (`ChooseTwoCustomMessageWords`, HeartGold's
  `PromptEasyChat`; checking the password waits with the other distribution events); the PC in the player's room
  counts the mail in the PC's mailbox and opens Platinum's mailbox menu; and the Johto Pokédex's and the Shiny Leaf
  crown's certificates, which have no screen here yet, close the field as a screen would. Checked in the emulator:
  with a mail in the mailbox the room's PC plays out and the room comes back (twice); Primo's Easy Chat screen opens,
  and quitting it (B, then Yes: its cursor starts on No, which the talk test keeps pressing A on, so it reports him
  STUCK) brings him back to answer and the field back. A subset of scripts can be installed again
  (`tools/complete/translate_hgss_scripts.py --install ... STEM`) without the others dropping out of the build's
  lists.
- The bigger bag in battle: Sovereign's bag-using battle cases (Ball Fetch, items, Pickup, Knock Off, Thief, Air
  Balloon) all match their recorded results.

## Oct 31, 2026: Fly over Johto and Kanto

- **Visited towns are recorded.** HeartGold records a town's Fly point as the player first arrives (its
  FlypointFlagAction, from its spawn points); nothing did here, so Johto and Kanto had no places to Fly to even once
  there is a map for them. HeartGold's 25 Fly points now unlock on arrival as Platinum's do
  (`TryUnlockFlyLocationByMap`), in HeartGold's flags (`FLAG_HGSS_SYS_FLYPOINT_*`; each spawn point's firstArrival is
  its Fly point number, from `tools/complete/import_hgss_spawns.py`).
- **Fly over Johto and Kanto** works until the three-region Town Map (art not decided yet): on a Johto or Kanto map,
  Fly from the party menu shows a list of the places reached, by name, and flies to the one chosen
  (`CommonScript_CompleteFly`, `CompleteInitFlyMenu`, `CompleteFlyTo`). Sinnoh keeps Platinum's Town Map.
- **Tested:** new `tools/complete/test_hgss_fly.py` passes: arriving in New Bark Town, Cherrygrove City and Violet
  City records each (Azalea Town, not visited, isn't); in Violet City the list offers New Bark Town and Cherrygrove
  City, B closes it, and A flies to New Bark Town. By hand: Fly from Starly's menu in the party screen (with the
  badges) brings up the list and lands in New Bark Town.

## Oct 31, 2026: a new game starts in New Bark Town

- **The story starts in Johto (decided Oct 29).** A new game still plays Platinum's introduction (Rowan names the
  player and the rival), then starts in the player's room in New Bark Town, HeartGold's start, instead of Twinleaf
  Town (`InitPlayerStartLocation`, `src/location.c`). Blacking out before a Pokémon Center sends the player home to Mom
  in New Bark Town (`FieldOverworldState_Init`'s first black-out point). Twinleaf Town's opening scenes and Sinnoh's
  League, which sends the player home to Twinleaf Town, stay as they were: what becomes of Platinum's opening is open
  (`docs/Roadmap.md`, "Still open").
- **Tested** on a new test build's bedroom state (`tools/test/new_game.sh` now ends in New Bark Town's room): the
  follower test, the save test (with the full bag), the Fly test and the gifts that need a start (Eevee, Elm's Togepi
  Egg, the Kanto starters) all pass.
- **The Ruins of Alph's underground hall** made no wild Pokémon in `tools/complete/test_hgss_encounters.py`: its Unown
  come out only once a puzzle is solved, as in HeartGold. The test now solves the four puzzles before it goes there:
  144 Unown, no problems.
- **Sovereign's tests again, on the latest build:** every evolution into or from a form
  (`tools/test/battle_evolutions.py`): 255 of 255. Elite Four runs (`tools/test/elite_four_runs.py`, Sovereign's ten):
  nine end with the Champion beaten; run 0 stopped in Flint's battle when the test chose a fainted Pokémon as the
  target (the test's doing, as before).

## Oct 31, 2026: the ferry network

- **Ships between the three main ports** (decided Oct 28–29; `docs/Features.md`, "The ferries"). Once the way to
  Sinnoh is open, the sailor at Olivine's or Vermilion's gangway asks where to: the S.S. Aqua's port, as before, or
  Canalave City, by Platinum's boat scene. Canalave's sailor offers Olivine City and Vermilion City after his islands;
  the ship lands the player at the S.S. Aqua's door in that port, where its arrival scene plays. The way opens with
  the Earth Badge, Kanto's eighth, as the Roadmap proposes, in one place (`CommonScript_CompleteFerryCheckSinnoh`) so
  it's easy to move; before it, nothing changes. Until now a game that starts in New Bark Town had no way to Sinnoh.
- **Complete's lines in Sacred Gold's scripts:** the gangways' question is put into the translated scripts by the
  translator (`INSERTS` in `tools/complete/translate_hgss_scripts.py`), so translating them again keeps it.
- **Tested:** `tools/complete/test_hgss_ferry.py` passes its 11 parts: the S.S. Aqua's four as before, and with the
  Earth Badge, Olivine and Vermilion to Canalave City, Canalave City to each (the arrival scene plays), the S.S. Aqua
  and staying in port from the gangway's menu; without it, Olivine's gangway asks nothing and boards the S.S. Aqua.

## Oct 31, 2026: the opening as a player plays it, and fixes the tests found

- **New test `tools/complete/test_hgss_opening.py`:** the opening played as a player plays it, from a new game's own
  start and without the test warp, walking from place to place by a path it finds over the maps (ledges one way,
  around people) and paging through every scene with A: down the stairs (Mom's scene), out of the front door, into
  Elm's lab (his greeting and the errand to Mr. Pokémon), the table of Poké Balls (the starter, a nickname turned
  down, Elm's lines), out past the aide's Potions, home to Mom for the Pokégear (Sacred Gold's Mom gives it once the
  player has a Pokémon; without it, the woman at the west exit sends the player back), west out of town (Elm runs out
  to give his number), along Route 29 to Cherrygrove City (the guide gent's tour), and up Route 30 to Mr. Pokémon's
  door, where Sacred Gold's Eevee gift stands, and inside (Mr. Pokémon's Egg, Oak's Pokédex), back south to
  Cherrygrove City's east entrance (the rival's battle) and east to Elm's lab (Elm and the police officer). Each part
  checks the flag or var its scene sets, and that the follower is beside the player (at most two steps off, as a
  scene can leave it diagonally). All ten parts pass, each from the save state the one before left.
- **The follower left behind:** after the starter, the following Pokémon came out beside the player at the table,
  then the scene walked the player back to Elm, and it trailed five tiles behind from then on, as it steps to the
  player's last tile each step. Now, with both standing still and the follower more than two tiles away (a ledge
  leaves two), it comes back on the player's tile to step out behind them, as after a warp
  (`src/complete_follower.c`). The opening test checks that the follower is within a tile of the player at the end
  of each part.
- **Hidden items** (`tools/complete/test_hgss_hidden_items.py`, on the latest build): 234 of 243 found once and only
  once, 7 lying under a person or an item ball as in HeartGold, and 2 the test can't reach, as before. Two lie on
  Headbutt trees, so once the item is taken a second A asks to Headbutt the tree, as in HeartGold; the test counts
  that as found once now.
- **The wild tables, all of them** (`tools/complete/test_hgss_encounters.py`, every Johto and Kanto map with wild
  Pokémon, each time of day, surfing and the rods): 29,088 Pokémon made, all from Sacred Gold's tables. What the run
  called problems were the test's own: the Ruins of Alph's hall and its three Sinjoh Ruins event versions let Unown
  out only once a puzzle is solved (the test now solves them first: 576 Unown, no problems), and the Safari Zone's map
  table is HeartGold's stand-in, as its Pokémon come from the arranged areas' tables, which
  `tools/complete/test_hgss_safari.py` checks (the test leaves it out now).
- **Johto's and Kanto's 737 trainers** (`tools/test/battle_all_trainers.py`, on the latest build): every battle
  starts, runs to its end and comes back to the field.
- **The talk test over every person and thing in all three regions** (`tools/test/talk_to_objects.py`, 4,859 on the
  test build of Oct 30): 4,086 ran to their end and none hung where the test could go. 632 started nothing (people who
  walk off or are hidden at this point of a new game), 44 had no tile to stand on, 19 are stand-ins (`docs/Features.md`,
  "Stand-ins"). The rest are Platinum's own: the Underground's and the Union Room's people (link-play maps the test's
  warp can't enter), the Ribbon Syndicate's and the Champion's rooms (they need the story's way in), Route 214's TV
  reporter (Easy Chat, which the test can't answer), and two answered by someone else on their tile.
- **Sovereign's battle script check** (`tools/test/check_battle_scripts.py`) found the Bug-Catching Contest's Sport
  Ball throw (`subscript_complete_throw_sport_ball`) in the subscripts' order but not in
  `generated/battle_subscripts.txt`, which keeps the two in step; it's there now, and every battle script fits (the
  largest, 1,944 of 2,048 bytes). Every battle sprite (`check_battle_sprites.py`): 5,344, no problems.

## Oct 31, 2026: Viridian Gym's arrows light up, Fuchsia Gym's walls flash

- **Viridian Gym** (HeartGold's `viridian.c`): its arrow tiles, Platinum's slide tiles here, light up under the
  player as they step onto one, HeartGold's model for that arrow's direction playing its texture animation on the
  tile, up to three at once as the player slides on (`src/complete_gyms.c`, `CompleteViridianGymInit`, HeartGold's
  `ViridianGymInit`, which the gym's script runs as it loads). The models and animations are HeartGold's `a/2/5/5`,
  brought in by new `tools/complete/import_hgss_gym_effects.py`.
- **Fuchsia Gym** (HeartGold's `fuchsia.c`): its walls are invisible, and now flash where the player bumps into one,
  HeartGold's model for that piece of wall playing its animations there, as HeartGold shows the way through
  (`CompleteFuchsiaGymInit`; the bump comes from Platinum's walking code, `src/player_move.c`). HeartGold's `a/2/4/6`
  and its table of the gym's 60 wall tiles come in through the same tool. With it, every gym's touches are in
  (`docs/ScriptConversion.md`, "Gym puzzles").
- **Tested:** new `tools/complete/test_hgss_viridian_gym.py` passes: in at the door, a step up onto the first arrow
  lights it, and the player slides back off it with the field free. New `tools/complete/test_hgss_fuchsia_gym.py`
  passes: a bump into the first row of walls starts a flash, a second bump while it flashes starts none, and the
  player stays put with the field free.

## Oct 31, 2026: the opening on to Violet City, Falkner and Azalea Town

- **`tools/complete/test_hgss_opening.py` goes on** past Elm: Lyra's catching lesson on Route 29, Routes 30 and 31
  through the gatehouse into Violet City, Sprout Tower by its ladders (up, back down, up again) to Elder Li (his
  battle, Sacred Gold's choice of an evolution item, his TM), Violet Gym's lift and Falkner's battle (the Zephyr
  Badge), Elm's call and his aide's Egg in Violet City's Poké Mart (without it, the man on Route 32 sends the player
  back), Route 32, Union Cave and Route 33 to Azalea Town, and Kurt and the Slowpoke Well (the Team Rocket grunts and
  Proton, then Kurt at home). From the bedroom in one run, all fourteen parts through Falkner pass; the three after
  pass from the state the one before left.
- **What the walk taught the test** (no game bugs this stretch): the battles on the way, trainers' and wild Pokémon's,
  are in the test build's god mode, and the test taps the damaging moves (Garchomp's first move, Precipice Blades,
  doesn't touch a flying Hoppip); a naming screen (the police officer asks the rival's name) is answered with START
  and A; a key press that only turned the player is made again; people standing in narrow ways are walked through
  when they are hidden; ladders up take a press toward them and ladders down the step itself; the overworld routes
  avoid water; Violet Gym's lift is ridden by stepping onto its trigger tile; a cave's exit, like a door mat, takes a
  press toward it; and the aide wants room in the party, so the test party is cut to its lead first (the test build's
  party hook, which applies on its warp, here onto the player's own tile), as a player would leave some in the PC.

## Oct 31, 2026: the story test on through four more gyms to Olivine and Cianwood

- **The whole opening in one run:** `tools/complete/test_hgss_opening.py` played all seventeen parts from the
  bedroom state in a single run, New Bark Town to Kurt's house after the Slowpoke Well (before, the last three had
  passed from the state the one before left).
- **Bugsy:** a new part goes into Azalea Gym and through its Spinarak carts (`src/complete_gyms.c`) to Bugsy: his
  battle, the Hive Badge and TM89. Five rides and both switches; the walks in the gym never step onto a cart's
  trigger but the one they mean to, as the triggers are always armed and a walk over one would ride off.
- **Ilex Forest:** the next part rides the carts back out, crosses Azalea Town (the rival's battle) and plays the
  forest's Farfetch'd chase. Sacred Gold has two lost Farfetch'd, and what each does when talked to or when the
  player steps on a twig is a small state machine in the forest's script: where it stands, the side the player talks
  from, and vars the twigs set. With both caught the charcoal maker gives HM01, so the chase can be finished as
  converted.
- **New `tools/complete/solve_story_puzzles.py`** finds both ways from the game's own data, as the test plays them: a
  search over the gym's stops, routes and switches, and a small interpreter for the commands the forest's script
  uses, run over its states. If a map or a script changes, it finds the test's steps again.
- **Goldenrod City:** Cut (the HM in the bag, with the Hive Badge) clears the tree north; in the gatehouse Sacred
  Gold's Odd Keystone giver stands in the north doorway and leaves once talked to (their script removes them, so it
  isn't a dead end); on Route 34 the friend's grandparents' scene in front of the Day-Care takes the player inside;
  and Goldenrod City's Fly point is recorded. pokeheartgold names a few Fly point flags after the wrong town
  (`tools/complete/import_hgss_spawns.py`; Goldenrod's is the one named for Ecruteak), so the test now checks a
  town's Fly point by its row in the spawn table, not by a flag's name.
- **Whitney:** the Radio Card quiz in the Radio Tower first (Goldenrod Gym stays shut until then, as in HeartGold),
  then the gym, Whitney's battle, the lass who takes the player back to her crying, and the Plain Badge with her TM.
- **On to Olivine and Cianwood:** the SquirtBottle from Goldenrod's Flower Shop and Sudowoodo on Route 36 (reached
  from the south), Route 37 to Ecruteak City, the Burned Tower (Eusine, the rival's battle, the drop to the basement
  and the legendary beasts), Morty along his gym's dark path between the pits, Surf from the Dance Theater's gentleman
  after the grunt on its stage, Routes 38 and 39 to Olivine City (the Route 38 gatehouse turns tourists back until
  Morty is beaten: Sacred Gold's), the Glitter Lighthouse up to Jasmine (4F's opening drops the player onto the
  balcony, HeartGold's step-on trigger, the way on to 3F's other side), the elevator down and Surf across Routes 40
  and 41 to Cianwood City, Chuck (the winch at the top of his gym stops the waterfall he trains under, as in
  HeartGold, before he notices the player), the SecretPotion from the pharmacist, and Surf back to the lighthouse,
  whose elevator from 1F takes the player up to give it to Jasmine. Each of these parts passes from the state the
  one before left: the test has 32 parts now. A full run from the bedroom with this stretch's walker passed the first
  nineteen; one with the final walker is under way.
- **Next, before Jasmine:** Sacred Gold puts a man on Olivine Gym's door mat once the medicine is given (his hide flag
  is FLAG_HGSS_SG_3FE8) until Team Rocket is beaten at the Safari Zone Gate, west of Cianwood: a scene in the gate's
  Pokémon Center brings them out, and a tag battle at the gate (VAR_HGSS_SG_6130 2) sends him away. Not a dead end,
  but a long leg the test doesn't play yet.
- **What the walk taught the test** (no game bugs this stretch): a gym leader's battle and lines take longer than a
  talk's old 9,000-frame limit (Bugsy's ended mid-sentence), so a talk gets a scene's budget; Azalea Gym's door leads
  into an entrance hall; a trigger that a scene moves the player off and leaves armed (Goldenrod Gym's lass) is
  stepped onto with one key, not walked to, and so is one whose scene ends somewhere else (the Day-Care's); only
  Azalea Gym's carts, Ilex Forest's twigs and Ecruteak Gym's pits are walked around, by their trigger's var, as the
  forest's apprentice stands where the player must step on his trigger; a walk never crosses a warp tile it isn't
  going to (doors, stairs, ladders); Goldenrod Gym stays shut until the player has taken the Radio Card quiz in the
  Radio Tower, where Whitney is, as in HeartGold; and the walks now know the maps' heights. Goldenrod Gym has
  walkways over its floor (HeartGold's bridge tiles), and from a walkway the corridor to Whitney is a drop the game
  doesn't allow; the walker now reads each map's BDHC as the game does (the plate nearest the player's height, no
  step of 20 or more) and the player's height from the game, and learns a step that fails rather than a tile, waits a
  little longer for a step that starts late (the follower getting out of the way) and forgets the failed steps when
  they leave no way (a trainer who walked over to battle may have stood in it). It surfs too: at the shore it faces
  the water and uses Surf, and its routes stay off whirlpools and waterfalls.

## Oct 31, 2026: a double free after Route 47's tag battles, and the walker rides Violet Gym's lift

- **The story test now checks the game's heaps** at the end of each part (`tools/test/heap_check.py`, as the battle
  tests do; `HEAP_STEPS=1` checks after each action), and the next leg, the Safari Zone Gate, found a real bug at
  once. After the tag battle on Route 47's bridge (Sacred Gold's; three such battles on the route heal the player
  after), the script shows a line, fades to black, heals, leaves the field and comes back (HeartGold's `ScrCmd_436`
  and `RestoreOverworld`, Platinum's `WaitForTransition` and `ReturnToField`), and only then closes the message box.
  Leaving the field frees the field's heap, the box's window with it, and the close frees the window a second time
  into the field's new heap: the free lists dumped frame by frame show the field heap rebuilt, then `CloseMessage`
  freeing a block already freed. HeartGold has the same slip (its `CloseMsg` and `RemoveWindow` do the same, and its
  field heap goes the same way); it may never show there, but a broken heap here crashes sooner or later. The
  translator now closes a box still open where a script leaves the field, while the screen is black
  (`close_before_leaving` in `tools/complete/translate_hgss_scripts.py`). A battle leaves the field as well, and a
  scan of every translated script finds three more with the box open: Arceus's on the Sinjoh Ruins' Mystri Stage, and
  Sacred Gold's Latios and Latias, whose scripts close the box after the battle, Latios's and Latias's through a jump
  to a shared ending. So the closes after, on every way through the jumps, are now `CompleteCloseMessageIfOpen`, a
  new command that closes the box only if it's still open (`src/complete_scrcmd.c`); the box is opened only by the
  message commands, which keep its flag. Sacred Gold's closing lines on the Mystri Stage (after Arceus, its two
  endings) stay open into Johto's game clear too, but that ends by resetting the system, so the window is never freed
  again. On a build with the fix, the test's walker, from the Cliff Edge Gate, crosses the bridge into the tag battle
  and the heal, and the heaps are whole after every step, where before they broke at that step.
- **Violet Gym's lift:** the full run from the bedroom with last stretch's height-aware walker stopped at Falkner, as
  the lift (`src/complete_gyms.c`) carries the player to height 496 over a floor whose BDHC says 32, and every step
  off it looked like a drop. The walker now reads the field's dynamic plates from the game (the lift's), through the
  player's map object to the field system, as one more height at their tiles, and walks off the lift to Falkner.
- **The next two parts**, 33 and 34 (written, not yet passed): the Safari Zone Gate (Cliff Edge Gate and Route 47's
  boulder, which won't budge until the grunts on the bridge are beaten in a tag battle; Cliff Cave and Route 48; the
  gate's Pokémon Center, whose nurse is a grunt; the tag battle beside Riley at the gate) and Jasmine. A full run on a
  build with the fix is under way. Ahead of Mahogany Gym and the Ice Path, the walker also slides on ice as the game
  does (`src/player_move.c`): a step onto ice goes on until the player is off it or something is in the way.

## Oct 31, 2026: Mahogany Gym's ice blocks

- **A gym that couldn't be crossed:** trying the walker on Mahogany Gym ahead of the story test, it found no way
  across the second room. Its ice is stopped only by two ice blocks, which in HeartGold the player pushes: run into
  one on the ice and it slides on until a wall or the end of the ice stops it, or someone, who it joins (another
  block above all), both turning to face up so they can't be pushed again. HeartGold does this from its ice movement
  (`unk_0206D494.c`), not as a gymmick, and Complete hadn't ported it, so Pryce couldn't be reached.
- **Ported** (`CompleteIceBlock_TryPush` in `src/complete_gyms.c`, hooked where Platinum's ice stops the player and
  where the player bumps into something, `src/player_move.c`): HeartGold's rule as it is, a block that faces down,
  the same steps (facing locked while it slides, a join turns both to face up) and a field task the field waits for.
  Seafoam Islands B3F has them too; Sinnoh's one ice rock (Route 217) faces up and stays put. Platinum's ice slide
  sound plays as a block slides; its sounds stand in for HeartGold's hit and join (step 6).
- **Tests:** `tools/complete/test_hgss_mahogany_gym.py` pushes the second room's first block into the second (one
  push, both joined and facing up, the player stopped where the game stops them), slides against the joined blocks
  without pushing them, and reaches the way on to Pryce: all pass. `tools/complete/solve_story_puzzles.py` now finds
  the way across each of the gym's three rooms (a search over the player's tile and the blocks), and the story
  test's walker, warped into the gym, followed it through all three rooms, four pushes and Pryce's battle to his TM,
  the heaps whole after every step.
- **The walker sees people where they are now**, read from the game's map objects (as trainers walk over to battle
  and blocks move), where it used the map's starting places; it slides over ice, and never takes a slide that would
  push a block (one the game says still faces down), so only the steps meant to push do. A full run from the bedroom
  with these is under way.

## Oct 31, 2026: the Mahogany leg ahead of the story test, and a follower that stopped following

- **Played ahead with probes** (the story test's walker, warped in from a bedroom save with the badges and HM03 the
  test build can give): the Lake of Rage's red Gyarados, which wanders, so the test has a new action, `meet`, that
  goes to beside whoever started on a tile wherever they are now, by land or water (Surf to it, its battle, the Red
  Scale); Lance there (yes, and he flies off to Mahogany); back over Route 43 to the souvenir shop, whose scene
  unmasks it and opens the stairs (east-facing stairs, so the press is right); the Rocket Hideout's B1F (the statues'
  alarms and the trap floor play out on the way), B2F, and B3F: the two password grunts, then the door and Petrel.
  HeartGold's hideout needs a floor change between beating the grunts and the rival's trigger, as its "on transition"
  scripts run only on a warp (here as in HeartGold), and its left side is reached through B2F's top corridor. Then
  Petrel's Murkrow leads the player between the floors, one trigger a step.
- **A real bug there: the follower stopped following.** After the Murkrow's scene on B2F, beside the stairs the
  player had just come up, the follower stayed on the stairs for good, however far the player walked. Platinum's
  follow step copies the player's current movement for the follower's step; a player who isn't walking (just warped
  in) has none, so the follower got a step that never ends and stayed "moving", which also kept Complete's
  left-behind check (it waits for both to stand still) from bringing it back. The follow code now walks when the
  player has no movement (`src/unk_02069BE0.c`, a two-line `Sovereign Complete:` change). A probe from the stairs with
  the hideout's progress set (the test build's var hook): before, the follower stays on (51, 29) while the player
  walks to (45, 29); after, it's on (46, 29), beside them. The main build boots (boot smoke PASS).
- **What's not ported, seen on the way, all looks:** HeartGold's trap floor and Persian statue effects in the hideout
  (`ScrCmd_708`, `709`), Lance's flight off the lake (`ScrCmd_775`), and the Rocket disguise's sprite (the disguise
  only restricts field moves and items in HeartGold; the scripts never check it). None changes the way through.
- **Parts 35 to 43 in the story test** (Mahogany Town to Pryce): 35 passes from Olivine Gym (a probe save with Jasmine's
  TM flag, as Sacred Gold blocks the Route 42 gatehouse until she gives it); 36 to 42, the red Gyarados to the
  Electrode, pass back to back from its end; 43, Pryce, passes from the hideout's end. Run back to back from that same
  probe save, Pryce skipped his battle: the probe had given all of Johto's badges (for Surf), and his script checks
  for the Glacier Badge first, as HeartGold's does, so that's the probe's doing. The whole run from the bedroom,
  with these parts, comes next, once the two full runs under way reach Jasmine.

## Oct 31, 2026: the story test from the bedroom to Pryce, 43 parts

- **Two full runs from a new game's bedroom pass every part, 1 to 43:** New Bark Town to Pryce's Glacier Badge and
  TM, the heaps whole and the follower beside the player at the end of each part. One ran on the build with all of
  this stretch's fixes (each run was resumed once from a part's save state, after the test was fixed: the save states
  keep a run going where it was).
- **What the runs taught the test,** none of it the game's doing: a tag battle on Route 47 waited on its target
  screen, as the cursor sat on a fainted foe and the test's taps missed the one left, so the test now also taps each
  foe's box; Sacred Gold puts two more people in the way between Route 47 and the Safari Zone Gate, a grunt in Cliff
  Cave's far doorway and a Rocket between two boulders past it, who each battle when talked to and then go (the test
  talks to them); Cliff Cave's ladders warp to another part of the same map, which the walker now counts as getting
  there; and a red Gyarados that steps away as A goes down is met again.
- **The follower fix and these runs:** the older build, without the fix, also got through the hideout's Murkrow scene
  this time, so the stuck follower depends on timing; the probe that sets the scene up (the hideout's progress set,
  then up the stairs and onto the trigger) shows it every time on that build, and never on the fixed one.

## Oct 31, 2026: the story test through the Radio Tower, 51 parts

- **Parts 44 to 51, the Radio Tower takeover,** pass back to back: from Pryce back to Goldenrod, the disguise in the
  underground, the tower's 1F grunt and the rival, Petrel's Basement Key on 5F, down through the underground's locked
  door to B2F and the rival again, B2F's switches and shutters to the warehouse and the real director's Card Key, out
  through the Department Store's basement and elevator, the Card Key's shutter on the tower's 3F, and by the elevator to
  the observation deck: Archer, then (Sacred Gold's addition) Giovanni, and the director's Rainbow Wing
  (VAR_HGSS_SCENE_ROCKET_TAKEOVER 5).
- **B2F's switches, and what looked like a broken one.** Each of the three switches opens some shutters and shuts
  others, so the test got a `switches` action: it presses them a set at a time (a Gray code) until the shutters, read
  from the game, leave a way through. At first no set worked, and the third switch seemed to do nothing. It works:
  the test pressed A for text while a script ran, and a switch shows none, so a tap landing as its script ended
  pressed it again and undid it. The action now presses once and checks that something moved. Nothing in the game
  needed changing.

## Oct 31, 2026: the story test to the Rising Badge, 56 parts

- **Parts 52 to 56 pass,** each from the end of the one before: back down the Radio Tower and by road to Mahogany
  Town; Route 44 and the Ice Path, with HM07 from 1F's ice and Strength's pushes of B1F's first boulder into its hole
  (it falls to B2F, where it stops a slide); on through B2F, B3F and the Kimono Girl on 1F's ice into Blackthorn
  City; Clair, across her gym's floors over the lava; and the Dragon's Den, its pond, its whirlpool and the shrine,
  where the elder's quiz ends with the Rising Badge.
- **Blackthorn Gym's floors, end to end in the emulator for the first time:** `solve_story_puzzles.py` now models
  them from `src/complete_gyms.c` (the floors' tiles, the moves that go the floor's width or nowhere, the turns the
  game's own tables stop) and finds the way to Clair, 30 button steps. The game moved and turned the floors exactly as
  the model said at every step, and the player rode them to Clair. The gym's pads, which send the player back to its
  door, are its way out, as in HeartGold. It also finds Ice Path B1F's pushes (six).
- **The test learned:** the Radio Tower's 4F is in two halves (the way down from the elevator's side is by 4F's east
  stairs to 3F); the Kimono Girl on the Ice Path asks to be let by (yes); Blackthorn's den is across a pond (Surf);
  Whirlpool is A facing the whirlpool; the elder's quiz asks again after an answer he doesn't take, so A alone (the
  first answer, "Weak" to the third question) looped for good, and the test now answers the scene's menus. New
  actions: `push` (Strength), `scene` (a scene that starts as the player arrives, with its menus answered). Walks keep
  off Ice Path B1F's holes, Blackthorn Gym's lava where no floor is, its buttons and its pads. Nothing in the game
  needed changing in this stretch.

## Oct 31, 2026: the story test past Ho-Oh, toward the League

- **Parts 57 to 62 pass,** each from the end of the one before: back out of the Dragon's Den (Clair's TM on the way)
  and down Routes 45, 46 and 29 to Elm's lab; west to Ecruteak City's Dance Theater; the Kimono Girls' battles for
  the Clear Bell; up the Bell Tower (its ladders, and 7F to 9F's warp panels) to the roof, where the Kimono Girls'
  dance brings Ho-Oh down and it battles when talked to; down the tower again; and back east past New Bark Town,
  where the friend no longer stops the player, onto Route 27 and into Tohjo Falls, up its first waterfall.
- **As in HeartGold, the League waits on Ho-Oh:** after the Rising Badge the friend stops the player at New Bark
  Town's east exit until the Bell Tower's battle (VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT 3), so the test now takes that
  way. The barrier station's sage steps aside when talked to (with the Fog Badge).
- **Victory Road's way,** worked out from its data for the parts still running: 1F's boulder pushed up, then up to
  3F and down one of its holes (3F's step-on scripts drop the player to 2F), 2F's boulder pushed two tiles west, up to
  3F again and down another hole to the top of 2F's ledge, and up to the exit. The other 2F boulder can only be pushed
  into a dead end from the south; checked in the emulator, it is the way back, not the way in. Sacred Gold keeps the
  Elite Four's doors shut and has a Kadabra in each room teleport the player on.
- Nothing in the game needed changing in this stretch.

## Oct 31, 2026: the story test reaches the Hall of Fame, 70 parts

- **Parts 63 to 70 pass,** each from the end of the one before, so every part from the bedroom to the Hall of Fame
  has now passed: Tohjo Falls (up one waterfall with Waterfall, down the other on Surf), Route 27 and Route 26 to the
  League's gate and its badge check, Victory Road (both boulders and both holes as worked out, and the rival at its
  exit), Indigo Plateau, the Elite Four by Sacred Gold's teleports between their rooms, Lance, and the Hall of Fame:
  the game is cleared and saved (FLAG_HGSS_GAME_CLEAR), starts over, and Continue puts the player back in their room in
  New Bark Town, as `ClearGame_Johto` intends.
- **What the test learned on the way:** the man at the League's inner door steps aside when talked to; going down a
  waterfall on Surf needs no prompt. Again nothing in the game needed changing.
- **Next:** one run of all 70 parts back to back from the bedroom (under way), to see the whole story in one go.

## Oct 31, 2026: the story test sails to Kanto, 74 parts

- **Parts 71 to 74 pass,** each from the end of the one before: Elm's S.S. Ticket after the Hall of Fame; back west to
  Olivine City's port; the S.S. Aqua's first trip as HeartGold plays it (the gentleman's missing granddaughter: a
  sailor's word on B1F, Sailor Stanly's battle, the captain's room by B1F's far ladder, the girl found on B1F, and the
  ship arrives); and off at Vermilion's port into Vermilion City.
- **After the Hall of Fame,** the game brings back the Pokémon not caught, so Route 36's Sudowoodo stands in the road
  again and battles once more after the SquirtBottle, as in HeartGold.
- **Ports:** the gangway's sailor takes the player aboard; on arrival, the port building's sailor lets the player
  through when talked to from below. Nothing in the game needed changing.

## Oct 31, 2026: the story test goes through Kanto, 95 parts

- **Kanto's order in Sacred Gold,** worked out from its scripts: Vermilion Gym's leader is away until Misty's TM, so
  the way goes east through Diglett's Cave (its door is on Vermilion's side of Route 11's Snorlax) to Pewter (Brock,
  whose TM sends the scientist at Mt. Moon's door away), Mt. Moon and Cerulean; the Power Plant's stolen part (the
  manager, Cerulean Gym's Rocket, his battle on the Nugget Bridge, the part in the gym), Misty's date on Route 25 and
  her battle; the part back to the Power Plant, which opens the Underground Path; Lt. Surge, whose TM clears Rock
  Tunnel's door; Lavender and Route 12 to Fuchsia, where Sacred Gold's Shellder swarm blocks the gym and the way west
  until three leading Cloyster are beaten for Janine; Janine (her TM opens Saffron Gym), the Cycling Road to Celadon and
  Erika (her badge opens Saffron's gatehouses), Sabrina (her badge sends Route 19's workmen home), Blaine in Seafoam
  Islands, Blue on Cinnabar and in Viridian Gym, and with the Earth Badge, Viridian Forest's gatehouses and the ferry
  from Vermilion to Canalave City.
- **Parts 75 to 95** play it, and all pass, each from the end of the one before (Blaine's from inside his gym's door,
  where a first try had stopped), the last landing the player in Canalave City.
- **What the test learned on the way:** an east, west or south warp (a gatehouse's door) takes the player only from its
  own tile with the key pressed that way, while a north warp takes them on stepping in. The last Power Plant scene ends
  in the plant with the power on (another map). Seafoam Islands' gym is reached by its east door, from Cinnabar's side
  of Route 20 (Route 19's sea reaches only the west door, and the cave's way from there takes several Strength
  boulders), and Sacred Gold's scientists in the gym step aside after their battles (one of them west, into the way,
  unless talked to from his west). A walk to someone (`meet`) now picks the nearest side the player can reach.
- **Seafoam Islands from its west door,** the way a player who sails down Route 19 from Fuchsia takes to Blaine and
  Cinnabar (Route 19's sea reaches neither otherwise), runs through 1F and B1F only, and worked out offline, three
  Strength pushes on B1F open it (the boulder at (11, 13) twice east, the one at (40, 16) once east), and a probe from
  the west door played it in the emulator into the gym. The test goes round by Route 2, which Sabrina's badge opens as
  it opens Route 19.
- **New test actions:** `bike` (Y, with the Bicycle registered: Sacred Gold's Mom gives it at the start, and the
  Cycling Road's gatehouses let only riders through) and `ride` (a key held up the Cycling Road's slope, which rolls a
  still bicycle back down, through its bikers' battles). The walks now slide along Viridian Gym's arrows as the game
  does (`src/overlay005/ov5_021E1154.c`: on in the arrow's way, turned by each arrow, to a stop tile or a wall), so its
  way to Blue is found like any other.
- **The ferries run any day:** Sacred Gold's sailors in Olivine's and Vermilion's port buildings let the player through
  on the S.S. Aqua's days only (Mondays and Fridays, Sundays and Wednesdays), which also kept the ferry to Canalave City
  to those days. The ferry network has no timetable (`docs/Roadmap.md`, "Ferry network"), so they let the player
  through any day now (the translator's `INSERTS`; `docs/Features.md`, "The ferries").
- **The back-to-back run** from the bedroom passed parts 1 to 26, then stopped at 27: on the way west out of Ecruteak,
  Sacred Gold's gentleman with the Iron Plate (a step-on scene at Route 38's gatehouse door) walked the player four
  tiles back, which the earlier runs hadn't met. The part now walks to the door again after it; the run, resumed there,
  is under way.
- **Resumed from part 27,** the run went on to part 72, then stopped in the S.S. Aqua's first battle: Shift style's
  'Will you switch Pokémon?', which the test's A answers yes, opened the party, and a battle tap picked the Pokémon
  already out, again and again. The same part passed run again; the test now sets the save's battle style to Set, so
  the question never comes (the part passes that way too).
- **The whole chain has now passed,** every part from the end of the one before, from the bedroom to the ferry
  landing in Canalave City: parts 1 to 26, 27 to 72, and 73 to 95 with restarts where the test needed fixing (none of
  them in the game). In Cerulean Gym, a trainer who comes down its one-tile side way to battle can stay in it, so the
  walks in and out go round by the pool on Surf; in Vermilion Gym, the cans action picks again from a can's free sides
  when a trainer who came over stays on the one it walked for. A fresh run of all 95 parts from the bedroom, with all
  of the test's fixes, is under way.

## Nov 1, 2026: the owner's new calls, Sovereign synced, and the original wild Pokémon

- **The owner's calls** (`docs/Roadmap.md`, "Decided"): a provisional Sinnoh integration of Claude's own so the whole
  game can be tested; Megas in all three regions; Sovereign's Totem trials and legendary encounters spread over Johto,
  Kanto and Sinnoh; the original games' wild Pokémon with the new species mixed in evenly; then a full test of the game
  and a highlight video.
- **Sovereign synced** to 2134aabe (its four commits since Oct 29: tall battle fronts moved down and shrunk to fit the
  screen), with no clashes; the ROM builds and boots.
- **Wild Pokémon** (`docs/Features.md`, "Wild Pokémon"; every table in `docs/WildPokemon.md`): new
  `tools/complete/gen_wild.py` writes Johto's and Kanto's tables from HeartGold's and SoulSilver's (both versions' species
  in one table) and Sinnoh's from Platinum's, and mixes in 404 of the 409 species no original table has a family of:
  134 in Johto, 134 in Kanto, 136 in Sinnoh, each in a slot the original table had twice, by habitat and level. The
  sync script now leaves Sovereign's changes to Sinnoh's tables out. Tested: every Johto and Kanto table at each time
  of day (`tools/complete/test_hgss_encounters.py`: 29,328 Pokémon made, no problems) and every Sinnoh map's
  (`tools/test/wild_forms.py`: 17,664 made, 323 species and forms, no problems). `docs/WildPokemon.xlsx`
  (`tools/complete/wild_spreadsheet.py`) lists every place's Pokémon, methods and odds, by place and by Pokémon.
- **The progress page** has a Sinnoh tab (what joins it already, the integration's parts) and a timeline tab (every
  day's log entries, decisions and commits, the steps by day, and the plan ahead).
- **The story test can record itself** (`VIDEO`: both screens to an MPEG-TS file by ffmpeg, with each part's and
  action's frame in a list beside it), for the highlight video.

## Nov 1, 2026: Totem trials, legendaries and Megas in all three regions

- **Placed encounters** (`docs/Features.md`, "Totem trials and legendaries in three regions"): one plan,
  `data/complete/placed.yaml`, and `src/complete_placed.c`, which takes Sovereign's moved objects off their maps and
  puts the placed ones on as each map's events load, gated as Sovereign gates them, talking through Sovereign's own
  trial and legendary scripts. Nothing of Sovereign's maps or scripts is edited for it.
- **Totem trials:** eight move to Johto and Kanto, each asked for by the next Gym Leader (Gumshoos before Bugsy...
  Salazzle before Blaine), at a level just under that leader's ace; Lurantis, Kommo-o and Togedemaru stay in Sinnoh.
  `tools/complete/test_placed.py` passes all eight (hidden before the badge, the trial with it, gone after); the story
  test has a part for each (103 parts now).
- **Legendaries:** the Unova and Kalos Chronicles' sixteen to Johto, Alola's and Galar's sixteen to Kanto, Paldea's
  in Sinnoh; `tools/complete/plan_legendaries.py` reads each one's level and gates from Sovereign's scripts and finds
  it a spot. The Legend Archivist's lines say where they are now; the five Chronicle roamers roam the region of their
  chapter.
- **Megas** (`docs/Features.md`, "Megas in Johto and Kanto"): Whitney gives the Mega Ring with the Plain Badge; 50 of
  the 63 bosses after her have a Mega (`docs/BossMegas.md`); 23 item balls in Johto and Kanto hold Mega Stones.
- **The test build** heals the party at each battle's start in god mode: the single story run stopped on the S.S. Aqua
  with its lead fainted (poison or weather, which god mode doesn't stop), in a battle that then asked which Pokémon to
  send out.

## Nov 1, 2026: Sinnoh's levels after Kanto

- **Sinnoh as the third region** (`docs/Features.md`, "Sinnoh, the third region"; Claude's provisional plan, every
  choice in `data/complete/sinnoh.yaml`): Sinnoh's trainers and wild Pokémon move up from Sovereign's levels to follow
  Kanto (Roark's ace Lv. 72, Cynthia's 96), trainers' Pokémon evolved to match; the post-game legendaries in Johto and
  Kanto and Sovereign's roamers too. The level caps run through all three regions in story order
  (`tools/complete/gen_sinnoh.py`). Built and boot-checked; the arrival in Twinleaf is next.
- **The arrival:** the first ship to Sinnoh sails to Twinleaf Town and leaves the player in their room, where
  Platinum's opening plays; gifts on Sinnoh's maps come at its levels and go to the PC when the party is full. The
  story test can start a part straight from the bedroom state (`JUMP`, the test warp with all sixteen badges), and
  its new 'Twinleaf Town' part passes: the sailor, the ship and the TV program's end.
- **A freeze fixed:** a placed legendary gated on an item in the bag (Reshiram, Zekrom, Hoopa) checked the bag with
  the field map's heap, which doesn't exist while a map loads, so entering Burned Tower B1F, Dragon's Den or the Ruins
  of Alph froze the game. It uses the field system's heap now. With the placement test's own fixes (the facing it
  warps with, a second warp when a scene on the way in moves the player, the test clock given time to apply), all 40
  Totems and legendaries pass.
- **Bosses' Megas, checked in battle:** `tools/complete/test_boss_megas.py` battles each Mega-holding boss
  (docs/BossMegas.md) and checks the test build's record of the foe that Mega Evolved (`gSovereignTestFoeMega`).
- **Rowan's lab** looked at the party's lead as the new starter (Platinum's player has only it), so with Johto's team
  he offered to nickname the lead. He now looks at the starter's own slot, or says it went to the PC.
- **A freeze at Rowan's briefcase fixed:** the Sinnoh story test froze the game after the starter was chosen. The
  field map's heap (0xC4000 in the overworld) ran out as Route 201 reloaded with Rowan, the counterpart, the rival
  and the following Pokémon's sprite, and a sprite's texture was read into the null buffer, over the interrupt
  handler's code (found with the emulator's write and exec hooks). The overworld's field heap is 32 KB bigger
  (0xCC000); the application heap keeps about 37 KB free while the field runs.
- **Every boss's Mega checked:** `tools/complete/test_boss_megas.py` passes all 50 (Erika's Victreebel Mega Evolves
  when the AI picks a move on its first turn; once in two runs it didn't).
- **The story test into Sinnoh:** 51 Sinnoh parts drafted from Platinum's scripts (three research passes), from the
  bedroom in Twinleaf Town to Celestic Town, with new actions: Hearthome Gym's doors (read from the save), Eterna
  Gym's turning clock (its blocked tiles by the clock's state), and a test warp across the gym puzzles the walks don't
  solve yet (Veilstone's punching bags, Pastoria's water levels).
- **The final build's tests so far:** all 40 Totem and legendary placements (the placement test now turns the player
  back when an arrival scene changed their facing), all 50 bosses' Megas, Cyrus's two Distortion World battles
  (the story walk crosses the Distortion World by a stand-in) and wild Giratina in both forms. The story test had
  taken the ledge-jump table's name for its part starts, so walks lost their ledges; renamed, and the final
  recorded run restarted from New Bark Town.

- **The story test across Sinnoh's middle:** Route 207's muddy slope up from Oreburgh only lets a Bicycle in 4th gear
  climb it, so the walks to Mt. Coronet get on the Bicycle below it, shift with B and ride up from a run-up (a new
  'slope' action); Route 212 South's marsh has deep mud, which holds the player fast as the Great Marsh's does, and
  the walks keep off it now. Canalave City, Byron, the library, the explosion and Saturn at Lake Valor pass.
- **Two Totems no player could reach:** the story test's walk found Totem Marowak in Rock Tunnel B1F behind Rock
  Climb walls, before Janine; an audit of all 40 placements then found Totem Salazzle on Cinnabar Island up one too,
  before Blaine. HeartGold's Rock Climb comes from Oak late in Kanto. `tools/complete/find_spot.py` had counted those
  walls as walkable; it treats Rock Climb walls and waterfalls as walls now, and both Totems stand in reachable nooks
  nearby. Since save states hold the old build's code, the final recorded run restarted from a new bedroom state.
- **The walks learn field moves:** a Cut tree or a Rock Smash rock in a walk's way is cleared, and a Rock Climb wall
  climbed, as a player would (A, yes). Route 223's waterfall is climbed with Waterfall on the way to Victory Road.
- **Sinnoh's ways, checked offline:** the walk planner run over Mt. Coronet's and Victory Road's warp graphs with their
  boulders in place found the drafted ways that couldn't work: Mt. Coronet 1F North Room 1 needs Strength pushes
  both ways (now in Acuity Lakefront's and the Storage Key's walks); its way south from Route 211 East is one way the
  other way, so Totem Kommo-o's walk takes Platinum's climb from 1F South (2F's boulder pushed down its column, 3F,
  the snow outside, 4F, 5F, 6F); and the path under Route 206's Cycling Road ends at Wayward Cave, so the walk north
  to Eterna rides the Cycling Road up (on the Bicycle before the gate, which turns back anyone on foot).
- **The test's no-damage setting** is set again at every part: a Hall of Fame resets the DS and cleared it, and a
  sailor's Kingdra then knocked out the lead on the S.S. Aqua.
- **Sinnoh's story walk to the Distortion World and back:** it passes Acuity Lakefront (up the Cycling Road on the
  Bicycle, Mt. Coronet's five Strength pushes), the temple guards, the Snowpoint Temple, Candice, Jupiter, the Storage
  Key, the Galactic HQ, Totem Kommo-o (Platinum's climb from 1F South: 2F's boulder, the snow outside, Rock Climb up
  4F, 5F, 6F), Spear Pillar, the Distortion World's stand-in and the way back to Rowan. Fixed on the way: a missed Y
  left the player on foot at the Cycling Road's gate (the Bicycle step now checks it took); Route 216's door, Mt.
  Coronet B1F's east stairs and Veilstone's gate are taken from the right tiles; a key's mat presses stop once the
  player has warped elsewhere on the same map (2F's way north); a scene step may take three times a talk's frames
  (Spear Pillar's runs about 35,000); and the Distortion World's stand-in opens the Spring Path, as the Giratina
  room's portal does.
- **Sinnoh's story test passes to the Hall of Fame:** the League's lift rooms raise their lifts on a step-on trigger
  before the door to each room (the walks now step on it); Bertha asks for her format too on a first run (singles, as
  Aaron's, so Flint and Lucian battle in doubles); and Cynthia's win runs on through the Hall of Fame, Platinum's
  credits and the reset to the title screen, which a new long wait ('settle') presses through to Continue in
  Twinleaf. Every part from Twinleaf to the Hall of Fame has now passed (across resumes from each part's state).
- **Rock Climb walls before the badge:** HeartGold marks Rock Climb walls with the same tile behaviors as Platinum
  (one sits on Route 5), and the full recorded run tried to climb it before Lt. Surge; the walks keep off Rock Climb
  walls until the Icicle or Earth Badge allows the move.
- **HeartGold's people sprites:** `tools/complete/gen_hgss_people_sprites.py` converts HeartGold's own overworld
  sprites (99 new ones: the 16 gym leaders, Silver, Team Rocket and its executives, Kurt, Bill, Eusine, Lance, Giovanni,
  Red, Elm, Ethan and Lyra, the Kimono Girls, Johto's townsfolk, Sudowoodo, the red Gyarados and the rest), and 26
  more turn out to be Platinum's art already (Oak, the nurse, the Gym Guide, the Maid), so they use Platinum's. Misty
  and Whitney no longer look like Crasher Wake: 1,449 objects on 381 maps changed. The new IDs are fixed
  (OBJ_EVENT_GFX_HGSS_<NAME> = 1024 + HeartGold's number), and the mapping is in `data/complete/hgss_sprites.json`,
  which `import_hgss_events.py` and the script translation read. The friend is Lyra or Ethan now, not Dawn or Lucas.
  Fixed on the way: scripts that set a sprite by number (Mom, Whitney and the friend in a scene, Silver's starter's
  Poké Ball) used HeartGold's numbers as they were, which name other sprites in Platinum's list (365 was the Iron
  Crown legendary) or none at all; they translate now. Still stand-ins: the following Pokémon's sprites (next), the
  Apricorn trees, signs, statues and the 3D gimmicks HeartGold draws as models.
- **All of HeartGold's walking Pokémon:** `tools/complete/gen_follower_sprites.py` now converts all 566 (every species
  to Arceus, the female variants, Unown's letters, Arceus's types and the other forms) into one range of graphics IDs
  from 2048, instead of four field-overlay table entries each: two template entries (32x32 and 64x64) serve the whole
  range, and the texture of each is the first's NARC member plus its place. Five small marked hooks in Sovereign's
  field lookups (`src/map_object.c`, `src/overlay005/ov5_021ECE40.c`, `ov5_021ECC20.c`) send a range ID to its size's
  template and its own texture. The follower picks its sprite as HeartGold does (the female one, or the form's), so
  every species to #493 follows now, not five; Sovereign's later species have none yet. The maps' Pokémon standing
  about (Sacred Gold's statics, shown as Poké Balls or the stand-in man before) use these sprites too.
  `tools/complete/show_followers.py` screenshots followers of any species on the test build.
- **HeartGold's still objects:** the people converter also takes HeartGold's one-frame sprites, 32x32 and 64x64, drawn
  as Platinum's bollard and Regigigas are, without a shadow or footprints: the Indigo League's room doors, the Snorlax
  on Routes 11 and 12 (a Strength boulder before), the Pokéathlon's medals and flag, the shop signs, the scroll and
  the player statues. HeartGold's STOP objects, which stood as bollards, are invisible blockers there (five ring
  Lugia's big sprite and share its hide flag), so they're Platinum's invisible object now. Still Platinum's: the
  Apricorn trees (HeartGold's change with the fruit, which needs the Apricorn code) and the 3D gimmicks HeartGold
  draws as models.
- **HeartGold's Apricorn trees:** the 31 trees were Platinum's Cut tree (so the story test's walks even tried to cut
  them); they're HeartGold's tree now, with its Apricorn's colour of fruit until it's picked that day, and bare after,
  as HeartGold shows them. `CompleteApricorns_TreeGfx` picks the look as each tree's object is made (one marked hook
  in `src/map_object.c`), and picking redraws the tree bare at once, the way the Bicycle redraws the player. Checked
  in the emulator on Route 29: fruit, then picked, then bare.
- **HeartGold's 3D gimmicks:** the objects HeartGold draws as 3D models stood as a Ninja Boy or a bollard. They're
  Platinum's 3D objects of the same kind now: the books in five houses ("History of Ecruteak"), the Elite Four rooms'
  doors behind the player, and the locked doors (the Rocket Hideout's, the Radio Tower's Card Key door, the Basement
  Key door) and the Ruins of Alph's opening walls as the wall before Rotom's room. Goldenrod Tunnel's 22 shutters stay
  bollards: as that many wall models, they left the map undrawn (black) in the emulator. Three whose look isn't known
  yet stay bollards too.
- **The full recorded run finished:** from a new game in New Bark Town to Sinnoh's Hall of Fame, all 186 parts passed
  (resumed three times from the failing part's state after each fix: 2, 17, 69 and 98 parts). The highlight video
  (`tools/complete/highlights.py`, 20 moments, 1:58) is cut from it; Cynthia's clip is her part's battle now that her
  part runs on through the Hall of Fame, and the reel ends home in Twinleaf. A second run on the build with
  HeartGold's sprites is under way for a new cut.
- **Every map on the sprite build:** the visit-every-map test loaded all of Johto's and Kanto's maps on the build with
  HeartGold's sprites. 504 came idle at once; 13 more have a scene on entry and pass with it played out; the last,
  the Dragon's Den shrine, is the elder's quiz, which only the story test answers (it passes there). Comparing each
  map's screen with the visit run before the sprites found no map drawn wrong.
- **The full run on the sprite build:** New Bark Town to Sinnoh's Hall of Fame on the build with HeartGold's sprites,
  all 186 parts passed (Johto and Kanto in one go; resumed three times in Sinnoh after test fixes): the height lookup
  lost the player while the Bicycle rolled down Route 206's Cycling Road; walks took Route 209's Bicycle slope on foot;
  and a talk's battle taps waited on a fainted foe's empty box in Flint's double battle. The highlight video is cut
  again from this run, with HeartGold's people in it.
- **Shiny followers:** a shiny lead followed in its normal colours; HeartGold's walking sprites carry a shiny palette
  too, and `gen_follower_sprites.py` now converts both, the shiny ones as a second range right after the first (566
  more textures, no table entries), which a shiny lead takes.
- **The follower never stands on the player's tile:** it used to come out on the player's own tile (after a warp,
  getting off the Bicycle, a lead change) until the player moved. Now it comes out on a free tile beside the player
  (behind, else to a side, never ahead, where a door's step-out goes). The tile can't be a wall, a step, water, a
  door, a warp or a ledge, or have a person on it. As a map loads, the map's terrain isn't loaded yet, so it waits
  hidden on the player's tile. Once the player has control, it moves beside them, or it shows when the player steps
  off, as when leaving a door: it comes out of the door behind them. A scene that leaves it on the player's tile is
  handled the same way. The first version checked the tiles as the map loaded and crashed the game (it read the last
  map's freed terrain). The player walks through the follower, as in HeartGold, so the two swap places, where it used
  to block the way. This is a marked hook in `src/map_object_move.c`'s collision check, for the player and the
  follower only. `test_follower.py` now also checks that it's never in view on the player's tile (a new game, after
  a warp, a lead change, off the bike): it passes.
- **The story test's map object scan:** the full run on the new build stuck in its first part. The walks find the
  player's map object by scanning RAM for its local ID beside a tile near the player, and a false match came first: a
  bogus object count kept the walk reading memory for minutes on end. A match must now be one of its manager's
  objects (the manager's array, at a whole object's offset). The run on the build where the follower comes out beside
  the player is under way.
- **Battle videos:** `tools/complete/record_battle.py` records a real battle as a player would play it. A test wild
  battle (run from) makes the lead the Pokémon asked for, with its item and moves and the MEGA toggle on. Two test
  warps add five Lv. 100 Pokémon, and no EXP is gained, so no level-up prompts. Then the test warp into a room (by
  default Cynthia's) plays the room's own scene, the walk up and her lines, into the battle. The battle is played
  from the bottom screen: FIGHT, then the move of the Pokémon out that does the most to the foe out (from the
  battle's own moves and types and the game's type chart), B for the rest (so no switch by choice), and the next
  healthy Pokémon on the party screen after a faint. `tools/complete/cut_battle.py` cuts the recording to a preview
  from the turn marks the recorder leaves.
- **Mega Charizard Y against Cynthia:** the preview videos the owner asked for. In real battles (Cynthia's Lv. 96
  team and items as the game has them) a Modest Lv. 100 Mega Charizard Y knocked out up to three of her six, but
  her team won all six that ran to the end: three against the first team (Feraligatr, Ampharos, Tyranitar,
  Espeon, Dragonite), three against one picked for her (Mamoswine, Gardevoir, Heatran, Raikou, Metagross).
  These are bot-played battles with random IVs, no EVs and
  level-up moves, against her competitive sets. Spiritomb's Confuse Ray and Cynthia's Full Restores drag out the
  first turns, Garchomp's Outrage or Lucario finishes. The preview is cut from the best real one. A second video
  shows the sweep in the test build's god mode, plainly marked as one-sided.
- **The Johto Pokédex:** the owner's call: Johto's is the regional Pokédex until Sinnoh's story begins, Sinnoh's
  after. The regional list, its numbers (Chansey #222) and its seen and obtained counts are HeartGold's Johto
  Pokédex's, under a JOHTO POKéDEX banner drawn in the Pokédex's own pixel font; with Sinnoh's story begun the switch
  shows SINNOH POKéDEX and Turtwig #001 as before (both checked in the emulator). Its goal is 254 seen, Mew and Celebi
  aside (`docs/Features.md`, "The Pokédex").
- **Red after the whole game, the credits once:** the owner's calls. Mt. Silver's summit stays empty until Sinnoh's
  League is won, then Red stands there (both checked in the emulator, by a test warp to the summit). Sacred Gold's
  snow pile with the Sky Plate, which stood behind him in Red's sprite, is invisible. The credits roll only the first
  time Sinnoh's League is won; Johto's League and Red had none already (`docs/Features.md`, "Red and the credits").
- **Voltorb Flip:** the owner's call: ported. HeartGold's code runs as it is (about 3,700 lines in an overlay of its
  own), with a header that names Platinum's engine by HeartGold's names, its graphics, text and two fanfares. The
  Game Corners' tables start it and the field comes back after. In the emulator, from Goldenrod's table: a round won
  by flipping every 2 and 3 paid 24 coins and moved on to level 2, a round quit with the buttons paid its 1 coin, and
  Quit brought the player back to the Game Corner (`docs/Features.md`, "Voltorb Flip").
- **Johto's Battle Frontier:** the owner's call: open. HeartGold built its Frontier on Platinum's, so its lobbies' scripts
  now call Platinum's own facilities: HeartGold's Frontier commands are Platinum's renumbered in blocks, with the same
  arguments, function numbers and scene numbers, and its lobby vars are Platinum's in the same order. All five
  facilities' lobbies translate in full (115 lines were left in the Battle Tower alone). In the emulator
  (`tools/complete/test_hgss_frontier.py`, all five parts pass): Johto's Factory starts Platinum's challenge, three
  Pokémon are rented, the first battle is won and RETIRE brings the player back to Johto's lobby; the Tower, Hall,
  Castle and Arcade each lead into their challenge. Battle Points, streaks and prints are one set for both Frontiers.
  Left: the Frontier Access's Battle Point move tutors (`docs/Features.md`, "Johto's Battle Frontier").
- **Calls the player places:** the first part of the Pokétch and Pokégear call. HeartGold's outgoing calls are in:
  what each of the phone book's callers says when the player calls them, as HeartGold picks it (a trainer's lines,
  Mom's savings question, Elm's news, Oak's Pokédex rating with its menu and fanfare, Bill's boxes, the Day-Care
  couple's news, Ethan's or Lyra's story about where the player is, Kurt's Balls, Kenji's breaks, Buena, Baoba,
  Irwin, and the Gym Leaders' rematches at the Fighting Dojo). A call starts once the player stands still, with
  HeartGold's dialing, or "That number is out of the area." where HeartGold had no signal. In the emulator
  (`tools/complete/test_hgss_phone_outgoing.py`, all 12 parts pass): calls from the bedroom to Mom, Elm, Oak (rating
  the Johto Pokédex, the National one, and quit), Bill, both Day-Care people, Kurt, Lyra (her New Bark Town story)
  and Falkner each showed the messages HeartGold shows, and Mom from Lugia's cave was out of the area. The Pokégear's
  contact list on the bottom screen, which places these calls, comes next.
- **The Pokégear beside the Pokétch:** the owner's call: both, with a button to switch. HeartGold's Pokégear is now
  the field's bottom screen in the Pokétch's place, with HeartGold's own graphics (its phone frame and its app bar):
  the contact list (names, and titles such as Pokémon Professor or Youngster), scrolling, and a tap to call. It comes
  up as soon as Mom gives it; with the Pokétch too, a blue button under the Pokétch's side button switches to the
  Pokégear, and the Pokégear's last app bar button switches back, with a fade; the choice is saved. In the emulator
  (`tools/complete/test_hgss_pokegear.py`, all 6 parts pass): the Pokégear came up as the flag was set, a tap on Mom
  called her, the down arrow then a tap called Elm, the switch went to the Pokétch and back, a warp kept the
  Pokégear, and it came back after a wild battle. Its Map and Radio come next (their buttons are dimmed for now).
- **The Pokégear's map:** HeartGold's map of Johto and Kanto on the Pokégear's Map page, with the player's head where
  HeartGold's map app puts them and the place's name; dragging scrolls it. HeartGold's map is 256-colour, too big for
  the bottom screen's video memory, so the importer makes it 16-colour without changing a pixel (five palettes, 593
  tiles). In the emulator (`tools/complete/test_hgss_pokegear.py`, now 8 parts, all pass): the head showed at the
  bedroom's place, then at Route 30's after a warp (the Pokégear came back on the Map), dragging scrolled toward
  Kanto, and the Phone button brought the list back.
- **The Pokégear's radio:** the last part of the Pokétch and Pokégear call. HeartGold's radio is on the Pokégear's
  Radio page: its globe, where dragging the cursor (or a tap on the four buttons beside it) tunes the stations of
  where the player is, and all twelve of HeartGold's shows with their text and music (DJ Ben's Pokémon Music,
  Professor Oak's Pokémon Talk, Trainer Profiles, That Town, These People, the Search Party, the Serial Radio Drama,
  Buena's Password and the commercials; the Poké Flute, the Unown's broadcast, Mahogany's signal and Team Rocket's
  broadcast). The music plays in the field while the page shows a station, and what HeartGold's radio does in the
  field works: the March and the Lullaby change how often wild Pokémon appear, Hoenn's and Sinnoh's sounds bring
  their Pokémon to the grass, the Unown's broadcast brings letters not yet seen, Oak's show names today's outbreak and
  the Poké Flute wakes Snorlax (the stand-in that woke it with the Expansion Card alone is gone). Buena's password now
  changes each day and her quiz asks for the one her show gave (its three words came from nothing before). Sinnoh has
  no signal. The show's lines print one at a time in a strip under the globe, as the top screen is the field's. In
  the emulator (`tools/complete/test_hgss_radio.py`, all 11 parts pass): the page in New Bark Town on the fourth station with
  static, each button's show (Pokémon Music playing Tuesday's Lullaby, Oak naming Misdreavus, That Town, These
  People), off the stations, leaving the page and back, Kanto's Poké Flute by Route 11's Snorlax, which then woke, and
  the Ruins of Alph's, Mahogany's and Sinnoh's stations.
- **The Battle Frontier's move tutors:** the last part of Johto's Battle Frontier. The three tutors in the Frontier
  Access teach HeartGold's 51 moves for Battle Points at HeartGold's prices: HeartGold's own script (its common
  scr_seq_0002, here at script 11200 on), with its three commands for the list, the price and the move's slot done
  in the engine (`src/overlay005/complete_move_tutor.c`): the moves the Pokémon can learn and doesn't know, six a
  page, each with its price, in Platinum's script menu. Who can learn Platinum's 38 tutor moves the engine's own data
  decides; HeartGold's 13 others come from HeartGold's list, and for the species after Arceus from their own
  learnsets, as for Headbutt (`tools/complete/import_hgss_tutors.py`). In the emulator
  (`tools/complete/test_hgss_frontier_tutors.py`, all 3 parts pass): the first tutor listed Fury Cutter at 32 BP for
  the lead, turned it down with no points, and with 500 taught it in place of a move it forgot, leaving 468.
- **Calls ring:** the phone's last stand-in. A call that comes in now rings, as HeartGold's does, instead of starting
  at once: the ring sounds every so often as the player walks and the Pokégear's Phone button flashes; a tap on it
  answers, and the call plays once the player stands still. Nobody answering, it stops after HeartGold's 59 seconds
  and is missed (a triggered call comes again later). HeartGold's forced calls (the Bike Shop's, Bill's, Baoba's) and
  the story's calls from map scripts still come through at once. In the emulator (`tools/complete/test_hgss_pokegear.py`,
  now 10 parts, all pass): Joey's call rang with no call yet, a tap on Phone answered it and his call played; another
  rang for the 59 seconds and stopped with no call. The phone test's 8 parts and the outgoing calls' 12 still pass.
- **The Pokégear's skins:** HeartGold's six skins (blue, pink, black, wood, gold, teal) on the Pokégear's Settings page,
  HeartGold's configure screen with its frame around the skin in use; a tap dresses the whole Pokégear in it (the
  app bar, phone, map colours, radio and settings), saved with the phone. Each graphic comes in its six variants, its
  tiles packed to fit a page's 128 (HeartGold's gold skin spreads over 1,024), and the map is made once for all six
  by HeartGold's colour indices. In the emulator (`tools/complete/test_hgss_pokegear.py`, now 11 parts, all pass): the
  pink skin chosen, saved and shown on the Phone, then the blue one back.
- **The story test on the follower fix:** the full run on the build where the follower comes out beside the player,
  never on their tile, passed all 186 parts, New Bark Town to Sinnoh's Hall of Fame (its first 16 in one run, the
  other 170 resumed from Azalea Town's save in another, with Cynthia beaten and the Hall of Fame entered).
- **Wild Pokémon fixes from the original tables:** three tests had failed since the Nov 1 switch to the original
  games' tables, and each was a real gap. The outbreak species are now HeartGold's own (Yanma on Route 35, Luvdisc on
  Route 27's water, where Sacred Gold had Illumise and Feebas); the test reads each map's from its table now. The
  Ruins of Alph's halls take no new species: they're Unown's, their letters let out by the puzzles, and the mixing
  had put a Gothita, a Hatenna, a Milcery and a Fidough in them (now in other Johto areas). HeartGold's data has what
  Sacred Gold's files lacked, so HeartGold's fishing outbreaks (Relicanth on Route 12, Qwilfish on Route 32, Remoraid
  on Route 44, Whiscash in Violet City) and its night fishing (a night species on the Good and Super Rods after 8
  p.m.) are in too, with no new species in the two rod slots night fishing takes. Mawile, whose only original table
  was a Game Boy Advance dual slot, is mixed in now (Johto, placed after the rest so no other species moved).
  `docs/WildPokemon.md` and the spreadsheet are regenerated. In the emulator: the outbreak test's 8 parts (with the
  rods and night fishing) and the Alph puzzle test's 4 pass. The Battle Factory's part of the Frontier test failed once
  as a slow battle ran past the test's wait: the rentals are random, so the wait is longer now.
- **Fly on the Pokégear's map:** Fly over Johto and Kanto is HeartGold's fly map now, on the Pokégear's Map, in place
  of the list: HeartGold's red cursor (its map app's own, flashing) on the town reached nearest the player, the
  field asking "Where do you want to fly?". The D-pad moves the cursor to the nearest town that way, a tap moves it
  to the town tapped, and A, or a tap on the town picked, flies there; B backs out to the page the Pokégear was on.
  With the Pokétch on the bottom screen, or before the Pokégear, the list stays. In the emulator
  (`tools/complete/test_hgss_fly.py`, its 13 checks pass): the list without the Pokégear, then with it the cursor on
  Cherrygrove City from New Bark Town, B backing out, UP to Violet City and a tap there flying to it.
- **A test runner, and a sweep:** `tools/complete/run_tests.py` runs Complete's emulator tests a few at a time on a
  test build, from a bedroom state it makes, and sums up (six tests that always exited 0 now exit with their result).
  Its first sweep on the latest build: 28 of 31 passed. The three that didn't were tests left behind by the game: the
  ferry test still expected the first ship to Sinnoh to go to Canalave City (since Nov 1 it lands in Twinleaf Town for
  Platinum's opening; the test now checks both), Voltorb Flip's touched the menu's Quit before the menu took touches
  (it tries again now), and the gifts test (four givers didn't answer in the full run, though all four answer on
  their own).
- **No calls from taps in a scene:** the new story run stopped in Sprout Tower with Joey's call on screen mid-walk:
  the test's taps for battle moves, made while a scene ran, had landed on Joey in the Pokégear's phone list, and the
  call came once the player stood still. A player tapping during a cutscene would get the same, so while a scene, a
  warp or another field task runs, the Pokégear's contacts (and the Phone button's answer to a ringing call) only beep
  now. The Pokégear test's 11 parts, the outgoing calls' 12 and the phone's 8 still pass. The gifts test's four
  failures in the full run don't come back: on a matching state it passes 23 of 23. Its givers who wander (Razor,
  Lola, the Phione Eggs' woman, Johto's starters' doctor) can step off before the test talks, so it now goes back and
  talks again, up to four times, as the talk test does, and its talk loop no longer reads a save's pause as a hang.
  (One hang came from rebuilding the test build under a running test: CLAUDE.md now says not to.)
- **HeartGold's legendary cutscenes:** the Bell Tower's roof and the Whirl Islands now play HeartGold's scenes
  (`src/overlay005/complete_legend_cutscene.c`, from its `legend_cutscene_camera.c`), which the translation had left
  as comments: the Clear Bell (or the Tidal Bell) rising from the bag and shimmering with its corner bells, the leaves
  blowing over the roof (or the waves in the cave), HeartGold's camera points and pans, Ho-Oh flapping down onto the
  roof with a ring of light, and Lugia's eye glinting. Its models are HeartGold's own (`tools/complete/
  import_hgss_legend.py`), drawn by Platinum's field 3D tasks. HeartGold's cinematic of the bird's flight stays out;
  as its return resets the camera there, the camera goes back to where it was. In the emulator
  (`tools/complete/test_hgss_legend_cutscenes.py`, both parts pass): each scene from its trigger to its end, the
  Kimono Girls dancing, the bells, the leaves and waves, Ho-Oh on the roof after.
- **HeartGold's Magnet Train ride:** between Goldenrod City and Saffron City the ride now plays as in HeartGold, where
  the screen had only faded out and in: three cuts of the train (the player on the platform as it comes in, the train
  at the station, the train crossing the country), from their own cameras, the first two closing like a camera
  shutter, the last fading out as the train pulls in to HeartGold's jingle. Its models are HeartGold's own, chosen as
  it chooses them: by the way, by day or by night, and by the player's gender; the last cut takes the area's light at
  the time (warm windows and a blue evening at night). HeartGold's overlay 104, in assembly there, is C here
  (`src/applications/complete_magnet_train/magnet_train.c`), its archive brought in by
  `tools/complete/import_hgss_magnet_train.py`, and HeartGold's ScrCmd_722 runs it between the script's fades, as
  Platinum's own scenes return to the field. The jingle (`SEQ_GS_E_LINEAR`) joins HeartGold's songs; the train's
  sound effects, HeartGold's own, stay out. In the emulator (`tools/complete/test_hgss_magnet_train.py`, both parts
  pass): Goldenrod to Saffron by day and Saffron to Goldenrod at 10 p.m., each walked aboard by the platform's scene,
  all three cuts with the right models, 617 frames, and the player welcomed at the other station and free there.
- **The long checks on the latest build:** every Totem and legendary placement (40 of 40), every boss Mega (50 of
  50), every tile behavior (252 of 252), the sound memory on every map (4 of 4 parts) and talking to the follower pass;
  the hidden items are as before (241 of 243: the same two the test can't reach).
- **The story run stopped at Bugsy's gym, and it was the test:** its talk to a cart switch kept pressing A for text
  while the switch's short script ran, and one press landed as the script ended and flipped the switch back, so the
  cart took the player the wrong way. Azalea Gym's switches now get one press and no more input until their script
  is over (a new `switch` action); from the same save Bugsy's part and the Ilex Forest's pass. The story test can
  also save a screenshot after each action (`STEP_SHOTS=1`) to see where a walk went wrong.
- **The Rocket Hideout's traps and alarms, and the monks' wings:** the hideout's trapped floor now sets off
  HeartGold's traps under the player before their battles (sparks, a gas cloud, falling rocks), and a Persian statue
  spotting the player pulses the screen red twice, where both had been left out (HeartGold's ScrCmd_708 and 709, in
  assembly there, are C here: `src/overlay005/complete_legend_cutscene.c`). The Bell Tower's and the Whirl Islands'
  monks show their wings again (HeartGold's ShowLegendaryWing), and with them come the scenes HeartGold starts from
  the wing, which had been skipped: each monk's lines after it and his step aside. They use the legendary cutscenes'
  archive, which now carries all of HeartGold's `demo/legend` (110 files, 505 KB). In the emulator
  (`tools/complete/test_hgss_field_effects.py`, 6 of 6 pass): each trap stepped on, its effect played to the end and
  its battle after, the first statue's alarm, and both wings with the monks' scenes.
- **Lance's flight** off the Lake of Rage: HeartGold's ScrCmd_775 plays its own Fly take-off cut-in (in assembly);
  Platinum's cut-in window stands in with his Dragonite, and with Fly's whoosh Lance and the Dragonite are gone, where
  they had vanished as the screen faded. The effects test has it as its seventh part (7 of 7 pass). Sacred Gold's
  Sinjoh Ruins reuse the hideout's alarm in the plates' event, which plays now too.
- **The Pokégear's cards:** the Map and the Radio now come with HeartGold's Map Card (Cherrygrove City's guide, at the
  end of his tour) and Radio Card (the Radio Tower's quiz); until then their buttons are dark and beep, and Fly uses
  the list. Both had been on from the start (HeartGold's RegisterPokegearCard was left out; the flags and the scene
  var it goes with carry it here). The app bar lights a card as it's given. In the emulator: the Pokégear test's new
  part (a tap on the Map before the card stays put), then its other 11, the radio's 11 and Fly's checks pass with the
  cards given.

- **The Rocket uniform:** in Goldenrod Tunnel the grunts put the player in a Rocket uniform for the Radio Tower, and
  now the player wears it: HeartGold's own walking sprites for it (the boy's and the girl's, imported with its people,
  `OBJ_EVENT_GFX_HGSS_RHERO` and `RHEROINE`), from the tunnel's scene until the Radio Tower's director takes it back.
  HeartGold's SetAvatarBits and RocketCostumeFlagAction set and clear its flag, and the player's walking sprite comes
  from it (`src/player_avatar.c`, a marked change). As in HeartGold, in it the player can't Fly, Surf, Rock Climb,
  Teleport or Dig, nor ride the Bicycle, fish or use an Escape Rope (next to Platinum's checks for a partner along, in
  `src/field_move_tasks.c` and `src/item_use_functions.c`). In the emulator
  (`tools/complete/test_hgss_rocket_costume.py`, 5 of 5 pass): the plain sprite, the uniform on arrival and walking
  about, taken off, the Bicycle on Y refused in it (Platinum's "Rowan's words echoed...") and taken without it. The
  story test's way through the takeover walks everywhere, so nothing it does is refused.
- **A sweep of every Complete test** on the build before the uniform: 32 of 33 pass. The gifts test's Johto starters
  failed: Saffron's doctor who gives them wanders, and stepped off his tile before the test talked, each time it
  warped back. The test now waits facing his tile and talks as he steps back onto it, warping back only now and then;
  the whole gifts test passes with it (23 of 23).
- **Ho-Oh's and Lugia's cinematics:** between the Kimono Girls' dance and the landing, HeartGold's cinematic now plays
  (its `Cinematic` command, its overlay 106, in assembly there; in C here as an app of its own,
  `src/applications/complete_legend_cinematic/legend_cinematic.c`). Over the Bell Tower the Clear Bell's sound spreads
  in rings of light, then Ho-Oh flies in around the tower to HeartGold's Ho-Oh theme (`SEQ_GS_E_HOUOU`, now among the
  imported songs); in the Whirl Islands Lugia rises through the waterfall and cries as the picture trails, the DS's
  display capture blending each frame with the last, as HeartGold does it (Platinum's own copy of that code is in
  the field's overlay, which is out while an app runs, so the app has its own). HeartGold's models (two archives,
  LZ-compressed there, unpacked by `tools/complete/import_hgss_legend_cinematic.py`: 34 files, 1.3 MB), Ho-Oh's by
  HeartGold's three times of day, lit by the field's light. The field map is left for the cinematic and comes back
  with the scene's people where the script put them, as HeartGold's command does it (Platinum's trade scene's way).
  In the emulator the legendary cutscenes test now checks each scene's cinematic too (begun, ended, its frames, its
  models, Lugia's trail): both scenes pass, from their trigger tiles to their ends. Arceus's cinematic at the Sinjoh
  Ruins (2D, with the Pokémon it brings) is next.
- **The Sinjoh Ruins' event, with the Unown circle and Arceus's cinematic:** Sacred Gold's event on the Mystri Stage
  (all 16 plates and the National Pokédex) now plays as HeartGold draws it. HeartGold's Unown circle (its
  `event_cutscene_sinjoh.c`, here `CompleteUnownCircle` with the other legend effects): two rings of Unown spin up and
  a light rises in them, from HeartGold's `demo/legend`. Then Arceus's cinematic, HeartGold's 2D one from the same
  overlay as Ho-Oh's and Lugia's: overlay 106 runs it from a script of its own (513 steps: waits, fades, backgrounds
  loaded and blended into each other, the sprite shown and moved, the music), which the importer reads out of
  HeartGold's assembly into `include/data/hgss_arceus_cinematic.h` and the app runs step for step. Its 68 backgrounds
  (256 colors each, with extended palettes) and its sprite come from HeartGold's archive 247, and Arceus is drawn from
  HeartGold's own walking sprites, one per form, in the lead's form and colors if the lead is Arceus. Arceus's theme
  (`SEQ_GS_E_ARCEUS`) joins the imported songs. In the emulator (`tools/complete/test_hgss_sinjoh.py`, 3 of 3): with
  the event's flags, the plates and the Pokédex written into the save, a step onto the stage's middle, the circle
  begins and ends, the cinematic plays its whole script (about 2,400 of its steps), and the scene goes on on the
  field. HeartGold's own Arceus event there (the egg, with Cynthia) needs a distributed Arceus and stays out of reach.
- **HeartGold's own sound effects:** the sound importer now also brings in each of HeartGold's sound effects
  (`SEQ_SE_GS_*`) that Sacred Gold's scripts play or Complete's code names, 69 of them, each with its own bank and
  waves (175 waves in `WAVE_ARC_GS` now, 520 KB). Platinum's sound effects play from its basic waves, always loaded,
  and its SE players' heaps are a kilobyte or two; HeartGold's need up to 23 KB, so each loads into sound memory as it
  starts (`CompleteSound_LoadOwnEffect`, from `Sound_PlayEffect`): up to four at once (the cinematics play a few
  together), each freed once it has ended and nothing has loaded above it, and stopped first if a song's load takes
  the memory back. NitroSystem's heap keeps a 32-byte record for each level saved, which restoring to the level keeps,
  so an effect loads into the heap's current level when nothing else is there (after a song's load), and otherwise
  saves a level that the next effect reuses: the memory comes back whole, and a game of Voltorb Flip can't pile up
  levels. The scripts play them (185 PlaySE in 65 of Sacred Gold's script files, retranslated; the Ruins of Alph's
  chambers' falls among them), and so do the ported scenes, which had Platinum's sounds standing in: the Clear Bell's
  rings and light, Ho-Oh's and Lugia's wings, Lugia's eyes and the Whirl Islands' falls (fading in), the Rocket
  Hideout's traps, siren and the wings' chime, the Magnet Train's rails for each cut, Voltorb Flip's cards and coins,
  the Ruins of Alph puzzles' panels, Mahogany Gym's ice and Blackthorn's lift. In the emulator (build_test3): the
  legendary cutscenes (2 of 2), the Magnet Train (2 of 2), the Sinjoh Ruins (3 of 3), Voltorb Flip (4 of 4), Mahogany
  Gym, the Alph puzzles (4 of 4) and the field effects' seven pass with them; the sound memory test's new part plays
  each of the 69 over New Bark Town's song (none fails to load; 95 KB left at the least) and checks that an effect
  gives all its memory back: between two fanfares (each of which keeps its own level's record, Platinum's way), twice
  running, it may add nothing to their step; it found the effect's own record first, gone since (build_test).
- **The Ruins of Alph's walls:** reading a chamber's north wall now shows its words on HeartGold's stone tablet, in
  the Unown's letters (ESCAPE, LIGHT, WATER, HO OH), until A is pressed: HeartGold's OpenAlphHiddenRoom (in assembly
  there), here `CompleteAlphWall`, the tablet from HeartGold's `demo/legend` on the field's BG1 and the words from its
  `msg_0198`, now imported. And the rooms behind open as in HeartGold: facing the wall from below it, an Escape Rope
  opens Kabuto's chamber's, Flash Omanyte's and a Water Stone Aerodactyl's (`CompleteAlph_CanOpenWall`, from its
  `alph_checks.c`, asked by the item use and by Flash), the chamber's own script shaking the room open, nothing used
  up; Ho-Oh's opens when read with Ho-Oh in the party. Each room has four item balls, which no one could reach before.
- **Lance's take-off:** off the Lake of Rage, Lance now leaves as in HeartGold, on his Dragonite in Fly's take-off.
  The stand-in had been Platinum's plain cut-in band (Cut's and Surf's), the two then simply gone. HeartGold's version
  (its ov02_022494C4) is its Fly cut-in with Lance as the rider; Platinum's Fly cut-in is the same code, so it takes a
  third rider, HeartGold's Lance, from HeartGold's field cut-in archive (its a/0/9/3, now imported whole,
  `fielddata/complete/field_cutin.narc`): Lance in the band sending out the Dragonite, the bird swooping down to his
  tile instead of the middle, his and the Dragonite's objects hidden instead of the player's (unpaused first, as
  Platinum does the player's: a paused object's drawing isn't updated, which the first try showed), and no fade at
  the end, the scene going on. In the emulator the field effects test now checks both are hidden by the bird.
- **The Bike Shop's call:** HeartGold's Bike Shop owner calls once the player has ridden 1,024 steps (its
  GAME_STAT_STEPS_BIKED and FieldSystem_UpdateBikeShop). Platinum's game records count steps but not on the bike, so
  the phone's save counts them (two of its reserved bytes), at each step on the bike, and sets the call's trigger
  once there are 1,024, if the call hasn't come yet and the number is in the phone. The phone test's new part
  (9 of 9 pass): a step on foot counts nothing, the 1,024th on the bike sets the trigger.
- **Sound effects before a fanfare:** an ended HeartGold sound effect is freed at the sound system's next tick, so a
  fanfare started in the same frame (Voltorb Flip plays its own once its effects have ended) saved its heap level
  above the effect and kept it loaded until the next song. Ended effects now go before any heap level is saved. The
  sound memory test (5 of 5), Voltorb Flip (4 of 4) and the legendary cutscenes (2 of 2) pass with it.
- **The Day-Care Man's calls:** nothing set his egg-call flag (HeartGold's FLAG_SYS_TRIGGER_EGG_CALL), so he called
  about every Egg with his first Egg's call. HeartGold's Day-Care Man (its scr_seq_0265) has lines for the first Egg
  after the couple's numbers (Route 34's state 3), taken or turned down, sets the flag and asks whether to keep
  calling, and asks again when he's talked to with nothing in his care; Johto's runs Platinum's script for him
  (`scripts_day_care_common.s`), which now does the same on Route 34 with HeartGold's lines (its msg_0439). After the
  first, he calls only with a yes. The phone test's new part (10 of 10 pass): an Egg written into the Day-Care's save
  and turned down twice, then yes; then, with nothing, his question again and a no. (The Egg's place in the save was
  found from an empty Pokémon's encrypted words, the game's compiler laying the mail out differently from gcc.)
- **A sweep of every short test** on build_test3 (HeartGold's sound effects, the Alph walls, Lance's take-off and the
  Bike Shop's call; split by the session's machine restarting): 34 of 36 pass. The Bug-Catching Contest's battle
  found no encounter in 300 steps once, and passes on a rerun (4 of 4); the phone test's Day-Care part needs the build
  after it, where it passes (10 of 10). The story run goes on from Chuck after its first 33 parts, and the talk test
  runs again on the newest build.

- **Room for eight sound effects:** checked on its own build: the sound memory test (5 of 5) and Voltorb Flip (4 of
  4) pass with the eight-effect stack.
- **HeartGold's Balls drawn as themselves:** the seven Apricorn Balls, the Sport Ball and the Park Ball had been
  drawn as Poké Balls. `Pokemon_BallToDraw` now gives the Ball graphics' tables HeartGold's Ball numbers (17 to 25),
  and each table has HeartGold's rows: the throw (its tiles and palettes from HeartGold's battle sprites, matched to
  Platinum's by content, with the Poké Ball's cells, animations and particles, which HeartGold's are copies of), the
  flash as a Pokémon comes out (HeartGold's colours) and the summary screen's icon (HeartGold's icons and palettes;
  HeartGold has none for the Park Ball, which shows a Poké Ball). The rows go after Platinum's special throws, so
  nothing that throws mud or bait changes. The catch's own throw now goes through the same lookup, so the
  Bug-Catching Contest's Sport Ball is thrown as itself; the trade room's cards keep a Poké Ball (their animations are
  Platinum's 16). `tools/complete/import_hgss_balls.py` brings the graphics in. The Ball test now also watches each
  throw for the Ball's own colours and opens the caught Pokémon's summary for its icon's: 7 of 7 pass, and the
  contest test (4 of 4) checks its Sport Ball's throw the same way.
- **The Bug-Catching Contest's battle screen:** the bottom screen is HeartGold's contest menu now: BALL where BAG was,
  one party Ball, and over the menu HeartGold's bug net, a Sport Ball with the Balls left, and the Pokémon the contest
  keeps (its icon, gender and level). The battle's contest Pokémon was an empty slot for a new catch; it starts as a
  copy of the kept one, so the menu can show it. HeartGold's net and Ball need colours Platinum's bottom-screen
  palettes don't have, and all sixteen palettes there are in use, so the contest's battles load HeartGold's own
  version of those palettes (Platinum's seven with the colours added), as HeartGold does. The contest test catches
  with as many Sport Balls as it takes (one missed a Lv. 30 Beedrill), returns to the grass every 25 steps (a step
  blocked one way had walked the player off it, the earlier "no encounter" failure), and checks a second battle's
  menu for the kept Pokémon before running from it: 4 of 4 pass, and so does the Safari Zone's test.
- **A fix to the Ball importer:** a one-line edit had replaced its check function's first line, and its check then
  compared HeartGold's members with the built archives, which hold them now; it compares with Platinum's own members
  only.
- **Baoba's calls on the Pokégear:** Baoba's Safari Zone calls had been a stand-in, their changes made at a map load
  with no call. They're HeartGold's now: a map load sets the call's trigger once three hours of play have passed
  (HeartGold's `sub_02092E54`: after his first test, his next; after the second, with the National Dex, the objects),
  the call comes through at the next step, and as it plays it does what it says (HeartGold's
  `PhoneCall_GetScriptId_Baoba`: the next test, one more group of objects with his time stamped again, or all of them).
  His call about new Pokémon is in too: when days pass and an area's Pokémon change, the areas go into the phone's
  save, and he names them (HeartGold's `SaveData_SafariZone_CheckAreasWithUpdatedEncounters` and
  `GearPhoneCall_Baoba`). The phone test's new part (11 of 11 pass): his next-test call sets the test going, his
  objects call gives the first group, and his areas call names the Plains and Wetland Areas written into the save.
- **The test build's memory:** the first test build with Baoba's calls showed a white screen at boot. The boot carves
  fixed heaps out of the main memory the code and data leave, and the test build, with its test code, had 296 bytes
  left; Baoba's code needed 544. The Safari Zone's encounter table (16,920 bytes, the main module's biggest of
  Complete's) is a NARC now, read an area at a time as it's needed (`fielddata/complete/safari_encounters.narc`,
  from `tools/complete/import_hgss_safari.py`; byte for byte the table the code held, checked against the running
  game). The test build has 16 KB left now and the release build 39 KB (it had 22). CLAUDE.md says how to read it.
- **A sweep of every short test** on build_test2 (HeartGold's Balls and the contest's screen): 34 of 36 pass. The
  phone and Safari tests failed only because they were changed during the sweep for the next build (Baoba's part,
  the encounters' NARC), where they pass (11 of 11, 6 of 6).
- **The Pokégear's own sounds:** it played Platinum's beeps. It plays HeartGold's now, as HeartGold's Pokégear code
  does: the app bar's change, the cursor (scrolling, the radio's buttons, the fly map's D-pad), picking, backing out
  and touching the map, and the phone's ring, dialing tone and hang-up click. The importer now also reads the engine's
  own scripts for HeartGold's sound names. Seven more effects cost the archive about 450 bytes of the sound memory
  that stays loaded, and the title screen's song, which needs nearly all of it, stopped fitting; HeartGold's banks
  that are just like another (50 of 271) are merged into it, which gives back 1.6 KB (the title song leaves 1 KB, the
  most it has). The Pokégear test now checks two of the sounds load as they play; it, the sound memory test (5 of 5),
  the phone (11 of 11), its calls (12 of 12), the radio, Fly, the cutscenes and Voltorb Flip pass.


- **Sacred Gold's special encounters, checked:** every one-time Pokémon in Sacred Gold's Special Event Guide that
  wasn't tested yet has a test now (`tools/complete/test_hgss_special_events.py`; `docs/Features.md`, "Sacred
  Gold's special encounters"). For each, the test sets what the script waits for (badges, an item, flags, the party,
  the hour or the weekday), talks to it, presses A at its spot or steps onto its trigger, and checks the battle's
  Pokémon, level and shininess, which the test build now records as each scripted wild battle starts
  (`gCompleteTestScriptedWild`). All of them start as the guide has them: Rotom, Spiritomb, the five shiny
  pseudo-legends (two tried), Friday's Lapras, Kanto's birds, Mewtwo, Mew after its three teleports (the test walks
  after it, as a warp would load the forest again), Celebi, Jirachi and Shaymin with the Azure
  Flute, the Regis and Regigigas, Latios with the Soul Dew, Groudon, Kyogre and Rayquaza, Deoxys late at night, the
  lake trio and the creation trio, Heatran, Cresselia and Darkrai. The tries before their time start nothing
  (Rotom before the Plain Badge, the well without a keystone, the radio before the Earth Badge, the shrine and
  Shaymin without the flute, the meteorites by day), and the steps that open the way work: the nightmare shows
  Cresselia, the Mt. Silver tablet breaks for the three Regis (not without them), the Lavender Town woman trades the
  Azure Flute for the Magma Stone, and picking up the Magma Stone brings Heatran out. Nothing in the game needed a
  fix; the test's one early failure was its own (Moltres takes Blaine's tile only once Heatran's catch has hidden
  him). 42 of 42 pass on build_test2.
- **The long runs:** every map's wild Pokémon passes on build_test3 (59 minutes). The story run is through 85 parts
  (to Kanto's Power Plant), all passing. The talk test is most of the way through with one stop more than the known
  three: Johto's Battle Factory attendant, whose lobby runs Platinum's Factory since the Frontier opened, stops at
  the same rental menu the test can't drive in Sinnoh's.

- **Arceus's plates, and the piles they hide under:** every one of the sixteen plates Arceus asks for can be had
  (`docs/Features.md`, "Sacred Gold's special encounters"): the special events test now takes each of the fourteen
  that aren't held by a gift Pokémon from its giver, pile or spot and checks it lands in the bag (57 of 57 pass,
  with the lead a Phione then a Manaphy, a Bellossom or an Alakazam where the giver wants one, and 15 Poké Balls
  for the lighthouse woman). On the way a sprite fault turned up: Sacred Gold hides the Stone, Flame, Icicle and Sky
  Plates under dirt and snow piles, which are HeartGold's disguises (movement types 51-54, an object under a mound,
  as Platinum's Galactic grunts are), and the events importer turned every movement type past 46 into "look
  south". So Pewter City had a Cynthia standing by the museum, the Sinjoh Ruins a Snorlax in the snow, Bellchime
  Trail a Poké Ball, and the Kanto Snorlax three little boys on its other tiles. HeartGold's table has Platinum's
  four disguises at the same numbers, drawn from the same models (`nin_hide_s`, `_b`, `_g`, `_k`, checked in both
  games' field-effect archives), so they're kept now: the piles show as mounds, and the Snorlax stands alone. The
  radio test, which wakes the Route 11 Snorlax, passes (11 of 11). The test also meets the guide's "special
  surprise" on Mewtwo's spot once it's caught: a trainer battle with "???" and Lugia, Ho-Oh and Mewtwo at Lv. 100
  (the test build's record of trainer battles), which starts as it should.
- **Four more of HeartGold's script commands:** of the 463 lines Sacred Gold's scripts still leave untranslated,
  nearly all belong to what's skipped or waits on the owner (Cameron's photos, the Pokéathlon, the Union Room and
  Wi-Fi, Pal Park). Four small ones in ordinary places run now: Cerulean Gym's pool and the Whirl Islands' Lugia cave
  keep their own music while the player surfs, as in HeartGold (its flag 0x99A, which their map scripts set and every
  map change clears; checked in the emulator: surfing in the gym's pool leaves the gym's song playing, on Route 24
  the surf theme plays); Mystery Gift unlocks with the Pokédex at Mr. Pokémon's, as in HeartGold; the Ruins of Alph's
  line in the Unown script prints (Platinum's own Unown-font message); and Flash at the Omanyte chamber's wall shows
  the Pokémon's HM cut-in. The walls test passes (2 of 2).
- **The script translator reproduces the installed scripts:** run as `--install --from .cache/sacredgold/scr_seq`
  (without `--from` it reads HeartGold's own scripts, whose labels and anchors differ), it gives back every installed
  file but five, which carry table entries added after they were last installed: Dragon's Den's rival's Pokémon
  sprites (now installed; nothing on that map draws them) and four wireless rooms (the Union Room, the Global
  Terminal, the Wi-Fi Plaza's room and the Safari Zone's link counter), whose link commands stay comments until
  they're tested. CLAUDE.md says how to run it.
- **The lighthouse lamp comes back on:** at the top of Olivine Lighthouse, once Amphy has had the SecretPotion,
  HeartGold's lamp scene plays (its ScrCmd_459, here `CompleteLighthouseLight` in
  `src/overlay005/complete_legend_cutscene.c`; `docs/Features.md`, the field effects): its lamp model from
  `demo/legend` turns and shines for a second and a half to a rising hum, the screen goes white and fades back in.
  Its two sounds are Diamond and Pearl effects HeartGold kept and Platinum dropped (`SEQ_SE_DP_FW411`, `_F207`): the
  sound importer now also takes those when Complete's code names one (`docs/Music.md`). The field effects test has
  the scene as its twelfth part (12 of 12 pass on build_test2), the sound memory test passes (5 of 5) and the release build boots.
- **A black panel at the top of the lighthouse:** in Olivine Lighthouse's light room a large black box hid Jasmine
  and Amphy (and the lamp scene). It was the room's door, one of HeartGold's 3D gimmick objects, which the events
  importer had drawn as Platinum's wall before Rotom's room. HeartGold gives each of its eleven gimmicks a model of its
  own in its field effects archive (overlay 1's ov01_02208E30): the lighthouse's and Goldenrod Tunnel's doors, the
  Radio Tower's, warehouse's and Rocket Hideout's locked doors, the Elite Four rooms' doors, Goldenrod Tunnel's four
  shutters, the warehouse's boxes, the Rocket Hideout's trap switch, and the Ruins of Alph's walls and holes. They are
  drawn with those models now (`docs/Features.md`, "HeartGold's 3D objects"; `tools/complete/import_hgss_gimmicks.py`),
  each loaded the first time a map shows one. Screenshots of eleven of their maps on build_test2 show each drawn, and
  no black panels; the field effects (12 of 12), Ruins of Alph walls (2 of 2), Pokégear (12 of 12) and radio (11 of
  11) tests pass. (The Radio Tower deck's dark skylight is HeartGold's: its glass is nearly clear, alpha 7 of 31,
  over an empty housing, and both games clear the 3D background to black.)
- **A crash at Rowan's briefcase again:** the story run crashed as Route 201 came back after the starter was chosen
  (an undefined instruction in low memory), as on Nov 1: a sprite's texture (13 KB) didn't fit in the field map's
  heap and was read into a null buffer. A trace of every allocation in that heap found 15 KB of it held by the
  Pokégear's contact list window, which takes its pixels from the field's BG config's heap. The Pokégear's windows
  now come from its own heap (0x18000, nearly empty), as the rest of it does. The heap couldn't simply grow again: the
  application heap keeps 36 KB free while the field runs, and the wireless club's link takes 28 KB of it. On
  build_test2 the story test from Twinleaf Town passes the briefcase, with nothing failing in the field map's heap
  as Route 201 comes back; the release build boots (38,904 bytes of the main arena to spare). The story test has a
  new option, STEP_STATES, a save state after each action, to try what comes next on its own.

## Nov 5, 2026: one Town Map for all three regions, the Day Care's yard, and the gallery

- **One Town Map for all three regions (the owner's call, Nov 5):** the Town Map now shows Sinnoh as Platinum does and
  Johto and Kanto (HeartGold's map, from its Pokégear) on the sea to its south-west, on one canvas the view scrolls
  across (`docs/Features.md`, "The Town Map of three regions"; `src/applications/town_map/complete_town_map.c`, its
  graphics from `tools/complete/import_town_map.py`). Scrolled to Sinnoh it is Platinum's screen pixel for pixel; L
  and R switch regions, and the D-pad crosses over at the edges, onto the nearest place. Fly from the party menu
  opens it everywhere and goes only within the player's region: Johto's and Kanto's places each fly to the Indigo
  Plateau and Mt. Silver, and those fly to either. The new test (`tools/complete/test_town_map.py`, Fly as a player
  uses it from Violet City, the Indigo Plateau, Vermilion City and Jubilife City) passes all 33 checks on
  build_test3; the first run showed sea cells named "Mystery Zone", the crossing landing in the sea and L from
  Sinnoh opening on the sea, all fixed. The release build boots.
- **The Day Care's yard:** the Pokémon left at the Route 34 Day Care stand in its yard beside the house, as in
  HeartGold (its UpdateDaycareMonObjects, the house's init script; `src/overlay005/complete_daycare.c`), each as its
  walking sprite, and leave it when taken back. Its test (`tools/complete/test_hgss_daycare_yard.py`: a Pikachu and
  a Marill left there by the test build's breeding hook) passes on build_test3.
- **Gallery captures:** the boss battles are all shot (34 of 35 bosses, 34 to 55 shots each; Morty's battle started
  on Ecruteak Gym's dark floor and is redone from inside its door), and 85 of the 230 places; the rest are running.
- **Places off the overworld on HeartGold's map:** the Town Map names the places HeartGold's map puts on cells the
  overworld leaves to the sea (the Battle Frontier, the Pokéathlon Dome, the Sinjoh Ruins, the S.S. Aqua, Victory
  Road), from each map's world map position, as the Pokégear's map does. The Town Map test walks the cursor to the
  Battle Frontier (34 of 34 checks pass on build_test). Morty's gallery battle is shot (Ecruteak Gym stays shut
  until the Burned Tower's scene, so the capture opens it first): all 35 bosses are in. The feature sweep on
  build_test3 is under way; the old Fly test (12 of 12) and the follower test pass on it.
- **The feature sweep on today's build:** 38 of 39 of Complete's tests passed on build_test3. The other, the special
  events test, missed three events whose person or Pokémon wanders (the S.S. Aqua's assistant for the Phione and
  Manaphy, Union Cave's Friday Lapras): on this run they had stepped off their tiles when the test talked, and for
  events with no battle the test took "nothing happened" for a pass's start. It now waits and talks again, and warps
  back now and then, as the gifts test does for its wandering givers: the three pass (the game was fine; the same
  three fail the same way on yesterday's build_test2 today).
- **The gallery is complete:** all 230 places in Sinnoh, Johto and Kanto have their photos (up to 30 each, from the
  test warp to spots spread over each map) and all 35 bosses their battles, on the progress page's Gallery tab.
- **The long checks on today's build:** the hidden items test found 240 of 243 as before but one, in Violet City,
  where a wandering boy had stepped onto the item's tile, so A talked to him (as it would in HeartGold). The test now
  warps back and tries again a little later when a wanderer is in the way: Violet City's two items pass.
- **The boss Megas test, again from fixed seeds:** 49 of 50 bosses Mega Evolved on today's build; Erika's Victreebel
  didn't, here or on the Nov 3 build where it had passed. Her AI switches her Pokémon about (Jumpluff's U-turn) and
  sends Victreebel in too late to Evolve before the god-mode battle ends, with tonight's random numbers (from the
  clock). The test now fights a boss again from two fixed seeds when the first battle shows no Mega: Erika's Victreebel
  Mega Evolves, and the long checks (wild encounters, hidden items, tile behaviors, placements, sound memory) pass.
## Nov 6, 2026: Ally Switch, Sovereign's tests rerun, and the owner's answers

- **Sovereign's own tests after Sinnoh's level move:** the rare wild Pokémon test (`tools/test/rare_wild.py`) still
  expected Sovereign's levels (Guzzlord Lv. 65); since Nov 1 Sinnoh's maps make them at Sinnoh's levels after Kanto
  (Lv. 91), as planned. The rare wild, roamers and gifts tests now read the level map from the generated header
  (`tools/complete/sinnoh_levels.py`, rounding as `CompleteSinnoh_Level` does; `gen_sinnoh.py` now rounds the same
  way): the rare wild test passes 26 of 26.
- **A Paradox Pokémon at the shown Pokémon's level:** the Mining Museum's dealers give it at the level of the
  present-day Pokémon shown to them, but on Sinnoh's maps every `GivePokemon` moves its level up, so a Lv. 50 one
  would have brought a Lv. 85 Paradox Pokémon. They use `CompleteGivePokemonAtLevel` now, which keeps the level.
- **Ally Switch and the Pledge moves (the owner asked):** neither works. Ally Switch has Splash's effect ("But
  nothing happened!") for the 21 species that learn it; the three Pledges are plain 80-power hits, and nothing learns
  them. The same is true in Sovereign. Ally Switch is being made to swap the two Pokémon in double battles; the
  Pledges' combinations wait on whether anything should learn them (the progress page's questions).
- **Ally Switch works** (docs/Features.md, "Ally Switch"): in a double battle the user and its ally trade places,
  each Pokémon taking its own state along and every record of a battler following the Pokémon
  (`src/battle/complete_ally_switch.c`); both positions are redrawn in place (sprites with a front sprite's shadow and
  Illusion's look, health boxes, substitute dolls); it shares Protect's chain as in Gen IX. Built and boot-checked;
  two battle cases (`ally_switch`, `ally_switch_single`) run next on a test build.
- **Sovereign's battle mechanics suite on today's build: 469 of 526 matched; the 57 others were two test-build
  changes of Complete's, not the battles.** (1) Since Nov 1 the test build heals the party before each god-mode battle
  (for the story test's long run), which undid the cases that start the lead at part HP (Shore Up, Stuff Cheeks, Flail,
  the Heal Block checks): it now heals only when no harness set the lead's HP. (2) The double-battle cases fight
  Sovereign's Sinnoh trainers (Twins Liv & Liz, Belle & Pa), whose teams now come at Sinnoh's levels after Kanto: the
  suite now sets `gCompleteTestSovereignLevels`, so they keep Sovereign's levels, as the cases were recorded. The gifts
  test passes 45 of 45 (each gift at Sinnoh's levels, the Paradox Pokémon at the shown one's level).
- **The battle suite again:** the 57 battles replay as recorded (57 of 57), and Ally Switch's two cases are recorded
  (`ally_switch`: they trade places, then a second use in a row fails, then a third works; `ally_switch_single`: "But
  it failed!"). Screenshots of the switch: the progress page's Gallery tab.
- **Roamers in three regions:** since Nov 1 Tornadus and Thundurus roam Johto and Zeraora, Glastrier and Spectrier
  Kanto, so Sovereign's roamers test (which flies over Sinnoh) never met them. It leaves them to
  `tools/complete/test_hgss_roamers.py` now, which releases, meets and battles them in their regions with HeartGold's
  four (their status in Sovereign's `VAR_ROAMING_*_STATE`).
- **A playtest build for the owner:** `tools/complete/make_playtest_patch.sh` builds `decomp/build_playtest` (meson
  option `complete_playtest`, `src/complete_playtest.c`) and writes an `.xdelta` from a clean Platinum (US) dump. It's
  the release game, but a new game starts with Champion Cynthia's Garchomp (Lv. 80: Earthquake, Outrage, Stone Edge,
  Swords Dance, Yache Berry), Staraptor with Fly and Empoleon with Surf (Lv. 50), and every town's Fly point in the
  three regions, and Fly and Surf need no badge; badges and the story are untouched. Checked in the emulator from
  Rowan's intro: the party and moves, Fly from New Bark Town to Cianwood City, Surf there with no badge.
- **Fly crashed once many of Johto's and Kanto's towns were reached:** the Town Map's sprite manager had room for
  Platinum's 20 Fly markers, the player and the places last visited, and HeartGold's Fly points were added on top, so
  past the few free slots a marker came back NULL and the game crashed as Fly opened the map (as it would have for a
  player who reached Sinnoh after Johto and Kanto). It has room for HeartGold's 30 now, and the Town Map's heap is
  16 KB bigger for them (it was nearly full: the three regions' map graphics load into it; the application heap has
  about 820 KB free while the Town Map runs).
- **The POKéMON option in the start menu** showed only once Sinnoh's starter variable was set (Rowan's briefcase on
  Route 201), which Elm's starter doesn't set (`VAR_HGSS_PLAYER_STARTER`): it shows with any Pokémon in the party now.
  (The story test's test party had hidden this.)
- **Johto's and Kanto's trainers drew as dots in battle** (the owner's playtest, Elite Four Will): every HeartGold
  class's front picture was a 4-bit PNG (nitrogfx's own output in `import_hgss_trainer_classes.py`), and the build
  converts each class's picture with `-convertTo4Bpp`, which reads it as 8-bit, so every other pixel drew. Sovereign's
  105 classes keep 8-bit PNGs; the 68 HeartGold ones are 8-bit now (the same pixels and 16 colors), and the importer
  writes them so. Will, Falkner, Koga and Youngster Joey draw right on build_test.
- **The owner's notes from the playtest, first fixes:** the bedroom TV's comment says Rowan has returned to Sinnoh from
  the Johto region (it said Kanto), and Mom says "Professor Elm has a gift for you" (it said "Elm"). All 68 of
  HeartGold's trainer classes were battled on build_test after the picture fix: each draws right. The starter scene
  passed with Chikorita and Cyndaquil, with parties of one to three, and with a nickname given (the naming screen and
  back), so the freeze the owner saw after choosing a starter isn't reproduced yet. Two Poké Balls on Elm's table is
  the playtest's party (the lab shows two when the party isn't empty), and "received GARCHOMP from Professor Elm" names
  the party's lead, the starter in a real game.
- **The owner's playtest notes still open (Nov 6, 2026):** the freeze after choosing a starter (not reproduced on
  build_test; asked the owner for details); the person who leaves Elm's lab has the male player's sprite; the
  following Pokémon appears inside the door as the player walks out of a building; Johto's and Kanto's Pokémon Centers
  show no Poké Balls on the healing machine; the S.S. Aqua's sailing scene is Platinum's icebreaker; the Mega
  Evolution animation and the Mega icon look bad (later; the owner will redo the stone shown on screen). The owner was
  given a release build (`decomp/build`, from a clean Rev 1 dump) to play through.
- **The S.S. Aqua's guard with no sprite** (the owner's note, Nov 6): on B1F, the first voyage's step-on scene has a
  sailor ask the player to find his buddy, but he belongs to the group of the ship's people that only Olivine's
  first-voyage boarding shows (FLAG_HGSS_UNK_22A clear). Vermilion's port sailor always showed the other group, so a
  first voyage from Vermilion (Kanto reached first, as the owner's playtest Fly allowed) played the scene with no one
  there. Vermilion's sailor now shows Olivine's first-voyage group while the first voyage isn't done
  (VAR_HGSS_SCENE_SS_AQUA below 7; the translator's `FIRST_VOYAGE_GROUP`, written into `scripts_hgss_0154.s` too, as
  the translator needs Sacred Gold's ROM to run). Checked on build_test through Vermilion's port building (the ferry
  test warps onto the dock past it), and the ferry test passes (12 of 12).
- **The owner's requests (Nov 6), not started:** in a double battle, when one move makes both foes faint, the EXP
  lines after both "fainted" lines, one per Pokémon for both foes together (up to 6 lines, not 12); faster HP bar
  animations (the gauge's step, `UpdateGauge` in `src/battle/healthbox.c`); the double battle's Poké Ball indicators
  of each side's party don't follow which Pokémon are left. Pokéfans Georgia (5 Pokémon) and Jeremy (3) on the
  S.S. Aqua see the player together, so they battle as one double with 8 Pokémon, as in HeartGold; the indicator has 6
  slots a side.
- **Faster HP bars** (the owner's request): the bar moves 2 pixels each time the healthbox redraws it (every other
  frame), whatever the Pokémon's HP, so a full bar takes 0.8 s (`COMPLETE_HP_GAUGE_PIXELS_PER_FRAME`,
  `src/battle/healthbox.c`). Platinum moved it one HP per redraw above 48 HP: on build_test, a third of a Lv. 100
  Blissey's bar took about 8 s before and 16 frames now. The EXP bar is unchanged.
- **The S.S. Aqua: the cruise or straight there** (the owner's design, Nov 6): after the first voyage, the sailor at
  Olivine's or Vermilion's gangway asks "Where to? A cruise on the S.S. Aqua, or straight to port?": S.S. AQUA CRUISE
  boards the ship as before, the other port's name is Platinum's boat scene and then that port's dock (where Canalave's
  ships land), and Canalave City stays once Sinnoh is open (`CommonScript_CompleteFerry`). The ferry test's four new
  cases pass with the twelve before (16 of 16 on build_test). The owner also scrapped the following Pokémon
  (`docs/Roadmap.md`; issue 1 of `docs/PlaytestIssues.md`, handed to the Sovereign Platinum session).
- **The owner's answers to all 23 questions** are in `docs/Roadmap.md` ("The owner's answers"), with the work split:
  the playtest session takes the playtest notes (`docs/PlaytestIssues.md`, the following Pokémon turned off, the
  playtest patch); this session takes the rest. The playtest session's branch is merged into main. The owner
  confirmed the Mega Stones that Sinnoh's former HM givers will give.
- **Sinnoh's Elite Four already has Sovereign's format** (two single and two double battles, Cynthia a double battle;
  Sovereign's `docs/EliteFourFormat.md`), as it came with Sovereign's engine; the Indigo Plateau gets it next.
- **A test hook for a trainer's whole team as the player's party** (`gCompleteTestPartyFromTrainer`, the next test
  warp; `tools/complete/record_battle.py --party-from`), and double battles played by the battle recorder: for the
  owner's final boss team (Sovereign's developer team) against Cynthia.
- **Sinnoh's top levels lowered (the owner's call):** the level plan's points are Sovereign's 78 → 89 and 89 → 96
  (they were 96 and 100): Cynthia Lv. 89, her rematch 95 to 96, the Elite Four 87 to 88 (rematches 92 to 95); Roark
  stays at 72. The level caps follow. The owner's note, written down: the Elite Four's rematch teams slightly better
  than their first teams.
- **Every map walked (`tools/complete/test_walk_everywhere.py`, the owner's call):** the story test walks only the
  story's way, so a new test warps to each map and walks onto every tile reachable on foot, noting refused steps,
  what starts on the way, map changes and hangs, with screenshots for review. New Bark Town: 347 of 347 tiles. All of
  Johto's and Kanto's 518 maps (242,756 tiles) are being walked on build_test4; Sinnoh's next.
- **The progress page's Possible issues tab:** anything that looks off in Claude's tests and screenshots is logged
  there for the owner, even when it may be nothing (the owner's rule, after the trainer pictures drawn as dots that
  Claude's own gallery shots had shown).
- **Aces a level over their teams (the owner's call):** the level move kept each Pokémon's order only loosely, so a
  boss's ace landed on its team's level. Now a Pokémon Sovereign put below another stays at least a level below it,
  the ace keeping its moved level (`CompleteSinnoh_ScaleParty`; the caps follow, `gen_sinnoh.py`): Roark 71 with his
  ace 72, Cynthia 88 and 89, her rematch 95 and 96. The Sinnoh Elite Four's rematches (singles and doubles) and
  Sovereign's trainer are flat, all at their ace's level (`flat_teams` in `data/complete/sinnoh.yaml`).
- **The player is Ethan or Dawn (the owner's call):** the boy is HeartGold's Ethan, the girl stays Platinum's Dawn
  (`tools/complete/import_hgss_player.py`; `docs/Features.md`, "The player"). Every pose the field draws the boy in is
  Ethan's: walking, running, the bike, surfing, fishing, saving and the Pokémon Center's counter from HeartGold's own
  sprites, and the four poses HeartGold never drew him in (a field move's raised Poké Ball, the Pokétch, the
  Sprayduck, the VS Seeker) with Lucas's arm and item moved onto him. Rowan's assistant keeps Lucas's look
  (Platinum drew the assistant with the player's graphics: he has his own now, in the 17 lines of the scripts that
  show him). In battle the boy throws with Ethan's back, and the Hall of Fame shows Ethan's picture; Platinum's
  player classes stay Lucas and Dawn for the assistant, who partners the player in Jubilife's and Veilstone's tag
  battles. HeartGold's tag partners got their own backs too: Lance and Silver had stood there with Lucas's.
- **Box and party icons from Pokémon Showdown (the owner asked):** a sample of 20 converted icons sent to the owner
  (`docs/Roadmap.md`): far better than the placeholders for Gen 8 and 9, and real icons for regional forms and Megas;
  the DS's three shared icon palettes are what limits the colours.
- **The owner's note on the Totems' overworld sprites:** to look like the other overworld Pokémon (Dialga, Palkia,
  Uxie) and stay large, not shrunk battle sprites (`docs/Roadmap.md`).
- **Ethan flies as himself:** the Fly take-off's cut-in and the landing draw HeartGold's own rider for him (the boy in
  HeartGold's cut-in archive, which Lance's take-off already used). The Town Map test flies across all three regions
  with it (0 problems), and the gallery shows him in the cut-in.

- **The Indigo Plateau's Elite Four in Sovereign's format (the owner's call):** two single and two double battles
  among Will, Koga, Bruno and Karen, chosen as Sinnoh's League chooses them, and Lance a single battle; with the
  rematch teams Will first offers all singles, all doubles, or two and two (`docs/Features.md`). Each member's
  double-battle team is their own team with the doubles AI, and keeps the Elite Four's music.
  `tools/complete/test_hgss_indigo_e4.py` plays eight runs through the formats: all eight pass, each battle with the
  right member, format and team.
- **Trade evolutions without trading (the owner's call):** a trade's held item evolves the Pokémon when it's used on
  it from the bag, as a stone does (Onix's Metal Coat and the rest, twelve species; the item is used up and keeps its
  held effect), and a trade with no item (Kadabra, Machoke, Graveler and Alolan Graveler, Haunter) is also a level-up
  evolution at Lv. 37. Sacred Gold's Covenant Orb still evolves those at any level. In code, the species' data left
  as Sovereign's (`include/complete_evolutions.h`; `tools/complete/trade_evolutions.py` gives the items the stones'
  field use). `tools/complete/test_trade_evolutions.py` uses each item, a Rare Candy and the Covenant Orb from the bag
  through the menus: 22 of 22 cases pass (a wrong item is refused and stays in the bag; Lv. 36 doesn't evolve).
- **The HMs (the owner's call):** HM05 is Whirlpool, as in HeartGold (Lance's gift after the Rocket Hideout): its
  description, the Water colours, and HeartGold's own list of who learns it for its 493 species; the later species and
  the forms learn it if they learn Surf by HM03 (a rule that misses none of HeartGold's list). Defog is a new HM09,
  in the Solaceon Ruins' item ball where Platinum had its HM05, and every Pokémon that learned Defog by HM05 learns it
  by HM09 (`tools/complete/hm_moves.py`). HM09 is the last item, so no item's number moves and saves keep their bags.
  HM moves were already forgettable (Sovereign's rule). `tools/complete/test_hms.py` teaches both from the bag through
  the menus: 6 of 6 cases (a Pokémon that can't learn one is refused, and the HM stays in the bag); the Whirlpool
  test still crosses Dragon's Den's whirlpool with HM05 in the bag.
- **Sinnoh begins in Canalave City (the owner's call):** the first ship to Sinnoh lands there, and Rowan and his
  assistant meet the player on the dock and invite them to his lab in Sandgem Town (`docs/Features.md`, "Sinnoh's
  opening"). Platinum's Twinleaf opening is marked done as its own scripts leave it; Route 218's blockade and its
  gate's policeman no longer stop anyone; Jubilife's welcome and Route 202's assistant wait for the lab; Barry's
  drawbridge battle waits for Fantina's badge. In the lab Rowan opens his briefcase (the starter at Sinnoh's levels,
  to the PC with a full party), then the Pokédex; outside he hands over Barry's Parcel. The ferry test (16 of 16) and
  the story test's new Sinnoh start (from the Vermilion gangway through Canalave City, Route 218, the lab, the Parcel,
  Route 202, Jubilife, the Trainers' School, the Pokétch, Route 203, Oreburgh and Roark's mine) pass.
- **The Town Map from Cherrygrove City (the owner's call):** the Guide Gent gives it with the Map Card; Barry's parcel
  at Jubilife's Trainers' School holds Altarianite instead (Claude's pick, for the owner to confirm).
- **No following Pokémon (the owner's call):** switched off, the code kept (`COMPLETE_FOLLOWER_ENABLED` FALSE in
  `include/complete_follower.h`): nobody follows the player, and the scripts that move the follower carry on as with
  the player on the bike. The new test builds' bedroom shows the player alone.
- **Mega Stones from Sinnoh's HM givers (the owner confirmed the list):** Cynthia Garchompite Z, the Galactic
  Warehouse Staraptite, Cynthia's grandmother Galladite, Riley Lucarionite, the Oreburgh Gate's hiker Excadrite,
  Crasher Wake Sharpedonite, Candice Froslassite, each with a line on what the stone does; the HMs all come from Johto
  and Kanto. Found on the way: Snowpoint's Regigigas story took HM08 in the bag as Candice's thanks, so the player's
  own HM08 from Kanto skipped it; a flag (`FLAG_COMPLETE_REGIGIGAS_CALMED`) is the record now.
- **The owner's note:** Sinnoh needs people where its HMs used to hold the player back (`docs/Roadmap.md`).
- **Showdown's icons for every Pokémon (the owner's call):** #1–1025 now use Pokémon Showdown's box icons, converted
  to the DS's icons in the three shared palettes (`tools/complete/import_showdown_icons.py`): 712 changed, the rest
  were the same PokeAPI icons already. Checked in the party menu on the test build; the forms come next.
- **The forms' own icons:** each of Sovereign's 383 forms has its own box icon now, 365 of them Showdown's (Alolan
  Vulpix, Paldean Wooper, the Megas, Totems, Pikachu's caps...), the rest their species'. They're appended to the icon
  archive in Sovereign's packing order, so a form's icon is found from its place in that order
  (`Pokemon_SovereignFormIndex`), with a 96-byte palette table. Checked in the party menu with an Alolan Vulpix and a
  Paldean Wooper leading; the boot check passes.
- **The Rapid Ferry (the owner's call):** the ferry network's trips other than the S.S. Aqua's cruise are the Rapid
  Ferry now in the sailors' words ("a cruise on the S.S. Aqua, or the Rapid Ferry straight to port?"): no passengers
  to battle, Platinum's Iron Island boat scene, between Olivine, Vermilion and Canalave City. The ferry test passes
  (16 of 16). The story test's JUMP gives Johto's HMs (a real save has them), so Sinnoh's parts after the HM givers
  run as a player's would.
- **The Pal Parks (the owner's call):** the regional forms live in two Pal Parks (`data/complete/pal_parks.yaml`,
  `tools/complete/gen_pal_parks.py`, `docs/PalParks.md`). Kanto's, HeartGold's Pal Park by Fuchsia City, is open
  from the start with no Catching Show: the receptionist walks the player in, the gate's step and the hiker ask before
  seeing them out; Alola's forms live in its west's tall grass, Galar's in its east, their water forms in the pond and
  lake. Sinnoh's, Sovereign's Regional Forms Park, has Hisui's forms in the forest and on the mountain, Paldea's in
  the field and at sea; its worker, signs, welcome and keeper's log say so. Every regional form is in one park (Sinnoh's
  has 22 kinds to Kanto's 37: a question for the owner). The Kanto park takes Platinum's park table for its rates, so
  Johto's and Kanto's table reader leaves it out (`CompleteEncounters_HasHGSSTable`). Tested
  (`tools/complete/test_pal_parks.py`): the walk in and out, and 64 encounters per quadrant and terrain in both parks,
  every one a Pokémon of its zone at a level in its range (Sinnoh's moved up with its levels).
- **Fly to and from the Sinjoh Ruins (the owner's call):** once the player has been to the Ruins, Fly reaches them
  from anywhere in Sinnoh or Johto (Mt. Silver and the Indigo Plateau too, not Kanto), and from the Ruins it reaches
  Johto's Fly points and Sinnoh's. A 31st Johto and Kanto spawn point (`SPAWN_HGSS_SINJOH_RUINS`) with the Fly flag
  after HeartGold's last, Fly allowed on the Ruins' grounds, and the Town Map's rules (`src/complete_map_info.c`,
  `CompleteTownMap_CanFly`). Tested (`tools/complete/test_sinjoh_fly.py`, 0 problems: no point before a visit; from
  Jubilife the Ruins and nothing else of HeartGold's, and the flight there; from the Ruins Johto's and Sinnoh's, and
  the flight to Jubilife; none from Vermilion; from the Indigo Plateau and Violet City, and the flight); the Town Map
  test still passes.
- **People where Sinnoh's HMs held the player back (the owner's note):** a survey of every Sinnoh map's tiles against
  the story's order found five places where Johto's and Kanto's HMs open a way early: Mt. Coronet 1F South's climb to
  Spear Pillar, Lake Acuity before Candice (whose Jupiter scene opens the Galactic HQ), Eterna Forest by Surf before
  the Valley Windworks, the Ravaged Path before Roark, and Mt. Coronet's boulder to Celestic before the Psyduck. People
  now stand at each (`tools/complete/sinnoh_blockers.py`), and go at the point Platinum would have let the player
  through (`src/complete_blockers.c`, as each map loads); Route 221's workers keep the Pal Park lobby until the Fen
  Badge. Tested (`tools/complete/test_sinnoh_blockers.py`): each group stops the player and talks, then is gone.
  Found on the way: a test build linked with plain `ninja` after a `main.lsf.in` change left the new file out of the
  linker spec (`platinum.us/main.lsf` is the Makefile's), and the game froze on a new game; noted in CLAUDE.md. The
  story test's JUMP now gives the Bicycle too (Eterna's exits reopen only with it), and its Sinnoh run is past
  Hearthome City.
- **The Pledges (the owner's call):** a tutor in Professor Elm's lab teaches every starter of Gen I to IX, at every
  stage, its own type's Pledge (`CommonScript_CompletePledgeTutor`, its list of starters from
  `tools/complete/pledges.py`), and the Pledges combine as in Gen VI on (`src/battle/complete_pledges.c`): in a double
  battle the first of two allies with different Pledges waits for the other, who acts next with the combined Pledge
  (150 power, STAB, the pair's type), which leaves a sea of fire (Fire and Grass: the target's side's non-Fire Pokémon
  lose 1/8 of their HP at each of its 4 turns' ends, the last too, before it ends), a rainbow (Water and Fire: the user's side's added effects twice as likely) or a
  swamp (Grass and Water: the target's side's Speed quartered) for 4 turns, with Platinum-style lines for each. Tested:
  the tutor (`tools/complete/test_pledge_tutor.py`: Turtwig learns Grass Pledge through the menus, Garchomp is
  refused) and five battle cases (`tools/test/battle_mechanics.py pledge_*`: each field's start, its turns and its
  end, the same Pledge twice and a single battle as plain hits).
- **HeartGold's photo album (the owner's call: every HeartGold feature ported):** Cameron the photographer's photos
  (66 photos on 59 maps) go in an album: asked for a photo, he walks the player to the spot, the map loads again with
  only the player and the party in HeartGold's photo camera, the viewfinder comes up and the shutter clicks
  (`src/complete_photo.c`, HeartGold's field_take_photo.c). The Pokémon Center's PC gains PHOTO ALBUM under the
  player's PC once there's a photo: HeartGold's album app (overlay 109, `src/applications/complete_photo_album/`, with
  Voltorb Flip's list menu), where a photo is viewed, moved or deleted; a photo viewed shows again as it was taken (the
  map at its spot, the hour it was taken, the player as they were) with HeartGold's caption and buttons on the bottom
  screen (`src/applications/complete_photo_caption/`). The album has its own save sector after the battle videos, so
  earlier saves still load. Its data from HeartGold (`tools/complete/import_hgss_photos.py`). Tested
  (`tools/complete/test_photo_album.py`, 0 problems: the photo on Route 1, the album from Cherrygrove's PC walked up
  to, the photo viewed, back to the album, out to the PC, the player where they stood). Found on the way and fixed:
  the photo's bottom screen printed with a font the field never loads (the game crashed as the photo's map started;
  found by tracing every call in the emulator); the PC's entry read "RULES" (Platinum's list-menu command kept text
  IDs in a byte, and the album's is 296; only the album's texts were past 255); the way back from a photo was where
  the player came into the Pokémon Center, not where they stood; and HeartGold's `ManagedSprite_SetPriority` (a BG
  priority) means the draw order in Platinum, so the album's EXIT button hid its text. The same name had been carried
  into Voltorb Flip (the flipping card) and Arceus's cinematic; all three now set the BG priority (noted in
  CLAUDE.md). The Sinnoh story test's Route 218 gate check still expected the Tea from before Canalave opened first;
  fixed, and two of its parts shared a name.
- **HeartGold's Berry Pots (the owner's call: every HeartGold feature ported):** the key item the girl on Route 36
  gives opens HeartGold's screen (its overlay 17 in C, `src/applications/complete_berry_pots/`, with Voltorb Flip's
  list menu compiled again under the pots' names), from the bag or registered to Y. A manager in the main module
  (`src/complete_berry_pots.c`, HeartGold's overlay 16) runs the screen, and, for FERTILIZE or PLANT BERRY, Platinum's
  bag at its Items or Berries pocket in gardening mode, then the screen again with what was chosen. HeartGold's growth
  rules (`berry_pots_growth.c`) on four of the save's berry patches Sinnoh doesn't use (124 to 127); their time is in
  Complete's phone save, so no save block changed size. Its graphics, texts and two sounds from HeartGold
  (`tools/complete/import_hgss_berry_pots.py`, message bank 248, `SEQ_SE_GS_KP01`/`MIZU`). Tested
  (`tools/complete/test_berry_pots.py`, 0 problems: Mulch and an Oran Berry through the bag, two hours on and WATER,
  sixteen hours on and TAKE BERRIES, back on the field, then USE from the bag and back to it); the release build
  boots, and the sound memory test passes (5 of 5 parts, with the pots' two sounds). Found on the way and fixed: the
  screen froze the game as it closed. The emulator showed every interrupt calling the VBlank handler thousands of times
  a frame; the OS's interrupt handler had been overwritten in ITCM, through address 0x24 (ITCM mirrors at 0): a heap
  free had followed a garbage pointer. The port loads the pots' first sprite manager by capacities (one resource at a
  time) where HeartGold loads it from resource lists, but still freed it the lists' way, freeing the unset table
  pointers; it's now freed as it's made, and the sprite list the two managers share is deleted once. The pots' soil
  drew black: Platinum's sprite-from-header always sets the template's palette, where HeartGold's palette mode 1 keeps
  the cell's own; the pots' compat header now honours the mode. And Platinum's new game fills all 128 berry patches
  from its table of 118 (a vanilla overrun), leaving the pots' patches with Berries numbered as high as 108 (there are 64) and
  yields of 542 or 65535: the pots are emptied the first time they open (their time still unset), for new games and earlier
  saves.
