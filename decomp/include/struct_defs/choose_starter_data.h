#ifndef POKEPLATINUM_STRUCT_020425E0_H
#define POKEPLATINUM_STRUCT_020425E0_H

#include "game_options.h"

typedef struct ChooseStarterData {
    int species;
    const Options *options;
    BOOL johto; // Sovereign Complete: Professor Elm's three (src/choose_starter/choose_starter_app.c)
} ChooseStarterData;

#endif // POKEPLATINUM_STRUCT_020425E0_H
