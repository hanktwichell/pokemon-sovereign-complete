#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0542.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T20_gsrivel 0
#define obj_T20_gswoman1 1
#define obj_T20_tsure_poke_static_marill 3
#define obj_T20_var_1 4
#define obj_T20_doctor 5
#define obj_T20_gsmiddleman1 6
#define obj_T20_gsmama 7
#define obj_T20_var_1_2 8
#define obj_T20_tsure_poke_static_marill_2 9

    ScriptEntry scr_seq_T20_000
    ScriptEntry scr_seq_T20_001
    ScriptEntry scr_seq_T20_002
    ScriptEntry scr_seq_T20_003
    ScriptEntry scr_seq_T20_004
    ScriptEntry scr_seq_T20_005
    ScriptEntry scr_seq_T20_006
    ScriptEntry scr_seq_T20_007
    ScriptEntry scr_seq_T20_008
    ScriptEntry scr_seq_T20_009
    ScriptEntry scr_seq_T20_010
    ScriptEntry scr_seq_T20_011
    ScriptEntry scr_seq_T20_012
    ScriptEntry scr_seq_T20_013
    ScriptEntry scr_seq_T20_014
    ScriptEntry scr_seq_T20_015
    ScriptEntry scr_seq_T20_016
    ScriptEntry scr_seq_T20_017
    ScriptEntryEnd
scr_seq_T20_006:
    @ HGSS: GetFriendSprite VAR_OBJ_0
    GoToIfUnset FLAG_HGSS_UNK_189, _0A05
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T20_009:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1
    GoToIf 1, _0A41
    End
scr_seq_T20_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0542_T20_00013
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0A6B
    ApplyMovement obj_T20_gsrivel, _1810
    GoTo _0AC0
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0A86
    ApplyMovement obj_T20_gsrivel, _1808
    GoTo _0AC0
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0AC0
    ApplyMovement obj_T20_gsrivel, _1818
    WaitMovement
    Message msg_0542_T20_00014
    CloseMessage
    GoToIfUnset FLAG_HGSS_GOT_STARTER, _0AF8
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0AE5
    GoTo _0B46
    GoTo _0AF8
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0AF8
    GoTo _0B1E
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0B0B
    GoTo _0B8E
    GoTo _0B1E
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0B1E
    GoTo _0B6E
    ApplyMovement obj_T20_gsrivel, _1820
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _17E8
    ApplyMovement LOCALID_PLAYER, _1844
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _1830
    WaitMovement
    ReleaseAll
    End
scr_seq_T20_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 0
    GoToIf 5, _0BAE
    Message msg_0542_T20_00009
    GoTo _0BFF
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1
    GoToIf 5, _0BC4
    Message msg_0542_T20_00005
    GoTo _0BFF
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 2
    GoToIf 5, _0BDA
    Message msg_0542_T20_00005
    GoTo _0BFF
    CompareVar VAR_HGSS_SCENE_NEW_BARK_WEST_EXIT, 1
    GoToIf 5, _0BF0
    Message msg_0542_T20_00000
    GoTo _0BFF
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00006, msg_0542_T20_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20_002:
    LockAll
    GoToIfSet FLAG_HGSS_GOT_POKEGEAR, _1034
    ApplyMovement obj_T20_gswoman1, _189C
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00001, msg_0542_T20_00002
    WaitTime 20, VAR_RESULT
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _18B8
    WaitMovement
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 2
    GoToIf 1, _0DDD
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0C07
    ApplyMovement obj_T20_gswoman1, _1900
    GoTo _0CCD
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0C22
    ApplyMovement obj_T20_gswoman1, _1910
    GoTo _0CCD
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0C3D
    ApplyMovement obj_T20_gswoman1, _1920
    GoTo _0CCD
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0C58
    ApplyMovement obj_T20_gswoman1, _1930
    GoTo _0CCD
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0C73
    ApplyMovement obj_T20_gswoman1, _1938
    GoTo _0CCD
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0C8E
    ApplyMovement obj_T20_gswoman1, _1948
    GoTo _0CCD
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0CCD
    ApplyMovement obj_T20_gswoman1, _1958
    WaitMovement
    Message msg_0542_T20_00003
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0CF7
    ApplyMovement obj_T20_gswoman1, _19C4
    ApplyMovement LOCALID_PLAYER, _1AAC
    GoTo _0DD0
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0D1A
    ApplyMovement obj_T20_gswoman1, _19D8
    ApplyMovement LOCALID_PLAYER, _1ABC
    GoTo _0DD0
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0D3D
    ApplyMovement obj_T20_gswoman1, _19EC
    ApplyMovement LOCALID_PLAYER, _1ACC
    GoTo _0DD0
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0D60
    ApplyMovement obj_T20_gswoman1, _1A00
    ApplyMovement LOCALID_PLAYER, _1ADC
    GoTo _0DD0
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0D83
    ApplyMovement obj_T20_gswoman1, _1A0C
    ApplyMovement LOCALID_PLAYER, _1AE4
    GoTo _0DD0
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0DA6
    ApplyMovement obj_T20_gswoman1, _1A20
    ApplyMovement LOCALID_PLAYER, _1AF4
    GoTo _0DD0
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0DD0
    ApplyMovement obj_T20_gswoman1, _1A30
    ApplyMovement LOCALID_PLAYER, _1B04
    WaitMovement
    Message msg_0542_T20_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20_003:
    LockAll
    ReleaseObject obj_T20_tsure_poke_static_marill
    ApplyMovement obj_T20_tsure_poke_static_marill, _1C58
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    AddObject obj_T20_var_1
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    Common_SetCounterpartBGM
    ApplyMovement obj_T20_var_1, _1CDC
    WaitMovement
    ApplyMovement obj_T20_tsure_poke_static_marill, _1C88
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _1CD4
    ApplyMovement obj_T20_var_1, _1CF0
    WaitMovement
    ApplyMovement obj_T20_tsure_poke_static_marill, _1CB0
    WaitMovement
    ApplyMovement obj_T20_var_1, _1CF8
    ApplyMovement obj_T20_tsure_poke_static_marill, _1CB8
    WaitMovement
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_SCENE_PLAYERS_HOUSE_1F, 2
    RemoveObject obj_T20_tsure_poke_static_marill
    RemoveObject obj_T20_var_1
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    ReleaseAll
    End
