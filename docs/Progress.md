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
