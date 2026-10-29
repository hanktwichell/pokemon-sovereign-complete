#include "macros/scrcmd.inc"

#define _EV_scr_seq_T25R1201_001 1
#define _EV_scr_seq_T25R1201_002 2

    InitScriptEntry_OnResume _EV_scr_seq_T25R1201_001 + 1
    InitScriptEntry_OnFrameTable scr_seq_T25R1201_map_scripts_2
    InitScriptEntryEnd
scr_seq_T25R1201_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4133, 6, _EV_scr_seq_T25R1201_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
