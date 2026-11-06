#include "complete_pokeathlon.h"

#include <nitro.h>

#include "constants/savedata/save_table.h"

#include "heap.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Pokéathlon save (include/complete_pokeathlon.h): the saved copy and the working copy,
// each in a save sector of its own, read and written whole as the photo album is

static u32 sSession; // this play session's mark, made the first time it's needed (a reset starts a new one)
static BOOL sChanged; // a change was stored since the game was last saved

#ifdef SOVEREIGN_TEST
u32 gCompleteTestPokeathlon[6];
u8 gCompleteTestPokeathlonRecordScreen[4]; // here as the record screens' overlay is reused when they close
CompletePokeathlonCourseRecord *gCompleteTestPokeathlonCourseRecords;
u8 *gCompleteTestPokeathlonMedals;
u16 gCompleteTestPokeathlonStatues[4];
#endif

// Sizes: one sector each, with its footer
typedef char CompletePokeathlonSizeCheck[(sizeof(CompletePokeathlonSave) + 16 <= 0x1000) ? 1 : -1];

static u32 Session(void)
{
    while (sSession == 0) {
        OSTick tick = OS_GetTick();

        sSession = (u32)tick ^ (u32)(tick >> 32) ^ 0x9E3779B9;
    }

    return sSession;
}

static void NoteForTests(const CompletePokeathlonSave *pokeathlon)
{
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlon[0] = pokeathlon->athletePoints;
    gCompleteTestPokeathlon[1] = pokeathlon->receivedDataCards;
    gCompleteTestPokeathlon[2] = pokeathlon->receivedDailyShopItems;
    gCompleteTestPokeathlon[3] = Session();
#endif
}

int CompletePokeathlon_SaveSize(void)
{
    return sizeof(CompletePokeathlonSave);
}

// HeartGold's PokeathlonSave_Init
void CompletePokeathlon_Init(CompletePokeathlonSave *pokeathlon)
{
    MI_CpuClear8(pokeathlon, sizeof(CompletePokeathlonSave));
    pokeathlon->magic = COMPLETE_POKEATHLON_MAGIC;

    for (int i = 0; i < COMPLETE_POKEATHLON_RECORDS; i++) {
        for (int j = 0; j < COMPLETE_POKEATHLON_COURSES; j++) {
            pokeathlon->recordsSolo[i].entries[j].unk_0 = 0xFFFF;
            pokeathlon->recordsLink[i].entries[j].unk_0 = 0xFFFF;
        }
    }
}

// This session's working copy if there is one, else the saved copy (an earlier save, before the Pokéathlon: a fresh one)
CompletePokeathlonSave *CompletePokeathlon_Load(SaveData *saveData, enum HeapID heapID)
{
    int result;
    CompletePokeathlonSave *pokeathlon = SaveDataExtra_Get(saveData, heapID, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON_WORK, &result);

    if (result != LOAD_RESULT_OK || pokeathlon->magic != COMPLETE_POKEATHLON_MAGIC || pokeathlon->session != Session()) {
        Heap_Free(pokeathlon);
        pokeathlon = SaveDataExtra_Get(saveData, heapID, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON, &result);

        if (result != LOAD_RESULT_OK || pokeathlon->magic != COMPLETE_POKEATHLON_MAGIC) {
            CompletePokeathlon_Init(pokeathlon);
        }
    }

    NoteForTests(pokeathlon);
    return pokeathlon;
}

void CompletePokeathlon_Store(SaveData *saveData, CompletePokeathlonSave *pokeathlon)
{
    // a fresh read first, so the write goes to the older of the two copies (as the Hall of Fame's does)
    int result;
    void *current = SaveDataExtra_Get(saveData, HEAP_ID_APPLICATION, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON_WORK, &result);

    Heap_Free(current);
    pokeathlon->magic = COMPLETE_POKEATHLON_MAGIC;
    pokeathlon->session = Session();
    SaveDataExtra_Save(saveData, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON_WORK, pokeathlon);
    sChanged = TRUE;
    NoteForTests(pokeathlon);
}

// From the save's end (src/savedata.c), once the main block is written: this session's changes are saved too
void CompletePokeathlon_Commit(SaveData *saveData)
{
    if (!sChanged) {
        return;
    }

    int result;
    void *current = SaveDataExtra_Get(saveData, HEAP_ID_APPLICATION, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON, &result);

    Heap_Free(current); // one buffer at a time: this can run where memory is short (the Hall of Fame's save)

    CompletePokeathlonSave *work = SaveDataExtra_Get(saveData, HEAP_ID_APPLICATION, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON_WORK, &result);

    if (result == LOAD_RESULT_OK && work->magic == COMPLETE_POKEATHLON_MAGIC && work->session == Session()) {
        SaveDataExtra_Save(saveData, EXTRA_SAVE_TABLE_ENTRY_COMPLETE_POKEATHLON, work);
        sChanged = FALSE;
    }

    Heap_Free(work);
}

// HeartGold's PokeathlonSave_ResetDailyItemReceivedFlags, with the day's other changes (FieldSystem_ClearDailyFlags)
void CompletePokeathlon_NewDay(SaveData *saveData)
{
    CompletePokeathlonSave *pokeathlon = CompletePokeathlon_Load(saveData, HEAP_ID_APPLICATION);

    if (pokeathlon->receivedDailyShopItems != 0) {
        pokeathlon->receivedDailyShopItems = 0;
        CompletePokeathlon_Store(saveData, pokeathlon);
    }

    Heap_Free(pokeathlon);
}

u32 CompletePokeathlon_GetAthletePoints(const CompletePokeathlonSave *pokeathlon)
{
    return pokeathlon->athletePoints;
}

void CompletePokeathlon_AddAthletePoints(CompletePokeathlonSave *pokeathlon, u16 amount)
{
    pokeathlon->athletePoints += amount;

    if (pokeathlon->athletePoints > COMPLETE_POKEATHLON_MAX_POINTS) {
        pokeathlon->athletePoints = COMPLETE_POKEATHLON_MAX_POINTS;
    }
}

void CompletePokeathlon_SubAthletePoints(CompletePokeathlonSave *pokeathlon, u16 amount)
{
    pokeathlon->athletePoints -= amount;

    if (pokeathlon->athletePoints < 0) {
        pokeathlon->athletePoints = 0;
    }
}

BOOL CompletePokeathlon_CheckReceivedDataCard(const CompletePokeathlonSave *pokeathlon, int card)
{
    GF_ASSERT(card < COMPLETE_POKEATHLON_DATA_CARDS);
    return (pokeathlon->receivedDataCards >> card) & 1;
}

void CompletePokeathlon_SetReceivedDataCard(CompletePokeathlonSave *pokeathlon, int card)
{
    GF_ASSERT(card < COMPLETE_POKEATHLON_DATA_CARDS);
    pokeathlon->receivedDataCards |= 1 << card;
}

BOOL CompletePokeathlon_CheckReceivedDailyItemSlot(const CompletePokeathlonSave *pokeathlon, int slot)
{
    return (pokeathlon->receivedDailyShopItems >> slot) & 1;
}

void CompletePokeathlon_SetReceivedDailyItemSlot(CompletePokeathlonSave *pokeathlon, int slot)
{
    pokeathlon->receivedDailyShopItems |= 1 << slot;
}
