#include <nitro.h>

#include "generated/map_headers.h"

#include "applications/complete_pokegear/radio.h"

#include "complete_encounters.h"
#include "complete_map_info.h"
#include "complete_radio.h"
#include "heap.h"
#include "map_header.h"
#include "math_util.h"
#include "pokedex.h"
#include "string_template.h"
#include "vars_flags.h"

#include "generated/text_banks.h"
#include "generated/vars_flags.h"
#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0414.h"

// Sovereign Complete: Professor Oak's Pokémon Talk with Mary (HeartGold's shows/pokemon_talk.c): today's outbreak, if
// there's one, then five places of the region the player is in (Johto or Kanto), each with one of its wild Pokémon
// (one the Pokédex hasn't caught, more often than not) and two of Mary's phrases about it. Route 47 and 48 wait
// until the player has been on Route 47 (its fly point, FLAG_HGSS_UNK_9C9).

#define TALK_PLACES       5
#define TALK_PHRASES      13
#define MAX_LANDMARKS     200 // HeartGold's: 150, of its own maps
#define MAX_SPECIES_HERE  59
#define FLYPOINT_ROUTE_47 FLAG_HGSS_UNK_9C9 // HeartGold's FLYPOINT_UNK25

typedef struct PokemonTalkData {
    u16 state;
    u16 swarmSpecies;
    u16 swarmMap;
    u16 numLandmarks;
    u16 numSpecies;
    u16 numPrioritySpecies; // not caught yet
    u16 landmarkSpeciesPairs[TALK_PLACES][2];
    u16 flavorTextPairs[TALK_PLACES][2];
    u16 landmarksBuffer[MAX_LANDMARKS];
    u16 speciesBuffer[MAX_SPECIES_HERE];
    u16 prioritySpeciesBuffer[MAX_SPECIES_HERE];
    u8 selector;
} PokemonTalkData;

// Maps Oak doesn't talk about: special events' and the contest's, the Ruins' hall, the Ice Path's and the Whirl
// Islands' lower floors, Tohjo Falls' hidden room, the Safari Zone's gate
static const u16 sFilterLandmarks[] = {
    MAP_HEADER_HGSS_MOUNT_MOON_SQUARE,
    MAP_HEADER_HGSS_MOUNT_MOON_SQUARE_CLEFAIRY_EVENT,
    MAP_HEADER_HGSS_NATIONAL_PARK_BUG_CATCHING_CONTEST,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_HALL_ENTRANCE_SINJOH_EVENT,
    MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2,
    MAP_HEADER_HGSS_ICE_PATH_B1F,
    MAP_HEADER_HGSS_ICE_PATH_B2F,
    MAP_HEADER_HGSS_ICE_PATH_B3F,
    MAP_HEADER_HGSS_WHIRL_ISLANDS_B1F,
    MAP_HEADER_HGSS_WHIRL_ISLANDS_B2F,
    MAP_HEADER_HGSS_TOHJO_FALLS_HIDDEN_ROOM,
    MAP_HEADER_HGSS_SAFARI_ZONE_ENTRANCE_EXTERIOR,
};

static BOOL AlreadySampledLandmark(PokemonTalkData *data, u16 landmark, u8 num)
{
    for (int i = 0; i < num; ++i) {
        if (landmark == data->landmarkSpeciesPairs[i][0]) {
            return TRUE;
        }
    }

    return FALSE;
}

// HeartGold's RadioShow_PokemonTalk_SampleSpeciesFromMapEncounters: one of the map's Pokémon, an uncaught one unless
// there's only one of those and a coin says otherwise
static u16 SampleSpecies(PokemonTalkData *data, Pokedex *pokedex, u16 mapHeaderID)
{
    data->numSpecies = CompleteEncounters_MapSpecies(mapHeaderID, data->speciesBuffer, MAX_SPECIES_HERE);
    data->numPrioritySpecies = 0;

    for (int i = 0; i < data->numSpecies; i++) {
        if (!Pokedex_HasCaughtSpecies(pokedex, data->speciesBuffer[i])) {
            data->prioritySpeciesBuffer[data->numPrioritySpecies++] = data->speciesBuffer[i];
        }
    }

    if (data->numSpecies == 0) {
        return SPECIES_RATTATA;
    }

    if (data->numPrioritySpecies == 0 || (data->numPrioritySpecies == 1 && (LCRNG_Next() % 1000) < 500)) {
        return data->speciesBuffer[LCRNG_Next() % data->numSpecies];
    }

    return data->prioritySpeciesBuffer[LCRNG_Next() % data->numPrioritySpecies];
}

static BOOL Filtered(u16 mapHeaderID, BOOL route47Visited)
{
    for (int i = 0; i < (int)NELEMS(sFilterLandmarks); ++i) {
        if (mapHeaderID == sFilterLandmarks[i]) {
            return TRUE;
        }
    }

    return !route47Visited && (mapHeaderID == MAP_HEADER_HGSS_ROUTE_47 || mapHeaderID == MAP_HEADER_HGSS_ROUTE_48);
}

