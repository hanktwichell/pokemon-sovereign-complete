#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0522.h"

#define obj_T10R0101_gsrivel 5
#define obj_T10R0101_counterm 8

    ScriptEntry scr_seq_T10R0101_000
    ScriptEntry scr_seq_T10R0101_001
    ScriptEntry scr_seq_T10R0101_002
    ScriptEntry scr_seq_T10R0101_003
    ScriptEntry scr_seq_T10R0101_004
    ScriptEntry scr_seq_T10R0101_005
    ScriptEntry scr_seq_T10R0101_006
    ScriptEntry scr_seq_T10R0101_007
    ScriptEntry scr_seq_T10R0101_008
    ScriptEntry scr_seq_T10R0101_009
    ScriptEntry scr_seq_T10R0101_010
    ScriptEntryEnd
scr_seq_T10R0101_005:
    SetFlag FLAG_HGSS_HIDE_WILLS_ROOM_RETREAT
    SetFlag FLAG_HGSS_HIDE_KOGAS_ROOM_RETREAT
    SetFlag FLAG_HGSS_HIDE_BRUNOS_ROOM_RETREAT
    SetFlag FLAG_HGSS_HIDE_KARENS_ROOM_RETREAT
    ClearFlag FLAG_HGSS_HIDE_WILLS_ROOM_EXIT
    ClearFlag FLAG_HGSS_HIDE_KOGAS_ROOM_EXIT
    ClearFlag FLAG_HGSS_HIDE_BRUNOS_ROOM_EXIT
    ClearFlag FLAG_HGSS_HIDE_KARENS_ROOM_EXIT
    ClearFlag FLAG_HGSS_DEFEATED_WILL
    ClearFlag FLAG_HGSS_DEFEATED_KOGA
    ClearFlag FLAG_HGSS_DEFEATED_BRUNO
    ClearFlag FLAG_HGSS_DEFEATED_KAREN
    ClearFlag FLAG_HGSS_SG_3FDB
    CompareVar VAR_HGSS_UNK_40FC, 1
    GoToIf 3, _025D
    GoToIfSet FLAG_HGSS_UNK_AA9, _025D
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _025F
    SetVarFromValue VAR_HGSS_UNK_4119, 1
    GoTo _0278
scr_seq_T10R0101_001:
    NPCMessage msg_0522_T10R0101_00000
    End
scr_seq_T10R0101_002:
    NPCMessage msg_0522_T10R0101_00001
    End
scr_seq_T10R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_ABRA, 0
    Message msg_0522_T10R0101_00002
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T10R0101_006:
    LockAll
    FadeOutBGM 0, 3
    ApplyMovement LOCALID_PLAYER, _061A
    WaitMovement
    StopMusic
    SetBGM SEQ_GS_E_RIVAL1_sseq
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    ClearFlag FLAG_HGSS_HIDE_INDIGO_PLATEAU_RIVAL
    AddObject obj_T10R0101_gsrivel
    SetPosition obj_T10R0101_gsrivel, VAR_0x8000, 0, 23, DIR_NORTH
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T10R0101_gsrivel, _0624
    ApplyMovement LOCALID_PLAYER, _062A
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteBufferHGSSRivalName 0
    Message msg_0522_T10R0101_00003
    CloseMessage
    SetVarFromVar VAR_RESULT, VAR_HGSS_PLAYER_STARTER
    CompareVar VAR_RESULT, 152
    GoToIf 5, _027A
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_20, 0
    GoTo _0295
scr_seq_T10R0101_000:
    SetVarFromValue VAR_0x8007, 0
    SetVarFromVar VAR_0x8007, VAR_LAST_TALKED
    CallCommonScript 0x7D2
    End
scr_seq_T10R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 13
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T10R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 4, _02D2
    Message msg_0522_T10R0101_00005
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _02DD
    ApplyMovement obj_T10R0101_counterm, _0634
    GoTo _02F3
scr_seq_T10R0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0522_T10R0101_00007
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 8, 0
    AddMenuEntry 9, 1
    AddMenuEntry 10, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02FF
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0357
    GoTo _03AF
scr_seq_T10R0101_009:
    PlayCry SPECIES_TYRANITAR, 0
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0522_T10R0101_00027
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T10R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_SG_3F71, _03B7
    Message msg_0522_T10R0101_00028
    SetVar VAR_0x8004, ITEM_TM71
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_SG_3F71
    Message msg_0522_T10R0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_025D:
    End
