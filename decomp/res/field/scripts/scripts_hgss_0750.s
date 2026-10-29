#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0460.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T03_gsmiddleman1 7
#define obj_T03_daigo 8
#define obj_T03_tsure_poke_static_latios 9
#define obj_T03_tsure_poke_static_latias 10

    ScriptEntry scr_seq_T03_000
    ScriptEntry scr_seq_T03_001
    ScriptEntry scr_seq_T03_002
    ScriptEntry scr_seq_T03_003
    ScriptEntry scr_seq_T03_004
    ScriptEntry scr_seq_T03_005
    ScriptEntry scr_seq_T03_006
    ScriptEntry scr_seq_T03_007
    ScriptEntry scr_seq_T03_008
    ScriptEntry scr_seq_T03_009
    ScriptEntry scr_seq_T03_010
    ScriptEntry scr_seq_T03_011
    ScriptEntry scr_seq_T03_012
    ScriptEntry scr_seq_T03_013
    ScriptEntryEnd
scr_seq_T03_008:
    GoToIfUnset FLAG_HGSS_UNK_189, _004B
    ClearFlag FLAG_HGSS_UNK_189
    End
_004B:
    GoTo _030E
_0051:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0075
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 1, _0075
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0075:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T03_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _00A5
    GoToIfSet FLAG_HGSS_UNK_094, _0108
    GoTo _00B0
_00A5:
    GoToIfSet FLAG_HGSS_UNK_093, _0108
_00B0:
    Message msg_0460_T03_00002
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _00E6
    SetVarFromValue VAR_0x8004, ITEM_SILVER_WING
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_UNK_094
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA
    SetFlag FLAG_HGSS_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS
    GoTo _0102
_00E6:
    SetVarFromValue VAR_0x8004, ITEM_RAINBOW_WING
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    SetFlag FLAG_HGSS_UNK_093
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_HO_OH
    SetFlag FLAG_HGSS_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS
_0102:
    CloseMessage
    ReleaseAll
    End
_0108:
    Message msg_0460_T03_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0218
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _022C
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0184
    ApplyMovement LOCALID_PLAYER, _0240
    GoTo _01B7
_0184:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _01A7
    ApplyMovement LOCALID_PLAYER, _0260
    ApplyMovement obj_T03_gsmiddleman1, _0274
    GoTo _01B7
_01A7:
    ApplyMovement LOCALID_PLAYER, _024C
    ApplyMovement obj_T03_gsmiddleman1, _0274
_01B7:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01DE
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0280
    WaitMovement
_01DE:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 66
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
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_022C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0240:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_024C:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0260:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0274:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0280:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T03_001:
    NPCMessage msg_0460_T03_00000
    End
scr_seq_T03_002:
    NPCMessage msg_0460_T03_00001
    End
scr_seq_T03_003:
    DrawSignpostInstantMessage msg_0460_T03_00020, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T03_004:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0460_T03_00021, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T03_005:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0460_T03_00022, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T03_006:
    DrawSignpostInstantMessage msg_0460_T03_00023, SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
_030E:
    CompareVar VAR_HGSS_UNK_4083, 4
    GoToIf 1, _0341
    CompareVar VAR_HGSS_UNK_4083, 2
    GoToIf 1, _033D
    CompareVar VAR_HGSS_UNK_4083, 3
    GoToIf 1, _033D
    GoTo _0051
    End
_033D:
    ClearFlag FLAG_HGSS_HIDE_PEWTER_CITY_STEVEN
_0341:
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _035C
    ClearFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIOS
    GoTo _0360
_035C:
    ClearFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIAS
_0360:
    End
scr_seq_T03_011:
    CompareVar VAR_HGSS_UNK_4083, 2
    GoToIf 1, _0371
    End
_0371:
    SetPosition obj_T03_daigo, 1047, 6, 81, DIR_WEST
    End
scr_seq_T03_013:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _038C
    End
_038C:
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _03AB
    SetFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIOS
    RemoveObject obj_T03_tsure_poke_static_latios
    GoTo _03B3
_03AB:
    SetFlag FLAG_HGSS_HIDE_PEWTER_CITY_LATIAS
    RemoveObject obj_T03_tsure_poke_static_latias
_03B3:
    End
scr_seq_T03_012:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0440
    WaitMovement
    ApplyMovement obj_T03_daigo, _045C
    WaitMovement
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _03F1
    Message msg_0460_T03_00006
    GoTo _03F4
_03F1:
    Message msg_0460_T03_00007
_03F4:
    CloseMessage
    ApplyMovement obj_T03_daigo, _0464
    ApplyMovement LOCALID_PLAYER, _0464
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _042C
    Message msg_0460_T03_00008
    GoTo _042F
_042C:
    Message msg_0460_T03_00009
_042F:
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 3
    ReleaseAll
    End
    .balign 4, 0
_0440:
    WalkNormalSouth 4
    FaceWest
    EndMovement
    .balign 4, 0
_044C:
    Delay8
    WalkNormalEast 2
    Delay8
    EndMovement
    .balign 4, 0
_045C:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0464:
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_046C:
    WalkNormalSouth 2
    WalkNormalWest
    EndMovement
    .balign 4, 0
_0478:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0480:
    WalkNormalEast 8
    EndMovement
scr_seq_T03_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_546 0, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0649
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _04C8
    SetVarFromValue VAR_MAP_LOCAL_0x0A, SPECIES_LATIOS
    PlayCry VAR_MAP_LOCAL_0x0A, 0
    Message msg_0460_T03_00010
    GoTo _04D7
_04C8:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, SPECIES_LATIAS
    PlayCry VAR_MAP_LOCAL_0x0A, 0
    Message msg_0460_T03_00011
_04D7:
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle VAR_TEMP_x400A, 40, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _057B
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _057B
    @ HGSS: LatiCaughtCheck VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0526
    CompareVar VAR_RESULT, 0
    GoToIf 1, _055A
_0526:
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0540
    Message msg_0460_T03_00012
    GoTo _0543
_0540:
    Message msg_0460_T03_00013
_0543:
    CloseMessage
    CompareVar VAR_HGSS_UNK_4083, 4
    GoToIf 1, _0649
    GoTo _0585
    End
_055A:
    SetVarFromVar VAR_MAP_LOCAL_0x09, VAR_HGSS_UNK_4083
    SetVarFromValue VAR_HGSS_UNK_4083, 5
    CompareVar VAR_MAP_LOCAL_0x09, 4
    GoToIf 1, _0649
    GoTo _0585
    End
_057B:
    BlackOutFromBattle
    GoTo _0649
    End
_0585:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T03_daigo, _046C
    ApplyMovement LOCALID_PLAYER, _044C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _060C
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _05D2
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _05FF
_05D2:
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _05EC
    Message msg_0460_T03_00016
    GoTo _05EF
_05EC:
    Message msg_0460_T03_00017
_05EF:
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 4
    GoTo _061F
    End
_05FF:
    Message msg_0460_T03_00014
    CloseMessage
    GoTo _061F
    End
_060C:
    Message msg_0460_T03_00018
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4083, 4
    GoTo _061F
    End
_061F:
    ApplyMovement obj_T03_daigo, _0478
    WaitMovement
    Message msg_0460_T03_00015
    CloseMessage
    ApplyMovement obj_T03_daigo, _0480
    WaitMovement
    RemoveObject obj_T03_daigo
    CompareVar VAR_HGSS_UNK_4130, 4
    CallIf 1, _064D
_0649:
    ReleaseAll
    End
_064D:
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    Return
scr_seq_T03_009:
    NPCMessage msg_0460_T03_00019
    End
    .balign 4, 0
