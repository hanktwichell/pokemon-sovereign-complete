#include "macros/scrcmd.inc"

#define _EV_scr_seq_R22_001 1
#define _EV_scr_seq_R22_003 3
#define _EV_scr_seq_R22_004 4

    InitScriptEntry_OnTransition _EV_scr_seq_R22_001 + 1
    InitScriptEntry_OnResume _EV_scr_seq_R22_004 + 1
    InitScriptEntry_OnFrameTable scr_seq_R22_map_scripts_2
    InitScriptEntryEnd
scr_seq_R22_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40FE, 1, _EV_scr_seq_R22_003 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
