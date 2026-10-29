#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0122.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D39R0101_gsmiddleman1 1
#define obj_D39R0101_dancer 2
#define obj_D39R0101_gsmiddleman1_2 5

    ScriptEntry scr_seq_D39R0101_000
    ScriptEntry scr_seq_D39R0101_001
    ScriptEntry scr_seq_D39R0101_002
    ScriptEntry scr_seq_D39R0101_003
    ScriptEntry scr_seq_D39R0101_004
    ScriptEntryEnd
scr_seq_D39R0101_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _0027
    ClearFlag FLAG_HGSS_UNK_189
    End
_0027:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _004B
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _004B
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_004B:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D39R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4100, 1
    GoToIf 1, _008A
    GoToIfSet FLAG_HGSS_HIDE_ITEMBALL_D39R0101_HM07, _0084
    Message msg_0122_D39R0101_00001
    CloseMessage
    ApplyMovement obj_D39R0101_gsmiddleman1, _0114
    WaitMovement
    ReleaseAll
    End
_0084:
    SetVarFromValue VAR_HGSS_UNK_4100, 1
_008A:
    Message msg_0122_D39R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D39R0101_004:
    LockAll
    GoToIfSet FLAG_HGSS_HIDE_ITEMBALL_D39R0101_HM07, _00E5
    ApplyMovement obj_D39R0101_gsmiddleman1, _0108
    ApplyMovement LOCALID_PLAYER, _011C
    WaitMovement
    Message msg_0122_D39R0101_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D39R0101_gsmiddleman1, _0114
    ApplyMovement LOCALID_PLAYER, _0128
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_00E5:
    ApplyMovement obj_D39R0101_gsmiddleman1, _0108
    ApplyMovement LOCALID_PLAYER, _011C
    WaitMovement
    Message msg_0122_D39R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4100, 1
    End
    .balign 4, 0
_0108:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0114:
    FaceSouth
    EndMovement
    .balign 4, 0
_011C:
    Delay8 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0128:
    WalkNormalWest
    EndMovement
scr_seq_D39R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0157
    GoTo _0169
_0151:
    GoTo _0157
_0157:
    BufferPlayerName 0
    Message msg_0122_D39R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    Common_FadeToDefaultMusic
    End
_0169:
    BufferPlayerName 0
    Message msg_0122_D39R0101_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0193
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01F3
    End
_0193:
    PlaySE SEQ_SE_DP_WALL_HIT_sseq
    Message msg_0122_D39R0101_00005
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    @ HGSS: ScrCmd_102 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    ApplyMovement obj_D39R0101_dancer, _021C
    ApplyMovement 241, _0244
    WaitMovement
    Message msg_0122_D39R0101_00007
    CloseMessage
    ApplyMovement obj_D39R0101_dancer, _023C
    WaitMovement
    RemoveObject obj_D39R0101_dancer
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_FadeToDefaultMusic
    SetFlag FLAG_HGSS_UNK_239
    SetVarFromValue VAR_HGSS_UNK_40E8, 1
    ApplyMovement 241, _024C
    WaitMovement
    @ HGSS: ScrCmd_103
    ReleaseAll
    End
_01F3:
    Message msg_0122_D39R0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0193
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01F3
    End
    .balign 4, 0
_021C:
    PauseAnimation 0
    WalkFastSouth 5
    ResumeAnimation 0
    WalkNormalSouth 2
    WalkOnSpotNormalSouth
    Delay8
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_023C:
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0244:
    WalkFastSouth 4
    EndMovement
    .balign 4, 0
_024C:
    WalkFastNorth 4
    EndMovement
    .balign 4, 0
_0254:
    FaceSouth
    EndMovement
scr_seq_D39R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0384
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0398
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02D5
    ApplyMovement LOCALID_PLAYER, _03AC
    ApplyMovement obj_D39R0101_gsmiddleman1_2, _03F8
    GoTo _0323
_02D5:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02F0
    ApplyMovement LOCALID_PLAYER, _03C4
    GoTo _0323
_02F0:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0313
    ApplyMovement LOCALID_PLAYER, _03E4
    ApplyMovement obj_D39R0101_gsmiddleman1_2, _03F8
    GoTo _0323
_0313:
    ApplyMovement LOCALID_PLAYER, _03D0
    ApplyMovement obj_D39R0101_gsmiddleman1_2, _03F8
_0323:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _034A
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0404
    WaitMovement
_034A:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 43
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
_0384:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0398:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03AC:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03C4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03D0:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03E4:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03F8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0404:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
