#include <nitro.h>

#include "constants/heap.h"

#include "complete_pokeathlon_course.h"
#include "complete_pokeathlon_select.h"
#include "complete_test.h"
#include "heap.h"
#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: the test build's way into HeartGold's overlay 97 (include/complete_pokeathlon_select.h), run on
// its own from the field (src/complete_test.c's hook, gCompleteTestPokeathlonSelect) instead of from the course: it
// makes the heap the course would have made and fills in the course's arguments from the save (one player), and it
// records what the screen did. It lives in the overlay, so it costs the main module nothing.
#ifdef SOVEREIGN_TEST

// The screen's own heap: HeartGold's course heap (0x72000), the most the screen ever had in HeartGold, where the
// course's own parts share it. By a count of its code's allocations the screen keeps about 130 KB (the picker's
// 18 KB, its sprites' tiles, 24 KB, two sprite lists of 66 and 43, eight background maps, windows, the yes/no buttons,
// the Pokémon's picture), and some 30 KB more for a moment while graphics are decompressed. It fits with the field closed: the field map's own heap
// (0xCC000 in the overworld) is given back to the application heap then.
#define SELECT_HEAP_SIZE 0x72000

// Overlay 97's data (its ApplicationManager_Data, HeartGold's 0x34 bytes): what the test reads of it
typedef struct HgssPokeathlonSelectData {
    void *bgConfig;
    u32 step;
    void *picker;
    void *screen;
    u32 picks[3][2]; // each chosen Pokémon's box (18: the party) and slot, the picker's answer
    u32 cancelled;
    SaveData *saveData;
    u32 course;
} HgssPokeathlonSelectData;

static void NoteHeapFree(void)
{
    u32 free = HeapExp_FndGetTotalFreeSize(HGSS_HEAP_ID_POKEATHLON);

    if (free < gCompleteTestPokeathlonSelect.heapFree) {
        gCompleteTestPokeathlonSelect.heapFree = free;
    }
}

BOOL CompletePokeathlonSelect_TestInit(ApplicationManager *appMan, int *state)
{
    CompleteTestPokeathlonSelect *test = &gCompleteTestPokeathlonSelect;
    HgssPokeathlonSelectArgs *args = ApplicationManager_Args(appMan);

    test->appFree = HeapExp_FndGetTotalFreeSize(HEAP_ID_APPLICATION);
    Heap_Create(HEAP_ID_APPLICATION, HGSS_HEAP_ID_POKEATHLON, SELECT_HEAP_SIZE);
    test->heapFree = HeapExp_FndGetTotalFreeSize(HGSS_HEAP_ID_POKEATHLON);
    test->heapLeft = 0;
    MI_CpuFill8(test->picks, 0xFF, sizeof(test->picks));

    MI_CpuClear8(&test->courseArgs, sizeof(test->courseArgs));
    test->courseArgs.saveData = SaveData_Ptr();
    test->courseArgs.mode = 0;
    test->courseArgs.supreme = test->supreme;

    MI_CpuClear8(args, sizeof(HgssPokeathlonSelectArgs));
    args->courseArgs = &test->courseArgs;
    args->cancelled = 0xFFFFFFFF;
    args->course = test->open - 1;

    // the course's copy of the Pokéathlon save, which HeartGold's save accessors hand out (the medals)
    HgssCompat_PokeathlonSave_Open(test->courseArgs.saveData, HGSS_HEAP_ID_POKEATHLON);

    BOOL done = ov97_0221E5C0(appMan, state);

    NoteHeapFree();
    return done;
}

BOOL CompletePokeathlonSelect_TestMain(ApplicationManager *appMan, int *state)
{
    NoteHeapFree();
    return ov97_0221E5D4(appMan, state);
}

BOOL CompletePokeathlonSelect_TestExit(ApplicationManager *appMan, int *state)
{
    HgssPokeathlonSelectData *data = ApplicationManager_Data(appMan);
    CompleteTestPokeathlonSelect *test = &gCompleteTestPokeathlonSelect;

    for (int i = 0; i < 3; i++) {
        test->picks[i][0] = data->picks[i][0];
        test->picks[i][1] = data->picks[i][1];
    }

    if (!ov97_0221E69C(appMan, state)) {
        return FALSE;
    }

    HgssCompat_PokeathlonSave_Close(test->courseArgs.saveData, FALSE);
    test->heapLeft = HeapExp_FndGetTotalFreeSize(HGSS_HEAP_ID_POKEATHLON);
    Heap_Destroy(HGSS_HEAP_ID_POKEATHLON);
    return TRUE;
}

#endif
