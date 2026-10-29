#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0550.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T21_gsoldman1 0
#define obj_T21_gsrivel 4
#define obj_T21_gsmiddleman1 5

    ScriptEntry scr_seq_T21_000
    ScriptEntry scr_seq_T21_001
    ScriptEntry scr_seq_T21_002
    ScriptEntry scr_seq_T21_003
    ScriptEntry scr_seq_T21_004
    ScriptEntry scr_seq_T21_005
    ScriptEntry scr_seq_T21_006
    ScriptEntry scr_seq_T21_007
    ScriptEntry scr_seq_T21_008
    ScriptEntry scr_seq_T21_009
    ScriptEntry scr_seq_T21_010
    ScriptEntryEnd
scr_seq_T21_010:
    GoToIfUnset FLAG_HGSS_UNK_189, _003F
    ClearFlag FLAG_HGSS_UNK_189
    End
_003F:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _007D
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0083
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0083
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0083
_007D:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0083:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T21_000:
    End
scr_seq_T21_001:
    LockObject obj_T21_gsoldman1
    ApplyMovement obj_T21_gsoldman1, _0350
    WaitMovement
    Common_SetFollowMeBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _00BE
    ApplyMovement obj_T21_gsoldman1, _0358
    GoTo _0109
_00BE:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _00D9
    ApplyMovement obj_T21_gsoldman1, _0360
    GoTo _0109
_00D9:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _00F4
    ApplyMovement obj_T21_gsoldman1, _0368
    GoTo _0109
_00F4:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0109
    ApplyMovement obj_T21_gsoldman1, _0370
_0109:
    ApplyMovement LOCALID_PLAYER, _0378
    WaitMovement
    Message msg_0550_T21_00000
    CloseMessage
    BufferPlayerName 0
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _013C
    ApplyMovement obj_T21_gsoldman1, _0390
    GoTo _0187
_013C:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0157
    ApplyMovement obj_T21_gsoldman1, _03AC
    GoTo _0187
_0157:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0172
    ApplyMovement obj_T21_gsoldman1, _03D0
    GoTo _0187
_0172:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0187
    ApplyMovement obj_T21_gsoldman1, _03F4
_0187:
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0380
    WaitMovement
    Message msg_0550_T21_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _01C5
    ApplyMovement obj_T21_gsoldman1, _0418
    ApplyMovement LOCALID_PLAYER, _0478
    GoTo _0228
_01C5:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _01E8
    ApplyMovement obj_T21_gsoldman1, _0430
    ApplyMovement LOCALID_PLAYER, _0488
    GoTo _0228
_01E8:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _020B
    ApplyMovement obj_T21_gsoldman1, _0448
    ApplyMovement LOCALID_PLAYER, _0498
    GoTo _0228
_020B:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0228
    ApplyMovement obj_T21_gsoldman1, _0460
    ApplyMovement LOCALID_PLAYER, _04A8
_0228:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _04B8
    ApplyMovement LOCALID_PLAYER, _04CC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00003
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _04E0
    ApplyMovement LOCALID_PLAYER, _04FC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00004
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _050C
    ApplyMovement LOCALID_PLAYER, _052C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00005
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _054C
    ApplyMovement LOCALID_PLAYER, _0568
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00006
    GiveRunningShoes
    BufferPlayerName 0
    Message msg_0550_T21_00007
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0550_T21_00008
    CloseMessage
    ApplyMovement obj_T21_gsoldman1, _0580
    WaitMovement
    @ HGSS: ScrCmd_307 17, 12, 14, 17, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_T21_gsoldman1, _0580
    WaitMovement
    ReleaseObject obj_T21_gsoldman1
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T21_gsoldman1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    Common_FadeToDefaultMusic3
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 1
    End
    .balign 4, 0
_0350:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0358:
    Delay4
    EndMovement
    .balign 4, 0
_0360:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0368:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0370:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0378:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0380:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0388:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0390:
    WalkFastWest 2
    WalkFastNorth 2
    EmoteExclamationMark
    WalkOnSpotFastSouth
    WalkFastSouth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_03AC:
    WalkFastWest 2
    WalkFastNorth 3
    Delay8
    WalkOnSpotFastSouth
    Delay32
    EmoteExclamationMark
    WalkFastSouth 4
    WalkFastEast
    EndMovement
    .balign 4, 0
_03D0:
    WalkFastWest 2
    WalkFastNorth 4
    Delay8
    WalkOnSpotFastSouth
    Delay32
    EmoteExclamationMark
    WalkFastSouth 5
    WalkFastEast
    EndMovement
    .balign 4, 0
