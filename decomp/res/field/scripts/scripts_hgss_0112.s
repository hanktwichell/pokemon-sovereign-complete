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
    GoToIfUnset FLAG_HGSS_UNK_189, _0365
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D44R0103_003:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0F88
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0130_D44R0103_00000
    SetVarFromValue VAR_0x8004, 0
    Message msg_0130_D44R0103_00001
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 280, 0
    AddMenuEntry 281, 1
    AddMenuEntry 282, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 1
    Message msg_0130_D44R0103_00002
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 283, 0
    AddMenuEntry 284, 0
    AddMenuEntry 285, 1
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 2
    Message msg_0130_D44R0103_00003
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 286, 1
    AddMenuEntry 287, 0
    AddMenuEntry 288, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 3
    Message msg_0130_D44R0103_00004
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 289, 0
    AddMenuEntry 290, 1
    AddMenuEntry 291, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 4
    Message msg_0130_D44R0103_00005
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 292, 1
    AddMenuEntry 293, 0
    AddMenuEntry 294, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    BufferPlayerName 0
    Message msg_0130_D44R0103_00006
    CloseMessage
    SetPosition obj_D44R0103_gsleader8, 6, 0, 21, DIR_NORTH
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_DOOR_sseq
    WaitTime 5, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0F8E
    ApplyMovement obj_D44R0103_gsleader8, _0FA4
    WaitMovement
    Message msg_0130_D44R0103_00010
    ApplyMovement obj_D44R0103_gsleader8, _0FBA
    WaitMovement
    Message msg_0130_D44R0103_00011
    ApplyMovement obj_D44R0103_gsleader8, _0FC8
    WaitMovement
    Message msg_0130_D44R0103_00012
    ApplyMovement obj_D44R0103_chourou, _0FD2
    WaitMovement
    Message msg_0130_D44R0103_00013
    ApplyMovement obj_D44R0103_gsleader8, _0FE0
    WaitMovement
    Message msg_0130_D44R0103_00014
    ApplyMovement obj_D44R0103_gsleader8, _0FE6
    ApplyMovement obj_D44R0103_chourou, _0FEC
    WaitMovement
    Message msg_0130_D44R0103_00015
    BufferPlayerName 0
    Message msg_0130_D44R0103_00016
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0130_D44R0103_00017
    ApplyMovement obj_D44R0103_chourou, _0FF6
    ApplyMovement LOCALID_PLAYER, _1004
    ApplyMovement obj_D44R0103_gsleader8, _100E
    WaitMovement
    Message msg_0130_D44R0103_00018
    CloseMessage
    WaitTime 15, VAR_0x8005
    Message msg_0130_D44R0103_00019
    CloseMessage
    ApplyMovement obj_D44R0103_gsleader8, _101C
    WaitMovement
    RemoveObject obj_D44R0103_gsleader8
    Common_FadeToDefaultMusic
    WaitFanfare
    ApplyMovement obj_D44R0103_chourou, _1036
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _03D6
    Message msg_0130_D44R0103_00020
    GoTo _0413
scr_seq_D44R0103_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_DRATINI_FROM_MASTER_LONG_AGO, _044D
    GoToIfSet FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW, _0458
    GoToIfSet FLAG_HGSS_GOT_TM59_FROM_CLAIR, _0467
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0484
    Message msg_0130_D44R0103_00020
    GoTo _048F
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
    GoToIf 1, _0497
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04AB
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _04BF
    ApplyMovement LOCALID_PLAYER, _103C
    ApplyMovement obj_D44R0103_gsmiddleman1, _1052
    GoTo _04DA
_0365:
    GoToIfSet FLAG_HGSS_UNK_0EA, _053B
    GoTo _0563
_0376:
    SetFlag FLAG_HGSS_FAILED_DRAGONS_DEN_QUIZ
    ApplyMovement obj_D44R0103_chourou, _105C
    WaitMovement
    Message msg_0130_D44R0103_00007
    ApplyMovement obj_D44R0103_chourou, _106A
    WaitMovement
    Message msg_0130_D44R0103_00008
    WaitABPress
    SetVar VAR_0x8008, VAR_0x8004
    CompareVar VAR_0x8008, 0
    GoToIf 1, _056D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _07A0
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0994
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0B49
    GoTo _0CBF
