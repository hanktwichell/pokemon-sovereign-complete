#include "macros/scrcmd.inc"
#include "generated/ribbons.h"
#include "res/text/bank/hgss_msg_0126.h"

#define obj_D41R0108_red 0

    ScriptEntry scr_seq_D41R0108_000
    ScriptEntry scr_seq_D41R0108_001
    ScriptEntryEnd
scr_seq_D41R0108_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0126_D41R0108_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PKMN_TRAINER_RED_RED, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00CD
    Message msg_0126_D41R0108_00001
    WaitTime 30, VAR_RESULT
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    RemoveObject obj_D41R0108_red
    SetFlag FLAG_HGSS_UNK_25F
    SetVarFromValue VAR_HGSS_UNK_40FD, 1
    CompareVar VAR_HGSS_UNK_4131, 0
    CallIf 1, _00D3
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 60, VAR_RESULT
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: HOFCredits 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D41R0108_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0126_D41R0108_00002
    CloseMessage
    BufferPlayerName 0
    ApplyMovement LOCALID_PLAYER, _0140
    WaitMovement
    RemoveObject 1
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_SKY_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
_00CD:
    BlackOutFromBattle
    ReleaseAll
    End
_00D3:
    SetVarFromValue VAR_HGSS_UNK_4131, 1
    ClearFlag FLAG_HGSS_HIDE_OAKS_LAB_BULBASAUR_BALL
    ClearFlag FLAG_HGSS_HIDE_OAKS_LAB_CHARMANDER_BALL
    ClearFlag FLAG_HGSS_HIDE_OAKS_LAB_SQUIRTLE_BALL
    Return
    GetPartyCount VAR_0x8004
    SetVarFromValue VAR_0x8005, 0
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _010E
    SetPartyMonRibbon VAR_0x8005, RIBBON_LEGEND
    @ HGSS data: .byte 39
    .balign 4, 0
    Return
_010E:
    AddVar VAR_0x8005, 1
    CompareVar VAR_0x8005, VAR_0x8004
    GoToIf 0, _0123
    Return
_0123:
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _010E
    SetPartyMonRibbon VAR_0x8005, RIBBON_LEGEND
    @ HGSS data: .byte 39
    @ HGSS data: .byte 0, 27, 0
    .balign 4, 0
_0140:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
