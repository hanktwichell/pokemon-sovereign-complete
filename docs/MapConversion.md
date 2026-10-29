# Bringing HeartGold's maps into the engine

How a Johto or Kanto map gets from the HeartGold source (`.cache/pokeheartgold`, pinned in `HEARTGOLD_COMMIT`) into
Sovereign Complete's Platinum engine. Findings first; the converter follows them.

## Land data (map blocks)

Each map block is one 32x32-tile piece of a map: its collision and tile behaviours, props (buildings), 3D model and
terrain heights.

| | Platinum (`decomp/res/field/maps/data/map_data_NNN.bin`) | HeartGold (`files/a/0/6/5`, a NARC) |
|---|---|---|
| Count | 666 | 676 |
| Header | 4 u32 sizes: permissions, props, model, terrain (BDHC) | the same 4 sizes, then u16 `0x1234` and a u16 size |
| Extra section | none | background sounds (that size; 0 in most blocks) |
| Then | permissions (2,048 bytes: 32x32 x u16), props, model (NSBMD), BDHC | the same four sections |

So a block converts by dropping HeartGold's 4-byte marker and its sound section, then:
- **props**: each entry names a building model, which moves to Platinum's building archive with a new number;
- **permissions**: each tile's behaviour byte is translated where the two games number behaviours differently
  (still to compare: tall grass, water, ledges, warps and the HeartGold-only ones such as headbutt trees);
- **model and BDHC**: kept as they are; the model's textures come from the area's texture set (below).

## Map matrices

HeartGold's `files/fielddata/mapmatrix/map_matrix/*.bin` is the binary that Platinum builds from its JSON
(`decomp/res/field/matrices/map_matrix_NNN.json`): u8 width, u8 height, u8 has-headers, u8 has-altitudes, u8 name
length, the name, then the header IDs (u16 each), altitudes (u8) and land data IDs (u16). A HeartGold matrix becomes a
Platinum JSON with its header and land data IDs renumbered.

## Map headers

Platinum: `decomp/include/map_header.h`, data in `include/data/map_headers.h`. HeartGold: the same files in its tree.

| Platinum | HeartGold |
|---|---|
| areaDataArchiveID | areaDataBank |
| preloadedMapObjectsArchiveID | moveModelBank (4 bits) |
| mapMatrixID | matrixId |
| scriptsArchiveID, initScriptsArchiveID | scriptsBank, scriptHeaderBank |
| msgArchiveID | msgBank |
| dayMusicID, nightMusicID | dayMusicId, nightMusicId (HeartGold's sound archive) |
| wildEncountersArchiveID | wildEncounterBank |
| eventsArchiveID | eventsBank |
| mapLabelTextID, mapLabelWindowID | mapsec, areaIcon |
| weather, cameraType, mapType, battleBG, bike/run/escape rope/fly | the same, in other bit widths |
| (none) | worldMapX/Y, regionNo, momCallIntroParam, outgoing/incoming calls, radio signal |
| (none) | **followMode**: where following Pokémon may follow on that map |

HeartGold-only fields go to a Sovereign Complete side table, keyed by map header ID: the Pokégear (world map, calls,
radio) and the following Pokémon's rules read it.

## Area data, textures and buildings

Platinum: `decomp/res/field/area_data/area_data_NNN.json` (77; each names a prop set, a texture set and a lighting
set) and `decomp/res/field/maps/texture_sets/map_texture_set_NNN.nsbtx` (76).

HeartGold keeps the same pieces in numbered NARCs (`files/a/...`), identified by their contents
(`tools/complete/narc.py`):

| HeartGold | Contents | Role |
|---|---|---|
| `a/0/4/0` | 340 BMD0 models | outdoor building models |
| `a/1/4/8` | 222 BMD0 models | indoor props, probably |
| `a/0/4/2` | 106 x 8 bytes | area data (building set, texture set, ...) |
| `a/0/4/3` | 104 small lists | the buildings each area uses |
| `a/0/4/4` | 106 BTX0 | map texture sets |
| `a/0/7/0` | 104 (94 BTX0) | building texture sets |

These get appended after Platinum's own, with new numbers, and the converted area data and land data point at them.

HeartGold's area record (`a/0/4/2`) is four u16: the building list (`a/0/4/3`), the texture set (`a/0/4/4`), a third
field that is 0xFFFF on many maps (likely "no animated textures") and a fourth that looks like outdoor/indoor and
lighting. A building list is a u16 count and that many building model numbers, like Platinum's prop model sets
(`decomp/res/field/props/model_sets`).

## Tile behaviours

`tools/complete/compare_tile_behaviors.py` lines up Platinum's `include/constants/field/map_tile_behaviors.h` with
HeartGold's `include/constants/metatile_behavior.h` by name:
- 40 named behaviours have the same name and number in both games;
- reflective water moved: HeartGold 0x2D, Platinum 0x2C, and HeartGold's 0x2C is magma, so that number needs
  translating in both directions;
- 15 named behaviours are HeartGold's own: headbutt trees, whirlpools, magma, ladders (3), sliding (4, the Ice Path)
  and its stop, Rock Climb walls (2), snow and the empty trash can (Vermilion Gym's puzzle). Some exist in Platinum
  under other names (Platinum has Rock Climb), so they still need matching by meaning; the rest need engine support
  before their maps work fully.

## Still to compare

- The rest of the tile behaviours by meaning (the unnamed numbers and the HeartGold-only ones).
- Events (`files/fielddata/eventdata/zone_event/*.json` vs `decomp/res/field/events/*.json`) and scripts (step 3).
