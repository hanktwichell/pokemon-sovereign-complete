#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0581.h"

#define obj_T25_rocketm 4
#define obj_T25_rocketm_9 15

    ScriptEntry scr_seq_T25_000
    ScriptEntry scr_seq_T25_001
    ScriptEntry scr_seq_T25_002
    ScriptEntry scr_seq_T25_003
    ScriptEntry scr_seq_T25_004
    ScriptEntry scr_seq_T25_005
    ScriptEntry scr_seq_T25_006
    ScriptEntry scr_seq_T25_007
    ScriptEntry scr_seq_T25_008
    ScriptEntry scr_seq_T25_009
    ScriptEntry scr_seq_T25_010
    ScriptEntry scr_seq_T25_011
    ScriptEntry scr_seq_T25_012
    ScriptEntry scr_seq_T25_013
    ScriptEntry scr_seq_T25_014
    ScriptEntry scr_seq_T25_015
    ScriptEntry scr_seq_T25_016
    ScriptEntry scr_seq_T25_017
    ScriptEntry scr_seq_T25_018
    ScriptEntry scr_seq_T25_019
    ScriptEntry scr_seq_T25_020
    ScriptEntry scr_seq_T25_021
    ScriptEntry scr_seq_T25_022
    ScriptEntry scr_seq_T25_023
    ScriptEntry scr_seq_T25_024
    ScriptEntry scr_seq_T25_025
    ScriptEntry scr_seq_T25_026
    ScriptEntry scr_seq_T25_027
    ScriptEntry scr_seq_T25_028
    ScriptEntry scr_seq_T25_029
    ScriptEntry scr_seq_T25_030
    ScriptEntry scr_seq_T25_031
    ScriptEntry scr_seq_T25_032
    ScriptEntryEnd
scr_seq_T25_018:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_3
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_4
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_5
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 0
    GoToIf 5, _00B5
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_3
    GoTo _011A
_00B5:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 1
    GoToIf 5, _00D4
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_3
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_4
    GoTo _011A
_00D4:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _00F7
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_3
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_4
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_5
    GoTo _011A
_00F7:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    GoToIf 5, _010E
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    GoTo _011A
_010E:
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_3
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_4
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
_011A:
    End
scr_seq_T25_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40DA, 1
    GoToIf 5, _013E
    CompareVar VAR_HGSS_UNK_40DB, 0
    GoToIf 1, _0149
_013E:
    Message msg_0581_T25_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0149:
    Message msg_0581_T25_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 4, _0172
    Message msg_0581_T25_00004
    GoTo _0175
_0172:
    Message msg_0581_T25_00005
_0175:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_RADIO_CARD, _019B
    Message msg_0581_T25_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019B:
    Message msg_0581_T25_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_003:
    NPCMessage msg_0581_T25_00008
    End
scr_seq_T25_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01DD
    Message msg_0581_T25_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DD:
    Message msg_0581_T25_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40DA, 1
    GoToIf 5, _020A
    CompareVar VAR_HGSS_UNK_40DB, 0
    GoToIf 1, _0215
_020A:
    Message msg_0581_T25_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0215:
    Message msg_0581_T25_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40DA, 1
    GoToIf 5, _0242
    CompareVar VAR_HGSS_UNK_40DB, 0
    GoToIf 1, _024D
_0242:
    Message msg_0581_T25_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_024D:
    Message msg_0581_T25_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0581_T25_00013
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0284
    ApplyMovement obj_T25_rocketm, _02F8
    WaitMovement
    GoTo _02B8
_0284:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _02A1
    ApplyMovement obj_T25_rocketm, _0308
    WaitMovement
    GoTo _02B8
_02A1:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _02B8
    ApplyMovement obj_T25_rocketm, _0300
    WaitMovement
_02B8:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _02CE
    Message msg_0581_T25_00015
    GoTo _02D1
_02CE:
    Message msg_0581_T25_00014
_02D1:
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 350
    GoToIf 1, _02EA
    ApplyMovement obj_T25_rocketm, _02F0
    WaitMovement
_02EA:
    ReleaseAll
    End
    .balign 4, 0
_02F0:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02F8:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0300:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0308:
    WalkOnSpotNormalEast
    EndMovement
scr_seq_T25_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _032E
    Message msg_0581_T25_00017
    GoTo _0331
_032E:
    Message msg_0581_T25_00016
_0331:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0357
    Message msg_0581_T25_00019
    GoTo _035A
_0357:
    Message msg_0581_T25_00018
_035A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0380
    Message msg_0581_T25_00021
    GoTo _0383
_0380:
    Message msg_0581_T25_00020
_0383:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _03A9
    Message msg_0581_T25_00023
    GoTo _03AC
_03A9:
    Message msg_0581_T25_00022
_03AC:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _03D2
    Message msg_0581_T25_00025
    GoTo _03D5
_03D2:
    Message msg_0581_T25_00024
_03D5:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _03FB
    Message msg_0581_T25_00030
    GoTo _03FE
_03FB:
    Message msg_0581_T25_00029
_03FE:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_030:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0581_T25_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_032:
    NPCMessage msg_0581_T25_00028
    End
scr_seq_T25_031:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0581_T25_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_014:
    NPCMessage msg_0581_T25_00031
    End
scr_seq_T25_015:
    NPCMessage msg_0581_T25_00032
    End
scr_seq_T25_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _047F
    Message msg_0581_T25_00034
    GoTo _0482
