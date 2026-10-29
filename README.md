# Pokémon Sovereign Complete

Pokémon Sovereign Complete combines Pokémon HeartGold/SoulSilver and Pokémon Platinum to create one complete game with
the entire Gen IV universe: Sinnoh, Johto and Kanto in one world.

It's a ROM hack built on the engine of
[**Pokémon Sovereign Platinum**](https://github.com/hanktwichell/pokemon-imperial-platinum): all 1025 Pokémon and
every form, Mega Evolution and Primal Reversion, and battle rules from Pokémon Champions. Johto and Kanto come over from
HeartGold, with Drayano's **Pokémon Sacred Gold** as the blueprint for their trainers, wild Pokémon and balance. Your
lead Pokémon follows you through all three regions, as in HeartGold.

> **Status: planned, not started.** Work begins after Sovereign Platinum is released. The plan and the time estimate
> are in [`docs/Roadmap.md`](docs/Roadmap.md).
>
> Non-commercial fan project. No ROMs are distributed.

## The world

- **Sinnoh** sits to the north and **Johto and Kanto** to the south, as in the real geography the regions are based
  on (Hokkaido and Honshu).
- Two new links join them:
  - **By sea:** the S.S. Aqua runs between three main ports, one in each region: **Olivine City** (Johto),
    **Vermilion City** (Kanto) and **Canalave City** (Sinnoh). Once a route is unlocked, you can sail from any port to
    the other two regions whenever you like.
    In Sinnoh, Canalave's menu also keeps its local stops, Iron Island and Fullmoon Island.
  - **On foot:** a path from the Ruins of Alph through the Sinjoh Ruins to Mt. Coronet.
- Johto and Kanto stay joined as they are in HeartGold. Snowpoint's ship to the Fight Area stays as it is.
- **The story** runs Johto, then Kanto, then Sinnoh. It starts in New Bark Town and ends at Spear Pillar, as Sovereign
  Platinum does.

## What it's built from

| Part | Source |
|---|---|
| Engine, Sinnoh, the 1025 Pokémon and their forms, Megas, Champions battle rules, test tools | Pokémon Sovereign Platinum, on the [pret/pokeplatinum](https://github.com/pret/pokeplatinum) decompilation |
| Johto and Kanto: maps, people, scripts, music | HeartGold, rebuilt from the [pret/pokeheartgold](https://github.com/pret/pokeheartgold) decompilation |
| Johto and Kanto: trainers, wild Pokémon, items, balance | Drayano's Sacred Gold, used with his permission (patches added at step 0) |

## The plan at a glance

| | Estimate |
|---|---|
| Building | about 4–7½ weeks of nonstop Claude sessions |
| Your playthrough | 80–120 hours of play |
| Start to release | about 2–3 months, at 2 hours of play a day |

Steps, decisions, risks and how the numbers were measured: [`docs/Roadmap.md`](docs/Roadmap.md).

## Game files

No ROMs are needed to develop. Both decompilations rebuild exact copies of the US games from source, and Drayano's
patches apply to those copies, the way Sovereign Platinum got Renegade Platinum's data. Never commit a ROM or a save
file here: `.gitignore` blocks them.

## Credits

- Drayano: Pokémon Sacred Gold and Pokémon Renegade Platinum, used with his permission.
- pret: the pokeplatinum and pokeheartgold decompilations.
- Everything credited in Sovereign Platinum's `CITATIONS.md`.

Pokémon is © Nintendo, Creatures Inc. and GAME FREAK inc. This project isn't affiliated with or endorsed by them.
