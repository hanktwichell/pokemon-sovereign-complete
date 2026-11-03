#ifndef POKEPLATINUM_COMPLETE_VOLTORB_FLIP_H
#define POKEPLATINUM_COMPLETE_VOLTORB_FLIP_H

// Sovereign Complete: HeartGold's Voltorb Flip, started by the Game Corners' scripts (CompleteScrCmd_VoltorbFlip). This
// header names only Platinum's types, so the field can include it; the app's own files add hgss_compat.h.

#include "game_options.h"
#include "overlay_manager.h"
#include "savedata.h"
#include "trainer_info.h"

// Whether the player last used the touch screen or the buttons (HeartGold keeps it in the field system; here it's the
// app's arguments')
typedef enum MenuInputState {
    MENU_INPUT_STATE_BUTTONS,
    MENU_INPUT_STATE_TOUCH,
} MenuInputState;

typedef struct MenuInputStateMgr {
    MenuInputState state;
} MenuInputStateMgr;

typedef struct VoltorbFlipArgs {
    Options *options;
    u16 *coins;
    MenuInputStateMgr *menuInputStatePtr;
    TrainerInfo *profile;
    SaveData *saveData;
    MenuInputStateMgr menuInputState; // Sovereign Complete: what menuInputStatePtr points at
} VoltorbFlipArgs;

#ifdef SOVEREIGN_TEST
// The running game's board (VoltorbFlipGameState), or NULL: tools/complete/test_hgss_voltorb_flip.py reads it to win a
// round
extern void *gCompleteTestVoltorbFlipGame;
#endif

BOOL VoltorbFlip_Init(ApplicationManager *man, int *state);
BOOL VoltorbFlip_Exit(ApplicationManager *man, int *state);
BOOL VoltorbFlip_Main(ApplicationManager *man, int *state);

#endif // POKEPLATINUM_COMPLETE_VOLTORB_FLIP_H
