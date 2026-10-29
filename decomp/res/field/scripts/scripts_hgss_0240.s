#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0387.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R35_gsmiddleman1 12

    ScriptEntry scr_seq_R35_000
    ScriptEntry scr_seq_R35_001
    ScriptEntry scr_seq_R35_002
    ScriptEntry scr_seq_R35_003
    ScriptEntry scr_seq_R35_004
    ScriptEntry scr_seq_R35_005
    ScriptEntry scr_seq_R35_006
    ScriptEntryEnd
scr_seq_R35_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _0147
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_R35_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _017C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0190
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _01A4
    ApplyMovement LOCALID_PLAYER, _03C8
    ApplyMovement obj_R35_gsmiddleman1, _03DA
    GoTo _01BF
scr_seq_R35_000:
    DrawSignpostInstantMessage msg_0387_R35_00028, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R35_004:
    DrawSignpostInstantMessage msg_0387_R35_00029, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R35_002:
    NPCMessage msg_0387_R35_00021
    End
scr_seq_R35_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SWELLOW, 0
    WaitCry
    CompleteStartWildBattle SPECIES_SWELLOW, 23, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0220
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 15
    SetFlag FLAG_HGSS_SG_3FED
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_R35_006:
    SetVarFromValue VAR_0x8008, 81
    SetVarFromValue VAR_0x8009, 1
    GoTo _0226
_0147:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0262
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0262
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0262
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _028E
_017C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0190:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01A4:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02B6
    ApplyMovement LOCALID_PLAYER, _03E4
    GoTo _01BF
_01BF:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0327
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03EE
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 11
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
_0220:
    BlackOutFromBattle
    ReleaseAll
    End
_0226:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    WaitSE SE_CONFIRM_sseq_3
    SetVarFromVar VAR_0x8004, VAR_0x8008
    SetVarFromVar VAR_0x8005, VAR_0x8009
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0361
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03A2
    End
_0262:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    @ HGSS: ScrCmd_379 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _03B8
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _03B8
    ClearFlag FLAG_HGSS_UNK_1CD
    SetFlag FLAG_HGSS_UNK_1CE
    End
_028E:
    @ HGSS: ScrCmd_379 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _03B8
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _03B8
    ClearFlag FLAG_HGSS_UNK_1CD
    SetFlag FLAG_HGSS_UNK_1CE
    End
_02B6:
    ApplyMovement LOCALID_PLAYER, _03FC
    ApplyMovement obj_R35_gsmiddleman1, _03DA
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0327
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _03EE
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 11
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
_0327:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 11
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
_0361:
    @ HGSS: CallStd std_hidden_item_fanfare
    RemoveObject VAR_LAST_TALKED
    AddItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    Message msg_0387_R35_00002
    WaitFanfare
    BufferPlayerName 0
    BufferItemName 1, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_0x800B
    Message msg_0387_R35_00003
    WaitButton
    SetVarFromValue VAR_RESULT, 1
    CloseMessage
    ReleaseAll
    End
_03A2:
    BufferItemName 0, VAR_0x8004
    Message msg_0387_R35_00004
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    GoTo _03C2
_03B8:
    ClearFlag FLAG_HGSS_UNK_1CE
    SetFlag FLAG_HGSS_UNK_1CD
    End
_03C2:
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03C8:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03DA:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03E4:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03EE:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_03FC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
