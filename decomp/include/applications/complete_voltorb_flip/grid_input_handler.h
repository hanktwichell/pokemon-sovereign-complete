#ifndef POKEPLATINUM_COMPLETE_VOLTORB_FLIP_GRID_INPUT_HANDLER_H
#define POKEPLATINUM_COMPLETE_VOLTORB_FLIP_GRID_INPUT_HANDLER_H

// Sovereign Complete: HeartGold's grid input handler (its unk_02019BA4.c) and d-pad boxes (unk_02020A0C.c), for
// Voltorb Flip: a grid of buttons reached by touch or by the d-pad

#include "constants/heap.h"

#include "applications/complete_voltorb_flip/hgss_compat.h"

typedef struct DpadMenuBox {
    u8 left;
    u8 top;
    u8 width;
    u8 height;
    u8 buttonUp;
    u8 buttonDown;
    u8 buttonLeft;
    u8 buttonRight;
} DpadMenuBox;

void DpadMenuBox_GetPosition(const DpadMenuBox *dpadBoxes, u8 *px, u8 *py);
void DpadMenuBox_GetDimensions(const DpadMenuBox *dpadBoxes, u8 *pw, u8 *ph);
u8 DpadMenuBox_GetNeighborInDirection(const DpadMenuBox *dpadBoxes, u8 *px, u8 *py, u8 *pw, u8 *ph, u8 partyMonIndex, u8 direction);

#define GRID_MENU_NOTHING_CHOSEN -1
#define GRID_MENU_CANCEL         -2
#define GRID_MENU_CURSOR_MOVE    -3
#define GRID_MENU_BUTTON_MODE    -4

typedef void (*DpadGridCallback)(void *data, int newTarget, int prevTarget);

typedef struct GridCallbacks {
    DpadGridCallback onButton;
    DpadGridCallback onSwitchToTouchMode;
    DpadGridCallback onKeyMove;
    DpadGridCallback onTouch;
} GridCallbacks;

typedef struct GridInputHandler {
    const TouchscreenHitbox *touchscreenHitboxes; // 0x00
    const DpadMenuBox *dpadPositions;             // 0x04
    BOOL isButtons;                               // 0x08
    u8 modeSwitchLagFrame;                        // 0x0C
    u8 nextInput;                                 // 0x0D
    u8 lastInput;                                 // 0x0E
    u8 unk_0F;                                    // 0x0F
    u32 enabledFlag[2];                           // 0x10
    const GridCallbacks *callbacks;               // 0x18
    void *data;                                   // 0x1C, passed as data to unk_18
} GridInputHandler;

GridInputHandler *GridInputHandler_Create(const TouchscreenHitbox *hitBoxes, const DpadMenuBox *dpadBoxes, const GridCallbacks *callbacks, void *callbackParam, BOOL inputState, u8 initialPos, enum HeapID heapId);
void GridInputHandler_Free(GridInputHandler *inputHandler);
int GridInputHandler_HandleInput_NoHold(GridInputHandler *inputHandler);
int GridInputHandler_HandleInput_AllowHold(GridInputHandler *inputHandler);
int GridInputHandler_GetNextInput(GridInputHandler *inputHandler);
int GridInputHandler_GetUnk0F(GridInputHandler *inputHandler);
void GridInputHandler_SetNextInput(GridInputHandler *inputHandler, int nextInput);
void GridInputHandler_SetNextLastUnk0FInputs(GridInputHandler *inputHandler, int nextInput, int lastInput, int unk0F);
BOOL GridInputHandler_IsButtonInputMode(GridInputHandler *inputHandler);
void GridInputHandler_SetButtonInputMode(GridInputHandler *inputHandler, BOOL isButtons);
void GridInputHandler_SetAllEnabled(GridInputHandler *inputHandler);
void GridInputHandler_ClearEnabledFlag(GridInputHandler *inputHandler, u32 target);
void GridInputHandler_SetEnabledFlag(GridInputHandler *inputHandler, u32 target);
const DpadMenuBox *GridInputHandler_GetDpadBox(GridInputHandler *inputHandler, int target);

#endif // POKEPLATINUM_COMPLETE_VOLTORB_FLIP_GRID_INPUT_HANDLER_H
