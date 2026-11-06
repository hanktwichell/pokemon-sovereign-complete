#include "applications/complete_pokeathlon_records/records_common.h"

#include <nitro.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "constants/narc.h"
#include "constants/species.h"
#include "generated/text_banks.h"

#include "bg_window.h"
#include "char_transfer.h"
#include "character_sprite.h"
#include "font.h"
#include "graphics.h"
#include "gx_layers.h"
#include "heap.h"
#include "message.h"
#include "message_util.h"
#include "narc.h"
#include "pokemon.h"
#include "pokemon_icon.h"
#include "pokemon_sprite.h"
#include "render_oam.h"
#include "screen_fade.h"
#include "sprite.h"
#include "sprite_system.h"
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "text.h"
#include "touch_screen.h"

#include "res/graphics/battle/sprites.naix"
#include "res/text/bank/hgss_msg_0313.h"

// Sovereign Complete: HeartGold's overlay 98, the record screens' shared parts
// (include/applications/complete_pokeathlon_records/records_common.h)

#define TEXT_COLOR_DEFAULT TEXT_COLOR(1, 2, 0) // HeartGold's 0x00010200
#define ICON_FRAME_SIZE    0x200 // a 32x32 icon frame's tiles
#define ICON_BLANK_TILES   28 // the archive's blank tiles for an icon, two frames (29: one)

static const GXBanks sBanks = { // ov98_0221F248
    GX_VRAM_BG_128_A,
    GX_VRAM_BGEXTPLTT_NONE,
    GX_VRAM_SUB_BG_128_C,
    GX_VRAM_SUB_BGEXTPLTT_NONE,
    GX_VRAM_OBJ_128_B,
    GX_VRAM_OBJEXTPLTT_NONE,
    GX_VRAM_SUB_OBJ_16_I,
    GX_VRAM_SUB_OBJEXTPLTT_NONE,
    GX_VRAM_TEX_NONE,
    GX_VRAM_TEXPLTT_NONE,
};

static const RenderOamTemplate sOamTemplate = { 0, 128, 0, 32, 0, 128, 0, 32 }; // ov98_0221F1C0
static const CharTransferTemplateWithModes sCharTransfer = { // ov98_0221F1AC (its first field the sprites' number)
    0, 0x20000, 0x4000, GX_OBJVRAMMODE_CHAR_1D_64K, GX_OBJVRAMMODE_CHAR_1D_64K
};

static const u32 sPowersOfTen[] = { 1, 10, 100, 1000, 10000 }; // ov98_0221F1E4
static const u16 sTrustTrophyMedalists[] = { 200, 150, 100, 75, 50, 25, 10, 5, 2, 1 }; // ov98_0221F220

// ov98_0221F1F8: each event's default record and Potential Trophy (Hurdle Dash's in frames: 100 and 80 seconds;
// Relay Run's in 1/1024 laps: 12 and 16)
static const u16 sEventGoals[COMPLETE_POKEATHLON_EVENTS][2] = {
    { 3000, 2400 },
    { 35, 50 },
    { 40, 60 },
    { 80, 130 },
    { 40, 70 },
    { 350, 500 },
    { 12 << 10, 16 << 10 },
    { 70, 100 },
    { 30, 55 },
    { 3, 9 },
};

#define EVENT_HURDLE_DASH 0 // the event where lower is better

static const TouchScreenHitTable sReturnHitTable[] = { // ov98_0221F1E0 (its right edge 0: the screen's, as the check wraps)
    { .rect = { 160, 192, 192, 0 } },
};

#define SPRITE_ROW_LENGTH  10
#define SPRITE_ROW_SPACING 16

// ov98_0221F090
void PokeathlonRecords_SetUpScreens(void)
{
    SetScreenColorBrightness(DS_SCREEN_MAIN, COLOR_BLACK);
    SetScreenColorBrightness(DS_SCREEN_SUB, COLOR_BLACK);
    SetVBlankCallback(NULL, NULL);
    DisableHBlank();
    GXLayers_DisableEngineALayers();
    GXLayers_DisableEngineBLayers();
    GX_SetVisiblePlane(0);
    GXS_SetVisiblePlane(0);
    GX_SetDispSelect(GX_DISP_SELECT_SUB_MAIN); // HeartGold clears POWCNT's display swap: the main engine below
    GXLayers_SetBanks(&sBanks);
}

