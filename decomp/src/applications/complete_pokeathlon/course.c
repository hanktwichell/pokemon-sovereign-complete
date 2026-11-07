#include <nitro.h>
#include <stddef.h>

#include "constants/heap.h"

#include "complete_pokeathlon.h"
#include "complete_pokeathlon_course.h"
#include "complete_pokeathlon_select.h"
#include "heap.h"
#include "overlay_manager.h"
#include "render_text.h"
#include "save_player.h"
#include "savedata.h"
#include "system.h"
#include "trainer_info.h"

// Sovereign Complete: HeartGold's Pokéathlon course, the C part of its overlay 96: pret's src/pokeathlon/
// pokeathlon_course.c and pokeathlon_data.c (pret's pokeheartgold), with Platinum's names for the engine (the
// assembly beside it, decomp/asm/complete_hgss/overlay_96.s, gets them from hgss_compat.inc) and three changes,
// marked: the course's heap and save copy (HgssCompat_PokeathlonSave_Open, _Close), link play left out (its
// functions are hgss_compat_course.c's stubs), and a test build's note of the course's progress. The struct is pret's
// PokeathlonCourseData (include/pokeathlon/pokeathlon.h), field for field, since the assembly reads it by offset.

#define HGSS_HEAP_SIZE_POKEATHLON 0x72000

typedef struct PokeathlonCourseData PokeathlonCourseData;

typedef BOOL (*PokeathlonStateFunc)(PokeathlonCourseData *, void **);
typedef BOOL (*PokeathlonStateHandlerFunc)(PokeathlonCourseData *, int);

typedef struct PokeathlonStateInfo {
    void *ptr; // the state function table
    u8 field_04;
    u8 stateArgsBase;
    u8 stateIndex;
    u8 field_07;
} PokeathlonStateInfo;

typedef struct PokeathlonParticipantData {
    u8 field_00[0x04];
    u8 field_04;
    u8 field_05[0x77];
} PokeathlonParticipantData;

typedef struct PokeathlonFieldData {
    u8 data[0x60];
} PokeathlonFieldData;

typedef struct PokeathlonCourseState {
    PokeathlonStateInfo *argsPtr;
    u32 transitionType;
    u32 mainState;
    u32 exitFlag;
} PokeathlonCourseState;

typedef struct PokeathlonUnkSubStruct_974 {
    u8 data[0x74];
} PokeathlonUnkSubStruct_974;

enum PokeathlonCourseMainState {
    POKEATHLON_STATE_IDLE = 0,
    POKEATHLON_STATE_START_TRANSITION,
    POKEATHLON_STATE_WAIT_TRANSITION,
    POKEATHLON_STATE_START_EXIT,
    POKEATHLON_STATE_EXIT_SEQUENCE,
};

struct PokeathlonCourseData {
    u32 field_0[4]; // 0x000
    u8 filler_10[0x14C];
    u8 field_15C;
    u8 filler_15D[0x83];
    u32 state; // 0x1E0
    void *heapAllocPtr4; // 0x1E4
    u8 filler_1E8[0x5];
    u8 field_1ED;
    u8 participantCount; // 0x1EE
    u8 field_1EF;
    u32 currentParticipantIndex; // 0x1F0
    u32 field_1F4;
    HgssPokeathlonCourseArgs *args; // 0x1F8
    u8 filler_1FC[0x74];
    void *field_270;
    u8 filler_274[0x8];
    u32 field_27C;
    ApplicationManager *subOverlay; // 0x280
    enum HeapID heapId; // 0x284
    void *system; // 0x288
    u8 dataCopySource[0x28]; // 0x28C
    u8 dataCopyBuffer1[0x28];
    u8 dataCopyBuffer2[0x28];
    u8 filler_304[0xA0];
    u32 field_3A4[4];
    PokeathlonCourseState courseState; // 0x3B4
    PokeathlonStateInfo stateInfo; // 0x3C4
    u8 filler_3CC[0xC];
    u32 field_3D8[4];
    u32 field_3E8;
    PokeathlonParticipantData participants[4]; // 0x3EC
    TrainerInfo *playerProfiles; // 0x5DC
    u16 field_5E0[4][2];
    u16 field_5F0[4][2];
    u8 filler_600[0x14];
    void *graphicsSystem; // 0x614
    u8 filler_618[0x112];
    u8 maxParticipants; // 0x72A
    u8 filler_72B[1];
    PokeathlonFieldData fieldData[6]; // 0x72C
    u8 filler_96C[8];
    PokeathlonUnkSubStruct_974 field_974[4]; // 0x974
    u8 filler_B44[0x60];
    u8 field_BA4[0x180];
    s32 frameCounter; // 0xD24
    u16 frameTimer;
    u16 filler_D2A;
    u32 counterEnabled; // 0xD2C
    u8 filler_D30[0x34];
    void *heapAllocPtr2; // 0xD64
    void *heapAllocPtr3; // 0xD68
    u8 filler_D6C[4];
};

