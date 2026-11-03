#include "complete_radio.h"

#include <nitro.h>

#include "field/field_system.h"

#include "field_bgm.h"
#include "field_script_context.h"
#include "inlines.h"
#include "location.h"
#include "sound.h"
#include "sound_playback.h"
#include "vars_flags.h"

#include "generated/vars_flags.h"

#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: the Pokégear radio's music (include/complete_radio.h). The main module keeps it, as the radio's
// overlay comes and goes with the bottom screen.

#define RADIO_CURSOR_NONE 0x7FFF

#ifdef SOVEREIGN_TEST
// include/applications/complete_pokegear/radio.h: here, as the overlay's memory goes to the next overlay
u16 gCompleteTestRadio[5];
#endif

static u16 sRadioSeq;
static s16 sCursorX = RADIO_CURSOR_NONE;
static s16 sCursorY;

static BOOL RadioPlaying(void)
{
    return sRadioSeq != 0 && Sound_GetCurrentBGM() == sRadioSeq;
}

void CompleteRadio_PlaySeq(u16 seqID)
{
    if (seqID == sRadioSeq && RadioPlaying() && Sound_IsSequencePlaying(seqID)) {
        return; // still on (the bottom screen came back after a menu)
    }

    sRadioSeq = seqID;
    Sound_PlayBGM(seqID);
}

void CompleteRadio_StopSeq(int fadeFrames)
{
    if (RadioPlaying()) {
        Sound_StopBGM(sRadioSeq, fadeFrames);
    }
}

BOOL CompleteRadio_IsSeqPlaying(void)
{
    return RadioPlaying() && Sound_IsSequencePlaying(sRadioSeq);
}

void CompleteRadio_TurnOff(FieldSystem *fieldSystem)
{
    if (sRadioSeq == 0) {
        return;
    }

    if (RadioPlaying()) {
        Sound_PlayBGM(FieldBGM_GetForMapHeader(fieldSystem, fieldSystem->location->mapHeaderID));
    }

    sRadioSeq = 0;
}

enum CompleteRadioMusic CompleteRadio_Music(void)
{
    if (!RadioPlaying()) {
        return RADIO_MUSIC_NONE;
    }

    switch (sRadioSeq) {
    case SEQ_GS_RADIO_MARCH_sseq:
    case SEQ_GS_P_RADIO_MARCH_sseq:
        return RADIO_MUSIC_MARCH;
    case SEQ_GS_RADIO_KOMORIUTA_sseq:
    case SEQ_GS_P_RADIO_KOMORIUTA_sseq:
        return RADIO_MUSIC_LULLABY;
    case SEQ_GS_RADIO_R_101_sseq:
        return RADIO_MUSIC_HOENN_SOUNDS;
    case SEQ_GS_RADIO_R_201_sseq:
        return RADIO_MUSIC_SINNOH_SOUNDS;
    case SEQ_GS_HUE_sseq:
    case SEQ_GS_P_HUE_sseq:
        return RADIO_MUSIC_POKE_FLUTE;
    case SEQ_GS_RADIO_UNKNOWN_sseq:
        return RADIO_MUSIC_UNOWN;
    default:
        return RADIO_MUSIC_NONE;
    }
}

void CompleteRadio_GetCursor(s16 *x, s16 *y)
{
    *x = sCursorX;
    *y = sCursorY;
}

void CompleteRadio_SetCursor(s16 x, s16 y)
{
    sCursorX = x;
    sCursorY = y;
}

// HeartGold's RadioMusicIsPlaying music, destVar (Snorlax on Routes 11 and 12 asks for the Poké Flute, 5)
BOOL CompleteScrCmd_RadioMusicIsPlaying(ScriptContext *ctx)
{
    u16 music = ScriptContext_GetVar(ctx);
    u16 *destVar = ScriptContext_GetVarPointer(ctx);

    *destVar = CompleteRadio_Music() == music;
    return FALSE;
}

#define BUENAS_PASSWORDS 30

static u16 *BuenasPasswordVar(SaveData *saveData)
{
    return VarsFlags_GetVarAddress(SaveData_GetVarsFlags(saveData), VAR_HGSS_BUENAS_PASSWORD_SET);
}

// HeartGold's Save_VarsFlags_UpdateBuenasPasswordSet: a new one each day, never the day before's
void CompleteRadio_NewBuenasPassword(SaveData *saveData)
{
    u16 *set = BuenasPasswordVar(saveData);
    u16 password = LCRNG_RandMod(BUENAS_PASSWORDS);

    if (password == *set) {
        password = (password + 1) % BUENAS_PASSWORDS;
    }

    *set = password;
}

u16 CompleteRadio_BuenasPassword(SaveData *saveData)
{
    return *BuenasPasswordVar(saveData) % BUENAS_PASSWORDS;
}

// HeartGold's GetBuenasPassword msgVar, answerVar: her bank's passwords are messages 40 to 69, three to a day's quiz
BOOL CompleteScrCmd_GetBuenasPassword(ScriptContext *ctx)
{
    u16 *msgVar = ScriptContext_GetVarPointer(ctx);
    u16 *answerVar = ScriptContext_GetVarPointer(ctx);
    u16 password = CompleteRadio_BuenasPassword(ctx->fieldSystem->saveData);

    *msgVar = 40 + password / 3 * 3;
    *answerVar = password % 3;
    return FALSE;
}
