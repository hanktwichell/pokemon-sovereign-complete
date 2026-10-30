#ifndef POKEPLATINUM_COMPLETE_FOLLOWER_H
#define POKEPLATINUM_COMPLETE_FOLLOWER_H

#include "field/field_system.h"

// Sovereign Complete: following Pokémon. The lead party Pokémon walks behind the player as a map object with
// MOVEMENT_TYPE_FOLLOW_PLAYER, the movement Platinum's Amity Square and partner trainers use.
#define LOCALID_COMPLETE_FOLLOWER 0xF0

void CompleteFollower_Refresh(FieldSystem *fieldSystem);
// Each field frame the player has control: the follower is made again when it isn't the one wanted.
void CompleteFollower_Update(FieldSystem *fieldSystem);
// Whether the lead is too tall to follow in most buildings (HeartGold's flag).
BOOL CompleteFollower_IsTooTall(FieldSystem *fieldSystem);

#ifdef SOVEREIGN_TEST
// Test build: the follower's tile each field frame (u16 x, then u16 z; 0xFFFF, 0xFFFF when nobody follows), for
// tools/complete/test_follower.py.
extern u16 gCompleteTestFollowerTile[2];
// Test build: the follower's graphics (0xFFFF: nobody follows), and what a test asks the field to do on its next free
// frame: the party's first two Pokémon swap places, or the player gets on or off the bike.
extern u16 gCompleteTestFollowerGfx;
extern u8 gCompleteTestFollowerAction;

enum CompleteTestFollowerAction {
    COMPLETE_TEST_FOLLOWER_NONE = 0,
    COMPLETE_TEST_FOLLOWER_SWAP_LEAD,
    COMPLETE_TEST_FOLLOWER_BICYCLE,
};
void CompleteFollower_TestRecordTile(FieldSystem *fieldSystem);
#endif

#endif // POKEPLATINUM_COMPLETE_FOLLOWER_H