// The assembly reads the struct by offset: pret's layout, checked here
#define COURSE_CHECK(name, cond) typedef char name[(cond) ? 1 : -1]
COURSE_CHECK(CourseDataSize, sizeof(PokeathlonCourseData) == 0xD70);
COURSE_CHECK(CourseDataArgs, offsetof(PokeathlonCourseData, args) == 0x1F8);
COURSE_CHECK(CourseDataState, offsetof(PokeathlonCourseData, courseState) == 0x3B4);
COURSE_CHECK(CourseDataStateInfo, offsetof(PokeathlonCourseData, stateInfo) == 0x3C4);
COURSE_CHECK(CourseDataParticipants, offsetof(PokeathlonCourseData, participants) == 0x3EC);
COURSE_CHECK(CourseDataGraphics, offsetof(PokeathlonCourseData, graphicsSystem) == 0x614);
COURSE_CHECK(CourseDataFieldData, offsetof(PokeathlonCourseData, fieldData) == 0x72C);
COURSE_CHECK(CourseDataFrames, offsetof(PokeathlonCourseData, frameCounter) == 0xD24);
COURSE_CHECK(CourseDataAlloc2, offsetof(PokeathlonCourseData, heapAllocPtr2) == 0xD64);
COURSE_CHECK(CourseArgsSize, sizeof(HgssPokeathlonCourseArgs) == 0x10);

// the assembly's own (decomp/asm/complete_hgss/overlay_96.s)
extern const ApplicationManagerTemplate subOverlayTemplate;
extern const u8 ov96_0221A934[40];
extern const void *sPokeathlonStateInfoFuncTable;

void ov96_021E67AC(PokeathlonCourseData *data);
void ov96_021E75BC(void *data);
void ov96_021E7F98(s32 frameCount, u32 maxValue, CompletePokeathlonTotals *totals);
void *ov96_021E8770(int a0, int a1, PokeathlonCourseData *data, int a3, enum HeapID heapID);
void ov96_021E87B4(int a0, void *a1, void *a2, void *a3);
void ov96_021E8810(void *system);
BOOL ov96_021E8828(void *system);
u8 *ov96_021E8A20(void *ptr);
int ov96_021E8A24(void);
int ov96_021E8A2C(void);
void *ov96_021E92E0(enum HeapID heapID);
void ov96_021E9320(void *graphicsSystem);
void *ov96_021E9A14(void);

// the event functions pokeathlon_data.c's tables name
extern void ov96_0220E22C(void);
extern void ov96_0220E2DC(void);
extern void ov96_0220E394(void);
extern void ov96_022117EC(void);
extern void ov96_02211870(void);
extern void ov96_02215984(void);
extern void ov96_022159F0(void);
extern void ov96_02215A70(void);

