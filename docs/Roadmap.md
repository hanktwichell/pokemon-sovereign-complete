# Pokémon Sovereign Complete: Roadmap

_Drafted Oct 28, 2026; updated Oct 29. Work started Oct 29, 2026, on the owner's go-ahead: steps 1 and 2 are done, 3 to 5 are under way (`docs/Progress.md` is the log, `docs/Features.md` and `docs/Music.md` the plans for steps 5 and 6)._

## Summary

| | Fast case | Slow case |
|---|---|---|
| Building (Claude, nonstop) | 26½ days (about 4 weeks) | 51 days (about 7½ weeks) |
| Your playthrough (80–120 hours at 2 h a day) | 40 days | 60 days |
| Start to release | about 8 weeks | about 12½ weeks |

Your playthrough starts once Johto and Kanto are playable (after step 4) and runs alongside the later steps. The game
starts in Johto, so the regions you play first are the first ones finished. Release
comes 3 days of final fixes after whichever finishes last. Playing more hours a day shortens the calendar; at 4 hours
a day, release is about 5–8 weeks from the start.

## Why Sovereign Platinum is the base

The 1025 Pokémon, every form and the Champions battle rules live deep inside Platinum's code. Bringing Johto and Kanto
to Sovereign keeps all of that as it is. Moving it the other way, into HeartGold, would mean redoing most of it.

**Comes with Sovereign:** all 1025 Pokémon and every form; Mega Evolution and Primal Reversion; Champions battle rules,
Gen IX moves and abilities; per-Pokémon trainer teams and the doubles AI; options and quality-of-life features; the
automated test tools.

**New for this game:** Johto and Kanto's maps, people and story; Sacred Gold's trainers and wild Pokémon; the HeartGold
features we keep; Johto and Kanto's music; a bigger save file; a three-region Town Map and the links between regions.

## Steps

| # | Step | Who | Days | Done when |
|---|---|---|---|---|
| 0 | **Before starting.** Release Sovereign Platinum; answer the open decisions below; add Sacred Gold's patch files to this repo (Drayano's okay is given) | You | — | Sovereign is out and the decisions are answered |
| 1 | **Groundwork.** New project from the finished Sovereign; room in the save for about 2,250 more story markers; a plan for the full sound memory; tools that convert HeartGold's maps, scripts and data; a first following-Pokémon prototype | Claude | 2–4 | The project builds and boots with the bigger save, and one Johto map converts cleanly |
| 2 | **Maps.** All 541 Johto and Kanto maps with buildings, collision and connections; the three ferry ports and the Sinjoh Ruins path | Claude | 3–6 | Every new map loads in the visit-every-map test |
| 3 | **Events and scripts.** Translate about 965 HeartGold script files (113,000 lines) into Platinum's script language: every person, sign, gym, cutscene and Team Rocket scene. The biggest step | Claude | 5–10 | Every person, sign and trigger on the new maps runs to its end in the automated test |
| 4 | **Sacred Gold's content.** Trainers, wild Pokémon by time of day, items, gifts and trades, rebuilt on Sovereign's 1025 Pokémon and trainer format | Claude | 2–4 | Every new trainer battles cleanly and every wild table matches the plan. Your playthrough can start |
| 5 | **HeartGold features.** The ones kept below | Claude | 6½–12 with the default picks | Each kept feature works in the test build |
| 6 | **Music.** Johto and Kanto's soundtracks, fitted into sound memory that's already full | Claude | 1–3 | Every new map plays its own music with no memory errors |
| 7 | **Joining the world.** Town Map and Fly map for three regions; the ferry menu at each port and its unlocks; level curve and level caps across 24 gyms and 2 Leagues. Sinnoh comes third, so its trainers, wild Pokémon and Totem trials move up to follow Kanto, with teams evolved and movesets updated to match | Both | 5–8 | A new game plays from New Bark Town to Spear Pillar with no dead ends |
| 8 | **Automated testing.** Sovereign's test tools over every new map, trainer, gift and event, plus the fixes they turn up | Claude | 2–4 | Every test passes |
| 9 | **Your playthrough and fixes.** All three regions at Drayano's difficulty; you report, Claude fixes as you go | You + Claude | 40–60 at 2 h a day | You finish with no blockers left |
| 10 | **Release.** Final fixes, then `.xdelta` patches for Platinum, made the same way as Sovereign's | Both | about 3 | Each patch rebuilds the game exactly |

