#ifndef POKEPLATINUM_COMPLETE_FOLLOWER_TALK_H
#define POKEPLATINUM_COMPLETE_FOLLOWER_TALK_H

#include "constants/complete_follower_talk.h"

#include "field_script_context.h"

// Sovereign Complete: talking to the following Pokémon, as in HeartGold (src/overlay006/complete_follower_talk.c). The
// follower's script (CommonScript_CompleteFollowerTalk):
#define COMPLETE_FOLLOWER_TALK (0x815 - 0x7D0)

BOOL CompleteScrCmd_FollowerTalkStart(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerTalkStep(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerTalkAnswer(ScriptContext *ctx);
BOOL CompleteScrCmd_FollowerTalkEnd(ScriptContext *ctx);

#endif // POKEPLATINUM_COMPLETE_FOLLOWER_TALK_H
