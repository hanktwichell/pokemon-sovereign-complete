#include "complete_blockers.h"

#include <nitro.h>

#include "field/field_system.h"

#include "save_player.h"
#include "script_manager.h"
#include "trainer_info.h"

#include "data/complete_blockers.h"

static BOOL Lifted(FieldSystem *fieldSystem, const CompleteBlocker *blocker)
{
    switch (blocker->until) {
    case COMPLETE_BLOCKER_UNTIL_FLAG:
        return FieldSystem_CheckFlag(fieldSystem, blocker->param);
    case COMPLETE_BLOCKER_UNTIL_BADGE:
        return TrainerInfo_HasBadge(SaveData_GetTrainerInfo(fieldSystem->saveData), blocker->param);
    case COMPLETE_BLOCKER_UNTIL_VAR:
        return *FieldSystem_GetVarPointer(fieldSystem, blocker->param) >= blocker->value;
    default:
        return TRUE;
    }
}

void CompleteBlockers_Update(FieldSystem *fieldSystem)
{
    for (int i = 0; i < NELEMS(sCompleteBlockers); i++) {
        if (Lifted(fieldSystem, &sCompleteBlockers[i])) {
            FieldSystem_SetFlag(fieldSystem, sCompleteBlockers[i].hideFlag);
        } else {
            FieldSystem_ClearFlag(fieldSystem, sCompleteBlockers[i].hideFlag);
        }
    }
}
