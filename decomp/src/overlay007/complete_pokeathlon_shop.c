#include "overlay007/complete_pokeathlon_shop.h"

#include <nitro.h>

#include "constants/field_base_tiles.h"
#include "constants/heap.h"
#include "constants/map_object.h"
#include "generated/items.h"
#include "generated/movement_types.h"
#include "generated/species.h"
#include "generated/text_banks.h"
#include "generated/vars_flags.h"

#include "field/field_system.h"
#include "overlay007/shop_menu.h"

#include "bag.h"
#include "bg_window.h"
#include "complete_follower.h"
#include "complete_pokeathlon.h"
#include "complete_pokeathlon_records.h"
#include "complete_scrcmd.h"
#include "field_script_context.h"
#include "field_system.h"
#include "field_task.h"
#include "font.h"
#include "heap.h"
#include "inlines.h"
#include "location.h"
#include "map_object.h"
#include "message.h"
#include "pokedex.h"
#include "render_window.h"
#include "rtc.h"
#include "save_player.h"
#include "script_manager.h"
#include "sound_playback.h"
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "text.h"
#include "vars_flags.h"

#include "res/text/bank/hgss_msg_0191.h"
#include "res/text/bank/hgss_msg_0277.h"
#include "res/text/bank/hgss_msg_0435.h"
#include "res/text/bank/unk_0543.h"

// Sovereign Complete: the Pokéathlon Dome's prize counters and the Athlete Points commands its scripts use
// (HeartGold's src/scrcmd_mart.c, src/overlay_03/shop_menu.c's Pokéathlon branches and src/overlay_22.c; its points
// box, ov01_021EEC00), its PC's records and its record rooms' screens. In overlay 7, the field's, as Platinum's shop
// is.

typedef struct PokeathlonPrize {
    u16 item;
    u16 price; // Athlete Points
} PokeathlonPrize;

#define PRIZES_PER_DAY 12
#define END            { 0xFFFF, 0 }

