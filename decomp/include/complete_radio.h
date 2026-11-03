#ifndef POKEPLATINUM_COMPLETE_RADIO_H
#define POKEPLATINUM_COMPLETE_RADIO_H

#include <nitro.h>

#include "field/field_system_decl.h"
#include "field_script_context.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Pokégear radio (the Pokégear's Radio page, src/applications/complete_pokegear/radio/).
// What it plays is the field's music while the page shows a station; HeartGold's checks of the radio's music (the
// March and the Lullaby's encounter rates, the Hoenn and Sinnoh Sounds' Pokémon, the Unown broadcast, the Poké Flute
// that wakes Snorlax) ask here, and find nothing once the field's music is something else (a new map, a battle).

// HeartGold's RadioMusicPlayingSeq
enum CompleteRadioMusic {
    RADIO_MUSIC_NONE = 0,
    RADIO_MUSIC_MARCH,
    RADIO_MUSIC_LULLABY,
    RADIO_MUSIC_HOENN_SOUNDS,
    RADIO_MUSIC_SINNOH_SOUNDS,
    RADIO_MUSIC_POKE_FLUTE,
    RADIO_MUSIC_UNOWN,
};

void CompleteRadio_PlaySeq(u16 seqID); // a show's song (HeartGold's SndRadio_StartSeq), as the field's music
void CompleteRadio_StopSeq(int fadeFrames); // HeartGold's SndRadio_StopSeq and StopBGM of its music
BOOL CompleteRadio_IsSeqPlaying(void); // HeartGold's SndRadio_CountPlayingSeq (a jingle that ends)
void CompleteRadio_TurnOff(FieldSystem *fieldSystem); // the map's own music again
enum CompleteRadioMusic CompleteRadio_Music(void); // HeartGold's GetRadioMusicPlayingSeq

// Where the radio's cursor was last tuned, kept while the bottom screen restarts (a battle, a menu, a map)
void CompleteRadio_GetCursor(s16 *x, s16 *y);
void CompleteRadio_SetCursor(s16 x, s16 y);

// Buena's password (HeartGold's VAR_BUENAS_PASSWORD_SET, VAR_HGSS_BUENAS_PASSWORD_SET here): one of 30 each day, which
// the radio's Buena's Password gives and her quiz asks for (as one of three)
void CompleteRadio_NewBuenasPassword(SaveData *saveData); // each day
u16 CompleteRadio_BuenasPassword(SaveData *saveData);

BOOL CompleteScrCmd_RadioMusicIsPlaying(ScriptContext *ctx);
BOOL CompleteScrCmd_GetBuenasPassword(ScriptContext *ctx);

#endif // POKEPLATINUM_COMPLETE_RADIO_H
