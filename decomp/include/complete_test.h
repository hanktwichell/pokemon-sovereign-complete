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
    u16 keyItems; // one of every key item and every Ball is put in the bag; how many are there
    u16 balls;
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

// HeartGold's mass outbreaks (src/complete_encounters.c), for tools/complete/test_hgss_outbreaks.py: when set, the
// day's outbreak map is this entry of its table + 1, in place of the day's pick.
extern u8 gCompleteTestOutbreakMap;

// The gifts that go by the lead's species (tools/complete/test_hgss_gifts.py): when set, the next free field frame makes
// the party's lead this species (then 0).
extern u16 gCompleteTestLeadSpecies;

// tools/complete/test_hgss_togepi.py: when set, the next free field frame hatches the party's Eggs, by the script a step
// starts when one is due (then FALSE).
extern u8 gCompleteTestHatchEggs;

// The wild battles HeartGold's Headbutt trees and Rock Smash have started (src/overlay006/wild_encounters.c), for
// tools/complete/test_hgss_headbutt.py: how many, and the last one's species and level; and the items smashed rocks
// have held (src/overlay006/complete_field_encounters.c): how many, and the last.
typedef struct CompleteTestFieldEncounter {
    u16 count;
    u16 species;
    u16 level;
    u16 items;
    u16 item;
    u16 padding;
} CompleteTestFieldEncounter;

extern CompleteTestFieldEncounter gCompleteTestFieldEncounter;

// A field task for the test build's battles (src/overlay005/field_control.c's SovereignTest_BattleTask), which starts
// them under it: after a lost battle it blacks out, as the script that starts a battle in the game has it do. Its env is
// the battle's result.
BOOL CompleteTest_BlackOutIfLost(FieldTask *task);

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

// Talking to the following Pokémon (src/overlay006/complete_follower_talk.c), for tools/complete/test_follower_talk.py:
// an interaction the harness asks for, and what the last talk did
typedef struct CompleteTestFollowerTalk {
    u16 force; // the harness's: the next talk runs this interaction instead of the one the tables choose (then 0)
    u16 talks; // talks started
    u16 interaction; // the last talk's first interaction (0: none fitted)
    u16 messages; // the messages it showed
    u16 lastMessage; // the last: its number in msg_0265 + 1, or 0x8000 + its number in msg_0040
    u8 motions; // the motions it played
    u8 questions; // the questions it asked
    u8 offsetBack; // TRUE when its end found the follower's sprite where its start did
    s8 mood; // after it, the lead's mood, friendship and Shiny Leaves
    u8 friendship;
    u8 shinyLeaves;
    u16 accessories; // the Fashion Case's count of the last accessory found
    u8 emotes; // the emotes it showed, and the last
    u8 lastEmote;
} CompleteTestFollowerTalk;

extern CompleteTestFollowerTalk gCompleteTestFollowerTalk;

void CompleteTest_FieldFrame(FieldSystem *fieldSystem);
BOOL CompleteTest_NoteSoundLoad(BOOL loaded, u16 id);

#else

#define CompleteTest_NoteSoundLoad(loaded, id) (loaded)

#endif

#endif // POKEPLATINUM_COMPLETE_TEST_H
