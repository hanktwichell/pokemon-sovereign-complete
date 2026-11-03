#include <nitro.h>

#include "constants/charcode.h"
#include "constants/narc.h"

#include "applications/complete_pokegear/radio.h"

#include "complete_radio.h"
#include "font.h"
#include "heap.h"
#include "message.h"
#include "math_util.h"
#include "message_util.h"
#include "rtc.h"
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "text.h"

#include "res/sound/pl_sound_data.naix"

// Sovereign Complete: HeartGold's radio shows' runner (pokeheartgold's overlay_101_021F57B8.c). A show prints its
// messages a line at a time; here the strip under the globe holds one line, so each line scrolls up and out before
// the next (HeartGold shows two, the old above the new), and stays a little longer for it.

#define LINE_FRAMES     75 // HeartGold's: 45, with two lines in view
#define SCROLL_STEP     2 // pixels a frame, a line's height over SCROLL_FRAMES
#define SCROLL_FRAMES   8
#define TEXT_LINE_CHARS 51 // HeartGold's buffers
#define TEXT_SHOW_CHARS 1351
#define STATIC_PERCENT  70 // a weak signal's static: the share of letters lost

enum RadioPrintState {
    RADIO_PRINT_STATE_NULL,
    RADIO_PRINT_STATE_WAIT_FIRST_LINE,
    RADIO_PRINT_STATE_PRINT_NEXT_LINE,
    RADIO_PRINT_STATE_WAIT_SCROLL,
    RADIO_PRINT_STATE_WAIT_SCROLL_EXIT,
    RADIO_PRINT_STATE_WAIT_EXIT,
    RADIO_PRINT_STATE_EXIT,
};

typedef struct RadioFuncs {
    BOOL (*setup)(RadioShow *);
    BOOL (*print)(RadioShow *);
    BOOL (*teardown)(RadioShow *);
} RadioFuncs;

static const RadioFuncs sRadioShowFuncs[] = {
    [RADIO_STATION_POKEMON_MUSIC] = { RadioShow_PokemonMusic_Setup, RadioShow_PokemonMusic_Print, RadioShow_PokemonMusic_Teardown },
    [RADIO_STATION_POKEMON_TALK] = { RadioShow_PokemonTalk_Setup, RadioShow_PokemonTalk_Print, RadioShow_PokemonTalk_Teardown },
    [RADIO_STATION_POKEMON_SEARCH_PARTY] = { RadioShow_PokemonSearchParty_Setup, RadioShow_PokemonSearchParty_Print, RadioShow_PokemonSearchParty_Teardown },
    [RADIO_STATION_SERIAL_RADIO_DRAMA] = { RadioShow_SerialRadioDrama_Setup, RadioShow_SerialRadioDrama_Print, RadioShow_SerialRadioDrama_Teardown },
    [RADIO_STATION_BUENAS_PASSWORD] = { RadioShow_BuenasPassword_Setup, RadioShow_BuenasPassword_Print, RadioShow_BuenasPassword_Teardown },
    [RADIO_STATION_TRAINER_PROFILES] = { RadioShow_TrainerProfiles_Setup, RadioShow_TrainerProfiles_Print, RadioShow_TrainerProfiles_Teardown },
    [RADIO_STATION_THAT_TOWN_THESE_PEOPLE] = { RadioShow_ThatTownThesePeople_Setup, RadioShow_ThatTownThesePeople_Print, RadioShow_ThatTownThesePeople_Teardown },
    [RADIO_STATION_POKE_FLUTE] = { RadioShow_PokeFlute_Setup, RadioShow_PokeFlute_Print, RadioShow_PokeFlute_Teardown },
    [RADIO_STATION_UNOWN] = { RadioShow_Unown_Setup, RadioShow_Unown_Print, RadioShow_Unown_Teardown },
    [RADIO_STATION_TEAM_ROCKET] = { RadioShow_TeamRocket_Setup, RadioShow_TeamRocket_Print, RadioShow_TeamRocket_Teardown },
    [RADIO_STATION_MAHOGANY_SIGNAL] = { RadioShow_MahoganySignal_Setup, RadioShow_MahoganySignal_Print, RadioShow_MahoganySignal_Teardown },
    [RADIO_STATION_COMMERCIALS] = { RadioShow_Commercials_Setup, RadioShow_Commercials_Print, RadioShow_Commercials_Teardown },
};

