#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0542.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T20_gsrivel 0
#define obj_T20_gswoman1 1
#define obj_T20_tsure_poke_static_marill 3
#define obj_T20_var_1 4
#define obj_T20_doctor 5
#define obj_T20_gsmiddleman1 6
#define obj_T20_gsmama 7
#define obj_T20_var_1_2 8
#define obj_T20_tsure_poke_static_marill_2 9

    ScriptEntry scr_seq_T20_000
    ScriptEntry scr_seq_T20_001
    ScriptEntry scr_seq_T20_002
    ScriptEntry scr_seq_T20_003
    ScriptEntry scr_seq_T20_004
    ScriptEntry scr_seq_T20_005
    ScriptEntry scr_seq_T20_006
    ScriptEntry scr_seq_T20_007
    ScriptEntry scr_seq_T20_008
    ScriptEntry scr_seq_T20_009
    ScriptEntry scr_seq_T20_010
    ScriptEntry scr_seq_T20_011
    ScriptEntry scr_seq_T20_012
    ScriptEntry scr_seq_T20_013
    ScriptEntry scr_seq_T20_014
    ScriptEntry scr_seq_T20_015
    ScriptEntry scr_seq_T20_016
    ScriptEntry scr_seq_T20_017
    ScriptEntryEnd
scr_seq_T20_006:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    GoToIfUnset FLAG_HGSS_UNK_189, _005F
    ClearFlag FLAG_HGSS_UNK_189
    End
_005F:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0089
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _008F
_0089:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_008F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T20_009:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1
    GoToIf 1, _00A4
    End
_00A4:
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    AddObject obj_T20_var_1
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    AddObject obj_T20_tsure_poke_static_marill
    SetPosition obj_T20_var_1, 686, 0, 396, DIR_WEST
    SetPosition obj_T20_tsure_poke_static_marill, 685, 0, 396, DIR_SOUTH
    End
scr_seq_T20_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0542_T20_00013
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00F8
    ApplyMovement obj_T20_gsrivel, _024C
    GoTo _0128
_00F8:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0113
    ApplyMovement obj_T20_gsrivel, _0244
    GoTo _0128
_0113:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0128
    ApplyMovement obj_T20_gsrivel, _0254
_0128:
    WaitMovement
    Message msg_0542_T20_00014
    CloseMessage
    GoToIfUnset FLAG_HGSS_GOT_STARTER, _0166
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0153
    GoTo _01BA
_014D:
    GoTo _0166
_0153:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0166
    GoTo _0192
_0166:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _017F
    GoTo _0202
_0179:
    GoTo _0192
_017F:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0192
    GoTo _01E2
_0192:
    ApplyMovement obj_T20_gsrivel, _0264
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0224
    ApplyMovement LOCALID_PLAYER, _0288
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _0274
    WaitMovement
    ReleaseAll
    End
_01BA:
    ApplyMovement obj_T20_gsrivel, _02A0
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0234
    ApplyMovement LOCALID_PLAYER, _02B8
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _0274
    WaitMovement
    ReleaseAll
    End
_01E2:
    ApplyMovement obj_T20_gsrivel, _0264
    ApplyMovement LOCALID_PLAYER, _0288
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _0274
    WaitMovement
    ReleaseAll
    End
_0202:
    ApplyMovement obj_T20_gsrivel, _02A0
    ApplyMovement LOCALID_PLAYER, _02B8
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _0274
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0224:
    LockDir
    WalkSlightlyFastSouth 4
    UnlockDir
    EndMovement
    .balign 4, 0
_0234:
    LockDir
    WalkSlightlyFastSouth 6
    UnlockDir
    EndMovement
    .balign 4, 0
_0244:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_024C:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0254:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_025C:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0264:
    WalkSlightlyFastWest
    FaceSouth
    WalkSlightlyFastSouth 2
    EndMovement
    .balign 4, 0
_0274:
    FaceNorth
    WalkNormalNorth 2
    FaceEast
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0288:
    FaceNorth
    LockDir
    WalkSlightlyFastSouth 2
    JumpFarSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_02A0:
    WalkSlightlyFastNorth
    FaceWest
    WalkSlightlyFastWest
    FaceSouth
    WalkSlightlyFastSouth 3
    EndMovement
    .balign 4, 0
_02B8:
    FaceEast
    LockDir
    WalkSlightlyFastWest
    UnlockDir
    FaceNorth
    LockDir
    WalkSlightlyFastSouth 3
    JumpFarSouth
    UnlockDir
    EndMovement
