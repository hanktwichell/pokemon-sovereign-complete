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
    GoToIfSet FLAG_HGSS_UNK_172, _0146
    SetFlag FLAG_HGSS_UNK_172
    Message msg_0509_T07R0501_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0164
    GoTo _016D
scr_seq_T07R0501_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 3, 0
    Message msg_0509_T07R0501_00009
    @ HGSS: ScrCmd_116 0, 20, 2
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 21, 0
    AddMenuEntry 22, 1
    AddMenuEntry 20, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _01E5
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0281
    GoTo _02F3
scr_seq_T07R0501_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 3, 0
    Message msg_0509_T07R0501_00018
    @ HGSS: ScrCmd_116 0, 20, 2
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 33, 0
    AddMenuEntry 34, 1
    AddMenuEntry 35, 2
    AddMenuEntry 20, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0300
    CompareVar VAR_0x8008, 1
    GoToIf 1, _030C
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0318
    GoTo _02F3
scr_seq_T07R0501_000:
    NPCMessage msg_0509_T07R0501_00000
    End
scr_seq_T07R0501_001:
    NPCMessage msg_0509_T07R0501_00001
    End
_0146:
    Message msg_0509_T07R0501_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0164
    GoTo _016D
_0164:
    Message msg_0509_T07R0501_00006
    GoTo _0324
_016D:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _0164
    GetPartyMonSpecies VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 0
    GoToIf 1, _032C
    @ HGSS: GetHiddenPowerType VAR_SPECIAL_x8000, VAR_SPECIAL_x8004
    CompareVar VAR_0x8004, 65535
    GoToIf 1, _0335
    CheckPartyMonHasMove VAR_RESULT, MOVE_HIDDEN_POWER, VAR_0x8000
    CompareVar VAR_RESULT, 0
    GoToIf 1, _033E
    BufferTypeName 0, VAR_0x8004
    Message msg_0509_T07R0501_00005
    GoTo _0324
_01E5:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 23, 0
    AddMenuEntry 24, 1
    AddMenuEntry 25, 2
    AddMenuEntry 26, 3
    AddMenuEntry 27, 4
    AddMenuEntry 28, 5
    AddMenuEntry 20, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _034C
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03D5
    CompareVar VAR_0x8008, 2
    GoToIf 1, _045E
    CompareVar VAR_0x8008, 3
    GoToIf 1, _04E7
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0570
    CompareVar VAR_0x8008, 5
    GoToIf 1, _05F9
    GoTo _0682
_0281:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 29, 0
    AddMenuEntry 30, 1
    AddMenuEntry 31, 2
    AddMenuEntry 32, 3
    AddMenuEntry 20, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06CA
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0753
    CompareVar VAR_0x8008, 2
    GoToIf 1, _07DC
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0865
    GoTo _0682
_02F3:
    Message msg_0509_T07R0501_00010
    WaitButton
    CloseMessage
    GoTo _08EE
_0300:
    SetVar VAR_MAP_LOCAL_0x02, 236
    GoTo _08FA
_030C:
    SetVar VAR_MAP_LOCAL_0x02, 133
    GoTo _08FA
_0318:
    SetVar VAR_MAP_LOCAL_0x02, 375
    GoTo _08FA
_0324:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_032C:
    Message msg_0509_T07R0501_00007
    GoTo _0324
_0335:
    Message msg_0509_T07R0501_00008
    GoTo _0324
_033E:
    BufferTypeName 0, VAR_0x8004
    Message msg_0509_T07R0501_00004
    GoTo _0324
_034C:
    SetVar VAR_0x8004, ITEM_TM58
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0930
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E5
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 2000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_03D5:
    SetVar VAR_0x8004, ITEM_TM32
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0979
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E5
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_045E:
    SetVar VAR_0x8004, ITEM_TM10
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09B9
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E5
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 6000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 6000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_04E7:
    SetVar VAR_0x8004, ITEM_TM29
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09F9
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E5
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_0570:
    SetVar VAR_0x8004, ITEM_TM74
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A39
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E5
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_05F9:
    SetVar VAR_0x8004, ITEM_TM68
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A79
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01E5
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 15000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 15000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_0682:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 21, 0
    AddMenuEntry 22, 1
    AddMenuEntry 20, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _01E5
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0281
    GoTo _02F3
