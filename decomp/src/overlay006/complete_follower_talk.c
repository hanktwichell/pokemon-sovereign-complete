#include <nitro.h>
#include <string.h>

#include "constants/battle/condition.h"
#include "constants/field/map_tile_behaviors.h"
#include "constants/heap.h"
#include "constants/items.h"
#include "constants/map_object.h"
#include "constants/menu.h"
#include "constants/narc.h"
#include "constants/overworld_weather.h"
#include "constants/scrcmd.h"
#include "constants/sound.h"
#include "constants/species.h"
#include "generated/bg_event_types.h"
#include "generated/genders.h"
#include "generated/pokemon_types.h"
#include "generated/text_banks.h"
#include "generated/vars_flags.h"

#include "data/hgss_follower_talk.h"
#include "field/field_system.h"
#include "overlay005/field_effect_manager.h"
#include "overlay005/ov5_021ECC20.h"
#include "overlay005/script_message.h"
#include "res/sound/pl_sound_data.naix"

#include "billboard.h"
#include "complete_follower.h"
#include "complete_follower_talk.h"
#include "complete_test.h"
#include "field_message.h"
#include "field_overworld_state.h"
#include "field_script_context.h"
#include "heap.h"
#include "inlines.h"
#include "item.h"
#include "location.h"
#include "map_header.h"
#include "map_header_data.h"
#include "map_object.h"
#include "map_object_move.h"
#include "map_tile_behavior.h"
#include "math_util.h"
#include "message.h"
#include "narc.h"
#include "overworld_anim_manager.h"
#include "party.h"
#include "player_avatar.h"
#include "pokemon.h"
#include "save_player.h"
#include "savedata_misc.h"
#include "script_manager.h"
#include "sound_playback.h"
#include "string_template.h"
#include "terrain_collision_manager.h"
#include "trainer_info.h"
#include "unk_020298BC.h"
#include "unk_020559DC.h"
#include "vars_flags.h"

// Sovereign Complete: talking to the following Pokémon, as HeartGold's does (its scr_seq_0163 and the
// Task_FollowMonInteract of its overlay 2, which pret's decomp has only as assembly). HeartGold's data is in
// res/prebuilt/fielddata/complete_follower_talk/follower_talk.narc (tools/complete/import_hgss_follower_talk.py):
// - the choices: what the moment is like (the Pokémon's HP, status, mood, friendship, nature, type and held item; the
//   tile it stands on, the time, the weather, the people and hidden items nearby, the map, a flag; a chance), each
//   leading to an interaction. The first 12 that can happen anywhere are tried, then the place's 30, then the other
//   58; the first that fits is it.
// - the interactions: up to five steps (a motion, a message, a cry, an emote), then a yes or no leading to another
//   interaction, a change to friendship and to the mood, and an accessory or a Shiny Leaf the Pokémon found.
// - the motions: hops, shakes and turns, a keyframe at a time.
// - the emotes: bubbles over the follower (a heart, faces, "...", "!"...), HeartGold's model and frames.
// CommonScript_CompleteFollowerTalk runs it with the commands below. Not ported: the Pokéathlon performance a few
// choices ask about.

#define TALK_STEPS              5
#define TALK_KEYFRAMES          10
#define TALK_NO_STEP            0xFFFF
#define TALK_LAST_KEYFRAME      0xFF
#define TALK_CHOICES            (FOLLOWER_TALK_GENERAL_CHOICES + FOLLOWER_TALK_PLACE_CHOICES)
#define KIND_LATER_SPECIES      130 // HeartGold's kind for most Pokémon, which the ones past #493 get
#define HGSS_SEQ_SE_END         2378 // a step's sound past HeartGold's sound effects is the Pokémon's cry
#define HGSS_ACCESSORIES        100
#define HGSS_MSG_0040_ACCESSORY 32 // "put away the ... in the Fashion Case."
#define HGSS_MSG_0040_CASE_FULL 95 // "received ...! But the Fashion Case is already full!"
#define HGSS_MSG_0040_LEAF      97 // "found a Shiny Leaf! ... put the Shiny Leaf on ...!"
#define HGSS_MSG_0040_HAS_LEAF  98 // "... already has a Shiny Leaf!"
#define SHINY_LEAVES            5
#define EMOTE_RESOURCES         900 // the emote's model, sequence, frames and billboard template, apart from the field effects'

typedef struct FollowerTalkChoice {
    u8 hp;
    u8 mood : 4;
    u8 friendship : 4;
    u8 nature : 3;
    u8 gender : 2;
    u8 status : 3;
    u8 heldItem : 5;
    u8 unused3 : 3;
    u8 type : 5;
    u8 pokeathlon : 3;
    u8 grass;
    u8 kind;
    u8 shinyLeaf;
    u16 weather : 3;
    u16 unused8 : 10;
    u16 facing : 3;
    u16 people : 3;
    u16 timeOfDay : 3;
    u16 interaction : 10;
    u16 mapHeaderID; // + 1
    u16 tileBehavior;
    u8 unused10 : 1;
    u8 level : 2;
    u8 sprites : 2;
    u8 hiddenItems : 3;
    u8 chance;
    u16 flag;
} FollowerTalkChoice;

typedef struct FollowerTalkStep {
    u16 motion;
    u16 message; // + 1, of HeartGold's msg_0265
    u16 sound;
    u8 emote;
    u8 delay;
} FollowerTalkStep;

typedef struct FollowerTalkInteraction {
    FollowerTalkStep steps[TALK_STEPS];
    u32 question;
    u16 yes;
    u16 no;
    s8 friendship;
    s8 mood;
    u8 accessory; // + 1
    u8 shinyLeaf; // 1-5
} FollowerTalkInteraction;