static void PrintTitleAndHost(RadioShow *radioShow);

RadioShow *RadioShow_Create(SaveData *saveData, u16 mapHeaderID, int regionNo, Window *scriptWindow, Window *titleWindow, u32 textColor, enum HeapID heapID)
{
    RadioShow *ret = Heap_Alloc(heapID, sizeof(RadioShow));

    MI_CpuClear8(ret, sizeof(RadioShow));
    ret->saveData = saveData;
    ret->mapHeaderID = mapHeaderID;
    ret->regionNo = regionNo;
    ret->scriptWindow = scriptWindow;
    ret->titleWindow = titleWindow;
    ret->textColor = textColor;
    ret->bgColor = textColor & 0xFF;
    ret->heapID = heapID;
    ret->template = StringTemplate_New(8, TEXT_LINE_CHARS, heapID);
    ret->line = String_Init(TEXT_LINE_CHARS, heapID);
    ret->title = String_Init(TEXT_LINE_CHARS, heapID);
    ret->host = String_Init(TEXT_LINE_CHARS, heapID);
    ret->formatted = String_Init(TEXT_SHOW_CHARS, heapID);
    ret->raw = String_Init(TEXT_SHOW_CHARS, heapID);
    ret->curStation = 0xFF;
    return ret;
}

void RadioShow_Delete(RadioShow *radioShow)
{
    String_Free(radioShow->raw);
    String_Free(radioShow->formatted);
    String_Free(radioShow->host);
    String_Free(radioShow->title);
    String_Free(radioShow->line);
    StringTemplate_Free(radioShow->template);
    Heap_Free(radioShow);
}

void RadioShow_LoadMessages(RadioShow *radioShow, u32 bank, BOOL hasHost)
{
    radioShow->showMessages = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, bank, radioShow->heapID);
    MessageLoader_GetString(radioShow->showMessages, 0, radioShow->title);

    if (hasHost) {
        MessageLoader_GetString(radioShow->showMessages, 1, radioShow->host);
    } else {
        String_Clear(radioShow->host);
    }
}

void RadioShow_FreeMessages(RadioShow *radioShow)
{
    MessageLoader_Free(radioShow->showMessages);
    radioShow->showMessages = NULL;
}

// A show's teardown: its data and its bank, those it still holds
BOOL RadioShow_FreeShowData(RadioShow *radioShow)
{
    if (radioShow->showData != NULL) {
        Heap_Free(radioShow->showData);
        radioShow->showData = NULL;
    }

    if (radioShow->showMessages != NULL) {
        RadioShow_FreeMessages(radioShow);
    }

    return FALSE;
}

void *RadioShow_AllocShowData(RadioShow *radioShow, u32 size)
{
    radioShow->showData = Heap_Alloc(radioShow->heapID, size);
    MI_CpuClear8(radioShow->showData, size);
    return radioShow->showData;
}

void RadioShow_SetSpeciesName(RadioShow *radioShow, u32 idx, u16 species)
{
    String *name = MessageUtil_SpeciesName(species, radioShow->heapID);

    StringTemplate_SetString(radioShow->template, idx, name, 0, TRUE, GAME_LANGUAGE);
    String_Free(name);
}

