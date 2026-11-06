# Playtest issues

The owner's notes from playing the game (from Nov 5, 2026), with what is known about each. Fixed ones move to the end
with the commit that fixed them; `docs/Progress.md` has the details. Builds for the owner are xdelta patches made from
a clean Platinum (US) Rev 1 dump (`CLAUDE.md`, "Building"), so new fixes reach the owner as a new patch.

## Open

1. **Scrap the following Pokémon** (the owner's call, Nov 6, 2026: "too many issues"). Turn the feature off for the
   player: no follower in the field, and the scripts that move it or wait on it carry on as if there were none
   (`CompleteFollowerCheckActive` answers no). The code is `src/complete_follower.c` (hooks in `src/field_map_change.c`,
   `src/map_object.c`, `src/overlay005/ov5_021ECE40.c`, `ov5_021ECC20.c`), the talk in
   `src/overlay006/complete_follower_talk.c`, and the translator's follower commands in Sacred Gold's scripts. The
   tests that check it (`test_follower.py`, `test_follower_talk.py`, the story test's follower checks) go too, or
   check that there's none. Record the decision in `docs/Roadmap.md` and `docs/Features.md`. Issue 4 below goes with it.
   **Done (Nov 6, main session):** `COMPLETE_FOLLOWER_ENABLED` is FALSE (`include/complete_follower.h`): nobody follows,
   the code stays. `test_follower.py` and `test_follower_talk.py` are retired while it's off.
2. **The game froze after choosing a starter** in Elm's lab (on the playtest build, a party of three already). Not
   reproduced on build_test: `tools/complete/test_hgss_starter.py` passes with parties of one to three, with
   Chikorita and Cyndaquil, and with a nickname given (the naming screen and back). That test warps to the table; the
   owner walked in through Elm's greeting. Asked the owner which starter, whether nicknamed, and what the freeze
   looked like. Try the whole walk on a release-type build (the story test's parts 3 and 4).
3. **The person who leaves Elm's lab has the male player's sprite**: one of them needs another sprite. Which person
   isn't confirmed yet (asked the owner); check the lab's and New Bark Town's events (`res/field/events/`) for a
   graphics ID that maps to Platinum's player (`data/complete/hgss_sprites.json`).
4. **The following Pokémon appears inside the door** as the player walks out of a building. Moot once issue 1 is done.
5. **Johto's and Kanto's Pokémon Centers show no Poké Balls on the healing machine** while it heals.
6. **The S.S. Aqua's sailing scene is Platinum's icebreaker** (`PlayBoatCutscene`, docs/Features.md, "The ferries"),
   not HeartGold's ship.
7. **Double battles: the Poké Ball indicators** that show each side's party don't follow which Pokémon are left.
   Note that two trainers who see the player together battle as one double with both teams (Pokéfans Georgia, 5
   Pokémon, and Jeremy, 3, on the S.S. Aqua: 8, as in HeartGold), and the indicator has 6 slots a side. Asked the
   owner how it goes wrong (a fainted Pokémon's ball not greyed, or the wrong one).
8. **Double battles: one EXP message per Pokémon for both foes** when one move makes both faint: both "fainted" lines
   first, then each party Pokémon's EXP for the two together (up to 6 lines, not 12).
9. **The Mega Evolution animation and the Mega icon look bad** (later; the owner will redo the stone shown on screen).
10. **A black screen after leaving the PC on the S.S. Aqua** (the owner's release build, Nov 6; the ship's one PC is in
   the player's cabin, `MAP_HEADER_HGSS_SS_AQUA_1F_SOUTHEAST_ROOMS`, tiles (26, 2-3), used facing north from (26, 4)).
   Not reproduced on build_test from the bedroom state: the PC's menus and the storage app (Deposit) open and close,
   and the field comes back. Asked the owner for their save file (the emulator's battery `.sav`; never commit it), to
   load with `drive.py ROM sav:FILE` on a release build, which also helps with issue 2. Suspect the field map's heap
   on the way back (`CLAUDE.md`, "Building": nearly full on a crowded map with a big follower; issue 1 may settle it).

## Fixed

- **Johto's and Kanto's trainers drew as dots in battle**: their 68 classes' pictures were 4-bit PNGs, which the
  build's `-convertTo4Bpp` reads as 8-bit. All 68 checked in battle on build_test.
- **Fly crashed** once enough of Johto's and Kanto's Fly points were reached (the Town Map's sprites and heap).
- **The start menu had no POKéMON** after Elm's starter (it waited for Rowan's).
- **Rowan's TV comment** said he came back from Kanto (Johto now); **Mom** said "Elm" (Professor Elm now).
- **The S.S. Aqua's guard with no sprite** on a first voyage from Vermilion.
- **Slow HP bars**: a full bar takes 0.8 s at any HP.
- **The S.S. Aqua, the cruise or straight there**: after the first voyage, the gangway's sailor offers the cruise or
  the sailing scene straight to the other port (the owner's design for the ship).
- Explained, not bugs: two Poké Balls on Elm's table and "received GARCHOMP from Professor Elm" came from the
  playtest's preset team (a real new game shows three Balls and names the starter).
- Explained, not a bug: **resting in the S.S. Aqua's cabin doesn't end the trip** on the first voyage (the
  granddaughter's story ends it); on later voyages the ship arrives as the player wakes (`scripts_hgss_0158.s`,
  `VAR_HGSS_SCENE_SS_AQUA` 7), as in HeartGold.
