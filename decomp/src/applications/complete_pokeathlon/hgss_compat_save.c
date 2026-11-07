#include <nitro.h>

#include "constants/heap.h"
#include "constants/species.h"

#include "complete_pokeathlon.h"
#include "complete_pokeathlon_course.h"
#include "complete_pokeathlon_select.h"
#include "heap.h"
#include "savedata.h"
#include "charcode_util.h"
#include "trainer_info.h"

// Sovereign Complete: HeartGold's Pokéathlon save as its assembly reaches it (decomp/asm/complete_hgss/, the course
// and overlay 97). HeartGold keeps one PokeathlonSave in its save block and hands out a pointer to it
// (Save_Pokeathlon_Get), then a pointer to each of its parts (PokeathlonSave_GetRecordsSolo2 and the like), which the
// assembly reads and writes by offset. Complete's save (include/complete_pokeathlon.h) follows HeartGold's field by
// field, but with an 8-byte header before it and medals for all of Complete's species, so every part after the
// course records sits elsewhere. So here Save_Pokeathlon_Get hands out the course's working copy of Complete's save
// (CompletePokeathlon_Load's, read when the course starts, HgssCompat_PokeathlonSave_Open, written back when it ends,
// _Close), and each accessor the pointer to that part of it. The parts have HeartGold's layouts (the course records,
// the totals, the event records, their points, the statues; the medals are longer), and the assembly only reaches
// into a part from its own accessor's pointer (no read of the whole save by HeartGold's offsets: every
// Save_Pokeathlon_Get in overlays 96 to 98 goes straight to an accessor). Where a part's layout does differ, the
// species in the records (11 bits here, not HeartGold's 9 or 10), the assembly that packs them is patched by the
// import (tools/complete/import_hgss_asm.py's PATCHES).

static CompletePokeathlonSave *sCourseSave;

void HgssCompat_PokeathlonSave_Open(SaveData *saveData, enum HeapID heapID)
{
    GF_ASSERT(sCourseSave == NULL);
    sCourseSave = CompletePokeathlon_Load(saveData, heapID);
}

void HgssCompat_PokeathlonSave_Close(SaveData *saveData, BOOL store)
{
    if (sCourseSave == NULL) {
        return;
    }

    if (store) {
        CompletePokeathlon_Store(saveData, sCourseSave);
    }

    Heap_Free(sCourseSave);
    sCourseSave = NULL;
}

// HeartGold's Save_Pokeathlon_Get: the save's Pokéathlon block, here the course's copy of it
CompletePokeathlonSave *HgssCompat_Save_Pokeathlon_Get(SaveData *saveData)
{
    (void)saveData;
    GF_ASSERT(sCourseSave != NULL);
    return sCourseSave;
}

// HeartGold's PokeathlonSave_dummy2: the save's start, which the course reads its course records from (its unk_0,
// five of 0x2C bytes: ov96_021E786C writes one, ov96_021E8060 and the results screen read their totals)
CompletePokeathlonCourseRecord *HgssCompat_PokeathlonSave_GetCourseRecords(CompletePokeathlonSave *pokeathlon)
{
    return pokeathlon->courseRecords;
}

// HeartGold's PokeathlonSave_GetUnkDC: the medals, a byte a species ([species - 1]), a bit a course
u8 *HgssCompat_PokeathlonSave_GetMedals(CompletePokeathlonSave *pokeathlon)
{
    return pokeathlon->medals;
}

// HeartGold's PokeathlonSave_SetUnkDC_AtIndex: the courses' medals (a bit each in courses) to a species
void HgssCompat_PokeathlonSave_SetMedals(CompletePokeathlonSave *pokeathlon, int courses, int species)
{
    if (species < 1 || species > COMPLETE_POKEATHLON_MEDAL_SPECIES) {
        GF_ASSERT(FALSE);
        return;
    }

    pokeathlon->medals[species - 1] |= courses & ((1 << COMPLETE_POKEATHLON_COURSES) - 1);
}

