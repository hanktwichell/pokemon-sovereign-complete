#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0134.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h

    ScriptEntry scr_seq_D47PC0101_000
    ScriptEntry scr_seq_D47PC0101_001
    ScriptEntry scr_seq_D47PC0101_002
    ScriptEntry scr_seq_D47PC0101_003
    ScriptEntry scr_seq_D47PC0101_004
    ScriptEntryEnd
scr_seq_D47PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_D47PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F82, _01AA
    Message msg_0134_D47PC0101_00000
    SetVar VAR_0x8004, ITEM_UPGRADE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F82
    Message msg_0134_D47PC0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47PC0101_002:
    NPCMessage msg_0134_D47PC0101_00001
    End
scr_seq_D47PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0134_D47PC0101_00002
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01B5
    StopMusic
    PlayMusic SEQ_GS_EYE_ROCKET_sseq
    Message msg_0134_D47PC0101_00004
    WaitButton
    CloseMessage
    ApplyMovement 7, _01C0
    WaitMovement
    ClearFlag FLAG_HGSS_SG_3FFF
    AddObject 6
    RemoveObject 7
    AddObject 8
    ApplyMovement 6, _01C0
    ApplyMovement 8, _01E2
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _01EC
    WaitMovement
    Message msg_0134_D47PC0101_00005
    CloseMessage
    AddObject 9
    ApplyMovement 9, _01F2
    ApplyMovement LOCALID_PLAYER, _01F8
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _01F8
    WaitMovement
    Message msg_0134_D47PC0101_00006
    CloseMessage
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _01EC
    ApplyMovement 9, _01EC
    WaitMovement
    Message msg_0134_D47PC0101_00007
    WaitButton
    CloseMessage
    ApplyMovement 8, _01FE
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject 8
    WaitSE SEQ_SE_DP_DOOR_sseq
    Message msg_0134_D47PC0101_00015
    WaitButton
    CloseMessage
    ApplyMovement 9, _020C
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject 9
    WaitSE SEQ_SE_DP_DOOR_sseq
    ApplyMovement LOCALID_PLAYER, _0212
    WaitMovement
    Message msg_0134_D47PC0101_00016
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject 6
    SetFlag FLAG_HGSS_SG_3FFF
    SetFlag FLAG_HGSS_SG_3FE0
    ClearFlag FLAG_HGSS_SG_3FDF
    SetVarFromValue VAR_HGSS_SG_6130, 0
    FadeScreen 8, 1, 1, COLOR_BLACK
    ReleaseAll
    End
scr_seq_D47PC0101_004:
    PlayCry SPECIES_PORYGON2, 0
    NPCMessage msg_0134_D47PC0101_00017
    End
_01AA:
    Message msg_0134_D47PC0101_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01B5:
    Message msg_0134_D47PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01C0:
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    EndMovement
    .balign 4, 0
_01E2:
    WalkNormalSouth 7
    WalkSlowWest 3
    EndMovement
    .balign 4, 0
_01EC:
    FaceEast
    EndMovement
    .balign 4, 0
_01F2:
    WalkFastNorth 4
    EndMovement
    .balign 4, 0
_01F8:
    FaceSouth
    EndMovement
    .balign 4, 0
_01FE:
    WalkNormalSouth 5
    WalkNormalWest 2
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_020C:
    WalkFastSouth 4
    EndMovement
    .balign 4, 0
_0212:
    FaceNorth
    EndMovement
    .balign 4, 0
