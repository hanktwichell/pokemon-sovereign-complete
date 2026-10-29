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
    ScriptEntryEnd
scr_seq_T26R0701_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _002F
    ClearFlag FLAG_HGSS_UNK_189
    End
_002F:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _004A
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _004E
_004A:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_004E:
    GoToIfUnset FLAG_HGSS_GAME_CLEAR, _00C3
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _008F
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 13
    GoToIf 5, _0087
    ClearFlag FLAG_HGSS_UNK_2CB
    GoTo _008D
_0087:
    GoTo _00C3
_008D:
    End
_008F:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00C3
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 12
    GoToIf 5, _00BD
    ClearFlag FLAG_HGSS_UNK_2CB
    GoTo _00C1
_00BD:
    SetFlag FLAG_HGSS_UNK_2CB
_00C1:
    End
_00C3:
    SetFlag FLAG_HGSS_UNK_2CB
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
    GoToIf 1, _025E
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0272
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _018C
    ApplyMovement LOCALID_PLAYER, _0288
    ApplyMovement obj_T26R0701_gsmiddleman1, _02C0
    GoTo _01B7
_018C:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01A7
    ApplyMovement LOCALID_PLAYER, _02A0
    GoTo _01B7
_01A7:
    ApplyMovement LOCALID_PLAYER, _02AC
    ApplyMovement obj_T26R0701_gsmiddleman1, _02C0
_01B7:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01DE
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _02CC
    WaitMovement
_01DE:
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
_0218:
    GetPlayerDir VAR_RESULT
    CompareVarToValue VAR_RESULT, 0
    GoToIf 5, _0237
    ApplyMovement LOCALID_PLAYER, _0288
    GoTo _025A
_0237:
    CompareVarToValue VAR_RESULT, 1
    GoToIf 5, _0252
    ApplyMovement LOCALID_PLAYER, _02A0
    GoTo _025A
_0252:
    ApplyMovement LOCALID_PLAYER, _02AC
_025A:
    WaitMovement
    Return
_025E:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0272:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0288:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02A0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02AC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02C0:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_02CC:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T26R0701_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_JASMINE, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _038A
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _037F
    Message msg_0611_T26R0701_00004
_0307:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _032B
    CompareVar VAR_RESULT, 1
    GoToIf 4, _036E
    End
_032B:
    BufferPlayerName 0
    Message msg_0611_T26R0701_00005
    PlayFanfare SEQ_FANFA4_sseq
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
_036E:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0611_T26R0701_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_037F:
    Message msg_0611_T26R0701_00008
    GoTo _0307
    End
_038A:
    Message msg_0611_T26R0701_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03EB
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03F6
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
_03EB:
    Message msg_0611_T26R0701_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03F6:
    Message msg_0611_T26R0701_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