Two Claude sessions at once, as on Sovereign, could build Johto and Kanto side by side and shorten steps 2–4.

## Decisions (step 0)

### Decided

- **The owner's answers to the 23 open questions (Nov 6, 2026)**, by the progress page's numbers. Who does what: the
  playtest session (branch `claude/cool-bohr-b3a91c`, `docs/PlaytestIssues.md`) takes the owner's playtest notes,
  including turning the following Pokémon off (16) and the playtest patch (23); this session takes the rest.
  1. **Sinnoh's opening:** the first ship to Sinnoh lands in Canalave City. Rowan meets the player there and invites
     them to his lab in Sandgem Town, where the player may choose a Sinnoh starter. The people who block the way from
     Canalave City to Jubilife City go. Sinnoh's HM givers give TMs or Mega Stones instead (Claude proposes, the
     owner confirms: the progress page's reminder).
  2. **The Rapid Ferry:** a fast S.S. Aqua with no passengers to battle, between Vermilion City or Olivine City and
     Canalave City. Canalave's boat to Iron Island also offers a rush to Olivine City or Vermilion City. Every Rapid
     Ferry trip uses the Iron Island boat's animation. *Done: the ferry network's trips other than the cruise, named
     the Rapid Ferry in the sailors' words (Nov 6).*
  3. **The level curve stays** (Sinnoh after Kanto, as now); the gyms aren't normalized. Byron's gym in Canalave City
     may need its levels lowered if nothing in the story holds it back now that Canalave City is the way in.
  4. **Cynthia stays hard;** a good matchup should beat her.
  5. **Northern Honshu stays empty.**
  6. **An HM earned in Johto works everywhere** (with the badge rules as they are).
  7. **Every HeartGold feature is ported,** whether or not the game uses it: HeartGold's photo album first.
  8. **The Pokéathlon is ported** too.
  9. **The Berry Pots, the Unown Report and the Dowsing Machine are ported.** *Done Nov 6: all three, from the bag
      or on Y (`docs/Features.md`).*
  10. **Trade evolutions:** a trade-evolution item is used from the bag like a stone; a trade evolution with no item
      becomes a level-up evolution. *Done Nov 6: at Lv. 37; Sacred Gold's Covenant Orb still works too
      (`docs/Features.md`).*
  11. **HMs:** Whirlpool is HM05 (as in HeartGold); Defog becomes a new HM09, found where Platinum has it. An HM can
      be forgotten without the Move Deleter. *Done Nov 6 (HM moves were already forgettable in Sovereign).*
  12. **The Town Map:** the Cherrygrove City guide gives it; Jubilife's Trainers' School gives a Mega Stone instead.
      The owner redraws the map in one style (19). Once the Sinjoh Ruins are unlocked, Fly reaches them from anywhere
      in Sinnoh or Johto (Mt. Silver and the Indigo Plateau too), and from the Ruins Fly reaches anywhere in Sinnoh or
      Johto. *The Town Map and the Trainers' School: done Nov 6 (Barry's parcel holds Altarianite, Claude's pick, for
      the owner to confirm). Fly to and from the Sinjoh Ruins: done Nov 6 (not from Kanto, as asked).*
  13. **The Pal Parks hold the regional forms:** Sinnoh's Pal Park Paldea's and Hisui's, Kanto's Pal Park (open
      earlier) Alola's and Galar's, about as many in each. *Done Nov 6 (`data/complete/pal_parks.yaml`,
      `docs/PalParks.md`): every regional form is in one of them, Kanto's open from the start with no Catching Show.
      Hisui and Paldea have 21 forms to Alola's and Galar's 37, so Sinnoh's park has fewer (a question for the
      owner: Hisui's new species, Wyrdeer, Kleavor, Ursaluna, Sneasler, Overqwil and Basculegion, could even it).*
  14. **Link play** waits: on the to-do list for when nothing else is left, and out of the build until then.
  15. **Event-only encounters:** as Sacred Gold has them.
  16. **No following Pokémon:** the player's Pokémon no longer walk behind them (too many issues); the code stays, off,
      in case it comes back. *Done Nov 6: `COMPLETE_FOLLOWER_ENABLED` (include/complete_follower.h) is FALSE.*
  17. (Moot with 16.)
  18. **The Trainer Card shows all 24 badges,** Johto's, Kanto's and Sinnoh's in that order, each in its own game's art.
      The owner wants a preview.
  19. **The Town Map's art:** the owner draws new maps; the regions will be made to fit together.
  20. **The Pledges are in:** a tutor teaches them to the starters (with the combinations), on Pokémon Champions'
      battle rules and learnsets. *Done Nov 6: the tutor in Elm's lab (every starter line, Gen I to IX) and the
      combinations as in Gen VI on (`docs/Features.md`, "The Pledges").*
  21. **Fly is Platinum's** (the Town Map); the Pokégear's fly map goes. *Fly already opens the Town Map everywhere
      (Nov 5); the Pokégear's fly map and the Fly list before it were taken out on Nov 6.*
  22. The owner's playtest notes are in `docs/PlaytestIssues.md` (the playtest session).
  23. **Builds for the owner are xdelta patches** (`tools/complete/make_playtest_patch.sh`).