_03D6:
    Message msg_0130_D44R0103_00021
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
_0413:
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
_044D:
    Message msg_0130_D44R0103_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0458:
    SetFlag FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW
    Message msg_0130_D44R0103_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0467:
    Message msg_0130_D44R0103_00026
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _0DF6
    Message msg_0130_D44R0103_00028
    GoTo _0E41
_0484:
    Message msg_0130_D44R0103_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_048F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0497:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04AB:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04BF:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0E49
    ApplyMovement LOCALID_PLAYER, _1070
    GoTo _04DA
_04DA:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0E6C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _107A
    WaitMovement
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
_053B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0EA6
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0EA6
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0EB7
_0563:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0EB7
_056D:
    SetVarFromValue VAR_0x8004, 0
    Message msg_0130_D44R0103_00001
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 280, 0
    AddMenuEntry 281, 1
    AddMenuEntry 282, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 1
    Message msg_0130_D44R0103_00002
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 283, 0
    AddMenuEntry 284, 0
    AddMenuEntry 285, 1
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 2
    Message msg_0130_D44R0103_00003
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 286, 1
    AddMenuEntry 287, 0
    AddMenuEntry 288, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 3
    Message msg_0130_D44R0103_00004
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 289, 0
    AddMenuEntry 290, 1
    AddMenuEntry 291, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 4
    Message msg_0130_D44R0103_00005
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 292, 1
    AddMenuEntry 293, 0
    AddMenuEntry 294, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    BufferPlayerName 0
    Message msg_0130_D44R0103_00006
    CloseMessage
    SetPosition obj_D44R0103_gsleader8, 6, 0, 21, DIR_NORTH
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_DOOR_sseq
    WaitTime 5, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0F8E
    ApplyMovement obj_D44R0103_gsleader8, _0FA4
    WaitMovement
    Message msg_0130_D44R0103_00010
    ApplyMovement obj_D44R0103_gsleader8, _0FBA
    WaitMovement
    Message msg_0130_D44R0103_00011
    ApplyMovement obj_D44R0103_gsleader8, _0FC8
    WaitMovement
    Message msg_0130_D44R0103_00012
    ApplyMovement obj_D44R0103_chourou, _0FD2
    WaitMovement
    Message msg_0130_D44R0103_00013
    ApplyMovement obj_D44R0103_gsleader8, _0FE0
    WaitMovement
    Message msg_0130_D44R0103_00014
    ApplyMovement obj_D44R0103_gsleader8, _0FE6
    ApplyMovement obj_D44R0103_chourou, _0FEC
    WaitMovement
    Message msg_0130_D44R0103_00015
    BufferPlayerName 0
    Message msg_0130_D44R0103_00016
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0130_D44R0103_00017
    ApplyMovement obj_D44R0103_chourou, _0FF6
    ApplyMovement LOCALID_PLAYER, _1004
    ApplyMovement obj_D44R0103_gsleader8, _100E
    WaitMovement
    Message msg_0130_D44R0103_00018
    CloseMessage
    WaitTime 15, VAR_0x8005
    Message msg_0130_D44R0103_00019
    CloseMessage
    ApplyMovement obj_D44R0103_gsleader8, _101C
    WaitMovement
    RemoveObject obj_D44R0103_gsleader8
    Common_FadeToDefaultMusic
    WaitFanfare
    ApplyMovement obj_D44R0103_chourou, _1036
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _03D6
    Message msg_0130_D44R0103_00020
    GoTo _0413
