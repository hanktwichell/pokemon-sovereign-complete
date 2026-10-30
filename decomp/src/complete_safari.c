#include "complete_safari.h"

#include <nitro.h>
#include <string.h>

#include "generated/map_headers.h"
#include "generated/species.h"
#include "generated/time_of_day.h"
#include "res/field/matrices/map_matrix.naix"

#include "field/field_system.h"
#include "savedata/save_table.h"

#include "constants/player_avatar.h"
#include "constants/scrcmd.h"
#include "generated/genders.h"
#include "generated/text_banks.h"
#include "generated/vars_flags.h"

#include "overlay005/field_menu.h"

#include "field_map_change.h"
#include "field_overworld_state.h"
#include "field_script_context.h"
#include "inlines.h"
#include "location.h"
#include "map_header.h"
#include "map_matrix.h"
#include "map_object.h"
#include "map_tile_behavior.h"
#include "message.h"
#include "party.h"
#include "play_time.h"
#include "player_avatar.h"
#include "pokedex.h"
#include "pokemon.h"
#include "rtc.h"
#include "save_player.h"
#include "savedata.h"
#include "script_manager.h"
#include "string_gf.h"
#include "string_template.h"
#include "system_flags.h"
#include "terrain_collision_manager.h"
#include "trainer_info.h"
#include "vars_flags.h"

#include "res/text/bank/hgss_msg_0428.h"
#include "res/text/bank/hgss_msg_0430.h"

// The Johto Safari Zone (HeartGold's src/safari_zone.c, src/unk_02097268.c and the Safari parts of src/map_matrix.c
// and src/field/encounter_check.c; docs/Features.md). Six of its twelve areas sit in a 3x2 grid on the outside map,
// in the arrangement the player picks with Baoba (a new game starts with one of HeartGold's ten). Each area has its
// Pokémon by time of day, and bonus Pokémon that the objects placed in it bring out as days pass. The areas and their
// objects are saved (SAVE_TABLE_ENTRY_COMPLETE_SAFARI). HeartGold's tables (include/data/complete_safari.h, from
// tools/complete/import_hgss_safari.py) are the same in Sacred Gold.

#define SAFARI_OUTSIDE_MATRIX     map_matrix_hgss_0212 // the outside map's matrix (HeartGold's map_matrix_0212)
#define HGSS_LAND_DATA_BASE       666 // HeartGold's land data k is map_data_{666 + k} (tools/complete/import_hgss_maps.py)
#define SAFARI_AREA_LAND_DATA     652 // HeartGold's first area's land data (PlaceSafariZoneAreas)
#define SAFARI_AREA_TILES         32
#define SAFARI_DEFAULT_AREA_SETS  10
#define SAFARI_ZONE_OBJECT_IDS    24
#define SAFARI_OBJECT_LEVEL_STEPS 5

#include "data/complete_safari.h"

static SafariZoneSave *sLoadedSafari; // the save the outside map was last arranged from
static u8 sPlayerGender;

// Each object's type (HeartGold's sObjects, src/unk_02097268.c): the first twelve bring out Pokémon
static const u8 sObjectTypes[SAFARI_ZONE_OBJECT_IDS] = {
    SAFARI_ZONE_OBJECT_TYPE_PLAINS, // shrubbery
    SAFARI_ZONE_OBJECT_TYPE_PLAINS, // red flower
    SAFARI_ZONE_OBJECT_TYPE_PLAINS, // white flower
    SAFARI_ZONE_OBJECT_TYPE_FOREST, // tree
    SAFARI_ZONE_OBJECT_TYPE_FOREST, // stump
    SAFARI_ZONE_OBJECT_TYPE_FOREST, // branches
    SAFARI_ZONE_OBJECT_TYPE_PEAK, // small rock
    SAFARI_ZONE_OBJECT_TYPE_PEAK, // big rock
    SAFARI_ZONE_OBJECT_TYPE_PEAK, // mossy rock
    SAFARI_ZONE_OBJECT_TYPE_WATER, // puddle
    SAFARI_ZONE_OBJECT_TYPE_WATER, // fountain
    SAFARI_ZONE_OBJECT_TYPE_WATER, // water hole
};

// How much an object adds to its type's level, by the area's days / 10 (HeartGold's sObjectLevelBoosts)
static const u8 sObjectLevelSteps[NUM_SAFARI_ZONE_OBJECT_TYPES][SAFARI_OBJECT_LEVEL_STEPS] = {
    { 1, 5, 10, 15, 20 },
    { 2, 6, 11, 16, 21 },
    { 3, 7, 12, 17, 22 },
    { 4, 8, 13, 18, 23 },
};

int CompleteSafari_SaveSize(void)
{
    return sizeof(SafariZoneSave);
}

void CompleteSafari_InitSave(SafariZoneSave *safari)
{
    MI_CpuClear8(safari, sizeof(SafariZoneSave));
}

