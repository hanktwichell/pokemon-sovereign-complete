#ifndef POKEPLATINUM_COMPLETE_BLOCKERS_H
#define POKEPLATINUM_COMPLETE_BLOCKERS_H

#include "field/field_system_decl.h"

// Sovereign Complete: the people who stand where Sinnoh's HMs used to hold the player back (the owner's note, Nov 6,
// 2026), placed by tools/complete/sinnoh_blockers.py, and Route 221's workers. Each group has a hide flag, set once
// what lifts it is reached.
enum CompleteBlockerUntil {
    COMPLETE_BLOCKER_UNTIL_FLAG = 0, // until a flag is set
    COMPLETE_BLOCKER_UNTIL_BADGE, // until a Sinnoh badge is won
    COMPLETE_BLOCKER_UNTIL_VAR, // until a var is at least a value
};

typedef struct CompleteBlocker {
    u16 hideFlag;
    u8 until;
    u16 param;
    u16 value;
} CompleteBlocker;

// Sets or clears each group's hide flag as a map loads: before its objects are made and its transition script runs
void CompleteBlockers_Update(FieldSystem *fieldSystem);

#endif // POKEPLATINUM_COMPLETE_BLOCKERS_H
