#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "generated/ribbons.h"
#include "res/text/bank/hgss_msg_0634.h"


    ScriptEntry scr_seq_T30R0301_000
    ScriptEntry scr_seq_T30R0301_001
    ScriptEntryEnd
scr_seq_T30R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_BLACKTHORN_CITY_DRAGONAIR_DODRIO, _00CA
    Message msg_0634_T30R0301_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _003B
    GoTo _00BF
_003B:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _00BF
    InitNPCTrade NPC_TRADE_HGSS_LOLA_SMOOCHUM
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetPartyMonGender_Unused VAR_0x8004, VAR_0x8006
    CompareVar VAR_0x8006, 0
    GoToIf 1, _00B2
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _00B2
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    SetFlag FLAG_HGSS_TRADE_BLACKTHORN_CITY_DRAGONAIR_DODRIO
    Message msg_0634_T30R0301_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B2:
    FinishNPCTrade
    Message msg_0634_T30R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00BF:
    Message msg_0634_T30R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00CA:
    Message msg_0634_T30R0301_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8000
    GetPartyMonRibbon VAR_RESULT, VAR_0x8000, RIBBON_HOENN_EFFORT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0199
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0634_T30R0301_00005
    @ HGSS: GetEVTotal VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 510
    GoToIf 0, _0136
    Message msg_0634_T30R0301_00006
    SetPartyMonRibbon VAR_0x8000, RIBBON_HOENN_EFFORT
    PlayFanfare SEQ_ME_ITEM_sseq
    BufferPlayerName 1
    Message msg_0634_T30R0301_00007
    WaitFanfare
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0634_T30R0301_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0136:
    CompareVar VAR_RESULT, 506
    GoToIf 5, _014C
    Message msg_0634_T30R0301_00010
    GoTo _0191
_014C:
    CompareVar VAR_RESULT, 507
    GoToIf 5, _0162
    Message msg_0634_T30R0301_00011
    GoTo _0191
_0162:
    CompareVar VAR_RESULT, 508
    GoToIf 5, _0178
    Message msg_0634_T30R0301_00012
    GoTo _0191
_0178:
    CompareVar VAR_RESULT, 509
    GoToIf 5, _018E
    Message msg_0634_T30R0301_00013
    GoTo _0191
_018E:
    Message msg_0634_T30R0301_00009
_0191:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0199:
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0634_T30R0301_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
