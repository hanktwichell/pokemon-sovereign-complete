# Session log

One entry per long working session: what was done, where it stands, what's next. `docs/Progress.md` has the details
of each piece; `docs/PlaytestIssues.md` the owner's open notes.

## Nov 5–6, 2026 (branch `claude/cool-bohr-b3a91c`)

**Builds for the owner.** Builds are now `.xdelta` patches for the owner's Platinum (US) Rev 1 dump. A clean Rev 1 and
Rev 0 are built from pret/pokeplatinum in `.cache/pret_platinum` (`CLAUDE.md`, "Building"), and the patches use no
secondary compression (`xdelta3 -S none`), so any patcher reads them. Last patch sent: the release build of commit
`76d6f605` (`decomp/build`, boot check passed).

**Done:**
- A playtest build (`complete_playtest`, `tools/complete/make_playtest_patch.sh`): a preset team and every Fly point.
  The owner moved on to the regular build; the option stays, off.
- Fixes from the owner's play:
  - Fly crashed with many Fly points (the Town Map's sprites and heap).
  - The start menu had no POKéMON after Elm's starter.
  - All 68 HeartGold trainer pictures drew as dots in battle (4-bit PNGs); all checked in battle.
  - Rowan's TV comment (Johto) and Mom's "Professor Elm".
  - The S.S. Aqua's guard with no sprite (a first voyage from Vermilion).
- The owner's requests:
  - Faster HP bars (0.8 s for a full bar).
  - The S.S. Aqua offers a cruise or a straight trip after the first voyage.
  - Sacred Gold's Cresselia and Darkrai are out.
  - **One of each legendary**: each of the 98 met once, spread over the regions (Johto 31, Kanto 29, Sinnoh 30;
    `docs/Legendaries.md`, `tools/complete/list_legendaries.py`).
- Docs: `docs/Drayano.md` (what comes from Sacred Gold and Renegade Platinum), `docs/PlaytestIssues.md` (open notes).
- Tests on build_test, all passing:
  - Town Map 33/33 and Fly.
  - The ferry test 16/16, with 4 new cases.
  - The special events test 46/46.
  - Sinjoh and the placed legendaries 40/40.
  - The new `test_one_of_each.py`.

**Not done / open:**
- `docs/PlaytestIssues.md`: scrap the following Pokémon (the owner's call), the freeze after choosing a starter (not
  reproduced; asked the owner for details or a save), the black screen after the S.S. Aqua's PC (not reproduced),
  the lab's sprite, Pokémon Centers' Balls, the S.S. Aqua's icebreaker scene, double battles' Ball indicators and EXP
  lines, the Mega animation and icon.
- The handoff: the Sovereign Platinum session (`session_01Sispid5Qo8kvdYnx3crKZR`) was asked to take that list, but
  it's waiting for the owner to confirm before it attaches this repo. Nobody is on it yet.
- Leftovers of the legendary change (`docs/Legendaries.md`, "Left as they are"): hint lines that point at encounters
  that are gone (the Ecruteak Kimono Girl's Jirachi, the Flower Shop's Shaymin), Sinnoh quest items that now lead
  nowhere (Oak's Clear Wings, the Hall of Origin's Azure Flute), Route 201's Mew feeding quest without Mew, and Fullmoon
  Island's Lati rock (its "nothing happened" path is untested in the emulator).
- The progress page (`CLAUDE.md`, "Progress page") couldn't be read from this account, so it wasn't updated.
