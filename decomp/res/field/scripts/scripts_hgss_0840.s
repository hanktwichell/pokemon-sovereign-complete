#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0540.h"


    ScriptEntry scr_seq_T11R0801_000
    ScriptEntry scr_seq_T11R0801_001
    ScriptEntry scr_seq_T11R0801_002
    ScriptEntryEnd
scr_seq_T11R0801_000:
    NPCMessage msg_0540_T11R0801_00000
    End
scr_seq_T11R0801_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _003F
    Message msg_0540_T11R0801_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_003F:
    Message msg_0540_T11R0801_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11R0801_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BLISSEY, 0
    Message msg_0540_T11R0801_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
