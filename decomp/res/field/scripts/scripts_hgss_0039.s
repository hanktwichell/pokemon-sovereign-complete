#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0074.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D24R0202_babyboy1_12 0
#define obj_D24R0202_babyboy1_13 1

    ScriptEntry scr_seq_D24R0202_000
    ScriptEntry scr_seq_D24R0202_001
    ScriptEntry scr_seq_D24R0202_002
    ScriptEntry scr_seq_D24R0202_003
    ScriptEntry scr_seq_D24R0202_004
    ScriptEntryEnd
scr_seq_D24R0202_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CompleteAlphPuzzle 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoToIfSet FLAG_HGSS_SYS_ALPH_PUZZLE_KABUTO, _004A
    ReleaseAll
    End
_004A:
    SetFlag FLAG_HGSS_UNK_188
    WaitTime 2, VAR_0x8004
    CompleteScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _02AC
    WaitMovement
    RemoveObject obj_D24R0202_babyboy1_13
    PlaySE SEQ_SE_DP_KI_GASYAN_sseq
    ClearFlag FLAG_HGSS_UNK_111
    SetFlag FLAG_HGSS_UNK_21C
    ClearFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00A2
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00B2
    End
_00A2:
    ApplyMovement LOCALID_PLAYER, _0234
    WaitMovement
    GoTo _00C4
_00B2:
    ApplyMovement LOCALID_PLAYER, _0234
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0240
    WaitMovement
_00C4:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNK_40EC, 1
    GoToIf 4, _010F
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 25, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40DD, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
_010F:
    SetFlag FLAG_HGSS_HIDE_RUINS_OF_ALPH_ASSISTANTS
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 25, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromValue VAR_HGSS_UNK_40DD, 1
    AddVar VAR_HGSS_UNK_40EC, 1
    ReleaseAll
    End
scr_seq_D24R0202_004:
    LockAll
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _016F
    CompareVar VAR_RESULT, 1
    GoToIf 1, _017F
    End
_016F:
    ApplyMovement LOCALID_PLAYER, _0234
    WaitMovement
    GoTo _0191
_017F:
    ApplyMovement LOCALID_PLAYER, _0234
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0240
    WaitMovement
_0191:
    SetVarFromValue VAR_HGSS_UNK_40CE, 1
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 7
    GoToIf 4, _01DD
    CompareVar VAR_HGSS_UNOWN_REPORT_LEVEL, 6
    GoToIf 1, _0207
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL, 25, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01D9:
    ReleaseAll
    End
_01DD:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT_2, 25, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01D9
_0207:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_RUINS_OF_ALPH_UNDERGROUND_HALL_SINJOH_EVENT, 25, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    GoTo _01D9
    .balign 4, 0
_0234:
    WalkOnSpotFasterNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0240:
    Delay4 3
    WalkFasterNorth
    SetInvisible
    EndMovement
scr_seq_D24R0202_001:
    LockAll
    ReleaseAll
    End
scr_seq_D24R0202_002:
    LockAll
    GoToIfSet FLAG_HGSS_OPENED_ALPH_ESCAPE_ROPE_SECRET_ROOM, _029A
    WaitTime 2, VAR_0x8004
    CompleteScreenShake 0, 2, 10, 6
    WaitTime 10, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _02AC
    WaitMovement
    RemoveObject obj_D24R0202_babyboy1_12
    SetFlag FLAG_HGSS_OPENED_ALPH_ESCAPE_ROPE_SECRET_ROOM
    PlaySE SEQ_SE_DP_UG_008_sseq
    ReleaseAll
    End
_029A:
    WaitTime 10, VAR_0x8004
    Message msg_0074_D24R0202_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02AC:
    EmoteExclamationMark
    EndMovement
scr_seq_D24R0202_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_188, _02D2
    Message msg_0074_D24R0202_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02D2:
    Message msg_0074_D24R0202_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
