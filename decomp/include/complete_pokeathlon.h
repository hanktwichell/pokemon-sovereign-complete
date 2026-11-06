#ifndef POKEPLATINUM_COMPLETE_POKEATHLON_H
#define POKEPLATINUM_COMPLETE_POKEATHLON_H

#include "constants/heap.h"
#include "constants/species.h"

#include "savedata.h"

// Sovereign Complete: HeartGold's Pokéathlon (the owner's call, Nov 6, 2026: ported, whether or not the game uses it;
// docs/Roadmap.md has the stages). Its save is HeartGold's PokeathlonSave (pret's include/pokeathlon/pokeathlon_save.h)
// field by field, with its medals (a byte a species, a bit a course) for every species, in a save sector of its own
// (EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON) so the save's blocks keep their sizes. HeartGold keeps it in the main
// save, so what the Pokéathlon changes counts only once the game is saved: here the changes go to a working copy in a
// second sector, marked with the play session that wrote it, and saving the game copies it over the saved one
// (CompletePokeathlon_Commit, from the save's end in src/savedata.c). After a reset without saving, the working copy is
// an older session's and the saved one is read.

#define COMPLETE_POKEATHLON_MAGIC         0x4E4C5441 // "ATLN": a Pokéathlon this game wrote
#define COMPLETE_POKEATHLON_COURSES       5
#define COMPLETE_POKEATHLON_RECORDS       10
#define COMPLETE_POKEATHLON_DATA_CARDS    27
#define COMPLETE_POKEATHLON_MAX_POINTS    99999
#define COMPLETE_POKEATHLON_MEDAL_SPECIES ((NATIONAL_DEX_COUNT + 3) & ~3)

// HeartGold's Pokeathlon_UnkSubStruct_B00: the running totals the Dome's records show (ScrCmd_724), among them the
// points earned in all (unk70, which the reception's gifts raise: ScrCmd_725)
typedef struct CompletePokeathlonTotals {
    u32 unk0;
    u32 unk4;
    u32 unk8;
    u32 unkC;
    u32 unk10;
    u32 unk14;
    u32 unk18;
    u32 unk1C;
    u32 unk20;
    u32 unk24;
    u32 unk28;
    u32 unk2C;
    u32 unk30;
    u32 unk34;
    u32 unk38;
    u32 unk3C;
    u32 unk40;
    u32 unk44[10];
    u32 unk6C;
    u32 unk70;
} CompletePokeathlonTotals;

// A course record's Pokémon (HeartGold's 12 bytes, which the course record screen draws: ov99_021E5B7C, ov98_0221E7E8).
// HeartGold gives the species 9 bits, too few for Complete's, so here it has two of the word's spare bits as well.
typedef struct CompletePokeathlonRecordMon {
    u32 species : 11;
    u32 form : 5;
    u32 gender : 2;
    u32 shiny : 1;
    u32 padding : 13;
    u32 personality;
    u32 unused; // HeartGold never writes it
} CompletePokeathlonRecordMon;

// HeartGold's best run of a course (the first 0xDC bytes of its PokeathlonSave, 0x2C a course): each event's points
// (at most 999), the total (the bonus is the rest; 0 while the course hasn't been run) and the three Pokémon
typedef struct CompletePokeathlonCourseRecord {
    u16 eventPoints[3];
    u16 total;
    CompletePokeathlonRecordMon mons[3];
} CompletePokeathlonCourseRecord;

typedef struct CompletePokeathlonCourseEntry {
    u16 unk_0;
    u8 unk_2[6];
} CompletePokeathlonCourseEntry;

typedef struct CompletePokeathlonRecordsSolo {
    CompletePokeathlonCourseEntry entries[COMPLETE_POKEATHLON_COURSES];
    u8 unk_28[0x4];
} CompletePokeathlonRecordsSolo;

typedef struct CompletePokeathlonRecordsLink {
    CompletePokeathlonCourseEntry entries[COMPLETE_POKEATHLON_COURSES];
    u8 unk_28[0x7C];
} CompletePokeathlonRecordsLink;

