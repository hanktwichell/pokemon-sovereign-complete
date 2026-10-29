#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0509.h"


    ScriptEntry scr_seq_T07R0501_000
    ScriptEntry scr_seq_T07R0501_001
    ScriptEntry scr_seq_T07R0501_002
    ScriptEntry scr_seq_T07R0501_003
    ScriptEntry scr_seq_T07R0501_004
    ScriptEntryEnd
scr_seq_T07R0501_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_172, _004D
    SetFlag FLAG_HGSS_UNK_172
    Message msg_0509_T07R0501_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F2
    GoTo _006D
    End
_004D:
    Message msg_0509_T07R0501_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F2
    GoTo _006D
    End
_006D:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: PartySelectUI
    @ HGSS: GetPartySelection VAR_SPECIAL_x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _00F2
    GetPartyMonSpecies VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 0
    GoToIf 1, _00FD
    @ HGSS: GetHiddenPowerType VAR_SPECIAL_x8000, VAR_SPECIAL_x8004
    CompareVar VAR_0x8004, 65535
    GoToIf 1, _00E7
    @ HGSS: MonHasMove VAR_SPECIAL_RESULT, MOVE_HIDDEN_POWER, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0108
    BufferTypeName 0, VAR_0x8004
    Message msg_0509_T07R0501_00005
    GoTo _0118
    End
_00E7:
    Message msg_0509_T07R0501_00008
    GoTo _0118
    End
_00F2:
    Message msg_0509_T07R0501_00006
    GoTo _0118
    End
_00FD:
    Message msg_0509_T07R0501_00007
    GoTo _0118
    End
_0108:
    BufferTypeName 0, VAR_0x8004
    Message msg_0509_T07R0501_00004
    GoTo _0118
    End
_0118:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0501_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 3, 0
    Message msg_0509_T07R0501_00009
    @ HGSS: ScrCmd_116 0, 20, 2
_0138:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 21, 0
    AddMenuEntryImm 22, 1
    AddMenuEntryImm 20, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0180
    CompareVar VAR_0x8008, 1
    GoToIf 1, _021C
    GoTo _0A43
_0180:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 23, 0
    AddMenuEntryImm 24, 1
    AddMenuEntryImm 25, 2
    AddMenuEntryImm 26, 3
    AddMenuEntryImm 27, 4
    AddMenuEntryImm 28, 5
    AddMenuEntryImm 20, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _028E
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0319
    CompareVar VAR_0x8008, 2
    GoToIf 1, _03A4
    CompareVar VAR_0x8008, 3
    GoToIf 1, _042F
    CompareVar VAR_0x8008, 4
    GoToIf 1, _04BA
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0545
    GoTo _0138
_021C:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 29, 0
    AddMenuEntryImm 30, 1
    AddMenuEntryImm 31, 2
    AddMenuEntryImm 32, 3
    AddMenuEntryImm 20, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _05D0
    CompareVar VAR_0x8008, 1
    GoToIf 1, _065B
    CompareVar VAR_0x8008, 2
    GoToIf 1, _06E6
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0771
    GoTo _0138
_028E:
    SetVar VAR_0x8004, ITEM_TM58
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02D7
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0180
_02D7:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 2000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0180
    End
_0319:
    SetVar VAR_0x8004, ITEM_TM32
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0362
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0180
_0362:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0180
    End
_03A4:
    SetVar VAR_0x8004, ITEM_TM10
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03ED
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0180
_03ED:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 6000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 6000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0180
    End
_042F:
    SetVar VAR_0x8004, ITEM_TM29
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0478
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0180
_0478:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0180
    End
_04BA:
    SetVar VAR_0x8004, ITEM_TM74
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0503
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0180
_0503:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0180
    End
_0545:
    SetVar VAR_0x8004, ITEM_TM68
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _058E
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0180
_058E:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 15000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 15000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0180
    End
_05D0:
    SetVar VAR_0x8004, ITEM_SILK_SCARF
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0619
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021C
_0619:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _021C
    End
_065B:
    SetVar VAR_0x8004, ITEM_WIDE_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06A4
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021C
_06A4:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _021C
    End
