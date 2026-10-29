#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0738.h"


    ScriptEntry scr_seq_UNION_000
    ScriptEntry scr_seq_UNION_001
    ScriptEntry scr_seq_UNION_002
    ScriptEntry scr_seq_UNION_003
    ScriptEntry scr_seq_UNION_004
    ScriptEntry scr_seq_UNION_005
    ScriptEntry scr_seq_UNION_006
    ScriptEntry scr_seq_UNION_007
    ScriptEntryEnd
scr_seq_UNION_000:
    End
scr_seq_UNION_001:
    End
scr_seq_UNION_002:
    @ HGSS: ScrCmd_270
    End
scr_seq_UNION_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_268 VAR_SPECIAL_RESULT
    SetVarFromVar VAR_0x8004, VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0499
    @ HGSS: ScrCmd_264 0
    CompareVar VAR_RESULT, 2
    GoToIf 1, _04AF
    CompareVar VAR_RESULT, 3
    GoToIf 1, _05DB
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0528
    @ HGSS: ScrCmd_274 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_268 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0499
    Message msg_0738_UNION_00199
    @ HGSS: ScrCmd_269 VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 3
    GoToIf 1, _07CC
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0488
    GoTo _00BC
    End
_00BC:
    @ HGSS: ScrCmd_257 100
    @ HGSS: ScrCmd_267 2, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_592 VAR_SPECIAL_RESULT
    GoTo _00EC
    End
_00D2:
    @ HGSS: ScrCmd_257 100
    @ HGSS: ScrCmd_267 22, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    GoTo _00EC
    End
_00EC:
    @ HGSS: ScrCmd_064 31, 3, 0, 1, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_841 1
    AddMenuEntryImm msg_0738_UNION_00168, 0
    AddMenuEntryImm msg_0738_UNION_00059, 1
    AddMenuEntryImm msg_0738_UNION_00052, 2
    AddMenuEntryImm msg_0738_UNION_00023, 3
    AddMenuEntryImm msg_0738_UNION_00142, 4
    AddMenuEntryImm msg_0738_UNION_00141, 5
    AddMenuEntryImm msg_0738_UNION_00024, 99
    @ HGSS: ScrCmd_585
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0184
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0336
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0276
    CompareVar VAR_0x8008, 3
    GoToIf 1, _01ED
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0396
    CompareVar VAR_0x8008, 5
    GoToIf 1, _03F6
    CompareVar VAR_0x8008, 7
    GoToIf 1, _07A0
    GoTo _0784
    End
_0184:
    @ HGSS: ScrCmd_267 9, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A1
    MessageVar VAR_RESULT
_01A1:
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _06AE
    @ HGSS: ScrCmd_267 1, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 1
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_160
    ReturnToField
    Call _0BDA
    MessageInstant msg_0738_UNION_00016
    GoTo _00D2
    End
_01ED:
    CountPartyNonEggs VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 0, _0264
    @ HGSS: ScrCmd_267 9, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021B
    MessageVar VAR_RESULT
_021B:
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _06F6
    @ HGSS: ScrCmd_267 1, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 3
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_161
    ReturnToField
    Call _0BDA
    GoTo _00D2
    End
_0264:
    @ HGSS: ScrCmd_267 20, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    GoTo _00D2
    End
_0276:
    @ HGSS: PartyCountMonsAtOrBelowLevel VAR_SPECIAL_RESULT, 30
    CompareVar VAR_RESULT, 2
    GoToIf 0, _0324
    @ HGSS: ScrCmd_267 9, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02A6
    MessageVar VAR_RESULT
_02A6:
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _06DE
    @ HGSS: ScrCmd_267 1, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 2
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_350
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0738_UNION_00202
    @ HGSS: ScrCmd_257 102
    CloseMessage
    @ HGSS: ScrCmd_586 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B8B
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0B8B
    @ HGSS: ScrCmd_230
    Call _0BDA
    GoTo _00D2
    End
_0324:
    @ HGSS: ScrCmd_267 19, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    GoTo _00D2
    End
_0336:
    @ HGSS: ScrCmd_267 9, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0353
    MessageVar VAR_RESULT
_0353:
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _06C6
    @ HGSS: ScrCmd_267 1, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitABPressTime 30
    @ HGSS: ScrCmd_257 4
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_159
    ReturnToField
    Call _0BDA
    GoTo _0478
    End
_0396:
    @ HGSS: ScrCmd_267 9, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03B3
    MessageVar VAR_RESULT
_03B3:
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _0726
    @ HGSS: ScrCmd_267 1, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitABPressTime 30
    @ HGSS: ScrCmd_257 5
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_162
    ReturnToField
    Call _0BDA
    GoTo _0478
    End
_03F6:
    CountPartyEggs VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _074F
    @ HGSS: ScrCmd_630 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0761
    @ HGSS: ScrCmd_267 9, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0435
    MessageVar VAR_RESULT
_0435:
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _076C
    @ HGSS: ScrCmd_267 1, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitABPressTime 30
    @ HGSS: ScrCmd_257 6
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_629
    ReturnToField
    Call _0BDA
    GoTo _0478
    End
