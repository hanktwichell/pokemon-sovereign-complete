#include "complete_pokedex.h"

#include <nitro.h>
#include <string.h>

#include "generated/species.h"
#include "generated/vars_flags.h"

#include "heap.h"
#include "savedata.h"
#include "vars_flags.h"

#include "data/hgss_johto_dex.h"

// Johto's is the regional Pokédex until Sinnoh's story begins: the first ship to Sinnoh leaves the player in their
// room in Twinleaf Town, where Platinum's opening (its TV program) moves VAR_PLAYER_HOUSE_SPECIAL_PROGRAM_STATE on
// from 0 (docs/Features.md, "Sinnoh, the third region")
BOOL CompletePokedex_IsJohto(void)
{
    SaveData *saveData = SaveData_Ptr();

    if (saveData == NULL) {
        return FALSE;
    }

    return *VarsFlags_GetVarAddress(SaveData_GetVarsFlags(saveData), VAR_PLAYER_HOUSE_SPECIAL_PROGRAM_STATE) == 0;
}

u16 CompletePokedex_JohtoNumber(u16 species)
{
    return species < NELEMS(sHGSSJohtoDexNumbers) ? sHGSSJohtoDexNumbers[species] : 0;
}

const u16 *CompletePokedex_JohtoList(void)
{
    return sHGSSJohtoDex;
}

u16 *CompletePokedex_NewJohtoList(enum HeapID heapID, int *length)
{
    u16 *list = Heap_Alloc(heapID, sizeof(sHGSSJohtoDex));

    memcpy(list, sHGSSJohtoDex, sizeof(sHGSSJohtoDex));
    *length = NELEMS(sHGSSJohtoDex);
    return list;
}

BOOL CompletePokedex_CountsForJohtoGoal(u16 species)
{
    return CompletePokedex_JohtoNumber(species) != 0 && species != SPECIES_MEW && species != SPECIES_CELEBI;
}
