#include "complete_scrcmd.h"

#include <nitro.h>

#include "constants/battle.h"
#include "constants/ball_capsule.h"
#include "constants/field/complete_tile_behaviors.h"
#include "constants/heap.h"
#include "constants/moves.h"
#include "constants/narc.h"
#include "constants/npc_trades.h"
#include "generated/genders.h"
#include "generated/items.h"
#include "generated/map_headers.h"
#include "generated/object_events_gfx.h"
#include "generated/species.h"
#include "generated/text_banks.h"
#include "generated/trainers.h"
#include "generated/vars_flags.h"
#include "res/text/bank/special_met_location_names.h"
#include "res/text/bank/lifestyle_words.h"
#include "res/text/bank/loss_sentences.h"
#include "res/text/bank/win_sentences.h"

#include "field/field_system.h"
#include "overlay005/daycare.h"
#include "overlay005/field_menu.h"
#include "overlay005/map_prop.h"
#include "overlay005/script_message.h"
#include "overlay005/size_contest.h"
#include "overlay006/complete_field_encounters.h"
#include "overlay006/npc_trade.h"
#include "struct_defs/choose_starter_data.h"

#include "data/hgss_johto_dex.h"

#include "applications/complete_alph_puzzle.h"
#include "applications/naming_screen.h"
#include "ball_seal_info.h"
#include "camera.h"
#include "charcode_util.h"
#include "clear_game.h"
#include "complete_badges.h"
#include "complete_follower.h"
#include "complete_rival.h"
#include "easy_chat_sentence.h"
#include "easy_chat_words.h"
#include "encounter.h"
#include "field_task.h"
#include "heap.h"
#include "field_message.h"
#include "field_overworld_state.h"
#include "field_script_context.h"
#include "field_system.h"
#include "inlines.h"
#include "item.h"
#include "mail.h"
#include "map_object.h"
#include "math_util.h"
#include "map_object_move.h"
#include "message.h"
#include "party.h"
#include "pokedex.h"
#include "pokemon.h"
#include "pokemon_icon.h"
#include "player_avatar.h"
#include "player_move.h"
#include "save_player.h"
#include "save_catchrecords.h"
#include "scrcmd.h"
#include "string_gf.h"
#include "terrain_collision_manager.h"
#include "string_template.h"
#include "script_manager.h"
#include "trainer_info.h"
#include "unk_02017038.h"
#include "unk_0203D1B8.h"
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

// HeartGold's ScrCmd_600: the follower goes back in its ball (before healing, a warp or a scene). Here it hides,
// without HeartGold's animation, and stays an object for the commands that follow.
BOOL CompleteScrCmd_FollowerPutAway(ScriptContext *ctx)
{
    MapObject *follower = Follower(ctx);

    if (follower != NULL) {
        MapObject_SetHidden(follower, TRUE);
    }

    return FALSE;
}

// HeartGold's ScrCmd_606, what its warps do at the end: the follower comes out again beside the player.
BOOL CompleteScrCmd_FollowerReturn(ScriptContext *ctx)
{
    CompleteFollower_Refresh(ctx->fieldSystem);
    return FALSE;
}

// HeartGold's ScrCmd_605: the follower stands a tile from the player in direction dir, facing facing (after Elm gives
// the starter, it comes out there; HeartGold's ScrCmd_608 then plays its ball's effect, which isn't ported).
BOOL CompleteScrCmd_FollowerPlace(ScriptContext *ctx)
{
    u8 dir = ScriptContext_ReadByte(ctx);
    u8 facing = ScriptContext_ReadByte(ctx);
    PlayerAvatar *playerAvatar = ctx->fieldSystem->playerAvatar;

    if (Follower(ctx) == NULL) {
        CompleteFollower_Refresh(ctx->fieldSystem);
    }

    MapObject *follower = Follower(ctx);

    if (follower != NULL) {
        MapObject_SetPosDirFromCoords(follower, PlayerAvatar_GetXPos(playerAvatar) + MapObject_GetDxFromDir(dir), 0,
            PlayerAvatar_GetZPos(playerAvatar) + MapObject_GetDzFromDir(dir), facing);
        MapObject_RecalculateObjectHeight(follower);
    }

    return FALSE;
}

// HeartGold's ScrCmd_729: whether a Pokémon is following.
BOOL CompleteScrCmd_FollowerCheckActive(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = Follower(ctx) != NULL;
    return FALSE;
}

// HeartGold's ChooseStarter, as Platinum's starter choice (Rowan's briefcase) with Professor Elm's three: the scene,
// then the species picked into a variable (the script then returns to the field and gives it, as Platinum's own does).
BOOL CompleteScrCmd_StartJohtoStarterScene(ScriptContext *ctx)
{
    void **dataPtr = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_DATA_PTR);
    ChooseStarterData *data = Heap_Alloc(HEAP_ID_FIELD2, sizeof(ChooseStarterData));

    *dataPtr = data;
    data->options = SaveData_GetOptions(ctx->fieldSystem->saveData);
    data->johto = TRUE;
    FieldSystem_LaunchChooseStarterApp(ctx->fieldSystem, data);
    ScriptContext_Pause(ctx, ScriptContext_WaitForApplicationExit);
    return TRUE;
}

#define ELMS_LAB_BALL_MODEL (930 + 0x8D) // HeartGold's indoor building model 0x8D (labo_mb): tools/complete/import_hgss_maps.py

