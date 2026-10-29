#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0379.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R31R0101_var_1 1
#define obj_R31R0101_tsure_poke_static_marill 2

    ScriptEntry scr_seq_R31R0101_000
    ScriptEntry scr_seq_R31R0101_001
    ScriptEntry scr_seq_R31R0101_002
    ScriptEntryEnd
scr_seq_R31R0101_001:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    End
scr_seq_R31R0101_000:
    LockAll
    Common_SetCounterpartBGM
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _028C
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    SetPosition obj_R31R0101_var_1, 10, 1, 7, DIR_WEST
    SetPosition obj_R31R0101_tsure_poke_static_marill, 10, 1, 7, DIR_WEST
    ApplyMovement obj_R31R0101_var_1, _0284
    WaitMovement
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _00C3
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _008A
    ApplyMovement obj_R31R0101_var_1, _02AC
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _02FC
    GoTo _00BD
_008A:
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _00AD
    ApplyMovement obj_R31R0101_var_1, _02BC
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0314
    GoTo _00BD
_00AD:
    ApplyMovement obj_R31R0101_var_1, _02C4
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0324
_00BD:
    GoTo _0119
_00C3:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _00E6
    ApplyMovement obj_R31R0101_var_1, _02D4
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _033C
    GoTo _0119
_00E6:
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _0109
    ApplyMovement obj_R31R0101_var_1, _02E4
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0354
    GoTo _0119
_0109:
    ApplyMovement obj_R31R0101_var_1, _02EC
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0364
_0119:
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0294
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _0138
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0294
_0138:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0379_R31R0101_00002, msg_0379_R31R0101_00003
    SetVar VAR_0x8004, ITEM_VS_RECORDER
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    MessageGendered msg_0379_R31R0101_00004, msg_0379_R31R0101_00005
    CloseMessage
    ApplyMovement obj_R31R0101_var_1, _0294
    WaitMovement
    MessageGendered msg_0379_R31R0101_00006, msg_0379_R31R0101_00007
    CloseMessage
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _02A4
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _01DA
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _01A1
    ApplyMovement obj_R31R0101_var_1, _037C
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _03EC
    GoTo _01D4
_01A1:
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _01C4
    ApplyMovement obj_R31R0101_var_1, _038C
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0404
    GoTo _01D4
_01C4:
    ApplyMovement obj_R31R0101_var_1, _03A4
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0424
_01D4:
    GoTo _0230
_01DA:
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _01FD
    ApplyMovement obj_R31R0101_var_1, _03B4
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _043C
    GoTo _0230
_01FD:
    CompareVar VAR_MAP_LOCAL_0x01, 7
    GoToIf 5, _0220
    ApplyMovement obj_R31R0101_var_1, _03C4
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0454
    GoTo _0230
_0220:
    ApplyMovement obj_R31R0101_var_1, _03DC
    ApplyMovement obj_R31R0101_tsure_poke_static_marill, _0474
_0230:
    WaitTime 16, VAR_RESULT
    ApplyMovement LOCALID_PLAYER, _029C
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 5, _0253
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _029C
_0253:
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetPosition obj_R31R0101_var_1, 12, 0, 28, DIR_NORTH
    SetPosition obj_R31R0101_tsure_poke_static_marill, 12, 0, 28, DIR_NORTH
    Common_FadeToDefaultMusic
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_4132, 1
    End
    .balign 4, 0
_0284:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_028C:
    SetInvisible
    EndMovement
    .balign 4, 0
_0294:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_029C:
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_02A4:
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_02AC:
    WalkNormalWest 2
    WalkNormalNorth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_02BC:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_02C4:
    WalkNormalWest 2
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_02D4:
    WalkNormalWest 2
    WalkNormalNorth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_02E4:
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_02EC:
    WalkNormalWest 2
    WalkNormalSouth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_02FC:
    Delay8
    SetVisible
    WalkNormalWest 2
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0314:
    Delay8
    SetVisible
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0324:
    Delay8
    SetVisible
    WalkNormalWest 2
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_033C:
    Delay8
    SetVisible
    WalkNormalWest 2
    WalkNormalNorth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0354:
    Delay8
    SetVisible
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0364:
    Delay8
    SetVisible
    WalkNormalWest 2
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_037C:
    RunSouth
    RunWest 6
    SetInvisible
    EndMovement
    .balign 4, 0
_038C:
    RunSouth
    RunWest 4
    RunNorth
    RunWest 2
    SetInvisible
    EndMovement
    .balign 4, 0
_03A4:
    RunNorth
    RunWest 6
    SetInvisible
    EndMovement
    .balign 4, 0
_03B4:
    RunSouth
    RunWest 5
    SetInvisible
    EndMovement
    .balign 4, 0
_03C4:
    RunSouth
    RunWest 3
    RunNorth
    RunWest 2
    SetInvisible
    EndMovement
    .balign 4, 0
_03DC:
    RunNorth
    RunWest 5
    SetInvisible
    EndMovement
    .balign 4, 0
_03EC:
    Delay2
    WalkFastWest
    WalkFastSouth
    WalkFastWest 6
    SetInvisible
    EndMovement
    .balign 4, 0
_0404:
    Delay2
    WalkFastWest
    WalkFastSouth
    WalkFastWest 4
    WalkFastNorth
    WalkFastWest 2
    SetInvisible
    EndMovement
    .balign 4, 0
_0424:
    Delay2
    WalkFastWest
    WalkFastNorth
    WalkFastWest 6
    SetInvisible
    EndMovement
    .balign 4, 0
_043C:
    Delay2
    WalkFastWest
    WalkFastSouth
    WalkFastWest 5
    SetInvisible
    EndMovement
    .balign 4, 0
_0454:
    Delay2
    WalkFastWest
    WalkFastSouth
    WalkFastWest 3
    WalkFastNorth
    WalkFastWest 2
    SetInvisible
    EndMovement
    .balign 4, 0
_0474:
    Delay2
    WalkFastWest
    WalkFastNorth
    WalkFastWest 5
    SetInvisible
    EndMovement
scr_seq_R31R0101_002:
    NPCMessage msg_0379_R31R0101_00000
    End
    .balign 4, 0