_03F4:
    WalkFastWest 2
    WalkFastNorth 4
    Delay8
    WalkOnSpotFastSouth
    Delay32
    EmoteExclamationMark
    WalkFastSouth 5
    WalkFastEast
    EndMovement
    .balign 4, 0
_0418:
    WalkFastWest
    WalkFastNorth 3
    WalkOnSpotFastSouth
    Delay4 4
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0430:
    WalkFastWest
    WalkFastNorth 4
    WalkOnSpotFastSouth
    Delay4 5
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0448:
    WalkFastWest
    WalkFastNorth 5
    WalkOnSpotFastSouth
    Delay4 6
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0460:
    WalkFastWest
    WalkFastNorth 6
    WalkOnSpotFastSouth
    Delay4 9
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0478:
    WalkNormalWest 2
    WalkNormalNorth 2
    Delay8
    EndMovement
    .balign 4, 0
_0488:
    WalkNormalWest 2
    WalkNormalNorth 3
    Delay8
    EndMovement
    .balign 4, 0
_0498:
    WalkNormalWest 2
    WalkNormalNorth 4
    Delay8
    EndMovement
    .balign 4, 0
_04A8:
    WalkNormalWest 2
    WalkNormalNorth 5
    Delay8
    EndMovement
    .balign 4, 0
_04B8:
    WalkFastWest 9
    WalkOnSpotFastEast
    Delay4 7
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_04CC:
    WalkNormalNorth
    WalkNormalWest 8
    Delay8 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_04E0:
    WalkFastWest 6
    WalkFastNorth 2
    WalkFastWest
    WalkOnSpotFastEast
    Delay4 7
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_04FC:
    WalkNormalWest 7
    WalkNormalNorth 2
    Delay8
    EndMovement
    .balign 4, 0
_050C:
    WalkFastSouth 2
    WalkFastWest 6
    WalkFastSouth 8
    WalkNormalWest 6
    WalkOnSpotFastNorth
    Delay4 17
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_052C:
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest 6
    WalkNormalSouth 7
    WalkNormalWest 6
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_054C:
    WalkFastEast 16
    WalkOnSpotFastWest
    Delay4 6
    WalkFastSouth 2
    WalkFastEast 6
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_0568:
    Delay4
    WalkNormalSouth
    WalkNormalEast 16
    WalkNormalSouth 2
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_0580:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0588:
    WalkNormalNorth
    EndMovement
scr_seq_T21_002:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0680
    WaitMovement
    Common_SetFollowMeBGM
    ClearFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    AddObject obj_T21_gsoldman1
    LockObject obj_T21_gsoldman1
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    SetPosition obj_T21_gsoldman1, VAR_MAP_LOCAL_0x00, 1, 394, DIR_NORTH
    CompareVar VAR_MAP_LOCAL_0x00, 549
    GoToIf 5, _05DB
    ApplyMovement obj_T21_gsoldman1, _068C
    GoTo _05FE
_05DB:
    CompareVar VAR_MAP_LOCAL_0x00, 550
    GoToIf 5, _05F6
    ApplyMovement obj_T21_gsoldman1, _068C
    GoTo _05FE
_05F6:
    ApplyMovement obj_T21_gsoldman1, _069C
_05FE:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 549
    GoToIf 5, _061B
    ApplyMovement LOCALID_PLAYER, _0380
    GoTo _063E
_061B:
    CompareVar VAR_MAP_LOCAL_0x00, 550
    GoToIf 5, _0636
    ApplyMovement LOCALID_PLAYER, _0380
    GoTo _063E
_0636:
    ApplyMovement LOCALID_PLAYER, _0388
_063E:
    WaitMovement
    Message msg_0550_T21_00009
    BufferPlayerName 0
    Message msg_0550_T21_00010
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0550_T21_00011
    Message msg_0550_T21_00012
    CloseMessage
    ApplyMovement obj_T21_gsoldman1, _06AC
    WaitMovement
    Common_FadeToDefaultMusic3
    ReleaseObject obj_T21_gsoldman1
    RemoveObject obj_T21_gsoldman1
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    @ HGSS: RegisterPokegearCard 1
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 2
    End
    .balign 4, 0
_0680:
    EmoteExclamationMark
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_068C:
    WalkFastWest
    WalkFastNorth 9
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_069C:
    WalkFastEast
    WalkFastNorth 9
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_06AC:
    WalkFastSouth 9
    EndMovement