// ov98_0221F0EC
void PokeathlonRecords_EndScreens(void)
{
    SetVBlankCallback(NULL, NULL);
    DisableHBlank();
    GXLayers_DisableEngineALayers();
    GXLayers_DisableEngineBLayers();
    GX_SetVisiblePlane(0);
    GXS_SetVisiblePlane(0);
    GX_SetDispSelect(GX_DISP_SELECT_MAIN_SUB); // the main engine back on the top screen, for the field
}

// ov98_0221E5E0. HeartGold also makes a PaletteData here, which nothing in the course record reads.
PokeathlonRecordsSprites *PokeathlonRecords_NewSprites(enum HeapID heapID, const SpriteResourceCapacities *capacities, int maxSprites)
{
    PokeathlonRecordsSprites *sprites = Heap_Alloc(heapID, sizeof(PokeathlonRecordsSprites));
    CharTransferTemplateWithModes transfer = sCharTransfer;

    sprites->heapID = heapID;
    sprites->spriteSystem = SpriteSystem_Alloc(heapID);
    sprites->spriteManager = SpriteManager_New(sprites->spriteSystem);
    sprites->iconNarc = NARC_ctor(NARC_INDEX_POKETOOL__ICONGRA__PL_POKE_ICON, heapID);
    sprites->iconPaletteBase = -1;

    transfer.maxTasks = maxSprites;
    SpriteSystem_Init(sprites->spriteSystem, &sOamTemplate, &transfer, 32);
    SpriteSystem_InitSprites(sprites->spriteSystem, sprites->spriteManager, maxSprites);
    SpriteSystem_InitManagerWithCapacities(sprites->spriteSystem, sprites->spriteManager, capacities);
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_OBJ, TRUE);
    GXLayers_EngineBToggleLayers(GX_PLANEMASK_OBJ, TRUE);
    return sprites;
}

// ov98_0221E684. The manager was set up by capacities, so it goes with FreeResourcesAndManager (CLAUDE.md's Berry Pots
// trap).
void PokeathlonRecords_FreeSprites(PokeathlonRecordsSprites *sprites, ManagedSprite **spriteList, int count)
{
    NARC_dtor(sprites->iconNarc);

    for (int i = 0; i < count; i++) {
        if (spriteList[i] != NULL) {
            Sprite_DeleteAndFreeResources(spriteList[i]);
            spriteList[i] = NULL;
        }
    }

    SpriteSystem_FreeResourcesAndManager(sprites->spriteSystem, sprites->spriteManager);
    SpriteSystem_Free(sprites->spriteSystem);
    Heap_Free(sprites);
}

// ov98_0221E6CC
void PokeathlonRecords_DrawSprites(PokeathlonRecordsSprites *sprites)
{
    GF_ASSERT(sprites != NULL);
    SpriteSystem_DrawSprites(sprites->spriteManager);
}

// ov98_0221E6E0
ManagedSprite *PokeathlonRecords_NewSprite(PokeathlonRecordsSprites *sprites, const SpriteTemplate *template)
{
    return SpriteSystem_NewSprite(sprites->spriteSystem, sprites->spriteManager, template);
}

void PokeathlonRecords_NewSpriteRow(PokeathlonRecordsSprites *sprites, ManagedSprite **spriteList, const int resourceIDs[4], int lit, int startIdx, s16 x, s16 y, enum NNS_G2D_VRAM_TYPE vramType)
{
    SpriteTemplate template;

    GF_ASSERT(lit <= SPRITE_ROW_LENGTH);
    MI_CpuClear8(&template, sizeof(SpriteTemplate));
    template.y = y;
    template.vramType = vramType;

    for (int i = 0; i < 4; i++) {
        template.resources[i] = resourceIDs[i];
    }

    for (int i = 0; i < SPRITE_ROW_LENGTH; i++) {
        template.animIdx = i < lit ? 1 : 0;
        template.x = x + SPRITE_ROW_SPACING * i;
        spriteList[startIdx + i] = PokeathlonRecords_NewSprite(sprites, &template);
        ManagedSprite_SetAnimateFlag(spriteList[startIdx + i], TRUE);
    }
}

