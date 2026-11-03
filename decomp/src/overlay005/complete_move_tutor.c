#include <nitro.h>

#include "constants/string.h"
#include "generated/moves.h"

#include "field/field_system.h"
#include "overlay005/field_menu.h"
#include "overlay005/scrcmd_move_tutor.h"

#include "complete_scrcmd.h"
#include "field_script_context.h"
#include "inlines.h"
#include "list_menu.h"
#include "menu.h"
#include "party.h"
#include "pokemon.h"
#include "script_manager.h"
#include "string_template.h"
#include "tutor_movesets.h"

#include "data/hgss_frontier_tutors.h"

// Sovereign Complete: HeartGold's Battle Frontier move tutors (pokeheartgold's src/field/scrcmd_move_tutor.c), who
// teach for Battle Points from the Frontier Access (HeartGold's scr_seq_0002, here scripts_hgss_0002 at
// SCRIPT_ID_OFFSET_COMPLETE_FRONTIER_TUTORS). Each tutor has HeartGold's moves and prices
// (include/data/hgss_frontier_tutors.h, from tools/complete/import_hgss_tutors.py). Who can learn Platinum's 38 tutor
// moves the engine's own data decides, as its tutors do; HeartGold's 13 others come from HeartGold's list, and for the
// species after it from their own learnsets.

#define TUTOR_MOVES_PER_PAGE 6
#define TUTOR_MENU_NEXT      0xFFFD // HeartGold's: the NEXT entry
#define TUTOR_MENU_QUIT      0xFFFE // and QUIT (B too: MENU_CANCEL)
#define TUTOR_FORMAT_MOVE    0 // HeartGold's msg_0748 0: a move's name, then its price
#define TUTOR_FORMAT_NEXT    2
#define TUTOR_FORMAT_QUIT    3

static BOOL CanLearn(Pokemon *mon, u16 move)
{
    for (int i = 0; i < (int)NELEMS(sTeachableMoves); i++) {
        if (sTeachableMoves[i].moveID == move) {
            return (Pokemon_ReadMovesetMaskByte(mon, i / 8) >> (i % 8)) & 1;
        }
    }

    u16 species = Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL);

    for (int i = 0; i < (int)NELEMS(sFrontierTutorOnlyMoves); i++) {
        if (sFrontierTutorOnlyMoves[i] == move) {
            return species < NELEMS(sFrontierTutorLearners) && ((sFrontierTutorLearners[species] >> i) & 1);
        }
    }

    return FALSE;
}

// HeartGold's GetLearnableTutorMoves: the tutor's moves the Pokémon can learn and doesn't know (their places in
// sFrontierTutorMoves), and how many
static int LearnableMoves(Pokemon *mon, u16 tutor, u8 *dest)
{
    int count = 0;

    for (int i = 0; i < (int)NELEMS(sFrontierTutorMoves); i++) {
        if (sFrontierTutorMoves[i].tutor != tutor || !CanLearn(mon, sFrontierTutorMoves[i].move)) {
            continue;
        }

        int slot;

        for (slot = 0; slot < LEARNED_MOVES_MAX; slot++) {
            if (Pokemon_GetValue(mon, MON_DATA_MOVE1 + slot, NULL) == sFrontierTutorMoves[i].move) {
                break;
            }
        }

        if (slot == LEARNED_MOVES_MAX) {
            dest[count++] = i;
        }
    }

    return count;
}

static Pokemon *PartyMon(ScriptContext *ctx, u16 slot)
{
    return Party_GetPokemonBySlotIndex(SaveData_GetParty(ctx->fieldSystem->saveData), slot);
}

// HeartGold's ScrCmd_652 slot, tutor, destVar: the pages its move list takes (0 for none to learn; one for up to seven,
// with no NEXT; else six a page)
BOOL CompleteScrCmd_TutorMovePages(ScriptContext *ctx)
{
    u16 slot = ScriptContext_GetVar(ctx);
    u16 tutor = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u8 moves[NELEMS(sFrontierTutorMoves)];
    int count = LearnableMoves(PartyMon(ctx, slot), tutor, moves);

    *destVar = count == 0 ? 0 : count <= 7 ? 1 : count / TUTOR_MOVES_PER_PAGE + 1;
#ifdef SOVEREIGN_TEST
    gCompleteTestTutor[0] = *destVar;
#endif
    return FALSE;
}

// HeartGold's TutorMoveGetPrice move, destVar: its price in Battle Points
BOOL CompleteScrCmd_TutorMovePrice(ScriptContext *ctx)
{
    u16 move = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = 0;

    for (int i = 0; i < (int)NELEMS(sFrontierTutorMoves); i++) {
        if (sFrontierTutorMoves[i].move == move) {
            *destVar = sFrontierTutorMoves[i].cost;
            break;
        }
    }

#ifdef SOVEREIGN_TEST
    gCompleteTestTutor[2] = *destVar;
    gCompleteTestTutor[3] = move;
#endif
    return FALSE;
}

static BOOL ResumeOnSelection(ScriptContext *ctx)
{
    return *FieldSystem_GetVarPointer(ctx->fieldSystem, ctx->data[0]) != LIST_MENU_NO_SELECTION_YET;
}

// HeartGold's MoveTutorChooseMove slot, tutor, page, destVar: the page's moves, each with its price, then NEXT (with
// more than seven) and QUIT; the move chosen, TUTOR_MENU_NEXT or TUTOR_MENU_QUIT
BOOL CompleteScrCmd_TutorChooseMove(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    u16 slot = ScriptContext_GetVar(ctx);
    u16 tutor = ScriptContext_GetVar(ctx);
    u16 page = ScriptContext_GetVar(ctx);
    u16 destVarID = ScriptContext_ReadHalfWord(ctx);
    u8 moves[NELEMS(sFrontierTutorMoves)];
    int count = LearnableMoves(PartyMon(ctx, slot), tutor, moves);
    int skip = 0;
    BOOL next = FALSE;

    if (count > 7) {
        skip = page * TUTOR_MOVES_PER_PAGE;
        count = count - skip > TUTOR_MOVES_PER_PAGE ? TUTOR_MOVES_PER_PAGE : count - skip;
        next = TRUE;
    }

    ctx->data[0] = destVarID;

    StringTemplate **template = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_STR_TEMPLATE);
    FieldMenuManager **menu = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_FIELD_MENU_MANAGER);

    *menu = FieldMenuManager_New(fieldSystem, 1, 1, 0, TRUE, FieldSystem_GetVarPointer(fieldSystem, destVarID), *template, FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_WINDOW), ctx->loader);

    for (int i = 0; i < count; i++) {
        u8 index = moves[skip + i];

        StringTemplate_SetMoveName(*template, 0, sFrontierTutorMoves[index].move);
        StringTemplate_SetNumber(*template, 1, sFrontierTutorMoves[index].cost, 2, PADDING_MODE_SPACES, CHARSET_MODE_EN);
        FieldMenuManager_AddMenuEntry(*menu, TUTOR_FORMAT_MOVE, sFrontierTutorMoves[index].move);
    }

    if (next) {
        FieldMenuManager_AddMenuEntry(*menu, TUTOR_FORMAT_NEXT, TUTOR_MENU_NEXT);
    }

    FieldMenuManager_AddMenuEntry(*menu, TUTOR_FORMAT_QUIT, TUTOR_MENU_QUIT);
#ifdef SOVEREIGN_TEST
    gCompleteTestTutor[1] = count + next + 1;
#endif
    FieldMenuManager_ShowSingleColumnMenu(*menu);
    ScriptContext_Pause(ctx, ResumeOnSelection);
    return TRUE;
}
