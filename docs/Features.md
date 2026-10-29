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

- **The Balls in battle.** The seven are battle items: they are thrown from the bag's Poké Balls pocket, each with
  HeartGold's catch rule (`BattleScript_CalcCatchShakes`, `src/battle/battle_script.c`): Fast ×4 for a base Speed of
  100 or more; Level ×2, ×4 or ×8 as the player's Pokémon's level is over the wild one's, twice it or four times it;
  Lure ×3 on a Pokémon hooked with a rod (battles now know it: `isFishing`); Heavy +20, +30 or +40 from 204.8,
  307.2 and 409.6 kg, and −20 below (the catch rate stays at least 1); Love ×8 for the same species and the other
  gender; Moon ×4 for the Moon Stone's lines; the Sport Ball ×1.5. A Friend Ball's catch starts at 200 friendship.
  The catch rate is capped at 255 after them, as in HeartGold.
- **Keeping the Ball.** A Pokémon keeps HeartGold's Balls (Fast to Park) as HeartGold keeps them: its Ball number
  (17-25) in the byte after Platinum's (`MON_DATA_POKEBALL`, `src/pokemon.c`), with a Poké Ball in Platinum's, so the
  engine's Ball is still an item. Until their graphics come in, they are drawn as a Poké Ball wherever a Pokémon's
  Ball is drawn (`Pokemon_BallToDraw`: sending out, the capsule, the summary, the trade room) and thrown as one.
- **Test:** `tools/complete/test_hgss_balls.py` throws each at a wild Pokémon in the test build: all seven catch, the
  Pokémon keeps that Ball, and a Friend Ball's starts at 200 friendship.

Left: the Balls' own graphics (in battle and on the summary screen; `a/0/0/8` and `a/1/6/2` below), Kurt's phone
calls (with the Pokégear), HeartGold's tree and Apricorn sprites, and the Apricorn juice stand, which is the skipped
Pokéathlon's.

### HeartGold's Balls' graphics (planned)

What drawing them takes, from both decomps (the rest of the original plan is done above):

- **Tables to grow** (17 entries now): the summary screen's palette table (`sBallIDToPaletteNum`), the battle fade
  colours (`sFadeColors`), and the three throw tables in `src/battle_anim/ov12_02235E94.c`, whose rows past 16 are
  special throws (Park, mud, bait, close) reached as 0xFF + n: those move to a new offset, as HeartGold moved them
  to 1000 + n, so Balls 17-25 can take ball − 1. `Pokemon_BallToDraw` then gives HeartGold's Ball numbers.
- **Graphics.** HeartGold's throw sprites (`a/0/0/8`: Fast 309/99/308/307 to Park 333/107/332/331, images, palettes,
  cells, animations) go into Platinum's battle sprites; their open and catch particles are byte for byte the Poké
  Ball's, so the new rows point at Platinum's. Summary icons: HeartGold's `a/1/6/2` members 41-48 (Fast to Sport) and
  their palettes 53-60, added through a lookup table rather than after Cherish (later members are hard-coded); neither
  game has a Park Ball icon.
- Also: the trade room's Ball animations are in a prebuilt archive.

## Bug-Catching Contest

National Park's contest, Tuesdays, Thursdays and Saturdays: 20 Sport Balls, 20 real-time minutes, one Pokémon kept,
judged against five of ten Bug Catchers. HeartGold's own parts, and where each went:

- **The contest** (HeartGold's `src/overlay_bug_contest.c` and helpers in `src/unk_0206D494.c`) is
  `src/complete_bug_contest.c`. It is never saved: it lives on the field's heap from the gate (the party is put away
  but for its first Pokémon that can battle) to the judging (the party comes back, and the caught Pokémon joins it or
  a box). The ten contestants' entries (one picked each by weekday and National Dex), the four encounter sets (no
  National Dex, then Tuesday, Thursday, Saturday) and the score (species 60-100, level, IVs, HP) are HeartGold's
  (`include/data/complete_bug_contest.h`, from `tools/complete/import_hgss_bug_contest.py`; Sacred Gold's are the
  same). Prizes: Sun Stone (with the National Dex, one of ten stones), Everstone, Sitrus Berry, Shed Shell. The 20
  minutes are counted from the console clock.