// HeartGold's save and link-play functions, as the assembly gets them (hgss_compat_save.c, hgss_compat_course.c)
CompletePokeathlonSave *HgssCompat_Save_Pokeathlon_Get(SaveData *saveData);
CompletePokeathlonTotals *HgssCompat_PokeathlonSave_GetTotals(CompletePokeathlonSave *pokeathlon);
int HgssCompat_LinkPlayerCount(void);
TrainerInfo *HgssCompat_LinkPlayerProfile(int netID);
void HgssCompat_LinkSyncStart(u8 type);
BOOL HgssCompat_LinkSyncDone(u8 type);

BOOL PokeathlonCourse_RunStateFunc(PokeathlonCourseData *data);
BOOL PokeathlonCourse_RunSubStateLoop(PokeathlonCourseData *data);
void PokeathlonCourse_InitStateInfo(const void *funcTable, PokeathlonStateInfo *stateInfo);
void PokeathlonCourse_InitPlayerProfiles(PokeathlonCourseData *data);
TrainerInfo *PokeathlonCourse_GetPlayerProfile(TrainerInfo *profiles, int index);
void PokeathlonCourse_SetField1ED(PokeathlonCourseData *data, int param);
void PokeathlonCourse_SetField1F4(PokeathlonCourseData *data, int param);
u32 ov96_021E5E7C(PokeathlonCourseData *data);
u32 PokeathlonCourse_GetMode(PokeathlonCourseData *data);
BOOL ov96_021E5F24(PokeathlonCourseData *data);

// pret's pokeathlon_data.c
u8 ov96_0221DC80[] = { 0x00, 0x04, 0x02, 0x01, 0x00, 0x01, 0x00, 0x01 };

void *ov96_0221DC88[] = {
    ov96_022117EC,
    ov96_02211870
};

void *ov96_0221DC90[] = {
    ov96_02215984,
    ov96_022159F0,
    ov96_02215A70,
    NULL
};

u8 ov96_0221E5A0[4];
u8 ov96_0221E5A4[0x1c];

BOOL PokeathlonCourse_Init(ApplicationManager *appMan, int *state)
{
    PokeathlonCourseData *data;
    ApplicationManagerTemplate subTemplate;
    BOOL linkMode;

    (void)state;
    Heap_Create(HEAP_ID_APPLICATION, HGSS_HEAP_ID_POKEATHLON, HGSS_HEAP_SIZE_POKEATHLON);

    data = ApplicationManager_NewData(appMan, sizeof(PokeathlonCourseData), HGSS_HEAP_ID_POKEATHLON);
    MI_CpuFill8(data, 0, sizeof(PokeathlonCourseData));

    data->heapId = HGSS_HEAP_ID_POKEATHLON;
    data->args = ApplicationManager_Args(appMan);

    // Sovereign Complete: the course's copy of the Pokéathlon save, which HeartGold's save accessors hand out
    HgssCompat_PokeathlonSave_Open(data->args->saveData, HGSS_HEAP_ID_POKEATHLON);

    subTemplate = subOverlayTemplate;
    data->subOverlay = ApplicationManager_New(&subTemplate, &data->args, HGSS_HEAP_ID_POKEATHLON);

    linkMode = FALSE;
    data->state = linkMode;

    if (data->args->mode == 1) {
        linkMode = TRUE;
        data->participantCount = HgssCompat_LinkPlayerCount();
        data->maxParticipants = 4;
    } else {
        data->participantCount = 1;
        data->maxParticipants = 3;
    }

    data->system = ov96_021E8770(ov96_021E8A24(), ov96_021E8A2C(), data, linkMode, data->heapId);

    PokeathlonCourse_InitStateInfo(&sPokeathlonStateInfoFuncTable, &data->stateInfo);

    data->stateInfo.stateIndex = 0;
    data->courseState.argsPtr = &data->stateInfo;
    data->courseState.exitFlag = 0;

    PokeathlonCourse_InitPlayerProfiles(data);

    data->graphicsSystem = ov96_021E92E0(HGSS_HEAP_ID_POKEATHLON);

    if (data->args->mode != 1) {
        RenderControlFlags_SetCanABSpeedUpPrint(TRUE);
        RenderControlFlags_SetAutoScrollFlags(0);
        RenderControlFlags_SetSpeedUpOnTouch(TRUE);
    } else {
        RenderControlFlags_SetCanABSpeedUpPrint(FALSE);
        RenderControlFlags_SetAutoScrollFlags(1);
        RenderControlFlags_SetSpeedUpOnTouch(FALSE);
    }

    PokeathlonCourse_SetField1F4(data, 0);
    PokeathlonCourse_SetField1ED(data, 0);

    return TRUE;
}

