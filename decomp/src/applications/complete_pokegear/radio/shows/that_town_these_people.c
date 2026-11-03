#include <nitro.h>

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "heap.h"
#include "math_util.h"
#include "vars_flags.h"

#include "generated/text_banks.h"
#include "generated/vars_flags.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0415.h"

// Sovereign Complete: That Town, These People (HeartGold's shows/that_town_these_people.c), on the third station in
// the odd hours: three of its stories, those about towns the player has flown to, none twice

enum TTTPUnlockCondition {
    TTTP_COND_ALWAYS,
    TTTP_COND_GOLDENROD,
    TTTP_COND_MAHOGANY,
    TTTP_COND_BLACKTHORN,
    TTTP_COND_VERMILION,
};

typedef struct ThatTownThesePeopleData {
    u16 state;
    u8 msgIDs[3];
    u8 selector;
    u8 episodeUnlockFlags[5];
    u8 unlockedEpisodes[20];
} ThatTownThesePeopleData;

static const u8 sEpisodeUnlockFlags[] = {
    TTTP_COND_ALWAYS,
    TTTP_COND_ALWAYS,
    TTTP_COND_ALWAYS,
    TTTP_COND_ALWAYS,
    TTTP_COND_ALWAYS,
    TTTP_COND_ALWAYS,
    TTTP_COND_ALWAYS,
    TTTP_COND_GOLDENROD,
    TTTP_COND_MAHOGANY,
    TTTP_COND_BLACKTHORN,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
    TTTP_COND_VERMILION,
};

static BOOL AlreadyPicked(ThatTownThesePeopleData *data, u8 msgID, u8 index)
{
    for (int i = 0; i < index; ++i) {
        if (data->msgIDs[i] == msgID) {
            return TRUE;
        }
    }

    return FALSE;
}

BOOL RadioShow_ThatTownThesePeople_Setup(RadioShow *radioShow)
{
    ThatTownThesePeopleData *data = RadioShow_AllocShowData(radioShow, sizeof(ThatTownThesePeopleData));
    VarsFlags *varsFlags = SaveData_GetVarsFlags(radioShow->saveData);
    int num = 0;

    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0415, TRUE);
    data->episodeUnlockFlags[TTTP_COND_ALWAYS] = 1;
    data->episodeUnlockFlags[TTTP_COND_GOLDENROD] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_GOLDENROD);
    data->episodeUnlockFlags[TTTP_COND_MAHOGANY] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_MAHOGANY);
    data->episodeUnlockFlags[TTTP_COND_BLACKTHORN] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_BLACKTHORN);
    data->episodeUnlockFlags[TTTP_COND_VERMILION] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_VERMILION);

    for (int i = 0; i < (int)NELEMS(sEpisodeUnlockFlags); ++i) {
        if (data->episodeUnlockFlags[sEpisodeUnlockFlags[i]]) {
            data->unlockedEpisodes[num++] = i;
        }
    }

    for (int i = 0; i < 3; ++i) {
        u8 msgID;

        do {
            msgID = msg_0415_00004 + data->unlockedEpisodes[LCRNG_Next() % num];
        } while (AlreadyPicked(data, msgID, i));

        data->msgIDs[i] = msgID;
    }

    CompleteRadio_StopSeq(0);
    CompleteRadio_PlaySeq(SEQ_GS_RADIO_PT_sseq);
    return FALSE;
}

BOOL RadioShow_ThatTownThesePeople_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_ThatTownThesePeople_Print(RadioShow *radioShow)
{
    ThatTownThesePeopleData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInitEz(radioShow, msg_0415_00002);
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
            RadioPrintAndPlayJingle(radioShow, msg_0415_00003);
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
