#include "dynamic_map_features.h"

#include <nitro.h>
#include <string.h>

#include "constants/field/dynamic_map_features.h"
#include "generated/map_headers.h"

#include "field/field_system.h"
#include "overlay005/villa_furniture.h"
#include "overlay006/great_marsh_tram.h"
#include "overlay008/gym_features.h"
#include "overlay009/ov9_02249960.h"

#include "complete_gyms.h" // Sovereign Complete
#include "field_system.h"
#include "persisted_map_features.h"
#include "platform_lift.h"
#include "savedata_misc.h"

const static DynamicMapFeaturesInitFunc sInitFuncs[DYNAMIC_MAP_FEATURES_COUNT] = {
    NULL,
    PastoriaGym_DynamicMapFeaturesInit,
    HearthomeGym_DynamicMapFeaturesInit,
    CanalaveGym_DynamicMapFeaturesInit,
    VeilstoneGym_DynamicMapFeaturesInit,
    SunyshoreGym_DynamicMapFeaturesInit,
    GreatMarshTram_DynamicMapFeaturesInit,
    PlatformLift_DynamicMapFeaturesInit,
    EternaGym_DynamicMapFeaturesInit,
    DistWorld_DynamicMapFeaturesInit,
    Villa_DynamicMapFeaturesInit,
    CompleteVermilionGym_DynamicMapFeaturesInit, // Sovereign Complete
    CompleteVioletGym_DynamicMapFeaturesInit, // Sovereign Complete
    CompleteCianwoodGym_DynamicMapFeaturesInit, // Sovereign Complete
    CompleteAzaleaGym_DynamicMapFeaturesInit, // Sovereign Complete
    CompleteBlackthornGym_DynamicMapFeaturesInit, // Sovereign Complete
    CompleteEcruteakGym_DynamicMapFeaturesInit, // Sovereign Complete
    CompleteViridianGym_DynamicMapFeaturesInit, // Sovereign Complete
    CompleteFuchsiaGym_DynamicMapFeaturesInit // Sovereign Complete
};

const static DynamicMapFeaturesFreeFunc sFreeFuncs[DYNAMIC_MAP_FEATURES_COUNT] = {
    NULL,
    NULL,
    HearthomeGym_DynamicMapFeaturesFree,
    CanalaveGym_DynamicMapFeaturesFree,
    VeilstoneGym_DynamicMapFeaturesFree,
    SunyshoreGym_DynamicMapFeaturesFree,
    NULL,
    NULL,
    EternaGym_DynamicMapFeaturesFree,
    DistWorld_DynamicMapFeaturesFree,
    Villa_DynamicMapFeaturesFree,
    CompleteVermilionGym_DynamicMapFeaturesFree, // Sovereign Complete
    CompleteVioletGym_DynamicMapFeaturesFree, // Sovereign Complete
    CompleteCianwoodGym_DynamicMapFeaturesFree, // Sovereign Complete
    CompleteAzaleaGym_DynamicMapFeaturesFree, // Sovereign Complete
    CompleteBlackthornGym_DynamicMapFeaturesFree, // Sovereign Complete
    CompleteEcruteakGym_DynamicMapFeaturesFree, // Sovereign Complete
    CompleteViridianGym_DynamicMapFeaturesFree, // Sovereign Complete
    CompleteFuchsiaGym_DynamicMapFeaturesFree // Sovereign Complete
};

const static DynamicMapFeaturesCheckCollisionFunc sCheckCollisionFuncs[DYNAMIC_MAP_FEATURES_COUNT] = {
    NULL,
    PastoriaGym_DynamicMapFeaturesCheckCollision,
    NULL,
    CanalaveGym_DynamicMapFeaturesCheckCollision,
    VeilstoneGym_DynamicMapFeaturesCheckCollision,
    SunyshoreGym_DynamicMapFeaturesCheckCollision,
    NULL,
    NULL,
    EternaGym_DynamicMapFeaturesCheckCollision,
    DistWorld_DynamicMapFeaturesCheckCollision,
    Villa_DynamicMapFeaturesCheckCollision,
    NULL, // Sovereign Complete
    NULL, // Sovereign Complete
    NULL, // Sovereign Complete
    NULL, // Sovereign Complete
    CompleteBlackthornGym_DynamicMapFeaturesCheckCollision, // Sovereign Complete
    NULL, // Sovereign Complete
    NULL, // Sovereign Complete
    NULL // Sovereign Complete
};

void DynamicMapFeatures_Init(FieldSystem *fieldSystem)
{
    PersistedMapFeatures *persistedMapFeatures = MiscSaveBlock_GetPersistedMapFeatures(FieldSystem_GetSaveData(fieldSystem));
    int id = PersistedMapFeatures_GetID(persistedMapFeatures);

    if (id == DYNAMIC_MAP_FEATURES_NONE) {
        return;
    }

    sInitFuncs[id](fieldSystem);
}

void DynamicMapFeatures_Free(FieldSystem *fieldSystem)
{
    PersistedMapFeatures *persistedMapFeatures = MiscSaveBlock_GetPersistedMapFeatures(FieldSystem_GetSaveData(fieldSystem));
    int id = PersistedMapFeatures_GetID(persistedMapFeatures);

    if (id == DYNAMIC_MAP_FEATURES_NONE) {
        return;
    }

    if (sFreeFuncs[id] != NULL) {
        sFreeFuncs[id](fieldSystem);
    }
}

BOOL DynamicMapFeatures_CheckCollision(FieldSystem *fieldSystem, const int tileX, const int tileZ, const fx32 height, BOOL *isColliding)
{
    PersistedMapFeatures *persistedMapFeatures = MiscSaveBlock_GetPersistedMapFeatures(FieldSystem_GetSaveData(fieldSystem));
    int id = PersistedMapFeatures_GetID(persistedMapFeatures);

    if (id == DYNAMIC_MAP_FEATURES_NONE) {
        return FALSE;
    }

    if (sCheckCollisionFuncs[id] != NULL) {
        BOOL hasCollision = sCheckCollisionFuncs[id](fieldSystem, tileX, tileZ, height, isColliding);
        return hasCollision;
    }

    return FALSE;
}

BOOL DynamicMapFeatures_WillPlayerJumpEternaGymClock(FieldSystem *fieldSystem, const int tileX, const int tileZ, const fx32 unused3, int direction)
{
    return fieldSystem->location->mapHeaderID == MAP_HEADER_ETERNA_CITY_GYM
        && EternaGym_IsHourHandJumpTile(fieldSystem, tileX, tileZ, direction);
}
