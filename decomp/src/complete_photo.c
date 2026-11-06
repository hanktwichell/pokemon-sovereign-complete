#include "complete_photo.h"

#include <nitro.h>
#include <string.h>

#include "constants/narc.h"
#include "generated/map_headers.h"
#include "generated/movement_types.h"
#include "generated/species.h"

#include "applications/complete_photo_album.h"
#include "field/field_system.h"
#include "overlay005/land_data.h"
#include "overlay005/map_prop.h"

#include "bg_window.h"
#include "camera.h"
#include "field_map_change.h"
#include "field_overworld_state.h"
#include "field_system.h"
#include "field_task.h"
#include "field_transition.h"
#include "game_overlay.h"
#include "graphics.h"
#include "heap.h"
#include "location.h"
#include "map_object.h"
#include "narc.h"
#include "party.h"
#include "player_avatar.h"
#include "pokemon.h"
#include "rtc.h"
#include "save_player.h"
#include "savedata.h"
#include "screen_fade.h"
#include "script_manager.h"
#include "sound.h"
#include "sound_playback.h"
#include "trainer_info.h"
#include "unk_02054884.h"

#include "complete_follower.h"
#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: HeartGold's photo album (include/complete_photo.h): its save, and the field's side of Cameron's
// photos and of looking at them (HeartGold's field_take_photo.c), which runs as field tasks while the map goes and
// comes back, so it lives in the main module.

FS_EXTERN_OVERLAY(complete_photo_album);

#define PHOTO_LOCALID_FIRST 0xF8 // the photo's Pokémon and person (0xF8 + n), clear of the maps' own and the follower's

static BOOL sPhotoMode; // the map loads as a photo (HeartGold's fieldSystem->unkAC)
static BOOL sTimeFrozen;
static u8 sFrozenHour, sFrozenMinute;
static CompletePhotoShowing *sShowing; // the photo showing, for the bottom screen

#ifdef SOVEREIGN_TEST
u8 gCompleteTestPhotoCount; // test build: the album's photos as last read or written
u8 gCompleteTestViewState = 0xFF; // test build: the album's field task's state (enum ViewAlbumState), 0xFF without one
#endif

// HeartGold's sCameraParam: a long lens from the south, a little above, on the spot and the party behind it
static const fx32 sCameraDistance = FX32_CONST(666.922119140625);
static const CameraAngle sCameraAngle = { 0xEE00, 0, 0, 0 };
static const u16 sCameraFOV = 0x230;
static const VecFx32 sCameraShift = { FX32_CONST(16.3125), 0, FX32_CONST(-47) };

// Where each Pokémon of the party stands, from the photo's spot (HeartGold's sPhotoMonCoordOffsets); with a person,
// they stand two to the east and the lead at one east, one north (sSoloPhotoMonCoordOffsets)
static const s8 sPartyOffsets[MAX_PARTY_SIZE][2] = { { 2, 0 }, { 1, -1 }, { -1, -1 }, { 3, -1 }, { 0, -2 }, { 2, -2 } };

int CompletePhotoAlbum_SaveSize(void)
{
    return sizeof(CompletePhotoAlbum);
}

void CompletePhotoAlbum_Init(CompletePhotoAlbum *album)
{
    MI_CpuClear8(album, sizeof(CompletePhotoAlbum));
    album->magic = COMPLETE_PHOTO_ALBUM_MAGIC;
}

CompletePhotoAlbum *CompletePhotoAlbum_Load(SaveData *saveData, enum HeapID heapID)
{
    int result;
    CompletePhotoAlbum *album = SaveDataExtra_Get(saveData, heapID, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_PHOTO_ALBUM, &result);

    if (result != LOAD_RESULT_OK || album->magic != COMPLETE_PHOTO_ALBUM_MAGIC) { // an earlier save: no album yet
        CompletePhotoAlbum_Init(album);
    }

#ifdef SOVEREIGN_TEST
    gCompleteTestPhotoCount = CompletePhotoAlbum_Count(album);
#endif
    return album;
}

