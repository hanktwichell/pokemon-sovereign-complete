#ifndef POKEPLATINUM_COMPLETE_SCRCMD_H
#define POKEPLATINUM_COMPLETE_SCRCMD_H

#include "field_script_context.h"

// Sovereign Complete: script commands for HeartGold's scripts (src/complete_scrcmd.c).
BOOL CompleteScrCmd_MessageGendered(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerPause(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerWait(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerSetMovementType(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerCheckActive(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerIsTooTall(ScriptContext *ctx);
BOOL CompleteScrCmd_StartJohtoStarterScene(ScriptContext *ctx);
BOOL CompleteScrCmd_GetChosenStarter(ScriptContext *ctx);
BOOL CompleteScrCmd_PlaceStarterBalls(ScriptContext *ctx);
BOOL CompleteScrCmd_NameHGSSRival(ScriptContext *ctx);
BOOL CompleteScrCmd_BufferHGSSRivalName(ScriptContext *ctx);
BOOL CompleteScrCmd_JohtoClearGame(ScriptContext *ctx);
BOOL CompleteScrCmd_GetBattleResult(ScriptContext *ctx);
BOOL CompleteScrCmd_StartWildBattle(ScriptContext *ctx);
BOOL CompleteScrCmd_InitHGSSMenu(ScriptContext *ctx);
BOOL CompleteScrCmd_GetElevatorFloor(ScriptContext *ctx);
BOOL CompleteScrCmd_BufferFloorName(ScriptContext *ctx);
BOOL CompleteScrCmd_GiveTogepiEgg(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckStaticNotBeaten(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerPutAway(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerReturn(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerPlace(ScriptContext *ctx);
BOOL CompleteScrCmd_GetFriendSprite(ScriptContext *ctx);
BOOL CompleteScrCmd_AlphPuzzle(ScriptContext *ctx);
BOOL CompleteScrCmd_ScreenShake(ScriptContext *ctx);
BOOL CompleteScrCmd_SetHGSSFlagFromVar(ScriptContext *ctx);
BOOL CompleteScrCmd_ClearHGSSFlagFromVar(ScriptContext *ctx);
BOOL CompleteScrCmd_MonAddContestValue(ScriptContext *ctx);
BOOL CompleteScrCmd_GiveBadge(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckBadge(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckFieldMoveBadge(ScriptContext *ctx);
BOOL CompleteScrCmd_Headbutt(ScriptContext *ctx);
BOOL CompleteScrCmd_RockSmashFind(ScriptContext *ctx);
BOOL CompleteScrCmd_CanLearnHeadbutt(ScriptContext *ctx);
BOOL CompleteScrCmd_WhirlpoolSteps(ScriptContext *ctx);
BOOL CompleteScrCmd_CountPartySpecies(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckKyogreGroudonInParty(ScriptContext *ctx);
BOOL CompleteScrCmd_PartyMonIsNotMine(ScriptContext *ctx);
BOOL CompleteScrCmd_GetEVTotal(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckSeenAllUnownLetters(ScriptContext *ctx);

// Set by CompleteStartWildBattle for a shiny static encounter; CreateWildMon_Scripted (overlay006/wild_encounters.c)
// makes the next scripted wild Pokémon shiny and clears it.
extern BOOL gCompleteNextWildShiny;

#endif // POKEPLATINUM_COMPLETE_SCRCMD_H
