#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0096.h"


    ScriptEntry scr_seq_D31R0201_000
    ScriptEntry scr_seq_D31R0201_001
    ScriptEntry scr_seq_D31R0201_002
    ScriptEntry scr_seq_D31R0201_003
    ScriptEntry scr_seq_D31R0201_004
    ScriptEntry scr_seq_D31R0201_005
    ScriptEntry scr_seq_D31R0201_006
    ScriptEntry scr_seq_D31R0201_007
    ScriptEntry scr_seq_D31R0201_008
    ScriptEntry scr_seq_D31R0201_009
    ScriptEntry scr_seq_D31R0201_010
    ScriptEntry scr_seq_D31R0201_011
    ScriptEntry scr_seq_D31R0201_012
    ScriptEntry scr_seq_D31R0201_013
    ScriptEntry scr_seq_D31R0201_014
    ScriptEntry scr_seq_D31R0201_015
    ScriptEntry scr_seq_D31R0201_016
    ScriptEntry scr_seq_D31R0201_017
    ScriptEntry scr_seq_D31R0201_018
    ScriptEntry scr_seq_D31R0201_019
    ScriptEntry scr_seq_D31R0201_020
    ScriptEntry scr_seq_D31R0201_021
    ScriptEntry scr_seq_D31R0201_022
    ScriptEntry scr_seq_D31R0201_023
    ScriptEntryEnd
scr_seq_D31R0201_021:
    CompareVar VAR_HGSS_UNK_414B, 1
    CallIf 1, _00A6
    CompareVar VAR_HGSS_UNK_414B, 3
    CallIf 1, _00A6
    CompareVar VAR_HGSS_UNK_414B, 255
    CallIf 1, _00A6
    @ HGSS: ScrCmd_415 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00A0
    SetFlag FLAG_HGSS_HIDE_BATTLE_TOWER_RECEPTIONIST
    End
_00A0:
    ClearFlag FLAG_HGSS_HIDE_BATTLE_TOWER_RECEPTIONIST
    End
_00A6:
    @ HGSS: ScrCmd_521
    Return
scr_seq_D31R0201_022:
    CompareVar VAR_HGSS_UNK_414B, 1
    GoToIf 5, _00EF
    @ HGSS: ScrCmd_415 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00F1
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _00F1
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _00F1
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00F1
_00EF:
    End
_00F1:
    @ HGSS: ScrCmd_344 3, 2
    End
_00F9:
    SetVarFromValue VAR_HGSS_UNK_414B, 255
    SetVarFromValue VAR_HGSS_UNK_414D, 1
    SetVarFromValue VAR_HGSS_UNK_414E, 1
    SetVarFromValue VAR_HGSS_UNK_414C, 1
    Return
_0113:
    SetVarFromValue VAR_HGSS_UNK_414B, 255
    SetVarFromValue VAR_HGSS_UNK_414D, 3
    SetVarFromValue VAR_HGSS_UNK_414F, 1
    SetVarFromValue VAR_HGSS_UNK_4150, 1
    SetVarFromValue VAR_HGSS_UNK_4151, 1
    Return
_0133:
    SetVarFromValue VAR_HGSS_UNK_414B, 255
    SetVarFromValue VAR_HGSS_UNK_414D, 1
    SetVarFromValue VAR_HGSS_UNK_414E, 1
    SetVarFromValue VAR_HGSS_UNK_414C, 2
    Return
scr_seq_D31R0201_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    @ HGSS: ScrCmd_414 VAR_TEMP_x4002
    GoTo _0167
    End
_0167:
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x02
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01DA
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01ED
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0200
    CompareVar VAR_0x8008, 4
    GoToIf 1, _01CF
    Message msg_0096_D31R0201_00015
    GoTo _01AC
    End
_01AC:
    WaitButton
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01C1
    CloseMessage
    ReleaseAll
    End
_01C1:
    Call _0872
    GoTo _0860
    End
_01CF:
    Message msg_0096_D31R0201_00089
    GoTo _01AC
    End
_01DA:
    BufferNumber 0, 20
    SetVarFromValue VAR_0x8004, 85
    GoTo _0213
    End
_01ED:
    BufferNumber 0, 50
    SetVarFromValue VAR_0x8004, 86
    GoTo _0213
    End
_0200:
    BufferNumber 0, 100
    SetVarFromValue VAR_0x8004, 87
    GoTo _0213
    End
