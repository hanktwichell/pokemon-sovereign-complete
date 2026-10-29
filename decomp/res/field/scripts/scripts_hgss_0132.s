#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0147.h"

#define obj_D51R0301_champion 0

    ScriptEntry scr_seq_D51R0301_000
    ScriptEntry scr_seq_D51R0301_001
    ScriptEntry scr_seq_D51R0301_002
    ScriptEntry scr_seq_D51R0301_003
    ScriptEntryEnd
scr_seq_D51R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_09E, _002E
    Message msg_0147_D51R0301_00000
    CloseMessage
    SetFlag FLAG_HGSS_UNK_09E
_002E:
    @ HGSS: PlayerHasSpecies VAR_SPECIAL_RESULT, SPECIES_ARCEUS
    CompareVar VAR_RESULT, 1
    GoToIf 1, _004C
    Message msg_0147_D51R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_004C:
    ApplyMovement obj_D51R0301_champion, _0188
    WaitMovement
    Message msg_0147_D51R0301_00001
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0078
    GoTo _0107
_0072:
    GoTo _0097
_0078:
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _0091
    GoTo _00CF
_008B:
    GoTo _0097
_0091:
    GoTo _0097
_0097:
    ApplyMovement obj_D51R0301_champion, _0194
    WaitMovement
    ApplyMovement obj_D51R0301_champion, _01A0
    WaitMovement
    Message msg_0147_D51R0301_00003
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _01A8
    WaitMovement
    Message msg_0147_D51R0301_00004
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _01B4
    WaitMovement
    GoTo _0167
_00CF:
    ApplyMovement obj_D51R0301_champion, _01C4
    WaitMovement
    ApplyMovement obj_D51R0301_champion, _01D0
    WaitMovement
    Message msg_0147_D51R0301_00003
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _01D8
    WaitMovement
    Message msg_0147_D51R0301_00004
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _01E0
    WaitMovement
    GoTo _0167
_0107:
    ApplyMovement obj_D51R0301_champion, _01F0
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01FC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D51R0301_champion, _0204
    WaitMovement
    Message msg_0147_D51R0301_00003
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _020C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _022C
    WaitMovement
    Message msg_0147_D51R0301_00004
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _021C
    WaitMovement
    GoTo _0167
_0167:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_UNK_2DD
    RemoveObject obj_D51R0301_champion
    ClearFlag FLAG_HGSS_HIDE_SINJOH_MYSTRI_SHRINE_CYNTHIA
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 7
    ReleaseAll
    End
    .balign 4, 0
_0188:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0194:
    WalkOnSpotNormalNorth
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
_01A0:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01A8:
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_01B4:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01C4:
    WalkOnSpotNormalSouth
    WalkSlowSouth
    EndMovement
    .balign 4, 0
_01D0:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_01D8:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_01E0:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F0:
    WalkOnSpotNormalNorth
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
_01FC:
    WalkSlowNorth
    EndMovement
    .balign 4, 0
_0204:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_020C:
    WalkNormalEast
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_021C:
    WalkNormalSouth 2
    WalkNormalWest 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_022C:
    WalkOnSpotNormalEast
    EndMovement
scr_seq_D51R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 4, _026E
    GoToIfSet FLAG_HGSS_UNK_09D, _0263
    Message msg_0147_D51R0301_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_09D
    ReleaseAll
    End
_0263:
    Message msg_0147_D51R0301_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026E:
    Message msg_0147_D51R0301_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D51R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0147_D51R0301_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02A6
    CompareVar VAR_RESULT, 1
    GoToIf 4, _030C
_02A6:
    Message msg_0147_D51R0301_00011
    CloseMessage
    PlaySE SEQ_SE_DP_TELE_sseq
    ApplyMovement LOCALID_PLAYER, _0318
    WaitMovement
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 5, _02D2
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 10
    GoTo _02E4
_02D2:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 1
    SetFlag FLAG_HGSS_HIDE_SINJOH_MYSTRI_SHRINE_CYNTHIA
    ClearFlag FLAG_HGSS_UNK_2DD
    ClearFlag FLAG_HGSS_UNK_2DB
_02E4:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NEW_BARK, 695, 397, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_030C:
    Message msg_0147_D51R0301_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0318:
    FaceEast
    Delay4
    FaceSouth
    Delay4
    FaceWest
    Delay4
    FaceNorth
    Delay4
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    EndMovement
scr_seq_D51R0301_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ABRA, 0
    Message msg_0147_D51R0301_00013
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
