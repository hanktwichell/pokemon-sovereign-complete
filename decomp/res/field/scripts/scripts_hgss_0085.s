#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0108.h"

#define obj_D32R0401_var_10 11
#define obj_D32R0401_var_2 12

    ScriptEntry scr_seq_D32R0401_000
    ScriptEntry scr_seq_D32R0401_001
    ScriptEntry scr_seq_D32R0401_002
    ScriptEntry scr_seq_D32R0401_003
    ScriptEntry scr_seq_D32R0401_004
    ScriptEntry scr_seq_D32R0401_005
    ScriptEntry scr_seq_D32R0401_006
    ScriptEntry scr_seq_D32R0401_007
    ScriptEntry scr_seq_D32R0401_008
    ScriptEntry scr_seq_D32R0401_009
    ScriptEntry scr_seq_D32R0401_010
    ScriptEntry scr_seq_D32R0401_011
    ScriptEntry scr_seq_D32R0401_012
    ScriptEntry scr_seq_D32R0401_013
    ScriptEntry scr_seq_D32R0401_014
    ScriptEntry scr_seq_D32R0401_015
    ScriptEntry scr_seq_D32R0401_016
    ScriptEntry scr_seq_D32R0401_017
    ScriptEntry scr_seq_D32R0401_018
    ScriptEntry scr_seq_D32R0401_019
    ScriptEntry scr_seq_D32R0401_020
    ScriptEntry scr_seq_D32R0401_021
    ScriptEntryEnd
scr_seq_D32R0401_021:
    @ HGSS: BattleHallCountUsedSpecies VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 11
    CallIf 4, _0090
    CompareVar VAR_MAP_LOCAL_0x00, 101
    CallIf 4, _007A
    End
_007A:
    SetObjectEventPos obj_D32R0401_var_10, 8, 11
    SetPosition obj_D32R0401_var_10, 8, 0, 11, DIR_WEST
    Return
_0090:
    SetObjectEventPos obj_D32R0401_var_10, 13, 11
    SetPosition obj_D32R0401_var_10, 13, 0, 11, DIR_WEST
    Return
scr_seq_D32R0401_020:
    CompareVar VAR_HGSS_UNK_4145, 1
    GoToIf 1, _00B5
    End
_00B5:
    GetRandom VAR_MAP_LOCAL_0x07, 100
    CallIfUnset FLAG_HGSS_UNK_234, _00D5
    CompareVar VAR_MAP_LOCAL_0x07, 30
    GoToIf 0, _00DF
    End
_00D5:
    RemoveObject obj_D32R0401_var_2
    SetFlag FLAG_HGSS_UNK_234
    Return
_00DF:
    GoToIfUnset FLAG_HGSS_UNK_AA1, _00EC
    End
_00EC:
    SetFlag FLAG_HGSS_UNK_AA1
    @ HGSS: BattleHallGetTotalStreak VAR_TEMP_x4008
    CompareVar VAR_MAP_LOCAL_0x08, 10000
    GoToIf 4, _011D
    CompareVar VAR_MAP_LOCAL_0x08, 1000
    GoToIf 4, _012B
    CompareVar VAR_MAP_LOCAL_0x08, 500
    GoToIf 4, _0139
    End
_011D:
    GetRandom VAR_HGSS_UNK_4053, 4
    GoTo _0147
    End
_012B:
    GetRandom VAR_HGSS_UNK_4053, 2
    GoTo _0147
    End
_0139:
    SetVarFromValue VAR_HGSS_UNK_4053, 0
    GoTo _0147
    End
_0147:
    ClearFlag FLAG_HGSS_UNK_234
    Call _017D
    AddObject obj_D32R0401_var_2
    End
scr_seq_D32R0401_015:
    GetPlayerGender VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    CallIf 1, _01FB
    CompareVar VAR_MAP_LOCAL_0x00, 1
    CallIf 1, _0203
    Call _017D
    End
