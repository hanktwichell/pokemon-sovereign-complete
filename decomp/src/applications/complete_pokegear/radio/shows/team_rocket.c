#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"

#include "generated/text_banks.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0418.h"

// Sovereign Complete: Team Rocket's broadcast while they hold the Radio Tower (HeartGold's shows/team_rocket.c): their
// message, over and over

typedef struct TeamRocketRadioData {
    u8 state;
} TeamRocketRadioData;

BOOL RadioShow_TeamRocket_Setup(RadioShow *radioShow)
{
    RadioShow_AllocShowData(radioShow, sizeof(TeamRocketRadioData));
    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0418, TRUE);
    CompleteRadio_StopSeq(1);
    CompleteRadio_PlaySeq(SEQ_GS_SENKYO_R_sseq);
    return FALSE;
}

BOOL RadioShow_TeamRocket_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_TeamRocket_Print(RadioShow *radioShow)
{
    TeamRocketRadioData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInitEz(radioShow, msg_0418_00002);
        ++data->state;
        break;
    case 1:
        if (Radio_RunTextPrinter(radioShow)) {
            data->state = 0;
        }
        break;
    }

    return FALSE;
}
