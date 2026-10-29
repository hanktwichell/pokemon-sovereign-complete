#include "macros/scrcmd.inc"

#define _EV_scr_seq_R34_000 0
#define _EV_scr_seq_R34_001 1

    InitScriptEntry_OnTransition _EV_scr_seq_R34_000 + 1
    InitScriptEntry_OnFrameTable scr_seq_R34_map_scripts_2
    InitScriptEntryEnd
scr_seq_R34_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_408E, 2, _EV_scr_seq_R34_001 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