scr_seq_T20_007:
    BufferPlayerName 0
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0542_T20_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_008:
    LockAll
    Common_SetCounterpartBGM
    ApplyMovement obj_T20_var_1, _1D0C
    ApplyMovement obj_T20_tsure_poke_static_marill, _1D44
    WaitMovement
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1D70
    ApplyMovement obj_T20_var_1, _1D7C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00015, msg_0542_T20_00016
    CloseMessage
    ApplyMovement obj_T20_var_1, _1D88
    ApplyMovement obj_T20_tsure_poke_static_marill, _1D9C
    ApplyMovement LOCALID_PLAYER, _1DC0
    WaitMovement
    ApplyMovement obj_T20_var_1, _1DCC
    ApplyMovement obj_T20_tsure_poke_static_marill, _1DD4
    WaitMovement
    RemoveObject obj_T20_tsure_poke_static_marill
    RemoveObject obj_T20_var_1
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    Common_FadeToDefaultMusic
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 2
    ReleaseAll
    End
scr_seq_T20_010:
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _1306
    @ HGSS: ScrCmd_596 VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1306
    CompleteFollowerPutAway
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_2F, 12, 6, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_582 MAP_NEW_BARK, 688, 393
    SetVarFromValue VAR_HGSS_UNK_407C, 1
    End
scr_seq_T20_016:
    @ HGSS: BufferFriendsName 0
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0542_T20_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _148C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _14A0
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _1342
    ApplyMovement LOCALID_PLAYER, _1DDC
    ApplyMovement obj_T20_gsmiddleman1, _1E28
    GoTo _13F1
    CompareVar VAR_RESULT, 1
    GoToIf 5, _135D
    ApplyMovement LOCALID_PLAYER, _1DF4
    GoTo _13F1
    CompareVar VAR_RESULT, 3
    GoToIf 5, _1380
    ApplyMovement LOCALID_PLAYER, _1E14
    ApplyMovement obj_T20_gsmiddleman1, _1E28
    GoTo _13F1
    ApplyMovement LOCALID_PLAYER, _1E00
    ApplyMovement obj_T20_gsmiddleman1, _1E28
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1452
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1E34
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 0
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
scr_seq_T20_011:
    LockAll
    CompareVar VAR_MAP_LOCAL_0x07, 2
    GoToIf 1, _1691
    LoadDoorAnimation 21, 12, 23, 12, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_MOM
    AddObject obj_T20_gsmama
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    ApplyMovement obj_T20_gsmama, _1E44
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _14B4
    BufferPlayerName 0
    Message msg_0542_T20_00021
    CloseMessage
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8005, 398
    GoToIf 5, _14F0
    ApplyMovement obj_T20_gsmama, _1E4C
    ApplyMovement LOCALID_PLAYER, _1E70
    GoTo _158B
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1513
    ApplyMovement obj_T20_gsmama, _1E58
    ApplyMovement LOCALID_PLAYER, _1E7C
    GoTo _158B
    CompareVar VAR_0x8005, 400
    GoToIf 5, _1536
    ApplyMovement obj_T20_gsmama, _1E64
    ApplyMovement LOCALID_PLAYER, _1E88
    GoTo _158B
    CompareVar VAR_0x8005, 401
    GoToIf 5, _1559
    ApplyMovement obj_T20_gsmama, _1E64
    ApplyMovement LOCALID_PLAYER, _1E94
    GoTo _158B
    ApplyMovement obj_T20_gsmama, _1E64
    ApplyMovement LOCALID_PLAYER, _1EA4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _15AD
    Message msg_0542_T20_00022
    GoTo _15CF
    Message msg_0542_T20_00023
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _15EE
    ApplyMovement obj_T20_gsmama, _1EB4
    WaitMovement
    GoTo _1653
    CompareVar VAR_0x8005, 399
    GoToIf 5, _160B
    ApplyMovement obj_T20_gsmama, _1EBC
    WaitMovement
    GoTo _1653
    ApplyMovement obj_T20_gsmama, _1EC4
    WaitMovement
    LoadDoorAnimation 21, 12, 23, 12, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T20_gsmama, _1ECC
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MOM
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20_gsmama
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    AddVar VAR_MAP_LOCAL_0x07, 1
    ReleaseAll
    End