_0478:
    ReleaseAll
    End
    CloseMessage
    ReleaseAll
    End
_0488:
    Message msg_0738_UNION_00038
    WaitTime 30, VAR_RESULT
    CloseMessage
    @ HGSS: ScrCmd_263
    ReleaseAll
    End
_0499:
    @ HGSS: ScrCmd_262
    @ HGSS: ScrCmd_267 0, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitABPress
    CloseMessage
    @ HGSS: ScrCmd_263
    ReleaseAll
    End
_04AF:
    @ HGSS: ScrCmd_262
    @ HGSS: ScrCmd_267 10, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05C3
    @ HGSS: ScrCmd_274 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0488
    @ HGSS: ScrCmd_269 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0488
    @ HGSS: ScrCmd_267 13, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_159
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    GoTo _0478
    End
_0528:
    @ HGSS: ScrCmd_262
    @ HGSS: ScrCmd_267 12, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _066C
    CountPartyEggs VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0698
    @ HGSS: PartyLegalCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0682
    @ HGSS: ScrCmd_274 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0488
    @ HGSS: ScrCmd_269 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0488
    @ HGSS: ScrCmd_267 15, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_629
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    GoTo _0478
    End
_05C3:
    @ HGSS: ScrCmd_267 16, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_263
    CloseMessage
    ReleaseAll
    End
_05DB:
    @ HGSS: ScrCmd_262
    @ HGSS: ScrCmd_267 11, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0654
    @ HGSS: ScrCmd_274 VAR_SPECIAL_x8004, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0488
    @ HGSS: ScrCmd_269 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0488
    @ HGSS: ScrCmd_267 14, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_162
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    GoTo _0478
    End
_0654:
    @ HGSS: ScrCmd_267 17, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    CloseMessage
    @ HGSS: ScrCmd_263
    ReleaseAll
    End
_066C:
    @ HGSS: ScrCmd_267 18, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    CloseMessage
    ReleaseAll
    End
_0682:
    @ HGSS: ScrCmd_267 26, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    CloseMessage
    ReleaseAll
    End
_0698:
    @ HGSS: ScrCmd_267 21, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    CloseMessage
    ReleaseAll
    End
_06AE:
    @ HGSS: ScrCmd_267 3, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    GoTo _07BC
    End
_06C6:
    @ HGSS: ScrCmd_267 4, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    GoTo _07BC
    End
_06DE:
    @ HGSS: ScrCmd_267 5, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    GoTo _07BC
    End
_06F6:
    @ HGSS: ScrCmd_267 6, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    GoTo _07BC
    End
    @ HGSS: ScrCmd_267 7, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    GoTo _07BC
    End
_0726:
    @ HGSS: ScrCmd_267 8, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    GoTo _07BC
    End
_073E:
    Message msg_0738_UNION_00036
    GoTo _0BC2
    End
_074F:
    @ HGSS: ScrCmd_267 21, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    GoTo _00D2
    End
_0761:
    Message msg_0738_UNION_00218
    GoTo _00D2
    End
_076C:
    @ HGSS: ScrCmd_267 8, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    GoTo _07BC
    End
_0784:
    @ HGSS: ScrCmd_267 23, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 101
    CloseMessage
    @ HGSS: ScrCmd_266
    ReleaseAll
    End
_07A0:
    @ HGSS: ScrCmd_267 24, VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 101
    CloseMessage
    @ HGSS: ScrCmd_266
    ReleaseAll
    End
_07BC:
    @ HGSS: ScrCmd_257 101
    CloseMessage
    @ HGSS: ScrCmd_266
    ReleaseAll
    End
scr_seq_UNION_004:
    LockAll
_07CC:
    PlaySE SEQ_SE_DP_BUTTON9_sseq
    @ HGSS: ScrCmd_264 1
    @ HGSS: ScrCmd_592 7
    WaitABPressTime 30
    GoTo _07E4
    End
_07E4:
    Message msg_0738_UNION_00009
    @ HGSS: ScrCmd_257 100
    @ HGSS: ScrCmd_273 VAR_SPECIAL_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0863
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0B11
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0974
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08DB
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0A44
    CompareVar VAR_0x8008, 6
    GoToIf 1, _0AA2
    CompareVar VAR_0x8008, 7
    GoToIf 1, _0BA0
    CompareVar VAR_0x8008, 8
    GoToIf 1, _0BB1
    End
_0863:
    Message msg_0738_UNION_00011
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _08CA
    CloseMessage
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _0B80
    @ HGSS: ScrCmd_576 VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 1
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_160
    ReturnToField
    Call _0BDA
    GoTo _07E4
    End
_08CA:
    Message msg_0738_UNION_00017
    GoTo _0BC2
    End
_08DB:
    Message msg_0738_UNION_00026
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0952
    CountPartyNonEggs VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 0, _0963
    CloseMessage
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _0BA0
    Message msg_0738_UNION_00027
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 3
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_161
    ReturnToField
    Call _0BDA
    GoTo _07E4
    End
