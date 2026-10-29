#include "macros/scrcmd.inc"

#define _EV_scr_seq_D31R0207_006 6
#define _EV_scr_seq_D31R0207_007 7
#define _EV_scr_seq_D31R0207_008 8
#define _EV_scr_seq_D31R0207_009 9

    InitScriptEntry_OnTransition _EV_scr_seq_D31R0207_006 + 1
    InitScriptEntry_OnResume _EV_scr_seq_D31R0207_007 + 1
    InitScriptEntry_OnFrameTable scr_seq_D31R0207_map_scripts_2
    InitScriptEntryEnd
scr_seq_D31R0207_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4151, 1, _EV_scr_seq_D31R0207_008 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_4151, 2, _EV_scr_seq_D31R0207_009 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
