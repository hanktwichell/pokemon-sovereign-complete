#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0568.h"


    ScriptEntry scr_seq_T23PC0101_000
    ScriptEntry scr_seq_T23PC0101_001
    ScriptEntry scr_seq_T23PC0101_002
    ScriptEntry scr_seq_T23PC0101_003
    ScriptEntry scr_seq_T23PC0101_004
    ScriptEntry scr_seq_T23PC0101_005
    ScriptEntry scr_seq_T23PC0101_006
    ScriptEntry scr_seq_T23PC0101_007
    ScriptEntry scr_seq_T23PC0101_008
    ScriptEntryEnd
scr_seq_T23PC0101_000:
    SetVarFromValue VAR_0x8007, 6
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T23PC0101_001:
    NPCMessage msg_0568_T23PC0101_00002
    End
scr_seq_T23PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM, _0192
    Message msg_0568_T23PC0101_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _019D
    GoTo _023E
scr_seq_T23PC0101_003:
    NPCMessage msg_0568_T23PC0101_00000
    End
scr_seq_T23PC0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3F92, _0249
    GoToIfSet FLAG_HGSS_SG_3F91, _0256
    Message msg_0568_T23PC0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025F
    Message msg_0568_T23PC0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23PC0101_005:
    NPCMessage msg_0568_T23PC0101_00002
    End
scr_seq_T23PC0101_006:
    PlaySE SE_CONFIRM_sseq_3
    BufferPlayerName 0
    LockAll
    FacePlayer
    Message msg_0568_T23PC0101_00022
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _02E0
    Message msg_0568_T23PC0101_00024
    WaitFanfare
    GiveEgg SPECIES_RIOLU, 10
    Message msg_0568_T23PC0101_00025
    WaitButton
    CloseMessage
    FadeScreen 6, 3, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 8
    FadeScreen 6, 3, 1, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_SG_3FF9
    ReleaseAll
    End
scr_seq_T23PC0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F76, _02EB
    Message msg_0568_T23PC0101_00027
    ShowYesNoMenu VAR_RESULT
    Message msg_0568_T23PC0101_00028
    SetVar VAR_0x8004, ITEM_TM34
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0568_T23PC0101_00029
    SetFlag FLAG_HGSS_SG_3F76
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23PC0101_008:
    PlayCry SPECIES_VOLTORB, 6
    NPCMessage msg_0568_T23PC0101_00030
    End
_0192:
    Message msg_0568_T23PC0101_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019D:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _023E
    InitNPCTrade NPC_TRADE_HGSS_ROBOTNIK_BELDUM
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _02F6
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 1, MOVE_ZEN_HEADBUTT
    SetFlag FLAG_HGSS_TRADE_STEVEN_FORRETRESS_BELDUM
    Message msg_0568_T23PC0101_00023
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0568_T23PC0101_00031
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_023E:
    Message msg_0568_T23PC0101_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0249:
    Message msg_0568_T23PC0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0256:
    Message msg_0568_T23PC0101_00021
    GoTo _0303
_025F:
    Message msg_0568_T23PC0101_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _037B
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0568_T23PC0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _037B
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0568_T23PC0101_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _037B
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0568_T23PC0101_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _037B
    CloseMessage
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    SetFlag FLAG_HGSS_SG_3F91
    Message msg_0568_T23PC0101_00010
    GoTo _0303
_02E0:
    Message msg_0568_T23PC0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02EB:
    Message msg_0568_T23PC0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02F6:
    FinishNPCTrade
    Message msg_0568_T23PC0101_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0303:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 12, 0
    AddMenuEntry 13, 1
    AddMenuEntry 14, 2
    AddMenuEntry 15, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    SetVarFromValue VAR_0x8004, 252
    GoToIf 1, _0392
    CompareVar VAR_0x8008, 1
    SetVarFromValue VAR_0x8004, 255
    GoToIf 1, _0392
    CompareVar VAR_0x8008, 2
    SetVarFromValue VAR_0x8004, 258
    GoToIf 1, _0392
    Message msg_0568_T23PC0101_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_037B:
    PlaySE SEQ_SE_DP_BOX03_sseq
    WaitSE SEQ_SE_DP_BOX03_sseq
    Message msg_0568_T23PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0392:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _02E0
    Message msg_0568_T23PC0101_00018
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    GivePokemon VAR_0x8004, 15, 0, VAR_RESULT
    SetFlag FLAG_HGSS_SG_3F92
    Message msg_0568_T23PC0101_00019
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0568_T23PC0101_00020
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _041F
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0452
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0568_T23PC0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_041F:
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0568_T23PC0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0452:
    Message msg_0568_T23PC0101_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
