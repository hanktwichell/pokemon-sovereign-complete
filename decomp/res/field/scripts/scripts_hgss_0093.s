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
    CompleteGetFriendSprite VAR_OBJ_GFX_ID_0
    End
scr_seq_D37R0101_002:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _012A
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_tsure_poke_static_marill
    CompareVar VAR_MAP_LOCAL_0x01, 30
    GoToIf 5, _0215
    SetPosition obj_D37R0101_tsure_poke_static_marill, 9, 0, 25, DIR_WEST
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _05FA
    WaitMovement
    WaitTime 8, VAR_RESULT
    PlayCry SPECIES_MARILL, 0
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0640
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_var_1
    CompareVar VAR_MAP_LOCAL_0x01, 30
    GoToIf 5, _02B3
    SetPosition obj_D37R0101_var_1, 9, 0, 25, DIR_WEST
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CallCommonScript 0x816
    ApplyMovement obj_D37R0101_var_1, _0646
    WaitMovement
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02F6
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0650
    ApplyMovement LOCALID_PLAYER, _0650
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0650
    WaitMovement
    GoTo _03AB
scr_seq_D37R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _0450
    Message msg_0116_D37R0101_00002
    GoTo _0466
scr_seq_D37R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _046E
    Message msg_0116_D37R0101_00005
    GoTo _0484
_012A:
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_var_1
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_tsure_poke_static_marill
    LockObject obj_D37R0101_tsure_poke_static_marill
    CallCommonScript 0x816
    SetPosition obj_D37R0101_var_1, 25, 0, 9, DIR_NORTH
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement LOCALID_PLAYER, _0656
    ApplyMovement obj_D37R0101_var_1, _065C
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0662
    ApplyMovement obj_D37R0101_var_1, _0668
    WaitTime 8, VAR_RESULT
    SetPosition obj_D37R0101_tsure_poke_static_marill, 25, 0, 9, DIR_NORTH
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _066E
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0116_D37R0101_00006, msg_0116_D37R0101_00009
    MessageGendered msg_0116_D37R0101_00012, msg_0116_D37R0101_00013
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_2, 0
    MessageGendered msg_0116_D37R0101_00007, msg_0116_D37R0101_00010
    SetVar VAR_0x8004, ITEM_FASHION_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Call _048C
    MessageGendered msg_0116_D37R0101_00008, msg_0116_D37R0101_00011
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _0674
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0686
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
_0215:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _05FA
    WaitMovement
    WaitTime 8, VAR_RESULT
    PlayCry SPECIES_MARILL, 0
    WaitCry
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0640
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_UNDERGROUND_FRIEND
    AddObject obj_D37R0101_var_1
    CompareVar VAR_MAP_LOCAL_0x01, 30
    GoToIf 5, _02B3
    SetPosition obj_D37R0101_var_1, 9, 0, 25, DIR_WEST
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CallCommonScript 0x816
    ApplyMovement obj_D37R0101_var_1, _0646
    WaitMovement
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02F6
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0650
    ApplyMovement LOCALID_PLAYER, _0650
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0650
    WaitMovement
    GoTo _03AB
_02B3:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CallCommonScript 0x816
    ApplyMovement obj_D37R0101_var_1, _0646
    WaitMovement
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02F6
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0650
    ApplyMovement LOCALID_PLAYER, _0650
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0650
    WaitMovement
    GoTo _03AB
