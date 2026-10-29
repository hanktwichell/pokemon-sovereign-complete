#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0144.h"

#define obj_D50R0101_breakrock 1
#define obj_D50R0101_breakrock_2 2
#define obj_D50R0101_breakrock_3 3
#define obj_D50R0101_breakrock_4 4
#define obj_D50R0101_breakrock_5 5
#define obj_D50R0101_breakrock_6 6

    ScriptEntry scr_seq_D50R0101_000
    ScriptEntry scr_seq_D50R0101_001
    ScriptEntryEnd
scr_seq_D50R0101_001:
    @ HGSS: NatDexFlagAction 2, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0064
    SetPosition obj_D50R0101_breakrock, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_2, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_3, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_4, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_5, 30, 1, 30, DIR_NORTH
    SetPosition obj_D50R0101_breakrock_6, 30, 1, 30, DIR_NORTH
_0064:
    End
scr_seq_D50R0101_000:
    NPCMessage msg_0144_D50R0101_00000
    End
    .balign 4, 0
