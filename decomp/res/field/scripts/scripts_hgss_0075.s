#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0099.h"

#define obj_D31R0207_bfsw1 0
#define obj_D31R0207_seven1 1
#define obj_D31R0207_seven5 2
#define obj_D31R0207_seven2 3
#define obj_D31R0207_seven3 4
#define obj_D31R0207_seven4 5

    ScriptEntry scr_seq_D31R0207_000
    ScriptEntry scr_seq_D31R0207_001
    ScriptEntry scr_seq_D31R0207_002
    ScriptEntry scr_seq_D31R0207_003
    ScriptEntry scr_seq_D31R0207_004
    ScriptEntry scr_seq_D31R0207_005
    ScriptEntry scr_seq_D31R0207_006
    ScriptEntry scr_seq_D31R0207_007
    ScriptEntry scr_seq_D31R0207_008
    ScriptEntry scr_seq_D31R0207_009
    ScriptEntryEnd
scr_seq_D31R0207_006:
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 5, _004C
    @ HGSS: ScrCmd_412 55, 2, VAR_TEMP_x4009
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 1, _00EA
_004C:
    ClearFlag FLAG_HGSS_UNK_2AD
_0050:
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 5, _0072
    @ HGSS: ScrCmd_412 55, 2, VAR_TEMP_x4009
    CompareVar VAR_MAP_LOCAL_0x09, 1
    GoToIf 1, _00F6
_0072:
    ClearFlag FLAG_HGSS_UNK_2AE
_0076:
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 5, _0098
    @ HGSS: ScrCmd_412 55, 2, VAR_TEMP_x4009
    CompareVar VAR_MAP_LOCAL_0x09, 2
    GoToIf 1, _0102
_0098:
    ClearFlag FLAG_HGSS_UNK_2AF
_009C:
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 5, _00BE
    @ HGSS: ScrCmd_412 55, 2, VAR_TEMP_x4009
    CompareVar VAR_MAP_LOCAL_0x09, 3
    GoToIf 1, _010E
_00BE:
    ClearFlag FLAG_HGSS_UNK_2B0
_00C2:
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 5, _00E4
    @ HGSS: ScrCmd_412 55, 2, VAR_TEMP_x4009
    CompareVar VAR_MAP_LOCAL_0x09, 4
    GoToIf 1, _011A
_00E4:
    ClearFlag FLAG_HGSS_UNK_2B1
_00E8:
    End
_00EA:
    SetFlag FLAG_HGSS_UNK_2AD
    GoTo _0050
    End
_00F6:
    SetFlag FLAG_HGSS_UNK_2AE
    GoTo _0076
    End
_0102:
    SetFlag FLAG_HGSS_UNK_2AF
    GoTo _009C
    End
_010E:
    SetFlag FLAG_HGSS_UNK_2B0
    GoTo _00C2
    End
_011A:
    SetFlag FLAG_HGSS_UNK_2B1
    GoTo _00E8
    End
scr_seq_D31R0207_007:
    CompareVar VAR_HGSS_UNK_4151, 1
    CallIf 1, _0142
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 1, _0148
    End
_0142:
    ShowObject LOCALID_PLAYER
    Return
_0148:
    SetPosition obj_D31R0207_bfsw1, 8, 0, 3, DIR_SOUTH
    End
scr_seq_D31R0207_008:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4151, 0
    Call _048B
    Message msg_0099_D31R0207_00000
    CloseMessage
    @ HGSS: ScrCmd_412 56, 0, 0
    ReleaseAll
    End
scr_seq_D31R0207_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0099_D31R0207_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01A3
    Message msg_0099_D31R0207_00000
    CloseMessage
    ReleaseAll
    End
_01A3:
    CloseMessage
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_414B, 3
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_TOWER, 11, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    End
scr_seq_D31R0207_009:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4151, 0
    Message msg_0099_D31R0207_00002
    CloseMessage
    Call _04C5
    SetVarFromValue VAR_HGSS_UNK_414D, 2
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_TOWER_ELEVATOR, 3, 6, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0216:
    @ HGSS: ScrCmd_413 VAR_TEMP_x4009, 0, VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    BufferSpeciesNameFromVar 0, VAR_0x8004, 0, 0
    BufferMoveName 1, VAR_0x8005
    @ HGSS: ScrCmd_413 VAR_TEMP_x4009, 1, VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    BufferSpeciesNameFromVar 2, VAR_0x8004, 0, 0
    BufferMoveName 3, VAR_0x8005
    Return