scr_seq_T20_012:
    LockAll
    ApplyMovement obj_T20_var_1_2, _1EDC
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00027, msg_0542_T20_00028
    CloseMessage
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8005, 398
    GoToIf 5, _16B8
    ApplyMovement obj_T20_var_1_2, _1EE8
    GoTo _1749
    CompareVar VAR_0x8005, 399
    GoToIf 5, _16D3
    ApplyMovement obj_T20_var_1_2, _1EF0
    GoTo _1749
    CompareVar VAR_0x8005, 399
    GoToIf 5, _16EE
    ApplyMovement obj_T20_var_1_2, _1EF8
    GoTo _1749
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1709
    ApplyMovement obj_T20_var_1_2, _1F00
    GoTo _1749
    ApplyMovement obj_T20_var_1_2, _1F08
    ApplyMovement LOCALID_PLAYER, _1F10
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00029, msg_0542_T20_00030
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _1781
    ApplyMovement obj_T20_var_1_2, _1F18
    GoTo _17E0
    CompareVar VAR_0x8005, 399
    GoToIf 5, _179C
    ApplyMovement obj_T20_var_1_2, _1F20
    GoTo _17E0
    CompareVar VAR_0x8005, 399
    GoToIf 5, _17B7
    ApplyMovement obj_T20_var_1_2, _1F28
    GoTo _17E0
    CompareVar VAR_0x8005, 399
    GoToIf 5, _17D2
    ApplyMovement obj_T20_var_1_2, _1F30
    GoTo _17E0
    ApplyMovement obj_T20_var_1_2, _1F38
    WaitMovement
    ReleaseAll
    End
scr_seq_T20_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    MessageGendered msg_0542_T20_00025, msg_0542_T20_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_AZUMARILL, 0
    Message msg_0542_T20_00033
    WaitCry
    CloseMessage
    ApplyMovement obj_T20_tsure_poke_static_marill_2, _1F40
    WaitMovement
    ApplyMovement obj_T20_var_1_2, _1F4C
    WaitMovement
    MessageGendered msg_0542_T20_00031, msg_0542_T20_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20_013:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0542_T20_00036, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_014:
    DrawSignpostInstantMessage msg_0542_T20_00034, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T20_015:
    BufferPlayerName 0
    NPCMessage msg_0542_T20_00012
    End
_0A05:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0A35
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0A3B
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0A35:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0A3B:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_0A41:
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    AddObject obj_T20_var_1
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    AddObject obj_T20_tsure_poke_static_marill
    SetPosition obj_T20_var_1, 686, 0, 396, DIR_WEST
    SetPosition obj_T20_tsure_poke_static_marill, 685, 0, 396, DIR_SOUTH
    End
_0A6B:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0A86
    ApplyMovement obj_T20_gsrivel, _1808
    GoTo _0AC0
_0A86:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0AC0
    ApplyMovement obj_T20_gsrivel, _1818
    WaitMovement
    Message msg_0542_T20_00014
    CloseMessage
    GoToIfUnset FLAG_HGSS_GOT_STARTER, _0AF8
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0AE5
    GoTo _0B46
_0AC0:
    WaitMovement
    Message msg_0542_T20_00014
    CloseMessage
    GoToIfUnset FLAG_HGSS_GOT_STARTER, _0AF8
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0AE5
    GoTo _0B46
_0AE5:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0AF8
    GoTo _0B1E
_0AF8:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0B0B
    GoTo _0B8E
_0B0B:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0B1E
    GoTo _0B6E
_0B1E:
    ApplyMovement obj_T20_gsrivel, _1820
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _17E8
    ApplyMovement LOCALID_PLAYER, _1844
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _1830
    WaitMovement
    ReleaseAll
    End
