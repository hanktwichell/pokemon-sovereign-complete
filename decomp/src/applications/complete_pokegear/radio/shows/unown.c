#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"

#include "generated/text_banks.h"
#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: the Unown's broadcast in the Ruins of Alph (HeartGold's shows/unown.c): their strange sound,
// and no lines; while it plays, the hall's Unown are often letters the Pokédex hasn't seen (src/complete_encounters.c)

BOOL RadioShow_Unown_Setup(RadioShow *radioShow)
{
    radioShow->showData = NULL;
    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0410, FALSE);
    CompleteRadio_StopSeq(1);
    CompleteRadio_PlaySeq(SEQ_GS_RADIO_UNKNOWN_sseq);
    return FALSE;
}

BOOL RadioShow_Unown_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_Unown_Print(RadioShow *radioShow)
{
    return FALSE;
}
