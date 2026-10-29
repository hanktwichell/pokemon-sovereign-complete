#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0511.h"

#define obj_T07SP0101_suit 0

    ScriptEntry scr_seq_T07SP0101_000
    ScriptEntry scr_seq_T07SP0101_001
    ScriptEntry scr_seq_T07SP0101_002
    ScriptEntry scr_seq_T07SP0101_003
    ScriptEntryEnd
scr_seq_T07SP0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0066
    ApplyMovement obj_T07SP0101_suit, _007C
    WaitMovement
    Message msg_0511_T07SP0101_00012
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 0, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_MAP_LOCAL_0x01, 2
    ReleaseAll
    End
_0066:
    Message msg_0511_T07SP0101_00010
    ApplyMovement obj_T07SP0101_suit, _007C
    WaitMovement
    Message msg_0511_T07SP0101_00011
    GoTo _00E4
    .balign 4, 0
_007C:
    FaceSouth
    EndMovement
    .balign 4, 0
_0084:
    FaceWest
    EndMovement
    .balign 4, 0
_008C:
    FaceEast
    EndMovement
scr_seq_T07SP0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _00B9
    Call _00EC
    GoTo _00C1
_00B9:
    ApplyMovement obj_T07SP0101_suit, _007C
_00C1:
    WaitMovement
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E1
    Message msg_0511_T07SP0101_00013
    GoTo _00E4
_00E1:
    Message msg_0511_T07SP0101_00011
_00E4:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00EC:
    GetPlayerMapPos VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x03
    GetPlayerMapPos VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x03
    CompareVar VAR_MAP_LOCAL_0x02, 6
    GoToIf 5, _0113
    ApplyMovement obj_T07SP0101_suit, _0084
    GoTo _0128
_0113:
    CompareVar VAR_MAP_LOCAL_0x02, 8
    GoToIf 5, _0128
    ApplyMovement obj_T07SP0101_suit, _008C
_0128:
    Return
scr_seq_T07SP0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0184
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0163
    Message msg_0511_T07SP0101_00006
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    GoTo _017C
_0163:
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 5, _0179
    Message msg_0511_T07SP0101_00007
    GoTo _017C
_0179:
    Message msg_0511_T07SP0101_00008
_017C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0184:
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _019A
    Message msg_0511_T07SP0101_00000
    GoTo _019D
_019A:
    Message msg_0511_T07SP0101_00009
_019D:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01D4
    Message msg_0511_T07SP0101_00003
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetVar VAR_0x8004, ITEM_COIN_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0511_T07SP0101_00004
    GoTo _00E4
_01D4:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Message msg_0511_T07SP0101_00005
    GoTo _00E4
scr_seq_T07SP0101_001:
    NPCMessage msg_0511_T07SP0101_00014
    End
    .balign 4, 0
