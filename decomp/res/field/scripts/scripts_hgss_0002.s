#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0748.h"


    ScriptEntry scr_seq_0002_000
    ScriptEntry scr_seq_0002_001
    ScriptEntry scr_seq_0002_002
    ScriptEntryEnd
scr_seq_0002_000:
    SetVarFromValue VAR_0x8000, 0
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 0
    SetVarFromValue VAR_0x8007, 0
    GoTo _005C
    End
scr_seq_0002_001:
    SetVarFromValue VAR_0x8000, 1
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 12
    SetVarFromValue VAR_0x8007, 1
    GoTo _005C
    End
scr_seq_0002_002:
    SetVarFromValue VAR_0x8000, 2
    SetVarFromValue VAR_MAP_LOCAL_0x0F, 24
    SetVarFromValue VAR_0x8007, 2
    GoTo _005C
    End
_005C:
    ShowBattlePoints 21, 1
    SetVarFromValue VAR_0x8004, 4
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0352
_008A:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    HideCoins
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8001
    ReturnToField
    ShowBattlePoints 21, 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8001, 255
    GoToIf 1, _0352
    GetPartyMonSpecies VAR_0x8001, VAR_0x8002
    CompareVar VAR_0x8002, 0
    GoToIf 1, _0391
    CompleteTutorMovePages VAR_0x8001, VAR_0x8000, VAR_0x8002
    CompareVar VAR_0x8002, 0
    GoToIf 1, _00F0
    GoTo _0125
_00F0:
    CompareVar VAR_0x8007, 0
    GoToIf 5, _0106
    Message msg_0748_00005
    GoTo _011F
_0106:
    CompareVar VAR_0x8007, 1
    GoToIf 5, _011C
    Message msg_0748_00017
    GoTo _011F
_011C:
    Message msg_0748_00029
_011F:
    GoTo _008A
_0125:
    SetVarFromValue VAR_0x8004, 0
_013D:
    CompleteTutorChooseMove VAR_0x8001, VAR_0x8000, VAR_0x8004, VAR_RESULT
    SetVarFromVar VAR_0x8003, VAR_RESULT
    CompareVar VAR_0x8003, 65533
    GoToIf 5, _018F
    AddVar VAR_0x8004, 1
    CompareVar VAR_0x8004, VAR_0x8002
    GoToIf 0, _013D
    SetVarFromValue VAR_0x8004, 0
    GoTo _013D
    GoTo _01D0
_018F:
    CompareVar VAR_0x8003, 65534
    GoToIf 5, _01D0
    BufferPartyMonNickname 0, VAR_0x8001
    SetVarFromValue VAR_0x8004, 7
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0352
    SetVarFromValue VAR_0x8004, 0
    CloseMessage
    GoTo _013D
_01D0:
    CompleteTutorMovePrice VAR_0x8003, VAR_0x8005
    CheckBattlePoints VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EF
    GoTo _0224
_01EF:
    CompareVar VAR_0x8007, 0
    GoToIf 5, _0205
    Message msg_0748_00006
    GoTo _021E
_0205:
    CompareVar VAR_0x8007, 1
    GoToIf 5, _021B
    Message msg_0748_00018
    GoTo _021E
_021B:
    Message msg_0748_00030
_021E:
    GoTo _0352
_0224:
    BufferPartyMonNickname 0, VAR_0x8001
    BufferMoveName 1, VAR_0x8003
    GetPartyMonMoveCount VAR_0x8006, VAR_0x8001
    CompareVar VAR_0x8006, 4
    GoToIf 0, _0328
_0241:
    SetVarFromValue VAR_0x8004, 8
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A4
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    HideCoins
    OpenSummaryScreenTeachMove VAR_0x8001, VAR_0x8003
    GetSummarySelectedMoveSlot VAR_0x8006
    ReturnToField
    ShowBattlePoints 21, 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8006, 4
    GoToIf 1, _03A4
    BufferPartyMoveName 2, VAR_0x8001, VAR_0x8006
    SetVarFromValue VAR_0x8004, 9
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03A4
    CompareVar VAR_0x8007, 0
    GoToIf 5, _02EA
    Message msg_0748_00012
    GoTo _0303
_02EA:
    CompareVar VAR_0x8007, 1
    GoToIf 5, _0300
    Message msg_0748_00024
    GoTo _0303
_0300:
    Message msg_0748_00036
_0303:
    PlaySE SEQ_SE_DP_KON_sseq
    WaitSE SEQ_SE_DP_KON_sseq
    WaitTime 30, VAR_RESULT
    BufferPartyMoveName 1, VAR_0x8001, VAR_0x8006
    SetVarFromValue VAR_0x8004, 13
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
_0328:
    BufferMoveName 1, VAR_0x8003
    SetVarFromValue VAR_0x8004, 14
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
    PlayFanfare SEQ_ME_LVUP_sseq
    WaitFanfare
    RemoveBattlePoints VAR_0x8005
    UpdateBPDisplay
    ResetMoveSlot VAR_0x8001, VAR_0x8003, VAR_0x8006
_0352:
    CompareVar VAR_0x8007, 0
    GoToIf 5, _0368
    Message msg_0748_00015
    GoTo _0381
_0368:
    CompareVar VAR_0x8007, 1
    GoToIf 5, _037E
    Message msg_0748_00027
    GoTo _0381
_037E:
    Message msg_0748_00039
_0381:
    WaitButton
    CloseMessage
    HideCoins
    ReturnCommonScript
    End
_0391:
    Message msg_0748_00040
    WaitButton
    CloseMessage
    HideCoins
    ReturnCommonScript
    End
_03A4:
    SetVarFromValue VAR_0x8004, 10
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0241
    SetVarFromValue VAR_0x8004, 11
    AddVar VAR_0x8004, VAR_MAP_LOCAL_0x0F
    MessageVar VAR_0x8004
    GoTo _0352
    End
    .balign 4, 0
