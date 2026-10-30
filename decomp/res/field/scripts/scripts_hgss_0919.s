#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0611.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T26R0701_gsmiddleman1 3
#define obj_T26R0701_gsleader6 4

    ScriptEntry scr_seq_T26R0701_000
    ScriptEntry scr_seq_T26R0701_001
    ScriptEntry scr_seq_T26R0701_002
    ScriptEntry scr_seq_T26R0701_003
    ScriptEntry scr_seq_T26R0701_004
    ScriptEntry scr_seq_T26R0701_005
    ScriptEntry scr_seq_T26R0701_006
    ScriptEntry scr_seq_T26R0701_007
    ScriptEntryEnd
scr_seq_T26R0701_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _017F
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T26R0701_006:
    NPCMessage msg_0611_T26R0701_00000
    End
scr_seq_T26R0701_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0611_T26R0701_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T26R0701_001:
    NPCMessage msg_0611_T26R0701_00002
    End
scr_seq_T26R0701_002:
    NPCMessage msg_0611_T26R0701_00003
    End
scr_seq_T26R0701_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _019A
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01AE
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01C2
    ApplyMovement LOCALID_PLAYER, _04F4
    ApplyMovement obj_T26R0701_gsmiddleman1, _050A
    GoTo _01DD
scr_seq_T26R0701_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _023E
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _029F
    Message msg_0611_T26R0701_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02A8
    CompareVar VAR_RESULT, 1
    GoToIf 4, _02EB
    End
scr_seq_T26R0701_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_GOOD_ROD, _049B
    Message msg_0611_T26R0701_00014
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04A6
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04DF
    End
_017F:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _02FC
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0339
_019A:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AE:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C2:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0372
    ApplyMovement LOCALID_PLAYER, _0514
    GoTo _01DD
_01DD:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03E3
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _051E
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 25
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
_023E:
    Message msg_0611_T26R0701_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _041D
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0428
    Message msg_0611_T26R0701_00010
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 89
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0611_T26R0701_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_029F:
    Message msg_0611_T26R0701_00008
    GoTo _0433
_02A8:
    BufferPlayerName 0
    Message msg_0611_T26R0701_00005
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_JASMINE
    Message msg_0611_T26R0701_00006
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_2CB
    RemoveObject obj_T26R0701_gsleader6
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_02EB:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0611_T26R0701_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02FC:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _0457
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _045D
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _048B
    ClearFlag FLAG_HGSS_UNK_2CB
    GoTo _0491
_0339:
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _0457
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _045D
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _048B
    ClearFlag FLAG_HGSS_UNK_2CB
    GoTo _0491
_0372:
    ApplyMovement LOCALID_PLAYER, _052C
    ApplyMovement obj_T26R0701_gsmiddleman1, _050A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03E3
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _051E
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 25
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
_03E3:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 25
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
_041D:
    Message msg_0611_T26R0701_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0428:
    Message msg_0611_T26R0701_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0433:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02A8
    CompareVar VAR_RESULT, 1
    GoToIf 4, _02EB
    End
_0457:
    SetFlag FLAG_HGSS_UNK_2CB
    End
_045D:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0457
    GetHour VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _0493
    ClearFlag FLAG_HGSS_UNK_2CB
    GoTo _0499
_048B:
    GoTo _0457
_0491:
    End
_0493:
    SetFlag FLAG_HGSS_UNK_2CB
    End
_0499:
    End
_049B:
    Message msg_0611_T26R0701_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A6:
    SetVar VAR_0x8004, ITEM_GOOD_ROD
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _04EA
    Message msg_0611_T26R0701_00015
    WaitButton
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_GOOD_ROD
    Message msg_0611_T26R0701_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04DF:
    Message msg_0611_T26R0701_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04EA:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_04F4:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_050A:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0514:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_051E:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_052C:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
