#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0562.h"


    ScriptEntry scr_seq_T22R0601_000
    ScriptEntry scr_seq_T22R0601_001
    ScriptEntry scr_seq_T22R0601_002
    ScriptEntryEnd
scr_seq_T22R0601_000:
    End
scr_seq_T22R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_VIOLET_CITY_BELLSPROUT_ONIX, _00BD
    Message msg_0562_T22R0601_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0041
    GoTo _00B2
_0041:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _00B2
    @ HGSS: LoadNPCTrade 0
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _00A5
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_VIOLET_CITY_BELLSPROUT_ONIX
    Message msg_0562_T22R0601_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A5:
    @ HGSS: NPCTradeEnd
    Message msg_0562_T22R0601_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B2:
    Message msg_0562_T22R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00BD:
    Message msg_0562_T22R0601_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22R0601_002:
    NPCMessage msg_0562_T22R0601_00000
    End
    .balign 4, 0