typedef struct FollowerTalkKeyframe {
    u8 facing; // + 1
    u8 frames;
    s8 x;
    s8 height;
    s8 z;
    u8 cry;
    u16 unused;
} FollowerTalkKeyframe;

// What the choices ask about, in HeartGold's terms (its ov02_0224F058)
typedef struct FollowerTalkMoment {
    u8 hasItem;
    u8 itemKind;
    u8 hp;
    u8 status;
    u8 level;
    u8 types[2];
    u8 friendship;
    u8 natureGroup;
    u8 gender;
    u8 kind;
    u8 shinyLeaves;
    u8 people;
    u8 hiddenItems;
    u8 weather;
    u8 tileBehavior;
    u8 grass;
    u8 timeOfDay;
    s8 mood;
    u8 facing;
    u16 mapHeaderID;
} FollowerTalkMoment;

enum TalkPhase {
    PHASE_MOTION = 0,
    PHASE_MESSAGE,
};

typedef struct FollowerTalk {
    FollowerTalkInteraction interaction;
    FollowerTalkKeyframe keyframes[TALK_KEYFRAMES];
    StringTemplate *template;
    VecFx32 offset;
    VecFx32 startOffset;
    u16 species;
    u8 form;
    u8 stepCount;
    u8 step;
    u8 phase;
    u8 keyframe;
    u8 frame;
    u8 startFacing;
    u8 effectsDone;
    u8 findingDone;
    u8 over;
    OverworldAnimManager *emote;
#ifdef SOVEREIGN_TEST
    VecFx32 talkOffset; // the follower's sprite offset as the talk began
    u16 accessory;
#endif
} FollowerTalk;

static FollowerTalk *sTalk;

// HeartGold's groups of natures (its ov02_02253AC0)
static const u8 sNatureGroups[] = { 4, 5, 4, 4, 1, 4, 3, 2, 1, 2, 5, 6, 3, 1, 1, 3, 6, 3, 5, 6, 2, 2, 1, 3, 6 };

// HeartGold's numbers for the types (its ov02_0224F79C); its ??? type, the engine's Fairy, has none
static const u8 sTypeKinds[NUM_POKEMON_TYPES] = {
    [TYPE_NORMAL] = 1,
    [TYPE_FIGHTING] = 7,
    [TYPE_FLYING] = 10,
    [TYPE_POISON] = 8,
    [TYPE_GROUND] = 9,
    [TYPE_ROCK] = 13,
    [TYPE_BUG] = 12,
    [TYPE_GHOST] = 14,
    [TYPE_STEEL] = 17,
    [TYPE_FAIRY] = 0,
    [TYPE_FIRE] = 2,
    [TYPE_WATER] = 3,
    [TYPE_GRASS] = 5,
    [TYPE_ELECTRIC] = 4,
    [TYPE_PSYCHIC] = 11,
    [TYPE_ICE] = 6,
    [TYPE_DRAGON] = 15,
    [TYPE_DARK] = 16,
};

// HeartGold's numbers for a held item's pocket (its ov02_0224F820)
static const u8 sPocketKinds[POCKET_KEY_ITEMS] = {
    [POCKET_ITEMS] = 4,
    [POCKET_MEDICINE] = 2,
    [POCKET_BALLS] = 1,
    [POCKET_TMHMS] = 7,
    [POCKET_BERRIES] = 6,
    [POCKET_MAIL] = 5,
    [POCKET_BATTLE_ITEMS] = 3,
};

static MapObject *Follower(FieldSystem *fieldSystem)
{
    return MapObjMan_LocalMapObjByIndex(fieldSystem->mapObjMan, LOCALID_COMPLETE_FOLLOWER);
}

static Pokemon *Lead(FieldSystem *fieldSystem)
{
    return Party_GetPokemonBySlotIndex(SaveData_GetParty(fieldSystem->saveData), 0);
}

static u8 SpeciesKind(int species)
{
    if (species < 1 || species > FOLLOWER_TALK_KINDS) {
        return KIND_LATER_SPECIES;
    }

    u8 *kinds = NARC_AllocAtEndAndReadFromMemberByIndexPair(NARC_INDEX_FIELDDATA__COMPLETE__FOLLOWER_TALK,
        FOLLOWER_TALK_MEMBER_KINDS, HEAP_ID_FIELD3, species - 1, 1);
    u8 kind = kinds[0];

    Heap_Free(kinds);
    return kind;
}

// People within a tile of the player (HeartGold's ov02_0224F4BC), the player and the follower aside
static u8 PeopleNearby(FieldSystem *fieldSystem)
{
    int playerX = PlayerAvatar_GetXPos(fieldSystem->playerAvatar);
    int playerZ = PlayerAvatar_GetZPos(fieldSystem->playerAvatar);
    MapObject *mapObj;
    int index = 0;
    u8 count = 0;

    while (MapObjectMan_FindObjectWithStatus(fieldSystem->mapObjMan, &mapObj, &index, MAP_OBJ_STATUS_0)) {
        int dx = playerX - MapObject_GetX(mapObj);
        int dz = playerZ - MapObject_GetZ(mapObj);
        u32 localID = MapObject_GetLocalID(mapObj);

        if (dx >= -1 && dx <= 1 && dz >= -1 && dz <= 1 && localID != LOCALID_PLAYER && localID != LOCALID_COMPLETE_FOLLOWER) {
            count++;
        }
    }

    return count;
}

// The map's hidden items not found yet (HeartGold's ov02_0224F580)
static u8 HiddenItemsLeft(FieldSystem *fieldSystem)
{
    const BgEvent *bgEvents = MapHeaderData_GetBgEvents(fieldSystem);
    int numBgEvents = MapHeaderData_GetNumBgEvents(fieldSystem);
    u8 count = 0;

    for (int i = 0; bgEvents != NULL && i < numBgEvents; i++) {
        if (bgEvents[i].type == BG_EVENT_TYPE_HIDDEN_ITEM
            && !FieldSystem_CheckFlag(fieldSystem, Script_GetHiddenItemFlag(bgEvents[i].script))) {
            count++;
        }
    }

    return count;
}

