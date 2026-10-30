#include <nitro.h>

#include "constants/field_base_tiles.h"
#include "constants/graphics.h"
#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/string.h"
#include "generated/text_banks.h"

#include "field/field_system.h"

#include "bg_window.h"
#include "complete_phone.h"
#include "field_script_context.h"
#include "font.h"
#include "heap.h"
#include "inlines.h"
#include "message.h"
#include "render_window.h"
#include "save_player.h"
#include "sound_playback.h"
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "text.h"
#include "trainer_info.h"

// Sovereign Complete: Mom's savings (include/complete_phone.h): what she bought with them, which the Poké Marts'
// deliveryman hands over (res/field/scripts/scripts_mystery_gift_deliveryman.s), and her bank at home in New Bark
// Town. HeartGold takes the amount on the touch screen's number pad; here it's a window: up and down change the digit
// under the cursor, left and right move it, A confirms and B gives up.

// HeartGold's savings box: the savings, then the wallet. Its tiles, and the amount window's, are under the map name's
// (src/overlay005/map_name_popup.c), past the field's menus (src/overlay005/field_menu.c)
#define SAVINGS_BOX_LEFT       17
#define SAVINGS_BOX_TOP        1
#define SAVINGS_BOX_WIDTH      14
#define SAVINGS_BOX_HEIGHT     8
#define AMOUNT_WINDOW_LEFT     22
#define AMOUNT_WINDOW_TOP      11
#define AMOUNT_WINDOW_WIDTH    9
#define AMOUNT_WINDOW_HEIGHT   2
#define BASE_TILE_AMOUNT       (BASE_TILE_MESSAGE_WINDOW - 32 * 5 - AMOUNT_WINDOW_WIDTH * AMOUNT_WINDOW_HEIGHT)
#define BASE_TILE_SAVINGS_BOX  (BASE_TILE_AMOUNT - SAVINGS_BOX_WIDTH * SAVINGS_BOX_HEIGHT)
#define AMOUNT_DIGITS          6
#define AMOUNT_DIGIT_WIDTH     8
#define AMOUNT_TEXT_YEN        332 // msg_0191: ${STRVAR_1 55, 0, 0}
#define SAVINGS_TEXT_DEPOSITED 330 // msg_0191: DEPOSITED MONEY
#define SAVINGS_TEXT_HELD      331 // msg_0191: HELD MONEY

enum BankMode {
    BANK_DEPOSIT = 0, // HeartGold's BankTransaction's modes
    BANK_WITHDRAW,
};

typedef struct MomsBank {
    Window window;
    u32 amount;
    u32 max;
    u16 *destVar;
    u8 mode;
    u8 digit; // 0: the highest
} MomsBank;

static Window *sSavingsBox;
static MomsBank *sMomsBank;

static const u32 sDigitValues[AMOUNT_DIGITS] = { 100000, 10000, 1000, 100, 10, 1 };

// CompleteMomGiftCheck destVar: whether Mom bought something the deliveryman has (HeartGold's MomGiftCheck)
BOOL CompleteScrCmd_MomGiftCheck(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = SaveData_GetCompletePhone(ctx->fieldSystem->saveData)->momGiftQueue[0][1] != 0;
    return FALSE;
}

// CompleteMomGiftPeek itemVar, quantityVar: the next thing she bought (HeartGold's ScrCmd_811)
BOOL CompleteScrCmd_MomGiftPeek(ScriptContext *ctx)
{
    u16 *itemVar = ScriptContext_GetVarPointer(ctx);
    u16 *quantityVar = ScriptContext_GetVarPointer(ctx);
    CompletePhoneSave *phone = SaveData_GetCompletePhone(ctx->fieldSystem->saveData);

    *itemVar = phone->momGiftQueue[0][0];
    *quantityVar = phone->momGiftQueue[0][1];
    return FALSE;
}

// CompleteMomGiftTake: the deliveryman handed it over (HeartGold's ScrCmd_812)
BOOL CompleteScrCmd_MomGiftTake(ScriptContext *ctx)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(ctx->fieldSystem->saveData);

    for (int i = 0; i < MOM_GIFT_QUEUE_SIZE - 1; i++) {
        phone->momGiftQueue[i][0] = phone->momGiftQueue[i + 1][0];
        phone->momGiftQueue[i][1] = phone->momGiftQueue[i + 1][1];
    }

    phone->momGiftQueue[MOM_GIFT_QUEUE_SIZE - 1][0] = 0;
    phone->momGiftQueue[MOM_GIFT_QUEUE_SIZE - 1][1] = 0;
    return FALSE;
}

// CompleteBankCheckBalance destVar, amount: whether Mom has saved that much (HeartGold's CheckBankBalance)
BOOL CompleteScrCmd_BankCheckBalance(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    u32 amount = ScriptContext_ReadWord(ctx);

    *destVar = SaveData_GetCompletePhone(ctx->fieldSystem->saveData)->momsSavings >= amount;
    return FALSE;
}

