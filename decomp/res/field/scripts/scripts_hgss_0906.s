#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0599.h"


    ScriptEntry scr_seq_T25R1101_000
    ScriptEntry scr_seq_T25R1101_001
    ScriptEntry scr_seq_T25R1101_002
    ScriptEntry scr_seq_T25R1101_003
    ScriptEntry scr_seq_T25R1101_004
    ScriptEntry scr_seq_T25R1101_005
    ScriptEntry scr_seq_T25R1101_006
    ScriptEntry scr_seq_T25R1101_007
    ScriptEntry scr_seq_T25R1101_008
    ScriptEntry scr_seq_T25R1101_009
    ScriptEntry scr_seq_T25R1101_010
    ScriptEntry scr_seq_T25R1101_011
    ScriptEntry scr_seq_T25R1101_012
    ScriptEntry scr_seq_T25R1101_013
    ScriptEntry scr_seq_T25R1101_014
    ScriptEntry scr_seq_T25R1101_015
    ScriptEntry scr_seq_T25R1101_016
    ScriptEntry scr_seq_T25R1101_017
    ScriptEntry scr_seq_T25R1101_018
    ScriptEntry scr_seq_T25R1101_019
    ScriptEntry scr_seq_T25R1101_020
    ScriptEntry scr_seq_T25R1101_021
    ScriptEntry scr_seq_T25R1101_022
    ScriptEntry scr_seq_T25R1101_023
    ScriptEntry scr_seq_T25R1101_024
    ScriptEntry scr_seq_T25R1101_025
    ScriptEntry scr_seq_T25R1101_026
    ScriptEntry scr_seq_T25R1101_027
    ScriptEntry scr_seq_T25R1101_028
    ScriptEntry scr_seq_T25R1101_029
    ScriptEntry scr_seq_T25R1101_030
    ScriptEntry scr_seq_T25R1101_031
    ScriptEntry scr_seq_T25R1101_032
    ScriptEntryEnd
scr_seq_T25R1101_032:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00A3
    GoTo _00AB
    GoTo _00A9
_00A3:
    GoTo _00FC
_00A9:
    End
_00AB:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _00C6
    SetFlag FLAG_HGSS_UNK_2DA
    GoTo _00FA
_00C6:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _00DD
    SetFlag FLAG_HGSS_UNK_2DA
    GoTo _00FA
_00DD:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _00F4
    SetFlag FLAG_HGSS_UNK_2DA
    GoTo _00FA
_00F4:
    GoTo _00FC
_00FA:
    End
_00FC:
    ClearFlag FLAG_HGSS_UNK_2DA
    End
scr_seq_T25R1101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0139
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 0, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0139:
    ReleaseAll
    End
_013D:
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0177
    HasCoinsFromValue VAR_RESULT, 3
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0186
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    Return
_0177:
    Message msg_0599_T25R1101_00025
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Return
_0186:
    Message msg_0599_T25R1101_00026
    WaitButton
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Return
scr_seq_T25R1101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01D0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 1, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01D0:
    ReleaseAll
    End
scr_seq_T25R1101_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _020B
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 2, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_020B:
    ReleaseAll
    End
scr_seq_T25R1101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0246
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 3, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0246:
    ReleaseAll
    End
scr_seq_T25R1101_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0281
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 4, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0281:
    ReleaseAll
    End
scr_seq_T25R1101_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _02BC
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 5, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_02BC:
    ReleaseAll
    End
scr_seq_T25R1101_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _02F7
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 6, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_02F7:
    ReleaseAll
    End
scr_seq_T25R1101_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0332
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 7, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0332:
    ReleaseAll
    End
scr_seq_T25R1101_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _036D
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 8, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_036D:
    ReleaseAll
    End
scr_seq_T25R1101_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _03A8
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 9, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_03A8:
    ReleaseAll
    End
scr_seq_T25R1101_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _03E3
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 10, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_03E3:
    ReleaseAll
    End
scr_seq_T25R1101_021:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _041E
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 11, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_041E:
    ReleaseAll
    End
scr_seq_T25R1101_022:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0459
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 21, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0459:
    ReleaseAll
    End
scr_seq_T25R1101_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0494
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 12, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0494:
    ReleaseAll
    End
scr_seq_T25R1101_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _04CF
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 13, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_04CF:
    ReleaseAll
    End
scr_seq_T25R1101_025:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _050A
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 14, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_050A:
    ReleaseAll
    End
scr_seq_T25R1101_026:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0545
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 15, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0545:
    ReleaseAll
    End
scr_seq_T25R1101_027:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0580
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 16, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0580:
    ReleaseAll
    End
scr_seq_T25R1101_028:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _05BB
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 17, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_05BB:
    ReleaseAll
    End
scr_seq_T25R1101_029:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _05F6
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 18, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_05F6:
    ReleaseAll
    End