_017D:
    CompareVar VAR_HGSS_UNK_4053, 0
    CallIf 1, _01B3
    CompareVar VAR_HGSS_UNK_4053, 1
    CallIf 1, _01E3
    CompareVar VAR_HGSS_UNK_4053, 2
    CallIf 1, _01EB
    CompareVar VAR_HGSS_UNK_4053, 3
    CallIf 1, _01F3
    Return
_01B3:
    GetPlayerGender VAR_MAP_LOCAL_0x09
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 1, _01D3
    CompareVar VAR_MAP_LOCAL_0x09, 1
    GoToIf 1, _01DB
    Return
_01D3:
    SetVarFromValue VAR_OBJ_GFX_ID_1, 97
    Return
_01DB:
    SetVarFromValue VAR_OBJ_GFX_ID_1, 0
    Return
_01E3:
    SetVarFromValue VAR_OBJ_GFX_ID_1, 365
    Return
_01EB:
    SetVarFromValue VAR_OBJ_GFX_ID_1, 366
    Return
_01F3:
    SetVarFromValue VAR_OBJ_GFX_ID_1, 354
    Return
_01FB:
    SetVarFromValue VAR_OBJ_GFX_ID_9, 320
    Return
_0203:
    SetVarFromValue VAR_OBJ_GFX_ID_9, 317
    Return
scr_seq_D32R0401_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    GoTo _0243
    End
scr_seq_D32R0401_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _0243
    End
_0243:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _0868
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _086D
    GoTo _0269
    End
_0269:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _0872
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _0891
    AddMenuEntry 19, 2
    AddMenuEntry 20, 3
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _030E
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0331
    CompareVar VAR_RESULT, 2
    GoToIf 1, _02D3
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0354
    GoTo _02F5
    End
_02D3:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _08A8
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _08AD
    GoTo _0269
    End
_02F5:
    GoTo _02FD
    End
_02FD:
    SetVarFromValue VAR_HGSS_UNK_4145, 0
    Message msg_0108_D32R0401_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_030E:
    SetVarFromValue VAR_HGSS_UNK_4146, 0
    @ HGSS: ScrCmd_633 0, 1, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0377
    GoTo _03A1
    End
_0331:
    SetVarFromValue VAR_HGSS_UNK_4146, 1
    @ HGSS: ScrCmd_633 0, 2, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _038C
    GoTo _03A1
    End
_0354:
    SetVarFromValue VAR_HGSS_UNK_4146, 2
    @ HGSS: ScrCmd_633 0, 1, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0377
    GoTo _03A1
    End
_0377:
    Message msg_0108_D32R0401_00035
    @ HGSS: ScrCmd_444 37, 1, 0, 0
    GoTo _02F5
    End
_038C:
    Message msg_0108_D32R0401_00036
    @ HGSS: ScrCmd_444 37, 2, 0, 0
    GoTo _02F5
    End
_03A1:
    Message msg_0108_D32R0401_00033
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_633 4, VAR_UNK_4146, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_635 VAR_TEMP_x4002, VAR_TEMP_x4005
    CompareVar VAR_MAP_LOCAL_0x02, 255
    GoToIf 5, _03D1
_03D1:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 255
    GoToIf 1, _02F5
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4002, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _07B9
    CompareVar VAR_HGSS_UNK_4146, 1
    GoToIf 1, _0414
    GoTo _042F
    End
_0414:
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4005, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _07B9
    GoTo _042F
    End
_042F:
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _044A
    GoTo _02F5
_044A:
    @ HGSS: ScrCmd_633 1, VAR_UNK_4146, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04D8
    @ HGSS: ScrCmd_633 2, VAR_UNK_4146, VAR_SPECIAL_RESULT
    BufferSpeciesNameFromVar 0, VAR_RESULT, 0, 0
    CompareVar VAR_RESULT, VAR_MAP_LOCAL_0x01
    GoToIf 1, _04D8
    GoTo _0484
    End
