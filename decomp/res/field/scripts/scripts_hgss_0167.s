#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0312.h"


    ScriptEntry scr_seq_0167_000
    ScriptEntry scr_seq_0167_001
    ScriptEntry scr_seq_0167_002
    ScriptEntryEnd
scr_seq_0167_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 0
    Message msg_0312_00000
    GoTo _0040
    End
scr_seq_0167_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 1
    Message msg_0312_00001
    GoTo _0040
    End
_0040:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 271, 0
    AddMenuEntry 11, 1
    AddMenuEntry 12, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _01A7
    CompareVar VAR_0x8008, 1
    GoToIf 1, _008C
    GoTo _07D9
    End
_008C:
    Message msg_0312_00011
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _00B4
    AddMenuEntry 272, 0
    GoTo _00BC
_00B4:
    AddMenuEntry 278, 7
_00BC:
    AddMenuEntry 273, 1
    AddMenuEntry 274, 2
    AddMenuEntry 277, 3
    AddMenuEntry 275, 4
    AddMenuEntry 276, 5
    AddMenuEntry 13, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _015A
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0165
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0170
    CompareVar VAR_0x8008, 3
    GoToIf 1, _017B
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0186
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0191
    CompareVar VAR_0x8008, 7
    GoToIf 1, _019C
    Message msg_0312_00002
    GoTo _0040
    End
_015A:
    Message msg_0312_00012
    GoTo _008C
    End
_0165:
    Message msg_0312_00014
    GoTo _008C
    End
_0170:
    Message msg_0312_00015
    GoTo _008C
    End
_017B:
    Message msg_0312_00018
    GoTo _008C
    End
_0186:
    Message msg_0312_00016
    GoTo _008C
    End
_0191:
    Message msg_0312_00017
    GoTo _008C
    End
_019C:
    Message msg_0312_00013
    GoTo _008C
    End
_01A7:
    CountAliveMonsAndBoxMons VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 0, _07E6
    Message msg_0312_00003
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 273, 0
    AddMenuEntry 274, 1
    AddMenuEntry 277, 4
    AddMenuEntry 275, 2
    AddMenuEntry 276, 3
    AddMenuEntry 13, 5
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0249
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0257
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0265
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0273
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0281
    Message msg_0312_00002
    GoTo _0040
    End
_0249:
    SetVarFromValue VAR_0x8000, 0
    GoTo _028F
    End
_0257:
    SetVarFromValue VAR_0x8000, 1
    GoTo _028F
    End
_0265:
    SetVarFromValue VAR_0x8000, 3
    GoTo _028F
    End
_0273:
    SetVarFromValue VAR_0x8000, 4
    GoTo _028F
    End
_0281:
    SetVarFromValue VAR_0x8000, 2
    GoTo _028F
    End
_028F:
    CompleteBufferPokeathlonCourseName 3, VAR_0x8000
    Message msg_0312_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01A7
    Message msg_0312_00005
    CloseMessage
    CompleteFollowerPutAway
    Call _04A3
    LoadDoorAnimation 0, 0, 22, 9, 77
    Call _045C
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0820
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _04DE
    ApplyMovement LOCALID_PLAYER, _0848
    WaitTime 40, VAR_RESULT
    SetPlayerState PLAYER_TRANSITION_WALKING
    ChangePlayerState
    WaitMovement
    PlayFanfare SEQ_ME_PT_NEW_sseq
    BufferPlayerName 0
    Message msg_0312_00008
    WaitFanfare
    WaitTime 30, VAR_RESULT
    Message msg_0312_00006
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0828
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    UnloadAnimation 77
    Call _0766
    ClearFlag FLAG_HGSS_SYS_ROCKET_COSTUME
    SetPlayerState PLAYER_TRANSITION_WALKING
    ChangePlayerState
    ApplyMovement LOCALID_PLAYER, _0934
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _08DC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    LoadDoorAnimation 0, 0, 22, 9, 77
    Call _045C
    CompareVar VAR_RESULT, 1
    GoToIf 1, _046F
    Call _0505
    Call _0540
    Call _0464
    Message msg_0312_00019
    BufferPlayerName 0
    BufferNumber 1, VAR_0x8001
    BufferNumber 2, VAR_0x8002
    Message msg_0312_00046
    Message msg_0312_00020
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    CompareVar VAR_0x8003, 0
    CallIf 1, _05AB
    Call _0567
    CompareVar VAR_HGSS_UNK_40E2, 1
    CallIf 1, _05ED
    CompareVar VAR_HGSS_UNK_40E2, 2
    CallIf 1, _05FA
    CompareVar VAR_HGSS_UNK_40E2, 3
    CallIf 1, _0607
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_SHOES_SIGN, _063E
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_CLOTHES_SIGN, _0657
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_FLAG_SIGN, _0670
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_POKEGEAR_SIGN, _0689
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_BALL_SIGN, _06A2
    Message msg_0312_00010
    WaitButton
    CloseMessage
    ReleaseAll
    CompleteFollowerReturn
    End