_0213:
    Message msg_0096_D31R0201_00088
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    CompareVar VAR_0x8004, 85
    GoToIf 5, _0233
    ClearFlag FLAG_HGSS_HIDE_PLAYERS_ROOM_BRONZE_TROPHY
    GoTo _024E
_0233:
    CompareVar VAR_0x8004, 86
    GoToIf 5, _024A
    ClearFlag FLAG_HGSS_HIDE_PLAYERS_ROOM_SILVER_TROPHY
    GoTo _024E
_024A:
    ClearFlag FLAG_HGSS_HIDE_PLAYERS_ROOM_GOLD_TROPHY
_024E:
    Message msg_0096_D31R0201_00015
    GoTo _01AC
    End
scr_seq_D31R0201_000:
    LockAll
    PlaySE SE_CONFIRM_sseq_3
    @ HGSS: ScrCmd_409
    Message msg_0096_D31R0201_00000
    GoTo _026E
    End
_026E:
    Message msg_0096_D31R0201_00001
    Call _02AC
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02D2
    CompareVar VAR_0x8008, 1
    GoToIf 1, _02A1
    GoTo _085B
    End
_02A1:
    Message msg_0096_D31R0201_00003
    GoTo _026E
    End
_02AC:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 143, 0
    AddMenuEntry 144, 1
    AddMenuEntry 145, 2
    ShowMenu
    Return
_02D2:
    Message msg_0096_D31R0201_00004
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 475, 0
    AddMenuEntry 476, 1
    AddMenuEntry 94, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0321
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0356
    GoTo _085B
    End
_0321:
    @ HGSS: ScrCmd_410 0, 0
    GoTo _032F
    End
_032F:
    @ HGSS: ScrCmd_412 1, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0383
    @ HGSS: ScrCmd_444 91, 3, 0, 0
    GoTo _085E
    End
_0356:
    @ HGSS: ScrCmd_410 0, 1
    @ HGSS: ScrCmd_412 1, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _042F
    @ HGSS: ScrCmd_444 91, 4, 0, 0
    GoTo _085E
    End
_0383:
    Message msg_0096_D31R0201_00008
    Call _0560
    CompareVar VAR_RESULT, 0
    GoToIf 1, _085B
    @ HGSS: ScrCmd_412 32, 0, VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0546
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0553
    @ HGSS: ScrCmd_412 53, 0, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 53, 1, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 53, 2, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 43, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0A97
    GoTo _04F6
    End
_042F:
    Message msg_0096_D31R0201_00008
    Call _0560
    CompareVar VAR_RESULT, 0
    GoToIf 1, _085B
    @ HGSS: ScrCmd_412 32, 0, VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0546
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0553
    @ HGSS: ScrCmd_412 53, 0, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 53, 1, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 53, 2, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 53, 3, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 43, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0A97
    GoTo _04F6
    End
_04F6:
    Call _00F9
    @ HGSS: ScrCmd_412 5, 0, 0
    HealParty
    Call _053A
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0855
    @ HGSS: ScrCmd_412 57, 0, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_412 52, 0, 0
    Message msg_0096_D31R0201_00011
    WaitABPress
    GoTo _06CD
    End
_053A:
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    Return
_0546:
    Message msg_0096_D31R0201_00009
    GoTo _085B
    End
_0553:
    Message msg_0096_D31R0201_00010
    GoTo _085B
    End
_0560:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: ScrCmd_412 30, 0, 0
    @ HGSS: ScrCmd_412 31, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _058F
_058F:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
scr_seq_D31R0201_004:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_414B, 0
    @ HGSS: ScrCmd_412 4, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, scr_seq_D31R0201_005
    Message msg_0096_D31R0201_00016
    @ HGSS: ScrCmd_410 1, 65535
    @ HGSS: ScrCmd_412 43, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _05FD
    Call _0133
    @ HGSS: ScrCmd_412 5, 0, 0
    Call _0817
    Message msg_0096_D31R0201_00011
    WaitABPress
    GoTo _06CD
    End
_05FD:
    Call _062C
    @ HGSS: ScrCmd_412 5, 0, 0
    Call _0817
    @ HGSS: ScrCmd_412 51, 0, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_MAP_LOCAL_0x09, VAR_RESULT
    Message msg_0096_D31R0201_00032
    WaitABPress
    GoTo _06CD
    End
