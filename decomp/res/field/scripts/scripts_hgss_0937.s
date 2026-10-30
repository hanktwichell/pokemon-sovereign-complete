#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0625.h"


    ScriptEntry scr_seq_T28R0201_000
    ScriptEntry scr_seq_T28R0201_001
    ScriptEntryEnd
scr_seq_T28R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3F9D, _007B
    Message msg_0625_T28R0201_00000
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0099
    Message msg_0625_T28R0201_00002
    PlayFanfare SEQ_ME_TAMAGO_GET_sseq
    WaitFanfare
    GiveEgg SPECIES_RIOLU, 10
    SetFlag FLAG_HGSS_SG_3F9D
    Message msg_0625_T28R0201_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T28R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F6
    Message msg_0625_T28R0201_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_007B:
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00A4
    Message msg_0625_T28R0201_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0099:
    Message msg_0625_T28R0201_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A4:
    Message msg_0625_T28R0201_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00EB
    Message msg_0625_T28R0201_00007
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PKMN_TRAINER_RILEY_RILEY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E5
    Message msg_0625_T28R0201_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E5:
    BlackOutFromBattle
    ReleaseAll
    End
_00EB:
    Message msg_0625_T28R0201_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F6:
    Message msg_0625_T28R0201_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0137
    Message msg_0625_T28R0201_00011
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_PKMN_TRAINER_MIRA_BUCK, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E5
    Message msg_0625_T28R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0137:
    Message msg_0625_T28R0201_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
