#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0109.h"


    ScriptEntry scr_seq_D32R0501_000
    ScriptEntry scr_seq_D32R0501_001
    ScriptEntry scr_seq_D32R0501_002
    ScriptEntry scr_seq_D32R0501_003
    ScriptEntry scr_seq_D32R0501_004
    ScriptEntry scr_seq_D32R0501_005
    ScriptEntry scr_seq_D32R0501_006
    ScriptEntry scr_seq_D32R0501_007
    ScriptEntry scr_seq_D32R0501_008
    ScriptEntry scr_seq_D32R0501_009
    ScriptEntry scr_seq_D32R0501_010
    ScriptEntry scr_seq_D32R0501_011
    ScriptEntry scr_seq_D32R0501_012
    ScriptEntry scr_seq_D32R0501_013
    ScriptEntryEnd
scr_seq_D32R0501_013:
    End
scr_seq_D32R0501_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    GoTo _0074
    End
scr_seq_D32R0501_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _0074
    End
_0074:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _068C
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _0691
    GoTo _009A
    End
_009A:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _0696
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _06B5
    AddMenuEntry 41, 2
    AddMenuEntry 42, 3
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _013F
    CompareVar VAR_RESULT, 1
    GoToIf 1, _016C
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0104
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0199
    GoTo _0126
    End
_0104:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _06CC
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _06D1
    GoTo _009A
    End
_0126:
    GoTo _012E
    End
_012E:
    SetVarFromValue VAR_HGSS_UNK_4147, 0
    Message msg_0109_D32R0501_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013F:
    SetVarFromValue VAR_HGSS_UNK_4148, 0
    @ HGSS: ScrCmd_637 0, 3, VAR_SPECIAL_RESULT
    BufferNumber 0, 3
    BufferNumber 1, 3
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01C6
    GoTo _01F0
    End
_016C:
    SetVarFromValue VAR_HGSS_UNK_4148, 1
    @ HGSS: ScrCmd_637 0, 3, VAR_SPECIAL_RESULT
    BufferNumber 0, 3
    BufferNumber 1, 3
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01C6
    GoTo _01F0
    End
_0199:
    SetVarFromValue VAR_HGSS_UNK_4148, 2
    @ HGSS: ScrCmd_637 0, 2, VAR_SPECIAL_RESULT
    BufferNumber 0, 2
    BufferNumber 1, 2
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01DB
    GoTo _01F0
    End
_01C6:
    Message msg_0109_D32R0501_00008
    @ HGSS: ScrCmd_444 9, 3, 0, 0
    GoTo _0126
    End
_01DB:
    Message msg_0109_D32R0501_00008
    @ HGSS: ScrCmd_444 9, 2, 0, 0
    GoTo _0126
    End
_01F0:
    Message msg_0109_D32R0501_00007
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_637 4, VAR_UNK_4148, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_639 VAR_TEMP_x4002, VAR_TEMP_x4005, VAR_TEMP_x4006
    CompareVar VAR_MAP_LOCAL_0x02, 255
    GoToIf 5, _0222
_0222:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 255
    GoToIf 1, _0126
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4002, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _05FB
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4005, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _05FB
    CompareVar VAR_HGSS_UNK_4148, 2
    GoToIf 1, _0283
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4006, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _05FB
_0283:
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _029E
    GoTo _0126
_029E:
    GoTo _02A6
    End
_02A6:
    GoTo _02AE
    End
_02AE:
    CompareVar VAR_HGSS_UNK_4148, 0
    CallIf 1, _046A
    CompareVar VAR_HGSS_UNK_4148, 1
    CallIf 1, _046A
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    HealParty
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0126
    CompareVar VAR_HGSS_UNK_4148, 2
    GoToIf 1, _02FE
    GoTo _04CB
    End
_02FE:
    Message msg_0109_D32R0501_00043
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 5, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _034F
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03A7
    GoTo _0126
    End
_034F:
    Message msg_0109_D32R0501_00044
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02FE
    CloseMessage
    @ HGSS: ScrCmd_226 31, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0395
    CompareVar VAR_RESULT, 3
    GoToIf 1, _039D
    GoTo _03FF
    End
