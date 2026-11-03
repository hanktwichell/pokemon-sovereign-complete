#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"
#include "math_util.h"

#include "generated/text_banks.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0413.h"

// Sovereign Complete: the Serial Radio Drama (HeartGold's shows/serial_radio_drama.c), on the fourth station in the
// hours after the Search Party's (1, 4, 7 and so on): one of its 22 episodes, never the last one heard twice running

#define EPISODES 22

typedef struct SerialRadioDramaShowData {
    u16 state;
    u16 episodeID;
} SerialRadioDramaShowData;

BOOL RadioShow_SerialRadioDrama_Setup(RadioShow *radioShow)
{
    SerialRadioDramaShowData *data = RadioShow_AllocShowData(radioShow, sizeof(SerialRadioDramaShowData));

    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0413, TRUE);
    data->episodeID = LCRNG_Next() % EPISODES;

    if (data->episodeID == radioShow->lastEpisodeID) {
        data->episodeID = (data->episodeID + 1) % EPISODES;
    }

    radioShow->lastEpisodeID = data->episodeID;
    CompleteRadio_StopSeq(0);
    CompleteRadio_PlaySeq(SEQ_GS_RADIO_VARIETY_sseq);
    return FALSE;
}

BOOL RadioShow_SerialRadioDrama_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_SerialRadioDrama_Print(RadioShow *radioShow)
{
    SerialRadioDramaShowData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInitEz(radioShow, msg_0413_00002);
        ++data->state;
        break;
    case 1:
        if (Radio_RunTextPrinter(radioShow)) {
            RadioPrintInitEz(radioShow, msg_0413_00004 + data->episodeID);
            ++data->state;
        }
        break;
    case 2:
        if (Radio_RunTextPrinter(radioShow)) {
            ++data->state;
        }
        break;
    case 3:
        if (RadioShow_DelayAndScrollLine(radioShow)) {
            RadioPrintAndPlayJingle(radioShow, msg_0413_00003);
            ++data->state;
        }
        break;
    case 4:
        if (Radio_RunTextPrinter_WaitJingle(radioShow)) {
            radioShow->triggerCommercials = TRUE;
            return TRUE;
        }
        break;
    }

    return FALSE;
}
