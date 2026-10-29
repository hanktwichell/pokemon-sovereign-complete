#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0110.h"


    ScriptEntry scr_seq_D32R0601_000
    ScriptEntry scr_seq_D32R0601_001
    ScriptEntry scr_seq_D32R0601_002
    ScriptEntry scr_seq_D32R0601_003
    ScriptEntry scr_seq_D32R0601_004
    ScriptEntry scr_seq_D32R0601_005
    ScriptEntry scr_seq_D32R0601_006
    ScriptEntry scr_seq_D32R0601_007
    ScriptEntry scr_seq_D32R0601_008
    ScriptEntry scr_seq_D32R0601_009
    ScriptEntry scr_seq_D32R0601_010
    ScriptEntry scr_seq_D32R0601_011
    ScriptEntry scr_seq_D32R0601_012
    ScriptEntry scr_seq_D32R0601_013
    ScriptEntry scr_seq_D32R0601_014
    ScriptEntry scr_seq_D32R0601_015
    ScriptEntry scr_seq_D32R0601_016
    ScriptEntryEnd
scr_seq_D32R0601_014:
    End
scr_seq_D32R0601_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    GoTo _0080
    End
scr_seq_D32R0601_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _0080
    End
_0080:
    @ HGSS: ScrCmd_682 0
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _06A0
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _06A5
    GoTo _00A6
    End
_00A6:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _06AA
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _06C9
    AddMenuEntry 41, 2
    AddMenuEntry 42, 3
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _014B
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0178
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0110
    CompareVar VAR_RESULT, 4
    GoToIf 1, _01A5
    GoTo _0132
    End
_0110:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _06E0
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _06E5
    GoTo _00A6
    End
_0132:
    GoTo _013A
    End
_013A:
    SetVarFromValue VAR_HGSS_UNK_414A, 0
    Message msg_0110_D32R0601_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_014B:
    SetVarFromValue VAR_HGSS_UNK_4149, 0
    @ HGSS: ScrCmd_643 0, 3, VAR_SPECIAL_RESULT
    BufferNumber 0, 3
    BufferNumber 1, 3
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01D2
    GoTo _01FC
    End
_0178:
    SetVarFromValue VAR_HGSS_UNK_4149, 1
    @ HGSS: ScrCmd_643 0, 3, VAR_SPECIAL_RESULT
    BufferNumber 0, 3
    BufferNumber 1, 3
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01D2
    GoTo _01FC
    End
_01A5:
    SetVarFromValue VAR_HGSS_UNK_4149, 2
    @ HGSS: ScrCmd_643 0, 2, VAR_SPECIAL_RESULT
    BufferNumber 0, 2
    BufferNumber 1, 2
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01E7
    GoTo _01FC
    End
_01D2:
    Message msg_0110_D32R0601_00008
    @ HGSS: ScrCmd_444 9, 3, 0, 0
    GoTo _0132
    End
_01E7:
    Message msg_0110_D32R0601_00008
    @ HGSS: ScrCmd_444 9, 2, 0, 0
    GoTo _0132
    End
_01FC:
    Message msg_0110_D32R0601_00007
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_643 4, VAR_UNK_4149, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_645 VAR_TEMP_x4002, VAR_TEMP_x4005, VAR_TEMP_x4006
    CompareVar VAR_MAP_LOCAL_0x02, 255
    GoToIf 5, _022E
    @ HGSS: ScrCmd_815 0
_022E:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 255
    GoToIf 1, _0132
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4002, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0607
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4005, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0607
    CompareVar VAR_HGSS_UNK_4149, 2
    GoToIf 1, _028F
    @ HGSS: DaycareSanitizeMon VAR_TEMP_x4006, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0607
_028F:
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _02AA
    GoTo _0132
_02AA:
    GoTo _02B2
    End
_02B2:
    GoTo _02BA
    End
_02BA:
    CompareVar VAR_HGSS_UNK_4149, 0
    CallIf 1, _0476
    CompareVar VAR_HGSS_UNK_4149, 1
    CallIf 1, _0476
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    HealParty
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0132
    CompareVar VAR_HGSS_UNK_4149, 2
    GoToIf 1, _030A
    GoTo _04D7
    End
_030A:
    Message msg_0110_D32R0601_00043
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 5, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _035B
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03B3
    GoTo _0132
    End