// HeartGold's RadioShow_TranslateStationID: what a station plays now, its talk shows by the hour, and the commercials
// after one
static u8 TranslateStationID(RadioShow *radioShow, int station)
{
    if (station >= 8) {
        station = 0;
    }

    if (radioShow->triggerCommercials) {
        radioShow->triggerCommercials = FALSE;
        return RADIO_STATION_COMMERCIALS;
    }

    GetCurrentDateTime(&radioShow->date, &radioShow->time);

    switch (station) {
    case 0:
        return RADIO_STATION_POKEMON_MUSIC;
    case 1:
        return RADIO_STATION_POKEMON_TALK;
    case 2:
        return RADIO_STATION_TRAINER_PROFILES + (radioShow->time.hour % 2);
    case 3:
        return RADIO_STATION_POKEMON_SEARCH_PARTY + (radioShow->time.hour % 3);
    case 4:
        return RADIO_STATION_POKE_FLUTE;
    case 5:
        return RADIO_STATION_UNOWN;
    case 6:
        return RADIO_STATION_TEAM_ROCKET;
    case 7:
        return RADIO_STATION_MAHOGANY_SIGNAL;
    }

    return RADIO_STATION_POKEMON_MUSIC;
}

static void ClearScript(RadioShow *radioShow)
{
    Window_FillTilemap(radioShow->scriptWindow, radioShow->bgColor);
    Window_CopyToVRAM(radioShow->scriptWindow);
}

void RadioShow_BeginSegment(RadioShow *radioShow, int station, int statik)
{
    radioShow->isSecondLine = FALSE;

    if (station >= 8) {
        station = 0;
    }

    radioShow->nextStation = station;

    if (radioShow->curStation != RADIO_STATION_COMMERCIALS) {
        radioShow->lastStation = radioShow->curStation;
    }

    radioShow->curStation = TranslateStationID(radioShow, station);
    radioShow->runState = 0;
    radioShow->delayFrames = LINE_FRAMES;
    radioShow->delayCounter = 0;
    radioShow->scrollFrames = SCROLL_FRAMES;
    radioShow->scrollCounter = 0;
    radioShow->statik = statik;
    radioShow->isPlayingJingle = FALSE;
    radioShow->printWithJingleState = 0;

    if (radioShow->curStation != RADIO_STATION_COMMERCIALS && radioShow->lastStation != radioShow->curStation) {
        radioShow->lastEpisodeID = 0;
    }

    ClearScript(radioShow);
    sRadioShowFuncs[radioShow->curStation].setup(radioShow);
    PrintTitleAndHost(radioShow);
}

void RadioShow_EndSegment(RadioShow *radioShow)
{
    if (radioShow->curStation != 0xFF) {
        sRadioShowFuncs[radioShow->curStation].teardown(radioShow); // each show's frees only what's still held
    }

    ClearScript(radioShow);
    Window_FillTilemap(radioShow->titleWindow, 0);
    Window_CopyToVRAM(radioShow->titleWindow);
    radioShow->triggerCommercials = FALSE;
    radioShow->curStation = 0xFF;
}

void RadioShow_SetStaticLevel(RadioShow *radioShow, BOOL statik)
{
    radioShow->statik = statik;
}

static void ScrollLine(RadioShow *radioShow)
{
    Window_Scroll(radioShow->scriptWindow, 0, SCROLL_STEP, radioShow->bgColor | (radioShow->bgColor << 4));
    Window_CopyToVRAM(radioShow->scriptWindow);
}

BOOL RadioShow_DelayAndScrollLine(RadioShow *radioShow)
{
    if (radioShow->delayCounter < radioShow->delayFrames) {
        ++radioShow->delayCounter;
        return FALSE;
    }

    if (radioShow->scrollCounter) {
        ScrollLine(radioShow);
    }

    if (radioShow->scrollCounter++ < SCROLL_FRAMES) {
        return FALSE;
    }

    radioShow->scrollCounter = 0;
    radioShow->delayCounter = 0;
    return TRUE;
}

