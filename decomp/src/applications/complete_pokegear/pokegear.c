#include <nitro.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "generated/text_banks.h"
#include "generated/trainers.h"

#include "bg_window.h"
#include "complete_phone.h"
#include "complete_pokegear.h"
#include "font.h"
#include "graphics.h"
#include "heap.h"
#include "message.h"
#include "narc.h"
#include "savedata.h"
#include "sound_playback.h"
#include "string_gf.h"
#include "sys_task.h"
#include "sys_task_manager.h"
#include "system.h"
#include "text.h"
#include "touch_pad.h"
#include "trainer_data.h"

#include "data/hgss_phone_contacts.h"
#include "res/graphics/complete_pokegear/complete_pokegear.naix"
#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: HeartGold's Pokégear on the field's bottom screen (include/complete_pokegear.h), in the
// Pokétch's place, with HeartGold's graphics (res/graphics/complete_pokegear/): its phone's contact list and its app
// bar. Tapping a contact calls them (CompletePhone_RequestCall: the call plays in the field's message box once the
// player stands still); the arrows scroll the list; the app bar's last button switches to the Pokétch when the player
// has it. HeartGold's Radio and Map wait (their buttons are dimmed), as does its skin setting.

#define LIST_ROWS        6 // HeartGold's: rows of 24 pixels, behind the frame's window
#define ROW_HEIGHT       24
#define LIST_X           16 // the list's window, inside the frame
#define LIST_Y           8
#define LIST_WIDTH       208
#define NAME_BOX_WIDTH   82 // HeartGold's name box, then its title box
#define PHONE_TILE_START 128 // the phone frame's tiles, after the app bar's, in one layer
#define BAR_TOP          20 // the app bar's first tile row
#define REFRESH_FRAMES   30 // the phone book is checked for changes this often
#define CALL_HIGHLIGHT   30 // frames a called contact stays lit
#define REPEAT_DELAY     20 // a held arrow scrolls again after this, then every REPEAT_FRAMES
#define REPEAT_FRAMES    6

// The palette (HeartGold's phone palette 2) colours of a contact's row (HeartGold's PhoneContactListUI_DrawNameSlotBG)
#define COLOR_ROW_GAP   11
#define COLOR_NAME_BOX  9
#define COLOR_TITLE_BOX 10
#define LIST_PALETTE    2

enum PokegearState {
    POKEGEAR_STATE_RUN = 0,
    POKEGEAR_STATE_SHUTDOWN,
};

enum AppBarButton {
    APP_BAR_SETTINGS = 0,
    APP_BAR_RADIO,
    APP_BAR_MAP,
    APP_BAR_PHONE,
    APP_BAR_EXIT, // here: the Pokétch
    APP_BAR_BUTTONS,
};

typedef struct CompletePokegear {
    FieldSystem *fieldSystem;
    SaveData *saveData;
    BgConfig *bgConfig;
    SysTask *task;
    Window list;
    MessageLoader *titles; // HeartGold's phone app's bank (0271)
    MessageLoader *classes;
    u8 state;
    u8 numContacts;
    u8 top; // the first contact shown
    u8 lit; // the row of the contact called, LIST_ROWS for none
    u8 litTimer;
    u8 held; // the arrow held: 1 up, 2 down
    u8 heldFrames;
    u8 refreshTimer;
    u8 poketchShown; // the exit button lit
    u8 contacts[NUM_PHONE_CONTACTS];
    u16 appBar[4][2][32]; // HeartGold's app bar's rows: lit and dimmed
} CompletePokegear;

static CompletePokegear *sPokegear;

// Each app bar button's first tile column and width (HeartGold's app bar: five buttons and a gap before the last)
static const u8 sAppBarButtons[APP_BAR_BUTTONS][2] = { { 1, 6 }, { 7, 6 }, { 13, 6 }, { 19, 6 }, { 26, 6 } };

typedef struct Box {
    u8 top;
    u8 bottom;
    u8 left;
    u8 right;
} Box;

static const Box sUpArrow = { 16, 72, 232, 255 };
static const Box sDownArrow = { 88, 144, 232, 255 };

static BOOL Touched(const Box *rect, u16 x, u16 y)
{
    return y >= rect->top && y <= rect->bottom && x >= rect->left && x <= rect->right;
}

static void ReadPhoneBook(CompletePokegear *gear, u8 *contacts, u8 *count)
{
    CompletePhoneSave *phone = SaveData_GetCompletePhone(gear->saveData);

    *count = 0;

    for (int i = 0; i < NUM_PHONE_CONTACTS && phone->contacts[i] != PHONE_CONTACT_NONE; i++) {
        contacts[(*count)++] = phone->contacts[i];
    }
}