BOOL PokeathlonCourse_Main(ApplicationManager *appMan, int *state)
{
    PokeathlonCourseData *data = ApplicationManager_Data(appMan);
    PokeathlonCourseState *courseState = &data->courseState;

    (void)state;

#ifdef SOVEREIGN_TEST
    CompletePokeathlonCourse_TestNote(data);
#endif

    // the time spent in the Dome: a minute counted every 1800 frames, up to 59999
    if (data->counterEnabled != FALSE) {
        data->frameTimer++;

        if (data->frameTimer >= 1800) {
            if (data->frameCounter < 59999) {
                data->frameCounter++;
            }

            data->frameTimer = 0;
        }
    }

    switch (courseState->mainState) {
    case POKEATHLON_STATE_IDLE:
        if (PokeathlonCourse_RunStateFunc(data)) {
            return TRUE;
        }

        if (courseState->exitFlag != 0) {
            PokeathlonStateInfo *info = courseState->argsPtr;

            info->stateIndex = info->field_07;
            info->stateArgsBase = 0;
            courseState->exitFlag = 0;
        }

        if (courseState->transitionType != 0) {
            if (courseState->transitionType == 0x10) {
                courseState->mainState = POKEATHLON_STATE_START_EXIT;
            } else {
                courseState->mainState = POKEATHLON_STATE_START_TRANSITION;
            }
        }
        break;

    case POKEATHLON_STATE_START_TRANSITION:
        HgssCompat_LinkSyncStart(courseState->transitionType);
        courseState->mainState = POKEATHLON_STATE_WAIT_TRANSITION;
        // fall through

    case POKEATHLON_STATE_WAIT_TRANSITION:
        if (HgssCompat_LinkSyncDone(courseState->transitionType)) {
            courseState->mainState = POKEATHLON_STATE_IDLE;
            courseState->transitionType = 0;
        }
        break;

    case POKEATHLON_STATE_START_EXIT:
        GF_ASSERT(courseState->transitionType == 0x10);
        HgssCompat_LinkSyncStart(courseState->transitionType);
        courseState->mainState = POKEATHLON_STATE_EXIT_SEQUENCE;
        // fall through

    case POKEATHLON_STATE_EXIT_SEQUENCE:
        if (!HgssCompat_LinkSyncDone(courseState->transitionType)) {
            if (ov96_021E5F24(data)) {
                break;
            }

            ov96_021E87B4(0x1B, data->dataCopyBuffer1, ov96_021E9A14(), data->system);

            u8 *dest = ov96_021E8A20(data->dataCopyBuffer2);
            u8 *src = ov96_021E8A20(data->dataCopySource);

            for (u32 i = 0; i < 0x28; i++) {
                dest[i] = src[i];
            }
        } else {
            courseState->mainState = POKEATHLON_STATE_IDLE;
            courseState->transitionType = 0;
        }
        break;
    }

    ov96_021E67AC(data);
    return FALSE;
}