static BOOL ScrollTextOffWindow(RadioShow *radioShow)
{
    if (radioShow->scrollCounter < SCROLL_FRAMES) {
        ScrollLine(radioShow);
    }

    if (radioShow->scrollCounter++ < radioShow->scrollFrames) {
        return FALSE;
    }

    radioShow->scrollCounter = 0;
    return TRUE;
}

BOOL RadioShow_Delay(RadioShow *radioShow)
{
    if (radioShow->delayCounter++ < radioShow->delayFrames) {
        return FALSE;
    }

    radioShow->delayCounter = 0;
    return TRUE;
}

void RadioShow_Main(RadioShow *radioShow)
{
    switch (radioShow->runState) {
    case 0:
        radioShow->runState = sRadioShowFuncs[radioShow->curStation].print(radioShow);
        break;
    case 1:
        sRadioShowFuncs[radioShow->curStation].teardown(radioShow);
        radioShow->scrollFrames = 16;
        radioShow->delayFrames = 15;
        ++radioShow->runState;
        break;
    case 2:
        if (ScrollTextOffWindow(radioShow)) {
            ++radioShow->runState;
        }
        break;
    case 3:
        if (RadioShow_Delay(radioShow)) {
            RadioShow_BeginSegment(radioShow, radioShow->nextStation, radioShow->statik);
            radioShow->runState = 0;
        }
        break;
    }
}

// The show's title on the band's left and its host on the right (HeartGold puts them in two places)
static void PrintTitleAndHost(RadioShow *radioShow)
{
    Window_FillTilemap(radioShow->titleWindow, 0);
    Text_AddPrinterWithParamsAndColor(radioShow->titleWindow, FONT_SYSTEM, radioShow->title, 0, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(1, 2, 0), NULL);

    if (String_Length(radioShow->host) != 0) {
        u32 width = Font_CalcStringWidth(FONT_SYSTEM, radioShow->host, 0);
        u32 right = radioShow->titleWindow->width * 8;

        Text_AddPrinterWithParamsAndColor(radioShow->titleWindow, FONT_SYSTEM, radioShow->host, width < right ? right - width : 0, 0, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR(1, 2, 0), NULL);
    }

    Window_CopyToVRAM(radioShow->titleWindow);
}

// HeartGold's String_RadioAddStatic: letters lost to a weak signal, each wide one an ellipsis and each narrow one a
// period (Platinum's font has no HeartGold's one- and two-dot letters)
static void AddStatic(String *string, u8 level)
{
    static const charcode_t sEllipsis[] = { CHAR_ELLIPSIS, CHAR_EOS };
    u32 ellipsisWidth = Font_CalcCharArrayWidth(FONT_SYSTEM, sEllipsis, 0);
    u32 length = String_Length(string);
    charcode_t *data = (charcode_t *)String_GetData(string);

    for (u32 i = 0; i + 1 < length; i++) {
        if (data[i] == CHAR_SPACE || data[i] >= CHAR_CR || (MTRNG_Next() / 256u) % 101 >= level) {
            continue;
        }

        charcode_t glyph[] = { data[i], CHAR_EOS };

        data[i] = Font_CalcCharArrayWidth(FONT_SYSTEM, glyph, 0) >= ellipsisWidth ? CHAR_ELLIPSIS : CHAR_PERIOD;
    }
}

// A line, alone in the strip
static void PrintLine(RadioShow *radioShow)
{
    if (radioShow->statik == TRUE) {
        AddStatic(radioShow->line, STATIC_PERCENT);
    }

    Window_FillTilemap(radioShow->scriptWindow, radioShow->bgColor);
    Text_AddPrinterWithParamsAndColor(radioShow->scriptWindow, FONT_SYSTEM, radioShow->line, 4, 0, TEXT_SPEED_NO_TRANSFER, radioShow->textColor, NULL);
    Window_CopyToVRAM(radioShow->scriptWindow);
}