_0B46:
    ApplyMovement obj_T20_gsrivel, _185C
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _17F8
    ApplyMovement LOCALID_PLAYER, _1874
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _1830
    WaitMovement
    ReleaseAll
    End
_0B6E:
    ApplyMovement obj_T20_gsrivel, _1820
    ApplyMovement LOCALID_PLAYER, _1844
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _1830
    WaitMovement
    ReleaseAll
    End
_0B8E:
    ApplyMovement obj_T20_gsrivel, _185C
    ApplyMovement LOCALID_PLAYER, _1874
    WaitMovement
    ApplyMovement obj_T20_gsrivel, _1830
    WaitMovement
    ReleaseAll
    End
_0BAE:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 1
    GoToIf 5, _0BC4
    Message msg_0542_T20_00005
    GoTo _0BFF
_0BC4:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_TOWN_OW, 2
    GoToIf 5, _0BDA
    Message msg_0542_T20_00005
    GoTo _0BFF
_0BDA:
    CompareVar VAR_HGSS_SCENE_NEW_BARK_WEST_EXIT, 1
    GoToIf 5, _0BF0
    Message msg_0542_T20_00000
    GoTo _0BFF
_0BF0:
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00006, msg_0542_T20_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0BFF:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0C07:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0C22
    ApplyMovement obj_T20_gswoman1, _1910
    GoTo _0CCD
_0C22:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0C3D
    ApplyMovement obj_T20_gswoman1, _1920
    GoTo _0CCD
_0C3D:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0C58
    ApplyMovement obj_T20_gswoman1, _1930
    GoTo _0CCD
_0C58:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0C73
    ApplyMovement obj_T20_gswoman1, _1938
    GoTo _0CCD
_0C73:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0C8E
    ApplyMovement obj_T20_gswoman1, _1948
    GoTo _0CCD
_0C8E:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0CCD
    ApplyMovement obj_T20_gswoman1, _1958
    WaitMovement
    Message msg_0542_T20_00003
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0CF7
    ApplyMovement obj_T20_gswoman1, _19C4
    ApplyMovement LOCALID_PLAYER, _1AAC
    GoTo _0DD0
_0CCD:
    WaitMovement
    Message msg_0542_T20_00003
    CloseMessage
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0CF7
    ApplyMovement obj_T20_gswoman1, _19C4
    ApplyMovement LOCALID_PLAYER, _1AAC
    GoTo _0DD0
_0CF7:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0D1A
    ApplyMovement obj_T20_gswoman1, _19D8
    ApplyMovement LOCALID_PLAYER, _1ABC
    GoTo _0DD0
_0D1A:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0D3D
    ApplyMovement obj_T20_gswoman1, _19EC
    ApplyMovement LOCALID_PLAYER, _1ACC
    GoTo _0DD0
_0D3D:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0D60
    ApplyMovement obj_T20_gswoman1, _1A00
    ApplyMovement LOCALID_PLAYER, _1ADC
    GoTo _0DD0
_0D60:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0D83
    ApplyMovement obj_T20_gswoman1, _1A0C
    ApplyMovement LOCALID_PLAYER, _1AE4
    GoTo _0DD0
_0D83:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0DA6
    ApplyMovement obj_T20_gswoman1, _1A20
    ApplyMovement LOCALID_PLAYER, _1AF4
    GoTo _0DD0
_0DA6:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0DD0
    ApplyMovement obj_T20_gswoman1, _1A30
    ApplyMovement LOCALID_PLAYER, _1B04
    WaitMovement
    Message msg_0542_T20_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DD0:
    WaitMovement
    Message msg_0542_T20_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0DDD:
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0E06
    ApplyMovement LOCALID_PLAYER, _18CC
    ApplyMovement obj_T20_gswoman1, _1968
    GoTo _0F06
_0E06:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0E29
    ApplyMovement LOCALID_PLAYER, _18CC
    ApplyMovement obj_T20_gswoman1, _1974
    GoTo _0F06
_0E29:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0E4C
    ApplyMovement LOCALID_PLAYER, _18CC
    ApplyMovement obj_T20_gswoman1, _1980
    GoTo _0F06
_0E4C:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0E6F
    ApplyMovement LOCALID_PLAYER, _18C0
    ApplyMovement obj_T20_gswoman1, _198C
    GoTo _0F06
_0E6F:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0E92
    ApplyMovement LOCALID_PLAYER, _18C0
    ApplyMovement obj_T20_gswoman1, _19A0
    GoTo _0F06
_0E92:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0EB5
    ApplyMovement LOCALID_PLAYER, _18C0
    ApplyMovement obj_T20_gswoman1, _19AC
    GoTo _0F06
_0EB5:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _0F06
    ApplyMovement LOCALID_PLAYER, _18C0
    ApplyMovement obj_T20_gswoman1, _19B8
    WaitMovement
    Message msg_0542_T20_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0F3A
    ApplyMovement obj_T20_gswoman1, _1A40
    ApplyMovement LOCALID_PLAYER, _1B14
    GoTo _101D
