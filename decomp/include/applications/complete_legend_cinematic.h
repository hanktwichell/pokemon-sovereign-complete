#ifndef POKEPLATINUM_APPLICATIONS_COMPLETE_LEGEND_CINEMATIC_H
#define POKEPLATINUM_APPLICATIONS_COMPLETE_LEGEND_CINEMATIC_H

#include "overlay005/model_attributes.h"

#include "overlay_manager.h"

// Sovereign Complete: HeartGold's legendary cinematics (its overlay 106, which its script command Cinematic starts
// between the field's fades): Ho-Oh flying in over the Bell Tower, Lugia rising from the Whirl Islands' water, and
// Arceus coming down at the Sinjoh Ruins, HeartGold's own
// (src/applications/complete_legend_cinematic/legend_cinematic.c).

#define COMPLETE_LEGEND_ARCEUS_FORMS 18 // Arceus's walking sprites, one for each form

enum CompleteLegendCinematic {
    COMPLETE_LEGEND_CINEMATIC_HO_OH = 0, // HeartGold's Cinematic 0
    COMPLETE_LEGEND_CINEMATIC_LUGIA, // Cinematic 1
    COMPLETE_LEGEND_CINEMATIC_ARCEUS, // Cinematic 2
    COMPLETE_LEGEND_CINEMATICS,
};

typedef struct CompleteLegendCinematicArgs {
    u8 cinematic;
    u8 timeOfDay; // HeartGold's three: the morning and the day, the evening, the night and late at night
    u8 arceusForm; // Arceus's walking sprite: the lead's form and colors if the lead is Arceus, as HeartGold has it
    u8 arceusShiny;
    ModelAttributes light; // the field's light as the cinematic begins (HeartGold copies its FieldSystem's)
} CompleteLegendCinematicArgs;

BOOL CompleteLegendCinematic_Init(ApplicationManager *appMan, int *state);
BOOL CompleteLegendCinematic_Main(ApplicationManager *appMan, int *state);
BOOL CompleteLegendCinematic_Exit(ApplicationManager *appMan, int *state);

#endif // POKEPLATINUM_APPLICATIONS_COMPLETE_LEGEND_CINEMATIC_H
