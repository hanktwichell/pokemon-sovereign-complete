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

- **Story order (Oct 29, 2026).** Johto, then Kanto, then Sinnoh. The game starts in New Bark Town and ends at Spear
  Pillar, as Sovereign Platinum does.
- **Ferry network (Oct 28–29, 2026).** Three main ports, one in each region: Olivine City (Johto), Vermilion City
  (Kanto) and Canalave City (Sinnoh). Each port's menu offers the other two regions, plus that region's own stops when
  you're already there. The ferry runs whenever the player wants once a route is unlocked; there's no weekly schedule.
  Only Sinnoh has local stops today: Canalave's boat to Iron Island and Fullmoon Island. Snowpoint's ship to the Fight
  Area stays separate. The menus and ferry scenes fit inside steps 2 and 7's estimates.
- **Drayano's okay (Oct 29, 2026).** Given: his games can be used as a base.
- **Following Pokémon (Oct 29, 2026).** Required, as in HeartGold. A first working version comes early, in step 1, to
  prove it before the big conversion work; it counts toward step 5's days.
- **Pokéathlon (Oct 29, 2026).** Skipped.

### HeartGold features

| Feature | Default | Days | Notes |
|---|---|---|---|
| Following Pokémon | Required (decided) | 4–7 | The biggest single feature. The movement starts from Platinum's own follow-the-player code (Amity Square's walking Pokémon, partner trainers like Cheryl). The behaviour ports HeartGold's follower code (`src/follow_mon.c`, about 2,000 lines): which Pokémon may follow where, surfing, cycling, doors, shiny, forms, talking to it. HeartGold's 627 walking sprites cover #1–493 with female and form variants; #494–1025 and newer forms need a community pack or an artist. Platinum's Sinnoh cutscenes were written without a follower, so each one is checked with a follower out |
| Pokégear phone and radio | Keep | 1–2 | Phone rematches and radio shows; beside the Pokétch or replacing it |
| Bug-Catching Contest | Keep | ½–1 | National Park's timed contest |
| Johto Safari Zone | Keep | ½–1 | Including the objects you place to change what appears |
| Kurt's Apricorn Balls | Keep | ½–1 | The seven Poké Balls Kurt makes |
| Pokéathlon | Skipped (decided) | — | A whole separate set of minigames |

### Still open

- **Unlock points (proposed):** the ferry to Kanto after the Indigo League, as in HeartGold; the way to Sinnoh, by
  ferry or through the Sinjoh Ruins, after Kanto's eighth badge.
- **Platinum's opening:** the game now starts in Johto. What happens to Twinleaf Town, Rowan's starters and Barry? For
  example, Rowan offers a Sinnoh starter when the player arrives.
- **Red at Mt. Silver:** before the player leaves for Sinnoh, or saved for the post-game.
- **Level curve:** how far Johto and Kanto compress so that Sinnoh, third, still ends at Spear Pillar by Lv. 100
  (Sovereign's developer battle is Lv. 100).
- **The land between:** northern Honshu, between Kanto and Sinnoh, is empty on the real map. The Sinjoh Ruins path
  could stay short, or become a new area there. A new area is new maps, not converted ones, so it adds days.
- **Megas for Johto and Kanto bosses,** like Sinnoh's big fights after the Eterna Jupiter battle.
- **Pokétch, Pokégear or both:** both use the bottom screen.
- **Johto's Battle Frontier:** keep it (its five facilities, Battle Points and the move tutors who take them), or leave
  it closed, with Sinnoh's as the game's Battle Frontier. Its scripts are in; the facilities' own HeartGold code isn't.
- **The Pokéathlon Dome:** open (the building and its people, without the Pokéathlon) or closed, now that the Pokéathlon
  is skipped.
- **The Hall of Fame and the credits.** HeartGold plays its Hall of Fame and credits after Lance (and the credits again
  after Red), Platinum after Cynthia. For now Johto's League records the team in the Hall of Fame, saves and starts the
  game over at home in New Bark Town, as HeartGold does, without credits; Sinnoh's League keeps Platinum's. Proposed:
  the credits roll once, at the end of the story (Spear Pillar or Sinnoh's League), and every League records the team.
- **Voltorb Flip** at the Game Corners, or Platinum's slot machines, which stand in for now (`docs/Features.md`,
  "Stand-ins"). Porting it is about a day.
- **Art:** who draws the three-region Town Map and the walking sprites for #494–1025 and the newer forms (a community
  pack, credited, could cover most of them).
- **Trade items from the bag:** Sacred Gold lets the trade-evolution items (Metal Coat, King's Rock, Dragon Scale,
  Up-Grade, Dubious Disc, Protector, Electirizer, Magmarizer, Reaper Cloth, DeepSeaTooth, DeepSeaScale) be used from
  the bag like a stone, so no trade is needed. Its own six evolution items are in (Covenant Orb for trades with no
  item, and the rest: `docs/SacredGold.md`). Proposed: the trade items work from the bag too, in all three regions,
  while trading still works.
- **Followers without a sprite yet:** until every walking sprite exists, those Pokémon stay in their Poké Ball, or use
  a stand-in sprite.

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
