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
    GoToIfUnset FLAG_HGSS_UNK_189, _022C
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T21_000:
    End
scr_seq_T21_001:
    LockObject obj_T21_gsoldman1
    ApplyMovement obj_T21_gsoldman1, _0AE4
    WaitMovement
    Common_SetFollowMeBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0270
    ApplyMovement obj_T21_gsoldman1, _0AEA
    GoTo _028B
scr_seq_T21_002:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0AF0
    WaitMovement
    Common_SetFollowMeBGM
    ClearFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    AddObject obj_T21_gsoldman1
    LockObject obj_T21_gsoldman1
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    SetPosition obj_T21_gsoldman1, VAR_MAP_LOCAL_0x00, 1, 394, DIR_NORTH
    CompareVar VAR_MAP_LOCAL_0x00, 549
    GoToIf 5, _02C4
    ApplyMovement obj_T21_gsoldman1, _0AFA
    GoTo _02DF
scr_seq_T21_003:
    LockAll
    FadeOutBGM 0, 3
    ApplyMovement LOCALID_PLAYER, _0AE4
    WaitMovement
    Common_SetRivalBGM
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    SetPosition obj_T21_gsrivel, 583, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_T21_gsrivel, _0B08
    WaitMovement
    Message msg_0550_T21_00013
    CloseMessage
    GetPlayerStarterSpecies VAR_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _02FC
    StartTrainerBattle TRAINER_HGSS_PASSERBY_BOY_2, 0
    GoTo _0317
scr_seq_T21_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_MYSTIC_WATER_FROM_CHERRYGROVE_CITY_MAN, _0353
    Message msg_0550_T21_00020
    SetVar VAR_0x8004, ITEM_MYSTIC_WATER
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _035E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_MYSTIC_WATER_FROM_CHERRYGROVE_CITY_MAN
    Message msg_0550_T21_00021
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
    GoToIf 1, _0369
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _037D
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0391
    ApplyMovement LOCALID_PLAYER, _0B0E
    ApplyMovement obj_T21_gsmiddleman1, _0B24
    GoTo _03AC
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
_022C:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _040D
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0413
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0413
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0413
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0270:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0419
    ApplyMovement obj_T21_gsoldman1, _0B2E
    GoTo _028B
_028B:
    ApplyMovement LOCALID_PLAYER, _0B34
    WaitMovement
    Message msg_0550_T21_00000
    CloseMessage
    BufferPlayerName 0
    SetVarFromValue VAR_HGSS_SG_6130, 2
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0434
    ApplyMovement obj_T21_gsoldman1, _0B3A
    GoTo _044F
_02C4:
    CompareVar VAR_MAP_LOCAL_0x00, 550
    GoToIf 5, _048D
    ApplyMovement obj_T21_gsoldman1, _0AFA
    GoTo _02DF
_02DF:
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 549
    GoToIf 5, _04B2
    ApplyMovement LOCALID_PLAYER, _0B54
    GoTo _04CD
_02FC:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _050D
    StartTrainerBattle TRAINER_HGSS_PASSERBY_BOY_3, 0
    GoTo _0317
_0317:
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
    GoToIf 5, _0551
    ApplyMovement LOCALID_PLAYER, _0B5A
    GoTo _0580
_0353:
    Message msg_0550_T21_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_035E:
    Message msg_0550_T21_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0369:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_037D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0391:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05A7
    ApplyMovement LOCALID_PLAYER, _0B6C
    GoTo _03AC
_03AC:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05CA
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0B76
    WaitMovement
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
_040D:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0413:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_0419:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0604
    ApplyMovement obj_T21_gsoldman1, _0B84
    GoTo _028B
_0434:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _064C
    ApplyMovement obj_T21_gsoldman1, _0B8A
    GoTo _044F
_044F:
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0B54
    WaitMovement
    Message msg_0550_T21_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0667
    ApplyMovement obj_T21_gsoldman1, _0BAC
    ApplyMovement LOCALID_PLAYER, _0BC2
    GoTo _068A
_048D:
    ApplyMovement obj_T21_gsoldman1, _0BD0
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 549
    GoToIf 5, _04B2
    ApplyMovement LOCALID_PLAYER, _0B54
    GoTo _04CD
_04B2:
    CompareVar VAR_MAP_LOCAL_0x00, 550
    GoToIf 5, _07B7
    ApplyMovement LOCALID_PLAYER, _0B54
    GoTo _04CD
_04CD:
    WaitMovement
    Message msg_0550_T21_00009
    BufferPlayerName 0
    Message msg_0550_T21_00010
    PlayFanfare SEQ_ME_KEYITEM_sseq
    WaitFanfare
    Message msg_0550_T21_00011
    Message msg_0550_T21_00012
    CloseMessage
    ApplyMovement obj_T21_gsoldman1, _0BDE
    WaitMovement
    Common_FadeToDefaultMusic3
    ReleaseObject obj_T21_gsoldman1
    RemoveObject obj_T21_gsoldman1
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    @ HGSS: RegisterPokegearCard 1
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 2
    End
