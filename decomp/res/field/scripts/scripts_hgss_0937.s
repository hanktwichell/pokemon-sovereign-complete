#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0625.h"


    ScriptEntry scr_seq_T28R0201_000
    ScriptEntry scr_seq_T28R0201_001
    ScriptEntryEnd
scr_seq_T28R0201_000:
    NPCMessage msg_0625_T28R0201_00000
    End
scr_seq_T28R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_RADIO_TOWER_ROCKETS, _003B
    GoToIfSet FLAG_HGSS_UNK_0C5, _0046
_003B:
    Message msg_0625_T28R0201_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0046:
    Message msg_0625_T28R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