static u8 Weather(FieldSystem *fieldSystem)
{
    switch (FieldOverworldState_GetWeather(SaveData_GetFieldOverworldState(fieldSystem->saveData))) {
    case OVERWORLD_WEATHER_CLEAR:
        return 1;
    case OVERWORLD_WEATHER_RAINING:
    case OVERWORLD_WEATHER_HEAVY_RAIN:
    case OVERWORLD_WEATHER_THUNDERSTORM:
        return 3; // HeartGold's rain
    default:
        return 0;
    }
}

static void GetMoment(FieldSystem *fieldSystem, FollowerTalkMoment *moment)
{
    Pokemon *mon = Lead(fieldSystem);
    MapObject *follower = Follower(fieldSystem);
    int item = Pokemon_GetValue(mon, MON_DATA_HELD_ITEM, NULL);
    int hp = Pokemon_GetValue(mon, MON_DATA_HP, NULL) * 100 / Pokemon_GetValue(mon, MON_DATA_MAX_HP, NULL);
    u32 status = Pokemon_GetValue(mon, MON_DATA_STATUS, NULL);
    int pocket = item != ITEM_NONE ? Item_LoadParam(item, ITEM_PARAM_FIELD_POCKET, HEAP_ID_FIELD3) : POCKET_KEY_ITEMS;

    memset(moment, 0, sizeof(*moment));
    moment->hasItem = item != ITEM_NONE;
    moment->itemKind = item != ITEM_NONE && pocket < POCKET_KEY_ITEMS ? sPocketKinds[pocket] : 8;
    moment->hp = hp >= 100 ? 1 : hp >= 75 ? 2 : hp >= 50 ? 3 : hp >= 25 ? 4 : 5;

    if (status & (MON_CONDITION_POISON | MON_CONDITION_TOXIC)) {
        moment->status = 5;
    } else if (status & MON_CONDITION_SLEEP) {
        moment->status = 8;
    } else if (status & MON_CONDITION_BURN) {
        moment->status = 2;
    } else if (status & MON_CONDITION_FREEZE) {
        moment->status = 3;
    } else if (status & MON_CONDITION_PARALYSIS) {
        moment->status = 4;
    } else {
        moment->status = 1;
    }

    moment->level = Pokemon_GetValue(mon, MON_DATA_LEVEL, NULL) >= 48 ? 4 : 6; // as HeartGold's, which no choice matches
    moment->types[0] = sTypeKinds[Pokemon_GetValue(mon, MON_DATA_TYPE_1, NULL)];
    moment->types[1] = sTypeKinds[Pokemon_GetValue(mon, MON_DATA_TYPE_2, NULL)];
    moment->friendship = Pokemon_GetValue(mon, MON_DATA_FRIENDSHIP, NULL);
    moment->natureGroup = sNatureGroups[Pokemon_GetNature(mon)];
    moment->gender = Pokemon_GetValue(mon, MON_DATA_GENDER, NULL) == GENDER_MALE ? 1 : 2;
    moment->kind = SpeciesKind(Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL));
    moment->shinyLeaves = CompleteFollower_GetShinyLeaves(mon);
    moment->people = PeopleNearby(fieldSystem);
    moment->hiddenItems = HiddenItemsLeft(fieldSystem);
    moment->weather = Weather(fieldSystem);
    moment->tileBehavior = TerrainCollisionManager_GetTileBehavior(fieldSystem, MapObject_GetX(follower), MapObject_GetZ(follower));
    moment->grass = TileBehavior_HasEncounters(moment->tileBehavior) ? 1 : 2;
    moment->timeOfDay = FieldSystem_GetTimeOfDay(fieldSystem) + 1;
    moment->mood = CompleteFollower_GetMood(mon);

    static const u8 facings[] = { [DIR_NORTH] = 3, [DIR_SOUTH] = 4, [DIR_WEST] = 2, [DIR_EAST] = 1 };
    int facing = MapObject_GetFacingDir(follower);

    moment->facing = facing >= DIR_NORTH && facing <= DIR_EAST ? facings[facing] : 0;
    moment->mapHeaderID = fieldSystem->location->mapHeaderID;
}

// HeartGold's ov02_02250594
static BOOL FriendshipFits(u8 range, u8 friendship)
{
    switch (range) {
    case 1:
        return friendship == 255;
    case 2:
        return friendship >= 200 && friendship < 255;
    case 3:
        return friendship >= 150 && friendship < 200;
    case 4:
        return friendship >= 90 && friendship < 150;
    case 5:
        return friendship >= 60 && friendship < 90;
    case 6:
        return friendship >= 30 && friendship < 60;
    case 7:
        return friendship >= 1 && friendship < 30;
    case 8:
        return friendship == 0;
    case 9:
        return friendship >= 90;
    case 10:
        return friendship < 60;
    default:
        return FALSE;
    }
}

// HeartGold's ov02_02250628
static BOOL MoodFits(u8 range, s8 mood)
{
    switch (range) {
    case 1:
        return mood == 127;
    case 2:
        return mood >= 100 && mood < 127;
    case 3:
        return mood >= 50 && mood < 100;
    case 4:
        return mood >= 30 && mood < 50;
    case 5:
        return mood > -30 && mood < 30;
    case 6:
        return mood > -50 && mood <= -30;
    case 7:
        return mood > -127 && mood <= -50;
    case 8:
        return mood == -127;
    case 9:
        return mood >= 0;
    case 10:
        return mood <= -1;
    default:
        return FALSE;
    }
}