// HeartGold's PlaceStarterBallsInElmsLab, as the lab loads: the Poké Balls left on Elm's table, three before the player
// chooses, two after, one once Rival has taken his, none once Falkner is beaten
BOOL CompleteScrCmd_PlaceStarterBalls(ScriptContext *ctx)
{
    static const VecFx32 ballPositions[] = {
        { FX32_CONST(131), 0, FX32_CONST(65) },
        { FX32_CONST(141), 0, FX32_CONST(65) },
        { FX32_CONST(136), 0, FX32_CONST(72) },
    };
    FieldSystem *fieldSystem = ctx->fieldSystem;
    int count;

    if (FieldSystem_CheckFlag(fieldSystem, FLAG_HGSS_GOT_TM51_FROM_FALKNER)) {
        count = 0;
    } else if (FieldSystem_CheckFlag(fieldSystem, FLAG_HGSS_MET_PASSERBY_BOY)) {
        count = 1;
    } else if (Party_GetCurrentCount(SaveData_GetParty(fieldSystem->saveData)) > 0) {
        count = 2;
    } else {
        count = 3;
    }

    for (int i = 0; i < count; i++) {
        MapPropManager_LoadOne(fieldSystem->mapPropManager, fieldSystem->areaDataManager, ELMS_LAB_BALL_MODEL, &ballPositions[i], NULL, fieldSystem->mapPropAnimMan);
    }

    return FALSE;
}

BOOL CompleteScrCmd_GetChosenStarter(ScriptContext *ctx)
{
    void **dataPtr = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_DATA_PTR);
    ChooseStarterData *data = *dataPtr;
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = data->species;
    Heap_Free(data);
    *dataPtr = NULL;
    return FALSE;
}

// HeartGold's NameRival: Platinum's naming screen for a rival, with HeartGold's prompt and default name, the name kept as
// Johto's rival's (src/complete_rival.c)
BOOL CompleteScrCmd_NameHGSSRival(ScriptContext *ctx)
{
    sub_0203DFE8(ctx->task, NAMING_SCREEN_TYPE_RIVAL, NAMING_SCREEN_RIVAL_JOHTO, TRAINER_NAME_LEN, 0, NULL, ScriptContext_GetVarPointer(ctx));
    return TRUE;
}

// HeartGold's BufferRivalsName: Johto's rival's name, or before the player has named him, his trainer data's (Silver)
BOOL CompleteScrCmd_BufferHGSSRivalName(ScriptContext *ctx)
{
    StringTemplate **stringTemplate = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    u8 templateArg = ScriptContext_ReadByte(ctx);
    charcode_t name[TRAINER_NAME_LEN + 1];
    String *string = String_Init(TRAINER_NAME_LEN + 1, HEAP_ID_FIELD3);

    if (CompleteRival_GetName(ctx->fieldSystem->saveData, name)) {
        String_CopyChars(string, name);
    } else {
        MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_NPC_TRAINER_NAMES, HEAP_ID_FIELD3);

        MessageLoader_GetString(loader, TRAINER_HGSS_RIVAL_SILVER, string);
        MessageLoader_Free(loader);
    }

    StringTemplate_SetString(*stringTemplate, templateArg, string, 0, TRUE, GAME_LANGUAGE);
    String_Free(string);
    return FALSE;
}

// HeartGold's HOFCredits (after Lance, or after Red): Johto's game clear (src/clear_game.c's ClearGame_Johto), which
// ends by starting the game over, as HeartGold's does after its credits
BOOL CompleteScrCmd_JohtoClearGame(ScriptContext *ctx)
{
    ScriptContext_ReadHalfWord(ctx); // HeartGold's vsTrainerRed: whether to count a League win
    ClearGame_Johto(ctx->fieldSystem->task);
    return TRUE;
}

// HeartGold's ScrCmd_596: whether the following Pokémon is too tall for most buildings, so that a script puts it away
// before the player goes into one (Route 10's Power Plant).
BOOL CompleteScrCmd_FollowerIsTooTall(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = Follower(ctx) != NULL && CompleteFollower_IsTooTall(ctx->fieldSystem);
    return FALSE;
}

// HeartGold's GetShinyLeafCount: the Shiny Leaves the party Pokémon in the slot has found (src/complete_follower.c)
BOOL CompleteScrCmd_GetShinyLeafCount(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u8 leaves = CompleteFollower_GetShinyLeaves(Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot));

    *destVar = 0;

    for (int i = 0; i < 5; i++) {
        *destVar += (leaves >> i) & 1;
    }

    return FALSE;
}

// HeartGold's TryGiveShinyLeafCrown: the five leaves of the party Pokémon in the slot become a crown
BOOL CompleteScrCmd_GiveShinyLeafCrown(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);
    Pokemon *mon = Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);
    u8 leaves = CompleteFollower_GetShinyLeaves(mon);

    if ((leaves & 0x1F) == 0x1F) {
        CompleteFollower_SetShinyLeaves(mon, leaves | SHINY_LEAF_CROWN);
    }

    return FALSE;
}

// HeartGold's ScrCmd_523 (its sub_0205BED8): an object sways sideways and back, as the legendary Pokémon do before
// Johto's and Kanto's scenes with them: cycles of a sine, the angle going up by step degrees a frame, x and z pixels
// wide
static struct {
    MapObject *object;
    fx32 x;
    fx32 z;
    u16 cycles;
    u16 step;
    u16 angle;
} sObjectSway;

