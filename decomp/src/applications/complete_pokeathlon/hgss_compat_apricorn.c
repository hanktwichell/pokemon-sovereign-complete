#include <nitro.h>

#include "constants/heap.h"
#include "constants/items.h"
#include "generated/game_records.h"

#include "applications/complete_pokeathlon/hgss_compat.h"
#include "applications/party_menu/defs.h"
#include "applications/party_menu/main.h"
#include "bag.h"
#include "complete_aprijuice.h"
#include "complete_follower.h"
#include "complete_pokeathlon.h"
#include "complete_pokeathlon_course.h"
#include "complete_test.h"
#include "game_overlay.h"
#include "heap.h"
#include "mail.h"
#include "narc.h"
#include "overlay_manager.h"
#include "particle_system.h"
#include "party.h"
#include "pokemon.h"
#include "pokemon_sprite.h"
#include "savedata.h"
#include "sprite_resource.h"
#include "sprite_system.h"
#include "sprite_transfer.h"
#include "sprite_util.h"

// Sovereign Complete: the shims HeartGold's Apricorn Box app calls (its overlays 58 and 59 and its Apricorn Box save
// code, decomp/asm/complete_hgss/, include/complete_aprijuice.h), named in hgss_compat.inc

FS_EXTERN_OVERLAY(complete_aprijuice);

#define HGSS_APRICORNS        7
#define HGSS_APRICORN_MAX     99 // the box held 99 of each; the bag holds more
#define HGSS_PERFORMANCE_STATS 5
#define HGSS_RESDAT_END        0xFFFFFFFE // a resdat header list's end (sprite_util.c's RESDAT_TABLE_TERMINATOR)
#define HGSS_RESDAT_NONE       0xFFFFFFFF // no multi-cell

// HeartGold's overlay 58 and its save code (decomp/asm/complete_hgss/overlay_58.s, unk_02031B0C.s)
BOOL ApricornBox_Init(ApplicationManager *appMan, int *state);
BOOL ApricornBox_Main(ApplicationManager *appMan, int *state);
BOOL ApricornBox_Exit(ApplicationManager *appMan, int *state);
void sub_02032058(void *apricornBox, u32 steps); // the Apriblender's juice, brought up to the steps walked

// hgss_compat_save.c and hgss_compat.c
CompletePokeathlonSave *HgssCompat_PokeathlonSave_IfOpen(void);
void HgssCompat_CalcBoxMonPokeathlonPerformance(BoxPokemon *boxMon, void *dest);

// HeartGold's sMoodModifiers (pokemon_mood.c): what an event does to a Pokémon's mood (7: drinking Aprijuice)
static const s8 sMoodModifiers[] = { 40, 8, 50, 40, -80, -50, -100, 30 };

// The box's seven kinds, in HeartGold's order, as the bag's items
static const u16 sApricorns[HGSS_APRICORNS] = {
    ITEM_RED_APRICORN,
    ITEM_YLW_APRICORN,
    ITEM_BLU_APRICORN,
    ITEM_GRN_APRICORN,
    ITEM_PNK_APRICORN,
    ITEM_WHT_APRICORN,
    ITEM_BLK_APRICORN,
};

static u32 sMenuInputState; // HeartGold's MenuInputStateMgr, where the caller gave none

// HeartGold's ApplyMonMoodModifier: the mood its walking Pokémon shows (Complete's follower's)
void HgssCompat_ApplyMonMoodModifier(Pokemon *mon, int modifierId)
{
    if (modifierId < 0 || modifierId >= (int)NELEMS(sMoodModifiers)) {
        return;
    }

    int mood = CompleteFollower_GetMood(mon) + sMoodModifiers[modifierId];

    CompleteFollower_SetMood(mon, mood > 127 ? 127 : (mood < -127 ? -127 : mood));
}

// HeartGold's ApricornBox_CountApricorn, _TakeApricorn and _GiveApricorn: the box's counts are the bag's (each returns
// the count after, as HeartGold's do)
int HgssCompat_ApricornBox_CountApricorn(void *apricornBox, u32 kind)
{
    (void)apricornBox;

    if (kind >= HGSS_APRICORNS) {
        return 0;
    }

    u32 count = Bag_GetItemQuantity(SaveData_GetBag(SaveData_Ptr()), sApricorns[kind], HEAP_ID_APPLICATION);
    return count > HGSS_APRICORN_MAX ? HGSS_APRICORN_MAX : count;
}

