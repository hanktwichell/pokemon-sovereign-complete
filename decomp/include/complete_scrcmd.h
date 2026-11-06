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
BOOL CompleteScrCmd_CloseMessageIfOpen(ScriptContext *ctx);
BOOL CompleteScrCmd_GetShinyLeafCount(ScriptContext *ctx);
BOOL CompleteScrCmd_GiveShinyLeafCrown(ScriptContext *ctx);
BOOL CompleteScrCmd_ObjectSway(ScriptContext *ctx);
BOOL CompleteScrCmd_GiveLoanMon(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckReturnLoanMon(ScriptContext *ctx);
BOOL CompleteScrCmd_ReturnLoanMon(ScriptContext *ctx);
BOOL CompleteScrCmd_KenyaCheck(ScriptContext *ctx);
BOOL CompleteScrCmd_KenyaCheckPartyOrMailbox(ScriptContext *ctx);
BOOL CompleteScrCmd_TakeMonMail(ScriptContext *ctx);
BOOL CompleteScrCmd_SizeRecordCompare(ScriptContext *ctx);
BOOL CompleteScrCmd_SizeRecordUpdate(ScriptContext *ctx);
BOOL CompleteScrCmd_BufferRecordSize(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckJohtoDexComplete(ScriptContext *ctx);
BOOL CompleteScrCmd_GiveRandomSeal(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckLastBattleNotBeaten(ScriptContext *ctx);
BOOL CompleteScrCmd_GetObjectDir(ScriptContext *ctx);
BOOL CompleteScrCmd_SetObjectDir(ScriptContext *ctx);
BOOL CompleteScrCmd_RandomChance(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerInhibit(ScriptContext *ctx);
BOOL CompleteScrCmd_TunnelAccessoriesFull(ScriptContext *ctx);
BOOL CompleteScrCmd_TunnelRandomAccessory(ScriptContext *ctx);
BOOL CompleteScrCmd_TunnelBackdropsOwned(ScriptContext *ctx);
BOOL CompleteScrCmd_TunnelRandomBackdrop(ScriptContext *ctx);
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
BOOL CompleteScrCmd_PlacedGet(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckFieldMoveBadge(ScriptContext *ctx);
BOOL CompleteScrCmd_Headbutt(ScriptContext *ctx);
BOOL CompleteScrCmd_RockSmashFind(ScriptContext *ctx);
BOOL CompleteScrCmd_CanLearnHeadbutt(ScriptContext *ctx);
// src/overlay005/complete_move_tutor.c: the Battle Frontier's move tutors
BOOL CompleteScrCmd_TutorMovePages(ScriptContext *ctx);
BOOL CompleteScrCmd_TutorChooseMove(ScriptContext *ctx);
BOOL CompleteScrCmd_TutorMovePrice(ScriptContext *ctx);
BOOL CompleteScrCmd_WhirlpoolSteps(ScriptContext *ctx);
BOOL CompleteScrCmd_CountPartySpecies(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckKyogreGroudonInParty(ScriptContext *ctx);
BOOL CompleteScrCmd_PartyMonIsNotMine(ScriptContext *ctx);
BOOL CompleteScrCmd_GetEVTotal(ScriptContext *ctx);
BOOL CompleteScrCmd_CheckSeenAllUnownLetters(ScriptContext *ctx);
BOOL CompleteScrCmd_FindStarterSlot(ScriptContext *ctx);
BOOL CompleteScrCmd_GivePokemonAtLevel(ScriptContext *ctx);
BOOL CompleteScrCmd_CameronPhoto(ScriptContext *ctx);
BOOL CompleteScrCmd_CountSavedPhotos(ScriptContext *ctx);
BOOL CompleteScrCmd_OpenPhotoAlbum(ScriptContext *ctx);
BOOL CompleteScrCmd_PhotoAlbumIsFull(ScriptContext *ctx);
BOOL CompleteScrCmd_VoltorbFlip(ScriptContext *ctx);
BOOL CompleteScrCmd_MagnetTrain(ScriptContext *ctx);
BOOL CompleteScrCmd_LegendCinematic(ScriptContext *ctx);
BOOL CompleteRocketCostume_IsOn(void); // HeartGold's Rocket uniform on (FLAG_HGSS_SYS_ROCKET_COSTUME)

// HeartGold's alph_checks.c: what opens three of the Ruins of Alph chambers' north walls, used facing the wall from
// (6, 3)
enum CompleteAlphWallKey {
    COMPLETE_ALPH_WALL_ESCAPE_ROPE = 0, // the Kabuto chamber's (HeartGold's D24R0202)
    COMPLETE_ALPH_WALL_FLASH, // the Omanyte chamber's (D24R0204)
    COMPLETE_ALPH_WALL_WATER_STONE, // the Aerodactyl chamber's (D24R0206)
    COMPLETE_ALPH_WALL_KEYS,
};
#define COMPLETE_ALPH_WALL_SCRIPT 3 // the chamber's own script that opens it (HeartGold's D24R0202_002 and the others)

BOOL CompleteAlph_CanOpenWall(FieldSystem *fieldSystem, enum CompleteAlphWallKey key);

// Set by CompleteStartWildBattle for a shiny static encounter; CreateWildMon_Scripted (overlay006/wild_encounters.c)
// makes the next scripted wild Pokémon shiny and clears it.
extern BOOL gCompleteNextWildShiny;

#ifdef SOVEREIGN_TEST
// The Battle Frontier move tutors' last: pages of moves, entries in the list (with NEXT and QUIT), price asked, and the
// move chosen
extern u16 gCompleteTestTutor[4];
#endif

#endif // POKEPLATINUM_COMPLETE_SCRCMD_H
