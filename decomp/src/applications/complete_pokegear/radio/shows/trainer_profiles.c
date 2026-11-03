#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"
#include "math_util.h"

#include "generated/text_banks.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0420.h"

// Sovereign Complete: Trainer Profiles (HeartGold's shows/trainer_profiles.c), on the third station in the even
// hours: three of its sixteen trainers, none twice

typedef struct TrainerProfilesData {
    u16 state;
    u8 msgIDs[3];
    u8 selector;
} TrainerProfilesData;

static BOOL AlreadyPicked(TrainerProfilesData *data, u8 msgID, u8 index)
{
    for (int i = 0; i < index; ++i) {
        if (data->msgIDs[i] == msgID) {
            return TRUE;
        }
    }

    return FALSE;
}

BOOL RadioShow_TrainerProfiles_Setup(RadioShow *radioShow)
{
    TrainerProfilesData *data = RadioShow_AllocShowData(radioShow, sizeof(TrainerProfilesData));

    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0420, TRUE);

    for (int i = 0; i < 3; ++i) {
        u8 msgID;

        do {
            msgID = msg_0420_00004 + (LCRNG_Next() % 16);
        } while (AlreadyPicked(data, msgID, i));

        data->msgIDs[i] = msgID;
    }

    CompleteRadio_StopSeq(0);
    CompleteRadio_PlaySeq(SEQ_GS_RADIO_TRAINER_sseq);
    return FALSE;
}

BOOL RadioShow_TrainerProfiles_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_TrainerProfiles_Print(RadioShow *radioShow)
{
    TrainerProfilesData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInitEz(radioShow, msg_0420_00002);
        ++data->state;
        break;
    case 1:
        if (!Radio_RunTextPrinter(radioShow)) {
            break;
        }
        ++data->state;
        // fallthrough
    case 2:
        RadioPrintInitEz(radioShow, data->msgIDs[data->selector]);
        ++data->state;
        break;
    case 3:
        if (!Radio_RunTextPrinter(radioShow)) {
            break;
        }

        data->state = ++data->selector < 3 ? 2 : 4;
        break;
    case 4:
        if (RadioShow_DelayAndScrollLine(radioShow)) {
            RadioPrintAndPlayJingle(radioShow, msg_0420_00003);
            ++data->state;
        }
        break;
    case 5:
        if (Radio_RunTextPrinter_WaitJingle(radioShow)) {
            radioShow->triggerCommercials = TRUE;
            return TRUE;
        }
        break;
    }

    return FALSE;
}