BOOL PokeathlonCourse_Exit(ApplicationManager *appMan, int *state)
{
    PokeathlonCourseData *data = ApplicationManager_Data(appMan);
    SaveData *saveData = data->args->saveData;

    (void)state;
    GF_ASSERT(GF_heap_c_dummy_return_true(HGSS_HEAP_ID_POKEATHLON));

    if (data->args->unk_08[6] == FALSE) { // pret's shouldFreeHeap (0x0E)
        Heap_Free(data->heapAllocPtr2);
        Heap_Free(data->heapAllocPtr3);
    }

    ov96_021E7F98(data->frameCounter, 59999, HgssCompat_PokeathlonSave_GetTotals(HgssCompat_Save_Pokeathlon_Get(saveData)));

    RenderControlFlags_SetCanABSpeedUpPrint(FALSE);
    RenderControlFlags_SetAutoScrollFlags(0);
    RenderControlFlags_SetSpeedUpOnTouch(FALSE);

    ov96_021E9320(data->graphicsSystem);
    Heap_Free(data->playerProfiles);
    ov96_021E8810(data->system);

#ifdef SOVEREIGN_TEST
    CompletePokeathlonCourse_TestNote(NULL);
#endif

    // Sovereign Complete: what the course changed in its copy of the save goes to the save's working copy (saved
    // with the game, as HeartGold's is)
    HgssCompat_PokeathlonSave_Close(saveData, TRUE);

    ApplicationManager_FreeData(appMan);
#ifdef SOVEREIGN_TEST
    CompletePokeathlonCourse_TestExit();
#endif
    Heap_Destroy(HGSS_HEAP_ID_POKEATHLON);

    return TRUE;
}

BOOL PokeathlonCourse_RunStateFunc(PokeathlonCourseData *data)
{
    void **stateDataPtr = (void **)&data->stateInfo.stateArgsBase;
    PokeathlonStateFunc *functionTable = (PokeathlonStateFunc *)data->stateInfo.ptr;

    return functionTable[data->stateInfo.stateIndex](data, stateDataPtr) != FALSE;
}

BOOL PokeathlonCourse_RunSubStateLoop(PokeathlonCourseData *data)
{
    BOOL result;

    do {
        PokeathlonStateHandlerFunc *statePtr = (PokeathlonStateHandlerFunc *)data->state;

        result = statePtr[0](data, 0);

        if (result == 1) {
            return TRUE;
        }

        if (result == 0) {
            break;
        }
    } while (data->args->mode == 0);

    return FALSE;
}

void PokeathlonCourse_InitStateInfo(const void *funcTable, PokeathlonStateInfo *stateInfo)
{
    stateInfo->ptr = (void *)funcTable;
    stateInfo->field_04 = 1;
    stateInfo->stateArgsBase = 0;
    stateInfo->stateIndex = 0;
    stateInfo->field_07 = 0;
}

void PokeathlonCourse_InitPlayerProfiles(PokeathlonCourseData *data)
{
    data->playerProfiles = Heap_Alloc(data->heapId, TrainerInfo_Size() * 4);

    for (int i = 0; i < 4; i++) {
        TrainerInfo_Init(PokeathlonCourse_GetPlayerProfile(data->playerProfiles, i));
    }

    if (data->args->mode == 0) {
        TrainerInfo_Copy(SaveData_GetTrainerInfo(data->args->saveData), PokeathlonCourse_GetPlayerProfile(data->playerProfiles, 0));
    } else {
        for (int i = 0; i < data->participantCount; i++) {
            TrainerInfo_Copy(HgssCompat_LinkPlayerProfile(i), PokeathlonCourse_GetPlayerProfile(data->playerProfiles, i));
        }
    }
}

TrainerInfo *PokeathlonCourse_GetPlayerProfile(TrainerInfo *profiles, int index)
{
    return (TrainerInfo *)&((u8 *)profiles)[TrainerInfo_Size() * index];
}

u8 PokeathlonCourse_GetParticipantCount(PokeathlonCourseData *data)
{
    return data->participantCount;
}

PokeathlonParticipantData *PokeathlonCourse_GetParticipantData(PokeathlonCourseData *data, int index)
{
    return &data->participants[index];
}

