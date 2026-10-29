#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0123.h"


    ScriptEntry scr_seq_D39R0103_000
    ScriptEntry scr_seq_D39R0103_001
    ScriptEntry scr_seq_D39R0103_002
    ScriptEntry scr_seq_D39R0103_003
    ScriptEntryEnd
scr_seq_D39R0103_000:
    ApplyMovement LOCALID_PLAYER, _00FE
    WaitTime 1, VAR_RESULT
    ShowObject LOCALID_PLAYER
    WaitMovement
    CompleteScreenShake 0, 1, 1, 8
    SetVarFromValue VAR_HGSS_UNK_40AB, 0
    End
scr_seq_D39R0103_001:
    CompareVar VAR_HGSS_UNK_40AB, 1
    GoToIf 5, _00E7
    ShowObject LOCALID_PLAYER
    End
scr_seq_D39R0103_002:
    NPCMessage msg_0123_D39R0103_00000
    End
scr_seq_D39R0103_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_REGICE, 6
    ReleaseObject 7
    @ HGSS: ScrCmd_523 7, 2, 90, 2, 0
    LockObject 7
    Message msg_0123_D39R0103_00001
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_REGICE, 40, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00E9
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 7
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _00EF
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _00EF
    ReleaseAll
    End
_00E7:
    End
_00E9:
    BlackOutFromBattle
    ReleaseAll
    End
_00EF:
    Message msg_0123_D39R0103_00002
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FD6
    ReleaseAll
    End
    .balign 4, 0
_00FE:
    WarpIn
    EndMovement
    .balign 4, 0
