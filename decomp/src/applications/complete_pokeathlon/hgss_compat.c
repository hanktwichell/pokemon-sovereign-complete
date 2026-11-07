#include <nitro.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/species.h"
#include "generated/text_banks.h"

#include "data/complete_pokeathlon_archives.h"
#include "data/complete_pokeathlon_performance.h"

#include "applications/complete_pokeathlon/hgss_compat.h"

#include "bg_window.h"
#include "character_sprite.h"
#include "complete_pokeathlon.h"
#include "complete_pokeathlon_select.h"
#include "font.h"
#include "graphics.h"
#include "heap.h"
#include "message.h"
#include "narc.h"
#include "network_icon.h"
#include "party.h"
#include "pokemon.h"
#include "rtc.h"
#include "sprite.h"
#include "sprite_resource.h"
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "text.h"
#include "yes_no_touch_menu.h"

// Sovereign Complete: the shims HeartGold's assembly in decomp/asm/complete_hgss/ calls (the Pokéathlon's port,
// docs/Roadmap.md). decomp/asm/complete_hgss/hgss_compat.inc names each engine function those files call: Platinum's
// own where it's the same function, else one of these, HgssCompat_ and HeartGold's name (or what it does, for an
// unnamed one). They translate HeartGold's numbers (NARCs, text banks, fonts), stand in where Platinum's function
// differs, and port what only HeartGold has. They live in the overlay with the assembly (main memory is full).

// NARCs and text banks: HeartGold's numbers to Complete's. A HeartGold archive Platinum has too is Platinum's (its
// members the same); HeartGold's own are packed into Complete's Pokéathlon archive, each from its first member there
// on (include/data/complete_pokeathlon_archives.h, tools/complete/import_hgss_pokeathlon_archives.py). A Pokémon
// picture's archive comes from Platinum's own sprite template, already Platinum's, marked HGSS_PLATINUM_NARC
// (HgssCompat_GetMonSpriteCharAndPlttNarcIdsEx). Any other number asserts: the assembly that asks for it can't run
// before it's imported.
static const u16 sNarcs[][2] = {
    { 20, NARC_INDEX_POKETOOL__ICONGRA__PL_POKE_ICON }, // poketool/icongra/poke_icon
    { 27, NARC_INDEX_MSGDATA__PL_MSG }, // msgdata/msg
    { 35, NARC_INDEX_GRAPHIC__FONTOAM }, // a/0/3/5: the TextOBJ's cells (HeartGold's unk_02013534, Platinum's FontOAM)
};

static const u16 sTextBanks[][2] = {
    { 278, TEXT_BANK_HGSS_MSG_0278 }, // the course's choice of Pokémon
    { 298, TEXT_BANK_HGSS_MSG_0298 }, // the party and box picker
    { 313, TEXT_BANK_HGSS_MSG_0313 },
    { 314, TEXT_BANK_HGSS_MSG_0314 },
    { 309, TEXT_BANK_HGSS_MSG_0309 }, // the course
    { 310, TEXT_BANK_HGSS_MSG_0310 },
    { 311, TEXT_BANK_HGSS_MSG_0311 },
    { 237, TEXT_BANK_SPECIES_NAME }, // the species' names (Complete's, all of them; overlay 98)
    { 21, TEXT_BANK_HGSS_MSG_0021 }, // the Apricorn Box and the Aprijuice (overlay 59)
    { 22, TEXT_BANK_HGSS_MSG_0022 },
};


// A HeartGold archive and member as Complete's: the archive returned, the member moved where it's packed
enum NarcID HgssCompat_NarcMember(int narcID, int *member)
{
    if (narcID & HGSS_PLATINUM_NARC) {
        return (enum NarcID)(narcID & ~HGSS_PLATINUM_NARC);
    }

    for (int i = 0; i < (int)NELEMS(sNarcs); i++) {
        if (sNarcs[i][0] == narcID) {
            return (enum NarcID)sNarcs[i][1];
        }
    }

