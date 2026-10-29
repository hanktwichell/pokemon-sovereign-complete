#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0603.h"

#define obj_T25SP0101_suit 0

    ScriptEntry scr_seq_T25SP0101_000
    ScriptEntry scr_seq_T25SP0101_001
    ScriptEntry scr_seq_T25SP0101_002
    ScriptEntry scr_seq_T25SP0101_003
    ScriptEntry scr_seq_T25SP0101_004
    ScriptEntry scr_seq_T25SP0101_005
    ScriptEntry scr_seq_T25SP0101_006
    ScriptEntry scr_seq_T25SP0101_007
    ScriptEntry scr_seq_T25SP0101_008
    ScriptEntry scr_seq_T25SP0101_009
    ScriptEntry scr_seq_T25SP0101_010
    ScriptEntry scr_seq_T25SP0101_011
    ScriptEntryEnd
scr_seq_T25SP0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0254
    ApplyMovement obj_T25SP0101_suit, _11DC
    WaitMovement
    Message msg_0603_T25SP0101_00040
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CasinoGame 0, 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_MAP_LOCAL_0x01, 2
    ReleaseAll
    End
scr_seq_T25SP0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _026A
    Call _0292
    GoTo _02B3
scr_seq_T25SP0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02D3
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _02E9
    Message msg_0603_T25SP0101_00034
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    GoTo _02FF
scr_seq_T25SP0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0603_T25SP0101_00000
    ShowCoins 20, 2
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 12, 0
    AddMenuEntry 13, 1
    AddMenuEntry 11, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0307
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03A3
    GoTo _0415
scr_seq_T25SP0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0603_T25SP0101_00009
    ShowCoins 20, 2
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0422
    GoTo _0428
scr_seq_T25SP0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    MessageGendered msg_0603_T25SP0101_00042, msg_0603_T25SP0101_00043
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0485
    Message msg_0603_T25SP0101_00044
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25SP0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BELLOSSOM, 0
    Message msg_0603_T25SP0101_00052
    WaitCry
    BufferPlayerName 0
    ApplyMovement 4, _11E2
    WaitMovement
    FacePlayer
    PlayCry SPECIES_BELLOSSOM, 0
    Message msg_0603_T25SP0101_00058
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25SP0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_WYNAUT, 0
    Message msg_0603_T25SP0101_00053
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25SP0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_WOBBUFFET, 0
    Message msg_0603_T25SP0101_00054
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25SP0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FF4, _04E6
    Message msg_0603_T25SP0101_00055
    PlayCry SPECIES_SPINDA, 0
    Message msg_0603_T25SP0101_00056
    SetFlag FLAG_HGSS_SG_3FF4
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25SP0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_LUDICOLO, 0
    Message msg_0603_T25SP0101_00057
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25SP0101_011:
    End
_0254:
    Message msg_0603_T25SP0101_00038
    ApplyMovement obj_T25SP0101_suit, _11DC
    WaitMovement
    Message msg_0603_T25SP0101_00039
    GoTo _04F9
_026A:
    ApplyMovement obj_T25SP0101_suit, _11DC
    WaitMovement
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0501
    Message msg_0603_T25SP0101_00041
    GoTo _04F9
_0292:
    GetPlayerMapPos VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x03
    CompareVar VAR_MAP_LOCAL_0x02, 6
    GoToIf 5, _050C
    ApplyMovement obj_T25SP0101_suit, _1244
    GoTo _0516
_02B3:
    WaitMovement
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0501
    Message msg_0603_T25SP0101_00041
    GoTo _04F9
_02D3:
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0518
    Message msg_0603_T25SP0101_00028
    GoTo _0552
_02E9:
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 5, _0589
    Message msg_0603_T25SP0101_00035
    GoTo _02FF
_02FF:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0307:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 16, 2
    AddMenuEntry 17, 3
    AddMenuEntry 18, 4
    AddMenuEntry 19, 5
    AddMenuEntry 11, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0594
    CompareVar VAR_0x8008, 1
    GoToIf 1, _061D
    CompareVar VAR_0x8008, 2
    GoToIf 1, _06A6
    CompareVar VAR_0x8008, 3
    GoToIf 1, _072F
    CompareVar VAR_0x8008, 4
    GoToIf 1, _07B8
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0841
    GoTo _08CA