- **Sinnoh's top levels (Nov 6, 2026).** With Roark's ace at Lv. 72, Cynthia's first ace is no higher than about 88
  to 90, and her rematch's 96: the level plan's points are now Sovereign's 78 → 89 and 89 → 96 (the Elite Four at 87
  to 88, their rematches 92 to 95).
- **The owner's note (Nov 6, 2026): people where Sinnoh's HMs used to hold the player back.** The player reaches
  Sinnoh with every HM from Johto and Kanto, and Sinnoh's HM givers now give Mega Stones, so the trees, rocks, water,
  boulders, cliffs and waterfalls that kept Platinum's story in order no longer do. Each such place needs a person
  (or another story block) standing in the way until the point Platinum's HM would have opened it. *Done Nov 6: five
  places from a survey of every Sinnoh map, and Route 221's workers (`docs/Features.md`, "People where Sinnoh's HMs
  held the player back").*
- **The owner's note to remember (Nov 6, 2026): the Elite Four's rematch teams should be slightly better than their
  first teams** (in both Leagues). *Checked Nov 7 (`docs/E4Rematches.md`, `tools/complete/compare_e4_rematches.py`):
  all 19 rematch teams already outlevel their first teams and hold as many items or more; two small points for the
  team review (Will's rematch Gardevoir holds nothing, Koga's rematch has two lighter Pokémon). Nothing changed yet.*
- **To do (the owner, Nov 6, 2026): every sprite in Sovereign Platinum ported to Sovereign Complete** (Pokémon
  fronts, backs, forms and icons, trainers, overworld sprites), checked against Sovereign's own folders. *Checked Nov 6
  (`tools/complete/check_sovereign_sprites.py`, against Sovereign's latest commit): all 23,162 of Sovereign's images
  are in Complete unchanged, but for its 710 Pokémon box icons, which are Pokémon Showdown's (the owner's call). Rerun
  it after each sync.*
- **The player is Ethan or Dawn (Nov 6, 2026).** The boy is HeartGold's Ethan (overworld, battle back, front
  picture); the girl stays Platinum's Dawn, who has every pose Platinum needs. The player gets graphics of its own, so
  Rowan's assistant in Sinnoh stays Lucas or Dawn; Johto's friend stays HeartGold's (Lyra for Ethan, Ethan for Dawn).
  Lyra instead of Dawn is one setting in `tools/complete/import_hgss_player.py`.
