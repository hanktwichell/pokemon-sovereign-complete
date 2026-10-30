#include "complete_rival.h"

#include <nitro.h>

#include "constants/charcode.h"
#include "constants/string.h"
#include "generated/vars_flags.h"

#include "charcode.h"
#include "savedata.h"
#include "string_gf.h"
#include "vars_flags.h"

// Sovereign Complete: Johto's rival's name is kept in eight vars from VAR_COMPLETE_RIVAL_NAME, a character in each
// (Sacred Gold's vars 61B6 to 61BD, which its scripts never use: tools/complete/import_hgss_events.py), so the save
// keeps its layout. The vars start at 0, which no name begins with: until the player names him, his trainer data's
// name (Silver) stands.

#define RIVAL_NAME_CHARS (TRAINER_NAME_LEN + 1)

void CompleteRival_SetName(SaveData *saveData, const String *name)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);
    charcode_t chars[RIVAL_NAME_CHARS];

    String_ToChars(name, chars, RIVAL_NAME_CHARS);

    for (int i = 0; i < RIVAL_NAME_CHARS; i++) {
        *VarsFlags_GetVarAddress(varsFlags, VAR_COMPLETE_RIVAL_NAME + i) = chars[i];
    }
}

BOOL CompleteRival_GetName(SaveData *saveData, charcode_t *name)
{
    VarsFlags *varsFlags = SaveData_GetVarsFlags(saveData);

    for (int i = 0; i < RIVAL_NAME_CHARS; i++) {
        name[i] = *VarsFlags_GetVarAddress(varsFlags, VAR_COMPLETE_RIVAL_NAME + i);
    }

    name[RIVAL_NAME_CHARS - 1] = CHAR_EOS;
    return name[0] != 0;
}
