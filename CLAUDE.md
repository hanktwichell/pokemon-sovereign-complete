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
  `Sovereign Complete:` comment, so syncs stay clean.
- `tools/complete/`: Sovereign Complete's own tools. A sync never touches them.
- `decomp/res/sound/complete/`: the sound archive the build uses, made from Sovereign's (`res/sound/`) by
  `tools/complete/split_sound_basic.py`, with HeartGold's songs from `tools/complete/import_hgss_sound.py` (run it
  first) in `hgss/` (docs/Music.md). Both need a build's `nitrosfx`. Don't edit it by hand; the sync script remakes it.
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
- Boot check: `python3 tools/test/boot_smoke.py decomp/build/pokeplatinum.us.nds .cache/smoke` (with
  `SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy`).
- Story check: `tools/complete/test_hgss_opening.py` plays a new game from New Bark Town as a player would, part by
  part through Johto's and Kanto's stories to the ferry to Sinnoh (hours; run it in the background, with `TEST_BUILD`
  set for a test build other than `build_test`). Its save states let a part be rerun on its own (`FROM`, a part's
  name). The ways through Azalea Gym's carts, Ilex Forest's Farfetch'd, Mahogany Gym's ice blocks, Ice Path B1F's
  boulder and Blackthorn Gym's floors come from `tools/complete/solve_story_puzzles.py`; its walks slide over ice and
  along Viridian Gym's arrows themselves.
- All of Complete's emulator tests: `TEST_BUILD=build_test3 python3 tools/complete/run_tests.py` (two at a time, from a
  bedroom state it makes on that build; the long ones with `--all` or by name). Summary in `.cache/tests/BUILD/`.
  Never rebuild a test build while a test runs on it (build the next change into another test build), and make a new
  bedroom state after each rebuild: a state made on another build of the ROM, or a ROM changed under a running test,
  can hang the game or fail at random.
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
- HeartGold's people: `tools/complete/gen_hgss_people_sprites.py` (`OBJ_EVENT_GFX_HGSS_<NAME>` = 1024 + HeartGold's
  number; the mapping in `data/complete/hgss_sprites.json`, read by `import_hgss_events.py` and the script translation).
- Test: build the test ROM (`tools/test/build_test_rom.sh`), then `python3 tools/complete/test_follower.py`. The emulator
  is slow here (about 10 minutes); run it in the background.
- Talking to it: `src/overlay006/complete_follower_talk.c` (HeartGold's interactions, motions and emote bubbles, from
  the archive `tools/complete/import_hgss_follower_talk.py` packs); test `tools/complete/test_follower_talk.py`.
- A new C file in an overlay's folder must also be listed in that overlay in `platinum.us/main.lsf.in`
  (`src/meson.build` is generated from it); otherwise it links outside the overlay and calls into it crash.

## HeartGold's apps

- Voltorb Flip: `src/applications/complete_voltorb_flip/` keeps HeartGold's code, and its `hgss_compat.h` (in
  `include/applications/complete_voltorb_flip/`) names Platinum's engine by HeartGold's names, with
  `require_prototypes` on, so an unmapped name fails to compile. Only the app's own files include it. Test:
  `tools/complete/test_hgss_voltorb_flip.py`.
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
- A new NARC needs its line in `platinum.us/filesys.csv`, its `constants/narc.h` entry and its path in `src/narc.c`'s
  `sNarcPaths` (without the path, opening it reads a null name and the game crashes).

## Game files

Never commit a ROM (`.nds`) or a save file. Both games rebuild from the pret decompilations, and Drayano's patches
apply to those builds. `.gitignore` blocks ROMs, saves and `.cache/`.

## Commit credit

Carried over from Sovereign Platinum's owner rule: every commit credits the owner as a co-author. End each commit
message with this line next to Claude's own trailer:

`Co-authored-by: Hank Twichell <78049692+hanktwichell@users.noreply.github.com>`
