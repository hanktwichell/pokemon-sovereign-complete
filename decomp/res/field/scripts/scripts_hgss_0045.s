#include "macros/scrcmd.inc"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D24R0208_babyboy1_12 0
#define obj_D24R0208_babyboy1_13 1

    ScriptEntry scr_seq_D24R0208_000
    ScriptEntry scr_seq_D24R0208_001
    ScriptEntry scr_seq_D24R0208_002
    ScriptEntryEnd
scr_seq_D24R0208_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: AlphPuzzle 3
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoToIfSet FLAG_HGSS_SYS_ALPH_PUZZLE_HO_OH, _0042
    ReleaseAll
    End
_0042:
    WaitTime 2, VAR_0x8004
    @ HGSS: ScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0298
    WaitMovement
    RemoveObject obj_D24R0208_babyboy1_13
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_UNK_111
    SetFlag FLAG_HGSS_UNK_222
    ClearFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0096
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00A6
    End
_0096:
    ApplyMovement LOCALID_PLAYER, _0228
    WaitMovement
    GoTo _00B8
_00A6:
    ApplyMovement LOCALID_PLAYER, _0228
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0234
    WaitMovement
_00B8:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 4, _0103
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 5, 24, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40E0, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
_0103:
    SetFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 5, 24, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40E0, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
scr_seq_D24R0208_002:
    LockAll
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0163
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0173
    End
_0163:
    ApplyMovement LOCALID_PLAYER, _0228
    WaitMovement
    GoTo _0185
_0173:
    ApplyMovement LOCALID_PLAYER, _0228
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0234
    WaitMovement
_0185:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _01D1
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _01FB
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 5, 24, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01CD:
    ReleaseAll
    End
_01D1:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 5, 24, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01CD
_01FB:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 5, 24, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01CD
    .balign 4, 0
_0228:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0234:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
scr_seq_D24R0208_001:
    LockAll
    @ HGSS: OpenAlphHiddenRoom 3
    CheckPartyHasSpecies VAR_RESULT, SPECIES_HO_OH
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0264
    GoTo _0268
_0264:
    ReleaseAll
    End
_0268:
    WaitTime 2, VAR_0x8004
    @ HGSS: ScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0298
    WaitMovement
    RemoveObject obj_D24R0208_babyboy1_12
    SetFlag FLAG_HGSS_OPENED_ALPH_HO_OH_SECRET_ROOM
    PlaySE SEQ_SE_DP_UG_008_sseq
    ReleaseAll
    End
    .balign 4, 0
_0298:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