_045C:
    PlayDoorOpenAnimation 77
    WaitForAnimation 77
    Return
_0464:
    PlayDoorCloseAnimation 77
    WaitForAnimation 77
    UnloadAnimation 77
    Return
_046F:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _090C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Call _0540
    Call _0464
    CompleteFollowerReturn
    ReleaseAll
    End
_04A3:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _04C8
    ApplyMovement LOCALID_PLAYER, _0814
    GoTo _04D0
_04C8:
    ApplyMovement LOCALID_PLAYER, _083C
_04D0:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
_04DE:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _04F9
    ApplyMovement 0, _0914
    GoTo _0501
_04F9:
    ApplyMovement 10, _091C
_0501:
    WaitMovement
    Return
_0505:
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _052A
    ApplyMovement LOCALID_PLAYER, _08EC
    GoTo _0532
_052A:
    ApplyMovement LOCALID_PLAYER, _08FC
_0532:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    Return
_0540:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _055B
    ApplyMovement 0, _0924
    GoTo _0563
_055B:
    ApplyMovement 10, _0924
_0563:
    WaitMovement
    Return
_0567:
    CompareVar VAR_0x8003, 0
    GoToIf 5, _057F
    CompletePokeathlonChangeTotalPoints 0, 10
    GoTo _05A9
_057F:
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0597
    CompletePokeathlonChangeTotalPoints 0, 5
    GoTo _05A9
_0597:
    CompareVar VAR_0x8003, 3
    GoToIf 5, _05A9
    CompletePokeathlonChangeTotalPoints 1, 5
_05A9:
    Return
_05AB:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _05C4
    SetVarFromValue VAR_MAP_LOCAL_0x09, 100
    GoTo _05CA
_05C4:
    SetVarFromValue VAR_MAP_LOCAL_0x09, 300
_05CA:
    BufferNumber 2, VAR_MAP_LOCAL_0x09
    Message msg_0312_00022
    CompleteGiveAthletePoints VAR_MAP_LOCAL_0x09
    BufferPlayerName 0
    BufferNumber 2, VAR_MAP_LOCAL_0x09
    Message msg_0312_00020
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    Return
_05ED:
    CallIfSet FLAG_HGSS_UNK_0EF, _0614
    Return
_05FA:
    CallIfSet FLAG_HGSS_UNK_0F0, _0622
    Return
_0607:
    CallIfSet FLAG_HGSS_UNK_0F1, _0630
    Return
_0614:
    BufferPlayerName 0
    Message msg_0312_00023
    SetVarFromValue VAR_HGSS_UNK_40E2, 2
    Return
_0622:
    BufferPlayerName 0
    Message msg_0312_00024
    SetVarFromValue VAR_HGSS_UNK_40E2, 3
    Return
_0630:
    BufferPlayerName 0
    Message msg_0312_00025
    SetVarFromValue VAR_HGSS_UNK_40E2, 4
    Return
