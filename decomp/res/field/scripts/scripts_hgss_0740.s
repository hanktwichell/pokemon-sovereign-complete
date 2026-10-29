#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0451.h"

#define obj_T01R0301_ookido 0
#define obj_T01R0301_monstarball 4
#define obj_T01R0301_monstarball_2 5
#define obj_T01R0301_monstarball_3 6

    ScriptEntry scr_seq_T01R0301_000
    ScriptEntry scr_seq_T01R0301_001
    ScriptEntry scr_seq_T01R0301_002
    ScriptEntry scr_seq_T01R0301_003
    ScriptEntry scr_seq_T01R0301_004
    ScriptEntry scr_seq_T01R0301_005
    ScriptEntry scr_seq_T01R0301_006
    ScriptEntry scr_seq_T01R0301_007
    ScriptEntry scr_seq_T01R0301_008
    ScriptEntry scr_seq_T01R0301_009
    ScriptEntry scr_seq_T01R0301_010
    ScriptEntryEnd
scr_seq_T01R0301_010:
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _0057
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _0057
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _0057
    End
_0057:
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_BULBASAUR_BALL
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_SQUIRTLE_BALL
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_CHARMANDER_BALL
    SetVarFromValue VAR_HGSS_UNK_4131, 6
    End
scr_seq_T01R0301_006:
    LockAll
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _00C8
    WaitMovement
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00039, msg_0451_T01R0301_00040
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _00E0
    WaitMovement
    Message msg_0451_T01R0301_00041
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _00F4
    ApplyMovement LOCALID_PLAYER, _00D0
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Message msg_0451_T01R0301_00042
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4131, 2
    ReleaseAll
    End
    .balign 4, 0
_00C8:
    WalkNormalNorth 5
    EndMovement
    .balign 4, 0
_00D0:
    Delay8 2
    WalkNormalNorth 3
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_00E0:
    FaceNorth
    Delay8 4
    FaceSouth
    Delay8 3
    EndMovement
    .balign 4, 0
_00F4:
    WalkNormalNorth
    WalkNormalWest 3
    FaceEast
    EndMovement
scr_seq_T01R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4096, 2
    GoToIf 1, _0282
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _0277
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _0277
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _0277
    CompareVar VAR_HGSS_UNK_4131, 2
    GoToIf 1, _026C
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 7
    GoToIf 1, _04B1
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoToIf 1, _04A6
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    GoToIf 1, _02CB
    GoToIfSet FLAG_HGSS_GOT_HM08, _01B2
    GoToIfSet FLAG_HGSS_UNK_12A, _0195
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00000, msg_0451_T01R0301_00001
    SetFlag FLAG_HGSS_UNK_12A
_0195:
    CompareVar VAR_HGSS_UNK_4135, 0
    GoToIf 5, _01AB
    Message msg_0451_T01R0301_00008
    GoTo _01B2
_01AB:
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00009, msg_0451_T01R0301_00010
_01B2:
    GoToIfSet FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION, _01F2
    @ HGSS: CallStd std_in_person_evaluate_dex
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01EC
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01EC
    @ HGSS: CheckNationalDexComplete VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01F0
_01EC:
    ReleaseAll
    End
_01F0:
    WaitABPress
_01F2:
    SetFlag FLAG_HGSS_SYS_OAK_ACKNOWLEDGED_NATIONAL_DEX_COMPLETION
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00004, msg_0451_T01R0301_00005
    Message msg_0451_T01R0301_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0256
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0261
    Message msg_0451_T01R0301_00029
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 90
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Message msg_0451_T01R0301_00030
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0256:
    Message msg_0451_T01R0301_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0261:
    Message msg_0451_T01R0301_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026C:
    Message msg_0451_T01R0301_00042
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0277:
    Message msg_0451_T01R0301_00053
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0282:
    GoToIfSet FLAG_HGSS_GOT_HM08, _02C0
    Message msg_0451_T01R0301_00055
    SetVar VAR_0x8004, ITEM_HM08
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    Message msg_0451_T01R0301_00056
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00006, msg_0451_T01R0301_00007
    SetVarFromValue VAR_HGSS_UNK_4110, 2
    SetFlag FLAG_HGSS_UNLOCKED_MT_SILVER
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_GOT_HM08
    ReleaseAll
    End
_02C0:
    Message msg_0451_T01R0301_00057
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02CB:
    @ HGSS: CheckKyogreGroudonInParty VAR_SPECIAL_x8005
    CompareVar VAR_0x8005, 1
    GoToIf 1, _040D
    GoToIfSet FLAG_HGSS_UNK_0BC, _03DE
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00011, msg_0451_T01R0301_00012
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _04D4
    WaitMovement
    SetFlag FLAG_HGSS_UNK_0BC
    Message msg_0451_T01R0301_00013
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0320
    GoTo _035A
_031A:
    GoTo _0358
_0320:
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _0339
    GoTo _037B
_0333:
    GoTo _0358
