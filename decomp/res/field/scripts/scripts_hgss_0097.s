#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0120.h"


    ScriptEntry scr_seq_D37R0105_000
    ScriptEntry scr_seq_D37R0105_001
    ScriptEntryEnd
scr_seq_D37R0105_000:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0027
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
_0027:
    End
scr_seq_D37R0105_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_CARD_KEY, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _005B
    Message msg_0120_D37R0105_00000
    SetFlag FLAG_HGSS_UNK_1C1
    SetVar VAR_0x8004, ITEM_CARD_KEY
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
_005B:
    Message msg_0120_D37R0105_00002
    Message msg_0120_D37R0105_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
