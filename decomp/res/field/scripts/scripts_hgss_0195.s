#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0344.h"


    ScriptEntry scr_seq_R10R0201_000
    ScriptEntry scr_seq_R10R0201_001
    ScriptEntry scr_seq_R10R0201_002
    ScriptEntry scr_seq_R10R0201_003
    ScriptEntry scr_seq_R10R0201_004
    ScriptEntry scr_seq_R10R0201_005
    ScriptEntry scr_seq_R10R0201_006
    ScriptEntry scr_seq_R10R0201_007
    ScriptEntry scr_seq_R10R0201_008
    ScriptEntry scr_seq_R10R0201_009
    ScriptEntry scr_seq_R10R0201_010
    ScriptEntryEnd
scr_seq_R10R0201_000:
    NPCMessage msg_0344_R10R0201_00003
    End
scr_seq_R10R0201_001:
    NPCMessage msg_0344_R10R0201_00004
    End
scr_seq_R10R0201_002:
    NPCMessage msg_0344_R10R0201_00005
    End
scr_seq_R10R0201_003:
    NPCMessage msg_0344_R10R0201_00006
    End
scr_seq_R10R0201_004:
    NPCMessage msg_0344_R10R0201_00007
    End
scr_seq_R10R0201_005:
    NPCMessage msg_0344_R10R0201_00008
    End
scr_seq_R10R0201_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_POWER_PLANT_DUGTRIO_MAGNETON, _01D2
    Message msg_0344_R10R0201_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01DD
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _01DD
    InitNPCTrade NPC_TRADE_HGSS_PERRY_PORYGON2
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _01E8
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_AURA_SPHERE
    SetFlag FLAG_HGSS_TRADE_POWER_PLANT_DUGTRIO_MAGNETON
    Message msg_0344_R10R0201_00010
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0344_R10R0201_00018
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0201_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0344_R10R0201_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0201_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0344_R10R0201_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0201_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FA4, _01F5
    Message msg_0344_R10R0201_00016
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _0200
    WaitMovement
    SetFlag FLAG_HGSS_SG_3FA4
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_ZAP_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0201_010:
    BufferPlayerName 0
    End
_01D2:
    Message msg_0344_R10R0201_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DD:
    Message msg_0344_R10R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E8:
    FinishNPCTrade
    Message msg_0344_R10R0201_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F5:
    Message msg_0344_R10R0201_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0200:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
