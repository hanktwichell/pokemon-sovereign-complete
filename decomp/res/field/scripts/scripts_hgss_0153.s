#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0256.h"

#define obj_P01R0102_seaman_2 0
#define obj_P01R0102_gswoman2 2
#define obj_P01R0102_gsleader10 3

    ScriptEntry scr_seq_P01R0102_000
    ScriptEntry scr_seq_P01R0102_001
    ScriptEntry scr_seq_P01R0102_002
    ScriptEntry scr_seq_P01R0102_003
    ScriptEntry scr_seq_P01R0102_004
    ScriptEntry scr_seq_P01R0102_005
    ScriptEntry scr_seq_P01R0102_006
    ScriptEntryEnd
scr_seq_P01R0102_001:
    CompareVar VAR_HGSS_BOAT_DIRECTION, 2
    GoToIf 1, _002D
    End
_002D:
    SetPosition obj_P01R0102_seaman_2, 28, 0, 22, DIR_WEST
    End
scr_seq_P01R0102_005:
    @ HGSS: ScrCmd_582 MAP_OLIVINE, 279, 276
    GoToIfUnset FLAG_HGSS_UNK_189, _0054
    ClearFlag FLAG_HGSS_UNK_189
    End
_0054:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_SABRINA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0097
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0080
    GoTo _00C1
_0080:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _00C1
    ClearFlag FLAG_HGSS_UNK_2C9
    End
_0097:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_SABRINA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00C1
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _00C1
    ClearFlag FLAG_HGSS_UNK_2C9
    End
_00C1:
    SetFlag FLAG_HGSS_UNK_2C9
    End
scr_seq_P01R0102_002:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0104
    WaitMovement
    ApplyMovement obj_P01R0102_seaman_2, _010C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_BOAT_DIRECTION, 0
    ClearFlag FLAG_HGSS_RECEIVED_PLATE_FROM_AQUA_CAPTAIN_THIS_TRIP
    ReleaseAll
    End
    .balign 4, 0
_0104:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_010C:
    WalkNormalWest
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_P01R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0256_P01R0102_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_P01R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0256_P01R0102_00003
    CloseMessage
    ApplyMovement obj_P01R0102_gswoman2, _0144
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0144:
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_P01R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _0211
    Message msg_0256_P01R0102_00000
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0197
    ApplyMovement obj_P01R0102_seaman_2, _021C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _024C
    GoTo _01F3
_0197:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _01BC
    ApplyMovement obj_P01R0102_seaman_2, _022C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _025C
    GoTo _01F3
_01BC:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _01E1
    ApplyMovement obj_P01R0102_seaman_2, _023C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _026C
    GoTo _01F3
_01E1:
    ApplyMovement obj_P01R0102_seaman_2, _023C
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _026C
_01F3:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_723 0, 0, 307, 24, 19
    ReleaseAll
    End
_0211:
    Message msg_0256_P01R0102_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_021C:
    FaceWest
    WalkNormalWest
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_022C:
    FaceEast
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_023C:
    FaceEast
    WalkNormalEast
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_024C:
    WalkNormalWest
    FaceNorth
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_025C:
    WalkNormalEast
    FaceNorth
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_026C:
    WalkNormalNorth 2
    EndMovement
scr_seq_P01R0102_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_SABRINA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0322
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 4, _0317
    Message msg_0256_P01R0102_00004
_029F:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02C3
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0306
    End
_02C3:
    BufferPlayerName 0
    Message msg_0256_P01R0102_00005
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_SABRINA
    Message msg_0256_P01R0102_00006
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_2C9
    RemoveObject obj_P01R0102_gsleader10
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0306:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0256_P01R0102_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0317:
    Message msg_0256_P01R0102_00008
    GoTo _029F
    End
_0322:
    Message msg_0256_P01R0102_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0383
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _038E
    Message msg_0256_P01R0102_00010
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 88
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0256_P01R0102_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0383:
    Message msg_0256_P01R0102_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_038E:
    Message msg_0256_P01R0102_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
