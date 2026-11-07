#include "complete_test.h"

#include <nitro.h>

#include "constants/savedata/vars_flags.h"
#include "generated/species.h"

#include "field/field_system.h"
#include "overlay005/save_info_window.h"

#include "bag.h"
#include "complete_follower.h"
#include "complete_map_info.h"
#include "complete_pokeathlon.h"
#include "complete_pokeathlon_course.h"
#include "complete_pokeathlon_select.h"
#include "game_overlay.h"
#include "generated/game_records.h"

#include "game_records.h"
#include "heap.h"
#include "complete_safari.h"
#include "field_battle_data_transfer.h"
#include "field_task.h"
#include "field_transition.h"
#include "item.h"
#include "map_object.h"
#include "party.h"
#include "player_avatar.h"
#include "pokemon.h"
#include "script_manager.h"
#include "sound.h"
#include "sound_playback.h"
#include "sound_system.h"
#include "field_overworld_state.h"
#include "system_flags.h"
#include "unk_020528D0.h"
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
u16 gCompleteTestKeepFlagClear;
u8 gCompleteTestOutbreakMap;
u16 gCompleteTestLeadSpecies;
u8 gCompleteTestHatchEggs;
u16 gCompleteTestLegend[5];
u16 gCompleteTestMagnetTrain[8];
u16 gCompleteTestLegendCinematic[8];
u16 gCompleteTestPlayerGfx;
CompleteTestFieldEncounter gCompleteTestFieldEncounter;
CompleteTestScriptedWild gCompleteTestScriptedWild;
u8 gCompleteTestSovereignLevels;

// An encounter leaves a loss to its caller (a script's BlackOutFromBattle) and doesn't bring the field back, so the field
// overlay, where SovereignTest_BattleTask is, isn't loaded when it returns: this runs from the main module.
BOOL CompleteTest_BlackOutIfLost(FieldTask *task)
{
    int *state = FieldTask_GetState(task);
    int *battleResult = FieldTask_GetEnv(task);

    if (*state == 0) {
        (*state)++;

        if (CheckPlayerWonBattle(*battleResult) == FALSE) {
            FieldTask_StartBlackOutFromBattle(task);
            return FALSE;
        }
    }

    return TRUE;
}
CompleteTestSafari gCompleteTestSafari;
CompleteTestSound gCompleteTestSound;
CompleteTestFollowerTalk gCompleteTestFollowerTalk;
CompleteTestPokeathlonSelect gCompleteTestPokeathlonSelect;
CompleteTestPokeathlonCourse gCompleteTestPokeathlonCourse;
CompleteTestAprijuice gCompleteTestAprijuice;

// The key items and Balls in the bag, one of each (written: the ones that fit)
static void BagProbe(SaveData *saveData, BOOL write, u16 *keyItems, u16 *balls)
{
    Bag *bag = SaveData_GetBag(saveData);

    *keyItems = *balls = 0;

    for (u16 item = 1; item < MAX_ITEMS; item++) {
        s32 pocket = Item_LoadParam(item, ITEM_PARAM_FIELD_POCKET, HEAP_ID_FIELD2);

        if (pocket != POCKET_KEY_ITEMS && pocket != POCKET_BALLS) {
            continue;
        }

        if (write ? Bag_TryAddItem(bag, item, 1, HEAP_ID_FIELD2) : Bag_CanRemoveItem(bag, item, 1, HEAP_ID_FIELD2)) {
            (*(pocket == POCKET_KEY_ITEMS ? keyItems : balls))++;
        }
    }
}

// The Pokéathlon's Athlete Points, with some added (to its working copy: saved only when the game is)
static void PokeathlonProbe(SaveData *saveData, u16 add, u32 *points)
{
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(saveData, HEAP_ID_FIELD2);

    if (add) {
        CompletePokeathlon_AddAthletePoints(pokeathlon, add);
        CompletePokeathlon_Store(saveData, pokeathlon);
    }

    *points = CompletePokeathlon_GetAthletePoints(pokeathlon);
    Heap_Free(pokeathlon);
}

static void StatueProbe(SaveData *saveData, const CompleteTestSaveProbe *probe)
{
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(saveData, HEAP_ID_FIELD2);

    for (int i = 0; i < 3; i++) {
        pokeathlon->friendshipRoomStatues[i].species = probe->statueSpecies[i];
        pokeathlon->friendshipRoomStatues[i].form = probe->statueForm[i];
        pokeathlon->friendshipRoomStatues[i].gender = probe->statueGender[i];
    }

    CompletePokeathlon_Store(saveData, pokeathlon);
    Heap_Free(pokeathlon);
}