scr_seq_T20_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 0
    GoToIf 5, _02FE
    Message msg_0542_T20_00009
    GoTo _0347
_02FE:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1
    GoToIf 5, _0314
    Message msg_0542_T20_00005
    GoTo _0347
_0314:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 2
    GoToIf 5, _032A
    Message msg_0542_T20_00005
    GoTo _0347
_032A:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_WEST_EXIT, 1
    GoToIf 5, _0340
    Message msg_0542_T20_00000
    GoTo _0347
_0340:
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00006, msg_0542_T20_00007
_0347:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20_002:
    LockAll
    GoToIfSet FLAG_HGSS_GOT_POKEGEAR, _075A
    ApplyMovement obj_T20_gswoman1, _09B8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00001, msg_0542_T20_00002
    WaitTime 20, VAR_RESULT
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _09D4
    WaitMovement
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 2
    GoToIf 1, _054E
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _03AF
    ApplyMovement obj_T20_gswoman1, _0A1C
    GoTo _044B
_03AF:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _03CA
    ApplyMovement obj_T20_gswoman1, _0A2C
    GoTo _044B
_03CA:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _03E5
    ApplyMovement obj_T20_gswoman1, _0A3C
    GoTo _044B
_03E5:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0400
    ApplyMovement obj_T20_gswoman1, _0A4C
    GoTo _044B
_0400:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _041B
    ApplyMovement obj_T20_gswoman1, _0A54
    GoTo _044B
_041B:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0436
    ApplyMovement obj_T20_gswoman1, _0A64
    GoTo _044B
_0436:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _044B
    ApplyMovement obj_T20_gswoman1, _0A74
_044B:
    WaitMovement
    Message msg_0542_T20_00003
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0475
    ApplyMovement obj_T20_gswoman1, _0AEC
    ApplyMovement LOCALID_PLAYER, _0BD4
    GoTo _0541
_0475:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0498
    ApplyMovement obj_T20_gswoman1, _0B00
    ApplyMovement LOCALID_PLAYER, _0BE4
    GoTo _0541
_0498:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _04BB
    ApplyMovement obj_T20_gswoman1, _0B14
    ApplyMovement LOCALID_PLAYER, _0BF4
    GoTo _0541
_04BB:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _04DE
    ApplyMovement obj_T20_gswoman1, _0B28
    ApplyMovement LOCALID_PLAYER, _0C04
    GoTo _0541
_04DE:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0501
    ApplyMovement obj_T20_gswoman1, _0B34
    ApplyMovement LOCALID_PLAYER, _0C0C
    GoTo _0541
_0501:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0524
    ApplyMovement obj_T20_gswoman1, _0B48
    ApplyMovement LOCALID_PLAYER, _0C1C
    GoTo _0541
_0524:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0541
    ApplyMovement obj_T20_gswoman1, _0B58
    ApplyMovement LOCALID_PLAYER, _0C2C
_0541:
    WaitMovement
    Message msg_0542_T20_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_054E:
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0577
    ApplyMovement LOCALID_PLAYER, _09E8
    ApplyMovement obj_T20_gswoman1, _0A84
    GoTo _0643
_0577:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _059A
    ApplyMovement LOCALID_PLAYER, _09E8
    ApplyMovement obj_T20_gswoman1, _0A90
    GoTo _0643
_059A:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _05BD
    ApplyMovement LOCALID_PLAYER, _09E8
    ApplyMovement obj_T20_gswoman1, _0A9C
    GoTo _0643
_05BD:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _05E0
    ApplyMovement LOCALID_PLAYER, _09DC
    ApplyMovement obj_T20_gswoman1, _0AA8
    GoTo _0643
_05E0:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0603
    ApplyMovement LOCALID_PLAYER, _09DC
    ApplyMovement obj_T20_gswoman1, _0ABC
    GoTo _0643
_0603:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0626
    ApplyMovement LOCALID_PLAYER, _09DC
    ApplyMovement obj_T20_gswoman1, _0AC8
    GoTo _0643
_0626:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0643
    ApplyMovement LOCALID_PLAYER, _09DC
    ApplyMovement obj_T20_gswoman1, _0AD4
_0643:
    WaitMovement
    Message msg_0542_T20_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0677
    ApplyMovement obj_T20_gswoman1, _0B68
    ApplyMovement LOCALID_PLAYER, _0C3C
    GoTo _0743
_0677:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _069A
    ApplyMovement obj_T20_gswoman1, _0B78
    ApplyMovement LOCALID_PLAYER, _0C48
    GoTo _0743
