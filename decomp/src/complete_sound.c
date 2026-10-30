#include "complete_sound.h"

#include <nitro.h>

#include "constants/battle.h"
#include "generated/species.h"
#include "generated/trainer_classes.h"
#include "generated/trainers.h"
#include "generated/vars_flags.h"

#include "complete_map_info.h"
#include "complete_trainers.h"
#include "field_battle_data_transfer.h"
#include "party.h"
#include "pokemon.h"
#include "sound.h"
#include "unk_02054884.h"
#include "vars_flags.h"

#include "data/hgss_sound.h"
#include "res/sound/pl_sound_data.naix"

#define HGSS_BATTLE_MUSIC_TRAINER       41 // sHGSSBattleMusic's rows (HeartGold's BattleSetup_GetTransitionAndMusicParam)
#define HGSS_BATTLE_MUSIC_WILD          42
#define HGSS_BATTLE_MUSIC_FRONTIER      35
#define HGSS_BATTLE_MUSIC_LINK          36
#define HGSS_BATTLE_MUSIC_DOUBLES       37
#define HGSS_BATTLE_MUSIC_DOUBLE_WILD   38
#define HGSS_BATTLE_MUSIC_FRONTIER_BRAIN 39
#define HGSS_BATTLE_MUSIC_ROCKET_FIRST  29
#define HGSS_BATTLE_MUSIC_ROCKET_LAST   34
#define HGSS_BATTLE_MUSIC_KIMONO_GIRL   43
#define HGSS_BATTLE_MUSIC_RED           44

// Sovereign Complete: HeartGold's songs in the engine's sound code (docs/Music.md). Platinum's field songs share its
// field and dungeon banks, and its surfing and cycling songs play with the map's song's bank. Each of HeartGold's
// songs has a bank of its own (tools/complete/import_hgss_sound.py), so a field song of HeartGold's plays with its own
// bank, which loads as the field's bank when the song starts (src/sound.c, src/sound_playback.c).

// HeartGold's songs' banks come after the engine's (tools/complete/split_sound_basic.py puts BANK_BGM_BASIC last)
BOOL CompleteSound_HasOwnBank(u16 seqID)
{
    return Sound_GetBankIDFromSequenceID(seqID) > BANK_BGM_BASIC_sbnk;
}

// The song whose bank a field song plays with: its own, for one of HeartGold's, or the map's song's
u16 CompleteSound_FieldBankSequence(u16 seqID, u16 fieldBGM)
{
    return CompleteSound_HasOwnBank(seqID) ? seqID : fieldBGM;
}

// Whether a field song of HeartGold's needs its bank loaded, the field's loaded bank being another
BOOL CompleteSound_FieldBankChanges(u16 seqID, u16 loadedBankID)
{
    return CompleteSound_HasOwnBank(seqID) && Sound_GetBankIDFromSequenceID(seqID) != loadedBankID;
}

// Johto and Kanto's own surfing and cycling songs in place of Sinnoh's (src/field_bgm.c)
u16 CompleteSound_ForMap(enum MapHeaderID mapHeaderID, u16 seqID)
{
    if (!MapHeader_IsHGSS(mapHeaderID)) {
        return seqID;
    }

    switch (seqID) {
    case SEQ_NAMINORI_sseq:
        return SEQ_GS_NAMINORI_sseq;
    case SEQ_BICYCLE_sseq:
    case SEQ_BICYCLE_sseq_1:
        return SEQ_GS_BICYCLE_sseq;
    default:
        return seqID;
    }
}