- **Totems' overworld sprites (the owner, Nov 6, 2026).** They should look like the game's other overworld Pokémon
  (Dialga, Palkia, Uxie), not shrunk battle sprites as now (Sovereign's `tools/sprites/make_totem_overworld.py`), and
  stay large to show their size. *Done Nov 6: each is its species' overworld sprite from pokeemerald-expansion
  (drawn in the DS overworld style), doubled to 64×64, Sovereign's orange aura kept
  (`tools/complete/make_totem_overworld.py`). Sovereign's post-game legendaries on the map are the same kind of
  shrunk battle sprite; the same could be done for them if the owner wants.*
- **Box, PC and party icons from Pokémon Showdown (the owner asked, Nov 6, 2026).** Showdown's icon sheet covers every
  species and form; it would replace the PokeAPI placeholders for #494–1025 and fill in forms. Each needs converting to
  the DS's 32×32 two-frame icons in its three shared palettes; a sample sheet first for the owner to look at.
  The sample (Nov 6, 20 Pokémon): Showdown's Gen 8–9 icons are far better than the placeholders (Fuecoco, Quaxly,
  Tinkaton, Pecharunt), and it has real icons for regional forms and Megas (forms show their base Pokémon's icon
  now). The limit is colour: every icon takes one of the three shared 16-colour palettes (`pl_poke_icon`, loaded as 3
  palettes by each screen that draws icons), so Grookey turns olive and Mega Charizard X loses its black. More icon
  palettes would mean each of those screens finding more palette slots; to look at if the owner wants it.

- **Story order (Oct 29, 2026).** Johto, then Kanto, then Sinnoh. The game starts in New Bark Town and ends at Spear
  Pillar, as Sovereign Platinum does.
- **Ferry network (Oct 28–29, 2026).** Three main ports, one in each region: Olivine City (Johto), Vermilion City
  (Kanto) and Canalave City (Sinnoh). Each port's menu offers the other two regions, plus that region's own stops when
  you're already there. The ferry runs whenever the player wants once a route is unlocked; there's no weekly schedule.
  Only Sinnoh has local stops today: Canalave's boat to Iron Island and Fullmoon Island. Snowpoint's ship to the Fight
  Area stays separate. The menus and ferry scenes fit inside steps 2 and 7's estimates.
  **The cruise or straight there (Nov 6, 2026):** between Olivine and Vermilion, after the S.S. Aqua's first voyage,
  the gangway's sailor offers the slow ship (the cruise, to battle its passengers) or the sailing scene and straight
  to the other port.
- **Drayano's okay (Oct 29, 2026).** Given: his games can be used as a base.
- **Following Pokémon (Oct 29, 2026).** Required, as in HeartGold. A first working version comes early, in step 1, to
  prove it before the big conversion work; it counts toward step 5's days.
  **Scrapped (Nov 6, 2026):** "too many issues" in the owner's playtest; the feature is to be turned off
  (`docs/PlaytestIssues.md`, issue 1).
- **Pokéathlon (Oct 29, 2026).** Skipped.
- **Sinnoh's integration (Nov 1, 2026).** Claude devises a provisional one, so the whole game can be played and tested
  now: what arriving in Canalave City starts, Sinnoh's levels after Kanto, level caps for all three regions. Each
  choice sits in one place, so it can change later.
- **Megas (Nov 1, 2026).** In all three regions: the Mega Ring and Mega Stones within reach in Johto and Kanto, and
  Megas for Johto's and Kanto's bosses as Sinnoh's big fights have.
- **Totem trials and legendaries (Nov 1, 2026).** Sovereign's Totem trials and its legendary encounters are spread
  over Johto, Kanto and Sinnoh instead of all being in Sinnoh.
- **Wild Pokémon (Nov 1, 2026).** Every map's wild Pokémon are the original games' own (HeartGold/SoulSilver's in
  Johto and Kanto, Platinum's in Sinnoh), with the Pokémon they don't have mixed in evenly over the three regions
  (`docs/Features.md`, "Wild Pokémon"). Sacred Gold's and Sovereign's own tables are no longer used.
- **A full test and a highlight video (Nov 1, 2026).** Once Sinnoh and the Megas are in: every test, the playthrough
  from New Bark Town to Spear Pillar, and a 1 to 2 minute video of it.
- **HeartGold's sprites (Nov 2, 2026).** Once the full test is finished, every sprite there is access to comes over:
  HeartGold's own people (the gym leaders, Elm, Lyra, Silver, Kurt, Team Rocket and the rest, now drawn with Sinnoh
  stand-ins) and its walking Pokémon. The owner deals with custom or missing Pokémon sprites later. The highlight
  clips are recorded again on that build.
- **The Pokédex (Nov 3, 2026).** HeartGold's Johto Pokédex (256) is the regional Pokédex until the National
  Pokédex; once the player is in Sinnoh, Sinnoh's comes back as the regional choice beside the National.
