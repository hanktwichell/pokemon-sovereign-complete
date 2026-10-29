#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0571.h"

#define obj_T23R0501_gantetsu 0
#define obj_T23R0501_gsbabygirl1 1

    ScriptEntry scr_seq_T23R0501_000
    ScriptEntry scr_seq_T23R0501_001
    ScriptEntry scr_seq_T23R0501_002
    ScriptEntry scr_seq_T23R0501_003
    ScriptEntry scr_seq_T23R0501_004
    ScriptEntry scr_seq_T23R0501_005
    ScriptEntry scr_seq_T23R0501_006
    ScriptEntryEnd
scr_seq_T23R0501_000:
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _002F
    SetFlag FLAG_HGSS_HIDE_AZALEA_SLOWPOKES
    End
_002F:
    ClearFlag FLAG_HGSS_HIDE_AZALEA_SLOWPOKES
    End
scr_seq_T23R0501_005:
    LockAll
    SetVarFromValue VAR_HGSS_UNK_4080, 3
    ApplyMovement obj_T23R0501_gantetsu, _02B0
    WaitMovement
    BufferPlayerName 0
    Message msg_0571_T23R0501_00001
    SetVarFromValue VAR_0x8004, 492
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_UNK_07C
    ReleaseAll
    GoTo _011A
    End
scr_seq_T23R0501_001:
    GoToIfSet FLAG_HGSS_UNK_07C, _011A
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0571_T23R0501_00000
    WaitABPress
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00A7
    GoTo _00C7
_00A1:
    GoTo _00AF
_00A7:
    ApplyMovement obj_T23R0501_gantetsu, _02E0
_00AF:
    WaitMovement
_00B1:
    ReleaseAll
    RemoveObject obj_T23R0501_gantetsu
    WaitFanfare
    SetFlag FLAG_HGSS_UNK_077
    SetFlag FLAG_HGSS_UNK_19E
    SetFlag FLAG_HGSS_UNK_19F
    End
_00C7:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    .short SCRCMD_UNUSED_06A
    .short 253
    .short VAR_MAP_LOCAL_0x02
    .short VAR_MAP_LOCAL_0x03
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 5, _00F4
    ApplyMovement obj_T23R0501_gantetsu, _02E8
    GoTo _0108
_00F4:
    PlaySE SEQ_SE_DP_WALL_HIT_sseq
    ApplyMovement obj_T23R0501_gantetsu, _02E0
    ApplyMovement LOCALID_PLAYER, _02C8
_0108:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _00B1
_011A:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_735 VAR_SPECIAL_x8000
    CompareVar VAR_0x8000, 0
    GoToIf 5, _01A5
    @ HGSS: GetTotalApricornCount VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _020F
    ApplyMovement obj_T23R0501_gantetsu, _02BC
    WaitMovement
    Message msg_0571_T23R0501_00004
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_739
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_735 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0189
    Message msg_0571_T23R0501_00006
    GoTo _0190
_0189:
    SetFlag FLAG_HGSS_DAILY_KURT_MAKING_BALLS
    Message msg_0571_T23R0501_00005
_0190:
    WaitButton
    CloseMessage
    CompareVar VAR_HGSS_UNK_4080, 3
    GoToIf 1, _022D
    ReleaseAll
    End
_01A5:
    GoToIfSet FLAG_HGSS_DAILY_KURT_MAKING_BALLS, _0204
    BufferPlayerName 0
    Message msg_0571_T23R0501_00008
    @ HGSS: ScrCmd_737 VAR_SPECIAL_x8004
    CanFitItem VAR_0x8004, VAR_0x8000, VAR_RESULT
    SetVarFromVar VAR_0x8005, VAR_0x8000
    Common_GiveItemQuantity
    @ HGSS: ClearKurtApricorn
    CompareVar VAR_HGSS_UNK_413B, 10
    GoToIf 4, _01EE
    AddVar VAR_HGSS_UNK_413B, 1
    CompareVar VAR_HGSS_UNK_413B, 10
    CallIf 4, _0227
_01EE:
    Message msg_0571_T23R0501_00010
    GoTo _021F
    End
_01F9:
    Message msg_0571_T23R0501_00009
    GoTo _021F
    End
_0204:
    Message msg_0571_T23R0501_00007
    GoTo _021F
    End
_020F:
    Message msg_0571_T23R0501_00003
    CompareVar VAR_HGSS_UNK_4080, 3
    GoToIf 1, _022D
_021F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0227:
    SetFlag FLAG_HGSS_UNK_127
    Return
_022D:
    SetVarFromValue VAR_HGSS_UNK_4080, 4
    ApplyMovement obj_T23R0501_gsbabygirl1, _02FC
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _02D4
    WaitMovement
    Message msg_0571_T23R0501_00015
_024A:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _026E
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0289
    End
_026E:
    BufferPlayerName 0
    Message msg_0571_T23R0501_00016
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_KURT
    Message msg_0571_T23R0501_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0289:
    Message msg_0571_T23R0501_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0294:
    ApplyMovement 1, _0304
    WaitMovement
    ReleaseAll
    End
_02A2:
    Message msg_0571_T23R0501_00019
    GoTo _024A
    End
    .balign 4, 0
_02B0:
    Delay16
    WalkOnSpotFastSouth
    EndMovement
    .balign 4, 0
_02BC:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_02C8:
    WalkFastWest
    Delay16
    EndMovement
    .balign 4, 0
_02D4:
    WalkOnSpotFastEast
    FaceEast
    EndMovement
    .balign 4, 0
_02E0:
    WalkFastSouth 5
    EndMovement
    .balign 4, 0
_02E8:
    WalkFastWest
    WalkFastSouth 2
    WalkFastEast
    WalkFastSouth 3
    EndMovement
    .balign 4, 0
_02FC:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0304:
    WalkOnSpotFastEast
    WalkNormalEast
    WalkOnSpotFastWest
    EndMovement
scr_seq_T23R0501_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_077, _0332
    Message msg_0571_T23R0501_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0332:
    GoToIfSet FLAG_HGSS_BEAT_AZALEA_ROCKETS, _0348
    Message msg_0571_T23R0501_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0348:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_KURT, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 1, _02A2
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0371
    Message msg_0571_T23R0501_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0371:
    Message msg_0571_T23R0501_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23R0501_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SLOWPOKE, 0
    Message msg_0571_T23R0501_00020
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T23R0501_004:
    NPCMessage msg_0571_T23R0501_00021
    End
scr_seq_T23R0501_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 2
    GoToIf 5, _03C8
    Message msg_0571_T23R0501_00024
    GoTo _03F7
_03C8:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _03DE
    Message msg_0571_T23R0501_00024
    GoTo _03F7
_03DE:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _03F4
    Message msg_0571_T23R0501_00024
    GoTo _03F7
_03F4:
    Message msg_0571_T23R0501_00023
_03F7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
