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
