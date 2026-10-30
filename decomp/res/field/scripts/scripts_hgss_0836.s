#include "macros/scrcmd.inc"


    ScriptEntry scr_seq_T11R0603_000
    ScriptEntryEnd
scr_seq_T11R0603_000:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0038
    WaitMovement
    WaitTime 40, VAR_0x8004
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_GOLDENROD_MAGNET_TRAIN_STATION_2F, 17, 11, 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_411E, 0
    ReleaseAll
    End
    .balign 4, 0
_0038:
    WalkNormalWest 7
    WalkNormalNorth 2
    EndMovement
    End
    .balign 4, 0
