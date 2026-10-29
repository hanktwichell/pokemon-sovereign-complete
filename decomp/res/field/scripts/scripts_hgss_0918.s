#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0610.h"


    ScriptEntry scr_seq_T26R0601_000
    ScriptEntry scr_seq_T26R0601_001
    ScriptEntry scr_seq_T26R0601_002
    ScriptEntry scr_seq_T26R0601_003
    ScriptEntry scr_seq_T26R0601_004
    ScriptEntryEnd
scr_seq_T26R0601_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_DAILY_RECEIVED_PLATE_FROM_AQUA_CAPTAIN, _00D9
    @ HGSS: ScrCmd_379 VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00E4
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _00E4
    Message msg_0610_T26R0601_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _011E
    Message msg_0610_T26R0601_00003
    SetVar VAR_0x8004, ITEM_SUN_STONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0610_T26R0601_00002
    SetFlag FLAG_HGSS_DAILY_RECEIVED_PLATE_FROM_AQUA_CAPTAIN
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T26R0601_001:
    NPCMessage msg_0610_T26R0601_00006
    End
scr_seq_T26R0601_002:
    PlayCry SPECIES_CLEFAIRY, 0
    NPCMessage msg_0610_T26R0601_00007
    End
scr_seq_T26R0601_003:
    PlayCry SPECIES_SUNFLORA, 0
    NPCMessage msg_0610_T26R0601_00008
    End
scr_seq_T26R0601_004:
    NPCMessage msg_0610_T26R0601_00009
    End
_00D9:
    Message msg_0610_T26R0601_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E4:
    Message msg_0610_T26R0601_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _011E
    Message msg_0610_T26R0601_00004
    SetVar VAR_0x8004, ITEM_MOON_STONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0610_T26R0601_00002
    SetFlag FLAG_HGSS_DAILY_RECEIVED_PLATE_FROM_AQUA_CAPTAIN
    WaitButton
    CloseMessage
    ReleaseAll
    End
_011E:
    Message msg_0610_T26R0601_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
