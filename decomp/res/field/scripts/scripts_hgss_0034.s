#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0070.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D23R0106_rkanbum 0
#define obj_D23R0106_gsgentleman 1

    ScriptEntry scr_seq_D23R0106_000
    ScriptEntry scr_seq_D23R0106_001
    ScriptEntryEnd
scr_seq_D23R0106_000:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    SetVarFromValue VAR_HGSS_UNK_4125, 0
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0137
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    End
scr_seq_D23R0106_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0070_D23R0106_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_EXECUTIVE_ARCHER_ARCHER, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0139
    Message msg_0070_D23R0106_00001
    CloseMessage
    HealParty
    AddObject 2
    SetPosition 2, 8, 0, 12, DIR_WEST
    ApplyMovement 2, _0464
    WaitMovement
    ApplyMovement obj_D23R0106_rkanbum, _047C
    WaitMovement
    ApplyMovement obj_D23R0106_rkanbum, _0484
    ApplyMovement LOCALID_PLAYER, _0484
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0484
    WaitMovement
    StopMusic
    Message msg_0070_D23R0106_00010
    WaitButton
    CloseMessage
    Message msg_0070_D23R0106_00012
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_ROCKET_BOSS_GIOVANNI, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0139
    Message msg_0070_D23R0106_00011
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_D23R0106_rkanbum
    RemoveObject 2
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ClearFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    FadeOutBGM 0, 30
    StopMusic
    WaitTime 15, VAR_RESULT
    PlayDefaultMusic
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetPosition obj_D23R0106_gsgentleman, 8, 1, 12, DIR_SOUTH
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _013F
    ApplyMovement obj_D23R0106_gsgentleman, _048C
    GoTo _016B
    End
_0137:
    End
_0139:
    BlackOutFromBattle
    ReleaseAll
    End
_013F:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _01B7
    ApplyMovement obj_D23R0106_gsgentleman, _04A8
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    CallIf 1, _0218
    GoTo _016B
_016B:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _023D
    ApplyMovement LOCALID_PLAYER, _04C4
    WaitMovement
    Message msg_0070_D23R0106_00002
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0272
    SetVar VAR_0x8004, ITEM_RAINBOW_WING
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_093
    Message msg_0070_D23R0106_00005
    CloseMessage
    GoTo _02A6
_01B7:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _016B
    ApplyMovement obj_D23R0106_gsgentleman, _04CC
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _023D
    ApplyMovement LOCALID_PLAYER, _04C4
    WaitMovement
    Message msg_0070_D23R0106_00002
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0272
    SetVar VAR_0x8004, ITEM_RAINBOW_WING
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_093
    Message msg_0070_D23R0106_00005
    CloseMessage
    GoTo _02A6
_0218:
    .short SCRCMD_UNUSED_06A
    .short LOCALID_COMPLETE_FOLLOWER
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_0x8004, 7
    GoToIf 5, _02C1
    WaitTime 112, VAR_RESULT
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _04E8
    Return
_023D:
    WaitMovement
    Message msg_0070_D23R0106_00002
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0272
    SetVar VAR_0x8004, ITEM_RAINBOW_WING
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_093
    Message msg_0070_D23R0106_00005
    CloseMessage
    GoTo _02A6
_0272:
    SetVar VAR_0x8004, ITEM_SILVER_WING
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_094
    Message msg_0070_D23R0106_00006
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _02C3
    ApplyMovement obj_D23R0106_gsgentleman, _04F8
    GoTo _02DE
_02A6:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _02C3
    ApplyMovement obj_D23R0106_gsgentleman, _04F8
    GoTo _02DE
_02C1:
    Return
_02C3:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _030E
    ApplyMovement obj_D23R0106_gsgentleman, _0508
    GoTo _02DE
_02DE:
    WaitMovement
    ApplyMovement obj_D23R0106_gsgentleman, _0518
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _04C4
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0353
    Message msg_0070_D23R0106_00007
    GoTo _03CE
_030E:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _02DE
    ApplyMovement obj_D23R0106_gsgentleman, _0520
    WaitMovement
    ApplyMovement obj_D23R0106_gsgentleman, _0518
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _04C4
    WaitMovement
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0353
    Message msg_0070_D23R0106_00007
    GoTo _03CE
_0353:
    Message msg_0070_D23R0106_00008
    CloseMessage
    ApplyMovement obj_D23R0106_gsgentleman, _0530
    WaitMovement
    Message msg_0070_D23R0106_00009
    CloseMessage
    ApplyMovement obj_D23R0106_gsgentleman, _0548
    WaitMovement
    PlaySE SEQ_SE_DP_DOOR10_sseq
    WaitSE SEQ_SE_DP_DOOR10_sseq
    WaitTime 8, VAR_RESULT
    RemoveObject obj_D23R0106_gsgentleman
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    SetFlag FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS
    ClearFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_OFFICE_DIRECTOR
    SetFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_PETREL_REVEALED
    CompareVar VAR_HGSS_UNK_40F8, 2
    GoToIf 5, _0446
    SetVarFromValue VAR_HGSS_UNK_40F8, 0
    SetVarFromValue VAR_HGSS_UNK_407A, 1
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_SALESWOMAN
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_INFRONT
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_ASIDE
    SetFlag FLAG_HGSS_UNK_998
    SetFlag FLAG_HGSS_UNK_97D
    End
_03CE:
    CloseMessage
    ApplyMovement obj_D23R0106_gsgentleman, _0530
    WaitMovement
    Message msg_0070_D23R0106_00009
    CloseMessage
    ApplyMovement obj_D23R0106_gsgentleman, _0548
    WaitMovement
    PlaySE SEQ_SE_DP_DOOR10_sseq
    WaitSE SEQ_SE_DP_DOOR10_sseq
    WaitTime 8, VAR_RESULT
    RemoveObject obj_D23R0106_gsgentleman
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    SetFlag FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS
    ClearFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_OFFICE_DIRECTOR
    SetFlag FLAG_HGSS_HIDE_RADIO_TOWER_5F_PETREL_REVEALED
    CompareVar VAR_HGSS_UNK_40F8, 2
    GoToIf 5, _0446
    SetVarFromValue VAR_HGSS_UNK_40F8, 0
    SetVarFromValue VAR_HGSS_UNK_407A, 1
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_SALESWOMAN
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_INFRONT
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_ASIDE
    SetFlag FLAG_HGSS_UNK_998
    SetFlag FLAG_HGSS_UNK_97D
    End
_0446:
    SetVarFromValue VAR_HGSS_UNK_407A, 1
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_SALESWOMAN
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_INFRONT
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_ASIDE
    SetFlag FLAG_HGSS_UNK_998
    SetFlag FLAG_HGSS_UNK_97D
    End
    .balign 4, 0
_0464:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth 7
    WalkNormalEast 4
    FaceNorth
    EndMovement
    .balign 4, 0
_047C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0484:
    FaceSouth
    EndMovement
    .balign 4, 0
_048C:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth 7
    WalkNormalEast 4
    WalkNormalNorth 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_04A8:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth 7
    WalkNormalEast 3
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_04C4:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_04CC:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth 7
    WalkNormalEast 4
    WalkNormalNorth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_04E8:
    WalkNormalNorth
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04F8:
    WalkNormalSouth 3
    WalkNormalWest 4
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0508:
    WalkNormalSouth 2
    WalkNormalWest 3
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0518:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0520:
    WalkNormalSouth 3
    WalkNormalWest 4
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0530:
    WalkNormalWest
    WalkNormalSouth
    EmoteExclamationMark
    Delay8 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0548:
    WalkNormalSouth 6
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
