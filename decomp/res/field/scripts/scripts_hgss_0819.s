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
    CompareVar VAR_HGSS_UNK_40FC, 1
    GoToIf 3, _00AC
    GoToIfSet FLAG_HGSS_UNK_AA9, _00AC
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _008B
    SetVarFromValue VAR_HGSS_UNK_4119, 1
    GoTo _00AA
_008B:
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _00A4
    SetVarFromValue VAR_HGSS_UNK_4119, 1
    GoTo _00AA
_00A4:
    SetVarFromValue VAR_HGSS_UNK_4119, 0
_00AA:
    End
_00AC:
    End
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
    ApplyMovement LOCALID_PLAYER, _01DC
    WaitMovement
    Common_SetRivalBGM
    GetPlayerMapPos VAR_0x8000, VAR_0x8001
    ClearFlag FLAG_HGSS_HIDE_INDIGO_PLATEAU_RIVAL
    AddObject obj_T10R0101_gsrivel
    SetPosition obj_T10R0101_gsrivel, VAR_0x8000, 0, 23, DIR_NORTH
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    ApplyMovement obj_T10R0101_gsrivel, _0208
    ApplyMovement LOCALID_PLAYER, _01E8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    BufferRivalName 0
    Message msg_0522_T10R0101_00003
    CloseMessage
    @ HGSS: GetStarterChoice VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 152
    GoToIf 5, _016E
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_20, 0, 0, 0
    GoTo _0191
_016E:
    CompareVar VAR_RESULT, 155
    GoToIf 5, _0189
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_21, 0, 0, 0
    GoTo _0191
_0189:
    @ HGSS: TrainerBattle TRAINER_RIVAL_SILVER_19, 0, 0, 0
_0191:
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01CE
    Common_SetRivalBGM
    BufferRivalName 0
    Message msg_0522_T10R0101_00004
    CloseMessage
    ApplyMovement obj_T10R0101_gsrivel, _0210
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4119, 0
    SetFlag FLAG_HGSS_UNK_AA9
    RemoveObject obj_T10R0101_gsrivel
    Common_FadeToDefaultMusic2
    ReleaseAll
    End
_01CE:
    RemoveObject obj_T10R0101_gsrivel
    SetFlag FLAG_HGSS_HIDE_INDIGO_PLATEAU_RIVAL
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_01DC:
    EmoteExclamationMark
    Delay8
    EndMovement
    .balign 4, 0
_01E8:
    Delay8 2
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01F4:
    Delay8 2
    WalkNormalEast
    WalkNormalNorth
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0208:
    WalkNormalNorth 7
    EndMovement
    .balign 4, 0
_0210:
    WalkOnSpotNormalSouth
    WalkNormalSouth 7
    EndMovement
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
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T10R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x05, 1
    GoToIf 4, _0293
    Message msg_0522_T10R0101_00005
    CloseMessage
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _027D
    ApplyMovement obj_T10R0101_counterm, _02A0
    GoTo _0287
_027D:
    ApplyMovement obj_T10R0101_counterm, _02B0
    WaitMovement
_0287:
    WaitMovement
    SetVarFromValue VAR_MAP_LOCAL_0x05, 1
    ReleaseAll
    End
_0293:
    Message msg_0522_T10R0101_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_02A0:
    LockDir
    WalkNormalWest
    UnlockDir
    EndMovement
    .balign 4, 0
_02B0:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
scr_seq_T10R0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0522_T10R0101_00007
_02CD:
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0522_T10R0101_00008, 0
    AddMenuEntryImm msg_0522_T10R0101_00009, 1
    AddMenuEntryImm msg_0522_T10R0101_00010, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0317
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0456
    GoTo _058C
    End
_0317:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 1, _037A
    Message msg_0522_T10R0101_00011
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0522_T10R0101_00012, 0
    AddMenuEntryImm msg_0522_T10R0101_00013, 1
    AddMenuEntryImm msg_0522_T10R0101_00014, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _037A
    CompareVar VAR_0x8008, 1
    GoToIf 1, _03F1
    GoTo _0371
    End
_0371:
    Message msg_0522_T10R0101_00007
    GoTo _02CD
_037A:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0522_T10R0101_00016, 0
    AddMenuEntryImm msg_0522_T10R0101_00017, 1
    AddMenuEntryImm msg_0522_T10R0101_00018, 2
    AddMenuEntryImm msg_0522_T10R0101_00019, 3
    AddMenuEntryImm msg_0522_T10R0101_00026, 4
    ShowMenu
    CompareVar VAR_RESULT, 4
    GoToIf 1, _03CF
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GROUP, RANKINGS_PAGE_POKEMON, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _02CD
_03CF:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 5, _03EB
    Message msg_0522_T10R0101_00007
    GoTo _02CD
_03E5:
    GoTo _03F1
_03EB:
    GoTo _0317
_03F1:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0522_T10R0101_00020, 0
    AddMenuEntryImm msg_0522_T10R0101_00021, 1
    AddMenuEntryImm msg_0522_T10R0101_00022, 2
    AddMenuEntryImm msg_0522_T10R0101_00023, 3
    AddMenuEntryImm msg_0522_T10R0101_00024, 4
    AddMenuEntryImm msg_0522_T10R0101_00025, 5
    AddMenuEntryImm msg_0522_T10R0101_00026, 6
    ShowMenu
    CompareVar VAR_RESULT, 6
    GoToIf 1, _03CF
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GROUP, RANKINGS_PAGE_BATTLE_TOWER, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _02CD
_0456:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 1, _04B0
    Message msg_0522_T10R0101_00011
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0522_T10R0101_00012, 0
    AddMenuEntryImm msg_0522_T10R0101_00013, 1
    AddMenuEntryImm msg_0522_T10R0101_00014, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _04B0
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0527
    GoTo _02CD
    End
_04B0:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0522_T10R0101_00016, 0
    AddMenuEntryImm msg_0522_T10R0101_00017, 1
    AddMenuEntryImm msg_0522_T10R0101_00018, 2
    AddMenuEntryImm msg_0522_T10R0101_00019, 3
    AddMenuEntryImm msg_0522_T10R0101_00026, 4
    ShowMenu
    CompareVar VAR_RESULT, 4
    GoToIf 1, _0505
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GLOBAL, RANKINGS_PAGE_POKEMON, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _02CD
_0505:
    CompareVar VAR_HGSS_UNK_40E6, 0
    GoToIf 5, _0521
    Message msg_0522_T10R0101_00007
    GoTo _02CD
_051B:
    GoTo _0527
_0521:
    GoTo _0456
_0527:
    Message msg_0522_T10R0101_00015
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntryImm msg_0522_T10R0101_00020, 0
    AddMenuEntryImm msg_0522_T10R0101_00021, 1
    AddMenuEntryImm msg_0522_T10R0101_00022, 2
    AddMenuEntryImm msg_0522_T10R0101_00023, 3
    AddMenuEntryImm msg_0522_T10R0101_00024, 4
    AddMenuEntryImm msg_0522_T10R0101_00025, 5
    AddMenuEntryImm msg_0522_T10R0101_00026, 6
    ShowMenu
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0505
    CloseMessage
    @ HGSS: ViewRankings RANKINGS_SCOPE_GLOBAL, RANKINGS_PAGE_BATTLE_TOWER, VAR_SPECIAL_RESULT
    Message msg_0522_T10R0101_00007
    GoTo _02CD
_058C:
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