_0484:
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x01, 0, 0
    Message msg_0108_D32R0401_00034
    CompleteInitHGSSMenu 1, 1, 1, VAR_RESULT, 1
    AddMenuEntry 42, 0
    AddMenuEntry 43, 1
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _04C8
    GoTo _02F5
    End
_04C8:
    @ HGSS: ScrCmd_633 3, VAR_UNK_4146, VAR_SPECIAL_RESULT
    GoTo _04D8
    End
_04D8:
    GoTo _04E0
    End
_04E0:
    CompareVar VAR_HGSS_UNK_4146, 0
    CallIf 1, _066C
    CompareVar VAR_HGSS_UNK_4146, 1
    CallIf 1, _066C
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    HealParty
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02F5
    CompareVar VAR_HGSS_UNK_4146, 2
    GoToIf 1, _052E
    GoTo _0689
    End
_052E:
    Message msg_0108_D32R0401_00030
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 5, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _057F
    CompareVar VAR_0x8008, 1
    GoToIf 1, _05D7
    GoTo _02F5
    End
_057F:
    Message msg_0108_D32R0401_00031
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _052E
    CloseMessage
    @ HGSS: ScrCmd_226 30, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05C5
    CompareVar VAR_RESULT, 3
    GoToIf 1, _05CD
    GoTo _062F
    End
_05C5:
    GoTo _052E
    End
_05CD:
    GoTo _052E
    End
_05D7:
    Message msg_0108_D32R0401_00031
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _052E
    CloseMessage
    @ HGSS: ScrCmd_227 30, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _061D
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0625
    GoTo _062F
    End
_061D:
    GoTo _052E
    End
_0625:
    GoTo _052E
    End
_062F:
    @ HGSS: ScrCmd_257 108
    @ HGSS: ScrCmd_634 VAR_TEMP_x4001, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0674
    @ HGSS: ScrCmd_257 110
    Message msg_0108_D32R0401_00032
    CompareVar VAR_HGSS_UNK_4146, 2
    CallIf 1, _066C
    Call _08D9
    GoTo _0689
    End
_066C:
    SetVarFromValue VAR_HGSS_UNK_4145, 255
    Return
_0674:
    Call _0685
    Message msg_0108_D32R0401_00057
    GoTo _02F5
    End
_0685:
    Return
_0689:
    CompareVar VAR_HGSS_UNK_4146, 0
    CallIf 1, _0721
    CompareVar VAR_HGSS_UNK_4146, 1
    CallIf 1, _073C
    CompareVar VAR_HGSS_UNK_4146, 2
    CallIf 1, _0757
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    GoTo _06BC
    End
_06BC:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_HGSS_UNK_4146, 0
    CallIf 1, _077D
    CompareVar VAR_HGSS_UNK_4146, 1
    CallIf 1, _0791
    CompareVar VAR_HGSS_UNK_4146, 2
    CallIf 1, _07A5
    IncrementGameRecord RECORD_TIMES_STARTED_BATTLE_FRONTIER_CHALLENGE
    @ HGSS: ScrCmd_436
    @ HGSS: ScrCmd_627 9
    CompareVar VAR_HGSS_UNK_4146, 2
    CallIf 1, _071D
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    End
_071D:
    Return
_0721:
    Message msg_0108_D32R0401_00009
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _07C8
    ApplyMovement VAR_LAST_TALKED, _07F0
    WaitMovement
    Return
_073C:
    Message msg_0108_D32R0401_00009
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _07C8
    ApplyMovement VAR_LAST_TALKED, _07F0
    WaitMovement
    Return
_0757:
    @ HGSS: NPCMsgVar msg_0108_D32R0401_00009
    WaitTime 10, VAR_RESULT
    @ HGSS: ScrCmd_257 109
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _07D8
    ApplyMovement VAR_LAST_TALKED, _0800
    WaitMovement
    Return
