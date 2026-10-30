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

## Johto Safari Zone

West of Cianwood, through Route 48's gate: ₽500, 30 Safari Balls, no step limit or timer. Six of HeartGold's twelve
areas sit in a 3×2 grid the player arranges with Baoba, and objects the player places in an area bring out more
Pokémon as days pass. Sacred Gold leaves it as HeartGold has it (its encounter data, arrangements, apps and area
blocks are byte for byte HeartGold's), so its Pokémon are at HeartGold's levels (about Lv. 15-17). HeartGold's own
parts, and where each went:

- **The core** (HeartGold's `src/safari_zone.c`, `src/unk_02097268.c` and the Safari parts of its map matrix and
  encounter code) is `src/complete_safari.c`. HeartGold's tables (the ten default arrangements, each area's
  encounters, the object types and levels) are `include/data/complete_safari.h`, from
  `tools/complete/import_hgss_safari.py`.
- **Save:** a save block of its own (`SAVE_TABLE_ENTRY_COMPLETE_SAFARI`, 750 bytes): the six cells' areas and their
  objects (up to 30 each), each area's days, the objects Baoba has unlocked and when he last spoke. Link play's
  friend's Safari Zone is left out. The first visit picks one of HeartGold's ten arrangements.
- **Areas:** the outside map's matrix has six empty cells; on each map load they get the arranged areas' blocks
  (`map_data_1318`-`1329`, HeartGold's 652-663), as HeartGold's `PlaceSafariZoneAreas` does.
- **The Safari game:** the gate's receptionist (HeartGold's scripts, translated) starts it with 30 Safari Balls and the
  Great Marsh's Safari battles (Ball, Bait, Mud, Run); there is no step limit, the start menu shows the Balls and
  Retire, and running out of Balls or walking out ends it (HeartGold's end scripts, `scr_seq_0262`, at script IDs
  11100 on: HeartGold's 8800 is Platinum's Safari game's number).
- **Encounters:** grass, water, the three rods and Sweet Scent pick one of the area's ten slots for the time of day
  (morning, day, night), all alike, as HeartGold does. Bonus Pokémon take the first slots once the area's objects
  reach their levels: an object's level comes from its type and the area's days (tens of days), and days count only
  once Baoba has unlocked the objects (during a Safari game they wait for its end).
- **Objects:** A facing open ground asks to place one; A facing an object takes it away (HeartGold's
  `std_safari_place_object` and `std_safari_remove_object`). HeartGold's object screen (an app still in assembly) is
  a list menu of the objects Baoba has unlocked (four groups of six, one more group at a time, in an order the trainer
  ID's last digit picks); the object goes on the tile in front, growing away from the player. The map then loads
  again in place. As each area's block loads (all five of the engine's ways), its objects are added as props, with
  their tiles blocked (behavior 0x23, which A finds).
- **Baoba:** his tests (catch a Geodude, then a Sandshrew, in the Safari Zone) are HeartGold's scripts; the check is
  `CompleteSafariChallengeCompleted`. His calls come by Pokégear in HeartGold; until there is a phone, what each call
  does happens at the first map load after it would have rung: three hours of play after the first test, the second;
  three hours after the second, with the National Dex, the objects, one more group every three hours. His console in
  the gate (HeartGold's area screen, also in assembly) is two list menus, a cell then its area: an area in another
  cell swaps places with it, objects and all; a new one starts empty.

- **Test:** `tools/complete/test_hgss_safari.py` pays at the gate (a Safari game with 30 Balls, on the outside map),
  checks the six arranged areas, surveys each grassy area (every Pokémon one of its ten noon slots, at their levels),
  places an object with Baoba's objects given (saved in its area, its tile blocking the way) and takes it away, walks
  out (the game ends), and rearranges two cells at Baoba's console (a new area, then a swap). All six parts pass.

Left: the object and area screens as HeartGold has them (moving an object about before it is placed), Baoba's calls
on the Pokégear, link play's friend's Safari Zone, and the Safari Zone's music (step 6).

## Badges

Johto's and Kanto's 16 badges are kept beside Sinnoh's eight, in the trainer info (`hgssBadgeMask`, in what was the
struct's padding, so the save keeps its layout; `src/complete_badges.c`). HeartGold's `GiveBadge` and `CheckBadge`
are `CompleteGiveBadge` and `CompleteCheckBadge` (`BADGE_ID_HGSS_*`, HeartGold's order).

- **Field moves:** a field move works with Sinnoh's badge for it or with HeartGold's (Cut: Forest or Hive; Fly: Cobble
  or Storm; Surf: Fen or Fog; Strength: Mine or Plain; Rock Smash: Coal or Zephyr; Waterfall: Beacon or Rising; Rock
  Climb: Icicle or Earth; Defog: Relic only, as HeartGold has no Defog). That covers the field-move scripts
  (`CompleteCheckFieldMoveBadge`, `res/field/scripts/scripts_field_moves.s`), the party menu and the Surf prompt.
  Until now Johto's Cut trees, rocks and boulders asked Sinnoh's badges, so a player in Johto couldn't use them.
- **Whirlpool** (HeartGold's own field move, on Route 27, Route 41 and in Dragon's Den, where its whirlpools are
  3×3 blocks of water that stop a surfer): facing one while surfing, with the Glacier Badge and Whirlpool, asks to use
  it, and the player surfs across (`CommonScript_CompleteWhirlpool`; HeartGold's own crossing scene is assembly, so
  this is a plain crossing). HeartGold's HM05 is Whirlpool, Platinum's is Defog, and Lance gives HM05 in Johto: for now
  HM05 in the bag also allows Whirlpool, as Sovereign lets an HM in the bag stand in for the move (`docs/Roadmap.md`,
  "Still open"). Test: `tools/complete/test_hgss_whirlpool.py` (Dragon's Den: surfing out, and across its whirlpool).
- **Counts:** every badge counts where Platinum counts badges: how high a traded Pokémon obeys, the money lost on
  blacking out (capped at eight, as its table is), the common Poké Mart's stock, the save and continue screens. Scripts
  that count Sinnoh's badges (`CountBadgesAcquired`) still count Sinnoh's.
- **Not yet:** the Trainer Card shows Sinnoh's badges only (Johto's and Kanto's need their art); Sovereign's level caps
  (an option, off by default) follow Sinnoh's fights only, so with the option on a player in Johto is held at Lv. 16
  until the level curve is decided (`docs/Roadmap.md`).

Test: `tools/complete/test_hgss_field_moves.py` (Ilex Forest's Cut tree with no badge and with the Hive Badge, Rock
Smash with the Zephyr Badge, Strength with the Plain Badge).

## Headbutt trees and Rock Smash

HeartGold's two field encounters Platinum doesn't have (`src/overlay006/complete_field_encounters.c`, with the tables
`tools/complete/import_hgss_field_encounters.py` writes; Sacred Gold's are HeartGold's):

- **Headbutt trees:** pressing A at a Headbutt tree (its HeartGold tile behaviour) with a Pokémon that knows Headbutt
  asks to use it (`CommonScript_CompleteHeadbutt`, HeartGold's lines); the tree shakes, and on a tree of a kind with
  Pokémon one falls out: as in HeartGold, a map's trees are common, rare or empty by the last digit of the trainer ID,
  and its secret trees always have their own. The battle is set up as Platinum's wild battles are (the lead's
  abilities, a Repel). 60 maps, 2,114 tree tiles. Headbutt is a move, not an HM, so no badge is needed; it isn't in
  the party menu's field moves yet.
- **Rock Smash:** after a rock breaks on a Johto or Kanto map, a Pokémon from the map's Rock Smash slots may come out
  at its rate (80% the first slot, 20% the second), or else, on the 17 maps with finds, an item from HeartGold's lists
  at the map's odds (Suction Cups, Magnet Pull and Keen Eye add 5%; Serene Grace and Super Luck favour the rarer
  items), as HeartGold's `RockSmashItemCheck` does.
- **Ilex Forest's Headbutt tutor** checks HeartGold's list of who can learn Headbutt; the species HeartGold doesn't
  have can when they learn it by level in Sovereign's data.

Test: `tools/complete/test_hgss_headbutt.py` (a battle from Route 29's trees; a battle and an item from Dark Cave's
rocks).

## The S.S. Aqua

The ship between Olivine City and Vermilion City runs as in Sacred Gold, with no weekly schedule. HeartGold's sailing
scene (`ScrCmd_723`) is Platinum's boat scene (`PlayBoatCutscene`), sailing east from Olivine and west from Vermilion;
Platinum's scene, which first sails its own ship out of the dock when there is one beside the player, now starts at the
fade-out when there isn't (`src/cutscenes/boat_cutscene/boat_cutscene.c`), as at HeartGold's ports. The first trip's
scenes and the cabin's rest play as in Sacred Gold. Test: `tools/complete/test_hgss_ferry.py` (boarding at each port,
and arriving at each).

## The Pokégear phone

HeartGold's phone, from its data (Sacred Gold's phone book and HeartGold's call tables,
`tools/complete/import_hgss_phone.py`; the 75 callers' text banks) and its code (`src/complete_phone.c`, the save;
`src/overlay006/complete_phone_calls.c`, the rest):

- **The phone book** is saved (`SAVE_TABLE_ENTRY_COMPLETE_PHONE`, 456 bytes: the contacts in the order registered, who
  wants a rematch, the gifts kept for the player, Mom's savings and the last random callers). Scripts register numbers
  and ask about them as HeartGold's do (`CompletePhoneRegister`, `CompletePhoneCheckRegistered`).
- **Phone trainers:** a trainer with a number asks for the player's after the first battle; talked to after that, they
  battle again when a call asked for a rematch (their next team, as HeartGold's rematch sets and their unlocks go), hand
  over a gift a call promised, or ask for the number again; a rematch won ends it, and some give an item for it
  (HeartGold's `scr_seq_0953`, in a marked block of Platinum's `scripts_battles.s`). Gym Leaders' rematches follow
  their own scripts, as in HeartGold.
- **Calls** show in the field's message box: the ring, the caller's greeting and lines (with HeartGold's text and
  its choices: a rematch, a gift, a word, a flag), any yes or no, and the click. Map scripts' calls (Elm's panic call,
  Mom's on Route 30 about saving money, Oak's, Baoba's) play where HeartGold plays them. **Incoming calls:** ten
  minutes after the last call, on a map with a signal, a step may bring a call: a call trigger's, or half the time a
  random caller from the phone book (HeartGold's three groups, not one on the same map or one who called lately).
- **Stand-ins until the Pokétch and Pokégear question is answered** (`docs/Roadmap.md`): a call is answered at once
  (HeartGold's Pokégear rings until the player opens it), and the player can't call anyone, as that needs the
  Pokégear's contact list: so Gym Leaders' rematches (arranged by calling them on their day), Oak's Pokédex rating by
  phone and the Day-Care's news wait for it.

## Mom's savings

HeartGold's (its `mom_gift.c`, the battle's money hand-back, and Mom's bank), in `src/complete_phone.c` and
`src/overlay006/complete_moms_savings.c`, with the balance and her shopping in the phone's save:

- **Her share:** with her savings on (her Route 30 call, or her at home), a quarter of the money a battle brings goes to
  her, to ¥999,999, and the prize message says so ("Sent some to Mom!", a marked block of Platinum's
  `subscript_battle_won.s`).
- **Her shopping:** HeartGold's list (a Super Potion at ¥900 saved, a Repel at ¥4,000, ... a Focus Sash at ¥50,000,
  each once), or five of a type-resist Berry each time her savings pass another ¥3,000; up to five things wait at a
  time. She calls about it (HeartGold's call trigger).
- **The deliveryman** in Johto's and Kanto's Marts shows as the Mart loads when she bought something, and hands it over,
  one thing a visit (Platinum's Mart script, with HeartGold's lines).
- **Her bank at home:** HeartGold's menu (withdraw, deposit, change the setting), with the savings and the wallet in a
  box. HeartGold takes the amount on the touch screen's number pad; here a window above the message box does: up and
  down change the digit under the cursor (red), left and right move it, A confirms and B gives up.

Test: `tools/complete/test_hgss_phone.py` (Youngster Joey on Route 30: his number after the battle, a rematch, a gift;
his call; Mom's call on Route 30; her share of his rematch's prize and the Super Potion she buys; the Cherrygrove Mart's
deliveryman; a withdrawal at home).

## The Ruins of Alph puzzles

HeartGold's sliding puzzles (its `alph_puzzle.c`), in `src/applications/complete_alph_puzzle.c` with HeartGold's
graphics (`res/graphics/alph_puzzle`, its `puzzle_gra` built the same way) and text:

- **The puzzles:** reading a chamber's slab opens its puzzle on the touch screen, the hint on the top one. A tap turns a
  loose panel a quarter, dragging moves it to a free square (not a corner); once every panel sits in the middle the
  right way up, the picture flashes and the puzzle's flag is set. Quit asks first, with Platinum's touch yes and no.
  Back in the field, HeartGold's script goes on: the floor gives way and the player drops into the underground hall.
  HeartGold's own sound effects aren't in the sound archive, so Platinum's stand in.
- **The Unown:** the underground hall has no Pokémon until a puzzle is solved, and then only the letters each solved
  puzzle lets out (Kabuto's A to J, Aerodactyl's R to V, Omanyte's K to Q, Ho-Oh's W to Z); its entrance in the Sinjoh
  Ruins event has ! and ? (`src/complete_encounters.c`). HeartGold's pull toward uncaught letters while the radio plays
  the Unown broadcast waits for the radio.
- **Not ported:** HeartGold's effect of a hidden room's wall as the player comes back into a chamber (its flags and
  warps are the scripts', which run).

Test: `tools/complete/test_hgss_alph_puzzle.py` (the hall empty before any puzzle; Quit, yes; the Kabuto puzzle solved
by touch and the drop into the hall; the hall's Unown then).

## Talking to the following Pokémon

HeartGold's (its `scr_seq_0163` and the `Task_FollowMonInteract` of its overlay 2, which pret's decomp has only as
assembly), in `src/overlay006/complete_follower_talk.c` and `CommonScript_CompleteFollowerTalk`, with HeartGold's data
(four of its archives, packed by `tools/complete/import_hgss_follower_talk.py` into
`res/prebuilt/fielddata/complete_follower_talk/follower_talk.narc`) and text (msg_0265, msg_0040):

- **What it says:** talking to the follower picks one of HeartGold's interactions from its choices: 70 that can happen
  anywhere and up to 30 for each place, each asking about the moment (the Pokémon's HP, status, mood, friendship,
  nature, type, held item and kind; the tile it stands on, the time, the weather, the people and hidden items nearby,
  the map, a story flag) and with a chance. HeartGold tries 12 general ones, then the place's, then the rest; the first
  that fits is it. Sinnoh's places have the general ones, and the League's, a place both games share.
- **What it does:** up to five steps of hops, shakes and turns (HeartGold's keyframes, on the follower's sprite), its
  cry and its lines; a question's yes or no leads on to another interaction; some raise or lower its friendship and
  mood, and some have it find an accessory for the Fashion Case or a Shiny Leaf to wear.
- **The mood** is HeartGold's, kept where HeartGold keeps it (a spare byte of the Pokémon's data): up 40 with a level
  gained in battle or a TM learned, down 80 when it faints (100 against a foe 30 levels higher) and 50 when it survives
  poison in the field, HeartGold's changes for items (a Rare Candy +40, vitamins +8, X items +10, bitter herbal
  medicine down 20 to 40), and a step back toward 0 with each step the follower is out.
- **Shiny Leaves** are kept per Pokémon (another spare byte), and the crown Lyra or Ethan makes from all five in
  their room in New Bark Town works (HeartGold's `GetShinyLeafCount` and `TryGiveShinyLeafCrown`).
- **The emotes:** HeartGold's 14 bubbles over the follower (a heart, faces, "...", "!"...), its model and two-frame
  pictures (also in the archive), pop up as in HeartGold and play their frames, as a billboard of Platinum's field
  effects loaded from the archive (`FieldEffectManager_Load*FromNARC`). None on a bridge, as in HeartGold.
- **Not ported:** the few choices that ask about Pokéathlon performance never come up, as in a game without the
  Pokéathlon.

Test: `tools/complete/test_follower_talk.py` (a talk the tables choose in New Bark Town; a nudge, its emote, its
question and the yes; an accessory found; a Shiny Leaf, with the friendship and mood it brings).

## Stand-ins

HeartGold features no one has decided to keep yet, or not ported yet, where Johto and Kanto's scripts reach them:

- **Voltorb Flip** (the Goldenrod and Celadon Game Corners' machines): Platinum's slot machine stands in, on one of its
  12 machines (each with its own odds for the day). Porting Voltorb Flip is about 3,700 lines of HeartGold's code
  (`src/voltorb_flip/`) and its own graphics.
- **The photo album** (Cameron the photographer, 66 photos on 59 maps): he takes the photo, but there is no album to
  keep it in.
- **The radio's Poké Flute** (Snorlax on Routes 11 and 12): HeartGold's Snorlax wakes when the Pokégear's radio plays
  the Poké Flute channel, which needs the Expansion Card. Until the radio comes (the same question), the Poké Flute
  counts as playing once the player has the Expansion Card, and every other radio check finds nothing playing.