_06CA:
    SetVar VAR_0x8004, ITEM_SILK_SCARF
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0AB9
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0281
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_0753:
    SetVar VAR_0x8004, ITEM_WIDE_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0AF9
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0281
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_07DC:
    SetVar VAR_0x8004, ITEM_ZOOM_LENS
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0B39
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0281
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_0865:
    SetVar VAR_0x8004, ITEM_METRONOME
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0918
    BufferItemName 0, VAR_0x8004
    Message msg_0509_T07R0501_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0B79
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0281
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_08EE:
    @ HGSS: ScrCmd_117
    @ HGSS: ScriptOverlayCmd 3, 1
    ReleaseAll
    End
_08FA:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _0BB9
    Message msg_0509_T07R0501_00015
    WaitButton
    CloseMessage
    GoTo _08EE
_0918:
    Message msg_0509_T07R0501_00014
    CloseMessage
    CompareVar VAR_0x8004, 385
    GoToIf 5, _0BDD
    GoTo _01E5
_0930:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 2000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 2000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_0970:
    Message msg_0509_T07R0501_00011
    GoTo _0BF0
_0979:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 4000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_09B9:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 6000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 6000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_09F9:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_0A39:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 10000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 10000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_0A79:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 15000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 15000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _01E5
_0AB9:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_0AF9:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_0B39:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_0B79:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1000
    GoToIf 0, _0970
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    SubtractCoinsFromValue 1000
    @ HGSS: ScrCmd_118 0
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    Message msg_0509_T07R0501_00019
    AddItem VAR_0x8004, 1, VAR_RESULT
    GoTo _0281
_0BB9:
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0509_T07R0501_00016
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0C03
    CloseMessage
    GoTo _0C27
_0BDD:
    CompareVar VAR_0x8004, 359
    GoToIf 5, _0C84
    GoTo _01E5
_0BF0:
    CompareVar VAR_0x8004, 385
    GoToIf 5, _0BDD
    GoTo _01E5
_0C03:
    CompareVar VAR_MAP_LOCAL_0x02, 236
    GoToIf 5, _0C97
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 1500
    GoToIf 0, _0CBB
    GoTo _0CC4
_0C27:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 33, 0
    AddMenuEntry 34, 1
    AddMenuEntry 35, 2
    AddMenuEntry 20, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0300
    CompareVar VAR_0x8008, 1
    GoToIf 1, _030C
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0318
    GoTo _02F3
_0C84:
    CompareVar VAR_0x8004, 337
    GoToIf 5, _0CFE
    GoTo _01E5
_0C97:
    CompareVar VAR_MAP_LOCAL_0x02, 133
    GoToIf 5, _0D11
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 3000
    GoToIf 0, _0CBB
    GoTo _0CC4
_0CBB:
    Message msg_0509_T07R0501_00011
    GoTo _0C27
_0CC4:
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    GivePokemon VAR_MAP_LOCAL_0x02, 20, 0, VAR_RESULT
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0509_T07R0501_00017
    CompareVar VAR_MAP_LOCAL_0x02, 236
    GoToIf 5, _0D5C
    SubtractCoinsFromValue 1500
    GoTo _0D73
_0CFE:
    CompareVar VAR_0x8004, 356
    GoToIf 5, _0D7C
    GoTo _01E5
_0D11:
    GetCoinsAmount VAR_0x8006
    CompareVar VAR_0x8006, 4500
    GoToIf 0, _0CBB
    Message msg_0509_T07R0501_00013
    PlaySE SEQ_SE_DP_REGI_sseq
    GivePokemon VAR_MAP_LOCAL_0x02, 20, 0, VAR_RESULT
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_MAP_LOCAL_0x02, 0, 0
    Message msg_0509_T07R0501_00017
    CompareVar VAR_MAP_LOCAL_0x02, 122
    GoToIf 5, _0D5C
    SubtractCoinsFromValue 1500
    GoTo _0D73
_0D5C:
    CompareVar VAR_MAP_LOCAL_0x02, 133
    GoToIf 5, _0D8F
    SubtractCoinsFromValue 3000
    GoTo _0D73
_0D73:
    @ HGSS: ScrCmd_118 0
    GoTo _0C27
_0D7C:
    CompareVar VAR_0x8004, 401
    GoToIf 5, _0D9C
    GoTo _01E5
_0D8F:
    SubtractCoinsFromValue 4500
    @ HGSS: ScrCmd_118 0
    GoTo _0C27
_0D9C:
    CompareVar VAR_0x8004, 395
    GoToIf 5, _0DAF
    GoTo _01E5
_0DAF:
    GoTo _0281
    .balign 4, 0
