#include "level_cap.h"

#include <nitro.h>

#include "constants/pokemon.h"

#include "data/complete_sinnoh.h" // Sovereign Complete: all three regions' caps
#include "data/level_caps.h"
#include "generated/vars_flags.h"

#include "complete_trainers.h"
#include "sovereign_options.h"
#include "savedata.h"
#include "vars_flags.h"

static BOOL IsTrainerDefeated(VarsFlags *varsFlags, u16 trainerID)
{
    return VarsFlags_CheckFlag(varsFlags, Trainer_DefeatedFlag(trainerID)); // Sovereign Complete
}

static BOOL IsStepCleared(VarsFlags *varsFlags, const LevelCapStep *step)
{
    for (int j = 0; j < LEVEL_CAP_MAX_TRAINERS_PER_STEP; j++) {
        if (step->trainers[j] == TRAINER_NONE) {
            continue;
        }

        BOOL defeated = IsTrainerDefeated(varsFlags, step->trainers[j]);

        if (step->mode == LEVEL_CAP_ANY && defeated) {
            return TRUE;
        }

        if (step->mode == LEVEL_CAP_ALL && !defeated) {
            return FALSE;
        }
    }

    return step->mode == LEVEL_CAP_ALL;
}

u8 LevelCap_ForProgress(SaveData *saveData)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);

    // Sovereign Complete: Johto's, Kanto's and Sinnoh's fights in story order (data/complete/sinnoh.yaml), in place of
    // Sovereign's list for Sinnoh alone (sLevelCapSteps)
    for (int i = 0; i < NELEMS(sCompleteLevelCapSteps); i++) {
        if (!IsStepCleared(varsFlags, &sCompleteLevelCapSteps[i])) {
            return sCompleteLevelCapSteps[i].level;
        }
    }

    return MAX_POKEMON_LEVEL;
}

u8 LevelCap_Get(SaveData *saveData)
{
    if (saveData == NULL || !SovereignOptions_LevelCapEnabled(SaveData_GetSovereignOptions(saveData))) {
        return MAX_POKEMON_LEVEL;
    }

    return LevelCap_ForProgress(saveData);
}
