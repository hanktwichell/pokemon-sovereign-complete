#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_H

#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Pokéathlon record screens (its overlay 99, written in C from its assembly in
// src/applications/complete_pokeathlon_records/, with the parts its overlay 98 gives them), which the Dome's record
// rooms open (HeartGold's ScrCmd_712, CompleteScrCmd_PokeathlonRecordScreen) between the script's fades. Ported so far:
// the course record (ScrCmd_712 0), the medals (1) and the event record (2); HeartGold's fourth screen (3) comes later.

enum CompletePokeathlonRecordScreen {
    COMPLETE_POKEATHLON_SCREEN_COURSE_RECORD = 0, // HeartGold's PokeathlonCourseRecord
    COMPLETE_POKEATHLON_SCREEN_MEDALS, // PokeathlonMedals
    COMPLETE_POKEATHLON_SCREEN_EVENT_RECORD, // PokeathlonEventRecord
    COMPLETE_POKEATHLON_SCREEN_UNK_3, // PokeathlonUnk (not ported yet)
};

// Every screen's arguments (HeartGold's PokeathlonCourseRecordArgs, PokeathlonMedalsArgs and the others, each built
// from the save): the save, which each screen reads what it shows from (the Pokéathlon's, the Pokédex), and whether
// FLAG_HGSS_UNK_0EF, 0F0 and 0F1 are all set (sub_0203EE54, the HeartGold args' unk4, unkC and unk10), with which the
// screens say what the next trophy needs
typedef struct CompletePokeathlonRecordArgs {
    SaveData *saveData;
    BOOL trophyGoals;
} CompletePokeathlonRecordArgs;

// src/applications/complete_pokeathlon_records/course_record.c (overlay complete_pokeathlon_records)
BOOL CompletePokeathlonCourseRecord_Init(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonCourseRecord_Main(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonCourseRecord_Exit(ApplicationManager *appMan, int *state);

// src/applications/complete_pokeathlon_records/medals.c (overlay complete_pokeathlon_records)
BOOL CompletePokeathlonMedals_Init(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonMedals_Main(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonMedals_Exit(ApplicationManager *appMan, int *state);

// src/applications/complete_pokeathlon_records/event_record.c (overlay complete_pokeathlon_records)
BOOL CompletePokeathlonEventRecord_Init(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonEventRecord_Main(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonEventRecord_Exit(ApplicationManager *appMan, int *state);

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_H
