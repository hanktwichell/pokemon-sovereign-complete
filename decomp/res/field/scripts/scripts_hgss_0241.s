#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0388.h"


    ScriptEntry scr_seq_R35R0101_000
    ScriptEntry scr_seq_R35R0101_001
    ScriptEntryEnd
scr_seq_R35R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_RADIO_CARD, _0028
    Message msg_0388_R35R0101_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0028:
    Message msg_0388_R35R0101_00014
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _004B
    Message msg_0388_R35R0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_004B:
    Message msg_0388_R35R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R35R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_LOAN_SPEAROW, 1
    GoToIf 1, _00BC
    CompareVar VAR_HGSS_LOAN_SPEAROW, 2
    GoToIf 4, _0104
    Message msg_0388_R35R0101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00EE
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _00F9
    Message msg_0388_R35R0101_00003
    @ HGSS: GiveLoanMon 7, 20, 101
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 1
    BufferPlayerName 0
    Message msg_0388_R35R0101_00004
    WaitFanfare
_00BC:
    @ HGSS: KenyaCheckPartyOrMailbox VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0178
    GoToIfSet FLAG_HGSS_UNK_0B5, _00E3
    Message msg_0388_R35R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E3:
    Message msg_0388_R35R0101_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00EE:
    Message msg_0388_R35R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F9:
    Message msg_0388_R35R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0104:
    CompareVar VAR_HGSS_LOAN_SPEAROW, 4
    GoToIf 4, _016D
    Message msg_0388_R35R0101_00007
    SetVar VAR_0x8004, ITEM_HP_UP
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0163
    Common_GiveItemQuantity
    CompareVar VAR_HGSS_LOAN_SPEAROW, 3
    GoToIf 5, _0152
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 5
    GoTo _0158
_0152:
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 4
_0158:
    Message msg_0388_R35R0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0163:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_016D:
    Message msg_0388_R35R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0178:
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 6
    Message msg_0388_R35R0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