static BOOL ObjectSwayFrame(ScriptContext *ctx)
{
    VecFx32 offset = { 0, 0, 0 };

    if (sObjectSway.cycles != 0) {
        fx32 sine = CalcSineDegrees(sObjectSway.angle);

        offset.x = FX_Mul(sine, sObjectSway.x);
        offset.z = FX_Mul(sine, sObjectSway.z);
        sObjectSway.angle += sObjectSway.step;

        if (sObjectSway.angle >= 360) {
            sObjectSway.angle = 0;
            sObjectSway.cycles--;
        }
    }

    MapObject_SetSpritePosOffset(sObjectSway.object, &offset);
    return sObjectSway.cycles == 0;
}

BOOL CompleteScrCmd_ObjectSway(ScriptContext *ctx)
{
    u16 localID = ScriptContext_GetVar(ctx);

    sObjectSway.cycles = ScriptContext_GetVar(ctx);
    sObjectSway.step = ScriptContext_GetVar(ctx);
    sObjectSway.x = ScriptContext_GetVar(ctx) * FX32_ONE;
    sObjectSway.z = ScriptContext_GetVar(ctx) * FX32_ONE;
    sObjectSway.angle = 0;
    sObjectSway.object = MapObjMan_LocalMapObjByIndex(ctx->fieldSystem->mapObjMan, localID);

    if (sObjectSway.object == NULL || sObjectSway.step == 0) {
        return FALSE;
    }

    ScriptContext_Pause(ctx, ObjectSwayFrame);
    return TRUE;
}

// HeartGold's GiveBadge and CheckBadge: Johto's and Kanto's badges (BADGE_ID_HGSS_*), beside Sinnoh's
BOOL CompleteScrCmd_GiveBadge(ScriptContext *ctx)
{
    u16 badge = ScriptContext_GetVar(ctx);

    GF_ASSERT(badge < MAX_HGSS_BADGES);
    CompleteBadges_Set(SaveData_GetTrainerInfo(ctx->fieldSystem->saveData), badge);
    return FALSE;
}

BOOL CompleteScrCmd_CheckBadge(ScriptContext *ctx)
{
    u16 badge = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    GF_ASSERT(badge < MAX_HGSS_BADGES);
    *destVar = CompleteBadges_Has(SaveData_GetTrainerInfo(ctx->fieldSystem->saveData), badge);
    return FALSE;
}

// Whether the player may use the field move Sinnoh's badge allows (res/field/scripts/scripts_field_moves.s): with
// that badge, or with the one that allows it in HeartGold
BOOL CompleteScrCmd_CheckFieldMoveBadge(ScriptContext *ctx)
{
    u16 badge = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    GF_ASSERT(badge < MAX_BADGES);
    *destVar = CompleteBadges_AllowsFieldMove(SaveData_GetTrainerInfo(ctx->fieldSystem->saveData), badge);
    return FALSE;
}

// HeartGold's TryHeadbuttEncounter and RockSmashItemCheck, and Ilex Forest's tutor's check (ScrCmd_656): Headbutt
// trees and Rock Smash on Johto's and Kanto's maps (src/overlay006/complete_field_encounters.c). A battle runs in a
// task under the script's, which waits for it.
BOOL CompleteScrCmd_Headbutt(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = CompleteFieldEncounters_TryHeadbutt(ctx->fieldSystem, ctx->task);
    return TRUE;
}

BOOL CompleteScrCmd_RockSmashFind(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u16 *itemVar = ScriptContext_GetVarPointer(ctx);

    *destVar = CompleteFieldEncounters_TryRockSmash(ctx->fieldSystem, ctx->task, itemVar);
    return TRUE;
}

BOOL CompleteScrCmd_CanLearnHeadbutt(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Pokemon *mon = Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);

    *destVar = CompleteFieldEncounters_CanLearnHeadbutt(Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL));
    return FALSE;
}

// HeartGold's Whirlpool (CommonScript_CompleteWhirlpool): how many steps take the player across the whirlpool ahead,
// its tiles and the water beyond
BOOL CompleteScrCmd_WhirlpoolSteps(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    int x, z;
    int dir = PlayerAvatar_GetFacingDir(ctx->fieldSystem->playerAvatar);
    int dx = dir == DIR_WEST ? -1 : dir == DIR_EAST ? 1 : 0;
    int dz = dir == DIR_NORTH ? -1 : dir == DIR_SOUTH ? 1 : 0;

    PlayerAvatar_GetFacingTileCoords(ctx->fieldSystem->playerAvatar, &x, &z);
    *destVar = 1;

    while (*destVar < 8 && TerrainCollisionManager_GetTileBehavior(ctx->fieldSystem, x, z) == TILE_BEHAVIOR_COMPLETE_WHIRLPOOL) {
        (*destVar)++;
        x += dx;
        z += dz;
    }

    return FALSE;
}