// HeartGold's ov02_022506D4
static BOOL KindFits(u8 wanted, u8 kind)
{
    switch (wanted) {
    case 0xFA:
        return kind <= 0x13;
    case 0xFB:
        return kind <= 0x82;
    case 0xFC:
        return kind >= 0x8C && kind <= 0x95;
    case 0xFD:
        return kind >= 0xA0;
    case 0xFE:
        return kind >= 0xDC;
    default:
        return wanted < 0xFA && wanted == kind;
    }
}

// HeartGold's ov02_0224F108: whether a choice fits the moment. The chance is drawn first, as HeartGold does.
static BOOL ChoiceFits(FieldSystem *fieldSystem, const FollowerTalkChoice *choice, const FollowerTalkMoment *moment)
{
    if (LCRNG_Next() % 100 >= choice->chance) {
        return FALSE;
    }

    if (choice->flag != 0 && !FieldSystem_CheckFlag(fieldSystem, choice->flag)) {
        return FALSE;
    }

    if (choice->heldItem != 0 && (choice->heldItem == 9 ? !moment->hasItem : choice->heldItem != moment->itemKind)) {
        return FALSE;
    }

    if (choice->hp != 0 && choice->hp != moment->hp) {
        return FALSE;
    }

    if (choice->status != 0) {
        BOOL ailing = moment->status == 2 || moment->status == 3 || moment->status == 4 || moment->status == 5 || moment->status == 8;

        if (choice->status == 7 ? !ailing : choice->status != moment->status) {
            return FALSE;
        }
    }

    if (choice->people != 0 && (choice->people == 5 ? moment->people < 5 : choice->people != moment->people)) {
        return FALSE;
    }

    if (choice->hiddenItems != 0 && (choice->hiddenItems == 4 ? moment->hiddenItems < 4 : choice->hiddenItems != moment->hiddenItems)) {
        return FALSE;
    }

    if (choice->level != 0 && choice->level != moment->level) {
        return FALSE;
    }

    if (choice->sprites != 0) { // as in HeartGold, a choice that asks for certain people nearby never fits
        return FALSE;
    }

    if (choice->type != 0 && choice->type != moment->types[0] && choice->type != moment->types[1]) {
        return FALSE;
    }

    if (choice->weather != 0 && choice->weather != moment->weather) {
        return FALSE;
    }

    if (choice->tileBehavior != 0 && choice->tileBehavior != moment->tileBehavior) {
        return FALSE;
    }

    if (choice->grass != 0 && choice->grass != moment->grass) {
        return FALSE;
    }

    if (choice->mapHeaderID != 0 && choice->mapHeaderID - 1 != moment->mapHeaderID) {
        return FALSE;
    }

    if (choice->timeOfDay != 0 && choice->timeOfDay != moment->timeOfDay) {
        return FALSE;
    }

    if (choice->mood != 0 && !MoodFits(choice->mood, moment->mood)) {
        return FALSE;
    }

    if (choice->pokeathlon != 0) { // the Pokéathlon isn't in the game
        return FALSE;
    }

    if (choice->friendship != 0 && !FriendshipFits(choice->friendship, moment->friendship)) {
        return FALSE;
    }

    if (choice->nature != 0 && choice->nature != moment->natureGroup) {
        return FALSE;
    }

    if (choice->kind != 0 && !KindFits(choice->kind, moment->kind)) {
        return FALSE;
    }

    if (choice->shinyLeaf != 0 && (choice->shinyLeaf > SHINY_LEAVES || (moment->shinyLeaves & (1 << (choice->shinyLeaf - 1))))) {
        return FALSE;
    }

    if (choice->gender != 0 && choice->gender != moment->gender) {
        return FALSE;
    }

    if (choice->facing != 0 && choice->facing != moment->facing) {
        return FALSE;
    }

    return TRUE;
}

// HeartGold's ov02_0224EF94: the interaction for this moment, or 0
static u16 ChooseInteraction(FieldSystem *fieldSystem)
{
    FollowerTalkMoment moment;
    FollowerTalkChoice *choices = Heap_AllocAtEnd(HEAP_ID_FIELD3, sizeof(FollowerTalkChoice) * TALK_CHOICES);
    FollowerTalkChoice *general = choices + FOLLOWER_TALK_PLACE_CHOICES;
    u32 place = MapHeader_GetMapLabelTextID(fieldSystem->location->mapHeaderID);
    u16 interaction = 0;

    GetMoment(fieldSystem, &moment);
    memset(choices, 0, sizeof(FollowerTalkChoice) * FOLLOWER_TALK_PLACE_CHOICES);

    if (place < FOLLOWER_TALK_PLACES) {
        NARC_ReadWholeMemberByIndexPair(choices, NARC_INDEX_FIELDDATA__COMPLETE__FOLLOWER_TALK, FOLLOWER_TALK_MEMBER_PLACES + place);
    }

    NARC_ReadWholeMemberByIndexPair(general, NARC_INDEX_FIELDDATA__COMPLETE__FOLLOWER_TALK, FOLLOWER_TALK_MEMBER_GENERAL);

    for (int i = 0; i < TALK_CHOICES && interaction == 0; i++) {
        // the first general ones, then the place's, then the other general ones
        const FollowerTalkChoice *choice = i < FOLLOWER_TALK_GENERAL_FIRST ? &general[i]
            : i < FOLLOWER_TALK_GENERAL_FIRST + FOLLOWER_TALK_PLACE_CHOICES ? &choices[i - FOLLOWER_TALK_GENERAL_FIRST]
                                                                             : &general[i - FOLLOWER_TALK_PLACE_CHOICES];

        if (choice->interaction != 0 && ChoiceFits(fieldSystem, choice, &moment)) {
            interaction = choice->interaction;
        }
    }

    Heap_Free(choices);
    return interaction;
}