_050D:
    StartTrainerBattle TRAINER_HGSS_PASSERBY_BOY, 0
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
    GoToIf 5, _0551
    ApplyMovement LOCALID_PLAYER, _0B5A
    GoTo _0580
_0551:
    ApplyMovement LOCALID_PLAYER, _0BE4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_0x8005, 398
    GoToIf 5, _07FF
    ApplyMovement obj_T21_gsrivel, _0BF6
    GoTo _0839
_0580:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_0x8005, 398
    GoToIf 5, _07FF
    ApplyMovement obj_T21_gsrivel, _0BF6
    GoTo _0839
_05A7:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _086B
    ApplyMovement LOCALID_PLAYER, _0C28
    ApplyMovement obj_T21_gsmiddleman1, _0B24
    GoTo _03AC
_05CA:
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
_0604:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _028B
    ApplyMovement obj_T21_gsoldman1, _0C42
    ApplyMovement LOCALID_PLAYER, _0B34
    WaitMovement
    Message msg_0550_T21_00000
    CloseMessage
    BufferPlayerName 0
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0434
    ApplyMovement obj_T21_gsoldman1, _0B3A
    GoTo _044F
_064C:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _08DC
    ApplyMovement obj_T21_gsoldman1, _0C48
    GoTo _044F
_0667:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _092F
    ApplyMovement obj_T21_gsoldman1, _0C6A
    ApplyMovement LOCALID_PLAYER, _0C80
    GoTo _068A
_068A:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0C8E
    ApplyMovement LOCALID_PLAYER, _0CA0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00003
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0CB2
    ApplyMovement LOCALID_PLAYER, _0CCC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00004
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0CDA
    ApplyMovement LOCALID_PLAYER, _0CF8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00005
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0D16
    ApplyMovement LOCALID_PLAYER, _0D30
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00006
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_OLD_ROD
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0550_T21_00008
    CloseMessage
    ApplyMovement obj_T21_gsoldman1, _0D46
    WaitMovement
    LoadDoorAnimation 17, 12, 14, 17, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T21_gsoldman1, _0D46
    WaitMovement
    ReleaseObject obj_T21_gsoldman1
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T21_gsoldman1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    Common_FadeToDefaultMusic3
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 1
    End
_07B7:
    ApplyMovement LOCALID_PLAYER, _0D4C
    WaitMovement
    Message msg_0550_T21_00009
    BufferPlayerName 0
    Message msg_0550_T21_00010
    PlayFanfare SEQ_ME_KEYITEM_sseq
    WaitFanfare
    Message msg_0550_T21_00011
    Message msg_0550_T21_00012
    CloseMessage
    ApplyMovement obj_T21_gsoldman1, _0BDE
    WaitMovement
    Common_FadeToDefaultMusic3
    ReleaseObject obj_T21_gsoldman1
    RemoveObject obj_T21_gsoldman1
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    @ HGSS: RegisterPokegearCard 1
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 2
    End
_07FF:
    ApplyMovement obj_T21_gsrivel, _0D52
    WaitMovement
    Message msg_0550_T21_00015
    CloseMessage
    .short SCRCMD_UNUSED_06A
    .short obj_T21_gsrivel
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_0x8005, 401
    GoToIf 5, _0952
    ApplyMovement obj_T21_gsrivel, _0D84
    ApplyMovement LOCALID_PLAYER, _0D92
    GoTo _097E
_0839:
    WaitMovement
    Message msg_0550_T21_00015
    CloseMessage
    .short SCRCMD_UNUSED_06A
    .short obj_T21_gsrivel
    .short VAR_0x8004
    .short VAR_0x8005
    CompareVar VAR_0x8005, 401
    GoToIf 5, _0952
    ApplyMovement obj_T21_gsrivel, _0D84
    ApplyMovement LOCALID_PLAYER, _0D92
    GoTo _097E
_086B:
    ApplyMovement LOCALID_PLAYER, _0D9C
    ApplyMovement obj_T21_gsmiddleman1, _0B24
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05CA
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0B76
    WaitMovement
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
_08DC:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _044F
    ApplyMovement obj_T21_gsoldman1, _0DAE
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0B54
    WaitMovement
    Message msg_0550_T21_00001
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0667
    ApplyMovement obj_T21_gsoldman1, _0BAC
    ApplyMovement LOCALID_PLAYER, _0BC2
    GoTo _068A
_092F:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _099A
    ApplyMovement obj_T21_gsoldman1, _0DD0
    ApplyMovement LOCALID_PLAYER, _0DE6
    GoTo _068A
_0952:
    ApplyMovement obj_T21_gsrivel, _0DF4
    ApplyMovement LOCALID_PLAYER, _0D92
    WaitMovement
    RemoveObject obj_T21_gsrivel
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_RIVAL
    Common_FadeToDefaultMusic2
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 4
    SetFlag FLAG_HGSS_MET_PASSERBY_BOY
    End
