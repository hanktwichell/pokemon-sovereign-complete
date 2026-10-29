#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0141.h"

#define obj_D49R0105_pcwoman2_2 1

    ScriptEntry scr_seq_D49R0105_000
    ScriptEntry scr_seq_D49R0105_001
    ScriptEntry scr_seq_D49R0105_002
    ScriptEntry scr_seq_D49R0105_003
    ScriptEntry scr_seq_D49R0105_004
    ScriptEntry scr_seq_D49R0105_005
    ScriptEntry scr_seq_D49R0105_006
    ScriptEntry scr_seq_D49R0105_007
    ScriptEntry scr_seq_D49R0105_008
    ScriptEntry scr_seq_D49R0105_009
    ScriptEntry scr_seq_D49R0105_010
    ScriptEntry scr_seq_D49R0105_011
    ScriptEntry scr_seq_D49R0105_012
    ScriptEntry scr_seq_D49R0105_013
    ScriptEntryEnd
scr_seq_D49R0105_012:
    GoToIfSet FLAG_HGSS_UNK_0F0, _004D
    SetVarFromValue VAR_MAP_LOCAL_0x0C, 0
    End
_004D:
    SetVarFromValue VAR_MAP_LOCAL_0x0C, 1
    End
scr_seq_D49R0105_011:
    CompareVar VAR_MAP_LOCAL_0x0C, 1
    GoToIf 5, _0074
    SetPosition obj_D49R0105_pcwoman2_2, 2, 1, 3, DIR_EAST
    SetVarFromValue VAR_MAP_LOCAL_0x0C, 0
_0074:
    End
scr_seq_D49R0105_000:
    NPCMessage msg_0141_D49R0105_00000
    End
scr_seq_D49R0105_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0F0, _00A7
    Message msg_0141_D49R0105_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A7:
    Message msg_0141_D49R0105_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0105_002:
    NPCMessage msg_0141_D49R0105_00003
    End
scr_seq_D49R0105_003:
    NPCMessage msg_0141_D49R0105_00004
    End
scr_seq_D49R0105_004:
    NPCMessage msg_0141_D49R0105_00005
    End
scr_seq_D49R0105_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0141_D49R0105_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0105_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_DRATINI, 0
    Message msg_0141_D49R0105_00015
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0105_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0141_D49R0105_00006
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_712 1
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D49R0105_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_HIDE_POKEATHLON_CLOTHES_SIGN, _0166
    Message msg_0141_D49R0105_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0166:
    Message msg_0141_D49R0105_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0105_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_HIDE_POKEATHLON_SHOES_SIGN, _018F
    Message msg_0141_D49R0105_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_018F:
    Message msg_0141_D49R0105_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0105_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_HIDE_POKEATHLON_FLAG_SIGN, _01B8
    Message msg_0141_D49R0105_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01B8:
    Message msg_0141_D49R0105_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0105_013:
    NPCMessage msg_0141_D49R0105_00013
    End
    .balign 4, 0