_0339:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0352
    GoTo _039C
_034C:
    GoTo _0358
_0352:
    GoTo _03BD
_0358:
    WaitMovement
_035A:
    ApplyMovement obj_T01R0301_ookido, _0500
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0500
    WaitMovement
    GoTo _03DE
    End
_037B:
    ApplyMovement obj_T01R0301_ookido, _052C
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _052C
    WaitMovement
    GoTo _03DE
    End
_039C:
    ApplyMovement obj_T01R0301_ookido, _0558
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0558
    WaitMovement
    GoTo _03DE
    End
_03BD:
    ApplyMovement obj_T01R0301_ookido, _0584
    WaitMovement
    Message msg_0451_T01R0301_00014
    CloseMessage
    ApplyMovement obj_T01R0301_ookido, _0584
    WaitMovement
    GoTo _03DE
    End
_03DE:
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 8
    GoToIf 1, _03FE
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00015, msg_0451_T01R0301_00016
    CloseMessage
    GoTo _01B2
_03FE:
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00017, msg_0451_T01R0301_00018
    CloseMessage
    GoTo _01B2
_040D:
    GoToIfUnset FLAG_HGSS_UNK_0BC, _04C2
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00019, msg_0451_T01R0301_00020
    CloseMessage
_0421:
    GetPlayerDir VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0440
    ApplyMovement obj_T01R0301_ookido, _0500
    GoTo _047E
_0440:
    CompareVar VAR_MAP_LOCAL_0x01, 3
    GoToIf 5, _045B
    ApplyMovement obj_T01R0301_ookido, _052C
    GoTo _047E
_045B:
    CompareVar VAR_MAP_LOCAL_0x01, 2
    GoToIf 5, _0476
    ApplyMovement obj_T01R0301_ookido, _0558
    GoTo _047E
_0476:
    ApplyMovement obj_T01R0301_ookido, _0584
_047E:
    WaitMovement
    BufferPlayerName 0
    SetVar VAR_0x8004, ITEM_JADE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    Message msg_0451_T01R0301_00021
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoTo _01B2
_04A6:
    Message msg_0451_T01R0301_00022
    CloseMessage
    GoTo _01B2
_04B1:
    Message msg_0451_T01R0301_00023
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 8
    GoTo _01B2
_04C2:
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00024, msg_0451_T01R0301_00025
    CloseMessage
    GoTo _0421
    .balign 4, 0
_04D4:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_04E0:
    WalkOnSpotNormalNorth
    WalkSlowNorth 2
    Delay8 4
    WalkOnSpotNormalSouth
    Delay8 4
    WalkSlowSouth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0500:
    WalkOnSpotNormalSouth
    Delay8
    EndMovement
    .balign 4, 0
_050C:
    WalkOnSpotNormalEast
    WalkSlowEast 2
    Delay8 4
    WalkOnSpotNormalWest
    Delay8 4
    WalkSlowWest 2
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_052C:
    WalkOnSpotNormalWest
    Delay8
    EndMovement
    .balign 4, 0
_0538:
    WalkOnSpotNormalWest
    WalkSlowWest 2
    Delay8 4
    WalkOnSpotNormalEast
    Delay8 4
    WalkSlowEast 2
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0558:
    WalkOnSpotNormalEast
    Delay8
    EndMovement
    .balign 4, 0
_0564:
    WalkOnSpotNormalSouth
    WalkSlowSouth 2
    Delay8 4
    WalkOnSpotNormalNorth
    Delay8 4
    WalkSlowNorth 2
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0584:
    WalkOnSpotNormalNorth
    Delay8
    EndMovement
scr_seq_T01R0301_001:
    NPCMessage msg_0451_T01R0301_00033
    End
scr_seq_T01R0301_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0451_T01R0301_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0451_T01R0301_00035
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0451_T01R0301_00036
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    MessageGendered msg_0451_T01R0301_00037, msg_0451_T01R0301_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T01R0301_007:
    CompareVar VAR_HGSS_UNK_4131, 6
    GoToIf 1, _0979
    CompareVar VAR_HGSS_UNK_4131, 0
    GoToIf 1, _097B
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _097B
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _097D
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _097D
    .short SCRCMD_UNUSED_06A
    .short 0
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0663
    ApplyMovement obj_T01R0301_ookido, _09C4
    GoTo _066B
_0663:
    ApplyMovement obj_T01R0301_ookido, _09BC
_066B:
    WaitMovement
    @ HGSS: ScrCmd_452 SPECIES_BULBASAUR, 0
    PlayCry SPECIES_BULBASAUR, 0
    Message msg_0451_T01R0301_00045
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _096C
    SetVarFromValue VAR_0x8004, 1
    SetVarFromValue VAR_0x8006, 3
    Call _0801
    End
