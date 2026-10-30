#ifndef POKEPLATINUM_COMPLETE_RIVAL_H
#define POKEPLATINUM_COMPLETE_RIVAL_H

#include "constants/string.h"

#include "charcode.h"
#include "savedata.h"
#include "string_gf.h"

// Sovereign Complete: Johto's rival's name (HeartGold's NameRival), apart from Platinum's rival's
// (MiscSaveBlock's rivalName).
void CompleteRival_SetName(SaveData *saveData, const String *name);
// The name as the player gave it (TRAINER_NAME_LEN + 1 characters with the end), or FALSE before they have.
BOOL CompleteRival_GetName(SaveData *saveData, charcode_t *name);

#endif // POKEPLATINUM_COMPLETE_RIVAL_H