_0F06:
    WaitMovement
    Message msg_0542_T20_00010
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _0F3A
    ApplyMovement obj_T20_gswoman1, _1A40
    ApplyMovement LOCALID_PLAYER, _1B14
    GoTo _101D
_0F3A:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _0F5D
    ApplyMovement obj_T20_gswoman1, _1A50
    ApplyMovement LOCALID_PLAYER, _1B20
    GoTo _101D
_0F5D:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _0F80
    ApplyMovement obj_T20_gswoman1, _1A60
    ApplyMovement LOCALID_PLAYER, _1B2C
    GoTo _101D
_0F80:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _0FA3
    ApplyMovement obj_T20_gswoman1, _1A6C
    ApplyMovement LOCALID_PLAYER, _1B38
    GoTo _101D
_0FA3:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _0FC6
    ApplyMovement obj_T20_gswoman1, _1A80
    ApplyMovement LOCALID_PLAYER, _1B4C
    GoTo _101D
_0FC6:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _0FE9
    ApplyMovement obj_T20_gswoman1, _1A8C
    ApplyMovement LOCALID_PLAYER, _1B58
    GoTo _101D
_0FE9:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _101D
    ApplyMovement obj_T20_gswoman1, _1A9C
    ApplyMovement LOCALID_PLAYER, _1B64
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0542_T20_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_101D:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0542_T20_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_1034:
    LoadDoorAnimation 21, 12, 12, 9, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    AddObject obj_T20_doctor
    SetPosition obj_T20_doctor, 684, 0, 393, DIR_SOUTH
    ApplyMovement obj_T20_doctor, _1BE0
    WaitMovement
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    Message msg_0542_T20_00017
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _18AC
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _10A0
    ApplyMovement obj_T20_doctor, _1B70
    ApplyMovement LOCALID_PLAYER, _18E0
    GoTo _11AF
_10A0:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _10C3
    ApplyMovement obj_T20_doctor, _1B80
    ApplyMovement LOCALID_PLAYER, _18F0
    GoTo _11AF
_10C3:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _10E6
    ApplyMovement obj_T20_doctor, _1B90
    ApplyMovement LOCALID_PLAYER, _18F0
    GoTo _11AF
_10E6:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _1109
    ApplyMovement obj_T20_doctor, _1BA0
    ApplyMovement LOCALID_PLAYER, _18F0
    GoTo _11AF
_1109:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _112C
    ApplyMovement obj_T20_doctor, _1BB0
    ApplyMovement LOCALID_PLAYER, _18F0
    GoTo _11AF
_112C:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _114F
    ApplyMovement obj_T20_doctor, _1BC0
    ApplyMovement LOCALID_PLAYER, _18D8
    GoTo _11AF
_114F:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _11AF
    ApplyMovement obj_T20_doctor, _1BD0
    ApplyMovement LOCALID_PLAYER, _18D8
    WaitMovement
    Message msg_0542_T20_00018
    @ HGSS: RegisterGearNumber PHONE_CONTACT_PROF__ELM
    BufferPlayerName 0
    Message msg_0542_T20_00019
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0542_T20_00020
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _11F2
    ApplyMovement LOCALID_PLAYER, _18B8
    ApplyMovement obj_T20_doctor, _1BF0
    GoTo _12D2
_11AF:
    WaitMovement
    Message msg_0542_T20_00018
    @ HGSS: RegisterGearNumber PHONE_CONTACT_PROF__ELM
    BufferPlayerName 0
    Message msg_0542_T20_00019
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0542_T20_00020
    CloseMessage
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 396
    GoToIf 5, _11F2
    ApplyMovement LOCALID_PLAYER, _18B8
    ApplyMovement obj_T20_doctor, _1BF0
    GoTo _12D2
_11F2:
    CompareVar VAR_MAP_LOCAL_0x01, 397
    GoToIf 5, _1215
    ApplyMovement LOCALID_PLAYER, _18B8
    ApplyMovement obj_T20_doctor, _1BFC
    GoTo _12D2
_1215:
    CompareVar VAR_MAP_LOCAL_0x01, 398
    GoToIf 5, _1238
    ApplyMovement LOCALID_PLAYER, _18D8
    ApplyMovement obj_T20_doctor, _1C08
    GoTo _12D2
_1238:
    CompareVar VAR_MAP_LOCAL_0x01, 399
    GoToIf 5, _1253
    ApplyMovement obj_T20_doctor, _1C18
    GoTo _12D2
_1253:
    CompareVar VAR_MAP_LOCAL_0x01, 400
    GoToIf 5, _126E
    ApplyMovement obj_T20_doctor, _1C28
    GoTo _12D2