// ov98_0221E784: a Pokémon picture's sprite resources (char, palette, cells, animations), its tiles and palette drawn
// in later (PokeathlonRecords_DrawMonPic). HeartGold's are its battle archive's 80x80 picture (members 75 to 78);
// Complete's pictures are 96x96, with the same archive's 96x96 copy (in the 64K mapping these screens use).
void PokeathlonRecords_LoadMonPicResources(PokeathlonRecordsSprites *sprites, const int resourceIDs[4], enum NNS_G2D_VRAM_TYPE vramType)
{
    SpriteSystem_LoadCharResObj(sprites->spriteSystem, sprites->spriteManager, NARC_INDEX_BATTLE__GRAPHIC__PL_BATT_OBJ, misc_pokesprite_96_NCGR, FALSE, vramType, resourceIDs[0]);
    SpriteSystem_LoadPlttResObj(sprites->spriteSystem, sprites->spriteManager, NARC_INDEX_BATTLE__GRAPHIC__PL_BATT_OBJ, misc_pokesprite_1_NCLR, FALSE, 1, vramType, resourceIDs[1]);
    SpriteSystem_LoadCellResObj(sprites->spriteSystem, sprites->spriteManager, NARC_INDEX_BATTLE__GRAPHIC__PL_BATT_OBJ, misc_pokesprite_96_cell_NCER, FALSE, resourceIDs[2]);
    SpriteSystem_LoadAnimResObj(sprites->spriteSystem, sprites->spriteManager, NARC_INDEX_BATTLE__GRAPHIC__PL_BATT_OBJ, misc_single_frame_anim_NANR, FALSE, resourceIDs[3]);
}

// ov98_0221E9FC: tiles straight into a sprite's place in VRAM
static void LoadSpriteTiles(ManagedSprite *sprite, void *data, u32 size)
{
    enum NNS_G2D_VRAM_TYPE vramType = Sprite_GetVRamType(sprite->sprite);
    u32 location = NNS_G2dGetImageLocation(Sprite_GetImageProxy(sprite->sprite), vramType);

    DC_FlushRange(data, size);

    switch (vramType) {
    case NNS_G2D_VRAM_TYPE_2DMAIN:
        GX_LoadOBJ(data, location, size);
        break;
    case NNS_G2D_VRAM_TYPE_2DSUB:
        GXS_LoadOBJ(data, location, size);
        break;
    default:
        GF_ASSERT(FALSE);
        break;
    }
}

// ov98_0221EA4C: a palette into a sprite's palette slot. HeartGold can grey it too; none of its record screens does.
static void LoadSpritePalette(ManagedSprite *sprite, enum NarcID narcID, u32 memberIdx, enum NNS_G2D_VRAM_TYPE vramType, enum HeapID heapID)
{
    u32 location = NNS_G2dGetImagePaletteLocation(Sprite_GetPaletteProxy(sprite->sprite), vramType);

    Graphics_LoadPalette(narcID, memberIdx, vramType == NNS_G2D_VRAM_TYPE_2DMAIN ? PAL_LOAD_MAIN_OBJ : PAL_LOAD_SUB_OBJ, location, PALETTE_SIZE_BYTES, heapID);
}

// ov98_0221E7E8: a Pokémon's front picture (its form, gender, shininess and Spinda's spots) into a sprite. HeartGold
// hides the sprite for no Pokémon and its caller shows it again; here it stays hidden (FALSE).
BOOL PokeathlonRecords_DrawMonPic(ManagedSprite *sprite, const CompletePokeathlonRecordMon *mon, enum NNS_G2D_VRAM_TYPE vramType, enum HeapID heapID)
{
    PokemonSpriteTemplate spriteTemplate;

    if (mon->species == SPECIES_NONE) {
        ManagedSprite_SetDrawFlag(sprite, FALSE);
        return FALSE;
    }

    BuildPokemonSpriteTemplate(&spriteTemplate, mon->species, mon->gender, FACE_FRONT, mon->shiny, mon->form, mon->personality);

    void *tiles = Heap_AllocAtEnd(heapID, MON_SPRITE_96_SIZE_BYTES);

    CharacterSprite_LoadPokemonSprite96(spriteTemplate.narcID, spriteTemplate.character, heapID, 0, tiles, mon->personality, FALSE, FACE_FRONT, mon->species);
    LoadSpriteTiles(sprite, tiles, MON_SPRITE_96_SIZE_BYTES);
    LoadSpritePalette(sprite, spriteTemplate.narcID, spriteTemplate.palette, vramType, heapID);
    ManagedSprite_SetDrawFlag(sprite, TRUE);
    Heap_Free(tiles);
    return TRUE;
}