// The day's prizes (HeartGold's sPokeathlonPrizeExchangePriceOverrides): Sunday to Saturday, then the same days with
// the National Pokédex
static const PokeathlonPrize sDailyPrizes[14][PRIZES_PER_DAY + 1] = {
    { { ITEM_RED_APRICORN, 200 }, { ITEM_BLU_APRICORN, 200 }, { ITEM_BLK_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_KINGS_ROCK, 3000 }, { ITEM_HEART_SCALE, 1000 }, END },
    { { ITEM_RED_APRICORN, 200 }, { ITEM_BLU_APRICORN, 200 }, { ITEM_GRN_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_MOON_STONE, 3000 }, { ITEM_RARE_CANDY, 2000 }, END },
    { { ITEM_YLW_APRICORN, 200 }, { ITEM_PNK_APRICORN, 200 }, { ITEM_WHT_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_FIRE_STONE, 2500 }, { ITEM_PP_UP, 1000 }, END },
    { { ITEM_BLU_APRICORN, 200 }, { ITEM_PNK_APRICORN, 200 }, { ITEM_BLK_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_WATER_STONE, 2500 }, { ITEM_HEART_SCALE, 1000 }, END },
    { { ITEM_YLW_APRICORN, 200 }, { ITEM_PNK_APRICORN, 200 }, { ITEM_WHT_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_THUNDERSTONE, 2500 }, { ITEM_PP_UP, 1000 }, END },
    { { ITEM_RED_APRICORN, 200 }, { ITEM_YLW_APRICORN, 200 }, { ITEM_GRN_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_METAL_COAT, 2500 }, { ITEM_NUGGET, 500 }, END },
    { { ITEM_GRN_APRICORN, 200 }, { ITEM_WHT_APRICORN, 200 }, { ITEM_BLK_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_LEAF_STONE, 2500 }, { ITEM_RARE_CANDY, 2000 }, END },
    { { ITEM_RED_APRICORN, 200 }, { ITEM_BLU_APRICORN, 200 }, { ITEM_BLK_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_KINGS_ROCK, 3000 }, { ITEM_HEART_SCALE, 1000 }, { ITEM_FULL_RESTORE, 500 }, { ITEM_NUGGET, 500 }, { ITEM_SUN_STONE, 3000 }, { ITEM_FIRE_STONE, 2500 }, { ITEM_SHINY_STONE, 3000 }, { ITEM_DAWN_STONE, 3000 }, END },
    { { ITEM_RED_APRICORN, 200 }, { ITEM_BLU_APRICORN, 200 }, { ITEM_GRN_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_MOON_STONE, 3000 }, { ITEM_RARE_CANDY, 2000 }, { ITEM_FULL_RESTORE, 500 }, { ITEM_KINGS_ROCK, 3000 }, { ITEM_SUN_STONE, 3000 }, { ITEM_WATER_STONE, 2500 }, { ITEM_SHINY_STONE, 3000 }, { ITEM_DUSK_STONE, 3000 }, END },
    { { ITEM_YLW_APRICORN, 200 }, { ITEM_PNK_APRICORN, 200 }, { ITEM_WHT_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_FIRE_STONE, 2500 }, { ITEM_PP_UP, 1000 }, { ITEM_FULL_RESTORE, 500 }, { ITEM_METAL_COAT, 2500 }, { ITEM_WATER_STONE, 2500 }, { ITEM_LEAF_STONE, 2500 }, { ITEM_DUSK_STONE, 3000 }, { ITEM_DAWN_STONE, 3000 }, END },
    { { ITEM_BLU_APRICORN, 200 }, { ITEM_PNK_APRICORN, 200 }, { ITEM_BLK_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_WATER_STONE, 2500 }, { ITEM_HEART_SCALE, 1000 }, { ITEM_FULL_RESTORE, 500 }, { ITEM_DRAGON_SCALE, 2500 }, { ITEM_THUNDERSTONE, 2500 }, { ITEM_MOON_STONE, 3000 }, { ITEM_SHINY_STONE, 3000 }, { ITEM_DAWN_STONE, 3000 }, END },
    { { ITEM_YLW_APRICORN, 200 }, { ITEM_PNK_APRICORN, 200 }, { ITEM_WHT_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_THUNDERSTONE, 2500 }, { ITEM_PP_UP, 1000 }, { ITEM_FULL_RESTORE, 500 }, { ITEM_KINGS_ROCK, 3000 }, { ITEM_FIRE_STONE, 2500 }, { ITEM_LEAF_STONE, 2500 }, { ITEM_SHINY_STONE, 3000 }, { ITEM_DUSK_STONE, 3000 }, END },
    { { ITEM_RED_APRICORN, 200 }, { ITEM_YLW_APRICORN, 200 }, { ITEM_GRN_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_METAL_COAT, 2500 }, { ITEM_NUGGET, 500 }, { ITEM_FULL_RESTORE, 500 }, { ITEM_DRAGON_SCALE, 2500 }, { ITEM_WATER_STONE, 2500 }, { ITEM_SUN_STONE, 3000 }, { ITEM_DUSK_STONE, 3000 }, { ITEM_DAWN_STONE, 3000 }, END },
    { { ITEM_GRN_APRICORN, 200 }, { ITEM_WHT_APRICORN, 200 }, { ITEM_BLK_APRICORN, 200 }, { ITEM_MOOMOO_MILK, 100 }, { ITEM_LEAF_STONE, 2500 }, { ITEM_RARE_CANDY, 2000 }, { ITEM_FULL_RESTORE, 500 }, { ITEM_METAL_COAT, 2500 }, { ITEM_THUNDERSTONE, 2500 }, { ITEM_SHINY_STONE, 3000 }, { ITEM_DUSK_STONE, 3000 }, { ITEM_DAWN_STONE, 3000 }, END },
};

// The data cards, six at a time (HeartGold's _0210F9D4): the counter shows the set the first card not bought is in
static const PokeathlonPrize sDataCards[5][7] = {
    { { ITEM_DATA_CARD_01, 500 }, { ITEM_DATA_CARD_02, 500 }, { ITEM_DATA_CARD_03, 1000 }, { ITEM_DATA_CARD_04, 1000 }, { ITEM_DATA_CARD_05, 500 }, { ITEM_DATA_CARD_06, 500 }, END },
    { { ITEM_DATA_CARD_07, 1000 }, { ITEM_DATA_CARD_08, 1000 }, { ITEM_DATA_CARD_09, 1000 }, { ITEM_DATA_CARD_10, 1000 }, { ITEM_DATA_CARD_11, 1000 }, { ITEM_DATA_CARD_12, 1000 }, END },
    { { ITEM_DATA_CARD_13, 1500 }, { ITEM_DATA_CARD_14, 1500 }, { ITEM_DATA_CARD_15, 1500 }, { ITEM_DATA_CARD_16, 1000 }, { ITEM_DATA_CARD_17, 1000 }, { ITEM_DATA_CARD_18, 1000 }, END },
    { { ITEM_DATA_CARD_19, 500 }, { ITEM_DATA_CARD_20, 500 }, { ITEM_DATA_CARD_21, 2000 }, { ITEM_DATA_CARD_22, 2000 }, { ITEM_DATA_CARD_23, 1000 }, { ITEM_DATA_CARD_24, 1000 }, END },
    { { ITEM_DATA_CARD_25, 2000 }, { ITEM_DATA_CARD_26, 3000 }, { ITEM_DATA_CARD_27, 9999 }, END },
};

