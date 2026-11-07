# Notes for Claude sessions

## Status

Work started on Oct 29, 2026, on the owner's go-ahead, while Pokémon Sovereign Platinum
([hanktwichell/pokemon-imperial-platinum](https://github.com/hanktwichell/pokemon-imperial-platinum)) is still being
finished. Step 1 (groundwork) is under way. The plan, estimates and decisions are in `docs/Roadmap.md`: keep it up to
date when the owner decides something. `docs/Progress.md` is the running log: add an entry at the end of each piece of
work.

## Repository layout

- `decomp/`, `tools/`, `data/`, `assets/`, `CITATIONS.md`: Sovereign Platinum's engine, copied at the commit in
  `SOVEREIGN_COMMIT`. Bring in Sovereign's later changes with `tools/complete/sync_sovereign.sh`, never by copying
  files by hand. Keep Sovereign Complete's own changes to these files small and mark them with a
  `Sovereign Complete:` comment, so syncs stay clean. Sovereign's JSON data can't hold a comment: Complete's edits
  there are made by a script that is their record (`tools/complete/trade_evolutions.py` for the trade items' field
  use, `tools/complete/hm_moves.py` for HM05 Whirlpool, HM09 Defog and the species' HM lists,
  `tools/complete/import_showdown_icons.py` for every species' and form's icon, `tools/complete/gen_pal_parks.py` for
  Sinnoh's Pal Park's texts and Pokédex area, `tools/complete/sinnoh_blockers.py` for the people where Sinnoh's HMs
  held the player back); rerun it if a sync clashes on those lines. Rerun the icons' importer after `tools/engine/gen_forms.py` changes the forms (a build error says so).
- `tools/complete/`: Sovereign Complete's own tools. A sync never touches them.
- `decomp/res/sound/complete/`: the sound archive the build uses, made from Sovereign's (`res/sound/`) by
  `tools/complete/split_sound_basic.py`, with HeartGold's songs from `tools/complete/import_hgss_sound.py` (run it
  first) in `hgss/` (docs/Music.md). Both need a build's `nitrosfx`. Don't edit it by hand; the sync script remakes it.
  The importer also takes each HeartGold sound effect (`SEQ_SE_GS_*`) Sacred Gold's scripts, `decomp/src` or
  `decomp/res/field/scripts` name, so rerun it after naming a new one, then `split_sound_basic.py`, then
  `ninja -C <build> res/sound/pl_sound_data.naix` before the build (the scripts link against it, built in no order).
  Each archive entry stays in sound memory (about 32 bytes a bank), and the title song needs nearly all of it: run
  the sound memory test (`sound_heap`) after adding sounds. They load into sound memory as they play (`src/complete_sound.c`,
  `CompleteSound_LoadOwnEffect`). `translate_hgss_scripts.py` reads the sound names from the release build's
  `res/sound/pl_sound_data.naix` (`ninja -C decomp/build res/sound/pl_sound_data.naix` after an import). Run it
  as `--install --from .cache/sacredgold/scr_seq [FILE_STEM ...]`: without `--from` it translates HeartGold's own
  scripts, not Sacred Gold's.
- `HEARTGOLD_COMMIT` and `tools/complete/build_heartgold.sh`: HeartGold from pret/pokeheartgold, and Sacred Gold from
  Drayano's patch, both built into `.cache/`.
- `Sacred Gold & Storm Silver V1.05 5/`: Drayano's patches and documents, unchanged.
- `.cache/` (ignored by git): the HeartGold source, the built games, the Sovereign checkout for syncs, build logs.

## Building

- `make -C decomp rom` builds `decomp/build/pokeplatinum.us.nds`. Dependencies are in `decomp/INSTALL.md`; on Linux:
  `bison flex g++ gcc-arm-none-eabi make ninja-build pkg-config wget python3 xz-utils nasm libc6:i386 libpng-dev`, and
  `xdelta` (XDelta 1.1.3; Drayano's patches are in the XDelta 1 format, which xdelta3 can't read) for the HeartGold
  script. The emulator tests need `pip install py-desmume pillow pyyaml` and `libgl1 libglib2.0-0t64 libx11-6`.
- In cloud sessions the network proxy refuses GitHub's source-archive downloads (`github.com/<owner>/<repo>/archive/...`).
  Meson then falls back to each wrap's `source_fallback_url` (the wrapdb mirror), which is allowed, after several
  retries. To skip the retries, put the tarball from the fallback URL into `decomp/subprojects/packagecache/` first,
  named as the wrap's `source_filename`, and check it against `source_hash`.
- `tools/complete/build_heartgold.sh` builds `.cache/heartgold.nds` (the retail HeartGold US ROM, checked by SHA-1)
  and `.cache/sacredgold.nds` (Sacred Gold, Complete version, checked against the MD5 the patch records for it).
- The owner's playtest: `tools/complete/make_playtest_patch.sh CLEAN_ROM...` builds `decomp/build_playtest` (meson
  option `complete_playtest`: the release game, but a new game starts with Cynthia's Garchomp at Lv. 80, Staraptor
  with Fly and Empoleon with Surf at Lv. 50, and every Fly point, and Fly and Surf need no badge;
  `src/complete_playtest.c`) and writes an `.xdelta` for each clean Platinum (US) dump, as Sovereign's release patch.
  Clean dumps come from pret/pokeplatinum, cloned into `.cache/pret_platinum` and built with
  `make BUILD=build_rev1 ROM_REVISION=1 rom` (and `0`; SHA-1s `0862ec35…` and `ce81046e…`). Its yyjson wrap fetches a
  WrapDB patch the proxy refuses: copy `decomp/subprojects/yyjson.wrap` and `packagefiles/yyjson/` into its subprojects.
