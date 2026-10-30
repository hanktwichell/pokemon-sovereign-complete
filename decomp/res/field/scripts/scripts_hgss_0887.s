#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0583.h"


    ScriptEntry scr_seq_T25PC0101_000
    ScriptEntry scr_seq_T25PC0101_001
    ScriptEntry scr_seq_T25PC0101_002
    ScriptEntry scr_seq_T25PC0101_003
    ScriptEntry scr_seq_T25PC0101_004
    ScriptEntry scr_seq_T25PC0101_005
    ScriptEntryEnd
scr_seq_T25PC0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T25PC0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _00E2
    Message msg_0583_T25PC0101_00003
    GoTo _010F
scr_seq_T25PC0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _0117
    Message msg_0583_T25PC0101_00005
    GoTo _0122
scr_seq_T25PC0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _012A
    Message msg_0583_T25PC0101_00001
    GoTo _0135
scr_seq_T25PC0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 3
    GoToIf 5, _013D
    Message msg_0583_T25PC0101_00003
    GoTo _010F
scr_seq_T25PC0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_SG_3FF3, _0180
    GoToIfSet FLAG_HGSS_SG_3FF2, _018D
    Message msg_0583_T25PC0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0196
    Message msg_0583_T25PC0101_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00E2:
    GoToIfSet FLAG_HGSS_SG_3F7B, _016A
    Message msg_0583_T25PC0101_00026
    SetVar VAR_0x8004, ITEM_TM04
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F7B
    Message msg_0583_T25PC0101_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_010F:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0117:
    Message msg_0583_T25PC0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0122:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_012A:
    Message msg_0583_T25PC0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0135:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013D:
    GoToIfSet FLAG_HGSS_SG_3F7A, _0175
    Message msg_0583_T25PC0101_00028
    SetVar VAR_0x8004, ITEM_TM08
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F7A
    Message msg_0583_T25PC0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_016A:
    Message msg_0583_T25PC0101_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0175:
    Message msg_0583_T25PC0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0180:
    Message msg_0583_T25PC0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_018D:
    Message msg_0583_T25PC0101_00025
    GoTo _0217
_0196:
    Message msg_0583_T25PC0101_00008
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _028F
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0583_T25PC0101_00011
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _028F
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0583_T25PC0101_00012
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _028F
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    Message msg_0583_T25PC0101_00013
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _028F
    CloseMessage
    PlaySE SEQ_SE_DP_PINPON_sseq
    WaitSE SEQ_SE_DP_PINPON_sseq
    SetFlag FLAG_HGSS_SG_3FF2
    Message msg_0583_T25PC0101_00014
    GoTo _0217
_0217:
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 16, 0
    AddMenuEntry 17, 1
    AddMenuEntry 18, 2
    AddMenuEntry 19, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    SetVarFromValue VAR_0x8004, 387
    GoToIf 1, _02A6
    CompareVar VAR_0x8008, 1
    SetVarFromValue VAR_0x8004, 390
    GoToIf 1, _02A6
    CompareVar VAR_0x8008, 2
    SetVarFromValue VAR_0x8004, 393
    GoToIf 1, _02A6
    Message msg_0583_T25PC0101_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
_028F:
    PlaySE SEQ_SE_DP_BOX03_sseq
    WaitSE SEQ_SE_DP_BOX03_sseq
    Message msg_0583_T25PC0101_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02A6:
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _0333
    Message msg_0583_T25PC0101_00022
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    GivePokemon VAR_0x8004, 20, 0, VAR_RESULT
    SetFlag FLAG_HGSS_SG_3FF3
    Message msg_0583_T25PC0101_00023
    PlayFanfare SEQ_ME_POKEGET_sseq
    WaitFanfare
    Message msg_0583_T25PC0101_00024
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _033E
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0371
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0583_T25PC0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0333:
    Message msg_0583_T25PC0101_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_033E:
    CloseMessage
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_0x8005, VAR_MAP_LOCAL_0x00
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0583_T25PC0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0371:
    Message msg_0583_T25PC0101_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
