#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_COMMON_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_COMMON_H

#include <nitro.h>

#include "constants/heap.h"

#include "bg_window.h"
#include "complete_pokeathlon.h"
#include "font.h"
#include "message.h"
#include "narc.h"
#include "sprite_system.h"
#include "string_gf.h"
#include "string_template.h"

// Sovereign Complete: the parts of HeartGold's overlay 98 (ov98_0221E5C0 to ov98_0221F174, in assembly in pret's
// HeartGold) that its Pokéathlon record screens share, written in C on Platinum's libraries
// (src/applications/complete_pokeathlon_records/records_common.c): a sprite system with the Pokémon icons' archive
// open, with the Pokémon's pictures and icons drawn into sprites; a set of text windows with the screen's messages and
// the species' names; the screens' set-up and a few sums. Ported so far: what the course record screen calls.

// HeartGold's ov98_0221E5E0's
typedef struct PokeathlonRecordsSprites {
    enum HeapID heapID;
    SpriteSystem *spriteSystem;
    SpriteManager *spriteManager;
    NARC *iconNarc; // HeartGold's poke_icon (its NARC 20): Platinum's, with every species and form of Complete's
    s8 iconPaletteBase; // the icons' first palette slot, -1 until loaded
} PokeathlonRecordsSprites;

// HeartGold's ov98_0221EABC's
typedef struct PokeathlonRecordsText {
    enum HeapID heapID;
    Window *windows;
    MessageLoader *loader; // the screen's text bank
    MessageLoader *speciesNames; // HeartGold's bank 237
    StringTemplate *template;
    String *buffer;
    int numWindows;
} PokeathlonRecordsText;

// The screens (ov98_0221F090, ov98_0221F0EC): nothing shown and nothing run at VBlank, the screens' VRAM banks, and the
// main engine on the bottom screen; and the same, as a screen ends, with the main engine back on top
void PokeathlonRecords_SetUpScreens(void);
void PokeathlonRecords_EndScreens(void);

// Sprites (ov98_0221E5E0 to ov98_0221E970). The Pokémon's pictures are Complete's 96x96 copies of their front sprites
// (HeartGold's are 80x80), drawn in the middle of the same place.
PokeathlonRecordsSprites *PokeathlonRecords_NewSprites(enum HeapID heapID, const SpriteResourceCapacities *capacities, int maxSprites);
void PokeathlonRecords_FreeSprites(PokeathlonRecordsSprites *sprites, ManagedSprite **spriteList, int count);
void PokeathlonRecords_DrawSprites(PokeathlonRecordsSprites *sprites);
ManagedSprite *PokeathlonRecords_NewSprite(PokeathlonRecordsSprites *sprites, const SpriteTemplate *template);
void PokeathlonRecords_LoadMonPicResources(PokeathlonRecordsSprites *sprites, const int resourceIDs[4], enum NNS_G2D_VRAM_TYPE vramType);
BOOL PokeathlonRecords_DrawMonPic(ManagedSprite *sprite, const CompletePokeathlonRecordMon *mon, enum NNS_G2D_VRAM_TYPE vramType, enum HeapID heapID);
void PokeathlonRecords_LoadIconResources(PokeathlonRecordsSprites *sprites, const int resourceIDs[4], int count, enum NNS_G2D_VRAM_TYPE vramType, BOOL animated);
void PokeathlonRecords_DrawIcon(PokeathlonRecordsSprites *sprites, ManagedSprite *sprite, const CompletePokeathlonRecordMon *mon, BOOL animated);

// Text (ov98_0221EABC to ov98_0221EF14). Each print clears its window first and prints in the system font's dark
// grey unless a font is given.
PokeathlonRecordsText *PokeathlonRecords_NewText(enum HeapID heapID, BgConfig *bgConfig, int numWindows, const WindowTemplate *templates, u32 bankID);
void PokeathlonRecords_FreeText(PokeathlonRecordsText *text);
void PokeathlonRecords_PrintMessageEx(PokeathlonRecordsText *text, int window, u32 entryID, BOOL center, u32 x, u32 y, enum Font font, u8 fill);
void PokeathlonRecords_PrintMessage(PokeathlonRecordsText *text, int window, u32 entryID, BOOL center); // at the top
void PokeathlonRecords_PrintMessageInFont(PokeathlonRecordsText *text, int window, u32 entryID, BOOL center, u32 y, enum Font font);
void PokeathlonRecords_PrintMessageAt(PokeathlonRecordsText *text, int window, u32 entryID, u32 x, u32 y);
void PokeathlonRecords_PrintNumberMessage(PokeathlonRecordsText *text, int window, u32 entryID, int number, u32 digits, u32 templateIdx);
void PokeathlonRecords_PrintSpeciesName(PokeathlonRecordsText *text, int window, u16 species);
void PokeathlonRecords_ClearWindow(PokeathlonRecordsText *text, int window);

// HeartGold's BufferPokeathlonCourseName, BufferPokeathlonMedalName and BufferPokeathlonEventName (its main module's;
// its text bank 313)
void PokeathlonRecords_SetCourseName(StringTemplate *template, u32 idx, u32 course);
void PokeathlonRecords_SetMedalName(StringTemplate *template, u32 idx, u32 medal);
void PokeathlonRecords_SetEventName(StringTemplate *template, u32 idx, u32 event);

// ov98_0221EF64: a course's total against its Collective Trophy, 0 below 420 points, 1 from 420, 2 from 450
int PokeathlonRecords_CourseTrophyRank(u16 total);
// ov98_0221F120: a number's digit, 1 the ones, 2 the tens, up to 4
u16 PokeathlonRecords_Digit(u32 number, u8 place);

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_RECORDS_COMMON_H
