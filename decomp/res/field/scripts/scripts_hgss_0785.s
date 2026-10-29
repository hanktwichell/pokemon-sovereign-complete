#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0491.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T07_gsleader12 9
#define obj_T07_gsleader6 10
#define obj_T07_gsmiddleman1 13

    ScriptEntry scr_seq_T07_000
    ScriptEntry scr_seq_T07_001
    ScriptEntry scr_seq_T07_002
    ScriptEntry scr_seq_T07_003
    ScriptEntry scr_seq_T07_004
    ScriptEntry scr_seq_T07_005
    ScriptEntry scr_seq_T07_006
    ScriptEntry scr_seq_T07_007
    ScriptEntry scr_seq_T07_008
    ScriptEntry scr_seq_T07_009
    ScriptEntry scr_seq_T07_010
    ScriptEntry scr_seq_T07_011
    ScriptEntry scr_seq_T07_012
    ScriptEntry scr_seq_T07_013
    ScriptEntry scr_seq_T07_014
    ScriptEntry scr_seq_T07_015
    ScriptEntry scr_seq_T07_016
    ScriptEntry scr_seq_T07_017
    ScriptEntry scr_seq_T07_018
    ScriptEntryEnd
scr_seq_T07_015:
    GoToIfUnset FLAG_HGSS_UNK_189, _005F
    ClearFlag FLAG_HGSS_UNK_189
    End
_005F:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _007A
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0095
_007A:
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 5, _0091
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _0095
_0091:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_0095:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _015E
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _00C3
    GoTo _0198
    End
_00C3:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 6
    GoToIf 5, _00E0
    GoTo _0101
_00DA:
    GoTo _00FF
_00E0:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00F9
    GoTo _0101
_00F3:
    GoTo _00FF
_00F9:
    GoTo _0198
_00FF:
    End
_0101:
    @ HGSS: ScrCmd_522 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 14
    GoToIf 5, _0120
    ClearFlag FLAG_HGSS_UNK_25D
    ClearFlag FLAG_HGSS_UNK_2E1
    GoTo _015C
_0120:
    CompareVar VAR_MAP_LOCAL_0x00, 15
    GoToIf 5, _013B
    ClearFlag FLAG_HGSS_UNK_25D
    ClearFlag FLAG_HGSS_UNK_2E1
    GoTo _015C
_013B:
    CompareVar VAR_MAP_LOCAL_0x00, 16
    GoToIf 5, _0156
    ClearFlag FLAG_HGSS_UNK_25D
    ClearFlag FLAG_HGSS_UNK_2E1
    GoTo _015C
_0156:
    GoTo _0198
_015C:
    End
_015E:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0198
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0190
    ClearFlag FLAG_HGSS_UNK_25D
    SetFlag FLAG_HGSS_UNK_2E1
    GoTo _0196
_0190:
    GoTo _0198
_0196:
    End
_0198:
    SetFlag FLAG_HGSS_UNK_25D
    SetFlag FLAG_HGSS_UNK_2E1
    End
scr_seq_T07_000:
    NPCMessage msg_0491_T07_00000
    End
scr_seq_T07_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_POLIWRATH, 0
    Message msg_0491_T07_00001
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07_002:
    NPCMessage msg_0491_T07_00002
    End
scr_seq_T07_003:
    NPCMessage msg_0491_T07_00003
    End
scr_seq_T07_004:
    NPCMessage msg_0491_T07_00004
    End
scr_seq_T07_005:
    NPCMessage msg_0491_T07_00005
    End
scr_seq_T07_006:
    NPCMessage msg_0491_T07_00006
    End
scr_seq_T07_007:
    NPCMessage msg_0491_T07_00007
    End
scr_seq_T07_008:
    NPCMessage msg_0491_T07_00008
    End
scr_seq_T07_009:
    DrawSignpostInstantMessage msg_0491_T07_00030, SIGNPOST_TYPE_MAP
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T07_010:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0491_T07_00031, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T07_011:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0491_T07_00032, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T07_012:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0491_T07_00033, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T07_013:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0491_T07_00034, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T07_014:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0491_T07_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_T07_016:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_ERIKA, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _046C
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 1, _0434
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 1, _03AA
_0302:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00009
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00010
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00011
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00012
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00013
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00014
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00015
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00016
    CloseMessage
    ApplyMovement obj_T07_gsleader12, _045C
    WaitMovement
    Message msg_0491_T07_00017
    CloseMessage
    ApplyMovement obj_T07_gsleader6, _0464
    WaitMovement
    Message msg_0491_T07_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03AA:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x05, 2
    BufferPlayerName 0
    Message msg_0491_T07_00019
_03BE:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03E2
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0429
    End
_03E2:
    BufferPlayerName 0
    Message msg_0491_T07_00020
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_ERIKA
    Message msg_0491_T07_00021
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_25D
    RemoveObject obj_T07_gsleader12
    RemoveObject obj_T07_gsleader6
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0429:
    Message msg_0491_T07_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0434:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0491_T07_00023
    GoTo _03BE
    End
_0447:
    NPCMessage msg_0491_T07_00021
    End
    .balign 4, 0
_045C:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0464:
    WalkOnSpotNormalWest
    EndMovement
_046C:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0491_T07_00024
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04D5
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _04E0
    Message msg_0491_T07_00025
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 81
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0491_T07_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04D5:
    Message msg_0491_T07_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04E0:
    Message msg_0491_T07_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07_017:
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _0500
    GoTo _0302
    End
_0500:
    NPCMessage msg_0491_T07_00029
    End
scr_seq_T07_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _063B
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _064F
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _058C
    ApplyMovement LOCALID_PLAYER, _0664
    ApplyMovement obj_T07_gsmiddleman1, _06B0
    GoTo _05DA
_058C:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _05A7
    ApplyMovement LOCALID_PLAYER, _067C
    GoTo _05DA
_05A7:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _05CA
    ApplyMovement LOCALID_PLAYER, _069C
    ApplyMovement obj_T07_gsmiddleman1, _06B0
    GoTo _05DA
_05CA:
    ApplyMovement LOCALID_PLAYER, _0688
    ApplyMovement obj_T07_gsmiddleman1, _06B0
_05DA:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0601
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _06BC
    WaitMovement
_0601:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 57
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
_063B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_064F:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0664:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_067C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0688:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_069C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06B0:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_06BC:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
