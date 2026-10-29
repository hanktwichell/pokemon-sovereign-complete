#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0140.h"

#define obj_D49R0104_pcwoman2_2 2
#define obj_D49R0104_tsure_poke_static_rattata 4

    ScriptEntry scr_seq_D49R0104_000
    ScriptEntry scr_seq_D49R0104_001
    ScriptEntry scr_seq_D49R0104_002
    ScriptEntry scr_seq_D49R0104_003
    ScriptEntry scr_seq_D49R0104_004
    ScriptEntry scr_seq_D49R0104_005
    ScriptEntry scr_seq_D49R0104_006
    ScriptEntry scr_seq_D49R0104_007
    ScriptEntry scr_seq_D49R0104_008
    ScriptEntry scr_seq_D49R0104_009
    ScriptEntry scr_seq_D49R0104_010
    ScriptEntry scr_seq_D49R0104_011
    ScriptEntry scr_seq_D49R0104_012
    ScriptEntry scr_seq_D49R0104_013
    ScriptEntryEnd
scr_seq_D49R0104_012:
    GoToIfSet FLAG_HGSS_UNK_0EF, _004D
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
    End
_004D:
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 1
    End
scr_seq_D49R0104_011:
    CompareVar VAR_MAP_LOCAL_0x0B, 1
    GoToIf 5, _0074
    SetPosition obj_D49R0104_pcwoman2_2, 2, 1, 3, DIR_EAST
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
_0074:
    End
scr_seq_D49R0104_000:
    NPCMessage msg_0140_D49R0104_00000
    End
scr_seq_D49R0104_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0EF, _00A7
    Message msg_0140_D49R0104_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00A7:
    Message msg_0140_D49R0104_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0104_002:
    NPCMessage msg_0140_D49R0104_00003
    End
scr_seq_D49R0104_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0140_D49R0104_00004
    CloseMessage
    ApplyMovement obj_D49R0104_tsure_poke_static_rattata, _00F0
    WaitMovement
    PlayCry SPECIES_RATTATA, 0
    Message msg_0140_D49R0104_00011
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_00F0:
    JumpOnSpotFastNorth 2
    EndMovement
scr_seq_D49R0104_004:
    NPCMessage msg_0140_D49R0104_00005
    End
scr_seq_D49R0104_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_RATTATA, 0
    Message msg_0140_D49R0104_00010
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0104_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ZUBAT, 0
    Message msg_0140_D49R0104_00012
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0104_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0140_D49R0104_00006
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_712 0
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D49R0104_008:
    NPCMessage msg_0140_D49R0104_00007
    End
scr_seq_D49R0104_009:
    NPCMessage msg_0140_D49R0104_00008
    End
scr_seq_D49R0104_010:
    NPCMessage msg_0140_D49R0104_00009
    End
scr_seq_D49R0104_013:
    NPCMessage msg_0140_D49R0104_00013
    End
    .balign 4, 0
