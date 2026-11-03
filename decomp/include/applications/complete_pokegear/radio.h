#ifndef POKEPLATINUM_COMPLETE_POKEGEAR_RADIO_H
#define POKEPLATINUM_COMPLETE_POKEGEAR_RADIO_H

#include <nitro.h>

#include "constants/heap.h"

#include "bg_window.h"
#include "field/field_system_decl.h"
#include "message.h"
#include "savedata.h"
#include "string_gf.h"
#include "string_template.h"

// Sovereign Complete: HeartGold's Pokégear radio (pokeheartgold's src/application/pokegear/radio), on the Pokégear's
// Radio page (src/applications/complete_pokegear/). radio_show.c runs a station's shows, as HeartGold's
// overlay_101_021F57B8.c does, and shows/ has HeartGold's twelve, each in its file; radio_page.c is the page: the
// globe the cursor tunes in and the four preset buttons (HeartGold's overlay_101_021F4F34.c and pokegear_radio.c).
//
// The show's lines print one at a time in a strip under the globe, as the bottom screen has no room for HeartGold's
// two lines on the top screen; its title and host share the band at the top.

// HeartGold's RadioStationSelection: the stations the globe has where the player is
enum RadioStationSelection {
    RADIO_STATION_SELECTION_JOHTO,
    RADIO_STATION_SELECTION_KANTO,
    RADIO_STATION_SELECTION_KANTO_EXPN,
    RADIO_STATION_SELECTION_NO_SIGNAL,
    RADIO_STATION_SELECTION_ALPH,
    RADIO_STATION_SELECTION_ROCKET,
    RADIO_STATION_SELECTION_MAHOGANY,
};

// HeartGold's constants/radio_station.h: the shows, by which the stations play them
enum RadioShowID {
    RADIO_STATION_POKEMON_MUSIC,
    RADIO_STATION_POKEMON_TALK,
    RADIO_STATION_POKEMON_SEARCH_PARTY,
    RADIO_STATION_SERIAL_RADIO_DRAMA,
    RADIO_STATION_BUENAS_PASSWORD,
    RADIO_STATION_TRAINER_PROFILES,
    RADIO_STATION_THAT_TOWN_THESE_PEOPLE,
    RADIO_STATION_POKE_FLUTE,
    RADIO_STATION_UNOWN,
    RADIO_STATION_TEAM_ROCKET,
    RADIO_STATION_MAHOGANY_SIGNAL,
    RADIO_STATION_COMMERCIALS,
};

#define RADIO_HEAP_ID HEAP_ID_POKETCH_APP

typedef struct RadioShow {
    enum HeapID heapID;
    SaveData *saveData;
    u16 mapHeaderID;
    Window *scriptWindow;
    Window *titleWindow; // the title, and the host on its right
    u32 textColor;
    void *showData;
    MessageLoader *showMessages;
    RTCDate date;
    RTCTime time;
    StringTemplate *template;
    String *line;
    String *title;
    String *host;
    u32 lastEpisodeID;
    u8 nextStation;
    u8 curStation;
    u8 lastStation;
    u8 bgColor;
    u8 runState;
    u8 printWithJingleState;
    u8 curLineIdx;
    u8 numLines;
    u8 printState;
    u8 textNoScroll;
    u8 isSecondLine : 1;
    u8 statik : 1; // HeartGold's spelling: a weak signal, the lines have static
    u8 regionNo : 1; // 0 Johto, 1 Kanto
    u8 isPlayingJingle : 1;
    u8 triggerCommercials : 1;
    u8 delayCounter;
    u8 delayFrames;
    u8 scrollCounter;
    u8 scrollFrames;
    String *formatted;
    String *raw;
} RadioShow;

// radio_show.c
RadioShow *RadioShow_Create(SaveData *saveData, u16 mapHeaderID, int regionNo, Window *scriptWindow, Window *titleWindow, u32 textColor, enum HeapID heapID);
void RadioShow_Delete(RadioShow *radioShow);
void RadioShow_BeginSegment(RadioShow *radioShow, int station, int statik);
void RadioShow_EndSegment(RadioShow *radioShow);
void RadioShow_SetStaticLevel(RadioShow *radioShow, BOOL statik);
BOOL RadioShow_DelayAndScrollLine(RadioShow *radioShow);
BOOL RadioShow_Delay(RadioShow *radioShow);
void RadioShow_Main(RadioShow *radioShow);
void RadioShow_LoadMessages(RadioShow *radioShow, u32 bank, BOOL hasHost); // the show's bank, title (0) and host (1)
void RadioShow_FreeMessages(RadioShow *radioShow);
void RadioPrintInit(RadioShow *radioShow, int msgId, int textNoScroll);
void RadioPrintInitEz(RadioShow *radioShow, int msgId);
void RadioPrintAndPlayJingle(RadioShow *radioShow, int msgId);
BOOL Radio_RunTextPrinter(RadioShow *radioShow);
BOOL Radio_RunTextPrinter_WaitJingle(RadioShow *radioShow);
void RadioShow_SetSpeciesName(RadioShow *radioShow, u32 idx, u16 species);
void *RadioShow_AllocShowData(RadioShow *radioShow, u32 size); // a show's data, cleared
BOOL RadioShow_FreeShowData(RadioShow *radioShow); // a show's teardown: its data and bank, if still held

