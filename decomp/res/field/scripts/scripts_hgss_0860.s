#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0559.h"

#define obj_T22PC0101_instructor 8

    ScriptEntry scr_seq_T22PC0101_000
    ScriptEntry scr_seq_T22PC0101_001
    ScriptEntry scr_seq_T22PC0101_002
    ScriptEntry scr_seq_T22PC0101_003
    ScriptEntry scr_seq_T22PC0101_004
    ScriptEntry scr_seq_T22PC0101_005
    ScriptEntry scr_seq_T22PC0101_006
    ScriptEntry scr_seq_T22PC0101_007
    ScriptEntry scr_seq_T22PC0101_008
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
    GoToIf 5, _01BC
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: PromptEasyChat VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01C9
    Message msg_0559_T22PC0101_00013
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    CloseMessage
    @ HGSS: PromptEasyChat VAR_SPECIAL_RESULT, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01C9
    @ HGSS: PrimoPasswordCheck1 VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003
    CompareVar VAR_RESULT, 255
    GoToIf 1, _01D4
    CompareVar VAR_RESULT, 0
    GoToIf 1, _024E
    GoTo _0259
scr_seq_T22PC0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_2C5, _0264
    Message msg_0559_T22PC0101_00021
    GoTo _0270
scr_seq_T22PC0101_001:
    NPCMessage msg_0559_T22PC0101_00009
    End
scr_seq_T22PC0101_002:
    NPCMessage msg_0559_T22PC0101_00010
    End
scr_seq_T22PC0101_003:
    NPCMessage msg_0559_T22PC0101_00011
    End
scr_seq_T22PC0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3FF8, _02F7
    GoToIfSet FLAG_HGSS_SG_3FF7, _0304
    Message msg_0559_T22PC0101_00027
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _030D
    Message msg_0559_T22PC0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22PC0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F6C, _038E
    Message msg_0559_T22PC0101_00046
    SetVar VAR_0x8004, ITEM_EXP_SHARE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0559_T22PC0101_00047
    SetFlag FLAG_HGSS_SG_3F6C
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T22PC0101_008:
    BufferPlayerName 0
    End
_01BC:
    Message msg_0559_T22PC0101_00015
    WaitButton
    GoTo _0399
_01C9:
    Message msg_0559_T22PC0101_00015
    WaitButton
    GoTo _0399
_01D4:
    @ HGSS: PrimoPasswordCheck2 VAR_SPECIAL_RESULT, VAR_SPECIAL_x8000, VAR_SPECIAL_x8001, VAR_SPECIAL_x8002, VAR_SPECIAL_x8003
    CompareVar VAR_RESULT, 255
    GoToIf 1, _024E
    CompareVar VAR_RESULT, 8
    GoToIf 1, _039F
    CompareVar VAR_RESULT, 9
    GoToIf 1, _03D9
    CompareVar VAR_RESULT, 10
    GoToIf 1, _0413
    GoToIfSet FLAG_HGSS_GOT_MAREEP_EGG_FROM_PRIMO, _024E
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _044D
    SetFlag FLAG_HGSS_GOT_MAREEP_EGG_FROM_PRIMO
    Message msg_0559_T22PC0101_00018
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, SPECIES_MAREEP, 0, 0
    GiveEgg SPECIES_MAREEP, 14
    GoTo _0458
_024E:
    Message msg_0559_T22PC0101_00014
    WaitButton
    GoTo _0399
_0259:
    Message msg_0559_T22PC0101_00016
    WaitButton
    GoTo _0399
_0264:
    CapitalizeFirstLetter 0
    Message msg_0559_T22PC0101_00026
    GoTo _0270
_0270:
    Message msg_0559_T22PC0101_00022
    @ HGSS: BufferUnionRoomAvatarChoices
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 53, 0
    AddMenuEntry 54, 1
    AddMenuEntry 55, 2
    AddMenuEntry 56, 3
    AddMenuEntry 44, 4
    ShowMenu
    SetVarFromVar VAR_0x8004, VAR_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0479
    CompareVar VAR_0x8008, 65534
    GoToIf 1, _0479
    @ HGSS: UnionRoomAvatarIdxToTrainerClass VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    BufferTrainerClassNameWithArticle 0, VAR_0x8005
    CapitalizeFirstLetter 0
    Message msg_0559_T22PC0101_00023
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0486
    GoTo _0270
