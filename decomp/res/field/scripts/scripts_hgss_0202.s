#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0351.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_R14_gsmiddleman1_3 10
#define obj_R14_tsure_poke_static_suicune 11
#define obj_R14_minaki 12
#define obj_R14_gswoman1 17

    ScriptEntry scr_seq_R14_000
    ScriptEntry scr_seq_R14_001
    ScriptEntry scr_seq_R14_002
    ScriptEntry scr_seq_R14_003
    ScriptEntry scr_seq_R14_004
    ScriptEntry scr_seq_R14_005
    ScriptEntryEnd
scr_seq_R14_001:
    GoToIfUnset FLAG_HGSS_UNK_189, _002B
    ClearFlag FLAG_HGSS_UNK_189
    End
_002B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _004F
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _004F
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_004F:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_R14_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _017D
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0191
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00CE
    ApplyMovement LOCALID_PLAYER, _01A8
    ApplyMovement obj_R14_gsmiddleman1_3, _01F4
    GoTo _011C
_00CE:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _00E9
    ApplyMovement LOCALID_PLAYER, _01C0
    GoTo _011C
_00E9:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _010C
    ApplyMovement LOCALID_PLAYER, _01E0
    ApplyMovement obj_R14_gsmiddleman1_3, _01F4
    GoTo _011C
_010C:
    ApplyMovement LOCALID_PLAYER, _01CC
    ApplyMovement obj_R14_gsmiddleman1_3, _01F4
_011C:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0143
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0200
    WaitMovement
_0143:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 60
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_017D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0191:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01A8:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01C0:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01CC:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01E0:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_01F4:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0200:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_R14_002:
    LockAll
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_EUSINE
    AddObject obj_R14_minaki
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x00, 1358
    GoToIf 5, _024F
    ApplyMovement LOCALID_PLAYER, _0450
    WaitMovement
    GoTo _027C
    GoTo _0255
_024F:
    GoTo _0255
_0255:
    CompareVar VAR_MAP_LOCAL_0x01, 409
    GoToIf 5, _0272
    ApplyMovement LOCALID_PLAYER, _0450
    WaitMovement
    GoTo _027C
_0272:
    ApplyMovement LOCALID_PLAYER, _0450
    WaitMovement
_027C:
    PlayCry SPECIES_SUICUNE, 0
    ReleaseObject obj_R14_tsure_poke_static_suicune
    @ HGSS: ScrCmd_523 obj_R14_tsure_poke_static_suicune, 2, 90, 2, 0
    LockObject obj_R14_tsure_poke_static_suicune
    WaitCry
    CompareVar VAR_MAP_LOCAL_0x00, 1358
    GoToIf 5, _02B1
    GoTo _02D0
    GoTo _02D0
_02B1:
    CompareVar VAR_MAP_LOCAL_0x00, 1359
    GoToIf 5, _02CA
    GoTo _0382
    GoTo _02D0
_02CA:
    GoTo _03AD
_02D0:
    CompareVar VAR_MAP_LOCAL_0x01, 409
    GoToIf 5, _02EB
    ApplyMovement LOCALID_PLAYER, _04AC
    GoTo _037A
_02EB:
    CompareVar VAR_MAP_LOCAL_0x01, 410
    GoToIf 5, _0306
    ApplyMovement LOCALID_PLAYER, _04C0
    GoTo _037A
_0306:
    CompareVar VAR_MAP_LOCAL_0x01, 411
    GoToIf 5, _0321
    ApplyMovement LOCALID_PLAYER, _04D0
    GoTo _037A
_0321:
    CompareVar VAR_MAP_LOCAL_0x01, 412
    GoToIf 5, _033C
    ApplyMovement LOCALID_PLAYER, _04E0
    GoTo _037A
_033C:
    CompareVar VAR_MAP_LOCAL_0x01, 413
    GoToIf 5, _0357
    ApplyMovement LOCALID_PLAYER, _04E8
    GoTo _037A
_0357:
    CompareVar VAR_MAP_LOCAL_0x01, 414
    GoToIf 5, _0372
    ApplyMovement LOCALID_PLAYER, _04F8
    GoTo _037A
_0372:
    ApplyMovement LOCALID_PLAYER, _0508
_037A:
    WaitMovement
    GoTo _03D2
_0382:
    CompareVar VAR_MAP_LOCAL_0x01, 409
    GoToIf 5, _039D
    ApplyMovement LOCALID_PLAYER, _051C
    GoTo _03A5
_039D:
    ApplyMovement LOCALID_PLAYER, _0530
_03A5:
    WaitMovement
    GoTo _03D2
_03AD:
    CompareVar VAR_MAP_LOCAL_0x01, 409
    GoToIf 5, _03C8
    ApplyMovement LOCALID_PLAYER, _0544
    GoTo _03D0