- **Scripts:** HeartGold's contest scripts (`scr_seq_0151`: the gate, time up, last Ball, retiring, the judging, the
  contestants' lines) are translated as they are (`scripts_hgss_0151.s`), at script IDs 11000 on (HeartGold's 10400
  on, which are Platinum's daily trainers here). Its six commands are `Complete*` commands, and HeartGold's
  flags held in a variable (the contestants' hide flags) have two of their own.
- **Encounters:** grass and Sweet Scent bring out the day's set while it runs (slots 20/20/10/10/10/10/5/5/5/5%); the
  map's own rate still decides when.
- **Battle:** a contest battle type (the lead still gains experience), where BAG throws a Sport Ball (×1.5), as the
  Great Marsh's BALL throws a Safari Ball. A catch gets no nickname and goes to the contest, not the party; with one
  already kept, the battle asks which to keep, where HeartGold has a screen of its own after the battle (an app still
  in assembly). The last Ball missing ends the battle and the contest; losing heals the party and ends it.
- **Field:** the time-up check runs each frame the field takes input, as HeartGold's; the start menu shows the Sport
  Balls left and Retire (HeartGold's retire script), with no Bag or saving.
- **The nickname** at the judging: Platinum's naming screen names a party Pokémon, so the caught one joins the
  contest's one-Pokémon party for it, and leaves after.

- **Test:** `tools/complete/test_hgss_bug_contest.py` enters at Route 36's gate on a Tuesday, surveys the contest's
  grass (every Pokémon is one of the day's ten, at its levels), catches one with a Sport Ball (the contest keeps it,
  with 19 Balls left), and lets the time run out: the announcement, the National Park, the judging, and the party back
  with the caught Pokémon in its Sport Ball. All four parts pass.

Left: the Sport Ball and the bug net on the battle's bottom screen (HeartGold's BALL label and Ball count, with the
kept Pokémon), the Sport Ball's own graphics, the contest's music and fanfares (step 6), and the Pokégear calls.

## Johto Safari Zone (planned)

West of Cianwood, through Route 48's gate: ₽500, 30 Safari Balls, no step limit or timer. Six areas sit in a 3×2
grid the player arranges with Baoba (12 areas in all, unlocked over time), and objects the player places in an area
bring out more Pokémon as days pass. Sacred Gold leaves it as HeartGold has it (its encounter data, arrangements,
apps and area blocks are byte for byte HeartGold's), so its Pokémon are at HeartGold's levels (about Lv. 15-17).

- **What's already here:** the maps, the area blocks (`map_data_1318`-`1329`, HeartGold's 652-663), the object
  models (in Safari's prop set), the gate's text, and the Great Marsh's Safari game: its flag, ball count, battles
  (Ball, Bait, Mud, Run), the start menu's ball count and Retire, and Fly and escape ending it.
- **Save:** the areas and their objects (HeartGold's `SafariZone`, 1,532 bytes; about 748 without link play's friend
  Safari), in a new save block, seeded at the new game with one of HeartGold's 10 arrangements.
- **Areas:** the outside map's matrix has six empty cells that HeartGold fills with the chosen areas' blocks on each
  map load (`PlaceSafariZoneAreas`): the same after the engine loads that matrix.
- **Objects:** an area's objects replace its props on each block load, with their tiles blocked; placing and taking
  them away (HeartGold's 717-721), and arranging the areas, are apps still in assembly (about 10,000 lines), so here
  they are list menus.
- **Encounters:** each area's land, surf and rod tables, by time of day, with bonus slots an object type unlocks at a
  level (its days ÷ 10); a uniform pick of 10 slots. A tool turns HeartGold's `safari_enc.json` into a C table.
- **Script commands** (`SafariZoneAction`, Baoba's tests and timer, the rearranging) and HeartGold's Safari standard
  scripts (its 8800, which is Platinum's Safari game's number, so they move to a free range); the Great Marsh's
  step limit, its own end scripts, TV and journal entries and daily Pokémon branch off for Johto's.
- **Baoba's unlocks** come by Pokégear call in HeartGold; until there's a phone, the gate gives them after the same
  time.
- About 1,300-1,500 lines. The riskiest part: placing the objects on every way a block loads, with their collision
  surviving reloads.
