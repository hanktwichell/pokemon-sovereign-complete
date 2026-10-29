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
    ScriptEntryEnd
scr_seq_T11_016:
    GoToIfUnset FLAG_HGSS_UNK_0A0, _0055
    ClearFlag FLAG_HGSS_UNK_0A0
_0055:
    GoToIfUnset FLAG_HGSS_UNK_189, _0066
    ClearFlag FLAG_HGSS_UNK_189
    End
_0066:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _00B5
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _00B5
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00B5
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _00BF
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _00BF
    SetFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    End
_00B5:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    End
_00BF:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    ClearFlag FLAG_HGSS_UNK_27F
    End
scr_seq_T11_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _034C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0360
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0142
    ApplyMovement LOCALID_PLAYER, _01D0
    ApplyMovement obj_T11_gsmiddleman1_2, _0208
    GoTo _016D
_0142:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _015D
    ApplyMovement LOCALID_PLAYER, _01E8
    GoTo _016D
_015D:
    ApplyMovement LOCALID_PLAYER, _01F4
    ApplyMovement obj_T11_gsmiddleman1_2, _0208
_016D:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0194
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0214
    WaitMovement
_0194:
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
    .balign 4, 0
_01D0:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01E8:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0208:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0214:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T11_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _034C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0360
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _029D
    ApplyMovement LOCALID_PLAYER, _0374
    ApplyMovement obj_T11_gsmiddleman1_3, _0208
    GoTo _02EB
_029D:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02B8
    ApplyMovement LOCALID_PLAYER, _01E8
    GoTo _02EB
_02B8:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _02DB
    ApplyMovement LOCALID_PLAYER, _01F4
    ApplyMovement obj_T11_gsmiddleman1_3, _0208
    GoTo _02EB
_02DB:
    ApplyMovement LOCALID_PLAYER, _038C
    ApplyMovement obj_T11_gsmiddleman1_3, _0208
_02EB:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0312
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0214
    WaitMovement
_0312:
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
_034C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0360:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0374:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_038C:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_T11_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_HIDE_SAFFRON_CITY_COPYCAT_HOUSE_CLEFAIRY_DOLL, _03BE
    Message msg_0529_T11_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03BE:
    Message msg_0529_T11_00003
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
    .balign 4, 0
