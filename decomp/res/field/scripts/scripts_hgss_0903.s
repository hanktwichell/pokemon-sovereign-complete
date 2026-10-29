#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0596.h"


    ScriptEntry scr_seq_T25R1005_000
    ScriptEntry scr_seq_T25R1005_001
    ScriptEntry scr_seq_T25R1005_002
    ScriptEntry scr_seq_T25R1005_003
    ScriptEntry scr_seq_T25R1005_004
    ScriptEntry scr_seq_T25R1005_005
    ScriptEntry scr_seq_T25R1005_006
    ScriptEntryEnd
scr_seq_T25R1005_005:
    SetFlag FLAG_HGSS_HIDE_GOLDENROD_DEPT_STORE_5F_RETURN_FRUSTRATION_LADY
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0046
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0044
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_DEPT_STORE_5F_RETURN_FRUSTRATION_LADY
_0044:
    End
_0046:
    ClearFlag FLAG_HGSS_HIDE_GOLDENROD_DEPT_STORE_5F_RETURN_FRUSTRATION_LADY
    End
scr_seq_T25R1005_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 7
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T25R1005_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0086
    Message msg_0596_T25R1005_00018
    GoTo _0089
_0086:
    Message msg_0596_T25R1005_00017
_0089:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1005_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _00AF
    Message msg_0596_T25R1005_00016
    GoTo _00B2
_00AF:
    Message msg_0596_T25R1005_00015
_00B2:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1005_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SYS_ROCKET_COSTUME, _017D
    GoToIfSet FLAG_HGSS_TRADE_GOLDENROD_CITY_DROWZEE_MACHOP, _0172
    Message msg_0596_T25R1005_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00F6
    GoTo _0167
_00F6:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0167
    @ HGSS: LoadNPCTrade 1
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _015A
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_GOLDENROD_CITY_DROWZEE_MACHOP
    Message msg_0596_T25R1005_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_015A:
    @ HGSS: NPCTradeEnd
    Message msg_0596_T25R1005_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0167:
    Message msg_0596_T25R1005_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0172:
    Message msg_0596_T25R1005_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_017D:
    Message msg_0596_T25R1005_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
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
    GoToIfSet FLAG_HGSS_UNK_08E, _0219
    GetFirstNonEggInParty VAR_0x8000
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0596_T25R1005_00000
    @ HGSS: MonGetFriendship VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000
    CompareVar VAR_RESULT, 149
    GoToIf 4, _01E3
    CompareVar VAR_RESULT, 50
    GoToIf 3, _01FE
    Message msg_0596_T25R1005_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E3:
    Message msg_0596_T25R1005_00001
    SetVarFromValue VAR_0x8004, 354
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    GoTo _0219
_01FE:
    Message msg_0596_T25R1005_00004
    SetVarFromValue VAR_0x8004, 348
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    GoTo _0219
_0219:
    Message msg_0596_T25R1005_00006
    SetFlag FLAG_HGSS_UNK_08E
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
