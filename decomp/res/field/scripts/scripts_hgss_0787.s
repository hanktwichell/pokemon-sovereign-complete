#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0493.h"


    ScriptEntry scr_seq_T07PC0101_000
    ScriptEntry scr_seq_T07PC0101_001
    ScriptEntry scr_seq_T07PC0101_002
    ScriptEntry scr_seq_T07PC0101_003
    ScriptEntry scr_seq_T07PC0101_004
    ScriptEntryEnd
scr_seq_T07PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T07PC0101_001:
    NPCMessage msg_0493_T07PC0101_00000
    End
scr_seq_T07PC0101_002:
    NPCMessage msg_0493_T07PC0101_00001
    End
scr_seq_T07PC0101_003:
    NPCMessage msg_0493_T07PC0101_00002
    End
scr_seq_T07PC0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferPlayerName 0
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 243
    GoToIf 1, _00F2
    CompareVar VAR_MAP_LOCAL_0x01, 244
    GoToIf 1, _00F2
    CompareVar VAR_MAP_LOCAL_0x01, 245
    GoToIf 1, _010A
    Message msg_0493_T07PC0101_00003
    GoTo _00B4
_00A3:
    Message msg_0493_T07PC0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00AE:
    BlackOutFromBattle
    ReleaseAll
    End
_00B4:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00A3
    Message msg_0493_T07PC0101_00005
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LASS_MICKEY_3, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00AE
    Message msg_0493_T07PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F2:
    ApplyMovement 7, _0122
    WaitMovement
    BufferPartyMonSpecies 1, 0
    Message msg_0493_T07PC0101_00007
    GoTo _00B4
_010A:
    ApplyMovement 7, _0122
    WaitMovement
    BufferPartyMonSpecies 1, 0
    Message msg_0493_T07PC0101_00008
    GoTo _00B4
    .balign 4, 0
_0122:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
