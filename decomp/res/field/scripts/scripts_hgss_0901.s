#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0594.h"


    ScriptEntry scr_seq_T25R1003_000
    ScriptEntry scr_seq_T25R1003_001
    ScriptEntry scr_seq_T25R1003_002
    ScriptEntry scr_seq_T25R1003_003
    ScriptEntryEnd
scr_seq_T25R1003_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 5
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T25R1003_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _004C
    Message msg_0594_T25R1003_00001
    GoTo _004F
_004C:
    Message msg_0594_T25R1003_00000
_004F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1003_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0075
    Message msg_0594_T25R1003_00003
    GoTo _0078
_0075:
    Message msg_0594_T25R1003_00002
_0078:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1003_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0594_T25R1003_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