// HeartGold's small party and Pokédex queries, as its commands answer them: CountPartyMonsOfSpecies (Rotom's
// room), CheckKyogreGroudonInParty (Professor Oak), PartyMonIsMine (TRUE when the Pokémon's trainer ID isn't the
// player's: the Name Rater's and the Move Deleter's kin), GetEVTotal (the EV checker) and CheckSeenAllLetterUnown
// (all 26 letters seen: the Ruins of Alph's researchers).
BOOL CompleteScrCmd_CountPartySpecies(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u16 species = ScriptContext_GetVar(ctx);
    Party *party = SaveData_GetParty(ctx->fieldSystem->saveData);

    *destVar = 0;

    for (int i = 0; i < Party_GetCurrentCount(party); i++) {
        Pokemon *mon = Party_GetPokemonBySlotIndex(party, i);

        if (!Pokemon_GetValue(mon, MON_DATA_IS_EGG, NULL) && Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL) == species) {
            (*destVar)++;
        }
    }

    return FALSE;
}

BOOL CompleteScrCmd_CheckKyogreGroudonInParty(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Party *party = SaveData_GetParty(ctx->fieldSystem->saveData);

    *destVar = Party_HasSpecies(party, SPECIES_KYOGRE) || Party_HasSpecies(party, SPECIES_GROUDON);
    return FALSE;
}

BOOL CompleteScrCmd_PartyMonIsNotMine(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Pokemon *mon = Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);
    u16 otID = Pokemon_GetValue(mon, MON_DATA_OT_ID, NULL);

    *destVar = otID != (u16)TrainerInfo_ID(SaveData_GetTrainerInfo(ctx->fieldSystem->saveData));
    return FALSE;
}

BOOL CompleteScrCmd_GetEVTotal(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u16 slot = ScriptContext_GetVar(ctx);
    Pokemon *mon = Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);

    *destVar = 0;

    for (int stat = MON_DATA_HP_EV; stat <= MON_DATA_SPDEF_EV; stat++) {
        *destVar += Pokemon_GetValue(mon, stat, NULL);
    }

    return FALSE;
}

BOOL CompleteScrCmd_CheckSeenAllUnownLetters(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    const Pokedex *pokedex = SaveData_GetPokedex(ctx->fieldSystem->saveData);
    u32 letters = 0;

    for (u32 i = 0; i < Pokedex_NumFormsSeen_Unown(pokedex); i++) {
        u32 form = Pokedex_GetForm_Unown(pokedex, i);

        if (form < 26) {
            letters |= 1 << form;
        }
    }

    *destVar = letters == (1 << 26) - 1;
    return FALSE;
}

// HeartGold's MonAddContestValue (the Goldenrod Underground's haircuts): adds amount to a party Pokémon's contest
// condition attribute (0 Cool, 1 Beauty, 2 Cute, 3 Smart, 4 Tough, 5 Sheen), up to 255; a Pokémon whose Sheen is full
// takes no more, as in HeartGold.
BOOL CompleteScrCmd_MonAddContestValue(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);
    u8 attribute = ScriptContext_ReadByte(ctx);
    u16 amount = ScriptContext_GetVar(ctx);
    Pokemon *mon;

    if (attribute > MON_DATA_SHEEN - MON_DATA_COOL) {
        return FALSE;
    }

    mon = Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);

    if (Pokemon_GetValue(mon, MON_DATA_SHEEN, NULL) != MAX_CONTEST_STAT) {
        Pokemon_IncreaseValue(mon, MON_DATA_COOL + attribute, amount);
    }

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