// shows/
BOOL RadioShow_PokemonMusic_Setup(RadioShow *radioShow);
BOOL RadioShow_PokemonMusic_Print(RadioShow *radioShow);
BOOL RadioShow_PokemonMusic_Teardown(RadioShow *radioShow);
BOOL RadioShow_PokemonTalk_Setup(RadioShow *radioShow);
BOOL RadioShow_PokemonTalk_Print(RadioShow *radioShow);
BOOL RadioShow_PokemonTalk_Teardown(RadioShow *radioShow);
BOOL RadioShow_PokemonSearchParty_Setup(RadioShow *radioShow);
BOOL RadioShow_PokemonSearchParty_Print(RadioShow *radioShow);
BOOL RadioShow_PokemonSearchParty_Teardown(RadioShow *radioShow);
BOOL RadioShow_SerialRadioDrama_Setup(RadioShow *radioShow);
BOOL RadioShow_SerialRadioDrama_Print(RadioShow *radioShow);
BOOL RadioShow_SerialRadioDrama_Teardown(RadioShow *radioShow);
BOOL RadioShow_BuenasPassword_Setup(RadioShow *radioShow);
BOOL RadioShow_BuenasPassword_Print(RadioShow *radioShow);
BOOL RadioShow_BuenasPassword_Teardown(RadioShow *radioShow);
BOOL RadioShow_TrainerProfiles_Setup(RadioShow *radioShow);
BOOL RadioShow_TrainerProfiles_Print(RadioShow *radioShow);
BOOL RadioShow_TrainerProfiles_Teardown(RadioShow *radioShow);
BOOL RadioShow_ThatTownThesePeople_Setup(RadioShow *radioShow);
BOOL RadioShow_ThatTownThesePeople_Print(RadioShow *radioShow);
BOOL RadioShow_ThatTownThesePeople_Teardown(RadioShow *radioShow);
BOOL RadioShow_PokeFlute_Setup(RadioShow *radioShow);
BOOL RadioShow_PokeFlute_Print(RadioShow *radioShow);
BOOL RadioShow_PokeFlute_Teardown(RadioShow *radioShow);
BOOL RadioShow_Unown_Setup(RadioShow *radioShow);
BOOL RadioShow_Unown_Print(RadioShow *radioShow);
BOOL RadioShow_Unown_Teardown(RadioShow *radioShow);
BOOL RadioShow_TeamRocket_Setup(RadioShow *radioShow);
BOOL RadioShow_TeamRocket_Print(RadioShow *radioShow);
BOOL RadioShow_TeamRocket_Teardown(RadioShow *radioShow);
BOOL RadioShow_MahoganySignal_Setup(RadioShow *radioShow);
BOOL RadioShow_MahoganySignal_Print(RadioShow *radioShow);
BOOL RadioShow_MahoganySignal_Teardown(RadioShow *radioShow);
BOOL RadioShow_Commercials_Setup(RadioShow *radioShow);
BOOL RadioShow_Commercials_Print(RadioShow *radioShow);
BOOL RadioShow_Commercials_Teardown(RadioShow *radioShow);

// radio_page.c: the Pokégear's Radio page, on its layers (pokegear.c's): the globe on layer 0 (tiles 0-127), the
// windows on layer 1 and the cursor a sprite
typedef struct RadioPage RadioPage;

RadioPage *RadioPage_New(FieldSystem *fieldSystem, BgConfig *bgConfig, enum HeapID heapID);
void RadioPage_Free(RadioPage *page, BOOL turnOff); // turnOff: the map's music again (the player left the page)
void RadioPage_Run(RadioPage *page); // each frame: touches, the show, the cursor

#ifdef SOVEREIGN_TEST
// The test's view of the radio: the station selection, the show playing (RADIO_STATION_*, 0xFF for none), the
// station tuned and its signal (station << 8 | signal), the cursor (x | y << 8) and the music (enum
// CompleteRadioMusic)
extern u16 gCompleteTestRadio[5];
#endif

#endif // POKEPLATINUM_COMPLETE_POKEGEAR_RADIO_H
