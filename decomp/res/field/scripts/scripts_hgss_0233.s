#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0381.h"


    ScriptEntry scr_seq_R32PC0101_000
    ScriptEntry scr_seq_R32PC0101_001
    ScriptEntry scr_seq_R32PC0101_002
    ScriptEntry scr_seq_R32PC0101_003
    ScriptEntry scr_seq_R32PC0101_004
    ScriptEntryEnd
scr_seq_R32PC0101_000:
    SetVarFromValue VAR_0x8007, 3
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_R32PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_OLD_ROD, _00BC
    Message msg_0381_R32PC0101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00C7
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00FE
    End
scr_seq_R32PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_LURE_BALL_FROM_ROUTE_32_KURT_FAN, _0109
    Message msg_0381_R32PC0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0114
    Message msg_0381_R32PC0101_00008
    GoTo _014B
scr_seq_R32PC0101_003:
    NPCMessage msg_0381_R32PC0101_00006
    End
scr_seq_R32PC0101_004:
    PlayCry SPECIES_WOOPER, 0
    NPCMessage msg_0381_R32PC0101_00013
    End
_00BC:
    Message msg_0381_R32PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00C7:
    Message msg_0381_R32PC0101_00014
    SetVar VAR_0x8004, ITEM_TM03
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _017F
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_OLD_ROD
    Message msg_0381_R32PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00FE:
    Message msg_0381_R32PC0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0109:
    Message msg_0381_R32PC0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0114:
    Message msg_0381_R32PC0101_00009
    SetVar VAR_0x8004, ITEM_LURE_BALL
    SetVar VAR_0x8005, 2
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0189
    Common_GiveItemQuantity
    Message msg_0381_R32PC0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_LURE_BALL_FROM_ROUTE_32_KURT_FAN
    End
_014B:
    SetVar VAR_0x8004, ITEM_LURE_BALL
    SetVar VAR_0x8005, 2
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0189
    Common_GiveItemQuantity
    Message msg_0381_R32PC0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_LURE_BALL_FROM_ROUTE_32_KURT_FAN
    End
_017F:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0189:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