_0395:
    GoTo _02FE
    End
_039D:
    GoTo _02FE
    End
_03A7:
    Message msg_0109_D32R0501_00044
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02FE
    CloseMessage
    @ HGSS: ScrCmd_227 31, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03ED
    CompareVar VAR_RESULT, 3
    GoToIf 1, _03F5
    GoTo _03FF
    End
_03ED:
    GoTo _02FE
    End
_03F5:
    GoTo _02FE
    End
_03FF:
    @ HGSS: ScrCmd_257 136
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_0x8000
    GetPartyMonSpecies VAR_MAP_LOCAL_0x05, VAR_0x8001
    @ HGSS: ScrCmd_638 VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0472
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0488
    CompareVar VAR_0x8008, 3
    GoToIf 1, _049E
    @ HGSS: ScrCmd_257 138
    Message msg_0109_D32R0501_00045
    CompareVar VAR_HGSS_UNK_4148, 2
    CallIf 1, _046A
    Call _06FD
    GoTo _04CB
    End
_046A:
    SetVarFromValue VAR_HGSS_UNK_4147, 255
    Return
_0472:
    Call _04C1
    BufferPartyMonSpecies 0, VAR_MAP_LOCAL_0x02
    Message msg_0109_D32R0501_00029
    GoTo _04B9
    End
_0488:
    Call _04C1
    BufferPartyMonSpecies 0, VAR_MAP_LOCAL_0x05
    Message msg_0109_D32R0501_00029
    GoTo _04B9
    End
_049E:
    Call _04C1
    BufferPartyMonSpecies 0, VAR_MAP_LOCAL_0x02
    BufferPartyMonSpecies 1, VAR_MAP_LOCAL_0x05
    Message msg_0109_D32R0501_00030
    GoTo _04B9
    End
_04B9:
    GoTo _0126
    End
_04C1:
    @ HGSS: ScrCmd_257 139
    Return
_04CB:
    CompareVar VAR_HGSS_UNK_4148, 0
    CallIf 1, _0563
    CompareVar VAR_HGSS_UNK_4148, 1
    CallIf 1, _057E
    CompareVar VAR_HGSS_UNK_4148, 2
    CallIf 1, _0599
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    GoTo _04FE
    End
_04FE:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_HGSS_UNK_4148, 0
    CallIf 1, _05BF
    CompareVar VAR_HGSS_UNK_4148, 1
    CallIf 1, _05D3
    CompareVar VAR_HGSS_UNK_4148, 2
    CallIf 1, _05E7
    IncrementGameRecord RECORD_TIMES_STARTED_BATTLE_FRONTIER_CHALLENGE
    @ HGSS: ScrCmd_436
    @ HGSS: ScrCmd_627 11
    CompareVar VAR_HGSS_UNK_4148, 2
    CallIf 1, _055F
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    End
_055F:
    Return
_0563:
    Message msg_0109_D32R0501_00032
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _060C
    ApplyMovement VAR_LAST_TALKED, _062C
    WaitMovement
    Return
_057E:
    Message msg_0109_D32R0501_00032
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _060C
    ApplyMovement VAR_LAST_TALKED, _062C
    WaitMovement
    Return
_0599:
    @ HGSS: NPCMsgVar msg_0109_D32R0501_00032
    WaitTime 10, VAR_RESULT
    @ HGSS: ScrCmd_257 137
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0618
    ApplyMovement VAR_LAST_TALKED, _0638
    WaitMovement
    Return
_05BF:
    ApplyMovement LOCALID_PLAYER, _064C
    ApplyMovement VAR_LAST_TALKED, _0670
    WaitMovement
    Return
_05D3:
    ApplyMovement LOCALID_PLAYER, _064C
    ApplyMovement VAR_LAST_TALKED, _0670
    WaitMovement
    Return
_05E7:
    ApplyMovement LOCALID_PLAYER, _065C
    ApplyMovement VAR_LAST_TALKED, _067C
    WaitMovement
    Return
_05FB:
    SetVarFromValue VAR_HGSS_UNK_4147, 0
    Common_GriseousOrbCouldNotBeRemoved
    End
    .balign 4, 0
