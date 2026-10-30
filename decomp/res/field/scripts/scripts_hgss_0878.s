#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0575.h"


    ScriptEntry scr_seq_T24PC0101_000
    ScriptEntry scr_seq_T24PC0101_001
    ScriptEntry scr_seq_T24PC0101_002
    ScriptEntry scr_seq_T24PC0101_003
    ScriptEntry scr_seq_T24PC0101_004
    ScriptEntry scr_seq_T24PC0101_005
    ScriptEntryEnd
scr_seq_T24PC0101_000:
    SetVarFromValue VAR_0x8007, 3
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T24PC0101_001:
    NPCMessage msg_0575_T24PC0101_00000
    End
scr_seq_T24PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPCBoxesFreeSlotCount VAR_RESULT
    CompareVar VAR_RESULT, 540
    GoToIf 5, _013C
    GoTo _0142
scr_seq_T24PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0159
    Message msg_0575_T24PC0101_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24PC0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F6D, _01E1
    ApplyMovement 7, _01F2
    ApplyMovement 8, _01EC
    WaitMovement
    Message msg_0575_T24PC0101_00007
    CloseMessage
    ApplyMovement 7, _01F2
    ApplyMovement 8, _01EC
    WaitMovement
    Message msg_0575_T24PC0101_00011
    CloseMessage
    ApplyMovement 7, _01F2
    ApplyMovement 8, _01EC
    WaitMovement
    Message msg_0575_T24PC0101_00012
    CloseMessage
    ApplyMovement 7, _01F2
    ApplyMovement 8, _01EC
    WaitMovement
    Message msg_0575_T24PC0101_00013
    CloseMessage
    ApplyMovement 7, _01F2
    ApplyMovement 8, _01EC
    WaitMovement
    FacePlayer
    Message msg_0575_T24PC0101_00010
    SetVar VAR_0x8004, ITEM_CHOICE_BAND
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0575_T24PC0101_00008
    SetFlag FLAG_HGSS_SG_3F6D
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T24PC0101_005:
    PlayCry SPECIES_MEDITITE, 0
    NPCMessage msg_0575_T24PC0101_00009
    End
_013C:
    GoTo _0167
_0142:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0172
    GoTo _0178
_0159:
    BufferPlayerName 0
    Message msg_0575_T24PC0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0167:
    Message msg_0575_T24PC0101_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0172:
    GoTo _0167
_0178:
    Message msg_0575_T24PC0101_00004
    BufferPlayerName 0
    Message msg_0575_T24PC0101_00005
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    GivePokemon SPECIES_TENTACOOL, 15, 0, VAR_RESULT
    Message msg_0575_T24PC0101_00006
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01B5
    CloseMessage
    GoTo _01DD
_01B5:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen 1, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_01DD:
    ReleaseAll
    End
_01E1:
    Message msg_0575_T24PC0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01EC:
    JumpOnSpotFastEast
    EndMovement
    .balign 4, 0
_01F2:
    JumpOnSpotFastWest
    EndMovement
    .balign 4, 0
