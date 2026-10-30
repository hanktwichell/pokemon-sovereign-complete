#include "complete_badges.h"

#include <nitro.h>

#include "trainer_info.h"

// The badge that allows each of Sinnoh's field moves in HeartGold (its src/field_move.c), by Sinnoh's badge. Defog
// isn't a field move there: only Sinnoh's Relic Badge allows it.
static const s8 sHGSSFieldMoveBadges[MAX_BADGES] = {
    [BADGE_ID_COAL] = BADGE_ID_HGSS_ZEPHYR, // Rock Smash
    [BADGE_ID_FOREST] = BADGE_ID_HGSS_HIVE, // Cut
    [BADGE_ID_COBBLE] = BADGE_ID_HGSS_STORM, // Fly
    [BADGE_ID_FEN] = BADGE_ID_HGSS_FOG, // Surf
    [BADGE_ID_RELIC] = -1, // Defog
    [BADGE_ID_MINE] = BADGE_ID_HGSS_PLAIN, // Strength
    [BADGE_ID_ICICLE] = BADGE_ID_HGSS_EARTH, // Rock Climb
    [BADGE_ID_BEACON] = BADGE_ID_HGSS_RISING, // Waterfall
};

BOOL CompleteBadges_Has(const TrainerInfo *info, int badge)
{
    return (info->hgssBadgeMask & (1 << badge)) != 0;
}

void CompleteBadges_Set(TrainerInfo *info, int badge)
{
    info->hgssBadgeMask |= 1 << badge;
}

int CompleteBadges_Count(const TrainerInfo *info)
{
    int count = 0;

    for (u32 mask = info->hgssBadgeMask; mask != 0; mask >>= 1) {
        count += mask & 1;
    }

    return count;
}

BOOL CompleteBadges_AllowsFieldMove(const TrainerInfo *info, enum Badge sinnohBadge)
{
    if (TrainerInfo_HasBadge(info, sinnohBadge)) {
        return TRUE;
    }

    return sHGSSFieldMoveBadges[sinnohBadge] >= 0 && CompleteBadges_Has(info, sHGSSFieldMoveBadges[sinnohBadge]);
}
