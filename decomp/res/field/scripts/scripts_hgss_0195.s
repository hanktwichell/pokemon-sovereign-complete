#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0344.h"


    ScriptEntry scr_seq_R10R0201_000
    ScriptEntry scr_seq_R10R0201_001
    ScriptEntry scr_seq_R10R0201_002
    ScriptEntry scr_seq_R10R0201_003
    ScriptEntry scr_seq_R10R0201_004
    ScriptEntry scr_seq_R10R0201_005
    ScriptEntry scr_seq_R10R0201_006
    ScriptEntry scr_seq_R10R0201_007
    ScriptEntry scr_seq_R10R0201_008
    ScriptEntryEnd
scr_seq_R10R0201_000:
    NPCMessage msg_0344_R10R0201_00003
    End
scr_seq_R10R0201_001:
    NPCMessage msg_0344_R10R0201_00004
    End
scr_seq_R10R0201_002:
    NPCMessage msg_0344_R10R0201_00005
    End
scr_seq_R10R0201_003:
    NPCMessage msg_0344_R10R0201_00006
    End
scr_seq_R10R0201_004:
    NPCMessage msg_0344_R10R0201_00007
    End
scr_seq_R10R0201_005:
    NPCMessage msg_0344_R10R0201_00008
    End
scr_seq_R10R0201_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_TRADE_POWER_PLANT_DUGTRIO_MAGNETON, _013F
    Message msg_0344_R10R0201_00009
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0134
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_566
    @ HGSS: GetPartySelection VAR_SPECIAL_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0134
    @ HGSS: LoadNPCTrade 8
    SetVarFromVar VAR_0x8004, VAR_RESULT
    GetPartyMonSpecies VAR_0x8004, VAR_0x8005
    @ HGSS: NPCTradeGetReqSpecies VAR_SPECIAL_RESULT
    CompareVar VAR_0x8005, VAR_RESULT
    GoToIf 5, _0127
    @ HGSS: NPCTradeExec VAR_SPECIAL_x8004
    @ HGSS: NPCTradeEnd
    SetFlag FLAG_HGSS_TRADE_POWER_PLANT_DUGTRIO_MAGNETON
    Message msg_0344_R10R0201_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0127:
    @ HGSS: NPCTradeEnd
    Message msg_0344_R10R0201_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0134:
    Message msg_0344_R10R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013F:
    Message msg_0344_R10R0201_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0201_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0344_R10R0201_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R10R0201_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0344_R10R0201_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