    for (int i = 0; i < COMPLETE_POKEATHLON_ARCHIVES; i++) {
        if (sCompletePokeathlonArchives[i][0] == narcID) {
            int base = sCompletePokeathlonArchives[i][3];

            // the walking Pokémon's models are packed from HeartGold's first (MMODEL_FOLLOWER_MON_BULBASAUR); the
            // course asks for model 1 for a species without one (past 493): Ditto's stands in
            if (narcID == HGSS_NARC_MMODEL && *member < base) {
                *member = base + HGSS_FOLLOWER_MON_DITTO;
            }

            GF_ASSERT(*member >= base && *member - base < sCompletePokeathlonArchives[i][2]);
            *member += sCompletePokeathlonArchives[i][1] - base;
            return NARC_INDEX_APPLICATION__COMPLETE__POKEATHLON;
        }
    }

    GF_ASSERT(FALSE);
    return (enum NarcID)sNarcs[0][1];
}

u32 HgssCompat_TextBank(int bank)
{
    for (int i = 0; i < (int)NELEMS(sTextBanks); i++) {
        if (sTextBanks[i][0] == bank) {
            return sTextBanks[i][1];
        }
    }

    GF_ASSERT(FALSE);
    return sTextBanks[0][1];
}

// HeartGold's fonts: 0 to 3 are Platinum's; its two more (4, 5: the small touch-screen ones) become Platinum's
// small font, as in Voltorb Flip
enum Font HgssCompat_Font(int font)
{
    return font <= FONT_UNOWN ? (enum Font)font : FONT_SUBSCREEN;
}

// HeartGold counts each font's users (FontID_Alloc, FontID_Release); Platinum loads one once and frees it at once,
// and keeps its system, message and Unown fonts loaded from the boot. So only the small font is loaded here, on its
// first user, and freed after its last (HeartGold's 2 and 4 are both it: overlay 97 and its picker each ask for one).
static u8 sSubscreenFontUsers;

SpriteResource *HgssCompat_AddCharResObjFromNarc(SpriteResourceCollection *collection, int narcID, int memberIdx, BOOL compressed, int id, NNS_G2D_VRAM_TYPE vramType, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    return SpriteResourceCollection_AddTiles(collection, narc, memberIdx, compressed, id, vramType, heapID);
}

SpriteResource *HgssCompat_AddPlttResObjFromNarc(SpriteResourceCollection *collection, int narcID, int memberIdx, BOOL compressed, int id, NNS_G2D_VRAM_TYPE vramType, int paletteIdx, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    return SpriteResourceCollection_AddPalette(collection, narc, memberIdx, compressed, id, vramType, paletteIdx, heapID);
}

SpriteResource *HgssCompat_AddCellOrAnimResObjFromNarc(SpriteResourceCollection *collection, int narcID, int memberIdx, BOOL compressed, int id, enum SpriteResourceType type, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    return SpriteResourceCollection_Add(collection, narc, memberIdx, compressed, id, type, heapID);
}

void *HgssCompat_AllocAndReadWholeNarcMemberByIdPair(int narcID, int memberIdx, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    return NARC_AllocAndReadWholeMemberByIndexPair(narc, memberIdx, heapID);
}

// An archive opened whole and read by member later (NARC_ReadWholeMember and the *FromOpenNarc loaders, HeartGold's
// member numbers). One of HeartGold's packed into Complete's Pokéathlon archive starts at its first member there, so
// each one open notes that first member, and the readers below add it to the member asked for.
#define HGSS_OPEN_NARCS 8

static struct {
    NARC *narc;
    u16 first;
} sOpenNarcs[HGSS_OPEN_NARCS];

static u32 HgssCompat_OpenNarcMember(NARC *narc, u32 member)
{
    for (int i = 0; i < HGSS_OPEN_NARCS; i++) {
        if (sOpenNarcs[i].narc == narc) {
            return member + sOpenNarcs[i].first;
        }
    }

    return member;
}

