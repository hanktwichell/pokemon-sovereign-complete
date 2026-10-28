# Notes for Claude sessions

## Status

Pokémon Sovereign Complete is **planned, not started**. Don't begin engine or content work until the owner says so;
it starts after Pokémon Sovereign Platinum
([hanktwichell/pokemon-imperial-platinum](https://github.com/hanktwichell/pokemon-imperial-platinum)) is released.
The plan, estimates and open decisions are in `docs/Roadmap.md`. Keep that file up to date when the owner decides
something.

## Game files

Never commit a ROM (`.nds`) or a save file. Both games rebuild from the pret decompilations, and Drayano's patches
apply to those builds. `.gitignore` blocks ROMs and saves.

## Commit credit

Carried over from Sovereign Platinum's owner rule: every commit credits the owner as a co-author. End each commit
message with this line next to Claude's own trailer:

`Co-authored-by: Hank Twichell <78049692+hanktwichell@users.noreply.github.com>`
