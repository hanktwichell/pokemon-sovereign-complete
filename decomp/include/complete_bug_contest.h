#ifndef POKEPLATINUM_COMPLETE_BUG_CONTEST_H
#define POKEPLATINUM_COMPLETE_BUG_CONTEST_H

#include "field/field_system_decl.h"

#include "field_script_context.h"
#include "pokemon.h"

#define BUG_CONTEST_SPORT_BALLS 20
#define BUG_CONTEST_MINUTES     20

typedef struct BugContestEncounter {
    u16 species;
    u8 minLevel;
    u8 maxLevel;
    u8 rate; // the slot's roll threshold: a roll of 0-99 picks the first slot it is at least
    u8 score;
} BugContestEncounter;

typedef struct BugContestantEntry {
    u8 national; // only with the National Dex
    u8 day; // only on this weekday, or any day (7)
    u16 species;
    u16 score;
    u16 randmod; // the score varies this much either way
} BugContestantEntry;

// The contest runs from the gate's start (BugContestAction 0) to the judging's end (BugContestAction 1).
BOOL CompleteBugContest_IsRunning(void);
u16 CompleteBugContest_GetSportBalls(void);
void CompleteBugContest_SetSportBalls(u16 sportBalls);
BOOL CompleteBugContest_HasCaught(void);
Pokemon *CompleteBugContest_GetCaughtMon(void);
void CompleteBugContest_KeepMon(Pokemon *mon);
void CompleteBugContest_GetEncounter(u16 *species, u8 *level);
BOOL CompleteBugContest_IsTimeUp(void);

BOOL CompleteScrCmd_BugContestAction(ScriptContext *ctx);
BOOL CompleteScrCmd_BufferBugContestWinner(ScriptContext *ctx);
BOOL CompleteScrCmd_JudgeBugContest(ScriptContext *ctx);
BOOL CompleteScrCmd_BufferBugContestMonNick(ScriptContext *ctx);
BOOL CompleteScrCmd_BugContestGetTimeLeft(ScriptContext *ctx);
BOOL CompleteScrCmd_IsBugContestantRegistered(ScriptContext *ctx);
BOOL CompleteScrCmd_BugContestNicknameStart(ScriptContext *ctx);
BOOL CompleteScrCmd_BugContestNicknameEnd(ScriptContext *ctx);

#endif // POKEPLATINUM_COMPLETE_BUG_CONTEST_H
