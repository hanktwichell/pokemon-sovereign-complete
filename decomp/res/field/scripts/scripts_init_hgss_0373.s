#include "macros/scrcmd.inc"

#define _EV_scr_seq_D44R0103_003 3
#define _EV_scr_seq_D44R0103_004 4

    InitScriptEntry_OnFrameTable scr_seq_D44R0103_map_scripts_2
    InitScriptEntry_OnTransition _EV_scr_seq_D44R0103_004 + 1
    InitScriptEntryEnd
scr_seq_D44R0103_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_40C3, 0, _EV_scr_seq_D44R0103_003 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
