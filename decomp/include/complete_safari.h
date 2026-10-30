#ifndef POKEPLATINUM_COMPLETE_SAFARI_H
#define POKEPLATINUM_COMPLETE_SAFARI_H

#include "field/field_system_decl.h"
#include "savedata.h"

#include "overlay005/area_data.h"
#include "overlay005/map_prop.h"
#include "overlay005/map_prop_animation.h"

#include "field_script_context.h"
#include "map_matrix.h"

#define SAFARI_ZONE_MAX_OBJECTS        30
#define SAFARI_ZONE_AREA_SET_COLS      3
#define SAFARI_ZONE_AREA_SET_ROWS      2
#define SAFARI_ZONE_AREAS_PER_SET      (SAFARI_ZONE_AREA_SET_COLS * SAFARI_ZONE_AREA_SET_ROWS)
#define SAFARI_ZONE_ENCOUNTER_SLOTS    10
#define SAFARI_ZONE_MAX_BONUS_SLOTS    10
#define SAFARI_ZONE_BALLS              30

// HeartGold's areas (its constants/safari.h)
enum SafariZoneArea {
    SAFARI_ZONE_AREA_PLAINS = 0,
    SAFARI_ZONE_AREA_MEADOW,
    SAFARI_ZONE_AREA_SAVANNAH,
    SAFARI_ZONE_AREA_PEAK,
    SAFARI_ZONE_AREA_ROCKY_BEACH,
    SAFARI_ZONE_AREA_WETLAND,
    SAFARI_ZONE_AREA_FOREST,
    SAFARI_ZONE_AREA_SWAMP,
    SAFARI_ZONE_AREA_MARSHLAND,
    SAFARI_ZONE_AREA_WASTELAND,
    SAFARI_ZONE_AREA_MOUNTAIN,
    SAFARI_ZONE_AREA_DESERT,
    NUM_SAFARI_ZONE_AREAS,
};

enum SafariZoneObjectType {
    SAFARI_ZONE_OBJECT_TYPE_NONE = 0,
    SAFARI_ZONE_OBJECT_TYPE_PLAINS,
    SAFARI_ZONE_OBJECT_TYPE_FOREST,
    SAFARI_ZONE_OBJECT_TYPE_PEAK,
    SAFARI_ZONE_OBJECT_TYPE_WATER,
    NUM_SAFARI_ZONE_OBJECT_TYPES = SAFARI_ZONE_OBJECT_TYPE_WATER,
};

enum SafariZoneEncounterType {
    SAFARI_ZONE_ENCOUNTERS_LAND = 0,
    SAFARI_ZONE_ENCOUNTERS_SURF,
    SAFARI_ZONE_ENCOUNTERS_OLD_ROD,
    SAFARI_ZONE_ENCOUNTERS_GOOD_ROD,
    SAFARI_ZONE_ENCOUNTERS_SUPER_ROD,
    NUM_SAFARI_ZONE_ENCOUNTER_TYPES,
};

typedef struct SafariZoneSlot {
    u16 species;
    u8 level;
} SafariZoneSlot;

typedef struct SafariZoneBonusNeed {
    u8 objectType;
    u8 level;
} SafariZoneBonusNeed;

typedef struct SafariZoneBonusSlot {
    SafariZoneSlot mons[3]; // morning, day, night
    SafariZoneBonusNeed needs[2];
} SafariZoneBonusSlot;

typedef struct SafariEncounters {
    SafariZoneSlot base[3][SAFARI_ZONE_ENCOUNTER_SLOTS];
    u8 bonusCount;
    SafariZoneBonusSlot bonus[SAFARI_ZONE_MAX_BONUS_SLOTS];
} SafariEncounters;

// Saved (HeartGold's SAFARIZONE_OBJECT, SAFARIZONE_AREA and its first SafariZoneAreaSet; link play's second set and
// friend are left out)
typedef struct SafariZoneObject {
    u8 id;
    u8 x;
    u8 y;
    u8 z;
} SafariZoneObject;

typedef struct SafariZoneAreaSave {
    u8 areaNo;
    u8 objectCount;
    SafariZoneObject objects[SAFARI_ZONE_MAX_OBJECTS];
} SafariZoneAreaSave;

typedef struct SafariZoneSave {
    SafariZoneAreaSave areas[SAFARI_ZONE_AREAS_PER_SET];
    u8 areaLevels[NUM_SAFARI_ZONE_AREAS]; // days the area has had its objects
    u8 arranged; // an arrangement has been picked (a new game picks one of HeartGold's ten)
    u8 objectUnlockLevel; // Baoba's: 0 before his first test, then the objects that may be placed
    u8 daysWhileInside; // days that passed during a Safari game, added when it ends (HeartGold's level)
    u8 padding;
    u16 baobaStampMinutes; // the play time Baoba last gave a test or objects at, in minutes (HeartGold's IGT stamp)
} SafariZoneSave;

int CompleteSafari_SaveSize(void);
void CompleteSafari_InitSave(SafariZoneSave *safari);
SafariZoneSave *SaveData_GetCompleteSafari(SaveData *saveData);

void CompleteSafari_LoadMap(MapMatrix *mapMatrix, SaveData *saveData);
BOOL CompleteSafari_IsSafariMap(FieldSystem *fieldSystem);
int CompleteSafari_AreaAt(FieldSystem *fieldSystem);
void CompleteSafari_GetEncounterSlots(SaveData *saveData, int area, enum SafariZoneEncounterType type, int timeOfDay, SafariZoneSlot *slots);
void CompleteSafari_AddDays(SaveData *saveData, int days);

BOOL CompleteScrCmd_SafariZoneAction(ScriptContext *ctx);

// The objects (stage two): props and blocked tiles as an area's block loads, and placing and taking them away
void CompleteSafari_LoadObjects(const MapMatrix *mapMatrix, int mapMatrixIndex, u16 *terrainAttributes, MapPropManager *mapPropManager, AreaDataManager *areaDataMan, MapPropAnimationManager *mapPropAnimMan);
u16 CompleteSafari_FacingScript(FieldSystem *fieldSystem);
BOOL CompleteScrCmd_SafariCanPlaceObject(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariAddObjectEntries(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariPlaceObject(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariBufferObjectName(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariObjectInFront(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariRemoveObject(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariChallengeCompleted(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariStampBaoba(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariAddAreaEntries(ScriptContext *ctx);
BOOL CompleteScrCmd_SafariSetArea(ScriptContext *ctx);

#endif // POKEPLATINUM_COMPLETE_SAFARI_H