// ov98_0221E8A8: count icons' sprite resources: blank tiles from the record screens' archive (each icon's drawn in
// later), the icons' cells, animations and palettes (loaded once) from the icons' archive, in the 64K mapping
void PokeathlonRecords_LoadIconResources(PokeathlonRecordsSprites *sprites, const int resourceIDs[4], int count, enum NNS_G2D_VRAM_TYPE vramType, BOOL animated)
{
    for (int i = 0; i < count; i++) {
        SpriteSystem_LoadCharResObj(sprites->spriteSystem, sprites->spriteManager, NARC_INDEX_GRAPHIC__COMPLETE__POKEATHLON_RECORDS, animated ? ICON_BLANK_TILES : ICON_BLANK_TILES + 1, TRUE, vramType, resourceIDs[0] + i);
    }

    SpriteSystem_LoadCellResObjFromOpenNarc(sprites->spriteSystem, sprites->spriteManager, sprites->iconNarc, PokeIcon64KCellsFileIndex(), FALSE, resourceIDs[2]);
    SpriteSystem_LoadAnimResObjFromOpenNarc(sprites->spriteSystem, sprites->spriteManager, sprites->iconNarc, PokeIcon64KAnimationFileIndex(), FALSE, resourceIDs[3]);

    if (sprites->iconPaletteBase == -1) {
        sprites->iconPaletteBase = SpriteSystem_LoadPlttResObjFromOpenNarc(sprites->spriteSystem, sprites->spriteManager, sprites->iconNarc, PokeIconPalettesFileIndex(), FALSE, 3, vramType, resourceIDs[1]);
    }
}

// ov98_0221E970: a Pokémon's icon (its form's) into an icon sprite, which is left hidden; animated, it hops
void PokeathlonRecords_DrawIcon(PokeathlonRecordsSprites *sprites, ManagedSprite *sprite, const CompletePokeathlonRecordMon *mon, BOOL animated)
{
    NNSG2dCharacterData *charData;
    void *file = Graphics_GetCharDataFromOpenNARC(sprites->iconNarc, PokeIconSpriteIndex(mon->species, FALSE, mon->form), FALSE, &charData, sprites->heapID);

    LoadSpriteTiles(sprite, charData->pRawData, animated ? ICON_FRAME_SIZE * 2 : ICON_FRAME_SIZE);
    Heap_Free(file);
    ManagedSprite_SetDrawFlag(sprite, FALSE);
    ManagedSprite_SetExplicitPalette(sprite, PokeIconPaletteIndex(mon->species, mon->form, FALSE) + sprites->iconPaletteBase);

    if (animated) {
        ManagedSprite_SetAnim(sprite, 1);
        ManagedSprite_SetAnimationSpeed(sprite, FX32_ONE);
        ManagedSprite_SetAnimateFlag(sprite, TRUE);
    }
}

// ov98_0221EABC: the text's font (HeartGold's font 4, Platinum's subscreen font), the text palette in slot 12 on both
// screens, the windows (cleared, off their maps until printed), the screen's text bank and the species' names
PokeathlonRecordsText *PokeathlonRecords_NewText(enum HeapID heapID, BgConfig *bgConfig, int numWindows, const WindowTemplate *templates, u32 bankID)
{
    Font_InitManager(FONT_SUBSCREEN, heapID);

    PokeathlonRecordsText *text = Heap_Alloc(heapID, sizeof(PokeathlonRecordsText));

    MI_CpuClear8(text, sizeof(PokeathlonRecordsText));
    text->windows = Window_New(heapID, numWindows);
    Font_LoadTextPalette(PAL_LOAD_MAIN_BG, PLTT_OFFSET(12), heapID);
    Font_LoadTextPalette(PAL_LOAD_SUB_BG, PLTT_OFFSET(12), heapID);

    for (int i = 0; i < numWindows; i++) {
        Window_AddFromTemplate(bgConfig, &text->windows[i], &templates[i]);
        Window_FillTilemap(&text->windows[i], 0);
        Window_ClearTilemap(&text->windows[i]);
    }

    text->speciesNames = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_SPECIES_NAME, heapID);
    text->loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, bankID, heapID);
    text->template = StringTemplate_Default(heapID);
    text->buffer = String_Init(0x400, heapID);
    text->heapID = heapID;
    text->numWindows = numWindows;
    return text;
}

