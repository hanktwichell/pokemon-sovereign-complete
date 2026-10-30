#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0508.h"


    ScriptEntry scr_seq_T07R0401_000
    ScriptEntry scr_seq_T07R0401_001
    ScriptEntry scr_seq_T07R0401_002
    ScriptEntry scr_seq_T07R0401_003
    ScriptEntry scr_seq_T07R0401_004
    ScriptEntry scr_seq_T07R0401_005
    ScriptEntry scr_seq_T07R0401_006
    ScriptEntry scr_seq_T07R0401_007
    ScriptEntry scr_seq_T07R0401_008
    ScriptEntry scr_seq_T07R0401_009
    ScriptEntry scr_seq_T07R0401_010
    ScriptEntry scr_seq_T07R0401_011
    ScriptEntry scr_seq_T07R0401_012
    ScriptEntry scr_seq_T07R0401_013
    ScriptEntry scr_seq_T07R0401_014
    ScriptEntry scr_seq_T07R0401_015
    ScriptEntry scr_seq_T07R0401_016
    ScriptEntry scr_seq_T07R0401_017
    ScriptEntry scr_seq_T07R0401_018
    ScriptEntry scr_seq_T07R0401_019
    ScriptEntry scr_seq_T07R0401_020
    ScriptEntry scr_seq_T07R0401_021
    ScriptEntry scr_seq_T07R0401_022
    ScriptEntry scr_seq_T07R0401_023
    ScriptEntryEnd
_0062:
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _009C
    HasCoinsFromValue VAR_RESULT, 3
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00AB
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    Return
_009C:
    Message msg_0508_T07R0401_00021
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Return
_00AB:
    Message msg_0508_T07R0401_00022
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Return
scr_seq_T07R0401_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00F5
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_00F5:
    ReleaseAll
    End
scr_seq_T07R0401_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0130
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0130:
    ReleaseAll
    End
scr_seq_T07R0401_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _016B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 2
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_016B:
    ReleaseAll
    End
scr_seq_T07R0401_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01A6
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 3
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01A6:
    ReleaseAll
    End
scr_seq_T07R0401_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01E1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 4
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01E1:
    ReleaseAll
    End
scr_seq_T07R0401_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _021C
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 5
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_021C:
    ReleaseAll
    End
scr_seq_T07R0401_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0257
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 6
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0257:
    ReleaseAll
    End
scr_seq_T07R0401_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0292
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 7
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0292:
    ReleaseAll
    End
scr_seq_T07R0401_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _02CD
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 8
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_02CD:
    ReleaseAll
    End
scr_seq_T07R0401_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0308
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 9
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0308:
    ReleaseAll
    End
scr_seq_T07R0401_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0343
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 10
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0343:
    ReleaseAll
    End
scr_seq_T07R0401_021:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _037E
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 11
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_037E:
    ReleaseAll
    End
scr_seq_T07R0401_022:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _03BE
    Message msg_0508_T07R0401_00020
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_03BE:
    ReleaseAll
    End
scr_seq_T07R0401_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _0062
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _03F9
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ScrCmd_267 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_03F9:
    ReleaseAll
    End
scr_seq_T07R0401_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0508_T07R0401_00000
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0428
    Message msg_0508_T07R0401_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0428:
    Message msg_0508_T07R0401_00002
    ShowCoins 20, 2
    ShowMoney 20, 7
_043E:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 127, 0
    AddMenuEntry 128, 1
    AddMenuEntry 129, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _048B
    CompareVar VAR_0x8008, 1
    GoToIf 1, _04D7
    Message msg_0508_T07R0401_00006
    GoTo _0531
    End
_048B:
    CheckMoney VAR_RESULT, 1000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _052E
    CheckCanAddCoins VAR_RESULT, 50
    .balign 4, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0523
    RemoveMoney 1000
    AddCoins 50
    UpdateCoinDisplay
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0508_T07R0401_00003
    GoTo _043E
    End
_04D7:
    CheckMoney VAR_RESULT, 10000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _052E
    CheckCanAddCoins VAR_RESULT, 500
    .balign 4, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0523
    RemoveMoney 10000
    AddCoins 500
    UpdateCoinDisplay
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0508_T07R0401_00003
    GoTo _043E
    End
_0523:
    Message msg_0508_T07R0401_00005
    GoTo _0531
    End
_052E:
    Message msg_0508_T07R0401_00004
_0531:
    WaitButton
    CloseMessage
    HideCoins
    HideMoney
    ReleaseAll
    End
scr_seq_T07R0401_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_17C, _059B
    Message msg_0508_T07R0401_00011
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05AA
    CheckCanAddCoins VAR_RESULT, 18
    Noop
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05B9
    AddCoins 18
    BufferPlayerName 0
    Message msg_0508_T07R0401_00012
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_UNK_17C
_059B:
    Message msg_0508_T07R0401_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05AA:
    Message msg_0508_T07R0401_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05B9:
    Message msg_0508_T07R0401_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0401_001:
    NPCMessage msg_0508_T07R0401_00007
    End
scr_seq_T07R0401_002:
    NPCMessage msg_0508_T07R0401_00008
    End
scr_seq_T07R0401_003:
    NPCMessage msg_0508_T07R0401_00009
    End
scr_seq_T07R0401_004:
    NPCMessage msg_0508_T07R0401_00010
    End
scr_seq_T07R0401_006:
    NPCMessage msg_0508_T07R0401_00016
    End
scr_seq_T07R0401_007:
    NPCMessage msg_0508_T07R0401_00017
    End
scr_seq_T07R0401_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0508_T07R0401_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0401_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0508_T07R0401_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