_035B:
    Message msg_0110_D32R0601_00044
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _030A
    CloseMessage
    @ HGSS: ScrCmd_226 32, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A1
    CompareVar VAR_RESULT, 3
    GoToIf 1, _03A9
    GoTo _040B
    End
_03A1:
    GoTo _030A
    End
_03A9:
    @ HGSS: ScrCmd_283
    GoTo _030A
    End
_03B3:
    Message msg_0110_D32R0601_00044
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _030A
    CloseMessage
    @ HGSS: ScrCmd_227 32, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03F9
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0401
    GoTo _040B
    End
_03F9:
    GoTo _030A
    End
_0401:
    @ HGSS: ScrCmd_283
    GoTo _030A
    End
_040B:
    ScrCmd_258
    @ HGSS: ScrCmd_257 154
    GetPartyMonSpecies VAR_MAP_LOCAL_0x02, VAR_0x8000
    GetPartyMonSpecies VAR_MAP_LOCAL_0x05, VAR_0x8001
    @ HGSS: ScrCmd_644 VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 1
    GoToIf 1, _047E
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0494
    CompareVar VAR_0x8008, 3
    GoToIf 1, _04AA
    ScrCmd_258
    @ HGSS: ScrCmd_257 156
    Message msg_0110_D32R0601_00045
    CompareVar VAR_HGSS_UNK_4149, 2
    CallIf 1, _0476
    Call _0711
    GoTo _04D7
    End
_0476:
    SetVarFromValue VAR_HGSS_UNK_414A, 255
    Return
_047E:
    Call _04CD
    BufferPartyMonSpecies 0, VAR_MAP_LOCAL_0x02
    Message msg_0110_D32R0601_00029
    GoTo _04C5
    End
_0494:
    Call _04CD
    BufferPartyMonSpecies 0, VAR_MAP_LOCAL_0x05
    Message msg_0110_D32R0601_00029
    GoTo _04C5
    End
_04AA:
    Call _04CD
    BufferPartyMonSpecies 0, VAR_MAP_LOCAL_0x02
    BufferPartyMonSpecies 1, VAR_MAP_LOCAL_0x05
    Message msg_0110_D32R0601_00030
    GoTo _04C5
    End
_04C5:
    GoTo _0132
    End
_04CD:
    ScrCmd_258
    @ HGSS: ScrCmd_257 157
    @ HGSS: ScrCmd_283
    Return
_04D7:
    CompareVar VAR_HGSS_UNK_4149, 0
    CallIf 1, _056F
    CompareVar VAR_HGSS_UNK_4149, 1
    CallIf 1, _058A
    CompareVar VAR_HGSS_UNK_4149, 2
    CallIf 1, _05A5
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    GoTo _050A
    End
_050A:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_815 0
    CompareVar VAR_HGSS_UNK_4149, 0
    CallIf 1, _05CB
    CompareVar VAR_HGSS_UNK_4149, 1
    CallIf 1, _05DF
    CompareVar VAR_HGSS_UNK_4149, 2
    CallIf 1, _05F3
    @ HGSS: ScrCmd_420 59
    @ HGSS: ScrCmd_436
    @ HGSS: ScrCmd_627 15
    CompareVar VAR_HGSS_UNK_4149, 2
    CallIf 1, _056B
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_682 1
    End
_056B:
    @ HGSS: ScrCmd_283
    Return
_056F:
    Message msg_0110_D32R0601_00032
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0618
    ApplyMovement VAR_LAST_TALKED, _0638
    WaitMovement
    Return
_058A:
    Message msg_0110_D32R0601_00032
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0618
    ApplyMovement VAR_LAST_TALKED, _0638
    WaitMovement
    Return
_05A5:
    @ HGSS: NPCMsgVar msg_0110_D32R0601_00032
    WaitTime 10, VAR_RESULT
    ScrCmd_258
    @ HGSS: ScrCmd_257 155
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _062C
    ApplyMovement VAR_LAST_TALKED, _064C
    WaitMovement
    Return
_05CB:
    ApplyMovement LOCALID_PLAYER, _0658
    ApplyMovement VAR_LAST_TALKED, _0680
    WaitMovement
    Return
_05DF:
    ApplyMovement LOCALID_PLAYER, _0658
    ApplyMovement VAR_LAST_TALKED, _0680
    WaitMovement
    Return
