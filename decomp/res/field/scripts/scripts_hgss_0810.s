#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0515.h"

#define obj_T08PC0101_gsgirl1 6

    ScriptEntry scr_seq_T08PC0101_000
    ScriptEntry scr_seq_T08PC0101_001
    ScriptEntry scr_seq_T08PC0101_002
    ScriptEntry scr_seq_T08PC0101_003
    ScriptEntry scr_seq_T08PC0101_004
    ScriptEntry scr_seq_T08PC0101_005
    ScriptEntry scr_seq_T08PC0101_006
    ScriptEntry scr_seq_T08PC0101_007
    ScriptEntryEnd
scr_seq_T08PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T08PC0101_001:
    NPCMessage msg_0515_T08PC0101_00000
    End
scr_seq_T08PC0101_002:
    NPCMessage msg_0515_T08PC0101_00001
    End
scr_seq_T08PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0515_T08PC0101_00002
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0115
    ApplyMovement obj_T08PC0101_gsgirl1, _01B2
    GoTo _0130
scr_seq_T08PC0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_CLOYSTER, 6
    Message msg_0515_T08PC0101_00004
    WaitCry
    Message msg_0515_T08PC0101_00005
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    PlayCry SPECIES_CLOYSTER, 0
    ReleaseObject 7
    @ HGSS: ScrCmd_523 7, 4, 90, 4, 0
    LockObject 7
    WaitCry
    GoToIfSet FLAG_HGSS_SG_3F61, _014E
    Message msg_0515_T08PC0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08PC0101_005:
    PlayCry SPECIES_SHELLDER, 5
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0515_T08PC0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08PC0101_006:
    PlayCry SPECIES_SHELLDER, 6
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0515_T08PC0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T08PC0101_007:
    PlayCry SPECIES_SLOWPOKE, 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0515_T08PC0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0115:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _013B
    ApplyMovement obj_T08PC0101_gsgirl1, _01D4
    GoTo _0130
_0130:
    Message msg_0515_T08PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013B:
    ApplyMovement obj_T08PC0101_gsgirl1, _01F6
    Message msg_0515_T08PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_014E:
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    Message msg_0515_T08PC0101_00010
    CloseMessage
    ReleaseObject 7
    @ HGSS: ScrCmd_523 7, 2, 90, 2, 0
    LockObject 7
    PlayCry SPECIES_CLOYSTER, 0
    Message msg_0515_T08PC0101_00011
    WaitCry
    CloseMessage
    CompleteStartWildBattle SPECIES_CLOYSTER, 59, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 7
    RemoveObject 8
    RemoveObject 9
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0515_T08PC0101_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01B2:
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    EndMovement
    .balign 4, 0
_01D4:
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    EndMovement
    .balign 4, 0
_01F6:
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    FaceSouth
    FaceEast
    FaceNorth
    FaceWest
    EndMovement
    .balign 4, 0