u8 *PokeathlonCourse_GetParticipantUnk04(PokeathlonCourseData *data, int index)
{
    return &data->participants[index].field_04;
}

SaveData *PokeathlonCourse_GetSaveData(PokeathlonCourseData *data)
{
    return data->args->saveData;
}

PokeathlonFieldData *PokeathlonCourse_GetFieldData(PokeathlonCourseData *data)
{
    return data->fieldData;
}

PokeathlonFieldData *PokeathlonCourse_GetFieldData_AtIndex(PokeathlonCourseData *data, int index)
{
    return &data->fieldData[index];
}

void *PokeathlonCourse_GetFieldBA4(PokeathlonCourseData *data)
{
    return data->field_BA4;
}

void *PokeathlonCourse_AllocPtr4FromHeap(PokeathlonCourseData *data, u32 size)
{
    data->heapAllocPtr4 = Heap_Alloc(data->heapId, size);
    return data->heapAllocPtr4;
}

void PokeathlonCourse_FreePtr4HeapAlloc(PokeathlonCourseData *data)
{
    Heap_Free(data->heapAllocPtr4);
    data->heapAllocPtr4 = NULL;
}

void *PokeathlonCourse_GetHeapAllocPtr4(PokeathlonCourseData *data)
{
    return data->heapAllocPtr4;
}

enum HeapID PokeathlonCourse_GetHeapID(PokeathlonCourseData *data)
{
    return data->heapId;
}

u8 PokeathlonCourse_GetField1ED(PokeathlonCourseData *data)
{
    return data->field_1ED;
}

void PokeathlonCourse_SetField1ED(PokeathlonCourseData *data, int param)
{
    data->field_1ED = param;
}

void PokeathlonCourse_IncrementField1ED(PokeathlonCourseData *data)
{
    data->field_1ED++;
}

void PokeathlonCourse_SetField1F4(PokeathlonCourseData *data, int param)
{
    data->field_1F4 = param;
}

void ov96_021E5E04(PokeathlonCourseData *data, u8 *param)
{
    for (int i = 0; i < data->maxParticipants; i++) {
        data->field_3D8[i] = param[i];
    }

    data->field_3E8 = ov96_021E5E7C(data);
    data->field_27C = data->field_3E8;
}

u32 PokeathlonCourse_GetField3D8_ForCurrentParticipant(PokeathlonCourseData *data)
{
    return data->field_3D8[data->currentParticipantIndex];
}

u32 PokeathlonCourse_GetField3D8_AtIndex(PokeathlonCourseData *data, u8 index)
{
    if (index >= data->maxParticipants) {
        GF_ASSERT(FALSE);
        return 0;
    }

    return data->field_3D8[index];
}

u32 ov96_021E5E7C(PokeathlonCourseData *data)
{
    u8 numParticipants = PokeathlonCourse_GetMode(data) == 1 ? 4 : 3;
    u32 *fieldPtr = data->field_3D8;

    for (u8 i = 0; i < 10; i++) {
        BOOL match = TRUE;

        for (u8 j = 0; j < numParticipants; j++) {
            if (fieldPtr[j] != ov96_0221A934[i * 4 + j]) {
                match = FALSE;
                break;
            }
        }

        if (match) {
            return i;
        }
    }

    return 10;
}

u32 PokeathlonCourse_GetCurrentParticipantIndex(PokeathlonCourseData *data)
{
    return data->currentParticipantIndex;
}

u32 PokeathlonCourse_GetMode(PokeathlonCourseData *data)
{
    return data->args->mode;
}

u8 PokeathlonCourse_GetField1EF(PokeathlonCourseData *data)
{
    return data->field_1EF;
}

void PokeathlonCourse_IncrementField1EF(PokeathlonCourseData *data)
{
    data->field_1EF++;
}

void PokeathlonCourse_ResetField1EF(PokeathlonCourseData *data)
{
    data->field_1EF = 0;
}