_077D:
    ApplyMovement LOCALID_PLAYER, _0818
    ApplyMovement VAR_LAST_TALKED, _0848
    WaitMovement
    Return
_0791:
    ApplyMovement LOCALID_PLAYER, _0818
    ApplyMovement VAR_LAST_TALKED, _0848
    WaitMovement
    Return
_07A5:
    ApplyMovement LOCALID_PLAYER, _082C
    ApplyMovement VAR_LAST_TALKED, _0858
    WaitMovement
    Return
_07B9:
    SetVarFromValue VAR_HGSS_UNK_4145, 0
    Common_GriseousOrbCouldNotBeRemoved
    End
    .balign 4, 0
_07C8:
    WalkNormalWest 4
    WalkNormalSouth 3
    SetInvisible
    EndMovement
    .balign 4, 0
_07D8:
    WalkNormalWest 2
    WalkNormalNorth
    WalkNormalWest 2
    WalkNormalSouth 3
    SetInvisible
    EndMovement
    .balign 4, 0
_07F0:
    WalkNormalWest 3
    WalkNormalSouth 3
    SetInvisible
    EndMovement
    .balign 4, 0
_0800:
    WalkNormalWest
    WalkNormalNorth
    WalkNormalWest 2
    WalkNormalSouth 3
    SetInvisible
    EndMovement
    .balign 4, 0
_0818:
    WalkFasterEast 4
    WalkFasterNorth 3
    FaceWest
    SetVisible
    EndMovement
    .balign 4, 0
_082C:
    WalkFasterEast 2
    WalkFasterSouth
    WalkFasterEast 2
    WalkFasterNorth 3
    FaceWest
    SetVisible
    EndMovement
    .balign 4, 0
_0848:
    WalkFasterNorth 3
    WalkFasterEast 3
    SetVisible
    EndMovement
    .balign 4, 0
_0858:
    WalkFasterNorth 2
    WalkFasterEast 3
    SetVisible
    EndMovement
_0868:
    Message msg_0108_D32R0401_00000
    Return
_086D:
    Message msg_0108_D32R0401_00003
    Return
_0872:
    Message msg_0108_D32R0401_00001
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 16, 0
    AddMenuEntry 17, 1
    Return
_0891:
    Message msg_0108_D32R0401_00004
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 18, 4
    Return
_08A8:
    Message msg_0108_D32R0401_00002
    Return
_08AD:
    Message msg_0108_D32R0401_00005
    Return
scr_seq_D32R0401_001:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    SetVarFromValue VAR_HGSS_UNK_4145, 0
    Message msg_0108_D32R0401_00011
    Call _066C
    Call _08D9
    GoTo _0689
    End
_08D9:
    ShowSavingIcon
    TrySaveGame VAR_RESULT
    HideSavingIcon
    PlaySE SEQ_SE_DP_SAVE_sseq
    WaitSE SEQ_SE_DP_SAVE_sseq
    Return
scr_seq_D32R0401_002:
    Message msg_0108_D32R0401_00012
    @ HGSS: ScrCmd_636 VAR_UNK_4146
    CompareVar VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 1
    CallIf 1, _0914
    CompareVar VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 3
    CallIf 1, _091C
    GoTo _02F5
    End
_0914:
    SetVarFromValue VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 0
    Return
_091C:
    SetVarFromValue VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 2
    Return
scr_seq_D32R0401_003:
    CompareVar VAR_HGSS_UNK_4146, 0
    CallIf 1, _0960
    CompareVar VAR_HGSS_UNK_4146, 1
    CallIf 1, _0960
    CompareVar VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 1
    CallIf 1, _0966
    CompareVar VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 3
    CallIf 1, _097D
    GoTo _02F5
    End
_0960:
    IncrementTrainerScore TRAINER_SCORE_EVENT_BATTLE_HALL_ROUND_COMPLETED
    Return
