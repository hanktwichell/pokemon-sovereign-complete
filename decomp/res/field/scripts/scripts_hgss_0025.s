#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0062.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D22R0101_counterm 20
#define obj_D22R0101_gsmiddleman1_3 26
#define obj_D22R0101_gsmiddleman1_4 27

    ScriptEntry scr_seq_D22R0101_000
    ScriptEntry scr_seq_D22R0101_001
    ScriptEntry scr_seq_D22R0101_002
    ScriptEntry scr_seq_D22R0101_003
    ScriptEntry scr_seq_D22R0101_004
    ScriptEntry scr_seq_D22R0101_005
    ScriptEntry scr_seq_D22R0101_006
    ScriptEntry scr_seq_D22R0101_007
    ScriptEntry scr_seq_D22R0101_008
    ScriptEntry scr_seq_D22R0101_009
    ScriptEntry scr_seq_D22R0101_010
    ScriptEntry scr_seq_D22R0101_011
    ScriptEntry scr_seq_D22R0101_012
    ScriptEntry scr_seq_D22R0101_013
    ScriptEntry scr_seq_D22R0101_014
    ScriptEntry scr_seq_D22R0101_015
    ScriptEntry scr_seq_D22R0101_016
    ScriptEntry scr_seq_D22R0101_017
    ScriptEntry scr_seq_D22R0101_018
    ScriptEntry scr_seq_D22R0101_019
    ScriptEntry scr_seq_D22R0101_020
    ScriptEntry scr_seq_D22R0101_021
    ScriptEntry scr_seq_D22R0101_022
    ScriptEntry scr_seq_D22R0101_023
    ScriptEntry scr_seq_D22R0101_024
    ScriptEntry scr_seq_D22R0101_025
    ScriptEntry scr_seq_D22R0101_026
    ScriptEntryEnd
scr_seq_D22R0101_011:
    CompareVar VAR_HGSS_UNK_40F7, 1
    CallIf 1, _007D
    End
_007D:
    SetPosition obj_D22R0101_counterm, 51, 0, 48, DIR_SOUTH
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 10
    SetVarFromValue VAR_MAP_LOCAL_0x02, 48
    @ HGSS: ScriptOverlayCmd 1, 0
_009F:
    @ HGSS: IsBugContestantRegistered VAR_TEMP_x4000, VAR_TEMP_x4004
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 5, _00C4
    SetPosition VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x02, 0, 50, DIR_NORTH
    AddVar VAR_MAP_LOCAL_0x02, 2
_00C4:
    AddVar VAR_MAP_LOCAL_0x00, 1
    AddVar VAR_MAP_LOCAL_0x01, 1
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 0, _009F
    @ HGSS: ScriptOverlayCmd 1, 1
    Return
scr_seq_D22R0101_025:
    GoToIfUnset FLAG_HGSS_UNK_189, _00F4
    ClearFlag FLAG_HGSS_UNK_189
    End
_00F4:
    CompareVar VAR_HGSS_UNK_40F7, 1
    GoToIf 1, _0162
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0154
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0154
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0162
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0162
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0162
    SetFlag FLAG_HGSS_HIDE_CAMERON
    ClearFlag FLAG_HGSS_UNK_27F
    GoTo _016E
_0154:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    GoTo _016E
_0162:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    ClearFlag FLAG_HGSS_UNK_996
_016E:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _017F
    SetFlag FLAG_HGSS_UNK_288
    End
_017F:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BUGSY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _01C9
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _01C3
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _01C3
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _01C3
    SetFlag FLAG_HGSS_UNK_288
    End
_01C3:
    ClearFlag FLAG_HGSS_UNK_288
    End
_01C9:
    SetFlag FLAG_HGSS_UNK_288
    End
scr_seq_D22R0101_012:
    NPCMessage msg_0062_D22R0101_00045
    End
scr_seq_D22R0101_013:
    NPCMessage msg_0062_D22R0101_00048
    End
scr_seq_D22R0101_014:
    NPCMessage msg_0062_D22R0101_00051
    End
scr_seq_D22R0101_015:
    NPCMessage msg_0062_D22R0101_00054
    End
