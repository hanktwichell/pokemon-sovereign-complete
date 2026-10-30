#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0386.h"


    ScriptEntry scr_seq_R34R0201_000
    ScriptEntry scr_seq_R34R0201_001
    ScriptEntry scr_seq_R34R0201_002
    ScriptEntry scr_seq_R34R0201_003
    ScriptEntry scr_seq_R34R0201_004
    ScriptEntryEnd
scr_seq_R34R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TM12_FROM_ILEX_FOREST_GATE_WOMAN, _010B
    Message msg_0386_R34R0201_00000
    WaitABPress
    SetVar VAR_0x8004, ITEM_TM12
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0116
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_TM12_FROM_ILEX_FOREST_GATE_WOMAN
    GoTo _010B
scr_seq_R34R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MOTHIM, 0
    Message msg_0386_R34R0201_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R34R0201_002:
    NPCMessage msg_0386_R34R0201_00004
    End
scr_seq_R34R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MOTHIM, 0
    Message msg_0386_R34R0201_00003
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R34R0201_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferPlayerName 0
    FadeOutBGM 0, 20
    StopMusic
    PlayMusic SEQ_GS_D_SHINTO_sseq
    Message msg_0386_R34R0201_00005
    Message msg_0386_R34R0201_00006
    SetVar VAR_0x8004, ITEM_ODD_KEYSTONE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0386_R34R0201_00007
    Message msg_0386_R34R0201_00008
    Message msg_0386_R34R0201_00009
    WaitButton
    CloseMessage
    ApplyMovement 3, _0120
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject 3
    WaitSE SEQ_SE_DP_DOOR_sseq
    FadeOutBGM 0, 20
    StopMusic
    PlayDefaultMusic
    ReleaseAll
    End
_010B:
    Message msg_0386_R34R0201_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0116:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0120:
    WalkNormalNorth
    EndMovement
    .balign 4, 0
