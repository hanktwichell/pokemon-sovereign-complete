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

`tools/complete/import_hgss_headers.py` brings in all 540 of HeartGold's map headers in HeartGold's order, so
HeartGold map n is `MAP_HEADER_HGSS_EVERYWHERE + n` (593 + n) and its name is `MAP_HEADER_HGSS_` + HeartGold's (for
example `MAP_HEADER_HGSS_OLIVINE`). Field by field:
- **area**: `area_data_{075 + areaDataBank}` (from `import_hgss_maps.py`);
- **matrix**: each HeartGold matrix a header uses (280 of 289) becomes `map_matrix_hgss_NNNN.json`, with each cell's
  map header renamed and its land data as `MAP_{666 + block}`. Johto and Kanto's overworld is one 47x17 matrix
  (`map_matrix_hgss_0000`), more cells than Sinnoh's 30x30 is wide but fewer in all (799 of the engine's 900), so it
  fits; the matrix ID moved from u8 to u16 (`include/map_matrix.h`), as HeartGold's matrices run past 255;
- **events**: each events bank becomes `events_hgss_NNN.json`, empty until the events converter fills it;
- **name popup**: location names 0-125 are Sinnoh's in both games (Sovereign calls 55, Pal Park, Regional Forms Park),
  so HeartGold's 126-234 are appended to `res/text/location_names.json` with the same numbers: Pokémon caught in
  HeartGold or SoulSilver show their real met location. The popup style (`areaIcon`) and the battle background have
  the same numbers in both games;
- **weather**: clear 0 -> clear; rain 1 -> raining; snow 5 -> snowing; 11, the caves that need Flash -> Platinum's
  dark (Flash) weather; 13, the Battle Arcade's low light -> Platinum's Battle Arcade weather (30);
- **map type**: city/town, route (outdoors), cave, interior (indoors) by name; HeartGold's leftover Underground map is
  plain (not Platinum's Underground);
- **camera**: HeartGold's own 17 cameras, added after Platinum's as `CAMERA_TYPE_HGSS_*`
  (`src/overlay005/field_camera.c`), with the position offsets some of them use. HeartGold's outdoor camera looks down
  at 48.7°, Platinum's at 59.1°, so Johto keeps its look;
- **music**: Platinum's music standing in by kind (Pokémon Center, Mart, Gym, city, town, route, cave...) until
  HeartGold's sound archive comes in (step 6);
- **scripts, text, wild encounters**: Platinum's empty scripts, a placeholder text bank, none (steps 3 and 4).

HeartGold-only fields go to a side table keyed by map header (`include/data/hgss_map_info.h`, read through
`src/complete_map_info.c`): where following Pokémon may follow, the region (Johto or Kanto; Sinnoh for the rest), the
Pokégear's world map position, Mom's call intro, phone calls and the radio signal.

What HeartGold's 540 headers use:
- weather: 5 values (mostly 0, clear); camera type: 15 numeric values (mostly 4 and 0); map type: interior (326),
  cave (116), route (64), city/town (32), underground (1), invalid (1); battle background: 17 values;
- music: 82 sequences from HeartGold's sound archive;
- **followMode**: allow on 178 maps, height-restricted on 320 (the big followers stay in their ball), prevent on 42.

Engine places that take "on matrix 0" (`MapHeader_IsOnMainMatrix`) to mean "on the overworld": the exit kept for
Escape Rope and Dig (`Field_TrySetMapConnection`) and the Vs. Seeker now use `MapHeader_IsOnOverworldMatrix`, which
also counts Johto and Kanto's (`map_matrix_hgss_0000`). The Town Map, the Pokétch map, the Explorer Kit (the
Underground) and the roamers' map history stay Sinnoh's until Johto and Kanto get their own (the Pokégear, step 5).

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
The area loader keeps one slot per building model number (`MAX_MAP_PROP_MODEL_FILES`, `include/overlay005/area_data.h`);
Platinum's 768 became 1,152 for HeartGold's models (590-1151). With 768, every area that used a model past 767 wrote
past the end of that array into the next heap block: the visit-every-map test caught it on Routes 6, 7 and 11,
Vermilion and Celadon.

HeartGold's area record (`a/0/4/2`, 8 bytes) as its loader uses it (`AreaDataManager_Alloc`, still assembly in
`asm/overlay_01_021FB878.s`):
- u16 building list (`a/0/4/3`); its building textures are `a/0/7/0` at the same index (104 of each);
- u16 map texture set (`a/0/4/4`);
- u16, 0xFFFF on many maps: likely the animated-texture set;
- u8 outdoor: 1 loads building models from `a/0/4/0` (and NARC 0x6B), 0 from `a/1/4/8` (indoor props, and NARC 0x6C);
- u8, 1 on Olivine: likely lighting. A building list is a u16 count and that many building model numbers, like Platinum's prop model sets
(`decomp/res/field/props/model_sets`).

