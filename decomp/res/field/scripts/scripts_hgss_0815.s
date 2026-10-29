#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0519.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T09_gsleader16 0
#define obj_T09_gsleader15 1

    ScriptEntry scr_seq_T09_000
    ScriptEntry scr_seq_T09_001
    ScriptEntry scr_seq_T09_002
    ScriptEntry scr_seq_T09_003
    ScriptEntry scr_seq_T09_004
    ScriptEntryEnd
scr_seq_T09_003:
    GoToIfUnset FLAG_HGSS_UNK_189, _0027
    ClearFlag FLAG_HGSS_UNK_189
    End
_0027:
    GoToIfSet FLAG_HGSS_UNK_129, _0038
    SetFlag FLAG_HGSS_UNK_27D
    End
_0038:
    SetFlag FLAG_HGSS_UNK_25A
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BLUE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _007B
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 1, _007B
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 5, _0077
    ClearFlag FLAG_HGSS_UNK_25A
    GoTo _007B
_0077:
    SetFlag FLAG_HGSS_UNK_25A
_007B:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BLAINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00CC
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _00A9
    GoTo _0102
    End
_00A9:
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 2
    GoToIf 5, _00C4
    ClearFlag FLAG_HGSS_UNK_27D
    GoTo _00CA
_00C4:
    GoTo _0102
_00CA:
    End
_00CC:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BLAINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0102
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 5, _00FA
    ClearFlag FLAG_HGSS_UNK_27D
    GoTo _0100
_00FA:
    GoTo _0102
_0100:
    End
_0102:
    SetFlag FLAG_HGSS_UNK_27D
    End
scr_seq_T09_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02FC
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_HGSS_UNK_40FD, 0
    GoToIf 5, _0304
    GoToIfSet FLAG_HGSS_UNK_128, _016F
    SetFlag FLAG_HGSS_UNK_128
    Message msg_0519_T09_00000
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0162
    ApplyMovement obj_T09_gsleader16, _0268
    GoTo _016A
_0162:
    ApplyMovement obj_T09_gsleader16, _0280
_016A:
    WaitMovement
    Message msg_0519_T09_00001
_016F:
    CompareVar VAR_HGSS_UNK_4135, 7
    GoToIf 4, _018C
    BufferNumber 0, VAR_HGSS_UNK_4135
    Message msg_0519_T09_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_018C:
    Message msg_0519_T09_00002
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    .short SCRCMD_UNUSED_06A
    .short 253
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _01C7
    CompareVar VAR_0x8004, 1035
    GoToIf 5, _01C1
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02D4
    WaitMovement
_01C1:
    GoTo _01DE
_01C7:
    CompareVar VAR_0x8005, 495
    GoToIf 5, _01DE
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02E4
    WaitMovement
_01DE:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _01F9
    ApplyMovement obj_T09_gsleader16, _0298
    GoTo _0201
_01F9:
    ApplyMovement obj_T09_gsleader16, _02A4
_0201:
    WaitMovement
    Message msg_0519_T09_00003
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0233
    ApplyMovement obj_T09_gsleader16, _02B0
    ApplyMovement LOCALID_PLAYER, _02F4
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02F4
    GoTo _024B
_0233:
    ApplyMovement obj_T09_gsleader16, _02C0
    ApplyMovement LOCALID_PLAYER, _02F4
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02F4
_024B:
    WaitMovement
    RemoveObject obj_T09_gsleader16
    SetFlag FLAG_HGSS_UNK_25A
    SetFlag FLAG_HGSS_UNK_129
    SetFlag FLAG_HGSS_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_LOCKED
    ClearFlag FLAG_HGSS_HIDE_VIRIDIAN_CITY_OLD_MAN_OUTSIDE_GYM_UNLOCKED
    ReleaseAll
    End
    .balign 4, 0
_0268:
    WalkOnSpotNormalEast
    Delay8 2
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0280:
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalEast
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0298:
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_02A4:
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_02B0:
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth 8
    EndMovement
    .balign 4, 0
_02C0:
    WalkNormalSouth
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_02D4:
    WalkNormalSouth
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02E4:
    WalkNormalWest
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02F4:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02FC:
    Delay1
    EndMovement
_0304:
    Message msg_0519_T09_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0365
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0370
    Message msg_0519_T09_00006
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 92
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0519_T09_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0365:
    Message msg_0519_T09_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0370:
    Message msg_0519_T09_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T09_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BLAINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0429
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _041E
    Message msg_0519_T09_00010
_03A6:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03CA
    CompareVar VAR_RESULT, 1
    GoToIf 4, _040D
    End
_03CA:
    BufferPlayerName 0
    Message msg_0519_T09_00011
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BLAINE
    Message msg_0519_T09_00012
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_27D
    RemoveObject obj_T09_gsleader15
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_040D:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0519_T09_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_041E:
    Message msg_0519_T09_00014
    GoTo _03A6
    End
_0429:
    Message msg_0519_T09_00015
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _048A
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0495
    Message msg_0519_T09_00016
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 85
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0519_T09_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_048A:
    Message msg_0519_T09_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0495:
    Message msg_0519_T09_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T09_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0519_T09_00020, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T09_002:
    DrawSignpostInstantMessage msg_0519_T09_00021, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
