#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0595.h"


    ScriptEntry scr_seq_T25R1004_000
    ScriptEntry scr_seq_T25R1004_001
    ScriptEntry scr_seq_T25R1004_002
    ScriptEntry scr_seq_T25R1004_003
    ScriptEntry scr_seq_T25R1004_004
    ScriptEntryEnd
scr_seq_T25R1004_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 6
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T25R1004_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0050
    Message msg_0595_T25R1004_00001
    GoTo _0053
_0050:
    Message msg_0595_T25R1004_00000
_0053:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1004_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0079
    Message msg_0595_T25R1004_00003
    GoTo _007C
_0079:
    Message msg_0595_T25R1004_00002
_007C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1004_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _00A2
    Message msg_0595_T25R1004_00005
    GoTo _00A5
_00A2:
    Message msg_0595_T25R1004_00004
_00A5:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T25R1004_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0595_T25R1004_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
