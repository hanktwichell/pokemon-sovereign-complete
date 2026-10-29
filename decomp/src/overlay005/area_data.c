#include "overlay005/area_data.h"

#include <nitro.h>
#include <string.h>

#include "constants/graphics.h"
#include "constants/heap.h"

#include "overlay005/map_prop_animation.h"
#include "overlay005/map_prop_material_shape.h"

#include "easy3d.h"
#include "heap.h"
#include "narc.h"

static const GXRgb sIndoorsEdgeMarkings[8] = {
    COLOR_BLACK,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY
};

static const GXRgb sOutdoorsEdgeMarkings[8] = {
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY,
    COLOR_DARK_GRAY
};

static void AreaData_StripTextureData(void *resourceFile, NNSG3dResTex *texture)
{
    u8 *textureData = (u8 *)texture + texture->texInfo.ofsTex;
    u32 strippedTextureDataSize = (u32)(textureData - (u8 *)resourceFile);

    Heap_Realloc(resourceFile, strippedTextureDataSize);
}

// Sovereign Complete: HeartGold's prop models (from 590: tools/complete/import_hgss_maps.py) each carry a copy of their
// textures. Platinum binds a prop to its area's texture set and never reads the copy, which stays in the field heap:
// Ecruteak Gym's four spotlights carry 49 KB each, more than the heap has room for. So the copy is cut off once the
// model is bound, as the area's own sets are. Should a model's textures not all be in its area's set, its copy is
// uploaded first and bound; a copy the same as one already uploaded for this area binds to that one.
#define HGSS_FIRST_PROP_MODEL   590
#define MAX_OWN_PROP_TEXTURES   8

typedef struct OwnPropTexture {
    u32 hash;
    NNSG3dResTex *texture;
} OwnPropTexture;

static u32 AreaData_HashTexture(const NNSG3dResTex *texture)
{
    const u8 *bytes = (const u8 *)texture;
    u32 hash = 2166136261u; // FNV-1a

    for (u32 i = 0; i < texture->header.size; i++) {
        hash = (hash ^ bytes[i]) * 16777619u;
    }

    return hash;
}

static void AreaData_BindHGSSPropModel(void *modelFile, NNSG3dResTex *areaTexture, OwnPropTexture *own, int *ownCount)
{
    NNSG3dResMdlSet *modelSet = NNS_G3dGetMdlSet((NNSG3dResFileHeader *)modelFile);
    NNSG3dResTex *texture = NNS_G3dGetTex((NNSG3dResFileHeader *)modelFile);

    if (texture == NULL || texture->texInfo.sizeTex == 0 || texture->texInfo.ofsTex == 0) {
        return;
    }

    if (areaTexture == NULL || NNS_G3dBindMdlSet(modelSet, areaTexture) == FALSE) {
        u32 hash = AreaData_HashTexture(texture);
        int i;

        for (i = 0; i < *ownCount && own[i].hash != hash; i++) {
        }

        if (i < *ownCount) {
            NNS_G3dBindMdlSet(modelSet, own[i].texture);
        } else if (*ownCount < MAX_OWN_PROP_TEXTURES && Easy3D_UploadTextureToVRAM(texture)) {
            NNS_G3dBindMdlSet(modelSet, texture);
            own[*ownCount].hash = hash;
            own[*ownCount].texture = texture;
            (*ownCount)++;
        }
    }

    AreaData_StripTextureData(modelFile, texture);
}

AreaDataManager *AreaDataManager_Alloc(const int areaDataArchiveID, MapPropAnimationManager *mapPropAnimMan)
{
    AreaDataManager *areaDataManager = Heap_Alloc(HEAP_ID_FIELD1, sizeof(AreaDataManager));

    areaDataManager->loadData = Heap_AllocAtEnd(HEAP_ID_FIELD1, sizeof(AreaDataManagerLoadData));
    areaDataManager->loadData->areaDataArchiveID = areaDataArchiveID;
    areaDataManager->loadData->mapPropAnimMan = mapPropAnimMan;
    areaDataManager->loadData->dummy0C = 0;

    return areaDataManager;
}

