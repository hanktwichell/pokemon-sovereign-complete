#ifndef POKEPLATINUM_COMPLETE_FOLLOWER_H
#define POKEPLATINUM_COMPLETE_FOLLOWER_H

#include "field/field_system.h"

// Sovereign Complete: following Pokémon. The lead party Pokémon walks behind the player as a map object with
// MOVEMENT_TYPE_FOLLOW_PLAYER, the movement Platinum's Amity Square and partner trainers use.
#define LOCALID_COMPLETE_FOLLOWER 0xF0

void CompleteFollower_Refresh(FieldSystem *fieldSystem);
// Whether the lead is too tall to follow in most buildings (HeartGold's flag).
BOOL CompleteFollower_IsTooTall(FieldSystem *fieldSystem);

#ifdef SOVEREIGN_TEST
// Test build: the follower's tile each field frame (u16 x, then u16 z; 0xFFFF, 0xFFFF when nobody follows), for
// tools/complete/test_follower.py.
extern u16 gCompleteTestFollowerTile[2];
void CompleteFollower_TestRecordTile(FieldSystem *fieldSystem);
#endif

#endif // POKEPLATINUM_COMPLETE_FOLLOWER_H