void CompletePhotoAlbum_Save(SaveData *saveData, CompletePhotoAlbum *album)
{
    // a fresh read first, so the write goes to the older of the two copies (as the Hall of Fame's does)
    int result;
    void *current = SaveDataExtra_Get(saveData, HEAP_ID_FIELD2, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_PHOTO_ALBUM, &result);

    Heap_Free(current);
    SaveDataExtra_Save(saveData, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_PHOTO_ALBUM, album);
#ifdef SOVEREIGN_TEST
    gCompleteTestPhotoCount = CompletePhotoAlbum_Count(album);
#endif
}

u8 CompletePhotoAlbum_Count(const CompletePhotoAlbum *album)
{
    u8 count = 0;

    for (int i = 0; i < COMPLETE_PHOTO_ALBUM_MAX; i++) {
        if (album->photos[i].spot != 0) {
            count++;
        }
    }

    return count;
}

u8 CompletePhotoAlbum_CountSaved(SaveData *saveData)
{
    CompletePhotoAlbum *album = CompletePhotoAlbum_Load(saveData, HEAP_ID_FIELD2);
    u8 count = CompletePhotoAlbum_Count(album);

    Heap_Free(album);
    return count;
}

void CompletePhotoAlbum_Delete(CompletePhotoAlbum *album, u8 index)
{
    for (int i = index; i < COMPLETE_PHOTO_ALBUM_MAX - 1; i++) {
        album->photos[i] = album->photos[i + 1];
    }

    MI_CpuClear8(&album->photos[COMPLETE_PHOTO_ALBUM_MAX - 1], sizeof(CompletePhoto));
}

void CompletePhotoAlbum_Swap(CompletePhotoAlbum *album, u8 a, u8 b)
{
    CompletePhoto photo = album->photos[a];

    album->photos[a] = album->photos[b];
    album->photos[b] = photo;
}

BOOL CompletePhoto_IsPhotoMode(void)
{
    return sPhotoMode;
}

void CompletePhoto_ApplyFrozenTime(RTCTime *time)
{
    if (sTimeFrozen) {
        time->hour = sFrozenHour;
        time->minute = sFrozenMinute;
    }
}

CompletePhotoShowing *CompletePhoto_Showing(void)
{
    return sShowing;
}

static void ReadSpot(u16 spot, CompletePhotoSpot *out)
{
    NARC_ReadFromMemberByIndexPair(out, NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, COMPLETE_PHOTO_NARC_SPOTS, spot * sizeof(CompletePhotoSpot), sizeof(CompletePhotoSpot));
}

static void SetPhotoMon(CompletePhotoMon *photoMon, Pokemon *mon)
{
    photoMon->species = Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL);
    photoMon->form = Pokemon_GetValue(mon, MON_DATA_FORM, NULL);
    photoMon->shiny = Pokemon_IsShiny(mon);
    photoMon->gender = Pokemon_GetGender(mon);
}

