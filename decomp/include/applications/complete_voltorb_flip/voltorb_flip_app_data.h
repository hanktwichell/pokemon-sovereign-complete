#ifndef POKEPLATINUM_COMPLETE_VOLTORB_FLIP_WORK_H
#define POKEPLATINUM_COMPLETE_VOLTORB_FLIP_WORK_H

#include "applications/complete_voltorb_flip/voltorb_flip_game.h"
#include "applications/complete_voltorb_flip/voltorb_flip_input.h"

#include "applications/complete_voltorb_flip/hgss_compat.h"
#include "applications/complete_voltorb_flip/touchscreen_list_menu.h"

#include "bg_window.h"
#include "heap.h"
#include "narc.h"
#include "sprite_system.h"

typedef struct VFCardFlipAnim {
    BgConfig *bgConfig;
    VoltorbFlipGameState *game;
    VoltorbFlipInputHandler *inputHandler;
    int mode;
    u8 step;
    u8 cursorPos;
    u8 frame;
    u8 row;
} VFCardFlipAnim;

typedef struct Ov122_021E7888 {
    u8 unk0;
} Ov122_021E7888;

typedef struct VoltorbFlipAppData {
    enum HeapID heapID;
    Options *options;
    u16 *coins;
    MenuInputStateMgr *menuInputStatePtr;
    PlayerProfile *profile;
    NARC *narc;
    BgConfig *bgConfig;
    void *listMenuSpawner;
    TouchscreenListMenu *menu;
    Window windows[17];
    ListMenuItem *menuItems[2];
    YesNoPrompt *yesNoPrompt;
    String *string;
    SpriteSystem *spriteRenderer;
    SpriteManager *spriteGfxHandler;
    ManagedSprite *sprites[13];
    MsgData *msgData;
    MessageFormat *msgFmt;
    u16 unk188[10][8];
    u8 menuInputState;
    u8 unk229;
    u8 unk22A;
    u8 printerId;
    u16 payoutDisplay;
    BOOL hasPlayedOneLeve;
    BOOL printedCanGetMoreCoinsMessage;
    BOOL memoOpen;
    struct VoltorbFlipTaskEngine *workflow;
    VoltorbFlipInputHandler *inputHandler;
    VoltorbFlipGameState *game;
    VFCardFlipAnim cardFlipControl;
    u8 screenIsDimmed;
} VoltorbFlipAppData;

#endif // POKEPLATINUM_COMPLETE_VOLTORB_FLIP_WORK_H
