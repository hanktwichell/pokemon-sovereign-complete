#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0387.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R35_gsmiddleman1 12

    ScriptEntry scr_seq_R35_000
    ScriptEntry scr_seq_R35_001
    ScriptEntry scr_seq_R35_002
    ScriptEntry scr_seq_R35_003
    ScriptEntry scr_seq_R35_004
    ScriptEntryEnd
scr_seq_R35_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _0027
    ClearFlag FLAG_HGSS_UNK_189
    End
_0027:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _005C
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _005C
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _005C
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0060
_005C:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
_0060:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0088
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0088
    ClearFlag FLAG_HGSS_UNK_1CD
    SetFlag FLAG_HGSS_UNK_1CE
    End
_0088:
    ClearFlag FLAG_HGSS_UNK_1CE
    SetFlag FLAG_HGSS_UNK_1CD
    End
scr_seq_R35_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0197
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01AB
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _010B
    ApplyMovement LOCALID_PLAYER, _01C0
    ApplyMovement obj_R35_gsmiddleman1, _01F4
    GoTo _0136
_010B:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0126
    ApplyMovement LOCALID_PLAYER, _01D4
    GoTo _0136
_0126:
    ApplyMovement LOCALID_PLAYER, _01E0
    ApplyMovement obj_R35_gsmiddleman1, _01F4
_0136:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _015D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0200
    WaitMovement
_015D:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 11
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
_0197:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AB:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01C0:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01D4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01E0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F4:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0200:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R35_000:
    DrawSignpostInstantMessage msg_0387_R35_00028, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R35_004:
    DrawSignpostInstantMessage msg_0387_R35_00029, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R35_002:
    NPCMessage msg_0387_R35_00021
    End
    .balign 4, 0
