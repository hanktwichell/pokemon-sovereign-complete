#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_SELECT_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_SELECT_H

#include "constants/heap.h"

#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's overlay 97, the Pokéathlon course's first screen (choosing the course's three
// Pokémon from the party and the boxes), HeartGold's assembly as it is (decomp/asm/complete_hgss/overlay_97.s and the
// main-module files it calls, through the shims in src/applications/complete_pokeathlon/hgss_compat.c), in the overlay
// complete_pokeathlon_select. HeartGold's course (its overlay 96) runs it as a child process, in the course's heap
// (HeartGold's HEAP_ID_POKEATHLON, the number its assembly passes), with these arguments. Nothing in Complete's game
// opens it yet; a test build's hook does (gCompleteTestPokeathlonSelect, include/complete_test.h).

// HeartGold's heap for the Pokéathlon's screens: the same number is an unused heap ID in Platinum, so the assembly's
// heap needs no translation. Whoever runs the screen makes it first (the course: 0x72000 from HeartGold's
// application heap, for all of the course).
#define HGSS_HEAP_ID_POKEATHLON HEAP_ID_92

// The start of HeartGold's PokeathlonCourseArgs (pret's include/pokeathlon/pokeathlon.h), what overlay 97 reads of it
typedef struct HgssPokeathlonCourseArgs {
    SaveData *saveData;
    u32 mode; // 0 one player; 1 link play (left out of Complete)
    u8 unk_08[7];
    u8 supreme; // the Supreme Cup's: "Supreme" shown by the course's name
} HgssPokeathlonCourseArgs;

// A Pokémon chosen, as overlay 97 hands it back (HeartGold's course keeps the three in its data from 0x204)
typedef struct HgssPokeathlonEntrant {
    u16 species;
    u16 form;
    u32 personality;
    u8 stars[5]; // today's stars, its five stats in the order the course keeps them
    u8 padding_0D;
    u16 starColors; // 3 bits a stat, in another order: 0 at its base, 1 above it, 2 below it
    u8 shiny;
    u8 gender;
    u16 nickname[11]; // MON_DATA_NICKNAME's characters
} HgssPokeathlonEntrant;

// What overlay 97's arguments point at: HeartGold's course data from its PokeathlonCourseArgs pointer (0x1F8) on
typedef struct HgssPokeathlonSelectArgs {
    HgssPokeathlonCourseArgs *courseArgs;
    u32 cancelled; // set as it ends: 0 when three were chosen (entrants), 1 when the player backed out
    u8 unk_08[4];
    HgssPokeathlonEntrant entrants[3];
    u32 course; // the course whose name it shows (BufferPokeathlonCourseName's, the low byte)
} HgssPokeathlonSelectArgs;

// HeartGold's overlay 97's application: its init, main and exit
BOOL ov97_0221E5C0(ApplicationManager *appMan, int *state);
BOOL ov97_0221E5D4(ApplicationManager *appMan, int *state);
BOOL ov97_0221E69C(ApplicationManager *appMan, int *state);

#ifdef SOVEREIGN_TEST
// The test build's way in (src/applications/complete_pokeathlon/select_test.c): overlay 97 on its own, with the
// course's heap and arguments made around it and what it did recorded
BOOL CompletePokeathlonSelect_TestInit(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonSelect_TestMain(ApplicationManager *appMan, int *state);
BOOL CompletePokeathlonSelect_TestExit(ApplicationManager *appMan, int *state);
#endif

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_SELECT_H
