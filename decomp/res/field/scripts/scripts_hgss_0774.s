#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0481.h"


    ScriptEntry scr_seq_T05R0601_000
    ScriptEntry scr_seq_T05R0601_001
    ScriptEntry scr_seq_T05R0601_002
    ScriptEntry scr_seq_T05R0601_003
    ScriptEntryEnd
scr_seq_T05R0601_000:
    NPCMessage msg_0481_T05R0601_00000
    End
scr_seq_T05R0601_001:
    NPCMessage msg_0481_T05R0601_00001
    End
scr_seq_T05R0601_002:
    NPCMessage msg_0481_T05R0601_00002
    End
scr_seq_T05R0601_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_SG_3F95, _0069
    Message msg_0481_T05R0601_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0069:
    Message msg_0481_T05R0601_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _008C
    Message msg_0481_T05R0601_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_008C:
    BufferPlayerName 0
    MessageGendered msg_0481_T05R0601_00006, msg_0481_T05R0601_00007
    CloseMessage
    FadeScreen 6, 3, 0, COLOR_BLACK
    FadeOutBGM 0, 10
    StopMusic
    WaitFadeScreen
    ApplyMovement 4, _0112
    WaitMovement
    ApplyMovement 4, _0112
    WaitMovement
    ApplyMovement 4, _0112
    WaitMovement
    ApplyMovement 4, _0112
    WaitMovement
    ApplyMovement 4, _0112
    WaitMovement
    ApplyMovement 4, _0112
    WaitMovement
    PlayDefaultMusic
    FadeScreen 6, 3, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0481_T05R0601_00008
    SetVar VAR_0x8004, ITEM_SPOOKY_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_SG_3F95
    End
    .balign 4, 0
_0112:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
