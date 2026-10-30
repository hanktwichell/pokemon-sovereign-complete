#ifndef POKEPLATINUM_APPLICATIONS_COMPLETE_ALPH_PUZZLE_H
#define POKEPLATINUM_APPLICATIONS_COMPLETE_ALPH_PUZZLE_H

#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Ruins of Alph sliding puzzles (its alph_puzzle.c), on the touch screen: a solved
// puzzle sets its FLAG_HGSS_SYS_ALPH_PUZZLE_* flag.

enum CompleteAlphPuzzle {
    COMPLETE_ALPH_PUZZLE_KABUTO = 0,
    COMPLETE_ALPH_PUZZLE_AERODACTYL,
    COMPLETE_ALPH_PUZZLE_OMANYTE,
    COMPLETE_ALPH_PUZZLE_HO_OH,
    COMPLETE_ALPH_PUZZLE_MAX,
};

typedef struct CompleteAlphPuzzleArgs {
    SaveData *saveData;
    u8 puzzle;
} CompleteAlphPuzzleArgs;

BOOL CompleteAlphPuzzle_Init(ApplicationManager *appMan, int *state);
BOOL CompleteAlphPuzzle_Main(ApplicationManager *appMan, int *state);
BOOL CompleteAlphPuzzle_Exit(ApplicationManager *appMan, int *state);

#endif // POKEPLATINUM_APPLICATIONS_COMPLETE_ALPH_PUZZLE_H