_062C:
    SetVarFromValue VAR_HGSS_UNK_414B, 255
    SetVarFromValue VAR_HGSS_UNK_414D, 2
    SetVarFromValue VAR_HGSS_UNK_414F, 1
    SetVarFromValue VAR_HGSS_UNK_4150, 2
    SetVarFromValue VAR_HGSS_UNK_4151, 0
    Return
scr_seq_D31R0201_005:
    LockAll
    Message msg_0096_D31R0201_00019
    @ HGSS: ScrCmd_412 14, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 1
    CallIf 1, _068A
    CompareVar VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 3
    CallIf 1, _0692
    CompareVar VAR_RESULT, 4
    GoToIf 1, _069A
    GoTo _0855
    End
_068A:
    SetVarFromValue VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 0
    Return
_0692:
    SetVarFromValue VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 2
    Return
_069A:
    @ HGSS: ScrCmd_412 9, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0855
    @ HGSS: ScrCmd_412 10, 0, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_0x8000, VAR_RESULT
    BufferNumber 0, VAR_0x8000
    Message msg_0096_D31R0201_00065
    GoTo _0855
    End
_06CD:
    CloseMessage
    @ HGSS: ScrCmd_412 43, 0, VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0733
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0733
    CompareVar VAR_0x8008, 2
    GoToIf 1, _074D
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0767
    GoTo _0719
    End
_0719:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    SetVarFromValue VAR_MAP_LOCAL_0x03, 15
    Call _078F
    GoTo _0829
    End
_0733:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 2
    SetVarFromValue VAR_MAP_LOCAL_0x03, 19
    Call _078F
    GoTo _0829
    End
_074D:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    SetVarFromValue VAR_MAP_LOCAL_0x03, 11
    Call _078F
    GoTo _07CF
    End
_0767:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    SetVarFromValue VAR_MAP_LOCAL_0x03, 11
    Call _078F
    GoTo _0781
    End
_0781:
    SetVarFromValue VAR_HGSS_UNK_414D, 2
    GoTo _0829
    End
_078F:
    ApplyMovement VAR_MAP_LOCAL_0x02, _1348
    ApplyMovement LOCALID_PLAYER, _1360
    WaitMovement
    LoadDoorAnimation 0, 0, VAR_MAP_LOCAL_0x03, 2, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement VAR_MAP_LOCAL_0x02, _1354
    ApplyMovement LOCALID_PLAYER, _136C
    WaitMovement
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    Return
_07CF:
    GoTo _0829
    End
scr_seq_D31R0201_007:
    LockAll
    Call _0807
    @ HGSS: ScrCmd_412 100, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _085B
    Message msg_0096_D31R0201_00056
    Call _0817
    GoTo _0855
    End
_0807:
    Call _0890
    @ HGSS: ScrCmd_412 6, 0, 0
    Return
_0817:
    ShowSavingIcon
    TrySaveGame VAR_RESULT
    HideSavingIcon
    PlaySE SEQ_SE_DP_SAVE_sseq
    WaitSE SEQ_SE_DP_SAVE_sseq
    Return
_0829:
    IncrementGameRecord RECORD_TIMES_STARTED_BATTLE_FRONTIER_CHALLENGE
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_TOWER_ELEVATOR, 3, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0855:
    Call _0872
_085B:
    Message msg_0096_D31R0201_00002
_085E:
    WaitButton
_0860:
    CloseMessage
    Call _088C
    Call _0890
    ReleaseAll
    End
_0872:
    @ HGSS: ScrCmd_412 6, 0, 0
    Call _0882
    Return
_0882:
    @ HGSS: ScrCmd_412 3, 0, 0
    Return
_088C:
    @ HGSS: ScrCmd_411
    Return
_0890:
    SetVarFromValue VAR_HGSS_UNK_414B, 0
    SetVarFromValue VAR_HGSS_UNK_414D, 0
    SetVarFromValue VAR_HGSS_UNK_414E, 0
    SetVarFromValue VAR_HGSS_UNK_414F, 0
    SetVarFromValue VAR_HGSS_UNK_414C, 0
    SetVarFromValue VAR_HGSS_UNK_4150, 0
    SetVarFromValue VAR_HGSS_UNK_4151, 0
    Return
