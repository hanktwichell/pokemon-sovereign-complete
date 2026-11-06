#ifndef POKEPLATINUM_COMPLETE_BERRY_POTS_H
#define POKEPLATINUM_COMPLETE_BERRY_POTS_H

#include "field/field_system_decl.h"

#include "bag.h"
#include "bag_context.h"
#include "berry_patches.h"
#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Berry Pots, the key item a girl on Route 36 gives. Four pots the player
// carries: plant a Berry, water it, lay down Mulch, pick the Berries, on HeartGold's screen (its overlay 17,
// src/applications/complete_berry_pots/) with HeartGold's growth rules (its overlay 16), which go by the minutes passed
// since the screen last opened, not by the field's clock as Sinnoh's soft soil does.
//
// The pots are four of the save's berry patches that Sinnoh's soil doesn't use (its patches are 0 to 117), field for
// field as HeartGold's pots: berryID, growthStage, stageMinutesRemaining (the stage's minutes left),
// moistureMinutesRemaining (the minutes toward the next hour of drying), yield, replantCount, moistureRating
// (0-100), yieldRating and mulchType mean what HeartGold's BerryPot fields do. isGrowing stays FALSE, so Platinum's own
// growth (BerryPatches_ElapseMinutes) leaves them be. The time they last grew is in Complete's phone save
// (CompletePhoneSave.berryPotsTime). A new game leaves junk in these patches (and so did one from before the pots):
// they're emptied the first time the pots open, while that time is still unset.

#define COMPLETE_BERRY_POTS_FIRST_PATCH 124
#define COMPLETE_BERRY_POT_COUNT        4

// What the pots' screen and the bag hand each other (HeartGold's BerryPotsAppArgs, the manager's own fields)
enum CompleteBerryPotsRequest {
    COMPLETE_BERRY_POTS_REQUEST_NONE = 0, // the screen closed
    COMPLETE_BERRY_POTS_REQUEST_MULCH, // the bag's Items pocket, for Mulch
    COMPLETE_BERRY_POTS_REQUEST_BERRY, // the bag's Berries pocket, for a Berry to plant
};

typedef struct CompleteBerryPotsArgs {
    SaveData *saveData;
    int *menuInputState; // the touch screen or the buttons, last used (HeartGold's MenuInputStateMgr)
    u8 request; // enum CompleteBerryPotsRequest, set by the screen as it closes
    u8 pot; // the pot it's for
    u16 itemId; // the item the bag gave back, 0xFFFF for none
    ApplicationManager *app; // the screen or the bag, running
    BagContext *bagContext;
} CompleteBerryPotsArgs;

// src/complete_berry_pots.c (main)
BerryPatch *CompleteBerryPots_Get(SaveData *saveData);
u8 *CompleteBerryPots_Time(SaveData *saveData); // an RTCDate and RTCTime, 28 bytes, unaligned (copy them out)
void CompleteBerryPots_Launch(FieldSystem *fieldSystem); // the pots' screen as the field's application
void *CompleteBerryPots_LaunchRegistered(void *fieldSystem); // the same, for the registered item (Y)
BOOL CompleteBerryPots_ManagerInit(ApplicationManager *appMan, int *state);
BOOL CompleteBerryPots_ManagerMain(ApplicationManager *appMan, int *state);
BOOL CompleteBerryPots_ManagerExit(ApplicationManager *appMan, int *state);

// src/applications/complete_berry_pots/ (overlay complete_berry_pots): the screen
BOOL CompleteBerryPotsApp_Init(ApplicationManager *appMan, int *state);
BOOL CompleteBerryPotsApp_Main(ApplicationManager *appMan, int *state);
BOOL CompleteBerryPotsApp_Exit(ApplicationManager *appMan, int *state);

#endif // POKEPLATINUM_COMPLETE_BERRY_POTS_H
