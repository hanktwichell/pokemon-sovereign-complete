#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0546.h"


    ScriptEntry scr_seq_T20R0202_000
    ScriptEntry scr_seq_T20R0202_001
    ScriptEntry scr_seq_T20R0202_002
    ScriptEntryEnd
scr_seq_T20R0202_000:
    LockAll
    PlaySE SEQ_SE_DP_PC_ON_sseq
    BufferPlayerName 0
    Message msg_0546_T20R0202_00000
    CloseMessage
    @ HGSS: ScrCmd_377 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00C2
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_376
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T20R0202_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0546_T20R0202_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0202_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    ApplyMovement LOCALID_PLAYER, _0256
    @ HGSS: ScrCmd_600
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3FC0, _00CD
    Message msg_0546_T20R0202_00003
    WaitButton
    CloseMessage
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00FE
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_00C2:
    Message msg_0546_T20R0202_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00CD:
    Message msg_0546_T20R0202_00003
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_00FE:
    CheckItem ITEM_LUNAR_WING, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0154
    FadeScreen 6, 6, 0, COLOR_BLACK
    WaitFadeScreen
    StopMusic
    PlayCry SPECIES_DARKRAI, 0
    WaitCry
    PlayMusic SEQ_TOWN01_D_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0546_T20R0202_00004
    ClearFlag FLAG_HGSS_SG_3FBF
    WaitButton
    CloseMessage
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_0154:
    Message msg_0546_T20R0202_00005
    CloseMessage
    FadeScreen 8, 6, 0, COLOR_BLACK
    WaitFadeScreen
    StopMusic
    PlayCry SPECIES_DARKRAI, 0
    WaitCry
    PlayMusic SEQ_TOWN01_D_sseq
    AddObject 3
    SetPosition 3, 2, 0, 7, DIR_NORTH
    ApplyMovement 3, _025C
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0546_T20R0202_00006
    WaitButton
    CloseMessage
    PlayCry SPECIES_DARKRAI, 6
    ReleaseObject 3
    @ HGSS: ScrCmd_523 3, 8, 90, 2, 0
    LockObject 3
    WaitCry
    GoTo _01D2
_01D2:
    CompleteStartWildBattle SPECIES_DARKRAI, 50, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0239
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 3
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _023F
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _024C
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _023F
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_0239:
    BlackOutFromBattle
    ReleaseAll
    End
_023F:
    Message msg_0546_T20R0202_00007
    WaitButton
    CloseMessage
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
_024C:
    SetFlag FLAG_HGSS_SG_3FC0
    @ HGSS: ScrCmd_606
    ReleaseAll
    End
    .balign 4, 0
_0256:
    FaceSouth
    EndMovement
    .balign 4, 0
_025C:
    WalkOnSpotNormalSouth 3
    EndMovement
    .balign 4, 0
