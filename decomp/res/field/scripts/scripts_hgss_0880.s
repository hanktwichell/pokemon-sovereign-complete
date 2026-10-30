#include "macros/scrcmd.inc"
#include "constants/npc_trades.h"
#include "res/text/bank/hgss_msg_0576.h"


    ScriptEntry scr_seq_T24R0201_000
    ScriptEntryEnd
scr_seq_T24R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RETURNED_OR_INHERITED_LOAN_SHUCKLE, _0037
    GoToIfUnset FLAG_HGSS_GOT_LOAN_SHUCKLE, _0042
    GoToIfSet FLAG_HGSS_DAILY_GOT_LOAN_SHUCKLE_TODAY, _00A2
    GoTo _00AD
    End
_0037:
    Message msg_0576_T24R0201_00011
_003A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0042:
    Message msg_0576_T24R0201_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0063
    Message msg_0576_T24R0201_00004
    GoTo _003A
_0063:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 5, _007D
    Message msg_0576_T24R0201_00003
    GoTo _003A
_007D:
    CompleteGiveLoanMon NPC_TRADE_HGSS_SHUCKIE_SHUCKLE, 20, MAP_HEADER_HGSS_CIANWOOD
    Message msg_0576_T24R0201_00001
    BufferPlayerName 0
    Message msg_0576_T24R0201_00002
    PlayFanfare SEQ_ME_PT_SPECIAL_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_GOT_LOAN_SHUCKLE
    SetFlag FLAG_HGSS_DAILY_GOT_LOAN_SHUCKLE_TODAY
    GoTo _003A
    End
_00A2:
    Message msg_0576_T24R0201_00006
    GoTo _003A
    End
_00AD:
    Message msg_0576_T24R0201_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01AA
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 255
    GoToIf 5, _00F2
    Call _019A
    GoTo _01AA
_00F2:
    CompleteCheckReturnLoanMon NPC_TRADE_HGSS_SHUCKIE_SHUCKLE, VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_RESULT, 0
    CallIf 5, _019A
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0120
    Message msg_0576_T24R0201_00008
    GoTo _0192
_0120:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0136
    Message msg_0576_T24R0201_00012
    GoTo _0192
_0136:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _014C
    Message msg_0576_T24R0201_00013
    GoTo _0192
_014C:
    CompareVar VAR_RESULT, 4
    GoToIf 5, _0162
    Message msg_0576_T24R0201_00014
    GoTo _0192
_0162:
    GetPartyMonFriendship VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 149
    GoToIf 3, _0181
    Call _019A
    GoTo _01B5
_0181:
    CompleteReturnLoanMon VAR_MAP_LOCAL_0x00
    Call _019A
    Message msg_0576_T24R0201_00007
    SetFlag FLAG_HGSS_RETURNED_OR_INHERITED_LOAN_SHUCKLE
_0192:
    GoTo _003A
    End
_019A:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
_01AA:
    Message msg_0576_T24R0201_00010
    GoTo _003A
    End
_01B5:
    Message msg_0576_T24R0201_00009
    SetFlag FLAG_HGSS_RETURNED_OR_INHERITED_LOAN_SHUCKLE
    GoTo _003A
    End
    .balign 4, 0
