#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0323.h"


    ScriptEntry scr_seq_R02R0301_000
    ScriptEntry scr_seq_R02R0301_001
    ScriptEntryEnd
scr_seq_R02R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_SACRED_ASH_FROM_ROUTE_2_LAB_AIDE, _004D
    BufferPlayerName 0
    MessageGendered msg_0323_R02R0301_00000, msg_0323_R02R0301_00001
    SetVar VAR_0x8004, ITEM_SACRED_ASH
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0058
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_SACRED_ASH_FROM_ROUTE_2_LAB_AIDE
_004D:
    Message msg_0323_R02R0301_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0058:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
scr_seq_R02R0301_001:
    NPCMessage msg_0323_R02R0301_00003
    End
    .balign 4, 0
