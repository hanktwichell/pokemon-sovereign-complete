#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0051.h"

#define obj_D02R0104_tsure_poke_static_clefairy 0
#define obj_D02R0104_tsure_poke_static_clefairy_2 1
#define obj_D02R0104_tsure_poke_static_clefairy_3 2
#define obj_D02R0104_tsure_poke_static_clefairy_4 3
#define obj_D02R0104_tsure_poke_static_clefairy_5 4
#define obj_D02R0104_tsure_poke_static_clefairy_6 5
#define obj_D02R0104_monstarball 6

    ScriptEntry scr_seq_D02R0104_000
    ScriptEntry scr_seq_D02R0104_001
    ScriptEntry scr_seq_D02R0104_002
    ScriptEntry scr_seq_D02R0104_003
    ScriptEntry scr_seq_D02R0104_004
    ScriptEntry scr_seq_D02R0104_005
    ScriptEntryEnd
scr_seq_D02R0104_000:
    SetFlag FLAG_HGSS_UNK_298
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _026E
    GoTo _0281
scr_seq_D02R0104_005:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _029E
    GoTo _02B1
scr_seq_D02R0104_002:
    LockAll
    ClearFlag FLAG_HGSS_UNK_298
    GetPlayerMapPos VAR_0x8004, VAR_0x8005
    AddFreeCamera VAR_0x8004, VAR_0x8005
    ApplyMovement 241, _03B6
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _03BC
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _03C6
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _03D0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _03DA
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _03E4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _03EA
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _03F0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _03FE
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _040C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _041A
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _0428
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _042E
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _0434
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _044E
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _0468
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _0482
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _049C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _04BE
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _04E0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _04FA
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _0514
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _052E
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _0548
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _056A
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _058C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _05A6
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _05C0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _05DA
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _05F4
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _0616
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _0638
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _064E
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _0668
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _0682
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _069C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _06BE
    WaitMovement
    PlayCry SPECIES_CLEFAIRY, 0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy, _06E0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_2, _0702
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_3, _0724
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _074A
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_5, _076C
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _0786
    WaitMovement
    AddObject obj_D02R0104_monstarball
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_4, _07A0
    ApplyMovement obj_D02R0104_tsure_poke_static_clefairy_6, _07BA
    WaitMovement
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_2
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_3
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_4
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_5
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_6
    SetFlag FLAG_HGSS_UNK_26E
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_AB5
    ApplyMovement 241, _07D8
    WaitMovement
    RestoreCamera
    ReleaseAll
    End
scr_seq_D02R0104_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0051_D02R0104_00001, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D02R0104_003:
    SetVarFromValue VAR_0x8008, 81
    SetVarFromValue VAR_0x8009, 1
    GoTo _02C8
scr_seq_D02R0104_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0051_D02R0104_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026E:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0304
    GoTo _0310
_0281:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _032D
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_26E
    End
_029E:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0339
    GoTo _033F
_02B1:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 1, _0356
    GoTo _0358
_02C8:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    WaitSE SE_CONFIRM_sseq_3
    SetVarFromVar VAR_0x8004, VAR_0x8008
    SetVarFromVar VAR_0x8005, VAR_0x8009
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0389
    CompareVar VAR_RESULT, 0
    GoToIf 1, _039A
    End
_0304:
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_26E
    End
_0310:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _032D
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    SetFlag FLAG_HGSS_UNK_26E
    End
_032D:
    SetVarFromValue VAR_HGSS_UNK_40F6, 0
    ClearFlag FLAG_HGSS_UNK_26E
    End
_0339:
    GoTo _0358
_033F:
    GetTimeOfDay VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 4
    GoToIf 1, _0356
    GoTo _0358
_0356:
    End
_0358:
    CompareVar VAR_HGSS_UNK_40F6, 1
    GoToIf 1, _0356
    SetFlag FLAG_HGSS_UNK_26E
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_2
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_3
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_4
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_5
    RemoveObject obj_D02R0104_tsure_poke_static_clefairy_6
    SetVarFromValue VAR_HGSS_UNK_40F6, 1
    End
_0389:
    RemoveObject VAR_LAST_TALKED
    Common_GiveItemQuantity
    BufferPlayerName 0
    CloseMessage
    ReleaseAll
    End
_039A:
    BufferItemName 0, VAR_0x8004
    Message msg_0051_D02R0104_00004
    WaitButton
    SetVarFromValue VAR_RESULT, 0
    GoTo _03B0
_03B0:
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_03B6:
    WalkSlightlyFastNorth 2
    EndMovement
    .balign 4, 0