_07A0:
    SetVarFromValue VAR_0x8004, 1
    Message msg_0130_D44R0103_00002
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 283, 0
    AddMenuEntry 284, 0
    AddMenuEntry 285, 1
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 2
    Message msg_0130_D44R0103_00003
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 286, 1
    AddMenuEntry 287, 0
    AddMenuEntry 288, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 3
    Message msg_0130_D44R0103_00004
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 289, 0
    AddMenuEntry 290, 1
    AddMenuEntry 291, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 4
    Message msg_0130_D44R0103_00005
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 292, 1
    AddMenuEntry 293, 0
    AddMenuEntry 294, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    BufferPlayerName 0
    Message msg_0130_D44R0103_00006
    CloseMessage
    SetPosition obj_D44R0103_gsleader8, 6, 0, 21, DIR_NORTH
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_DOOR_sseq
    WaitTime 5, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0F8E
    ApplyMovement obj_D44R0103_gsleader8, _0FA4
    WaitMovement
    Message msg_0130_D44R0103_00010
    ApplyMovement obj_D44R0103_gsleader8, _0FBA
    WaitMovement
    Message msg_0130_D44R0103_00011
    ApplyMovement obj_D44R0103_gsleader8, _0FC8
    WaitMovement
    Message msg_0130_D44R0103_00012
    ApplyMovement obj_D44R0103_chourou, _0FD2
    WaitMovement
    Message msg_0130_D44R0103_00013
    ApplyMovement obj_D44R0103_gsleader8, _0FE0
    WaitMovement
    Message msg_0130_D44R0103_00014
    ApplyMovement obj_D44R0103_gsleader8, _0FE6
    ApplyMovement obj_D44R0103_chourou, _0FEC
    WaitMovement
    Message msg_0130_D44R0103_00015
    BufferPlayerName 0
    Message msg_0130_D44R0103_00016
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0130_D44R0103_00017
    ApplyMovement obj_D44R0103_chourou, _0FF6
    ApplyMovement LOCALID_PLAYER, _1004
    ApplyMovement obj_D44R0103_gsleader8, _100E
    WaitMovement
    Message msg_0130_D44R0103_00018
    CloseMessage
    WaitTime 15, VAR_0x8005
    Message msg_0130_D44R0103_00019
    CloseMessage
    ApplyMovement obj_D44R0103_gsleader8, _101C
    WaitMovement
    RemoveObject obj_D44R0103_gsleader8
    Common_FadeToDefaultMusic
    WaitFanfare
    ApplyMovement obj_D44R0103_chourou, _1036
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _03D6
    Message msg_0130_D44R0103_00020
    GoTo _0413
_0994:
    SetVarFromValue VAR_0x8004, 2
    Message msg_0130_D44R0103_00003
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 286, 1
    AddMenuEntry 287, 0
    AddMenuEntry 288, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 3
    Message msg_0130_D44R0103_00004
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 289, 0
    AddMenuEntry 290, 1
    AddMenuEntry 291, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 4
    Message msg_0130_D44R0103_00005
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 292, 1
    AddMenuEntry 293, 0
    AddMenuEntry 294, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    BufferPlayerName 0
    Message msg_0130_D44R0103_00006
    CloseMessage
    SetPosition obj_D44R0103_gsleader8, 6, 0, 21, DIR_NORTH
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_DOOR_sseq
    WaitTime 5, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0F8E
    ApplyMovement obj_D44R0103_gsleader8, _0FA4
    WaitMovement
    Message msg_0130_D44R0103_00010
    ApplyMovement obj_D44R0103_gsleader8, _0FBA
    WaitMovement
    Message msg_0130_D44R0103_00011
    ApplyMovement obj_D44R0103_gsleader8, _0FC8
    WaitMovement
    Message msg_0130_D44R0103_00012
    ApplyMovement obj_D44R0103_chourou, _0FD2
    WaitMovement
    Message msg_0130_D44R0103_00013
    ApplyMovement obj_D44R0103_gsleader8, _0FE0
    WaitMovement
    Message msg_0130_D44R0103_00014
    ApplyMovement obj_D44R0103_gsleader8, _0FE6
    ApplyMovement obj_D44R0103_chourou, _0FEC
    WaitMovement
    Message msg_0130_D44R0103_00015
    BufferPlayerName 0
    Message msg_0130_D44R0103_00016
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0130_D44R0103_00017
    ApplyMovement obj_D44R0103_chourou, _0FF6
    ApplyMovement LOCALID_PLAYER, _1004
    ApplyMovement obj_D44R0103_gsleader8, _100E
    WaitMovement
    Message msg_0130_D44R0103_00018
    CloseMessage
    WaitTime 15, VAR_0x8005
    Message msg_0130_D44R0103_00019
    CloseMessage
    ApplyMovement obj_D44R0103_gsleader8, _101C
    WaitMovement
    RemoveObject obj_D44R0103_gsleader8
    Common_FadeToDefaultMusic
    WaitFanfare
    ApplyMovement obj_D44R0103_chourou, _1036
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _03D6
    Message msg_0130_D44R0103_00020
    GoTo _0413