_063E:
    CompletePokeathlonGetTotal 16, VAR_RESULT
    CompareVar VAR_RESULT, 5000
    GoToIf 0, _0655
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_SHOES_SIGN
_0655:
    Return
_0657:
    CompletePokeathlonGetTotal 12, VAR_RESULT
    CompareVar VAR_RESULT, 50
    GoToIf 0, _066E
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_CLOTHES_SIGN
_066E:
    Return
_0670:
    CompletePokeathlonGetTotal 17, VAR_RESULT
    CompareVar VAR_RESULT, 200
    GoToIf 0, _0687
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_FLAG_SIGN
_0687:
    Return
_0689:
    CompletePokeathlonGetTotal 10, VAR_RESULT
    CompareVar VAR_RESULT, 100
    GoToIf 0, _06A0
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_POKEGEAR_SIGN
_06A0:
    Return
_06A2:
    CompletePokeathlonGetTotal 0, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 1, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 2, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 3, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 4, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 5, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 6, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 7, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 8, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    CompletePokeathlonGetTotal 9, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 50
    GoToIf 0, _0764
    ClearFlag FLAG_HGSS_HIDE_POKEATHLON_BALL_SIGN
_0764:
    Return
_0766:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _0787
    CompletePokeathlon 0, 0, VAR_0x8000, VAR_RESULT, VAR_0x8001, VAR_0x8002, VAR_0x8003
    ReturnToField
    GoTo _07D7
_0787:
    CompareVar VAR_MAP_LOCAL_0x0A, 1
    GoToIf 5, _07A8
    CompletePokeathlon 0, 1, VAR_0x8000, VAR_RESULT, VAR_0x8001, VAR_0x8002, VAR_0x8003
    ReturnToField
    GoTo _07D7
_07A8:
    CompareVar VAR_MAP_LOCAL_0x0A, 2
    GoToIf 5, _07C9
    CompletePokeathlon 1, 0, VAR_0x8000, VAR_RESULT, VAR_0x8001, VAR_0x8002, VAR_0x8003
    ReturnToField
    GoTo _07D7
_07C9:
    CompletePokeathlon 1, 1, VAR_0x8000, VAR_RESULT, VAR_0x8001, VAR_0x8002, VAR_0x8003
    ReturnToField
_07D7:
    Return
_07D9:
_07DB:
    Message msg_0312_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07E6:
    Message msg_0312_00037
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
    WalkNormalNorth 3
    WalkNormalWest
    FaceEast
    EndMovement
    .balign 4, 0
    Delay8 2
    WalkNormalEast
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0814:
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0820:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0828:
    WalkOnSpotNormalNorth
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_083C:
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0848:
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    Delay1
    FaceEast
    Delay1
    FaceSouth
    Delay1
    FaceWest
    Delay1
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    FaceWest
    FaceNorth
    FaceEast
    FaceSouth
    Delay8
    EndMovement
    .balign 4, 0
_08DC:
    WalkNormalSouth
    WalkNormalWest
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_08EC:
    WalkNormalSouth 2
    WalkNormalEast
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_08FC:
    WalkNormalSouth 2
    WalkNormalWest
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_090C:
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_0914:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_091C:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0924:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0934:
    FaceSouth
    EndMovement
scr_seq_0167_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_UNK_40E2, 0
    GoToIf 1, _0FE4
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 2
    Message msg_0312_00026
_095A:
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 271, 0
    AddMenuEntry 11, 1
    AddMenuEntry 12, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0AB1
    CompareVar VAR_0x8008, 1
    GoToIf 1, _09A6
    GoTo _07D9
    End