_03A3:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 20, 0
    AddMenuEntry 21, 1
    AddMenuEntry 22, 2
    AddMenuEntry 23, 3
    AddMenuEntry 11, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0912
    CompareVar VAR_0x8008, 1
    GoToIf 1, _099B
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0A24
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0AAD
    GoTo _08CA
_0415:
    Message msg_0603_T25SP0101_00001
    WaitButton
    CloseMessage
    GoTo _0B36
_0422:
    GoTo _0B42
_0428:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 24, 0
    AddMenuEntry 25, 1
    AddMenuEntry 26, 2
    AddMenuEntry 11, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B9F
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BAB
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0BB7
    GoTo _0415
_0485:
    Message msg_0603_T25SP0101_00049
    ShowCoins 20, 2
    ShowMoney 20, 7
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 45, 0
    AddMenuEntry 46, 1
    AddMenuEntry 11, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0BC3
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0C0D
    Message msg_0603_T25SP0101_00050
    GoTo _0C57
_04E6:
    PlayCry SPECIES_SPINDA, 0
    Message msg_0603_T25SP0101_00056
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04F9:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0501:
    Message msg_0603_T25SP0101_00039
    WaitButton
    CloseMessage
    ReleaseAll
    End
_050C:
    ApplyMovement obj_T25SP0101_suit, _124A
    Return
_0516:
    Return
_0518:
    Message msg_0603_T25SP0101_00037
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C69
    Message msg_0603_T25SP0101_00031
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetVar VAR_0x8004, ITEM_COIN_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0603_T25SP0101_00032
    GoTo _04F9
_0552:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C69
    Message msg_0603_T25SP0101_00031
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetVar VAR_0x8004, ITEM_COIN_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0603_T25SP0101_00032
    GoTo _04F9
_0589:
    Message msg_0603_T25SP0101_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0594:
    SetVar VAR_0x8004, ITEM_TM90
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C90
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0307
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_061D:
    SetVar VAR_0x8004, ITEM_TM75
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0CD9
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0307
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_06A6:
    SetVar VAR_0x8004, ITEM_TM44
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D19
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0307
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 2000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_072F:
    SetVar VAR_0x8004, ITEM_TM35
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D59
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0307
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_07B8:
    SetVar VAR_0x8004, ITEM_TM13
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0D99
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0307
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_0841:
    SetVar VAR_0x8004, ITEM_TM24
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0DD9
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0307
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_08CA:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 12, 0
    AddMenuEntry 13, 1
    AddMenuEntry 11, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0307
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03A3
    GoTo _0415
_0912:
    SetVar VAR_0x8004, ITEM_SILK_SCARF
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0E19
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A3
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_099B:
    SetVar VAR_0x8004, ITEM_WIDE_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0E59
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A3
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_0A24:
    SetVar VAR_0x8004, ITEM_ZOOM_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0E99
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A3
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_0AAD:
    SetVar VAR_0x8004, ITEM_METRONOME
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0C78
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0ED9
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A3
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_0B36:
    HideCoins
    ReleaseAll
    End
_0B42:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 24, 0
    AddMenuEntry 27, 1
    AddMenuEntry 26, 2
    AddMenuEntry 11, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B9F
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0F19
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0BB7
    GoTo _0415
_0B9F:
    SetVar VAR_MAP_LOCAL_0x02, 235
    GoTo _0F25
_0BAB:
    SetVar VAR_MAP_LOCAL_0x02, 114
    GoTo _0F25
_0BB7:
    SetVar VAR_MAP_LOCAL_0x02, 137
    GoTo _0F25
_0BC3:
    CheckMoney VAR_RESULT, 1000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0F43
    CheckCanAddCoins VAR_RESULT, 100
    .balign 4, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0F58
    RemoveMoney 1000
    AddCoins 100
    UpdateCoinDisplay
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0603_T25SP0101_00051
    GoTo _0F61
_0C0D:
    CheckMoney VAR_RESULT, 10000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0F43
    CheckCanAddCoins VAR_RESULT, 1000
    Noop
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0F58
    RemoveMoney 10000
    AddCoins 1000
    UpdateCoinDisplay
    UpdateMoneyDisplay
    PlaySE SEQ_SE_DP_REGI_sseq
    WaitSE SEQ_SE_DP_REGI_sseq
    Message msg_0603_T25SP0101_00051
    GoTo _0F61
_0C57:
    WaitButton
    CloseMessage
    HideCoins
    HideMoney
    ReleaseAll
    End
