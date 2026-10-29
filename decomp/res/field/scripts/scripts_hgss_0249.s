#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0396.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R39_gsgentleman 8
#define obj_R39_gsmiddleman1_2 11

    ScriptEntry scr_seq_R39_000
    ScriptEntry scr_seq_R39_001
    ScriptEntry scr_seq_R39_002
    ScriptEntry scr_seq_R39_003
    ScriptEntry scr_seq_R39_004
    ScriptEntry scr_seq_R39_005
    ScriptEntry scr_seq_R39_006
    ScriptEntry scr_seq_R39_007
    ScriptEntry scr_seq_R39_008
    ScriptEntryEnd
scr_seq_R39_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _01D8
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_R39_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MILTANK, 0
    Message msg_0396_R39_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R39_002:
    LockAll
    ApplyMovement obj_R39_gsgentleman, _0778
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 171
    GoToIf 5, _0200
    ApplyMovement obj_R39_gsgentleman, _0782
    GoTo _021B
scr_seq_R39_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0271
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0285
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0299
    ApplyMovement LOCALID_PLAYER, _078C
    ApplyMovement obj_R39_gsmiddleman1_2, _07A2
    GoTo _02B4
scr_seq_R39_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0396_R39_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0315
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0320
    Message msg_0396_R39_00011
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 80
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0396_R39_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R39_003:
    DrawSignpostInstantMessage msg_0396_R39_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R39_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0396_R39_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R39_005:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0396_R39_00002, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R39_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    GoToIfSet FLAG_HGSS_SG_3FA3, _032B
    Message msg_0396_R39_00015
    CloseMessage
    ApplyMovement 13, _07AC
    WaitMovement
    FacePlayer
    Message msg_0396_R39_00016
    Message msg_0396_R39_00017
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_SG_3FA3
    ReleaseAll
    End
_01D8:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _034F
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _034F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _037B
_0200:
    CompareVar VAR_MAP_LOCAL_0x01, 172
    GoToIf 5, _03A3
    ApplyMovement obj_R39_gsgentleman, _07B2
    GoTo _021B
_021B:
    WaitMovement
    Message msg_0396_R39_00004
    Message msg_0396_R39_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0401
    Message msg_0396_R39_00006
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BAOBA
    BufferPlayerName 0
    Message msg_0396_R39_00008
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0396_R39_00009
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 171
    GoToIf 5, _0422
    ApplyMovement obj_R39_gsgentleman, _07B8
    GoTo _043D
_0271:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0285:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0299:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0451
    ApplyMovement LOCALID_PLAYER, _07C6
    GoTo _02B4
_02B4:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0474
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07D0
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 28
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
_0315:
    Message msg_0396_R39_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0320:
    Message msg_0396_R39_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_032B:
    FacePlayer
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 182
    GoToIf 1, _04AE
    Message msg_0396_R39_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_034F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _04D1
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _04D1
    ClearFlag FLAG_HGSS_UNK_226
    GoTo _050E
_037B:
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _04D1
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _04D1
    ClearFlag FLAG_HGSS_UNK_226
    GoTo _050E
_03A3:
    ApplyMovement obj_R39_gsgentleman, _07DE
    WaitMovement
    Message msg_0396_R39_00004
    Message msg_0396_R39_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0401
    Message msg_0396_R39_00006
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BAOBA
    BufferPlayerName 0
    Message msg_0396_R39_00008
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0396_R39_00009
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 171
    GoToIf 5, _0422
    ApplyMovement obj_R39_gsgentleman, _07B8
    GoTo _043D
_0401:
    Message msg_0396_R39_00007
    Message msg_0396_R39_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0401
    GoTo _0547
_0422:
    CompareVar VAR_MAP_LOCAL_0x01, 172
    GoToIf 5, _0580
    ApplyMovement obj_R39_gsgentleman, _07E8
    GoTo _043D
_043D:
    WaitMovement
    RemoveObject obj_R39_gsgentleman
    SetFlag FLAG_HGSS_UNK_228
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_408F, 1
    End
_0451:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _059C
    ApplyMovement LOCALID_PLAYER, _07F6
    ApplyMovement obj_R39_gsmiddleman1_2, _07A2
    GoTo _02B4
_0474:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 28
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
_04AE:
    Message msg_0396_R39_00018
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _060D
    Message msg_0396_R39_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04D1:
    SetFlag FLAG_HGSS_UNK_226
    GoToIfUnset FLAG_HGSS_TRADE_LT_SURGE_PIKACHU, _0661
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0661
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0667
    ClearFlag FLAG_HGSS_HIDE_ROUTE_39_LT_SURGE
    GoTo _067E
_050E:
    GoToIfUnset FLAG_HGSS_TRADE_LT_SURGE_PIKACHU, _0661
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0661
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0667
    ClearFlag FLAG_HGSS_HIDE_ROUTE_39_LT_SURGE
    GoTo _067E
_0547:
    Message msg_0396_R39_00006
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BAOBA
    BufferPlayerName 0
    Message msg_0396_R39_00008
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0396_R39_00009
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 171
    GoToIf 5, _0422
    ApplyMovement obj_R39_gsgentleman, _07B8
    GoTo _043D
