#include "macros/scrcmd.inc"

#define _EV_scr_seq_D32R0601_001 1
#define _EV_scr_seq_D32R0601_002 2
#define _EV_scr_seq_D32R0601_003 3
#define _EV_scr_seq_D32R0601_004 4
#define _EV_scr_seq_D32R0601_014 14

    InitScriptEntry_OnTransition _EV_scr_seq_D32R0601_014 + 1
    InitScriptEntry_OnFrameTable scr_seq_D32R0601_map_scripts_2
    InitScriptEntryEnd
scr_seq_D32R0601_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_414A, 1, _EV_scr_seq_D32R0601_003 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_414A, 2, _EV_scr_seq_D32R0601_001 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_414A, 3, _EV_scr_seq_D32R0601_004 + 1
    InitScriptGoToIfEqual VAR_HGSS_UNK_414A, 255, _EV_scr_seq_D32R0601_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
