#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0050.h"

#define obj_D02R0103_stop 0

    ScriptEntry scr_seq_D02R0103_000
    ScriptEntry scr_seq_D02R0103_001
    ScriptEntry scr_seq_D02R0103_002
    ScriptEntry scr_seq_D02R0103_003
    ScriptEntry scr_seq_D02R0103_004
    ScriptEntryEnd
scr_seq_D02R0103_002:
    ShowObject obj_D02R0103_stop
    @ HGSS: ScrCmd_379 VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _010E
    SetPosition obj_D02R0103_stop, 18, 0, 10, DIR_SOUTH
    SetWarpEventPos 2, 20, 3
    GoTo _0131
scr_seq_D02R0103_000:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0050_D02R0103_00000, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D02R0103_001:
    NPCMessage msg_0050_D02R0103_00001
    End
scr_seq_D02R0103_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_CRESSELIA, 6
    Message msg_0050_D02R0103_00002
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_CRESSELIA, 50, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0133
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 1
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _0139
    CompareVar VAR_MAP_LOCAL_0x02, 4
    CallIf 1, _0148
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _0139
    ReleaseAll
    End
scr_seq_D02R0103_004:
    SetFlag FLAG_HGSS_SG_3FBF
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 5, _0131
    SetPosition obj_D02R0103_stop, 18, 0, 10, DIR_SOUTH
    SetWarpEventPos 2, 20, 3
    End
_010E:
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 5, _0131
    SetPosition obj_D02R0103_stop, 18, 0, 10, DIR_SOUTH
    SetWarpEventPos 2, 20, 3
    End
_0131:
    End
_0133:
    BlackOutFromBattle
    ReleaseAll
    End
_0139:
    Message msg_0050_D02R0103_00003
    ClearFlag FLAG_HGSS_SG_3FBF
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0148:
    Message msg_0050_D02R0103_00004
    SetVar VAR_0x8004, ITEM_LUNAR_WING
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
