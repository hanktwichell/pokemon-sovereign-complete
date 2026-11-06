#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_H

#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Pokéathlon record screens (its overlay 99, written in C from its assembly in
// src/applications/complete_pokeathlon_records/, with the parts its overlay 98 gives them), which the Dome's record
// rooms open (HeartGold's ScrCmd_712, CompleteScrCmd_PokeathlonRecordScreen) between the script's fades. Ported so far:
// the course record (ScrCmd_712 0); the medals (1), the event records (2) and HeartGold's fourth screen (3) come later.

enum CompletePokeathlonRecordScreen {
    COMPLETE_POKEATHLON_SCREEN_COURSE_RECORD = 0, // HeartGold's PokeathlonCourseRecord
    COMPLETE_POKEATHLON_SCREEN_MEDALS, // PokeathlonMedals (not ported yet)
    COMPLETE_POKEATHLON_SCREEN_EVENT_RECORD, // PokeathlonEventRecord (not ported yet)
    COMPLETE_POKEATHLON_SCREEN_UNK_3, // PokeathlonUnk (not ported yet)
};

// HeartGold's PokeathlonCourseRecordArgs: the save (the screen reads the Pokéathlon's from it) and its unk4, whether
// FLAG_HGSS_UNK_0EF, 0F0 and 0F1 are all set (sub_0203EE54: every course, event and medal played), with which a course's
// page says the points its Collective Trophy needs
typedef struct CompletePokeathlonCourseRecordArgs {
    SaveData *saveData;
    BOOL trophyGoals;
} CompletePokeathlonCourseRecordArgs;

// src/applications/complete_pokeathlon_records/course_record.c (overlay complete_pokeathlon_records)
BOOL CompletePokeathlonCourseRecord_Init(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonCourseRecord_Main(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonCourseRecord_Exit(ApplicationManager *appMan, int *state);

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_H