_069A:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _06BD
    ApplyMovement obj_T20_gswoman1, _0B88
    ApplyMovement LOCALID_PLAYER, _0C54
    GoTo _0743
_06BD:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _06E0
    ApplyMovement obj_T20_gswoman1, _0B94
    ApplyMovement LOCALID_PLAYER, _0C60
    GoTo _0743
_06E0:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0703
    ApplyMovement obj_T20_gswoman1, _0BA8
    ApplyMovement LOCALID_PLAYER, _0C74
    GoTo _0743
_0703:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0726
    ApplyMovement obj_T20_gswoman1, _0BB4
    ApplyMovement LOCALID_PLAYER, _0C80
    GoTo _0743
_0726:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0743
    ApplyMovement obj_T20_gswoman1, _0BC4
    ApplyMovement LOCALID_PLAYER, _0C8C
_0743:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0542_T20_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_075A:
    @ HGSS: ScrCmd_307 21, 12, 12, 9, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    AddObject obj_T20_doctor
    SetPosition obj_T20_doctor, 684, 0, 393, DIR_SOUTH
    ApplyMovement obj_T20_doctor, _0D08
    WaitMovement
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    Message msg_0542_T20_00017
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _09C8
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _07C6
    ApplyMovement obj_T20_doctor, _0C98
    ApplyMovement LOCALID_PLAYER, _09FC
    GoTo _0892
_07C6:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _07E9
    ApplyMovement obj_T20_doctor, _0CA8
    ApplyMovement LOCALID_PLAYER, _0A0C
    GoTo _0892
_07E9:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _080C
    ApplyMovement obj_T20_doctor, _0CB8
    ApplyMovement LOCALID_PLAYER, _0A0C
    GoTo _0892
_080C:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _082F
    ApplyMovement obj_T20_doctor, _0CC8
    ApplyMovement LOCALID_PLAYER, _0A0C
    GoTo _0892
_082F:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0852
    ApplyMovement obj_T20_doctor, _0CD8
    ApplyMovement LOCALID_PLAYER, _0A0C
    GoTo _0892
_0852:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0875
    ApplyMovement obj_T20_doctor, _0CE8
    ApplyMovement LOCALID_PLAYER, _09F4
    GoTo _0892
_0875:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0892
    ApplyMovement obj_T20_doctor, _0CF8
    ApplyMovement LOCALID_PLAYER, _09F4
_0892:
    WaitMovement
    Message msg_0542_T20_00018
    @ HGSS: RegisterGearNumber PHONE_CONTACT_PROF__ELM
    BufferPlayerName 0
    Message msg_0542_T20_00019
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0542_T20_00020
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _08D5
    ApplyMovement LOCALID_PLAYER, _09D4
    ApplyMovement obj_T20_doctor, _0D18
    GoTo _0981
_08D5:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _08F8
    ApplyMovement LOCALID_PLAYER, _09D4
    ApplyMovement obj_T20_doctor, _0D24
    GoTo _0981
_08F8:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _091B
    ApplyMovement LOCALID_PLAYER, _09F4
    ApplyMovement obj_T20_doctor, _0D30
    GoTo _0981
_091B:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0936
    ApplyMovement obj_T20_doctor, _0D40
    GoTo _0981
_0936:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0951
    ApplyMovement obj_T20_doctor, _0D50
    GoTo _0981
_0951:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _096C
    ApplyMovement obj_T20_doctor, _0D60
    GoTo _0981
_096C:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0981
    ApplyMovement obj_T20_doctor, _0D70
_0981:
    WaitMovement
    @ HGSS: ScrCmd_307 21, 12, 12, 9, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_T20_doctor, _0D10
    WaitMovement
    RemoveObject obj_T20_doctor
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_WEST_EXIT, 1
    ReleaseAll
    End
    .balign 4, 0
_09B8:
    WalkOnSpotNormalWest
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_09C8:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_09D4:
    FaceEast
    EndMovement
    .balign 4, 0
_09DC:
    Delay32 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_09E8:
    Delay32 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_09F4:
    FaceNorth
    EndMovement
    .balign 4, 0
_09FC:
    FaceEast
    Delay32 2
    FaceSouth
    EndMovement
    .balign 4, 0
_0A0C:
    FaceEast
    Delay32 2
    FaceNorth
    EndMovement
    .balign 4, 0