int HgssCompat_ApricornBox_TakeApricorn(void *apricornBox, u32 kind, u8 count)
{
    if (kind < HGSS_APRICORNS && HgssCompat_ApricornBox_CountApricorn(apricornBox, kind) >= count) {
        Bag_TryRemoveItem(SaveData_GetBag(SaveData_Ptr()), sApricorns[kind], count, HEAP_ID_APPLICATION);
    }

    return HgssCompat_ApricornBox_CountApricorn(apricornBox, kind);
}

int HgssCompat_ApricornBox_GiveApricorn(void *apricornBox, u32 kind, u8 count)
{
    if (kind < HGSS_APRICORNS) {
        Bag_TryAddItem(SaveData_GetBag(SaveData_Ptr()), sApricorns[kind], count, HEAP_ID_APPLICATION);
    }

    return HgssCompat_ApricornBox_CountApricorn(apricornBox, kind);
}

// HeartGold keeps each party Pokémon's Aprijuice in its Party (PartyExtraSub, a byte a Pokéathlon stat); Complete in the
// Pokéathlon's save, by the Pokémon's personality (include/complete_pokeathlon.h). Read while the save is open (the
// course and the Apricorn Box open it); none otherwise.
static CompletePokeathlonJuice *FindJuice(CompletePokeathlonSave *pokeathlon, Party *party, u32 personality, BOOL make)
{
    CompletePokeathlonJuice *free = NULL;

    for (int i = 0; i < (int)NELEMS(pokeathlon->partyJuice); i++) {
        CompletePokeathlonJuice *juice = &pokeathlon->partyJuice[i];

        if (juice->personality == personality && personality != 0) {
            return juice;
        }

        if (free == NULL && make) {
            BOOL inParty = FALSE;

            for (int slot = 0; slot < Party_GetCurrentCount(party) && juice->personality != 0; slot++) {
                inParty |= Pokemon_GetValue(Party_GetPokemonBySlotIndex(party, slot), MON_DATA_PERSONALITY, NULL) == juice->personality;
            }

            if (!inParty) {
                free = juice; // never used, or its Pokémon has left the party (HeartGold clears it then)
            }
        }
    }

    if (free != NULL) {
        MI_CpuClear8(free, sizeof(*free));
        free->personality = personality;
    }

    return free;
}

void HgssCompat_Party_GetMonAprijuiceModifiers(Party *party, s8 *dest, int slot)
{
    CompletePokeathlonSave *pokeathlon = HgssCompat_PokeathlonSave_IfOpen();

    MI_CpuClear8(dest, HGSS_PERFORMANCE_STATS);

    if (pokeathlon == NULL || slot >= Party_GetCurrentCount(party)) {
        return;
    }

    u32 personality = Pokemon_GetValue(Party_GetPokemonBySlotIndex(party, slot), MON_DATA_PERSONALITY, NULL);
    CompletePokeathlonJuice *juice = FindJuice(pokeathlon, party, personality, FALSE);

    if (juice != NULL) {
        MI_CpuCopy8(juice->stats, dest, HGSS_PERFORMANCE_STATS);
    }
}

void HgssCompat_Party_SetMonAprijuiceModifiers(Party *party, const s8 *src, int slot)
{
    CompletePokeathlonSave *pokeathlon = HgssCompat_PokeathlonSave_IfOpen();

    if (pokeathlon == NULL || slot >= Party_GetCurrentCount(party)) {
        GF_ASSERT(FALSE);
        return;
    }

    u32 personality = Pokemon_GetValue(Party_GetPokemonBySlotIndex(party, slot), MON_DATA_PERSONALITY, NULL);
    CompletePokeathlonJuice *juice = FindJuice(pokeathlon, party, personality, TRUE);

    if (juice != NULL) {
        MI_CpuCopy8(src, juice->stats, HGSS_PERFORMANCE_STATS);
    }
}

// HeartGold's CalcMonPokeathlonPerformance
void HgssCompat_CalcMonPokeathlonPerformance(Pokemon *mon, void *dest)
{
    HgssCompat_CalcBoxMonPokeathlonPerformance(Pokemon_GetBoxPokemon(mon), dest);
}

// HeartGold's GetPokemonSpriteCharAndPlttNarcIds: its PokepicTemplate has Platinum's PokemonSpriteTemplate's layout
// (its species where Platinum's Spinda flag is), and the sprite is made by Platinum's manager
void HgssCompat_GetPokemonSpriteCharAndPlttNarcIds(PokemonSpriteTemplate *template, Pokemon *mon, u8 face)
{
    Pokemon_BuildSpriteTemplate(template, mon, face);
}

// HeartGold's MenuInputStateMgr (a word in its FieldSystem): whether its menus were last used by keys or touch
u32 HgssCompat_MenuInputStateMgr_GetState(u32 *stateMgr)
{
    return stateMgr != NULL ? *stateMgr : sMenuInputState;
}