scr_seq_D31R0207_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 1, _02A7
    SetVarFromValue VAR_MAP_LOCAL_0x09, 0
    @ HGSS: ScrCmd_413 VAR_TEMP_x4009, 0, VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    @ HGSS: BufferSpeciesNameIndef 0, VAR_SPECIAL_x8004, 0, 0
    BufferMoveName 1, VAR_0x8005
    @ HGSS: ScrCmd_413 VAR_TEMP_x4009, 1, VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    @ HGSS: BufferSpeciesNameIndef 2, VAR_SPECIAL_x8004, 0, 0
    BufferMoveName 3, VAR_0x8005
    Message msg_0099_D31R0207_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02B2
_02A7:
    Message msg_0099_D31R0207_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02B2:
    @ HGSS: ScrCmd_412 50, VAR_TEMP_x4009, 0
    SetVarFromValue VAR_HGSS_UNK_4151, 2
    Message msg_0099_D31R0207_00008
    CloseMessage
    ReleaseAll
    LockObject obj_D31R0207_seven1
    GoTo _0541
    End
scr_seq_D31R0207_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 1, _030F
    SetVarFromValue VAR_MAP_LOCAL_0x09, 1
    Call _0216
    BufferPlayerName 4
    Message msg_0099_D31R0207_00015
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _031A
_030F:
    Message msg_0099_D31R0207_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031A:
    @ HGSS: ScrCmd_412 50, VAR_TEMP_x4009, 0
    SetVarFromValue VAR_HGSS_UNK_4151, 2
    BufferPlayerName 0
    Message msg_0099_D31R0207_00017
    CloseMessage
    ReleaseAll
    LockObject obj_D31R0207_seven5
    GoTo _0586
    End
scr_seq_D31R0207_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 1, _0377
    SetVarFromValue VAR_MAP_LOCAL_0x09, 2
    Call _0216
    Message msg_0099_D31R0207_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0382
_0377:
    Message msg_0099_D31R0207_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0382:
    @ HGSS: ScrCmd_412 50, VAR_TEMP_x4009, 0
    SetVarFromValue VAR_HGSS_UNK_4151, 2
    Message msg_0099_D31R0207_00005
    CloseMessage
    ReleaseAll
    LockObject obj_D31R0207_seven2
    GoTo _05CB
    End
scr_seq_D31R0207_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 1, _03DC
    SetVarFromValue VAR_MAP_LOCAL_0x09, 3
    Call _0216
    Message msg_0099_D31R0207_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03E7
_03DC:
    Message msg_0099_D31R0207_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E7:
    @ HGSS: ScrCmd_412 50, VAR_TEMP_x4009, 0
    SetVarFromValue VAR_HGSS_UNK_4151, 2
    Message msg_0099_D31R0207_00014
    CloseMessage
    ReleaseAll
    LockObject obj_D31R0207_seven3
    GoTo _0610
    End
scr_seq_D31R0207_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4151, 2
    GoToIf 1, _0441
    SetVarFromValue VAR_MAP_LOCAL_0x09, 4
    Call _0216
    Message msg_0099_D31R0207_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _044C
_0441:
    Message msg_0099_D31R0207_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_044C:
    @ HGSS: ScrCmd_412 50, VAR_TEMP_x4009, 0
    SetVarFromValue VAR_HGSS_UNK_4151, 2
    Message msg_0099_D31R0207_00011
    CloseMessage
    ReleaseAll
    LockObject obj_D31R0207_seven4
    GoTo _0655
    End
_046D:
    @ HGSS: ScrCmd_307 0, 0, 8, 2, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    Return
_0480:
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    Return
_048B:
    Call _046D
    ApplyMovement obj_D31R0207_bfsw1, _06AC
    WaitMovement
    @ HGSS: ScrCmd_374 obj_player
    ApplyMovement LOCALID_PLAYER, _069C
    WaitMovement
    Call _0480
    ApplyMovement obj_D31R0207_bfsw1, _06BC
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _06A4
    WaitMovement
    Return