_03BC:
    WalkOnSpotNormalNorth 5
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_03C6:
    WalkOnSpotNormalWest 5
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_03D0:
    WalkOnSpotNormalSouth 5
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_03DA:
    WalkOnSpotNormalEast 5
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_03E4:
    WalkOnSpotNormalWest 6
    EndMovement
    .balign 4, 0
_03EA:
    WalkOnSpotNormalEast 6
    EndMovement
    .balign 4, 0
_03F0:
    WalkOnSpotNormalEast 6
    WalkNormalEast
    JumpFarEast
    EndMovement
    .balign 4, 0
_03FE:
    WalkOnSpotNormalNorth 6
    WalkNormalNorth
    JumpFarNorth
    EndMovement
    .balign 4, 0
_040C:
    WalkOnSpotNormalWest 6
    WalkNormalWest
    JumpFarWest
    EndMovement
    .balign 4, 0
_041A:
    WalkOnSpotNormalSouth 6
    WalkNormalSouth
    JumpFarSouth
    EndMovement
    .balign 4, 0
_0428:
    WalkOnSpotNormalWest 8
    EndMovement
    .balign 4, 0
_042E:
    WalkOnSpotNormalEast 8
    EndMovement
    .balign 4, 0
_0434:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 4
    JumpFarNorth
    EndMovement
    .balign 4, 0
_044E:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 4
    JumpFarWest
    EndMovement
    .balign 4, 0
_0468:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 4
    JumpFarSouth
    EndMovement
    .balign 4, 0
_0482:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkNormalEast 4
    JumpFarEast
    EndMovement
    .balign 4, 0
_049C:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_04BE:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_04E0:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 4
    JumpFarWest
    EndMovement
    .balign 4, 0
_04FA:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 4
    JumpFarSouth
    EndMovement
    .balign 4, 0
_0514:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkNormalEast 4
    JumpFarEast
    EndMovement
    .balign 4, 0
_052E:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 4
    JumpFarNorth
    EndMovement
    .balign 4, 0
_0548:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_056A:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_058C:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 4
    JumpFarSouth
    EndMovement
    .balign 4, 0
_05A6:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkNormalEast 4
    JumpFarEast
    EndMovement
    .balign 4, 0
_05C0:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 4
    JumpFarNorth
    EndMovement
    .balign 4, 0
_05DA:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 4
    JumpFarWest
    EndMovement
    .balign 4, 0
_05F4:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0616:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0638:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_064E:
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkNormalNorth 2
    JumpFarNorth
    EndMovement
    .balign 4, 0
_0668:
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkNormalWest 2
    JumpFarWest
    EndMovement
    .balign 4, 0
_0682:
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkNormalSouth 2
    JumpFarSouth
    EndMovement
    .balign 4, 0
_069C:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06BE:
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    WalkOnSpotNormalEast
    WalkOnSpotNormalNorth
    WalkOnSpotNormalWest
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_06E0:
    JumpOnSpotFastNorth 3
    WalkFastEast 6
    WalkFastNorth 3
    WalkFastEast 3
    WalkFastSouth 3
    WalkFastEast
    JumpFarEast
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_0702:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastSouth
    WalkFastEast 3
    WalkFastSouth 2
    WalkFastEast
    JumpFarEast
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_0724:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastEast 4
    WalkFastSouth 3
    WalkFastEast 3
    WalkFastSouth 2
    WalkFastEast
    JumpFarEast
    WalkFastEast 2
    EndMovement
    .balign 4, 0
_074A:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastSouth 2
    WalkFastEast 6
    WalkFastNorth 3
    WalkFastEast 2
    WalkFastSouth 3
    JumpOnSpotFastWest 2
    EndMovement
    .balign 4, 0
_076C:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkFastSouth 2
    WalkFastEast 2
    JumpFarEast
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_0786:
    WalkOnSpotNormalSouth
    EmoteExclamationMark
    WalkNormalEast 2
    WalkNormalSouth 3
    WalkNormalEast 5
    JumpOnSpotFastEast 2
    EndMovement
    .balign 4, 0
_07A0:
    WalkOnSpotFastWest 2
    WalkOnSpotFastNorth 4
    JumpOnSpotFastNorth 2
    WalkFastEast 2
    JumpFarEast
    WalkFastEast 3
    EndMovement
    .balign 4, 0
_07BA:
    WalkNormalEast
    WalkNormalNorth 3
    WalkNormalEast 3
    WalkNormalSouth 3
    WalkNormalEast
    JumpFarEast
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_07D8:
    Delay16
    WalkSlightlyFastSouth 2
    EndMovement
    .balign 4, 0