_03C8:
    ApplyMovement LOCALID_PLAYER, _0550
_03D0:
    WaitMovement
_03D2:
    ApplyMovement obj_R14_tsure_poke_static_suicune, _0488
    ApplyMovement LOCALID_PLAYER, _055C
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement obj_R14_minaki, _057C
    ApplyMovement LOCALID_PLAYER, _056C
    WaitMovement
    BufferPlayerName 0
    Message msg_0351_R14_00006
    WaitButton
    CloseMessage
    Common_FadeToDefaultMusic
    RemoveObject obj_R14_tsure_poke_static_suicune
    SetFlag FLAG_HGSS_HIDE_ROUTE_14_SUICUNE
    SetFlag FLAG_HGSS_HIDE_ROUTE_14_EUSINE
    ClearFlag FLAG_HGSS_HIDE_ROUTE_14_EUSINE_2
    SetVarFromValue VAR_HGSS_UNK_4086, 0
    SetFlag FLAG_HGSS_UNK_14D
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0449
    ClearFlag FLAG_HGSS_HIDE_ROUTE_25_SUICUNE
    SetVarFromValue VAR_HGSS_SCENE_ROUTE_25, 1
_0449:
    ReleaseAll
    End
    .balign 4, 0
_0450:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
    Delay4
    FaceWest
    EndMovement
    .balign 4, 0
    Delay4
    FaceNorth
    EndMovement
    .balign 4, 0
    Delay4
    FaceSouth
    EndMovement
    .balign 4, 0
    JumpFartherEast
    FaceWest
    EndMovement
    .balign 4, 0
_0488:
    WalkFasterNorth 2
    JumpNearFastNorth
    JumpFarNorth
    WalkFasterNorth 2
    JumpNearFastNorth
    JumpFarNorth 2
    WalkFasterNorth 2
    JumpNearFastNorth
    EndMovement
    .balign 4, 0
_04AC:
    WalkNormalSouth
    WalkNormalEast 3
    WalkNormalSouth 2
    FaceEast
    EndMovement
    .balign 4, 0
_04C0:
    WalkNormalEast 3
    WalkNormalSouth 2
    FaceEast
    EndMovement
    .balign 4, 0
_04D0:
    WalkNormalEast 3
    WalkNormalSouth
    FaceEast
    EndMovement
    .balign 4, 0
_04E0:
    WalkNormalEast 3
    EndMovement
    .balign 4, 0
_04E8:
    WalkNormalEast 3
    WalkNormalNorth
    FaceEast
    EndMovement
    .balign 4, 0
_04F8:
    WalkNormalEast 3
    WalkNormalNorth 2
    FaceEast
    EndMovement
    .balign 4, 0
_0508:
    WalkNormalNorth
    WalkNormalEast 3
    WalkNormalNorth 2
    FaceEast
    EndMovement
    .balign 4, 0
_051C:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalSouth 2
    FaceEast
    EndMovement
    .balign 4, 0
_0530:
    WalkNormalNorth
    WalkNormalEast 2
    WalkNormalNorth 2
    FaceEast
    EndMovement
    .balign 4, 0
_0544:
    WalkNormalSouth 3
    FaceEast
    EndMovement
    .balign 4, 0
_0550:
    WalkNormalNorth 3
    FaceEast
    EndMovement
    .balign 4, 0
_055C:
    Delay8
    FaceNorth
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_056C:
    Delay16 5
    FaceWest
    EndMovement
    .balign 4, 0
    EndMovement
    .balign 4, 0
_057C:
    WalkFastNorth 11
    WalkNormalNorth 2
    WalkSlowerNorth
    Delay8 3
    WalkSlowSouth
    FaceEast
    EndMovement
scr_seq_R14_003:
    BufferPlayerName 0
    NPCMessage msg_0351_R14_00007
    End
scr_seq_R14_004:
    BufferPlayerName 0
    NPCMessage msg_0351_R14_00007
    End
scr_seq_R14_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_LUCKY_PUNCH_FROM_ROUTE_14_WOMAN, _0658
    Message msg_0351_R14_00000
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0602
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 113
    GoToIf 1, _060D
_0602:
    Message msg_0351_R14_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_060D:
    ApplyMovement obj_R14_gswoman1, _0698
    WaitMovement
    Message msg_0351_R14_00002
    SetVar VAR_0x8004, ITEM_LUCKY_PUNCH
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _064E
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_LUCKY_PUNCH_FROM_ROUTE_14_WOMAN
    Message msg_0351_R14_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_064E:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0658:
    CheckPlayerOnBike VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0680
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 113
    GoToIf 1, _068B
_0680:
    Message msg_0351_R14_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_068B:
    Message msg_0351_R14_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0698:
    EmoteExclamationMark
    Delay4
    EndMovement
    .balign 4, 0
