#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0495.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T07R0102_gsmiddleman1_2 4
#define obj_T07R0102_leader3 5

    ScriptEntry scr_seq_T07R0102_000
    ScriptEntry scr_seq_T07R0102_001
    ScriptEntry scr_seq_T07R0102_002
    ScriptEntry scr_seq_T07R0102_003
    ScriptEntry scr_seq_T07R0102_004
    ScriptEntry scr_seq_T07R0102_005
    ScriptEntry scr_seq_T07R0102_006
    ScriptEntry scr_seq_T07R0102_007
    ScriptEntryEnd
scr_seq_T07R0102_006:
    GoToIfUnset FLAG_HGSS_UNK_189, _0033
    ClearFlag FLAG_HGSS_UNK_189
    End
_0033:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _004E
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0052
_004E:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_0052:
    End
scr_seq_T07R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 18
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T07R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 19
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T07R0102_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    CheckItem ITEM_FASHION_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01DA
    Message msg_0495_T07R0102_00003
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _00C9
    ApplyMovement obj_T07R0102_leader3, _01E8
    GoTo _00D1
_00C9:
    ApplyMovement obj_T07R0102_leader3, _0200
_00D1:
    WaitMovement
    Message msg_0495_T07R0102_00004
    ApplyMovement obj_T07R0102_leader3, _0218
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00FB
    ApplyMovement obj_T07R0102_leader3, _0220
    GoTo _011E
_00FB:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0116
    ApplyMovement obj_T07R0102_leader3, _0230
    GoTo _011E
_0116:
    ApplyMovement obj_T07R0102_leader3, _0228
_011E:
    WaitMovement
    Message msg_0495_T07R0102_00005
    SetVarFromValue VAR_0x8004, 92
    SetVarFromValue VAR_0x8005, 1
    Common_GiveAccessory
    Message msg_0495_T07R0102_00006
    SetVarFromValue VAR_0x8004, 93
    SetVarFromValue VAR_0x8005, 1
    Common_GiveAccessory
    Message msg_0495_T07R0102_00007
    SetVarFromValue VAR_0x8004, 94
    SetVarFromValue VAR_0x8005, 1
    Common_GiveAccessory
    Message msg_0495_T07R0102_00008
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 3
    CallIf 1, _01A0
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _0186
    ApplyMovement obj_T07R0102_leader3, _0250
    GoTo _018E
_0186:
    ApplyMovement obj_T07R0102_leader3, _0238
_018E:
    WaitMovement
    RemoveObject obj_T07R0102_leader3
    SetFlag FLAG_HGSS_HIDE_CELADON_DEPT_STORE_2F_CRASHER_WAKE
    ClearFlag FLAG_HGSS_HIDE_ROUTE_47_CRASHER_WAKE
    ReleaseAll
    End
_01A0:
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01D8
    .short SCRCMD_UNUSED_06A
    .short 253
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_0x8005, 5
    GoToIf 5, _01D8
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0264
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
_01D8:
    Return
_01DA:
    Message msg_0495_T07R0102_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01E8:
    WalkNormalWest
    WalkOnSpotNormalNorth
    Delay8
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0200:
    WalkNormalEast
    WalkOnSpotNormalNorth
    Delay8
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0218:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0220:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0228:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0230:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0238:
    WalkNormalWest 2
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0250:
    WalkNormalSouth
    WalkNormalWest 6
    WalkNormalNorth
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0264:
    WalkSlightlyFastWest
    WalkSlightlyFastNorth
    FaceSouth
    EndMovement
scr_seq_T07R0102_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _039C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03B0
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02ED
    ApplyMovement LOCALID_PLAYER, _03C4
    ApplyMovement obj_T07R0102_gsmiddleman1_2, _0410
    GoTo _033B
_02ED:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0308
    ApplyMovement LOCALID_PLAYER, _03DC
    GoTo _033B
_0308:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _032B
    ApplyMovement LOCALID_PLAYER, _03FC
    ApplyMovement obj_T07R0102_gsmiddleman1_2, _0410
    GoTo _033B
_032B:
    ApplyMovement LOCALID_PLAYER, _03E8
    ApplyMovement obj_T07R0102_gsmiddleman1_2, _0410
_033B:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0362
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _041C
    WaitMovement
_0362:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 58
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
_039C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03B0:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03C4:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03DC:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03E8:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03FC:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0410:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_041C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T07R0102_002:
    NPCMessage msg_0495_T07R0102_00000
    End
scr_seq_T07R0102_003:
    NPCMessage msg_0495_T07R0102_00001
    End
scr_seq_T07R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0495_T07R0102_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