// CompleteBankOrWalletIsFull which, destVar: 0, whether the savings are full; 1, the wallet (HeartGold's
// BankOrWalletIsFull)
BOOL CompleteScrCmd_BankOrWalletIsFull(ScriptContext *ctx)
{
    u16 which = ScriptContext_ReadHalfWord(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    SaveData *saveData = ctx->fieldSystem->saveData;

    if (which == 0) {
        *destVar = SaveData_GetCompletePhone(saveData)->momsSavings >= MOMS_SAVINGS_MAX;
    } else {
        *destVar = TrainerInfo_Money(SaveData_GetTrainerInfo(saveData)) >= MOMS_SAVINGS_MAX;
    }

    return FALSE;
}

static void PrintText(Window *window, MessageLoader *loader, u32 entry, u32 x, u32 y)
{
    String *string = MessageLoader_GetNewString(loader, entry);

    Text_AddPrinterWithParams(window, FONT_SYSTEM, string, x, y, TEXT_SPEED_NO_TRANSFER, NULL);
    String_Free(string);
}

static void PrintMoney(Window *window, MessageLoader *loader, u32 amount, u32 y)
{
    StringTemplate *template = StringTemplate_Default(HEAP_ID_FIELD1);
    String *format = MessageLoader_GetNewString(loader, AMOUNT_TEXT_YEN);
    String *string = String_Init(16, HEAP_ID_FIELD1);

    StringTemplate_SetNumber(template, 0, amount, AMOUNT_DIGITS, PADDING_MODE_SPACES, CHARSET_MODE_EN);
    StringTemplate_Format(template, string, format);
    Text_AddPrinterWithParams(window, FONT_SYSTEM, string, SAVINGS_BOX_WIDTH * TILE_WIDTH_PIXELS - Font_CalcStringWidth(FONT_SYSTEM, string, 0), y, TEXT_SPEED_NO_TRANSFER, NULL);

    String_Free(string);
    String_Free(format);
    StringTemplate_Free(template);
}

// CompleteBankShowBalance: HeartGold's ScrCmd_795, the savings and the wallet in a box
BOOL CompleteScrCmd_BankShowBalance(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;

    if (sSavingsBox != NULL) {
        return FALSE;
    }

    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_PRELOAD_ENTIRE_BANK, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0191, HEAP_ID_FIELD1);

    sSavingsBox = Window_New(HEAP_ID_FIELD1, 1);
    Window_Add(fieldSystem->bgConfig, sSavingsBox, BG_LAYER_MAIN_3, SAVINGS_BOX_LEFT, SAVINGS_BOX_TOP, SAVINGS_BOX_WIDTH, SAVINGS_BOX_HEIGHT, 13, BASE_TILE_SAVINGS_BOX);
    LoadStandardWindowGraphics(fieldSystem->bgConfig, BG_LAYER_MAIN_3, BASE_TILE_STANDARD_WINDOW_FRAME, 11, STANDARD_WINDOW_SYSTEM, HEAP_ID_FIELD1);
    Window_DrawStandardFrame(sSavingsBox, TRUE, BASE_TILE_STANDARD_WINDOW_FRAME, 11);
    Window_FillTilemap(sSavingsBox, 15);

    PrintText(sSavingsBox, loader, SAVINGS_TEXT_DEPOSITED, 0, 0);
    PrintMoney(sSavingsBox, loader, SaveData_GetCompletePhone(fieldSystem->saveData)->momsSavings, 16);
    PrintText(sSavingsBox, loader, SAVINGS_TEXT_HELD, 0, 32);
    PrintMoney(sSavingsBox, loader, TrainerInfo_Money(SaveData_GetTrainerInfo(fieldSystem->saveData)), 48);

    MessageLoader_Free(loader);
    Window_ScheduleCopyToVRAM(sSavingsBox);
    return FALSE;
}

// CompleteBankHideBalance: HeartGold's ScrCmd_796
BOOL CompleteScrCmd_BankHideBalance(ScriptContext *ctx)
{
    if (sSavingsBox != NULL) {
        Window_EraseStandardFrame(sSavingsBox, FALSE);
        Windows_Delete(sSavingsBox, 1);
        sSavingsBox = NULL;
    }

    return FALSE;
}

// The amount, a digit at a time, the one under the cursor in red
static void PrintAmount(void)
{
    String *string = String_Init(4, HEAP_ID_FIELD1);
    u32 x = (AMOUNT_WINDOW_WIDTH * TILE_WIDTH_PIXELS - AMOUNT_DIGITS * AMOUNT_DIGIT_WIDTH) / 2;

    Window_FillTilemap(&sMomsBank->window, 15);

    for (int i = 0; i < AMOUNT_DIGITS; i++) {
        String_FormatInt(string, sMomsBank->amount / sDigitValues[i] % 10, 1, PADDING_MODE_ZEROES, CHARSET_MODE_EN);
        Text_AddPrinterWithParamsAndColor(&sMomsBank->window, FONT_SYSTEM, string, x + i * AMOUNT_DIGIT_WIDTH, 0, TEXT_SPEED_NO_TRANSFER, i == sMomsBank->digit ? TEXT_COLOR(3, 4, 15) : TEXT_COLOR(1, 2, 15), NULL);
    }

    String_Free(string);
    Window_ScheduleCopyToVRAM(&sMomsBank->window);
}

