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
#define COMPLETE_POKEATHLON_EVENTS        10
#define COMPLETE_POKEATHLON_EVENT_ENTRIES 5
#define COMPLETE_POKEATHLON_NO_RESULT     0xFFFF
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

// An event record's Pokémon (HeartGold's u16, its species in 9 bits and its form from bit 10): here 11 bits for
// Complete's species, and the form above them
typedef struct CompletePokeathlonEventMon {
    u16 species : 11;
    u16 form : 5;
} CompletePokeathlonEventMon;

// An event record (HeartGold's Pokeathlon_CourseEntry, which the event record screen draws): the result in the
// event's unit (Hurdle Dash's frames, Relay Run's 1/1024 laps, else a count; COMPLETE_POKEATHLON_NO_RESULT for none)
// and the three Pokémon
typedef struct CompletePokeathlonEventEntry {
    u16 result;
    CompletePokeathlonEventMon mons[3];
} CompletePokeathlonEventEntry;

// An event's five best (HeartGold's Pokeathlon_RecordsSolo and _RecordsLink), and how often it's been joined (their
// unk_28's first word: ov99_021E94FC). The link records' players' names follow, 12 characters each 0x18 bytes apart
// from 0x30 (ov99_021E9518); Complete has no link play, so they're never written.
typedef struct CompletePokeathlonRecordsSolo {
    CompletePokeathlonEventEntry entries[COMPLETE_POKEATHLON_EVENT_ENTRIES];
    u32 timesJoined;
} CompletePokeathlonRecordsSolo;

typedef struct CompletePokeathlonRecordsLink {
    CompletePokeathlonEventEntry entries[COMPLETE_POKEATHLON_EVENT_ENTRIES];
    u32 timesJoined;
    u8 unk_2C[0x78];
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
    u16 recordPoints[COMPLETE_POKEATHLON_EVENTS]; // HeartGold's unk_AEC: each event record's points in its course
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
// The record screen open (1 + its ScrCmd_712 number: 1 the course record, 2 the medals, 3 the event record, 4 the
// trophies; 0 when none), its page drawn last (1 + the course; 1 + the medals' page; 1 + the event shown, 0 for none;
// the trophies earned in all) and its cursor (the course record's 0-4 the courses, 5 Return; the medals' 0-29 the
// Pokémon, 30 Return; the event record's 0-9 the events, 10 Return, 255 the Single/Link button; the Friendship
// Trophies earned); [3], a test's request (1) that the medals, event record or trophies screen reread its data and
// redraw, cleared once done; [4], the event record's Link mode (src/applications/complete_pokeathlon_records/). The
// open screens' data, which a test can fill: the course record's copy of the course records (turn a page to see them),
// the medals screen's copy of the medals ([species - 1], a bit a course; then the request), the event record's copy of
// the Single records (then the request; the Link records and the records' points follow them, as in
// CompletePokeathlonSave) and the trophies screen's copy of the whole save (then the request)
extern u8 gCompleteTestPokeathlonRecordScreen[5];
extern CompletePokeathlonCourseRecord *gCompleteTestPokeathlonCourseRecords;
extern u8 *gCompleteTestPokeathlonMedals;
extern CompletePokeathlonRecordsSolo *gCompleteTestPokeathlonEventRecords;
extern CompletePokeathlonSave *gCompleteTestPokeathlonSaveCopy;
// The Friendship Room's statues (CompleteScrCmd_PokeathlonStatues): how many times the room made them, then each
// statue's walking sprite (its graphics ID; 0 for none)
extern u16 gCompleteTestPokeathlonStatues[4];
#endif

#endif // POKEPLATINUM_COMPLETE_POKEATHLON_H
