#include "macros/scrcmd.inc"

#define _EV_scr_seq_D32R0401_001 1
#define _EV_scr_seq_D32R0401_002 2
#define _EV_scr_seq_D32R0401_003 3
#define _EV_scr_seq_D32R0401_004 4
#define _EV_scr_seq_D32R0401_015 15
#define _EV_scr_seq_D32R0401_020 20
#define _EV_scr_seq_D32R0401_021 21

    InitScriptEntry_OnLoad _EV_scr_seq_D32R0401_020 + 1
    InitScriptEntry_OnTransition _EV_scr_seq_D32R0401_015 + 1
    InitScriptEntry_OnResume _EV_scr_seq_D32R0401_021 + 1
    InitScriptEntry_OnFrameTable scr_seq_D32R0401_map_scripts_2
    InitScriptEntryEnd
scr_seq_D32R0401_map_scripts_2:
    InitScriptGoToIfEqual VAR_BATTLE_HALL_LOBBY_LOAD_ACTION, 1, _EV_scr_seq_D32R0401_003 + 1
    InitScriptGoToIfEqual VAR_BATTLE_HALL_LOBBY_LOAD_ACTION, 2, _EV_scr_seq_D32R0401_001 + 1
    InitScriptGoToIfEqual VAR_BATTLE_HALL_LOBBY_LOAD_ACTION, 3, _EV_scr_seq_D32R0401_004 + 1
    InitScriptGoToIfEqual VAR_BATTLE_HALL_LOBBY_LOAD_ACTION, 255, _EV_scr_seq_D32R0401_002 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