scr_seq_T25R1101_030:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0631
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 19, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_0631:
    ReleaseAll
    End
scr_seq_T25R1101_031:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Call _013D
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _066C
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 20, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_066C:
    ReleaseAll
    End
scr_seq_T25R1101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0599_T25R1101_00000
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _069B
    Message msg_0599_T25R1101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_069B:
    Message msg_0599_T25R1101_00002
    ShowCoins 20, 2
    ShowMoney 20, 7
_06B1:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 127, 0
    AddMenuEntry 128, 1
    AddMenuEntry 129, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06FE
    CompareVar VAR_0x8008, 1
    GoToIf 1, _074A
    Message msg_0599_T25R1101_00006
    GoTo _07A4
    End
_06FE:
    CheckMoney VAR_RESULT, 1000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07A1
    CheckCanAddCoins VAR_RESULT, 50
    Noop
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0796
    RemoveMoney 1000
    AddCoins 50
    UpdateCoinDisplay
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0599_T25R1101_00003
    GoTo _06B1
    End
_074A:
    CheckMoney VAR_RESULT, 10000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07A1
    CheckCanAddCoins VAR_RESULT, 500
    Noop
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0796
    RemoveMoney 10000
    AddCoins 500
    UpdateCoinDisplay
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0599_T25R1101_00003
    GoTo _06B1
    End
_0796:
    Message msg_0599_T25R1101_00005
    GoTo _07A4
    End
_07A1:
    Message msg_0599_T25R1101_00004
_07A4:
    WaitButton
    CloseMessage
    HideCoins
    HideMoney
    ReleaseAll
    End
scr_seq_T25R1101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0599_T25R1101_00007
    ShowCoins 20, 2
_07CE:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 37, 0
    AddMenuEntry 38, 1
    AddMenuEntry 36, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0816
    CompareVar VAR_0x8008, 1
    GoToIf 1, _08B2
    GoTo _11F9
_0816:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 39, 0
    AddMenuEntry 40, 1
    AddMenuEntry 41, 2
    AddMenuEntry 42, 3
    AddMenuEntry 43, 4
    AddMenuEntry 44, 5
    AddMenuEntry 36, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0924
    CompareVar VAR_0x8008, 1
    GoToIf 1, _09AF
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0A3A
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0AC5
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0B50
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0BDB
    GoTo _07CE
_08B2:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 45, 0
    AddMenuEntry 46, 1
    AddMenuEntry 47, 2
    AddMenuEntry 48, 3
    AddMenuEntry 36, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0C66
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0CF1
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0D7C
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0E07
    GoTo _07CE
_0924:
    SetVar VAR_0x8004, ITEM_TM90
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _096D
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0816
_096D:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 2000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0816
    End
_09AF:
    SetVar VAR_0x8004, ITEM_TM75
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09F8
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0816
_09F8:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0816
    End
_0A3A:
    SetVar VAR_0x8004, ITEM_TM44
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A83
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0816
_0A83:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 6000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 6000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0816
    End
_0AC5:
    SetVar VAR_0x8004, ITEM_TM35
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0B0E
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0816
_0B0E:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0816
    End
_0B50:
    SetVar VAR_0x8004, ITEM_TM13
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0B99
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0816
_0B99:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0816
    End
_0BDB:
    SetVar VAR_0x8004, ITEM_TM24
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C24
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0816
_0C24:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0816
    End
_0C66:
    SetVar VAR_0x8004, ITEM_SILK_SCARF
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0CAF
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08B2
_0CAF:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _08B2
    End
_0CF1:
    SetVar VAR_0x8004, ITEM_WIDE_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D3A
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08B2
_0D3A:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _08B2
    End
_0D7C:
    SetVar VAR_0x8004, ITEM_ZOOM_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0DC5
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08B2
_0DC5:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _08B2
    End
_0E07:
    SetVar VAR_0x8004, ITEM_METRONOME
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _1127
    BufferItemName 0, VAR_0x8004
    Message msg_0599_T25R1101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0E50
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08B2
_0E50:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _11C8
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0599_T25R1101_00017
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _08B2
    End
scr_seq_T25R1101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0599_T25R1101_00016
    ShowCoins 20, 2
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0EC7
    GoTo _0ECD
    GoTo _0ECD
_0EC7:
    GoTo _0F2A
_0ECD:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 49, 0
    AddMenuEntry 50, 1
    AddMenuEntry 51, 2
    AddMenuEntry 36, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0F87
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0F93
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0F9F
    GoTo _11F9
_0F2A:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 49, 0
    AddMenuEntry 52, 1
    AddMenuEntry 51, 2
    AddMenuEntry 36, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0F87
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0FAB
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0F9F
    GoTo _11F9
_0F87:
    SetVar VAR_MAP_LOCAL_0x02, 63
    GoTo _0FB7
_0F93:
    SetVar VAR_MAP_LOCAL_0x02, 23
    GoTo _0FB7