// A contact's row (HeartGold's PhoneContactListUI_PrintNameAndClass): their name in the white box and their title in
// the blue one, lit when they're being called
static void DrawRow(CompletePokegear *gear, int row)
{
    int y = row * ROW_HEIGHT;
    int index = gear->top + row;

    Window_FillRectWithColor(&gear->list, COLOR_ROW_GAP, 0, y, LIST_WIDTH, ROW_HEIGHT);
    Window_FillRectWithColor(&gear->list, COLOR_NAME_BOX, 0, y, NAME_BOX_WIDTH, ROW_HEIGHT - 4);
    Window_FillRectWithColor(&gear->list, COLOR_TITLE_BOX, NAME_BOX_WIDTH, y, LIST_WIDTH - NAME_BOX_WIDTH, ROW_HEIGHT - 4);

    if (index >= gear->numContacts) {
        return;
    }

    u8 contact = gear->contacts[index];
    BOOL lit = row == gear->lit;
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, sPhoneContactNames[contact].textBank, HEAP_ID_POKETCH_APP);
    String *name = MessageLoader_GetNewString(loader, 0);

    Text_AddPrinterWithParamsAndColor(&gear->list, FONT_SYSTEM, name, 8, y + 2, TEXT_SPEED_NO_TRANSFER, lit ? TEXT_COLOR(4, 7, COLOR_NAME_BOX) : TEXT_COLOR(11, 8, COLOR_NAME_BOX), NULL);
    String_Free(name);
    MessageLoader_Free(loader);

    String *title = NULL;
    u8 kind = sPhoneContactNames[contact].title;

    if (kind == CONTACT_TITLE_TRAINER_CLASS) {
        title = MessageLoader_GetNewString(gear->classes, Trainer_LoadParam(sPhoneContactNames[contact].trainerID, TRDATA_CLASS));
    } else if (kind != CONTACT_TITLE_NONE) {
        title = MessageLoader_GetNewString(gear->titles, kind);
    }

    if (title != NULL) {
        Text_AddPrinterWithParamsAndColor(&gear->list, FONT_SYSTEM, title, NAME_BOX_WIDTH + 4, y + 2, TEXT_SPEED_NO_TRANSFER, lit ? TEXT_COLOR(1, 2, COLOR_TITLE_BOX) : TEXT_COLOR(5, 6, COLOR_TITLE_BOX), NULL);
        String_Free(title);
    }
}

static void DrawList(CompletePokegear *gear)
{
    for (int row = 0; row < LIST_ROWS; row++) {
        DrawRow(gear, row);
    }

    Window_CopyToVRAM(&gear->list);
}

// HeartGold's app bar (its PokegearApp_UpdateAppSwitchButtonBGState): the phone and, with a Pokétch to switch to, the
// exit button lit; the rest dimmed
static void DrawAppBar(CompletePokegear *gear)
{
    gear->poketchShown = CompletePokegear_PoketchAvailable(gear->saveData);

    for (int y = 0; y < 4; y++) {
        u16 row[32];

        for (int x = 0; x < 32; x++) {
            row[x] = gear->appBar[y][1][x];
        }

        for (int button = 0; button < APP_BAR_BUTTONS; button++) {
            BOOL lit = button == APP_BAR_PHONE || (button == APP_BAR_EXIT && gear->poketchShown);

            for (int x = sAppBarButtons[button][0]; x < sAppBarButtons[button][0] + sAppBarButtons[button][1]; x++) {
                row[x] = gear->appBar[y][!lit][x];
            }
        }

        Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, row, 0, BAR_TOP + y, 32, 1);
    }

    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_0);
}

