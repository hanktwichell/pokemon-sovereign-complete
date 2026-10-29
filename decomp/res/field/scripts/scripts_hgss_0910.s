#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0603.h"

#define obj_T25SP0101_suit 0

    ScriptEntry scr_seq_T25SP0101_000
    ScriptEntry scr_seq_T25SP0101_001
    ScriptEntry scr_seq_T25SP0101_002
    ScriptEntry scr_seq_T25SP0101_003
    ScriptEntry scr_seq_T25SP0101_004
    ScriptEntryEnd
scr_seq_T25SP0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _006A
    ApplyMovement obj_T25SP0101_suit, _0080
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
_006A:
    Message msg_0603_T25SP0101_00038
    ApplyMovement obj_T25SP0101_suit, _0080
    WaitMovement
    Message msg_0603_T25SP0101_00039
    GoTo _00E8
    .balign 4, 0
_0080:
    FaceSouth
    EndMovement
    .balign 4, 0
_0088:
    FaceWest
    EndMovement
    .balign 4, 0
_0090:
    FaceEast
    EndMovement
scr_seq_T25SP0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _00BD
    Call _00F0
    GoTo _00C5
_00BD:
    ApplyMovement obj_T25SP0101_suit, _0080
_00C5:
    WaitMovement
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E5
    Message msg_0603_T25SP0101_00041
    GoTo _00E8
_00E5:
    Message msg_0603_T25SP0101_00039
_00E8:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F0:
    GetPlayerMapPos VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x03
    CompareVar VAR_MAP_LOCAL_0x02, 6
    GoToIf 5, _0111
    ApplyMovement obj_T25SP0101_suit, _0088
    GoTo _0119
_0111:
    ApplyMovement obj_T25SP0101_suit, _0090
_0119:
    Return
scr_seq_T25SP0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CheckItem ITEM_COIN_CASE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0175
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0154
    Message msg_0603_T25SP0101_00034
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    GoTo _016D
_0154:
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 5, _016A
    Message msg_0603_T25SP0101_00035
    GoTo _016D
_016A:
    Message msg_0603_T25SP0101_00036
_016D:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0175:
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _018B
    Message msg_0603_T25SP0101_00028
    GoTo _018E
_018B:
    Message msg_0603_T25SP0101_00037
_018E:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01C5
    Message msg_0603_T25SP0101_00031
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    SetVar VAR_0x8004, ITEM_COIN_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0603_T25SP0101_00032
    GoTo _00E8
_01C5:
    SetVarFromValue VAR_MAP_LOCAL_0x01, 1
    Message msg_0603_T25SP0101_00033
    GoTo _00E8
scr_seq_T25SP0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 3, 0
    Message msg_0603_T25SP0101_00000
    @ HGSS: ScrCmd_116 0, 20, 2
_01EC:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 12, 0
    AddMenuEntryImm 13, 1
    AddMenuEntryImm 11, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0234
    CompareVar VAR_0x8008, 1
    GoToIf 1, _02D0
    GoTo _0C17
_0234:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 14, 0
    AddMenuEntryImm 15, 1
    AddMenuEntryImm 16, 2
    AddMenuEntryImm 17, 3
    AddMenuEntryImm 18, 4
    AddMenuEntryImm 19, 5
    AddMenuEntryImm 11, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0342
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03CD
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0458
    CompareVar VAR_0x8008, 3
    GoToIf 1, _04E3
    CompareVar VAR_0x8008, 4
    GoToIf 1, _056E
    CompareVar VAR_0x8008, 5
    GoToIf 1, _05F9
    GoTo _01EC
_02D0:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 20, 0
    AddMenuEntryImm 21, 1
    AddMenuEntryImm 22, 2
    AddMenuEntryImm 23, 3
    AddMenuEntryImm 11, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0684
    CompareVar VAR_0x8008, 1
    GoToIf 1, _070F
    CompareVar VAR_0x8008, 2
    GoToIf 1, _079A
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0825
    GoTo _01EC
_0342:
    SetVar VAR_0x8004, ITEM_TM90
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _038B
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0234
_038B:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 2000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0234
    End
_03CD:
    SetVar VAR_0x8004, ITEM_TM75
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0416
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0234
_0416:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0234
    End
_0458:
    SetVar VAR_0x8004, ITEM_TM44
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04A1
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0234
_04A1:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 6000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 6000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0234
    End
_04E3:
    SetVar VAR_0x8004, ITEM_TM35
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _052C
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0234
_052C:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0234
    End
_056E:
    SetVar VAR_0x8004, ITEM_TM13
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05B7
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0234
_05B7:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0234
    End
_05F9:
    SetVar VAR_0x8004, ITEM_TM24
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0642
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0234
_0642:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0234
    End
_0684:
    SetVar VAR_0x8004, ITEM_SILK_SCARF
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06CD
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02D0
_06CD:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _02D0
    End
_070F:
    SetVar VAR_0x8004, ITEM_WIDE_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0758
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02D0
_0758:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _02D0
    End
_079A:
    SetVar VAR_0x8004, ITEM_ZOOM_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07E3
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02D0
_07E3:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _02D0
    End
_0825:
    SetVar VAR_0x8004, ITEM_METRONOME
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0B45
    BufferItemName 0, VAR_0x8004
    Message msg_0603_T25SP0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _086E
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02D0
_086E:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0BE6
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0603_T25SP0101_00010
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _02D0
    End
