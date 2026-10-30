#ifndef POKEPLATINUM_COMPLETE_SOUND_H
#define POKEPLATINUM_COMPLETE_SOUND_H

#include "generated/map_headers.h"

#include "field_battle_data_transfer.h"
#include "sound.h"
#include "vars_flags.h"

// Sovereign Complete: HeartGold's songs in the engine's sound code (docs/Music.md; src/complete_sound.c)
BOOL CompleteSound_HasOwnBank(u16 seqID);
u16 CompleteSound_FieldBankSequence(u16 seqID, u16 fieldBGM);
BOOL CompleteSound_FieldBankChanges(u16 seqID, u16 loadedBankID);
u16 CompleteSound_ForMap(enum MapHeaderID mapHeaderID, u16 seqID);
u16 CompleteSound_AltMusicForHeader(VarsFlags *varsFlags, enum MapHeaderID mapHeaderID);
u16 CompleteSound_EncounterBGM(u16 trainerID, u32 trainerClass);
u16 CompleteSound_BattleBGM(const FieldBattleDTO *dto);
u16 CompleteSound_TrainerVictoryBGM(int mapHeaderID, u32 trainerClass);
u16 CompleteSound_WildVictoryBGM(int mapHeaderID);

#endif // POKEPLATINUM_COMPLETE_SOUND_H
