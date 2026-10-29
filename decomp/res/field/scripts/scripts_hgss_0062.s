#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0093.h"


    ScriptEntry scr_seq_D27R0101_000
    ScriptEntry scr_seq_D27R0101_001
    ScriptEntry scr_seq_D27R0101_002
    ScriptEntry scr_seq_D27R0101_003
    ScriptEntry scr_seq_D27R0101_004
    ScriptEntryEnd
scr_seq_D27R0101_002:
    SetVarFromValue VAR_HGSS_UNK_4125, 0
    End
scr_seq_D27R0101_000:
    NPCMessage msg_0093_D27R0101_00000
    End
scr_seq_D27R0101_001:
    NPCMessage msg_0093_D27R0101_00001
    End
scr_seq_D27R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    MessageGendered msg_0093_D27R0101_00007, msg_0093_D27R0101_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00CC
    Message msg_0093_D27R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D27R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0093_D27R0101_00009
    BufferPlayerName 0
    CloseMessage
    ApplyMovement 5, _01D2
    WaitMovement
    FacePlayer
    Message msg_0093_D27R0101_00010
    SetVar VAR_0x8004, ITEM_TM73
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0093_D27R0101_00011
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 5
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_00CC:
    CheckItem ITEM_POKE_BALL, 15, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _018C
    CheckItem ITEM_DESTINY_KNOT, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _018C
    Message msg_0093_D27R0101_00005
    RemoveItem ITEM_POKE_BALL, 15, VAR_RESULT
    RemoveItem ITEM_DESTINY_KNOT, 1, VAR_RESULT
    CloseMessage
    BufferPlayerName 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement 3, _01D8
    WaitMovement
    ApplyMovement 3, _01D8
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement 2, _01D2
    WaitMovement
    WaitFanfare
    Message msg_0093_D27R0101_00006
    CloseMessage
    SetPosition 4, 15, 1, 3, DIR_NORTH
    ApplyMovement 4, _01D8
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0197
    ApplyMovement 2, _01E2
    WaitMovement
    GoTo _01A7
_018C:
    Message msg_0093_D27R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0197:
    ApplyMovement 2, _01E8
    WaitMovement
    GoTo _01A7
_01A7:
    RemoveObject 2
    ApplyMovement LOCALID_PLAYER, _01D2
    WaitMovement
    Message msg_0093_D27R0101_00008
    RemoveObject 4
    SetVar VAR_0x8004, ITEM_DREAD_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01D2:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_01D8:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01E2:
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
_01E8:
    WalkFastWest 3
    WalkFastSouth 10
    EndMovement
    .balign 4, 0
