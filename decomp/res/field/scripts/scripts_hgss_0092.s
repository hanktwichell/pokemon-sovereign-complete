#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0115.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D36R0101_tsure_poke_static_farfetchd 0
#define obj_D36R0101_gsbigman 1
#define obj_D36R0101_tsure_poke_static_farfetchd_2 2
#define obj_D36R0101_gsboy1 3
#define obj_D36R0101_gsfighter 4
#define obj_D36R0101_dancer 12
#define obj_D36R0101_gsmiddleman1 13
#define obj_D36R0101_tsure_poke_static_pichu_spiky 14
#define obj_D36R0101_gsoldman1 15
#define obj_D36R0101_var_1 16
#define obj_D36R0101_tsure_poke_static_marill 17

    ScriptEntry scr_seq_D36R0101_000
    ScriptEntry scr_seq_D36R0101_001
    ScriptEntry scr_seq_D36R0101_002
    ScriptEntry scr_seq_D36R0101_003
    ScriptEntry scr_seq_D36R0101_004
    ScriptEntry scr_seq_D36R0101_005
    ScriptEntry scr_seq_D36R0101_006
    ScriptEntry scr_seq_D36R0101_007
    ScriptEntry scr_seq_D36R0101_008
    ScriptEntry scr_seq_D36R0101_009
    ScriptEntry scr_seq_D36R0101_010
    ScriptEntry scr_seq_D36R0101_011
    ScriptEntry scr_seq_D36R0101_012
    ScriptEntry scr_seq_D36R0101_013
    ScriptEntry scr_seq_D36R0101_014
    ScriptEntry scr_seq_D36R0101_015
    ScriptEntry scr_seq_D36R0101_016
    ScriptEntry scr_seq_D36R0101_017
    ScriptEntry scr_seq_D36R0101_018
    ScriptEntry scr_seq_D36R0101_019
    ScriptEntry scr_seq_D36R0101_020
    ScriptEntry scr_seq_D36R0101_021
    ScriptEntry scr_seq_D36R0101_022
    ScriptEntry scr_seq_D36R0101_023
    ScriptEntry scr_seq_D36R0101_024
    ScriptEntry scr_seq_D36R0101_025
    ScriptEntry scr_seq_D36R0101_026
    ScriptEntryEnd
scr_seq_D36R0101_000:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    GoToIfUnset FLAG_HGSS_UNK_189, _06A7
    ClearFlag FLAG_HGSS_UNK_189
    GoTo _06EF
scr_seq_D36R0101_021:
    CompareVar VAR_HGSS_UNK_412B, 1
    CallIf 1, _06FC
    CompareVar VAR_HGSS_UNK_40FE, 4
    CallIf 1, _0716
    End
scr_seq_D36R0101_001:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 25
    GoToIf 5, _0730
    GoTo _0743
scr_seq_D36R0101_003:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 1, _075E
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 1
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 25
    GoToIf 5, _0778
    GoTo _078B
scr_seq_D36R0101_004:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 1, _075E
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 25
    GoToIf 5, _07A6
    GoTo _07B9
scr_seq_D36R0101_005:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 41
    GoToIf 5, _07D4
    GoTo _07E7
scr_seq_D36R0101_006:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 41
    GoToIf 5, _0808
    GoTo _081B
scr_seq_D36R0101_007:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 41
    GoToIf 5, _0836
    GoTo _0849
scr_seq_D36R0101_008:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 41
    GoToIf 5, _0864
    GoTo _0877
scr_seq_D36R0101_009:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 41
    GoToIf 5, _0892
    GoTo _08A5
scr_seq_D36R0101_016:
    LockAll
    ApplyMovement LOCALID_PLAYER, _2268
    WaitMovement
    ApplyMovement obj_D36R0101_gsbigman, _2272
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    CompleteScreenShake 0, 2, 10, 5
    ApplyMovement obj_D36R0101_gsbigman, _2278
    WaitMovement
    ApplyMovement obj_D36R0101_gsbigman, _2272
    WaitMovement
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    CompleteScreenShake 0, 2, 10, 5
    ApplyMovement obj_D36R0101_gsbigman, _2278
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_40EA, 1
    ReleaseAll
    End
scr_seq_D36R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0115_D36R0101_00011
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08C0
    Message msg_0115_D36R0101_00014
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _08CD
    GetPartyMonSpecies VAR_RESULT, VAR_0x8005
    SetVar VAR_0x8006, VAR_RESULT
    CompareVar VAR_0x8005, 0
    GoToIf 1, _08DA
    CheckPartyMonHasMove VAR_RESULT, MOVE_HEADBUTT, VAR_0x8006
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08E5
    @ HGSS: ScrCmd_656 VAR_SPECIAL_x8006, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08F5
    Message msg_0115_D36R0101_00016
    CloseMessage
    GoTo _09B2
scr_seq_D36R0101_010:
    GoToIfSet FLAG_HGSS_FOUND_FIRST_FARFETCHD, _0A2B
    GoTo _0A3C
scr_seq_D36R0101_017:
    LockAll
    ApplyMovement obj_D36R0101_gsboy1, _2286
    ApplyMovement LOCALID_PLAYER, _228C
    WaitMovement
    Message msg_0115_D36R0101_00000
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_40F4, 0
    ReleaseAll
    End
scr_seq_D36R0101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_HM01, _0A4D
    Message msg_0115_D36R0101_00006
    SetVar VAR_0x8004, ITEM_HM01
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0A58
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_HM01
    ClearFlag FLAG_HGSS_UNK_1AE
    ClearFlag FLAG_HGSS_UNK_1AC
    Message msg_0115_D36R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D36R0101_014:
    PlayCry SPECIES_FARFETCHD, 0
    NPCMessage msg_0115_D36R0101_00004
    End
scr_seq_D36R0101_015:
    LockAll
    ApplyMovement obj_D36R0101_dancer, _2296
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8004, 40
    GoToIf 5, _0A62
    ApplyMovement obj_D36R0101_dancer, _22A0
    GoTo _0A9C
scr_seq_D36R0101_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0ACE
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0AE2
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0AF6
    ApplyMovement LOCALID_PLAYER, _22AE
    ApplyMovement obj_D36R0101_gsmiddleman1, _22C4
    GoTo _0B11
