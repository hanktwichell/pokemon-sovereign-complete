#include "complete_apricorns.h"

#include <nitro.h>

#include "constants/heap.h"
#include "generated/items.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"

#include "bag.h"
#include "field_script_context.h"
#include "heap.h"
#include "inlines.h"
#include "map_object.h"
#include "script_manager.h"
#include "unk_0203D1B8.h"
#include "vars_flags.h"

// Kurt's Apricorn Balls (HeartGold's apricorn_tree_sys.c, scrcmd_apricorn.c and Kurt's commands in
// field/scrcmd_pokemon_misc.c). HeartGold keeps the Apricorns in the Apricorn Box; here they are bag items (the Items
// pocket), and the box is the key item that lets the player pick them, as in HeartGold. Each of the 31 trees gives
// one Apricorn a day: its object's first parameter is its number in sTreeApricorns, and a picked tree's flag
// (COMPLETE_APRICORN_TREE_FLAGS_START) is cleared with the daily flags. Kurt takes all of one kind of Apricorn the
// player picks from the bag, and has as many Balls of its kind the next day (VAR_COMPLETE_KURT_BALL and
// VAR_COMPLETE_KURT_QUANTITY).

#define NUM_APRICORN_TREES 31
#define NUM_APRICORNS      7
#define KURT_MAX_APRICORNS 99

// HeartGold's sTreeApricorns, as items
static const u16 sTreeApricorns[NUM_APRICORN_TREES] = {
    ITEM_BLK_APRICORN, // Route 1
    ITEM_PNK_APRICORN, // Route 2 North
    ITEM_YLW_APRICORN, // Route 8
    ITEM_GRN_APRICORN, // Route 11
    ITEM_BLU_APRICORN, // Route 26
    ITEM_GRN_APRICORN, // Route 29
    ITEM_GRN_APRICORN, // Route 30
    ITEM_PNK_APRICORN, // Route 30
    ITEM_BLK_APRICORN, // Route 31
    ITEM_PNK_APRICORN, // Route 33
    ITEM_BLK_APRICORN, // Route 33
    ITEM_GRN_APRICORN, // Route 35
    ITEM_BLU_APRICORN, // Route 36
    ITEM_RED_APRICORN, // Route 37
    ITEM_BLU_APRICORN, // Route 37
    ITEM_BLK_APRICORN, // Route 37
    ITEM_WHT_APRICORN, // Route 38
    ITEM_GRN_APRICORN, // Route 39
    ITEM_PNK_APRICORN, // Route 42
    ITEM_GRN_APRICORN, // Route 42
    ITEM_YLW_APRICORN, // Route 42
    ITEM_BLK_APRICORN, // Route 43
    ITEM_RED_APRICORN, // Route 44
    ITEM_GRN_APRICORN, // Route 45
    ITEM_GRN_APRICORN, // Route 46
    ITEM_YLW_APRICORN, // Route 46
    ITEM_BLU_APRICORN, // Pewter City
    ITEM_WHT_APRICORN, // Pewter City
    ITEM_RED_APRICORN, // Fuchsia City
    ITEM_YLW_APRICORN, // Violet City
    ITEM_WHT_APRICORN, // Azalea Town
};

// Each Apricorn and the Ball Kurt makes from it
static const u16 sApricornBalls[NUM_APRICORNS][2] = {
    { ITEM_RED_APRICORN, ITEM_LEVEL_BALL },
    { ITEM_YLW_APRICORN, ITEM_MOON_BALL },
    { ITEM_BLU_APRICORN, ITEM_LURE_BALL },
    { ITEM_GRN_APRICORN, ITEM_FRIEND_BALL },
    { ITEM_PNK_APRICORN, ITEM_LOVE_BALL },
    { ITEM_WHT_APRICORN, ITEM_FAST_BALL },
    { ITEM_BLK_APRICORN, ITEM_HEAVY_BALL },
};

static int ApricornTree_Index(FieldSystem *fieldSystem)
{
    MapObject **tree = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_TARGET_OBJECT);

    if (*tree == NULL) {
        return -1;
    }

    int index = MapObject_GetDataAt(*tree, 0);
    return index >= 0 && index < NUM_APRICORN_TREES ? index : -1;
}