_097E:
    WaitMovement
    RemoveObject obj_T21_gsrivel
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_RIVAL
    Common_FadeToDefaultMusic2
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 4
    SetFlag FLAG_HGSS_MET_PASSERBY_BOY
    End
_099A:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _068A
    ApplyMovement obj_T21_gsoldman1, _0DFA
    ApplyMovement LOCALID_PLAYER, _0E10
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00002
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0C8E
    ApplyMovement LOCALID_PLAYER, _0CA0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00003
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0CB2
    ApplyMovement LOCALID_PLAYER, _0CCC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00004
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0CDA
    ApplyMovement LOCALID_PLAYER, _0CF8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00005
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T21_gsoldman1, _0D16
    ApplyMovement LOCALID_PLAYER, _0D30
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0550_T21_00006
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_OLD_ROD
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0550_T21_00008
    CloseMessage
    ApplyMovement obj_T21_gsoldman1, _0D46
    WaitMovement
    LoadDoorAnimation 17, 12, 14, 17, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T21_gsoldman1, _0D46
    WaitMovement
    ReleaseObject obj_T21_gsoldman1
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T21_gsoldman1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_CHERRYGROVE_GUIDE_GENT
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    Common_FadeToDefaultMusic3
    SetVarFromValue VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW, 1
    End
    .balign 4, 0
_0AE4:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0AEA:
    Delay4
    EndMovement
    .balign 4, 0
_0AF0:
    EmoteExclamationMark
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_0AFA:
    WalkFastWest
    WalkFastNorth 9
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0B08:
    WalkNormalWest 7
    EndMovement
    .balign 4, 0
_0B0E:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0B24:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0B2E:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0B34:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0B3A:
    WalkFastWest 2
    WalkFastNorth 2
    EmoteExclamationMark
    WalkOnSpotFastSouth
    WalkFastSouth 3
    WalkFastEast
    EndMovement
    .balign 4, 0
_0B54:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0B5A:
    FaceNorth
    LockDir
    WalkFastSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_0B6C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0B76:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0B84:
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0B8A:
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
_0BAC:
    WalkFastWest
    WalkFastNorth 3
    WalkOnSpotFastSouth
    Delay4 4
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0BC2:
    WalkNormalWest 2
    WalkNormalNorth 2
    Delay8
    EndMovement
    .balign 4, 0
_0BD0:
    WalkFastEast
    WalkFastNorth 9
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BDE:
    WalkFastSouth 9
    EndMovement
    .balign 4, 0
_0BE4:
    FaceSouth
    LockDir
    WalkFastNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_0BF6:
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
_0C28:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C42:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0C48:
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
_0C6A:
    WalkFastWest
    WalkFastNorth 4
    WalkOnSpotFastSouth
    Delay4 5
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0C80:
    WalkNormalWest 2
    WalkNormalNorth 3
    Delay8
    EndMovement
    .balign 4, 0
_0C8E:
    WalkFastWest 9
    WalkOnSpotFastEast
    Delay4 7
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0CA0:
    WalkNormalNorth
    WalkNormalWest 8
    Delay8 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0CB2:
    WalkFastWest 6
    WalkFastNorth 2
    WalkFastWest
    WalkOnSpotFastEast
    Delay4 7
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0CCC:
    WalkNormalWest 7
    WalkNormalNorth 2
    Delay8
    EndMovement
    .balign 4, 0
_0CDA:
    WalkFastSouth 2
    WalkFastWest 6
    WalkFastSouth 8
    WalkNormalWest 6
    WalkOnSpotFastNorth
    Delay4 17
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_0CF8:
    WalkNormalWest
    WalkNormalSouth 2
    WalkNormalWest 6
    WalkNormalSouth 7
    WalkNormalWest 6
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0D16:
    WalkFastEast 16
    WalkOnSpotFastWest
    Delay4 6
    WalkFastSouth 2
    WalkFastEast 6
    WalkOnSpotFastWest
    EndMovement
    .balign 4, 0
_0D30:
    Delay4
    WalkNormalSouth
    WalkNormalEast 16
    WalkNormalSouth 2
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_0D46:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0D4C:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0D52:
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
_0D84:
    WalkNormalWest 5
    WalkNormalNorth
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_0D92:
    Delay8 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0D9C:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0DAE:
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
_0DD0:
    WalkFastWest
    WalkFastNorth 5
    WalkOnSpotFastSouth
    Delay4 6
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0DE6:
    WalkNormalWest 2
    WalkNormalNorth 4
    Delay8
    EndMovement
    .balign 4, 0
_0DF4:
    WalkNormalWest 11
    EndMovement
    .balign 4, 0
_0DFA:
    WalkFastWest
    WalkFastNorth 6
    WalkOnSpotFastSouth
    Delay4 9
    WalkOnSpotFastNorth
    EndMovement
    .balign 4, 0
_0E10:
    WalkNormalWest 2
    WalkNormalNorth 5
    Delay8
    EndMovement
    .balign 4, 0
