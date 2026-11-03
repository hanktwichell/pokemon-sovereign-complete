#include "complete_pokegear.h"

#include <nitro.h>

#include "generated/vars_flags.h"

#include "poketch.h"
#include "savedata.h"
#include "system_flags.h"
#include "vars_flags.h"

// Sovereign Complete: which bottom screen the field shows (include/complete_pokegear.h). The main module keeps it, as
// the bottom screen outlives the overlays that draw it.

static u8 sActiveBottomScreen = COMPLETE_BOTTOM_SCREEN_UNAVAILABLE;

#ifdef SOVEREIGN_TEST
void *gCompleteTestPokegear; // the Pokégear while it runs (here, as the Pokétch takes the overlay's memory after it)
#endif
static u8 sBottomScreenSwitchRequested;

BOOL CompletePokegear_IsOwned(SaveData *saveData)
{
    return VarsFlags_CheckFlag(SaveData_GetVarsFlags(saveData), FLAG_HGSS_GOT_POKEGEAR);
}

BOOL CompletePokegear_PoketchAvailable(SaveData *saveData)
{
    return Poketch_IsEnabled(SaveData_GetPoketch(saveData)) && !SystemFlag_CheckPoketchHidden(SaveData_GetVarsFlags(saveData));
}

enum CompleteBottomScreen CompleteBottomScreen_Wanted(SaveData *saveData)
{
    Poketch *poketch = SaveData_GetPoketch(saveData);

    if (SystemFlag_CheckPoketchHidden(SaveData_GetVarsFlags(saveData))) {
        return COMPLETE_BOTTOM_SCREEN_UNAVAILABLE;
    }

    if (CompletePokegear_IsOwned(saveData) && (!Poketch_IsEnabled(poketch) || poketch->completePokegearShown)) {
        return COMPLETE_BOTTOM_SCREEN_POKEGEAR;
    }

    return Poketch_IsEnabled(poketch) ? COMPLETE_BOTTOM_SCREEN_POKETCH : COMPLETE_BOTTOM_SCREEN_UNAVAILABLE;
}

enum CompleteBottomScreen CompleteBottomScreen_Active(void)
{
    return sActiveBottomScreen;
}

void CompleteBottomScreen_SetActive(enum CompleteBottomScreen screen)
{
    sActiveBottomScreen = screen;
}

void CompleteBottomScreen_RequestSwitch(SaveData *saveData)
{
    Poketch *poketch = SaveData_GetPoketch(saveData);

    if (sActiveBottomScreen == COMPLETE_BOTTOM_SCREEN_POKETCH && CompletePokegear_IsOwned(saveData)) {
        poketch->completePokegearShown = TRUE;
        sBottomScreenSwitchRequested = TRUE;
    } else if (sActiveBottomScreen == COMPLETE_BOTTOM_SCREEN_POKEGEAR && CompletePokegear_PoketchAvailable(saveData)) {
        poketch->completePokegearShown = FALSE;
        sBottomScreenSwitchRequested = TRUE;
    }
}

// The field switches the bottom screen as it runs when the player asked for the other one, or got the Pokégear while
// the "no Pokétch" screen shows (a script hiding the Pokétch, as Platinum's, waits for the next map)
BOOL CompleteBottomScreen_SwitchDue(SaveData *saveData)
{
    enum CompleteBottomScreen wanted = CompleteBottomScreen_Wanted(saveData);

    if (wanted == sActiveBottomScreen) {
        sBottomScreenSwitchRequested = FALSE;
        return FALSE;
    }

    if (sBottomScreenSwitchRequested || (sActiveBottomScreen == COMPLETE_BOTTOM_SCREEN_UNAVAILABLE && wanted == COMPLETE_BOTTOM_SCREEN_POKEGEAR)) {
        sBottomScreenSwitchRequested = FALSE;
        return TRUE;
    }

    return FALSE;
}
