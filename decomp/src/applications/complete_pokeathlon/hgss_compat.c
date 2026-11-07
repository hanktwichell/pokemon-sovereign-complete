#include <nitro.h>

#include "constants/heap.h"
#include "constants/narc.h"
#include "generated/text_banks.h"

#include "data/complete_pokeathlon_archives.h"

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
};

static const u16 sTextBanks[][2] = {
    { 278, TEXT_BANK_HGSS_MSG_0278 }, // the course's choice of Pokémon
    { 298, TEXT_BANK_HGSS_MSG_0298 }, // the party and box picker
    { 313, TEXT_BANK_HGSS_MSG_0313 },
    { 314, TEXT_BANK_HGSS_MSG_0314 },
};

#define HGSS_NARC_MSGDATA  27
#define HGSS_PLATINUM_NARC 0x8000

// A HeartGold archive and member as Complete's: the archive returned, the member moved where it's packed
static enum NarcID HgssCompat_NarcMember(int narcID, int *member)
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
            GF_ASSERT(*member < sCompletePokeathlonArchives[i][2]);
            *member += sCompletePokeathlonArchives[i][1];
            return NARC_INDEX_APPLICATION__COMPLETE__POKEATHLON;
        }
    }

    GF_ASSERT(FALSE);
    return (enum NarcID)sNarcs[0][1];
}

static u32 HgssCompat_TextBank(int bank)
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
static enum Font HgssCompat_Font(int font)
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

// The whole archive, read by member later (NARC_ReadWholeMember, HeartGold's numbers): one of the archives Platinum
// has too, as a packed one's members would need moving at each read (none of the callers opens one)
NARC *HgssCompat_NARC_New(int narcID, enum HeapID heapID)
{
    int first = 0;
    enum NarcID narc = HgssCompat_NarcMember(narcID, &first);

    GF_ASSERT(narc != NARC_INDEX_APPLICATION__COMPLETE__POKEATHLON);
    return NARC_ctor(narc, heapID);
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
void HgssCompat_LoadPokemonSprite(int narcID, int narcIdx, enum HeapID heapID, void *dest, u32 personality, BOOL isAnimated, int face, enum Species species)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &narcIdx);
    CharacterSprite_LoadPokemonSpriteRect(narc, narcIdx, heapID, 0, 0, 10, 10, dest, personality, isAnimated, face, species);
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
    u8 color[5]; // 0 at the base, 1 below, 2 above
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

void HgssCompat_CalcBoxMonPokeathlonPerformance(BoxPokemon *boxMon, HgssTodayPerformanceStat *dest)
{
    RTCDate date;
    u32 personality = BoxPokemon_GetValue(boxMon, MON_DATA_PERSONALITY, NULL);
    u32 nature = BoxPokemon_GetNature(boxMon);

    GetCurrentDate(&date);

    for (int i = 0; i < HGSS_PERFORMANCE_MAX; i++) {
        u32 digit = HgssCompat_Digit(personality, i);
        dest[i].dailyMod = sNatureMods[nature][i] + (2 * HgssCompat_Digit(digit + (date.day + (7 - i)) * (date.day + (i + 3)), 0) - 9);
        // the species' base stars and range: data/complete/pokeathlon_performance.json, whose archive comes with the
        // course (docs/Roadmap.md, stage 1's last part); until then every stat is 3 stars, 1 to 5
        dest[i].base = 3;
        dest[i].lo = 1;
        dest[i].hi = 5;
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

        dest->color[i] = stars == today[i].base ? 0 : (stars < today[i].base ? 1 : 2);
        dest->stars |= stars << (3 * i);
    }
}

void HgssCompat_CalcMonPokeathlonStars(HgssPerformanceStars *dest, Pokemon *mon, const s8 *aprijuice, enum HeapID heapID)
{
    HgssCompat_CalcBoxmonPokeathlonStars(dest, Pokemon_GetBoxPokemon(mon), aprijuice, heapID);
}

// HeartGold keeps each party Pokémon's Aprijuice in the party (PartyExtraSub, a byte a stat). Complete has no
// Aprijuice yet (stage 1's Aprijuice stand): none.
void HgssCompat_Party_GetMonAprijuiceModifiers(const Party *party, s8 *dest, int slot)
{
    (void)party;
    (void)slot;
    MI_CpuClear8(dest, HGSS_PERFORMANCE_MAX);
}

// HeartGold's Save_Pokeathlon_Get gives its save's Pokéathlon block. Complete's is in its own sectors, read into a
// copy (include/complete_pokeathlon.h): the "block" handed back is the save itself, which the accessors below read.
void *HgssCompat_Save_Pokeathlon_Get(SaveData *saveData)
{
    return saveData;
}

// HeartGold's PokeathlonSave_GetUnkDC_AtIndex: whether a species has a course's medal
BOOL HgssCompat_PokeathlonSave_GetMedal(void *saveData, int course, int species)
{
    CompletePokeathlonSave *pokeathlon;
    BOOL medal;

    if (course < 0 || course >= COMPLETE_POKEATHLON_COURSES || species < 1 || species > COMPLETE_POKEATHLON_MEDAL_SPECIES) {
        GF_ASSERT(FALSE);
        return FALSE;
    }

    pokeathlon = CompletePokeathlon_Load(saveData, HGSS_HEAP_ID_POKEATHLON);
    medal = (pokeathlon->medals[species - 1] >> course) & 1;
    Heap_Free(pokeathlon);
    return medal;
}

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
