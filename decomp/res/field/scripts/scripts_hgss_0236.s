#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0383.h"


    ScriptEntry scr_seq_R33_000
    ScriptEntry scr_seq_R33_001
    ScriptEntry scr_seq_R33_002
    ScriptEntryEnd
scr_seq_R33_000:
    NPCMessage msg_0383_R33_00000
    End
scr_seq_R33_001:
    DrawSignpostInstantMessage msg_0383_R33_00001, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R33_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_FEAROW, 0
    WaitCry
    CompleteStartWildBattle SPECIES_FEAROW, 20, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0084
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 4
    SetFlag FLAG_HGSS_SG_3FF9
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0084:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