_047F:
    Message msg_0581_T25_00033
_0482:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25_017:
    LockAll
    ApplyMovement obj_T25_rocketm_9, _06E4
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 354
    GoToIf 5, _04B9
    ApplyMovement obj_T25_rocketm_9, _06EC
    GoTo _05A6
_04B9:
    CompareVar VAR_MAP_LOCAL_0x00, 355
    GoToIf 5, _04D4
    ApplyMovement obj_T25_rocketm_9, _06F4
    GoTo _05A6
_04D4:
    CompareVar VAR_MAP_LOCAL_0x00, 356
    GoToIf 5, _04EF
    ApplyMovement obj_T25_rocketm_9, _06FC
    GoTo _05A6
_04EF:
    CompareVar VAR_MAP_LOCAL_0x00, 357
    GoToIf 5, _050A
    ApplyMovement obj_T25_rocketm_9, _0704
    GoTo _05A6
_050A:
    CompareVar VAR_MAP_LOCAL_0x00, 358
    GoToIf 5, _0525
    ApplyMovement obj_T25_rocketm_9, _070C
    GoTo _05A6
_0525:
    CompareVar VAR_MAP_LOCAL_0x00, 359
    GoToIf 5, _0540
    ApplyMovement obj_T25_rocketm_9, _0714
    GoTo _05A6
_0540:
    CompareVar VAR_MAP_LOCAL_0x00, 360
    GoToIf 5, _055B
    ApplyMovement obj_T25_rocketm_9, _071C
    GoTo _05A6
_055B:
    CompareVar VAR_MAP_LOCAL_0x00, 361
    GoToIf 5, _0576
    ApplyMovement obj_T25_rocketm_9, _0724
    GoTo _05A6
_0576:
    CompareVar VAR_MAP_LOCAL_0x00, 362
    GoToIf 5, _0591
    ApplyMovement obj_T25_rocketm_9, _072C
    GoTo _05A6
_0591:
    CompareVar VAR_MAP_LOCAL_0x00, 363
    GoToIf 5, _05A6
    ApplyMovement obj_T25_rocketm_9, _0734
_05A6:
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T25_rocketm_9, _073C
    ApplyMovement LOCALID_PLAYER, _0744
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0581_T25_00035
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 354
    GoToIf 5, _05EE
    ApplyMovement obj_T25_rocketm_9, _0754
    GoTo _06DB
_05EE:
    CompareVar VAR_MAP_LOCAL_0x00, 355
    GoToIf 5, _0609
    ApplyMovement obj_T25_rocketm_9, _0764
    GoTo _06DB
_0609:
    CompareVar VAR_MAP_LOCAL_0x00, 356
    GoToIf 5, _0624
    ApplyMovement obj_T25_rocketm_9, _0774
    GoTo _06DB
_0624:
    CompareVar VAR_MAP_LOCAL_0x00, 357
    GoToIf 5, _063F
    ApplyMovement obj_T25_rocketm_9, _0784
    GoTo _06DB
_063F:
    CompareVar VAR_MAP_LOCAL_0x00, 358
    GoToIf 5, _065A
    ApplyMovement obj_T25_rocketm_9, _0794
    GoTo _06DB
_065A:
    CompareVar VAR_MAP_LOCAL_0x00, 359
    GoToIf 5, _0675
    ApplyMovement obj_T25_rocketm_9, _07A4
    GoTo _06DB
_0675:
    CompareVar VAR_MAP_LOCAL_0x00, 360
    GoToIf 5, _0690
    ApplyMovement obj_T25_rocketm_9, _07B0
    GoTo _06DB
_0690:
    CompareVar VAR_MAP_LOCAL_0x00, 361
    GoToIf 5, _06AB
    ApplyMovement obj_T25_rocketm_9, _07C0
    GoTo _06DB
_06AB:
    CompareVar VAR_MAP_LOCAL_0x00, 362
    GoToIf 5, _06C6
    ApplyMovement obj_T25_rocketm_9, _07D0
    GoTo _06DB
_06C6:
    CompareVar VAR_MAP_LOCAL_0x00, 363
    GoToIf 5, _06DB
    ApplyMovement obj_T25_rocketm_9, _07E0
_06DB:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_06E4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_06EC:
    WalkNormalWest 5
    EndMovement
    .balign 4, 0
_06F4:
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_06FC:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0704:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_070C:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0714:
    Delay1
    EndMovement
    .balign 4, 0
_071C:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0724:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_072C:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0734:
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
_073C:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0744:
    LockDir
    WalkNormalNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_0754:
    WalkNormalSouth
    WalkNormalEast 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0764:
    WalkNormalSouth
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0774:
    WalkNormalSouth
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0784:
    WalkNormalSouth
    WalkNormalEast 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0794:
    WalkNormalSouth
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07A4:
    WalkNormalSouth
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07B0:
    WalkNormalSouth
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07C0:
    WalkNormalSouth
    WalkNormalWest 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07D0:
    WalkNormalSouth
    WalkNormalWest 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07E0:
    WalkNormalSouth
    WalkNormalWest 4
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_T25_019:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00036, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_020:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00037, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_021:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00038, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_022:
    DrawSignpostInstantMessage msg_0581_T25_00039, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_023:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00040, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_024:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00041, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_025:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00042, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_026:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00043, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_027:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00044, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_028:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00045, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T25_029:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0581_T25_00046, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
