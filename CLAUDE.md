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
- `HEARTGOLD_COMMIT` and `tools/complete/build_heartgold.sh`: HeartGold from pret/pokeheartgold, and Sacred Gold from
  Drayano's patch, both built into `.cache/`.
- `Sacred Gold & Storm Silver V1.05 5/`: Drayano's patches and documents, unchanged.
- `.cache/` (ignored by git): the HeartGold source, the built games, the Sovereign checkout for syncs, build logs.

## Building

- `make -C decomp rom` builds `decomp/build/pokeplatinum.us.nds`. Dependencies are in `decomp/INSTALL.md`; on Linux:
  `bison flex g++ gcc-arm-none-eabi make ninja-build pkg-config wget python3 xz-utils nasm libc6:i386 libpng-dev`, and
  `xdelta3` for the HeartGold script.
- In cloud sessions the network proxy refuses GitHub's source-archive downloads (`github.com/<owner>/<repo>/archive/...`).
  Meson then falls back to each wrap's `source_fallback_url` (the wrapdb mirror), which is allowed, after several
  retries. To skip the retries, put the tarball from the fallback URL into `decomp/subprojects/packagecache/` first,
  named as the wrap's `source_filename`, and check it against `source_hash`.
- `tools/complete/build_heartgold.sh` builds `.cache/heartgold.nds` (the retail HeartGold US ROM, checked by SHA-1 and
  by the CRC32 in Drayano's readme) and `.cache/sacredgold.nds` (Sacred Gold, Complete version).

## Game files

Never commit a ROM (`.nds`) or a save file. Both games rebuild from the pret decompilations, and Drayano's patches
apply to those builds. `.gitignore` blocks ROMs, saves and `.cache/`.

## Commit credit

Carried over from Sovereign Platinum's owner rule: every commit credits the owner as a co-author. End each commit
message with this line next to Claude's own trailer:

`Co-authored-by: Hank Twichell <78049692+hanktwichell@users.noreply.github.com>`
