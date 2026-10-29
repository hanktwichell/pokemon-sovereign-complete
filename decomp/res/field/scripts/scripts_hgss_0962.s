#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0744.h"

#define obj_W40_gsmiddleman1 5

    ScriptEntry scr_seq_W40_000
    ScriptEntry scr_seq_W40_001
    ScriptEntry scr_seq_W40_002
    ScriptEntry scr_seq_W40_003
    ScriptEntry scr_seq_W40_004
    ScriptEntry scr_seq_W40_005
    ScriptEntry scr_seq_W40_006
    ScriptEntry scr_seq_W40_007
    ScriptEntry scr_seq_W40_008
    ScriptEntry scr_seq_W40_009
    ScriptEntryEnd
scr_seq_W40_000:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0045
    ClearFlag FLAG_HGSS_UNK_206
    GoTo _0049
_0045:
    SetFlag FLAG_HGSS_UNK_206
_0049:
    End
scr_seq_W40_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetFirstNonEggInParty VAR_0x8002
    @ HGSS: MonHasRibbon VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, RIBBON_ALERT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0171
    GoToIfSet FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON, _0185
    CompareVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 7
    GoToIf 1, _011F
    GoToIfSet FLAG_HGSS_GOT_SHARP_BEAK_FROM_MONICA, _0101
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00B2
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 3
    GoTo _00F9
_00B2:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 0
    SetVar VAR_0x8004, ITEM_SHARP_BEAK
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0115
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_SHARP_BEAK_FROM_MONICA
    AddVar VAR_HGSS_NUM_MET_WEEKDAY_SIBLINGS, 1
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 1
_00F9:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0101:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0115:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_011F:
    GetDayOfWeek VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0142
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 3
    GoTo _00F9
_0142:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 28
    BufferPartyMonSpecies 0, VAR_0x8002
    MessageFromBank VAR_RESULT, 30
    @ HGSS: GiveRibbon VAR_SPECIAL_x8002, RIBBON_ALERT
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetFlag FLAG_HGSS_DAILY_GOT_SHOCK_RIBBON
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0171:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 29
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0185:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0752
    MessageFromBank VAR_RESULT, 31
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_W40_008:
    LockAll
    ApplyMovement obj_W40_gsmiddleman1, _02C8
    WaitMovement
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 252
    GoToIf 5, _01C8
    ApplyMovement obj_W40_gsmiddleman1, _02D4
    GoTo _0206
_01C8:
    CompareVar VAR_0x8000, 253
    GoToIf 5, _01E3
    ApplyMovement obj_W40_gsmiddleman1, _02E0
    GoTo _0206
_01E3:
    CompareVar VAR_0x8000, 254
    GoToIf 5, _01FE
    ApplyMovement obj_W40_gsmiddleman1, _02F4
    GoTo _0206
_01FE:
    ApplyMovement obj_W40_gsmiddleman1, _0308
_0206:
    WaitMovement
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 1, _0223
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
_0223:
    ApplyMovement obj_W40_gsmiddleman1, _031C
    ApplyMovement LOCALID_PLAYER, _02B8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0744_W40_00015
    CloseMessage
    ApplyMovement obj_W40_gsmiddleman1, _02C8
    WaitMovement
    Message msg_0744_W40_00016
    CloseMessage
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8000, 252
    GoToIf 5, _0274
    ApplyMovement obj_W40_gsmiddleman1, _0324
    GoTo _02B2
_0274:
    CompareVar VAR_0x8000, 253
    GoToIf 5, _028F
    ApplyMovement obj_W40_gsmiddleman1, _0330
    GoTo _02B2
_028F:
    CompareVar VAR_0x8000, 254
    GoToIf 5, _02AA
    ApplyMovement obj_W40_gsmiddleman1, _0344
    GoTo _02B2
_02AA:
    ApplyMovement obj_W40_gsmiddleman1, _0358
_02B2:
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_02B8:
    LockDir
    WalkNormalNorth
    UnlockDir
    EndMovement
    .balign 4, 0
_02C8:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_02D4:
    WalkFastNorth 5
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_02E0:
    WalkFastNorth 2
    WalkFastEast
    WalkFastNorth 3
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_02F4:
    WalkFastNorth 2
    WalkFastEast 2
    WalkFastNorth 3
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_0308:
    WalkFastNorth 2
    WalkFastEast 3
    WalkFastNorth 3
    WalkOnSpotNormalNorth 2
    EndMovement
    .balign 4, 0
_031C:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0324:
    WalkFastSouth 6
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0330:
    WalkFastSouth 3
    WalkFastWest
    WalkFastSouth 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0344:
    WalkFastSouth 3
    WalkFastWest 2
    WalkFastSouth 3
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0358:
    WalkFastSouth 3
    WalkFastWest 3
    WalkFastSouth 3
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_W40_007:
    NPCMessage msg_0744_W40_00018
    End
scr_seq_W40_002:
    DrawSignpostInstantMessage msg_0744_W40_00019, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_W40_009:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0744_W40_00020, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_W40_003:
    NPCMessage msg_0744_W40_00000
    End
scr_seq_W40_004:
    NPCMessage msg_0744_W40_00006
    End
scr_seq_W40_005:
    NPCMessage msg_0744_W40_00003
    End
scr_seq_W40_006:
    NPCMessage msg_0744_W40_00009
    End
    .balign 4, 0
