# Bringing HeartGold's scripts into the engine (step 3)

How HeartGold's map scripts and text (`.cache/pokeheartgold`, pinned in `HEARTGOLD_COMMIT`) become Sovereign
Complete's. Findings first; the translator follows them. Maps, events and flags are in `docs/MapConversion.md`.

## Size

- 965 script files (`files/fielddata/script/scr_seq/scr_seq_*.s`): 77,976 command lines, 818 different commands.
- 181 of those commands have a Platinum command of the same name (`decomp/asm/macros/scrcmd.inc`, `movement.inc`),
  62% of the lines: `End`, `GoTo`, `SetFlag`, `ApplyMovement`, the walking movements...
- The other 637 are skewed: the 25 most used cover 80% of their lines, 100 cover 94%, 200 cover 97%. The long tail is
  mostly HeartGold's own features (Pokégear calls, Apricorns, the Bug-Catching Contest, Safari Zone, the Pokéathlon,
  which is skipped, following Pokémon in scenes), which need engine work as well as translation.

## Commands

Both games write scripts as assembler macros over numbered commands (`.short` opcode, then arguments). The opcodes
drift apart after the shared core from Diamond and Pearl: HeartGold's 41 is `SetVar`, Platinum's 41 is
`SetVarFromVar`; HeartGold's `NPCMsg` (45) is Platinum's `Message`. So the translation goes by meaning, command by
command, not by number. Most control flow carries over directly: HeartGold's `Compare` then `GoToIfNe label` is
Platinum's `CompareVar` then `GoToIf` with the same condition.

## Standard scripts

HeartGold's standard scripts (`CallStd`, `include/constants/std_script.h`, 679 of them) are numbered from 2000 like
Platinum's common scripts. The most used: the trainer battle script (390 uses), Rock Smash (103), item gifts (88 +
20), a full bag (75), Cut (48), marts (42 + 33 + 14), Apricorn trees (31), Strength (29), the Pokémon Center's
nurse and Wi-Fi counters (25 each, one per Pokémon Center), saving (18). They map to Platinum's common scripts by
meaning; the HeartGold-only ones (Apricorn trees, the deliverymen) are added.

## Text

HeartGold's message banks (`files/msgdata/msg/*.json`) have Platinum's layout (`key`, then `messages` with `id` and
`en_US` lines) and the same control codes (`{STRVAR_1 ...}`, `{COLOR ...}`, `{YESNO ...}`). Every code HeartGold
uses is in Platinum's text encoder (`decomp/tools/msgenc/charmap.txt`) except `TRNAME` (10 uses). Each map's bank
becomes a Platinum text bank, appended to `generated/text_banks.txt` (the bank number is its place in that list) as
`res/text/hgss_*.json`.

## Numbers in scripts

- Flags and vars: as for events (`docs/MapConversion.md`): HeartGold's per-map, object-sprite and script vars keep
  their numbers; the rest move to `FLAG_HGSS_*` (2912 + f) and `VAR_COMPLETE_*` (0x4030 on).
- People: the `LOCALID` constants are HeartGold's object names, from the converted events files.
- Items, species, moves: by name, through Sovereign's lists. 65 of HeartGold's 69 items past Platinum's 467 aren't in
  Sovereign (it has the GS Ball): the seven Apricorns and Kurt's nine balls (Fast, Level, Lure, Heavy, Love, Friend,
  Moon, Sport, Park), the Red Scale, SquirtBottle, Card Key, Pass, Machine Part, the Pokégear's data cards and the
  other key items. They are added to Sovereign's item list first; Sovereign's numbers past Platinum's are later
  games' items, so HeartGold's numbers can't be kept.