SafariZoneSave *SaveData_GetCompleteSafari(SaveData *saveData)
{
    return SaveData_SaveTable(saveData, SAVE_TABLE_ENTRY_COMPLETE_SAFARI);
}

// HeartGold's SafariZone_ResetAreaSetToDefaultSet: one of its ten arrangements, with no objects and no days
static void Safari_Arrange(SafariZoneSave *safari, int set)
{
    MI_CpuClear8(safari->areas, sizeof(safari->areas));
    MI_CpuClear8(safari->areaLevels, sizeof(safari->areaLevels));

    for (int i = 0; i < SAFARI_ZONE_AREAS_PER_SET; i++) {
        safari->areas[i].areaNo = sSafariDefaultAreaSets[set % SAFARI_DEFAULT_AREA_SETS][i];
    }

    safari->arranged = TRUE;
}

static SafariZoneSave *Safari_Get(SaveData *saveData)
{
    SafariZoneSave *safari = SaveData_GetCompleteSafari(saveData);

    if (!safari->arranged) { // a new game's first visit picks one of HeartGold's (it picks at the new game)
        Safari_Arrange(safari, LCRNG_RandMod(SAFARI_DEFAULT_AREA_SETS));
    }

    return safari;
}

static void Safari_BaobaCalls(SaveData *saveData);

// On each map load: Baoba's calls, and (HeartGold's PlaceSafariZoneAreas) the outside map's six empty cells get the
// arranged areas' blocks
void CompleteSafari_LoadMap(MapMatrix *mapMatrix, SaveData *saveData)
{
    Safari_BaobaCalls(saveData);

    if (mapMatrix->matrixID != SAFARI_OUTSIDE_MATRIX) {
        return;
    }

    SafariZoneSave *safari = Safari_Get(saveData);
    int width = mapMatrix->width;

    sLoadedSafari = safari; // for the objects as the area blocks load (CompleteSafari_LoadObjects)
    sPlayerGender = TrainerInfo_Gender(SaveData_GetTrainerInfo(saveData));

    for (int row = 0; row < SAFARI_ZONE_AREA_SET_ROWS; row++) {
        for (int col = 0; col < SAFARI_ZONE_AREA_SET_COLS; col++) {
            u8 area = safari->areas[row * SAFARI_ZONE_AREA_SET_COLS + col].areaNo;
            mapMatrix->data.landDataIDs[width * (row + 1) + col + 1] = HGSS_LAND_DATA_BASE + SAFARI_AREA_LAND_DATA + area;
        }
    }
}

BOOL CompleteSafari_IsSafariMap(FieldSystem *fieldSystem)
{
    return fieldSystem->location->mapHeaderID == MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_EXTERIOR;
}

// The arranged area the player stands in, 0-5 (HeartGold's ov02_0224E340)
int CompleteSafari_AreaAt(FieldSystem *fieldSystem)
{
    int x = PlayerAvatar_GetXPos(fieldSystem->playerAvatar) - SAFARI_AREA_TILES;
    int z = PlayerAvatar_GetZPos(fieldSystem->playerAvatar) - SAFARI_AREA_TILES;
    int col = x < 0 ? 0 : x / SAFARI_AREA_TILES;
    int row = z < 0 ? 0 : z / SAFARI_AREA_TILES;

    if (col >= SAFARI_ZONE_AREA_SET_COLS) {
        col = SAFARI_ZONE_AREA_SET_COLS - 1;
    }

    if (row >= SAFARI_ZONE_AREA_SET_ROWS) {
        row = SAFARI_ZONE_AREA_SET_ROWS - 1;
    }

    return row * SAFARI_ZONE_AREA_SET_COLS + col;
}

// HeartGold's getObjectLevelBoost
static u8 Safari_ObjectLevel(u8 tensOfDays, u8 objectType)
{
    if (objectType == SAFARI_ZONE_OBJECT_TYPE_NONE) {
        return 0;
    }

    for (int i = 0; i < SAFARI_OBJECT_LEVEL_STEPS; i++) {
        if (tensOfDays < sObjectLevelSteps[objectType - 1][i]) {
            return i + 1;
        }
    }

    return tensOfDays < 25 ? 6 : 7;
}

// Each object type's level in an arranged area (HeartGold's SafariZoneAreaSet_GetObjectsInArea)
static void Safari_ObjectLevels(SafariZoneSave *safari, int area, u8 *levels)
{
    SafariZoneAreaSave *placed = &safari->areas[area];
    u8 tensOfDays = safari->areaLevels[placed->areaNo] / 10;

    MI_CpuClear8(levels, NUM_SAFARI_ZONE_OBJECT_TYPES);

    for (int i = 0; i < placed->objectCount && i < SAFARI_ZONE_MAX_OBJECTS; i++) {
        u8 id = placed->objects[i].id;
        u8 type = id < NELEMS(sObjectTypes) ? sObjectTypes[id] : SAFARI_ZONE_OBJECT_TYPE_NONE;

        if (type != SAFARI_ZONE_OBJECT_TYPE_NONE) {
            int level = levels[type - 1] + Safari_ObjectLevel(tensOfDays, type);
            levels[type - 1] = level > 255 ? 255 : level;
        }
    }
}