// HeartGold's Togepi Egg (GiveTogepiEgg): Platinum's egg gift with Extrasensory in its first free move slot, from
// Mr. Pokémon (HeartGold's gift place 13, which Sovereign Complete adds after Platinum's).
BOOL CompleteScrCmd_GiveTogepiEgg(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    Party *party = SaveData_GetParty(fieldSystem->saveData);

    if (Party_GetCurrentCount(party) >= MAX_PARTY_SIZE) {
        return FALSE;
    }

    Pokemon *egg = Pokemon_New(HEAP_ID_FIELD2);
    Pokemon_Init(egg);
    Egg_CreateEgg(egg, SPECIES_TOGEPI, 1, SaveData_GetTrainerInfo(fieldSystem->saveData), 3, SpecialMetLoc_GetId(1, SPECIAL_METLOC_NAME_MR_POKEMON));

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

// HeartGold's StaticWildWonOrCaughtCheck's form 1 and LatiCaughtCheck, on the result HeartGold keeps in VAR_BATTLE_RESULT
// (src/encounter.c), which a map's script on returning from the battle (its OnResume, as in Team Rocket's hideout)
// reads before the battle's own script goes on: whether the Pokémon got away, neither beaten nor caught (caughtOnly 0),
// or wasn't caught (caughtOnly 1: Pewter City's Latias or Latios, who flees)
BOOL CompleteScrCmd_CheckLastBattleNotBeaten(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u16 caughtOnly = ScriptContext_ReadHalfWord(ctx);

    *destVar = gCompleteLastBattleResult != BATTLE_RESULT_CAPTURED_MON
        && (caughtOnly || gCompleteLastBattleResult != BATTLE_RESULT_WIN);
    return FALSE;
}

typedef struct ScreenShake {
    VecFx32 offset;
    fx32 amplitudeX;
    fx32 amplitudeY;
    u16 cycles;
    u16 frames;
    u16 frame;
} ScreenShake;

static BOOL CompleteScreenShake_Task(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    ScreenShake *shake = FieldTask_GetEnv(task);
    VecFx32 offset = { 0, 0, 0 };
    VecFx32 delta;

    if (++shake->frame < shake->frames) {
        fx32 sine = FX_SinIdx((u16)(0x10000 * shake->frame / shake->frames));
        offset.x = FX_Mul(sine, shake->amplitudeX);
        offset.y = FX_Mul(sine, shake->amplitudeY);
    } else {
        shake->frame = 0;
        shake->cycles--;
    }

    VEC_Subtract(&offset, &shake->offset, &delta);
    Camera_Move(&delta, fieldSystem->camera);
    shake->offset = offset;

    if (shake->cycles == 0) {
        Heap_Free(shake);
        return TRUE;
    }

    return FALSE;
}

// HeartGold's ScreenShake x, y, cycles, frames (its ov02_02246714): the camera sways by up to x and y on a sine wave of
// that many frames, that many times, then comes back.
#define HGSS_MAP_LOCAL_FLAGS_END 65

static u16 HGSSFlag(u16 flag)
{
    return flag < HGSS_MAP_LOCAL_FLAGS_END ? flag : COMPLETE_FLAGS_START + flag;
}

BOOL CompleteScrCmd_SetHGSSFlagFromVar(ScriptContext *ctx)
{
    FieldSystem_SetFlag(ctx->fieldSystem, HGSSFlag(ScriptContext_GetVar(ctx)));
    return FALSE;
}

BOOL CompleteScrCmd_ClearHGSSFlagFromVar(ScriptContext *ctx)
{
    FieldSystem_ClearFlag(ctx->fieldSystem, HGSSFlag(ScriptContext_GetVar(ctx)));
    return FALSE;
}

BOOL CompleteScrCmd_ScreenShake(ScriptContext *ctx)
{
    u16 amplitudeX = ScriptContext_GetVar(ctx);
    u16 amplitudeY = ScriptContext_GetVar(ctx);
    u16 cycles = ScriptContext_GetVar(ctx);
    u16 frames = ScriptContext_GetVar(ctx);

    if (cycles == 0 || frames == 0) {
        return FALSE;
    }

    ScreenShake *shake = Heap_AllocAtEnd(HEAP_ID_FIELD2, sizeof(ScreenShake));
    shake->offset = (VecFx32) { 0, 0, 0 };
    shake->amplitudeX = (s16)(amplitudeX * FX32_ONE); // HeartGold keeps them in 16 bits: its 20 sways by 4
    shake->amplitudeY = (s16)(amplitudeY * FX32_ONE);
    shake->cycles = cycles;
    shake->frames = frames;
    shake->frame = 0;

    FieldTask_InitCall(ctx->fieldSystem->task, CompleteScreenShake_Task, shake);
    return TRUE;
}

// HeartGold's GetFriendSprite: the childhood friend's look, the player sprite of the other gender (Platinum's stand in
// for Ethan's and Lyra's, as the maps' player sprites do: tools/complete/import_hgss_events.py)
BOOL CompleteScrCmd_GetFriendSprite(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = TrainerInfo_Gender(SaveData_GetTrainerInfo(ctx->fieldSystem->saveData)) == GENDER_MALE ? OBJ_EVENT_GFX_PLAYER_F : OBJ_EVENT_GFX_PLAYER_M;
    return FALSE;
}

static BOOL WaitForAlphPuzzle(ScriptContext *ctx)
{
    void **args = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_PARTY_MANAGEMENT_DATA);

    if (FieldSystem_IsRunningApplication(ctx->fieldSystem)) {
        return FALSE;
    }

    Heap_Free(*args);
    *args = NULL;
    return TRUE;
}

// HeartGold's AlphPuzzle: the Ruins of Alph's puzzle (src/applications/complete_alph_puzzle.c), whose flag is set when
// it's solved; the field is left for it as Platinum's diploma leaves it (ReturnToField brings it back)
BOOL CompleteScrCmd_AlphPuzzle(ScriptContext *ctx)
{
    FS_EXTERN_OVERLAY(complete_alph_puzzle);

    static const ApplicationManagerTemplate sTemplate = {
        CompleteAlphPuzzle_Init,
        CompleteAlphPuzzle_Main,
        CompleteAlphPuzzle_Exit,
        FS_OVERLAY_ID(complete_alph_puzzle),
    };
    u8 puzzle = ScriptContext_ReadByte(ctx);
    void **args = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_PARTY_MANAGEMENT_DATA);
    CompleteAlphPuzzleArgs *puzzleArgs = Heap_Alloc(HEAP_ID_FIELD3, sizeof(CompleteAlphPuzzleArgs));

    puzzleArgs->saveData = ctx->fieldSystem->saveData;
    puzzleArgs->puzzle = puzzle;
    *args = puzzleArgs;
    FieldSystem_StartChildProcess(ctx->fieldSystem, &sTemplate, puzzleArgs);
    ScriptContext_Pause(ctx, WaitForAlphPuzzle);
    return TRUE;
}

// HeartGold's loan Pokémon: Kenya, the Spearow the Route 35 gatehouse's man lends with a letter for his friend on
// Route 31 (Sacred Gold's Dux), and Kirk's Shuckle in Cianwood City (src/overlay006/npc_trade.c)
#define KENYA_LEVEL 20

