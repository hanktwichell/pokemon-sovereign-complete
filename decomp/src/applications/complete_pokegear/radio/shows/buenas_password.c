#include <nitro.h>

#include "generated/items.h"

#include "applications/complete_pokegear/radio.h"

#include "bag.h"
#include "complete_radio.h"
#include "heap.h"
#include "message.h"
#include "vars_flags.h"

#include "generated/text_banks.h"
#include "generated/vars_flags.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0411.h"

// Sovereign Complete: Buena's Password (HeartGold's shows/buenas_password.c), on the fourth station in the hours after
// the drama's (2, 5, 8 and so on): today's password (CompleteRadio_BuenasPassword) for players with her Blue Card, who
// have then heard it today (FLAG_HGSS_DAILY_HEARD_BUENAS_PASSWORD); her quiz in the Radio Tower asks for it

#define BUENA_BANK_PASSWORDS 40 // her bank's (HeartGold's msg_0066_D23R0102) first password

typedef struct BuenasPasswordData {
    u16 state;
    u16 msgID;
} BuenasPasswordData;

BOOL RadioShow_BuenasPassword_Setup(RadioShow *radioShow)
{
    BuenasPasswordData *data = RadioShow_AllocShowData(radioShow, sizeof(BuenasPasswordData));

    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0411, TRUE);
    data->msgID = Bag_CanRemoveItem(SaveData_GetBag(radioShow->saveData), ITEM_BLUE_CARD, 1, radioShow->heapID) ? msg_0411_00004 : msg_0411_00005;

    MessageLoader *passwords = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0066, radioShow->heapID);
    String *answer = MessageLoader_GetNewString(passwords, BUENA_BANK_PASSWORDS + CompleteRadio_BuenasPassword(radioShow->saveData));

    StringTemplate_SetString(radioShow->template, 0, answer, 2, TRUE, GAME_LANGUAGE);
    String_Free(answer);
    MessageLoader_Free(passwords);

    CompleteRadio_StopSeq(0);
    CompleteRadio_PlaySeq(SEQ_GS_AIKOTOBA_sseq);
    return FALSE;
}

BOOL RadioShow_BuenasPassword_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_BuenasPassword_Print(RadioShow *radioShow)
{
    BuenasPasswordData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInitEz(radioShow, msg_0411_00002);
        ++data->state;
        break;
    case 1:
        if (Radio_RunTextPrinter(radioShow)) {
            RadioPrintInitEz(radioShow, data->msgID);

            if (data->msgID == msg_0411_00004) {
                VarsFlags_SetFlag(SaveData_GetVarsFlags(radioShow->saveData), FLAG_HGSS_DAILY_HEARD_BUENAS_PASSWORD);
            }

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
            RadioPrintAndPlayJingle(radioShow, msg_0411_00003);
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
