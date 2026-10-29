#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0126.h"

#define obj_D41R0108_red 0

    ScriptEntry scr_seq_D41R0108_000
    ScriptEntryEnd
scr_seq_D41R0108_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0126_D41R0108_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_PKMN_TRAINER_RED_RED, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0098
    Message msg_0126_D41R0108_00001
    WaitTime 30, VAR_RESULT
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    RemoveObject obj_D41R0108_red
    SetFlag FLAG_HGSS_UNK_25F
    SetVarFromValue VAR_HGSS_UNK_40FD, 1
    CompareVar VAR_HGSS_UNK_4131, 0
    CallIf 1, _009E
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Call _00B2
    WaitTime 60, VAR_RESULT
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: HOFCredits 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0098:
    BlackOutFromBattle
    ReleaseAll
    End
_009E:
    SetVarFromValue VAR_HGSS_UNK_4131, 1
    ClearFlag FLAG_HGSS_HIDE_OAKS_LAB_BULBASAUR_BALL
    ClearFlag FLAG_HGSS_HIDE_OAKS_LAB_CHARMANDER_BALL
    ClearFlag FLAG_HGSS_HIDE_OAKS_LAB_SQUIRTLE_BALL
    Return
_00B2:
    GetPartyCount VAR_0x8004
    SetVarFromValue VAR_0x8005, 0
_00BC:
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00D5
    @ HGSS: GiveRibbon VAR_SPECIAL_x8005, RIBBON_LEGEND
_00D5:
    AddVar VAR_0x8005, 1
    CompareVar VAR_0x8005, VAR_0x8004
    GoToIf 0, _00BC
    Return
    .balign 4, 0
