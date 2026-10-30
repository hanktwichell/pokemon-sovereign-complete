#include "complete_test.h"

#include <nitro.h>

#include "constants/savedata/vars_flags.h"

#include "field/field_system.h"
#include "overlay005/save_info_window.h"

#include "complete_follower.h"
#include "complete_safari.h"
#include "field_overworld_state.h"
#include "system_flags.h"
#include "vars_flags.h"

// Sovereign Complete: test-build hooks, called on each free field frame (src/field_system.c).
#ifdef SOVEREIGN_TEST

// tools/complete/test_save.py: Johto and Kanto's flags and vars survive a save. The probe uses the first, a middle and
// the last of the new flags, one past the old end of the flag names (0x0FFF), and one new flag left unset; the first
// and last new vars; and Sinnoh's last var, which must keep its value.
static const u16 sProbeFlags[] = { COMPLETE_FLAGS_START, 0x0FFF, 0x1000, NUM_FLAGS - 1, 5000 };
static const u16 sProbeVars[] = { VAR_COMPLETE_000, VAR_COMPLETE_1FF, VAR_VEILSTONE_CITY_GALACTIC_WAREHOUSE_STATE };
static const u16 sProbeVarValues[] = { 0xC0DE, 0xBEEF };

CompleteTestSaveProbe gCompleteTestSaveProbe;
CompleteTestScriptPos gCompleteTestScriptPos;
CompleteTestSafari gCompleteTestSafari;

static void SaveProbe(FieldSystem *fieldSystem)
{
    CompleteTestSaveProbe *probe = &gCompleteTestSaveProbe;
    VarsFlags *varsFlags = SaveData_GetVarsFlags(fieldSystem->saveData);

    switch (probe->request) {
    case COMPLETE_TEST_SAVE_WRITE:
        for (int i = 0; i < (int)NELEMS(sProbeFlags) - 1; i++) {
            VarsFlags_SetFlag(varsFlags, sProbeFlags[i]);
        }

        for (int i = 0; i < (int)NELEMS(sProbeVarValues); i++) {
            *VarsFlags_GetVarAddress(varsFlags, sProbeVars[i]) = sProbeVarValues[i];
        }
        break;
    case COMPLETE_TEST_SAVE_SAVE:
        probe->saveOK = FieldSystem_Save(fieldSystem);
        break;
    case COMPLETE_TEST_SAVE_READ:
        for (int i = 0; i < (int)NELEMS(sProbeFlags); i++) {
            probe->flags[i] = VarsFlags_CheckFlag(varsFlags, sProbeFlags[i]);
        }

        for (int i = 0; i < (int)NELEMS(sProbeVars); i++) {
            probe->vars[i] = *VarsFlags_GetVarAddress(varsFlags, sProbeVars[i]);
        }
        break;
    default:
        return;
    }

    probe->done = probe->request;
    probe->request = COMPLETE_TEST_SAVE_NONE;
}

static void NoteSafari(FieldSystem *fieldSystem)
{
    SafariZoneSave *safari = SaveData_GetCompleteSafari(fieldSystem->saveData);

    for (int i = 0; i < SAFARI_ZONE_AREAS_PER_SET; i++) {
        gCompleteTestSafari.areas[i] = safari->areas[i].areaNo;
        gCompleteTestSafari.objectCounts[i] = safari->areas[i].objectCount;
    }

    gCompleteTestSafari.save = safari;

    gCompleteTestSafari.active = SystemFlag_CheckSafariGameActive(SaveData_GetVarsFlags(fieldSystem->saveData));
    gCompleteTestSafari.balls = *FieldOverworldState_GetSafariBallCount(SaveData_GetFieldOverworldState(fieldSystem->saveData));
}

void CompleteTest_FieldFrame(FieldSystem *fieldSystem)
{
    CompleteFollower_TestRecordTile(fieldSystem);
    SaveProbe(fieldSystem);
    NoteSafari(fieldSystem);
}

#endif
