#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0521.h"


    ScriptEntry scr_seq_T10_000
    ScriptEntry scr_seq_T10_001
    ScriptEntry scr_seq_T10_002
    ScriptEntry scr_seq_T10_003
    ScriptEntry scr_seq_T10_004
    ScriptEntryEnd
scr_seq_T10_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0521_T10_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T10_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    BufferPlayerName 0
    Message msg_0521_T10_00001
    WaitButton
    ClearFlag FLAG_HGSS_SG_3FDE
    AddObject 0
    SetPosition 0, 912, 0, 211, DIR_NORTH
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _02AA
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _02B0
    ApplyMovement 0, _02B6
    WaitMovement
    LockAll
    Message msg_0521_T10_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayCry SPECIES_LATIAS, 0
    WaitCry
    PlayCry SPECIES_LATIOS, 0
    WaitCry
    ClearFlag FLAG_HGSS_SG_3FDD
    ClearFlag FLAG_HGSS_SG_3FDC
    AddObject 2
    AddObject 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement 0, _02AA
    WaitMovement
    ApplyMovement 0, _02C0
    WaitMovement
    Message msg_0521_T10_00003
    WaitButton
    CloseMessage
    SetVar VAR_0x8004, ITEM_ULTRA_BALL
    SetVar VAR_0x8005, 50
    Common_GiveItemQuantity
    CloseMessage
    ApplyMovement 0, _02D6
    WaitMovement
    SetVarFromValue VAR_HGSS_SG_6136, 2
    ReleaseAll
    End
scr_seq_T10_002:
    GoToIfSet FLAG_HGSS_SG_3FDD, _01E6
    GoToIfSet FLAG_HGSS_SG_3FDC, _0228
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0521_T10_00004
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T10_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_LATIAS, 0
    Message msg_0521_T10_00006
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_LATIAS, 50, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _026A
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 1
    SetFlag FLAG_HGSS_SG_3FDD
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T10_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_LATIOS, 0
    Message msg_0521_T10_00005
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_LATIOS, 50, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _026A
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 2
    SetFlag FLAG_HGSS_SG_3FDC
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_01E6:
    GoToIfSet FLAG_HGSS_SG_3FDC, _0270
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0521_T10_00004
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0228:
    GoToIfSet FLAG_HGSS_SG_3FDD, _0270
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0521_T10_00004
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_026A:
    BlackOutFromBattle
    ReleaseAll
    End
_0270:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0521_T10_00007
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 0
    RemoveObject 3
    SetFlag FLAG_HGSS_SG_3FDE
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_02AA:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_02B0:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_02B6:
    WalkFastNorth 7
    FaceNorth
    EndMovement
    .balign 4, 0
_02C0:
    WalkOnSpotNormalWest
    Delay4 3
    WalkOnSpotNormalEast
    Delay4 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02D6:
    WalkNormalWest
    WalkNormalNorth 3
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