_0580:
    ApplyMovement obj_R39_gsgentleman, _0808
    WaitMovement
    RemoveObject obj_R39_gsgentleman
    SetFlag FLAG_HGSS_UNK_228
    ReleaseAll
    SetVarFromValue VAR_HGSS_UNK_408F, 1
    End
_059C:
    ApplyMovement LOCALID_PLAYER, _0816
    ApplyMovement obj_R39_gsmiddleman1_2, _07A2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0474
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _07D0
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 28
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
_060D:
    Message msg_0396_R39_00020
    CloseMessage
    PlayCry SPECIES_BELLOSSOM, 6
    WaitCry
    BufferPlayerName 0
    ApplyMovement 13, _0828
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0680
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 2
    GoToIf 1, _069A
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _082E
    WaitMovement
    GoTo _06B4
_0661:
    SetFlag FLAG_HGSS_HIDE_ROUTE_39_LT_SURGE
    End
_0667:
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _0772
    ClearFlag FLAG_HGSS_HIDE_ROUTE_39_LT_SURGE
    GoTo _067E
_067E:
    End
_0680:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _083C
    WaitMovement
    GoTo _06B4
_069A:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0846
    WaitMovement
    GoTo _06B4
_06B4:
    LockAll
    ReleaseObject LOCALID_COMPLETE_FOLLOWER
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0854
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _0862
    FadeOutBGM 0, 50
    PlayMusic SEQ_TOWN01_D_sseq
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0868
    WaitMovement
    PlayCry SPECIES_BELLOSSOM, 0
    WaitCry
    FadeOutBGM 0, 50
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0922
    ApplyMovement 13, _092C
    ApplyMovement LOCALID_PLAYER, _0936
    WaitMovement
    PlayMusic SEQ_ROAD_A_D_sseq
    ApplyMovement 241, _093C
    WaitMovement
    RestoreCamera
    LockAll
    Message msg_0396_R39_00021
    SetVar VAR_0x8004, ITEM_TM53
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    ApplyMovement 13, _07AC
    Message msg_0396_R39_00022
    WaitMovement
    Message msg_0396_R39_00023
    SetVar VAR_0x8004, ITEM_MEADOW_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0396_R39_00024
    WaitButton
    CloseMessage
    ApplyMovement 13, _0942
    WaitMovement
    RemoveObject 13
    ReleaseAll
    End
_0772:
    GoTo _0661
    .balign 4, 0
_0778:
    EmoteExclamationMark
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0782:
    WalkNormalNorth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_078C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_07A2:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07AC:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_07B2:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_07B8:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 9
    EndMovement
    .balign 4, 0
_07C6:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_07D0:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_07DE:
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_07E8:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 8
    EndMovement
    .balign 4, 0
_07F6:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0808:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_0816:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0828:
    FaceSouth
    EndMovement
    .balign 4, 0
_082E:
    WalkNormalSouth
    WalkNormalWest 2
    FaceSouth
    EndMovement
    .balign 4, 0
_083C:
    WalkNormalWest 3
    FaceSouth
    EndMovement
    .balign 4, 0
_0846:
    WalkNormalSouth
    WalkNormalWest 4
    FaceSouth
    EndMovement
    .balign 4, 0
_0854:
    WalkNormalSouth
    WalkNormalWest
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_0862:
    WalkSlightlyFastSouth 3
    EndMovement
    .balign 4, 0
_0868:
    WalkNormalWest
    FaceSouth
    JumpOnSpotFastSouth
    WalkNormalEast 2
    FaceSouth
    JumpOnSpotFastSouth
    WalkNormalWest
    FaceSouth
    JumpOnSpotFastSouth 2
    FaceWest
    Delay1
    WalkOnSpotNormalWest
    FaceNorth
    Delay1
    WalkOnSpotNormalNorth
    FaceEast
    Delay1
    WalkOnSpotNormalEast
    FaceSouth
    Delay1
    WalkOnSpotNormalSouth
    FaceWest
    Delay1
    WalkOnSpotNormalWest
    FaceNorth
    Delay1
    WalkOnSpotNormalNorth
    FaceEast
    Delay1
    WalkOnSpotNormalEast
    FaceSouth
    Delay1
    WalkOnSpotNormalSouth
    FaceWest
    Delay1
    WalkOnSpotNormalWest
    FaceNorth
    Delay1
    WalkOnSpotNormalNorth
    FaceEast
    Delay1
    WalkOnSpotNormalEast
    FaceSouth
    Delay1
    WalkOnSpotNormalSouth
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_0922:
    WalkNormalNorth 2
    FaceEast
    EndMovement
    .balign 4, 0
_092C:
    WalkNormalSouth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0936:
    FaceEast
    EndMovement
    .balign 4, 0
_093C:
    WalkSlightlyFastNorth 3
    EndMovement
    .balign 4, 0
_0942:
    WalkNormalNorth
    WalkNormalWest 2
    WalkNormalNorth 10
    EndMovement
    .balign 4, 0
