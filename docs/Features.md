# HeartGold's features (step 5)

The features the owner kept (`docs/Roadmap.md`, "HeartGold features"), as they work here, and what's left of each.

## Kurt's Apricorn Balls

Kurt in Azalea Town makes Poké Balls from Apricorns, which grow on 31 trees across Johto and Kanto, one a day each.

- **Trees.** HeartGold's Apricorn trees are people on the map running its `std_apricorn_tree` script, with the tree's
  number in their first parameter (HeartGold's `sTreeApricorns`, `src/apricorn_tree_sys.c`, gives each its colour).
  `tools/complete/import_hgss_events.py` gives them `CommonScript_CompleteApricornTree`
  (`res/field/scripts/scripts_common.s`, common script 0x80F) and, until HeartGold's sprites come in, Platinum's Cut
  tree as a stand-in (its berry soil, the first stand-in, showed Sinnoh's berry patches). The script is HeartGold's
  with its text (in `common_strings.json`): a tree gives its Apricorn once a day to a player with the Apricorn Box. A
  picked tree's flag (`COMPLETE_APRICORN_TREE_FLAGS_START`, past HeartGold's and Sacred Gold's flags) is cleared with
  the daily flags.
- **Apricorns** are bag items (the Items pocket), where HeartGold keeps them in the Apricorn Box. The box is still the
  key item Kurt gives, which lets the player pick them, as in HeartGold.
- **Kurt.** Where HeartGold opens its Apricorn Box, the bag opens on the Items pocket: Kurt takes all of the kind of
  Apricorn the player picks (up to 99) and has as many Balls of its kind the next day (Red: Level, Yellow: Moon,
  Blue: Lure, Green: Friend, Pink: Love, White: Fast, Black: Heavy). He keeps them in two vars, on the two Sacred Gold
  left unused (`VAR_COMPLETE_KURT_BALL`, `VAR_COMPLETE_KURT_QUANTITY`). The commands are in
  `src/complete_apricorns.c`.
- **Daily flags.** HeartGold's 192 daily flags (Kurt making Balls, the haircut brothers, Union Cave's Lapras on
  Fridays, Buena's password, the Trainer House, the Bug-Catching Contest) weren't cleared each day; they are now, with
  Sinnoh's (`FieldSystem_ClearDailyFlags`).

Left: **the Balls can't be thrown yet.** They are items (from HeartGold's list), but not battle items: throwing one
needs its catch rule (Level, Lure, Moon, Love, Heavy, Fast and Friend each have HeartGold's), its graphics in battle
and on the summary screen, and somewhere in the Pokémon's data to keep it (HeartGold has a byte for its own Balls;
Platinum's ball field only knows its 16). That comes with the sprites. Also left: Kurt's phone calls (with the
Pokégear), HeartGold's tree and Apricorn sprites, and the Apricorn juice stand, which is the skipped Pokéathlon's.

### Plan: HeartGold's Balls in battle

What throwing HeartGold's nine Balls (the seven Apricorn Balls, Sport, Park) takes, from both decomps:

- **Where a Pokémon keeps its Ball.** Platinum keeps the Ball's item ID in one byte (`pokeball`, `include/struct_defs/pokemon.h`),
  and every Ball table holds 16 (Master to Cherish). HeartGold keeps those in the same byte and its own Balls (17 Fast
  to 24 Sport, 25 Park) in a second byte, the one Platinum has unused at the same place (`MON_DATA_UNUSED_159`), with
  a Poké Ball in the first so older games see one. The same here: the first byte stays an item ID 1-16, the second
  holds HeartGold's Ball number, and a getter gives the Ball to show. HeartGold's own getter hides the second byte
  for Pokémon from other games, which here would be every one, so it isn't copied as is.
- **Tables to grow** (17 entries now): the summary screen's palette table (`sBallIDToPaletteNum`), the battle fade
  colours (`sFadeColors`), and the three throw tables in `src/battle_anim/ov12_02235E94.c`, whose rows past 16 are
  special throws (Park, mud, bait, close) reached as 0xFF + n: those move to a new offset, as HeartGold moved them
  to 1000 + n, so Balls 17-25 can take ball − 1.
- **Graphics.** HeartGold's throw sprites (`a/0/0/8`: Fast 309/99/308/307 to Park 333/107/332/331, images, palettes,
  cells, animations) go into Platinum's battle sprites; their open and catch particles are byte for byte the Poké
  Ball's, so the new rows point at Platinum's. Summary icons: HeartGold's `a/1/6/2` members 41-48 (Fast to Sport) and
  their palettes 53-60, added through a lookup table rather than after Cherish (later members are hard-coded); neither
  game has a Park Ball icon.
- **Catch rules** (HeartGold's `BattleSystem_CalculateBallShakes`): Fast ×4 on base Speed 100 or more; Level ×2, ×4,
  ×8 as the player's Pokémon is over 1, 2, 4 times the level; Lure ×3 when fishing (Platinum's battles need a fishing
  flag); Heavy +40, +30, +20 at 409.6, 307.2, 204.8 kg, and −20 below (HeartGold tests the catch rate there by
  mistake, so every lighter Pokémon got −20); Love ×8 for the same species and the other gender; Moon ×4 for the
  Nidoran, Clefairy, Jigglypuff and Skitty lines; Sport ×1.5; Friend sets friendship to 200. Platinum's catch rate is
  unsigned, so the Heavy Ball's −20 needs care.
- **Items:** the Balls become battle items (their battle pocket and use category, as the Master Ball's).
- Also: the Pokémon's Ball where code reads it as an item (the TV, the Heal Ball, the day care, Pal Park, trainer
  data) goes through an item lookup; the trade room's Ball animations are in a prebuilt archive.
