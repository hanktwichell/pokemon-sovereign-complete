#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0133.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D47_gsmiddleman1 12

    ScriptEntry scr_seq_D47_000
    ScriptEntry scr_seq_D47_001
    ScriptEntry scr_seq_D47_002
    ScriptEntry scr_seq_D47_003
    ScriptEntry scr_seq_D47_004
    ScriptEntry scr_seq_D47_005
    ScriptEntry scr_seq_D47_006
    ScriptEntry scr_seq_D47_007
    ScriptEntry scr_seq_D47_008
    ScriptEntry scr_seq_D47_009
    ScriptEntry scr_seq_D47_010
    ScriptEntry scr_seq_D47_011
    ScriptEntry scr_seq_D47_012
    ScriptEntry scr_seq_D47_013
    ScriptEntry scr_seq_D47_014
    ScriptEntry scr_seq_D47_015
    ScriptEntry scr_seq_D47_016
    ScriptEntryEnd
scr_seq_D47_014:
    GoToIfUnset FLAG_HGSS_UNK_189, _0057
    ClearFlag FLAG_HGSS_UNK_189
    End
_0057:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _007B
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _007B
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_007B:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_D47_000:
    NPCMessage msg_0133_D47_00002
    End
scr_seq_D47_001:
    NPCMessage msg_0133_D47_00003
    End
scr_seq_D47_002:
    NPCMessage msg_0133_D47_00004
    End
scr_seq_D47_003:
    NPCMessage msg_0133_D47_00005
    End
scr_seq_D47_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_JIGGLYPUFF, 0
    Message msg_0133_D47_00006
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0106
    Message msg_0133_D47_00007
    GoTo _0109
_0106:
    Message msg_0133_D47_00008
_0109:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0128
    AddVar VAR_MAP_LOCAL_0x0B, 1
    GoTo _012E
_0128:
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
_012E:
    End
scr_seq_D47_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0133_D47_00009
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 6
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_D47_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0133_D47_00010
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 14
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_D47_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BUTTERFREE, 0
    Message msg_0133_D47_00011
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_009:
    NPCMessage msg_0133_D47_00012
    End
scr_seq_D47_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SLOWPOKE, 0
    Message msg_0133_D47_00013
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_011:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0133_D47_00017, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D47_012:
    NPCMessage msg_0133_D47_00014
    End
scr_seq_D47_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0307
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _031B
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0258
    ApplyMovement LOCALID_PLAYER, _0330
    ApplyMovement obj_D47_gsmiddleman1, _037C
    GoTo _02A6
_0258:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0273
    ApplyMovement LOCALID_PLAYER, _0348
    GoTo _02A6
_0273:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0296
    ApplyMovement LOCALID_PLAYER, _0368
    ApplyMovement obj_D47_gsmiddleman1, _037C
    GoTo _02A6
_0296:
    ApplyMovement LOCALID_PLAYER, _0354
    ApplyMovement obj_D47_gsmiddleman1, _037C
_02A6:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _02CD
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0388
    WaitMovement
_02CD:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 38
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
_0307:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_031B:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0330:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0348:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0354:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0368:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_037C:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0388:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D47_015:
    NPCMessage msg_0133_D47_00015
    End
scr_seq_D47_016:
    NPCMessage msg_0133_D47_00016
    End
    .balign 4, 0