scr_seq_D36R0101_012:
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B72
    CompareVar VAR_HGSS_UNK_412B, 2
    GoToIf 4, _0B9A
    CompareVar VAR_HGSS_UNK_412B, 1
    GoToIf 1, _0B72
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0BD0
    GoTo _0B9A
scr_seq_D36R0101_019:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _0BDA
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _22CE
    GoTo _0BF5
scr_seq_D36R0101_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x08, 1
    Call _0C40
    CompareVar VAR_0x8004, 0
    GoToIf 5, _0C5D
    Call _0C67
    GoTo _0C70
scr_seq_D36R0101_022:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_D36R0101_var_1, _22D4
    ApplyMovement LOCALID_PLAYER, _22E6
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    MessageGendered msg_0115_D36R0101_00061, msg_0115_D36R0101_00060
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _22F0
    WaitMovement
    Common_SetCounterpartBGM
    ApplyMovement obj_D36R0101_var_1, _230A
    WaitMovement
    MessageGendered msg_0115_D36R0101_00063, msg_0115_D36R0101_00062
    CloseMessage
    ApplyMovement obj_D36R0101_var_1, _231C
    WaitMovement
    MessageGendered msg_0115_D36R0101_00065, msg_0115_D36R0101_00064
    CloseMessage
    ApplyMovement obj_D36R0101_var_1, _232A
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _2330
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0115_D36R0101_00067, msg_0115_D36R0101_00066
    CloseMessage
    ApplyMovement obj_D36R0101_var_1, _2336
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _234C
    WaitMovement
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_40FE, 5
    RemoveObject obj_D36R0101_var_1
    RemoveObject obj_D36R0101_tsure_poke_static_marill
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    ReleaseAll
    End
scr_seq_D36R0101_013:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0115_D36R0101_00027, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D36R0101_023:
    LockAll
    Message msg_0115_D36R0101_00068
    WaitFanfare
    ClearFlag FLAG_HGSS_SG_3FF9
    ClearFlag FLAG_HGSS_SG_3FF6
    ClearFlag FLAG_HGSS_SG_3FF5
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_61A9, 2
    ReleaseAll
    End
scr_seq_D36R0101_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BRELOOM, 0
    WaitCry
    CompleteStartWildBattle SPECIES_BRELOOM, 23, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C74
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 18
    SetFlag FLAG_HGSS_SG_3FEF
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D36R0101_025:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfSet FLAG_HGSS_SG_3F6F, _225B
    Message msg_0115_D36R0101_00072
    BufferPlayerName 0
    CloseMessage
    ApplyMovement 20, _285C
    WaitMovement
    FacePlayer
    Message msg_0115_D36R0101_00073
    SetVar VAR_0x8004, ITEM_TM81
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F6F
    Message msg_0115_D36R0101_00074
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D36R0101_026:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0115_D36R0101_00075
    CloseMessage
    PlayCry SPECIES_IVYSAUR, 0
    WaitCry
    Message msg_0115_D36R0101_00076
    CloseMessage
    ApplyMovement 21, _285C
    WaitMovement
    FacePlayer
    Message msg_0115_D36R0101_00077
    SetVar VAR_0x8004, ITEM_TM86
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0115_D36R0101_00078
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 21
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_06A7:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0C7A
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0C84
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0C84
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0C84
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _06EF
_06EF:
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _0C95
    End
_06FC:
    SetPosition obj_D36R0101_gsoldman1, 15, 0, 58, DIR_SOUTH
    SetPosition obj_D36R0101_tsure_poke_static_pichu_spiky, 15, 0, 59, DIR_EAST
    Return
_0716:
    SetPosition obj_D36R0101_var_1, 15, 0, 58, DIR_SOUTH
    SetPosition obj_D36R0101_tsure_poke_static_marill, 11, 0, 58, DIR_EAST
    Return
_0730:
    CompareVar VAR_MAP_LOCAL_0x00, 32
    GoToIf 5, _0743
    GoTo _0CE9
_0743:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 52
    GoToIf 5, _0D0A
    GoTo _0D1D
_075E:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _237A
    WaitMovement
    ReleaseAll
    End
_0778:
    CompareVar VAR_MAP_LOCAL_0x00, 32
    GoToIf 5, _078B
    GoTo _0D4A
_078B:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 52
    GoToIf 5, _0D65
    GoTo _0D78
_07A6:
    CompareVar VAR_MAP_LOCAL_0x00, 32
    GoToIf 5, _07B9
    GoTo _0D86
_07B9:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 52
    GoToIf 5, _0DA1
    GoTo _0DB4
_07D4:
    CompareVar VAR_MAP_LOCAL_0x00, 49
    GoToIf 5, _07E7
    GoTo _0DC2
_07E7:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _0DDD
    GoTo _0DF0
_0808:
    CompareVar VAR_MAP_LOCAL_0x00, 49
    GoToIf 5, _081B
    GoTo _0E31
_081B:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _0E4C
    GoTo _0E5F
_0836:
    CompareVar VAR_MAP_LOCAL_0x00, 49
    GoToIf 5, _0849
    GoTo _0E6D
_0849:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _0E88
    GoTo _0E9B
_0864:
    CompareVar VAR_MAP_LOCAL_0x00, 49
    GoToIf 5, _0877
    GoTo _0EA9
_0877:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _0EC4
    GoTo _0ED7
_0892:
    CompareVar VAR_MAP_LOCAL_0x00, 49
    GoToIf 5, _08A5
    GoTo _0EE5
_08A5:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _0F00
    GoTo _0F13
_08C0:
    Message msg_0115_D36R0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08CD:
    Message msg_0115_D36R0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08DA:
    Message msg_0115_D36R0101_00015
    CloseMessage
    GoTo _09B2
_08E5:
    BufferPartyMonSpecies 0, VAR_0x8006
    Message msg_0115_D36R0101_00023
    CloseMessage
    GoTo _09B2
