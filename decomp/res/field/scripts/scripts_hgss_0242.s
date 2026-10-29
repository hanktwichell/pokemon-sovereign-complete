#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0389.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R35R0201_workman 2
#define obj_R35R0201_gsmiddleman1 6
#define obj_R35R0201_counterm_3 7

    ScriptEntry scr_seq_R35R0201_000
    ScriptEntry scr_seq_R35R0201_001
    ScriptEntry scr_seq_R35R0201_002
    ScriptEntry scr_seq_R35R0201_003
    ScriptEntry scr_seq_R35R0201_004
    ScriptEntry scr_seq_R35R0201_005
    ScriptEntry scr_seq_R35R0201_006
    ScriptEntry scr_seq_R35R0201_007
    ScriptEntry scr_seq_R35R0201_008
    ScriptEntry scr_seq_R35R0201_009
    ScriptEntry scr_seq_R35R0201_010
    ScriptEntry scr_seq_R35R0201_011
    ScriptEntry scr_seq_R35R0201_012
    ScriptEntryEnd
scr_seq_R35R0201_009:
    End
scr_seq_R35R0201_010:
    LockAll
    ApplyMovement LOCALID_PLAYER, _00D8
    ApplyMovement obj_R35R0201_counterm_3, _00E0
    WaitMovement
    @ HGSS: CallStd std_bug_contest_guard_ask_end
    CompareVar VAR_HGSS_UNK_4118, 1
    GoToIf 5, _00D2
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0448
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NATIONAL_PARK_BUG_CATCHING_CONTEST, 40, 86, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00C2
    @ HGSS: ScrCmd_606
    GoTo _00C4
_00C2:
    @ HGSS: ScrCmd_607
_00C4:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _00E8
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
_00D2:
    ReleaseAll
    End
    .balign 4, 0
_00D8:
    FaceWest
    EndMovement
    .balign 4, 0
_00E0:
    FaceEast
    EndMovement
    .balign 4, 0
_00E8:
    FaceNorth
    EndMovement
scr_seq_R35R0201_012:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_HGSS_UNK_4118, 1
    GoToIf 5, _010F
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0168
_010F:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _012A
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0168
_012A:
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _0145
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0168
_0145:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0160
    ClearFlag FLAG_HGSS_UNK_1C4
    SetFlag FLAG_HGSS_UNK_1C3
    GoTo _0168
_0160:
    ClearFlag FLAG_HGSS_UNK_1C3
    SetFlag FLAG_HGSS_UNK_1C4
_0168:
    GoToIfUnset FLAG_HGSS_UNK_189, _0179
    ClearFlag FLAG_HGSS_UNK_189
    End
_0179:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _019D
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _019D
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_019D:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_R35R0201_008:
    LockAll
    ApplyMovement obj_R35R0201_workman, _029C
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _01D2
    ApplyMovement obj_R35R0201_workman, _02A4
    GoTo _0210
_01D2:
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _01ED
    ApplyMovement obj_R35R0201_workman, _02B4
    GoTo _0210
_01ED:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _0208
    ApplyMovement obj_R35R0201_workman, _02C4
    GoTo _0210
_0208:
    ApplyMovement obj_R35R0201_workman, _02D4
_0210:
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R35R0201_workman, _02E4
    ApplyMovement LOCALID_PLAYER, _02EC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0389_R35R0201_00010
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _0258
    ApplyMovement obj_R35R0201_workman, _02FC
    GoTo _0296
_0258:
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _0273
    ApplyMovement obj_R35R0201_workman, _0308
    GoTo _0296
_0273:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _028E
    ApplyMovement obj_R35R0201_workman, _0314
    GoTo _0296
_028E:
    ApplyMovement obj_R35R0201_workman, _0320
_0296:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_029C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_02A4:
    WalkFastWest
    WalkFastNorth 2
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_02B4:
    WalkFastWest
    WalkFastNorth
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_02C4:
    WalkFastWest
    WalkFastSouth
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_02D4:
    WalkFastWest
    WalkFastSouth 2
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_02E4:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_02EC:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_02FC:
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0308:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0314:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0320:
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
scr_seq_R35R0201_000:
    NPCMessage msg_0389_R35R0201_00009
    End
scr_seq_R35R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CallStd std_bug_contest_guard_start
    CompareVar VAR_HGSS_UNK_4118, 1
    GoToIf 5, _0438
    GoToIfSet FLAG_HGSS_UNK_1C4, _03C1
    GetPlayerDir VAR_RESULT
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_RESULT, 0
    GoToIf 5, _038C
    ApplyMovement LOCALID_PLAYER, _043C
    GoTo _03AF
_038C:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _03A7
    ApplyMovement LOCALID_PLAYER, _0448
    GoTo _03AF
_03A7:
    ApplyMovement LOCALID_PLAYER, _0450
_03AF:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _03E3
_03C1:
    GetPlayerDir VAR_RESULT
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0460
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
_03E3:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NATIONAL_PARK_BUG_CATCHING_CONTEST, 40, 86, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    LockObject LOCALID_COMPLETE_FOLLOWER
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0428
    @ HGSS: ScrCmd_606
    GoTo _042A
_0428:
    @ HGSS: ScrCmd_607
_042A:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _00E8
    WaitMovement
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
_0438:
    ReleaseAll
    End
    .balign 4, 0
_043C:
    WalkNormalEast
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0448:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0450:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0460:
    WalkNormalEast 2
    WalkNormalNorth 2
    EndMovement
scr_seq_R35R0201_002:
    NPCMessage msg_0389_R35R0201_00003
    End
scr_seq_R35R0201_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05A7
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05BB
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04F8
    ApplyMovement LOCALID_PLAYER, _05D0
    ApplyMovement obj_R35R0201_gsmiddleman1, _061C
    GoTo _0546
_04F8:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0513
    ApplyMovement LOCALID_PLAYER, _05E8
    GoTo _0546
_0513:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0536
    ApplyMovement LOCALID_PLAYER, _0608
    ApplyMovement obj_R35R0201_gsmiddleman1, _061C
    GoTo _0546
_0536:
    ApplyMovement LOCALID_PLAYER, _05F4
    ApplyMovement obj_R35R0201_gsmiddleman1, _061C
_0546:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _056D
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0628
    WaitMovement
_056D:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 12
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
_05A7:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05BB:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_05D0:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05E8:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05F4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0608:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_061C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0628:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R35R0201_003:
    NPCMessage msg_0389_R35R0201_00005
    End
scr_seq_R35R0201_004:
    NPCMessage msg_0389_R35R0201_00006
    End
scr_seq_R35R0201_005:
    NPCMessage msg_0389_R35R0201_00000
    End
scr_seq_R35R0201_006:
    NPCMessage msg_0389_R35R0201_00007
    End
scr_seq_R35R0201_007:
    NPCMessage msg_0389_R35R0201_00008
    End
    .balign 4, 0
