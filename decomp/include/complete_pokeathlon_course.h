#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_COURSE_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_COURSE_H

#include "complete_pokeathlon_select.h"
#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Pokéathlon course (its overlay 96, the course and its ten events), HeartGold's
// assembly as it is in decomp/asm/complete_hgss/, and pret's C for the course's frame
// (src/applications/complete_pokeathlon/course.c), in the overlay complete_pokeathlon_course. It runs on the shims its
// assembly calls (src/applications/complete_pokeathlon/hgss_compat*.c, with HeartGold's TextOBJ file), an overlay of
// their own, complete_hgss_compat, which whoever starts the course loads first; the course loads its choice of
// Pokémon (HeartGold's overlay 97, complete_pokeathlon_select) and its overlay 98 (complete_pokeathlon_parts) after
// itself as it goes.
//
// HeartGold's reception starts a course with its script command 611 (pret's ScrCmd_Pokeathlon: `Pokeathlon link,
// supreme, VAR_SPECIAL_x8000, VAR_SPECIAL_RESULT, VAR_SPECIAL_x8001, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003`, its
// scr_seq_0167 and scr_seq_0166), whose field task (sub_02095E30) runs the course as a child process with these
// arguments (HgssPokeathlonCourseArgs, include/complete_pokeathlon_select.h: the save, the mode, the course from
// VAR_SPECIAL_x8000 at 0x0C, the Supreme Cup's flag at 0x0F) and hands back four of its bytes into the script's
// variables. Nothing in Complete's game starts one yet; a test build's hook does (gCompleteTestPokeathlonCourse,
// include/complete_test.h).

// What the course hands back in its arguments (HeartGold's task's four variables)
typedef struct HgssPokeathlonCourseResults {
    u16 points; // 0x08 -> VAR_SPECIAL_x8002: the Athlete Points won
    u16 score; // 0x0A -> VAR_SPECIAL_x8001: the course's score
    u8 course; // 0x0C, the course run (0-4; the Supreme Cup's course with supreme set)
    u8 medal; // 0x0D -> VAR_SPECIAL_x8003
    u8 result; // 0x0E -> VAR_SPECIAL_RESULT (pret's "shouldFreeHeap": 1 when backed out before the course began)
    u8 supreme;
} HgssPokeathlonCourseResults;

// The course's application (pret's src/pokeathlon/pokeathlon_course.c)
BOOL PokeathlonCourse_Init(ApplicationManager *appMan, int *state);
BOOL PokeathlonCourse_Main(ApplicationManager *appMan, int *state);
BOOL PokeathlonCourse_Exit(ApplicationManager *appMan, int *state);

// The course's working copy of the Pokéathlon save (include/complete_pokeathlon.h), which HeartGold's save accessors
// hand out (src/applications/complete_pokeathlon/hgss_compat_save.c): read in when the course (or overlay 97 run on
// its own) starts, written back to the save's working copy when it ends (store TRUE)
void HgssCompat_PokeathlonSave_Open(SaveData *saveData, enum HeapID heapID);
void HgssCompat_PokeathlonSave_Close(SaveData *saveData, BOOL store);

#ifdef SOVEREIGN_TEST
// The course's progress for a test build's marker (gCompleteTestPokeathlonCourse, include/complete_test.h), noted each
// frame by course.c: its state index (the state function table's, 0-38), the event's, the heap's low point
void CompletePokeathlonCourse_TestNote(void *courseData);
void CompletePokeathlonCourse_TestExit(void); // the heap's free bytes as the course ends
#endif

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_COURSE_H
