#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0551.h"


    ScriptEntry scr_seq_T21FS0101_000
    ScriptEntry scr_seq_T21FS0101_001
    ScriptEntry scr_seq_T21FS0101_002
    ScriptEntry scr_seq_T21FS0101_003
    ScriptEntryEnd
scr_seq_T21FS0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 0
    PokeMartCommon
    ReleaseAll
    End
scr_seq_T21FS0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 0
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T21FS0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 4
    GoToIf 0, _0068
    Message msg_0551_T21FS0101_00001
    GoTo _006B
_0068:
    Message msg_0551_T21FS0101_00000
_006B:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T21FS0101_001:
    NPCMessage msg_0551_T21FS0101_00002
    End
    .balign 4, 0