_08F5:
    GetPartyMonMoveCount VAR_0x8002, VAR_0x8006
    CompareVar VAR_0x8002, 3
    GoToIf 3, _0F27
    BufferPartyMonNickname 0, VAR_0x8006
    Message msg_0115_D36R0101_00017
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F5F
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenSummaryScreenTeachMove VAR_0x8006, 29
    GetSummarySelectedMoveSlot VAR_0x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8001, 4
    GoToIf 1, _0F79
    @ HGSS: BufferPartyMonMoveName 1, VAR_SPECIAL_x8006, VAR_SPECIAL_x8001
    Message msg_0115_D36R0101_00018
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F5F
    ResetPartyMonMoveSlot_Unused VAR_0x8006, VAR_0x8001, MOVE_HEADBUTT
    Message msg_0115_D36R0101_00020
    PlaySE SEQ_SE_DP_KON_sseq
    WaitSE SEQ_SE_DP_KON_sseq
    WaitTime 30, VAR_RESULT
    Message msg_0115_D36R0101_00024
    WaitTime 32, VAR_RESULT
    Message msg_0115_D36R0101_00025
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    WaitTime 16, VAR_RESULT
    PlayCry VAR_0x8005, 0
    GoTo _0F95
_09B2:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _08CD
    GetPartyMonSpecies VAR_RESULT, VAR_0x8005
    SetVar VAR_0x8006, VAR_RESULT
    CompareVar VAR_0x8005, 0
    GoToIf 1, _08DA
    CheckPartyMonHasMove VAR_RESULT, MOVE_HEADBUTT, VAR_0x8006
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08E5
    @ HGSS: ScrCmd_656 VAR_SPECIAL_x8006, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08F5
    Message msg_0115_D36R0101_00016
    CloseMessage
    GoTo _09B2
_0A2B:
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _0FA2
    GoTo _0FB5
_0A3C:
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _0FB5
    GoTo _0FC8
_0A4D:
    Message msg_0115_D36R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0A58:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0A62:
    ApplyMovement obj_D36R0101_dancer, _2384
    WaitMovement
    Message msg_0115_D36R0101_00029
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _2392
    WaitMovement
    Message msg_0115_D36R0101_00030
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0FE1
    Message msg_0115_D36R0101_00031
    GoTo _1031
_0A9C:
    WaitMovement
    Message msg_0115_D36R0101_00029
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _2392
    WaitMovement
    Message msg_0115_D36R0101_00030
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0FE1
    Message msg_0115_D36R0101_00031
    GoTo _1031
_0ACE:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0AE2:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0AF6:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _107E
    ApplyMovement LOCALID_PLAYER, _23D4
    GoTo _0B11
_0B11:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _10A1
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _23DE
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 8
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
_0B72:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0115_D36R0101_00028
    WaitButton
    CloseMessage
    CheckItem ITEM_AZURE_FLUTE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _10DB
    ReleaseAll
    End
_0B9A:
    CompareVar VAR_HGSS_UNK_40FE, 4
    GoToIf 4, _0B72
    GoToIfUnset FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS, _0B72
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x06
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _1195
    GoTo _0B72
_0BD0:
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_SPIKY_EAR_PICHU
    GoTo _119B
_0BDA:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _130C
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _23EC
    GoTo _0BF5
_0BF5:
    WaitMovement
    PlayCry SPECIES_PICHU, 0
    Message msg_0115_D36R0101_00043
    WaitCry
    CloseMessage
    Call _0C40
    CompareVar VAR_0x8004, 1
    GoToIf 4, _135F
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _136A
    ApplyMovement obj_D36R0101_gsoldman1, _23F2
    GoTo _1385
_0C40:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 0, _13AB
    SetVarFromValue VAR_0x8004, 1
    GoTo _13B3
_0C5D:
    Call _13B5
    ReleaseAll
    End
_0C67:
    Message msg_0115_D36R0101_00055
    WaitButton
    CloseMessage
    Return
_0C70:
    ReleaseAll
    End
_0C74:
    BlackOutFromBattle
    ReleaseAll
    End
_0C7A:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _06EF
_0C84:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _0C95
    End
_0C95:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 1
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    GoToIfSet FLAG_HGSS_FOUND_FIRST_FARFETCHD, _13D5
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _13E8
    End
_0CE9:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 52
    GoToIf 5, _13F6
    GoTo _1409
_0D0A:
    CompareVar VAR_MAP_LOCAL_0x01, 62
    GoToIf 5, _0CE9
    GoTo _1442
_0D1D:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _1459
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _23F8
    GoTo _1480
_0D4A:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 52
    GoToIf 5, _1486
    GoTo _1499
_0D65:
    CompareVar VAR_MAP_LOCAL_0x01, 62
    GoToIf 5, _0D4A
    GoTo _14A7
_0D78:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _2406
    WaitMovement
    ReleaseAll
    End
_0D86:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 52
    GoToIf 5, _14CB
    GoTo _14DE
_0DA1:
    CompareVar VAR_MAP_LOCAL_0x01, 62
    GoToIf 5, _0D86
    GoTo _14EC
_0DB4:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _2406
    WaitMovement
    ReleaseAll
    End
_0DC2:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _14FA
    GoTo _150D
_0DDD:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0DC2
    GoTo _1524
_0DF0:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _1563
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2410
    WaitMovement
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    GoTo _15AC
_0E31:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _15C6
    GoTo _15D9
_0E4C:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0E31
    GoTo _15FF
_0E5F:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _241E
    WaitMovement
    ReleaseAll
    End
_0E6D:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _160D
    GoTo _1620
_0E88:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0E6D
    GoTo _1646
_0E9B:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _241E
    WaitMovement
    ReleaseAll
    End
_0EA9:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _1654
    GoTo _1667
_0EC4:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0EA9
    GoTo _1675
_0ED7:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2406
    WaitMovement
    ReleaseAll
    End
_0EE5:
    .short SCRCMD_UNUSED_06A
    .short obj_D36R0101_tsure_poke_static_farfetchd_2
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 54
    GoToIf 5, _1689
    GoTo _169C
_0F00:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0EE5
    GoTo _16BC
_0F13:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _241E
    WaitMovement
    ReleaseAll
    End
