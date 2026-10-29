#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0333.h"


    ScriptEntry scr_seq_R05R0401_000
    ScriptEntry scr_seq_R05R0401_001
    ScriptEntryEnd
scr_seq_R05R0401_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_CLEANSE_TAG_FROM_ROUTE_5_GRANDMA, _0049
    Message msg_0333_R05R0401_00000
    SetVar VAR_0x8004, ITEM_CLEANSE_TAG
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0054
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_CLEANSE_TAG_FROM_ROUTE_5_GRANDMA
_0049:
    Message msg_0333_R05R0401_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0054:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_R05R0401_001:
    NPCMessage msg_0333_R05R0401_00002
    End
    .balign 4, 0
