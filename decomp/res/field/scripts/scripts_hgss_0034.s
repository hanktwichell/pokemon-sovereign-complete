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
    GoToIf 5, _002D
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
_002D:
    End
scr_seq_D23R0106_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0070_D23R0106_00000
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_EXECUTIVE_ARCHER_ARCHER, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025D
    Message msg_0070_D23R0106_00001
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject obj_D23R0106_rkanbum
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ClearFlag FLAG_HGSS_ROCKET_TAKEOVER_ACTIVE
    FadeOutBGM 0, 30
    StopMusic
    WaitTime 15, VAR_RESULT
    @ HGSS: ResetBGM
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetPosition obj_D23R0106_gsgentleman, 8, 1, 12, DIR_SOUTH
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _00C1
    ApplyMovement obj_D23R0106_gsgentleman, _0288
    GoTo _0102
_00C1:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _00ED
    ApplyMovement obj_D23R0106_gsgentleman, _02A4
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    CallIf 1, _0263
    GoTo _0102
_00ED:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _0102
    ApplyMovement obj_D23R0106_gsgentleman, _02C0
_0102:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0119
    ApplyMovement LOCALID_PLAYER, _02EC
_0119:
    WaitMovement
    Message msg_0070_D23R0106_00002
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _014E
    SetVar VAR_0x8004, ITEM_RAINBOW_WING
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_093
    Message msg_0070_D23R0106_00005
    CloseMessage
    GoTo _0167
_014E:
    SetVar VAR_0x8004, ITEM_SILVER_WING
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_UNK_094
    Message msg_0070_D23R0106_00006
    CloseMessage
_0167:
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0182
    ApplyMovement obj_D23R0106_gsgentleman, _02F4
    GoTo _01B2
_0182:
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _019D
    ApplyMovement obj_D23R0106_gsgentleman, _0304
    GoTo _01B2
_019D:
    CompareVar VAR_MAP_LOCAL_0x00, 9
    GoToIf 5, _01B2
    ApplyMovement obj_D23R0106_gsgentleman, _0314
_01B2:
    WaitMovement
    ApplyMovement obj_D23R0106_gsgentleman, _0324
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _02EC
    WaitMovement
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _01E2
    Message msg_0070_D23R0106_00007
    GoTo _01E5
_01E2:
    Message msg_0070_D23R0106_00008
_01E5:
    CloseMessage
    ApplyMovement obj_D23R0106_gsgentleman, _032C
    WaitMovement
    Message msg_0070_D23R0106_00009
    CloseMessage
    ApplyMovement obj_D23R0106_gsgentleman, _0344
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
    GoToIf 5, _0241
    SetVarFromValue VAR_HGSS_UNK_40F8, 0
_0241:
    SetVarFromValue VAR_HGSS_UNK_407A, 1
    ClearFlag FLAG_HGSS_HIDE_MAHOGANY_SHOP_SALESWOMAN
    SetFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_INFRONT
    ClearFlag FLAG_HGSS_HIDE_BLACKTHORN_GYM_GUARD_ASIDE
    SetFlag FLAG_HGSS_UNK_998
    SetFlag FLAG_HGSS_UNK_97D
    End
_025D:
    BlackOutFromBattle
    ReleaseAll
    End
_0263:
    .short SCRCMD_UNUSED_06A
    .short 253
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_0x8004, 7
    GoToIf 5, _0286
    WaitTime 112, VAR_RESULT
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02DC
_0286:
    Return
    .balign 4, 0
_0288:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth 7
    WalkNormalEast 4
    WalkNormalNorth 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02A4:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth 7
    WalkNormalEast 3
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02C0:
    WalkNormalSouth
    WalkNormalWest 4
    WalkNormalNorth 7
    WalkNormalEast 4
    WalkNormalNorth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02DC:
    WalkNormalNorth
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02EC:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02F4:
    WalkNormalSouth 3
    WalkNormalWest 4
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0304:
    WalkNormalSouth 2
    WalkNormalWest 3
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0314:
    WalkNormalSouth 3
    WalkNormalWest 4
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0324:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_032C:
    WalkNormalWest
    WalkNormalSouth
    EmoteExclamationMark
    Delay8 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0344:
    WalkNormalSouth 6
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
