#include "macros/scrcmd.inc"

#define _EV_scr_seq_T27GYM0101_000 0
#define _EV_scr_seq_T27GYM0101_004 4

    InitScriptEntry_OnTransition _EV_scr_seq_T27GYM0101_000 + 1
    InitScriptEntry_OnFrameTable scr_seq_T27GYM0101_map_scripts_2
    InitScriptEntryEnd
scr_seq_T27GYM0101_map_scripts_2:
    InitScriptGoToIfEqual VAR_HGSS_UNK_4079, 0, _EV_scr_seq_T27GYM0101_004 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