- **Pokétch and Pokégear (Nov 3, 2026).** Both: a button on the bottom screen switches between them. The Pokégear
  brings the phone's contact list, the radio and the Town Map of Johto and Kanto. Done: the Pokégear on the bottom
  screen with its contact list, the calls the player places from it, its map of Johto and Kanto, its radio with
  HeartGold's twelve shows, and the switch both ways (`docs/Features.md`, "The Pokégear and the Pokétch" and "The
  Pokégear radio"). The radio has no signal in Sinnoh, and the Settings choose HeartGold's six skins.
- **Red at Mt. Silver (Nov 3, 2026).** Post-game: after the end of the whole game.
- **Johto's Battle Frontier (Nov 3, 2026).** Open. Done: its five facilities run Platinum's challenges, and its three move
  tutors teach HeartGold's moves for Battle Points (`docs/Features.md`, "Johto's Battle Frontier").
- **Voltorb Flip (Nov 3, 2026).** Ported to the Game Corners. Done (`docs/Features.md`, "Voltorb Flip").
- **The credits (Nov 3, 2026).** They roll once, at the end of the whole game.
- **One Town Map (Nov 5, 2026).** A single Town Map for all three regions, Sinnoh's and Johto and Kanto's joined into
  one that the player scrolls across, so the game needs only one. Claude makes a first version from the two games'
  own maps. Fly goes only between places in the region the player is in; Johto and Kanto can both fly to the area
  between them. First version in (`docs/Features.md`, "The Town Map of three regions").
- **A photo gallery on the progress page (Nov 5, 2026).** A tab where the owner clicks a region's map (Sinnoh, Johto,
  Kanto), picks a town or route and sees dozens of in-game screenshots of it, with battle screenshots of every gym
  leader, Elite Four member and champion.

### HeartGold features

| Feature | Default | Days | Notes |
|---|---|---|---|
| Following Pokémon | Off (Nov 6: built, then turned off; the code stays) | 4–7 | The biggest single feature. The movement starts from Platinum's own follow-the-player code (Amity Square's walking Pokémon, partner trainers like Cheryl). The behaviour ports HeartGold's follower code (`src/follow_mon.c`, about 2,000 lines): which Pokémon may follow where, surfing, cycling, doors, shiny, forms, talking to it. HeartGold's 627 walking sprites cover #1–493 with female and form variants; #494–1025 and newer forms need a community pack or an artist. Platinum's Sinnoh cutscenes were written without a follower, so each one is checked with a follower out |
| Pokégear phone and radio | Keep | 1–2 | Phone rematches and radio shows; beside the Pokétch or replacing it |
| Bug-Catching Contest | Keep | ½–1 | National Park's timed contest |
| Johto Safari Zone | Keep | ½–1 | Including the objects you place to change what appears |
| Kurt's Apricorn Balls | Keep | ½–1 | The seven Poké Balls Kurt makes |
| Pokéathlon | Port (Nov 6) | 6–10 | A whole separate set of minigames: ported, whether or not the game uses it (plan below) |

