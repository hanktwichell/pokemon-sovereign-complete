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

// A flag no script may set (src/vars_flags.c), for tools/test/talk_to_objects.py --unhide: an object's hidden_flag, so
// that its map's scripts, which set it from the story as the map loads, leave the object on the map. 0: none.
extern u16 gCompleteTestKeepFlagClear;

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

#define COMPLETE_TEST_SOUND_LOG     8
#define COMPLETE_TEST_SOUND_FANFARE 0xFFFF

// Sound memory, for tools/complete/test_sound_heap.py: after each load into the sound heap (src/sound_system.c), its
// free bytes, the fewest since the harness last set minFree, the loads that didn't fit (with the last one's file),
// and the last loads (log[loads % COMPLETE_TEST_SOUND_LOG]: the file and the free bytes after). The harness sets
// playSeq to play a song on the next free field frame: in playScene's sound scene if it sets one (a cutscene's), as a
// fanfare for COMPLETE_TEST_SOUND_FANFARE, otherwise a field song as a map's and any other as a script plays it.
typedef struct CompleteTestSoundLoad {
    u16 id;
    u16 loaded;
    u32 free;
} CompleteTestSoundLoad;

typedef struct CompleteTestSound {
    u32 free;
    u32 minFree;
    u32 failures;
    u16 lastFailedID;
    u16 loads;
    u16 playSeq;
    u16 playScene;
    CompleteTestSoundLoad log[COMPLETE_TEST_SOUND_LOG];
} CompleteTestSound;

extern CompleteTestSound gCompleteTestSound;

void CompleteTest_FieldFrame(FieldSystem *fieldSystem);
BOOL CompleteTest_NoteSoundLoad(BOOL loaded, u16 id);

#else

#define CompleteTest_NoteSoundLoad(loaded, id) (loaded)

#endif

#endif // POKEPLATINUM_COMPLETE_TEST_H