NARC *HgssCompat_NARC_New(int narcID, enum HeapID heapID)
{
    int first = 0;
    enum NarcID narcIndex = HgssCompat_NarcMember(narcID, &first);
    NARC *narc = NARC_ctor(narcIndex, heapID);

    if (first != 0) {
        int i;

        for (i = 0; i < HGSS_OPEN_NARCS && sOpenNarcs[i].narc != NULL; i++) { }

        GF_ASSERT(i < HGSS_OPEN_NARCS);

        if (i < HGSS_OPEN_NARCS) {
            sOpenNarcs[i].narc = narc;
            sOpenNarcs[i].first = first;
        }
    }

    return narc;
}

void HgssCompat_NARC_Delete(NARC *narc)
{
    for (int i = 0; i < HGSS_OPEN_NARCS; i++) {
        if (sOpenNarcs[i].narc == narc) {
            sOpenNarcs[i].narc = NULL;
        }
    }

    NARC_dtor(narc);
}

void HgssCompat_NARC_ReadWholeMember(NARC *narc, u32 member, void *dest)
{
    NARC_ReadWholeMember(narc, HgssCompat_OpenNarcMember(narc, member), dest);
}

void *HgssCompat_NARC_AllocAndReadWholeMember(NARC *narc, u32 member, enum HeapID heapID)
{
    return NARC_AllocAndReadWholeMember(narc, HgssCompat_OpenNarcMember(narc, member), heapID);
}

void HgssCompat_GfGfxLoader_GXLoadPalFromOpenNarc(NARC *narc, u32 member, enum PaletteLoadLocation location, u32 offset, u32 size, enum HeapID heapID)
{
    Graphics_LoadPaletteFromOpenNARC(narc, HgssCompat_OpenNarcMember(narc, member), location, offset, size, heapID);
}

void *HgssCompat_GfGfxLoader_GetCharDataFromOpenNarc(NARC *narc, u32 member, BOOL compressed, NNSG2dCharacterData **charData, enum HeapID heapID)
{
    return Graphics_GetCharDataFromOpenNARC(narc, HgssCompat_OpenNarcMember(narc, member), compressed, charData, heapID);
}

u32 HgssCompat_GfGfxLoader_LoadCharDataFromOpenNarc(NARC *narc, u32 member, BgConfig *bgConfig, u32 bgLayer, u32 offset, u32 size, BOOL compressed, enum HeapID heapID)
{
    return Graphics_LoadTilesToBgLayerFromOpenNARC(narc, HgssCompat_OpenNarcMember(narc, member), bgConfig, bgLayer, offset, size, compressed, heapID);
}

void HgssCompat_GfGfxLoader_LoadScrnDataFromOpenNarc(NARC *narc, u32 member, BgConfig *bgConfig, u32 bgLayer, u32 offset, u32 size, BOOL compressed, enum HeapID heapID)
{
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, HgssCompat_OpenNarcMember(narc, member), bgConfig, bgLayer, offset, size, compressed, heapID);
}

BOOL HgssCompat_SpriteSystem_LoadCharResObjFromOpenNarc(SpriteSystem *spriteSys, SpriteManager *spriteMan, NARC *narc, int member, BOOL compressed, enum NNS_G2D_VRAM_TYPE vramType, int resourceID)
{
    return SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, HgssCompat_OpenNarcMember(narc, member), compressed, vramType, resourceID);
}

s8 HgssCompat_SpriteSystem_LoadPlttResObjFromOpenNarc(SpriteSystem *spriteSys, SpriteManager *spriteMan, NARC *narc, int member, BOOL compressed, int paletteIdx, enum NNS_G2D_VRAM_TYPE vramType, int resourceID)
{
    return SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, HgssCompat_OpenNarcMember(narc, member), compressed, paletteIdx, vramType, resourceID);
}

BOOL HgssCompat_SpriteSystem_LoadCellResObjFromOpenNarc(SpriteSystem *spriteSys, SpriteManager *spriteMan, NARC *narc, int member, BOOL compressed, int resourceID)
{
    return SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, HgssCompat_OpenNarcMember(narc, member), compressed, resourceID);
}

