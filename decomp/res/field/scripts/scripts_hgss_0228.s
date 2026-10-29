#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0376.h"


    ScriptEntry scr_seq_R30R0101_000
    ScriptEntryEnd
scr_seq_R30R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_APRICORN_BOX, _0041
    Message msg_0376_R30R0101_00000
    SetVar VAR_0x8004, ITEM_APRICORN_BOX
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_APRICORN_BOX
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_30_OW, 1
    Message msg_0376_R30R0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0041:
    Message msg_0376_R30R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