_0A1C:
    WalkNormalWest 3
    WalkNormalNorth 3
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0A2C:
    WalkNormalWest 3
    WalkNormalNorth 2
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0A3C:
    WalkNormalWest 3
    WalkNormalNorth
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0A4C:
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_0A54:
    WalkNormalWest 3
    WalkNormalSouth
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_0A64:
    WalkNormalWest 6
    WalkNormalSouth 2
    FaceWest
    EndMovement
    .balign 4, 0
_0A74:
    WalkNormalWest 6
    WalkNormalSouth 3
    FaceWest
    EndMovement
    .balign 4, 0
_0A84:
    WalkNormalWest 7
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0A90:
    WalkNormalWest 7
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0A9C:
    WalkNormalWest 7
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0AA8:
    WalkNormalWest 3
    WalkNormalNorth
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0ABC:
    WalkNormalWest 7
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0AC8:
    WalkNormalWest 7
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0AD4:
    WalkNormalWest 7
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0AE0:
    WalkNormalEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0AEC:
    WalkNormalEast 3
    WalkNormalSouth 3
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B00:
    WalkNormalEast 3
    WalkNormalSouth 2
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B14:
    WalkNormalEast 3
    WalkNormalSouth
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B28:
    WalkNormalEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B34:
    WalkNormalEast 3
    WalkNormalNorth
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B48:
    WalkNormalNorth 2
    WalkNormalEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B58:
    WalkNormalNorth 3
    WalkNormalEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B68:
    WalkNormalSouth 2
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B78:
    WalkNormalSouth
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B88:
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B94:
    WalkNormalEast 3
    WalkNormalSouth
    WalkNormalEast 4
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BA8:
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BB4:
    WalkNormalNorth
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BC4:
    WalkNormalNorth 2
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BD4:
    WalkNormalEast 4
    WalkNormalSouth 3
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0BE4:
    WalkNormalEast 4
    WalkNormalSouth 2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0BF4:
    WalkNormalEast 4
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0C04:
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0C0C:
    WalkNormalEast 4
    WalkNormalNorth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0C1C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_0C2C:
    WalkNormalEast
    WalkNormalNorth 3
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_0C3C:
    WalkNormalSouth 3
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0C48:
    WalkNormalSouth 2
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0C54:
    WalkNormalSouth
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0C60:
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalSouth
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0C74:
    WalkNormalNorth
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0C80:
    WalkNormalNorth 2
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0C8C:
    WalkNormalNorth 3
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_0C98:
    WalkNormalSouth 3
    WalkNormalWest 8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0CA8:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CB8:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0CC8:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0CD8:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0CE8:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_0CF8:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 5
    EndMovement
    .balign 4, 0
_0D08:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0D10:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0D18:
    WalkNormalEast 8
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_0D24:
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0D30:
    WalkNormalNorth
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0D40:
    WalkNormalNorth 2
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0D50:
    WalkNormalNorth 2
    WalkNormalEast 8
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_0D60:
    WalkNormalNorth 2
    WalkNormalEast 8
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_0D70:
    WalkNormalNorth 5
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
scr_seq_T20_003:
    LockAll
    ReleaseObject obj_T20_tsure_poke_static_marill
    ApplyMovement obj_T20_tsure_poke_static_marill, _0E08
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    AddObject obj_T20_var_1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_SetCounterpartBGM
    ApplyMovement obj_T20_var_1, _0EA4
    WaitMovement
    ApplyMovement obj_T20_tsure_poke_static_marill, _0E38
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0E9C
    ApplyMovement obj_T20_var_1, _0EB8
    WaitMovement
    ApplyMovement obj_T20_tsure_poke_static_marill, _0E60
    WaitMovement
    ApplyMovement obj_T20_var_1, _0EC0
    ApplyMovement obj_T20_tsure_poke_static_marill, _0E68
    WaitMovement
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 2
    RemoveObject obj_T20_tsure_poke_static_marill
    RemoveObject obj_T20_var_1
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    ReleaseAll
    End
    .balign 4, 0
_0E08:
    Delay32
    WalkFastNorth 8
    LockDir
    JumpNearFastSouth
    UnlockDir
    FaceEast 5
    FaceNorth 5
    FaceWest 5
    FaceNorth 5
    WalkNormalNorth
    Delay32
    EndMovement
    .balign 4, 0
_0E38:
    FaceWest
    EmoteExclamationMark
    WalkOnSpotFastNorth 4
    FaceSouth 2
    FaceEast 2
    FaceNorth 2
    FaceWest 2
    WalkOnSpotFastWest 4
    WalkFastWest 6
    EndMovement
    .balign 4, 0