_0966:
    Message msg_0108_D32R0401_00013
    BufferPlayerName 0
    Message msg_0108_D32R0401_00015
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 2
    Return
_097D:
    Message msg_0108_D32R0401_00013
    BufferPlayerName 0
    Message msg_0108_D32R0401_00014
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_HALL_PRINT_PROGRESS, 4
    Common_CheckAllFrontierGoldPrintsObtained
    Return
scr_seq_D32R0401_004:
    GoTo _02F5
    End
    .balign 4, 0
    WalkNormalNorth 2
    Delay8
    WalkNormalNorth
    EndMovement
    .balign 4, 0
    WalkNormalNorth 2
    Delay8
    WalkNormalNorth
    EndMovement
scr_seq_D32R0401_006:
    NPCMessage msg_0108_D32R0401_00059
    End
scr_seq_D32R0401_007:
    NPCMessage msg_0108_D32R0401_00060
    End
scr_seq_D32R0401_008:
    NPCMessage msg_0108_D32R0401_00061
    End
scr_seq_D32R0401_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    WaitSE SE_CONFIRM_sseq_3
    PlayCry SPECIES_SLOWBRO, 0
    Message msg_0108_D32R0401_00062
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0401_010:
    NPCMessage msg_0108_D32R0401_00063
    End
scr_seq_D32R0401_011:
    NPCMessage msg_0108_D32R0401_00064
    End
scr_seq_D32R0401_012:
    NPCMessage msg_0108_D32R0401_00065
    End
scr_seq_D32R0401_013:
    NPCMessage msg_0108_D32R0401_00066
    End
scr_seq_D32R0401_014:
    NPCMessage msg_0108_D32R0401_00067
    End
scr_seq_D32R0401_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_MET_HALL_STREAK_TRACKER_DUDE, _0AFF
    @ HGSS: BufferBattleHallStreak 1, 2, 3, 4, VAR_BATTLE_HALL_WIN_STREAK_LEVEL, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0AD5
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0AE0
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0AF1
    BufferPlayerName 0
    Message msg_0108_D32R0401_00069
    Message msg_0108_D32R0401_00070
    Message msg_0108_D32R0401_00072
    WaitFanfare
    GoTo _0B0E
    End
_0AD5:
    Message msg_0108_D32R0401_00068
    GoTo _0B0E
    End
_0AE0:
    BufferPlayerName 0
    Message msg_0108_D32R0401_00073
    Message msg_0108_D32R0401_00071
    GoTo _0B0E
    End
_0AF1:
    BufferPlayerName 0
    Message msg_0108_D32R0401_00074
    GoTo _0B0E
    End
_0AFF:
    SetFlag FLAG_HGSS_MET_HALL_STREAK_TRACKER_DUDE
    Message msg_0108_D32R0401_00068
    GoTo _0B0E
    End
_0B0E:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0401_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerGender VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C4A
    GoTo _0B37
    End
_0B37:
    BufferPlayerName 0
    @ HGSS: BattleHallCountUsedSpecies VAR_SPECIAL_x8005
    CompareVar VAR_0x8005, 475
    GoToIf 4, _0BBE
    CompareVar VAR_0x8005, 351
    GoToIf 4, _0BC9
    CompareVar VAR_0x8005, 251
    GoToIf 4, _0BD4
    CompareVar VAR_0x8005, 151
    GoToIf 4, _0BDF
    CompareVar VAR_0x8005, 101
    GoToIf 4, _0BEA
    CompareVar VAR_0x8005, 51
    GoToIf 4, _0BF5
    CompareVar VAR_0x8005, 31
    GoToIf 4, _0C00
    CompareVar VAR_0x8005, 11
    GoToIf 4, _0C0B
    CompareVar VAR_0x8005, 1
    GoToIf 4, _0C16
    Message msg_0108_D32R0401_00075
    GoTo _0C21
    End