_0C69:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Message msg_0603_T25SP0101_00033
    GoTo _04F9
_0C78:
    Message msg_0603_T25SP0101_00005
    CloseMessage
    CompareVar VAR_0x8004, 417
    GoToIf 5, _0FAC
    GoTo _0307
_0C90:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_0CD0:
    Message msg_0603_T25SP0101_00002
    GoTo _0FBF
_0CD9:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_0D19:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 2000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_0D59:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_0D99:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_0DD9:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0307
_0E19:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_0E59:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_0E99:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_0ED9:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0CD0
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    UpdateCoinDisplay
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _03A3
_0F19:
    SetVar VAR_MAP_LOCAL_0x02, 114
    GoTo _0F25
_0F25:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _0FD2
    Message msg_0603_T25SP0101_00006
    WaitButton
    CloseMessage
    GoTo _0B36
_0F43:
    Message msg_0603_T25SP0101_00047
    WaitButton
    CloseMessage
    HideCoins
    HideMoney
    ReleaseAll
    End
_0F58:
    Message msg_0603_T25SP0101_00048
    GoTo _0C57
_0F61:
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 45, 0
    AddMenuEntry 46, 1
    AddMenuEntry 11, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0BC3
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0C0D
    Message msg_0603_T25SP0101_00050
    GoTo _0C57
_0FAC:
    CompareVar VAR_0x8004, 402
    GoToIf 5, _1007
    GoTo _0307
_0FBF:
    CompareVar VAR_0x8004, 417
    GoToIf 5, _0FAC
    GoTo _0307
_0FD2:
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0603_T25SP0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _101A
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _103E
    GoTo _0428
_1007:
    CompareVar VAR_0x8004, 371
    GoToIf 5, _1044
    GoTo _0307
_101A:
    CompareVar VAR_MAP_LOCAL_0x02, 235
    GoToIf 5, _1057
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _107B
    GoTo _1095
_103E:
    GoTo _0B42
_1044:
    CompareVar VAR_0x8004, 362
    GoToIf 5, _10CF
    GoTo _0307
_1057:
    CompareVar VAR_MAP_LOCAL_0x02, 114
    GoToIf 5, _10E2
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2300
    GoToIf 0, _107B
    GoTo _1095
_107B:
    Message msg_0603_T25SP0101_00002
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _1106
    GoTo _0428
_1095:
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    GivePokemon VAR_MAP_LOCAL_0x02, 22, 0, VAR_RESULT
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0603_T25SP0101_00008
    CompareVar VAR_MAP_LOCAL_0x02, 235
    GoToIf 5, _110C
    SubtractCoinsFromValue 1000
    GoTo _1123
_10CF:
    CompareVar VAR_0x8004, 340
    GoToIf 5, _113D
    GoTo _0307
_10E2:
    CompareVar VAR_MAP_LOCAL_0x02, 114
    GoToIf 5, _1150
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2300
    GoToIf 0, _107B
    GoTo _1095
_1106:
    GoTo _0B42
_110C:
    CompareVar VAR_MAP_LOCAL_0x02, 114
    GoToIf 5, _119B
    SubtractCoinsFromValue 2300
    GoTo _1123
_1123:
    UpdateCoinDisplay
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _11B2
    GoTo _0428
_113D:
    CompareVar VAR_0x8004, 351
    GoToIf 5, _11B8
    GoTo _0307
_1150:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 3500
    GoToIf 0, _107B
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    GivePokemon VAR_MAP_LOCAL_0x02, 22, 0, VAR_RESULT
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0603_T25SP0101_00008
    CompareVar VAR_MAP_LOCAL_0x02, 235
    GoToIf 5, _110C
    SubtractCoinsFromValue 2300
    GoTo _1123
_119B:
    CompareVar VAR_MAP_LOCAL_0x02, 459
    GoToIf 5, _11BE
    SubtractCoinsFromValue 2300
    GoTo _1123
_11B2:
    GoTo _0B42
_11B8:
    GoTo _03A3
_11BE:
    SubtractCoinsFromValue 3500
    UpdateCoinDisplay
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _11B2
    GoTo _0428
    .balign 4, 0
_11DC:
    FaceSouth
    EndMovement
    .balign 4, 0
_11E2:
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
    FaceEast
    EndMovement
    .balign 4, 0
_1244:
    FaceWest
    EndMovement
    .balign 4, 0
_124A:
    FaceEast
    EndMovement
    .balign 4, 0