// HeartGold's Kenya letter (its CreateKenyaMail): its Trainer's, on the paper Kenya holds, with Kenya's icon and three
// lines ("LETTER! Thank you!", "ADVENTURE was fun, wasn't it?", "ZUBAT was the one thing I wanted to avoid...")
static Mail *NewKenyaMail(Pokemon *kenya, enum HeapID heapID)
{
    Mail *mail = Mail_New(heapID);
    u32 species = Pokemon_GetValue(kenya, MON_DATA_SPECIES, NULL);
    u32 form = Pokemon_GetValue(kenya, MON_DATA_FORM, NULL);
    u32 isEgg = Pokemon_GetValue(kenya, MON_DATA_IS_EGG, NULL);

    mail->mailType = Item_GetMailType(Pokemon_GetValue(kenya, MON_DATA_HELD_ITEM, NULL));
    Pokemon_GetValue(kenya, MON_DATA_OT_NAME, mail->trainerName);
    mail->trainerGender = Pokemon_GetValue(kenya, MON_DATA_OT_GENDER, NULL);
    mail->trainerID = Pokemon_GetValue(kenya, MON_DATA_OT_ID, NULL);

    EasyChatSentence_SetTypeAndID(&mail->sentences[0], EASY_CHAT_SENTENCE_TYPE_WIN, WinSentences_Text_BlankThankYou);
    EasyChatSentence_SetWord(&mail->sentences[0], 0, EasyChatWord_FromBankAndEntry(TEXT_BANK_LIFESTYLE_WORDS, LifestyleWords_Text_Letter));
    EasyChatSentence_SetTypeAndID(&mail->sentences[1], EASY_CHAT_SENTENCE_TYPE_WIN, WinSentences_Text_BlankWasFunWasntIt);
    EasyChatSentence_SetWord(&mail->sentences[1], 0, EasyChatWord_FromBankAndEntry(TEXT_BANK_LIFESTYLE_WORDS, LifestyleWords_Text_Adventure));
    EasyChatSentence_SetTypeAndID(&mail->sentences[2], EASY_CHAT_SENTENCE_TYPE_LOSS, LossSentences_Text_BlankWasThingIWantedToAvoid);
    EasyChatSentence_SetWord(&mail->sentences[2], 0, EasyChatWord_FromBankAndEntry(TEXT_BANK_SPECIES_NAME, SPECIES_ZUBAT));

    mail->iconData[0].asStruct.spriteIndex = Pokemon_IconSpriteIndex(kenya);
    mail->iconData[0].asStruct.palIndex = PokeIconPaletteIndex(species, form, isEgg);

    return mail;
}

// The letter as Kenya carried it when lent (HeartGold's NPCTrade_MakeKenyaMail)
static Mail *NewLentKenyaMail(enum HeapID heapID)
{
    Pokemon *kenya = Pokemon_New(heapID);

    NPCTrade_CreateLoanMon(kenya, NPC_TRADE_HGSS_DUX_SPEAROW, KENYA_LEVEL, MAP_HEADER_HGSS_ROUTE_35_GOLDENROD_GATEHOUSE, heapID);
    Mail *mail = NewKenyaMail(kenya, heapID);
    Heap_Free(kenya);

    return mail;
}

// HeartGold's Mail_Compare
static BOOL MailsMatch(const Mail *mail1, const Mail *mail2)
{
    if (mail1->trainerID != mail2->trainerID
        || mail1->trainerGender != mail2->trainerGender
        || mail1->language != mail2->language
        || mail1->gameVersion != mail2->gameVersion
        || mail1->mailType != mail2->mailType
        || mail1->platExclusiveFormIcons != mail2->platExclusiveFormIcons
        || CharCode_Compare(mail1->trainerName, mail2->trainerName)) {
        return FALSE;
    }

    for (int i = 0; i < MAIL_MAX_ICONS; i++) {
        if (mail1->iconData[i].asValue != mail2->iconData[i].asValue) {
            return FALSE;
        }
    }

    for (int i = 0; i < MAIL_MAX_SENTENCES; i++) {
        if (!EasyChatSentence_Compare(&mail1->sentences[i], &mail2->sentences[i])) {
            return FALSE;
        }
    }

    return TRUE;
}

// HeartGold's MonIsInGameTradePoke: the Pokémon is the one lent (Kenya may have evolved)
static BOOL IsLoanMon(Pokemon *mon, u32 npcTradeID)
{
    NPCTradeMon *npcTradeMon = NPCTrade_LoadTradeMon(npcTradeID, HEAP_ID_FIELD2);
    u32 species = Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL);
    BOOL isLoanMon;

    if (npcTradeID == NPC_TRADE_HGSS_DUX_SPEAROW) {
        isLoanMon = species == SPECIES_SPEAROW || species == SPECIES_FEAROW;
    } else {
        isLoanMon = species == npcTradeMon->species;
    }

    isLoanMon = isLoanMon
        && Pokemon_GetValue(mon, MON_DATA_OT_ID, NULL) == npcTradeMon->otID
        && Pokemon_GetValue(mon, MON_DATA_PERSONALITY, NULL) == npcTradeMon->personality
        && Pokemon_GetValue(mon, MON_DATA_OT_GENDER, NULL) == npcTradeMon->otGender
        && Pokemon_GetValue(mon, MON_DATA_LANGUAGE, NULL) == npcTradeMon->language
        && Pokemon_GetValue(mon, MON_DATA_MET_GAME, NULL) == gGameVersion;

    Heap_Free(npcTradeMon);
    return isLoanMon;
}