_0F27:
    BufferPartyMonNickname 0, VAR_0x8006
    ResetPartyMonMoveSlot_Unused VAR_0x8006, VAR_0x8002, MOVE_HEADBUTT
    Message msg_0115_D36R0101_00021
    WaitTime 30, VAR_RESULT
    Message msg_0115_D36R0101_00026
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    WaitTime 32, VAR_RESULT
    PlayCry VAR_0x8005, 0
    Message msg_0115_D36R0101_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0F5F:
    Message msg_0115_D36R0101_00019
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _16CA
    GoTo _08C0
_0F79:
    Message msg_0115_D36R0101_00019
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _16CA
    GoTo _08C0
_0F95:
    Message msg_0115_D36R0101_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0FA2:
    NPCMessage msg_0115_D36R0101_00002
    End
_0FB5:
    NPCMessage msg_0115_D36R0101_00001
    End
_0FC8:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0115_D36R0101_00000
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_40F4, 0
    ReleaseAll
    End
_0FE1:
    Message msg_0115_D36R0101_00032
    CloseMessage
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 50
    GoToIf 1, _1772
    CompareVar VAR_MAP_LOCAL_0x01, 51
    GoToIf 1, _1772
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1799
    ApplyMovement LOCALID_PLAYER, _2428
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _243A
    GoTo _17AD
_1031:
    CloseMessage
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 50
    GoToIf 1, _1772
    CompareVar VAR_MAP_LOCAL_0x01, 51
    GoToIf 1, _1772
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1799
    ApplyMovement LOCALID_PLAYER, _2428
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _243A
    GoTo _17AD
_107E:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _17B9
    ApplyMovement LOCALID_PLAYER, _2454
    ApplyMovement obj_D36R0101_gsmiddleman1, _22C4
    GoTo _0B11
_10A1:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 8
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
_10DB:
    GoToIfSet FLAG_HGSS_SG_3FC7, _0C70
    Message msg_0115_D36R0101_00071
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C70
    StopMusic
    PlayMusic SEQ_GS_PHC_sseq
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0115_D36R0101_00069
    CloseMessage
    PlayCry SPECIES_CELEBI, 0
    WaitCry
    ApplyMovement LOCALID_PLAYER, _2466
    WaitMovement
    @ HGSS: ScrCmd_810
    SetPosition 19, 17, 0, 56, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _2470
    ApplyMovement 19, _2476
    Message msg_0115_D36R0101_00070
    CloseMessage
    CompleteStartWildBattle SPECIES_CELEBI, 45, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C74
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _182E
    SetPosition 19, 6666, 0, 6666, DIR_SOUTH
    SetFlag FLAG_HGSS_SG_3FC7
    ReleaseAll
    End
_1195:
    GoTo _1834
_119B:
    LockAll
    StopMusic
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_SPIKY_EAR_PICHU
    AddObject obj_D36R0101_tsure_poke_static_pichu_spiky
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _247C
    WaitMovement
    PlayCry SPECIES_PICHU, 0
    WaitCry
    ApplyMovement LOCALID_PLAYER, _2466
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _248E
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _24B4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0115_D36R0101_00038
    CloseMessage
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _24DA
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _24E8
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _251A
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _2528
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _254A
    WaitMovement
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_OLD_MAN
    AddObject obj_D36R0101_gsoldman1
    ApplyMovement obj_D36R0101_gsoldman1, _2564
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _2576
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _25D0
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _260A
    WaitMovement
    Message msg_0115_D36R0101_00046
    CloseMessage
    ApplyMovement obj_D36R0101_gsoldman1, _2610
    WaitMovement
    Message msg_0115_D36R0101_00047
    CloseMessage
    ApplyMovement obj_D36R0101_gsoldman1, _261A
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _2628
    ApplyMovement LOCALID_PLAYER, _2636
    WaitMovement
    Message msg_0115_D36R0101_00048
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _263C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _2646
    WaitMovement
    Message msg_0115_D36R0101_00049
    CloseMessage
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _2650
    WaitMovement
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _2656
    WaitMovement
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _265C
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _2662
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0115_D36R0101_00039
    PlayCry SPECIES_PICHU, 0
    Message msg_0115_D36R0101_00043
    WaitCry
    CloseMessage
    Call _0C40
    CompareVar VAR_0x8004, 1
    CallIf 4, _13B5
    CompareVar VAR_0x8004, 0
    CallIf 1, _18F5
    ReleaseAll
    End
_130C:
    ApplyMovement obj_D36R0101_tsure_poke_static_pichu_spiky, _2674
    WaitMovement
    PlayCry SPECIES_PICHU, 0
    Message msg_0115_D36R0101_00043
    WaitCry
    CloseMessage
    Call _0C40
    CompareVar VAR_0x8004, 1
    GoToIf 4, _135F
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _136A
    ApplyMovement obj_D36R0101_gsoldman1, _23F2
    GoTo _1385
_135F:
    Message msg_0115_D36R0101_00042
    WaitButton
    CloseMessage
    ReleaseAll
    End
_136A:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _1937
    ApplyMovement obj_D36R0101_gsoldman1, _267A
    GoTo _1385
_1385:
    WaitMovement
    Message msg_0115_D36R0101_00052
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1965
    ApplyMovement LOCALID_PLAYER, _2680
    GoTo _1980
_13AB:
    SetVarFromValue VAR_0x8004, 0
    Return
_13B3:
    Return
_13B5:
    Message msg_0115_D36R0101_00050
    WaitButton
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _1998
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_412B, 1
    Return
_13D5:
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _19A0
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    End
_13E8:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    End
_13F6:
    CompareVar VAR_MAP_LOCAL_0x01, 62
    GoToIf 5, _0D1D
    GoTo _19AE
_1409:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _19E7
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _268A
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 1
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _1A0E
_1442:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 5, _1A14
    GoTo _1A27
_1459:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _1480
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _268A
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 1
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    WaitMovement
    ReleaseAll
    End
_1480:
    WaitMovement
    ReleaseAll
    End
_1486:
    CompareVar VAR_MAP_LOCAL_0x01, 62
    GoToIf 5, _0D78
    GoTo _1A5F
_1499:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _2406
    WaitMovement
    ReleaseAll
    End