- Boot check: `python3 tools/test/boot_smoke.py decomp/build/pokeplatinum.us.nds .cache/smoke` (with
  `SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy`).
- Story check: `tools/complete/test_hgss_opening.py` plays a new game from New Bark Town as a player would, part by
  part through Johto's and Kanto's stories to the ferry to Sinnoh (hours; run it in the background, with `TEST_BUILD`
  set for a test build other than `build_test`). Its save states let a part be rerun on its own (`FROM`, a part's
  name). The ways through Azalea Gym's carts, Ilex Forest's Farfetch'd, Mahogany Gym's ice blocks, Ice Path B1F's
  boulder and Blackthorn Gym's floors come from `tools/complete/solve_story_puzzles.py`; its walks slide over ice and
  along Viridian Gym's arrows themselves.
- Sacred Gold's one-time encounters (its Special Event Guide): `tools/complete/test_hgss_special_events.py` checks
  each battle's Pokémon, level and shininess from the test build's record of each scripted wild battle
  (`gCompleteTestScriptedWild`, set in `CreateWildMon_Scripted`), and the steps that unlock them.
- All of Complete's emulator tests: `TEST_BUILD=build_test3 python3 tools/complete/run_tests.py` (two at a time, from a
  bedroom state it makes on that build; the long ones with `--all` or by name). Summary in `.cache/tests/BUILD/`.
  Never rebuild a test build while a test runs on it (build the next change into another test build), and make a new
  bedroom state after each rebuild: a state made on another build of the ROM, or a ROM changed under a running test,
  can hang the game or fail at random.
