#include "complete_aprijuice.h"

#include <nitro.h>

#include "generated/game_records.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"

#include "field_system.h"
#include "game_records.h"
#include "overlay_manager.h"
#include "vars_flags.h"

// Sovereign Complete: HeartGold's ApricornBox_LaunchApp from the bag (include/complete_aprijuice.h), in the main
// module, as the box's overlays are unloaded while it isn't open: the Apriblender's mode once the stand has given it
// (HeartGold's flag 997), only the box before

FS_EXTERN_OVERLAY(complete_hgss_compat);

static HgssApricornBoxArgs sArgs; // one at a time, from the bag or the registered item

static const ApplicationManagerTemplate sTemplate = {
    HgssCompat_ApricornBoxApp_Init,
    HgssCompat_ApricornBoxApp_Main,
    HgssCompat_ApricornBoxApp_Exit,
    FS_OVERLAY_ID(complete_hgss_compat),
};

void CompleteApricornBox_Launch(FieldSystem *fieldSystem)
{
    MI_CpuClear8(&sArgs, sizeof(sArgs));
    sArgs.mode = VarsFlags_CheckFlag(SaveData_GetVarsFlags(fieldSystem->saveData), FLAG_HGSS_UNK_997) ? HGSS_APRICORN_BOX_MODE_BAG : HGSS_APRICORN_BOX_MODE_VIEW;
    sArgs.steps = GameRecords_GetRecordValue(SaveData_GetGameRecords(fieldSystem->saveData), RECORD_STEPS);
    sArgs.saveData = fieldSystem->saveData;
    FieldSystem_StartChildProcess(fieldSystem, &sTemplate, &sArgs);
}

// The registered item's: nothing for its task to free
void *CompleteApricornBox_LaunchRegistered(void *fieldSystem)
{
    CompleteApricornBox_Launch(fieldSystem);
    return NULL;
}