scr_seq_D31R0201_002:
    LockAll
    PlaySE SE_CONFIRM_sseq_3
    @ HGSS: ScrCmd_409
    @ HGSS: ScrCmd_412 12, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _09F7
    Message msg_0096_D31R0201_00036
    GoTo _08E6
    End
_08E6:
    @ HGSS: ScrCmd_412 15, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0974
    GoTo _0903
    End
_0903:
    Message msg_0096_D31R0201_00037
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 143, 0
    AddMenuEntry 155, 1
    AddMenuEntry 144, 2
    AddMenuEntry 145, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B97
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0B46
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0969
    GoTo _085B
    End
_0969:
    Message msg_0096_D31R0201_00038
    GoTo _08E6
    End
_0974:
    Message msg_0096_D31R0201_00037
    Call _09C1
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B97
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0B46
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0BA5
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0969
    GoTo _085B
    End
_09C1:
    CompleteInitHGSSMenu 12, 7, 0, VAR_RESULT, 1
    AddMenuEntry 143, 0
    AddMenuEntry 153, 1
    AddMenuEntry 154, 2
    AddMenuEntry 144, 3
    AddMenuEntry 145, 4
    ShowMenu
    Return
_09F7:
    Message msg_0096_D31R0201_00061
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08E6
    Call _053A
    CompareVar VAR_RESULT, 0
    GoToIf 1, _085B
    Call _0A42
    CompareVar VAR_RESULT, 0
    GoToIf 5, _085B
    Message msg_0096_D31R0201_00060
    GoTo _085B
    End
_0A42:
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Call _0A52
    Return
_0A52:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_166 VAR_TEMP_x4000
    @ HGSS: ScrCmd_412 16, VAR_TEMP_x4001, VAR_TEMP_x4000
    SetVarFromVar VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _0A81
_0A81:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x01
    Return
_0A97:
    HealParty
    Call _053A
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0855
    Call _00F9
    @ HGSS: ScrCmd_412 5, 0, 0
    HealParty
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    Call _0A52
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0855
    GoTo _0ADF
    End
_0ADF:
    Message msg_0096_D31R0201_00047
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06CD
    Message msg_0096_D31R0201_00048
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0ADF
    SetVarFromValue VAR_HGSS_UNK_414B, 2
    @ HGSS: ScrCmd_412 39, 0, 0
    @ HGSS: ScrCmd_411
    Message msg_0096_D31R0201_00056
    Call _0817
    WaitABPressTime 30
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: ScrCmd_412 2, 0, 0
    ReleaseAll
    End
_0B46:
    Call _053A
    CompareVar VAR_RESULT, 0
    GoToIf 1, _085B
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 2
    Call _0A52
    CompareVar VAR_RESULT, 0
    GoToIf 5, _085B
    @ HGSS: ScrCmd_418 VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    BufferNumber 0, VAR_0x8004
    @ HGSS: BufferIntEx 1, VAR_SPECIAL_x8005, 2, 3
    Message msg_0096_D31R0201_00052
    WaitABPress
    GoTo _0860
    End
_0B97:
    @ HGSS: ScrCmd_410 0, 4
    GoTo _032F
    End
_0BA5:
    @ HGSS: ScrCmd_410 0, 5
    GoTo _032F
    End
_0BB3:
    ApplyMovement LOCALID_PLAYER, _1378
    WaitMovement
    Return
scr_seq_D31R0201_001:
    LockAll
    PlaySE SE_CONFIRM_sseq_3
    @ HGSS: ScrCmd_409
    Message msg_0096_D31R0201_00020
    GoTo _0BD4
    End
_0BD4:
    Message msg_0096_D31R0201_00021
    Call _02AC
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0C12
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0C07
    GoTo _085B
    End
_0C07:
    Message msg_0096_D31R0201_00023
    GoTo _0BD4
    End
_0C12:
    @ HGSS: ScrCmd_412 1, 2, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C39
    @ HGSS: ScrCmd_444 91, 2, 0, 0
    GoTo _085E
    End
_0C39:
    Message msg_0096_D31R0201_00026
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C69
    GoTo _0C55
    End
_0C55:
    @ HGSS: ScrCmd_410 0, 2
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    GoTo _0C7D
    End
_0C69:
    @ HGSS: ScrCmd_410 0, 3
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    GoTo _0C7D
    End
