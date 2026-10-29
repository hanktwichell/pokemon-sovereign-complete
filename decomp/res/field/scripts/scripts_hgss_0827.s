#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0529.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T11_gsmiddleman1_2 8
#define obj_T11_gsmiddleman1_3 9

    ScriptEntry scr_seq_T11_000
    ScriptEntry scr_seq_T11_001
    ScriptEntry scr_seq_T11_002
    ScriptEntry scr_seq_T11_003
    ScriptEntry scr_seq_T11_004
    ScriptEntry scr_seq_T11_005
    ScriptEntry scr_seq_T11_006
    ScriptEntry scr_seq_T11_007
    ScriptEntry scr_seq_T11_008
    ScriptEntry scr_seq_T11_009
    ScriptEntry scr_seq_T11_010
    ScriptEntry scr_seq_T11_011
    ScriptEntry scr_seq_T11_012
    ScriptEntry scr_seq_T11_013
    ScriptEntry scr_seq_T11_014
    ScriptEntry scr_seq_T11_015
    ScriptEntry scr_seq_T11_016
    ScriptEntry scr_seq_T11_017
    ScriptEntryEnd
scr_seq_T11_016:
    GoToIfUnset FLAG_HGSS_UNK_0A0, _0292
    ClearFlag FLAG_HGSS_UNK_0A0
    GoToIfUnset FLAG_HGSS_UNK_189, _02A3
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T11_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02F2
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0306
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _031A
    ApplyMovement LOCALID_PLAYER, _05AA
    ApplyMovement obj_T11_gsmiddleman1_2, _05C0
    GoTo _0335
scr_seq_T11_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02F2
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0306
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0396
    ApplyMovement LOCALID_PLAYER, _05CA
    ApplyMovement obj_T11_gsmiddleman1_3, _05C0
    GoTo _03B1
scr_seq_T11_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL, _0412
    Message msg_0529_T11_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11_000:
    NPCMessage msg_0529_T11_00000
    End
scr_seq_T11_001:
    NPCMessage msg_0529_T11_00001
    End
scr_seq_T11_003:
    NPCMessage msg_0529_T11_00004
    End
scr_seq_T11_004:
    NPCMessage msg_0529_T11_00005
    End
scr_seq_T11_005:
    NPCMessage msg_0529_T11_00006
    End
scr_seq_T11_006:
    NPCMessage msg_0529_T11_00007
    End
scr_seq_T11_007:
    NPCMessage msg_0529_T11_00008
    End
scr_seq_T11_008:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0529_T11_00009, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T11_009:
    DrawSignpostInstantMessage msg_0529_T11_00010, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T11_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0529_T11_00011, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T11_011:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0529_T11_00012, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T11_012:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0529_T11_00013, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T11_013:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0529_T11_00014, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T11_017:
    NPCMessage msg_0529_T11_00015
    End
_0292:
    GoToIfUnset FLAG_HGSS_UNK_189, _02A3
    ClearFlag FLAG_HGSS_UNK_189
    End
_02A3:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _041D
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _041D
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _041D
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0427
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0427
    SetFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    End
_02F2:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0306:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031A:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0431
    ApplyMovement LOCALID_PLAYER, _05E0
    GoTo _0335
_0335:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04A2
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05EA
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 52
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
_0396:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04DC
    ApplyMovement LOCALID_PLAYER, _05E0
    GoTo _03B1
_03B1:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04FF
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05EA
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 53
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
_0412:
    Message msg_0529_T11_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_041D:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    End
_0427:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    ClearFlag FLAG_HGSS_UNK_27F
    End
_0431:
    ApplyMovement LOCALID_PLAYER, _05F8
    ApplyMovement obj_T11_gsmiddleman1_2, _05C0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04A2
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05EA
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 52
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
_04A2:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 52
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
_04DC:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0539
    ApplyMovement LOCALID_PLAYER, _05F8
    ApplyMovement obj_T11_gsmiddleman1_3, _05C0
    GoTo _03B1
_04FF:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 53
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
_0539:
    ApplyMovement LOCALID_PLAYER, _060A
    ApplyMovement obj_T11_gsmiddleman1_3, _05C0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04FF
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05EA
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 53
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
    .balign 4, 0
_05AA:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05C0:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_05CA:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05E0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05EA:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_05F8:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_060A:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
