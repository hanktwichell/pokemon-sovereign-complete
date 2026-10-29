#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0405.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R45_gsmiddleman1 14

    ScriptEntry scr_seq_R45_000
    ScriptEntry scr_seq_R45_001
    ScriptEntry scr_seq_R45_002
    ScriptEntry scr_seq_R45_003
    ScriptEntry scr_seq_R45_004
    ScriptEntryEnd
scr_seq_R45_002:
    GoToIfUnset FLAG_HGSS_UNK_189, _0027
    ClearFlag FLAG_HGSS_UNK_189
    End
_0027:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _004B
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _004B
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_004B:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_R45_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0133
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0147
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00C2
    ApplyMovement LOCALID_PLAYER, _015C
    GoTo _00D2
_00C2:
    ApplyMovement LOCALID_PLAYER, _0168
    ApplyMovement obj_R45_gsmiddleman1, _017C
_00D2:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00F9
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0188
    WaitMovement
_00F9:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 47
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
_0133:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0147:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_015C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0168:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_017C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0188:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R45_003:
    NPCMessage msg_0405_R45_00000
    End
scr_seq_R45_000:
    DrawSignpostInstantMessage msg_0405_R45_00001, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R45_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0405_R45_00002, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
