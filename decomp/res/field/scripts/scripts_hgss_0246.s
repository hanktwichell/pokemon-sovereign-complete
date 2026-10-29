#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "generated/ribbons.h"
#include "res/text/bank/hgss_msg_0393.h"


    ScriptEntry scr_seq_R37_000
    ScriptEntry scr_seq_R37_001
    ScriptEntry scr_seq_R37_002
    ScriptEntry scr_seq_R37_003
    ScriptEntry scr_seq_R37_004
    ScriptEntryEnd
scr_seq_R37_000:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0110
    ClearFlag FLAG_HGSS_UNK_1C3
    GoTo _0116
scr_seq_R37_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    GetPartyMonRibbon VAR_RESULT, VAR_0x8002, RIBBON_SMILE
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0118
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _012C
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _0140
    GoToIfSet FLAG_HGSS_GOT_MAGNET_FROM_SUNNY, _0163
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0177
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 27
    GoTo _01C6
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
scr_seq_R37_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_GIRAFARIG, 0
    WaitCry
    CompleteStartWildBattle SPECIES_GIRAFARIG, 26, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CE
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 9
    SetFlag FLAG_HGSS_SG_3FEC
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0110:
    SetFlag FLAG_HGSS_UNK_1C3
    End
_0116:
    End
_0118:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 53
    WaitButton
    CloseMessage
    ReleaseAll
    End
_012C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 55
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0140:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01D4
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 27
    GoTo _01C6
_0163:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 26
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0177:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 24
    SetVar VAR_0x8004, ITEM_MAGNET
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01FD
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_MAGNET_FROM_SUNNY
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 25
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C6:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01CE:
    BlackOutFromBattle
    ReleaseAll
    End
_01D4:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 52
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 54
    SetPartyMonRibbon VAR_0x8002, RIBBON_SMILE
    PlayFanfare 20
    @ HGSS data: .byte 217, 7, 53, 0, 97, 0, 2, 0
_01FD:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
