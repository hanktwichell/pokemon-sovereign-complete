#include "macros/btlcmd.inc"

// Sovereign Complete: a Pledge user waits for its ally's different Pledge, which acts next as the combined Pledge
// (BattleControllerPlayer_BeforeMove; BTLSCR_MSG_TEMP is the ally).

_000:
    // {0} is waiting for {1}’s move...
    PrintMessage BattleStrings_Text_CompletePledgeWaiting_AllyAlly, TAG_NICKNAME_NICKNAME, BTLSCR_ATTACKER, BTLSCR_MSG_TEMP
    Wait
    WaitButtonABTime 30
    End