_126E:
    CompareVar VAR_MAP_LOCAL_0x01, 401
    GoToIf 5, _1289
    ApplyMovement obj_T20_doctor, _1C38
    GoTo _12D2
_1289:
    CompareVar VAR_MAP_LOCAL_0x01, 402
    GoToIf 5, _12D2
    ApplyMovement obj_T20_doctor, _1C48
    WaitMovement
    LoadDoorAnimation 21, 12, 12, 9, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T20_doctor, _1BE8
    WaitMovement
    RemoveObject obj_T20_doctor
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_WEST_EXIT, 1
    ReleaseAll
    End
_12D2:
    WaitMovement
    LoadDoorAnimation 21, 12, 12, 9, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T20_doctor, _1BE8
    WaitMovement
    RemoveObject obj_T20_doctor
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_WEST_EXIT, 1
    ReleaseAll
    End
_1306:
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_NEW_BARK_ELMS_LAB_2F, 12, 6, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    @ HGSS: ScrCmd_582 MAP_NEW_BARK, 688, 393
    SetVarFromValue VAR_HGSS_UNK_407C, 1
    End
_1342:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _135D
    ApplyMovement LOCALID_PLAYER, _1DF4
    GoTo _13F1
_135D:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _1380
    ApplyMovement LOCALID_PLAYER, _1E14
    ApplyMovement obj_T20_gsmiddleman1, _1E28
    GoTo _13F1
_1380:
    ApplyMovement LOCALID_PLAYER, _1E00
    ApplyMovement obj_T20_gsmiddleman1, _1E28
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1452
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1E34
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 0
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
_13F1:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _1452
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _1E34
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 0
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
_1452:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 0
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
_148C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_14A0:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_14B4:
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8005, 398
    GoToIf 5, _14F0
    ApplyMovement obj_T20_gsmama, _1E4C
    ApplyMovement LOCALID_PLAYER, _1E70
    GoTo _158B
_14F0:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1513
    ApplyMovement obj_T20_gsmama, _1E58
    ApplyMovement LOCALID_PLAYER, _1E7C
    GoTo _158B
_1513:
    CompareVar VAR_0x8005, 400
    GoToIf 5, _1536
    ApplyMovement obj_T20_gsmama, _1E64
    ApplyMovement LOCALID_PLAYER, _1E88
    GoTo _158B
_1536:
    CompareVar VAR_0x8005, 401
    GoToIf 5, _1559
    ApplyMovement obj_T20_gsmama, _1E64
    ApplyMovement LOCALID_PLAYER, _1E94
    GoTo _158B
_1559:
    ApplyMovement obj_T20_gsmama, _1E64
    ApplyMovement LOCALID_PLAYER, _1EA4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _15AD
    Message msg_0542_T20_00022
    GoTo _15CF
_158B:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _15AD
    Message msg_0542_T20_00022
    GoTo _15CF
_15AD:
    Message msg_0542_T20_00023
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _15EE
    ApplyMovement obj_T20_gsmama, _1EB4
    WaitMovement
    GoTo _1653
_15CF:
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _15EE
    ApplyMovement obj_T20_gsmama, _1EB4
    WaitMovement
    GoTo _1653
_15EE:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _160B
    ApplyMovement obj_T20_gsmama, _1EBC
    WaitMovement
    GoTo _1653
_160B:
    ApplyMovement obj_T20_gsmama, _1EC4
    WaitMovement
    LoadDoorAnimation 21, 12, 23, 12, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T20_gsmama, _1ECC
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MOM
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20_gsmama
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    AddVar VAR_MAP_LOCAL_0x07, 1
    ReleaseAll
    End
_1653:
    LoadDoorAnimation 21, 12, 23, 12, 77
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    ApplyMovement obj_T20_gsmama, _1ECC
    WaitMovement
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MOM
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T20_gsmama
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    AddVar VAR_MAP_LOCAL_0x07, 1
    ReleaseAll
    End
_1691:
    Message msg_0542_T20_00024
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _1ED4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ReleaseAll
    End
_16B8:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _16D3
    ApplyMovement obj_T20_var_1_2, _1EF0
    GoTo _1749
_16D3:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _16EE
    ApplyMovement obj_T20_var_1_2, _1EF8
    GoTo _1749
_16EE:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _1709
    ApplyMovement obj_T20_var_1_2, _1F00
    GoTo _1749
_1709:
    ApplyMovement obj_T20_var_1_2, _1F08
    ApplyMovement LOCALID_PLAYER, _1F10
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00029, msg_0542_T20_00030
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _1781
    ApplyMovement obj_T20_var_1_2, _1F18
    GoTo _17E0
_1749:
    ApplyMovement LOCALID_PLAYER, _1F10
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferPlayerName 0
    MessageGendered msg_0542_T20_00029, msg_0542_T20_00030
    CloseMessage
    CompareVar VAR_0x8005, 398
    GoToIf 5, _1781
    ApplyMovement obj_T20_var_1_2, _1F18
    GoTo _17E0