static void LoadInteraction(FollowerTalk *talk, u16 interaction)
{
    talk->step = 0;
    talk->phase = PHASE_MOTION;
    talk->effectsDone = FALSE;
    talk->findingDone = FALSE;
    talk->stepCount = 0;
    talk->over = interaction == 0 || interaction > FOLLOWER_TALK_INTERACTIONS;

    if (talk->over) {
        return;
    }

    NARC_ReadWholeMemberByIndexPair(&talk->interaction, NARC_INDEX_FIELDDATA__COMPLETE__FOLLOWER_TALK,
        FOLLOWER_TALK_MEMBER_INTERACTIONS + interaction - 1);

    while (talk->stepCount < TALK_STEPS && talk->interaction.steps[talk->stepCount].motion != TALK_NO_STEP) {
        talk->stepCount++;
    }
}

// HeartGold's ov02_02250504: the interaction's change to the mood and to friendship
static void ApplyEffects(FieldSystem *fieldSystem, FollowerTalk *talk)
{
    Pokemon *mon = Lead(fieldSystem);
    int friendship = Pokemon_GetValue(mon, MON_DATA_FRIENDSHIP, NULL) + talk->interaction.friendship;

    if (talk->effectsDone) {
        return;
    }

    talk->effectsDone = TRUE;
    CompleteFollower_SetMood(mon, CompleteFollower_GetMood(mon) + talk->interaction.mood);
    friendship = friendship > 255 ? 255 : friendship < 0 ? 0 : friendship;
    Pokemon_SetValue(mon, MON_DATA_FRIENDSHIP, &friendship);
}

static BOOL WaitForMessage(ScriptContext *ctx)
{
    u8 *printerID = FieldSystem_GetScriptMemberPtr(ctx->fieldSystem, SCRIPT_MANAGER_MESSAGE_ID);
    return FieldMessage_FinishedPrinting(*printerID);
}

static void ShowMessage(ScriptContext *ctx, u16 bank, u16 message)
{
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, bank, HEAP_ID_FIELD3);
    MessageLoader *scriptLoader = ctx->loader;

    ctx->loader = loader; // ScriptMessage_ShowTemplate reads the script's bank
    ScriptMessage_ShowTemplate(ctx, sTalk->template, message, TRUE);
    ctx->loader = scriptLoader;
    MessageLoader_Free(loader);
    ScriptContext_Pause(ctx, WaitForMessage);

#ifdef SOVEREIGN_TEST
    gCompleteTestFollowerTalk.messages++;
    gCompleteTestFollowerTalk.lastMessage = bank == TEXT_BANK_HGSS_MSG_0265 ? message + 1 : 0x8000 + message;
#endif
}

// HeartGold's FollowMon_PlaceholdersSet: the Pokémon, its species, the player, the place and the held item
static void SetTalkNames(FieldSystem *fieldSystem)
{
    Pokemon *mon = Lead(fieldSystem);
    BoxPokemon *boxMon = Pokemon_GetBoxPokemon(mon);

    StringTemplate_SetNickname(sTalk->template, 0, boxMon);
    StringTemplate_SetSpeciesName(sTalk->template, 1, boxMon);
    StringTemplate_SetPlayerName(sTalk->template, 2, SaveData_GetTrainerInfo(fieldSystem->saveData));
    StringTemplate_SetLocationName(sTalk->template, 3, MapHeader_GetMapLabelTextID(fieldSystem->location->mapHeaderID));
    StringTemplate_SetItemName(sTalk->template, 4, Pokemon_GetValue(mon, MON_DATA_HELD_ITEM, NULL));
}

// An emote over the follower (HeartGold's ov01_02203AB4 and its effect, ov01_02203BB4 to ov01_02203DF8): the bubble
// pops up, plays its frames and stays two frames more. One at a time; the talk ends it.
typedef struct FollowerEmote {
    int state;
    int timer;
    int step;
    BOOL done;
    fx32 height;
    fx32 rise;
    MapObject *follower;
    int localID;
    int mapHeaderID;
    FieldEffectManager *fieldEffMan;
    Billboard *billboard;
} FollowerEmote;

typedef struct FollowerEmoteParams {
    MapObject *follower;
    FieldEffectManager *fieldEffMan;
    u16 emote;
} FollowerEmoteParams;

// The frame sequence all fourteen share (HeartGold's a/1/0/3 member 150): the bubble's two frames by turns. Platinum's
// billboards read its numbers as the frames each step starts on; HeartGold's ov01_02203DF8 counts them as how long
// each step lasts, as here: after the first frame, 4 frames of the second, 8 of the first, 12 of the second.
static const u8 sEmoteSteps[] = { 0, 4, 8, 12 };

static const BillboardAnim sEmoteAnims[] = {
    { 0, 15, BILLBOARD_ANIM_TYPE_LOOP },
    { 0, 0, BILLBOARD_ANIM_TYPE_TABLE_END },
};

