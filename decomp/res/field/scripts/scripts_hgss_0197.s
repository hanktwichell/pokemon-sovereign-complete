#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0346.h"

#define obj_R11_kabigon 4
#define obj_R11_gsbabyboy1 7
#define obj_R11_gsbabyboy1_2 8
#define obj_R11_gsbabyboy1_3 9

    ScriptEntry scr_seq_R11_000
    ScriptEntry scr_seq_R11_001
    ScriptEntry scr_seq_R11_002
    ScriptEntry scr_seq_R11_003
    ScriptEntryEnd
scr_seq_R11_001:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _002A
    GoToIfSet FLAG_HGSS_SNORLAX_MEET, _0044
    End
_002A:
    SetFlag FLAG_HGSS_HIDE_ROUTE_11_SNORLAX
    RemoveObject obj_R11_kabigon
    RemoveObject obj_R11_gsbabyboy1_2
    RemoveObject obj_R11_gsbabyboy1
    RemoveObject obj_R11_gsbabyboy1_3
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_0044:
    End
scr_seq_R11_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    @ HGSS: RadioMusicIsPlaying 5, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _006A
    Message msg_0346_R11_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_006A:
    PlayCry SPECIES_SNORLAX, 0
    Message msg_0346_R11_00003
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    @ HGSS: WildBattle SPECIES_SNORLAX, 50, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00B4
    @ HGSS: GetStaticEncounterOutcome VAR_TEMP_x4005
    CompareVar VAR_MAP_LOCAL_0x05, 4
    CallIf 1, _00BA
    SetFlag FLAG_HGSS_UNK_998
    SetFlag FLAG_HGSS_SNORLAX_MEET
    ReleaseAll
    End
_00B4:
    BlackOutFromBattle
    ReleaseAll
    End
_00BA:
    SetFlag FLAG_HGSS_CAUGHT_SNORLAX
    Return
scr_seq_R11_002:
    DrawSignpostInstantMessage msg_0346_R11_00000, SIGNPOST_TYPE_ARROW
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    GetSignpostInput VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_R11_003:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0346_R11_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
    .balign 4, 0
