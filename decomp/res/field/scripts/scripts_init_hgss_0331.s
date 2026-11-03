#include "macros/scrcmd.inc"

#define _EV_scr_seq_D31R0202_000 0
#define _EV_scr_seq_D31R0202_001 1
#define _EV_scr_seq_D31R0202_002 2
#define _EV_scr_seq_D31R0202_003 3

    InitScriptEntry_OnTransition _EV_scr_seq_D31R0202_000 + 1
    InitScriptEntry_OnFrameTable scr_seq_D31R0202_map_scripts_2
    InitScriptEntryEnd
scr_seq_D31R0202_map_scripts_2:
    InitScriptGoToIfEqual VAR_BATTLE_TOWER_ELEVATOR_LOAD_ACTION, 1, _EV_scr_seq_D31R0202_001 + 1
    InitScriptGoToIfEqual VAR_BATTLE_TOWER_ELEVATOR_LOAD_ACTION, 2, _EV_scr_seq_D31R0202_002 + 1
    InitScriptGoToIfEqual VAR_BATTLE_TOWER_ELEVATOR_LOAD_ACTION, 3, _EV_scr_seq_D31R0202_003 + 1
    InitScriptFrameTableEnd
    InitScriptEnd