// HeartGold's PokeathlonFriendshipRoomStatueData
typedef struct CompletePokeathlonStatue {
    u16 species;
    u8 gender;
    u8 form;
} CompletePokeathlonStatue;

typedef struct CompletePokeathlonSave {
    u32 magic;
    u32 session; // the play session that wrote it (the working copy's; the saved one's says nothing)
    CompletePokeathlonCourseRecord courseRecords[COMPLETE_POKEATHLON_COURSES]; // HeartGold's unk_0
    u8 medals[COMPLETE_POKEATHLON_MEDAL_SPECIES]; // HeartGold's unk_DC: [species - 1], a bit a course
    CompletePokeathlonRecordsSolo recordsSolo[COMPLETE_POKEATHLON_RECORDS];
    CompletePokeathlonRecordsLink recordsLink[COMPLETE_POKEATHLON_RECORDS];
    u8 unk_AEC[0x14];
    CompletePokeathlonTotals totals;
    int athletePoints; // up to 99999
    u32 receivedDataCards; // a bit a data card (27)
    u16 receivedDailyShopItems; // a bit for each of the day's prizes bought, cleared each day
    u16 unk_B7E;
    CompletePokeathlonStatue friendshipRoomStatues[3]; // HeartGold's PokeathlonSave_FriendshipRecords
    u8 friendshipUnk[0x1C];
} CompletePokeathlonSave;

// src/complete_pokeathlon.c (main)
int CompletePokeathlon_SaveSize(void);
void CompletePokeathlon_Init(CompletePokeathlonSave *pokeathlon);
CompletePokeathlonSave *CompletePokeathlon_Load(SaveData *saveData, enum HeapID heapID); // allocated; Heap_Free it
void CompletePokeathlon_Store(SaveData *saveData, CompletePokeathlonSave *pokeathlon); // to the working copy
void CompletePokeathlon_Commit(SaveData *saveData); // the game was saved: the working copy is the saved one
void CompletePokeathlon_NewDay(SaveData *saveData); // the day's prizes can be bought again

// HeartGold's PokeathlonSave_* accessors
u32 CompletePokeathlon_GetAthletePoints(const CompletePokeathlonSave *pokeathlon);
void CompletePokeathlon_AddAthletePoints(CompletePokeathlonSave *pokeathlon, u16 amount);
void CompletePokeathlon_SubAthletePoints(CompletePokeathlonSave *pokeathlon, u16 amount);
BOOL CompletePokeathlon_CheckReceivedDataCard(const CompletePokeathlonSave *pokeathlon, int card);
void CompletePokeathlon_SetReceivedDataCard(CompletePokeathlonSave *pokeathlon, int card);
BOOL CompletePokeathlon_CheckReceivedDailyItemSlot(const CompletePokeathlonSave *pokeathlon, int slot);
void CompletePokeathlon_SetReceivedDailyItemSlot(CompletePokeathlonSave *pokeathlon, int slot);

#ifdef SOVEREIGN_TEST
// The Athlete Points and the data cards and day's prizes bought, as last read or written; the session; the last text a
// prize counter refused with (hgss_msg_0435's: src/overlay007/complete_pokeathlon_shop.c); the counters' purchases
extern u32 gCompleteTestPokeathlon[6];
// The record screen open (1 + its ScrCmd_712 number: 1 the course record; 0 when none), its page drawn last (1 + the
// course) and its cursor (0-4 the courses, 5 Return); the open screen's copy of the course records, which a test can
// fill and then turn a page to see (src/applications/complete_pokeathlon_records/)
extern u8 gCompleteTestPokeathlonRecordScreen[3];
extern CompletePokeathlonCourseRecord *gCompleteTestPokeathlonCourseRecords;
// The Friendship Room's statues (CompleteScrCmd_PokeathlonStatues): how many times the room made them, then each
// statue's walking sprite (its graphics ID; 0 for none)
extern u16 gCompleteTestPokeathlonStatues[4];
#endif

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_H
