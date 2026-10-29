#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0259.h"

#define obj_P01R0301_seaman_2_2 1
#define obj_P01R0301_gsgentleman 3

    ScriptEntry scr_seq_P01R0301_000
    ScriptEntry scr_seq_P01R0301_001
    ScriptEntry scr_seq_P01R0301_002
    ScriptEntry scr_seq_P01R0301_003
    ScriptEntry scr_seq_P01R0301_004
    ScriptEntry scr_seq_P01R0301_005
    ScriptEntry scr_seq_P01R0301_006
    ScriptEntry scr_seq_P01R0301_007
    ScriptEntry scr_seq_P01R0301_008
    ScriptEntry scr_seq_P01R0301_009
    ScriptEntryEnd
scr_seq_P01R0301_007:
    GoToIfUnset FLAG_HGSS_BOAT_ARRIVED, _014B
    End
scr_seq_P01R0301_006:
    CompareVar VAR_HGSS_BOAT_DIRECTION, 1
    GoToIf 3, _014D
    CompareVar VAR_HGSS_BOAT_DIRECTION, 2
    GoToIf 4, _0157
    End
scr_seq_P01R0301_008:
    End
scr_seq_P01R0301_005:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _039C
    ApplyMovement obj_P01R0301_seaman_2_2, _03A2
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    SetVarFromValue VAR_HGSS_UNK_40DC, 1
    ReleaseAll
    End
scr_seq_P01R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_BOAT_DIRECTION, 1
    GoToIf 2, _0161
    GoTo _0167
scr_seq_P01R0301_004:
    LockAll
    ApplyMovement LOCALID_PLAYER, _03C0
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 22
    GoToIf 5, _017D
    SetPosition obj_P01R0301_gsgentleman, 31, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _019C
scr_seq_P01R0301_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: NopVar490 VAR_SCENE_SS_AQUA
    CompareVar VAR_HGSS_SCENE_SS_AQUA, 7
    GoToIf 0, _01DD
    Message msg_0259_P01R0301_00009
    GoTo _01E8
scr_seq_P01R0301_002:
    NPCMessage msg_0259_P01R0301_00010
    End
scr_seq_P01R0301_003:
    End
scr_seq_P01R0301_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3FAD, _02F9
    DrawPokemonPreview SPECIES_PHIONE, 0
    Message msg_0259_P01R0301_00013
    WaitButton
    CloseMessage
    RemovePokemonPreview
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 489
    GoToIf 1, _0323
    ReleaseAll
    End
_014B:
    End
_014D:
    SetWarpEventPos 0, 27, 20
    End
_0157:
    SetWarpEventPos 12, 27, 20
    End
_0161:
    GoTo _01F0
_0167:
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _0206
    Message msg_0259_P01R0301_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_017D:
    CompareVar VAR_MAP_LOCAL_0x00, 23
    GoToIf 5, _0232
    SetPosition obj_P01R0301_gsgentleman, 32, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _019C
_019C:
    ApplyMovement obj_P01R0301_gsgentleman, _03C6
    ApplyMovement LOCALID_PLAYER, _03DC
    WaitMovement
    ApplyMovement obj_P01R0301_gsgentleman, _03F2
    WaitMovement
    Message msg_0259_P01R0301_00007
    CloseMessage
    ApplyMovement obj_P01R0301_gsgentleman, _03F8
    WaitMovement
    RemoveObject obj_P01R0301_gsgentleman
    SetFlag FLAG_HGSS_UNK_215
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 2
    ReleaseAll
    End
_01DD:
    Message msg_0259_P01R0301_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01E8:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F0:
    GoToIfSet FLAG_HGSS_BOAT_ARRIVED, _0251
    Message msg_0259_P01R0301_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0206:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0277
    Message msg_0259_P01R0301_00002
    CloseMessage
    ApplyMovement obj_P01R0301_seaman_2_2, _040E
    WaitMovement
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 7
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    ReleaseAll
    End
_0232:
    CompareVar VAR_MAP_LOCAL_0x00, 24
    GoToIf 5, _0282
    SetPosition obj_P01R0301_gsgentleman, 33, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _019C
_0251:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _02A1
    Message msg_0259_P01R0301_00005
    CloseMessage
    ApplyMovement obj_P01R0301_seaman_2_2, _040E
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x00, 1
    ReleaseAll
    End
_0277:
    Message msg_0259_P01R0301_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0282:
    CompareVar VAR_MAP_LOCAL_0x00, 25
    GoToIf 5, _02AC
    SetPosition obj_P01R0301_gsgentleman, 34, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    GoTo _019C
_02A1:
    Message msg_0259_P01R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02AC:
    SetPosition obj_P01R0301_gsgentleman, 35, 0, VAR_MAP_LOCAL_0x01, DIR_WEST
    ApplyMovement obj_P01R0301_gsgentleman, _03C6
    ApplyMovement LOCALID_PLAYER, _03DC
    WaitMovement
    ApplyMovement obj_P01R0301_gsgentleman, _03F2
    WaitMovement
    Message msg_0259_P01R0301_00007
    CloseMessage
    ApplyMovement obj_P01R0301_gsgentleman, _03F8
    WaitMovement
    RemoveObject obj_P01R0301_gsgentleman
    SetFlag FLAG_HGSS_UNK_215
    SetVarFromValue VAR_HGSS_SCENE_SS_AQUA, 2
    ReleaseAll
    End
_02F9:
    DrawPokemonPreview SPECIES_MANAPHY, 0
    Message msg_0259_P01R0301_00015
    WaitButton
    CloseMessage
    RemovePokemonPreview
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 490
    GoToIf 1, _034F
    ReleaseAll
    End
_0323:
    PlayCry SPECIES_PHIONE, 6
    WaitCry
    ApplyMovement 4, _03C0
    WaitMovement
    Message msg_0259_P01R0301_00014
    DrawPokemonPreview SPECIES_MANAPHY, 0
    SetFlag FLAG_HGSS_SG_3FAD
    Message msg_0259_P01R0301_00015
    WaitButton
    CloseMessage
    RemovePokemonPreview
    ReleaseAll
    End
_034F:
    PlayCry SPECIES_MANAPHY, 6
    WaitCry
    ApplyMovement 4, _03C0
    WaitMovement
    Message msg_0259_P01R0301_00016
    SetVar VAR_0x8004, ITEM_SPLASH_PLATE
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    MessageGendered msg_0259_P01R0301_00017, msg_0259_P01R0301_00018
    WaitButton
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 4
    FadeScreen 8, 1, 1, 10
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_039C:
    WalkNormalNorth 4
    EndMovement
    .balign 4, 0
_03A2:
    LockDir
    WalkSlowWest
    UnlockDir
    FaceEast 2
    Delay16
    WalkSlowEast
    FaceNorth 2
    EndMovement
    .balign 4, 0
_03C0:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_03C6:
    WalkFastWest 9
    LockDir
    JumpNearFastEast
    UnlockDir
    Delay16
    EndMovement
    .balign 4, 0
_03DC:
    Delay2 5
    FaceEast 2
    Delay2 5
    JumpOnSpotFastEast
    Delay16
    EndMovement
    .balign 4, 0
_03F2:
    JumpOnSpotFastWest 4
    EndMovement
    .balign 4, 0
_03F8:
    WalkOnSpotFastWest 2
    FaceNorth 2
    WalkFastNorth
    FaceWest 2
    WalkFastWest 10
    EndMovement
    .balign 4, 0
_040E:
    LockDir
    WalkNormalSouth
    UnlockDir
    FaceWest 2
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