// The course records' totals (a course with a total has a record: its button and crowns on the record screen), each
// run by a Pikachu
static void CourseProbe(SaveData *saveData, const CompleteTestSaveProbe *probe)
{
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(saveData, HEAP_ID_FIELD2);

    for (int i = 0; i < COMPLETE_POKEATHLON_COURSES; i++) {
        CompletePokeathlonCourseRecord *record = &pokeathlon->courseRecords[i];

        MI_CpuClear8(record, sizeof(*record));
        record->total = probe->courseTotals[i];

        for (int j = 0; j < 3 && record->total != 0; j++) {
            record->mons[j].species = SPECIES_PIKACHU;
        }
    }

    CompletePokeathlon_Store(saveData, pokeathlon);
    Heap_Free(pokeathlon);
}

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

        BagProbe(fieldSystem->saveData, TRUE, &probe->keyItems, &probe->balls);
        PokeathlonProbe(fieldSystem->saveData, 1234, &probe->athletePoints);
        break;
    case COMPLETE_TEST_SAVE_POKEATHLON_UNSAVED:
        PokeathlonProbe(fieldSystem->saveData, 500, &probe->athletePoints);
        break;
    case COMPLETE_TEST_SAVE_POKEATHLON_STATUES:
        StatueProbe(fieldSystem->saveData, probe);
        break;
    case COMPLETE_TEST_SAVE_POKEATHLON_COURSES:
        CourseProbe(fieldSystem->saveData, probe);
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

        BagProbe(fieldSystem->saveData, FALSE, &probe->keyItems, &probe->balls);
        PokeathlonProbe(fieldSystem->saveData, 0, &probe->athletePoints);
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

BOOL CompleteTest_NoteSoundLoad(BOOL loaded, u16 id)
{
    CompleteTestSoundLoad *entry = &gCompleteTestSound.log[gCompleteTestSound.loads % COMPLETE_TEST_SOUND_LOG];

    gCompleteTestSound.free = NNS_SndHeapGetFreeSize(SoundSystem_Get()->heap);
    gCompleteTestSound.loads++;
    entry->id = id;
    entry->loaded = loaded;
    entry->free = gCompleteTestSound.free;

    if (gCompleteTestSound.free < gCompleteTestSound.minFree) {
        gCompleteTestSound.minFree = gCompleteTestSound.free;
    }

    if (!loaded) {
        gCompleteTestSound.failures++;
        gCompleteTestSound.lastFailedID = id;
    }

    return loaded;
}

static BOOL sFanfarePlaying;

// A song the harness asked for: in a cutscene's sound scene, a fanfare as a script plays one (with its WaitFanfare,
// which gives the fanfare's memory back once it ends), a field song as a map's (src/field_bgm.c), a sound effect as a
// script's PlaySE, any other as a script's PlayMusic
static void PlaySong(void)
{
    u16 seqID = gCompleteTestSound.playSeq;

    if (sFanfarePlaying) {
        sFanfarePlaying = Sound_IsBGMPausedByFanfare();
    }

    if (seqID == 0) {
        return;
    }

    gCompleteTestSound.playSeq = 0;

    if (gCompleteTestSound.playScene == COMPLETE_TEST_SOUND_FANFARE) {
        Sound_PlayFanfare(seqID);
        sFanfarePlaying = TRUE;
        gCompleteTestSound.playScene = SOUND_SCENE_NONE;
    } else if (gCompleteTestSound.playScene != SOUND_SCENE_NONE) {
        Sound_SetSceneAndPlayBGM(gCompleteTestSound.playScene, seqID, 1);
        gCompleteTestSound.playScene = SOUND_SCENE_NONE;
    } else if (Sound_GetPlayerForSequence(seqID) == PLAYER_FIELD) {
        Sound_SetScene(SOUND_SCENE_NONE);
        Sound_SetFieldBGM(seqID);
        Sound_SetSceneAndPlayBGM(SOUND_SCENE_FIELD, seqID, 1);
    } else if (Sound_GetPlayerForSequence(seqID) >= PLAYER_SE_1 && Sound_GetPlayerForSequence(seqID) <= PLAYER_SE_4) {
        Sound_PlayEffect(seqID); // a sound effect as a script plays one (HeartGold's own load as they play)
    } else {
        Sound_PlayBGM(seqID);
    }
}