Each building model carries a copy of its textures, which the area's building texture set also holds: Platinum binds
a building to its area's set, uploads that set to VRAM and cuts its texture data out of the field heap, but keeps each
model's own copy in the heap unread. For HeartGold's models that copy is cut off too, once the model is bound
(`src/overlay005/area_data.c`): Ecruteak Gym's four spotlights carry 49 KB each, and with them the field heap ran out
on the way in (the game crashed reading a file into a NULL buffer). Should a model's textures not all be in its
area's set, its own copy is uploaded and bound first, and a copy the same as one already uploaded for the area binds
to that one.

## Building animations

Doors, windmills, water wheels and the gym puzzles' gates and carts are animated building models. HeartGold keeps
them as Platinum does: the animation files (`a/1/0/6`, 273 of them; Platinum's `arc/bm_anime.narc`) and, for each
building model, a list of up to four with its flags (`a/1/0/7` for the outdoor models, `a/1/0/8` for the indoor ones;
Platinum keeps one list for all its models, `arc/bm_anime_list.narc`). HeartGold's list entry has one word more,
whose first byte marks a door and picks its sound (hinged, sliding, the chime of Platinum's Veilstone store, or
HeartGold's own sliding paper door). `tools/complete/import_hgss_prop_animations.py` adds the animations after Platinum's 98
(`res/field/props/animations`) and gives each of HeartGold's models its list entry at its new number (outdoor
590 + k, indoor 930 + k): 240 of HeartGold's 562 models are animated.

The two engines differ in how they play them, and `src/overlay005/map_prop_animation.c` takes HeartGold's ways:
- Platinum loads a model's animations once for its area, and every copy of the model on the map shares them; HeartGold
  loads them for each copy. NNS links a shared animation object into each copy's list, so with two or more animations
  playing on a model, a second copy would link one to itself and the game hung (Route 3, Route 32 and most Kanto towns,
  found by the hidden-item test). An animation already in a copy's list is no longer added again.
- A model with flags 8 has four animations, one per time of day (morning, day, evening, night: windows that light up
  in the evening), and HeartGold shows the current one; 37 of its models do. Platinum has no such flag and played all
  four. The copies now show the first animation's object, which is set up again with the current time's animation when
  the time of day changes.
- Platinum knows its doors from lists in its code (`src/overlay005/ov5_021D431C.c`: walking in and out, and the
  scripts' `LoadDoorAnimation`), so HeartGold's 56 doors were never found: no door opened, and a scene that opens one
  (Mom coming out in New Bark) played an animation that wasn't loaded, writing through a NULL pointer. The import tool
  now writes HeartGold's doors and their sounds to `include/data/complete_hgss_doors.h` for those lists, and a door
  animation that isn't loaded is skipped rather than played.
- HeartGold's towns play up to 14 animations at once (Platinum's 11), besides a door's, so Platinum's limit of 16 a
  map is now 24.

## Tile behaviours

`tools/complete/compare_tile_behaviors.py` lines up Platinum's `include/constants/field/map_tile_behaviors.h` with
HeartGold's `include/constants/metatile_behavior.h` by name:
- 40 named behaviours have the same name and number in both games;
- reflective water moved: HeartGold 0x2D, Platinum 0x2C, and HeartGold's 0x2C is magma, so that number needs
  translating in both directions;
- 15 named behaviours are HeartGold's own: headbutt trees, whirlpools, magma, ladders (3), sliding (4, the Ice Path)
  and its stop, Rock Climb walls (2), snow and the empty trash can (Vermilion Gym's puzzle). Some exist in Platinum
  under other names (Platinum has Rock Climb), so they still need matching by meaning; the rest need engine support
  before their maps work fully. Now all have it (`include/constants/field/complete_tile_behaviors.h`): Headbutt trees,
  whirlpools, Blackthorn Gym's magma, the ladders (pressing up or down on one, or stepping onto a ladder down, takes
  its warp, with Platinum's stairs sound and fade, arriving facing north, as Platinum's arrival would step a player
  facing south off the warp; HeartGold's short climb before the fade isn't ported) and the stop
  tile, which ends a slide on it (Viridian Gym: Platinum's slides go on to a wall). The slides themselves, Rock Climb,
  snow and the trash can are Platinum's at the same numbers.
- Ice Path B1F's boulder holes are HeartGold's code, not a tile behaviour (its `ov01_021F1F8C` and a table of four
  holes): a boulder pushed onto its hole falls through, its flag set and its copy on B2F shown
  (`CompleteMapInfo_BoulderFell`, called after Platinum's Strength push). HeartGold's fade around it isn't ported.
  Strength can't be used on B2F, as in HeartGold, so the fallen boulders stay where they stop the player on the ice.
- Test: `tools/complete/test_hgss_tile_behaviors.py` climbs all 250 ladders, slides along Viridian Gym's first row to
  its stop tile, and pushes Ice Path's third boulder through its hole.

## Events

HeartGold's `files/fielddata/eventdata/zone_event/*.json` and Platinum's `decomp/res/field/events/*.json` hold the
same four lists under other names, field for field:

| HeartGold | Platinum | Remapped |
|---|---|---|
| `bgs`: dir, scriptId, type, x, y, z | `bg_events`: player_facing_dir, script, type, x, y, z | script |
| `objects`: id, spriteId, movement, type, facingDirection, xRange, yRange, eventFlag, scriptId, param0-2, x, y, z | `object_events`: id, graphics_id, movement_type, trainer_type, initial_dir, movement_range_x/z, hidden_flag, script, data (3), x, y, z | sprite, movement type, flag, script |
| `warps`: header, anchor, x, y, z | `warp_events`: dest_header_id, dest_warp_id, x, z | map header |
| `coords`: w, h, val, var, scriptId, x, y, z | `coord_events`: width, length, value, var, script, x, y, z | var, script |

`tools/complete/import_hgss_events.py` converts them, reading the numbers from HeartGold's built events archive
(`zone_event.narc`, whose records have Platinum's layout byte for byte) and the names from its JSON sources:
- **warps**: HeartGold map n -> `MAP_HEADER_HGSS_*`; the arrival warp stays; 4095, back where the player came from
  (the Pokémon Centers' and elevators' exits), means the same in both games (`MAP_HEADER_DYNAMIC`);
- **people and things**: same local IDs, with HeartGold's object names (`obj_T26_seaman_2`) as the `LOCALID`
  constants step 3's scripts will use; same position, facing and range. Movement types 0-46 are the same list in both
  games; the few above (6 objects) look south;
- **flags**: HeartGold's per-map flags (1-64) are Platinum's per-map flags; every other flag f is
  `COMPLETE_FLAGS_START + f` (2912 + f), named `FLAG_HGSS_*` after HeartGold's (`generated/vars_flags.txt`, 2,113
  names), so the hide flags work as in HeartGold. HeartGold uses 2,912 flags and 368 vars, within the 4,096 and 512
  made for them. Vars keep the same scheme for step 3: HeartGold's per-map vars (0x4000-0x401F), object sprite vars
  (0x4020-0x402F) and script vars (0x8000 on) are Platinum's; 0x4030-0x416F become `VAR_COMPLETE_000` on. HeartGold's
  daily flags (0xAA0-0xB5F) will need resetting each day like Platinum's;
- **sprites**: both games kept Diamond and Pearl's numbering for the first 146 (HeartGold's BOY2 is Platinum's
  Youngster, SEAMAN its Sailor), so those keep their number (Platinum's variable sprites sit one later, after its berry
  soil). For HeartGold's own: the Diamond and Pearl sprite of the same kind (GSWOMAN1 -> WOMAN1 -> Pokémon Breeder),
  Sovereign's overworld Pokémon (Suicune, Lugia, Ho-Oh...), or a stand-in (`SPRITE_STAND_INS`: Rocket grunts as
  Galactic grunts, Oak, gym leaders as Sinnoh's), until HeartGold's sprites come in with the art;
- **signs and hidden items** (bg events): kept, same kind and facing.

Until step 3 brings HeartGold's scripts, every event runs Platinum's do-nothing script 0; trainers are plain people
(their sight would start a battle from script 0); the 195 step-on triggers (coord events) are left out, since each
starts a scripted scene.

HeartGold's tiles also set flags in bits 8-14 that Platinum never uses (room floors are `0x0600`, the space around a
room `0x0000`); the engine reads only the behaviour byte and the collision bit, so they are harmless and stay.

## Still to compare

- The rest of the tile behaviours by meaning (the unnamed numbers and the HeartGold-only ones).
- Scripts (step 3).
- What HeartGold's tile flags in bits 8-14 mean to HeartGold (likely the following Pokémon's rules).