static BOOL FollowerEmote_Init(OverworldAnimManager *manager, void *context)
{
    FollowerEmote *emote = context;
    const FollowerEmoteParams *params = OverworldAnimManager_GetUserData(manager);
    NARC *narc = NARC_ctor(NARC_INDEX_FIELDDATA__COMPLETE__FOLLOWER_TALK, HEAP_ID_FIELD3);
    VecFx32 pos;

    emote->follower = params->follower;
    emote->fieldEffMan = params->fieldEffMan;
    emote->localID = MapObject_GetLocalID(emote->follower);
    emote->mapHeaderID = MapObject_GetMapHeaderID(emote->follower);
    emote->rise = FX32_ONE * 6;

    FieldEffectManager_LoadModelFromNARC(emote->fieldEffMan, EMOTE_RESOURCES, narc, FOLLOWER_TALK_MEMBER_EMOTE_MODEL);
    FieldEffectManager_LoadMetadataFromNARC(emote->fieldEffMan, EMOTE_RESOURCES, narc, FOLLOWER_TALK_MEMBER_EMOTE_SEQUENCE);
    FieldEffectManager_LoadTextureFromNARC(emote->fieldEffMan, EMOTE_RESOURCES, narc, FOLLOWER_TALK_MEMBER_EMOTE_FRAMES + params->emote - 1);
    NARC_dtor(narc);

    ov5_021DF864(emote->fieldEffMan, EMOTE_RESOURCES, EMOTE_RESOURCES, EMOTE_RESOURCES, EMOTE_RESOURCES, 0, sEmoteAnims);
    OverworldAnimManager_GetPosition(manager, &pos);
    emote->billboard = ov5_021DF84C(emote->fieldEffMan, EMOTE_RESOURCES, &pos);
    NNS_G3dMdlSetMdlFogEnableFlagAll(Billboard_GetModel(emote->billboard), 0);
    Sound_PlayEffect(SEQ_SE_DP_DECIDE_sseq); // as HeartGold's
    return TRUE;
}

static void FollowerEmote_Exit(OverworldAnimManager *manager, void *context)
{
    FollowerEmote *emote = context;

    Billboard_Delete(emote->billboard);
    ov5_021DF9D4(emote->fieldEffMan, EMOTE_RESOURCES);
    ov5_021DFA08(emote->fieldEffMan, EMOTE_RESOURCES);
    ov5_021DFA30(emote->fieldEffMan, EMOTE_RESOURCES);
    ov5_021DFA7C(emote->fieldEffMan, EMOTE_RESOURCES);
}

static void FollowerEmote_Tick(OverworldAnimManager *manager, void *context)
{
    FollowerEmote *emote = context;

    switch (emote->state) {
    case 0: // up it pops
        emote->height += emote->rise;

        if (emote->height > 0) {
            emote->rise -= FX32_ONE * 2;
        } else {
            emote->height = 0;
            emote->state++;
        }
        break;
    case 1: // its frames
        if (++emote->timer >= sEmoteSteps[emote->step]) {
            emote->timer = 0;

            if (++emote->step >= (int)NELEMS(sEmoteSteps)) {
                emote->state++;
                break;
            }

            Billboard_SetFrameNum(emote->billboard, sEmoteSteps[emote->step] * FX32_ONE);
            Billboard_TryRequestVRAMTransfer(emote->billboard);
        }
        break;
    case 2:
        if (++emote->timer >= 2) {
            emote->state++;
            emote->done = TRUE;
        }
        break;
    }
}

static void FollowerEmote_Render(OverworldAnimManager *manager, void *context)
{
    FollowerEmote *emote = context;
    VecFx32 pos;

    if (emote->done || sub_02062764(emote->follower, emote->localID, emote->mapHeaderID) == 0) {
        Billboard_SetDrawFlag(emote->billboard, FALSE);
        return;
    }

    ov5_021ECDA0(emote->follower, &pos); // over the follower, as Platinum's own bubbles sit over people
    pos.y += FX32_ONE * 32 + emote->height;
    pos.z += FX32_ONE;
    Billboard_SetPos(emote->billboard, &pos);
}

static const OverworldAnimManagerFuncs sFollowerEmoteFuncs = {
    sizeof(FollowerEmote),
    FollowerEmote_Init,
    FollowerEmote_Exit,
    FollowerEmote_Tick,
    FollowerEmote_Render,
};

static void EndEmote(FollowerTalk *talk)
{
    if (talk->emote != NULL) {
        OverworldAnimManager_Finish(talk->emote);
        talk->emote = NULL;
    }
}

// HeartGold shows none while the follower is on a bridge (its sub_0205BB04)
static void StartEmote(FieldSystem *fieldSystem, FollowerTalk *talk, u16 emote)
{
    MapObject *follower = Follower(fieldSystem);

    if (emote == 0 || emote > FOLLOWER_TALK_EMOTES || follower == NULL) {
        return;
    }

    u8 behavior = TerrainCollisionManager_GetTileBehavior(fieldSystem, MapObject_GetX(follower), MapObject_GetZ(follower));

    if (behavior == TILE_BEHAVIOR_BRIDGE || behavior == TILE_BEHAVIOR_BRIDGE_OVER_CAVE || behavior == TILE_BEHAVIOR_UNUSED_x2E) {
        return;
    }

    FollowerEmoteParams params = { follower, fieldSystem->fieldEffMan, emote };
    VecFx32 pos;

    EndEmote(talk);
    MapObject_GetPosPtr(follower, &pos);
    talk->emote = FieldEffectManager_InitAnimManager(fieldSystem->fieldEffMan, &sFollowerEmoteFuncs, &pos, 0, &params,
        MapObject_GetTaskBasePriority(follower) + 1);

#ifdef SOVEREIGN_TEST
    gCompleteTestFollowerTalk.emotes++;
    gCompleteTestFollowerTalk.lastEmote = emote;
#endif
}

// A keyframe of a motion (HeartGold's ov02_0224FD9C and ov02_0224FDF8): a nudge, a cry, a facing
static void StartKeyframe(FollowerTalk *talk, MapObject *follower, const FollowerTalkKeyframe *keyframe)
{
    u16 sound = talk->interaction.steps[talk->step].sound;

    talk->offset.x += keyframe->x * FX32_ONE;
    talk->offset.z += keyframe->z * FX32_ONE;

    if (talk->species != SPECIES_DIGLETT && talk->species != SPECIES_DUGTRIO) { // as HeartGold: they stay in the ground
        talk->offset.y += keyframe->height * FX32_ONE;
    }

    MapObject_SetSpritePosOffset(follower, &talk->offset);

    if (keyframe->cry && sound > HGSS_SEQ_SE_END) {
        Sound_PlayPokemonCryEx(sound == HGSS_SEQ_SE_END + 1 ? POKECRY_NORMAL : POKECRY_PINCH_NORMAL, talk->species, 0, 127,
            HEAP_ID_FIELD3, talk->form);
    }

    if (keyframe->facing != 0) {
        MapObject_Face(follower, keyframe->facing - 1);
    }
}