static void CloseBank(void)
{
    Window_EraseStandardFrame(&sMomsBank->window, FALSE);
    Window_Remove(&sMomsBank->window);
    Heap_Free(sMomsBank);
    sMomsBank = NULL;
}

// HeartGold's sub_020479D4, with the number pad's input: destVar is 0 when money moved, 1 when the player gave up
// (or chose nothing)
static BOOL BankInput(ScriptContext *ctx)
{
    if (JOY_NEW(PAD_BUTTON_A) || JOY_NEW(PAD_BUTTON_B)) {
        SaveData *saveData = ctx->fieldSystem->saveData;
        TrainerInfo *info = SaveData_GetTrainerInfo(saveData);
        CompletePhoneSave *phone = SaveData_GetCompletePhone(saveData);

        Sound_PlayEffect(SE_CONFIRM_sseq_3);

        if (JOY_NEW(PAD_BUTTON_B) || sMomsBank->amount == 0) {
            *sMomsBank->destVar = 1;
        } else if (sMomsBank->mode == BANK_DEPOSIT) {
            TrainerInfo_TakeMoney(info, sMomsBank->amount);
            phone->momsSavings += sMomsBank->amount;
            *sMomsBank->destVar = 0;
        } else {
            TrainerInfo_GiveMoney(info, sMomsBank->amount);
            phone->momsSavings -= sMomsBank->amount;
            *sMomsBank->destVar = 0;
        }

        CloseBank();
        return TRUE;
    }

    u32 amount = sMomsBank->amount;
    u32 step = sDigitValues[sMomsBank->digit];

    if (JOY_REPEAT(PAD_KEY_UP)) {
        amount = amount + step > sMomsBank->max ? sMomsBank->max : amount + step;
    } else if (JOY_REPEAT(PAD_KEY_DOWN)) {
        amount = amount < step ? 0 : amount - step;
    } else if (JOY_REPEAT(PAD_KEY_LEFT) && sMomsBank->digit > 0) {
        sMomsBank->digit--;
    } else if (JOY_REPEAT(PAD_KEY_RIGHT) && sMomsBank->digit < AMOUNT_DIGITS - 1) {
        sMomsBank->digit++;
    } else {
        return FALSE;
    }

    sMomsBank->amount = amount;
    Sound_PlayEffect(SE_CONFIRM_sseq_3);
    PrintAmount();
    return FALSE;
}

// CompleteBankTransaction mode, destVar: HeartGold's BankTransaction (0: deposit, 1: withdraw), to what the move
// allows (its GetMaxBankTransactionAmount); destVar as BankInput
BOOL CompleteScrCmd_BankTransaction(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    u16 mode = ScriptContext_GetVar(ctx);
    u32 wallet = TrainerInfo_Money(SaveData_GetTrainerInfo(fieldSystem->saveData));
    u32 savings = SaveData_GetCompletePhone(fieldSystem->saveData)->momsSavings;

    sMomsBank = Heap_Alloc(HEAP_ID_FIELD1, sizeof(MomsBank));
    sMomsBank->destVar = ScriptContext_GetVarPointer(ctx);
    sMomsBank->mode = mode;
    sMomsBank->amount = 0;

    if (mode == BANK_DEPOSIT) {
        sMomsBank->max = wallet < MOMS_SAVINGS_MAX - savings ? wallet : MOMS_SAVINGS_MAX - savings;
    } else {
        sMomsBank->max = savings < MOMS_SAVINGS_MAX - wallet ? savings : MOMS_SAVINGS_MAX - wallet;
    }

    // the cursor starts under the highest digit the amount can have
    for (sMomsBank->digit = 0; sMomsBank->digit < AMOUNT_DIGITS - 1 && sDigitValues[sMomsBank->digit] > sMomsBank->max; sMomsBank->digit++) {
        ;
    }

    Window_Add(fieldSystem->bgConfig, &sMomsBank->window, BG_LAYER_MAIN_3, AMOUNT_WINDOW_LEFT, AMOUNT_WINDOW_TOP, AMOUNT_WINDOW_WIDTH, AMOUNT_WINDOW_HEIGHT, 13, BASE_TILE_AMOUNT);
    LoadStandardWindowGraphics(fieldSystem->bgConfig, BG_LAYER_MAIN_3, BASE_TILE_STANDARD_WINDOW_FRAME, 11, STANDARD_WINDOW_SYSTEM, HEAP_ID_FIELD1);
    Window_DrawStandardFrame(&sMomsBank->window, TRUE, BASE_TILE_STANDARD_WINDOW_FRAME, 11);
    PrintAmount();

    ScriptContext_Pause(ctx, BankInput);
    return TRUE;
}