_02F6:
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _0650
    ApplyMovement LOCALID_PLAYER, _0650
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0116_D37R0101_00006, msg_0116_D37R0101_00009
    ApplyMovement obj_D37R0101_var_1, _069C
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _06AA
    WaitMovement
    MessageGendered msg_0116_D37R0101_00012, msg_0116_D37R0101_00013
    CloseMessage
    GetPlayerGender VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04E0
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_MICKEY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0553
    LockAll
    MessageGendered msg_0116_D37R0101_00007, msg_0116_D37R0101_00010
    SetVar VAR_0x8004, ITEM_FASHION_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Call _048C
    MessageGendered msg_0116_D37R0101_00008, msg_0116_D37R0101_00011
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _06B8
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _06CA
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
_03AB:
    BufferPlayerName 0
    MessageGendered msg_0116_D37R0101_00006, msg_0116_D37R0101_00009
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _069C
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _06AA
    WaitMovement
    MessageGendered msg_0116_D37R0101_00012, msg_0116_D37R0101_00013
    CloseMessage
    GetPlayerGender VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04E0
    StartTrainerBattle TRAINER_HGSS_KIMONO_GIRL_MICKEY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0553
    LockAll
    MessageGendered msg_0116_D37R0101_00007, msg_0116_D37R0101_00010
    SetVar VAR_0x8004, ITEM_FASHION_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Call _048C
    MessageGendered msg_0116_D37R0101_00008, msg_0116_D37R0101_00011
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _06B8
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _06CA
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
_0450:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0559
    Message msg_0116_D37R0101_00002
    GoTo _0466
_0466:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_046E:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _056F
    Message msg_0116_D37R0101_00005
    GoTo _0484
_0484:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_048C:
    Call _0585
    Call _0585
    Call _0585
    Call _0585
    Call _0585
    Call _059F
    Call _059F
    Call _059F
    Call _059F
    Call _059F
    AddContestBackdrop 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 9999
    Call _05B9
    Call _05B9
    Return
_04E0:
    StartTrainerBattle TRAINER_HGSS_BIKER_MICKEY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0553
    LockAll
    MessageGendered msg_0116_D37R0101_00007, msg_0116_D37R0101_00010
    SetVar VAR_0x8004, ITEM_FASHION_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Call _048C
    MessageGendered msg_0116_D37R0101_00008, msg_0116_D37R0101_00011
    CloseMessage
    ApplyMovement obj_D37R0101_var_1, _06B8
    ApplyMovement obj_D37R0101_tsure_poke_static_marill, _06CA
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
_0553:
    BlackOutFromBattle
    ReleaseAll
    End
_0559:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _05E4
    Message msg_0116_D37R0101_00001
    GoTo _0466
_056F:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _05EF
    Message msg_0116_D37R0101_00004
    GoTo _0484
_0585:
    GetRandom VAR_RESULT, 6
    SetVarFromValue VAR_0x8004, 0
    AddVar VAR_0x8004, VAR_RESULT
    AddAccessory VAR_0x8004, 1
    Return
_059F:
    GetRandom VAR_RESULT, 6
    SetVarFromValue VAR_0x8004, 18
    AddVar VAR_0x8004, VAR_RESULT
    AddAccessory VAR_0x8004, 1
    Return
_05B9:
    GetRandom VAR_RESULT, 8
    CompareVar VAR_MAP_LOCAL_0x01, VAR_RESULT
    GoToIf 1, _05B9
    SetVarFromVar VAR_MAP_LOCAL_0x01, VAR_RESULT
    SetVarFromValue VAR_0x8004, 1
    AddVar VAR_0x8004, VAR_RESULT
    AddContestBackdrop VAR_0x8004
    Return
_05E4:
    Message msg_0116_D37R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05EF:
    Message msg_0116_D37R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_05FA:
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
_0640:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_0646:
    WalkNormalWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0650:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0656:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_065C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0662:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0668:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_066E:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0674:
    WalkNormalEast
    WalkNormalNorth 4
    WalkNormalWest 2
    SetInvisible
    EndMovement
    .balign 4, 0
_0686:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 4
    WalkNormalWest 2
    SetInvisible
    EndMovement
    .balign 4, 0
_069C:
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest
    EndMovement
    .balign 4, 0
_06AA:
    Delay8 3
    WalkNormalEast
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_06B8:
    WalkNormalSouth 2
    WalkNormalWest
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
_06CA:
    WalkNormalSouth 3
    WalkNormalWest
    WalkNormalSouth
    SetInvisible
    EndMovement
    .balign 4, 0