static const PokeathlonPrize *TodaysPrizes(SaveData *saveData)
{
    RTCDate date;

    GetCurrentDate(&date);
    return sDailyPrizes[date.week + (Pokedex_IsNationalDexObtained(SaveData_GetPokedex(saveData)) ? 7 : 0)];
}

// The first data card not bought (27 with all of them)
static int DataCardsBought(const CompletePokeathlonSave *pokeathlon)
{
    int i;

    for (i = 0; i < COMPLETE_POKEATHLON_DATA_CARDS; i++) {
        if (!CompletePokeathlon_CheckReceivedDataCard(pokeathlon, i)) {
            break;
        }
    }

    return i;
}

static void StartCounter(ScriptContext *ctx, const PokeathlonPrize *prizes, enum CompletePokeathlonCounter counter)
{
    u16 items[PRIZES_PER_DAY + 1], prices[PRIZES_PER_DAY + 1];
    int i;

    for (i = 0; prizes[i].item != 0xFFFF; i++) {
        items[i] = prizes[i].item;
        prices[i] = prizes[i].price;
    }

    items[i] = SHOP_ITEM_END;
    Shop_StartCompletePokeathlon(ctx->task, ctx->fieldSystem, items, prices, counter);
}

// HeartGold's ScrCmd_771: the day's prizes
BOOL CompleteScrCmd_PokeathlonPrizeCounter(ScriptContext *ctx)
{
    StartCounter(ctx, TodaysPrizes(ctx->fieldSystem->saveData), COMPLETE_POKEATHLON_COUNTER_PRIZES);
    return TRUE;
}

// HeartGold's ScrCmd_772: the data cards, from the set the first one not bought is in
BOOL CompleteScrCmd_PokeathlonDataCardCounter(ScriptContext *ctx)
{
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(ctx->fieldSystem->saveData, HEAP_ID_FIELD2);
    int bought = DataCardsBought(pokeathlon);

    Heap_Free(pokeathlon);
    StartCounter(ctx, sDataCards[(bought < COMPLETE_POKEATHLON_DATA_CARDS ? bought : COMPLETE_POKEATHLON_DATA_CARDS - 1) / 6], COMPLETE_POKEATHLON_COUNTER_DATA_CARDS);
    return TRUE;
}

// HeartGold's ScrCmd_834: TRUE while some of the day's prizes are still to be bought
BOOL CompleteScrCmd_PokeathlonPrizesLeft(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    const PokeathlonPrize *prizes = TodaysPrizes(ctx->fieldSystem->saveData);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(ctx->fieldSystem->saveData, HEAP_ID_FIELD2);
    int count = 0, bought = 0;

    for (int i = 0; i < PRIZES_PER_DAY; i++) {
        if (prizes[i].item == 0xFFFF) {
            break;
        }

        count++;
    }

    for (int i = 0; i < PRIZES_PER_DAY; i++) {
        if (CompletePokeathlon_CheckReceivedDailyItemSlot(pokeathlon, i)) {
            bought++;
        }
    }

    Heap_Free(pokeathlon);
    *destVar = count > bought;
    return FALSE;
}

// HeartGold's ScrCmd_835: how many data cards in a row were bought (27 with all of them)
BOOL CompleteScrCmd_PokeathlonDataCardsBought(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(ctx->fieldSystem->saveData, HEAP_ID_FIELD2);

    *destVar = DataCardsBought(pokeathlon);
    Heap_Free(pokeathlon);
    return FALSE;
}

static u16 CapU16(u32 value)
{
    return value > 0xFFFF ? 0xFFFF : value;
}

// HeartGold's ScrCmd_724: one of the Dome's running totals (0-9 the events' and 10-17 its others, among them 11 the
// points earned in all), to 65535
BOOL CompleteScrCmd_PokeathlonGetTotal(ScriptContext *ctx)
{
    u8 which = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(ctx->fieldSystem->saveData, HEAP_ID_FIELD2);
    const CompletePokeathlonTotals *totals = &pokeathlon->totals;

    if (which <= 9) {
        *destVar = CapU16(totals->unk44[which]);
    } else {
        switch (which - 10) {
        case 0:
            *destVar = CapU16(totals->unk8);
            break;
        case 1:
            *destVar = CapU16(totals->unk70);
            break;
        case 2:
            *destVar = CapU16(totals->unk4);
            break;
        case 3:
            *destVar = CapU16(totals->unk14);
            break;
        case 4:
            *destVar = CapU16(totals->unk1C);
            break;
        case 5:
            *destVar = CapU16(totals->unk24);
            break;
        case 6:
            *destVar = CapU16(totals->unk2C);
            break;
        case 7:
            *destVar = CapU16(totals->unk30);
            break;
        default:
            *destVar = 0;
            break;
        }
    }

    Heap_Free(pokeathlon);
    return FALSE;
}

