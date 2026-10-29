#include "macros/scrcmd.inc"

#define _EV_scr_seq_D49R0107_005 5
#define _EV_scr_seq_D49R0107_006 6
#define _EV_scr_seq_D49R0107_007 7

    InitScriptEntry_OnResume _EV_scr_seq_D49R0107_006 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_D49R0107_007 + 1
    InitScriptEntry_OnFrameTable scr_seq_D49R0107_map_scripts_2
    InitScriptEntryEnd
scr_seq_D49R0107_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40D3, 0, _EV_scr_seq_D49R0107_005 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