// HeartGold's ov02_02250004: a frame of the step's motion; at the end the follower is back as it was
static BOOL RunMotion(ScriptContext *ctx)
{
    FollowerTalk *talk = sTalk;
    MapObject *follower = Follower(ctx->fieldSystem);

    if (follower == NULL) {
        return TRUE;
    }

    if (talk->keyframe >= TALK_KEYFRAMES || talk->keyframes[talk->keyframe].facing == TALK_LAST_KEYFRAME) {
        MapObject_SetSpritePosOffset(follower, &talk->startOffset);
        MapObject_Face(follower, talk->startFacing);
        return TRUE;
    }

    const FollowerTalkKeyframe *keyframe = &talk->keyframes[talk->keyframe];

    if (talk->frame == 0) {
        StartKeyframe(talk, follower, keyframe);
    }

    if (++talk->frame >= keyframe->frames) {
        talk->keyframe++;
        talk->frame = 0;
    }

    return FALSE;
}

static BOOL StartMotion(FieldSystem *fieldSystem, FollowerTalk *talk, u16 motion)
{
    MapObject *follower = Follower(fieldSystem);

    if (motion == 0 || motion > FOLLOWER_TALK_MOTIONS || follower == NULL) {
        return FALSE;
    }

    NARC_ReadWholeMemberByIndexPair(talk->keyframes, NARC_INDEX_FIELDDATA__COMPLETE__FOLLOWER_TALK,
        FOLLOWER_TALK_MEMBER_MOTIONS + motion - 1);
    MapObject_GetSpritePosOffset(follower, &talk->startOffset);
    talk->offset = talk->startOffset;
    talk->startFacing = MapObject_GetFacingDir(follower);
    talk->keyframe = 0;
    talk->frame = 0;

#ifdef SOVEREIGN_TEST
    gCompleteTestFollowerTalk.motions++;
#endif
    return TRUE;
}

// What the follower found (HeartGold's Task_FollowMonInteract, states 3 and 4): an accessory for the Fashion Case, or a
// Shiny Leaf it wears. Returns whether there's a message.
static BOOL ShowFinding(ScriptContext *ctx, FollowerTalk *talk)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    FollowerTalkInteraction *interaction = &talk->interaction;

    if (interaction->accessory != 0 && interaction->accessory <= HGSS_ACCESSORIES) {
        FashionCase *fashionCase = ImageClips_GetFashionCase(SaveData_GetImageClips(fieldSystem->saveData));
        u32 accessory = interaction->accessory - 1;
        BOOL fits = FashionCase_CanFitAccessoryCount(fashionCase, accessory, 1);

        StringTemplate_SetPlayerName(talk->template, 0, SaveData_GetTrainerInfo(fieldSystem->saveData));

#ifdef SOVEREIGN_TEST
        talk->accessory = accessory;
#endif

        if (fits) {
            FashionCase_AddAccessory(fashionCase, accessory, 1);
            StringTemplate_SetContestAccessoryName(talk->template, 1, accessory);
            Sound_PlayFanfare(SEQ_ACCE_sseq);
        } else {
            StringTemplate_SetContestAccessoryNameWithArticle(talk->template, 1, accessory);
        }

        ShowMessage(ctx, TEXT_BANK_HGSS_MSG_0040, fits ? HGSS_MSG_0040_ACCESSORY : HGSS_MSG_0040_CASE_FULL);
        return TRUE;
    }

    if (interaction->shinyLeaf != 0 && interaction->shinyLeaf <= SHINY_LEAVES) {
        Pokemon *mon = Lead(fieldSystem);
        u8 leaves = CompleteFollower_GetShinyLeaves(mon);
        u8 leaf = 1 << (interaction->shinyLeaf - 1);
        BOOL hasIt = (leaves & leaf) != 0;

        StringTemplate_SetPlayerName(talk->template, 0, SaveData_GetTrainerInfo(fieldSystem->saveData));
        StringTemplate_SetNickname(talk->template, 1, Pokemon_GetBoxPokemon(mon));

        if (!hasIt) {
            FieldSystem_SetFlag(fieldSystem, FLAG_HGSS_UNK_99C);
            CompleteFollower_SetShinyLeaves(mon, leaves | leaf);
            Sound_PlayFanfare(SEQ_ACCE_sseq);
        }

        ShowMessage(ctx, TEXT_BANK_HGSS_MSG_0040, hasIt ? HGSS_MSG_0040_HAS_LEAF : HGSS_MSG_0040_LEAF);
        return TRUE;
    }

    return FALSE;
}

