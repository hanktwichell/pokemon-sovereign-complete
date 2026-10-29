#include "macros/scrcmd.inc"

#define _EV_scr_seq_R34R0101_000 0
#define _EV_scr_seq_R34R0101_001 1

    InitScriptEntry_OnResume _EV_scr_seq_R34R0101_000 + 1
    InitScriptEntry_OnFrameTable scr_seq_R34R0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_R34R0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_408E, 1, _EV_scr_seq_R34R0101_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