_06E6:
    SetVar VAR_0x8004, ITEM_ZOOM_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _072F
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021C
_072F:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _021C
    End
_0771:
    SetVar VAR_0x8004, ITEM_METRONOME
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0990
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07BA
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021C
_07BA:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0A31
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _021C
    End
scr_seq_T07R0501_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 3, 0
    Message msg_0509_T07R0501_00018
    @ HGSS: ScrCmd_116 0, 20, 2
_0814:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntryImm 33, 0
    AddMenuEntryImm 34, 1
    AddMenuEntryImm 35, 2
    AddMenuEntryImm 20, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0871
    CompareVar VAR_0x8008, 1
    GoToIf 1, _087D
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0889
    GoTo _0A43
_0871:
    @ HGSS: SetOrCopyVar VAR_TEMP_x4002, 122
    GoTo _0895
_087D:
    @ HGSS: SetOrCopyVar VAR_TEMP_x4002, 133
    GoTo _0895
_0889:
    @ HGSS: SetOrCopyVar VAR_TEMP_x4002, 137
    GoTo _0895
_0895:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _08B3
    Message msg_0509_T07R0501_00015
    WaitButton
    CloseMessage
    GoTo _0A52
_08B3:
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0509_T07R0501_00016
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _08D7
    CloseMessage
    GoTo _0814
_08D7:
    CompareVar VAR_MAP_LOCAL_0x02, 122
    GoToIf 5, _08FB
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 3333
    GoToIf 0, _0A3A
    GoTo _0930
_08FB:
    CompareVar VAR_MAP_LOCAL_0x02, 133
    GoToIf 5, _091F
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 6666
    GoToIf 0, _0A3A
    GoTo _0930
_091F:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 9999
    GoToIf 0, _0A3A
_0930:
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    @ HGSS: GiveMon VAR_TEMP_x4002, 15, 0, 0, 0, VAR_SPECIAL_RESULT
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0509_T07R0501_00017
    CompareVar VAR_MAP_LOCAL_0x02, 122
    GoToIf 5, _096A
    SubtractCoinsFromValue 3333
    GoTo _0985
_096A:
    CompareVar VAR_MAP_LOCAL_0x02, 133
    GoToIf 5, _0981
    SubtractCoinsFromValue 6666
    GoTo _0985
_0981:
    SubtractCoinsFromValue 9999
_0985:
    @ HGSS: ScrCmd_118 0
    GoTo _0814
    End
_0990:
    Message msg_0509_T07R0501_00014
    CloseMessage
_0995:
    CompareVar VAR_0x8004, 385
    GoToIf 5, _09AE
    GoTo _0180
_09A8:
    GoTo _0A31
_09AE:
    CompareVar VAR_0x8004, 359
    GoToIf 5, _09C7
    GoTo _0180
_09C1:
    GoTo _0A31
_09C7:
    CompareVar VAR_0x8004, 337
    GoToIf 5, _09E0
    GoTo _0180
_09DA:
    GoTo _0A31
_09E0:
    CompareVar VAR_0x8004, 356
    GoToIf 5, _09F9
    GoTo _0180
_09F3:
    GoTo _0A31
_09F9:
    CompareVar VAR_0x8004, 401
    GoToIf 5, _0A12
    GoTo _0180
_0A0C:
    GoTo _0A31
_0A12:
    CompareVar VAR_0x8004, 395
    GoToIf 5, _0A2B
    GoTo _0180
_0A25:
    GoTo _0A31
_0A2B:
    GoTo _021C
_0A31:
    Message msg_0509_T07R0501_00011
    GoTo _0995
_0A3A:
    Message msg_0509_T07R0501_00011
    GoTo _0814
_0A43:
    Message msg_0509_T07R0501_00010
    WaitButton
    CloseMessage
    GoTo _0A52
    End
_0A52:
    @ HGSS: ScrCmd_117
    @ HGSS: ScriptOverlayCmd 3, 1
    ReleaseAll
    End
scr_seq_T07R0501_000:
    NPCMessage msg_0509_T07R0501_00000
    End
scr_seq_T07R0501_001:
    NPCMessage msg_0509_T07R0501_00001
    End
    .balign 4, 0