static int Safari_TimeOfDay(int timeOfDay)
{
    switch (timeOfDay) {
    case TIMEOFDAY_DAY:
    case TIMEOFDAY_TWILIGHT:
        return 1;
    case TIMEOFDAY_NIGHT:
    case TIMEOFDAY_LATE_NIGHT:
        return 2;
    default:
        return 0;
    }
}

// The ten slots of an arranged area's table at this time of day: its base Pokémon, with the bonus Pokémon its objects
// bring out taking the first slots (HeartGold's SafariZoneAreaSet_LoadAreaEncounters). An area with no surfing
// bonus has no water: its water tables are HeartGold's placeholder, Magikarp at 5.
void CompleteSafari_GetEncounterSlots(SaveData *saveData, int area, enum SafariZoneEncounterType type, int timeOfDay, SafariZoneSlot *slots)
{
    SafariZoneSave *safari = Safari_Get(saveData);
    const SafariEncounters *table = &sSafariEncounters[safari->areas[area].areaNo][type];
    const SafariEncounters *surf = &sSafariEncounters[safari->areas[area].areaNo][SAFARI_ZONE_ENCOUNTERS_SURF];
    int time = Safari_TimeOfDay(timeOfDay);

    if (type != SAFARI_ZONE_ENCOUNTERS_LAND && surf->bonusCount == 0) {
        for (int i = 0; i < SAFARI_ZONE_ENCOUNTER_SLOTS; i++) {
            slots[i].species = SPECIES_MAGIKARP;
            slots[i].level = 5;
        }

        return;
    }

    for (int i = 0; i < SAFARI_ZONE_ENCOUNTER_SLOTS; i++) {
        slots[i] = table->base[time][i];
    }

    u8 levels[NUM_SAFARI_ZONE_OBJECT_TYPES];
    int filled = 0;

    Safari_ObjectLevels(safari, area, levels);

    for (int i = 0; i < table->bonusCount && filled < SAFARI_ZONE_ENCOUNTER_SLOTS; i++) {
        const SafariZoneBonusNeed *needs = table->bonus[i].needs;

        if (levels[needs[0].objectType - 1] < needs[0].level) {
            continue;
        }

        if (needs[1].objectType != SAFARI_ZONE_OBJECT_TYPE_NONE && levels[needs[1].objectType - 1] < needs[1].level) {
            continue;
        }

        slots[filled++] = table->bonus[i].mons[time];
    }
}

// Days passing (HeartGold's SaveData_SafariZone_CheckAreasWithUpdatedEncounters): once Baoba has let the player place
// objects, every area's days go up; during a Safari game they wait for its end.
void CompleteSafari_AddDays(SaveData *saveData, int days)
{
    SafariZoneSave *safari = SaveData_GetCompleteSafari(saveData);

    if (safari->objectUnlockLevel == 0 || days <= 0) {
        return;
    }

    if (SystemFlag_CheckSafariGameActive(SaveData_GetVarsFlags(saveData))) {
        safari->daysWhileInside = safari->daysWhileInside + days > 255 ? 255 : safari->daysWhileInside + days;
        return;
    }

    for (int i = 0; i < NUM_SAFARI_ZONE_AREAS; i++) {
        safari->areaLevels[i] = safari->areaLevels[i] + days > 255 ? 255 : safari->areaLevels[i] + days;
    }
}

// HeartGold's SafariZoneAction: 0 starts a Safari game (30 Safari Balls), 1 ends it, adding the days that passed
BOOL CompleteScrCmd_SafariZoneAction(ScriptContext *ctx)
{
    SaveData *saveData = ctx->fieldSystem->saveData;
    FieldOverworldState *state = SaveData_GetFieldOverworldState(saveData);
    SafariZoneSave *safari = Safari_Get(saveData);
    u8 action = ScriptContext_ReadByte(ctx);

    ScriptContext_ReadByte(ctx); // HeartGold's area set: a friend's (link play) is left out

    if (action == 0) {
        SystemFlag_SetSafariGameActive(SaveData_GetVarsFlags(saveData));
        *FieldOverworldState_GetSafariBallCount(state) = SAFARI_ZONE_BALLS;
        *FieldOverworldState_GetSafariStepCount(state) = 0;
    } else {
        int days = safari->daysWhileInside;

        SystemFlag_ClearSafariGameActive(SaveData_GetVarsFlags(saveData));
        safari->daysWhileInside = 0;
        CompleteSafari_AddDays(saveData, days);
        *FieldOverworldState_GetSafariBallCount(state) = 0;
        *FieldOverworldState_GetSafariStepCount(state) = 0;
    }

    return FALSE;
}

