#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0121.h"


    ScriptEntry scr_seq_D38R0104_000
    ScriptEntryEnd
scr_seq_D38R0104_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TYROGUE_FROM_KARATE_KING, _0097
    GoToIfSet FLAG_HGSS_BEAT_KARATE_KING, _0046
    Message msg_0121_D38R0104_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_BLACK_BELT_KIYO, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00CC
    SetFlag FLAG_HGSS_BEAT_KARATE_KING
_0046:
    Message msg_0121_D38R0104_00001
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _0063
    Message msg_0121_D38R0104_00004
    GoTo _00D2
_0063:
    BufferPlayerName 0
    Message msg_0121_D38R0104_00002
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    @ HGSS: GiveMon SPECIES_TYROGUE, 10, 0, 0, 0, VAR_SPECIAL_RESULT
    Message msg_0121_D38R0104_00005
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    CallIf 1, _00A6
_0097:
    SetFlag FLAG_HGSS_GOT_TYROGUE_FROM_KARATE_KING
    Message msg_0121_D38R0104_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A6:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
_00CC:
    BlackOutFromBattle
    ReleaseAll
    End
_00D2:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