_0B49:
    SetVarFromValue VAR_0x8004, 3
    Message msg_0130_D44R0103_00004
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 289, 0
    AddMenuEntry 290, 1
    AddMenuEntry 291, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    Message msg_0130_D44R0103_00009
    SetVarFromValue VAR_0x8004, 4
    Message msg_0130_D44R0103_00005
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 292, 1
    AddMenuEntry 293, 0
    AddMenuEntry 294, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    BufferPlayerName 0
    Message msg_0130_D44R0103_00006
    CloseMessage
    SetPosition obj_D44R0103_gsleader8, 6, 0, 21, DIR_NORTH
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_DOOR_sseq
    WaitTime 5, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0F8E
    ApplyMovement obj_D44R0103_gsleader8, _0FA4
    WaitMovement
    Message msg_0130_D44R0103_00010
    ApplyMovement obj_D44R0103_gsleader8, _0FBA
    WaitMovement
    Message msg_0130_D44R0103_00011
    ApplyMovement obj_D44R0103_gsleader8, _0FC8
    WaitMovement
    Message msg_0130_D44R0103_00012
    ApplyMovement obj_D44R0103_chourou, _0FD2
    WaitMovement
    Message msg_0130_D44R0103_00013
    ApplyMovement obj_D44R0103_gsleader8, _0FE0
    WaitMovement
    Message msg_0130_D44R0103_00014
    ApplyMovement obj_D44R0103_gsleader8, _0FE6
    ApplyMovement obj_D44R0103_chourou, _0FEC
    WaitMovement
    Message msg_0130_D44R0103_00015
    BufferPlayerName 0
    Message msg_0130_D44R0103_00016
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0130_D44R0103_00017
    ApplyMovement obj_D44R0103_chourou, _0FF6
    ApplyMovement LOCALID_PLAYER, _1004
    ApplyMovement obj_D44R0103_gsleader8, _100E
    WaitMovement
    Message msg_0130_D44R0103_00018
    CloseMessage
    WaitTime 15, VAR_0x8005
    Message msg_0130_D44R0103_00019
    CloseMessage
    ApplyMovement obj_D44R0103_gsleader8, _101C
    WaitMovement
    RemoveObject obj_D44R0103_gsleader8
    Common_FadeToDefaultMusic
    WaitFanfare
    ApplyMovement obj_D44R0103_chourou, _1036
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _03D6
    Message msg_0130_D44R0103_00020
    GoTo _0413
_0CBF:
    SetVarFromValue VAR_0x8004, 4
    Message msg_0130_D44R0103_00005
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 0
    AddMenuEntry 292, 1
    AddMenuEntry 293, 0
    AddMenuEntry 294, 0
    ShowMenu
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0376
    BufferPlayerName 0
    Message msg_0130_D44R0103_00006
    CloseMessage
    SetPosition obj_D44R0103_gsleader8, 6, 0, 21, DIR_NORTH
    WaitTime 10, VAR_0x8004
    PlaySE SEQ_SE_DP_DOOR_sseq
    WaitTime 5, VAR_0x8004
    ApplyMovement LOCALID_PLAYER, _0F8E
    ApplyMovement obj_D44R0103_gsleader8, _0FA4
    WaitMovement
    Message msg_0130_D44R0103_00010
    ApplyMovement obj_D44R0103_gsleader8, _0FBA
    WaitMovement
    Message msg_0130_D44R0103_00011
    ApplyMovement obj_D44R0103_gsleader8, _0FC8
    WaitMovement
    Message msg_0130_D44R0103_00012
    ApplyMovement obj_D44R0103_chourou, _0FD2
    WaitMovement
    Message msg_0130_D44R0103_00013
    ApplyMovement obj_D44R0103_gsleader8, _0FE0
    WaitMovement
    Message msg_0130_D44R0103_00014
    ApplyMovement obj_D44R0103_gsleader8, _0FE6
    ApplyMovement obj_D44R0103_chourou, _0FEC
    WaitMovement
    Message msg_0130_D44R0103_00015
    BufferPlayerName 0
    Message msg_0130_D44R0103_00016
    PlayFanfare SEQ_BADGE_sseq
    WaitFanfare
    Message msg_0130_D44R0103_00017
    ApplyMovement obj_D44R0103_chourou, _0FF6
    ApplyMovement LOCALID_PLAYER, _1004
    ApplyMovement obj_D44R0103_gsleader8, _100E
    WaitMovement
    Message msg_0130_D44R0103_00018
    CloseMessage
    WaitTime 15, VAR_0x8005
    Message msg_0130_D44R0103_00019
    CloseMessage
    ApplyMovement obj_D44R0103_gsleader8, _101C
    WaitMovement
    RemoveObject obj_D44R0103_gsleader8
    Common_FadeToDefaultMusic
    WaitFanfare
    ApplyMovement obj_D44R0103_chourou, _1036
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _03D6
    Message msg_0130_D44R0103_00020
    GoTo _0413