// --- The objects (HeartGold's src/field/map_prop_manager.c MapPropManager_LoadFromSafariZone, overlay 3's script
// commands and overlay 108's object choice) ---

#define SAFARI_OBJECT_TILE        0x8023 // HeartGold's: a blocked tile of behavior 0x23 (Platinum leaves 0x23 unused)
#define SAFARI_OBJECT_BEHAVIOR    0x23
#define SAFARI_OBJECT_NONE        255
#define SAFARI_OBJECT_STATUE      18
#define SAFARI_OBJECT_FLAG        19
#define SAFARI_OBJECT_GROUPS      4
#define SAFARI_GROUP_OBJECTS      6
#define SAFARI_MAX_UNLOCK_LEVEL   4
#define SAFARI_BAOBA_HOURS        3 // HeartGold's: Baoba calls three hours of play after his last word
#define SAFARI_MAX_STAMP          59999 // HeartGold's: play time past this many minutes always counts as long enough
#define HGSS_FIRST_PROP_MODEL     590 // HeartGold's outdoor model k is the engine's 590 + k (src/overlay005/area_data.c)
#define BLOCK_TILES               32

enum SafariPlaceResult { // HeartGold's ScrCmd_721
    SAFARI_PLACE_OK = 0,
    SAFARI_PLACE_AREA_FULL,
    SAFARI_PLACE_NO_OBJECTS,
    SAFARI_PLACE_NO_ROOM,
};

typedef struct SafariObjectShape {
    u8 model; // HeartGold's BUILD_MODEL_SAF_*
    u8 width;
    u8 height;
} SafariObjectShape;

// Each object's model and size in tiles (HeartGold's sObjects); the statue's and flag's female models follow the male
static const SafariObjectShape sObjectShapes[SAFARI_ZONE_OBJECT_IDS] = {
    { 189, 1, 1 }, { 190, 1, 1 }, { 191, 1, 1 }, // shrubbery, red and white flowers
    { 192, 2, 2 }, { 193, 2, 2 }, { 194, 2, 2 }, // tree, stump, branches
    { 195, 1, 1 }, { 196, 2, 2 }, { 197, 2, 2 }, // small, big and mossy rocks
    { 198, 2, 2 }, { 199, 2, 2 }, { 200, 2, 2 }, // puddle, fountain, water hole
    { 201, 2, 1 }, { 202, 1, 1 }, { 203, 1, 1 }, // bench, short fences
    { 204, 2, 1 }, { 205, 1, 2 }, { 206, 1, 1 }, // long fences, signboard
    { 207, 1, 1 }, { 209, 1, 1 }, // the player's statue and flag
    { 211, 1, 1 }, { 212, 1, 1 }, { 213, 1, 1 }, { 214, 1, 1 }, // lamp, guideposts, trash can
};

// The objects Baoba lets the player place come in four groups, one more at each of his levels, in an order the trainer
// ID's last digit picks (HeartGold's overlay 108 tables at 0x021EACE8-0x021EAD28)
static const u8 sObjectGroups[SAFARI_OBJECT_GROUPS][SAFARI_GROUP_OBJECTS] = {
    { 0, 1, 2, 19, 20, 12 },
    { 3, 4, 5, 13, 14, 17 },
    { 6, 7, 8, 21, 22, 23 },
    { 9, 10, 11, 15, 16, 18 },
};

static const u8 sGroupOrder[10][SAFARI_OBJECT_GROUPS] = {
    { 0, 1, 2, 3 }, { 0, 1, 2, 3 }, { 0, 1, 2, 3 }, { 1, 2, 3, 0 }, { 1, 2, 3, 0 },
    { 1, 2, 3, 0 }, { 2, 3, 0, 1 }, { 2, 3, 0, 1 }, { 3, 0, 1, 2 }, { 3, 0, 1, 2 },
};

