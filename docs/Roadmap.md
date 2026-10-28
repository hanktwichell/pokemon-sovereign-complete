# Pokémon Sovereign Complete: Roadmap

_Drafted Oct 28, 2026. Not started: work begins after Pokémon Sovereign Platinum is released._

## Summary

| | Fast case | Slow case |
|---|---|---|
| Building (Claude, nonstop) | 23½ days (about 3½ weeks) | 46 days (about 6½ weeks) |
| Your playthrough (80–120 hours at 2 h a day) | 40 days | 60 days |
| Start to release | about 8 weeks | about 12½ weeks |

Your playthrough starts once Johto and Kanto are playable (after step 4) and runs alongside the later steps. Release
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
| 0 | **Before starting.** Release Sovereign Platinum; get Drayano's okay to build on Sacred Gold; answer the decisions below; add Sacred Gold's patch files to this repo | You | — | Sovereign is out and the decisions are answered |
| 1 | **Groundwork.** New project from the finished Sovereign; room in the save for about 2,250 more story markers; a plan for the full sound memory; tools that convert HeartGold's maps, scripts and data | Claude | 2–4 | The project builds and boots with the bigger save, and one Johto map converts cleanly |
| 2 | **Maps.** All 541 Johto and Kanto maps with buildings, collision and connections; the three ferry ports and the Sinjoh Ruins path | Claude | 3–6 | Every new map loads in the visit-every-map test |
| 3 | **Events and scripts.** Translate about 965 HeartGold script files (113,000 lines) into Platinum's script language: every person, sign, gym, cutscene and Team Rocket scene. The biggest step | Claude | 5–10 | Every person, sign and trigger on the new maps runs to its end in the automated test |
| 4 | **Sacred Gold's content.** Trainers, wild Pokémon by time of day, items, gifts and trades, rebuilt on Sovereign's 1025 Pokémon and trainer format | Claude | 2–4 | Every new trainer battles cleanly and every wild table matches the plan. Your playthrough can start |
| 5 | **HeartGold features.** The ones kept below | Claude | 5½–10 with the default picks | Each kept feature works in the test build |
| 6 | **Music.** Johto and Kanto's soundtracks, fitted into sound memory that's already full | Claude | 1–3 | Every new map plays its own music with no memory errors |
| 7 | **Joining the world.** Town Map and Fly map for three regions; the ferry menu at each port; story order; level curve and level caps across 24 gyms and 2 Leagues; the Sovereign story carried into the new regions | Both | 3–5 | A new game can reach both Leagues with no dead ends |
| 8 | **Automated testing.** Sovereign's test tools over every new map, trainer, gift and event, plus the fixes they turn up | Claude | 2–4 | Every test passes |
| 9 | **Your playthrough and fixes.** All three regions at Drayano's difficulty; you report, Claude fixes as you go | You + Claude | 40–60 at 2 h a day | You finish with no blockers left |
| 10 | **Release.** Final fixes, then `.xdelta` patches for Platinum, made the same way as Sovereign's | Both | about 3 | Each patch rebuilds the game exactly |

Two Claude sessions at once, as on Sovereign, could build Johto and Kanto side by side and shorten steps 2–4.

## Decisions (step 0)

### Decided

- **Ferry network (Oct 28, 2026).** Three main ports, one in each region: Olivine City (Johto), Vermilion City (Kanto)
  and Canalave City (Sinnoh). Each port's menu offers the other two regions, plus that region's own stops when you're
  already there. Only Sinnoh has local stops today: Canalave's boat to Iron Island and Fullmoon Island. Snowpoint's
  ship to the Fight Area stays separate. The menus and ferry scenes fit inside steps 2 and 7's estimates.

### HeartGold features

| Feature | Default | Days | Notes |
|---|---|---|---|
| Following Pokémon | Keep | 3–5 | The biggest single feature. Platinum's Amity Square is a head start. HeartGold has walking sprites for #1–493; #494–1025 and the forms need a community pack or an artist |
| Pokégear phone and radio | Keep | 1–2 | Phone rematches and radio shows; beside the Pokétch or replacing it |
| Bug-Catching Contest | Keep | ½–1 | National Park's timed contest |
| Johto Safari Zone | Keep | ½–1 | Including the objects you place to change what appears |
| Kurt's Apricorn Balls | Keep | ½–1 | The seven Poké Balls Kurt makes |
| Pokéathlon | Skip (suggested) | 5–7 | A whole separate set of minigames |

### Other decisions

- **Story order:** which region comes first and when the others open. It sets the level curve across 24 gyms.
- **Ferry schedule:** every day, or HeartGold's schedule (from Olivine on Mondays and Fridays, from Vermilion on
  Wednesdays and Sundays). When each route first opens goes with the story order.
- **The land between:** northern Honshu, between Kanto and Sinnoh, is empty on the real map. The Sinjoh Ruins path
  could stay short, or become a new area there. A new area is new maps, not converted ones, so it adds days.
- **Megas for Johto and Kanto bosses,** like Sinnoh's big fights after the Eterna Jupiter battle.
- **Pokétch, Pokégear or both:** both use the bottom screen.
- **Drayano's okay:** check Sacred Gold's readme for reuse rules, ask him if it's unclear, and credit him either way.
- **Art:** who draws the three-region Town Map and, if following Pokémon stays, the walking sprites for #494–1025.

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