_14A7:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _2406
    WaitMovement
    GoToIfSet FLAG_HGSS_FARFETCHD_NOTICED_YOU, _1A6D
    Message msg_0115_D36R0101_00035
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_FARFETCHD_NOTICED_YOU
    ReleaseAll
    End
_14CB:
    CompareVar VAR_MAP_LOCAL_0x01, 62
    GoToIf 5, _0DB4
    GoTo _1A71
_14DE:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _2406
    WaitMovement
    ReleaseAll
    End
_14EC:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _241E
    WaitMovement
    ReleaseAll
    End
_14FA:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0DF0
    GoTo _1A7F
_150D:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _1AC4
    GoTo _1AD7
_1524:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1B05
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2410
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    GoTo _1B38
_1563:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _15AC
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _268A
    WaitMovement
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    GoToIfSet FLAG_HGSS_UNK_126, _1B3E
    Message msg_0115_D36R0101_00036
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_126
    ReleaseAll
    End
_15AC:
    GoToIfSet FLAG_HGSS_UNK_126, _1B3E
    Message msg_0115_D36R0101_00036
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_126
    ReleaseAll
    End
_15C6:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0E5F
    GoTo _1B42
_15D9:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 1
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2698
    WaitMovement
    ReleaseAll
    End
_15FF:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2698
    WaitMovement
    ReleaseAll
    End
_160D:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0E9B
    GoTo _1B50
_1620:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 1
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _241E
    WaitMovement
    ReleaseAll
    End
_1646:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _241E
    WaitMovement
    ReleaseAll
    End
_1654:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0ED7
    GoTo _1B5E
_1667:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2406
    WaitMovement
    ReleaseAll
    End
_1675:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _241E
    WaitMovement
    ReleaseAll
    End
_1689:
    CompareVar VAR_MAP_LOCAL_0x01, 64
    GoToIf 5, _0F13
    GoTo _1B72
_169C:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _237A
    WaitMovement
    ReleaseAll
    End
_16BC:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2698
    WaitMovement
    ReleaseAll
    End
_16CA:
    BufferPartyMonNickname 0, VAR_0x8006
    Message msg_0115_D36R0101_00017
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F5F
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenSummaryScreenTeachMove VAR_0x8006, 29
    GetSummarySelectedMoveSlot VAR_0x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8001, 4
    GoToIf 1, _0F79
    @ HGSS: BufferPartyMonMoveName 1, VAR_SPECIAL_x8006, VAR_SPECIAL_x8001
    Message msg_0115_D36R0101_00018
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0F5F
    ResetPartyMonMoveSlot_Unused VAR_0x8006, VAR_0x8001, MOVE_HEADBUTT
    Message msg_0115_D36R0101_00020
    PlaySE SEQ_SE_DP_KON_sseq
    WaitSE SEQ_SE_DP_KON_sseq
    WaitTime 30, VAR_RESULT
    Message msg_0115_D36R0101_00024
    WaitTime 32, VAR_RESULT
    Message msg_0115_D36R0101_00025
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    WaitTime 16, VAR_RESULT
    PlayCry VAR_0x8005, 0
    GoTo _0F95
_1772:
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1B80
    ApplyMovement LOCALID_PLAYER, _2428
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _26A2
    GoTo _1BA9
_1799:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _26B8
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    GoTo _1BCA
_17AD:
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    GoTo _1BCA
_17B9:
    ApplyMovement LOCALID_PLAYER, _26D6
    ApplyMovement obj_D36R0101_gsmiddleman1, _22C4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _10A1
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _23DE
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 8
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
_182E:
    SetFlag FLAG_HGSS_SG_3FB0
    Return
_1834:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _26E8
    WaitMovement
    FadeOutBGM 0, 30
    Common_SetCounterpartBGM
    ClearFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    AddObject obj_D36R0101_var_1
    AddObject obj_D36R0101_tsure_poke_static_marill
    ApplyMovement obj_D36R0101_var_1, _2702
    ApplyMovement obj_D36R0101_tsure_poke_static_marill, _270C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _2736
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0115_D36R0101_00057, msg_0115_D36R0101_00056
    CloseMessage
    Common_FadeToDefaultMusic
    FadeScreen 6, 6, 0, COLOR_WHITE
    WaitFadeScreen
    WaitTime 15, VAR_RESULT
    FadeScreen 6, 6, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement LOCALID_PLAYER, _273C
    ApplyMovement obj_D36R0101_var_1, _275E
    WaitMovement
    MessageGendered msg_0115_D36R0101_00059, msg_0115_D36R0101_00058
    CloseMessage
    @ HGSS: ScrCmd_810
    SetVarFromValue VAR_HGSS_UNK_40FE, 1
    ClearFlag FLAG_HGSS_HIDE_ROUTE_22_GIOVANNI_RIVAL
    ClearFlag FLAG_HGSS_HIDE_ROUTE_22_FRIEND
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_FRIEND
    Warp MAP_HEADER_HGSS_ROUTE_22, 954, 280, DIR_SOUTH
    FadeScreen 6, 15, 1, COLOR_WHITE
    WaitFadeScreen
    ReleaseAll
    End
_18F5:
    Message msg_0115_D36R0101_00052
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _2770
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1BE5
    ApplyMovement obj_D36R0101_gsoldman1, _23F2
    GoTo _1C23
_1937:
    ApplyMovement obj_D36R0101_gsoldman1, _277A
    WaitMovement
    Message msg_0115_D36R0101_00052
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1965
    ApplyMovement LOCALID_PLAYER, _2680
    GoTo _1980
_1965:
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 5, _1C59
    ApplyMovement LOCALID_PLAYER, _2770
    GoTo _1980
_1980:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _1C79
    GoTo _1C98
_1998:
    SetVarFromValue VAR_HGSS_UNK_412B, 1
    Return
_19A0:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    End
_19AE:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _1C9C
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _2780
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    GoTo _1CC3
_19E7:
    CompareVar VAR_RESULT, 0
    GoToIf 5, _1A0E
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _278E
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    WaitMovement
    ReleaseAll
    End
_1A0E:
    WaitMovement
    ReleaseAll
    End
