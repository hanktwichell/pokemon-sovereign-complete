#include "complete_trainers.h"

#include <nitro.h>

#include "data/hgss_trainer_classes.h"

// Sovereign Complete: HeartGold's trainers and classes (include/complete_trainers.h).

u32 CompleteTrainerClass_StandIn(u32 trainerClass)
{
    if (trainerClass >= TRAINER_CLASS_HGSS_FIRST && trainerClass <= TRAINER_CLASS_HGSS_LAST) {
        return sHGSSTrainerClassStandIns[trainerClass - TRAINER_CLASS_HGSS_FIRST];
    }

    return trainerClass;
}

BOOL CompleteTrainerClass_IsHGSS(u32 trainerClass)
{
    return trainerClass >= TRAINER_CLASS_HGSS_FIRST && trainerClass <= TRAINER_CLASS_HGSS_LAST;
}