_0DF6:
    BufferPlayerName 0
    Message msg_0130_D44R0103_00027
    WaitFanfare
    GivePokemon SPECIES_DRAGONAIR, 45, ITEM_DRACO_PLATE, VAR_RESULT
    GoToIfSet FLAG_HGSS_FAILED_DRAGONS_DEN_QUIZ, _0EC4
    ResetPartyMonMoveSlot_Unused VAR_0x8005, 0, MOVE_EXTREME_SPEED
    Message msg_0130_D44R0103_00032
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0EE2
    GoTo _0458
_0E41:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0E49:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0F11
    ApplyMovement LOCALID_PLAYER, _1088
    ApplyMovement obj_D44R0103_gsmiddleman1, _1052
    GoTo _04DA
_0E6C:
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
_0EA6:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoToIfSet FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW, _0F82
    End
_0EB7:
    GoToIfSet FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW, _0F82
    End
_0EC4:
    Message msg_0130_D44R0103_00032
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0EE2
    GoTo _0458
_0EE2:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_GOT_DRATINI_FROM_MASTER_JUST_NOW
    Message msg_0130_D44R0103_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0F11:
    ApplyMovement LOCALID_PLAYER, _109A
    ApplyMovement obj_D44R0103_gsmiddleman1, _1052
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0E6C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _107A
    WaitMovement
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
_0F82:
    SetFlag FLAG_HGSS_GOT_DRATINI_FROM_MASTER_LONG_AGO
    End
    .balign 4, 0
_0F88:
    WalkNormalNorth 8
    EndMovement
    .balign 4, 0
_0F8E:
    Delay8
    EmoteExclamationMark
    FaceSouth
    Delay8 8
    FaceWest
    EndMovement
    .balign 4, 0
_0FA4:
    Delay8 4
    WalkNormalNorth 8
    WalkNormalWest
    WalkNormalNorth 2
    FaceEast
    EndMovement
    .balign 4, 0
_0FBA:
    Delay8
    LockDir
    WalkFastWest
    EndMovement
    .balign 4, 0
_0FC8:
    Delay8
    WalkSlowWest
    EndMovement
    .balign 4, 0
_0FD2:
    Delay8
    WalkSlowSouth
    WalkSlowWest
    EndMovement
    .balign 4, 0
_0FE0:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0FE6:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0FEC:
    Delay8 2
    FaceEast
    EndMovement
    .balign 4, 0
_0FF6:
    WalkSlowNorth
    WalkSlowEast
    FaceSouth
    EndMovement
    .balign 4, 0
_1004:
    Delay16 2
    FaceNorth
    EndMovement
    .balign 4, 0
_100E:
    UnlockDir
    Delay16 2
    FaceNorth
    EndMovement
    .balign 4, 0
_101C:
    LockDir
    WalkNormalSouth
    UnlockDir
    WalkFasterSouth 3
    WalkFasterEast
    WalkFasterSouth 4
    EndMovement
    .balign 4, 0
_1036:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_103C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1052:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_105C:
    Delay8 2
    FaceEast
    Delay8 2
    EndMovement
    .balign 4, 0
_106A:
    FaceSouth
    EndMovement
    .balign 4, 0
_1070:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_107A:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_1088:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_109A:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