scr_seq_D22R0101_016:
    NPCMessage msg_0062_D22R0101_00057
    End
scr_seq_D22R0101_017:
    NPCMessage msg_0062_D22R0101_00060
    End
scr_seq_D22R0101_018:
    NPCMessage msg_0062_D22R0101_00063
    End
scr_seq_D22R0101_019:
    NPCMessage msg_0062_D22R0101_00066
    End
scr_seq_D22R0101_020:
    NPCMessage msg_0062_D22R0101_00069
    End
scr_seq_D22R0101_021:
    NPCMessage msg_0062_D22R0101_00072
    End
scr_seq_D22R0101_022:
    NPCMessage msg_0062_D22R0101_00042
    End
scr_seq_D22R0101_026:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _02C7
    BufferPlayerName 0
    Message msg_0062_D22R0101_00084
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02C7:
    BufferPlayerName 0
    Message msg_0062_D22R0101_00085
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _032B
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0336
    Message msg_0062_D22R0101_00086
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 7
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0062_D22R0101_00087
    WaitButton
    CloseMessage
    ReleaseAll
    End
_032B:
    Message msg_0062_D22R0101_00088
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0336:
    Message msg_0062_D22R0101_00089
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_QUICK_CLAW_FROM_NATIONAL_PARK_WOMAN, _0380
    Message msg_0062_D22R0101_00002
    SetVar VAR_0x8004, ITEM_QUICK_CLAW
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _038B
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_QUICK_CLAW_FROM_NATIONAL_PARK_WOMAN
_0380:
    Message msg_0062_D22R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_038B:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0101_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0650
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0664
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _040E
    ApplyMovement LOCALID_PLAYER, _04C0
    ApplyMovement obj_D22R0101_gsmiddleman1_3, _050C
    GoTo _045C
_040E:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0429
    ApplyMovement LOCALID_PLAYER, _04D8
    GoTo _045C
_0429:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _044C
    ApplyMovement LOCALID_PLAYER, _04F8
    ApplyMovement obj_D22R0101_gsmiddleman1_3, _050C
    GoTo _045C
_044C:
    ApplyMovement LOCALID_PLAYER, _04E4
    ApplyMovement obj_D22R0101_gsmiddleman1_3, _050C
_045C:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0483
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0518
    WaitMovement
_0483:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 16
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
    .balign 4, 0
_04C0:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04D8:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04E4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_04F8:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_050C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0518:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D22R0101_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0650
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0664
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05A1
    ApplyMovement LOCALID_PLAYER, _04C0
    ApplyMovement obj_D22R0101_gsmiddleman1_4, _050C
    GoTo _05EF
_05A1:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05BC
    ApplyMovement LOCALID_PLAYER, _04D8
    GoTo _05EF
_05BC:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _05DF
    ApplyMovement LOCALID_PLAYER, _0678
    ApplyMovement obj_D22R0101_gsmiddleman1_4, _050C
    GoTo _05EF
_05DF:
    ApplyMovement LOCALID_PLAYER, _04E4
    ApplyMovement obj_D22R0101_gsmiddleman1_4, _050C
_05EF:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0616
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0518
    WaitMovement
_0616:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 17
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
_0650:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0664:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0678:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_D22R0101_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0062_D22R0101_00022, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0101_002:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0062_D22R0101_00023, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0101_003:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0062_D22R0101_00024, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0101_004:
    NPCMessage msg_0062_D22R0101_00000
    End
scr_seq_D22R0101_005:
    NPCMessage msg_0062_D22R0101_00001
    End
scr_seq_D22R0101_006:
    NPCMessage msg_0062_D22R0101_00005
    End
scr_seq_D22R0101_007:
    NPCMessage msg_0062_D22R0101_00006
    End
scr_seq_D22R0101_008:
    NPCMessage msg_0062_D22R0101_00009
    End
scr_seq_D22R0101_009:
    NPCMessage msg_0062_D22R0101_00007
    End
scr_seq_D22R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0062_D22R0101_00008
    PlayCry SPECIES_PERSIAN, 0
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0760:
    End
    .balign 4, 0
