#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0384.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R34_gswoman3 5
#define obj_R34_gswoman3_2 6
#define obj_R34_gswoman3_3 7
#define obj_R34_gsoldman1 10
#define obj_R34_var_1 11
#define obj_R34_tsure_poke_static_marill 12
#define obj_R34_gsmiddleman1_2 15

    ScriptEntry scr_seq_R34_000
    ScriptEntry scr_seq_R34_001
    ScriptEntry scr_seq_R34_002
    ScriptEntry scr_seq_R34_003
    ScriptEntry scr_seq_R34_004
    ScriptEntry scr_seq_R34_005
    ScriptEntry scr_seq_R34_006
    ScriptEntry scr_seq_R34_007
    ScriptEntry scr_seq_R34_008
    ScriptEntry scr_seq_R34_009
    ScriptEntry scr_seq_R34_010
    ScriptEntry scr_seq_R34_011
    ScriptEntry scr_seq_R34_012
    ScriptEntry scr_seq_R34_013
    ScriptEntry scr_seq_R34_014
    ScriptEntryEnd
scr_seq_R34_000:
    CompleteGetFriendSprite VAR_OBJ_GFX_ID_0
    CheckDaycareHasEgg VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0351
    SetObjectEventMovementType obj_R34_gsoldman1, 16
    GoTo _0368
scr_seq_R34_001:
    LockAll
    ApplyMovement obj_R34_gsoldman1, _0BC8
    ApplyMovement LOCALID_PLAYER, _0BD6
    WaitMovement
    Message msg_0384_R34_00046
    BufferPlayerName 0
    CompletePhoneRegister PHONE_CONTACT_DAY_C_MAN
    Message msg_0384_R34_00047
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    CompletePhoneRegister PHONE_CONTACT_DAY_C_LADY
    Message msg_0384_R34_00048
    PlayFanfare SEQ_ME_POKEGEAR_REGIST_sseq
    WaitFanfare
    Message msg_0384_R34_00049
    CloseMessage
    ApplyMovement obj_R34_gsoldman1, _0BE0
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_408E, 3
    ReleaseAll
    End
scr_seq_R34_003:
    LockAll
    MessageGendered msg_0384_R34_00036, msg_0384_R34_00041
    CloseMessage
    ApplyMovement obj_R34_gsoldman1, _0BEE
    WaitMovement
    CallCommonScript 0x816
    ApplyMovement obj_R34_var_1, _0BF4
    ApplyMovement obj_R34_tsure_poke_static_marill, _0C06
    WaitMovement
    ApplyMovement obj_R34_gsoldman1, _0C14
    WaitMovement
    MessageGendered msg_0384_R34_00037, msg_0384_R34_00042
    CloseMessage
    ApplyMovement obj_R34_var_1, _0C1A
    WaitMovement
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    BufferPlayerName 0
    CompareVar VAR_0x8004, 368
    GoToIf 5, _0379
    ApplyMovement obj_R34_var_1, _0C20
    ApplyMovement obj_R34_tsure_poke_static_marill, _0C2A
    ApplyMovement obj_R34_gsoldman1, _0C30
    GoTo _03A4
scr_seq_R34_002:
    NPCMessage msg_0384_R34_00018
    End
scr_seq_R34_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03D1
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03E5
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03F9
    ApplyMovement LOCALID_PLAYER, _0C36
    ApplyMovement obj_R34_gsmiddleman1_2, _0C4C
    GoTo _0414
scr_seq_R34_004:
    LockAll
    CountAliveMonsExcept VAR_MAP_LOCAL_0x03, 6
    CompareVar VAR_MAP_LOCAL_0x03, 1
    GoToIf 5, _0475
    GoTo _047B
scr_seq_R34_005:
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x04, 777
    ApplyMovement obj_R34_gswoman3_3, _0C56
    StopMusic
    PlayMusic SEQ_GS_EYE_J_SHOUJO_sseq
    WaitMovement
    Message msg_0384_R34_00028
    CloseMessage
    StopMusic
    StartTrainerBattle TRAINER_HGSS_ACE_TRAINER_F_KATE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0515
    SetVarFromValue VAR_HGSS_UNK_4097, 2
    Message msg_0384_R34_00030
    SetVar VAR_0x8004, ITEM_POWER_HERB
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _051B
    Common_GiveItemQuantity
    SetVarFromValue VAR_HGSS_UNK_4097, 3
    Message msg_0384_R34_00032
    WaitButton
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x04, 777
    GoToIf 5, _0527
    ReleaseAll
    GoTo _052B
