#include "complete_unown_report.h"

#include <nitro.h>

#include "field/field_system.h"

#include "field_system.h"
#include "overlay_manager.h"

// Sovereign Complete: HeartGold's UnownReport_LaunchApp (include/complete_unown_report.h), in the main module, as the
// screen's overlay is unloaded while it isn't open

FS_EXTERN_OVERLAY(complete_unown_report);

#ifdef SOVEREIGN_TEST
u8 gCompleteTestUnownReportPage;
#endif

static CompleteUnownReportArgs sArgs; // one at a time, from the bag or the registered item
static int sMenuInputState; // the touch screen or the buttons, kept between openings (HeartGold's field system's)

static const ApplicationManagerTemplate sTemplate = {
    CompleteUnownReport_Init,
    CompleteUnownReport_Main,
    CompleteUnownReport_Exit,
    FS_OVERLAY_ID(complete_unown_report),
};

void CompleteUnownReport_Launch(FieldSystem *fieldSystem)
{
    sArgs.menuInputState = &sMenuInputState;
    sArgs.saveData = fieldSystem->saveData;
    FieldSystem_StartChildProcess(fieldSystem, &sTemplate, &sArgs);
}

// The registered item's: nothing for its task to free
void *CompleteUnownReport_LaunchRegistered(void *fieldSystem)
{
    CompleteUnownReport_Launch(fieldSystem);
    return NULL;
}