// An area's objects as its block loads: props, and their tiles blocked (behavior 0x23, which A on them finds)
void CompleteSafari_LoadObjects(const MapMatrix *mapMatrix, int mapMatrixIndex, u16 *terrainAttributes, MapPropManager *mapPropManager, AreaDataManager *areaDataMan, MapPropAnimationManager *mapPropAnimMan)
{
    if (mapMatrix->matrixID != SAFARI_OUTSIDE_MATRIX || sLoadedSafari == NULL || mapPropManager == NULL) {
        return;
    }

    int col = mapMatrixIndex % mapMatrix->width - 1;
    int row = mapMatrixIndex / mapMatrix->width - 1;

    if (col < 0 || col >= SAFARI_ZONE_AREA_SET_COLS || row < 0 || row >= SAFARI_ZONE_AREA_SET_ROWS) {
        return;
    }

    const SafariZoneAreaSave *area = &sLoadedSafari->areas[row * SAFARI_ZONE_AREA_SET_COLS + col];
    int free = 0;

    for (int i = 0; i < MAX_LOADED_MAP_PROPS; i++) {
        free += !mapPropManager->loadedProps[i].loaded;
    }

    for (int i = 0; i < area->objectCount && i < SAFARI_ZONE_MAX_OBJECTS; i++) {
        const SafariZoneObject *object = &area->objects[i];

        if (object->id >= SAFARI_ZONE_OBJECT_IDS) {
            continue;
        }

        const SafariObjectShape *shape = &sObjectShapes[object->id];

        if (free > 0) {
            int model = shape->model + (sPlayerGender == GENDER_FEMALE && (object->id == SAFARI_OBJECT_STATUE || object->id == SAFARI_OBJECT_FLAG));
            VecFx32 position = {
                FX32_CONST(16 * object->x + 8 * shape->width - 0x100),
                FX32_CONST(object->y),
                FX32_CONST(16 * object->z + 8 * (2 - shape->height) - 0x100),
            };

            MapPropManager_LoadOne(mapPropManager, areaDataMan, HGSS_FIRST_PROP_MODEL + model, &position, NULL, mapPropAnimMan);
            free--;
        }

        if (terrainAttributes != NULL) {
            for (int z = object->z; z > object->z - shape->height && z >= 0; z--) {
                for (int x = object->x; x < object->x + shape->width && x < BLOCK_TILES; x++) {
                    terrainAttributes[z * BLOCK_TILES + x] = SAFARI_OBJECT_TILE;
                }
            }
        }
    }
}

static void Safari_FrontTile(FieldSystem *fieldSystem, int *x, int *z, int *dir)
{
    *dir = PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar);
    *x = PlayerAvatar_GetXPos(fieldSystem->playerAvatar) + (*dir == DIR_WEST ? -1 : *dir == DIR_EAST ? 1 : 0);
    *z = PlayerAvatar_GetZPos(fieldSystem->playerAvatar) + (*dir == DIR_NORTH ? -1 : *dir == DIR_SOUTH ? 1 : 0);
}

// The arranged area a tile is in, or -1 outside them
static int Safari_AreaOfTile(int x, int z)
{
    x -= BLOCK_TILES;
    z -= BLOCK_TILES;

    if (x < 0 || z < 0 || x >= BLOCK_TILES * SAFARI_ZONE_AREA_SET_COLS || z >= BLOCK_TILES * SAFARI_ZONE_AREA_SET_ROWS) {
        return -1;
    }

    return x / BLOCK_TILES + SAFARI_ZONE_AREA_SET_COLS * (z / BLOCK_TILES);
}

// Whether an object can stand on a tile: in an area, open land, nobody on it
static BOOL Safari_TileFree(FieldSystem *fieldSystem, int x, int z)
{
    if (Safari_AreaOfTile(x, z) < 0 || TerrainCollisionManager_CheckCollision(fieldSystem, x, z)) {
        return FALSE;
    }

    if (TileBehavior_IsSurfable(TerrainCollisionManager_GetTileBehavior(fieldSystem, x, z))) {
        return FALSE;
    }

    return sub_0206326C(fieldSystem->mapObjMan, x, z, TRUE) == NULL;
}

// Where an object goes for the tile in front: it grows away from the player (HeartGold's app lets the player move it)
static BOOL Safari_Footprint(FieldSystem *fieldSystem, int id, int *ox, int *oz)
{
    const SafariObjectShape *shape = &sObjectShapes[id];
    int x, z, dir;

    Safari_FrontTile(fieldSystem, &x, &z, &dir);
    *ox = dir == DIR_WEST ? x - shape->width + 1 : x;
    *oz = dir == DIR_SOUTH ? z + shape->height - 1 : z;

    int area = Safari_AreaOfTile(x, z);

    for (int tz = *oz; tz > *oz - shape->height; tz--) {
        for (int tx = *ox; tx < *ox + shape->width; tx++) {
            if (Safari_AreaOfTile(tx, tz) != area || !Safari_TileFree(fieldSystem, tx, tz)) {
                return FALSE;
            }
        }
    }

    return area >= 0;
}

// A on the Safari Zone's ground, with objects to place, places one; A on an object takes it away (HeartGold's
// std_safari_place_object and std_safari_remove_object, from its field input)
u16 CompleteSafari_FacingScript(FieldSystem *fieldSystem)
{
    if (!CompleteSafari_IsSafariMap(fieldSystem) || SaveData_GetCompleteSafari(fieldSystem->saveData)->objectUnlockLevel == 0) {
        return 0xFFFF;
    }

    int x, z, dir;

    Safari_FrontTile(fieldSystem, &x, &z, &dir);

    if (Safari_AreaOfTile(x, z) >= 0 && TerrainCollisionManager_GetTileBehavior(fieldSystem, x, z) == SAFARI_OBJECT_BEHAVIOR) {
        return SCRIPT_ID(COMPLETE_SAFARI, 1);
    }

    if (Safari_TileFree(fieldSystem, x, z) && PlayerAvatar_GetPlayerState(fieldSystem->playerAvatar) != PLAYER_AVATAR_SURFING) {
        return SCRIPT_ID(COMPLETE_SAFARI, 0);
    }

    return 0xFFFF;
}