// HeartGold's ScrCmd_725: raises (0) or lowers (1) the points earned in all, between 0 and 65535 (the reception's gifts)
BOOL CompleteScrCmd_PokeathlonChangeTotalPoints(ScriptContext *ctx)
{
    u8 lower = ScriptContext_ReadByte(ctx);
    u32 amount = ScriptContext_GetVar(ctx);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(ctx->fieldSystem->saveData, HEAP_ID_FIELD2);
    s32 value = lower ? (s32)pokeathlon->totals.unk70 - (s32)amount : (s32)(pokeathlon->totals.unk70 + amount);

    pokeathlon->totals.unk70 = value < 0 ? 0 : CapU16(value);
    CompletePokeathlon_Store(ctx->fieldSystem->saveData, pokeathlon);
    Heap_Free(pokeathlon);
    return FALSE;
}

static void ChangeAthletePoints(ScriptContext *ctx, BOOL take)
{
    u16 amount = ScriptContext_GetVar(ctx);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(ctx->fieldSystem->saveData, HEAP_ID_FIELD2);

    if (take) {
        CompletePokeathlon_SubAthletePoints(pokeathlon, amount);
    } else {
        CompletePokeathlon_AddAthletePoints(pokeathlon, amount);
    }

    CompletePokeathlon_Store(ctx->fieldSystem->saveData, pokeathlon);
    Heap_Free(pokeathlon);
}

// HeartGold's GiveAthletePoints, TakeAthletePoints and CheckAthletePoints
BOOL CompleteScrCmd_GiveAthletePoints(ScriptContext *ctx)
{
    ChangeAthletePoints(ctx, FALSE);
    return FALSE;
}

BOOL CompleteScrCmd_TakeAthletePoints(ScriptContext *ctx)
{
    ChangeAthletePoints(ctx, TRUE);
    return FALSE;
}

BOOL CompleteScrCmd_CheckAthletePoints(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u16 amount = ScriptContext_GetVar(ctx);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(ctx->fieldSystem->saveData, HEAP_ID_FIELD2);

    *destVar = CompletePokeathlon_GetAthletePoints(pokeathlon) >= amount;
    Heap_Free(pokeathlon);
    return FALSE;
}

// HeartGold's points box for the Athlete Points (its ScrCmd_116 2, 117 and 118 2: ov01_021EEC00), in the window slot
// Platinum's coins and Battle Points boxes share: ten tiles by two, "{n}P"
#define POINTS_BOX_WIDTH  10
#define POINTS_BOX_HEIGHT 2

static void PrintAthletePoints(FieldSystem *fieldSystem, Window *window)
{
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_PRELOAD_ENTIRE_BANK, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0191, HEAP_ID_FIELD1);
    StringTemplate *template = StringTemplate_Default(HEAP_ID_FIELD1);
    String *string = String_Init(16, HEAP_ID_FIELD1);
    String *format = MessageLoader_GetNewString(loader, msg_0191_00223);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(fieldSystem->saveData, HEAP_ID_FIELD1);

    Window_FillTilemap(window, 15);
    StringTemplate_SetNumber(template, 0, CompletePokeathlon_GetAthletePoints(pokeathlon), 5, PADDING_MODE_SPACES, CHARSET_MODE_EN);
    StringTemplate_Format(template, string, format);
    Text_AddPrinterWithParams(window, FONT_SYSTEM, string, POINTS_BOX_WIDTH * 8 - Font_CalcStringWidth(FONT_SYSTEM, string, 0), 0, TEXT_SPEED_NO_TRANSFER, NULL);
    Window_ScheduleCopyToVRAM(window);

    Heap_Free(pokeathlon);
    String_Free(format);
    String_Free(string);
    StringTemplate_Free(template);
    MessageLoader_Free(loader);
}

