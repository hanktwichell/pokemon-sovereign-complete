#ifndef POKEPLATINUM_COMPLETE_TRAINERS_H
#define POKEPLATINUM_COMPLETE_TRAINERS_H

#include "generated/trainers.h"
#include "generated/vars_flags.h"

#include "data/hgss_trainers.h"

#include "vars_flags.h"

// Sovereign Complete: the flag that records a trainer's defeat. Sinnoh's trainers use their block
// (TRAINER_DEFEATED_FLAGS_START + trainer); HeartGold's (TRAINER_HGSS_FIRST on, tools/complete/import_hgss_trainers.py)
// use HeartGold's own trainer flags (its flag 0x550 + its trainer number), which are FLAG_HGSS_* in the save
// (COMPLETE_FLAGS_START + HeartGold's flag).
#define HGSS_TRAINER_FLAG_BASE 0x550

// The Indigo Plateau's double-battle teams (after HeartGold's, in the order Will, Koga, Bruno, Karen, then their
// rematch teams) count as their members' own teams: a win records the singles team's flag
#define TRAINER_COMPLETE_INDIGO_FIRST TRAINER_COMPLETE_INDIGO_WILL_DOUBLES
#define TRAINER_COMPLETE_INDIGO_LAST  TRAINER_COMPLETE_INDIGO_KAREN_REMATCH_DOUBLES

static inline u16 CompleteTrainer_IndigoSingles(u16 trainerID)
{
    static const u16 singles[] = {
        TRAINER_HGSS_ELITE_FOUR_WILL_WILL, TRAINER_HGSS_ELITE_FOUR_KOGA_KOGA, TRAINER_HGSS_ELITE_FOUR_BRUNO_BRUNO,
        TRAINER_HGSS_ELITE_FOUR_KAREN_KAREN, TRAINER_HGSS_ELITE_FOUR_WILL_WILL_2, TRAINER_HGSS_ELITE_FOUR_KOGA_KOGA_2,
        TRAINER_HGSS_ELITE_FOUR_BRUNO_BRUNO_2, TRAINER_HGSS_ELITE_FOUR_KAREN_KAREN_2
    };

    return singles[trainerID - TRAINER_COMPLETE_INDIGO_FIRST];
}

static inline u16 Trainer_DefeatedFlag(u16 trainerID)
{
    if (trainerID >= TRAINER_COMPLETE_INDIGO_FIRST && trainerID <= TRAINER_COMPLETE_INDIGO_LAST) {
        trainerID = CompleteTrainer_IndigoSingles(trainerID);
    }

    if (trainerID >= TRAINER_HGSS_FIRST && trainerID <= TRAINER_HGSS_LAST) {
        return COMPLETE_FLAGS_START + HGSS_TRAINER_FLAG_BASE + (trainerID - TRAINER_HGSS_FIRST + 1);
    }

    return TRAINER_DEFEATED_FLAGS_START + trainerID;
}

// HeartGold's classes (TRAINER_CLASS_HGSS_*, tools/complete/import_hgss_trainer_classes.py) play their Sinnoh
// stand-in class's music (eyes-meet, encounter, victory) until HeartGold's music comes in; other classes are their own.
u32 CompleteTrainerClass_StandIn(u32 trainerClass);
BOOL CompleteTrainerClass_IsHGSS(u32 trainerClass);

#endif // POKEPLATINUM_COMPLETE_TRAINERS_H
