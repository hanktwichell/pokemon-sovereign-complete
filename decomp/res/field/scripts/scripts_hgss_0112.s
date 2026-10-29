#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0130.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D44R0103_chourou 0
#define obj_D44R0103_gsleader8 3
#define obj_D44R0103_gsmiddleman1 4

    ScriptEntry scr_seq_D44R0103_000
    ScriptEntry scr_seq_D44R0103_001
    ScriptEntry scr_seq_D44R0103_002
    ScriptEntry scr_seq_D44R0103_003
    ScriptEntry scr_seq_D44R0103_004
    ScriptEntry scr_seq_D44R0103_005
    ScriptEntryEnd
scr_seq_D44R0103_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _002B
    ClearFlag FLAG_HGSS_UNK_189
    End
_002B:
    GoToIfSet FLAG_HGSS_UNK_0EA, _003C
    GoTo _005A
_003C:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0064
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0064
_005A:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0068
_0064:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
_0068:
    GoToIfSet FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW, _0075
    End
_0075:
    SetFlag FLAG_HGSS_GOT_DRATINI_FROM_MASTER_LONG_AGO
    End
scr_seq_D44R0103_003:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0370
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0130_D44R0103_00000
_00A0:
    SetVarFromValue VAR_0x8004, 0
    Message msg_0130_D44R0103_00001
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntryImm 280, 0
    AddMenuEntryImm 281, 1
    AddMenuEntryImm 282, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0310
    Message msg_0130_D44R0103_00009
_00DF:
    SetVarFromValue VAR_0x8004, 1
    Message msg_0130_D44R0103_00002
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntryImm 283, 0
    AddMenuEntryImm 284, 0
    AddMenuEntryImm 285, 1
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0310
    Message msg_0130_D44R0103_00009
_011E:
    SetVarFromValue VAR_0x8004, 2
    Message msg_0130_D44R0103_00003
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntryImm 286, 1
    AddMenuEntryImm 287, 0
    AddMenuEntryImm 288, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0310
    Message msg_0130_D44R0103_00009
_015D:
    SetVarFromValue VAR_0x8004, 3
    Message msg_0130_D44R0103_00004
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntryImm 289, 0
    AddMenuEntryImm 290, 1
    AddMenuEntryImm 291, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0310
    Message msg_0130_D44R0103_00009
_019C:
    SetVarFromValue VAR_0x8004, 4
    Message msg_0130_D44R0103_00005
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntryImm 292, 1
    AddMenuEntryImm 293, 0
    AddMenuEntryImm 294, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0310
    BufferPlayerName 0
    Message msg_0130_D44R0103_00006
    CloseMessage
    SetPosition obj_D44R0103_gsleader8, 6, 0, 21, DIR_NORTH
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_DOOR_sseq
    WaitTime 5, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0390
    ApplyMovement obj_D44R0103_gsleader8, _03A8
    WaitMovement
    Message msg_0130_D44R0103_00010
    ApplyMovement obj_D44R0103_gsleader8, _03C0
    WaitMovement
    Message msg_0130_D44R0103_00011
    ApplyMovement obj_D44R0103_gsleader8, _03D0
    WaitMovement
    Message msg_0130_D44R0103_00012
    ApplyMovement obj_D44R0103_chourou, _03DC
    WaitMovement
    Message msg_0130_D44R0103_00013
    ApplyMovement obj_D44R0103_gsleader8, _03EC
    WaitMovement
    Message msg_0130_D44R0103_00014
    ApplyMovement obj_D44R0103_gsleader8, _03F4
    ApplyMovement obj_D44R0103_chourou, _03FC
    WaitMovement
    Message msg_0130_D44R0103_00015
    BufferPlayerName 0
    Message msg_0130_D44R0103_00016
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0130_D44R0103_00017
    ApplyMovement obj_D44R0103_chourou, _0408
    ApplyMovement LOCALID_PLAYER, _0418
    ApplyMovement obj_D44R0103_gsleader8, _0424
    WaitMovement
    Message msg_0130_D44R0103_00018
    CloseMessage
    WaitTime 15, VAR_0x8005
    Message msg_0130_D44R0103_00019
    CloseMessage
    ApplyMovement obj_D44R0103_gsleader8, _0434
    WaitMovement
    RemoveObject obj_D44R0103_gsleader8
    Common_FadeToDefaultMusic
    WaitFanfare
    ApplyMovement obj_D44R0103_chourou, _0450
    WaitMovement
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _02D3
    Message msg_0130_D44R0103_00020
    GoTo _02D6
_02D3:
    Message msg_0130_D44R0103_00021