// tools/complete/test_hgss_gifts.py: the party's lead becomes this species (for the gifts that go by the lead's)
static void SetLeadSpecies(FieldSystem *fieldSystem)
{
    if (gCompleteTestLeadSpecies == SPECIES_NONE) {
        return;
    }

    Pokemon *lead = Party_GetPokemonBySlotIndex(SaveData_GetParty(fieldSystem->saveData), 0);
    u32 species = gCompleteTestLeadSpecies;

    Pokemon_SetValue(lead, MON_DATA_SPECIES, &species);
    Pokemon_CalcLevelAndStats(lead);
    gCompleteTestLeadSpecies = SPECIES_NONE;
}

// tools/complete/test_hgss_togepi.py: the party's Eggs have no egg cycles left, and the hatch starts as a step starts
// it when one is due (Field_UpdateDaycare's script)
static void HatchEggs(FieldSystem *fieldSystem)
{
    if (!gCompleteTestHatchEggs) {
        return;
    }

    Party *party = SaveData_GetParty(fieldSystem->saveData);
    u8 cycles = 0;

    for (int i = 0; i < Party_GetCurrentCount(party); i++) {
        Pokemon *mon = Party_GetPokemonBySlotIndex(party, i);

        if (Pokemon_GetValue(mon, MON_DATA_IS_EGG, NULL)) {
            Pokemon_SetValue(mon, MON_DATA_FRIENDSHIP, &cycles);
        }
    }

    gCompleteTestHatchEggs = FALSE;
    ScriptManager_Set(fieldSystem, SCRIPT_ID(COMMON_SCRIPTS, 31), NULL);
}

// HeartGold's overlay 97 (include/complete_pokeathlon_select.h) from the field, as the NPC trade runs its scene: the
// field faded out and closed, the screen (its heap and arguments made by the overlay's test entry points), the field
// back
static BOOL PokeathlonSelectTask(FieldTask *task)
{
    FS_EXTERN_OVERLAY(complete_pokeathlon_select);
    FS_EXTERN_OVERLAY(complete_hgss_compat);

    static const ApplicationManagerTemplate sTemplate = {
        CompletePokeathlonSelect_TestInit,
        CompletePokeathlonSelect_TestMain,
        CompletePokeathlonSelect_TestExit,
        FS_OVERLAY_ID(complete_pokeathlon_select),
    };
    int *state = FieldTask_GetState(task);

    switch (*state) {
    case 0:
        FieldTransition_FadeOutAndFinishMap(task);
        break;
    case 1:
        // the shims HeartGold's assembly calls are in an overlay of their own, loaded first
        Overlay_LoadByID(FS_OVERLAY_ID(complete_hgss_compat), OVERLAY_LOAD_ASYNC);
        FieldTask_RunApplication(task, &sTemplate, &gCompleteTestPokeathlonSelect.args);
        break;
    case 2:
        Overlay_UnloadByID(FS_OVERLAY_ID(complete_hgss_compat));
        FieldTransition_StartMapAndFadeIn(task);
        break;
    default:
        gCompleteTestPokeathlonSelect.open = 0;
        gCompleteTestPokeathlonSelect.step = 0;
        gCompleteTestPokeathlonSelect.runs++;
        return TRUE;
    }

    gCompleteTestPokeathlonSelect.step = ++(*state);
    return FALSE;
}

// HeartGold's Pokéathlon course (include/complete_pokeathlon_course.h) from the field, as its reception's task runs it
// (HeartGold's sub_02095E30): the field closed, the course with HeartGold's arguments, the field back
static BOOL PokeathlonCourseTask(FieldTask *task)
{
    FS_EXTERN_OVERLAY(complete_pokeathlon_course);
    FS_EXTERN_OVERLAY(complete_hgss_compat);

    static const ApplicationManagerTemplate sTemplate = {
        PokeathlonCourse_Init,
        PokeathlonCourse_Main,
        PokeathlonCourse_Exit,
        FS_OVERLAY_ID(complete_pokeathlon_course),
    };
    CompleteTestPokeathlonCourse *test = &gCompleteTestPokeathlonCourse;
    int *state = FieldTask_GetState(task);

    switch (*state) {
    case 0:
        FieldTransition_FadeOutAndFinishMap(task);
        break;
    case 1:
        MI_CpuClear8(&test->args, sizeof(test->args));
        test->args.saveData = SaveData_Ptr();
        test->args.mode = 0;
        test->args.unk_08[4] = test->open - 1; // 0x0C: the course
        test->args.supreme = test->supreme;
        test->state = test->eventState = test->eventIndex = test->event = 0;
        test->data = NULL;
        test->frames = 0;
        test->appFree = HeapExp_FndGetTotalFreeSize(HEAP_ID_APPLICATION);
        test->heapFree = 0xFFFFFFFF;
        test->heapLeft = 0;
        // the shims HeartGold's assembly calls are in an overlay of their own, loaded first
        Overlay_LoadByID(FS_OVERLAY_ID(complete_hgss_compat), OVERLAY_LOAD_ASYNC);
        FieldTask_RunApplication(task, &sTemplate, &test->args);
        break;
    case 2:
        Overlay_UnloadByID(FS_OVERLAY_ID(complete_hgss_compat));
        FieldTransition_StartMapAndFadeIn(task);
        break;
    default:
        test->open = 0;
        test->step = 0;
        test->runs++;
        return TRUE;
    }

    test->step = ++(*state);
    return FALSE;
}

