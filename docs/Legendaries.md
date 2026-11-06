# Legendaries and mythicals: one of each

The owner's call (Nov 6, 2026): every legendary and mythical Pokémon is met once, in one place, and they're spread over
the three regions. Where HeartGold or SoulSilver has its own in-game encounter, Johto or Kanto keeps it and Sinnoh's copy
goes. The other doubles (Sacred Gold's additions against Sovereign's, from Renegade Platinum) were split to balance the
regions, each Gen IV Pokémon mostly in Sinnoh.

`tools/complete/list_legendaries.py` lists every way to meet each one, from the scripts, the roamers and the placed
legendaries (`data/complete/placed.yaml`), leaving out the copies switched off (its `OFF`). Run it after a change: a
species in two places is marked `DUP` (the ones left are a single quest in steps: see below).

## Where each one is

**Johto: 31**

| Pokémon | Where | From |
|---|---|---|
| Raikou, Entei | Roam Johto from the Burned Tower scene (again after the Hall of Fame) | HeartGold |
| Suicune | The chase from the Burned Tower; the battle on Route 25 (in Kanto) | HeartGold |
| Ho-Oh | Bell Tower roof | HeartGold |
| Lugia | Whirl Islands | HeartGold |
| Groudon, Kyogre, Rayquaza | Embedded Tower (Route 47), with the Orbs from Mr. Pokémon after Red | HeartGold |
| Celebi | Ilex Forest's shrine, with the Azure Flute | Sacred Gold |
| Regirock, Regice, Registeel | Mt. Mortar, Ice Path, Dark Cave, after the Lock Capsule | Sacred Gold |
| Arceus | Sinjoh Ruins, Mystri Stage (the 16 plates, the National Dex) | Sacred Gold |
| Victini, Cobalion, Terrakion, Virizion, Reshiram, Zekrom, Landorus, Kyurem, Keldeo, Enamorus | Olivine Lighthouse, Mt. Mortar, Dark Cave, Ilex Forest, Burned Tower, Dragon's Den, Route 46, Ice Path, Lake of Rage, Route 43 | Sovereign's Unova Chronicle |
| Tornadus, Thundurus | Roam Johto | Sovereign's Unova Chronicle |
| Xerneas, Yveltal, Zygarde, Diancie, Hoopa, Volcanion | Route 37, Route 45, Union Cave, Cliff Cave, Ruins of Alph, Route 47 | Sovereign's Kalos Chronicle |

**Kanto: 29**

| Pokémon | Where | From |
|---|---|---|
| Articuno | Seafoam Islands | HeartGold |
| Zapdos | Route 10, by the Power Plant | HeartGold |
| Moltres | Cinnabar Gym, once the Magma Stone is picked up | HeartGold (Sacred Gold's spot) |
| Mewtwo | Cerulean Cave (then the "???" trainer on its spot) | HeartGold |
| Latias, Latios | The roamer from Steven in Vermilion, then the other at Vermilion's plaque with the Soul Dew | HeartGold (Sacred Gold's Soul Dew) |
| Mew | Viridian Forest (it teleports three times) | Sacred Gold |
| Deoxys | Route 3's meteorites, midnight to 4 am, after the Earth Badge | Sacred Gold |
| Phione | Pewter City | Sacred Gold |
| Tapu Koko, Tapu Lele, Tapu Bulu, Tapu Fini, Magearna, Marshadow, Meltan, Melmetal | Route 10, Lavender Town, Viridian Forest, Route 19, Silph Co., Rock Tunnel, Mt. Moon | Sovereign's Alola Chronicle |
| Zeraora | Roams Kanto | Sovereign's Alola Chronicle |
| Zacian, Zamazenta, Eternatus, Kubfu, Zarude, Regieleki, Regidrago, Calyrex | Route 2, Victory Road, Saffron's dojo, Route 14, the Power Plant, Route 28, Route 22 | Sovereign's Galar Chronicle |
| Glastrier, Spectrier | Roam Kanto | Sovereign's Galar Chronicle |

**Sinnoh: 30**

