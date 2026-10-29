#include "macros/scrcmd.inc"

#define _EV_scr_seq_D24R0203_000 0
#define _EV_scr_seq_D24R0203_001 1

    InitScriptEntry_OnFrameTable scr_seq_D24R0203_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_D24R0203_001 + 1
    InitScriptEntryEnd
scr_seq_D24R0203_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40CD, 1, _EV_scr_seq_D24R0203_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