void HgssCompat_MenuInputStateMgr_SetState(u32 *stateMgr, u32 state)
{
    if (stateMgr != NULL) {
        *stateMgr = state;
    } else {
        sMenuInputState = state;
    }
}

// HeartGold's YesNoPrompt_IsInTouchMode: Platinum's Yes/No (YesNoTouchMenu, hgss_compat.c) is a touch menu
u32 HgssCompat_YesNoPrompt_IsInTouchMode(void *menu)
{
    (void)menu;
    return TRUE;
}

// HeartGold's sub_02015264: a particle resource from one of its archives
void *HgssCompat_LoadParticleResource(int narcID, int member, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return ParticleSystem_LoadResourceFromNARC(narc, member, heapID);
}

// HeartGold's sub_0200D2A4: a sprite manager's resources from its data/resdat archive's lists (a member each for the
// tiles, palettes, cells and animations, and one for the sprites' headers), as Platinum's
// SpriteSystem_LoadResourceDataFromFilepaths does from its files. Complete has the lists the Apricorn Box uses here, each
// HeartGold's (pret's files/data/resdat/resdat_*.json) with its archive's member found in Complete's.
typedef struct HgssResdatList {
    u16 id; // the data/resdat member
    u16 narcID; // HeartGold's archive
    u16 member;
    u8 compressed;
    u8 vramType;
    u8 paletteIndex;
} HgssResdatList;

static const HgssResdatList sResdatLists[] = {
    { 16, 220, 10, FALSE, 0, 0 }, // anim (the Apricorn Box's sprites)
    { 17, 220, 9, FALSE, 0, 0 }, // cell
    { 18, 220, 8, FALSE, NNS_G2D_VRAM_TYPE_2DMAIN, 0 }, // char
    { 19, 220, 7, FALSE, NNS_G2D_VRAM_TYPE_2DMAIN, 13 }, // pltt: 13 palettes
    { 12, 244, 3, TRUE, 0, 0 }, // anim (the Apriblender's sprites)
    { 13, 244, 2, TRUE, 0, 0 }, // cell
    { 14, 244, 1, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 0 }, // char
    { 15, 244, 0, FALSE, NNS_G2D_VRAM_TYPE_2DMAIN, 4 }, // pltt: four palettes
};

static const struct {
    u16 id;
    ResdatTableEntry entries[2];
} sResdatHeaders[] = {
    { 75, { { 0, 0, 0, 0, HGSS_RESDAT_NONE, HGSS_RESDAT_NONE, 0, 2 }, { HGSS_RESDAT_END } } },
    { 76, { { 0, 0, 0, 0, HGSS_RESDAT_NONE, HGSS_RESDAT_NONE, 0, 3 }, { HGSS_RESDAT_END } } },
};