// HeartGold's 721: whether an object can go in front (enum SafariPlaceResult)
BOOL CompleteScrCmd_SafariCanPlaceObject(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    SafariZoneSave *safari = Safari_Get(ctx->fieldSystem->saveData);
    int x, z, dir;

    Safari_FrontTile(ctx->fieldSystem, &x, &z, &dir);
    int area = Safari_AreaOfTile(x, z);

    if (area >= 0 && safari->areas[area].objectCount >= SAFARI_ZONE_MAX_OBJECTS) {
        *destVar = SAFARI_PLACE_AREA_FULL;
    } else if (safari->objectUnlockLevel == 0) {
        *destVar = SAFARI_PLACE_NO_OBJECTS;
    } else if (!Safari_TileFree(ctx->fieldSystem, x, z)) {
        *destVar = SAFARI_PLACE_NO_ROOM;
    } else {
        *destVar = SAFARI_PLACE_OK;
    }

    return FALSE;
}

// An entry of the list menu the script opened, from another bank (HeartGold's object and area names, in banks 0430
// and 0428): the menu reads an entry's text as it is added
static void Safari_AddListEntry(FieldMenuManager *menu, MessageLoader *loader, u32 entryID, u32 index)
{
    MessageLoader *scriptLoader = menu->messageLoader;

    menu->messageLoader = loader;
    FieldMenuManager_AddListMenuEntry(menu, entryID, LIST_MENU_ENTRY_NO_ALT_TEXT, index);
    menu->messageLoader = scriptLoader;
}

// The objects Baoba has let the player place, as entries of the list menu the script opened (in place of
// HeartGold's object screen)
BOOL CompleteScrCmd_SafariAddObjectEntries(ScriptContext *ctx)
{
    FieldMenuManager **menu = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_FIELD_MENU_MANAGER);
    MessageLoader *names = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0430, HEAP_ID_FIELD1);
    SafariZoneSave *safari = Safari_Get(ctx->fieldSystem->saveData);
    const u8 *order = sGroupOrder[TrainerInfo_ID(SaveData_GetTrainerInfo(ctx->fieldSystem->saveData)) % 10];
    int groups = safari->objectUnlockLevel > SAFARI_MAX_UNLOCK_LEVEL ? SAFARI_MAX_UNLOCK_LEVEL : safari->objectUnlockLevel;

    for (int g = 0; g < groups; g++) {
        for (int i = 0; i < SAFARI_GROUP_OBJECTS; i++) {
            u8 id = sObjectGroups[order[g]][i];
            Safari_AddListEntry(*menu, names, msg_0430_00014 + id, id);
        }
    }

    MessageLoader_Free(names);
    return FALSE;
}

// The map loads again in place, with the objects as they now are (the script has faded the screen out)
static BOOL Safari_Reload(ScriptContext *ctx)
{
    PlayerAvatar *playerAvatar = ctx->fieldSystem->playerAvatar;

    FieldTask_StartMapChangeFull(ctx->task, ctx->fieldSystem->location->mapHeaderID, -1, PlayerAvatar_GetXPos(playerAvatar), PlayerAvatar_GetZPos(playerAvatar), PlayerAvatar_GetFacingDir(playerAvatar));
    return TRUE;
}

// The object the menu chose goes in front of the player (var: the object, or SAFARI_OBJECT_NONE if the menu was left
// or it has no room), and the map reloads to show it
BOOL CompleteScrCmd_SafariPlaceObject(ScriptContext *ctx)
{
    u16 *var = ScriptContext_GetVarPointer(ctx);
    SafariZoneSave *safari = Safari_Get(ctx->fieldSystem->saveData);
    int ox, oz;

    if (*var >= SAFARI_ZONE_OBJECT_IDS || !Safari_Footprint(ctx->fieldSystem, *var, &ox, &oz)) {
        *var = SAFARI_OBJECT_NONE;
        return FALSE;
    }

    SafariZoneAreaSave *area = &safari->areas[Safari_AreaOfTile(ox, oz)];

    if (area->objectCount >= SAFARI_ZONE_MAX_OBJECTS) {
        *var = SAFARI_OBJECT_NONE;
        return FALSE;
    }

    VecFx32 position;
    PlayerAvatar_GetPosPtr(ctx->fieldSystem->playerAvatar, &position);
    int y = position.y >> FX32_SHIFT;

    SafariZoneObject *object = &area->objects[area->objectCount++];
    object->id = *var;
    object->x = (ox - BLOCK_TILES) % BLOCK_TILES;
    object->z = (oz - BLOCK_TILES) % BLOCK_TILES;
    object->y = y < 0 ? 0 : y > 255 ? 255 : y;
    return Safari_Reload(ctx);
}

