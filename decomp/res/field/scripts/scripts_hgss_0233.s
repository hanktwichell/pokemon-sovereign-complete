#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0381.h"


    ScriptEntry scr_seq_R32PC0101_000
    ScriptEntry scr_seq_R32PC0101_001
    ScriptEntry scr_seq_R32PC0101_002
    ScriptEntry scr_seq_R32PC0101_003
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
    GoToIfSet FLAG_HGSS_GOT_OLD_ROD, _008C
    Message msg_0381_R32PC0101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0058
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00A1
    End
_0058:
    SetVar VAR_0x8004, ITEM_OLD_ROD
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0097
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_OLD_ROD
    Message msg_0381_R32PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_008C:
    Message msg_0381_R32PC0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0097:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_00A1:
    Message msg_0381_R32PC0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R32PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_LURE_BALL_FROM_ROUTE_32_KURT_FAN, _0121
    Message msg_0381_R32PC0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00E0
    Message msg_0381_R32PC0101_00008
    GoTo _00E3
_00E0:
    Message msg_0381_R32PC0101_00009
_00E3:
    SetVar VAR_0x8004, ITEM_LURE_BALL
    SetVar VAR_0x8005, 2
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0117
    Common_GiveItemQuantity
    Message msg_0381_R32PC0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_LURE_BALL_FROM_ROUTE_32_KURT_FAN
    End
_0117:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0121:
    Message msg_0381_R32PC0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R32PC0101_003:
    NPCMessage msg_0381_R32PC0101_00006
    End
    .balign 4, 0
