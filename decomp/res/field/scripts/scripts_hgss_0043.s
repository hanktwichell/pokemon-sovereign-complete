#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0077.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D24R0206_babyboy1_12 0
#define obj_D24R0206_babyboy1_13 1

    ScriptEntry scr_seq_D24R0206_000
    ScriptEntry scr_seq_D24R0206_001
    ScriptEntry scr_seq_D24R0206_002
    ScriptEntry scr_seq_D24R0206_003
    ScriptEntryEnd
scr_seq_D24R0206_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteAlphPuzzle 2
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoToIfSet FLAG_HGSS_SYS_ALPH_PUZZLE_OMANYTE, _0046
    ReleaseAll
    End
_0046:
    WaitTime 2, VAR_0x8004
    CompleteScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _02A4
    WaitMovement
    RemoveObject obj_D24R0206_babyboy1_13
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_UNK_111
    SetFlag FLAG_HGSS_UNK_220
    ClearFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _009A
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00AA
    End
_009A:
    ApplyMovement LOCALID_PLAYER, _022C
    WaitMovement
    GoTo _00BC
_00AA:
    ApplyMovement LOCALID_PLAYER, _022C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0238
    WaitMovement
_00BC:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 4, _0107
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 5, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40DF, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
_0107:
    SetFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 5, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40DF, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
scr_seq_D24R0206_003:
    LockAll
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0167
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0177
    End
_0167:
    ApplyMovement LOCALID_PLAYER, _022C
    WaitMovement
    GoTo _0189
_0177:
    ApplyMovement LOCALID_PLAYER, _022C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0238
    WaitMovement
_0189:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _01D5
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _01FF
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 5, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01D1:
    ReleaseAll
    End
_01D5:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 5, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01D1
_01FF:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 5, 42, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01D1
    .balign 4, 0
_022C:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0238:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
scr_seq_D24R0206_001:
    LockAll
    ReleaseAll
    End
scr_seq_D24R0206_002:
    LockAll
    GoToIfSet FLAG_HGSS_OPENED_ALPH_WATER_STONE_SECRET_ROOM, _0292
    WaitTime 2, VAR_0x8004
    CompleteScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _02A4
    WaitMovement
    RemoveObject obj_D24R0206_babyboy1_12
    SetFlag FLAG_HGSS_OPENED_ALPH_WATER_STONE_SECRET_ROOM
    PlaySE SEQ_SE_DP_UG_008_sseq
    ReleaseAll
    End
_0292:
    WaitTime 10, VAR_0x8004
    Message msg_0077_D24R0206_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02A4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