BOOL HgssCompat_SpriteSystem_LoadAnimResObjFromOpenNarc(SpriteSystem *spriteSys, SpriteManager *spriteMan, NARC *narc, int member, BOOL compressed, int resourceID)
{
    return SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, HgssCompat_OpenNarcMember(narc, member), compressed, resourceID);
}

// The same, by HeartGold's archive and member number
BOOL HgssCompat_SpriteSystem_LoadCharResObj(SpriteSystem *spriteSys, SpriteManager *spriteMan, int narcID, int member, BOOL compressed, enum NNS_G2D_VRAM_TYPE vramType, int resourceID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return SpriteSystem_LoadCharResObj(spriteSys, spriteMan, narc, member, compressed, vramType, resourceID);
}

s8 HgssCompat_SpriteSystem_LoadPlttResObj(SpriteSystem *spriteSys, SpriteManager *spriteMan, int narcID, int member, BOOL compressed, int paletteIdx, enum NNS_G2D_VRAM_TYPE vramType, int resourceID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return SpriteSystem_LoadPlttResObj(spriteSys, spriteMan, narc, member, compressed, paletteIdx, vramType, resourceID);
}

BOOL HgssCompat_SpriteSystem_LoadCellResObj(SpriteSystem *spriteSys, SpriteManager *spriteMan, int narcID, int member, BOOL compressed, int resourceID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return SpriteSystem_LoadCellResObj(spriteSys, spriteMan, narc, member, compressed, resourceID);
}

BOOL HgssCompat_SpriteSystem_LoadAnimResObj(SpriteSystem *spriteSys, SpriteManager *spriteMan, int narcID, int member, BOOL compressed, int resourceID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return SpriteSystem_LoadAnimResObj(spriteSys, spriteMan, narc, member, compressed, resourceID);
}

void HgssCompat_ReadWholeNarcMemberByIdPair(void *dest, int narcID, int member)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    NARC_ReadWholeMemberByIndexPair(dest, narc, member);
}

void *HgssCompat_GfGfxLoader_LoadFromNarc(int narcID, int member, BOOL compressed, enum HeapID heapID, BOOL atEnd)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return LoadMemberFromNARC(narc, member, compressed, heapID, atEnd);
}

void *HgssCompat_GfGfxLoader_GetCellBank(int narcID, int member, BOOL compressed, NNSG2dCellDataBank **cellBank, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return Graphics_GetCellBank(narc, member, compressed, cellBank, heapID);
}

void *HgssCompat_GfGfxLoader_GetPlttData(int narcID, int member, NNSG2dPaletteData **paletteData, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return Graphics_GetPlttData(narc, member, paletteData, heapID);
}

void HgssCompat_GfGfxLoader_GXLoadPal(int narcID, int memberIdx, enum PaletteLoadLocation location, u32 offset, u32 size, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    Graphics_LoadPalette(narc, memberIdx, location, offset, size, heapID);
}

void *HgssCompat_GfGfxLoader_GetScrnData(int narcID, int memberIdx, BOOL compressed, NNSG2dScreenData **screenData, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    return Graphics_GetScrnData(narc, memberIdx, compressed, screenData, heapID);
}

u32 HgssCompat_GfGfxLoader_LoadCharData(int narcID, int memberIdx, BgConfig *bgConfig, u32 bgLayer, u32 offset, u32 size, BOOL compressed, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    return Graphics_LoadTilesToBgLayer(narc, memberIdx, bgConfig, bgLayer, offset, size, compressed, heapID);
}

void HgssCompat_GfGfxLoader_LoadScrnData(int narcID, int memberIdx, BgConfig *bgConfig, u32 bgLayer, u32 offset, u32 size, BOOL compressed, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &memberIdx);
    Graphics_LoadTilemapToBgLayer(narc, memberIdx, bgConfig, bgLayer, offset, size, compressed, heapID);
}

MessageLoader *HgssCompat_NewMsgDataFromNarc(enum MessageLoaderMode mode, int narcID, int bank, enum HeapID heapID)
{
    if (narcID == HGSS_NARC_MSGDATA) {
        return MessageLoader_Init(mode, NARC_INDEX_MSGDATA__PL_MSG, HgssCompat_TextBank(bank), heapID);
    }

    enum NarcID narc = HgssCompat_NarcMember(narcID, &bank);
    return MessageLoader_Init(mode, narc, bank, heapID);
}

