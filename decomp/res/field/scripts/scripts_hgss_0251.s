#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0398.h"

#define obj_R39R0201_gsbabygirl1 0
#define obj_R39R0201_gsbabygirl1_2 2

    ScriptEntry scr_seq_R39R0201_000
    ScriptEntry scr_seq_R39R0201_001
    ScriptEntry scr_seq_R39R0201_002
    ScriptEntry scr_seq_R39R0201_003
    ScriptEntry scr_seq_R39R0201_004
    ScriptEntryEnd
scr_seq_R39R0201_004:
    GetTimeOfDay VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0047
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0047
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0047
    ClearFlag FLAG_HGSS_UNK_226
    End
_0047:
    SetFlag FLAG_HGSS_UNK_226
    End
scr_seq_R39R0201_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_100, _00A2
    GoToIfSet FLAG_HGSS_UNK_0AA, _007E
    Message msg_0398_R39R0201_00005
    CloseMessage
_0070:
    ApplyMovement obj_R39R0201_gsbabygirl1, _021C
    WaitMovement
    ReleaseAll
    End
_007E:
    Message msg_0398_R39R0201_00006
    SetVar VAR_0x8004, ITEM_SEAL_CASE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0398_R39R0201_00007
    CloseMessage
    SetFlag FLAG_HGSS_UNK_100
    GoTo _0070
    End
_00A2:
    Message msg_0398_R39R0201_00008
    CloseMessage
    GoTo _0070
    End
scr_seq_R39R0201_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_101, _00E0
    GoToIfSet FLAG_HGSS_UNK_0AA, _00FA
    Message msg_0398_R39R0201_00000
    CloseMessage
_00D2:
    ApplyMovement obj_R39R0201_gsbabygirl1_2, _0224
    WaitMovement
    ReleaseAll
    End
_00E0:
    Message msg_0398_R39R0201_00004
    CloseMessage
    GoTo _00D2
    End
_00ED:
    Message msg_0398_R39R0201_00002
    CloseMessage
    GoTo _00D2
    End
_00FA:
    GoToIfUnset FLAG_HGSS_UNK_100, _00ED
    Message msg_0398_R39R0201_00001
    SetVarFromValue VAR_0x8004, ITEM_MAX_REVIVE
    SetVarFromValue VAR_0x8005, 34
    SetVarFromValue VAR_0x8006, 39
    CountSealOccurence VAR_0x8004, VAR_RESULT
    CompareVar VAR_RESULT, 99
    GoToIf 1, _020C
    CountSealOccurence VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 99
    GoToIf 1, _020C
    CountSealOccurence VAR_0x8006, VAR_RESULT
    CompareVar VAR_RESULT, 99
    GoToIf 1, _020C
    SetVarFromValue VAR_0x8000, 3
    SetVarFromValue VAR_0x8001, 3
    SetVarFromValue VAR_0x8002, 3
    CountSealOccurence VAR_0x8004, VAR_RESULT
    CompareVar VAR_RESULT, 96
    GoToIf 3, _01C2
    SubVar VAR_RESULT, 96
    SubVar VAR_0x8000, VAR_RESULT
    CountSealOccurence VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 96
    GoToIf 3, _01C2
    SubVar VAR_RESULT, 96
    SubVar VAR_0x8001, VAR_RESULT
    CountSealOccurence VAR_0x8006, VAR_RESULT
    CompareVar VAR_RESULT, 96
    GoToIf 3, _01C2
    SubVar VAR_RESULT, 96
    SubVar VAR_0x8002, VAR_RESULT
_01C2:
    GiveOrTakeSeal VAR_0x8004, VAR_0x8000
    GiveOrTakeSeal VAR_0x8005, VAR_0x8001
    GiveOrTakeSeal VAR_0x8006, VAR_0x8002
    BufferBallSealNamePlural 0, VAR_0x8004
    Message msg_0398_R39R0201_00020
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    BufferBallSealNamePlural 0, VAR_0x8005
    Message msg_0398_R39R0201_00020
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    BufferBallSealNamePlural 0, VAR_0x8006
    Message msg_0398_R39R0201_00020
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    CloseMessage
    SetFlag FLAG_HGSS_UNK_101
    GoTo _00D2
    End
_020C:
    Message msg_0398_R39R0201_00003
    CloseMessage
    GoTo _00D2
    End
    .balign 4, 0
_021C:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0224:
    WalkOnSpotNormalWest
    EndMovement
scr_seq_R39R0201_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0AA, _0354
    PlayCry SPECIES_MILTANK, 11
    Message msg_0398_R39R0201_00009
    WaitCry
    GoToIfSet FLAG_HGSS_UNK_0A8, _0260
    Message msg_0398_R39R0201_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0260:
    Message msg_0398_R39R0201_00010
    WaitABPress
    Message msg_0398_R39R0201_00013
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _028C
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0378
    End
_028C:
    SetVarFromValue VAR_0x8004, ITEM_ORAN_BERRY
    SetVarFromValue VAR_0x8005, 1
    CheckItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _036A
    RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    BufferPlayerName 0
    Message msg_0398_R39R0201_00014
    WaitButton
    CloseMessage
    GoToIfSet FLAG_HGSS_UNK_0B0, _033F
    GoToIfSet FLAG_HGSS_UNK_0AF, _0337
    GoToIfSet FLAG_HGSS_UNK_0AE, _0328
    GoToIfSet FLAG_HGSS_UNK_0AD, _0320
    GoToIfSet FLAG_HGSS_UNK_0AC, _0311
    GoToIfSet FLAG_HGSS_UNK_0A9, _0309
    SetFlag FLAG_HGSS_UNK_0A9
    ReleaseAll
    End
_0309:
    SetFlag FLAG_HGSS_UNK_0AC
    ReleaseAll
    End
_0311:
    SetFlag FLAG_HGSS_UNK_0AD
    Message msg_0398_R39R0201_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0320:
    SetFlag FLAG_HGSS_UNK_0AE
    ReleaseAll
    End
_0328:
    SetFlag FLAG_HGSS_UNK_0AF
    Message msg_0398_R39R0201_00016
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0337:
    SetFlag FLAG_HGSS_UNK_0B0
    ReleaseAll
    End
_033F:
    PlayFanfare SEQ_ASA_sseq
    WaitFanfare
    Message msg_0398_R39R0201_00017
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_UNK_0AA
    ReleaseAll
    End
_0354:
    PlayCry SPECIES_MILTANK, 0
    Message msg_0398_R39R0201_00011
    WaitCry
    Message msg_0398_R39R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_036A:
    BufferPlayerName 0
    Message msg_0398_R39R0201_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0378:
    BufferPlayerName 0
    Message msg_0398_R39R0201_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R39R0201_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MILTANK, 0
    Message msg_0398_R39R0201_00011
    WaitCry
    Message msg_0398_R39R0201_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