**The Pokéathlon's port, in stages (Claude's plan, Nov 6).** HeartGold's Pokéathlon is the biggest piece of its code
pret hasn't decompiled: overlay 96 (the course and its ten events, 1,435 functions, about 109,000 lines of assembly),
97 to 99 and 102 to 103 (the record screens and the course's parts), against about 2,800 lines for the Dowsing
Machine. Each stage is written in C from the assembly, as the other HeartGold screens were, and goes in when it plays
and has its test:
1. **The Dome without the events:** HeartGold's Pokéathlon save (Athlete Points, data cards, the day's prizes, the
   records) in its own save sector, as the photo album's is, so saves keep their size; the two prize counters paid
   in Athlete Points (HeartGold's `ScrCmd_771`, 772, 834, 835: Platinum's Battle Point shop, with HeartGold's lists);
   the four record screens (`ScrCmd_712`); the Pokémon's performance (Speed, Power, Skill, Stamina, Jump) from
   HeartGold's data.
2. **The course:** entering a course with three Pokémon, the course's flow from event to event, the results and the
   points (overlay 96's state machine and overlays 97 and 98).
3. **The ten events,** one at a time: Hurdle Dash, Pennant Capture, Relay Run, Block Smash, Disc Catch, Lamp Jump,
   Circle Push, Snow Throw, Goal Roll and Ring Drop. The link-play parts stay out with the rest of link play (answer 14).

**How stage 2 could go faster (Claude's proposal, Nov 6).** Writing overlay 96 in C by hand, as the smaller screens
were, would take weeks (about 109,000 lines of assembly). HeartGold's assembly could instead be assembled as it is
(Complete's build assembles with the same assembler pret uses) and linked against a compatibility layer: a C file of
HeartGold-named functions over Platinum's (overlay 96 calls 473 distinct engine functions, most the same Game Freak
code under another name), with HeartGold's NARC, text bank, sound and heap numbers translated where they're passed,
and its 39 direct reads of `gSystem` checked against Platinum's layout. A first try on a small overlay (97, 2,900
lines) would show whether it holds before the course is attempted.


**The trial on overlay 97 (Claude, Nov 7):** it holds. Overlay 97 and the two HeartGold
main-module files it calls (8,400 lines of assembly in all) assemble unchanged with Complete's assembler and link into
an overlay of their own; the release build boots and the main module keeps its size (docs/Progress.md, Nov 7). Of
their 150 engine symbols, 114 are the same Platinum function under another name (97 of them the same machine code),
26 need a shim and 8 are HeartGold's own. For overlay 96, `tools/complete/hgss_asm_symbols.py` finds 461 symbols
(6,235 calls): about 330 the same function (268 by their code, 28 the compiler's runtime, about 36 by hand), about
50 shims (sounds, fonts, NARCs and text banks by number, touch, HeartGold's TextOBJ as Platinum's FontOAM, link play
left out) and about 80 HeartGold's own (47 the course's own C and data in pret, 11 overlay 98, 14 its save and the
Apricorn Box, 8 more). Its 36 references to gSystem are fixed by the import (27 point at the touch fields and move;
9 point below them, and the 24 touch reads through those move instead). Estimate: 9 to 13 days this way
(3 to 4 for the compat layer, 1 to 2 for the save in HeartGold's layout, 1 to 2 for the graphics, text and sound
imports, the rest to run each event and test it), against about 4 to 5 weeks writing 109,000 lines in C (overlay 99's
8,200 lines took a day). The risks: the course packs a species in 9 bits (its records: about 20 9-bit masks and shifts to check) and
draws only species up to 493 as walking sprites; struct layouts are checked only where the assembly calls through
Platinum's functions, not where it reads an engine structure's fields itself (none seen in overlay 97); the course's
heap is 0x72000 of an application heap 64 KB smaller than HeartGold's; and the course stays assembly: a change to
it is a shim or an edit of the assembly.

**Overlay 97 ready to run (Claude, Nov 7; same branch):** its archives and text are in (HeartGold's four archives
packed into one, `application/complete/pokeathlon.narc`, so the course's archives can join it at no cost to main
memory; banks 278 and 298) and a test build opens it from the field (`gCompleteTestPokeathlonSelect`), in a heap of
HeartGold's course size (0x72000, which fits with the field closed: the field map gives back 0xCC000). Not yet run:
the owner tests it (docs/Progress.md, Nov 7).

**The course assembled (Claude, Nov 7; branch `wip/pokeathlon-course`):** HeartGold's overlay 96 (the course and its
ten events), its overlay 98 and the TextOBJ file they call are in Complete's build as HeartGold's own assembly, with
pret's C for the course's frame, every one of their 502 engine symbols named (291 Platinum's own function, 126
shims, the rest the course's own and the compiler's), in the overlays `complete_hgss_compat` (the shims, shared with
what comes next by this route), `complete_pokeathlon_course`, and after it overlays 97 and 98; the release build
links and boots with its main module unchanged. The save is reached through HeartGold's accessors over a working copy
of Complete's (the records' species packed in Complete's 11 bits by patches to the assembly), the performance is
Complete's data read as HeartGold reads it, and a test build starts a course from the field
(`gCompleteTestPokeathlonCourse`, `tools/complete/test_pokeathlon_course.py`). Left: running it (the owner's test:
each state and event, as far as it goes), the Pokéathlon's own songs and 60 sound effects (not in Complete's sound
archive yet: silent until `import_hgss_sound.py` brings them in, and the sound memory test), the Dome's reception's
command (HeartGold's 611) to start a course in the game, and whatever the run turns up event by event (stage 3).

**The course's first run (Nov 7; merged into main):** the Speed Course plays from the choice of three Pokémon through
the opening, Hurdle Dash, Pennant Capture and Relay Run, to the results (380 points) and back to the field, its heap
returned whole (`test_pokeathlon_course.py`: 46 states and events, 0 problems). The other four courses and seven
events haven't been run yet. Seen in that run and since fixed (Nov 7): the event intro screens' bottom icons and
start button drew black (HeartGold's sprites keep their cells' palettes for a template palette of 0xFFFF; Platinum's
overrode them); no Pokéathlon song or effect played (its 7 songs, fanfare and 62 effects are in the sound archive
now, after winning back the sound memory they took: `docs/Music.md`, item 7). The results screen's top strip looked
garbled in that first run; no run since the font fix below has shown it (the Hurdle Dash's "11th" is a place among
the twelve runners). Still open: species past 493 run as Ditto;
an event's text may show control codes Platinum lacks; tied results may sort differently from HeartGold's (the SDK's
sort isn't linked, Complete's replaces it). One of the Aprijuice port's fixes to the shared layer reaches the course
(HeartGold's font numbers now translated in every printer and in the width check, which the course calls too).

**The reception (Nov 7):** the Dome's reception starts a course in the game (HeartGold's standard scripts 9850 to
9852 and its `Pokeathlon` command, `CompletePokeathlon`): joined, the Speed Course played through its three events
and the points given back in the lobby, in a test that talks to the nurse as a player would.

Done so far (Nov 6): stage 1's save, the two prize counters, the Athlete Points box, the Dome PC's records, the
reception's totals, all four record screens (`ScrCmd_712` 0 to 3: course records, medals, event records, trophies;
HeartGold's overlay 99's apps, in C), the Friendship Room's statues and the performance data (HeartGold's for its 493
and their forms, provisional stars from base stats past that: `data/complete/pokeathlon_performance.json`; the
archive and the code that reads it come with their first user). Left in stage 1: the Aprijuice stand
(`ScrCmd_740`, 741: it runs HeartGold's Apricorn Box app, overlay 58, in a juice mode, and the juice changes a Pokémon's
performance; Complete keeps Apricorns in the bag, so the juice mode needs its own way to pick them) and the code that
works out a Pokémon's stars for the day (HeartGold's CalcBoxMonPokeathlonPerformance: its nature, personality and the
date move each stat within its range).

