#include "complete_test.h"

#include <nitro.h>

#include "constants/savedata/vars_flags.h"
#include "generated/species.h"

#include "field/field_system.h"
#include "overlay005/save_info_window.h"

#include "bag.h"
#include "complete_follower.h"
#include "complete_safari.h"
#include "field_battle_data_transfer.h"
#include "field_task.h"
#include "item.h"
#include "party.h"
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
CompleteTestFieldEncounter gCompleteTestFieldEncounter;

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
// which gives the fanfare's memory back once it ends), a field song as a map's (src/field_bgm.c), any other as a
// script's PlayMusic
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

void CompleteTest_FieldFrame(FieldSystem *fieldSystem)
{
    SetLeadSpecies(fieldSystem);
    HatchEggs(fieldSystem);
    PlaySong();
    CompleteFollower_TestRecordTile(fieldSystem);
    SaveProbe(fieldSystem);
    NoteSafari(fieldSystem);
}

#endif
