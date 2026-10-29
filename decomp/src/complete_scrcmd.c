#include "complete_scrcmd.h"

#include <nitro.h>

#include "constants/battle.h"
#include "constants/heap.h"
#include "constants/moves.h"
#include "constants/narc.h"
#include "generated/genders.h"
#include "generated/map_headers.h"
#include "generated/species.h"
#include "generated/text_banks.h"
#include "res/text/bank/special_met_location_names.h"

#include "field/field_system.h"
#include "overlay005/daycare.h"
#include "overlay005/field_menu.h"
#include "overlay005/script_message.h"

#include "complete_follower.h"
#include "encounter.h"
#include "field_message.h"
#include "field_overworld_state.h"
#include "field_script_context.h"
#include "field_system.h"
#include "inlines.h"
#include "map_object.h"
#include "message.h"
#include "party.h"
#include "pokemon.h"
#include "save_player.h"
#include "string_gf.h"
#include "string_template.h"
#include "script_manager.h"
#include "trainer_info.h"
#include "unk_02017038.h"
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

// HeartGold's elevators (Goldenrod and Celadon's department stores, the Radio Tower, Olivine's lighthouse, Silph Co.,
// Celadon's condominiums) number a floor from the bottom, as HeartGold's MapNumToFloorNo does: the floor of the
// elevator's last stop (the special location SetSpecialLocation keeps).
static const struct {
    u16 mapHeaderID;
    u16 floor;
} sHGSSElevatorFloors[] = {
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_5F, 0 },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_OBSERVATION_DECK, 1 },
    { MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_1F, 0 },
    { MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_LIGHT_ROOM, 1 },
    { MAP_HEADER_HGSS_SAFFRON_SILPH_CO_HQ, 0 },
    { MAP_HEADER_HGSS_SAFFRON_SILPH_CO_ROTOM_ROOM, 1 },
    { MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_BASEMENT, 0 },
    { MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_1F, 1 },
    { MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_2F, 2 },
    { MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_3F, 3 },
    { MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_4F, 4 },
    { MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_5F, 5 },
    { MAP_HEADER_HGSS_GOLDENROD_DEPARTMENT_STORE_6F, 6 },
    { MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_1F, 0 },
    { MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_2F, 1 },
    { MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_3F, 2 },
    { MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_4F, 3 },
    { MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_5F, 4 },
    { MAP_HEADER_HGSS_CELADON_DEPARTMENT_STORE_ROOF, 5 },
    { MAP_HEADER_HGSS_CELADON_CONDOMINIUMS_1F, 0 },
    { MAP_HEADER_HGSS_CELADON_CONDOMINIUMS_2F, 1 },
    { MAP_HEADER_HGSS_CELADON_CONDOMINIUMS_3F, 2 },
    { MAP_HEADER_HGSS_CELADON_CONDOMINIUMS_ROOF, 3 },
};

BOOL CompleteScrCmd_GetElevatorFloor(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Location *location = FieldOverworldState_GetSpecialLocation(SaveData_GetFieldOverworldState(ctx->fieldSystem->saveData));

    *destVar = 0;

    for (int i = 0; i < NELEMS(sHGSSElevatorFloors); i++) {
        if (sHGSSElevatorFloors[i].mapHeaderID == location->mapHeaderID) {
            *destVar = sHGSSElevatorFloors[i].floor;
            break;
        }
    }

    return FALSE;
}

// HeartGold's floor names (its BufferDeptStoreFloorNo), from its menu strings: B1F for 0, then 1F to 6F (Platinum's
// own stop at 5F).
#define HGSS_MENU_TEXT_1F  116
#define HGSS_MENU_TEXT_B1F 122

BOOL CompleteScrCmd_BufferFloorName(ScriptContext *ctx)
{
    StringTemplate **strTemplate = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u8 templateArg = ScriptContext_ReadByte(ctx);
    u8 floor = ScriptContext_ReadByte(ctx);

    GF_ASSERT(floor <= 6);

    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0191, HEAP_ID_FIELD2);
    String *string = MessageLoader_GetNewString(loader, floor == 0 ? HGSS_MENU_TEXT_B1F : HGSS_MENU_TEXT_1F + floor - 1);

    StringTemplate_SetString(*strTemplate, templateArg, string, 0, TRUE, GAME_LANGUAGE);
    String_Free(string);
    MessageLoader_Free(loader);
    return FALSE;
}

// HeartGold's Togepi Egg (GiveTogepiEgg): Platinum's egg gift with Extrasensory in its first free move slot. It is met
// in Johto, as Platinum's gift places lack HeartGold's Mr. Pokémon.
BOOL CompleteScrCmd_GiveTogepiEgg(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    Party *party = SaveData_GetParty(fieldSystem->saveData);

    if (Party_GetCurrentCount(party) >= MAX_PARTY_SIZE) {
        return FALSE;
    }

    Pokemon *egg = Pokemon_New(HEAP_ID_FIELD2);
    Pokemon_Init(egg);
    Egg_CreateEgg(egg, SPECIES_TOGEPI, 1, SaveData_GetTrainerInfo(fieldSystem->saveData), 3, SpecialMetLoc_GetId(1, SPECIAL_METLOC_NAME_JOHTO));

    int slot;

    for (slot = 0; slot < LEARNED_MOVES_MAX - 1; slot++) {
        if (Pokemon_GetValue(egg, MON_DATA_MOVE1 + slot, NULL) == MOVE_NONE) {
            break;
        }
    }

    u16 move = MOVE_EXTRASENSORY;
    Pokemon_SetValue(egg, MON_DATA_MOVE1 + slot, &move);
    u8 pp = Pokemon_GetValue(egg, MON_DATA_MOVE1_MAX_PP + slot, NULL);
    Pokemon_SetValue(egg, MON_DATA_MOVE1_PP + slot, &pp);

    Party_AddPokemon(party, egg);
    Heap_Free(egg);
    return FALSE;
}

// HeartGold's StaticWildWonOrCaughtCheck (its form 0, from the battle just fought): whether the Pokémon got away,
// neither beaten nor caught.
BOOL CompleteScrCmd_CheckStaticNotBeaten(ScriptContext *ctx)
{
    int *battleResult = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_BATTLE_RESULT);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = *battleResult != BATTLE_RESULT_WIN && *battleResult != BATTLE_RESULT_CAPTURED_MON;
    return TRUE;
}
