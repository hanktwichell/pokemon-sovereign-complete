#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0378.h"


    ScriptEntry scr_seq_R31_000
    ScriptEntry scr_seq_R31_001
    ScriptEntry scr_seq_R31_002
    ScriptEntry scr_seq_R31_003
    ScriptEntry scr_seq_R31_004
    ScriptEntry scr_seq_R31_005
    ScriptEntry scr_seq_R31_006
    ScriptEntryEnd
scr_seq_R31_000:
    End
scr_seq_R31_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_LOAN_SPEAROW, 1
    GoToIf 5, _0092
    GoTo _00A5
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
scr_seq_R31_005:
    NPCMessage msg_0378_R31_00011
    End
scr_seq_R31_006:
    BufferPlayerName 0
    End
_0092:
    CompareVar VAR_HGSS_LOAN_SPEAROW, 2
    GoToIf 5, _015C
    GoTo _016F
_00A5:
    Message msg_0378_R31_00001
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 255
    GoToIf 1, _01AD
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _01C6
    @ HGSS: KenyaCheck VAR_SPECIAL_RESULT, VAR_TEMP_x4000, 0
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01DF
    @ HGSS: KenyaCheck VAR_SPECIAL_RESULT, VAR_TEMP_x4000, 1
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01F8
    @ HGSS: CheckReturnLoanMon 7, VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0211
    CompareVar VAR_RESULT, 4
    GoToIf 1, _024B
    @ HGSS: ReturnLoanMon VAR_TEMP_x4000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0264
    ApplyMovement LOCALID_PLAYER, _03D0
    GoTo _027F
    BlackOutFromBattle
    ReleaseAll
    End
_015C:
    CompareVar VAR_HGSS_LOAN_SPEAROW, 4
    GoToIf 5, _02E3
    GoTo _016F
_016F:
    SetVar VAR_0x8004, ITEM_TM44
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _030C
    Common_GiveItemQuantity
    CompareVar VAR_HGSS_LOAN_SPEAROW, 2
    GoToIf 5, _0316
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 3
    GoTo _0327
_01AD:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C6:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01DF:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F8:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0211:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00004
    CloseMessage
    BufferPlayerName 0
    Message msg_0378_R31_00006
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: MonGiveMail 150
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_024B:
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0378_R31_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0264:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0332
    ApplyMovement LOCALID_PLAYER, _03D6
    GoTo _027F
_027F:
    WaitMovement
    BufferPlayerName 0
    Message msg_0378_R31_00005
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0378_R31_00007
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 2
    CompareVar VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    GoToIf 5, _016F
    @ HGSS: ScrCmd_606
    SetVar VAR_0x8004, ITEM_TM44
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _030C
    Common_GiveItemQuantity
    CompareVar VAR_HGSS_LOAN_SPEAROW, 2
    GoToIf 5, _0316
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 3
    GoTo _0327
_02E3:
    CompareVar VAR_HGSS_LOAN_SPEAROW, 6
    GoToIf 5, _034D
    @ HGSS: KenyaCheckPartyOrMailbox VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0358
    Message msg_0378_R31_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_030C:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0316:
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 5
    Message msg_0378_R31_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0327:
    Message msg_0378_R31_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0332:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0364
    ApplyMovement LOCALID_PLAYER, _03DC
    GoTo _027F
_034D:
    Message msg_0378_R31_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0358:
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 1
    GoTo _00A5
_0364:
    ApplyMovement LOCALID_PLAYER, _03E2
    WaitMovement
    BufferPlayerName 0
    Message msg_0378_R31_00005
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0378_R31_00007
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 2
    CompareVar VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    GoToIf 5, _016F
    @ HGSS: ScrCmd_606
    SetVar VAR_0x8004, ITEM_TM44
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _030C
    Common_GiveItemQuantity
    CompareVar VAR_HGSS_LOAN_SPEAROW, 2
    GoToIf 5, _0316
    SetVarFromValue VAR_HGSS_LOAN_SPEAROW, 3
    GoTo _0327
    .balign 4, 0
_03D0:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03D6:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03DC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03E2:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