_1A14:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1A27
    GoTo _1CC9
_1A27:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _2780
    WaitMovement
    GoToIfSet FLAG_HGSS_UNK_126, _1D0E
    Message msg_0115_D36R0101_00036
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_126
    ReleaseAll
    End
_1A5F:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _237A
    WaitMovement
    ReleaseAll
    End
_1A6D:
    ReleaseAll
    End
_1A71:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _237A
    WaitMovement
    ReleaseAll
    End
_1A7F:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _1D12
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2780
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 1
    GoTo _1D45
_1AC4:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _1AD7
    GoTo _1D4B
_1AD7:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _279C
    WaitMovement
    ReleaseAll
    End
_1B05:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _1B38
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2780
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 1
    WaitMovement
    ReleaseAll
    End
_1B38:
    WaitMovement
    ReleaseAll
    End
_1B3E:
    ReleaseAll
    End
_1B42:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2698
    WaitMovement
    ReleaseAll
    End
_1B50:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2698
    WaitMovement
    ReleaseAll
    End
_1B5E:
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _237A
    WaitMovement
    ReleaseAll
    End
_1B72:
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2698
    WaitMovement
    ReleaseAll
    End
_1B80:
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _27AA
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1D86
    ApplyMovement obj_D36R0101_dancer, _27C4
    GoTo _1DD6
_1BA9:
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1D86
    ApplyMovement obj_D36R0101_dancer, _27C4
    GoTo _1DD6
_1BCA:
    CompareVar VAR_0x8004, 40
    GoToIf 5, _1D86
    ApplyMovement obj_D36R0101_dancer, _27C4
    GoTo _1DD6
_1BE5:
    ApplyMovement obj_D36R0101_gsoldman1, _267A
    WaitMovement
    PlayFanfare SEQ_FANFA4_sseq
    BufferPlayerName 0
    Message msg_0115_D36R0101_00044
    WaitFanfare
    Message msg_0115_D36R0101_00053
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1E1E
    ApplyMovement LOCALID_PLAYER, _27CA
    GoTo _1ED9
_1C23:
    WaitMovement
    PlayFanfare SEQ_FANFA4_sseq
    BufferPlayerName 0
    Message msg_0115_D36R0101_00044
    WaitFanfare
    Message msg_0115_D36R0101_00053
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1E1E
    ApplyMovement LOCALID_PLAYER, _27CA
    GoTo _1ED9
_1C59:
    ApplyMovement LOCALID_PLAYER, _27D4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _1C79
    GoTo _1C98
_1C79:
    GetPlayerDir VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _1BE5
    ApplyMovement obj_D36R0101_gsoldman1, _23F2
    GoTo _1C23
_1C98:
    ReleaseAll
    End
_1C9C:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1CC3
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _278E
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    WaitMovement
    ReleaseAll
    End
_1CC3:
    WaitMovement
    ReleaseAll
    End
_1CC9:
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _1F8C
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _23F8
    WaitMovement
    GoToIfSet FLAG_HGSS_UNK_126, _2010
    Message msg_0115_D36R0101_00036
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_126
    ReleaseAll
    End
_1D0E:
    ReleaseAll
    End
_1D12:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1D45
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _279C
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    WaitMovement
    ReleaseAll
    End
_1D45:
    WaitMovement
    ReleaseAll
    End
_1D4B:
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 1, _2014
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 1
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _268A
    WaitMovement
    ReleaseAll
    End
_1D86:
    ApplyMovement obj_D36R0101_dancer, _27E2
    WaitMovement
    Message msg_0115_D36R0101_00033
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _27E8
    WaitMovement
    Message msg_0115_D36R0101_00034
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _27EE
    WaitMovement
    RemoveObject obj_D36R0101_dancer
    SetFlag FLAG_HGSS_UNK_23D
    Common_FadeToDefaultMusic
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _27FC
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E9, 1
    End
_1DD6:
    WaitMovement
    Message msg_0115_D36R0101_00033
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _27E8
    WaitMovement
    Message msg_0115_D36R0101_00034
    CloseMessage
    ApplyMovement obj_D36R0101_dancer, _27EE
    WaitMovement
    RemoveObject obj_D36R0101_dancer
    SetFlag FLAG_HGSS_UNK_23D
    Common_FadeToDefaultMusic
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _27FC
    WaitMovement
    LockObject LOCALID_COMPLETE_FOLLOWER
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_40E9, 1
    End
_1E1E:
    ApplyMovement LOCALID_PLAYER, _2812
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _20AF
    Common_FadeToDefaultMusic
    @ HGSS: GiveSpikyEarPichu
    RemoveObject obj_D36R0101_tsure_poke_static_pichu_spiky
    SetVarFromValue VAR_HGSS_UNK_412B, 2
    Message msg_0115_D36R0101_00040
    WaitFanfare
    Message msg_0115_D36R0101_00045
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _2145
    CloseMessage
    GetPartyCount VAR_MAP_LOCAL_0x09
    SubVar VAR_MAP_LOCAL_0x09, 1
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_MAP_LOCAL_0x09, VAR_MAP_LOCAL_0x0A
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 1, _2145
    BufferPartyMonNickname 0, VAR_MAP_LOCAL_0x09
    Message msg_0115_D36R0101_00054
    Message msg_0115_D36R0101_00051
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _2167
    ApplyMovement obj_D36R0101_gsoldman1, _281C
    GoTo _217B
_1ED9:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _20AF
    Common_FadeToDefaultMusic
    @ HGSS: GiveSpikyEarPichu
    RemoveObject obj_D36R0101_tsure_poke_static_pichu_spiky
    SetVarFromValue VAR_HGSS_UNK_412B, 2
    Message msg_0115_D36R0101_00040
    WaitFanfare
    Message msg_0115_D36R0101_00045
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _2145
    CloseMessage
    GetPartyCount VAR_MAP_LOCAL_0x09
    SubVar VAR_MAP_LOCAL_0x09, 1
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_MAP_LOCAL_0x09, VAR_MAP_LOCAL_0x0A
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 1, _2145
    BufferPartyMonNickname 0, VAR_MAP_LOCAL_0x09
    Message msg_0115_D36R0101_00054
    Message msg_0115_D36R0101_00051
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _2167
    ApplyMovement obj_D36R0101_gsoldman1, _281C
    GoTo _217B
