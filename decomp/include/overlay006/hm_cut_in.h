#ifndef POKEPLATINUM_HM_CUT_IN_H
#define POKEPLATINUM_HM_CUT_IN_H

#include "field/field_system_decl.h"

#include "map_object.h"
#include "pokemon.h"
#include "sys_task_manager.h"

SysTask *HMCutIn_StartTask(FieldSystem *fieldSystem, BOOL isNotFly, Pokemon *shownPokemon, int playerGender);
int HMCutIn_IsFinished(SysTask *cutInTask);
void HMCutIn_EndTask(SysTask *cutInTask);
// Sovereign Complete: HeartGold's ScrCmd_775, Lance taking off from the Lake of Rage on his Dragonite: Fly's cut-in
// and take-off with HeartGold's Lance as the rider, the bird coming down for him (his object and the Dragonite's then
// hidden) instead of the player, and no fade at the end
SysTask *CompleteHMCutIn_StartLanceTask(FieldSystem *fieldSystem, Pokemon *shownPokemon, MapObject *lance, MapObject *dragonite);
SysTask *FieldTask_FlyLanding_InitTask(FieldSystem *fieldSystem, int playerGender);
int FlyLanding_IsAnimFinished(SysTask *sysTask);
void FlyLanding_SetTaskDone(SysTask *sysTask);

#endif // POKEPLATINUM_HM_CUT_IN_H