_04C5:
    Call _046D
    ApplyMovement obj_D31R0207_bfsw1, _06F0
    ApplyMovement LOCALID_PLAYER, _06E4
    WaitMovement
    Call _0480
    Return
_04E5:
    ApplyMovement VAR_MAP_LOCAL_0x00, _06FC
    WaitMovement
    ApplyMovement obj_D31R0207_bfsw1, _06C8
    WaitMovement
    Call _046D
    ApplyMovement VAR_MAP_LOCAL_0x00, _0704
    WaitMovement
    Call _0480
    ApplyMovement obj_D31R0207_bfsw1, _06D8
    WaitMovement
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_TOWER_PARTNER_ROOM, 8, 4, DIR_NORTH
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0541:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 12
    GoToIf 1, _0562
    GoTo _0574
    End
_0562:
    ApplyMovement obj_D31R0207_seven1, _0710
    WaitMovement
    GoTo _04E5
    End
_0574:
    ApplyMovement obj_D31R0207_seven1, _0724
    WaitMovement
    GoTo _04E5
    End
_0586:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 2
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 4
    GoToIf 1, _05A7
    GoTo _05B9
    End
_05A7:
    ApplyMovement obj_D31R0207_seven5, _073C
    WaitMovement
    GoTo _04E5
    End
_05B9:
    ApplyMovement obj_D31R0207_seven5, _074C
    WaitMovement
    GoTo _04E5
    End
_05CB:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 3
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 7
    GoToIf 1, _05EC
    GoTo _05FE
    End
_05EC:
    ApplyMovement obj_D31R0207_seven2, _0758
    WaitMovement
    GoTo _04E5
    End
_05FE:
    ApplyMovement obj_D31R0207_seven2, _0768
    WaitMovement
    GoTo _04E5
    End
_0610:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 4
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 9
    GoToIf 1, _0631
    GoTo _0643
    End
_0631:
    ApplyMovement obj_D31R0207_seven3, _0774
    WaitMovement
    GoTo _04E5
    End
_0643:
    ApplyMovement obj_D31R0207_seven3, _0788
    WaitMovement
    GoTo _04E5
    End
_0655:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 5
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 8
    GoToIf 1, _0676
    GoTo _0688
    End
_0676:
    ApplyMovement obj_D31R0207_seven4, _079C
    WaitMovement
    GoTo _04E5
    End
_0688:
    ApplyMovement obj_D31R0207_seven4, _07AC
    WaitMovement
    GoTo _04E5
    End
    .balign 4, 0
_069C:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_06A4:
    FaceNorth
    EndMovement
    .balign 4, 0
_06AC:
    WalkNormalSouth 2
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
_06BC:
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_06C8:
    FaceSouth
    WalkFastWest
    FaceEast
    EndMovement
    .balign 4, 0
_06D8:
    WalkFastEast
    FaceSouth
    EndMovement
    .balign 4, 0
_06E4:
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_06F0:
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_06FC:
    FaceNorth
    EndMovement
    .balign 4, 0
_0704:
    WalkFastNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_0710:
    WalkFastSouth
    WalkFastWest 3
    WalkFastNorth 7
    WalkFastWest 2
    EndMovement
    .balign 4, 0
_0724:
    WalkFastWest
    WalkFastNorth
    WalkFastWest 2
    WalkFastNorth 5
    WalkFastWest 2
    EndMovement
    .balign 4, 0
_073C:
    WalkFastEast
    WalkFastNorth 2
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_074C:
    WalkFastNorth 2
    WalkFastEast 4
    EndMovement
    .balign 4, 0
_0758:
    WalkFastWest
    WalkFastNorth 4
    WalkFastWest 2
    EndMovement
    .balign 4, 0
_0768:
    WalkFastNorth 4
    WalkFastWest 3
    EndMovement
    .balign 4, 0
_0774:
    WalkFastSouth
    WalkFastEast 4
    WalkFastNorth 7
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_0788:
    WalkFastNorth
    WalkFastEast 4
    WalkFastNorth 5
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_079C:
    WalkFastWest
    WalkFastNorth 5
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_07AC:
    WalkFastEast 3
    WalkFastNorth 5
    WalkFastWest 2
    EndMovement
    .balign 4, 0
