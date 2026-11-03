#include <nitro.h>

#include "generated/items.h"

#include "applications/complete_pokegear/radio.h"

#include "bag.h"
#include "complete_radio.h"
#include "heap.h"
#include "math_util.h"
#include "pokedex.h"
#include "rtc.h"

#include "generated/text_banks.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0416.h"

// Sovereign Complete: DJ Ben's Pokémon Music (HeartGold's shows/pokemon_music.c): the day's music, which plays until
// the day ends. Mondays and Fridays the March (more wild Pokémon), Tuesdays and Saturdays the Lullaby (fewer); with the
// National Pokédex, Wednesdays Hoenn's and Thursdays Sinnoh's sounds (their Pokémon in the grass); Sundays, with the GB
// Sounds, an old song of the Game Boy's.

enum PokemonMusicTrack {
    PKMUSTRACK_MARCH,
    PKMUSTRACK_LULLABY,
    PKMUSTRACK_HOENN,
    PKMUSTRACK_SINNOH,
    PKMUSTRACK_GBSOUNDS,
};

enum PokemonMusicState {
    PKMUSSTATE_PRINT_INTRO,
    PKMUSSTATE_WAIT_INTRO,
    PKMUSSTATE_PRINT_DAY,
    PKMUSSTATE_LOOP_DAY,
    PKMUSSTATE_WAIT_OUT,
};

typedef struct PokemonMusicData {
    u8 hasNationalDex;
    u8 queuedMsg;
    u8 weekday;
    u8 queuedTrack;
    u8 state;
    RTCDate tuneInDate;
    RTCDate afterIntroDate;
} PokemonMusicData;

static const u16 sMusicIDs_Default[] = {
    SEQ_GS_RADIO_MARCH_sseq,
    SEQ_GS_RADIO_KOMORIUTA_sseq,
    SEQ_GS_RADIO_R_101_sseq,
    SEQ_GS_RADIO_R_201_sseq,
};

static const u16 sMusicIDs_GBSounds[] = {
    SEQ_GS_P_TITLE_sseq,
    SEQ_GS_P_OPENING_TITLE_G_sseq,
    SEQ_GS_P_ENDING_sseq,
    SEQ_GS_P_ENDING2_sseq,
    SEQ_GS_P_SENKYO_sseq,
    SEQ_GS_P_E_MINAKI_sseq,
    SEQ_GS_P_IBUKI_sseq,
    SEQ_GS_P_EYE_J_SHOUJO_sseq,
    SEQ_GS_P_EYE_J_SHOUNEN_sseq,
    SEQ_GS_P_EYE_J_AYASHII_sseq,
    SEQ_GS_P_EYE_BOUZU_sseq,
    SEQ_GS_P_EYE_MAIKO_sseq,
    SEQ_GS_P_EYE_ROCKET_sseq,
    SEQ_GS_P_EYE_K_SHOUJO_sseq,
    SEQ_GS_P_EYE_K_SHOUNEN_sseq,
    SEQ_GS_P_EYE_K_AYASHII_sseq,
    SEQ_GS_P_VS_ROCKET_sseq,
    SEQ_GS_P_AIKOTOBA_sseq,
    SEQ_GS_P_RADIO_JINGLE_sseq,
    SEQ_GS_P_OHKIDO_RABO_sseq,
    SEQ_GS_P_RADIO_MARCH_sseq,
    SEQ_GS_P_RADIO_KOMORIUTA_sseq,
    SEQ_GS_P_HUE_sseq,
    SEQ_GS_P_POKEMON_THEME_sseq,
    SEQ_GS_P_OHKIDO_sseq,
};

static void StartPlaying(u8 track)
{
    u16 seqNo;

    if (track == PKMUSTRACK_GBSOUNDS) {
        seqNo = sMusicIDs_GBSounds[(LCRNG_Next() % 25000) / 1000];
    } else {
        seqNo = sMusicIDs_Default[track];
    }

    CompleteRadio_PlaySeq(seqNo);
}

BOOL RadioShow_PokemonMusic_Setup(RadioShow *radioShow)
{
    PokemonMusicData *data = RadioShow_AllocShowData(radioShow, sizeof(PokemonMusicData));

    data->hasNationalDex = Pokedex_IsNationalDexObtained(SaveData_GetPokedex(radioShow->saveData));
    GetCurrentDate(&data->tuneInDate);
    data->weekday = data->tuneInDate.week;
    data->queuedMsg = msg_0416_00003 + data->weekday;

    switch (data->weekday) {
    case RTC_WEEK_SUNDAY:
        if (Bag_CanRemoveItem(SaveData_GetBag(radioShow->saveData), ITEM_GB_SOUNDS, 1, radioShow->heapID)) {
            data->queuedTrack = PKMUSTRACK_GBSOUNDS;
        } else {
            data->queuedTrack = PKMUSTRACK_MARCH;
            data->queuedMsg = msg_0416_00012;
        }
        break;
    case RTC_WEEK_MONDAY:
    case RTC_WEEK_FRIDAY:
        data->queuedTrack = PKMUSTRACK_MARCH;
        break;
    case RTC_WEEK_WEDNESDAY:
        if (data->hasNationalDex) {
            data->queuedTrack = PKMUSTRACK_HOENN;
            data->queuedMsg = msg_0416_00010;
        } else {
            data->queuedTrack = PKMUSTRACK_MARCH;
        }
        break;
    case RTC_WEEK_TUESDAY:
    case RTC_WEEK_SATURDAY:
        data->queuedTrack = PKMUSTRACK_LULLABY;
        break;
    case RTC_WEEK_THURSDAY:
        if (data->hasNationalDex) {
            data->queuedTrack = PKMUSTRACK_SINNOH;
            data->queuedMsg = msg_0416_00011;
        } else {
            data->queuedTrack = PKMUSTRACK_LULLABY;
        }
        break;
    }

    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0416, TRUE);
    CompleteRadio_StopSeq(0);
    StartPlaying(data->queuedTrack);
    radioShow->isSecondLine = FALSE;
    return FALSE;
}

BOOL RadioShow_PokemonMusic_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_PokemonMusic_Print(RadioShow *radioShow)
{
    PokemonMusicData *data = radioShow->showData;

    switch (data->state) {
    case PKMUSSTATE_PRINT_INTRO:
        RadioPrintInitEz(radioShow, msg_0416_00002);
        ++data->state;
        break;
    case PKMUSSTATE_WAIT_INTRO:
        if (Radio_RunTextPrinter(radioShow)) {
            ++data->state;
        }
        break;
    case PKMUSSTATE_PRINT_DAY:
        GetCurrentDate(&data->afterIntroDate);
        RadioPrintInitEz(radioShow, data->queuedMsg);
        ++data->state;
        break;
    case PKMUSSTATE_LOOP_DAY:
        if (Radio_RunTextPrinter(radioShow)) {
            RTCDate date;

            GetCurrentDate(&date);

            if (date.day == data->afterIntroDate.day && date.day == data->tuneInDate.day) {
                data->state = PKMUSSTATE_PRINT_DAY;
                return FALSE;
            }

            radioShow->isPlayingJingle = TRUE;
            CompleteRadio_StopSeq(30);
            ++data->state;
        }
        break;
    case PKMUSSTATE_WAIT_OUT:
        if (RadioShow_DelayAndScrollLine(radioShow)) {
            return TRUE;
        }
        break;
    }

    return FALSE;
}