u8 HgssCompat_AddTextPrinterParameterizedWithColor(Window *window, int font, const String *string, u32 x, u32 y, u32 delay, TextColor color, TextPrinterCallback callback)
{
    return Text_AddPrinterWithParamsAndColor(window, HgssCompat_Font(font), string, x, y, delay, color, callback);
}

void HgssCompat_FontID_Alloc(int font, enum HeapID heapID)
{
    if (HgssCompat_Font(font) == FONT_SUBSCREEN && sSubscreenFontUsers++ == 0) {
        Font_InitManager(FONT_SUBSCREEN, heapID);
    }
}

void HgssCompat_FontID_Release(int font)
{
    if (HgssCompat_Font(font) == FONT_SUBSCREEN && sSubscreenFontUsers != 0 && --sSubscreenFontUsers == 0) {
        Font_Free(FONT_SUBSCREEN);
    }
}

u32 HgssCompat_FontID_String_GetCenterAlignmentX(int font, const String *string, u32 letterSpacing, u32 windowWidth)
{
    return Font_CalcCenterAlignment(HgssCompat_Font(font), string, letterSpacing, windowWidth);
}

// HeartGold's Sprite_SetDrawPriority is Platinum's Sprite_SetPriority, a name hgss_compat.inc gives HeartGold's
// Sprite_SetPriority (Platinum's Sprite_SetExplicitPriority) to
void HgssCompat_Sprite_SetDrawPriority(Sprite *sprite, u32 priority)
{
    Sprite_SetPriority(sprite, priority);
}

// Platinum's BoxPokemon_IsShiny is the same code, but static to pokemon.c
u8 HgssCompat_BoxMonIsShiny(BoxPokemon *boxMon)
{
    return Pokemon_IsPersonalityShiny(BoxPokemon_GetValue(boxMon, MON_DATA_OT_ID, NULL), BoxPokemon_GetValue(boxMon, MON_DATA_PERSONALITY, NULL));
}

// HeartGold's GetMonSpriteCharAndPlttNarcIdsEx is Platinum's BuildPokemonSpriteTemplate, which names Platinum's
// archives: marked so, so that the shims reading the picture (sub_02014540, AllocAndReadWholeNarcMemberByIdPair)
// don't take them for HeartGold's numbers
void HgssCompat_GetMonSpriteCharAndPlttNarcIdsEx(PokemonSpriteTemplate *spriteTemplate, u16 species, u8 gender, u8 face, u8 shiny, u8 form, u32 personality)
{
    BuildPokemonSpriteTemplate(spriteTemplate, species, gender, face, shiny, form, personality);
    spriteTemplate->narcID |= HGSS_PLATINUM_NARC;
}

// HeartGold's sub_02014540: a Pokémon's sprite's first frame (10 by 10 tiles) into dest. Platinum's own for it
// (CharacterSprite_LoadPokemonSprite, by way of ..._LoadPokemonSpriteRegion) is called by nothing else in Complete, so
// the linker leaves both out; calling them would put them back into the main module, into main memory.
void HgssCompat_LoadPokemonSprite(int narcID, int narcIdx, enum HeapID heapID, void *dest, u32 personality, BOOL isAnimated, int face, int species)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &narcIdx);
    CharacterSprite_LoadPokemonSpriteRect(narc, narcIdx, heapID, 0, 0, 10, 10, dest, personality, isAnimated, face, (enum Species)species);
}

// HeartGold reads the touch screen through these (Platinum's gSystem has the same fields, 4 bytes earlier)
BOOL HgssCompat_System_GetTouchHeld(void)
{
    return gSystem.touchHeld;
}

BOOL HgssCompat_System_GetTouchNew(void)
{
    return gSystem.touchPressed;
}