_025F:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _03C2
    SetVarFromValue VAR_HGSS_UNK_4119, 1
    GoTo _0278
_0278:
    End
_027A:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _03CA
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_21, 0
    GoTo _0295
_0295:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _040F
    StopMusic
    SetBGM SEQ_GS_E_RIVAL2_sseq
    CompleteBufferHGSSRivalName 0
    Message msg_0522_T10R0101_00004
    CloseMessage
    ApplyMovement obj_T10R0101_gsrivel, _0642
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4119, 0
    SetFlag FLAG_HGSS_UNK_AA9
    RemoveObject obj_T10R0101_gsrivel
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_02D2:
    Message msg_0522_T10R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02DD:
    ApplyMovement obj_T10R0101_counterm, _064C
    WaitMovement
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    ReleaseAll
    End
_02F3:
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    ReleaseAll
    End
_02FF:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 1, _041D
    Message msg_0522_T10R0101_00011
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 12, 0
    AddMenuEntry 13, 1
    AddMenuEntry 14, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _041D
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0472
    GoTo _04D7
_0357:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 1, _04E0
    Message msg_0522_T10R0101_00011
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 12, 0
    AddMenuEntry 13, 1
    AddMenuEntry 14, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _04E0
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0535
    GoTo _059A
_03AF:
    CloseMessage
    ReleaseAll
    End
_03B7:
    Message msg_0522_T10R0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03C2:
    SetVarFromValue VAR_HGSS_UNK_4119, 0
    End
_03CA:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_19, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _040F
    StopMusic
    SetBGM SEQ_GS_E_RIVAL2_sseq
    CompleteBufferHGSSRivalName 0
    Message msg_0522_T10R0101_00004
    CloseMessage
    ApplyMovement obj_T10R0101_gsrivel, _0642
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4119, 0
    SetFlag FLAG_HGSS_UNK_AA9
    RemoveObject obj_T10R0101_gsrivel
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_040F:
    RemoveObject obj_T10R0101_gsrivel
    SetFlag FLAG_HGSS_HIDE_INDIGO_PLATEAU_RIVAL
    BlackOutFromBattle
    ReleaseAll
    End
_041D:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 16, 0
    AddMenuEntry 17, 1
    AddMenuEntry 18, 2
    AddMenuEntry 19, 3
    AddMenuEntry 26, 4
    ShowMenu
    CompareVar VAR_RESULT, 4
    GoToIf 1, _05E2
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GROUP, RANKINGS_SCOPE_GROUP, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _059A
_0472:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 20, 0
    AddMenuEntry 21, 1
    AddMenuEntry 22, 2
    AddMenuEntry 23, 3
    AddMenuEntry 24, 4
    AddMenuEntry 25, 5
    AddMenuEntry 26, 6
    ShowMenu
    CompareVar VAR_RESULT, 6
    GoToIf 1, _05E2
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GROUP, RANKINGS_SCOPE_GLOBAL, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _059A
_04D7:
    Message msg_0522_T10R0101_00007
    GoTo _059A
_04E0:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 16, 0
    AddMenuEntry 17, 1
    AddMenuEntry 18, 2
    AddMenuEntry 19, 3
    AddMenuEntry 26, 4
    ShowMenu
    CompareVar VAR_RESULT, 4
    GoToIf 1, _05F8
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GLOBAL, RANKINGS_SCOPE_GROUP, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _059A
_0535:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 20, 0
    AddMenuEntry 21, 1
    AddMenuEntry 22, 2
    AddMenuEntry 23, 3
    AddMenuEntry 24, 4
    AddMenuEntry 25, 5
    AddMenuEntry 26, 6
    ShowMenu
    CompareVar VAR_RESULT, 6
    GoToIf 1, _05F8
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GLOBAL, RANKINGS_SCOPE_GLOBAL, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _059A
_059A:
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 8, 0
    AddMenuEntry 9, 1
    AddMenuEntry 10, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02FF
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0357
    GoTo _03AF
_05E2:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 5, _060E
    Message msg_0522_T10R0101_00007
    GoTo _059A
_05F8:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 5, _0614
    Message msg_0522_T10R0101_00007
    GoTo _059A
_060E:
    GoTo _02FF
_0614:
    GoTo _0357
    .balign 4, 0
_061A:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_0624:
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_062A:
    Delay8 2
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0634:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_0642:
    WalkOnSpotNormalSouth
    WalkNormalSouth 7
    EndMovement
    .balign 4, 0
_064C:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