// ov98_0221EB84
void PokeathlonRecords_FreeText(PokeathlonRecordsText *text)
{
    Font_Free(FONT_SUBSCREEN);
    String_Free(text->buffer);
    StringTemplate_Free(text->template);
    MessageLoader_Free(text->speciesNames);
    MessageLoader_Free(text->loader);

    for (int i = 0; i < text->numWindows; i++) {
        Window_ClearAndCopyToVRAM(&text->windows[i]);
        Window_Remove(&text->windows[i]);
    }

    Heap_Free(text->windows);
    Heap_Free(text);
}

void PokeathlonRecords_SetSpeciesName(PokeathlonRecordsText *text, u32 idx, u16 species)
{
    String *name = MessageLoader_GetNewString(text->speciesNames, species);

    StringTemplate_SetString(text->template, idx, name, 0, TRUE, GAME_LANGUAGE);
    String_Free(name);
}

// ov98_0221EF14 and ov98_0221EE84
static void FillWindow(PokeathlonRecordsText *text, int window)
{
    Window_FillTilemap(&text->windows[window], 0);
}

void PokeathlonRecords_ClearWindow(PokeathlonRecordsText *text, int window)
{
    FillWindow(text, window);
    Window_ScheduleCopyToVRAM(&text->windows[window]);
}

static void PrintString(PokeathlonRecordsText *text, int window, const String *string, u32 x, u32 y, enum Font font)
{
    Text_AddPrinterWithParamsAndColor(&text->windows[window], font, string, x, y, TEXT_SPEED_NO_TRANSFER, TEXT_COLOR_DEFAULT, NULL);
    Window_ScheduleCopyToVRAM(&text->windows[window]);
}

void PokeathlonRecords_PrintStringAt(PokeathlonRecordsText *text, int window, const String *string, u32 x, u32 y)
{
    FillWindow(text, window);
    PrintString(text, window, string, x, y, FONT_SYSTEM);
}

// ov98_0221EC3C: a message, its placeholders filled from the template, at (x, y) or centred across the window (plus x)
void PokeathlonRecords_PrintMessageEx(PokeathlonRecordsText *text, int window, u32 entryID, BOOL center, u32 x, u32 y, enum Font font, u8 fill)
{
    GF_ASSERT(window < text->numWindows);

    String *string = MessageUtil_ExpandedString(text->template, text->loader, entryID, text->heapID);
    u32 offset = 0;

    if (center) {
        offset = (u8)(Window_GetWidth(&text->windows[window]) * 8 - Font_CalcMaxLineWidth(font, string, 0)) / 2;
    }

    Window_FillTilemap(&text->windows[window], fill);
    PrintString(text, window, string, x + offset, y, font);
    String_Free(string);
}

// ov98_0221EBD8
void PokeathlonRecords_PrintMessage(PokeathlonRecordsText *text, int window, u32 entryID, BOOL center)
{
    PokeathlonRecords_PrintMessageEx(text, window, entryID, center, 0, 0, FONT_SYSTEM, 0);
}

// ov98_0221EBEC
void PokeathlonRecords_PrintMessageInFont(PokeathlonRecordsText *text, int window, u32 entryID, BOOL center, u32 y, enum Font font)
{
    PokeathlonRecords_PrintMessageEx(text, window, entryID, center, 0, y, font, 0);
}

// ov98_0221EC08
void PokeathlonRecords_PrintMessageAt(PokeathlonRecordsText *text, int window, u32 entryID, u32 x, u32 y)
{
    PokeathlonRecords_PrintMessageEx(text, window, entryID, FALSE, x, y, FONT_SYSTEM, 0);
}