BOOL HgssCompat_System_GetTouchHeldCoords(u32 *x, u32 *y)
{
    if (gSystem.touchHeld) {
        *x = gSystem.touchX;
        *y = gSystem.touchY;
        return TRUE;
    }

    return FALSE;
}

// HeartGold's yes/no prompt (touch and buttons) is Platinum's touch-only one: its template starts with the same
// fields as Platinum's parameters, and its answers have the same numbers (0 none yet, 1 yes, 2 no). The buttons'
// cursor HeartGold also gave it is missing.
typedef struct HgssYesNoPromptTemplate {
    BgConfig *bgConfig;
    int bgLayer;
    int baseTile;
    u32 palette;
    u8 x;
    u8 y;
    u8 ignoreTouch : 4;
    u8 initialCursorPos : 4;
    u8 shape;
} HgssYesNoPromptTemplate;

YesNoTouchMenu *HgssCompat_YesNoPrompt_Create(enum HeapID heapID)
{
    return YesNoTouchMenu_New(heapID);
}

void HgssCompat_YesNoPrompt_Destroy(YesNoTouchMenu *menu)
{
    YesNoTouchMenu_Free(menu);
}

void HgssCompat_YesNoPrompt_InitFromTemplate(YesNoTouchMenu *menu, const HgssYesNoPromptTemplate *template)
{
    YesNoTouchMenuParams params;

    params.bgConfig = template->bgConfig;
    params.bgLayer = (enum BgLayer)template->bgLayer;
    params.baseTile = template->baseTile;
    params.palette = template->palette;
    params.tilemapLeft = template->x;
    params.tilemapTop = template->y;
    YesNoTouchMenu_InitWithParams(menu, &params);
}

u32 HgssCompat_YesNoPrompt_HandleInput(YesNoTouchMenu *menu)
{
    return YesNoTouchMenu_ProcessInput(menu);
}

void HgssCompat_YesNoPrompt_Reset(YesNoTouchMenu *menu)
{
    YesNoTouchMenu_Reset(menu);
}

// HeartGold's sub_0203A994: the wireless icon while linked, on the screen given (NNS_G2D_VRAM_TYPE_2DSUB for the
// Pokéathlon). Complete leaves the Pokéathlon's link play out (docs/Roadmap.md), so only the main screen's is shown,
// as Platinum's screens do.
void HgssCompat_ShowNetworkIcon(int vramType)
{
    if (vramType == NNS_G2D_VRAM_TYPE_2DMAIN) {
        NetworkIcon_InitIfConnected();
    }
}

// HeartGold's BufferPokeathlonCourseName: a course's name (msg_0313's first eleven) into the template's slot
void HgssCompat_BufferPokeathlonCourseName(StringTemplate *template, u32 idx, u32 course)
{
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0313, template->heapID);
    String *name = MessageLoader_GetNewString(loader, course);

    GF_ASSERT(course < 11);
    StringTemplate_SetString(template, idx, name, 0, TRUE, GAME_LANGUAGE);
    String_Free(name);
    MessageLoader_Free(loader);
}

// HeartGold's Pokéathlon performance (pret's src/pokemon.c): each stat's stars for the day are its base moved by the
// nature, the personality and the date, within the species' range
typedef struct HgssTodayPerformanceStat {
    u16 base : 3;
    u16 hi : 3;
    u16 lo : 3;
    u16 dummy : 7;
    s16 dailyMod;
} HgssTodayPerformanceStat;

typedef struct HgssPerformanceStars {
    u16 stars; // 3 bits a stat
    u8 color[5]; // 0 at the base, 1 above, 2 below (HeartGold's STARS_*)
    u8 dummy;
} HgssPerformanceStars;

enum {
    HGSS_PERFORMANCE_POWER = 0,
    HGSS_PERFORMANCE_SKILL,
    HGSS_PERFORMANCE_SPEED,
    HGSS_PERFORMANCE_JUMP,
    HGSS_PERFORMANCE_STAMINA,
    HGSS_PERFORMANCE_MAX,
};