_09A6:
    Message msg_0312_00011
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 272, 0
    AddMenuEntry 342, 1
    AddMenuEntry 343, 2
    AddMenuEntry 344, 3
    AddMenuEntry 345, 4
    AddMenuEntry 346, 6
    CallIfUnset FLAG_HGSS_HIDE_POKEATHLON_SUPREME_CUP_RECEPTIONIST, _0B93
    AddMenuEntry 13, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0A64
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0A6F
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0A7A
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0A85
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0A90
    CompareVar VAR_0x8008, 6
    GoToIf 1, _0A9B
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0AA6
    Message msg_0312_00002
    GoTo _095A
    End
_0A64:
    Message msg_0312_00039
    GoTo _09A6
    End
_0A6F:
    Message msg_0312_00040
    GoTo _09A6
    End
_0A7A:
    Message msg_0312_00041
    GoTo _09A6
    End
_0A85:
    Message msg_0312_00042
    GoTo _09A6
    End
_0A90:
    Message msg_0312_00043
    GoTo _09A6
    End
_0A9B:
    Message msg_0312_00044
    GoTo _09A6
    End
_0AA6:
    Message msg_0312_00045
    GoTo _09A6
    End
_0AB1:
    CountAliveMonsAndBoxMons VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 0, _07E6
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0AE1
    GoTo _07DB
    End
_0AE1:
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 2
    Message msg_0312_00003
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 342, 0
    AddMenuEntry 343, 1
    AddMenuEntry 344, 2
    AddMenuEntry 345, 3
    AddMenuEntry 346, 4
    CallIfUnset FLAG_HGSS_HIDE_POKEATHLON_SUPREME_CUP_RECEPTIONIST, _0B93
    AddMenuEntry 12, 6
    ShowMenu
    SetVarFromVar VAR_MAP_LOCAL_0x0B, VAR_RESULT
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0B9D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0BAB
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0BB9
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0BC7
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0BD5
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0BE3
    GoTo _07D9
    End
_0B93:
    AddMenuEntry 279, 5
    Return
_0B9D:
    SetVarFromValue VAR_0x8000, 5
    GoTo _0BF7
    End
_0BAB:
    SetVarFromValue VAR_0x8000, 6
    GoTo _0BF7
    End
_0BB9:
    SetVarFromValue VAR_0x8000, 7
    GoTo _0BF7
    End
_0BC7:
    SetVarFromValue VAR_0x8000, 8
    GoTo _0BF7
    End
_0BD5:
    SetVarFromValue VAR_0x8000, 9
    GoTo _0BF7
    End
_0BE3:
    SetVarFromValue VAR_0x8000, 10
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 3
    GoTo _0BF7
    End
_0BF7:
    Message msg_0312_00027
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 13, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0C48
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0C88
    GoTo _0AE1
    End
    End
_0C48:
    Message msg_0312_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0BF7
    StartBattleClient 40, VAR_MAP_LOCAL_0x0B, 0, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0CC8
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0CD2
    GoTo _0CE3
    End
_0C88:
    Message msg_0312_00028
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0BF7
    StartBattleServer 40, VAR_MAP_LOCAL_0x0B, 0, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0CC8
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0CD2
    GoTo _0CE3
    End
_0CC8:
    GoTo _0BF7
    End
_0CD2:
    Message msg_0312_00029
    WaitButton
    CloseMessage
    ReleaseAll
    CompleteFollowerReturn
    End
_0CE3:
    Message msg_0312_00036
    WaitTime 30, VAR_0x8004
    CloseMessage
    CompleteFollowerPutAway
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0814
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    LoadDoorAnimation 0, 0, 10, 9, 77
    Call _045C
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0820
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement 2, _0914
    ApplyMovement LOCALID_PLAYER, _0848
    WaitTime 40, VAR_RESULT
    SetPlayerState PLAYER_TRANSITION_WALKING
    ChangePlayerState
    WaitMovement
    PlayFanfare SEQ_ME_PT_NEW_sseq
    BufferPlayerName 0
    Message msg_0312_00035
    WaitTime 30, VAR_0x8004
    WaitFanfare
    CompleteBufferPokeathlonCourseName 3, VAR_0x8000
    GetCurNetID VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0D96
    Message msg_0312_00030
    WaitTime 30, VAR_0x8004
    GoTo _0DD7