void AreaDataManager_Load(AreaDataManager *areaDataManager)
{
    AreaDataManagerLoadData *loadData = areaDataManager->loadData;

    NARC_ReadWholeMemberByIndexPair(&areaDataManager->areaData, NARC_INDEX_FIELDDATA__AREADATA__AREA_DATA, loadData->areaDataArchiveID);

    areaDataManager->mapPropModelIDs = NARC_AllocAndReadWholeMemberByIndexPair(NARC_INDEX_FIELDDATA__AREADATA__AREA_BUILD_MODEL__AREA_BUILD, areaDataManager->areaData.mapPropArchivesID, HEAP_ID_FIELD1);
    loadData->mapPropModelIDsCount = areaDataManager->mapPropModelIDs[0];

    GF_ASSERT(loadData->mapPropModelIDsCount < MAX_MAP_PROP_MODEL_FILES);

    areaDataManager->mapTexture = NULL;
    areaDataManager->mapTextureFile = NARC_AllocAndReadWholeMemberByIndexPair(NARC_INDEX_FIELDDATA__AREADATA__AREA_MAP_TEX__MAP_TEX_SET, areaDataManager->areaData.mapTextureArchiveID, HEAP_ID_FIELD1);
    areaDataManager->mapPropTextureFile = NARC_AllocAndReadWholeMemberByIndexPair(NARC_INDEX_FIELDDATA__AREADATA__AREA_BUILD_MODEL__AREABM_TEXSET, areaDataManager->areaData.mapPropArchivesID, HEAP_ID_FIELD1);
    areaDataManager->mapTexture = NNS_G3dGetTex((NNSG3dResFileHeader *)areaDataManager->mapTextureFile);

    if (loadData->mapPropModelIDsCount != 0) {
        areaDataManager->mapPropTexture = NNS_G3dGetTex((NNSG3dResFileHeader *)areaDataManager->mapPropTextureFile);
    } else {
        areaDataManager->mapPropTexture = NULL;
    }

    BOOL textureUploaded = Easy3D_UploadTextureToVRAM(areaDataManager->mapTexture);
    GF_ASSERT(textureUploaded);

    AreaData_StripTextureData(areaDataManager->mapTextureFile, areaDataManager->mapTexture);

    if (areaDataManager->mapPropTexture != NULL) {
        BOOL textureUploaded = Easy3D_UploadTextureToVRAM(areaDataManager->mapPropTexture);
        GF_ASSERT(textureUploaded);

        AreaData_StripTextureData(areaDataManager->mapPropTextureFile, areaDataManager->mapPropTexture);
    }

    for (int i = 0; i < MAX_MAP_PROP_MODEL_FILES; i++) {
        areaDataManager->mapPropModelFiles[i] = NULL;
    }

    areaDataManager->mapPropMatShp = NULL;

    NARC *narc = NARC_ctor(NARC_INDEX_FIELDDATA__BUILD_MODEL__BUILD_MODEL, HEAP_ID_FIELD1);

    int i;
    int mapPropModelAnimeListNARCFileCount = MapPropAnimationManager_GetAnimeListNARCFileCount(loadData->mapPropAnimMan);
    OwnPropTexture ownTextures[MAX_OWN_PROP_TEXTURES]; // Sovereign Complete
    int ownTextureCount = 0;

    for (i = 0; i < loadData->mapPropModelIDsCount; i++) {
        u16 mapPropModelID = areaDataManager->mapPropModelIDs[i + 1];

        GF_ASSERT(areaDataManager->mapPropModelFiles[mapPropModelID] == NULL);
        areaDataManager->mapPropModelFiles[mapPropModelID] = NARC_AllocAndReadWholeMember(narc, mapPropModelID, HEAP_ID_FIELD1);

        if (mapPropModelID < mapPropModelAnimeListNARCFileCount) {
            NNSG3dResMdl *mapPropModel = NNS_G3dGetMdlByIdx(NNS_G3dGetMdlSet(areaDataManager->mapPropModelFiles[mapPropModelID]), 0);
            MapPropAnimationManager_LoadPropAnimations(mapPropModelID, mapPropModel, areaDataManager->mapPropTexture, loadData->mapPropAnimMan);
        }

        if (mapPropModelID >= HGSS_FIRST_PROP_MODEL) { // Sovereign Complete
            AreaData_BindHGSSPropModel(areaDataManager->mapPropModelFiles[mapPropModelID], areaDataManager->mapPropTexture, ownTextures, &ownTextureCount);
            continue;
        }

        BOOL textureBound = Easy3D_BindTextureToResource(areaDataManager->mapPropModelFiles[mapPropModelID], areaDataManager->mapPropTexture);
        GF_ASSERT(textureBound);
    }

    // Make sure the dummy box ("dmybox00") model is always loaded
    if (areaDataManager->mapPropModelFiles[0] == NULL) {
        areaDataManager->mapPropModelFiles[0] = NARC_AllocAndReadWholeMember(narc, 0, HEAP_ID_FIELD1);
        NNSG3dResTex *texture = NNS_G3dGetTex(areaDataManager->mapPropModelFiles[0]);

        if (texture != NULL) {
            BOOL res = Easy3D_UploadTextureToVRAM(texture);
            GF_ASSERT(res);

            res = Easy3D_BindTextureToResource(areaDataManager->mapPropModelFiles[0], texture);
            GF_ASSERT(res);
        }
    }

    NARC_dtor(narc);
    G3X_EdgeMarking(TRUE);

    if (!AreaDataManager_IsOutdoorsLighting(areaDataManager)) {
        G3X_SetEdgeColorTable(sIndoorsEdgeMarkings);
    } else {
        G3X_SetEdgeColorTable(sOutdoorsEdgeMarkings);
    }

    char mapPropMaterialShapeFilePath[256];

    areaDataManager->mapPropMatShp = MapPropMaterialShape_Alloc();
    sprintf(mapPropMaterialShapeFilePath, "fielddata/build_model/build_model_matshp.dat");
    MapPropMaterialShape_Load(mapPropMaterialShapeFilePath, areaDataManager->mapPropMatShp);

    Heap_Free(areaDataManager->loadData);
    areaDataManager->loadData = NULL;
}

