#ifndef POKEPLATINUM_CONSTANTS_COMPLETE_FOLLOWER_TALK_H
#define POKEPLATINUM_CONSTANTS_COMPLETE_FOLLOWER_TALK_H

// Sovereign Complete: what CompleteFollowerTalkStep leaves in its destVar (src/overlay006/complete_follower_talk.c)
#define FOLLOWER_TALK_END      0 // nothing more: the talk is over
#define FOLLOWER_TALK_MESSAGE  1 // a message is up: wait for a button, close it, and go on
#define FOLLOWER_TALK_QUESTION 2 // a message ending in a question is up: a yes or no, then CompleteFollowerTalkAnswer
#define FOLLOWER_TALK_CONTINUE 3 // a step with no message ran: go on

#endif // POKEPLATINUM_CONSTANTS_COMPLETE_FOLLOWER_TALK_H