static void SampleMapAreasAndEncounters(RadioShow *radioShow, PokemonTalkData *data)
{
    Pokedex *pokedex = SaveData_GetPokedex(radioShow->saveData);
    BOOL route47Visited = VarsFlags_CheckFlag(SaveData_GetVarsFlags(radioShow->saveData), FLYPOINT_ROUTE_47);
    enum MapRegion region = radioShow->regionNo ? MAP_REGION_KANTO : MAP_REGION_JOHTO;

    data->numLandmarks = 0;

    for (u16 i = 0; i < MAP_HEADER_COUNT && data->numLandmarks < MAX_LANDMARKS; ++i) {
        if (MapHeader_IsHGSS(i) && MapHeader_HasWildEncounters(i) && MapHeader_GetRegion(i) == region && !Filtered(i, route47Visited)) {
            data->landmarksBuffer[data->numLandmarks++] = i;
        }
    }

    for (u8 i = 0; i < TALK_PLACES; ++i) {
        u16 index, landmark;
        int tries = 0;

        do {
            index = LCRNG_Next() % data->numLandmarks;
            landmark = MapHeader_GetMapLabelTextID(data->landmarksBuffer[index]);
        } while (AlreadySampledLandmark(data, landmark, i) && ++tries < 100);

        data->landmarkSpeciesPairs[i][0] = landmark;
        data->landmarkSpeciesPairs[i][1] = SampleSpecies(data, pokedex, data->landmarksBuffer[index]);
    }
}

static void Init(RadioShow *radioShow)
{
    PokemonTalkData *data = radioShow->showData;

    RadioShow_LoadMessages(radioShow, TEXT_BANK_HGSS_MSG_0414, TRUE);

    if (!CompleteEncounters_TodaysOutbreak(radioShow->saveData, &data->swarmMap, &data->swarmSpecies)) {
        data->swarmSpecies = SPECIES_NONE;
    }

    SampleMapAreasAndEncounters(radioShow, data);

    int step = ((LCRNG_Next() % 3) + 1) * 2; // 2, 4 or 6: each coprime with 13, so the phrases don't repeat
    u8 phrase1 = LCRNG_Next() % TALK_PHRASES;
    u8 phrase2 = LCRNG_Next() % TALK_PHRASES;

    for (int i = 0; i < TALK_PLACES; ++i) {
        data->flavorTextPairs[i][0] = phrase1;
        data->flavorTextPairs[i][1] = phrase2;
        phrase1 = (phrase1 + step) % TALK_PHRASES;
        phrase2 = (phrase2 + step) % TALK_PHRASES;
    }
}

BOOL RadioShow_PokemonTalk_Setup(RadioShow *radioShow)
{
    RadioShow_AllocShowData(radioShow, sizeof(PokemonTalkData));
    Init(radioShow);
    CompleteRadio_StopSeq(0);
    CompleteRadio_PlaySeq(SEQ_GS_OHKIDO_RABO_sseq);
    return FALSE;
}

BOOL RadioShow_PokemonTalk_Teardown(RadioShow *radioShow)
{
    return RadioShow_FreeShowData(radioShow);
}

BOOL RadioShow_PokemonTalk_Print(RadioShow *radioShow)
{
    PokemonTalkData *data = radioShow->showData;

    switch (data->state) {
    case 0:
        RadioPrintInitEz(radioShow, msg_0414_00002);
        ++data->state;
        break;
    case 1:
        if (!Radio_RunTextPrinter(radioShow)) {
            break;
        }

        if (data->swarmSpecies == SPECIES_NONE) {
            data->state = 3;
        } else {
            StringTemplate_SetLocationName(radioShow->template, 0, MapHeader_GetMapLabelTextID(data->swarmMap));
            RadioShow_SetSpeciesName(radioShow, 1, data->swarmSpecies);
            RadioPrintInitEz(radioShow, msg_0414_00032);
            ++data->state;
        }
        break;
    case 2:
        if (!Radio_RunTextPrinter(radioShow)) {
            break;
        }
        ++data->state;
        // fallthrough
    case 3:
        StringTemplate_SetLocationName(radioShow->template, 0, data->landmarkSpeciesPairs[data->selector][0]);
        RadioShow_SetSpeciesName(radioShow, 1, data->landmarkSpeciesPairs[data->selector][1]);
        RadioPrintInitEz(radioShow, msg_0414_00004);
        ++data->state;
        break;
    case 4:
        if (!Radio_RunTextPrinter(radioShow)) {
            break;
        }

        // Mary's two phrases: the first from messages 6 to 18, the second from 19 to 31
        for (int i = 0; i < 2; ++i) {
            MessageLoader_GetString(radioShow->showMessages, (msg_0414_00019 - msg_0414_00006) * i + msg_0414_00006 + data->flavorTextPairs[data->selector][i], radioShow->line);
            StringTemplate_SetString(radioShow->template, i + 2, radioShow->line, 0, TRUE, GAME_LANGUAGE);
        }

        RadioPrintInitEz(radioShow, msg_0414_00005);
        ++data->state;
        break;
    case 5:
        if (!Radio_RunTextPrinter(radioShow)) {
            break;
        }

        data->state = ++data->selector < TALK_PLACES ? 3 : 6;
        break;
    case 6:
        if (RadioShow_DelayAndScrollLine(radioShow)) {
            RadioPrintAndPlayJingle(radioShow, msg_0414_00003);
            ++data->state;
        }
        break;
    case 7:
        if (Radio_RunTextPrinter_WaitJingle(radioShow)) {
            radioShow->triggerCommercials = TRUE;
            return TRUE;
        }
        break;
    }

    return FALSE;
}
