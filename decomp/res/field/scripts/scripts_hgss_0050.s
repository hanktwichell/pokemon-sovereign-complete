#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0081.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D24R0213_000
    ScriptEntry scr_seq_D24R0213_001
    ScriptEntryEnd
scr_seq_D24R0213_000:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40D1, 1
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0034
    CompareVar VAR_RESULT, 1
    GoToIf 1, _007E
    End
_0034:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0053
    ApplyMovement LOCALID_PLAYER, _0108
    GoTo _0076
_0053:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _006E
    ApplyMovement LOCALID_PLAYER, _0140
    GoTo _0076
_006E:
    ApplyMovement LOCALID_PLAYER, _0124
_0076:
    WaitMovement
    GoTo _00DA
_007E:
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00A5
    ApplyMovement LOCALID_PLAYER, _0108
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0114
    GoTo _00D8
_00A5:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _00C8
    ApplyMovement LOCALID_PLAYER, _0140
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _014C
    GoTo _00D8
_00C8:
    ApplyMovement LOCALID_PLAYER, _0124
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0130
_00D8:
    WaitMovement
_00DA:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_SOUTHEAST_HIDDEN_ROOM, 11, 7, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0108:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0114:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_0124:
    WalkOnSpotFasterWest 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0130:
    Delay4 3
    WalkFasterWest
    SetInvisible
    EndMovement
    .balign 4, 0
_0140:
    WalkOnSpotFasterEast 4
    SetInvisible
    EndMovement
    .balign 4, 0
_014C:
    Delay4 3
    WalkFasterEast
    SetInvisible
    EndMovement
scr_seq_D24R0213_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0081_D24R0213_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
