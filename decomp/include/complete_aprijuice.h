#ifndef POKEPLATINUM_COMPLETE_APRIJUICE_H
#define POKEPLATINUM_COMPLETE_APRIJUICE_H

#include "constants/heap.h"

#include "field/field_system_decl.h"

#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Apricorn Box app (its overlays 58 and 59, assembled as they are in the overlays
// complete_aprijuice and complete_aprijuice_box, with its Apricorn Box save code: decomp/asm/complete_hgss/), which the
// Aprijuice stand's clerks open to give a party Pokémon the juice of the day and the Apricorn Box opens from the bag
// (its Apriblender). Its shims are in src/applications/complete_pokeathlon/hgss_compat_apricorn.c (the overlay
// complete_hgss_compat): the Apricorns are the bag's, the box and each party Pokémon's juice in the Pokéathlon's save.

enum HgssApricornBoxMode {
    HGSS_APRICORN_BOX_MODE_VIEW = 0, // HeartGold's 0 and 1: the box and its Apriblender, from the bag
    HGSS_APRICORN_BOX_MODE_BAG = 1,
    HGSS_APRICORN_BOX_MODE_KURT = 2, // Kurt takes Apricorns (Complete's Kurt uses the bag instead: unused)
    HGSS_APRICORN_BOX_MODE_STAND = 3, // the stand's juice, given to a party Pokémon
};

// HeartGold's ApricornBoxArgs
typedef struct HgssApricornBoxArgs {
    u8 mode;
    u8 unk1[7];
    u16 *result; // the stand's: whether a Pokémon drank the juice
    u32 juice; // the stand's: which juice (ScrCmd_741's index)
    u32 steps; // the steps walked (RECORD_STEPS), which make the Apriblender's juice
    void *menuInputState; // HeartGold's MenuInputStateMgr: a word, keys (0) or touch (1)
    SaveData *saveData;
} HgssApricornBoxArgs;

// The app, run from the field with the overlay complete_hgss_compat (its template's): it loads complete_aprijuice,
// opens the Pokéathlon's save, brings the Apriblender's juice up to the steps walked, runs HeartGold's app, then stores
// the save and unloads the overlay
BOOL HgssCompat_ApricornBoxApp_Init(ApplicationManager *appMan, int *state);
BOOL HgssCompat_ApricornBoxApp_Main(ApplicationManager *appMan, int *state);
BOOL HgssCompat_ApricornBoxApp_Exit(ApplicationManager *appMan, int *state);

// The box from the bag (src/complete_aprijuice.c, the main module): HeartGold's Apricorn Box item, from its menu or
// registered to Y
void CompleteApricornBox_Launch(FieldSystem *fieldSystem);
void *CompleteApricornBox_LaunchRegistered(void *fieldSystem);

#endif // POKEPLATINUM_COMPLETE_APRIJUICE_H