scr_seq_T21_003:
    LockAll
    FadeOutBGM 0, 3
    ApplyMovement LOCALID_PLAYER, _0350
    WaitMovement
    Common_SetRivalBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    SetPosition obj_T21_gsrivel, 583, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_T21_gsrivel, _0808
    WaitMovement
    Message msg_0550_T21_00013
    CloseMessage
    @ HGSS: GetStarterChoice VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _070C
    @ HGSS: TrainerBattle TRAINER_PASSERBY_BOY_2, 0, 1, 0
    GoTo _072F
_070C:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _0727
    @ HGSS: TrainerBattle TRAINER_PASSERBY_BOY_3, 0, 1, 0
    GoTo _072F
_0727:
    @ HGSS: TrainerBattle TRAINER_PASSERBY_BOY, 0, 1, 0
_072F:
    CheckWonBattle VAR_RESULT
    Common_SetRivalBGM
    Message msg_0550_T21_00014
    CloseMessage
    PlaySE SEQ_SE_DP_WALL_HIT2_sseq
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompareVar VAR_0x8005, 398
    GoToIf 5, _076B
    ApplyMovement LOCALID_PLAYER, _0890
    GoTo _0773
_076B:
    ApplyMovement LOCALID_PLAYER, _08A4
_0773:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_0x8005, 398
    GoToIf 5, _079A
    ApplyMovement obj_T21_gsrivel, _0810
    GoTo _07A2
_079A:
    ApplyMovement obj_T21_gsrivel, _0844
_07A2:
    WaitMovement
    Message msg_0550_T21_00015
    CloseMessage
    .short SCRCMD_UNUSED_06A
    .short 4
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_0x8005, 401
    GoToIf 5, _07D4
    ApplyMovement obj_T21_gsrivel, _0880
    ApplyMovement LOCALID_PLAYER, _08B8
    GoTo _07E4
_07D4:
    ApplyMovement obj_T21_gsrivel, _0878
    ApplyMovement LOCALID_PLAYER, _08B8
_07E4:
    WaitMovement
    RemoveObject obj_T21_gsrivel
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_RIVAL
    Common_FadeToDefaultMusic2
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 4
    SetFlag FLAG_HGSS_MET_PASSERBY_BOY
    End
_0800:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0808:
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0810:
    WalkNormalWest 6
    EmoteExclamationMark
    WalkOnSpotFastSouth
    Delay8
    WalkOnSpotFastNorth
    Delay8
    WalkOnSpotFastSouth
    Delay8
    WalkOnSpotNormalEast
    Delay8
    WalkNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0844:
    WalkNormalWest 6
    EmoteExclamationMark
    WalkOnSpotFastSouth
    Delay8
    WalkOnSpotFastNorth
    Delay8
    WalkOnSpotFastSouth
    Delay8
    WalkOnSpotNormalEast
    Delay8
    WalkNormalEast 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0878:
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0880:
    WalkNormalWest 5
    WalkNormalNorth
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_0890:
    FaceNorth
    LockDir
    WalkFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_08A4:
    FaceSouth
    LockDir
    WalkFastNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_08B8:
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
scr_seq_T21_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_MYSTIC_WATER_FROM_CHERRYGROVE_CITY_MAN, _0903
    Message msg_0550_T21_00020
    SetVar VAR_0x8004, ITEM_MYSTIC_WATER
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _090E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_MYSTIC_WATER_FROM_CHERRYGROVE_CITY_MAN
_0903:
    Message msg_0550_T21_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_090E:
    Message msg_0550_T21_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T21_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A41
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A55
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0992
    ApplyMovement LOCALID_PLAYER, _0A6C
    ApplyMovement obj_T21_gsmiddleman1, _0AC0
    GoTo _09E0
_0992:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _09AD
    ApplyMovement LOCALID_PLAYER, _0A84
    GoTo _09E0
_09AD:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _09D0
    ApplyMovement LOCALID_PLAYER, _0AA4
    ApplyMovement obj_T21_gsmiddleman1, _0AC0
    GoTo _09E0
_09D0:
    ApplyMovement LOCALID_PLAYER, _0A90
    ApplyMovement obj_T21_gsmiddleman1, _0AC0
_09E0:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0A07
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0ACC
    WaitMovement
_0A07:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 1
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
_0A41:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0A55:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0A6C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0A84:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0A90:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0AA4:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0AC0:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0ACC:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T21_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0550_T21_00024, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T21_006:
    DrawSignpostInstantMessage msg_0550_T21_00023, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T21_007:
    NPCMessage msg_0550_T21_00019
    End
scr_seq_T21_008:
    NPCMessage msg_0550_T21_00017
    End
    .balign 4, 0
