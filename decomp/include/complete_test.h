#ifndef POKEPLATINUM_COMPLETE_TEST_H
#define POKEPLATINUM_COMPLETE_TEST_H

#include "field/field_system.h"

#include "complete_aprijuice.h"
#include "complete_pokeathlon_select.h"
#include "complete_safari.h"

// Sovereign Complete: test-build hooks for tools/complete/ harnesses. Nothing here is in the shipping ROM.
#ifdef SOVEREIGN_TEST

enum CompleteTestSaveRequest {
    COMPLETE_TEST_SAVE_NONE = 0,
    COMPLETE_TEST_SAVE_WRITE, // set the probe flags and vars
    COMPLETE_TEST_SAVE_SAVE, // save as the start menu does (FieldSystem_Save)
    COMPLETE_TEST_SAVE_READ, // read the probe flags and vars back
    COMPLETE_TEST_SAVE_POKEATHLON_UNSAVED, // add 500 Athlete Points, not saved (include/complete_pokeathlon.h)
    COMPLETE_TEST_SAVE_POKEATHLON_STATUES, // the Friendship Room's statues from statueSpecies etc., not saved
    COMPLETE_TEST_SAVE_POKEATHLON_COURSES, // the five course records' totals from courseTotals (a Pikachu each), not saved
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
    u32 athletePoints; // the Pokéathlon's: 1234 are added with the probe flags, read back with them
    u16 statueSpecies[3]; // COMPLETE_TEST_SAVE_POKEATHLON_STATUES's (tools/complete/test_pokeathlon_statues.py)
    u8 statueForm[3];
    u8 statueGender[3];
    u16 courseTotals[5]; // COMPLETE_TEST_SAVE_POKEATHLON_COURSES's (tools/complete/test_pokeathlon_records.py)
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

// The legendary cutscenes (src/overlay005/complete_legend_cutscene.c): the ops run, the last, whether a scene's camera
// is held, and the camera's distance (in whole units) as the scene began and once it ended
extern u16 gCompleteTestLegend[5];
// The Magnet Train's ride (src/applications/complete_magnet_train/magnet_train.c): the cuts played, the first cut's
// model (its member in the archive), the frames the ride ran and whether it ended; and, as it runs, its first light's
// color, its diffuse color, the main screen's layers (DISPCNT's low half) and its brightness (MASTER_BRIGHT)
extern u16 gCompleteTestMagnetTrain[8];
// The legendary cinematics (src/applications/complete_legend_cinematic/legend_cinematic.c): 0x100 + the cinematic as it
// begins, its step, the frames drawn, the models loaded, whether the motion blur is on, the main screen's layers
// (DISPCNT's low half), its brightness (MASTER_BRIGHT) and whether it has ended
extern u16 gCompleteTestLegendCinematic[8];
// The player's sprite (its graphics ID) as the field last ran, for tools/complete/test_hgss_rocket_costume.py
extern u16 gCompleteTestPlayerGfx;

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

// The static encounters scripts have started (CreateWildMon_Scripted, src/overlay006/wild_encounters.c), for
// tools/complete/test_hgss_special_events.py: how many, and the last foe's species, level and whether it's shiny.
typedef struct CompleteTestScriptedWild {
    u16 count;
    u16 species;
    u16 level;
    u16 shiny;
} CompleteTestScriptedWild;

extern CompleteTestScriptedWild gCompleteTestScriptedWild;

// tools/test/battle_mechanics.py: while set, Sinnoh's trainers keep Sovereign's levels (CompleteSinnoh_ScaleParty), so
// Sovereign's recorded double battles replay as they were recorded.
extern u8 gCompleteTestSovereignLevels;

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
// fanfare for COMPLETE_TEST_SOUND_FANFARE, otherwise a field song as a map's, a sound effect and any other as a
// script plays it.
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

// HeartGold's overlay 97, the Pokéathlon course's choice of three Pokémon (include/complete_pokeathlon_select.h), for
// a test of it. The harness sets open to the course + 1 (HeartGold's courses: 1 to 5, for 0 to 4) and supreme (TRUE:
// "Supreme" by its name); the next free field frame fades the field out, closes it and opens the screen as the course
// would (one player, the save's party and boxes), and once the screen ends brings the field back and clears open.
// step says where that is (1 leaving the field, 2 on the screen, 3 coming back, 0 back on the field) and runs counts
// the runs ended. The screen's own answer is in args: cancelled (0 three chosen, 1 backed out; 0xFFFFFFFF until it
// ends) and the three chosen's species, form, personality, nickname and stars, each one's box (18: the party) and
// slot in picks. appFree is the application heap's free bytes with the field closed, before the screen's heap
// (0x72000) was made from it; heapFree the screen's heap's fewest free bytes seen at the start of a frame, and
// heapLeft its free bytes after the screen's exit (all of it but its own bookkeeping, unless something wasn't freed).
typedef struct CompleteTestPokeathlonSelect {
    u8 open;
    u8 supreme;
    u8 step;
    u8 runs;
    u8 picks[3][2];
    u16 padding;
    u32 appFree;
    u32 heapFree;
    u32 heapLeft;
    HgssPokeathlonCourseArgs courseArgs;
    HgssPokeathlonSelectArgs args;
} CompleteTestPokeathlonSelect;

extern CompleteTestPokeathlonSelect gCompleteTestPokeathlonSelect;

// HeartGold's Pokéathlon course (include/complete_pokeathlon_course.h), for a test of it. The harness sets open to the
// course + 1 (1 to 5: Speed, Power, Skill, Stamina, Jump) and supreme (TRUE: the Supreme Cup's); the next free field
// frame fades the field out, closes it and runs the course as HeartGold's reception does (its script command 611's
// task: one player, the course and the Supreme flag in its arguments), and once it ends brings the field back and
// clears open. step says where that is (1 leaving the field, 2 the course, 3 coming back, 0 back on the field), runs
// counts the runs ended. Each frame of the course notes its state (its state function's index, 0-38; lastState the
// highest seen), its event index and event (its data's 0x1F0 and the event number there, 0-9) and counts frames.
// appFree is the application heap's free bytes with the field closed, before the course made its heap (0x72000);
// heapFree that heap's fewest free bytes seen; heapLeft its free bytes as the course ended, before it was destroyed
// (all of it but its own bookkeeping, unless something wasn't freed). args are the course's arguments, which hold its
// results once it ends (HgssPokeathlonCourseResults from 0x08: points, score, course, medal, result).
typedef struct CompleteTestPokeathlonCourse {
    u8 open;
    u8 supreme;
    u8 step;
    u8 runs;
    u8 state;
    u8 lastState;
    u8 eventIndex;
    u8 event;
    u32 frames;
    u32 appFree;
    u32 heapFree;
    u32 heapLeft;
    HgssPokeathlonCourseArgs args;
} CompleteTestPokeathlonCourse;

extern CompleteTestPokeathlonCourse gCompleteTestPokeathlonCourse;

// HeartGold's Apricorn Box app (include/complete_aprijuice.h) from the field, as the Aprijuice stand's clerk opens it:
// open = 1 + its mode (HGSS_APRICORN_BOX_MODE_*), juice the stand's (ScrCmd_741's index); step (1-3 while it runs), runs;
// result (the stand's: whether a Pokémon drank)
typedef struct CompleteTestAprijuice {
    u8 open;
    u8 juice;
    u8 step;
    u8 runs;
    u16 result;
    u8 stage; // how far the app's launcher got (hgss_compat_apricorn.c): 1-5 in its Init, 6 running, 7 its Exit done
    u8 innerState; // HeartGold's app's state (its ApplicationManager's procState << 4 | execState)
    u32 appFree;
    u32 subState; // HeartGold's overlay 59, run by its overlay 58: procState << 8 | execState
    HgssApricornBoxArgs args;
} CompleteTestAprijuice;

extern CompleteTestAprijuice gCompleteTestAprijuice;

void CompleteTest_FieldFrame(FieldSystem *fieldSystem);
BOOL CompleteTest_NoteSoundLoad(BOOL loaded, u16 id);

#else

#define CompleteTest_NoteSoundLoad(loaded, id) (loaded)

#endif

#endif // POKEPLATINUM_COMPLETE_TEST_H
