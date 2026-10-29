#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0463.h"


    ScriptEntry scr_seq_T03PC0101_000
    ScriptEntry scr_seq_T03PC0101_001
    ScriptEntry scr_seq_T03PC0101_002
    ScriptEntry scr_seq_T03PC0101_003
    ScriptEntry scr_seq_T03PC0101_004
    ScriptEntryEnd
scr_seq_T03PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T03PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_PEWTER_CITY_HAUNTER_XATU, _00C9
    Message msg_0463_T03PC0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00BE
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _00BE
    @ HGSS: LoadNPCTrade 9
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _00B1
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_PEWTER_CITY_HAUNTER_XATU
    Message msg_0463_T03PC0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B1:
    @ HGSS: NPCTradeEnd
    Message msg_0463_T03PC0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00BE:
    Message msg_0463_T03PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00C9:
    Message msg_0463_T03PC0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03PC0101_002:
    NPCMessage msg_0463_T03PC0101_00000
    End
scr_seq_T03PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_JIGGLYPUFF, 0
    Message msg_0463_T03PC0101_00001
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03PC0101_004:
    NPCMessage msg_0463_T03PC0101_00002
    End
    .balign 4, 0