_0BBE:
    Message msg_0108_D32R0401_00084
    GoTo _0C21
    End
_0BC9:
    Message msg_0108_D32R0401_00083
    GoTo _0C21
    End
_0BD4:
    Message msg_0108_D32R0401_00082
    GoTo _0C21
    End
_0BDF:
    Message msg_0108_D32R0401_00081
    GoTo _0C21
    End
_0BEA:
    Message msg_0108_D32R0401_00080
    GoTo _0C21
    End
_0BF5:
    Message msg_0108_D32R0401_00079
    GoTo _0C21
    End
_0C00:
    Message msg_0108_D32R0401_00078
    GoTo _0C21
    End
_0C0B:
    Message msg_0108_D32R0401_00077
    GoTo _0C21
    End
_0C16:
    Message msg_0108_D32R0401_00076
    GoTo _0C21
    End
_0C21:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0401_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerGender VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B37
    GoTo _0C4A
    End
_0C4A:
    BufferPlayerName 0
    @ HGSS: BattleHallCountUsedSpecies VAR_SPECIAL_x8005
    CompareVar VAR_0x8005, 475
    GoToIf 4, _0CD1
    CompareVar VAR_0x8005, 351
    GoToIf 4, _0CDC
    CompareVar VAR_0x8005, 251
    GoToIf 4, _0CE7
    CompareVar VAR_0x8005, 151
    GoToIf 4, _0CF2
    CompareVar VAR_0x8005, 101
    GoToIf 4, _0CFD
    CompareVar VAR_0x8005, 51
    GoToIf 4, _0D08
    CompareVar VAR_0x8005, 31
    GoToIf 4, _0D13
    CompareVar VAR_0x8005, 11
    GoToIf 4, _0D1E
    CompareVar VAR_0x8005, 1
    GoToIf 4, _0D29
    Message msg_0108_D32R0401_00085
    GoTo _0D34
    End
_0CD1:
    Message msg_0108_D32R0401_00094
    GoTo _0D34
    End
_0CDC:
    Message msg_0108_D32R0401_00093
    GoTo _0D34
    End
_0CE7:
    Message msg_0108_D32R0401_00092
    GoTo _0D34
    End
_0CF2:
    Message msg_0108_D32R0401_00091
    GoTo _0D34
    End
_0CFD:
    Message msg_0108_D32R0401_00090
    GoTo _0D34
    End
_0D08:
    Message msg_0108_D32R0401_00089
    GoTo _0D34
    End
_0D13:
    Message msg_0108_D32R0401_00088
    GoTo _0D34
    End
_0D1E:
    Message msg_0108_D32R0401_00087
    GoTo _0D34
    End
_0D29:
    Message msg_0108_D32R0401_00086
    GoTo _0D34
    End
_0D34:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0401_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    SetVarFromVar VAR_MAP_LOCAL_0x01, VAR_OBJ_GFX_ID_1
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _0D90
    CompareVar VAR_MAP_LOCAL_0x01, 97
    GoToIf 1, _0D9B
    CompareVar VAR_MAP_LOCAL_0x01, 365
    GoToIf 1, _0DA6
    CompareVar VAR_MAP_LOCAL_0x01, 366
    GoToIf 1, _0DB1
    CompareVar VAR_MAP_LOCAL_0x01, 354
    GoToIf 1, _0DBC
    End
_0D90:
    Message msg_0108_D32R0401_00096
    GoTo _0DC7
    End
_0D9B:
    Message msg_0108_D32R0401_00095
    GoTo _0DC7
    End
_0DA6:
    Message msg_0108_D32R0401_00097
    GoTo _0DC7
    End
_0DB1:
    Message msg_0108_D32R0401_00098
    GoTo _0DC7
    End
_0DBC:
    Message msg_0108_D32R0401_00099
    GoTo _0DC7
    End
_0DC7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