_060C:
    WalkNormalWest 6
    SetInvisible
    EndMovement
    .balign 4, 0
_0618:
    WalkNormalWest 3
    WalkNormalNorth
    WalkNormalWest 3
    SetInvisible
    EndMovement
    .balign 4, 0
_062C:
    WalkNormalWest 5
    SetInvisible
    EndMovement
    .balign 4, 0
_0638:
    WalkNormalWest 2
    WalkNormalNorth
    WalkNormalWest 3
    SetInvisible
    EndMovement
    .balign 4, 0
_064C:
    WalkFasterEast 6
    SetVisible
    FaceWest
    EndMovement
    .balign 4, 0
_065C:
    WalkFasterEast 6
    WalkFasterSouth
    SetVisible
    FaceWest
    EndMovement
    .balign 4, 0
_0670:
    WalkFasterEast 5
    SetVisible
    EndMovement
    .balign 4, 0
_067C:
    WalkFasterSouth
    WalkFasterEast 5
    SetVisible
    EndMovement
_068C:
    Message msg_0109_D32R0501_00000
    Return
_0691:
    Message msg_0109_D32R0501_00003
    Return
_0696:
    Message msg_0109_D32R0501_00001
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 38, 0
    AddMenuEntry 39, 1
    Return
_06B5:
    Message msg_0109_D32R0501_00004
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 40, 4
    Return
_06CC:
    Message msg_0109_D32R0501_00002
    Return
_06D1:
    Message msg_0109_D32R0501_00005
    Return
scr_seq_D32R0501_001:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    SetVarFromValue VAR_HGSS_UNK_4147, 0
    Message msg_0109_D32R0501_00033
    Call _046A
    Call _06FD
    GoTo _04CB
    End
_06FD:
    ShowSavingIcon
    TrySaveGame VAR_RESULT
    HideSavingIcon
    PlaySE SEQ_SE_DP_SAVE_sseq
    WaitSE SEQ_SE_DP_SAVE_sseq
    Return
scr_seq_D32R0501_002:
    LockAll
    FacePlayer
    Message msg_0109_D32R0501_00034
    @ HGSS: ScrCmd_640 VAR_UNK_4148
    CompareVar VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 1
    CallIf 1, _073C
    CompareVar VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 3
    CallIf 1, _0744
    GoTo _0126
    End
_073C:
    SetVarFromValue VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 0
    Return
_0744:
    SetVarFromValue VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 2
    Return
scr_seq_D32R0501_003:
    CompareVar VAR_HGSS_UNK_4148, 0
    CallIf 1, _0788
    CompareVar VAR_HGSS_UNK_4148, 1
    CallIf 1, _0788
    CompareVar VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 1
    CallIf 1, _078E
    CompareVar VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 3
    CallIf 1, _07A5
    GoTo _0126
    End
_0788:
    IncrementTrainerScore TRAINER_SCORE_EVENT_BATTLE_CASTLE_ROUND_COMPLETED
    Return
_078E:
    Message msg_0109_D32R0501_00035
    BufferPlayerName 0
    Message msg_0109_D32R0501_00037
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 2
    Return
_07A5:
    Message msg_0109_D32R0501_00035
    BufferPlayerName 0
    Message msg_0109_D32R0501_00036
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_CASTLE_PRINT_PROGRESS, 4
    Common_CheckAllFrontierGoldPrintsObtained
    Return
scr_seq_D32R0501_004:
    GoTo _0126
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
scr_seq_D32R0501_006:
    NPCMessage msg_0109_D32R0501_00046
    End
scr_seq_D32R0501_007:
    NPCMessage msg_0109_D32R0501_00047
    End
scr_seq_D32R0501_008:
    NPCMessage msg_0109_D32R0501_00048
    End
scr_seq_D32R0501_009:
    NPCMessage msg_0109_D32R0501_00049
    End
scr_seq_D32R0501_010:
    NPCMessage msg_0109_D32R0501_00050
    End
scr_seq_D32R0501_011:
    NPCMessage msg_0109_D32R0501_00051
    End
scr_seq_D32R0501_012:
    NPCMessage msg_0109_D32R0501_00052
    End
    .balign 4, 0
