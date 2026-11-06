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
     Ferry trip uses the Iron Island boat's animation.
  3. **The level curve stays** (Sinnoh after Kanto, as now); the gyms aren't normalized. Byron's gym in Canalave City
     may need its levels lowered if nothing in the story holds it back now that Canalave City is the way in.
  4. **Cynthia stays hard;** a good matchup should beat her.
  5. **Northern Honshu stays empty.**
  6. **An HM earned in Johto works everywhere** (with the badge rules as they are).
  7. **Every HeartGold feature is ported,** whether or not the game uses it: HeartGold's photo album first.
  8. **The Pokéathlon is ported** too.
  9. **The Berry Pots, the Unown Report and the Dowsing Machine are ported.**
  10. **Trade evolutions:** a trade-evolution item is used from the bag like a stone; a trade evolution with no item
      becomes a level-up evolution.
  11. **HMs:** Whirlpool is HM05 (as in HeartGold); Defog becomes a new HM09, found where Platinum has it. An HM can
      be forgotten without the Move Deleter.
  12. **The Town Map:** the Cherrygrove City guide gives it; Jubilife's Trainers' School gives a Mega Stone instead.
      The owner redraws the map in one style (19). Once the Sinjoh Ruins are unlocked, Fly reaches them from anywhere
      in Sinnoh or Johto (Mt. Silver and the Indigo Plateau too), and from the Ruins Fly reaches anywhere in Sinnoh or
      Johto.
  13. **The Pal Parks hold the regional forms:** Sinnoh's Pal Park Paldea's and Hisui's, Kanto's Pal Park (open
      earlier) Alola's and Galar's, about as many in each.
  14. **Link play** waits: on the to-do list for when nothing else is left, and out of the build until then.
  15. **Event-only encounters:** as Sacred Gold has them.
  16. **No following Pokémon:** the player's Pokémon no longer walk behind them (too many issues); the code stays, off,
      in case it comes back.
  17. (Moot with 16.)
  18. **The Trainer Card shows all 24 badges,** Johto's, Kanto's and Sinnoh's in that order, each in its own game's art.
      The owner wants a preview.
  19. **The Town Map's art:** the owner draws new maps; the regions will be made to fit together.
  20. **The Pledges are in:** a tutor teaches them to the starters (with the combinations), on Pokémon Champions'
      battle rules and learnsets.
  21. **Fly is Platinum's** (the Town Map); the Pokégear's fly map goes.
  22. The owner's playtest notes are in `docs/PlaytestIssues.md` (the playtest session).
  23. **Builds for the owner are xdelta patches** (`tools/complete/make_playtest_patch.sh`).
- **Sinnoh's top levels (Nov 6, 2026).** With Roark's ace at Lv. 72, Cynthia's first ace is no higher than about 88
  to 90, and her rematch's 96: the level plan's points are now Sovereign's 78 → 89 and 89 → 96 (the Elite Four at 87
  to 88, their rematches 92 to 95).
- **The owner's note to remember (Nov 6, 2026): the Elite Four's rematch teams should be slightly better than their
  first teams** (in both Leagues). Not done yet: on the list for when the teams are reviewed.

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
| Pokéathlon | Port (Nov 6) | — | A whole separate set of minigames: ported, whether or not the game uses it |

### Still open

The questions open until Nov 5 were all answered on Nov 6 (above, "The owner's answers"). Open now:
- **What Sinnoh's HM givers give instead** (Claude's proposal; **the owner confirmed it, Nov 6**):
  Cynthia in Eterna City (was HM01 Cut) Garchompite Z; the Galactic Warehouse's item ball in Veilstone City (HM02
  Fly) Staraptite; Cynthia's grandmother in Celestic Town (HM03 Surf) Galladite; Riley on Iron Island (HM04
  Strength) Lucarionite; the Oreburgh Gate's hiker (HM06 Rock Smash) Excadrite; Crasher Wake in Pastoria City (HM07
  Waterfall) Sharpedonite; Snowpoint Temple's last floor (HM08 Rock Climb) Froslassite; Platinum's Defog (HM05) stays
  where it is, as the new HM09. Every one is also sold in Sovereign's Mega Stone shops; these are early gifts.
- **Byron's levels** once Canalave City is the way into Sinnoh (answer 3).

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