BOOL CompleteScrCmd_ShowAthletePoints(ScriptContext *ctx)
{
    u16 tilemapLeft = ScriptContext_GetVar(ctx);
    u16 tilemapTop = ScriptContext_GetVar(ctx);
    Window **slot = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_SPECIAL_CURRENCY_WINDOW);
    Window *window = Window_New(HEAP_ID_FIELD1, 1);

    Window_Add(ctx->fieldSystem->bgConfig, window, BG_LAYER_MAIN_3, tilemapLeft, tilemapTop, POINTS_BOX_WIDTH, POINTS_BOX_HEIGHT, 13, 1 + 10 * 4);
    LoadStandardWindowGraphics(ctx->fieldSystem->bgConfig, BG_LAYER_MAIN_3, BASE_TILE_STANDARD_WINDOW_FRAME, 11, STANDARD_WINDOW_SYSTEM, HEAP_ID_FIELD1);
    Window_DrawStandardFrame(window, TRUE, BASE_TILE_STANDARD_WINDOW_FRAME, 11);
    PrintAthletePoints(ctx->fieldSystem, window);
    *slot = window;
    return FALSE;
}

BOOL CompleteScrCmd_HideAthletePoints(ScriptContext *ctx)
{
    Window **slot = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_SPECIAL_CURRENCY_WINDOW);

    Window_EraseStandardFrame(*slot, FALSE);
    Windows_Delete(*slot, 1);
    *slot = NULL;
    return FALSE;
}

BOOL CompleteScrCmd_UpdateAthletePoints(ScriptContext *ctx)
{
    Window **slot = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_SPECIAL_CURRENCY_WINDOW);

    PrintAthletePoints(ctx->fieldSystem, *slot);
    return FALSE;
}

// HeartGold's Pokéathlon data (ScrCmd_743, its overlay 3's pokeathlon_records.c): the records the Dome's PC shows, a
// page each (0 the Pokéathlon's, 1 the events', 2 the Pokémon's actions), a line each, the ones a data card unlocks
// shown only once it's bought ("???" before), in a window over the field until A, B or a touch
typedef struct PokeathlonRecords {
    Window window;
    u8 page;
    u8 state;
} PokeathlonRecords;

// Each line's data card (+1; 0 for a line always shown), the pages' ten lines in a row
static const u8 sRecordCards[30] = {
    0, 1, 2, 25, 21, 22, 0, 19, 20, 27,
    5, 7, 18, 8, 9, 17, 6, 16, 10, 24,
    26, 3, 4, 14, 23, 13, 11, 12, 15, 0
};

static const u8 sRecordLines[3] = { 10, 10, 9 };

// HeartGold's ov03_02259070: the line's record
static u32 RecordValue(const CompletePokeathlonTotals *totals, int line)
{
    if (line >= 10 && line <= 19) {
        return totals->unk44[line - 10];
    }

    switch (line) {
    case 0:
        return totals->unk4;
    case 1:
        return totals->unk8;
    case 2:
        return totals->unkC;
    case 3:
        return totals->unk10;
    case 4: {
        u32 sum = 0;

        for (int i = 0; i < 10; i++) {
            sum += totals->unk44[i];
        }

        return sum;
    }
    case 5:
        return totals->unk6C;
    case 6:
        return totals->unk38;
    case 7:
        return totals->unk3C;
    case 8:
        return totals->unk40;
    case 9:
        return totals->unk0;
    case 20:
        return totals->unk14;
    case 21:
        return totals->unk2C;
    case 22:
        return totals->unk1C;
    case 23:
        return totals->unk24;
    case 24:
        return totals->unk30;
    case 25:
        return totals->unk34;
    case 26:
        return totals->unk20;
    case 27:
        return totals->unk18;
    case 28:
        return totals->unk28;
    default:
        return 0;
    }
}