_02F7:
    Message msg_0559_T22PC0101_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0304:
    Message msg_0559_T22PC0101_00045
    GoTo _04A4
_030D:
    Message msg_0559_T22PC0101_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051C
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0559_T22PC0101_00031
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _051C
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0559_T22PC0101_00032
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _051C
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0559_T22PC0101_00033
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _051C
    CloseMessage
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    SetFlag FLAG_HGSS_SG_3FF7
    Message msg_0559_T22PC0101_00034
    GoTo _04A4
_038E:
    Message msg_0559_T22PC0101_00047
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0399:
    CloseMessage
    ReleaseAll
    End
_039F:
    GoToIfSet FLAG_HGSS_GOT_MAREEP_EGG_FROM_PRIMO, _024E
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _044D
    SetFlag FLAG_HGSS_GOT_MAREEP_EGG_FROM_PRIMO
    Message msg_0559_T22PC0101_00018
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, SPECIES_MAREEP, 0, 0
    GiveEgg SPECIES_MAREEP, 14
    GoTo _0458
_03D9:
    GoToIfSet FLAG_HGSS_GOT_WOOPER_EGG_FROM_PRIMO, _024E
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _044D
    SetFlag FLAG_HGSS_GOT_WOOPER_EGG_FROM_PRIMO
    Message msg_0559_T22PC0101_00018
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, SPECIES_WOOPER, 0, 0
    GiveEgg SPECIES_WOOPER, 14
    GoTo _0458
_0413:
    GoToIfSet FLAG_HGSS_GOT_SLUGMA_EGG_FROM_PRIMO, _024E
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _044D
    SetFlag FLAG_HGSS_GOT_SLUGMA_EGG_FROM_PRIMO
    Message msg_0559_T22PC0101_00018
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, SPECIES_SLUGMA, 0, 0
    GiveEgg SPECIES_SLUGMA, 14
    GoTo _0458
_044D:
    Message msg_0559_T22PC0101_00020
    WaitButton
    GoTo _0399
_0458:
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0533
    ApplyMovement obj_T22PC0101_instructor, _0644
    GoTo _054E
_0479:
    Message msg_0559_T22PC0101_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0486:
    BufferTrainerClassNameWithArticle 0, VAR_0x8005
    Message msg_0559_T22PC0101_00024
    SetFlag FLAG_HGSS_UNK_2C5
    @ HGSS: UnionRoomAvatarIdxToSprite VAR_SPECIAL_x8004, VAR_SPECIAL_x8005
    @ HGSS: ScrCmd_289 VAR_SPECIAL_x8005
    GoTo _0561
_04A4:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 36, 0
    AddMenuEntry 37, 1
    AddMenuEntry 38, 2
    AddMenuEntry 39, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    SetVarFromValue VAR_0x8004, 1
    GoToIf 1, _056C
    CompareVar VAR_0x8008, 1
    SetVarFromValue VAR_0x8004, 4
    GoToIf 1, _056C
    CompareVar VAR_0x8008, 2
    SetVarFromValue VAR_0x8004, 7
    GoToIf 1, _056C
    Message msg_0559_T22PC0101_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
_051C:
    PlaySE SEQ_SE_DP_BOX03_sseq
    WaitSE SEQ_SE_DP_BOX03_sseq
    Message msg_0559_T22PC0101_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0533:
    ApplyMovement obj_T22PC0101_instructor, _0656
    WaitMovement
    PlayFanfare SEQ_ME_TAMAGO_GET_sseq
    Message msg_0559_T22PC0101_00019
    WaitFanfare
    WaitButton
    GoTo _0399
_054E:
    WaitMovement
    PlayFanfare SEQ_ME_TAMAGO_GET_sseq
    Message msg_0559_T22PC0101_00019
    WaitFanfare
    WaitButton
    GoTo _0399
_0561:
    Message msg_0559_T22PC0101_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_056C:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _05F9
    Message msg_0559_T22PC0101_00042
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    GivePokemon VAR_0x8004, 10, 0, VAR_RESULT
    SetFlag FLAG_HGSS_SG_3FF8
    Message msg_0559_T22PC0101_00043
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0559_T22PC0101_00044
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0604
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0637
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0559_T22PC0101_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05F9:
    Message msg_0559_T22PC0101_00040
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0604:
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0559_T22PC0101_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0637:
    Message msg_0559_T22PC0101_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0644:
    Delay8
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0656:
    Delay8
    WalkOnSpotNormalNorth
    Delay8 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
