#include "macros/scrcmd.inc"

#define _EV_scr_seq_D24R0207_000 0
#define _EV_scr_seq_D24R0207_001 1

    InitScriptEntry_OnFrameTable scr_seq_D24R0207_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_D24R0207_001 + 1
    InitScriptEntryEnd
scr_seq_D24R0207_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40D5, 1, _EV_scr_seq_D24R0207_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
