#ifndef POKEPLATINUM_COMPLETE_BADGES_H
#define POKEPLATINUM_COMPLETE_BADGES_H

#include "constants/hgss_badges.h"
#include "generated/badges.h"

#include "trainer_info.h"

// Johto's and Kanto's badges (BADGE_ID_HGSS_*), kept in the trainer info beside Sinnoh's.
BOOL CompleteBadges_Has(const TrainerInfo *info, int badge);
void CompleteBadges_Set(TrainerInfo *info, int badge);
int CompleteBadges_Count(const TrainerInfo *info);

// Whether the player may use the field move that Sinnoh's badge allows: with that badge, or with the badge that
// allows the same move in HeartGold.
BOOL CompleteBadges_AllowsFieldMove(const TrainerInfo *info, enum Badge sinnohBadge);

#endif // POKEPLATINUM_COMPLETE_BADGES_H