_1F8C:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_FARFETCHD, 0
    Message msg_0115_D36R0101_00003
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd, _282A
    WaitMovement
    RemoveObject obj_D36R0101_tsure_poke_static_farfetchd
    Message msg_0115_D36R0101_00037
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS2, 2
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_1_LOST
    SetFlag FLAG_HGSS_FOUND_FIRST_FARFETCHD
    GoToIfSet FLAG_HGSS_FOUND_SECOND_FARFETCHD, _2187
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_1_FOUND
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 15, 65, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 5, VAR_0x8004
    Message msg_0115_D36R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_2010:
    ReleaseAll
    End
_2014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_FARFETCHD, 0
    Message msg_0115_D36R0101_00003
    CloseMessage
    ApplyMovement obj_D36R0101_tsure_poke_static_farfetchd_2, _2830
    WaitMovement
    RemoveObject obj_D36R0101_tsure_poke_static_farfetchd_2
    Message msg_0115_D36R0101_00037
    WaitButton
    CloseMessage
    CallIfUnset FLAG_HGSS_FOUND_FIRST_FARFETCHD, _223E
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS1, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS2, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS3, 2
    SetVarFromValue VAR_HGSS_FARFETCHD2_STICKS4, 2
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_2_LOST
    SetFlag FLAG_HGSS_FOUND_SECOND_FARFETCHD
    GoToIfSet FLAG_HGSS_FOUND_FIRST_FARFETCHD, _2187
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_1_FOUND
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 15, 65, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 5, VAR_0x8004
    Message msg_0115_D36R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_20AF:
    @ HGSS: GiveSpikyEarPichu
    RemoveObject obj_D36R0101_tsure_poke_static_pichu_spiky
    SetVarFromValue VAR_HGSS_UNK_412B, 2
    Message msg_0115_D36R0101_00040
    WaitFanfare
    Message msg_0115_D36R0101_00045
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _2145
    CloseMessage
    GetPartyCount VAR_MAP_LOCAL_0x09
    SubVar VAR_MAP_LOCAL_0x09, 1
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_MAP_LOCAL_0x09, VAR_MAP_LOCAL_0x0A
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 1, _2145
    BufferPartyMonNickname 0, VAR_MAP_LOCAL_0x09
    Message msg_0115_D36R0101_00054
    Message msg_0115_D36R0101_00051
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _2167
    ApplyMovement obj_D36R0101_gsoldman1, _281C
    GoTo _217B
_2145:
    Message msg_0115_D36R0101_00051
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 5, _2167
    ApplyMovement obj_D36R0101_gsoldman1, _281C
    GoTo _217B
_2167:
    ApplyMovement obj_D36R0101_gsoldman1, _2836
    WaitMovement
    RemoveObject obj_D36R0101_gsoldman1
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_OLD_MAN
    Return
_217B:
    WaitMovement
    RemoveObject obj_D36R0101_gsoldman1
    SetFlag FLAG_HGSS_HIDE_ILEX_FOREST_OLD_MAN
    Return
_2187:
    ClearFlag FLAG_HGSS_HIDE_ILEX_CUT_MASTER
    AddObject obj_D36R0101_gsfighter
    ClearFlag FLAG_HGSS_HIDE_FARFETCHD_2_FOUND
    WaitTime 20, VAR_0x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_ILEX_FOREST, 15, 65, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 5, VAR_0x8004
    Message msg_0115_D36R0101_00002
    WaitButton
    CloseMessage
    ApplyMovement obj_D36R0101_gsfighter, _2848
    ApplyMovement LOCALID_PLAYER, _2852
    WaitMovement
    GoToIfSet FLAG_HGSS_GOT_HM01, _2246
    Message msg_0115_D36R0101_00006
    SetVar VAR_0x8004, ITEM_HM01
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _2251
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_HIDE_ILEX_CUT_MASTER
    SetFlag FLAG_HGSS_HIDE_ILEX_APPRENTICE
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_1_LOST
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_2_LOST
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_1_FOUND
    SetFlag FLAG_HGSS_HIDE_FARFETCHD_2_FOUND
    SetFlag FLAG_HGSS_GOT_HM01
    ClearFlag FLAG_HGSS_UNK_1AE
    ClearFlag FLAG_HGSS_UNK_1AC
    Message msg_0115_D36R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_223E:
    SetVarFromValue VAR_HGSS_FARFETCHD1_STICKS1, 1
    Return
_2246:
    Message msg_0115_D36R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_2251:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_225B:
    FacePlayer
    Message msg_0115_D36R0101_00074
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_2268:
    EmoteExclamationMark
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_2272:
    JumpNearFastNorth
    EndMovement
    .balign 4, 0
_2278:
    LockDir
    WalkSlowSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_2286:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_228C:
    Delay8 2
    FaceNorth
    EndMovement
    .balign 4, 0
_2296:
    EmoteExclamationMark
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_22A0:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_22AE:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_22C4:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_22CE:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_22D4:
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalEast
    Delay8
    EndMovement
    .balign 4, 0
_22E6:
    WalkNormalSouth
    Delay8
    EndMovement
    .balign 4, 0
_22F0:
    Delay8
    JumpOnSpotFastEast 2
    LockDir
    JumpNearFastNorth
    JumpNearFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_230A:
    WalkOnSpotNormalWest
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_231C:
    WalkNormalWest 3
    Delay16
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_232A:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_2330:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_2336:
    WalkNormalWest 4
    WalkNormalNorth 6
    WalkOnSpotNormalSouth
    Delay8 6
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_234C:
    LockDir
    JumpNearFastSouth
    UnlockDir
    WalkOnSpotNormalNorth
    WalkNormalWest 3
    Delay8
    WalkOnSpotNormalEast
    Delay8 4
    WalkOnSpotNormalNorth
    JumpOnSpotFastNorth
    WalkNormalNorth 10
    EndMovement
    .balign 4, 0
