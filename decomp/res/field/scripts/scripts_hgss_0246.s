#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0393.h"


    ScriptEntry scr_seq_R37_000
    ScriptEntry scr_seq_R37_001
    ScriptEntry scr_seq_R37_002
    ScriptEntry scr_seq_R37_003
    ScriptEntryEnd
scr_seq_R37_000:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _002D
    ClearFlag FLAG_HGSS_UNK_1C3
    GoTo _0031
_002D:
    SetFlag FLAG_HGSS_UNK_1C3
_0031:
    End
scr_seq_R37_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    @ HGSS: MonHasRibbon VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, RIBBON_SMILE
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0159
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _016D
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0107
    GoToIfSet FLAG_HGSS_GOT_MAGNET_FROM_SUNNY, _00E9
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _009A
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 27
    GoTo _00E1
_009A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 24
    SetVar VAR_0x8004, ITEM_MAGNET
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _00FD
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_MAGNET_FROM_SUNNY
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 25
_00E1:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E9:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 26
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00FD:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0107:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _012A
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 27
    GoTo _00E1
_012A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 52
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 54
    @ HGSS: GiveRibbon VAR_SPECIAL_x8002, RIBBON_SMILE
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0159:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 53
    WaitButton
    CloseMessage
    ReleaseAll
    End
_016D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 55
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R37_002:
    DrawSignpostInstantMessage msg_0393_R37_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R37_003:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0393_R37_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