_0E60:
    JumpOnSpotFastWest 4
    EndMovement
    .balign 4, 0
_0E68:
    FaceWest
    WalkNormalWest
    FaceSouth
    WalkNormalSouth 4
    FaceWest
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0E84:
    FaceSouth 2
    EmoteExclamationMark
    WalkNormalSouth
    FaceWest
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_0E9C:
    FaceWest 4
    EndMovement
    .balign 4, 0
_0EA4:
    Delay16
    WalkNormalSouth 6
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0EB8:
    WalkOnSpotFastEast 4
    EndMovement
    .balign 4, 0
_0EC0:
    FaceSouth
    WalkNormalSouth 4
    FaceWest
    WalkNormalWest 2
    EndMovement
scr_seq_T20_007:
    BufferPlayerName 0
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0542_T20_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_008:
    LockAll
    Common_SetCounterpartBGM
    ApplyMovement obj_T20_var_1, _0F84
    ApplyMovement obj_T20_tsure_poke_static_marill, _0FBC
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0FE8
    ApplyMovement obj_T20_var_1, _0FF4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    @ HGSS: BufferPartyMonSpeciesNameIndef 1, 0
    MessageGendered msg_0542_T20_00015, msg_0542_T20_00016
    CloseMessage
    ApplyMovement obj_T20_var_1, _1000
    ApplyMovement obj_T20_tsure_poke_static_marill, _1014
    ApplyMovement LOCALID_PLAYER, _1038
    WaitMovement
    ApplyMovement obj_T20_var_1, _1044
    ApplyMovement obj_T20_tsure_poke_static_marill, _104C
    WaitMovement
    RemoveObject obj_T20_tsure_poke_static_marill
    RemoveObject obj_T20_var_1
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 2
    ReleaseAll
    End
    .balign 4, 0
_0F84:
    Delay4 4
    Delay4 2
    WalkOnSpotFastSouth
    Delay4 2
    WalkOnSpotFastEast
    Delay4
    WalkOnSpotFastNorth
    Delay4
    WalkOnSpotFastSouth
    Delay4
    WalkOnSpotFastNorth
    Delay4
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0FBC:
    JumpOnSpotFastEast 3
    WalkFastSouth
    WalkFastEast 2
    WalkFastNorth 2
    WalkFastWest 2
    WalkFastSouth 2
    WalkFastNorth 2
    WalkFastEast 2
    WalkFastSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0FE8:
    WalkNormalSouth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0FF4:
    Delay8
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1000:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1014:
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 2
    WalkOnSpotNormalNorth
    Delay8 3
    WalkOnSpotNormalSouth
    WalkFastSouth 4
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_1038:
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1044:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_104C:
    WalkNormalSouth 4
    EndMovement
scr_seq_T20_010:
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _1078
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1078
    @ HGSS: ScrCmd_600
_1078:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_2F, 12, 6, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_582 MAP_NEW_BARK, 688, 393
    SetVarFromValue VAR_HGSS_UNK_407C, 1
    End
    .balign 4, 0
_10B4:
    WalkNormalSouth
    EndMovement
scr_seq_T20_016:
    @ HGSS: BufferFriendsName 0
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0542_T20_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _11FC
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _1224
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _114D
    ApplyMovement LOCALID_PLAYER, _1238
    ApplyMovement obj_T20_gsmiddleman1, _1284
    GoTo _119B
_114D:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1168
    ApplyMovement LOCALID_PLAYER, _1250
    GoTo _119B
_1168:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _118B
    ApplyMovement LOCALID_PLAYER, _1270
    ApplyMovement obj_T20_gsmiddleman1, _1284
    GoTo _119B
_118B:
    ApplyMovement LOCALID_PLAYER, _125C
    ApplyMovement obj_T20_gsmiddleman1, _1284
_119B:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _11C2
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1290
    WaitMovement
_11C2:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 0
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
_11FC:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1210:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 4
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1224:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_1238:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1250:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_125C:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1270:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1284:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1290:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T20_011:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x07, 2
    GoToIf 1, _144F
    @ HGSS: ScrCmd_307 21, 12, 23, 12, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_MOM
    AddObject obj_T20_gsmama
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20_gsmama, _1478
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _12F1
    BufferPlayerName 0
    Message msg_0542_T20_00021
    CloseMessage
_12F1:
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8005, 398
    GoToIf 5, _132D
    ApplyMovement obj_T20_gsmama, _1480
    ApplyMovement LOCALID_PLAYER, _14A4
    GoTo _13A6
