#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0596.h"


    ScriptEntry scr_seq_T25R1005_000
    ScriptEntry scr_seq_T25R1005_001
    ScriptEntry scr_seq_T25R1005_002
    ScriptEntry scr_seq_T25R1005_003
    ScriptEntry scr_seq_T25R1005_004
    ScriptEntry scr_seq_T25R1005_005
    ScriptEntry scr_seq_T25R1005_006
    ScriptEntry scr_seq_T25R1005_007
    ScriptEntry scr_seq_T25R1005_008
    ScriptEntryEnd
scr_seq_T25R1005_005:
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_DEPT_STORE_5F_RETURN_FRUSTRATION_LADY
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0172
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0178
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_DEPT_STORE_5F_RETURN_FRUSTRATION_LADY
    End
scr_seq_T25R1005_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 7
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T25R1005_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _017A
    Message msg_0596_T25R1005_00018
    GoTo _0185
scr_seq_T25R1005_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _018D
    Message msg_0596_T25R1005_00016
    GoTo _0198
scr_seq_T25R1005_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SYS_ROCKET_COSTUME, _01A0
    GoToIfSet FLAG_HGSS_TRADE_GOLDENROD_CITY_DROWZEE_MACHOP, _01AB
    Message msg_0596_T25R1005_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01B6
    GoTo _0257
scr_seq_T25R1005_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0596_T25R1005_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1005_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_08E, _0262
    GetFirstNonEggInParty VAR_0x8000
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0596_T25R1005_00000
    GetPartyMonFriendship VAR_RESULT, VAR_0x8000
    CompareVar VAR_RESULT, 149
    GoToIf 4, _0271
    CompareVar VAR_RESULT, 50
    GoToIf 3, _028C
    Message msg_0596_T25R1005_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1005_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 21
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T25R1005_008:
    PlayCry SPECIES_HAPPINY, 0
    NPCMessage msg_0596_T25R1005_00021
    End
_0172:
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_DEPT_STORE_5F_RETURN_FRUSTRATION_LADY
    End
_0178:
    End
_017A:
    Message msg_0596_T25R1005_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0185:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_018D:
    Message msg_0596_T25R1005_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0198:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A0:
    Message msg_0596_T25R1005_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AB:
    Message msg_0596_T25R1005_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01B6:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPartyMenuForTrade
    GetSelectedPartySlot VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0257
    InitNPCTrade NPC_TRADE_HGSS_SQUILLACI_TORKOAL
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    GetNPCTradeRequestedSpecies VAR_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _02A7
    StartNPCTrade VAR_0x8004
    FinishNPCTrade
    ResetPartyMonMoveSlot_Unused VAR_0x8004, 0, MOVE_EARTH_POWER
    SetFlag FLAG_HGSS_TRADE_GOLDENROD_CITY_DROWZEE_MACHOP
    Message msg_0596_T25R1005_00010
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0596_T25R1005_00020
    SetVar VAR_0x8004, ITEM_COVENANT_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_0257:
    Message msg_0596_T25R1005_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0262:
    Message msg_0596_T25R1005_00006
    SetFlag FLAG_HGSS_UNK_08E
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0271:
    Message msg_0596_T25R1005_00001
    SetVarFromValue VAR_0x8004, ITEM_TM27
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    GoTo _0262
_028C:
    Message msg_0596_T25R1005_00004
    SetVarFromValue VAR_0x8004, ITEM_TM21
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    GoTo _0262
_02A7:
    FinishNPCTrade
    Message msg_0596_T25R1005_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
