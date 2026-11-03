#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"

#include "generated/text_banks.h"
#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: the strange signal around Mahogany Town before the Rocket Hideout is cleared (HeartGold's
// shows/mahogany_signal.c): the signal's sound, and no lines

BOOL RadioShow_MahoganySignal_Setup(RadioShow *radioShow)
{
    radioShow->showData = NULL;
    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0409, FALSE);
    CompleteRadio_StopSeq(1);
    CompleteRadio_PlaySeq(SEQ_GS_KAIDENPA_sseq);
    return FALSE;
}

BOOL RadioShow_MahoganySignal_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_MahoganySignal_Print(RadioShow *radioShow)
{
    return FALSE;
}
