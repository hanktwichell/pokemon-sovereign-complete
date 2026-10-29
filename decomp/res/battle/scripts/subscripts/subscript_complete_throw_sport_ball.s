#include "macros/btlcmd.inc"


    // Sovereign Complete: the Bug-Catching Contest's Sport Ball, as subscript_throw_safari_ball's
_000:
    // {0} used one {1}!
    PrintMessage BattleStrings_Text_PlayerUsedOneItem, TAG_TRNAME_ITEM, BTLSCR_ATTACKER, BTLSCR_MSG_TEMP
    Wait
    StartCatchMonTask CAPTURE_NORMAL
    WaitCatchMonTask
    CompareVarToValue OPCODE_FLAG_SET, BTLVAR_RESULT_MASK, BATTLE_RESULT_CAPTURED_MON, _end
    CompareVarToValue OPCODE_NEQ, BTLVAR_NUM_SAFARI_BALLS, 0, _end
    PlaySound BTLSCR_ATTACKER, SEQ_SE_DP_PINPON_sseq
    // Announcer: You’re out of Sport Balls! Game over!
    PrintMessage BattleStrings_Text_CompleteYoureOutOfSportBalls, TAG_NONE
    Wait
    WaitButtonABTime 30
    FadeOutBattle
    Wait
    UpdateVar OPCODE_FLAG_ON, BTLVAR_RESULT_MASK, BATTLE_RESULT_PLAYER_FLED

_end:
    End