// The songs a flag puts on a map (HeartGold's sMusicOverrideMap, its src/sys_flags.c): the Bug-Catching Contest's
// theme in the National Park and its gatehouses while the contest runs, and the occupation theme in the Radio Tower
// while Team Rocket holds it. HeartGold's entries for Cerulean Gym, Route 24 and Pal Park wait on flags no script
// sets, so they're left out.
static const struct {
    u16 mapHeaderID;
    u16 flag;
    u16 seqID;
} sAltMusic[] = {
    { MAP_HEADER_HGSS_NATIONAL_PARK, FLAG_HGSS_BUG_CONTEST_ACTIVE, SEQ_GS_TAIKAIMAE_D5_sseq },
    { MAP_HEADER_HGSS_ROUTE_35_NATIONAL_PARK_POKEATHALON_GATEHOUSE, FLAG_HGSS_BUG_CONTEST_ACTIVE, SEQ_GS_TAIKAIMAE_sseq },
    { MAP_HEADER_HGSS_ROUTE_36_NATIONAL_PARK_GATEHOUSE, FLAG_HGSS_BUG_CONTEST_ACTIVE, SEQ_GS_TAIKAIMAE_sseq },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_1F, FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE, SEQ_GS_SENKYO_sseq },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_2F, FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE, SEQ_GS_SENKYO_sseq },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_3F, FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE, SEQ_GS_SENKYO_sseq },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_4F, FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE, SEQ_GS_SENKYO_sseq },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_5F, FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE, SEQ_GS_SENKYO_sseq },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_OBSERVATION_DECK, FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE, SEQ_GS_SENKYO_sseq },
    { MAP_HEADER_HGSS_GOLDENROD_RADIO_TOWER_ELEVATOR, FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE, SEQ_GS_SENKYO_sseq },
};

// A map's song while a flag is set, or 0 (src/system_flags.c, SystemFlag_GetAltMusicForHeader)
u16 CompleteSound_AltMusicForHeader(VarsFlags *varsFlags, enum MapHeaderID mapHeaderID)
{
    for (int i = 0; i < NELEMS(sAltMusic); i++) {
        if (sAltMusic[i].mapHeaderID == mapHeaderID && VarsFlags_CheckFlag(varsFlags, sAltMusic[i].flag)) {
            return sAltMusic[i].seqID;
        }
    }

    return 0;
}

// HeartGold's encounter theme for one of its trainers (its src/field_bgm.c), or SEQ_NONE for Sinnoh's
u16 CompleteSound_EncounterBGM(u16 trainerID, u32 trainerClass)
{
    if (trainerID < TRAINER_HGSS_FIRST || trainerID > TRAINER_HGSS_LAST) {
        return SEQ_NONE;
    }

    for (int i = 0; i < NELEMS(sHGSSEncounterMusic); i++) {
        if (sHGSSEncounterMusic[i][0] == trainerClass) {
            return sHGSSEncounterMusic[i][1];
        }
    }

    return SEQ_GS_EYE_J_SHOUNEN_sseq;
}

static int FindRow(const u16 (*table)[2], int count, u32 key, int otherwise)
{
    for (int i = 0; i < count; i++) {
        if (table[i][0] == key) {
            return table[i][1];
        }
    }

    return otherwise;
}

// HeartGold's battle theme for a battle on Johto and Kanto's maps (its BattleSetup_GetTransitionAndMusicParam and
// BattleSetup_GetWildBattleMusic), or SEQ_NONE elsewhere: by trainer class or wild species, with Kanto's own trainer
// and wild themes in Kanto
u16 CompleteSound_BattleBGM(const FieldBattleDTO *dto)
{
    if (!MapHeader_IsHGSS(dto->mapHeaderID)) {
        return SEQ_NONE;
    }

    u32 battleType = dto->battleType;
    int row;

    if (battleType & BATTLE_TYPE_TRAINER) {
        row = FindRow(sHGSSBattleMusicByClass, NELEMS(sHGSSBattleMusicByClass), dto->trainer[1].header.trainerType, HGSS_BATTLE_MUSIC_TRAINER);

        if (battleType & BATTLE_TYPE_FRONTIER) {
            if (row != HGSS_BATTLE_MUSIC_FRONTIER_BRAIN) {
                row = (battleType & BATTLE_TYPE_DOUBLES) ? HGSS_BATTLE_MUSIC_DOUBLES : HGSS_BATTLE_MUSIC_FRONTIER;
            }
        } else if ((row < HGSS_BATTLE_MUSIC_ROCKET_FIRST || row > HGSS_BATTLE_MUSIC_ROCKET_LAST) && row != HGSS_BATTLE_MUSIC_KIMONO_GIRL && row != HGSS_BATTLE_MUSIC_RED) {
            if (battleType & BATTLE_TYPE_DOUBLES) {
                row = HGSS_BATTLE_MUSIC_DOUBLES;
            } else if (battleType & BATTLE_TYPE_LINK) {
                row = HGSS_BATTLE_MUSIC_LINK;
            }
        }
    } else {
        Pokemon *mon = Party_FindFirstEligibleBattler(dto->parties[1]);

        row = FindRow(sHGSSBattleMusicBySpecies, NELEMS(sHGSSBattleMusicBySpecies), Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL), HGSS_BATTLE_MUSIC_WILD);

        if (row >= HGSS_BATTLE_MUSIC_WILD && (battleType & BATTLE_TYPE_DOUBLES)) {
            row = HGSS_BATTLE_MUSIC_DOUBLE_WILD;
        }
    }

    u16 seqID = sHGSSBattleMusic[row];

    if (MapHeader_GetRegion(dto->mapHeaderID) == MAP_REGION_KANTO) {
        if (seqID == SEQ_GS_VS_NORAPOKE_sseq) {
            seqID = SEQ_GS_VS_NORAPOKE_KANTO_sseq;
        } else if (seqID == SEQ_GS_VS_TRAINER_sseq) {
            seqID = SEQ_GS_VS_TRAINER_KANTO_sseq;
        }
    }

    return seqID;
}

