#include "complete_dowsing.h"

#include <nitro.h>

#include "field/field_system.h"

#include "complete_phone.h"
#include "complete_pokegear.h"
#include "field_task.h"
#include "savedata.h"
#include "system_flags.h"

// Sovereign Complete: HeartGold's Dowsing Machine, its side in the main module (include/complete_dowsing.h): the
// bottom screen it takes outlives the overlay that draws it

#define FIELD_BOTTOM_SCREEN_POKETCH 1 // FieldSystem's bottomScreen: the Pokétch's, of the map's load mode

static BOOL sDowsingOn;
u16 gCompleteSimulatedKeys;

#ifdef SOVEREIGN_TEST
u16 gCompleteTestDowsing[12];
#endif

BOOL CompleteDowsing_IsOn(void)
{
    return sDowsingOn;
}

void CompleteDowsing_SetOn(BOOL on)
{
    sDowsingOn = on;
    CompleteBottomScreen_RequestRefresh();
}

BOOL CompleteDowsing_CanUse(FieldSystem *fieldSystem)
{
    return fieldSystem->bottomScreen == FIELD_BOTTOM_SCREEN_POKETCH && !SystemFlag_CheckPoketchHidden(SaveData_GetVarsFlags(fieldSystem->saveData));
}

// HeartGold's Task_ActivateDowsingMchnUI: the field's bottom screen becomes the Dowsing Machine's
BOOL CompleteDowsing_FieldTask_Start(FieldTask *task)
{
    CompleteDowsing_SetOn(TRUE);
    return TRUE;
}

// HeartGold's PlayerAvatar_CheckRunningShoesLock: its running shoes, set on the Dowsing Machine's screen, make the
// player run without B (src/player_move.c's PlayerAvatar_IsRunButtonHeld)
BOOL CompleteDowsing_RunningShoesOn(SaveData *saveData)
{
    return SaveData_GetCompletePhone(saveData)->runningShoesLock;
}

void CompleteDowsing_SetRunningShoes(SaveData *saveData, BOOL on)
{
    SaveData_GetCompletePhone(saveData)->runningShoesLock = on;
}