// HeartGold's Photo_InitFromArcData: the spot's data, the date, the party (eggs left out), the lead's name
static void InitPhoto(CompletePhoto *photo, FieldSystem *fieldSystem, u16 spotIndex, const CompletePhotoSpot *spot)
{
    SaveData *saveData = fieldSystem->saveData;
    Party *party = SaveData_GetParty(saveData);
    int partyCount = Party_GetCurrentCount(party);
    RTCDate date;
    RTCTime time;

    MI_CpuClear8(photo, sizeof(CompletePhoto));
    GetCurrentDateTime(&date, &time);

    photo->spot = spotIndex + 1;
    photo->icon = spot->icon;
    photo->mapHeaderID = spot->mapHeaderID;
    photo->x = spot->x;
    photo->z = spot->z;
    photo->subjectGfx = spot->subjectGfx;
    photo->playerState = FieldOverworldState_GetPlayerData(SaveData_GetFieldOverworldState(saveData))->playerState;
    photo->gender = TrainerInfo_Gender(SaveData_GetTrainerInfo(saveData));
    photo->hour = time.hour;
    photo->minute = time.minute;
    photo->date = ((date.year & 0xFF) << 24) | ((date.month & 0xFF) << 16) | ((date.day & 0xFF) << 8) | date.week;

    Pokemon *lead = Party_FindFirstEligibleBattler(party);

    Pokemon_GetValue(lead, MON_DATA_NICKNAME, photo->leadMonNick);

    if (spot->subjectGfx != 0) {
        photo->numMons = 1;
        SetPhotoMon(&photo->party[0], lead);
        return;
    }

    photo->numMons = partyCount;

    for (int i = 0; i < partyCount; i++) {
        Pokemon *mon = Party_GetPokemonBySlotIndex(party, i);

        if (!Pokemon_GetValue(mon, MON_DATA_IS_EGG, NULL)) {
            SetPhotoMon(&photo->party[i], mon);
        }
    }
}

static MapObject *AddPhotoObject(FieldSystem *fieldSystem, int gfx, int x, int z, int localID)
{
    MapObject *object = MapObjectMan_AddMapObject(fieldSystem->mapObjMan, x, z, DIR_SOUTH, gfx, MOVEMENT_TYPE_NONE, fieldSystem->location->mapHeaderID);

    if (object != NULL) {
        MapObject_SetLocalID(object, localID);
    }

    return object;
}

static void HideProps(FieldSystem *fieldSystem, u16 model)
{
    for (u8 block = 0; block < 4; block++) {
        MapPropManager *propMan = NULL;

        LandDataManager_GetLoadedMapPropManager(block, fieldSystem->landDataMan, &propMan);

        if (propMan == NULL) {
            continue;
        }

        for (int i = 0; i < MAX_LOADED_MAP_PROPS; i++) {
            MapProp *prop = MapPropManager_GetLoadedProp(propMan, i);

            if (prop->loaded && MapProp_GetModelID(prop) == model) {
                MapProp_SetHidden(prop, TRUE);
            }
        }
    }
}

// Sprites sit 2 units lower for HeartGold's camera (its facingVector.y -= 2, Platinum's sprite jump offset)
static void LowerSprite(MapObject *object)
{
    VecFx32 offset;

    MapObject_GetSpriteJumpOffset(object, &offset);
    offset.y -= FX32_CONST(2);
    MapObject_SetSpriteJumpOffset(object, &offset);
}

// The photo's scene on the map loaded at its spot: HeartGold's camera, the buildings in the way hidden, the player
// facing it, the party around them (or the person and the lead)
static void SetUpScene(FieldSystem *fieldSystem, const CompletePhoto *photo)
{
    CompletePhotoSpot spot;

    Camera_SetDistance(sCameraDistance, fieldSystem->camera);
    Camera_SetAngleAroundTarget(&sCameraAngle, fieldSystem->camera);
    Camera_SetFOV(sCameraFOV, fieldSystem->camera);
    Camera_ComputeProjectionMatrix(CAMERA_PROJECTION_PERSPECTIVE, fieldSystem->camera);
    Camera_Move(&sCameraShift, fieldSystem->camera);

    ReadSpot(photo->spot - 1, &spot);

    for (int i = 0; i < 2; i++) {
        if (spot.hiddenProps[i] != 0) {
            HideProps(fieldSystem, spot.hiddenProps[i]);
        }
    }

    LowerSprite(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar));

    if (photo->subjectGfx != 0) {
        MapObject *subject = AddPhotoObject(fieldSystem, photo->subjectGfx, photo->x + 2, photo->z, PHOTO_LOCALID_FIRST);

        if (subject != NULL) {
            LowerSprite(subject);
        }
    }

    for (int i = 0; i < photo->numMons && i < MAX_PARTY_SIZE; i++) {
        const CompletePhotoMon *mon = &photo->party[i];

        if (mon->species == SPECIES_NONE) {
            continue;
        }

        int gfx = CompleteFollower_MonGfx(mon->species, mon->form, mon->gender, mon->shiny);

        if (gfx < 0) {
            continue;
        }

        int x = photo->subjectGfx != 0 ? photo->x + 1 : photo->x + sPartyOffsets[i][0];
        int z = photo->subjectGfx != 0 ? photo->z - 1 : photo->z + sPartyOffsets[i][1];
        MapObject *object = AddPhotoObject(fieldSystem, gfx, x, z, PHOTO_LOCALID_FIRST + 1 + i);

        if (object != NULL) {
            LowerSprite(object);
        }
    }
}

