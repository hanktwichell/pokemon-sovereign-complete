#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"

#include "generated/text_banks.h"
#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: the Poké Flute channel (HeartGold's shows/poke_flute.c): the flute's song, which wakes
// Snorlax, and no lines

BOOL RadioShow_PokeFlute_Setup(RadioShow *radioShow)
{
    radioShow->showData = NULL;
    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0417, FALSE);
    CompleteRadio_StopSeq(1);
    CompleteRadio_PlaySeq(SEQ_GS_HUE_sseq);
    return FALSE;
}

BOOL RadioShow_PokeFlute_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_PokeFlute_Print(RadioShow *radioShow)
{
    return FALSE;
}