| Pokémon | Where | From |
|---|---|---|
| Uxie, Mesprit, Azelf | Acuity, Verity and Valor Caverns | Platinum (Renegade's levels) |
| Dialga, Palkia | Spear Pillar | Platinum |
| Giratina | The Distortion World (Turnback Cave if not caught) | Platinum |
| Heatran | Stark Mountain | Platinum |
| Regigigas | Snowpoint Temple (Renegade's temple story, before the Gym) | Platinum (Renegade's story) |
| Cresselia | Fullmoon Island | Platinum (Renegade: a battle) |
| Darkrai | Newmoon Island, after the Harbor Inn's dream | Platinum (Renegade's Member Card) |
| Shaymin | Flower Paradise, with Oak's Letter | Platinum |
| Manaphy | The Pokémon Mansion, after its siege | Renegade |
| Jirachi | Solaceon Ruins, after the three wishes | Renegade |
| Meloetta, Genesect, Type: Null, Cosmog, Necrozma | Contest Hall, Galactic HQ, Galactic HQ, Mt. Coronet, Wayward Cave | Sovereign |
| Wo-Chien, Chien-Pao, Ting-Lu, Chi-Yu, Koraidon, Miraidon, Ogerpon, Terapagos, Pecharunt | Route 212, Lake Acuity, Route 214, Fuego Ironworks, Sendoff Spring, Route 211, Route 224 | Sovereign's Paldea Chronicle |
| Okidogi, Munkidori, Fezandipiti | Roam Sinnoh | Sovereign's Paldea Chronicle |

Met by evolving: Silvally (Type: Null), Cosmoem, Solgaleo and Lunala (Cosmog), Urshifu (Kubfu).

## What was switched off

**Sinnoh's copies** (Sovereign's, from Renegade Platinum):
- Off their maps (`placed.yaml`'s `moved`): Articuno (Mt. Coronet), Zapdos (Valley Windworks), Moltres (Victory
  Road), Mewtwo (Oreburgh Gate), Raikou (Route 208), Entei (Route 211), Suicune (Route 213), Lugia (Route 220), Ho-Oh
  (Lost Tower), Kyogre (Mt. Coronet), Groudon (Stark Mountain), Rayquaza (the League's waterfall).
- Stopped in their scripts (marked `Sovereign Complete: one of each legendary`): Celebi (Eterna Forest's portal: the
  memory battles still play), Mew (Route 201: the hungry Pokémon are still fed, the Pachirisu leaves, no Mew comes),
  Deoxys (Veilstone's meteorites), Latias and Latios (Fullmoon Island's rock), the Regis (Rock Peak, Iceberg and Iron
  Ruins' statues), Arceus (the Hall of Origin).

**Sacred Gold's copies:**
- Off their maps (6666, 6666), as Sacred Gold takes an item ball away (`import_hgss_events.py`'s `SCRAPPED`): Jirachi
  (Mt. Mortar), Shaymin (National Park), the Kimono Girl with the Manaphy Egg (Route 40), Heatran (Cinnabar Island),
  Regigigas (Mt. Silver), the lake and creation trios (Sinjoh Ruins).
- Cresselia and Darkrai: the bed in the player's room has no nightmare (`NO_NIGHTMARE`, earlier the same day).

**Knock-on changes** (the translator's `INSERTS`, written into the scripts too):
- Cinnabar Island: picking up the Magma Stone brings out Moltres in the Cinnabar Gym (it waited for Heatran's catch).
- Sinjoh Ruins: Arceus asks for Sinnoh's Jirachi, Darkrai and Shaymin caught, in place of Sacred Gold's (the other
  conditions are Sacred Gold's: the 16 plates, the National Dex, its Mew, Celebi and Deoxys).

## Left as they are, for the owner

- Some lines still point at encounters that are gone: the Ecruteak Kimono Girl's hint about Jirachi in Johto, the
  Goldenrod Flower Shop girl's about Shaymin, Sinnoh's Azure Flute (the Hall of Origin), Steven's Orbs and Oak's Clear
  Wings in Sinnoh (they called Kyogre, Groudon, Ho-Oh and Lugia there), and the Regi statues' and Lati rock's messages.
- The S.S. Aqua's Plate wants a Manaphy shown, which now comes from Sinnoh after its League (Arceus needs the
  National Dex anyway).
- Phione: Sacred Gold's wild Phione (Routes 40 and 41) left with its wild tables (Nov 1); Pewter's is the one left,
  and Manaphy breeds them.

## Tests

- `tools/complete/test_one_of_each.py`: the Hall of Origin brings no Arceus and Rock Peak Ruins's statue no Regirock.
- `tools/complete/test_hgss_special_events.py`: the encounters kept (the cases of those switched off are out), the
  Magma Stone bringing Moltres out with Heatran hidden, and the bed's rest.
- `tools/complete/test_hgss_sinjoh.py`: Arceus's event with the new conditions.