// HeartGold's drawCameraGfx: the viewfinder over the main screen's BG2
static void DrawViewfinder(FieldSystem *fieldSystem)
{
    Graphics_LoadPalette(NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, COMPLETE_PHOTO_NARC_VIEWFINDER_PALETTE, PAL_LOAD_MAIN_BG, 0, 0, HEAP_ID_FIELD1);
    Graphics_LoadTilesToBgLayer(NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, COMPLETE_PHOTO_NARC_VIEWFINDER_TILES, fieldSystem->bgConfig, BG_LAYER_MAIN_2, 0, 0, TRUE, HEAP_ID_FIELD1);
    Graphics_LoadTilemapToBgLayer(NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM, COMPLETE_PHOTO_NARC_VIEWFINDER_SCREEN, fieldSystem->bgConfig, BG_LAYER_MAIN_2, 0, 0x600, TRUE, HEAP_ID_FIELD1);
    Bg_CopyTilemapBufferToVRAM(fieldSystem->bgConfig, BG_LAYER_MAIN_2);
    Bg_SetPriority(BG_LAYER_MAIN_2, 0);
}

// After the map comes back with the script's object recreated, its pointer is the new one (a script talking to Cameron
// locks and releases him by it)
static void KeepScriptTarget(FieldSystem *fieldSystem, int localID)
{
    MapObject **target = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_TARGET_OBJECT);

    if (target != NULL && *target != NULL) {
        *target = localID >= 0 ? MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, localID) : NULL;
    }
}

static int ScriptTargetLocalID(FieldSystem *fieldSystem)
{
    MapObject **target = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_TARGET_OBJECT);

    return target != NULL && *target != NULL ? MapObject_GetLocalID(*target) : -1;
}

enum TakePhotoState {
    TAKE_PHOTO_LEAVE = 0,
    TAKE_PHOTO_GO_TO_SPOT,
    TAKE_PHOTO_START_MAP,
    TAKE_PHOTO_SCENE,
    TAKE_PHOTO_FADE_IN,
    TAKE_PHOTO_WAIT,
    TAKE_PHOTO_SHUTTER,
    TAKE_PHOTO_SHUTTER_CLOSED,
    TAKE_PHOTO_SHUTTER_OPEN,
    TAKE_PHOTO_AFTER,
    TAKE_PHOTO_FADE_OUT,
    TAKE_PHOTO_LEAVE_SPOT,
    TAKE_PHOTO_GO_BACK,
    TAKE_PHOTO_RESTART_MAP,
    TAKE_PHOTO_DONE,
};

typedef struct TakePhotoTask {
    u8 state;
    u8 timer;
    s16 targetLocalID;
    Location back;
    CompletePhoto photo;
} TakePhotoTask;

