#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0346.h"

#define obj_R11_kabigon 4
#define obj_R11_gsbabyboy1 7
#define obj_R11_gsbabyboy1_2 8
#define obj_R11_gsbabyboy1_3 9

    ScriptEntry scr_seq_R11_000
    ScriptEntry scr_seq_R11_001
    ScriptEntry scr_seq_R11_002
    ScriptEntry scr_seq_R11_003
    ScriptEntryEnd
scr_seq_R11_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _007A
    GoToIfSet FLAG_HGSS_SNORLAX_MEET, _0094
    End
scr_seq_R11_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_RESULT, FLAG_HGSS_GOT_EXPN_CARD
    CheckFlagFromVar VAR_RESULT, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0096
    Message msg_0346_R11_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R11_002:
    DrawSignpostInstantMessage msg_0346_R11_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R11_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0346_R11_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
_007A:
    SetFlag FLAG_HGSS_HIDE_ROUTE_11_SNORLAX
    RemoveObject obj_R11_kabigon
    RemoveObject obj_R11_gsbabyboy1_2
    RemoveObject obj_R11_gsbabyboy1
    RemoveObject obj_R11_gsbabyboy1_3
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0094:
    End
_0096:
    PlayCry SPECIES_SNORLAX, 0
    Message msg_0346_R11_00003
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_SNORLAX, 60, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E0
    CompleteGetBattleResult VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 4
    CallIf 1, _00E6
    SetFlag FLAG_HGSS_UNK_998
    SetFlag FLAG_HGSS_SNORLAX_MEET
    ReleaseAll
    End
_00E0:
    BlackOutFromBattle
    ReleaseAll
    End
_00E6:
    SetFlag FLAG_HGSS_CAUGHT_SNORLAX
    Return
    .balign 4, 0