_02D6:
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_998
    SetFlag FLAG_HGSS_UNK_0EA
    ClearFlag FLAG_HGSS_HIDE_VICTORY_ROAD_CLAIR
    SetVarFromValue VAR_HGSS_UNK_40C4, 1
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    SetVarFromValue VAR_HGSS_UNK_40C3, 1
    SetVarFromValue VAR_HGSS_UNK_407B, 1
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 8
    ClearFlag FLAG_HGSS_HIDE_ELMS_LAB_FRIEND
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT, 1
    End
_0310:
    SetFlag FLAG_HGSS_FAILED_DRAGONS_DEN_QUIZ
    ApplyMovement obj_D44R0103_chourou, _0378
    WaitMovement
    Message msg_0130_D44R0103_00007
    ApplyMovement obj_D44R0103_chourou, _0388
    WaitMovement
    Message msg_0130_D44R0103_00008
    WaitABPress
    SetVar VAR_0x8008, VAR_0x8004
    CompareVar VAR_0x8008, 0
    GoToIf 1, _00A0
    CompareVar VAR_0x8008, 1
    GoToIf 1, _00DF
    CompareVar VAR_0x8008, 2
    GoToIf 1, _011E
    CompareVar VAR_0x8008, 3
    GoToIf 1, _015D
    GoTo _019C
    .balign 4, 0
_0370:
    WalkNormalNorth 8
    EndMovement
    .balign 4, 0
_0378:
    Delay8 2
    FaceEast
    Delay8 2
    EndMovement
    .balign 4, 0
_0388:
    FaceSouth
    EndMovement
    .balign 4, 0
_0390:
    Delay8
    EmoteExclamationMark
    FaceSouth
    Delay8 8
    FaceWest
    EndMovement
    .balign 4, 0
_03A8:
    Delay8 4
    WalkNormalNorth 8
    WalkNormalWest
    WalkNormalNorth 2
    FaceEast
    EndMovement
    .balign 4, 0
_03C0:
    Delay8
    LockDir
    WalkFastWest
    EndMovement
    .balign 4, 0
_03D0:
    Delay8
    WalkSlowWest
    EndMovement
    .balign 4, 0
_03DC:
    Delay8
    WalkSlowSouth
    WalkSlowWest
    EndMovement
    .balign 4, 0
_03EC:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03F4:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_03FC:
    Delay8 2
    FaceEast
    EndMovement
    .balign 4, 0
_0408:
    WalkSlowNorth
    WalkSlowEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0418:
    Delay16 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0424:
    UnlockDir
    Delay16 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0434:
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkFasterSouth 3
    WalkFasterEast
    WalkFasterSouth 4
    EndMovement
    .balign 4, 0
_0450:
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D44R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_DRATINI_FROM_MASTER_LONG_AGO, _053D
    GoToIfSet FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW, _052E
    GoToIfSet FLAG_HGSS_GOT_TM59_FROM_CLAIR, _04A6
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _049B
    Message msg_0130_D44R0103_00020
    GoTo _049E
_049B:
    Message msg_0130_D44R0103_00022
_049E:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A6:
    Message msg_0130_D44R0103_00026
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _04C3
    Message msg_0130_D44R0103_00028
    GoTo _0548
_04C3:
    BufferPlayerName 0
    Message msg_0130_D44R0103_00027
    WaitFanfare
    @ HGSS: GiveMon SPECIES_DRATINI, 15, 0, 0, 0, VAR_SPECIAL_RESULT
    GoToIfSet FLAG_HGSS_FAILED_DRAGONS_DEN_QUIZ, _04F0
    @ HGSS: SetMonMove VAR_SPECIAL_x8005, 0, MOVE_EXTREME_SPEED
_04F0:
    Message msg_0130_D44R0103_00032
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _050E
    GoTo _052E
_050E:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_SPECIAL_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_052E:
    SetFlag FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW
    Message msg_0130_D44R0103_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_053D:
    Message msg_0130_D44R0103_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0548:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D44R0103_001:
    NPCMessage msg_0130_D44R0103_00024
    End
scr_seq_D44R0103_002:
    NPCMessage msg_0130_D44R0103_00025
    End
scr_seq_D44R0103_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _069E
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06B2
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05EF
    ApplyMovement LOCALID_PLAYER, _06C8
    ApplyMovement obj_D44R0103_gsmiddleman1, _0714
    GoTo _063D
_05EF:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _060A
    ApplyMovement LOCALID_PLAYER, _06E0
    GoTo _063D
_060A:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _062D
    ApplyMovement LOCALID_PLAYER, _0700
    ApplyMovement obj_D44R0103_gsmiddleman1, _0714
    GoTo _063D
_062D:
    ApplyMovement LOCALID_PLAYER, _06EC
    ApplyMovement obj_D44R0103_gsmiddleman1, _0714
_063D:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0664
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0720
    WaitMovement
_0664:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 46
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_069E:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06B2:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_06C8:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06E0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06EC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0700:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0714:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0720:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
