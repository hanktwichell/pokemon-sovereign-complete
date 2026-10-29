#include "macros/scrcmd.inc"

#define _EV_scr_seq_D24R0209_000 0
#define _EV_scr_seq_D24R0209_001 1

    InitScriptEntry_OnResume _EV_scr_seq_D24R0209_001 + 1
    InitScriptEntry_OnFrameTable scr_seq_D24R0209_map_scripts_2
    InitScriptEntryEnd
scr_seq_D24R0209_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40D8, 1, _EV_scr_seq_D24R0209_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
