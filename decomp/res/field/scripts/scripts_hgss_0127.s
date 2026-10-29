#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0142.h"

#define obj_D49R0106_pcwoman2 0
#define obj_D49R0106_tsure_poke_static_dodrio 3

    ScriptEntry scr_seq_D49R0106_000
    ScriptEntry scr_seq_D49R0106_001
    ScriptEntry scr_seq_D49R0106_002
    ScriptEntry scr_seq_D49R0106_003
    ScriptEntry scr_seq_D49R0106_004
    ScriptEntry scr_seq_D49R0106_005
    ScriptEntry scr_seq_D49R0106_006
    ScriptEntry scr_seq_D49R0106_007
    ScriptEntry scr_seq_D49R0106_008
    ScriptEntryEnd
scr_seq_D49R0106_008:
    GoToIfSet FLAG_HGSS_UNK_0F1, _0039
    SetVarFromValue VAR_MAP_LOCAL_0x0D, 0
    End
_0039:
    SetVarFromValue VAR_MAP_LOCAL_0x0D, 1
    End
scr_seq_D49R0106_007:
    CompareVar VAR_MAP_LOCAL_0x0D, 1
    GoToIf 5, _0060
    SetPosition obj_D49R0106_pcwoman2, 6, 1, 3, DIR_EAST
    SetVarFromValue VAR_MAP_LOCAL_0x0D, 0
_0060:
    End
scr_seq_D49R0106_000:
    NPCMessage msg_0142_D49R0106_00000
    End
scr_seq_D49R0106_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_0F1, _0093
    Message msg_0142_D49R0106_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0093:
    Message msg_0142_D49R0106_00002
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0106_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0142_D49R0106_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03AC
_00BC:
    Message msg_0142_D49R0106_00006
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 308, 0
    AddMenuEntryImm 309, 1
    AddMenuEntryImm 310, 2
    AddMenuEntryImm 311, 3
    AddMenuEntryImm 312, 4
    AddMenuEntryImm 135, 5
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 5
    GoToIf 1, _03AC
    Message msg_0142_D49R0106_00007
    CompareVar VAR_0x8008, 0
    GoToIf 1, _014D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0187
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01C1
    CompareVar VAR_0x8008, 3
    GoToIf 1, _01FB
    GoTo _0235
    End
_014D:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 298, 0
    AddMenuEntryImm 299, 1
    AddMenuEntryImm 304, 6
    AddMenuEntryImm 13, 10
    ShowMenu
    GoTo _026F
    End
_0187:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 1
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 301, 3
    AddMenuEntryImm 300, 2
    AddMenuEntryImm 307, 9
    AddMenuEntryImm 13, 10
    ShowMenu
    GoTo _026F
    End
_01C1:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 2
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 306, 8
    AddMenuEntryImm 307, 9
    AddMenuEntryImm 299, 1
    AddMenuEntryImm 13, 10
    ShowMenu
    GoTo _026F
    End
_01FB:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 3
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 305, 7
    AddMenuEntryImm 304, 6
    AddMenuEntryImm 301, 3
    AddMenuEntryImm 13, 10
    ShowMenu
    GoTo _026F
    End
_0235:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 4
    InitGlobalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm 303, 5
    AddMenuEntryImm 302, 4
    AddMenuEntryImm 298, 0
    AddMenuEntryImm 13, 10
    ShowMenu
    GoTo _026F
    End
_026F:
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02FF
    CompareVar VAR_0x8008, 1
    GoToIf 1, _030A
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0315
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0320
    CompareVar VAR_0x8008, 4
    GoToIf 1, _032B
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0336
    CompareVar VAR_0x8008, 6
    GoToIf 1, _0341
    CompareVar VAR_0x8008, 7
    GoToIf 1, _034C
    CompareVar VAR_0x8008, 8
    GoToIf 1, _0357
    CompareVar VAR_0x8008, 9
    GoToIf 1, _0362
    GoTo _00BC
    End
_02FF:
    Message msg_0142_D49R0106_00008
    GoTo _036D
    End
_030A:
    Message msg_0142_D49R0106_00009
    GoTo _036D
    End
_0315:
    Message msg_0142_D49R0106_00010
    GoTo _036D
    End
_0320:
    Message msg_0142_D49R0106_00011
    GoTo _036D
    End
_032B:
    Message msg_0142_D49R0106_00012
    GoTo _036D
    End
_0336:
    Message msg_0142_D49R0106_00013
    GoTo _036D
    End
_0341:
    Message msg_0142_D49R0106_00014
    GoTo _036D
    End
_034C:
    Message msg_0142_D49R0106_00015
    GoTo _036D
    End
_0357:
    Message msg_0142_D49R0106_00016
    GoTo _036D
    End
_0362:
    Message msg_0142_D49R0106_00017
    GoTo _036D
    End
_036D:
    Message msg_0142_D49R0106_00007
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 1, _014D
    CompareVar VAR_MAP_LOCAL_0x07, 1
    GoToIf 1, _0187
    CompareVar VAR_MAP_LOCAL_0x07, 2
    GoToIf 1, _01C1
    CompareVar VAR_MAP_LOCAL_0x07, 3
    GoToIf 1, _01FB
    GoTo _0235
    End
_03AC:
    Message msg_0142_D49R0106_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0106_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03E0
    ApplyMovement obj_D49R0106_tsure_poke_static_dodrio, _043C
    GoTo _041E
_03E0:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _03FB
    ApplyMovement obj_D49R0106_tsure_poke_static_dodrio, _0434
    GoTo _041E
_03FB:
    CompareVar VAR_RESULT, 2
    GoToIf 5, _0416
    ApplyMovement obj_D49R0106_tsure_poke_static_dodrio, _044C
    GoTo _041E
_0416:
    ApplyMovement obj_D49R0106_tsure_poke_static_dodrio, _0444
_041E:
    WaitMovement
    PlayCry SPECIES_DODRIO, 0
    Message msg_0142_D49R0106_00024
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0434:
    JumpOnSpotFastNorth 2
    EndMovement
    .balign 4, 0
_043C:
    JumpOnSpotFastSouth 2
    EndMovement
    .balign 4, 0
_0444:
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_044C:
    JumpOnSpotFastEast 2
    EndMovement
scr_seq_D49R0106_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0142_D49R0106_00023
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_712 2
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D49R0106_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_HIDE_POKEATHLON_POKEGEAR_SIGN, _04A3
    Message msg_0142_D49R0106_00019
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04A3:
    Message msg_0142_D49R0106_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0106_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_HIDE_POKEATHLON_BALL_SIGN, _04CC
    Message msg_0142_D49R0106_00021
    WaitButton
    CloseMessage
    ReleaseAll
    End
_04CC:
    Message msg_0142_D49R0106_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