scr_seq_R34_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4097, 1
    GoToIf 5, _052D
    Message msg_0384_R34_00022
    GoTo _0538
scr_seq_R34_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4097, 1
    GoToIf 5, _0540
    Message msg_0384_R34_00026
    GoTo _054B
scr_seq_R34_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x04, 555
    CompareVar VAR_HGSS_UNK_4097, 2
    GoToIf 1, _0553
    Message msg_0384_R34_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R34_009:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0384_R34_00034, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R34_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0384_R34_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R34_011:
    DrawSignpostInstantMessage msg_0384_R34_00033, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R34_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_KIRLIA, 0
    WaitCry
    CompleteStartWildBattle SPECIES_KIRLIA, 22, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0515
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 16
    SetFlag FLAG_HGSS_SG_3FF0
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_R34_014:
    BufferPlayerName 0
    End
_0351:
    SetObjectEventMovementType obj_R34_gsoldman1, 15
    GoToIfUnset FLAG_HGSS_UNK_189, _059D
    ClearFlag FLAG_HGSS_UNK_189
    End
_0368:
    GoToIfUnset FLAG_HGSS_UNK_189, _059D
    ClearFlag FLAG_HGSS_UNK_189
    End
_0379:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _05D8
    ApplyMovement obj_R34_var_1, _0C20
    ApplyMovement obj_R34_tsure_poke_static_marill, _0C2A
    ApplyMovement obj_R34_gsoldman1, _0C30
    GoTo _03A4
_03A4:
    WaitMovement
    MessageGendered msg_0384_R34_00038, msg_0384_R34_00043
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 363
    GoToIf 5, _060D
    ApplyMovement LOCALID_PLAYER, _0C60
    GoTo _0628
_03D1:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E5:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03F9:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _064F
    ApplyMovement LOCALID_PLAYER, _0C6A
    GoTo _0414
_0414:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0672
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C74
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 9
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
_0475:
    GoTo _06AC
_047B:
    ApplyMovement obj_R34_gswoman3, _0C82
    StopMusic
    PlayMusic SEQ_GS_EYE_J_SHOUJO_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0C8C
    WaitMovement
    Message msg_0384_R34_00019
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_ACE_TRAINER_F_IRENE, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0515
    ApplyMovement obj_R34_gswoman3, _0C92
    WaitMovement
    Message msg_0384_R34_00021
    CloseMessage
    ApplyMovement obj_R34_gswoman3_2, _0C98
    StopMusic
    PlayMusic SEQ_GS_EYE_J_SHOUJO_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0CA2
    WaitMovement
    Message msg_0384_R34_00024
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_ACE_TRAINER_F_JENN, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0515
    ApplyMovement obj_R34_gswoman3_2, _0CA8
    WaitMovement
    Message msg_0384_R34_00026
    WaitButton
    CloseMessage
    GoTo _0741
_0515:
    BlackOutFromBattle
    ReleaseAll
    End
_051B:
    Common_MessageBagIsFull
    CloseMessage
    GoTo _074B
_0527:
    ReleaseAll
    End
_052B:
    End
_052D:
    Message msg_0384_R34_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0538:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0540:
    Message msg_0384_R34_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_054B:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0553:
    Message msg_0384_R34_00030
    SetVar VAR_0x8004, ITEM_POWER_HERB
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _051B
    Common_GiveItemQuantity
    SetVarFromValue VAR_HGSS_UNK_4097, 3
    Message msg_0384_R34_00032
    WaitButton
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x04, 777
    GoToIf 5, _0527
    ReleaseAll
    GoTo _052B
_059D:
    CompleteCheckBadge BADGE_ID_HGSS_PLAIN, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0760
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _076A
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _076A
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0796
_05D8:
    ApplyMovement obj_R34_var_1, _0CAE
    WaitMovement
    MessageGendered msg_0384_R34_00038, msg_0384_R34_00043
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 363
    GoToIf 5, _060D
    ApplyMovement LOCALID_PLAYER, _0C60
    GoTo _0628
_060D:
    CompareVar VAR_0x8004, 364
    GoToIf 5, _07BE
    ApplyMovement LOCALID_PLAYER, _0CB4
    GoTo _0628
_0628:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_0x8004, 368
    GoToIf 5, _07D9
    ApplyMovement obj_R34_var_1, _0BEE
    GoTo _07F4
