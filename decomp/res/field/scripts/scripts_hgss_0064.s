#include "macros/scrcmd.inc"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D27R0105_000
    ScriptEntryEnd
scr_seq_D27R0105_000:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_40A7, 1
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0039
    ApplyMovement LOCALID_PLAYER, _0070
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _007C
    WaitMovement
    GoTo _0043
_0039:
    ApplyMovement LOCALID_PLAYER, _0070
    WaitMovement
_0043:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_OLIVINE_LIGHTHOUSE_EXTERIOR, 15, 3, DIR_SOUTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0070:
    WalkFastEast
    SetInvisible
    EndMovement
    .balign 4, 0
_007C:
    WalkFastEast
    SetInvisible
    EndMovement
    .balign 4, 0
