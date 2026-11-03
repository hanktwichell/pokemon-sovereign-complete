#ifndef POKEPLATINUM_APPLICATIONS_COMPLETE_MAGNET_TRAIN_H
#define POKEPLATINUM_APPLICATIONS_COMPLETE_MAGNET_TRAIN_H

#include "overlay005/model_attributes.h"

#include "overlay_manager.h"

// Sovereign Complete: HeartGold's Magnet Train ride (its overlay 104, and the field task that runs it, its
// unk_020977CC.s): three cuts of the train between Goldenrod City and Saffron City, HeartGold's own models, chosen by
// the way, the time of day and the player's gender (src/applications/complete_magnet_train/magnet_train.c).

enum CompleteMagnetTrainWay {
    COMPLETE_MAGNET_TRAIN_TO_SAFFRON = 0, // from Goldenrod City
    COMPLETE_MAGNET_TRAIN_TO_GOLDENROD,
    COMPLETE_MAGNET_TRAIN_WAYS,
};

typedef struct CompleteMagnetTrainArgs {
    u8 way;
    u8 gender;
    u8 night; // the evening, the night or late at night, as HeartGold picks its night models
    ModelAttributes light; // the area's first light (HeartGold's LoadAreaOrDungeonLightTxt(0)) at the time of the ride
} CompleteMagnetTrainArgs;

BOOL CompleteMagnetTrain_Init(ApplicationManager *appMan, int *state);
BOOL CompleteMagnetTrain_Main(ApplicationManager *appMan, int *state);
BOOL CompleteMagnetTrain_Exit(ApplicationManager *appMan, int *state);

#endif // POKEPLATINUM_APPLICATIONS_COMPLETE_MAGNET_TRAIN_H
