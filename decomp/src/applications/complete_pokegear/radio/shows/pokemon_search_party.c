#include <nitro.h>

#include "constants/hgss_badges.h"

#include "applications/complete_pokegear/radio.h"

#include "complete_badges.h"
#include "complete_radio.h"
#include "heap.h"
#include "math_util.h"
#include "trainer_info.h"
#include "vars_flags.h"

#include "generated/text_banks.h"
#include "generated/vars_flags.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0419.h"

// Sovereign Complete: the Pokémon Search Party (HeartGold's shows/pokemon_search_party.c), on the fourth station in
// every third hour (midnight, 3, 6 and so on; the drama and Buena's show the hours after): an episode of the search
// party's travels, the later ones as the player gets on

enum PSPEpisodeUnlockFlag {
    PSP_EPISODE_UNLOCK_ALWAYS,
    PSP_EPISODE_UNLOCK_AZALEA_ROCKETS,
    PSP_EPISODE_UNLOCK_PLAINBADGE,
    PSP_EPISODE_UNLOCK_TOWER_ROCKETS,
    PSP_EPISODE_UNLOCK_8BADGES,
    PSP_EPISODE_UNLOCK_9BADGES,
    PSP_EPISODE_UNLOCK_VERMILION,
    PSP_EPISODE_UNLOCK_16BADGES,
};

typedef struct PokemonSearchPartyData {
    u16 state;
    u16 episodeID;
    u8 episodeUnlockFlags[8];
    u8 unlockedEpisodes[13];
} PokemonSearchPartyData;

static const u8 sEpisodeUnlockFlags[] = {
    PSP_EPISODE_UNLOCK_ALWAYS,
    PSP_EPISODE_UNLOCK_ALWAYS,
    PSP_EPISODE_UNLOCK_AZALEA_ROCKETS,
    PSP_EPISODE_UNLOCK_PLAINBADGE,
    PSP_EPISODE_UNLOCK_TOWER_ROCKETS,
    PSP_EPISODE_UNLOCK_8BADGES,
    PSP_EPISODE_UNLOCK_9BADGES,
    PSP_EPISODE_UNLOCK_VERMILION,
    PSP_EPISODE_UNLOCK_VERMILION,
    PSP_EPISODE_UNLOCK_VERMILION,
    PSP_EPISODE_UNLOCK_16BADGES,
    PSP_EPISODE_UNLOCK_16BADGES,
    PSP_EPISODE_UNLOCK_16BADGES,
};

static void Init(RadioShow *radioShow)
{
    PokemonSearchPartyData *data = radioShow->showData;
    VarsFlags *varsFlags = SaveData_GetVarsFlags(radioShow->saveData);
    TrainerInfo *info = SaveData_GetTrainerInfo(radioShow->saveData);
    u8 num = 0;

    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0419, TRUE);

    int badgeCount = CompleteBadges_Count(info);

    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_ALWAYS] = 1;
    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_AZALEA_ROCKETS] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_BEAT_AZALEA_ROCKETS);
    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_PLAINBADGE] = CompleteBadges_Has(info, BADGE_ID_HGSS_PLAIN);
    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_TOWER_ROCKETS] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS);
    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_8BADGES] = badgeCount >= 8;
    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_9BADGES] = badgeCount >= 9;
    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_16BADGES] = badgeCount >= 16;
    data->episodeUnlockFlags[PSP_EPISODE_UNLOCK_VERMILION] = VarsFlags_CheckFlag(varsFlags, FLAG_HGSS_SYS_FLYPOINT_VERMILION);

    for (u8 i = 0; i < NELEMS(sEpisodeUnlockFlags); ++i) {
        if (data->episodeUnlockFlags[sEpisodeUnlockFlags[i]]) {
            data->unlockedEpisodes[num++] = i;
        }
    }

    data->episodeID = LCRNG_Next() % num;

    if (data->episodeID == radioShow->lastEpisodeID) {
        data->episodeID = (data->episodeID + 1) % num;
    }

    radioShow->lastEpisodeID = data->episodeID;
}

BOOL RadioShow_PokemonSearchParty_Setup(RadioShow *radioShow)
{
    RadioShow_AllocShowData(radioShow, sizeof(PokemonSearchPartyData));
    Init(radioShow);
    CompleteRadio_StopSeq(0);
    CompleteRadio_PlaySeq(SEQ_GS_RADIO_VARIETY_sseq);
    return FALSE;
}

BOOL RadioShow_PokemonSearchParty_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_PokemonSearchParty_Print(RadioShow *radioShow)
{
    PokemonSearchPartyData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInitEz(radioShow, msg_0419_00002);
        ++data->state;
        break;
    case 1:
        if (Radio_RunTextPrinter(radioShow)) {
            RadioPrintInitEz(radioShow, msg_0419_00004 + data->unlockedEpisodes[data->episodeID]);
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
            RadioPrintAndPlayJingle(radioShow, msg_0419_00003);
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