scr_seq_T25SP0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 3, 0
    Message msg_0603_T25SP0101_00009
    @ HGSS: ScrCmd_116 0, 20, 2
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _08E5
    GoTo _08EB
_08DF:
    GoTo _08EB
_08E5:
    GoTo _0948
_08EB:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 24, 0
    AddMenuEntryImm 25, 1
    AddMenuEntryImm 26, 2
    AddMenuEntryImm 11, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _09A5
    CompareVar VAR_0x8008, 1
    GoToIf 1, _09B1
    CompareVar VAR_0x8008, 2
    GoToIf 1, _09BD
    GoTo _0C17
_0948:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 24, 0
    AddMenuEntryImm 27, 1
    AddMenuEntryImm 26, 2
    AddMenuEntryImm 11, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _09A5
    CompareVar VAR_0x8008, 1
    GoToIf 1, _09C9
    CompareVar VAR_0x8008, 2
    GoToIf 1, _09BD
    GoTo _0C17
_09A5:
    @ HGSS: SetOrCopyVar VAR_TEMP_x4002, 63
    GoTo _09D5
_09B1:
    @ HGSS: SetOrCopyVar VAR_TEMP_x4002, 23
    GoTo _09D5
_09BD:
    @ HGSS: SetOrCopyVar VAR_TEMP_x4002, 147
    GoTo _09D5
_09C9:
    @ HGSS: SetOrCopyVar VAR_TEMP_x4002, 27
    GoTo _09D5
_09D5:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _09F3
    Message msg_0603_T25SP0101_00006
    WaitButton
    CloseMessage
    GoTo _0C26
_09F3:
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0603_T25SP0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A34
    CloseMessage
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0A2E
    GoTo _08EB
_0A28:
    GoTo _0A34
_0A2E:
    GoTo _0948
_0A34:
    CompareVar VAR_MAP_LOCAL_0x02, 63
    GoToIf 5, _0A58
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 200
    GoToIf 0, _0BF1
    GoTo _0AB1
_0A58:
    CompareVar VAR_MAP_LOCAL_0x02, 23
    GoToIf 5, _0A7C
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 700
    GoToIf 0, _0BF1
    GoTo _0AB1
_0A7C:
    CompareVar VAR_MAP_LOCAL_0x02, 27
    GoToIf 5, _0AA0
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 700
    GoToIf 0, _0BF1
    GoTo _0AB1
_0AA0:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2100
    GoToIf 0, _0BF1
_0AB1:
    Message msg_0603_T25SP0101_00004
    PlaySE SEQ_SE_DP_REGI_sseq
    @ HGSS: GiveMon VAR_TEMP_x4002, 15, 0, 0, 0, VAR_SPECIAL_RESULT
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0603_T25SP0101_00008
    CompareVar VAR_MAP_LOCAL_0x02, 63
    GoToIf 5, _0AEB
    SubtractCoinsFromValue 200
    GoTo _0B1D
_0AEB:
    CompareVar VAR_MAP_LOCAL_0x02, 23
    GoToIf 5, _0B02
    SubtractCoinsFromValue 700
    GoTo _0B1D
_0B02:
    CompareVar VAR_MAP_LOCAL_0x02, 27
    GoToIf 5, _0B19
    SubtractCoinsFromValue 700
    GoTo _0B1D
_0B19:
    SubtractCoinsFromValue 2100
_0B1D:
    @ HGSS: ScrCmd_118 0
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0B3D
    GoTo _08EB
_0B37:
    GoTo _0B43
_0B3D:
    GoTo _0948
_0B43:
    End
_0B45:
    Message msg_0603_T25SP0101_00005
    CloseMessage
_0B4A:
    CompareVar VAR_0x8004, 417
    GoToIf 5, _0B63
    GoTo _0234
_0B5D:
    GoTo _0BE6
_0B63:
    CompareVar VAR_0x8004, 402
    GoToIf 5, _0B7C
    GoTo _0234
_0B76:
    GoTo _0BE6
_0B7C:
    CompareVar VAR_0x8004, 371
    GoToIf 5, _0B95
    GoTo _0234
_0B8F:
    GoTo _0BE6
_0B95:
    CompareVar VAR_0x8004, 362
    GoToIf 5, _0BAE
    GoTo _0234
_0BA8:
    GoTo _0BE6
_0BAE:
    CompareVar VAR_0x8004, 340
    GoToIf 5, _0BC7
    GoTo _0234
_0BC1:
    GoTo _0BE6
_0BC7:
    CompareVar VAR_0x8004, 351
    GoToIf 5, _0BE0
    GoTo _0234
_0BDA:
    GoTo _0BE6
_0BE0:
    GoTo _02D0
_0BE6:
    Message msg_0603_T25SP0101_00002
    GoTo _0B4A
    End
_0BF1:
    Message msg_0603_T25SP0101_00002
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0C11
    GoTo _08EB
_0C0B:
    GoTo _0C17
_0C11:
    GoTo _0948
_0C17:
    Message msg_0603_T25SP0101_00001
    WaitButton
    CloseMessage
    GoTo _0C26
    End
_0C26:
    @ HGSS: ScrCmd_117
    @ HGSS: ScriptOverlayCmd 3, 1
    ReleaseAll
    End
    .balign 4, 0
