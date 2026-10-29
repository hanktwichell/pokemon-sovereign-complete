#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
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
    GoToIfSet FLAG_HGSS_TRADE_PEWTER_CITY_HAUNTER_XATU, _012F
    Message msg_0463_T03PC0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _013A
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _013A
    InitNPCTrade NPC_TRADE_HGSS_BEXXI_ESPEON
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0145
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_ZAP_CANNON
    SetFlag FLAG_HGSS_TRADE_PEWTER_CITY_HAUNTER_XATU
    Message msg_0463_T03PC0101_00004
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0463_T03PC0101_00008
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
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
_012F:
    Message msg_0463_T03PC0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013A:
    Message msg_0463_T03PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0145:
    FinishNPCTrade
    Message msg_0463_T03PC0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