// CompleteFollowerTalkStart: the follower turns to the player, and the interaction for the moment is chosen
BOOL CompleteScrCmd_FollowerTalkStart(ScriptContext *ctx)
{
    FieldSystem *fieldSystem = ctx->fieldSystem;
    MapObject *follower = Follower(fieldSystem);

    GF_ASSERT(sTalk == NULL);
    sTalk = Heap_AllocAtEnd(HEAP_ID_FIELD3, sizeof(FollowerTalk));
    memset(sTalk, 0, sizeof(FollowerTalk));
    sTalk->over = TRUE;

    if (follower == NULL) {
        return FALSE;
    }

    Pokemon *mon = Lead(fieldSystem);

    MapObject_Face(follower, Direction_GetOpposite(PlayerAvatar_GetFacingDir(fieldSystem->playerAvatar)));
    sTalk->species = Pokemon_GetValue(mon, MON_DATA_SPECIES, NULL);
    sTalk->form = Pokemon_GetValue(mon, MON_DATA_FORM, NULL);
    sTalk->template = StringTemplate_Default(HEAP_ID_FIELD3);

    u16 interaction = ChooseInteraction(fieldSystem);

#ifdef SOVEREIGN_TEST
    if (gCompleteTestFollowerTalk.force != 0) {
        interaction = gCompleteTestFollowerTalk.force;
        gCompleteTestFollowerTalk.force = 0;
    }

    gCompleteTestFollowerTalk.talks++;
    gCompleteTestFollowerTalk.interaction = interaction;
    gCompleteTestFollowerTalk.messages = 0;
    gCompleteTestFollowerTalk.lastMessage = 0;
    gCompleteTestFollowerTalk.motions = 0;
    gCompleteTestFollowerTalk.questions = 0;
    gCompleteTestFollowerTalk.emotes = 0;
    gCompleteTestFollowerTalk.lastEmote = 0;
    gCompleteTestFollowerTalk.offsetBack = FALSE;
    MapObject_GetSpritePosOffset(follower, &sTalk->talkOffset);
#endif

    LoadInteraction(sTalk, interaction);
    return FALSE;
}

// CompleteFollowerTalkStep destVar: the next step of the interaction: its motion, then its message
// (FOLLOWER_TALK_* in destVar)
BOOL CompleteScrCmd_FollowerTalkStep(ScriptContext *ctx)
{
    u16 *destVar = ScriptContext_GetVarPointer(ctx);
    FieldSystem *fieldSystem = ctx->fieldSystem;
    FollowerTalk *talk = sTalk;

    *destVar = FOLLOWER_TALK_END;

    if (talk == NULL || talk->over || Follower(fieldSystem) == NULL) {
        return FALSE;
    }

    if (talk->step >= talk->stepCount) {
        ApplyEffects(fieldSystem, talk);

        if (!talk->findingDone) {
            talk->findingDone = TRUE;

            if (ShowFinding(ctx, talk)) {
                *destVar = FOLLOWER_TALK_MESSAGE;
                return TRUE;
            }
        }

        talk->over = TRUE;
        return FALSE;
    }

    const FollowerTalkStep *step = &talk->interaction.steps[talk->step];

    if (talk->phase == PHASE_MOTION) {
        talk->phase = PHASE_MESSAGE;

        if (StartMotion(fieldSystem, talk, step->motion)) {
            *destVar = FOLLOWER_TALK_CONTINUE;
            ScriptContext_Pause(ctx, RunMotion);
            return TRUE;
        }
    }

    StartEmote(fieldSystem, talk, step->emote);
    talk->step++;
    talk->phase = PHASE_MOTION;

    if (step->message == 0) {
        *destVar = FOLLOWER_TALK_CONTINUE;
        return FALSE;
    }

    *destVar = FOLLOWER_TALK_MESSAGE;

    if (talk->step >= talk->stepCount && talk->interaction.question) {
        ApplyEffects(fieldSystem, talk);
        *destVar = FOLLOWER_TALK_QUESTION;

#ifdef SOVEREIGN_TEST
        gCompleteTestFollowerTalk.questions++;
#endif
    }

    SetTalkNames(fieldSystem);
    ShowMessage(ctx, TEXT_BANK_HGSS_MSG_0265, step->message - 1);
    return TRUE;
}

// CompleteFollowerTalkAnswer answer: the interaction the yes (MENU_YES) or no leads to
BOOL CompleteScrCmd_FollowerTalkAnswer(ScriptContext *ctx)
{
    u16 answer = ScriptContext_GetVar(ctx);

    if (sTalk != NULL && !sTalk->over) {
        LoadInteraction(sTalk, answer == MENU_YES ? sTalk->interaction.yes : sTalk->interaction.no);
    }

    return FALSE;
}

// Once its last emote is over, the talk's done with
static BOOL FreeTalkAfterEmote(ScriptContext *ctx)
{
    if (sTalk->emote != NULL && !((FollowerEmote *)OverworldAnimManager_GetFuncsContext(sTalk->emote))->done) {
        return FALSE;
    }

    EndEmote(sTalk);

    if (sTalk->template != NULL) {
        StringTemplate_Free(sTalk->template);
    }

    Heap_Free(sTalk);
    sTalk = NULL;
    return TRUE;
}

// CompleteFollowerTalkEnd: the talk is over (once its last emote is)
BOOL CompleteScrCmd_FollowerTalkEnd(ScriptContext *ctx)
{
#ifdef SOVEREIGN_TEST
    MapObject *follower = Follower(ctx->fieldSystem);

    if (sTalk != NULL && follower != NULL) {
        Pokemon *mon = Lead(ctx->fieldSystem);
        VecFx32 offset;

        MapObject_GetSpritePosOffset(follower, &offset);
        gCompleteTestFollowerTalk.offsetBack = offset.x == sTalk->talkOffset.x && offset.y == sTalk->talkOffset.y
            && offset.z == sTalk->talkOffset.z;
        gCompleteTestFollowerTalk.mood = CompleteFollower_GetMood(mon);
        gCompleteTestFollowerTalk.friendship = Pokemon_GetValue(mon, MON_DATA_FRIENDSHIP, NULL);
        gCompleteTestFollowerTalk.shinyLeaves = CompleteFollower_GetShinyLeaves(mon);
        gCompleteTestFollowerTalk.accessories = FashionCase_GetAccessoryCount(
            ImageClips_GetFashionCase(SaveData_GetImageClips(ctx->fieldSystem->saveData)), sTalk->accessory);
    }
#endif

    if (sTalk == NULL) {
        return FALSE;
    }

    if (!FreeTalkAfterEmote(ctx)) {
        ScriptContext_Pause(ctx, FreeTalkAfterEmote);
        return TRUE;
    }

    return FALSE;
}
