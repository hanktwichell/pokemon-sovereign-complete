#include "macros/scrcmd.inc"

#define _EV_scr_seq_D32R0301_001 1
#define _EV_scr_seq_D32R0301_002 2
#define _EV_scr_seq_D32R0301_003 3
#define _EV_scr_seq_D32R0301_004 4
#define _EV_scr_seq_D32R0301_013 13

    InitScriptEntry_OnTransition _EV_scr_seq_D32R0301_013 + 1
    InitScriptEntry_OnFrameTable scr_seq_D32R0301_map_scripts_2
    InitScriptEntryEnd
scr_seq_D32R0301_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4142, 1, _EV_scr_seq_D32R0301_003 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_4142, 2, _EV_scr_seq_D32R0301_001 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_4142, 3, _EV_scr_seq_D32R0301_004 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_4142, 255, _EV_scr_seq_D32R0301_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