static const s8 sNatureMods[25][HGSS_PERFORMANCE_MAX] = {
    { 10, 0, 0, 0, -10 },
    { 35, -35, 0, 0, 0 },
    { 35, 0, 0, 0, -35 },
    { 35, 0, 0, -35, 0 },
    { 35, 0, -35, 0, 0 },
    { -35, 35, 0, 0, 0 },
    { 0, 10, 0, -10, 0 },
    { 0, 35, 0, 0, -35 },
    { 0, 35, 0, -35, 0 },
    { 0, 35, -35, 0, 0 },
    { -35, 0, 0, 0, 35 },
    { 0, -35, 0, 0, 35 },
    { 0, 0, -10, 0, 10 },
    { 0, 0, 0, -35, 35 },
    { 0, 0, -35, 0, 35 },
    { -35, 0, 0, 35, 0 },
    { 0, -35, 0, 35, 0 },
    { 0, 0, 0, 35, -35 },
    { -10, 0, 0, 10, 0 },
    { 0, 0, -35, 35, 0 },
    { -35, 0, 35, 0, 0 },
    { 0, -35, 35, 0, 0 },
    { 0, 0, 35, 0, -35 },
    { 0, 0, 35, -35, 0 },
    { 0, -10, 10, 0, 0 },
};

static u32 HgssCompat_Digit(u32 num, u8 digit)
{
    static const u32 sPowers[8] = { 1, 10, 100, 1000, 10000, 100000, 1000000, 10000000 };
    return (num % sPowers[digit + 1]) / sPowers[digit];
}

static s16 HgssCompat_ScoreToStars(s16 score)
{
    static const s16 sThresholds[] = { -120, -80, -40, -15, 14, 39, 79, 119 };

    for (int i = 0; i < (int)NELEMS(sThresholds); i++) {
        if (score <= sThresholds[i]) {
            return i - 4;
        }
    }

    return 4;
}

// A species' (and form's) performance member in Complete's archive (HeartGold's archive 169 as
// tools/complete/import_hgss_pokeathlon_archives.py makes it from data/complete/pokeathlon_performance.json): its
// species' own, or its form's for a species with HeartGold's forms. The course reads the members itself too
// (overlay 96's ov96_021E679C, which the import redirects here: its own table stopped at HeartGold's 493).
u16 HgssCompat_PokeathlonPerformanceMember(u16 species, u16 form)
{
    if (species > NATIONAL_DEX_COUNT) {
        GF_ASSERT(FALSE);
        return 0;
    }

    for (int i = 0; i < COMPLETE_POKEATHLON_PERFORMANCE_FORMS; i++) {
        if (sCompletePokeathlonPerformanceForms[i][0] == species) {
            return sCompletePokeathlonPerformanceForms[i][1] + (form < sCompletePokeathlonPerformanceForms[i][2] ? form : 0);
        }
    }

    return species;
}

// HeartGold's PokeathlonBasePerformance: a member of the archive (its five slots in the archive's order: HeartGold's
// code reads them through pret's ARCPERF_ numbers below, whatever their names say: the data shows the slots are
// Power, Speed, Jump, Stamina, Skill, tools/complete/import_hgss_performance.py)
typedef struct HgssBasePerformance {
    u8 base[HGSS_PERFORMANCE_MAX];
    u8 dummy[4];
    u8 minmax[HGSS_PERFORMANCE_MAX][2];
    u8 dummy2;
} HgssBasePerformance;

enum {
    HGSS_ARCPERF_POWER = 0,
    HGSS_ARCPERF_STAMINA,
    HGSS_ARCPERF_JUMP,
    HGSS_ARCPERF_SKILL,
    HGSS_ARCPERF_SPEED,
};