_237A:
    FaceWest
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_2384:
    WalkNormalSouth
    WalkNormalEast 3
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_2392:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_23D4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_23DE:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_23EC:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_23F2:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_23F8:
    EmoteExclamationMark
    WalkFastEast 7
    FaceWest
    EndMovement
    .balign 4, 0
_2406:
    FaceSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_2410:
    EmoteExclamationMark
    WalkFastEast 8
    FaceWest
    EndMovement
    .balign 4, 0
_241E:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_2428:
    FaceWest
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_243A:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    JumpOnSpotFastEast 3
    EndMovement
    .balign 4, 0
_2454:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_2466:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_2470:
    FaceEast
    EndMovement
    .balign 4, 0
_2476:
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_247C:
    LockDir
    JumpFarEast
    UnlockDir
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_248E:
    WalkFastSouth 7
    JumpOnSpotFastWest
    WalkFastWest 4
    WalkFastNorth 4
    WalkFastEast 4
    WalkFastSouth 4
    WalkFastWest 2
    FaceNorth
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_24B4:
    Delay8 3
    FaceSouth
    Delay8
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    Delay16
    WalkOnSpotNormalWest
    Delay16
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_24DA:
    WalkNormalEast
    WalkNormalSouth
    FaceSouth
    EndMovement
    .balign 4, 0
_24E8:
    LockDir
    JumpNearFastEast
    UnlockDir
    JumpOnSpotFastNorth
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
_251A:
    EmoteExclamationMark
    Delay8
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_2528:
    LockDir
    JumpNearFastSouth
    UnlockDir
    Delay16
    JumpOnSpotFastWest
    WalkFastWest 7
    WalkFastNorth 13
    WalkNormalEast
    EndMovement
    .balign 4, 0
_254A:
    Delay16 2
    WalkFastSouth
    WalkFastWest 6
    JumpOnSpotFastNorth
    WalkFastNorth 13
    WalkFastWest
    EndMovement
    .balign 4, 0
_2564:
    Delay16 5
    WalkSlowSouth 10
    WalkSlowEast 4
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_2576:
    WalkFastSouth 12
    WalkFastEast 6
    WalkFastNorth 4
    WalkFastWest 3
    WalkFastSouth 4
    WalkFastEast 3
    LockDir
    JumpNearFastWest
    UnlockDir
    FaceSouth 6
    LockDir
    WalkSlowWest
    UnlockDir
    FaceWest 6
    FaceNorth 6
    LockDir
    WalkSlowEast
    UnlockDir
    FaceEast 6
    LockDir
    WalkSlowWest
    UnlockDir
    EndMovement
    .balign 4, 0
_25D0:
    WalkFastSouth 13
    WalkFastEast 7
    JumpOnSpotFastNorth
    JumpOnSpotFastWest
    Delay8 4
    LockDir
    JumpNearFastEast
    UnlockDir
    FaceSouth 6
    FaceEast 6
    FaceNorth 6
    FaceWest 6
    Delay32
    WalkNormalWest
    EndMovement
    .balign 4, 0
_260A:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_2610:
    WalkOnSpotNormalNorth
    Delay16
    EndMovement
    .balign 4, 0
_261A:
    WalkOnSpotNormalSouth
    Delay16
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_2628:
    Delay16
    WalkOnSpotNormalNorth
    Delay16
    EndMovement
    .balign 4, 0
_2636:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_263C:
    JumpOnSpotFastNorth
    JumpOnSpotFastEast
    EndMovement
    .balign 4, 0
_2646:
    JumpNearFastWest
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_2650:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_2656:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_265C:
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_2662:
    EmoteExclamationMark
    Delay8
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_2674:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_267A:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_2680:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_268A:
    EmoteExclamationMark
    WalkFastSouth 10
    FaceNorth
    EndMovement
    .balign 4, 0
_2698:
    FaceNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_26A2:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_26B8:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    JumpOnSpotFastEast 3
    EndMovement
    .balign 4, 0
_26D6:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_26E8:
    FaceSouth
    FaceSouth
    JumpFarSouth
    LockDir
    JumpNearFastNorth
    LockDir
    EndMovement
    .balign 4, 0
_2702:
    WalkNormalSouth 11
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_270C:
    WalkNormalSouth 8
    WalkOnSpotNormalEast
    WalkNormalEast
    LockDir
    WalkNormalSouth
    Delay8
    UnlockDir
    WalkOnSpotNormalWest
    Delay8
    WalkNormalWest
    EndMovement
    .balign 4, 0
_2736:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_273C:
    EmoteExclamationMark
    Delay8
    WalkOnSpotNormalNorth
    Delay8
    WalkOnSpotNormalWest
    Delay8
    WalkOnSpotNormalSouth
    Delay8
    EndMovement
    .balign 4, 0
_275E:
    Delay16
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_2770:
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_277A:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_2780:
    EmoteExclamationMark
    WalkFastNorth 10
    FaceSouth
    EndMovement
    .balign 4, 0
_278E:
    EmoteExclamationMark
    WalkFastWest 7
    FaceEast
    EndMovement
    .balign 4, 0
_279C:
    EmoteExclamationMark
    WalkFastWest 8
    FaceEast
    EndMovement
    .balign 4, 0
_27AA:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_27C4:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_27CA:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_27D4:
    WalkNormalEast
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_27E2:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_27E8:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_27EE:
    WalkNormalWest 2
    WalkNormalNorth 2
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_27FC:
    WalkNormalEast 3
    WalkNormalSouth 2
    WalkNormalEast
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_2812:
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_281C:
    WalkSlowSouth 2
    WalkSlowWest 4
    WalkSlowNorth 12
    EndMovement
    .balign 4, 0
_282A:
    WalkOnSpotFastSouth 5
    EndMovement
    .balign 4, 0
_2830:
    WalkOnSpotFastEast 5
    EndMovement
    .balign 4, 0
_2836:
    WalkOnSpotNormalEast
    Delay16
    WalkSlowWest 4
    WalkSlowNorth 10
    EndMovement
    .balign 4, 0
_2848:
    WalkNormalNorth 10
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_2852:
    Delay8 12
    FaceWest
    EndMovement
    .balign 4, 0
_285C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