static void DrawRecords(FieldSystem *fieldSystem, PokeathlonRecords *records)
{
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_PRELOAD_ENTIRE_BANK, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0277, HEAP_ID_FIELD1);
    StringTemplate *template = StringTemplate_New(3, 16, HEAP_ID_FIELD1);
    String *string = String_Init(128, HEAP_ID_FIELD1);
    String *format = MessageLoader_GetNewString(loader, msg_0277_00002);
    String *unknown = MessageLoader_GetNewString(loader, msg_0277_00003);
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(fieldSystem->saveData, HEAP_ID_FIELD1);

    Window_Add(fieldSystem->bgConfig, &records->window, BG_LAYER_MAIN_3, 2, 1, 28, 22, 13, 1);
    LoadStandardWindowGraphics(fieldSystem->bgConfig, BG_LAYER_MAIN_3, BASE_TILE_STANDARD_WINDOW_FRAME, 11, STANDARD_WINDOW_SYSTEM, HEAP_ID_FIELD1);
    Window_DrawStandardFrame(&records->window, TRUE, BASE_TILE_STANDARD_WINDOW_FRAME, 11);
    Window_FillTilemap(&records->window, 15);

    for (int i = 0; i < sRecordLines[records->page]; i++) {
        int line = records->page * 10 + i;
        int y = 8 + 16 * i;
        u8 card = sRecordCards[line];

        if (card != 0 && !CompletePokeathlon_CheckReceivedDataCard(pokeathlon, card - 1)) {
            Text_AddPrinterWithParamsAndColor(&records->window, FONT_SYSTEM, unknown, 8, y, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(1, 2, 15), NULL);
            continue;
        }

        MessageLoader_GetString(loader, msg_0277_00004 + line, string);
        Text_AddPrinterWithParamsAndColor(&records->window, FONT_SYSTEM, string, 8, y, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(1, 2, 15), NULL);

        u32 value = RecordValue(&pokeathlon->totals, line);

        if (value > 9999999) {
            value = 9999999;
        }

        if (line == 9) { // the time spent, in minutes and seconds
            u32 minutes = value / 60;

            StringTemplate_SetNumber(template, 0, minutes > 999 ? 999 : minutes, 3, PADDING_MODE_SPACES, CHARSET_MODE_EN);
            StringTemplate_SetNumber(template, 1, value % 60, 2, PADDING_MODE_ZEROES, CHARSET_MODE_EN);
            StringTemplate_Format(template, string, format);
        } else {
            String_FormatInt(string, value, 7, PADDING_MODE_SPACES, CHARSET_MODE_EN);
        }

        Text_AddPrinterWithParamsAndColor(&records->window, FONT_SYSTEM, string, 224 - Font_CalcStringWidth(FONT_SYSTEM, string, 0) - 8, y, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(1, 2, 15), NULL);
    }

    Window_ScheduleCopyToVRAM(&records->window);
    Bg_ScheduleTilemapTransfer(fieldSystem->bgConfig, BG_LAYER_MAIN_3);

    Heap_Free(pokeathlon);
    String_Free(unknown);
    String_Free(format);
    String_Free(string);
    StringTemplate_Free(template);
    MessageLoader_Free(loader);
}

static BOOL FieldTask_PokeathlonRecords(FieldTask *task)
{
    FieldSystem *fieldSystem = FieldTask_GetFieldSystem(task);
    PokeathlonRecords *records = FieldTask_GetEnv(task);

    switch (records->state) {
    case 0:
        DrawRecords(fieldSystem, records);
        records->state++;
        break;
    case 1:
        if (gSystem.touchPressed || JOY_NEW(PAD_BUTTON_A | PAD_BUTTON_B)) {
            Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
            Window_EraseStandardFrame(&records->window, FALSE);
            Window_ClearAndCopyToVRAM(&records->window);
            Window_Remove(&records->window);
            Bg_ScheduleTilemapTransfer(fieldSystem->bgConfig, BG_LAYER_MAIN_3);
            Heap_Free(records);
            return TRUE;
        }
        break;
    }

    return FALSE;
}

BOOL CompleteScrCmd_PokeathlonRecords(ScriptContext *ctx)
{
    PokeathlonRecords *records = Heap_Alloc(HEAP_ID_FIELD2, sizeof(PokeathlonRecords));
    u16 page = ScriptContext_GetVar(ctx);

    records->page = page < 3 ? page : 0;
    records->state = 0;
    FieldTask_InitCall(ctx->task, FieldTask_PokeathlonRecords, records);
    return TRUE;
}