_0F9F:
    SetVar VAR_MAP_LOCAL_0x02, 147
    GoTo _0FB7
_0FAB:
    SetVar VAR_MAP_LOCAL_0x02, 27
    GoTo _0FB7
_0FB7:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _0FD5
    Message msg_0599_T25R1101_00013
    WaitButton
    CloseMessage
    GoTo _1208
_0FD5:
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0599_T25R1101_00014
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _1016
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _1010
    GoTo _0ECD
    GoTo _1016
_1010:
    GoTo _0F2A
_1016:
    CompareVar VAR_MAP_LOCAL_0x02, 63
    GoToIf 5, _103A
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 200
    GoToIf 0, _11D3
    GoTo _1093
_103A:
    CompareVar VAR_MAP_LOCAL_0x02, 23
    GoToIf 5, _105E
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 700
    GoToIf 0, _11D3
    GoTo _1093
_105E:
    CompareVar VAR_MAP_LOCAL_0x02, 27
    GoToIf 5, _1082
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 700
    GoToIf 0, _11D3
    GoTo _1093
_1082:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2100
    GoToIf 0, _11D3
_1093:
    Message msg_0599_T25R1101_00011
    PlaySE SEQ_SE_DP_REGI_sseq
    GivePokemon VAR_MAP_LOCAL_0x02, 15, 0, VAR_RESULT
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0599_T25R1101_00015
    CompareVar VAR_MAP_LOCAL_0x02, 63
    GoToIf 5, _10CD
    SubtractCoinsFromValue 200
    GoTo _10FF
_10CD:
    CompareVar VAR_MAP_LOCAL_0x02, 23
    GoToIf 5, _10E4
    SubtractCoinsFromValue 700
    GoTo _10FF
_10E4:
    CompareVar VAR_MAP_LOCAL_0x02, 27
    GoToIf 5, _10FB
    SubtractCoinsFromValue 700
    GoTo _10FF
_10FB:
    SubtractCoinsFromValue 2100
_10FF:
    UpdateCoinDisplay
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _111F
    GoTo _0ECD
    GoTo _1125
_111F:
    GoTo _0F2A
_1125:
    End
_1127:
    Message msg_0599_T25R1101_00012
    CloseMessage
_112C:
    CompareVar VAR_0x8004, 417
    GoToIf 5, _1145
    GoTo _0816
    GoTo _11C8
_1145:
    CompareVar VAR_0x8004, 402
    GoToIf 5, _115E
    GoTo _0816
    GoTo _11C8
_115E:
    CompareVar VAR_0x8004, 371
    GoToIf 5, _1177
    GoTo _0816
    GoTo _11C8
_1177:
    CompareVar VAR_0x8004, 362
    GoToIf 5, _1190
    GoTo _0816
    GoTo _11C8
_1190:
    CompareVar VAR_0x8004, 340
    GoToIf 5, _11A9
    GoTo _0816
    GoTo _11C8
_11A9:
    CompareVar VAR_0x8004, 351
    GoToIf 5, _11C2
    GoTo _0816
    GoTo _11C8
_11C2:
    GoTo _08B2
_11C8:
    Message msg_0599_T25R1101_00009
    GoTo _112C
    End
_11D3:
    Message msg_0599_T25R1101_00009
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _11F3
    GoTo _0ECD
    GoTo _11F9
_11F3:
    GoTo _0F2A
_11F9:
    Message msg_0599_T25R1101_00008
    WaitButton
    CloseMessage
    GoTo _1208
    End
_1208:
    HideCoins
    ReleaseAll
    End
scr_seq_T25R1101_003:
    NPCMessage msg_0599_T25R1101_00018
    End
scr_seq_T25R1101_004:
    NPCMessage msg_0599_T25R1101_00019
    End
scr_seq_T25R1101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0599_T25R1101_00027
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _12DE
    Message msg_0599_T25R1101_00031
    WaitButton
    Message msg_0599_T25R1101_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _12DE
    Message msg_0599_T25R1101_00032
    WaitButton
    Message msg_0599_T25R1101_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _12DE
    Message msg_0599_T25R1101_00033
    WaitButton
    Message msg_0599_T25R1101_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _12DE
    Message msg_0599_T25R1101_00034
    WaitButton
    Message msg_0599_T25R1101_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _12DE
    Message msg_0599_T25R1101_00035
    WaitButton
    Message msg_0599_T25R1101_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_12DE:
    Message msg_0599_T25R1101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1101_006:
    NPCMessage msg_0599_T25R1101_00021
    End
scr_seq_T25R1101_007:
    NPCMessage msg_0599_T25R1101_00022
    End
scr_seq_T25R1101_008:
    NPCMessage msg_0599_T25R1101_00023
    End
scr_seq_T25R1101_009:
    NPCMessage msg_0599_T25R1101_00024
    End
    .balign 4, 0