// HeartGold's Apricorn Box app (include/complete_aprijuice.h) from the field, as the Aprijuice stand's clerk opens it
static BOOL AprijuiceTask(FieldTask *task)
{
    FS_EXTERN_OVERLAY(complete_hgss_compat);

    static const ApplicationManagerTemplate sTemplate = {
        HgssCompat_ApricornBoxApp_Init,
        HgssCompat_ApricornBoxApp_Main,
        HgssCompat_ApricornBoxApp_Exit,
        FS_OVERLAY_ID_NONE,
    };
    CompleteTestAprijuice *test = &gCompleteTestAprijuice;
    int *state = FieldTask_GetState(task);

    switch (*state) {
    case 0:
        FieldTransition_FadeOutAndFinishMap(task);
        break;
    case 1:
        MI_CpuClear8(&test->args, sizeof(test->args));
        test->result = 0xFFFF;
        test->args.mode = test->open - 1;
        test->args.result = &test->result;
        test->args.juice = test->juice;
        test->args.steps = GameRecords_GetRecordValue(SaveData_GetGameRecords(SaveData_Ptr()), RECORD_STEPS);
        test->args.saveData = SaveData_Ptr();
        for (u16 item = ITEM_RED_APRICORN; test->apricorns && item <= ITEM_BLK_APRICORN; item++) {
            Bag_TryAddItem(SaveData_GetBag(SaveData_Ptr()), item, test->apricorns, HEAP_ID_FIELD2);
        }
        test->appFree = HeapExp_FndGetTotalFreeSize(HEAP_ID_APPLICATION);
        Overlay_LoadByID(FS_OVERLAY_ID(complete_hgss_compat), OVERLAY_LOAD_ASYNC);
        FieldTask_RunApplication(task, &sTemplate, &test->args);
        break;
    case 2:
        Overlay_UnloadByID(FS_OVERLAY_ID(complete_hgss_compat));
        FieldTransition_StartMapAndFadeIn(task);
        break;
    default:
        test->open = 0;
        test->step = 0;
        test->runs++;
        return TRUE;
    }

    test->step = ++(*state);
    return FALSE;
}

void CompleteTest_FieldFrame(FieldSystem *fieldSystem)
{
    if (gCompleteTestAprijuice.open && gCompleteTestAprijuice.step == 0 && !FieldSystem_IsRunningTask(fieldSystem)) {
        gCompleteTestAprijuice.step = 1;
        FieldSystem_CreateTask(fieldSystem, AprijuiceTask, NULL);
    }

    if (gCompleteTestPokeathlonSelect.open && gCompleteTestPokeathlonSelect.step == 0 && !FieldSystem_IsRunningTask(fieldSystem)) {
        gCompleteTestPokeathlonSelect.step = 1;
        FieldSystem_CreateTask(fieldSystem, PokeathlonSelectTask, NULL);
    }

    if (gCompleteTestPokeathlonCourse.open && gCompleteTestPokeathlonCourse.step == 0 && !FieldSystem_IsRunningTask(fieldSystem)) {
        gCompleteTestPokeathlonCourse.step = 1;
        FieldSystem_CreateTask(fieldSystem, PokeathlonCourseTask, NULL);
    }

    SetLeadSpecies(fieldSystem);
    HatchEggs(fieldSystem);
    PlaySong();
    CompleteFollower_TestRecordTile(fieldSystem);
    SaveProbe(fieldSystem);
    NoteSafari(fieldSystem);
    gCompleteTestPlayerGfx = MapObject_GetGraphicsID(PlayerAvatar_GetMapObject(fieldSystem->playerAvatar));
}

#endif
