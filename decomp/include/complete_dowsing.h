#ifndef POKEPLATINUM_COMPLETE_DOWSING_H
#define POKEPLATINUM_COMPLETE_DOWSING_H

#include "bg_window.h"
#include "field/field_system_decl.h"

#include "field_task.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Dowsing Machine, the key item the man in Ecruteak City's Dowsing Machine house
// gives. Used from the bag or on Y, it takes the field's bottom screen (in the Pokégear's or the Pokétch's place, until
// EXIT) for HeartGold's radar: hold the circle and its dots light up and its needles swing toward the nearest hidden
// item within 17 tiles, with a beep that rises as the item comes closer; within 8 tiles the needles point at it and
// the dots light brightest over it. Around the radar, HeartGold's touch-screen buttons: the A button with what A does
// (CHECK, TALK, FISHING or NEXT), touched to press A, and the running shoes, which make the player run without B
// (kept in the save, as HeartGold keeps them). HeartGold's overlay 28, written in C from pret's assembly
// (src/applications/complete_dowsing/), with its graphics from tools/complete/import_hgss_dowsing.py.

// src/complete_dowsing.c (main): whether the Dowsing Machine is on (it stays on through battles, menus and map
// changes, as HeartGold's touch-screen app does) and HeartGold's running shoes
BOOL CompleteDowsing_IsOn(void);
void CompleteDowsing_SetOn(BOOL on); // the field's bottom screen switches as the field runs (CompleteBottomScreen_TrySwitch)
BOOL CompleteDowsing_CanUse(FieldSystem *fieldSystem); // a bottom screen to take: a map with one, not hidden by a script
BOOL CompleteDowsing_FieldTask_Start(FieldTask *task); // a FieldTask: switch it on, from the bag or on Y
BOOL CompleteDowsing_RunningShoesOn(SaveData *saveData);
void CompleteDowsing_SetRunningShoes(SaveData *saveData, BOOL on);

// HeartGold's gSystem.simulatedInputs: buttons the touch screen presses, read with the pad's next frame (src/system.c)
extern u16 gCompleteSimulatedKeys;

#ifdef SOVEREIGN_TEST
// The screen as it runs (here, as an overlay's memory is reused): 1 while it's on the bottom screen, the radar's level
// (0 nothing within 17 tiles, 1-4 nearer), the nearest hidden item (x, z from the player, as s16), whether there's one,
// the needles' strength, the A button's label (0 CHECK, 1 TALK, 2 CHECK, 3 FISHING, 4 NEXT), whether the radar is
// held, the first needle's angle, the dots lit, the beep's pitch (as s16), the running shoes
extern u16 gCompleteTestDowsing[12];
#endif

// src/applications/complete_dowsing/dowsing.c (the complete_dowsing overlay, in the Pokétch's place): like the
// Pokégear, a task of its own until it's shut down
void CompleteDowsing_Create(FieldSystem *fieldSystem, BgConfig *bgConfig);
void CompleteDowsing_StartShutdown(void);
BOOL CompleteDowsing_IsShutdown(void);

#endif // POKEPLATINUM_COMPLETE_DOWSING_H
