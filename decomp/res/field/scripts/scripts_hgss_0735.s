#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0446.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T01_gsmiddleman1 2

    ScriptEntry scr_seq_T01_000
    ScriptEntry scr_seq_T01_001
    ScriptEntry scr_seq_T01_002
    ScriptEntry scr_seq_T01_003
    ScriptEntry scr_seq_T01_004
    ScriptEntry scr_seq_T01_005
    ScriptEntry scr_seq_T01_006
    ScriptEntry scr_seq_T01_007
    ScriptEntryEnd
scr_seq_T01_007:
    GoToIfUnset FLAG_HGSS_UNK_189, _0033
    ClearFlag FLAG_HGSS_UNK_189
    End
_0033:
    GoToIfSet FLAG_HGSS_GOT_HM08, _0044
    GoTo _004A
_0044:
    SetVarFromValue VAR_HGSS_UNK_4096, 0
_004A:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _007B
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _007B
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _007B
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_007B:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T01_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01A9
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01BD
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00FA
    ApplyMovement LOCALID_PLAYER, _01D4
    ApplyMovement obj_T01_gsmiddleman1, _0220
    GoTo _0148
_00FA:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0115
    ApplyMovement LOCALID_PLAYER, _01EC
    GoTo _0148
_0115:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0138
    ApplyMovement LOCALID_PLAYER, _020C
    ApplyMovement obj_T01_gsmiddleman1, _0220
    GoTo _0148
_0138:
    ApplyMovement LOCALID_PLAYER, _01F8
    ApplyMovement obj_T01_gsmiddleman1, _0220
_0148:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _016F
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _022C
    WaitMovement
_016F:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 73
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A9:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01BD:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01D4:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01EC:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F8:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_020C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0220:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_022C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T01_000:
    NPCMessage msg_0446_T01_00000
    End
scr_seq_T01_001:
    NPCMessage msg_0446_T01_00001
    End
scr_seq_T01_002:
    DrawSignpostInstantMessage msg_0446_T01_00002, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T01_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0446_T01_00003, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T01_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0446_T01_00004, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T01_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0446_T01_00005, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
