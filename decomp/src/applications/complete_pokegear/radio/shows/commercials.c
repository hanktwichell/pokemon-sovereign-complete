#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"
#include "math_util.h"
#include "vars_flags.h"

#include "generated/text_banks.h"
#include "generated/vars_flags.h"
#include "res/text/bank/hgss_msg_0412.h"

// Sovereign Complete: the commercials after a talk show (HeartGold's shows/commercials.c): one of those for the region
// and the station, with more as the player gets on (towns flown to, the Pokédex, the Power Plant, the game's end), in
// the quiet after the show's jingle

enum CommercialUnlockFlag {
    COMM_UNLOCK_ALWAYS,
    COMM_UNLOCK_POKEDEX,
    COMM_UNLOCK_ECRUTEAK,
    COMM_UNLOCK_CIANWOOD,
    COMM_UNLOCK_OLIVINE,
    COMM_UNLOCK_GAME_CLEAR,
    COMM_UNLOCK_VERMILION,
    COMM_UNLOCK_RESTORED_POWER,
};

enum CommercialRegion {
    COMM_REGION_JOHTO_F = 1,
    COMM_REGION_KANTO_F = 2,
};

typedef struct CommercialsData {
    u16 state;
    u16 msgID;
    u8 commercialUnlockFlags[8];
    u8 unlockedCommercials[36];
} CommercialsData;

// Each: what lets it play, the regions it plays in, and its station (0xFF any)
static const u8 sCommercialsData[][3] = {
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F, 0xFF },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 2 },
    { COMM_UNLOCK_ALWAYS, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 2 },
    { COMM_UNLOCK_POKEDEX, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_POKEDEX, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_POKEDEX, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_POKEDEX, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 0xFF },
    { COMM_UNLOCK_ECRUTEAK, COMM_REGION_JOHTO_F, 3 },
    { COMM_UNLOCK_ECRUTEAK, COMM_REGION_JOHTO_F, 3 },
    { COMM_UNLOCK_ECRUTEAK, COMM_REGION_JOHTO_F, 3 },
    { COMM_UNLOCK_ECRUTEAK, COMM_REGION_JOHTO_F, 2 },
    { COMM_UNLOCK_ECRUTEAK, COMM_REGION_JOHTO_F, 2 },
    { COMM_UNLOCK_ECRUTEAK, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 2 },
    { COMM_UNLOCK_CIANWOOD, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 2 },
    { COMM_UNLOCK_CIANWOOD, COMM_REGION_JOHTO_F, 3 },
    { COMM_UNLOCK_OLIVINE, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 1 },
    { COMM_UNLOCK_OLIVINE, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 1 },
    { COMM_UNLOCK_OLIVINE, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 1 },
    { COMM_UNLOCK_OLIVINE, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 1 },
    { COMM_UNLOCK_OLIVINE, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 1 },
    { COMM_UNLOCK_OLIVINE, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 1 },
    { COMM_UNLOCK_GAME_CLEAR, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 3 },
    { COMM_UNLOCK_VERMILION, COMM_REGION_KANTO_F, 3 },
    { COMM_UNLOCK_VERMILION, COMM_REGION_KANTO_F, 3 },
    { COMM_UNLOCK_VERMILION, COMM_REGION_KANTO_F, 3 },
    { COMM_UNLOCK_VERMILION, COMM_REGION_KANTO_F, 3 },
    { COMM_UNLOCK_VERMILION, COMM_REGION_KANTO_F, 3 },
    { COMM_UNLOCK_RESTORED_POWER, COMM_REGION_JOHTO_F | COMM_REGION_KANTO_F, 3 },
};

BOOL RadioShow_Commercials_Setup(RadioShow *radioShow)
{
    CommercialsData *data = RadioShow_AllocShowData(radioShow, sizeof(CommercialsData));
    VarsFlags *varsFlags = SaveData_GetVarsFlags(radioShow->saveData);
    u8 num = 0;

    radioShow->triggerCommercials = FALSE;
    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0412, FALSE);
    data->commercialUnlockFlags[COMM_UNLOCK_ALWAYS] = 1;
    data->commercialUnlockFlags[COMM_UNLOCK_POKEDEX] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_GOT_POKEDEX);
    data->commercialUnlockFlags[COMM_UNLOCK_ECRUTEAK] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_ECRUTEAK);
    data->commercialUnlockFlags[COMM_UNLOCK_CIANWOOD] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_CIANWOOD);
    data->commercialUnlockFlags[COMM_UNLOCK_OLIVINE] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_OLIVINE);
    data->commercialUnlockFlags[COMM_UNLOCK_VERMILION] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_VERMILION);
    data->commercialUnlockFlags[COMM_UNLOCK_GAME_CLEAR] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_GAME_CLEAR);
    data->commercialUnlockFlags[COMM_UNLOCK_RESTORED_POWER] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_RESTORED_POWER);

    for (u8 i = 0; i < NELEMS(sCommercialsData); ++i) {
        if (!data->commercialUnlockFlags[sCommercialsData[i][0]]) {
            continue;
        }

        if (sCommercialsData[i][2] != 0xFF && sCommercialsData[i][2] != radioShow->nextStation) {
            continue;
        }

        if (sCommercialsData[i][1] & (radioShow->regionNo + 1)) {
            data->unlockedCommercials[num++] = i;
        }
    }

    data->msgID = msg_0412_00002 + data->unlockedCommercials[LCRNG_Next() % num];
    return FALSE;
}

BOOL RadioShow_Commercials_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_Commercials_Print(RadioShow *radioShow)
{
    CommercialsData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInit(radioShow, data->msgID, 1);
        ++data->state;
        break;
    case 1:
        if (Radio_RunTextPrinter(radioShow)) {
            ++data->state;
        }
        break;
    case 2:
        if (RadioShow_Delay(radioShow)) {
            return TRUE;
        }
        break;
    }

    return FALSE;
}