void *PokeathlonCourse_GetSystem(PokeathlonCourseData *data)
{
    return data->system;
}

BOOL ov96_021E5F24(PokeathlonCourseData *data)
{
    return ov96_021E8828(data->system);
}

TrainerInfo *PokeathlonCourse_GetPlayerProfileFromData(PokeathlonCourseData *data, int index)
{
    return PokeathlonCourse_GetPlayerProfile(data->playerProfiles, index);
}

PokeathlonUnkSubStruct_974 *PokeathlonCourse_GetField974_AtIndex(PokeathlonCourseData *data, int index)
{
    return &data->field_974[index];
}

u8 *PokeathlonCourse_GetDataCopyArea(PokeathlonCourseData *data)
{
    return data->dataCopySource;
}

void PokeathlonCourse_ResetDataCopyArea(PokeathlonCourseData *data)
{
    MI_CpuFill8(data->dataCopySource, 0, 296); // dataCopySource to field_3A4
}

void PokeathlonCourse_SetField3A4(PokeathlonCourseData *data, u32 a0, u32 a1, u32 a2)
{
    data->field_3A4[0] = a0;
    data->field_3A4[1] = a1;
    data->field_3A4[2] = a2;
    data->field_3A4[3] = 1;
}

void PokeathlonCourse_ResetField3A4(PokeathlonCourseData *data)
{
    data->field_3A4[0] = 0;
    data->field_3A4[1] = 0;
    data->field_3A4[2] = 0;
    data->field_3A4[3] = 0;
}

u32 PokeathlonCourse_GetField3A4(PokeathlonCourseData *data)
{
    return data->field_3A4[1];
}

u32 PokeathlonCourse_GetUnkConstant4(void)
{
    return 4;
}

void PokeathlonCourse_SetField5E0_AtIndex(PokeathlonCourseData *data, int index, u16 value)
{
    data->field_5E0[index][0] = value;
}

u16 PokeathlonCourse_GetField5F0_AtIndex(PokeathlonCourseData *data, int index)
{
    return data->field_5F0[index][0];
}

void PokeathlonCourse_SetStateField07(PokeathlonCourseData *data, u8 value)
{
    GF_ASSERT(data->courseState.exitFlag != 1);
    data->courseState.exitFlag = 1;
    data->courseState.argsPtr->field_07 = value;
}

void PokeathlonCourse_SetStateField07_IfDifferent(PokeathlonCourseData *data, u8 value, u8 value2)
{
    if (data->courseState.argsPtr->field_07 != value2) {
        GF_ASSERT(data->courseState.exitFlag != 1);
        data->courseState.exitFlag = 1;
        data->courseState.argsPtr->field_07 = value;
    }
}

void PokeathlonCourse_SetStateTransitionType(PokeathlonCourseData *data, u32 transitionType)
{
    if (data->args->mode == 1) {
        data->courseState.transitionType = transitionType;
    }
}

void PokeathlonCourse_SetVBlankIntrCB(PokeathlonCourseData *data)
{
    SetVBlankCallback(ov96_021E75BC, data);
}

void *PokeathlonCourse_GetGraphicsSystem(PokeathlonCourseData *data)
{
    return data->graphicsSystem;
}

#ifdef SOVEREIGN_TEST
// What the test build's marker reads of the course's data (CompletePokeathlonCourse_TestNote, course_test.c)
u8 CompletePokeathlonCourse_TestStateIndex(void *courseData)
{
    return ((PokeathlonCourseData *)courseData)->stateInfo.stateIndex;
}

u32 CompletePokeathlonCourse_TestEventIndex(void *courseData)
{
    return ((PokeathlonCourseData *)courseData)->currentParticipantIndex;
}

u32 CompletePokeathlonCourse_TestEvent(void *courseData)
{
    PokeathlonCourseData *data = courseData;
    return data->field_3D8[data->currentParticipantIndex < 4 ? data->currentParticipantIndex : 0];
}
#endif