// HeartGold's 718: an object's name
BOOL CompleteScrCmd_SafariBufferObjectName(ScriptContext *ctx)
{
    StringTemplate **template = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u8 slot = ScriptContext_ReadByte(ctx);
    u16 id = ScriptContext_GetVar(ctx);
    MessageLoader *names = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0430, HEAP_ID_FIELD1);
    String *name = MessageLoader_GetNewString(names, msg_0430_00014 + (id < SAFARI_ZONE_OBJECT_IDS ? id : 0));

    StringTemplate_SetString(*template, slot, name, 0, TRUE, GAME_LANGUAGE);
    String_Free(name);
    MessageLoader_Free(names);
    return FALSE;
}

// HeartGold's 719: the object in front of the player (its kind, or SAFARI_OBJECT_NONE) and its place in its area
BOOL CompleteScrCmd_SafariObjectInFront(ScriptContext *ctx)
{
    u16 *idVar = ScriptContext_GetVarPointer(ctx);
    u16 *indexVar = ScriptContext_GetVarPointer(ctx);
    SafariZoneSave *safari = Safari_Get(ctx->fieldSystem->saveData);
    int x, z, dir;

    Safari_FrontTile(ctx->fieldSystem, &x, &z, &dir);
    int area = Safari_AreaOfTile(x, z);

    *idVar = SAFARI_OBJECT_NONE;

    if (area < 0) {
        return FALSE;
    }

    int bx = (x - BLOCK_TILES) % BLOCK_TILES, bz = (z - BLOCK_TILES) % BLOCK_TILES;
    const SafariZoneAreaSave *placed = &safari->areas[area];

    for (int i = 0; i < placed->objectCount; i++) {
        const SafariZoneObject *object = &placed->objects[i];

        if (object->id >= SAFARI_ZONE_OBJECT_IDS) {
            continue;
        }

        const SafariObjectShape *shape = &sObjectShapes[object->id];

        if (bx >= object->x && bx < object->x + shape->width && bz <= object->z && bz > object->z - shape->height) {
            *idVar = object->id;
            *indexVar = i;
            break;
        }
    }

    return FALSE;
}

// HeartGold's 720: the object takes its leave, and the map reloads
BOOL CompleteScrCmd_SafariRemoveObject(ScriptContext *ctx)
{
    u16 index = ScriptContext_GetVar(ctx);
    SafariZoneSave *safari = Safari_Get(ctx->fieldSystem->saveData);
    int x, z, dir;

    Safari_FrontTile(ctx->fieldSystem, &x, &z, &dir);
    int area = Safari_AreaOfTile(x, z);

    if (area < 0 || index >= safari->areas[area].objectCount) {
        return FALSE;
    }

    SafariZoneAreaSave *placed = &safari->areas[area];

    for (int i = index; i < placed->objectCount - 1; i++) {
        placed->objects[i] = placed->objects[i + 1];
    }

    placed->objectCount--;
    return Safari_Reload(ctx);
}

// --- Baoba (HeartGold's gate scripts and his Pokégear calls) ---

// The area arrangement, as list menus in place of HeartGold's screen (overlay 108's SafariAreaCustomizer): the six
// cells' areas (0), or all twelve areas (1)
BOOL CompleteScrCmd_SafariAddAreaEntries(ScriptContext *ctx)
{
    FieldMenuManager **menu = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_FIELD_MENU_MANAGER);
    MessageLoader *names = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0428, HEAP_ID_FIELD1);
    SafariZoneSave *safari = Safari_Get(ctx->fieldSystem->saveData);
    u8 allAreas = ScriptContext_ReadByte(ctx);

    if (allAreas) {
        for (int area = 0; area < NUM_SAFARI_ZONE_AREAS; area++) {
            Safari_AddListEntry(*menu, names, msg_0428_00000 + area, area);
        }
    } else {
        for (int cell = 0; cell < SAFARI_ZONE_AREAS_PER_SET; cell++) {
            Safari_AddListEntry(*menu, names, msg_0428_00000 + safari->areas[cell].areaNo, cell);
        }
    }

    MessageLoader_Free(names);
    return FALSE;
}

