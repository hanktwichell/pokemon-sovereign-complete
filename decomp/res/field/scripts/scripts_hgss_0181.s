#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0331.h"

#define obj_R05R0202_gsmiddleman1 0

    ScriptEntry scr_seq_R05R0202_000
    ScriptEntry scr_seq_R05R0202_001
    ScriptEntryEnd
scr_seq_R05R0202_001:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    End
scr_seq_R05R0202_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00BE
    GoToIfSet FLAG_HGSS_UNK_164, _00D8
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _006E
    CheckItem ITEM_RAGECANDYBAR, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _005F
    Message msg_0331_R05R0202_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_005F:
    Message msg_0331_R05R0202_00001
    CloseMessage
    ApplyMovement obj_R05R0202_gsmiddleman1, _0100
    WaitMovement
_006E:
    Message msg_0331_R05R0202_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00E3
    CanFitItem ITEM_TM64, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00F4
    BufferPlayerName 0
    Message msg_0331_R05R0202_00003
    RemoveItem ITEM_RAGECANDYBAR, 1, VAR_RESULT
    Message msg_0331_R05R0202_00004
    CloseMessage
    SetVarFromValue VAR_0x8004, ITEM_TM64
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
_00BE:
    Message msg_0331_R05R0202_00005
    CloseMessage
    Message msg_0331_R05R0202_00006
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetFlag FLAG_HGSS_UNK_164
    ReleaseAll
    End
_00D8:
    Message msg_0331_R05R0202_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E3:
    Message msg_0331_R05R0202_00008
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    End
_00F4:
    Message msg_0331_R05R0202_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0100:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
