#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0118.h"

#define obj_D37R0103_tsure_poke_static_machoke 1
#define obj_D37R0103_tsure_poke_static_machoke_2 2
#define obj_D37R0103_tsure_poke_static_machoke_3 3
#define obj_D37R0103_babyboy1_5 5
#define obj_D37R0103_babyboy1_5_2 6
#define obj_D37R0103_babyboy1_5_3 7
#define obj_D37R0103_stop 9
#define obj_D37R0103_stop_2 10
#define obj_D37R0103_stop_3 11
#define obj_D37R0103_stop_4 12
#define obj_D37R0103_stop_5 13
#define obj_D37R0103_stop_6 14
#define obj_D37R0103_stop_7 15
#define obj_D37R0103_stop_8 16
#define obj_D37R0103_stop_9 17

    ScriptEntry scr_seq_D37R0103_000
    ScriptEntry scr_seq_D37R0103_001
    ScriptEntry scr_seq_D37R0103_002
    ScriptEntry scr_seq_D37R0103_003
    ScriptEntryEnd
scr_seq_D37R0103_003:
    ShowObject obj_D37R0103_stop
    ShowObject obj_D37R0103_stop_2
    ShowObject obj_D37R0103_stop_3
    ShowObject obj_D37R0103_stop_4
    ShowObject obj_D37R0103_stop_5
    ShowObject obj_D37R0103_stop_6
    ShowObject obj_D37R0103_stop_7
    ShowObject obj_D37R0103_stop_8
    ShowObject obj_D37R0103_stop_9
    GoToIfSet FLAG_HGSS_UNK_096, _0059
    GoToIfSet FLAG_HGSS_UNK_097, _01BE
    GoToIfSet FLAG_HGSS_UNK_098, _0207
    End
_0059:
    GoToIfSet FLAG_HGSS_UNK_097, _00B3
    GoToIfSet FLAG_HGSS_UNK_098, _013E
    @ HGSS: ScrCmd_109 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    End
_00B3:
    GoToIfSet FLAG_HGSS_UNK_098, _02BF
    @ HGSS: ScrCmd_109 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    End
_013E:
    @ HGSS: ScrCmd_109 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
_01BE:
    GoToIfSet FLAG_HGSS_UNK_098, _0245
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    End
_0207:
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
_0245:
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
_02BF:
    @ HGSS: ScrCmd_109 0, 9
    SetPosition obj_D37R0103_tsure_poke_static_machoke, 19, 0, 16, DIR_SOUTH
    SetPosition obj_D37R0103_babyboy1_5_3, 19, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop, 19, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_2, 20, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_3, 20, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_2, 3, 0, 14, DIR_WEST
    SetPosition obj_D37R0103_babyboy1_5_2, 1, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_stop_4, 1, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_5, 2, 0, 13, DIR_NORTH
    SetPosition obj_D37R0103_stop_6, 2, 0, 14, DIR_NORTH
    SetPosition obj_D37R0103_tsure_poke_static_machoke_3, 7, 0, 17, DIR_EAST
    SetPosition obj_D37R0103_babyboy1_5, 8, 0, 18, DIR_NORTH
    SetPosition obj_D37R0103_stop_7, 8, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_8, 9, 0, 17, DIR_NORTH
    SetPosition obj_D37R0103_stop_9, 9, 0, 18, DIR_NORTH
    End
scr_seq_D37R0103_000:
    GoToIfSet FLAG_HGSS_UNK_096, _03C9
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0118_D37R0103_00000
    CloseMessage
    ApplyMovement obj_D37R0103_tsure_poke_static_machoke, _0504
    ApplyMovement obj_D37R0103_babyboy1_5_3, _0504
    ApplyMovement obj_D37R0103_stop, _0504
    ApplyMovement obj_D37R0103_stop_2, _0504
    ApplyMovement obj_D37R0103_stop_3, _0504
    WaitMovement
    SetFlag FLAG_HGSS_UNK_096
    @ HGSS: ScrCmd_109 0, 9
    ReleaseAll
    End
_03C9:
    NPCMessage msg_0118_D37R0103_00001
    End
scr_seq_D37R0103_001:
    .short SCRCMD_UNUSED_06A
    .short 4
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 15
    GoToIf 5, _03FD
    GoTo _041C
_03F7:
    GoTo _041C
_03FD:
    CompareVar VAR_MAP_LOCAL_0x01, 16
    GoToIf 5, _0416
    GoTo _0483
_0410:
    GoTo _041C
_0416:
    GoTo _03C9
_041C:
    GoToIfSet FLAG_HGSS_UNK_097, _03C9
    @ HGSS: ScrCmd_622 4, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0440
    GoTo _0446
_0440:
    GoTo _03C9
_0446:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0118_D37R0103_00000
    CloseMessage
    ApplyMovement obj_D37R0103_tsure_poke_static_machoke_2, _050C
    ApplyMovement obj_D37R0103_babyboy1_5_2, _050C
    ApplyMovement obj_D37R0103_stop_4, _050C
    ApplyMovement obj_D37R0103_stop_5, _050C
    ApplyMovement obj_D37R0103_stop_6, _050C
    WaitMovement
    SetFlag FLAG_HGSS_UNK_097
    ReleaseAll
    End
_0483:
    GoToIfSet FLAG_HGSS_UNK_098, _03C9
    @ HGSS: ScrCmd_622 4, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _04A7
    GoTo _04AD
_04A7:
    GoTo _03C9
_04AD:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0118_D37R0103_00000
    CloseMessage
    ApplyMovement obj_D37R0103_tsure_poke_static_machoke_3, _0514
    ApplyMovement obj_D37R0103_babyboy1_5, _0514
    ApplyMovement obj_D37R0103_stop_7, _0514
    ApplyMovement obj_D37R0103_stop_8, _0514
    ApplyMovement obj_D37R0103_stop_9, _0514
    WaitMovement
    SetFlag FLAG_HGSS_UNK_098
    ReleaseAll
    End
scr_seq_D37R0103_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_MACHOKE, 0
    Message msg_0118_D37R0103_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0504:
    WalkSlowSouth 2
    EndMovement
    .balign 4, 0
_050C:
    WalkSlowWest 2
    EndMovement
    .balign 4, 0
_0514:
    WalkSlowEast 2
    EndMovement
    .balign 4, 0