_132D:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1350
    ApplyMovement obj_T20_gsmama, _148C
    ApplyMovement LOCALID_PLAYER, _14B0
    GoTo _13A6
_1350:
    CompareVar VAR_0x8005, 400
    GoToIf 5, _1373
    ApplyMovement obj_T20_gsmama, _1498
    ApplyMovement LOCALID_PLAYER, _14BC
    GoTo _13A6
_1373:
    CompareVar VAR_0x8005, 401
    GoToIf 5, _1396
    ApplyMovement obj_T20_gsmama, _1498
    ApplyMovement LOCALID_PLAYER, _14C8
    GoTo _13A6
_1396:
    ApplyMovement obj_T20_gsmama, _1498
    ApplyMovement LOCALID_PLAYER, _14D8
_13A6:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _13C8
    Message msg_0542_T20_00022
    GoTo _13CB
_13C8:
    Message msg_0542_T20_00023
_13CB:
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _13EA
    ApplyMovement obj_T20_gsmama, _14E8
    WaitMovement
    GoTo _1411
_13EA:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1407
    ApplyMovement obj_T20_gsmama, _14F0
    WaitMovement
    GoTo _1411
_1407:
    ApplyMovement obj_T20_gsmama, _14F8
    WaitMovement
_1411:
    @ HGSS: ScrCmd_307 21, 12, 23, 12, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_T20_gsmama, _1500
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MOM
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20_gsmama
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    AddVar VAR_MAP_LOCAL_0x07, 1
    ReleaseAll
    End
_144F:
    Message msg_0542_T20_00024
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1508
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
    .balign 4, 0
_1478:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1480:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_148C:
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1498:
    WalkNormalSouth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_14A4:
    WalkOnSpotNormalWest
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_14B0:
    WalkOnSpotNormalWest
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_14BC:
    WalkOnSpotNormalWest
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_14C8:
    WalkNormalWest 2
    WalkNormalNorth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_14D8:
    WalkNormalWest 2
    WalkNormalNorth 2
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_14E8:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_14F0:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_14F8:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_1500:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1508:
    WalkNormalWest
    EndMovement
scr_seq_T20_012:
    LockAll
    ApplyMovement obj_T20_var_1_2, _1644
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00027, msg_0542_T20_00028
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8005, 398
    GoToIf 5, _1552
    ApplyMovement obj_T20_var_1_2, _1650
    GoTo _15AB
_1552:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _156D
    ApplyMovement obj_T20_var_1_2, _1658
    GoTo _15AB
_156D:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1588
    ApplyMovement obj_T20_var_1_2, _1660
    GoTo _15AB
_1588:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _15A3
    ApplyMovement obj_T20_var_1_2, _1668
    GoTo _15AB
_15A3:
    ApplyMovement obj_T20_var_1_2, _1670
_15AB:
    ApplyMovement LOCALID_PLAYER, _1678
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00029, msg_0542_T20_00030
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _15E3
    ApplyMovement obj_T20_var_1_2, _1680
    GoTo _163C
_15E3:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _15FE
    ApplyMovement obj_T20_var_1_2, _1688
    GoTo _163C
_15FE:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1619
    ApplyMovement obj_T20_var_1_2, _1690
    GoTo _163C
_1619:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1634
    ApplyMovement obj_T20_var_1_2, _1698
    GoTo _163C
_1634:
    ApplyMovement obj_T20_var_1_2, _16A0
_163C:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_1644:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_1650:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1658:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1660:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_1668:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1670:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1678:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_1680:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1688:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1690:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1698:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_16A0:
    WalkOnSpotNormalWest
    EndMovement
scr_seq_T20_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    MessageGendered msg_0542_T20_00025, msg_0542_T20_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MARILL, 0
    Message msg_0542_T20_00033
    WaitCry
    CloseMessage
    ApplyMovement obj_T20_tsure_poke_static_marill_2, _16F4
    WaitMovement
    ApplyMovement obj_T20_var_1_2, _1700
    WaitMovement
    MessageGendered msg_0542_T20_00031, msg_0542_T20_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_16F4:
    JumpOnSpotSlowEast
    JumpOnSpotSlowEast
    EndMovement
    .balign 4, 0
_1700:
    WalkOnSpotNormalWest
    EndMovement
scr_seq_T20_013:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0542_T20_00036, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_014:
    DrawSignpostInstantMessage msg_0542_T20_00034, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_015:
    BufferPlayerName 0
    NPCMessage msg_0542_T20_00012
    End
    .balign 4, 0