- Main memory is nearly full: the boot carves fixed heaps (`sHeapInitParams`, `src/system.c`, plus a random 0-252
  bytes) out of what the main module's code and data leave, and the test build, with its test code, had a few
  hundred bytes left. Past that the last heap doesn't fit and the ROM shows a white screen at boot (no title; the new
  bedroom state is then a dead one, at (0, 0)). Read what's left with the main arena's pointers at 0x027FFDA0 (low,
  then high nine words on) after a few frames; keep big tables out of the main module (in a NARC read as needed, as
  the Safari Zone's encounters are, or in an overlay).
- The field map's heap (`HEAP_ID_FIELD1`, 0xCC000 in the overworld, `sMapLoadMode` in `src/field_map_change.c`) is
  nearly full on a crowded map (Route 201's briefcase scene, with a big follower); a failed allocation there reads a
  texture into a null buffer and crashes later. It can't grow again (the application heap keeps 36 KB free while the
  field runs, and the wireless club's link takes 28 KB), so keep Complete's field-time buffers in their own heaps: a
  window on the field's BG config takes its pixels from the field map's heap (the Pokégear's `AddWindowFromHeap`).
- Battle videos: `tools/complete/record_battle.py` (a real battle from a room's scene, Cynthia's by default, with a
  given Mega lead and a Lv. 100 team; test build and a bedroom state) and `tools/complete/cut_battle.py` (a preview
  cut from its turn marks). SDL catches SIGTERM, so stop an emulator run with `kill -9` on its PID.

## Progress page

- The owner follows progress on a claude.ai page: https://claude.ai/artifact/7tr6iuoekaQj92qKSfR5JX (tabs: the whole
  game, since yesterday, maps and routes, the story test). `python3 tools/complete/progress_page.py` builds it from the
  repo into `.cache/progress/index.html` (maps, places, the story test's logs in `.cache`); the steps' status, next
  steps, open decisions and recent work are kept by hand at the top of that script. Republish that file with the
  Artifact tool, passing the URL, after each piece of work.

## Following Pokémon

- `decomp/src/complete_follower.c` (hooks in `src/field_map_change.c`; a test-only tile record in `src/field_system.c`).
  It never stands on the player's tile in view. As a map loads, the map's terrain isn't loaded yet
  (`fieldSystem->landDataMan` still points at the last map's freed data), so it's made hidden on the player's tile
  and moved beside them once the field runs. Never check tiles from the map-change hooks.
- `tools/complete/gen_follower_sprites.py` converts all 566 of HeartGold's walking sprites into one range of graphics IDs
  (`OBJ_EVENT_GFX_HGSS_MON_*`, from 2048): the field's lookups take each one's size's template entry and its own
  texture (`CompleteFollower_TemplateGfx`, `CompleteFollower_GfxNarcIndex`; marked hooks in `src/map_object.c`,
  `src/overlay005/ov5_021ECE40.c` and `ov5_021ECC20.c`). `tools/complete/show_followers.py` screenshots followers.
- The player is Ethan (boy) or Dawn (girl): `tools/complete/import_hgss_player.py` (the boy's field textures in
  `res/graphics/field_sprites/player/complete/`, Lucas kept for Rowan's assistant as `OBJ_EVENT_GFX_COMPLETE_LUCAS`,
  HeartGold's trainer backs, `include/data/complete_player.h` for the player's battle class). Platinum's
  `TRAINER_CLASS_PLAYER_MALE`/`_FEMALE` and `OBJ_EVENT_GFX_PLAYER_*` IDs stay: the IDs draw the player, the classes
  Lucas and Dawn as the assistant.
- HeartGold's people: `tools/complete/gen_hgss_people_sprites.py` (`OBJ_EVENT_GFX_HGSS_<NAME>` = 1024 + HeartGold's
  number; the mapping in `data/complete/hgss_sprites.json`, read by `import_hgss_events.py` and the script translation).
  Its 3D gimmick objects (doors, shutters, boxes, the Ruins of Alph's walls): `tools/complete/import_hgss_gimmicks.py`
  (the same numbering; their models in `fielddata/complete/gimmicks.narc`, loaded the first time a map draws one, in
  `src/overlay005/ov5_021F10E8.c`), then rerun `import_hgss_events.py --rom .cache/sacredgold.nds`.
- Test: build the test ROM (`tools/test/build_test_rom.sh`), then `python3 tools/complete/test_follower.py`. The emulator
  is slow here (about 10 minutes); run it in the background.
- Talking to it: `src/overlay006/complete_follower_talk.c` (HeartGold's interactions, motions and emote bubbles, from
  the archive `tools/complete/import_hgss_follower_talk.py` packs); test `tools/complete/test_follower_talk.py`.
- A new C file in an overlay's folder must also be listed in that overlay in `platinum.us/main.lsf.in`
  (`src/meson.build` is generated from it); otherwise it links outside the overlay and calls into it crash.
- `platinum.us/main.lsf` (the linker spec) and `src/meson.build` are made from `main.lsf.in` by the Makefile
  (`tools/scripts/lsfgen.py`), not by ninja: after changing `main.lsf.in`, build with `make` (or run lsfgen) before
  `ninja -C <build>`, or the new file's code gets no place in the ROM and calls into it freeze the game.

## HeartGold's apps

- Voltorb Flip: `src/applications/complete_voltorb_flip/` keeps HeartGold's code, and its `hgss_compat.h` (in
  `include/applications/complete_voltorb_flip/`) names Platinum's engine by HeartGold's names, with
  `require_prototypes` on, so an unmapped name fails to compile. Only the app's own files include it. Test:
  `tools/complete/test_hgss_voltorb_flip.py`.
- HeartGold's field effects from its `demo/legend` archive (all of it in `fielddata/complete/legend.narc`, from
  `tools/complete/import_hgss_legend.py`; `LEGEND_MEMBER(n)` is HeartGold's member n): the legendary cutscenes, the
  Rocket Hideout's traps and alarms, the monks' wings, Lance's take-off and the Ruins of Alph walls' tablet, in
  `src/overlay005/complete_legend_cutscene.c`. Tests: `tools/complete/test_hgss_legend_cutscenes.py`,
  `tools/complete/test_hgss_field_effects.py` (`ONLY`, `SHOTS`). The walls' item and Flash hooks:
  `CompleteAlph_CanOpenWall` (`tools/complete/test_hgss_alph_walls.py` uses items from the bag through the menus).
  Lance's take-off is Platinum's Fly cut-in (`src/overlay006/hm_cut_in.c`, `CompleteHMCutIn_StartLanceTask`) with
  HeartGold's Lance rider from `fielddata/complete/field_cutin.narc` (`tools/complete/import_hgss_field_cutin.py`).
- The legendary cinematics (Ho-Oh's, Lugia's, Arceus's): `src/applications/complete_legend_cinematic/` (HeartGold's
  overlay 106 in C; its models, Arceus's backgrounds and sprites and Arceus's script from
  `tools/complete/import_hgss_legend_cinematic.py`), started by `CompleteLegendCinematic` between the script's fades
  (it leaves the field map and brings it back). Tests: `tools/complete/test_hgss_legend_cutscenes.py`,
  `tools/complete/test_hgss_sinjoh.py` (the Unown circle and Arceus's).
- The Magnet Train's ride: `src/applications/complete_magnet_train/` (HeartGold's overlay 104, written in C from its
  assembly; its models from `tools/complete/import_hgss_magnet_train.py`), run by `CompleteMagnetTrain` between the
  script's fades. Test: `tools/complete/test_hgss_magnet_train.py`.
- HeartGold's own Balls (Fast to Park) are drawn as HeartGold numbers them, 17 to 25 (`Pokemon_BallToDraw`,
  `BALL_DRAW_HGSS_*` in `pokemon.h`), with HeartGold's throws, flash colours and summary icons
  (`tools/complete/import_hgss_balls.py`, into `res/graphics/battle/ball_throws/hgss/` and
  `res/graphics/pokemon_summary_screen/balls/hgss/`, at the end of each archive's `.order`). Test:
  `tools/complete/test_hgss_balls.py` (each throw's colours, the catch, the summary's icon).
- The Indigo Plateau's Elite Four in Sovereign's format (two singles, two doubles, Lance single): common scripts
  `CommonScript_CompleteIndigoE4Format`/`Announce` (0x81F, 0x820), called from the rooms by the translator's
  `indigo_e4_insert`; the doubles teams `TRAINER_COMPLETE_INDIGO_*_DOUBLES` follow HeartGold's trainers in
  `generated/trainers.txt` (import_hgss_trainers.py keeps them there) and record their members' singles flags.
  Test: `tools/complete/test_hgss_indigo_e4.py`.
- Johto's Battle Frontier runs Platinum's facilities (the lobbies' commands and vars map to Platinum's in
  `tools/complete/hgss_script_table.py` and `translate_hgss_scripts.py`). Test: `tools/complete/test_hgss_frontier.py`.
- The Pokégear: the field's bottom screen is the "no Pokétch" screen, the Pokétch or the Pokégear
  (`include/complete_pokegear.h`; the overlay `src/applications/complete_pokegear/`, in the Pokétch's place, with
  HeartGold's graphics from `tools/complete/import_hgss_pokegear_gfx.py`). Test: `tools/complete/test_hgss_pokegear.py`.
- Its radio: `src/applications/complete_pokegear/radio/` (HeartGold's shows, one file each, and the page); its music
  is the field's BGM, kept by `src/complete_radio.c` in the main module, which the encounter and script checks ask
  (`CompleteRadio_Music`). Test: `tools/complete/test_hgss_radio.py`.
- Its six skins: each graphic's six variants sit in a row in the NARC (`complete_pokegear.order`), loaded as the first's
  index + `CompletePokegear_GetSkin`; the importer packs each screen's tiles to fit a page's 128. Incoming calls ring
  (`CompletePhone_StartRinging`, main module) until the Phone button answers; the ring's limit is the clock's (the
  host's in the emulator), not frames.
  Test-only markers the tests read belong in the main module: an overlay's memory is reused by the next overlay.
- The Town Map of three regions: `src/applications/town_map/complete_town_map.c` (marked hooks in the overlay's
  `main.c`, `graphics.c` and `context.c`; the field's hand-off in `gCompleteTownMap`, `src/complete_map_info.c`), its
  graphics from `tools/complete/import_town_map.py` (`graphic/complete/town_map.narc`). Fly from the party menu opens
  it everywhere. Test: `tools/complete/test_town_map.py`.
- Names that mean different things in the two engines: HeartGold's `ManagedSprite_SetPriority`/`Sprite_SetPriority`
  set a sprite's BG priority (Platinum's `ManagedSprite_SetExplicitPriority`); Platinum's set the draw order
  (HeartGold's `SetDrawPriority`). A port that keeps the call by name draws the sprite over the text it should sit under.
- The photo album: `include/complete_photo.h` (the field's side in `src/complete_photo.c`, the album app in
  `src/applications/complete_photo_album/`, the photo's bottom screen in `src/applications/complete_photo_caption/`,
  which loads `FONT_SUBSCREEN` itself: the field doesn't). Test: `tools/complete/test_photo_album.py`.
- The Berry Pots: `include/complete_berry_pots.h` (the manager in `src/complete_berry_pots.c` runs HeartGold's screen,
  `src/applications/complete_berry_pots/`, and Platinum's bag in turn). Test: `tools/complete/test_berry_pots.py`.
  Two traps its port hit: Platinum's `SpriteSystem_DestroySpriteManager` frees a manager loaded from resource lists; one
  set up by `SpriteSystem_InitManagerWithCapacities` must go with `SpriteSystem_FreeResourcesAndManager` (else it frees
  unset pointers and the heap corrupts ITCM through address 0's mirror). And `SpriteSystem_NewSpriteFromResourceHeader`
  ignores HeartGold's palette mode (the template's last fields): mode 1 keeps the cell's palettes, which Platinum
  overrides with the template's.
- The Unown Report: `include/complete_unown_report.h` (HeartGold's overlay 113 in C,
  `src/applications/complete_unown_report/`). Test: `tools/complete/test_unown_report.py`. HeartGold's `{ALN_CENTER}`
  and `{ALN_RIGHT}` (control codes 0x205, 0x206) now work in Platinum's text renderer (`src/render_text.c`).
- The Dowsing Machine: `include/complete_dowsing.h` (HeartGold's overlay 28 in C, `src/applications/complete_dowsing/`,
  a fourth field bottom screen, `COMPLETE_BOTTOM_SCREEN_DOWSING`). Its A button presses A through
  `gCompleteSimulatedKeys` (read with the pad in `src/system.c`); its running shoes are a byte of Complete's phone save.
  Test: `tools/complete/test_dowsing.py`. The field runs at 30 frames a second: a test's waits count two vblanks a frame.
- The Pokéathlon (being ported in stages, `docs/Roadmap.md`): its save is `include/complete_pokeathlon.h` (two
  extra save sectors; `CompletePokeathlon_Load` gives a heap copy, `_Store` writes the working copy, saved with the
  game). The Dome's commands and its prize counters are in overlay 7 (`src/overlay007/complete_pokeathlon_shop.c`,
  hooks in Platinum's shop marked `completeCounter`); test `tools/complete/test_pokeathlon_counters.py`. New items go
  after HM09 at the list's end (`tools/complete/import_hgss_data_cards.py`), never between, so saves' items keep their
  numbers. Overlay 7's chain ends well before the battle overlay, which sets the arena: code there costs no heap.
  Its record screens: `include/complete_pokeathlon_records.h` (HeartGold's overlay 99 in C, the overlay
  `complete_pokeathlon_records`: the course record, the medals, the event record and the trophies), opened by
  `CompletePokeathlonRecordScreen` between the script's fades; tests `tools/complete/test_pokeathlon_records.py`,
  `test_pokeathlon_medals.py`, `test_pokeathlon_event_records.py` and `test_pokeathlon_trophies.py`. The Friendship Room's statues:
  `CompleteScrCmd_PokeathlonStatues`; test `tools/complete/test_pokeathlon_statues.py` (the save probe
  `COMPLETE_TEST_SAVE_POKEATHLON_STATUES` sets the records).
- HeartGold's assembly as it is (a trial, Nov 7: overlay 97, `complete_pokeathlon_select`):
  `tools/complete/import_hgss_asm.py NAME...` copies pret's `asm/NAME.s` into `decomp/asm/complete_hgss/` (only its
  constants' includes dropped and gSystem's touch fields moved: HeartGold's System has a word more), listed in
  `main.lsf.in` as `Object asm/complete_hgss/NAME.s` (lsfgen writes `asm/meson.build`). Every engine symbol the files
  call needs a line in `asm/complete_hgss/hgss_compat.inc` (Platinum's name, or a `HgssCompat_` shim in
  `src/applications/complete_pokeathlon/hgss_compat.c`); the import stops otherwise. `tools/complete/hgss_asm_symbols.py
  FILE.s --compat ...` finds each one's Platinum twin by comparing both builds' code. Platinum's twin may be static,
  or unused in Complete (the linker drops it, so calling it grows the main module): shim those in the overlay, and
  check the main module's size after. An overlay nothing calls yet is dropped by the linker: its entry points are in
  `meson.build`'s `-force_active` (overlay 97's in the release build only: a test build's hook calls them).
  HeartGold's archives the assembly loads by number are packed into one, `application/complete/pokeathlon.narc`
  (`tools/complete/import_hgss_pokeathlon_archives.py`, each one's first member in
  `include/data/complete_pokeathlon_archives.h`, which the shims add): add an archive there, not a NARC of its own (each
  costs a path in the main module). Its text banks: `import_hgss_text.py`'s list (a new bank goes after the last, so
  no bank's number moves). Overlay 97 in a test build: set `gCompleteTestPokeathlonSelect.open` to the course + 1
  (`include/complete_test.h`; the overlay's `select_test.c` makes its heap and arguments and records its answer).
- Berry patches 118 to 127 hold junk from a new game (Platinum's init overruns its 118-entry table); only the pots use
  any of them, and empty them on first use.
- In the emulator tests, `mem.write_long` to an address not a multiple of 4 writes the aligned word: write such fields
  byte by byte.
- A new NARC needs its line in `platinum.us/filesys.csv`, its `constants/narc.h` entry and its path in `src/narc.c`'s
  `sNarcPaths` (without the path, opening it reads a null name and the game crashes).

## Game files

Never commit a ROM (`.nds`) or a save file. Both games rebuild from the pret decompilations, and Drayano's patches
apply to those builds. `.gitignore` blocks ROMs, saves and `.cache/`.

## Commit credit

Carried over from Sovereign Platinum's owner rule: every commit credits the owner as a co-author. End each commit
message with this line next to Claude's own trailer:

`Co-authored-by: Hank Twichell <78049692+hanktwichell@users.noreply.github.com>`
