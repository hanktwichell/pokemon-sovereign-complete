#ifndef POKEPLATINUM_COMPLETE_TEST_H
#define POKEPLATINUM_COMPLETE_TEST_H

#include "field/field_system.h"

#include "complete_safari.h"

// Sovereign Complete: test-build hooks for tools/complete/ harnesses. Nothing here is in the shipping ROM.
#ifdef SOVEREIGN_TEST

enum CompleteTestSaveRequest {
    COMPLETE_TEST_SAVE_NONE = 0,
    COMPLETE_TEST_SAVE_WRITE, // set the probe flags and vars
    COMPLETE_TEST_SAVE_SAVE, // save as the start menu does (FieldSystem_Save)
    COMPLETE_TEST_SAVE_READ, // read the probe flags and vars back
};

// The harness writes request; the game does it on the next free field frame, then sets done to it.
typedef struct CompleteTestSaveProbe {
    u32 request;
    u32 done;
    u32 saveOK;
    u16 flags[5];
    u16 vars[3];
} CompleteTestSaveProbe;

extern CompleteTestSaveProbe gCompleteTestSaveProbe;

// The last script command run (src/field_script_context.c), for tools/complete/where_script.py: the script file it is
// in, its offset there and its opcode, and the function a waiting script waits on.
typedef struct CompleteTestScriptPos {
    const u8 *scripts;
    u32 offset;
    u32 command;
    void *waitingOn;
} CompleteTestScriptPos;

extern CompleteTestScriptPos gCompleteTestScriptPos;

// The Johto Safari Zone as the field sees it each free frame, for tools/complete/test_hgss_safari.py: the six arranged
// areas (src/complete_safari.c), whether a Safari game runs, its Balls left, the objects placed in each area, and the
// save's Safari Zone (where the harness gives the objects Baoba unlocks).
typedef struct CompleteTestSafari {
    u8 areas[6];
    u8 active;
    u8 padding;
    u16 balls;
    u8 objectCounts[6];
    SafariZoneSave *save;
} CompleteTestSafari;

extern CompleteTestSafari gCompleteTestSafari;

void CompleteTest_FieldFrame(FieldSystem *fieldSystem);

#endif

#endif // POKEPLATINUM_COMPLETE_TEST_H
