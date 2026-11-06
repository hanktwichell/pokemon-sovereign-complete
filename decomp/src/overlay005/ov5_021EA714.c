#include "overlay005/ov5_021EA714.h"

#include <nitro.h>
#include <string.h>

#include "applications/poketch/unavailable/graphics.h"
#include "field/field_system.h"
#include "field/field_system_sub2_t.h"

#include "applications/complete_photo_caption.h" // Sovereign Complete
#include "complete_dowsing.h" // Sovereign Complete
#include "complete_photo.h" // Sovereign Complete
#include "complete_pokegear.h" // Sovereign Complete
#include "game_overlay.h"
#include "poketch.h"
#include "render_oam.h"
#include "system_flags.h"
#include "vars_flags.h"

#ifdef SOVEREIGN_TEST
#include "sovereign_test.h"
#endif

FS_EXTERN_OVERLAY(poketch_unavailable);
FS_EXTERN_OVERLAY(poketch);
FS_EXTERN_OVERLAY(complete_pokegear); // Sovereign Complete
FS_EXTERN_OVERLAY(complete_photo_caption); // Sovereign Complete
FS_EXTERN_OVERLAY(complete_dowsing); // Sovereign Complete

void FieldSystem_SendPoketchEvent(FieldSystem *fieldSystem, enum PoketchEventID eventID, u32 dummy)
{
    if (fieldSystem->unk_04 != NULL && fieldSystem->unk_04->poketchSys != NULL) {
        PoketchSystem_SendEvent(fieldSystem->unk_04->poketchSys, eventID, dummy);
    }
}

void ov5_021EA728(FieldSystem *fieldSystem)
{
#ifdef SOVEREIGN_TEST
    Poketch *poketch = SaveData_GetPoketch(fieldSystem->saveData);

    if (gSovereignTestPoketchApp) { // here, as the bottom screen is set up, so its shutdown later matches it
        Poketch_Enable(poketch);
        Poketch_RegisterApp(poketch, gSovereignTestPoketchApp - 1);
        poketch->appIndex = gSovereignTestPoketchApp - 1;
        gSovereignTestPoketchApp = 0;
    }
#endif

    // Sovereign Complete: or HeartGold's Pokégear (include/complete_pokegear.h); the one shown is remembered, for its end
    enum CompleteBottomScreen screen = CompletePhoto_Showing() != NULL ? COMPLETE_BOTTOM_SCREEN_PHOTO : CompleteBottomScreen_Wanted(fieldSystem->saveData);

    CompleteBottomScreen_SetActive(screen);

    if (screen == COMPLETE_BOTTOM_SCREEN_PHOTO) { // a photo from the album shows: its caption (include/complete_photo.h)
        Overlay_LoadByID(FS_OVERLAY_ID(complete_photo_caption), 2);
        CompletePhotoCaption_Create(fieldSystem, fieldSystem->bgConfig);
    } else if (screen == COMPLETE_BOTTOM_SCREEN_DOWSING) { // HeartGold's Dowsing Machine (include/complete_dowsing.h)
        Overlay_LoadByID(FS_OVERLAY_ID(complete_dowsing), 2);
        CompleteDowsing_Create(fieldSystem, fieldSystem->bgConfig);
    } else if (screen == COMPLETE_BOTTOM_SCREEN_POKEGEAR) {
        Overlay_LoadByID(FS_OVERLAY_ID(complete_pokegear), 2);
        CompletePokegear_Create(fieldSystem, fieldSystem->bgConfig);
    } else if (screen == COMPLETE_BOTTOM_SCREEN_POKETCH) {
        Overlay_LoadByID(FS_OVERLAY_ID(poketch), 2);
        PoketchSystem_Create(fieldSystem, &fieldSystem->unk_04->poketchSys, fieldSystem->saveData, fieldSystem->bgConfig, RenderOam_GetScreenOam(1));
    } else {
        Overlay_LoadByID(FS_OVERLAY_ID(poketch_unavailable), 2);
        PoketchUnavailableScreen_Init(fieldSystem->bgConfig);
    }
}

// Sovereign Complete: the bottom screen that was started ends (Platinum asked the save again, which a script can have
// changed since)
void ov5_021EA790(FieldSystem *fieldSystem)
{
    if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_PHOTO) {
        CompletePhotoCaption_StartShutdown();
    } else if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_DOWSING) {
        CompleteDowsing_StartShutdown();
    } else if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_POKEGEAR) {
        CompletePokegear_StartShutdown();
    } else if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_POKETCH) {
        PoketchSystem_StartShutdown(fieldSystem->unk_04->poketchSys);
    } else {
        PoketchUnavailableScreen_Exit(fieldSystem->bgConfig);
    }
}

u8 ov5_021EA7CC(FieldSystem *fieldSystem)
{
    if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_PHOTO) { // Sovereign Complete
        if (CompletePhotoCaption_IsShutdown()) {
            Overlay_UnloadByID(FS_OVERLAY_ID(complete_photo_caption));
            return 1;
        }
    } else if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_DOWSING) { // Sovereign Complete
        if (CompleteDowsing_IsShutdown()) {
            Overlay_UnloadByID(FS_OVERLAY_ID(complete_dowsing));
            return 1;
        }
    } else if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_POKEGEAR) { // Sovereign Complete
        if (CompletePokegear_IsShutdown()) {
            Overlay_UnloadByID(FS_OVERLAY_ID(complete_pokegear));
            return 1;
        }
    } else if (CompleteBottomScreen_Active() == COMPLETE_BOTTOM_SCREEN_POKETCH) {
        if (PoketchSystem_IsSystemShutdown(fieldSystem->unk_04->poketchSys)) {
            fieldSystem->unk_04->poketchSys = NULL;
            Overlay_UnloadByID(FS_OVERLAY_ID(poketch));
            return 1;
        }
    } else {
        if (PoketchUnavailableScreen_IsDone(fieldSystem->bgConfig)) {
            Overlay_UnloadByID(FS_OVERLAY_ID(poketch_unavailable));
            return 1;
        }
    }

    return 0;
}

void ov5_021EA830(FieldSystem *fieldSystem)
{
    Overlay_LoadByID(FS_OVERLAY_ID(poketch_unavailable), 2);
    PoketchUnavailableScreen_Init(fieldSystem->bgConfig);
}

void ov5_021EA848(FieldSystem *fieldSystem)
{
    PoketchUnavailableScreen_Exit(fieldSystem->bgConfig);
}

BOOL ov5_021EA854(FieldSystem *fieldSystem)
{
    if (PoketchUnavailableScreen_IsDone(fieldSystem->bgConfig)) {
        Overlay_UnloadByID(FS_OVERLAY_ID(poketch_unavailable));
        return 1;
    }

    return 0;
}
