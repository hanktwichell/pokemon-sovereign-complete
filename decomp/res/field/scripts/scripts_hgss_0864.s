#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
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
    GoToIfSet FLAG_HGSS_TRADE_VIOLET_CITY_BELLSPROUT_ONIX, _0054
    Message msg_0562_T22R0601_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _005F
    GoTo _0100
scr_seq_T22R0601_002:
    NPCMessage msg_0562_T22R0601_00000
    End
_0054:
    Message msg_0562_T22R0601_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_005F:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0100
    InitNPCTrade NPC_TRADE_HGSS_RAZOR_GLIGAR
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _010B
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_AERIAL_ACE
    SetFlag FLAG_HGSS_TRADE_VIOLET_CITY_BELLSPROUT_ONIX
    Message msg_0562_T22R0601_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0562_T22R0601_00006
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_0100:
    Message msg_0562_T22R0601_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_010B:
    FinishNPCTrade
    Message msg_0562_T22R0601_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
