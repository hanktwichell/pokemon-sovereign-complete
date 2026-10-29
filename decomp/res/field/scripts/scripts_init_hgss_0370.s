#include "macros/scrcmd.inc"

#define _EV_scr_seq_D43R0102_000 0
#define _EV_scr_seq_D43R0102_001 1

    InitScriptEntry_OnFrameTable scr_seq_D43R0102_map_scripts_2
    InitScriptEntry_OnResume _EV_scr_seq_D43R0102_001 + 1
    InitScriptEntryEnd
scr_seq_D43R0102_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40CA, 1, _EV_scr_seq_D43R0102_000 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