_064F:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0822
    ApplyMovement LOCALID_PLAYER, _0CBA
    ApplyMovement obj_R34_gsmiddleman1_2, _0C4C
    GoTo _0414
_0672:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 9
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
_06AC:
    ApplyMovement obj_R34_gswoman3, _0C82
    StopMusic
    PlayMusic SEQ_GS_EYE_J_SHOUJO_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0C8C
    WaitMovement
    Message msg_0384_R34_00019
    CloseMessage
    ApplyMovement obj_R34_gswoman3_2, _0C98
    PlayMusic SEQ_GS_EYE_J_SHOUJO_sseq
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0CA2
    WaitMovement
    Message msg_0384_R34_00024
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_ACE_TRAINER_F_JENN, 120
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0515
    ApplyMovement obj_R34_gswoman3, _0C92
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0C8C
    WaitMovement
    Message msg_0384_R34_00021
    CloseMessage
    ApplyMovement obj_R34_gswoman3_2, _0CA8
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0CA2
    WaitMovement
    Message msg_0384_R34_00026
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4097, 1
    ReleaseAll
    End
_0741:
    SetVarFromValue VAR_HGSS_UNK_4097, 1
    ReleaseAll
    End
_074B:
    CompareVar VAR_MAP_LOCAL_0x04, 777
    GoToIf 5, _0527
    ReleaseAll
    GoTo _052B
_0760:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0796
_076A:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0893
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0893
    ClearFlag FLAG_HGSS_UNK_1D1
    SetFlag FLAG_HGSS_UNK_1D2
    End
_0796:
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0893
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0893
    ClearFlag FLAG_HGSS_UNK_1D1
    SetFlag FLAG_HGSS_UNK_1D2
    End
_07BE:
    CompareVar VAR_0x8004, 365
    GoToIf 5, _089D
    ApplyMovement LOCALID_PLAYER, _0CCC
    GoTo _0628
_07D9:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _08B8
    ApplyMovement obj_R34_var_1, _0BEE
    GoTo _07F4
_07F4:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0384_R34_00039, msg_0384_R34_00044
    CloseMessage
    CompareVar VAR_0x8004, 368
    GoToIf 5, _08EE
    ApplyMovement obj_R34_var_1, _0CD6
    ApplyMovement obj_R34_tsure_poke_static_marill, _0CE0
    GoTo _0911
_0822:
    ApplyMovement LOCALID_PLAYER, _0CE6
    ApplyMovement obj_R34_gsmiddleman1_2, _0C4C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0672
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0C74
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 9
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
_0893:
    ClearFlag FLAG_HGSS_UNK_1D2
    SetFlag FLAG_HGSS_UNK_1D1
    End
_089D:
    CompareVar VAR_0x8004, 366
    GoToIf 5, _0951
    ApplyMovement LOCALID_PLAYER, _0CF8
    GoTo _0628
_08B8:
    ApplyMovement obj_R34_var_1, _0D02
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0384_R34_00039, msg_0384_R34_00044
    CloseMessage
    CompareVar VAR_0x8004, 368
    GoToIf 5, _08EE
    ApplyMovement obj_R34_var_1, _0CD6
    ApplyMovement obj_R34_tsure_poke_static_marill, _0CE0
    GoTo _0911
_08EE:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _096C
    ApplyMovement obj_R34_var_1, _0CD6
    ApplyMovement obj_R34_tsure_poke_static_marill, _0CE0
    GoTo _0911
_0911:
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0384_R34_00040, msg_0384_R34_00045
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 368
    GoToIf 5, _09BC
    ApplyMovement obj_R34_var_1, _0D08
    ApplyMovement obj_R34_tsure_poke_static_marill, _0D12
    ApplyMovement LOCALID_PLAYER, _0D18
    GoTo _09E7
_0951:
    CompareVar VAR_0x8004, 367
    GoToIf 5, _0A88
    ApplyMovement LOCALID_PLAYER, _0D26
    GoTo _0628
_096C:
    ApplyMovement obj_R34_var_1, _0D30
    ApplyMovement obj_R34_tsure_poke_static_marill, _0D36
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0384_R34_00040, msg_0384_R34_00045
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 368
    GoToIf 5, _09BC
    ApplyMovement obj_R34_var_1, _0D08
    ApplyMovement obj_R34_tsure_poke_static_marill, _0D12
    ApplyMovement LOCALID_PLAYER, _0D18
    GoTo _09E7
