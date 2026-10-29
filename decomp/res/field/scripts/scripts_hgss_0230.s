#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0378.h"


    ScriptEntry scr_seq_R31_000
    ScriptEntry scr_seq_R31_001
    ScriptEntry scr_seq_R31_002
    ScriptEntry scr_seq_R31_003
    ScriptEntry scr_seq_R31_004
    ScriptEntry scr_seq_R31_005
    ScriptEntryEnd
scr_seq_R31_000:
    End
scr_seq_R31_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_LOAN_SPEAROW, 1
    GoToIf 5, _003D
    GoTo _0098
_0037:
    GoTo _008D
_003D:
    CompareVar VAR_HGSS_LOAN_SPEAROW, 2
    GoToIf 5, _0056
    GoTo _01AD
_0050:
    GoTo _008D
_0056:
    CompareVar VAR_HGSS_LOAN_SPEAROW, 4
    GoToIf 5, _006F
    GoTo _01AD
_0069:
    GoTo _008D
_006F:
    CompareVar VAR_HGSS_LOAN_SPEAROW, 6
    GoToIf 5, _008D
    @ HGSS: KenyaCheckPartyOrMailbox VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02AE
_008D:
    Message msg_0378_R31_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0098:
    Message msg_0378_R31_00001
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: PartySelectUI
    @ HGSS: GetPartySelection VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 255
    GoToIf 1, _0206
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _021F
    @ HGSS: KenyaCheck VAR_SPECIAL_RESULT, VAR_TEMP_x4000, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0238
    @ HGSS: KenyaCheck VAR_SPECIAL_RESULT, VAR_TEMP_x4000, 1
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0251
    @ HGSS: CheckReturnLoanMon 7, VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _026A
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0295
    @ HGSS: ReturnLoanMon VAR_TEMP_x4000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0149
    ApplyMovement LOCALID_PLAYER, _02BC
    GoTo _0187
_0149:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0164
    ApplyMovement LOCALID_PLAYER, _02C4
    GoTo _0187
_0164:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _017F
    ApplyMovement LOCALID_PLAYER, _02CC
    GoTo _0187
_017F:
    ApplyMovement LOCALID_PLAYER, _02D4
_0187:
    WaitMovement
    BufferPlayerName 0
    Message msg_0378_R31_00005
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
_0195:
    Message msg_0378_R31_00007
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 2
    CompareVar VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    GoToIf 5, _01AD
    @ HGSS: ScrCmd_606
_01AD:
    SetVar VAR_0x8004, ITEM_TM44
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01FC
    Common_GiveItemQuantity
    CompareVar VAR_HGSS_LOAN_SPEAROW, 2
    GoToIf 5, _01EB
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 3
    GoTo _01F1
_01EB:
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 5
_01F1:
    Message msg_0378_R31_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01FC:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0206:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021F:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0238:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0251:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026A:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00004
    CloseMessage
    BufferPlayerName 0
    Message msg_0378_R31_00006
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: MonGiveMail VAR_TEMP_x4000
    GoTo _0195
    End
_0295:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02AE:
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 1
    GoTo _0098
    End
    .balign 4, 0
_02BC:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02C4:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02CC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02D4:
    WalkOnSpotNormalEast
    EndMovement
scr_seq_R31_002:
    DrawSignpostInstantMessage msg_0378_R31_00013, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R31_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0378_R31_00014, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R31_004:
    NPCMessage msg_0378_R31_00012
    End
_0308:
    NPCMessage msg_0378_R31_00001
    End
scr_seq_R31_005:
    NPCMessage msg_0378_R31_00011
    End
    .balign 4, 0
