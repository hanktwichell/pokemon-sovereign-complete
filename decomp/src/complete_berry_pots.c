#include "complete_berry_pots.h"

#include <nitro.h>

#include "constants/heap.h"

#include "applications/bag/application.h"
#include "field/field_system.h"

#include "bag.h"
#include "bag_context.h"
#include "complete_phone.h"
#include "field_system.h"
#include "heap.h"
#include "overlay_manager.h"
#include "savedata_misc.h"
#include "system.h"

// Sovereign Complete: HeartGold's Berry Pots (include/complete_berry_pots.h): where they're kept, and HeartGold's
// manager (its overlay 16, ov16_02201948.c), which runs the pots' screen and, when it asks, the bag to choose a Berry
// or Mulch, then the screen again with what was chosen. Here in the main module, as the screen's overlay and the bag's
// can't both be loaded.

FS_EXTERN_OVERLAY(bag);
FS_EXTERN_OVERLAY(complete_berry_pots);

enum ManagerState {
    MANAGER_START_SCREEN = 0,
    MANAGER_RUN_SCREEN,
    MANAGER_START_BAG,
    MANAGER_RUN_BAG,
    MANAGER_DONE,
};

typedef struct BerryPotsManager {
    CompleteBerryPotsArgs args;
    BagCursor *berriesCursor; // the bag's cursors while the pots are open, a pocket's each (HeartGold's)
    BagCursor *itemsCursor;
} BerryPotsManager;

static BerryPotsManager sManager; // one at a time, from the bag or the registered item

#ifdef SOVEREIGN_TEST
u8 gCompleteTestBerryPotsStep; // test build: the manager's state * 16 (tools/complete/test_berry_pots.py)
#endif
static int sMenuInputState; // the touch screen or the buttons, kept between openings (HeartGold's field system's)

static const ApplicationManagerTemplate sManagerTemplate = {
    CompleteBerryPots_ManagerInit,
    CompleteBerryPots_ManagerMain,
    CompleteBerryPots_ManagerExit,
    FS_OVERLAY_ID_NONE,
};

static const ApplicationManagerTemplate sScreenTemplate = {
    CompleteBerryPotsApp_Init,
    CompleteBerryPotsApp_Main,
    CompleteBerryPotsApp_Exit,
    FS_OVERLAY_ID(complete_berry_pots),
};

static const ApplicationManagerTemplate sBagTemplate = {
    BagApplication_Init,
    BagApplication_Main,
    BagApplication_Exit,
    FS_OVERLAY_ID(bag),
};

BerryPatch *CompleteBerryPots_Get(SaveData *saveData)
{
    return MiscSaveBlock_GetBerryPatches(saveData) + COMPLETE_BERRY_POTS_FIRST_PATCH;
}

u8 *CompleteBerryPots_Time(SaveData *saveData)
{
    return SaveData_GetCompletePhone(saveData)->berryPotsTime;
}

// The pots' patches hold what Platinum's new game left there: its init (BerryPatches_Init) fills all 128 patches from
// a table of Sinnoh's 118, so the last ten get what follows the table (Berries numbered past 64, hundreds of them). The
// pots are emptied the first time they open, when their time is still unset; a save from before them is the same.
static void EmptyNewPots(SaveData *saveData)
{
    u8 *time = CompleteBerryPots_Time(saveData);

    for (int i = 0; i < sizeof(RTCDate) + sizeof(RTCTime); i++) {
        if (time[i] != 0) {
            return;
        }
    }

    MI_CpuClear8(CompleteBerryPots_Get(saveData), sizeof(BerryPatch) * COMPLETE_BERRY_POT_COUNT); // no Berry, NONE
}

// HeartGold's BerryPots_LaunchApp: the pots as the field's application (from the bag, which reopens after)
void CompleteBerryPots_Launch(FieldSystem *fieldSystem)
{
    EmptyNewPots(fieldSystem->saveData);
    MI_CpuClear8(&sManager, sizeof(BerryPotsManager));
    sManager.args.saveData = fieldSystem->saveData;
    sManager.args.menuInputState = &sMenuInputState;
    FieldSystem_StartChildProcess(fieldSystem, &sManagerTemplate, &sManager);
}

// The registered item's: nothing for its task to free
void *CompleteBerryPots_LaunchRegistered(void *fieldSystem)
{
    CompleteBerryPots_Launch(fieldSystem);
    return NULL;
}

static BOOL RunSubApplication(ApplicationManager **app)
{
    if (*app != NULL && ApplicationManager_Exec(*app)) {
        ApplicationManager_Free(*app);
        *app = NULL;
        return TRUE;
    }

    return FALSE;
}

BOOL CompleteBerryPots_ManagerInit(ApplicationManager *appMan, int *state)
{
    BerryPotsManager *manager = ApplicationManager_Args(appMan);

    manager->berriesCursor = BagCursor_New(HEAP_ID_FIELD2);
    manager->itemsCursor = BagCursor_New(HEAP_ID_FIELD2);
    return TRUE;
}

BOOL CompleteBerryPots_ManagerMain(ApplicationManager *appMan, int *state)
{
    static const u8 sBerries[] = { POCKET_BERRIES, POCKET_LIST_END };
    static const u8 sItems[] = { POCKET_ITEMS, POCKET_LIST_END };
    BerryPotsManager *manager = ApplicationManager_Args(appMan);
    CompleteBerryPotsArgs *args = &manager->args;

#ifdef SOVEREIGN_TEST
    gCompleteTestBerryPotsStep = *state * 16;
#endif

    switch (*state) {
    case MANAGER_START_SCREEN:
        args->app = ApplicationManager_New(&sScreenTemplate, args, HEAP_ID_FIELD2);
        *state = MANAGER_RUN_SCREEN;
        break;
    case MANAGER_RUN_SCREEN:
        if (RunSubApplication(&args->app)) {
            *state = args->request == COMPLETE_BERRY_POTS_REQUEST_NONE ? MANAGER_DONE : MANAGER_START_BAG;
        }
        break;
    case MANAGER_START_BAG: { // Platinum's bag for soft soil: Mulch from the Items pocket, or a Berry
        BOOL mulch = args->request == COMPLETE_BERRY_POTS_REQUEST_MULCH;

        args->bagContext = BagContext_CreateWithPockets(SaveData_GetBag(args->saveData), mulch ? sItems : sBerries, HEAP_ID_FIELD2);
        BagContext_Init(args->bagContext, args->saveData, BAG_MODE_GARDENING, mulch ? manager->itemsCursor : manager->berriesCursor);
        args->app = ApplicationManager_New(&sBagTemplate, args->bagContext, HEAP_ID_FIELD2);
        *state = MANAGER_RUN_BAG;
        break;
    }
    case MANAGER_RUN_BAG:
        if (RunSubApplication(&args->app)) {
            args->itemId = BagContext_GetExitCode(args->bagContext) == BAG_EXIT_CODE_USE_ITEM ? BagContext_GetItem(args->bagContext) : 0xFFFF;
            Heap_Free(args->bagContext);
            args->bagContext = NULL;
            *state = MANAGER_START_SCREEN;
        }
        break;
    case MANAGER_DONE:
        return TRUE;
    }

    return FALSE;
}

BOOL CompleteBerryPots_ManagerExit(ApplicationManager *appMan, int *state)
{
    BerryPotsManager *manager = ApplicationManager_Args(appMan);

    Heap_Free(manager->itemsCursor);
    Heap_Free(manager->berriesCursor);
    SetVBlankCallback(NULL, NULL); // HeartGold's manager's ov17_02201BC0: nothing of the screen's or the bag's runs on
    return TRUE;
}