// HeartGold's ScrCmd_712: a Dome record room's screen (enum CompletePokeathlonRecordScreen), after the script's fade
// (ReturnToField brings the field back), as the Voltorb Flip and Alph puzzle commands open theirs. The wait that frees
// the arguments is in the main module: this overlay goes with the field's map as the screen opens. Another number leaves
// the field as it is (ReturnToField finds it running and returns).
BOOL CompleteScrCmd_PokeathlonRecordScreen(ScriptContext *ctx)
{
    FS_EXTERN_OVERLAY(complete_pokeathlon_records);

    static const ApplicationManagerTemplate sTemplates[] = {
        [COMPLETE_POKEATHLON_SCREEN_COURSE_RECORD] = {
            CompletePokeathlonCourseRecord_Init,
            CompletePokeathlonCourseRecord_Main,
            CompletePokeathlonCourseRecord_Exit,
            FS_OVERLAY_ID(complete_pokeathlon_records),
        },
        [COMPLETE_POKEATHLON_SCREEN_MEDALS] = {
            CompletePokeathlonMedals_Init,
            CompletePokeathlonMedals_Main,
            CompletePokeathlonMedals_Exit,
            FS_OVERLAY_ID(complete_pokeathlon_records),
        },
        [COMPLETE_POKEATHLON_SCREEN_EVENT_RECORD] = {
            CompletePokeathlonEventRecord_Init,
            CompletePokeathlonEventRecord_Main,
            CompletePokeathlonEventRecord_Exit,
            FS_OVERLAY_ID(complete_pokeathlon_records),
        },
        [COMPLETE_POKEATHLON_SCREEN_TROPHIES] = {
            CompletePokeathlonTrophies_Init,
            CompletePokeathlonTrophies_Main,
            CompletePokeathlonTrophies_Exit,
            FS_OVERLAY_ID(complete_pokeathlon_records),
        },
    };
    u8 screen = ScriptContext_ReadByte(ctx);

    if (screen >= NELEMS(sTemplates)) {
        return FALSE;
    }

    SaveData *saveData = ctx->fieldSystem->saveData;
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);
    void **args = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_PARTY_MANAGEMENT_DATA);
    CompletePokeathlonRecordArgs *recordArgs = Heap_Alloc(HEAP_ID_FIELD3, sizeof(CompletePokeathlonRecordArgs));

    recordArgs->saveData = saveData;
    recordArgs->trophyGoals = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_UNK_0EF) && VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_UNK_0F0) && VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_UNK_0F1);
    *args = recordArgs;
    FieldSystem_StartChildProcess(ctx->fieldSystem, &sTemplates[screen], recordArgs);
    ScriptContext_Pause(ctx, CompleteScript_WaitApplicationDestroyArgs);
    return TRUE;
}

// HeartGold's CreatePokeathlonFriendshipRoomStatues (its scrcmd_pokemon_misc.c): the Friendship Room's three statues,
// the Pokémon of the save's friendship records, each as its walking sprite (HeartGold's follow-mon sprite, never
// shiny), facing south and still, at (4, 10), (7, 5) and (10, 10), with local IDs 0xF6 to 0xF8. Any made before go
// first. HeartGold leaves out species past Arceus; Complete leaves out those with no walking sprite (the same ones).
#define STATUE_FIRST_LOCALID 0xF6

static const u8 sStatuePositions[3][2] = {
    { 4, 10 },
    { 7, 5 },
    { 10, 10 },
};

BOOL CompleteScrCmd_PokeathlonStatues(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(fieldSystem->saveData, HEAP_ID_FIELD2);

#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonStatues[0]++;
#endif

    for (int i = 0; i < 3; i++) {
        MapObject *statue = MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, STATUE_FIRST_LOCALID + i);
        const CompletePokeathlonStatue *record = &pokeathlon->friendshipRoomStatues[i];

        if (statue != NULL) {
            MapObject_Delete(statue);
        }

#ifdef SOVEREIGN_TEST
        gCompleteTestPokeathlonStatues[1 + i] = 0;
#endif

        if (record->species == SPECIES_NONE) {
            continue;
        }

        int gfx = CompleteFollower_MonGfx(record->species, record->form, record->gender, FALSE);

        if (gfx < 0) {
            continue;
        }

        statue = MapObjectMan_AddMapObject(fieldSystem->mapObjMan, sStatuePositions[i][0], sStatuePositions[i][1], DIR_SOUTH, gfx, MOVEMENT_TYPE_NONE, fieldSystem->location->mapHeaderID);

        if (statue != NULL) {
            MapObject_SetLocalID(statue, STATUE_FIRST_LOCALID + i);
#ifdef SOVEREIGN_TEST
            gCompleteTestPokeathlonStatues[1 + i] = gfx;
#endif
        }
    }

    Heap_Free(pokeathlon);
    return FALSE;
}

// The shop's side (src/overlay007/shop_menu.c's marked hooks)

void CompletePokeathlonShop_Init(ShopMenu *shopMenu, const u16 *prices, enum CompletePokeathlonCounter counter)
{
    shopMenu->completeCounter = counter;
    shopMenu->completePokeathlon = CompletePokeathlon_Load(shopMenu->saveData, HEAP_ID_FIELD2);
    shopMenu->completePrices = Heap_Alloc(HEAP_ID_FIELD2, shopMenu->itemsCount * sizeof(u16));
    shopMenu->completeMsgLoader = MessageLoader_Init(MSG_LOADER_PRELOAD_ENTIRE_BANK, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0435, HEAP_ID_FIELD2);

    for (int i = 0; i < shopMenu->itemsCount; i++) {
        shopMenu->completePrices[i] = prices[i];
    }
}

void CompletePokeathlonShop_Free(ShopMenu *shopMenu)
{
    if (shopMenu->completeCounter != COMPLETE_POKEATHLON_COUNTER_NONE) {
        MessageLoader_Free(shopMenu->completeMsgLoader);
        Heap_Free(shopMenu->completePrices);
        Heap_Free(shopMenu->completePokeathlon);
    }
}

