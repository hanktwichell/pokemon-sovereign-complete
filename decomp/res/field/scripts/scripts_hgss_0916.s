#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0608.h"


    ScriptEntry scr_seq_T26R0301_000
    ScriptEntry scr_seq_T26R0301_001
    ScriptEntryEnd
scr_seq_T26R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_OLIVINE_CITY_KRABBY_VOLTORB, _0070
    Message msg_0608_T26R0301_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _007B
    GoTo _011C
scr_seq_T26R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F83, _0127
    Message msg_0608_T26R0301_00005
    SetVar VAR_0x8004, ITEM_METAL_COAT
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F83
    Message msg_0608_T26R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0070:
    Message msg_0608_T26R0301_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_007B:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _011C
    InitNPCTrade NPC_TRADE_HGSS_MOXXI_SKARMORY
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0132
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_BRAVE_BIRD
    SetFlag FLAG_HGSS_TRADE_OLIVINE_CITY_KRABBY_VOLTORB
    Message msg_0608_T26R0301_00001
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0608_T26R0301_00007
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_011C:
    Message msg_0608_T26R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0127:
    Message msg_0608_T26R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0132:
    FinishNPCTrade
    Message msg_0608_T26R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