NNSG3dResFileHeader **AreaDataManager_GetMapPropModelFile(const int mapPropModelID, AreaDataManager *const areaDataManager)
{
    GF_ASSERT(areaDataManager != NULL);

    if (areaDataManager->mapPropModelFiles[mapPropModelID] == NULL) {
        // Return the dummy box model if the requested one is not loaded
        GF_ASSERT(areaDataManager->mapPropModelFiles[0] != NULL);
        return &areaDataManager->mapPropModelFiles[0];
    }

    return &areaDataManager->mapPropModelFiles[mapPropModelID];
}

void AreaDataManager_Free(AreaDataManager **areaDataManager)
{
    if ((*areaDataManager)->mapPropMatShp != NULL) {
        MapPropMaterialShape_Free((*areaDataManager)->mapPropMatShp);
    }

    for (int i = 0; i < MAX_MAP_PROP_MODEL_FILES; i++) {
        if ((*areaDataManager)->mapPropModelFiles[i] != NULL) {
            Heap_Free((*areaDataManager)->mapPropModelFiles[i]);
        }
    }

    Heap_Free((*areaDataManager)->mapPropModelIDs);
    Heap_Free((*areaDataManager)->mapTextureFile);

    (*areaDataManager)->mapTextureFile = NULL;
    Heap_Free((*areaDataManager)->mapPropTextureFile);

    (*areaDataManager)->mapPropTextureFile = NULL;
    Heap_Free(*areaDataManager);

    (*areaDataManager) = NULL;
}

NNSG3dResTex *AreaDataManager_GetMapTexture(const AreaDataManager *areaDataManager)
{
    GF_ASSERT(areaDataManager != NULL);
    return areaDataManager->mapTexture;
}

NNSG3dResTex *AreaDataManager_GetMapPropTexture(const AreaDataManager *areaDataManager)
{
    GF_ASSERT(areaDataManager != NULL);
    return areaDataManager->mapPropTexture;
}

const MapPropMaterialShape *AreaDataManager_GetMapPropMaterialShape(const AreaDataManager *areaDataManager)
{
    return areaDataManager->mapPropMatShp;
}

BOOL AreaDataManager_IsOutdoorsLighting(const AreaDataManager *areaDataManager)
{
    if ((areaDataManager->areaData.areaLightArchiveID == 0) || (areaDataManager->areaData.areaLightArchiveID == 3)) {
        return TRUE;
    } else {
        return FALSE;
    }
}

u8 AreaDataManager_GetAreaLightArchiveID(const AreaDataManager *areaDataManager)
{
    return areaDataManager->areaData.areaLightArchiveID;
}

int AreaDataManager_GetMapPropModelID(const AreaDataManager *areaDataManager, const int index)
{
    return areaDataManager->mapPropModelIDs[index];
}

BOOL AreaDataManager_HasMapPropModelFile(const AreaDataManager *areaDataManager, const int mapPropModelID)
{
    return areaDataManager->mapPropModelFiles[mapPropModelID] != NULL;
}