BOOL HgssCompat_LoadResdatSprites(SpriteSystem *spriteSys, SpriteManager *spriteMan, const u16 *lists, int charMode, int plttMode)
{
    if (spriteSys == NULL || spriteMan == NULL) {
        return FALSE;
    }

    GF_ASSERT(lists[SPRITE_RESOURCE_MULTI_CELL] == 0xFFFF); // no multi-cells in the lists Complete has
    int numResourceTypes = SPRITE_RESOURCE_MAX - 2;

    spriteMan->numResourceTypes = numResourceTypes;
    spriteMan->resourcePaths = Heap_Alloc(spriteSys->heapID, SpriteResourceTable_Size() * numResourceTypes);

    for (int i = 0; i < numResourceTypes; i++) {
        const HgssResdatList *list = NULL;

        for (int j = 0; j < (int)NELEMS(sResdatLists); j++) {
            if (sResdatLists[j].id == lists[i]) {
                list = &sResdatLists[j];
            }
        }

        GF_ASSERT(list != NULL);

        if (list == NULL) { // a list Complete doesn't have: nothing loaded rather than a wild read
            return FALSE;
        }

        SpriteResourceTable *table = SpriteResourceTable_GetArrayElement(spriteMan->resourcePaths, i);
        SpriteResourceTableEntryNARC *entry = Heap_Alloc(spriteSys->heapID, sizeof(SpriteResourceTableEntryNARC));
        int member = list->member;

        entry->narcID = HgssCompat_NarcMember(list->narcID, &member);
        entry->memberIndex = member;
        entry->compressed = list->compressed;
        entry->id = 0;
        entry->vramType = list->vramType;
        entry->paletteIndex = list->paletteIndex;
        table->entries = entry;
        table->count = 1;
        table->type = i;
        table->loadFromNARC = TRUE;
    }

    for (int i = 0; i < numResourceTypes; i++) {
        SpriteResourceTable *table = SpriteResourceTable_GetArrayElement(spriteMan->resourcePaths, i);
        int count = SpriteResourceTable_GetCount(table);

        spriteMan->ownedResources[i] = SpriteResourceCollection_New(count, i, spriteSys->heapID);
    }

    for (int i = 0; i < numResourceTypes; i++) {
        SpriteResourceTable *table = SpriteResourceTable_GetArrayElement(spriteMan->resourcePaths, i);
        int count = SpriteResourceTable_GetCount(table);

        spriteMan->unownedResources[i] = SpriteResourceList_New(count, spriteSys->heapID);
        spriteMan->loadedResourceCount[i] = SpriteResourceCollection_Extend(spriteMan->ownedResources[i], table, spriteMan->unownedResources[i], spriteSys->heapID);
    }

    // HeartGold's modes, each Platinum's twin: the tiles at VRAM's end (0, the box's: its sprite system keeps all of
    // its 64 KB for such transfers, nothing at the start), the same with the hardware's mapping (1), or at the start
    // (2); the palettes in free slots (0) or over the whole range (1)
    const SpriteResourceList *chars = spriteMan->unownedResources[SPRITE_RESOURCE_CHAR];

    if (charMode == 0) {
        SpriteTransfer_RequestCharListAtEnd(chars);
    } else if (charMode == 1) {
        for (int i = 0; i < chars->capacity; i++) {
            if (chars->resources[i] != NULL) {
                SpriteTransfer_RequestCharAtEndWithHardwareMappingType(chars->resources[i]);
            }
        }
    } else {
        SpriteTransfer_RequestCharList(chars);
    }

    if (plttMode == 0) {
        SpriteTransfer_RequestPlttFreeSpaceList(spriteMan->unownedResources[SPRITE_RESOURCE_PLTT]);
    } else {
        SpriteTransfer_RequestPlttWholeRangeList(spriteMan->unownedResources[SPRITE_RESOURCE_PLTT]);
    }

    const ResdatTableEntry *headers = NULL;

    for (int j = 0; j < (int)NELEMS(sResdatHeaders); j++) {
        if (sResdatHeaders[j].id == lists[SPRITE_RESOURCE_MAX]) {
            headers = sResdatHeaders[j].entries;
        }
    }

    GF_ASSERT(headers != NULL);
    spriteMan->resourceHeaders = SpriteResourcesHeaderList_NewFromResdat(headers,
        spriteSys->heapID,
        spriteMan->ownedResources[SPRITE_RESOURCE_CHAR],
        spriteMan->ownedResources[SPRITE_RESOURCE_PLTT],
        spriteMan->ownedResources[SPRITE_RESOURCE_CELL],
        spriteMan->ownedResources[SPRITE_RESOURCE_ANIM],
        NULL,
        NULL);

    return TRUE;
}

// HeartGold's gOverlayTemplate_PartyMenu, run by its overlay 58 with HeartGold's PartyMenuArgs: Platinum's party menu
// (gPokemonPartyAppTemplate, the main module's) with Platinum's arguments, the chosen slot and action copied back. The
// two structs differ by one word (HeartGold's menuInputStatePtr before the mode); the mode's number is the same (20,
// feeding: a Poffin in Platinum, Aprijuice in HeartGold).
typedef struct HgssPartyMenuArgs {
    Party *party;
    Bag *bag;
    Mailbox *mailbox;
    Options *options;
    void *unk_10;
    void *linkBattleRuleset;
    void *fieldMoveCheckData;
    FieldSystem *fieldSystem;
    void *menuInputStatePtr;
    u8 context;
    u8 unk_25;
    u8 partySlot;
    u8 selectedAction;
} HgssPartyMenuArgs;

typedef struct HgssPartyMenuApp {
    PartyMenu partyMenu;
    ApplicationManager *appMan;
} HgssPartyMenuApp;

static BOOL HgssPartyMenu_Init(ApplicationManager *appMan, int *state)
{
    HgssPartyMenuArgs *args = ApplicationManager_Args(appMan);
    HgssPartyMenuApp *app = ApplicationManager_NewData(appMan, sizeof(HgssPartyMenuApp), HEAP_ID_APPLICATION);

    MI_CpuClear8(app, sizeof(HgssPartyMenuApp));
    app->partyMenu.party = args->party;
    app->partyMenu.bag = args->bag;
    app->partyMenu.mailbox = args->mailbox;
    app->partyMenu.options = args->options;
    app->partyMenu.fieldSystem = args->fieldSystem;
    app->partyMenu.mode = args->context;
    app->partyMenu.type = args->unk_25;
    app->partyMenu.selectedMonSlot = args->partySlot;
    app->appMan = ApplicationManager_New(&gPokemonPartyAppTemplate, &app->partyMenu, HEAP_ID_APPLICATION);

    return TRUE;
}