// A cell gets an area: one in another cell swaps places with it, objects and all; a new one starts with none
// (HeartGold's SafariZone_SwapAreasInSet and SafariZone_InitAreaInSet). A change sets HeartGold's flag 99D, which
// Baoba's script answers.
BOOL CompleteScrCmd_SafariSetArea(ScriptContext *ctx)
{
    u16 cell = ScriptContext_GetVar(ctx);
    u16 areaNo = ScriptContext_GetVar(ctx);
    SafariZoneSave *safari = Safari_Get(ctx->fieldSystem->saveData);

    if (cell >= SAFARI_ZONE_AREAS_PER_SET || areaNo >= NUM_SAFARI_ZONE_AREAS || safari->areas[cell].areaNo == areaNo) {
        return FALSE;
    }

    int other = 0;

    while (other < SAFARI_ZONE_AREAS_PER_SET && safari->areas[other].areaNo != areaNo) {
        other++;
    }

    if (other < SAFARI_ZONE_AREAS_PER_SET) {
        SafariZoneAreaSave swap = safari->areas[cell];
        safari->areas[cell] = safari->areas[other];
        safari->areas[other] = swap;
    } else {
        MI_CpuClear8(&safari->areas[cell], sizeof(SafariZoneAreaSave));
        safari->areas[cell].areaNo = areaNo;
    }

    FieldSystem_SetFlag(ctx->fieldSystem, FLAG_HGSS_UNK_99D);
    return FALSE;
}

// HeartGold's CheckSafariZoneChallengeCompleted: the player caught Baoba's Pokémon (Geodude, then Sandshrew) in the
// Safari Zone themselves
BOOL CompleteScrCmd_SafariChallengeCompleted(ScriptContext *ctx)
{
    static const u16 sChallengeSpecies[] = { SPECIES_GEODUDE, SPECIES_SANDSHREW };
    u8 challenge = ScriptContext_ReadByte(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    SaveData *saveData = ctx->fieldSystem->saveData;
    Party *party = SaveData_GetParty(saveData);
    u32 trainerID = TrainerInfo_ID(SaveData_GetTrainerInfo(saveData));
    u32 safariLocation = MapHeader_GetMapLabelTextID(MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_EXTERIOR);

    *destVar = FALSE;

    for (int i = 0; i < Party_GetCurrentCount(party) && challenge < NELEMS(sChallengeSpecies); i++) {
        Pokemon *mon = Party_GetPokemonBySlotIndex(party, i);

        if (!Pokemon_GetValue(mon, MON_DATA_IS_EGG, NULL)
            && Pokemon_GetValue(mon, MON_DATA_OT_ID, NULL) == trainerID
            && Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL) == sChallengeSpecies[challenge]
            && Pokemon_GetValue(mon, MON_DATA_EGG_LOCATION, NULL) == 0
            && Pokemon_GetValue(mon, MON_DATA_MET_LOCATION, NULL) == safariLocation) {
            *destVar = TRUE;
            break;
        }
    }

    return FALSE;
}

// Play time in minutes, as HeartGold stamps it (its sub_0202F784)
static u16 Safari_PlayMinutes(SaveData *saveData)
{
    const PlayTime *playTime = SaveData_GetPlayTime(saveData);
    u32 minutes = PlayTime_GetHours(playTime) * 60 + PlayTime_GetMinutes(playTime);

    return minutes > SAFARI_MAX_STAMP ? SAFARI_MAX_STAMP : minutes;
}

// HeartGold's UpdateSafariZoneIGT: when Baoba last spoke, by play time
BOOL CompleteScrCmd_SafariStampBaoba(ScriptContext *ctx)
{
    Safari_Get(ctx->fieldSystem->saveData)->baobaStampMinutes = Safari_PlayMinutes(ctx->fieldSystem->saveData);
    return FALSE;
}

// Baoba's calls, until there is a Pokégear (HeartGold's sub_02092E54 and phone_scripts_baoba.c): what each would do
// happens at the first map load after it would have rung, and he says the rest at the gate. Three hours of play
// after the player passes his first test, his next test (VAR 4057 to 4, which the gate's map script picks up); three
// hours after the second, with the National Dex, the objects (to 7), one more group each three hours after that.
static void Safari_BaobaCalls(SaveData *saveData)
{
    SafariZoneSave *safari = SaveData_GetCompleteSafari(saveData);
    u16 *progress = VarsFlags_GetVarAddress(SaveData_GetVarsFlags(saveData), VAR_HGSS_UNK_4057);
    u16 minutes = Safari_PlayMinutes(saveData);

    if (*progress < 3 || safari->objectUnlockLevel >= SAFARI_MAX_UNLOCK_LEVEL
        || (minutes - safari->baobaStampMinutes < SAFARI_BAOBA_HOURS * 60 && minutes < SAFARI_MAX_STAMP)) {
        return;
    }

    if (*progress == 3) {
        *progress = 4;
    } else if (*progress >= 6 && Pokedex_IsNationalDexObtained(SaveData_GetPokedex(saveData))) {
        safari->objectUnlockLevel++;
        safari->baobaStampMinutes = minutes;
        *progress = 7;
    }
}