static BOOL FieldTask_TakePhoto(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    TakePhotoTask *take = FieldTask_GetEnv(task);
    Location spot;

    switch (take->state) {
    case TAKE_PHOTO_LEAVE: // the script has faded to black
        FieldTransition_FinishMap(task);
        take->state++;
        break;
    case TAKE_PHOTO_GO_TO_SPOT:
        sPhotoMode = TRUE;
        Location_Set(&spot, take->photo.mapHeaderID, -1, take->photo.x, take->photo.z, DIR_SOUTH);
        FieldTask_ChangeMapByLocation(task, &spot);
        take->state++;
        break;
    case TAKE_PHOTO_START_MAP:
        FieldTransition_StartMap(task);
        take->state++;
        break;
    case TAKE_PHOTO_SCENE:
        SetUpScene(fieldSystem, &take->photo);
        take->timer = 0;
        take->state++;
        break;
    case TAKE_PHOTO_FADE_IN: // a few frames for the sprites' graphics, then the viewfinder
        if (++take->timer < 6) {
            break;
        }

        DrawViewfinder(fieldSystem);
        FieldTransition_FadeIn(task);
        take->timer = 0;
        take->state++;
        break;
    case TAKE_PHOTO_WAIT:
        if (++take->timer >= 30) {
            take->timer = 0;
            take->state++;
        }
        break;
    case TAKE_PHOTO_SHUTTER: // HeartGold's shutter: the main screen closes and opens again
        Sound_PlayEffect(SEQ_SE_GS_SHUTTER_sseq);
        StartScreenFade(FADE_MAIN_ONLY, FADE_TYPE_UNK_8, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, 1, HEAP_ID_FIELD1);
        take->state++;
        break;
    case TAKE_PHOTO_SHUTTER_CLOSED:
        if (IsScreenFadeDone()) {
            CompletePhotoAlbum *album = CompletePhotoAlbum_Load(fieldSystem->saveData, HEAP_ID_FIELD2);
            u8 count = CompletePhotoAlbum_Count(album);

            if (count < COMPLETE_PHOTO_ALBUM_MAX) {
                RTCDate date;
                RTCTime time;

                GetCurrentDateTime(&date, &time);
                take->photo.date = ((date.year & 0xFF) << 24) | ((date.month & 0xFF) << 16) | ((date.day & 0xFF) << 8) | date.week;
                take->photo.hour = time.hour;
                take->photo.minute = time.minute;
                album->photos[count] = take->photo;
                CompletePhotoAlbum_Save(fieldSystem->saveData, album);
            }

            Heap_Free(album);
            StartScreenFade(FADE_MAIN_ONLY, FADE_TYPE_UNK_9, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, 1, HEAP_ID_FIELD1);
            take->state++;
        }
        break;
    case TAKE_PHOTO_SHUTTER_OPEN:
        if (IsScreenFadeDone()) {
            take->timer = 0;
            take->state++;
        }
        break;
    case TAKE_PHOTO_AFTER:
        if (++take->timer >= 30) {
            take->state++;
        }
        break;
    case TAKE_PHOTO_FADE_OUT:
        FieldTransition_FadeOut(task);
        take->state++;
        break;
    case TAKE_PHOTO_LEAVE_SPOT:
        FieldTransition_FinishMap(task);
        take->state++;
        break;
    case TAKE_PHOTO_GO_BACK:
        sPhotoMode = FALSE;
        FieldTask_ChangeMapByLocation(task, &take->back);
        take->state++;
        break;
    case TAKE_PHOTO_RESTART_MAP:
        FieldTransition_StartMap(task);
        take->state++;
        break;
    case TAKE_PHOTO_DONE: // the script fades back in
        KeepScriptTarget(fieldSystem, take->targetLocalID);
        Heap_Free(take);
        return TRUE;
    }

    return FALSE;
}

// HeartGold's FieldSystem_TakePhoto (CameronPhoto); nothing with a full album (its scripts ask first)
void CompletePhoto_StartTakePhoto(FieldSystem *fieldSystem, u16 spotIndex)
{
    if (CompletePhotoAlbum_CountSaved(fieldSystem->saveData) >= COMPLETE_PHOTO_ALBUM_MAX) {
        return;
    }

    TakePhotoTask *take = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(TakePhotoTask));
    CompletePhotoSpot spot;

    MI_CpuClear8(take, sizeof(TakePhotoTask));
    ReadSpot(spotIndex, &spot);
    InitPhoto(&take->photo, fieldSystem, spotIndex, &spot);
    Location_Set(&take->back, fieldSystem->location->mapHeaderID, -1, PlayerAvatar_GetXPos(fieldSystem->playerAvatar), PlayerAvatar_GetZPos(fieldSystem->playerAvatar), PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar));
    take->targetLocalID = ScriptTargetLocalID(fieldSystem);
    FieldTask_InitCall(fieldSystem->task, FieldTask_TakePhoto, take);
}