// HeartGold's GiveLoanMon: the trade's Pokémon at the level, met on the map, joins the party (Kenya with the letter)
BOOL CompleteScrCmd_GiveLoanMon(ScriptContext *ctx)
{
    u16 npcTradeID = ScriptContext_ReadHalfWord(ctx);
    u16 level = ScriptContext_ReadHalfWord(ctx);
    u16 mapID = ScriptContext_ReadHalfWord(ctx);
    Pokemon *mon = Pokemon_New(HEAP_ID_FIELD2);

    NPCTrade_CreateLoanMon(mon, npcTradeID, level, mapID, HEAP_ID_FIELD2);

    if (npcTradeID == NPC_TRADE_HGSS_DUX_SPEAROW) {
        Mail *mail = NewKenyaMail(mon, HEAP_ID_FIELD2);
        Pokemon_SetValue(mon, MON_DATA_MAIL, mail);
        Heap_Free(mail);
    }

    SaveData_UpdateCatchRecords(ctx->fieldSystem->saveData, mon);
    Party_AddPokemon(SaveData_GetParty(ctx->fieldSystem->saveData), mon);
    Heap_Free(mon);

    return FALSE;
}

// HeartGold's CheckReturnLoanMon: whether the party Pokémon in the slot can go back to its Trainer: 0 yes, 1 it isn't
// the one lent, 2 it holds an item, 3 it has a Ball Capsule, 4 it's the party's last that can battle
BOOL CompleteScrCmd_CheckReturnLoanMon(ScriptContext *ctx)
{
    u16 npcTradeID = ScriptContext_ReadHalfWord(ctx);
    u16 slot = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Party *party = SaveData_GetParty(ctx->fieldSystem->saveData);
    Pokemon *mon = Party_GetPokemonBySlotIndex(party, slot);
    int ableToBattle = 0;

    for (int i = 0; i < Party_GetCurrentCount(party); i++) {
        Pokemon *partyMon = Party_GetPokemonBySlotIndex(party, i);

        if (Pokemon_GetValue(partyMon, MON_DATA_HP, NULL) != 0 && !Pokemon_GetValue(partyMon, MON_DATA_IS_EGG, NULL)) {
            ableToBattle++;
        }
    }

    if (!IsLoanMon(mon, npcTradeID)) {
        *destVar = 1;
    } else if (Pokemon_GetValue(mon, MON_DATA_BALL_CAPSULE_ID, NULL) != 0) {
        *destVar = 3;
    } else if (ableToBattle < 2) {
        *destVar = 4;
    } else if (Pokemon_GetValue(mon, MON_DATA_HELD_ITEM, NULL) != ITEM_NONE) {
        *destVar = 2;
    } else {
        *destVar = 0;
    }

    return FALSE;
}

// HeartGold's ReturnLoanMon: the party Pokémon in the slot leaves
BOOL CompleteScrCmd_ReturnLoanMon(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);

    Party_RemovePokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);
    return FALSE;
}

// HeartGold's KenyaCheck: whether the party Pokémon in the slot holds mail (whether mode is 0), or Kenya's letter
BOOL CompleteScrCmd_KenyaCheck(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u16 slot = ScriptContext_GetVar(ctx);
    u16 mode = ScriptContext_ReadHalfWord(ctx);
    Pokemon *mon = Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);

    if (!Item_IsMail(Pokemon_GetValue(mon, MON_DATA_HELD_ITEM, NULL))) {
        *destVar = FALSE;
    } else if (mode == 0) {
        *destVar = TRUE;
    } else {
        Mail *kenyaMail = NewLentKenyaMail(HEAP_ID_FIELD2);
        Mail *mail = Mail_New(HEAP_ID_FIELD2);

        Pokemon_GetValue(mon, MON_DATA_MAIL, mail);
        *destVar = MailsMatch(kenyaMail, mail);
        Heap_Free(mail);
        Heap_Free(kenyaMail);
    }

    return FALSE;
}

// HeartGold's KenyaCheckPartyOrMailbox: whether a party Pokémon holds Kenya's letter or the PC's mailbox keeps it
BOOL CompleteScrCmd_KenyaCheckPartyOrMailbox(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Party *party = SaveData_GetParty(ctx->fieldSystem->saveData);
    Mailbox *mailbox = SaveData_GetMailbox(ctx->fieldSystem->saveData);
    Mail *kenyaMail = NewLentKenyaMail(HEAP_ID_FIELD2);
    Mail *mail = Mail_New(HEAP_ID_FIELD2);

    *destVar = FALSE;

    for (int i = 0; i < Party_GetCurrentCount(party) && !*destVar; i++) {
        Pokemon *mon = Party_GetPokemonBySlotIndex(party, i);

        if (Item_IsMail(Pokemon_GetValue(mon, MON_DATA_HELD_ITEM, NULL))) {
            Pokemon_GetValue(mon, MON_DATA_MAIL, mail);
            *destVar = MailsMatch(kenyaMail, mail);
        }
    }

    for (int i = 0; i < MAILBOX_SIZE && !*destVar; i++) {
        Mailbox_GetMailAtSlot(mailbox, MAIL_CONTEXT_MAILBOX, i, mail);
        *destVar = Mail_IsValid(mail) && MailsMatch(kenyaMail, mail);
    }

    Heap_Free(mail);
    Heap_Free(kenyaMail);
    return FALSE;
}

