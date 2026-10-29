#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0590.h"


    ScriptEntry scr_seq_T25R0801_000
    ScriptEntry scr_seq_T25R0801_001
    ScriptEntry scr_seq_T25R0801_002
    ScriptEntryEnd
scr_seq_T25R0801_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3F8F, _0094
    Message msg_0590_T25R0801_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00B2
    GoTo _0149
scr_seq_T25R0801_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0154
    Message msg_0590_T25R0801_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R0801_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0197
    Message msg_0590_T25R0801_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0094:
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01DA
    Message msg_0590_T25R0801_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B2:
    WaitFadeScreen
    CloseMessage
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0149
    InitNPCTrade NPC_TRADE_HGSS_MIMI_CHANSEY
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _021D
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_AROMATHERAPY
    SetFlag FLAG_HGSS_SG_3F8F
    Message msg_0590_T25R0801_00001
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0590_T25R0801_00019
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_0149:
    Message msg_0590_T25R0801_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0154:
    Message msg_0590_T25R0801_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _022A
    Message msg_0590_T25R0801_00010
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PKMN_TRAINER_MARLEY_MIRA, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0235
    Message msg_0590_T25R0801_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0197:
    Message msg_0590_T25R0801_00011
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _023B
    Message msg_0590_T25R0801_00013
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PKMN_TRAINER_BUCK_MARLEY, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0235
    Message msg_0590_T25R0801_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DA:
    Message msg_0590_T25R0801_00015
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0246
    Message msg_0590_T25R0801_00017
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PKMN_TRAINER_CHERYL_CHERYL, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0235
    Message msg_0590_T25R0801_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021D:
    FinishNPCTrade
    Message msg_0590_T25R0801_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_022A:
    Message msg_0590_T25R0801_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0235:
    BlackOutFromBattle
    ReleaseAll
    End
_023B:
    Message msg_0590_T25R0801_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0246:
    Message msg_0590_T25R0801_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