_0C7D:
    Message msg_0096_D31R0201_00008
    Call _0560
    CompareVar VAR_RESULT, 0
    GoToIf 1, _085B
    @ HGSS: ScrCmd_412 32, 0, VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0546
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0553
    @ HGSS: ScrCmd_412 53, 0, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    @ HGSS: ScrCmd_412 53, 1, VAR_SPECIAL_RESULT
    @ HGSS: DaycareSanitizeMon VAR_SPECIAL_RESULT, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 255
    GoToIf 1, _14C8
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0D40
    Call _0113
    @ HGSS: ScrCmd_412 5, 0, 0
    HealParty
    Call _053A
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0855
    @ HGSS: ScrCmd_412 57, 0, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_412 52, 0, 0
    Message msg_0096_D31R0201_00035
    GoTo _06CD
    End
_0D40:
    HealParty
    Call _053A
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0855
_0D55:
    Message msg_0096_D31R0201_00027
    CompleteInitHGSSMenu 18, 1, 0, VAR_RESULT, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 5, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0DA6
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0DFE
    GoTo _0855
    End
_0DA6:
    Message msg_0096_D31R0201_00112
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0D55
    CloseMessage
    @ HGSS: ScrCmd_226 16, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0DEC
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0DF4
    GoTo _0E56
    End
_0DEC:
    GoTo _0D55
    End
_0DF4:
    GoTo _0D55
    End
_0DFE:
    Message msg_0096_D31R0201_00112
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0D55
    CloseMessage
    @ HGSS: ScrCmd_227 16, 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0E44
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0E4C
    GoTo _0E56
    End
_0E44:
    GoTo _0D55
    End
_0E4C:
    GoTo _0D55
    End
_0E56:
    @ HGSS: ScrCmd_257 1
    @ HGSS: ScrCmd_412 58, 0, 0
    GoTo _0E6C
    End
_0E6C:
    @ HGSS: ScrCmd_416 0, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0E6C
    @ HGSS: ScrCmd_417 0, VAR_TEMP_x4000
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0EE1
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0EFF
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0F1D
    @ HGSS: ScrCmd_257 2
    @ HGSS: ScrCmd_412 57, 0, VAR_SPECIAL_x8004
    @ HGSS: ScrCmd_451 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0F84
    @ HGSS: ScrCmd_417 1, VAR_TEMP_x4000
    GoTo _0F52
    End
_0EE1:
    Call _0F48
    @ HGSS: ScrCmd_412 53, 0, VAR_SPECIAL_RESULT
    BufferPartyMonSpecies 0, VAR_RESULT
    Message msg_0096_D31R0201_00033
    GoTo _0855
    End
_0EFF:
    Call _0F48
    @ HGSS: ScrCmd_412 53, 1, VAR_SPECIAL_RESULT
    BufferPartyMonSpecies 0, VAR_RESULT
    Message msg_0096_D31R0201_00033
    GoTo _0855
    End
_0F1D:
    Call _0F48
    @ HGSS: ScrCmd_412 53, 0, VAR_SPECIAL_RESULT
    BufferPartyMonSpecies 0, VAR_RESULT
    @ HGSS: ScrCmd_412 53, 1, VAR_SPECIAL_RESULT
    BufferPartyMonSpecies 1, VAR_RESULT
    Message msg_0096_D31R0201_00034
    GoTo _0855
    End
_0F48:
    @ HGSS: ScrCmd_257 8
    Return
_0F52:
    Call _0113
    @ HGSS: ScrCmd_412 5, 0, 0
    HealParty
    Message msg_0096_D31R0201_00069
    Call _0817
    @ HGSS: BattleTowerSetUpMultiBattle
    Message msg_0096_D31R0201_00032
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 3
    GoTo _06CD
    End
_0F84:
    @ HGSS: ScrCmd_412 52, 0, 0
    @ HGSS: ScrCmd_412 58, 0, 0
    GoTo _0F9C
    End
_0F9C:
    @ HGSS: ScrCmd_416 1, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0F9C
    GoTo _0F52
    End
scr_seq_D31R0201_003:
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Call _0807
    @ HGSS: ScrCmd_412 100, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _085B
    @ HGSS: ScrCmd_412 35, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _107A
    GoTo _1001
    End
