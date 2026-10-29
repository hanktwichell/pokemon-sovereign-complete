#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0116.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D37R0101_var_1 2
#define obj_D37R0101_tsure_poke_static_marill 3

    ScriptEntry scr_seq_D37R0101_000
    ScriptEntry scr_seq_D37R0101_001
    ScriptEntry scr_seq_D37R0101_002
    ScriptEntry scr_seq_D37R0101_003
    ScriptEntryEnd
scr_seq_D37R0101_003:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    End
scr_seq_D37R0101_002:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _0228
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_tsure_poke_static_marill
    CompareVar VAR_MAP_LOCAL_0x01, 30
    GoToIf 5, _0050
    SetPosition obj_D37R0101_tsure_poke_static_marill, 9, 0, 25, DIR_WEST
_0050:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0174
    WaitMovement
    WaitTime 8, VAR_RESULT
    PlayCry SPECIES_MARILL, 0
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _01BC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_var_1
    CompareVar VAR_MAP_LOCAL_0x01, 30
    GoToIf 5, _00AB
    SetPosition obj_D37R0101_var_1, 9, 0, 25, DIR_WEST
_00AB:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    Common_SetCounterpartBGM
    ApplyMovement obj_D37R0101_var_1, _01C4
    WaitMovement
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00EE
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0218
    ApplyMovement LOCALID_PLAYER, _0218
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0218
    WaitMovement
    GoTo _0100
_00EE:
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0218
    ApplyMovement LOCALID_PLAYER, _0218
    WaitMovement
_0100:
    BufferPlayerName 0
    MessageGendered msg_0116_D37R0101_00006, msg_0116_D37R0101_00009
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _01D0
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _01E0
    WaitMovement
    MessageGendered msg_0116_D37R0101_00007, msg_0116_D37R0101_00010
    SetVar VAR_0x8004, ITEM_FASHION_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Call _0354
    MessageGendered msg_0116_D37R0101_00008, msg_0116_D37R0101_00011
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _01F0
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0204
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    RemoveObject obj_D37R0101_var_1
    RemoveObject obj_D37R0101_tsure_poke_static_marill
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_40F8, 1
    SetFlag FLAG_HGSS_UNK_14C
    ReleaseAll
    End
    .balign 4, 0
_0174:
    WalkSlightlyFastWest
    WalkOnSpotFastEast
    JumpOnSpotFastWest 2
    WalkFastWest 3
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    EndMovement
    .balign 4, 0
_01BC:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_01C4:
    WalkNormalWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_01D0:
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest
    EndMovement
    .balign 4, 0
_01E0:
    Delay8 3
    WalkNormalEast
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01F0:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0204:
    WalkNormalSouth 3
    WalkNormalWest
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_0218:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0220:
    WalkOnSpotNormalSouth
    EndMovement
_0228:
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_var_1
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_tsure_poke_static_marill
    LockObject obj_D37R0101_tsure_poke_static_marill
    Common_SetCounterpartBGM
    SetPosition obj_D37R0101_var_1, 25, 0, 9, DIR_NORTH
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement LOCALID_PLAYER, _0220
    ApplyMovement obj_D37R0101_var_1, _0308
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0310
    ApplyMovement obj_D37R0101_var_1, _0318
    WaitTime 8, VAR_RESULT
    SetPosition obj_D37R0101_tsure_poke_static_marill, 25, 0, 9, DIR_NORTH
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0320
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0116_D37R0101_00006, msg_0116_D37R0101_00009
    MessageGendered msg_0116_D37R0101_00007, msg_0116_D37R0101_00010
    SetVar VAR_0x8004, ITEM_FASHION_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Call _0354
    MessageGendered msg_0116_D37R0101_00008, msg_0116_D37R0101_00011
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _0328
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _033C
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    RemoveObject obj_D37R0101_var_1
    RemoveObject obj_D37R0101_tsure_poke_static_marill
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_40F8, 1
    SetFlag FLAG_HGSS_UNK_14C
    ReleaseAll
    End
    .balign 4, 0
_0308:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0310:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0318:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0320:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0328:
    WalkNormalEast
    WalkNormalNorth 4
    WalkNormalWest 2
    SetInvisible
    EndMovement
    .balign 4, 0
_033C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 4
    WalkNormalWest 2
    SetInvisible
    EndMovement
_0354:
    Call _03A8
    Call _03A8
    Call _03A8
    Call _03A8
    Call _03A8
    Call _03C2
    Call _03C2
    Call _03C2
    Call _03C2
    Call _03C2
    @ HGSS: ScrCmd_406 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 9999
    Call _03DC
    Call _03DC
    Return
_03A8:
    @ HGSS: Random VAR_SPECIAL_RESULT, 6
    SetVarFromValue VAR_0x8004, 0
    AddVar VAR_0x8004, VAR_RESULT
    @ HGSS: ScrCmd_403 VAR_SPECIAL_x8004, 1
    Return
_03C2:
    @ HGSS: Random VAR_SPECIAL_RESULT, 6
    SetVarFromValue VAR_0x8004, 18
    AddVar VAR_0x8004, VAR_RESULT
    @ HGSS: ScrCmd_403 VAR_SPECIAL_x8004, 1
    Return
_03DC:
    @ HGSS: Random VAR_SPECIAL_RESULT, 8
    CompareVar VAR_MAP_LOCAL_0x01, VAR_RESULT
    GoToIf 1, _03DC
    SetVarFromVar VAR_MAP_LOCAL_0x01, VAR_RESULT
    SetVarFromValue VAR_0x8004, 1
    AddVar VAR_0x8004, VAR_RESULT
    @ HGSS: ScrCmd_406 VAR_SPECIAL_x8004
    Return
scr_seq_D37R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _0425
    Message msg_0116_D37R0101_00002
    GoTo _0454
_0425:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _043B
    Message msg_0116_D37R0101_00002
    GoTo _0454
_043B:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0451
    Message msg_0116_D37R0101_00001
    GoTo _0454
_0451:
    Message msg_0116_D37R0101_00000
_0454:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D37R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _047A
    Message msg_0116_D37R0101_00005
    GoTo _04A9
_047A:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0490
    Message msg_0116_D37R0101_00005
    GoTo _04A9
_0490:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _04A6
    Message msg_0116_D37R0101_00004
    GoTo _04A9
_04A6:
    Message msg_0116_D37R0101_00003
_04A9:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