enum ViewAlbumState {
    VIEW_ALBUM_OPEN = 0,
    VIEW_ALBUM_WAIT,
    VIEW_ALBUM_GO_TO_PHOTO,
    VIEW_ALBUM_START_MAP,
    VIEW_ALBUM_SCENE,
    VIEW_ALBUM_FADE_IN,
    VIEW_ALBUM_LOOK,
    VIEW_ALBUM_FADE_OUT,
    VIEW_ALBUM_LEAVE_PHOTO,
    VIEW_ALBUM_NEXT,
    VIEW_ALBUM_GO_BACK,
    VIEW_ALBUM_DONE,
};

typedef struct ViewAlbumTask {
    u8 state;
    u8 timer;
    u8 viewed; // a photo showed, so the player's map loads again at the end
    u8 playerState; // the player's, kept while a photo shows its own
    Location back;
    CompletePhotoAlbumArgs *args;
    CompletePhotoShowing showing;
} ViewAlbumTask;

static void LoadShowing(FieldSystem *fieldSystem, ViewAlbumTask *view)
{
    CompletePhotoAlbum *album = CompletePhotoAlbum_Load(fieldSystem->saveData, HEAP_ID_FIELD2);

    view->showing.photo = album->photos[view->showing.index];
    view->showing.count = CompletePhotoAlbum_Count(album);
    view->showing.input = COMPLETE_PHOTO_INPUT_NONE;
    Heap_Free(album);
}

static BOOL FieldTask_ViewAlbum(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    ViewAlbumTask *view = FieldTask_GetEnv(task);
    PlayerData *playerData = FieldOverworldState_GetPlayerData(SaveData_GetFieldOverworldState(fieldSystem->saveData));
    Location spot;

#ifdef SOVEREIGN_TEST
    gCompleteTestViewState = view->state;
#endif

    switch (view->state) {
    case VIEW_ALBUM_OPEN: // HeartGold's ViewPhotoFieldTask_Init: the album, its cursor on the last photo shown
        view->args = CompletePhotoAlbum_LaunchApp(fieldSystem, view->showing.index);
        view->state++;
        break;
    case VIEW_ALBUM_WAIT:
        if (FieldSystem_IsRunningApplication(fieldSystem)) {
            break;
        }

        view->showing.index = view->args->cursorPos;
        view->state = view->args->photoWasSelected ? VIEW_ALBUM_GO_TO_PHOTO : VIEW_ALBUM_GO_BACK;
        Heap_Free(view->args);
        view->args = NULL;
        break;
    case VIEW_ALBUM_GO_TO_PHOTO: // the map at the photo's spot, at the hour it was taken, with its player
        LoadShowing(fieldSystem, view);
        view->viewed = TRUE;
        sPhotoMode = TRUE;
        sTimeFrozen = TRUE;
        sFrozenHour = view->showing.photo.hour;
        sFrozenMinute = view->showing.photo.minute;
        sShowing = &view->showing;
        playerData->playerState = view->showing.photo.playerState;
        Location_Set(&spot, view->showing.photo.mapHeaderID, -1, view->showing.photo.x, view->showing.photo.z, DIR_SOUTH);
        FieldTask_ChangeMapByLocation(task, &spot);
        view->state++;
        break;
    case VIEW_ALBUM_START_MAP:
        FieldTransition_StartMap(task);
        view->state++;
        break;
    case VIEW_ALBUM_SCENE:
        SetUpScene(fieldSystem, &view->showing.photo);
        view->timer = 0;
        view->state++;
        break;
    case VIEW_ALBUM_FADE_IN:
        if (++view->timer < 6) {
            break;
        }

        FieldTransition_FadeIn(task);
        view->state++;
        break;
    case VIEW_ALBUM_LOOK: // the bottom screen's buttons: back to the album, or the photo before or after
        if (view->showing.input != COMPLETE_PHOTO_INPUT_NONE) {
            view->state++;
        }
        break;
    case VIEW_ALBUM_FADE_OUT:
        FieldTransition_FadeOut(task);
        view->state++;
        break;
    case VIEW_ALBUM_LEAVE_PHOTO:
        FieldTransition_FinishMap(task);
        view->state++;
        break;
    case VIEW_ALBUM_NEXT:
        sShowing = NULL;

        if (view->showing.input == COMPLETE_PHOTO_INPUT_PREV && view->showing.index > 0) {
            view->showing.index--;
            view->state = VIEW_ALBUM_GO_TO_PHOTO;
        } else if (view->showing.input == COMPLETE_PHOTO_INPUT_NEXT && view->showing.index + 1 < view->showing.count) {
            view->showing.index++;
            view->state = VIEW_ALBUM_GO_TO_PHOTO;
        } else {
            view->state = VIEW_ALBUM_OPEN;
        }
        break;
    case VIEW_ALBUM_GO_BACK: // HeartGold's RestorePlayerOverworldPosition; the script's ReturnToField starts the map
        sPhotoMode = FALSE;
        sTimeFrozen = FALSE;
        sShowing = NULL;
        playerData->playerState = view->playerState;

        if (view->viewed) {
            FieldTask_ChangeMapByLocation(task, &view->back);
        }

        view->state++;
        break;
    case VIEW_ALBUM_DONE:
        Heap_Free(view);
#ifdef SOVEREIGN_TEST
        gCompleteTestViewState = 0xFF;
#endif
        return TRUE;
    }

    return FALSE;
}

