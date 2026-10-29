#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0488.h"

#define obj_T06R0301_mono_pip 5

    ScriptEntry scr_seq_T06R0301_000
    ScriptEntry scr_seq_T06R0301_001
    ScriptEntry scr_seq_T06R0301_002
    ScriptEntry scr_seq_T06R0301_003
    ScriptEntry scr_seq_T06R0301_004
    ScriptEntry scr_seq_T06R0301_005
    ScriptEntry scr_seq_T06R0301_006
    ScriptEntry scr_seq_T06R0301_007
    ScriptEntry scr_seq_T06R0301_008
    ScriptEntryEnd
scr_seq_T06R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_GOT_RARE_CANDY_FROM_FAN_CLUB_CHAIRMAN, _0137
    BufferPlayerName 0
    MessageGendered msg_0488_T06R0301_00004, msg_0488_T06R0301_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T06R0301_001:
    NPCMessage msg_0488_T06R0301_00008
    End
scr_seq_T06R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_LOST_ITEM, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0186
    GetItemQuantity ITEM_PASS, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0186
    GoToIfSet FLAG_HGSS_UNK_119, _0191
    GoToIfSet FLAG_HGSS_RESTORED_POWER, _01BC
    Message msg_0488_T06R0301_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T06R0301_003:
    NPCMessage msg_0488_T06R0301_00014
    End
scr_seq_T06R0301_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SKUNTANK, 0
    Message msg_0488_T06R0301_00016
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T06R0301_007:
    GoToIfSet FLAG_HGSS_HIDE_VERMILION_FAN_CLUB_LOST_ITEM, _01C7
    NPCMessage msg_0488_T06R0301_00015
    End
scr_seq_T06R0301_005:
    NPCMessage msg_0488_T06R0301_00017
    End
scr_seq_T06R0301_006:
    NPCMessage msg_0488_T06R0301_00018
    End
scr_seq_T06R0301_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_RAPIDASH, 0
    Message msg_0488_T06R0301_00019
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0137:
    Message msg_0488_T06R0301_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01C9
    Message msg_0488_T06R0301_00001
    SetVar VAR_0x8004, ITEM_RARE_CANDY
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _01D4
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_RARE_CANDY_FROM_FAN_CLUB_CHAIRMAN
    Message msg_0488_T06R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0186:
    Message msg_0488_T06R0301_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0191:
    Message msg_0488_T06R0301_00011
    RemoveObject obj_T06R0301_mono_pip
    SetFlag FLAG_HGSS_HIDE_VERMILION_FAN_CLUB_LOST_ITEM
    SetVar VAR_0x8004, ITEM_LOST_ITEM
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetVarFromValue VAR_HGSS_UNK_4130, 1
    ClearFlag FLAG_HGSS_HIDE_VERMILION_CITY_STEVEN
    CloseMessage
    ReleaseAll
    End
_01BC:
    Message msg_0488_T06R0301_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01C7:
    End
_01C9:
    Message msg_0488_T06R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01D4:
    Message msg_0488_T06R0301_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