_1001:
    Message msg_0096_D31R0201_00053
    @ HGSS: ScrCmd_412 43, 0, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_MAP_LOCAL_0x00, VAR_RESULT
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 5
    GoToIf 1, _104F
    CompareVar VAR_0x8008, 4
    GoToIf 1, _12B6
    @ HGSS: ScrCmd_412 49, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    CallIf 1, _106F
    GoTo _104F
    End
_104F:
    Message msg_0096_D31R0201_00056
    Call _0817
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _1286
    GoTo _0855
    End
_106F:
    Message msg_0096_D31R0201_00073
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    Return
_107A:
    @ HGSS: ScrCmd_412 43, 0, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _1268
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _118D
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _10E6
    @ HGSS: ScrCmd_412 49, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _10D2
    Call _1263
    GoTo _1273
    End
_10D2:
    Message msg_0096_D31R0201_00012
    Message msg_0096_D31R0201_00073
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    GoTo _1273
    End
_10E6:
    Message msg_0096_D31R0201_00012
    @ HGSS: ScrCmd_412 54, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _115A
    GoTo _1106
    End
_1106:
    @ HGSS: ScrCmd_412 10, 0, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_MAP_LOCAL_0x00, VAR_RESULT
    BufferPlayerName 0
    BufferNumber 1, VAR_MAP_LOCAL_0x00
    Message msg_0096_D31R0201_00055
    GoTo _1127
    End
_1127:
    @ HGSS: ScrCmd_412 49, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _12F1
    GoTo _1144
    End
_1144:
    BufferNumber 0, VAR_MAP_LOCAL_0x00
    Message msg_0096_D31R0201_00070
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    GoTo _12F1
    End
_115A:
    @ HGSS: ScrCmd_412 49, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _12F1
    GoTo _1177
    End
_1177:
    BufferNumber 0, VAR_MAP_LOCAL_0x00
    Message msg_0096_D31R0201_00132
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    GoTo _12F1
    End
_118D:
    @ HGSS: ScrCmd_412 45, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11AA
    GoTo _11F1
    End
_11AA:
    Call _1263
    GoTo _11B8
    End
_11B8:
    Message msg_0096_D31R0201_00014
    Call _0817
    @ HGSS: ScrCmd_414 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0855
    Message msg_0096_D31R0201_00113
    CloseMessage
    SetVarFromVar VAR_MAP_LOCAL_0x02, VAR_RESULT
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Call _0BB3
    GoTo _0167
    End
_11F1:
    CompareVar VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 1
    CallIf 1, _1231
    CompareVar VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 3
    CallIf 1, _1248
    @ HGSS: ScrCmd_412 48, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _11B8
    Message msg_0096_D31R0201_00084
    PlayFanfare SEQ_FANFA1_sseq
    WaitFanfare
    GoTo _11B8
    End
_1231:
    Message msg_0096_D31R0201_00085
    BufferPlayerName 0
    Message msg_0096_D31R0201_00087
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 2
    Return
_1248:
    Message msg_0096_D31R0201_00085
    BufferPlayerName 0
    Message msg_0096_D31R0201_00086
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_TOWER_PRINT_PROGRESS, 4
    Common_CheckAllFrontierGoldPrintsObtained
    Return
_1263:
    Message msg_0096_D31R0201_00012
    Return
_1268:
    Message msg_0096_D31R0201_00054
    GoTo _1273
    End
_1273:
    Message msg_0096_D31R0201_00014
    Call _0817
    CloseMessage
    GoTo _0855
    End
_1286:
    @ HGSS: ScrCmd_414 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0855
    Message msg_0096_D31R0201_00113
    CloseMessage
    SetVarFromVar VAR_MAP_LOCAL_0x02, VAR_RESULT
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Call _0BB3
    GoTo _0167
    End
_12B6:
    @ HGSS: ScrCmd_412 9, 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _12D3
    GoTo _12F1
    End
_12D3:
    @ HGSS: ScrCmd_412 10, 0, VAR_SPECIAL_RESULT
    SetVarFromVar VAR_0x8000, VAR_RESULT
    BufferNumber 0, VAR_0x8000
    Message msg_0096_D31R0201_00065
    GoTo _12F1
    End
_12F1:
    @ HGSS: ScrCmd_412 11, 1, 0
    GoTo _1301
    End