_0D96:
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _0DB2
    Message msg_0312_00031
    WaitTime 30, VAR_0x8004
    GoTo _0DD7
_0DB2:
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _0DCE
    Message msg_0312_00032
    WaitTime 30, VAR_0x8004
    GoTo _0DD7
_0DCE:
    Message msg_0312_00033
    WaitTime 30, VAR_0x8004
_0DD7:
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0FD4
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    UnloadAnimation 77
    ClearReceivedTempDataAllPlayers
    ScrCmd_135 239
    Call _0766
    ClearFlag FLAG_HGSS_SYS_ROCKET_COSTUME
    SetPlayerState PLAYER_TRANSITION_WALKING
    ChangePlayerState
    ApplyMovement LOCALID_PLAYER, _0934
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _0FDC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    LoadDoorAnimation 0, 0, 10, 9, 77
    Call _045C
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement LOCALID_PLAYER, _08EC
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement 2, _0924
    WaitMovement
    Call _0464
    Message msg_0312_00019
    BufferPlayerName 0
    BufferNumber 1, VAR_0x8001
    BufferNumber 2, VAR_0x8002
    CompareVar VAR_0x8000, 10
    GoToIf 0, _0EB5
    Message msg_0312_00047
    GoTo _0EB8
_0EB5:
    Message msg_0312_00046
_0EB8:
    Message msg_0312_00020
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    CompareVar VAR_0x8003, 1
    CallIf 3, _0F43
    Call _0F8D
    CompareVar VAR_HGSS_UNK_40E2, 1
    CallIf 1, _05ED
    CompareVar VAR_HGSS_UNK_40E2, 2
    CallIf 1, _05FA
    CompareVar VAR_HGSS_UNK_40E2, 3
    CallIf 1, _0607
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_SHOES_SIGN, _063E
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_CLOTHES_SIGN, _0657
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_FLAG_SIGN, _0670
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_POKEGEAR_SIGN, _0689
    CallIfSet FLAG_HGSS_HIDE_POKEATHLON_BALL_SIGN, _06A2
    Message msg_0312_00010
    WaitButton
    CloseMessage
    ReleaseAll
    CompleteFollowerReturn
    End
_0F43:
    CompareVar VAR_0x8003, 0
    GoToIf 5, _0F68
    SetVarFromValue VAR_MAP_LOCAL_0x09, 500
    BufferNumber 2, VAR_MAP_LOCAL_0x09
    Message msg_0312_00022
    GoTo _0F76
_0F68:
    SetVarFromValue VAR_MAP_LOCAL_0x09, 200
    BufferNumber 2, VAR_MAP_LOCAL_0x09
    Message msg_0312_00034
_0F76:
    CompleteGiveAthletePoints VAR_MAP_LOCAL_0x09
    BufferPlayerName 0
    BufferNumber 2, VAR_MAP_LOCAL_0x09
    Message msg_0312_00020
    PlayFanfare SEQ_ME_ITEM_sseq
    WaitFanfare
    Return
_0F8D:
    CompareVar VAR_0x8003, 0
    GoToIf 5, _0FA5
    CompletePokeathlonChangeTotalPoints 0, 15
    GoTo _0FCF
_0FA5:
    CompareVar VAR_0x8003, 1
    GoToIf 5, _0FBD
    CompletePokeathlonChangeTotalPoints 0, 10
    GoTo _0FCF
_0FBD:
    CompareVar VAR_0x8003, 3
    GoToIf 5, _0FCF
    CompletePokeathlonChangeTotalPoints 1, 5
_0FCF:
    Return
    .balign 4, 0
_0FD4:
    WalkNormalNorth 2
    EndMovement
    .balign 4, 0
_0FDC:
    WalkNormalSouth 2
    EndMovement
_0FE4:
    Message msg_0312_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