static BOOL HgssPartyMenu_Main(ApplicationManager *appMan, int *state)
{
    HgssPartyMenuApp *app = ApplicationManager_Data(appMan);
    return ApplicationManager_Exec(app->appMan);
}

static BOOL HgssPartyMenu_Exit(ApplicationManager *appMan, int *state)
{
    HgssPartyMenuArgs *args = ApplicationManager_Args(appMan);
    HgssPartyMenuApp *app = ApplicationManager_Data(appMan);

    ApplicationManager_Free(app->appMan);
    args->partySlot = app->partyMenu.selectedMonSlot;
    args->selectedAction = app->partyMenu.menuSelectionResult;
    ApplicationManager_FreeData(appMan);

    return TRUE;
}

const ApplicationManagerTemplate gHgssCompat_PartyMenuTemplate = {
    HgssPartyMenu_Init,
    HgssPartyMenu_Main,
    HgssPartyMenu_Exit,
    FS_OVERLAY_ID_NONE,
};

#ifdef SOVEREIGN_TEST
#define NOTE_STAGE(n) (gCompleteTestAprijuice.stage = (n))
#else
#define NOTE_STAGE(n)
#endif

// The Apricorn Box app (include/complete_aprijuice.h): HeartGold's overlay 58 runs inside it, with its overlay loaded
// here (its own template has none) and the Pokéathlon's save open around it
typedef struct HgssApricornBoxApp {
    ApplicationManager *appMan;
} HgssApricornBoxApp;

BOOL HgssCompat_ApricornBoxApp_Init(ApplicationManager *appMan, int *state)
{
    static const ApplicationManagerTemplate sTemplate = {
        ApricornBox_Init,
        ApricornBox_Main,
        ApricornBox_Exit,
        FS_OVERLAY_ID_NONE,
    };
    HgssApricornBoxArgs *args = ApplicationManager_Args(appMan);
    HgssApricornBoxApp *app = ApplicationManager_NewData(appMan, sizeof(HgssApricornBoxApp), HEAP_ID_APPLICATION);

    NOTE_STAGE(1);
    Overlay_LoadByID(FS_OVERLAY_ID(complete_aprijuice), OVERLAY_LOAD_ASYNC);
    NOTE_STAGE(2);
    HgssCompat_PokeathlonSave_Open(args->saveData, HEAP_ID_APPLICATION);
    NOTE_STAGE(3);
    sub_02032058(HgssCompat_PokeathlonSave_IfOpen()->apricornBox, args->steps);
    NOTE_STAGE(4);

    if (args->menuInputState == NULL) {
        args->menuInputState = &sMenuInputState;
    }

    app->appMan = ApplicationManager_New(&sTemplate, args, HEAP_ID_APPLICATION);
    NOTE_STAGE(5);
    return TRUE;
}

BOOL HgssCompat_ApricornBoxApp_Main(ApplicationManager *appMan, int *state)
{
    HgssApricornBoxApp *app = ApplicationManager_Data(appMan);
    BOOL done = ApplicationManager_Exec(app->appMan);

#ifdef SOVEREIGN_TEST
    gCompleteTestAprijuice.stage = 6;
    gCompleteTestAprijuice.innerState = (u8)(app->appMan->procState << 4 | (app->appMan->execState & 0xF));
    {
        u8 *data58 = app->appMan->data; // HeartGold's overlay 58's: its sub-app (overlay 59 or the party menu) at 8
        ApplicationManager *sub = data58 != NULL ? *(ApplicationManager **)(data58 + 8) : NULL;

        gCompleteTestAprijuice.subState = sub != NULL ? (u32)(sub->procState << 8 | (sub->execState & 0xFF)) : 0xFFFFFFFF;
    }
#endif
    return done;
}

BOOL HgssCompat_ApricornBoxApp_Exit(ApplicationManager *appMan, int *state)
{
    HgssApricornBoxArgs *args = ApplicationManager_Args(appMan);
    HgssApricornBoxApp *app = ApplicationManager_Data(appMan);

    ApplicationManager_Free(app->appMan);
    HgssCompat_PokeathlonSave_Close(args->saveData, TRUE);
    Overlay_UnloadByID(FS_OVERLAY_ID(complete_aprijuice));
    ApplicationManager_FreeData(appMan);
    NOTE_STAGE(7);

    return TRUE;
}
