#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0617.h"


    ScriptEntry scr_seq_T27R0401_000
    ScriptEntry scr_seq_T27R0401_001
    ScriptEntry scr_seq_T27R0401_002
    ScriptEntryEnd
scr_seq_T27R0401_000:
    NPCMessage msg_0617_T27R0401_00005
    End
scr_seq_T27R0401_001:
    NPCMessage msg_0617_T27R0401_00006
    End
scr_seq_T27R0401_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_BLACKTHORN_CITY_DRAGONAIR_DODRIO, _0065
    Message msg_0617_T27R0401_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0070
    GoTo _0111
_0065:
    Message msg_0617_T27R0401_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0070:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0111
    InitNPCTrade NPC_TRADE_HGSS_LOLA_SMOOCHUM
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _011C
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_PSYCHIC
    SetFlag FLAG_HGSS_TRADE_BLACKTHORN_CITY_DRAGONAIR_DODRIO
    Message msg_0617_T27R0401_00001
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0617_T27R0401_00009
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_0111:
    Message msg_0617_T27R0401_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_011C:
    FinishNPCTrade
    MessageGendered msg_0617_T27R0401_00007, msg_0617_T27R0401_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