_1301:
    Call _0872
    Message msg_0096_D31R0201_00056
    Call _0817
    Message msg_0096_D31R0201_00057
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _085B
    Call _0A42
    CompareVar VAR_RESULT, 0
    GoToIf 5, _085B
    Message msg_0096_D31R0201_00060
    GoTo _085B
    End
    .balign 4, 0
_1348:
    Delay4
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_1354:
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_1360:
    Delay4
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_136C:
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_1378:
    FaceEast
    EndMovement
scr_seq_D31R0201_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_0x8001, 0
    Call _1404
    End
scr_seq_D31R0201_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_0x8001, 1
    Call _1404
    End
scr_seq_D31R0201_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_0x8001, 2
    Call _1404
    End
scr_seq_D31R0201_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: ScrCmd_419 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _13F9
    SetVarFromValue VAR_0x8000, 1
    SetVarFromValue VAR_0x8001, 0
    Call _1404
    End
_13F9:
    Message msg_0096_D31R0201_00111
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1404:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_408 VAR_SPECIAL_x8000, VAR_SPECIAL_x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    Return
scr_seq_D31R0201_013:
    NPCMessage msg_0096_D31R0201_00074
    End
scr_seq_D31R0201_014:
    NPCMessage msg_0096_D31R0201_00075
    End
scr_seq_D31R0201_015:
    NPCMessage msg_0096_D31R0201_00076
    End
scr_seq_D31R0201_016:
    NPCMessage msg_0096_D31R0201_00077
    End
scr_seq_D31R0201_017:
    NPCMessage msg_0096_D31R0201_00078
    End
scr_seq_D31R0201_018:
    NPCMessage msg_0096_D31R0201_00079
    End
scr_seq_D31R0201_019:
    NPCMessage msg_0096_D31R0201_00080
    End
scr_seq_D31R0201_008:
    End
scr_seq_D31R0201_020:
    PlayCry SPECIES_PIKACHU, 0
    NPCMessage msg_0096_D31R0201_00081
    End
_14C8:
    Call _088C
    Call _0890
    Common_GriseousOrbCouldNotBeRemoved
    End
scr_seq_D31R0201_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CallIfUnset FLAG_HGSS_GOT_JUDGE_EXPLANATION, _158E
    CallIfSet FLAG_HGSS_GOT_JUDGE_EXPLANATION, _1593
    SetFlag FLAG_HGSS_GOT_JUDGE_EXPLANATION
    GoTo _1506
    End
_1506:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    SetVarFromVar VAR_0x8000, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _1645
    GetPartyMonSpecies VAR_0x8000, VAR_0x8004
    CompareVar VAR_0x8004, 0
    GoToIf 1, _1598
    @ HGSS: StatJudge VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003
    CompareVar VAR_0x8001, 90
    GoToIf 3, _15E5
    CompareVar VAR_0x8001, 120
    GoToIf 3, _15F0
    CompareVar VAR_0x8001, 150
    GoToIf 3, _15FB
    CompareVar VAR_0x8001, 151
    GoToIf 4, _1606
    End
_158E:
    Message msg_0096_D31R0201_00114
    Return
_1593:
    Message msg_0096_D31R0201_00115
    Return
_1598:
    Message msg_0096_D31R0201_00117
    GoTo _1506
    End
_15A3:
    MessageVar VAR_0x8002
    GoTo _15AF
    End
_15AF:
    CompareVar VAR_0x8003, 15
    GoToIf 3, _1611
    CompareVar VAR_0x8003, 25
    GoToIf 3, _161C
    CompareVar VAR_0x8003, 30
    GoToIf 3, _1627
    CompareVar VAR_0x8003, 31
    GoToIf 4, _1632
    End
_15E5:
    Message msg_0096_D31R0201_00118
    GoTo _15A3
    End
_15F0:
    Message msg_0096_D31R0201_00119
    GoTo _15A3
    End
_15FB:
    Message msg_0096_D31R0201_00120
    GoTo _15A3
    End
_1606:
    Message msg_0096_D31R0201_00121
    GoTo _15A3
    End
_1611:
    Message msg_0096_D31R0201_00128
    GoTo _163D
    End
_161C:
    Message msg_0096_D31R0201_00129
    GoTo _163D
    End
_1627:
    Message msg_0096_D31R0201_00130
    GoTo _163D
    End
_1632:
    Message msg_0096_D31R0201_00131
    GoTo _163D
    End
_163D:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1645:
    Message msg_0096_D31R0201_00116
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
