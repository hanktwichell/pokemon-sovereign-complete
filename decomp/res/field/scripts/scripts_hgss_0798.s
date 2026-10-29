#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0503.h"

#define obj_T07R0203_var_1 5
#define obj_T07R0203_tsure_poke_static_marill 6

    ScriptEntry scr_seq_T07R0203_000
    ScriptEntry scr_seq_T07R0203_001
    ScriptEntry scr_seq_T07R0203_002
    ScriptEntry scr_seq_T07R0203_003
    ScriptEntry scr_seq_T07R0203_004
    ScriptEntry scr_seq_T07R0203_005
    ScriptEntry scr_seq_T07R0203_006
    ScriptEntry scr_seq_T07R0203_007
    ScriptEntry scr_seq_T07R0203_008
    ScriptEntry scr_seq_T07R0203_009
    ScriptEntry scr_seq_T07R0203_010
    ScriptEntry scr_seq_T07R0203_011
    ScriptEntry scr_seq_T07R0203_012
    ScriptEntry scr_seq_T07R0203_013
    ScriptEntryEnd
scr_seq_T07R0203_008:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    SetVarFromValue VAR_HGSS_UNK_4125, 0
    End
scr_seq_T07R0203_011:
    CompareVar VAR_HGSS_UNK_412C, 0
    GoToIf 5, _006B
    SetPosition obj_T07R0203_var_1, 12, 0, 6, DIR_WEST
    SetPosition obj_T07R0203_tsure_poke_static_marill, 13, 0, 6, DIR_WEST
_006B:
    End
scr_seq_T07R0203_010:
    LockAll
    Common_SetCounterpartBGM
    ApplyMovement obj_T07R0203_var_1, _012C
    ApplyMovement obj_T07R0203_tsure_poke_static_marill, _0138
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0503_T07R0203_00012, msg_0503_T07R0203_00013
    CloseMessage
    ApplyMovement obj_T07R0203_var_1, _0140
    ApplyMovement obj_T07R0203_tsure_poke_static_marill, _0148
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0150
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0503_T07R0203_00014, msg_0503_T07R0203_00015
    CloseMessage
    ApplyMovement obj_T07R0203_var_1, _015C
    ApplyMovement obj_T07R0203_tsure_poke_static_marill, _016C
    WaitMovement
    @ HGSS: ScrCmd_307 0, 0, 3, 2, 77
    @ HGSS: ScrCmd_310 77
    @ HGSS: ScrCmd_308 77
    ApplyMovement obj_T07R0203_var_1, _0180
    ApplyMovement obj_T07R0203_tsure_poke_static_marill, _018C
    WaitMovement
    @ HGSS: ScrCmd_311 77
    @ HGSS: ScrCmd_308 77
    @ HGSS: ScrCmd_309 77
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_UNK_412C, 1
    SetPosition obj_T07R0203_var_1, 29, 0, 29, DIR_WEST
    SetPosition obj_T07R0203_tsure_poke_static_marill, 29, 0, 29, DIR_WEST
    ReleaseAll
    End
    .balign 4, 0
_012C:
    WalkNormalWest 4
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0138:
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0140:
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0148:
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0150:
    WalkNormalSouth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_015C:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_016C:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0180:
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_018C:
    WalkNormalNorth 2
    SetInvisible
    EndMovement
scr_seq_T07R0203_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: CheckJohtoDexComplete VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0245
    GoToIfSet FLAG_HGSS_SAW_JOHTO_DEX_CERTIFICATE, _01ED
    Message msg_0503_T07R0203_00001
    WaitFanfare
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ShowCertificate 0
    ReturnToField
    SetFlag FLAG_HGSS_SAW_JOHTO_DEX_CERTIFICATE
    @ HGSS: AddSpecialGameStat SCORE_EVENT_REGIONAL_DEX_COMPLETE
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_01ED:
    @ HGSS: CheckNationalDexComplete VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0245
    GoToIfSet FLAG_HGSS_SAW_NATIONAL_DEX_CERTIFICATE, _023A
    Message msg_0503_T07R0203_00002
    WaitFanfare
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ShowCertificate 1
    ReturnToField
    SetFlag FLAG_HGSS_SAW_NATIONAL_DEX_CERTIFICATE
    @ HGSS: AddSpecialGameStat SCORE_EVENT_NATIONAL_DEX_COMPLETE
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
_023A:
    Message msg_0503_T07R0203_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0245:
    Message msg_0503_T07R0203_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0203_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0276
    Message msg_0503_T07R0203_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0276:
    GetItemQuantity ITEM_GB_SOUNDS, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _02A7
    Message msg_0503_T07R0203_00008
    SetVar VAR_0x8004, ITEM_GB_SOUNDS
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0503_T07R0203_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A7:
    Message msg_0503_T07R0203_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0203_001:
    NPCMessage msg_0503_T07R0203_00004
    End
scr_seq_T07R0203_002:
    NPCMessage msg_0503_T07R0203_00005
    End
scr_seq_T07R0203_003:
    NPCMessage msg_0503_T07R0203_00006
    End
scr_seq_T07R0203_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0203_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0203_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0203_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0203_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0503_T07R0203_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0203_012:
    NPCMessage msg_0503_T07R0203_00021
    End
    .balign 4, 0