// HeartGold's PokeathlonSave_GetUnkDC_AtIndex (overlay 97's medals): whether a species has a course's medal
BOOL HgssCompat_PokeathlonSave_GetMedal(CompletePokeathlonSave *pokeathlon, int course, int species)
{
    if (course < 0 || course >= COMPLETE_POKEATHLON_COURSES || species < 1 || species > COMPLETE_POKEATHLON_MEDAL_SPECIES) {
        GF_ASSERT(FALSE);
        return FALSE;
    }

    return (pokeathlon->medals[species - 1] >> course) & 1;
}

CompletePokeathlonRecordsSolo *HgssCompat_PokeathlonSave_GetRecordsSolo(CompletePokeathlonSave *pokeathlon)
{
    return pokeathlon->recordsSolo;
}

CompletePokeathlonRecordsLink *HgssCompat_PokeathlonSave_GetRecordsLink(CompletePokeathlonSave *pokeathlon)
{
    return pokeathlon->recordsLink;
}

// HeartGold's PokeathlonSave_GetUnkAEC: each event record's points
u16 *HgssCompat_PokeathlonSave_GetRecordPoints(CompletePokeathlonSave *pokeathlon)
{
    return pokeathlon->recordPoints;
}

// HeartGold's PokeathlonSave_GetUnkB00 and _GetAgainUnkB00: the totals the Dome's records show
CompletePokeathlonTotals *HgssCompat_PokeathlonSave_GetTotals(CompletePokeathlonSave *pokeathlon)
{
    return &pokeathlon->totals;
}

void HgssCompat_PokeathlonSave_AddAthletePoints(CompletePokeathlonSave *pokeathlon, u16 amount)
{
    CompletePokeathlon_AddAthletePoints(pokeathlon, amount);
}

// HeartGold's Save_Pokeathlon_FriendshipRecords_Get (its own save block there): the Friendship Room's statues, which
// Complete keeps at the end of its Pokéathlon save in HeartGold's layout
CompletePokeathlonStatue *HgssCompat_Save_Pokeathlon_FriendshipRecords_Get(SaveData *saveData)
{
    return HgssCompat_Save_Pokeathlon_Get(saveData)->friendshipRoomStatues;
}

// HeartGold's Apricorn Box save block also keeps the last three link partners' records (0x20 bytes each, from 0x20),
// which the course updates after link play (sub_020321A0) and reads to make the player's own (sub_020320E0). Complete
// keeps Apricorns in the bag and leaves link play out: the course's single-player path makes the player's record and
// frees it at its end, so there is no box to hand out.
#define HGSS_LINK_RECORD_SIZE 0x20

void *HgssCompat_Save_ApricornBox_Get(SaveData *saveData)
{
    (void)saveData;
    return NULL;
}

u32 HgssCompat_LinkRecordSize(void)
{
    return HGSS_LINK_RECORD_SIZE;
}

// HeartGold's sub_020320E0: the player's link record (trainer ID, gender, language, version, name, the trophies'
// count from the box (none here) and the Athlete Points earned in all), allocated
void *HgssCompat_NewLinkRecord(void *apricornBox, TrainerInfo *trainerInfo, u32 points, enum HeapID heapID)
{
    u8 *record = Heap_AllocAtEnd(heapID, HGSS_LINK_RECORD_SIZE);

    (void)apricornBox;
    MI_CpuFill8(record, 0, HGSS_LINK_RECORD_SIZE);
    *(u32 *)record = TrainerInfo_ID(trainerInfo);
    record[4] = TrainerInfo_Gender(trainerInfo);
    record[5] = TrainerInfo_Language(trainerInfo);
    record[6] = TrainerInfo_GameCode(trainerInfo);
    CharCode_FillWithEOS((charcode_t *)(record + 8), 8);
    CharCode_CopyNumChars((charcode_t *)(record + 8), TrainerInfo_Name(trainerInfo), 7);
    *(u16 *)(record + 0x18) = points > 0xFFFF ? 0xFFFF : points;

    return record;
}

// HeartGold's sub_020321A0: keeps the link partners' records in the box (none in single play: the player's own is
// skipped)
void HgssCompat_SaveLinkRecords(void *apricornBox, void *records, int count, int myID)
{
    (void)apricornBox;
    (void)records;
    (void)count;
    (void)myID;
}