_1781:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _179C
    ApplyMovement obj_T20_var_1_2, _1F20
    GoTo _17E0
_179C:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _17B7
    ApplyMovement obj_T20_var_1_2, _1F28
    GoTo _17E0
_17B7:
    CompareVar VAR_0x8005, 399
    GoToIf 5, _17D2
    ApplyMovement obj_T20_var_1_2, _1F30
    GoTo _17E0
_17D2:
    ApplyMovement obj_T20_var_1_2, _1F38
    WaitMovement
    ReleaseAll
    End
_17E0:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_17E8:
    LockDir
    WalkSlightlyFastSouth 4
    UnlockDir
    EndMovement
    .balign 4, 0
_17F8:
    LockDir
    WalkSlightlyFastSouth 6
    UnlockDir
    EndMovement
    .balign 4, 0
_1808:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1810:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1818:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1820:
    WalkSlightlyFastWest
    FaceSouth
    WalkSlightlyFastSouth 2
    EndMovement
    .balign 4, 0
_1830:
    FaceNorth
    WalkNormalNorth 2
    FaceEast
    WalkNormalEast
    EndMovement
    .balign 4, 0
_1844:
    FaceNorth
    LockDir
    WalkSlightlyFastSouth 2
    JumpFarSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_185C:
    WalkSlightlyFastNorth
    FaceWest
    WalkSlightlyFastWest
    FaceSouth
    WalkSlightlyFastSouth 3
    EndMovement
    .balign 4, 0
_1874:
    FaceEast
    LockDir
    WalkSlightlyFastWest
    UnlockDir
    FaceNorth
    LockDir
    WalkSlightlyFastSouth 3
    JumpFarSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_189C:
    WalkOnSpotNormalWest
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_18AC:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_18B8:
    FaceEast
    EndMovement
    .balign 4, 0
_18C0:
    Delay32 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_18CC:
    Delay32 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_18D8:
    FaceNorth
    EndMovement
    .balign 4, 0
_18E0:
    FaceEast
    Delay32 2
    FaceSouth
    EndMovement
    .balign 4, 0
_18F0:
    FaceEast
    Delay32 2
    FaceNorth
    EndMovement
    .balign 4, 0
_1900:
    WalkNormalWest 3
    WalkNormalNorth 3
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_1910:
    WalkNormalWest 3
    WalkNormalNorth 2
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_1920:
    WalkNormalWest 3
    WalkNormalNorth
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_1930:
    WalkNormalWest 6
    EndMovement
    .balign 4, 0
_1938:
    WalkNormalWest 3
    WalkNormalSouth
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_1948:
    WalkNormalWest 6
    WalkNormalSouth 2
    FaceWest
    EndMovement
    .balign 4, 0
_1958:
    WalkNormalWest 6
    WalkNormalSouth 3
    FaceWest
    EndMovement
    .balign 4, 0
_1968:
    WalkNormalWest 7
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_1974:
    WalkNormalWest 7
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1980:
    WalkNormalWest 7
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_198C:
    WalkNormalWest 3
    WalkNormalNorth
    WalkNormalWest 4
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_19A0:
    WalkNormalWest 7
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_19AC:
    WalkNormalWest 7
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_19B8:
    WalkNormalWest 7
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_19C4:
    WalkNormalEast 3
    WalkNormalSouth 3
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_19D8:
    WalkNormalEast 3
    WalkNormalSouth 2
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_19EC:
    WalkNormalEast 3
    WalkNormalSouth
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A00:
    WalkNormalEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A0C:
    WalkNormalEast 3
    WalkNormalNorth
    WalkNormalEast 3
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A20:
    WalkNormalNorth 2
    WalkNormalEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A30:
    WalkNormalNorth 3
    WalkNormalEast 6
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A40:
    WalkNormalSouth 2
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A50:
    WalkNormalSouth
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A60:
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A6C:
    WalkNormalEast 3
    WalkNormalSouth
    WalkNormalEast 4
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A80:
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A8C:
    WalkNormalNorth
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1A9C:
    WalkNormalNorth 2
    WalkNormalEast 7
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1AAC:
    WalkNormalEast 4
    WalkNormalSouth 3
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_1ABC:
    WalkNormalEast 4
    WalkNormalSouth 2
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_1ACC:
    WalkNormalEast 4
    WalkNormalSouth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_1ADC:
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_1AE4:
    WalkNormalEast 4
    WalkNormalNorth
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_1AF4:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_1B04:
    WalkNormalEast
    WalkNormalNorth 3
    WalkNormalEast 5
    EndMovement
    .balign 4, 0
