#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0147.h"

#define obj_D51R0301_champion 0

    ScriptEntry scr_seq_D51R0301_000
    ScriptEntry scr_seq_D51R0301_001
    ScriptEntry scr_seq_D51R0301_002
    ScriptEntry scr_seq_D51R0301_003
    ScriptEntry scr_seq_D51R0301_004
    ScriptEntryEnd
scr_seq_D51R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_09E, _0146
    Message msg_0147_D51R0301_00000
    CloseMessage
    SetFlag FLAG_HGSS_UNK_09E
    CheckPartyHasSpecies VAR_RESULT, SPECIES_ARCEUS
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0164
    Message msg_0147_D51R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D51R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 4, _018A
    GoToIfSet FLAG_HGSS_UNK_09D, _0195
    Message msg_0147_D51R0301_00007
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_09D
    ReleaseAll
    End
scr_seq_D51R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0147_D51R0301_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A0
    CompareVar VAR_RESULT, 1
    GoToIf 4, _01CC
    Message msg_0147_D51R0301_00011
    CloseMessage
    PlaySE SEQ_SE_DP_TELE_sseq
    ApplyMovement LOCALID_PLAYER, _03A7
    WaitMovement
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 5, _01D7
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 10
    GoTo _0211
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
scr_seq_D51R0301_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_SG_3FCE, _0239
    GoToIfUnset FLAG_HGSS_SG_3FCD, _0239
    GoToIfUnset FLAG_HGSS_SG_3FCC, _0239
    GoToIfUnset FLAG_HGSS_SG_3FC6, _0242
    GoToIfUnset FLAG_HGSS_SG_3FC5, _0242
    GoToIfUnset FLAG_HGSS_SG_3FC4, _0242
    Message msg_0147_D51R0301_00017
    GoTo _024B
_0146:
    CheckPartyHasSpecies VAR_RESULT, SPECIES_ARCEUS
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0164
    Message msg_0147_D51R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0164:
    ApplyMovement obj_D51R0301_champion, _0419
    WaitMovement
    Message msg_0147_D51R0301_00001
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0295
    GoTo _02A8
_018A:
    Message msg_0147_D51R0301_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0195:
    Message msg_0147_D51R0301_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A0:
    Message msg_0147_D51R0301_00011
    CloseMessage
    PlaySE SEQ_SE_DP_TELE_sseq
    ApplyMovement LOCALID_PLAYER, _03A7
    WaitMovement
    CompareVar VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 13
    GoToIf 5, _01D7
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 10
    GoTo _0211
_01CC:
    Message msg_0147_D51R0301_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01D7:
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 1
    SetFlag FLAG_HGSS_HIDE_SINJOH_MYSTRI_SHRINE_CYNTHIA
    ClearFlag FLAG_HGSS_UNK_2DD
    ClearFlag FLAG_HGSS_UNK_2DB
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NEW_BARK, 695, 397, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0211:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NEW_BARK, 695, 397, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0239:
    Message msg_0147_D51R0301_00016
    GoTo _024B
_0242:
    Message msg_0147_D51R0301_00018
    GoTo _024B
_024B:
    Message msg_0147_D51R0301_00014
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0308
    CloseMessage
    CompleteFollowerPutAway
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_GOLDENROD_BIKE_SHOP, 7, 4, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerReturn
    ReleaseAll
    End
_0295:
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _0313
    GoTo _0319
_02A8:
    ApplyMovement obj_D51R0301_champion, _0423
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _042D
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_D51R0301_champion, _0433
    WaitMovement
    Message msg_0147_D51R0301_00003
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _0439
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0447
    WaitMovement
    Message msg_0147_D51R0301_00004
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _044D
    WaitMovement
    GoTo _0351
_0308:
    Message msg_0147_D51R0301_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0313:
    GoTo _036F
_0319:
    ApplyMovement obj_D51R0301_champion, _045B
    WaitMovement
    ApplyMovement obj_D51R0301_champion, _0465
    WaitMovement
    Message msg_0147_D51R0301_00003
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _046B
    WaitMovement
    Message msg_0147_D51R0301_00004
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _0471
    WaitMovement
    GoTo _0351
_0351:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_UNK_2DD
    RemoveObject obj_D51R0301_champion
    ClearFlag FLAG_HGSS_HIDE_SINJOH_MYSTRI_SHRINE_CYNTHIA
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetVarFromValue VAR_HGSS_SCENE_SINJOH_MYSTRI_ROOM, 7
    ReleaseAll
    End
_036F:
    ApplyMovement obj_D51R0301_champion, _047F
    WaitMovement
    ApplyMovement obj_D51R0301_champion, _0489
    WaitMovement
    Message msg_0147_D51R0301_00003
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _048F
    WaitMovement
    Message msg_0147_D51R0301_00004
    CloseMessage
    ApplyMovement obj_D51R0301_champion, _0499
    WaitMovement
    GoTo _0351
    .balign 4, 0
_03A7:
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
    .balign 4, 0
_0419:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0423:
    WalkOnSpotNormalNorth
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
_042D:
    WalkSlowNorth
    EndMovement
    .balign 4, 0
_0433:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0439:
    WalkNormalEast
    WalkNormalSouth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0447:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_044D:
    WalkNormalSouth 2
    WalkNormalWest 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_045B:
    WalkOnSpotNormalSouth
    WalkSlowSouth
    EndMovement
    .balign 4, 0
_0465:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_046B:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0471:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_047F:
    WalkOnSpotNormalNorth
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
_0489:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_048F:
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0499:
    WalkNormalSouth 2
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
