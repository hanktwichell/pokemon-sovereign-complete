#ifndef POKEPLATINUM_COMPLETE_PLAYTEST_H
#define POKEPLATINUM_COMPLETE_PLAYTEST_H

#include "field/field_system_decl.h"

#include "generated/badges.h"

// The playtest build (meson option complete_playtest, tools/complete/make_playtest_patch.sh): the story plays as in
// the release, but a new game starts with a team to travel with (Cynthia's Garchomp at Lv. 80, Staraptor with Fly
// and Empoleon with Surf, both Lv. 50) and every town's Fly point, and Fly and Surf need no badge.
#ifdef COMPLETE_PLAYTEST
void CompletePlaytest_SetupNewGame(FieldSystem *fieldSystem);
BOOL CompletePlaytest_AllowsFieldMove(enum Badge sinnohBadge);
#endif

#endif // POKEPLATINUM_COMPLETE_PLAYTEST_H
