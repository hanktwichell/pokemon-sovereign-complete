#include "complete_scrcmd.h"

#include <nitro.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "generated/genders.h"
#include "generated/text_banks.h"

#include "field/field_system.h"
#include "overlay005/field_menu.h"
#include "overlay005/script_message.h"

#include "complete_follower.h"
#include "encounter.h"
#include "field_message.h"
#include "field_script_context.h"
#include "field_system.h"
#include "inlines.h"
#include "map_object.h"
#include "message.h"
#include "save_player.h"
#include "script_manager.h"
#include "trainer_info.h"
#include "unk_020655F4.h"
#include "vars_flags.h"

// Sovereign Complete: script commands HeartGold's scripts need that Platinum lacks (tools/complete/hgss_script_table.py,
// docs/ScriptConversion.md). Registered after Sovereign's own in include/data/scripts/scrcmd.h.

static BOOL WaitForFinishedPrinting(ScriptContext *ctx)
{
    u8 *printerID = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_MESSAGE_ID);
    return FieldMessage_FinishedPrinting(*printerID);
}

static MapObject *Follower(ScriptContext *ctx)
{
    return MapObjMan_LocalMapObjByIndex(ctx->fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);
}

// HeartGold's GenderMsgBox: the first message for a boy, the second for a girl.
BOOL CompleteScrCmd_MessageGendered(ScriptContext *ctx)
{
    u8 messageMale = ScriptContext_ReadByte(ctx);
    u8 messageFemale = ScriptContext_ReadByte(ctx);
    TrainerInfo *trainerInfo = SaveData_GetTrainerInfo(FieldSystem_GetSaveData(ctx->fieldSystem));

    ScriptMessage_Show(ctx, ctx->loader, TrainerInfo_Gender(trainerInfo) == GENDER_MALE ? messageMale : messageFemale,
        TRUE, NULL);
    ScriptContext_Pause(ctx, WaitForFinishedPrinting);

    return TRUE;
}

// HeartGold's ToggleFollowingPokemonMovement: pause (non-zero) or resume the follower's movement. A scene resumes it
// (0) to move it while the others are locked, then pauses it again (1) before ReleaseAll.
BOOL CompleteScrCmd_FollowerPause(ScriptContext *ctx)
{
    u16 pause = ScriptContext_ReadHalfWord(ctx);
    MapObject *follower = Follower(ctx);

    if (follower != NULL) {
        if (pause) {
            MapObject_SetPauseMovementOn(follower);
        } else {
            MapObject_SetPauseMovementOff(follower);
        }
    }

    return FALSE;
}

static BOOL FollowerStepFinished(ScriptContext *ctx)
{
    MapObject *follower = Follower(ctx);
    return follower == NULL || LocalMapObj_CheckAnimationFinished(follower);
}

// HeartGold's WaitFollowingPokemonMovement: wait until the follower has finished its step (HeartGold's
// MapObject_IsMovementPaused is Platinum's LocalMapObj_CheckAnimationFinished, not a check of the pause flag).
BOOL CompleteScrCmd_FollowerWait(ScriptContext *ctx)
{
    if (Follower(ctx) != NULL) {
        ScriptContext_Pause(ctx, FollowerStepFinished);
    }

    return TRUE;
}

// HeartGold's FollowingPokemonMovement: give the follower a movement type (MOVEMENT_TYPE_FOLLOW_PLAYER to follow
// again, MOVEMENT_TYPE_NONE to stand by during a scene).
BOOL CompleteScrCmd_FollowerSetMovementType(ScriptContext *ctx)
{
    u16 movementType = ScriptContext_ReadHalfWord(ctx);
    MapObject *follower = Follower(ctx);

    if (follower != NULL) {
        MapObject_SwitchMovementType(follower, movementType); // as HeartGold's sub_0205FC94: ends the old one first
    }

    return TRUE;
}

// HeartGold's ScrCmd_729: whether a Pokémon is following.
BOOL CompleteScrCmd_FollowerCheckActive(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = Follower(ctx) != NULL;
    return FALSE;
}

// HeartGold's GetStaticEncounterOutcome: the last battle's result. Platinum keeps it as BATTLE_RESULT_*, whose values
// are HeartGold's BATTLE_OUTCOME_* (win 1, lose 2, draw 3, caught 4, fled 5, foe fled 6).
BOOL CompleteScrCmd_GetBattleResult(ScriptContext *ctx)
{
    int *battleResult = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_BATTLE_RESULT);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = *battleResult;
    return FALSE;
}

BOOL gCompleteNextWildShiny;

// HeartGold's WildBattle: a static encounter, shiny when its last argument is set (Sacred Gold's red Gyarados).
BOOL CompleteScrCmd_StartWildBattle(ScriptContext *ctx)
{
    int *battleResult = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_BATTLE_RESULT);
    u16 species = ScriptContext_GetVar(ctx);
    u8 level = ScriptContext_GetVar(ctx);
    u8 shiny = ScriptContext_ReadByte(ctx);

    gCompleteNextWildShiny = shiny != 0;
    Encounter_NewVsSpeciesAtLevel(ctx->task, species, level, battleResult, FALSE);
    return TRUE;
}

// HeartGold's standard menu (MenuInitStdGmm): Platinum's global text menu, with its entries from HeartGold's menu
// strings (its bank 191) in place of Platinum's. The menu frees the loader when it closes.
BOOL CompleteScrCmd_InitHGSSMenu(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    FieldMenuManager **fieldMenuMan = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_FIELD_MENU_MANAGER);
    StringTemplate **stringTemplate = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u8 anchorX = ScriptContext_ReadByte(ctx);
    u8 anchorY = ScriptContext_ReadByte(ctx);
    u8 initialCursorPos = ScriptContext_ReadByte(ctx);
    u8 canExitWithB = ScriptContext_ReadByte(ctx);
    u16 selectedOptionVar = ScriptContext_ReadHalfWord(ctx);

    *fieldMenuMan = FieldMenuManager_New(fieldSystem, anchorX, anchorY, initialCursorPos, canExitWithB, FieldSystem_GetVarPointer(fieldSystem, selectedOptionVar), *stringTemplate, FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_WINDOW), NULL);
    MessageLoader_Free((*fieldMenuMan)->messageLoader);
    (*fieldMenuMan)->messageLoader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0191, HEAP_ID_FIELD1);

    ctx->data[0] = selectedOptionVar;
    return TRUE;
}
