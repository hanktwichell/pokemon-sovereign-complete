#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0191.h"
#include "res/text/bank/hgss_msg_0559.h"

#define obj_T22PC0101_instructor 8

    ScriptEntry scr_seq_T22PC0101_000
    ScriptEntry scr_seq_T22PC0101_001
    ScriptEntry scr_seq_T22PC0101_002
    ScriptEntry scr_seq_T22PC0101_003
    ScriptEntry scr_seq_T22PC0101_004
    ScriptEntry scr_seq_T22PC0101_005
    ScriptEntryEnd
scr_seq_T22PC0101_000:
    SetVarFromValue VAR_0x8007, 3
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T22PC0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0559_T22PC0101_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _021D
    @ HGSS: ScrCmd_815 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: PromptEasyChat VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021F
    Message msg_0559_T22PC0101_00013
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: ScrCmd_815 0
    @ HGSS: PromptEasyChat VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 0
    GoToIf 1, _021F
    @ HGSS: PrimoPasswordCheck1 VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003
    CompareVar VAR_RESULT, 255
    GoToIf 1, _00DD
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0212
    GoTo _022A
_00DD:
    @ HGSS: PrimoPasswordCheck2 VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003
    CompareVar VAR_RESULT, 255
    GoToIf 1, _0212
    CompareVar VAR_RESULT, 8
    GoToIf 1, _011D
    CompareVar VAR_RESULT, 9
    GoToIf 1, _0157
    CompareVar VAR_RESULT, 10
    GoToIf 1, _0191
_011D:
    GoToIfSet FLAG_HGSS_GOT_MAREEP_EGG_FROM_PRIMO, _0212
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0207
    SetFlag FLAG_HGSS_GOT_MAREEP_EGG_FROM_PRIMO
    Message msg_0559_T22PC0101_00018
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, SPECIES_MAREEP, 0, 0
    GiveEgg SPECIES_MAREEP, 14
    GoTo _01CB
_0157:
    GoToIfSet FLAG_HGSS_GOT_WOOPER_EGG_FROM_PRIMO, _0212
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0207
    SetFlag FLAG_HGSS_GOT_WOOPER_EGG_FROM_PRIMO
    Message msg_0559_T22PC0101_00018
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, SPECIES_WOOPER, 0, 0
    GiveEgg SPECIES_WOOPER, 14
    GoTo _01CB
_0191:
    GoToIfSet FLAG_HGSS_GOT_SLUGMA_EGG_FROM_PRIMO, _0212
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0207
    SetFlag FLAG_HGSS_GOT_SLUGMA_EGG_FROM_PRIMO
    Message msg_0559_T22PC0101_00018
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, SPECIES_SLUGMA, 0, 0
    GiveEgg SPECIES_SLUGMA, 14
    GoTo _01CB
_01CB:
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01EC
    ApplyMovement obj_T22PC0101_instructor, _023C
    GoTo _01F4
_01EC:
    ApplyMovement obj_T22PC0101_instructor, _0250
_01F4:
    WaitMovement
    Message msg_0559_T22PC0101_00019
    WaitFanfare
    WaitButton
    GoTo _0235
_0207:
    Message msg_0559_T22PC0101_00020
    WaitButton
    GoTo _0235
_0212:
    Message msg_0559_T22PC0101_00014
    WaitButton
    GoTo _0235
_021D:
_021F:
    Message msg_0559_T22PC0101_00015
    WaitButton
    GoTo _0235
_022A:
    Message msg_0559_T22PC0101_00016
    WaitButton
    GoTo _0235
_0235:
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_023C:
    Delay8
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0250:
    Delay8
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalEast
    EndMovement
scr_seq_T22PC0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_2C5, _0280
    Message msg_0559_T22PC0101_00021
    GoTo _028C
_0280:
    @ HGSS: BufferPlayerUnionAvatarClassName 0
    Message msg_0559_T22PC0101_00026
    GoTo _028C
_028C:
    Message msg_0559_T22PC0101_00022
    @ HGSS: BufferUnionRoomAvatarChoices
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0191_00053, 0
    AddMenuEntryImm msg_0191_00054, 1
    AddMenuEntryImm msg_0191_00055, 2
    AddMenuEntryImm msg_0191_00056, 3
    AddMenuEntryImm msg_0191_00044, 4
    ShowMenu
    SetVarFromVar VAR_0x8004, VAR_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0331
    CompareVar VAR_0x8008, -2
    GoToIf 1, _0331
    @ HGSS: UnionRoomAvatarIdxToTrainerClass VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    @ HGSS: BufferTrainerClassNameIndef 0, VAR_SPECIAL_x8005
    @ HGSS: Capitalize 0
    Message msg_0559_T22PC0101_00023
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0313
    GoTo _028C
_0313:
    @ HGSS: BufferTrainerClassNameIndef 0, VAR_SPECIAL_x8005
    Message msg_0559_T22PC0101_00024
    SetFlag FLAG_HGSS_UNK_2C5
    @ HGSS: UnionRoomAvatarIdxToSprite VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    @ HGSS: ScrCmd_289 VAR_SPECIAL_x8005
    GoTo _0333
_0331:
_0333:
    Message msg_0559_T22PC0101_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22PC0101_001:
    NPCMessage msg_0559_T22PC0101_00009
    End
scr_seq_T22PC0101_002:
    NPCMessage msg_0559_T22PC0101_00010
    End
scr_seq_T22PC0101_003:
    NPCMessage msg_0559_T22PC0101_00011
    End
    .balign 4, 0