// The tree's Apricorn, or ITEM_NONE if it has been picked today.
BOOL CompleteScrCmd_ApricornTree(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    int index = ApricornTree_Index(ctx->fieldSystem);
    VarsFlags *varsFlags = SaveData_GetVarsFlags(ctx->fieldSystem->saveData);

    if (index < 0 || VarsFlags_CheckFlag(varsFlags, COMPLETE_APRICORN_TREE_FLAGS_START + index)) {
        *destVar = ITEM_NONE;
    } else {
        *destVar = sTreeApricorns[index];
    }

    return FALSE;
}

BOOL CompleteScrCmd_ApricornTreePick(ScriptContext *ctx)
{
    int index = ApricornTree_Index(ctx->fieldSystem);

    if (index >= 0) {
        VarsFlags_SetFlag(SaveData_GetVarsFlags(ctx->fieldSystem->saveData), COMPLETE_APRICORN_TREE_FLAGS_START + index);
    }

    return FALSE;
}

// HeartGold's GetTotalApricornCount: every Apricorn the player has.
BOOL CompleteScrCmd_CountApricorns(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    Bag *bag = SaveData_GetBag(ctx->fieldSystem->saveData);
    u32 count = 0;

    for (int i = 0; i < NUM_APRICORNS; i++) {
        count += Bag_GetItemQuantity(bag, sApricornBalls[i][0], HEAP_ID_FIELD2);
    }

    *destVar = count;
    return FALSE;
}

// After OpenItemsBag, in place of HeartGold's Apricorn Box (its 739): if the player picked an Apricorn, Kurt takes
// all of that kind (up to 99) to make into Balls. The bag's choice is read and freed as GetSelectedItem does.
BOOL CompleteScrCmd_KurtTakeApricorns(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    void **bagContext = FieldSystem_GetScriptMemberPtr(fieldSystem, SCRIPT_MANAGER_PARTY_MANAGEMENT_DATA);
    u16 item = ITEM_NONE;

    if (*bagContext != NULL) {
        item = BagContext_GetSelectedItem(*bagContext);
        Heap_Free(*bagContext);
        *bagContext = NULL;
    }

    for (int i = 0; i < NUM_APRICORNS; i++) {
        if (sApricornBalls[i][0] != item) {
            continue;
        }

        Bag *bag = SaveData_GetBag(fieldSystem->saveData);
        u16 quantity = Bag_GetItemQuantity(bag, item, HEAP_ID_FIELD2);

        if (quantity > KURT_MAX_APRICORNS) {
            quantity = KURT_MAX_APRICORNS;
        }

        if (quantity != 0 && Bag_TryRemoveItem(bag, item, quantity, HEAP_ID_FIELD2)) {
            VarsFlags *varsFlags = SaveData_GetVarsFlags(fieldSystem->saveData);

            *VarsFlags_GetVarAddress(varsFlags, VAR_COMPLETE_KURT_BALL) = sApricornBalls[i][1];
            *VarsFlags_GetVarAddress(varsFlags, VAR_COMPLETE_KURT_QUANTITY) = quantity;
        }
    }

    return FALSE;
}

// HeartGold's 735: how many Balls Kurt is making, or 0.
BOOL CompleteScrCmd_KurtBallCount(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = *VarsFlags_GetVarAddress(SaveData_GetVarsFlags(ctx->fieldSystem->saveData), VAR_COMPLETE_KURT_QUANTITY);
    return FALSE;
}

// HeartGold's 737: the Ball Kurt is making.
BOOL CompleteScrCmd_KurtBall(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = *VarsFlags_GetVarAddress(SaveData_GetVarsFlags(ctx->fieldSystem->saveData), VAR_COMPLETE_KURT_BALL);
    return FALSE;
}

// HeartGold's ClearKurtApricorn: the Balls are given.
BOOL CompleteScrCmd_KurtClear(ScriptContext *ctx)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(ctx->fieldSystem->saveData);

    *VarsFlags_GetVarAddress(varsFlags, VAR_COMPLETE_KURT_BALL) = ITEM_NONE;
    *VarsFlags_GetVarAddress(varsFlags, VAR_COMPLETE_KURT_QUANTITY) = 0;
    return FALSE;
}
