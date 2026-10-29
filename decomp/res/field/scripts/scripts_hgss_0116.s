#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0133.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D47_gsmiddleman1 12

    ScriptEntry scr_seq_D47_000
    ScriptEntry scr_seq_D47_001
    ScriptEntry scr_seq_D47_002
    ScriptEntry scr_seq_D47_003
    ScriptEntry scr_seq_D47_004
    ScriptEntry scr_seq_D47_005
    ScriptEntry scr_seq_D47_006
    ScriptEntry scr_seq_D47_007
    ScriptEntry scr_seq_D47_008
    ScriptEntry scr_seq_D47_009
    ScriptEntry scr_seq_D47_010
    ScriptEntry scr_seq_D47_011
    ScriptEntry scr_seq_D47_012
    ScriptEntry scr_seq_D47_013
    ScriptEntry scr_seq_D47_014
    ScriptEntry scr_seq_D47_015
    ScriptEntry scr_seq_D47_016
    ScriptEntry scr_seq_D47_017
    ScriptEntry scr_seq_D47_018
    ScriptEntry scr_seq_D47_019
    ScriptEntry scr_seq_D47_020
    ScriptEntry scr_seq_D47_021
    ScriptEntryEnd
scr_seq_D47_014:
    GoToIfUnset FLAG_HGSS_UNK_189, _0353
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D47_000:
    NPCMessage msg_0133_D47_00002
    End
scr_seq_D47_001:
    NPCMessage msg_0133_D47_00003
    End
scr_seq_D47_002:
    NPCMessage msg_0133_D47_00004
    End
scr_seq_D47_003:
    NPCMessage msg_0133_D47_00005
    End
scr_seq_D47_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_JIGGLYPUFF, 0
    Message msg_0133_D47_00006
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0377
    Message msg_0133_D47_00007
    GoTo _0399
scr_seq_D47_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0133_D47_00009
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 6
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_D47_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0133_D47_00010
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 1
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_D47_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_BEAUTIFLY, 0
    Message msg_0133_D47_00011
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_009:
    NPCMessage msg_0133_D47_00012
    End
scr_seq_D47_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_SLOWPOKE, 0
    Message msg_0133_D47_00013
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_011:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0133_D47_00017, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D47_012:
    NPCMessage msg_0133_D47_00014
    End
scr_seq_D47_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03B8
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _03CC
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _03E0
    ApplyMovement LOCALID_PLAYER, _055C
    ApplyMovement obj_D47_gsmiddleman1, _0572
    GoTo _03FB
scr_seq_D47_015:
    NPCMessage msg_0133_D47_00015
    End
scr_seq_D47_016:
    NPCMessage msg_0133_D47_00016
    End
scr_seq_D47_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0133_D47_00018
    SetFlag FLAG_HGSS_SG_3FFF
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_018:
    NPCMessage msg_0133_D47_00022
    End
scr_seq_D47_019:
    NPCMessage msg_0133_D47_00019
    End
scr_seq_D47_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    Message msg_0133_D47_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D47_021:
    ApplyMovement 17, _057C
    ApplyMovement 18, _057C
    ApplyMovement LOCALID_PLAYER, _0582
    ApplyMovement 19, _0582
    WaitMovement
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0133_D47_00021
    CloseMessage
    StartTagBattle TRAINER_HGSS_BIKER_MICKEY_2, TRAINER_HGSS_SWIMMER_M_MICKEY_3, TRAINER_HGSS_SWIMMER_M_MICKEY_2
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _045C
    Message msg_0133_D47_00023
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_SG_6130, 2
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 17
    RemoveObject 18
    SetFlag FLAG_HGSS_SG_3FDF
    SetFlag FLAG_HGSS_SG_3FE8
    ClearFlag FLAG_HGSS_SG_3FE7
    FadeScreen 8, 1, 1, COLOR_BLACK
    ApplyMovement 19, _0588
    ApplyMovement LOCALID_PLAYER, _058E
    WaitMovement
    Message msg_0133_D47_00024
    GoToIfSet FLAG_HGSS_GOT_EEVEE_FROM_BILL, _0462
    Message msg_0133_D47_00025
    Message msg_0133_D47_00027
    WaitButton
    CloseMessage
    ApplyMovement 19, _0594
    WaitMovement
    RemoveObject 19
    ReleaseAll
    End
_0353:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _047E
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _047E
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0377:
    Message msg_0133_D47_00008
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0484
    AddVar VAR_MAP_LOCAL_0x0B, 1
    GoTo _048C
_0399:
    WaitButton
    CloseMessage
    ReleaseAll
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0484
    AddVar VAR_MAP_LOCAL_0x0B, 1
    GoTo _048C
_03B8:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03CC:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_03E0:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _048E
    ApplyMovement LOCALID_PLAYER, _059A
    GoTo _03FB
_03FB:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04B1
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05A4
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 38
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
_045C:
    BlackOutFromBattle
    ReleaseAll
    End
_0462:
    Message msg_0133_D47_00026
    Message msg_0133_D47_00027
    WaitButton
    CloseMessage
    ApplyMovement 19, _0594
    WaitMovement
    RemoveObject 19
    ReleaseAll
    End
_047E:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
_0484:
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
    End
_048C:
    End
_048E:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _04EB
    ApplyMovement LOCALID_PLAYER, _05B2
    ApplyMovement obj_D47_gsmiddleman1, _0572
    GoTo _03FB
_04B1:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 38
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
_04EB:
    ApplyMovement LOCALID_PLAYER, _05C4
    ApplyMovement obj_D47_gsmiddleman1, _0572
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _04B1
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _05A4
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 38
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
    .balign 4, 0
_055C:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0572:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_057C:
    FaceSouth
    EndMovement
    .balign 4, 0
_0582:
    FaceNorth
    EndMovement
    .balign 4, 0
_0588:
    FaceWest
    EndMovement
    .balign 4, 0
_058E:
    FaceEast
    EndMovement
    .balign 4, 0
_0594:
    WalkNormalSouth 11
    EndMovement
    .balign 4, 0
_059A:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05A4:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_05B2:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_05C4:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
