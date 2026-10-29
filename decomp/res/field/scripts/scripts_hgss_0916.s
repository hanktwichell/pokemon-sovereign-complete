#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0608.h"


    ScriptEntry scr_seq_T26R0301_000
    ScriptEntryEnd
scr_seq_T26R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_OLIVINE_CITY_KRABBY_VOLTORB, _00B3
    Message msg_0608_T26R0301_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0037
    GoTo _00A8
_0037:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _00A8
    @ HGSS: LoadNPCTrade 2
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _009B
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_OLIVINE_CITY_KRABBY_VOLTORB
    Message msg_0608_T26R0301_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_009B:
    @ HGSS: NPCTradeEnd
    Message msg_0608_T26R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A8:
    Message msg_0608_T26R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B3:
    Message msg_0608_T26R0301_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