**The Aprijuice stand, sized (Claude, Nov 7).** HeartGold's stand (the Dome's three clerks, `scr_seq_0122_D49`: the
first talk gives the Apriblender; each clerk sells the juice of the day, `ScrCmd_741` its label, richness, smoothness
and price; buying opens `ScrCmd_740`, the Apricorn Box app in its fourth mode, where a party Pokémon drinks it) and
the player's own juice (the Apricorn Box from the bag, its Apriblender mode: Apricorns in, 100 steps to blend) are
HeartGold's overlay 58 (597 lines of assembly, the app's frame: it runs overlay 59 and the party menu in turn),
overlay 59 (9,629 lines, 163 functions: the box, the blender, the juice) and its main module's Apricorn Box save
code (`unk_02031B0C`, 1,627 lines). By the course's route (HeartGold's assembly as it is): 213 engine symbols, 137
the same code in Platinum; most of the rest are the course's too (windows, text, sprites, overlay managers), so it
goes after overlay 96's compatibility layer. What Complete adds: the Apricorn Box's counts are the bag's Apricorns
(Kurt's port keeps them there); the box's other 0x80 bytes (the blender, its step count, the stand's three juices)
and each party Pokémon's juice (HeartGold keeps five bytes a party slot in the Party, which Platinum's save can't
grow) go in the Pokéathlon's save sector, the juice found by the Pokémon's personality. That sector's size is pinned
to the whole sector first (a size change makes a saved sector unreadable; nothing in it can be earned in play yet,
so a change now loses nothing). The box's code goes in the app's overlay, not the main module (main memory is
nearly full); the stand's label (`ScrCmd_741`) needs some of it on the field, from overlay 7 or a small copy.

### Still open

The questions open until Nov 5 were all answered on Nov 6 (above, "The owner's answers"). Open now:
- **What Sinnoh's HM givers give instead** (Claude's proposal; **the owner confirmed it, Nov 6**):
  Cynthia in Eterna City (was HM01 Cut) Garchompite Z; the Galactic Warehouse's item ball in Veilstone City (HM02
  Fly) Staraptite; Cynthia's grandmother in Celestic Town (HM03 Surf) Galladite; Riley on Iron Island (HM04
  Strength) Lucarionite; the Oreburgh Gate's hiker (HM06 Rock Smash) Excadrite; Crasher Wake in Pastoria City (HM07
  Waterfall) Sharpedonite; Snowpoint Temple's last floor (HM08 Rock Climb) Froslassite; Platinum's Defog (HM05) stays
  where it is, as the new HM09. Every one is also sold in Sovereign's Mega Stone shops; these are early gifts.