// HeartGold's PhotoAlbum_LaunchApp: the album, its cursor on a photo; the field map ends as it starts
CompletePhotoAlbumArgs *CompletePhotoAlbum_LaunchApp(FieldSystem *fieldSystem, u8 cursorPos)
{
    static const ApplicationManagerTemplate sTemplate = {
        CompletePhotoAlbum_AppInit,
        CompletePhotoAlbum_AppMain,
        CompletePhotoAlbum_AppExit,
        FS_OVERLAY_ID(complete_photo_album),
    };
    static int sMenuInputState; // HeartGold keeps it in the field system; the album's own between its openings
    CompletePhotoAlbumArgs *args = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(CompletePhotoAlbumArgs));

    MI_CpuClear8(args, sizeof(CompletePhotoAlbumArgs));
    args->saveData = fieldSystem->saveData;
    args->menuInputState = &sMenuInputState;
    args->cursorPos = cursorPos;
    FieldSystem_StartChildProcess(fieldSystem, &sTemplate, args);
    return args;
}

// HeartGold's FieldSystem_ViewSavedPhotos (OpenPhotoAlbum): the script has faded out; the map ends as the album opens
void CompletePhoto_StartViewAlbum(FieldSystem *fieldSystem)
{
    ViewAlbumTask *view = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(ViewAlbumTask));

    MI_CpuClear8(view, sizeof(ViewAlbumTask));
    // where the player stands at the PC (the location is still where they came onto the map)
    Location_Set(&view->back, fieldSystem->location->mapHeaderID, -1, PlayerAvatar_GetXPos(fieldSystem->playerAvatar), PlayerAvatar_GetZPos(fieldSystem->playerAvatar), PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar));
    view->playerState = FieldOverworldState_GetPlayerData(SaveData_GetFieldOverworldState(fieldSystem->saveData))->playerState;
    FieldTask_InitCall(fieldSystem->task, FieldTask_ViewAlbum, view);
}