// HeartGold's MonGiveMail: the party Pokémon in the slot gives up its mail (Kenya's letter, to the friend on Route 31).
// Sacred Gold's Route 31 passes a slot past the party (150), which leaves the party as it is.
BOOL CompleteScrCmd_TakeMonMail(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);
    Party *party = SaveData_GetParty(ctx->fieldSystem->saveData);

    if (slot >= Party_GetCurrentCount(party)) {
        return FALSE;
    }

    Pokemon *mon = Party_GetPokemonBySlotIndex(party, slot);

    if (Item_IsMail(Pokemon_GetValue(mon, MON_DATA_HELD_ITEM, NULL))) {
        Mail *mail = Mail_New(HEAP_ID_FIELD2);
        u16 item = ITEM_NONE;

        Pokemon_SetValue(mon, MON_DATA_MAIL, mail);
        Pokemon_SetValue(mon, MON_DATA_HELD_ITEM, &item);
        Heap_Free(mail);
    }

    return FALSE;
}

// HeartGold's Magikarp record at the Lake of Rage (its scrcmd_size_record.c): Platinum's size contest's sizes, against
// the record in VAR_HGSS_MAGIKARP_SIZE_RECORD (src/overlay005/size_contest.c)

// HeartGold's SizeRecordCompare: the party Pokémon in the slot against the record (SIZE_CONTEST_SMALLER, _SAME_SIZE
// or _LARGER). On the same size HeartGold's leaves the var as it was, a slip; this sets it
BOOL CompleteScrCmd_SizeRecordCompare(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u16 slot = ScriptContext_GetVar(ctx);

    *destVar = SizeContest_CompareWithRecord(ctx->fieldSystem, slot, *FieldSystem_GetVarPointer(ctx->fieldSystem, VAR_HGSS_MAGIKARP_SIZE_RECORD));
    return FALSE;
}

// HeartGold's SizeRecordUpdate: the party Pokémon in the slot is the new record
BOOL CompleteScrCmd_SizeRecordUpdate(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);

    *FieldSystem_GetVarPointer(ctx->fieldSystem, VAR_HGSS_MAGIKARP_SIZE_RECORD) = SizeContest_GetPartyMonSizeFactor(ctx->fieldSystem, slot);
    return FALSE;
}

// HeartGold's BufferRecordSize: the record's size, for the species, into two string template slots (feet and inches)
BOOL CompleteScrCmd_BufferRecordSize(ScriptContext *ctx)
{
    u16 intPartIdx = ScriptContext_GetVar(ctx);
    u16 fracPartIdx = ScriptContext_GetVar(ctx);
    u16 species = ScriptContext_GetVar(ctx);

    SizeContest_SetSizeStrParams(ctx->fieldSystem, intPartIdx, fracPartIdx, species, *FieldSystem_GetVarPointer(ctx->fieldSystem, VAR_HGSS_MAGIKARP_SIZE_RECORD));
    return FALSE;
}

// HeartGold's CheckJohtoDexComplete (the Celadon Condominiums' game designer): whether every species of HeartGold's
// Johto Pokédex is caught, Mew and Celebi aside
BOOL CompleteScrCmd_CheckJohtoDexComplete(ScriptContext *ctx)
{
    Pokedex *pokedex = SaveData_GetPokedex(ctx->fieldSystem->saveData);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = TRUE;

    for (int i = 0; i < NELEMS(sHGSSJohtoDex); i++) {
        if (sHGSSJohtoDex[i] != SPECIES_MEW && sHGSSJohtoDex[i] != SPECIES_CELEBI
            && !Pokedex_HasCaughtSpecies(pokedex, sHGSSJohtoDex[i])) {
            *destVar = FALSE;
            break;
        }
    }

    return FALSE;
}

// HeartGold's GiveRandomSeal (Olivine City): up to three different seals into the Seal Case, each picked with a chance
// as large as the room left for it, from the seals before the unreleased Mystery Seal; their IDs (0 for none) into
// the three vars
BOOL CompleteScrCmd_GiveRandomSeal(ScriptContext *ctx)
{
    u16 *destVars[3];
    SealCase *sealCase = SaveData_GetSealCase(ctx->fieldSystem->saveData);
    u16 thresholds[MYSTERY_SEAL - 1];
    u16 picked[3];
    s32 room = 0;

    for (int i = 0; i < 3; i++) {
        destVars[i] = ScriptContext_GetVarPointer(ctx);
    }

    for (int i = 0; i < MYSTERY_SEAL - 1; i++) {
        room += MAX_SEALS_PER_TYPE - SealCase_CountSealOccurrenceAnywhere(sealCase, i + 1);
        thresholds[i] = room;
    }

    for (int i = 0; i < 3; i++) {
        *destVars[i] = 0;

        if (i >= room) {
            continue;
        }

        BOOL seen;
        u16 roll;

        do {
            roll = LCRNG_Next() % room;
            seen = FALSE;

            for (int j = 0; j < i; j++) {
                seen |= picked[j] == roll;
            }
        } while (seen);

        picked[i] = roll;

        for (int j = 0; j < MYSTERY_SEAL - 1; j++) {
            if (roll < thresholds[j]) {
                *destVars[i] = j + 1;
                GiveOrTakeSeal(sealCase, j + 1, 1);
                break;
            }
        }
    }

    return FALSE;
}