// The item's place in the list: the day's prizes are marked bought by their place, as HeartGold's are
static int ItemSlot(ShopMenu *shopMenu, u16 item)
{
    for (int i = 0; i < shopMenu->itemsCount; i++) {
        if (shopMenu->itemsPtr[i] == item) {
            return i;
        }
    }

    return 0;
}

u32 CompletePokeathlonShop_Price(ShopMenu *shopMenu, u16 item)
{
    return shopMenu->completePrices[ItemSlot(shopMenu, item)];
}

u32 CompletePokeathlonShop_Points(ShopMenu *shopMenu)
{
    return CompletePokeathlon_GetAthletePoints(shopMenu->completePokeathlon);
}

// After the item's been given (CompletePokeathlonShop_Buy): the points and the purchase go to the working copy together
void CompletePokeathlonShop_TakePoints(ShopMenu *shopMenu, u32 amount)
{
    CompletePokeathlon_SubAthletePoints(shopMenu->completePokeathlon, amount);
    CompletePokeathlon_Store(shopMenu->saveData, shopMenu->completePokeathlon);
}

// HeartGold's MartData_BuyMenu_CheckCanPurchaseItem: a prize already bought today, a data card already bought, or too
// few points
String *CompletePokeathlonShop_Refusal(ShopMenu *shopMenu, u32 points)
{
    u32 textID;

    if (shopMenu->completeCounter == COMPLETE_POKEATHLON_COUNTER_PRIZES
        && CompletePokeathlon_CheckReceivedDailyItemSlot(shopMenu->completePokeathlon, ItemSlot(shopMenu, shopMenu->itemId))) {
        textID = msg_0435_00025;
    } else if (shopMenu->completeCounter == COMPLETE_POKEATHLON_COUNTER_DATA_CARDS
        && CompletePokeathlon_CheckReceivedDataCard(shopMenu->completePokeathlon, shopMenu->itemId - ITEM_DATA_CARD_01)) {
        textID = msg_0435_00026;
    } else if (points < shopMenu->itemPrice) {
        textID = msg_0435_00048;
    } else {
        return NULL;
    }

#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlon[4] = textID;
#endif
    return MessageLoader_GetNewString(shopMenu->completeMsgLoader, textID);
}

// A data card is a record, not an item in the bag
BOOL CompletePokeathlonShop_CanFit(ShopMenu *shopMenu)
{
    return shopMenu->completeCounter == COMPLETE_POKEATHLON_COUNTER_DATA_CARDS
        || Bag_CanFitItem(shopMenu->destInventory, shopMenu->itemId, shopMenu->itemAmount, HEAP_ID_FIELD2);
}

// HeartGold's MartData_PerformTransaction
void CompletePokeathlonShop_Buy(ShopMenu *shopMenu)
{
    if (shopMenu->completeCounter == COMPLETE_POKEATHLON_COUNTER_PRIZES) {
        Bag_TryAddItem(shopMenu->destInventory, shopMenu->itemId, shopMenu->itemAmount, HEAP_ID_FIELD2);
        CompletePokeathlon_SetReceivedDailyItemSlot(shopMenu->completePokeathlon, ItemSlot(shopMenu, shopMenu->itemId));
    } else {
        CompletePokeathlon_SetReceivedDataCard(shopMenu->completePokeathlon, shopMenu->itemId - ITEM_DATA_CARD_01);
    }

#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlon[5]++;
#endif
}

// HeartGold's texts in place of the shop's: Athlete Points for money, one of an item, and a data card's purchase
String *CompletePokeathlonShop_String(ShopMenu *shopMenu, u32 shopTextID)
{
    u32 textID;

    switch (shopMenu->completeCounter == COMPLETE_POKEATHLON_COUNTER_NONE ? 0xFFFF : shopTextID) {
    case pl_msg_00000543_00009: // an item's price
    case pl_msg_00000543_00019: // the points
        textID = msg_0435_00032;
        break;
    case pl_msg_00000543_00018: // "Money"
        textID = msg_0435_00033;
        break;
    case pl_msg_00000543_00005: // the purchase's question
        textID = msg_0435_00046;
        break;
    case pl_msg_00000543_00006: // the purchase
        if (shopMenu->completeCounter == COMPLETE_POKEATHLON_COUNTER_DATA_CARDS) {
            textID = msg_0435_00049;
            break;
        }
        // fall through
    default:
        return MessageLoader_GetNewString(shopMenu->msgLoader, shopTextID);
    }

    return MessageLoader_GetNewString(shopMenu->completeMsgLoader, textID);
}