// ov98_0221ECD0: a message with a number (right-aligned in its digits) in the template's templateIdx
void PokeathlonRecords_PrintNumberMessage(PokeathlonRecordsText *text, int window, u32 entryID, int number, u32 digits, u32 templateIdx)
{
    StringTemplate_SetNumber(text->template, templateIdx, number, digits, PADDING_MODE_SPACES, CHARSET_MODE_EN);

    String *format = MessageLoader_GetNewString(text->loader, entryID);

    StringTemplate_Format(text->template, text->buffer, format);
    FillWindow(text, window);
    PrintString(text, window, text->buffer, 0, 0, FONT_SYSTEM);
    String_Free(format);
}

// ov98_0221EE28
void PokeathlonRecords_PrintSpeciesName(PokeathlonRecordsText *text, int window, u16 species)
{
    GF_ASSERT(species <= NATIONAL_DEX_COUNT);
    MessageLoader_GetString(text->speciesNames, species, text->buffer);
    FillWindow(text, window);
    PrintString(text, window, text->buffer, 0, 0, FONT_SYSTEM);
}

static void SetNameFromBank313(StringTemplate *template, u32 idx, u32 entryID)
{
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0313, template->heapID);
    String *name = MessageLoader_GetNewString(loader, entryID);

    StringTemplate_SetString(template, idx, name, 0, TRUE, GAME_LANGUAGE);
    String_Free(name);
    MessageLoader_Free(loader);
}

void PokeathlonRecords_SetCourseName(StringTemplate *template, u32 idx, u32 course)
{
    GF_ASSERT(course < 11);
    SetNameFromBank313(template, idx, msg_0313_00000 + course);
}

void PokeathlonRecords_SetMedalName(StringTemplate *template, u32 idx, u32 medal)
{
    GF_ASSERT(medal < 5);
    SetNameFromBank313(template, idx, msg_0313_00015 + medal);
}

void PokeathlonRecords_SetEventName(StringTemplate *template, u32 idx, u32 event)
{
    GF_ASSERT(event < 10);
    SetNameFromBank313(template, idx, msg_0313_00020 + event);
}

int PokeathlonRecords_CourseTrophyRank(u16 total)
{
    if (total >= 450) {
        return 2;
    }

    if (total >= 420) {
        return 1;
    }

    return 0;
}

u16 PokeathlonRecords_Digit(u32 number, u8 place)
{
    GF_ASSERT(place != 0 && place < NELEMS(sPowersOfTen));
    return (number % sPowersOfTen[place]) / sPowersOfTen[place - 1];
}

BOOL PokeathlonRecords_ReturnPressed(void)
{
    return TouchScreen_LocationPressed(sReturnHitTable) || JOY_NEW(PAD_BUTTON_B);
}

u16 PokeathlonRecords_CountMedalists(const u8 *medals)
{
    u16 medalists = 0;

    for (int i = 0; i < NATIONAL_DEX_COUNT; i++) {
        if (MATH_CountPopulation(medals[i]) == COMPLETE_POKEATHLON_COURSES) {
            medalists++;
        }
    }

    return medalists;
}

int PokeathlonRecords_TrustTrophyRank(u16 medalists)
{
    int i;

    for (i = 0; i < NELEMS(sTrustTrophyMedalists); i++) {
        if (sTrustTrophyMedalists[i] <= medalists) {
            break;
        }
    }

    return NELEMS(sTrustTrophyMedalists) - i;
}

u16 PokeathlonRecords_EventGoal(int event, enum PokeathlonEventGoal goal)
{
    GF_ASSERT(event < COMPLETE_POKEATHLON_EVENTS);
    return sEventGoals[event][goal];
}

BOOL PokeathlonRecords_EventResultBeats(int event, enum PokeathlonEventGoal goal, u16 result)
{
    u16 target = PokeathlonRecords_EventGoal(event, goal);

    if (result == COMPLETE_POKEATHLON_NO_RESULT) {
        return FALSE;
    }

    return event == EVENT_HURDLE_DASH ? result < target : result > target;
}

BOOL PokeathlonRecords_EventResultReaches(int event, enum PokeathlonEventGoal goal, u16 result)
{
    u16 target = PokeathlonRecords_EventGoal(event, goal);

    if (result == COMPLETE_POKEATHLON_NO_RESULT) {
        return FALSE;
    }

    return event == EVENT_HURDLE_DASH ? result <= target : result >= target;
}