// HeartGold's victory theme over a trainer on Johto and Kanto's maps (its battle_controller_player.c), or SEQ_NONE
// elsewhere: its Gym Leaders', Elite Four's and Champion's, the Frontier Brains', or a trainer's
u16 CompleteSound_TrainerVictoryBGM(int mapHeaderID, u32 trainerClass)
{
    if (!MapHeader_IsHGSS(mapHeaderID)) {
        return SEQ_NONE;
    }

    switch (trainerClass) {
    case TRAINER_CLASS_HGSS_LEADER_FALKNER:
    case TRAINER_CLASS_HGSS_LEADER_BUGSY:
    case TRAINER_CLASS_HGSS_LEADER_WHITNEY:
    case TRAINER_CLASS_HGSS_LEADER_MORTY:
    case TRAINER_CLASS_HGSS_LEADER_PRYCE:
    case TRAINER_CLASS_HGSS_LEADER_JASMINE:
    case TRAINER_CLASS_HGSS_LEADER_CHUCK:
    case TRAINER_CLASS_HGSS_LEADER_CLAIR:
    case TRAINER_CLASS_HGSS_CHAMPION:
    case TRAINER_CLASS_HGSS_ELITE_FOUR_WILL:
    case TRAINER_CLASS_HGSS_ELITE_FOUR_KAREN:
    case TRAINER_CLASS_HGSS_ELITE_FOUR_KOGA:
    case TRAINER_CLASS_HGSS_ELITE_FOUR_BRUNO:
    case TRAINER_CLASS_HGSS_LEADER_BROCK:
    case TRAINER_CLASS_HGSS_LEADER_MISTY:
    case TRAINER_CLASS_HGSS_LEADER_LT_SURGE:
    case TRAINER_CLASS_HGSS_LEADER_ERIKA:
    case TRAINER_CLASS_HGSS_LEADER_JANINE:
    case TRAINER_CLASS_HGSS_LEADER_SABRINA:
    case TRAINER_CLASS_HGSS_LEADER_BLAINE:
    case TRAINER_CLASS_HGSS_LEADER_BLUE:
        return SEQ_GS_WIN3_sseq;
    case TRAINER_CLASS_TOWER_TYCOON:
    case TRAINER_CLASS_HALL_MATRON:
    case TRAINER_CLASS_FACTORY_HEAD:
    case TRAINER_CLASS_ARCADE_STAR:
    case TRAINER_CLASS_CASTLE_VALET:
        return SEQ_GS_WINBRAIN_sseq;
    default:
        return SEQ_GS_WIN1_sseq;
    }
}

// The wild victory theme: HeartGold's on Johto and Kanto's maps
u16 CompleteSound_WildVictoryBGM(int mapHeaderID)
{
    return MapHeader_IsHGSS(mapHeaderID) ? SEQ_GS_WIN2_sseq : VICTORY_WILD_POKEMON_sseq;
}