_05F3:
    ApplyMovement LOCALID_PLAYER, _0670
    ApplyMovement VAR_LAST_TALKED, _0694
    WaitMovement
    Return
_0607:
    SetVarFromValue VAR_HGSS_UNK_414A, 0
    Common_GriseousOrbCouldNotBeRemoved
    End
    .balign 4, 0
_0618:
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_062C:
    WalkNormalNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0638:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_064C:
    WalkNormalNorth 3
    SetInvisible
    EndMovement
    .balign 4, 0
_0658:
    WalkFasterSouth 2
    WalkFasterWest
    WalkFasterSouth 2
    FaceNorth
    SetVisible
    EndMovement
    .balign 4, 0
_0670:
    WalkFasterSouth 4
    FaceNorth
    SetVisible
    EndMovement
    .balign 4, 0
_0680:
    WalkFasterSouth
    WalkFasterWest
    WalkFasterSouth 2
    SetVisible
    EndMovement
    .balign 4, 0
_0694:
    WalkFasterSouth 3
    SetVisible
    EndMovement
_06A0:
    Message msg_0110_D32R0601_00000
    Return
_06A5:
    Message msg_0110_D32R0601_00003
    Return
_06AA:
    Message msg_0110_D32R0601_00001
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 38, 0
    AddMenuEntry 39, 1
    Return
_06C9:
    Message msg_0110_D32R0601_00004
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 40, 4
    Return
_06E0:
    Message msg_0110_D32R0601_00002
    Return
_06E5:
    Message msg_0110_D32R0601_00005
    Return
scr_seq_D32R0601_001:
    @ HGSS: ScrCmd_682 0
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    SetVarFromValue VAR_HGSS_UNK_414A, 0
    Message msg_0110_D32R0601_00033
    Call _0476
    Call _0711
    GoTo _04D7
    End
_0711:
    ShowSavingIcon
    TrySaveGame VAR_RESULT
    HideSavingIcon
    PlaySE SEQ_SE_DP_SAVE_sseq
    WaitSE SEQ_SE_DP_SAVE_sseq
    Return
scr_seq_D32R0601_002:
    Message msg_0110_D32R0601_00034
    @ HGSS: ScrCmd_646 VAR_UNK_4149
    CompareVar VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 1
    CallIf 1, _074C
    CompareVar VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 3
    CallIf 1, _0754
    GoTo _0132
    End
_074C:
    SetVarFromValue VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 0
    Return
_0754:
    SetVarFromValue VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 2
    Return
scr_seq_D32R0601_003:
    CompareVar VAR_HGSS_UNK_4149, 0
    CallIf 1, _0798
    CompareVar VAR_HGSS_UNK_4149, 1
    CallIf 1, _0798
    CompareVar VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 1
    CallIf 1, _079E
    CompareVar VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 3
    CallIf 1, _07B5
    GoTo _0132
    End
_0798:
    IncrementTrainerScore TRAINER_SCORE_EVENT_BATTLE_ARCADE_ROUND_COMPLETED
    Return
_079E:
    Message msg_0110_D32R0601_00035
    BufferPlayerName 0
    Message msg_0110_D32R0601_00037
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 2
    Return
_07B5:
    Message msg_0110_D32R0601_00035
    BufferPlayerName 0
    Message msg_0110_D32R0601_00036
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_ARCADE_PRINT_PROGRESS, 4
    Common_CheckAllFrontierGoldPrintsObtained
    Return
scr_seq_D32R0601_004:
    GoTo _0132
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
scr_seq_D32R0601_006:
    NPCMessage msg_0110_D32R0601_00046
    End
scr_seq_D32R0601_007:
    NPCMessage msg_0110_D32R0601_00047
    End
scr_seq_D32R0601_008:
    NPCMessage msg_0110_D32R0601_00048
    End
scr_seq_D32R0601_009:
    NPCMessage msg_0110_D32R0601_00049
    End
scr_seq_D32R0601_010:
    NPCMessage msg_0110_D32R0601_00050
    End
scr_seq_D32R0601_011:
    NPCMessage msg_0110_D32R0601_00051
    End
scr_seq_D32R0601_012:
    NPCMessage msg_0110_D32R0601_00052
    End
scr_seq_D32R0601_013:
    NPCMessage msg_0110_D32R0601_00053
    End
scr_seq_D32R0601_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0110_D32R0601_00054
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32R0601_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0110_D32R0601_00055
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