static void LoadGraphics(CompletePokegear *gear)
{
    static const BgTemplate sFrameTemplate = {
        .x = 0,
        .y = 0,
        .bufferSize = 0x800,
        .baseTile = 0,
        .screenSize = BG_SCREEN_SIZE_256x256,
        .colorMode = GX_BG_COLORMODE_16,
        .screenBase = GX_BG_SCRBASE_0x7800,
        .charBase = GX_BG_CHARBASE_0x04000,
        .bgExtPltt = GX_BG_EXTPLTT_01,
        .priority = 0,
        .areaOver = 0,
        .mosaic = FALSE,
    };
    static const BgTemplate sListTemplate = {
        .x = 0,
        .y = 0,
        .bufferSize = 0x800,
        .baseTile = 0,
        .screenSize = BG_SCREEN_SIZE_256x256,
        .colorMode = GX_BG_COLORMODE_16,
        .screenBase = GX_BG_SCRBASE_0x7000,
        .charBase = GX_BG_CHARBASE_0x00000,
        .bgExtPltt = GX_BG_EXTPLTT_01,
        .priority = 1,
        .areaOver = 0,
        .mosaic = FALSE,
    };
    NNSG2dScreenData *screen;

    GXS_SetGraphicsMode(GX_BGMODE_0);
    GX_SetBankForSubBG(GX_VRAM_SUB_BG_32_H);
    GX_SetBankForSubOBJ(GX_VRAM_SUB_OBJ_16_I);
    GXS_SetOBJVRamModeChar(GX_OBJVRAMMODE_CHAR_1D_32K);

    Bg_InitFromTemplate(gear->bgConfig, BG_LAYER_SUB_0, &sFrameTemplate, BG_TYPE_STATIC);
    Bg_InitFromTemplate(gear->bgConfig, BG_LAYER_SUB_1, &sListTemplate, BG_TYPE_STATIC);
    Bg_ClearTilesRange(BG_LAYER_SUB_1, TILE_SIZE_4BPP, 0, HEAP_ID_POKETCH_APP);

    NARC *narc = NARC_ctor(NARC_INDEX_APPLICATION__COMPLETE__POKEGEAR, HEAP_ID_POKETCH_APP);

    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, app_bar_NCGR, gear->bgConfig, BG_LAYER_SUB_0, 0, 0, FALSE, HEAP_ID_POKETCH_APP);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, phone_NCGR, gear->bgConfig, BG_LAYER_SUB_0, PHONE_TILE_START, 0, FALSE, HEAP_ID_POKETCH_APP);
    Graphics_LoadPaletteFromOpenNARC(narc, pokegear_NCLR, PAL_LOAD_SUB_BG, 0, PALETTE_SIZE_BYTES * 16, HEAP_ID_POKETCH_APP);

    // the phone's frame, rows 0-19, its tiles after the app bar's
    void *file = Graphics_GetScrnDataFromOpenNARC(narc, phone_NSCR, FALSE, &screen, HEAP_ID_POKETCH_APP);
    const u16 *src = (const u16 *)screen->rawData;
    u16 *frame = Heap_Alloc(HEAP_ID_POKETCH_APP, 32 * BAR_TOP * sizeof(u16));

    for (int i = 0; i < 32 * BAR_TOP; i++) {
        frame[i] = src[i] + PHONE_TILE_START;
    }

    Bg_LoadToTilemapRect(gear->bgConfig, BG_LAYER_SUB_0, frame, 0, 0, 32, BAR_TOP);
    Heap_Free(frame);
    Heap_Free(file);

    // the app bar's two states, lit (its rows 0-3) and dimmed (4-7)
    file = Graphics_GetScrnDataFromOpenNARC(narc, app_bar_NSCR, FALSE, &screen, HEAP_ID_POKETCH_APP);
    src = (const u16 *)screen->rawData;

    for (int y = 0; y < 4; y++) {
        for (int x = 0; x < 32; x++) {
            gear->appBar[y][0][x] = src[y * 32 + x];
            gear->appBar[y][1][x] = src[(y + 4) * 32 + x];
        }
    }

    Heap_Free(file);
    NARC_dtor(narc);

    Window_Add(gear->bgConfig, &gear->list, BG_LAYER_SUB_1, LIST_X / 8, LIST_Y / 8, LIST_WIDTH / 8, LIST_ROWS * ROW_HEIGHT / 8, LIST_PALETTE, 1);
    Window_PutToTilemap(&gear->list);
    Bg_CopyTilemapBufferToVRAM(gear->bgConfig, BG_LAYER_SUB_1);

    DrawAppBar(gear);
    DrawList(gear);

    GXS_SetVisibleWnd(GX_WNDMASK_NONE);
    GXS_SetVisiblePlane(GX_PLANEMASK_BG0 | GX_PLANEMASK_BG1);
}

static void Scroll(CompletePokegear *gear, int by)
{
    int top = gear->top + by;

    if (top < 0 || (by > 0 && top + LIST_ROWS > gear->numContacts)) {
        return;
    }

    gear->top = top;
    gear->lit = LIST_ROWS;
    Sound_PlayEffect(SEQ_SE_DP_BUTTON3_sseq);
    DrawList(gear);
}