// HeartGold's CalcBoxMonPokeathlonPerformance (pret's src/pokemon.c): each stat's daily move from the nature, the
// personality and the date, and the species' base and range from the archive, in HeartGold's order
void HgssCompat_CalcBoxMonPokeathlonPerformance(BoxPokemon *boxMon, HgssTodayPerformanceStat *dest)
{
    static const u8 sFromArchive[HGSS_PERFORMANCE_MAX] = {
        [HGSS_PERFORMANCE_POWER] = HGSS_ARCPERF_POWER,
        [HGSS_PERFORMANCE_SKILL] = HGSS_ARCPERF_SKILL,
        [HGSS_PERFORMANCE_SPEED] = HGSS_ARCPERF_SPEED,
        [HGSS_PERFORMANCE_JUMP] = HGSS_ARCPERF_JUMP,
        [HGSS_PERFORMANCE_STAMINA] = HGSS_ARCPERF_STAMINA,
    };
    RTCDate date;
    HgssBasePerformance data;
    u32 personality = BoxPokemon_GetValue(boxMon, MON_DATA_PERSONALITY, NULL);
    u32 nature = BoxPokemon_GetNature(boxMon);
    int member;

    GetCurrentDate(&date);

    for (int i = 0; i < HGSS_PERFORMANCE_MAX; i++) {
        u32 digit = HgssCompat_Digit(personality, i);
        dest[i].dailyMod = sNatureMods[nature][i] + (2 * HgssCompat_Digit(digit + (date.day + (7 - i)) * (date.day + (i + 3)), 0) - 9);
    }

    member = HgssCompat_PokeathlonPerformanceMember(BoxPokemon_GetValue(boxMon, MON_DATA_SPECIES, NULL), BoxPokemon_GetValue(boxMon, MON_DATA_FORM, NULL));
    NARC_ReadWholeMemberByIndexPair(&data, HgssCompat_NarcMember(HGSS_NARC_PERFORMANCE, &member), member);

    for (int i = 0; i < HGSS_PERFORMANCE_MAX; i++) {
        dest[i].base = data.base[sFromArchive[i]];
        dest[i].lo = data.minmax[sFromArchive[i]][0];
        dest[i].hi = data.minmax[sFromArchive[i]][1];
    }
}

void HgssCompat_CalcBoxmonPokeathlonStars(HgssPerformanceStars *dest, BoxPokemon *boxMon, const s8 *aprijuice, enum HeapID heapID)
{
    HgssTodayPerformanceStat today[HGSS_PERFORMANCE_MAX];

    (void)heapID; // HeartGold's is unused too

    MI_CpuClear8(dest, sizeof(HgssPerformanceStars));
    HgssCompat_CalcBoxMonPokeathlonPerformance(boxMon, today);

    for (int i = 0; i < HGSS_PERFORMANCE_MAX; i++) {
        s16 stars = HgssCompat_ScoreToStars(today[i].dailyMod + (aprijuice != NULL ? aprijuice[i] : 0)) + today[i].base;

        if (stars < today[i].lo) {
            stars = today[i].lo;
        } else if (stars > today[i].hi) {
            stars = today[i].hi;
        }

        // HeartGold's STARS_AT_BASE (0), STARS_BELOW_BASE (2), STARS_ABOVE_BASE (1)
        dest->color[i] = stars == today[i].base ? 0 : (stars < today[i].base ? 2 : 1);
        dest->stars |= stars << (3 * i);
    }
}

void HgssCompat_CalcMonPokeathlonStars(HgssPerformanceStars *dest, Pokemon *mon, const s8 *aprijuice, enum HeapID heapID)
{
    HgssCompat_CalcBoxmonPokeathlonStars(dest, Pokemon_GetBoxPokemon(mon), aprijuice, heapID);
}

// HeartGold's Party_GetMonAprijuiceModifiers: hgss_compat_apricorn.c

// HeartGold's sub_0208B85C: a stat's five stars to draw (0 none, 1 an empty one, 2 + the colour a full one) and the
// way the Aprijuice moved it (1 up, -1 down, 0 neither)
int HgssCompat_StarsToShow(u8 *dest, int stars, int full, int color, int juice)
{
    for (int i = 0; i < 5; i++) {
        if (i > stars) {
            dest[i] = 0;
        } else if (i > full) {
            dest[i] = 1;
        } else {
            dest[i] = (u8)(color + 2);
        }
    }

    if (juice > 0) {
        return 1;
    }

    return juice < 0 ? -1 : 0;
}