static BOOL RadioPrintAdvance(RadioShow *radioShow)
{
    radioShow->isSecondLine = TRUE;
    String_CopyLineNum(radioShow->line, radioShow->formatted, radioShow->curLineIdx++);
    PrintLine(radioShow);
    return radioShow->curLineIdx >= radioShow->numLines;
}

void RadioPrintInit(RadioShow *radioShow, int msgId, int textNoScroll)
{
    radioShow->textNoScroll = textNoScroll;
    MessageLoader_GetString(radioShow->showMessages, msgId, radioShow->raw);
    StringTemplate_Format(radioShow->template, radioShow->formatted, radioShow->raw);
    radioShow->curLineIdx = 0;
    radioShow->numLines = String_NumLines(radioShow->formatted);
    radioShow->printState = RADIO_PRINT_STATE_NULL;
    String_CopyLineNum(radioShow->line, radioShow->formatted, radioShow->curLineIdx++);
    PrintLine(radioShow);

    if (radioShow->curLineIdx >= radioShow->numLines) {
        radioShow->printState = RADIO_PRINT_STATE_WAIT_EXIT;
    } else {
        radioShow->printState = RADIO_PRINT_STATE_WAIT_SCROLL; // HeartGold's first line waits without a scroll
    }
}

void RadioPrintInitEz(RadioShow *radioShow, int msgId)
{
    RadioPrintInit(radioShow, msgId, 0);
}

void RadioPrintAndPlayJingle(RadioShow *radioShow, int msgId)
{
    RadioPrintInitEz(radioShow, msgId);
    radioShow->textNoScroll = 1;
    radioShow->isPlayingJingle = TRUE;
    CompleteRadio_StopSeq(0);
    CompleteRadio_PlaySeq(SEQ_GS_RADIO_JINGLE_sseq);
}

BOOL Radio_RunTextPrinter(RadioShow *radioShow)
{
    switch (radioShow->printState) {
    case RADIO_PRINT_STATE_NULL:
        break;
    case RADIO_PRINT_STATE_PRINT_NEXT_LINE:
        if (RadioPrintAdvance(radioShow)) {
            radioShow->printState = radioShow->textNoScroll ? RADIO_PRINT_STATE_EXIT : RADIO_PRINT_STATE_WAIT_SCROLL_EXIT;
        } else {
            radioShow->printState = RADIO_PRINT_STATE_WAIT_SCROLL;
        }
        break;
    case RADIO_PRINT_STATE_WAIT_SCROLL:
        if (RadioShow_DelayAndScrollLine(radioShow)) {
            radioShow->printState = RADIO_PRINT_STATE_PRINT_NEXT_LINE;
        }
        break;
    case RADIO_PRINT_STATE_WAIT_FIRST_LINE:
        if (RadioShow_Delay(radioShow)) {
            radioShow->printState = RADIO_PRINT_STATE_PRINT_NEXT_LINE;
        }
        break;
    case RADIO_PRINT_STATE_WAIT_SCROLL_EXIT:
        if (RadioShow_DelayAndScrollLine(radioShow)) {
            radioShow->printState = RADIO_PRINT_STATE_EXIT;
        }
        break;
    case RADIO_PRINT_STATE_WAIT_EXIT:
        if (!RadioShow_Delay(radioShow)) {
            break;
        }
        // fallthrough
    case RADIO_PRINT_STATE_EXIT:
        radioShow->printState = RADIO_PRINT_STATE_NULL;
        return TRUE;
    }

    return FALSE;
}

BOOL Radio_RunTextPrinter_WaitJingle(RadioShow *radioShow)
{
    switch (radioShow->printWithJingleState) {
    case 0:
        if (Radio_RunTextPrinter(radioShow)) {
            ++radioShow->printWithJingleState;
        }
        break;
    case 1:
        if (!CompleteRadio_IsSeqPlaying()) {
            radioShow->printWithJingleState = 0;
            return TRUE;
        }
    }

    return FALSE;
}
