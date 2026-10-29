#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0593.h"


    ScriptEntry scr_seq_T25R1002_000
    ScriptEntry scr_seq_T25R1002_001
    ScriptEntry scr_seq_T25R1002_002
    ScriptEntry scr_seq_T25R1002_003
    ScriptEntry scr_seq_T25R1002_004
    ScriptEntry scr_seq_T25R1002_005
    ScriptEntry scr_seq_T25R1002_006
    ScriptEntry scr_seq_T25R1002_007
    ScriptEntryEnd
scr_seq_T25R1002_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 3
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T25R1002_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 4
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T25R1002_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _00F1
    Message msg_0593_T25R1002_00001
    GoTo _00FC
scr_seq_T25R1002_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0104
    Message msg_0593_T25R1002_00005
    GoTo _010F
scr_seq_T25R1002_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0117
    Message msg_0593_T25R1002_00003
    GoTo _0122
scr_seq_T25R1002_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0593_T25R1002_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1002_006:
    NPCMessage msg_0593_T25R1002_00009
    End
scr_seq_T25R1002_007:
    PlayCry SPECIES_IGGLYBUFF, 0
    NPCMessage msg_0593_T25R1002_00010
    End
_00F1:
    Message msg_0593_T25R1002_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00FC:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0104:
    Message msg_0593_T25R1002_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_010F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0117:
    Message msg_0593_T25R1002_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0122:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