- **Byron's levels** once Canalave City is the way into Sinnoh (answer 3).
- **The Pokéathlon performance of Pokémon past #493** (Nov 6): HeartGold has Speed, Power, Skill, Stamina and Jump
  stars only for its 493. Provisional, until the owner decides: stars from base stats, a rule fitted to HeartGold's
  own (40-52% exact, 83-96% within one star on its species), each entry a line of
  `data/complete/pokeathlon_performance.json` (`tools/complete/import_hgss_performance.py`; the owner's own lines are
  kept on a rerun). Options: keep it; copy an older relative's stars where there is one; set some by hand.

Hoenn and the Sevii Islands aren't in scope. There's no DS version of Hoenn, so it would be built from scratch.

## Scope

| | Johto + Kanto (HeartGold) | Sinnoh (Sovereign today) |
|---|---|---|
| Map headers | 541 | 596 |
| Script files | 965 | 1,144 |
| Lines of script | 112,859 | 99,890 |
| Story flags | 2,246 named | 2,912 total, about 24 spare |

Johto and Kanto together are close to a second Sinnoh.

## Risks

| Risk | Why | If it's harder than expected |
|---|---|---|
| Save room | Sovereign has about 24 spare story markers; Johto and Kanto use about 2,250. Sovereign has its own save format, so the save can grow, but it has to happen first and carefully | 2–4 more days |
| Sound memory | Already full; it's why the new Pokémon have no cries yet. Johto and Kanto's music adds to it | 2–3 more days, or some areas share tracks |
| HeartGold-only script commands | Phone calls, following Pokémon in cutscenes and similar have no Platinum equivalent; each is rewritten by hand | Already in step 3's high end |
| Art | The Town Map and walking sprites need an artist or a community pack | Can hold up the release, not the build |

## Game files

- **HeartGold and Platinum:** nothing needed. Both decompilations rebuild exact copies of the US games from source
  (pokeheartgold: HeartGold SHA-1 `4fcded0e2713dc03929845de631d0932ea2b5a37`).
- **Renegade Platinum patches:** already in the Sovereign Platinum repo.
- **Sacred Gold patches:** you download them from Drayano's official release and add them here at step 0. One of
  Sacred Gold or Storm Silver is enough.

## How the numbers were measured

- Johto and Kanto: the pret/pokeheartgold source code (`include/constants/maps.h`, `files/fielddata/script/scr_seq`,
  `include/constants/flags.h`).
- Sinnoh: Sovereign Platinum's source code (`decomp/generated/map_headers.txt`, `decomp/res/field/scripts`,
  `decomp/include/vars_flags.h`; spare flags counted as `FLAG_UNUSED_*`).
- Pace: Sovereign's history. About 320 merged changes between Oct 21 and Oct 28, 2026, and the Renegade port's 41 parts
  in about 20 hours on Oct 24. This job is a different kind of work: Sovereign changed a world Platinum already had;
  here a whole world comes from another game and every script is translated.
- Days are days of one Claude session running nonstop. Playthrough hours are an estimate for three regions at
  Drayano's difficulty. A small test port at step 1 will firm everything up.