_1B14:
    WalkNormalSouth 3
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_1B20:
    WalkNormalSouth 2
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_1B2C:
    WalkNormalSouth
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_1B38:
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalSouth
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_1B4C:
    WalkNormalNorth
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_1B58:
    WalkNormalNorth 2
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_1B64:
    WalkNormalNorth 3
    WalkNormalEast 6
    EndMovement
    .balign 4, 0
_1B70:
    WalkNormalSouth 3
    WalkNormalWest 8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1B80:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1B90:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1BA0:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 2
    EndMovement
    .balign 4, 0
_1BB0:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_1BC0:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_1BD0:
    WalkNormalSouth 2
    WalkNormalWest 8
    WalkNormalSouth 5
    EndMovement
    .balign 4, 0
_1BE0:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1BE8:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1BF0:
    WalkNormalEast 8
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_1BFC:
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_1C08:
    WalkNormalNorth
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_1C18:
    WalkNormalNorth 2
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_1C28:
    WalkNormalNorth 2
    WalkNormalEast 8
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_1C38:
    WalkNormalNorth 2
    WalkNormalEast 8
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_1C48:
    WalkNormalNorth 5
    WalkNormalEast 8
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_1C58:
    Delay32
    WalkFastNorth 8
    LockDir
    JumpNearFastSouth
    UnlockDir
    FaceEast 5
    FaceNorth 5
    FaceWest 5
    FaceNorth 5
    WalkNormalNorth
    Delay32
    EndMovement
    .balign 4, 0
_1C88:
    FaceWest
    EmoteExclamationMark
    WalkOnSpotFastNorth 4
    FaceSouth 2
    FaceEast 2
    FaceNorth 2
    FaceWest 2
    WalkOnSpotFastWest 4
    WalkFastWest 6
    EndMovement
    .balign 4, 0
_1CB0:
    JumpOnSpotFastWest 4
    EndMovement
    .balign 4, 0
_1CB8:
    FaceWest
    WalkNormalWest
    FaceSouth
    WalkNormalSouth 4
    FaceWest
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_1CD4:
    FaceWest 4
    EndMovement
    .balign 4, 0
_1CDC:
    Delay16
    WalkNormalSouth 6
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_1CF0:
    WalkOnSpotFastEast 4
    EndMovement
    .balign 4, 0
_1CF8:
    FaceSouth
    WalkNormalSouth 4
    FaceWest
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_1D0C:
    Delay4 4
    Delay4 2
    WalkOnSpotFastSouth
    Delay4 2
    WalkOnSpotFastEast
    Delay4
    WalkOnSpotFastNorth
    Delay4
    WalkOnSpotFastSouth
    Delay4
    WalkOnSpotFastNorth
    Delay4
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_1D44:
    JumpOnSpotFastEast 3
    WalkFastSouth
    WalkFastEast 2
    WalkFastNorth 2
    WalkFastWest 2
    WalkFastSouth 2
    WalkFastNorth 2
    WalkFastEast 2
    WalkFastSouth
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1D70:
    WalkNormalSouth 2
    WalkNormalEast
    EndMovement
    .balign 4, 0
_1D7C:
    Delay8
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1D88:
    WalkNormalSouth
    WalkNormalWest 2
    WalkNormalSouth 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1D9C:
    WalkNormalWest
    WalkNormalSouth
    WalkNormalWest 2
    WalkOnSpotNormalNorth
    Delay8 3
    WalkOnSpotNormalSouth
    WalkFastSouth 4
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_1DC0:
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1DCC:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_1DD4:
    WalkNormalSouth 4
    EndMovement
    .balign 4, 0
_1DDC:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1DF4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1E00:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1E14:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_1E28:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_1E34:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_1E44:
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_1E4C:
    WalkNormalSouth
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1E58:
    WalkNormalSouth 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1E64:
    WalkNormalSouth 3
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1E70:
    WalkOnSpotNormalWest
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_1E7C:
    WalkOnSpotNormalWest
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_1E88:
    WalkOnSpotNormalWest
    WalkNormalWest 4
    EndMovement
    .balign 4, 0
_1E94:
    WalkNormalWest 2
    WalkNormalNorth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_1EA4:
    WalkNormalWest 2
    WalkNormalNorth 2
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_1EB4:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1EBC:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_1EC4:
    WalkNormalNorth 3
    EndMovement
    .balign 4, 0
_1ECC:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_1ED4:
    WalkNormalWest
    EndMovement
    .balign 4, 0
_1EDC:
    FaceEast
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_1EE8:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1EF0:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1EF8:
    WalkNormalEast
    EndMovement
    .balign 4, 0
_1F00:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1F08:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_1F10:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_1F18:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1F20:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1F28:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1F30:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1F38:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_1F40:
    JumpOnSpotSlowEast
    JumpOnSpotSlowEast
    EndMovement
    .balign 4, 0
_1F4C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
