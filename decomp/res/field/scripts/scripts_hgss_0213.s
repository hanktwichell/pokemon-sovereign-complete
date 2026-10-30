#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0361.h"

#define obj_R22R0101_policeman 0
#define obj_R22R0101_policeman_2 1
#define obj_R22R0101_policeman_3 2
#define obj_R22R0101_gsleader13 3

    ScriptEntry scr_seq_R22R0101_000
    ScriptEntry scr_seq_R22R0101_001
    ScriptEntry scr_seq_R22R0101_002
    ScriptEntry scr_seq_R22R0101_003
    ScriptEntry scr_seq_R22R0101_004
    ScriptEntry scr_seq_R22R0101_005
    ScriptEntry scr_seq_R22R0101_006
    ScriptEntry scr_seq_R22R0101_007
    ScriptEntry scr_seq_R22R0101_008
    ScriptEntryEnd
scr_seq_R22R0101_006:
    GoToIfUnset FLAG_HGSS_UNLOCKED_WEST_KANTO, _003D
    SetPosition obj_R22R0101_policeman_3, 15, 0, 8, DIR_SOUTH
_003D:
    GoToIfUnset FLAG_HGSS_UNLOCKED_MT_SILVER, _0054
    SetPosition obj_R22R0101_policeman_2, 7, 0, 8, DIR_SOUTH
_0054:
    End
scr_seq_R22R0101_007:
    SetFlag FLAG_HGSS_SYS_FLYPOINT_VICTORY_ROAD
    GoToIfUnset FLAG_HGSS_UNK_189, _006B
    ClearFlag FLAG_HGSS_UNK_189
    End
_006B:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JANINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00DF
    CompleteCheckBadge BADGE_ID_HGSS_SOUL, VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _009D
    GoTo _012C
    GoTo _00A3
_009D:
    GoTo _00A5
_00A3:
    End
_00A5:
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _00C0
    ClearFlag FLAG_HGSS_UNK_270
    GoTo _00DD
_00C0:
    CompareVar VAR_MAP_LOCAL_0x00, 17
    GoToIf 5, _00D7
    ClearFlag FLAG_HGSS_UNK_270
    GoTo _00DD
_00D7:
    GoTo _012C
_00DD:
    End
_00DF:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JANINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _012C
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 18
    GoToIf 5, _010D
    ClearFlag FLAG_HGSS_UNK_270
    GoTo _012A
_010D:
    CompareVar VAR_MAP_LOCAL_0x00, 19
    GoToIf 5, _0124
    ClearFlag FLAG_HGSS_UNK_270
    GoTo _012A
_0124:
    GoTo _012C
_012A:
    End
_012C:
    SetFlag FLAG_HGSS_UNK_270
    End
scr_seq_R22R0101_000:
    LockAll
    ApplyMovement obj_R22R0101_policeman, _015C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0164
    WaitMovement
    Message msg_0361_R22R0101_00000
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4110, 1
    ReleaseAll
    End
    .balign 4, 0
_015C:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0164:
    WalkOnSpotNormalWest
    EndMovement
scr_seq_R22R0101_003:
    NPCMessage msg_0361_R22R0101_00000
    End
scr_seq_R22R0101_001:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _01A4
    ApplyMovement obj_R22R0101_policeman_3, _0264
    GoTo _01AC
_01A4:
    ApplyMovement obj_R22R0101_policeman_3, _0270
_01AC:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _01C9
    ApplyMovement obj_R22R0101_policeman_3, _027C
    GoTo _01EC
_01C9:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _01E4
    ApplyMovement obj_R22R0101_policeman_3, _028C
    GoTo _01EC
_01E4:
    ApplyMovement obj_R22R0101_policeman_3, _029C
_01EC:
    WaitMovement
    Message msg_0361_R22R0101_00005
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R22R0101_policeman_3, _02AC
    ApplyMovement LOCALID_PLAYER, _02B4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    WaitTime 16, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _023A
    ApplyMovement obj_R22R0101_policeman_3, _02C4
    GoTo _025D
_023A:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _0255
    ApplyMovement obj_R22R0101_policeman_3, _02D0
    GoTo _025D
_0255:
    ApplyMovement obj_R22R0101_policeman_3, _02DC
_025D:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0264:
    WalkOnSpotNormalNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0270:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_027C:
    WalkFastEast
    WalkFastNorth
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_028C:
    WalkFastEast
    WalkFastSouth
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_029C:
    WalkFastEast
    WalkFastSouth 2
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_02AC:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_02B4:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_02C4:
    WalkNormalSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02D0:
    WalkNormalNorth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02DC:
    WalkNormalNorth 2
    WalkOnSpotNormalWest
    EndMovement
scr_seq_R22R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNLOCKED_WEST_KANTO, _0306
    Message msg_0361_R22R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0306:
    Message msg_0361_R22R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R22R0101_002:
    LockAll
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _0336
    ApplyMovement obj_R22R0101_policeman_2, _03F8
    GoTo _033E
_0336:
    ApplyMovement obj_R22R0101_policeman_2, _0404
_033E:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _035B
    ApplyMovement obj_R22R0101_policeman_2, _0410
    GoTo _037E
_035B:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _0376
    ApplyMovement obj_R22R0101_policeman_2, _0420
    GoTo _037E
_0376:
    ApplyMovement obj_R22R0101_policeman_2, _0430
_037E:
    WaitMovement
    Message msg_0361_R22R0101_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_R22R0101_policeman_2, _0440
    ApplyMovement LOCALID_PLAYER, _0448
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    WaitTime 16, VAR_RESULT
    CompareVar VAR_MAP_LOCAL_0x01, 8
    GoToIf 5, _03CC
    ApplyMovement obj_R22R0101_policeman_2, _0458
    GoTo _03EF
_03CC:
    CompareVar VAR_MAP_LOCAL_0x01, 10
    GoToIf 5, _03E7
    ApplyMovement obj_R22R0101_policeman_2, _0464
    GoTo _03EF
_03E7:
    ApplyMovement obj_R22R0101_policeman_2, _0470
_03EF:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_03F8:
    WalkOnSpotNormalNorth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0404:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0410:
    WalkFastWest
    WalkFastNorth
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_0420:
    WalkFastWest
    WalkFastSouth
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_0430:
    WalkFastWest
    WalkFastSouth 2
    WalkOnSpotFastEast
    EndMovement
    .balign 4, 0
_0440:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_0448:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0458:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0464:
    WalkNormalNorth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0470:
    WalkNormalNorth 2
    WalkOnSpotNormalEast
    EndMovement
scr_seq_R22R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNLOCKED_MT_SILVER, _049A
    Message msg_0361_R22R0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_049A:
    Message msg_0361_R22R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R22R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JANINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0553
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 4, _0548
    Message msg_0361_R22R0101_00007
_04D0:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04F4
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0537
    End
_04F4:
    BufferPlayerName 0
    Message msg_0361_R22R0101_00008
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_JANINE
    Message msg_0361_R22R0101_00009
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_270
    RemoveObject obj_R22R0101_gsleader13
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0537:
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    Message msg_0361_R22R0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0548:
    Message msg_0361_R22R0101_00011
    GoTo _04D0
    End
_0553:
    Message msg_0361_R22R0101_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05B4
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05BF
    Message msg_0361_R22R0101_00013
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 70
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0361_R22R0101_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05B4:
    Message msg_0361_R22R0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05BF:
    Message msg_0361_R22R0101_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