static void HandleTouch(CompletePokegear *gear)
{
    u16 x = gSystem.touchX, y = gSystem.touchY;

    if (gSystem.touchHeld && gear->held) {
        if (++gear->heldFrames >= REPEAT_DELAY && (gear->heldFrames - REPEAT_DELAY) % REPEAT_FRAMES == 0) {
            Scroll(gear, gear->held == 1 ? -1 : 1);
        }

        return;
    }

    gear->held = 0;

    if (!gSystem.touchPressed) {
        return;
    }

    if (x >= LIST_X && x < LIST_X + LIST_WIDTH && y >= LIST_Y && y < LIST_Y + LIST_ROWS * ROW_HEIGHT) {
        int row = (y - LIST_Y) / ROW_HEIGHT;

        if ((y - LIST_Y) % ROW_HEIGHT < ROW_HEIGHT - 4 && gear->top + row < gear->numContacts) {
            gear->lit = row;
            gear->litTimer = CALL_HIGHLIGHT;
            Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
            DrawList(gear);
            CompletePhone_RequestCall(gear->contacts[gear->top + row]);
        }
    } else if (Touched(&sUpArrow, x, y) || Touched(&sDownArrow, x, y)) {
        gear->held = Touched(&sUpArrow, x, y) ? 1 : 2;
        gear->heldFrames = 0;
        Scroll(gear, gear->held == 1 ? -1 : 1);
    } else if (y >= BAR_TOP * 8 && x >= sAppBarButtons[APP_BAR_EXIT][0] * 8) {
        if (gear->poketchShown) {
            Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq);
            CompleteBottomScreen_RequestSwitch(gear->saveData);
        } else {
            Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq);
        }
    } else if (y >= BAR_TOP * 8) {
        Sound_PlayEffect(SEQ_SE_DP_BEEP_sseq); // the Radio, the Map and the settings aren't here yet
    }
}

static void Shutdown(CompletePokegear *gear)
{
    DisableTouchPad();
    Window_Remove(&gear->list);
    Bg_FreeTilemapBuffer(gear->bgConfig, BG_LAYER_SUB_0);
    Bg_FreeTilemapBuffer(gear->bgConfig, BG_LAYER_SUB_1);
    MessageLoader_Free(gear->titles);
    MessageLoader_Free(gear->classes);
}

static void CompletePokegear_Task(SysTask *task, void *data)
{
    CompletePokegear *gear = data;

    if (gear->state == POKEGEAR_STATE_SHUTDOWN) {
        Shutdown(gear);
        SysTask_Done(task);
        Heap_Free(gear);
        sPokegear = NULL;
#ifdef SOVEREIGN_TEST
        gCompleteTestPokegear = NULL;
#endif
        Heap_Destroy(HEAP_ID_POKETCH_APP);
        return;
    }

    HandleTouch(gear);

    if (gear->litTimer != 0 && --gear->litTimer == 0) {
        gear->lit = LIST_ROWS;
        DrawList(gear);
    }

    if (++gear->refreshTimer >= REFRESH_FRAMES) {
        u8 contacts[NUM_PHONE_CONTACTS], count;

        gear->refreshTimer = 0;
        ReadPhoneBook(gear, contacts, &count);

        if (count != gear->numContacts || memcmp(contacts, gear->contacts, count) != 0) {
            MI_CpuCopy8(contacts, gear->contacts, count);
            gear->numContacts = count;
            gear->top = 0;
            DrawList(gear);
        }

        if (CompletePokegear_PoketchAvailable(gear->saveData) != gear->poketchShown) {
            DrawAppBar(gear);
        }
    }
}

void CompletePokegear_Create(FieldSystem *fieldSystem, BgConfig *bgConfig)
{
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_POKETCH_APP, HEAP_SIZE_PRE_POKETCH_SUBSCREEN);

    CompletePokegear *gear = Heap_Alloc(HEAP_ID_POKETCH_APP, sizeof(CompletePokegear));

    MI_CpuClear8(gear, sizeof(CompletePokegear));
    gear->fieldSystem = fieldSystem;
    gear->saveData = FieldSystem_GetSaveData(fieldSystem);
    gear->bgConfig = bgConfig;
    gear->lit = LIST_ROWS;
    gear->titles = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0271, HEAP_ID_POKETCH_APP);
    gear->classes = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_TRAINER_CLASS_NAMES, HEAP_ID_POKETCH_APP);
    ReadPhoneBook(gear, gear->contacts, &gear->numContacts);

    LoadGraphics(gear);

    EnableTouchPad();
    InitializeTouchPad(4);

    sPokegear = gear;
#ifdef SOVEREIGN_TEST
    gCompleteTestPokegear = gear;
#endif
    gear->task = SysTask_Start(CompletePokegear_Task, gear, 0);
}

void CompletePokegear_StartShutdown(void)
{
    if (sPokegear != NULL) {
        sPokegear->state = POKEGEAR_STATE_SHUTDOWN;
    }
}

BOOL CompletePokegear_IsShutdown(void)
{
    return sPokegear == NULL;
}