_0952:
    Message msg_0738_UNION_00020
    GoTo _0BC2
    End
_0963:
    Message msg_0738_UNION_00029
    GoTo _0BC2
    End
_0974:
    Message msg_0738_UNION_00021
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A22
    @ HGSS: PartyCountMonsAtOrBelowLevel VAR_SPECIAL_RESULT, 30
    CompareVar VAR_RESULT, 2
    GoToIf 0, _0A33
    CloseMessage
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _0BA0
    Message msg_0738_UNION_00022
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 2
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_350
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0738_UNION_00202
    @ HGSS: ScrCmd_257 102
    CloseMessage
    @ HGSS: ScrCmd_586 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B8B
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0B8B
    @ HGSS: ScrCmd_230
    Call _0BDA
    GoTo _07E4
    End
_0A22:
    Message msg_0738_UNION_00023
    GoTo _0BC2
    End
_0A33:
    Message msg_0738_UNION_00024
    GoTo _0BC2
    End
_0A44:
    Message msg_0738_UNION_00030
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A22
    CloseMessage
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _0BA0
    Message msg_0738_UNION_00031
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 5
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_162
    ReturnToField
    Call _0BDA
    ReleaseAll
    End
_0AA2:
    Message msg_0738_UNION_00033
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A22
    CloseMessage
    CountPartyEggs VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _073E
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _0BA0
    Message msg_0738_UNION_00034
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 6
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_629
    ReturnToField
    Call _0BDA
    ReleaseAll
    End
_0B11:
    Message msg_0738_UNION_00018
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B6F
    CloseMessage
    @ HGSS: ScrCmd_272 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 1, _0BA0
    Message msg_0738_UNION_00019
    WaitTime 30, VAR_RESULT
    @ HGSS: ScrCmd_257 4
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_159
    ReturnToField
    Call _0BDA
    ReleaseAll
    End
_0B6F:
    Message msg_0738_UNION_00028
    GoTo _0BC2
    End
_0B80:
    Message msg_0738_UNION_00035
    GoTo _0BC2
    End
_0B8B:
    Message msg_0738_UNION_00025
    WaitTime 30, VAR_RESULT
    GoTo _0BC2
    End
_0BA0:
    Message msg_0738_UNION_00008
    WaitTime 30, VAR_RESULT
    GoTo _0BC2
    End
_0BB1:
    Message msg_0738_UNION_00010
    WaitTime 30, VAR_RESULT
    GoTo _0BC2
    End
_0BC2:
    @ HGSS: ScrCmd_257 101
    CloseMessage
    @ HGSS: ScrCmd_266
    ReleaseAll
    End
    CloseMessage
    ReleaseAll
    End
_0BDA:
    @ HGSS: ScrCmd_265
    FadeScreen 6, 1, 1, COLOR_BLACK
    Return
scr_seq_UNION_005:
    NPCMessage msg_0738_UNION_00207
    End
scr_seq_UNION_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoTo _0499
    End
scr_seq_UNION_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoTo _0C1F
    End
_0C1F:
    @ HGSS: ScrCmd_262
    CallIfSet FLAG_HGSS_UNK_069, _0C87
_0C2E:
    CallIfUnset FLAG_HGSS_UNK_069, _0C8C
    SetFlag FLAG_HGSS_UNK_069
    CompleteInitHGSSMenu 21, 11, 0, VAR_RESULT, 1
    AddMenuEntry 11, 0
    AddMenuEntry 169, 1
    AddMenuEntry 24, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0CAF
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0C91
    GoTo _0CA5
    End
_0C87:
    Message msg_0738_UNION_00158
    Return
_0C8C:
    Message msg_0738_UNION_00157
    Return
_0C91:
    @ HGSS: ScrCmd_260 VAR_SPECIAL_RESULT
    MessageVar VAR_RESULT
    GoTo _0C2E
    End
_0CA5:
    @ HGSS: ScrCmd_263
    CloseMessage
    ReleaseAll
    End
_0CAF:
    Message msg_0738_UNION_00159
    CompleteInitHGSSMenu 24, 3, 0, VAR_RESULT, 1
    AddMenuEntry 52, 0
    AddMenuEntry 23, 1
    AddMenuEntry 142, 2
    AddMenuEntry 59, 3
    AddMenuEntry 170, 4
    AddMenuEntry 141, 5
    AddMenuEntry 13, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0D50
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0D5F
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0D6E
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0D7D
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0D8C
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0D9B
    GoTo _0C2E
    End
_0D50:
    Message msg_0738_UNION_00160
    GoTo _0CAF
    End
_0D5F:
    Message msg_0738_UNION_00161
    GoTo _0CAF
    End
_0D6E:
    Message msg_0738_UNION_00162
    GoTo _0CAF
    End
_0D7D:
    Message msg_0738_UNION_00164
    GoTo _0CAF
    End
_0D8C:
    Message msg_0738_UNION_00165
    GoTo _0CAF
    End
_0D9B:
    Message msg_0738_UNION_00163
    GoTo _0CAF
    End
    GoTo _0C2E
    End
    .balign 4, 0