scr_seq_T01R0301_008:
    CompareVar VAR_HGSS_UNK_4131, 6
    GoToIf 1, _0979
    CompareVar VAR_HGSS_UNK_4131, 0
    GoToIf 1, _097B
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _097B
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _097D
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _097D
    .short SCRCMD_UNUSED_06A
    .short 0
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _0711
    ApplyMovement obj_T01R0301_ookido, _09C4
    GoTo _0719
_0711:
    ApplyMovement obj_T01R0301_ookido, _09BC
_0719:
    WaitMovement
    @ HGSS: ScrCmd_452 SPECIES_SQUIRTLE, 0
    PlayCry SPECIES_SQUIRTLE, 0
    Message msg_0451_T01R0301_00044
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _096C
    SetVarFromValue VAR_0x8004, 7
    SetVarFromValue VAR_0x8006, 4
    Call _0801
    End
scr_seq_T01R0301_009:
    CompareVar VAR_HGSS_UNK_4131, 6
    GoToIf 1, _0979
    CompareVar VAR_HGSS_UNK_4131, 0
    GoToIf 1, _097B
    CompareVar VAR_HGSS_UNK_4131, 5
    GoToIf 1, _097B
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_4131, 3
    GoToIf 1, _097D
    CompareVar VAR_HGSS_UNK_4131, 4
    GoToIf 1, _097D
    .short SCRCMD_UNUSED_06A
    .short 0
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 5, _07BF
    ApplyMovement obj_T01R0301_ookido, _09C4
    GoTo _07C7
_07BF:
    ApplyMovement obj_T01R0301_ookido, _09BC
_07C7:
    WaitMovement
    @ HGSS: ScrCmd_452 SPECIES_CHARMANDER, 0
    PlayCry SPECIES_CHARMANDER, 0
    Message msg_0451_T01R0301_00043
    WaitCry
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _096C
    SetVarFromValue VAR_0x8004, 4
    SetVarFromValue VAR_0x8006, 5
    Call _0801
    End
_0801:
    @ HGSS: ScrCmd_453
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 1, _098B
    CompareVar VAR_0x8004, 1
    GoToIf 5, _082F
    RemoveObject obj_T01R0301_monstarball_3
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_BULBASAUR_BALL
    GoTo _0852
_082F:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _084A
    RemoveObject obj_T01R0301_monstarball_2
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_SQUIRTLE_BALL
    GoTo _0852
_084A:
    RemoveObject obj_T01R0301_monstarball
    SetFlag FLAG_HGSS_HIDE_OAKS_LAB_CHARMANDER_BALL
_0852:
    BufferPlayerName 0
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    Message msg_0451_T01R0301_00046
    Message msg_0451_T01R0301_00048
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    @ HGSS: GiveMon VAR_SPECIAL_x8004, 5, 0, 0, 0, VAR_SPECIAL_RESULT
    BufferSpeciesNameFromVar 1, VAR_0x8004, 0, 0
    Message msg_0451_T01R0301_00049
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    CallIf 1, _0929
    .short SCRCMD_UNUSED_06A
    .short 0
    .short VAR_MAP_LOCAL_0x00
    .short VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 8
    GoToIf 1, _0908
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_0x8004, 1
    GoToIf 5, _08D3
    ApplyMovement LOCALID_PLAYER, _0998
    GoTo _08F6
_08D3:
    CompareVar VAR_0x8004, 7
    GoToIf 5, _08EE
    ApplyMovement LOCALID_PLAYER, _09A4
    GoTo _08F6
_08EE:
    ApplyMovement LOCALID_PLAYER, _09B0
_08F6:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    GoTo _0912
_0908:
    ApplyMovement LOCALID_PLAYER, _09CC
    WaitMovement
_0912:
    Message msg_0451_T01R0301_00052
    WaitButton
    CloseMessage
    ReleaseAll
    SetVarFromVar VAR_HGSS_UNK_4131, VAR_0x8006
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 1
    Return
_0929:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    BufferPartyMonNickname 1, VAR_0x8005
    Message msg_0451_T01R0301_00050
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0929
    Return
_096C:
    @ HGSS: ScrCmd_453
    Message msg_0451_T01R0301_00047
    WaitButton
    CloseMessage
    ReleaseAll
_0979:
    End
_097B:
    End
_097D:
    BufferRivalName 1
    Message msg_0451_T01R0301_00054
    WaitButton
    CloseMessage
    ReleaseAll
    End
_098B:
    Message msg_0451_T01R0301_00051
    WaitButton
    CloseMessage
    ReleaseAll
    Return
    .balign 4, 0
_0998:
    WalkNormalSouth
    WalkNormalWest 3
    EndMovement
    .balign 4, 0
_09A4:
    WalkNormalSouth
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_09B0:
    WalkNormalSouth
    WalkNormalWest
    EndMovement
    .balign 4, 0
_09BC:
    FaceEast
    EndMovement
    .balign 4, 0
_09C4:
    FaceNorth
    EndMovement
    .balign 4, 0
_09CC:
    FaceSouth
    EndMovement
    .balign 4, 0