_09BC:
    CompareVar VAR_0x8004, 369
    GoToIf 5, _0AA3
    ApplyMovement obj_R34_var_1, _0D08
    ApplyMovement obj_R34_tsure_poke_static_marill, _0D12
    ApplyMovement LOCALID_PLAYER, _0D18
    GoTo _09E7
_09E7:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    LoadDoorAnimation 11, 12, 16, 26, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_R34_var_1, _0D3C
    ApplyMovement obj_R34_tsure_poke_static_marill, _0D46
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0D54
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CompleteFollowerIsTooTall VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0B5C
    CompleteFollowerPutAway
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    WaitFadeScreen
    UnloadAnimation 77
    SetVarFromValue VAR_HGSS_UNK_408E, 1
    Warp MAP_HEADER_HGSS_ROUTE_34_DAYCARE, 3, 12, DIR_NORTH
    ScrCmd_2B5 MAP_HEADER_HGSS_ROUTE_34, 368, 411
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0A88:
    CompareVar VAR_0x8004, 368
    GoToIf 5, _0B99
    ApplyMovement LOCALID_PLAYER, _0D5E
    GoTo _0628
_0AA3:
    ApplyMovement obj_R34_var_1, _0D68
    ApplyMovement obj_R34_tsure_poke_static_marill, _0D72
    ApplyMovement LOCALID_PLAYER, _0D7C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    LoadDoorAnimation 11, 12, 16, 26, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_R34_var_1, _0D3C
    ApplyMovement obj_R34_tsure_poke_static_marill, _0D46
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0D54
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    CompleteFollowerIsTooTall VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0B5C
    CompleteFollowerPutAway
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    WaitFadeScreen
    UnloadAnimation 77
    SetVarFromValue VAR_HGSS_UNK_408E, 1
    Warp MAP_HEADER_HGSS_ROUTE_34_DAYCARE, 3, 12, DIR_NORTH
    ScrCmd_2B5 MAP_HEADER_HGSS_ROUTE_34, 368, 411
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0B5C:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    WaitFadeScreen
    UnloadAnimation 77
    SetVarFromValue VAR_HGSS_UNK_408E, 1
    Warp MAP_HEADER_HGSS_ROUTE_34_DAYCARE, 3, 12, DIR_NORTH
    ScrCmd_2B5 MAP_HEADER_HGSS_ROUTE_34, 368, 411
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0B99:
    ApplyMovement LOCALID_PLAYER, _0D8A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_0x8004, 368
    GoToIf 5, _07D9
    ApplyMovement obj_R34_var_1, _0BEE
    GoTo _07F4
    .balign 4, 0
_0BC8:
    EmoteExclamationMark
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0BD6:
    Delay8 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0BE0:
    WalkNormalWest 2
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0BEE:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0BF4:
    WalkNormalSouth 6
    WalkNormalEast 3
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0C06:
    WalkNormalSouth 7
    WalkNormalEast 3
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0C14:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0C1A:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0C20:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0C2A:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0C30:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C36:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C4C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0C56:
    EmoteExclamationMark
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0C60:
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0C6A:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C74:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0C82:
    EmoteExclamationMark
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_0C8C:
    FaceEast
    EndMovement
    .balign 4, 0
_0C92:
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_0C98:
    EmoteExclamationMark
    WalkNormalEast 4
    EndMovement
    .balign 4, 0
_0CA2:
    FaceWest
    EndMovement
    .balign 4, 0
_0CA8:
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_0CAE:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CB4:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0CBA:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CCC:
    WalkNormalWest
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0CD6:
    WalkNormalEast
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CE0:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0CE6:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0CF8:
    WalkNormalWest 2
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0D02:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0D08:
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0D12:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0D18:
    Delay8
    WalkNormalEast 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0D26:
    WalkNormalWest 3
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0D30:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0D36:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0D3C:
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_0D46:
    WalkNormalEast
    WalkNormalNorth
    SetInvisible
    EndMovement
    .balign 4, 0
_0D54:
    WalkNormalNorth 2
    SetInvisible
    EndMovement
    .balign 4, 0
_0D5E:
    WalkNormalWest 3
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0D68:
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0D72:
    WalkNormalSouth
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_0D7C:
    Delay8
    WalkNormalEast 4
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0D8A:
    WalkNormalWest 4
    WalkNormalNorth
    EndMovement
    .balign 4, 0
