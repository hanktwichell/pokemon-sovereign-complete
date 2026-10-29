#include "macros/scrcmd.inc"

#define _EV_scr_seq_D45R0102_000 0
#define _EV_scr_seq_D45R0102_001 1
#define _EV_scr_seq_D45R0102_002 2

    InitScriptEntry_OnResume _EV_scr_seq_D45R0102_000 + 1
    InitScriptEntry_OnLoad _EV_scr_seq_D45R0102_002 + 1
    InitScriptEntry_OnFrameTable scr_seq_D45R0102_map_scripts_2
    InitScriptEntryEnd
scr_seq_D45R0102_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40FE, 2, _EV_scr_seq_D45R0102_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
