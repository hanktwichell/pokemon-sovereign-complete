#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0062.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D22R0101_counterm 20
#define obj_D22R0101_gsmiddleman1_3 26
#define obj_D22R0101_gsmiddleman1_4 27

    ScriptEntry scr_seq_D22R0101_000
    ScriptEntry scr_seq_D22R0101_001
    ScriptEntry scr_seq_D22R0101_002
    ScriptEntry scr_seq_D22R0101_003
    ScriptEntry scr_seq_D22R0101_004
    ScriptEntry scr_seq_D22R0101_005
    ScriptEntry scr_seq_D22R0101_006
    ScriptEntry scr_seq_D22R0101_007
    ScriptEntry scr_seq_D22R0101_008
    ScriptEntry scr_seq_D22R0101_009
    ScriptEntry scr_seq_D22R0101_010
    ScriptEntry scr_seq_D22R0101_011
    ScriptEntry scr_seq_D22R0101_012
    ScriptEntry scr_seq_D22R0101_013
    ScriptEntry scr_seq_D22R0101_014
    ScriptEntry scr_seq_D22R0101_015
    ScriptEntry scr_seq_D22R0101_016
    ScriptEntry scr_seq_D22R0101_017
    ScriptEntry scr_seq_D22R0101_018
    ScriptEntry scr_seq_D22R0101_019
    ScriptEntry scr_seq_D22R0101_020
    ScriptEntry scr_seq_D22R0101_021
    ScriptEntry scr_seq_D22R0101_022
    ScriptEntry scr_seq_D22R0101_023
    ScriptEntry scr_seq_D22R0101_024
    ScriptEntry scr_seq_D22R0101_025
    ScriptEntry scr_seq_D22R0101_026
    ScriptEntry scr_seq_D22R0101_027
    ScriptEntry scr_seq_D22R0101_028
    ScriptEntry scr_seq_D22R0101_029
    ScriptEntryEnd
scr_seq_D22R0101_011:
    CompareVar VAR_HGSS_UNK_40F7, 1
    CallIf 1, _03EA
    End
scr_seq_D22R0101_025:
    GoToIfUnset FLAG_HGSS_UNK_189, _0450
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_D22R0101_012:
    NPCMessage msg_0062_D22R0101_00045
    End
scr_seq_D22R0101_013:
    NPCMessage msg_0062_D22R0101_00048
    End
scr_seq_D22R0101_014:
    NPCMessage msg_0062_D22R0101_00051
    End
scr_seq_D22R0101_015:
    NPCMessage msg_0062_D22R0101_00054
    End
scr_seq_D22R0101_016:
    NPCMessage msg_0062_D22R0101_00057
    End
scr_seq_D22R0101_017:
    NPCMessage msg_0062_D22R0101_00060
    End
scr_seq_D22R0101_018:
    NPCMessage msg_0062_D22R0101_00063
    End
scr_seq_D22R0101_019:
    NPCMessage msg_0062_D22R0101_00066
    End
scr_seq_D22R0101_020:
    NPCMessage msg_0062_D22R0101_00069
    End
scr_seq_D22R0101_021:
    NPCMessage msg_0062_D22R0101_00072
    End
scr_seq_D22R0101_022:
    NPCMessage msg_0062_D22R0101_00042
    End
scr_seq_D22R0101_026:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _04B0
    BufferPlayerName 0
    Message msg_0062_D22R0101_00084
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_QUICK_CLAW_FROM_NATIONAL_PARK_WOMAN, _0514
    Message msg_0062_D22R0101_00002
    SetVar VAR_0x8004, ITEM_QUICK_CLAW
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _051F
    Common_GiveItemQuantity
    SetFlag FLAG_HGSS_GOT_QUICK_CLAW_FROM_NATIONAL_PARK_WOMAN
    Message msg_0062_D22R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0101_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0529
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _053D
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0551
    ApplyMovement LOCALID_PLAYER, _0BC2
    ApplyMovement obj_D22R0101_gsmiddleman1_3, _0BD8
    GoTo _056C
scr_seq_D22R0101_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0529
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _053D
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05CD
    ApplyMovement LOCALID_PLAYER, _0BC2
    ApplyMovement obj_D22R0101_gsmiddleman1_4, _0BD8
    GoTo _05E8
scr_seq_D22R0101_001:
    DrawSignpostTextBox SIGNPOST_TYPE_LANDMARK
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0062_D22R0101_00022, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0101_002:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0062_D22R0101_00023, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0101_003:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0062_D22R0101_00024, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D22R0101_004:
    NPCMessage msg_0062_D22R0101_00000
    End
scr_seq_D22R0101_005:
    NPCMessage msg_0062_D22R0101_00001
    End
scr_seq_D22R0101_006:
    NPCMessage msg_0062_D22R0101_00005
    End
scr_seq_D22R0101_007:
    NPCMessage msg_0062_D22R0101_00006
    End
scr_seq_D22R0101_008:
    NPCMessage msg_0062_D22R0101_00009
    End
scr_seq_D22R0101_009:
    NPCMessage msg_0062_D22R0101_00007
    End
scr_seq_D22R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0062_D22R0101_00008
    PlayCry SPECIES_PERSIAN, 0
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D22R0101_027:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    PlayCry SPECIES_SHAYMIN, 0
    Message msg_0062_D22R0101_00090
    WaitCry
    WaitButton
    CloseMessage
    CheckItem ITEM_AZURE_FLUTE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0649
    ReleaseAll
    End
scr_seq_D22R0101_028:
    SetFlag FLAG_HGSS_SG_3FBE
    End
scr_seq_D22R0101_029:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0062_D22R0101_00096
    WaitButton
    CloseMessage
    GoToIfSet FLAG_HGSS_HIDE_OLIVINE_PORT_OAK, _0724
    ReleaseAll
    End
_03EA:
    SetPosition obj_D22R0101_counterm, 51, 0, 48, DIR_SOUTH
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 10
    SetVarFromValue VAR_MAP_LOCAL_0x02, 48
    @ HGSS: IsBugContestantRegistered VAR_TEMP_x4000, VAR_TEMP_x4004
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 5, _07B3
    SetPosition VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x02, 0, 50, DIR_NORTH
    AddVar VAR_MAP_LOCAL_0x02, 2
    AddVar VAR_MAP_LOCAL_0x00, 1
    AddVar VAR_MAP_LOCAL_0x01, 1
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 0, _07D2
    Return
_0450:
    CompareVar VAR_HGSS_UNK_40F7, 1
    GoToIf 1, _0816
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0833
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0833
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 1, _0816
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 1, _0816
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0816
    SetFlag FLAG_HGSS_HIDE_CAMERON
    ClearFlag FLAG_HGSS_UNK_27F
    GoTo _0841
_04B0:
    BufferPlayerName 0
    Message msg_0062_D22R0101_00085
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0852
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _085D
    Message msg_0062_D22R0101_00086
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 7
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0062_D22R0101_00087
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0514:
    Message msg_0062_D22R0101_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_051F:
    Common_MessageBagIsFull
    CloseMessage
    ReleaseAll
    End
_0529:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_053D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0551:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0868
    ApplyMovement LOCALID_PLAYER, _0BE2
    GoTo _056C
_056C:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _088B
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0BEC
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 16
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
_05CD:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _08C5
    ApplyMovement LOCALID_PLAYER, _0BE2
    GoTo _05E8
_05E8:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _08E8
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0BEC
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 17
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
_0649:
    GoToIfSet FLAG_HGSS_SG_3FBE, _0922
    Message msg_0062_D22R0101_00091
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0922
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    BufferPlayerName 0
    Message msg_0062_D22R0101_00092
    CloseMessage
    FadeScreen 6, 4, 0, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement 29, _0BFA
    WaitMovement
    ApplyMovement 29, _0BFA
    WaitMovement
    ApplyMovement 29, _0BFA
    WaitMovement
    FadeScreen 6, 4, 1, COLOR_WHITE
    WaitFadeScreen
    Message msg_0062_D22R0101_00094
    CloseMessage
    FacePlayer
    PlayCry SPECIES_SHAYMIN, 0
    Message msg_0062_D22R0101_00093
    WaitCry
    CloseMessage
    CompleteStartWildBattle SPECIES_SHAYMIN, 45, 0
    LockAll
    SetFlag FLAG_HGSS_SG_3FBE
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0926
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 29
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _092C
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _092C
    ReleaseAll
    End
_0724:
    FacePlayer
    Message msg_0062_D22R0101_00097
    GetFirstNonEggInParty VAR_MAP_LOCAL_0x00
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompareVar VAR_MAP_LOCAL_0x01, 252
    GoToIf 1, _093B
    CompareVar VAR_MAP_LOCAL_0x01, 253
    GoToIf 1, _093B
    CompareVar VAR_MAP_LOCAL_0x01, 254
    GoToIf 1, _093B
    CompareVar VAR_MAP_LOCAL_0x01, 255
    GoToIf 1, _09A9
    CompareVar VAR_MAP_LOCAL_0x01, 256
    GoToIf 1, _09A9
    CompareVar VAR_MAP_LOCAL_0x01, 257
    GoToIf 1, _09A9
    CompareVar VAR_MAP_LOCAL_0x01, 258
    GoToIf 1, _0A17
    CompareVar VAR_MAP_LOCAL_0x01, 259
    GoToIf 1, _0A17
    CompareVar VAR_MAP_LOCAL_0x01, 260
    GoToIf 1, _0A17
    Message msg_0062_D22R0101_00098
    WaitButton
    CloseMessage
    ReleaseAll
    End
_07B3:
    AddVar VAR_MAP_LOCAL_0x00, 1
    AddVar VAR_MAP_LOCAL_0x01, 1
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 0, _07D2
    Return
_07D2:
    @ HGSS: IsBugContestantRegistered VAR_TEMP_x4000, VAR_TEMP_x4004
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 5, _07B3
    SetPosition VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x02, 0, 50, DIR_NORTH
    AddVar VAR_MAP_LOCAL_0x02, 2
    AddVar VAR_MAP_LOCAL_0x00, 1
    AddVar VAR_MAP_LOCAL_0x01, 1
    CompareVar VAR_MAP_LOCAL_0x00, 10
    GoToIf 0, _07D2
    Return
_0816:
    SetFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    ClearFlag FLAG_HGSS_UNK_996
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0A85
    SetFlag FLAG_HGSS_UNK_288
    End
_0833:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    SetFlag FLAG_HGSS_UNK_27F
    GoTo _0841
_0841:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _0A85
    SetFlag FLAG_HGSS_UNK_288
    End
_0852:
    Message msg_0062_D22R0101_00088
    WaitButton
    CloseMessage
    ReleaseAll
    End
_085D:
    Message msg_0062_D22R0101_00089
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0868:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0AC9
    ApplyMovement LOCALID_PLAYER, _0C5C
    ApplyMovement obj_D22R0101_gsmiddleman1_3, _0BD8
    GoTo _056C
_088B:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 16
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
_08C5:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0B3A
    ApplyMovement LOCALID_PLAYER, _0C6E
    ApplyMovement obj_D22R0101_gsmiddleman1_4, _0BD8
    GoTo _05E8
_08E8:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 17
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
_0922:
    ReleaseAll
    End
_0926:
    BlackOutFromBattle
    ReleaseAll
    End
_092C:
    Message msg_0062_D22R0101_00095
    ClearFlag FLAG_HGSS_SG_3FBE
    WaitButton
    CloseMessage
    ReleaseAll
    End
_093B:
    Message msg_0062_D22R0101_00099
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0BAB
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0BAB
    GivePokemon SPECIES_TORCHIC, 10, 155, VAR_RESULT
    GivePokemon SPECIES_MUDKIP, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0062_D22R0101_00101
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0062_D22R0101_00102
    WaitButton
    CloseMessage
    FadeScreen 6, 2, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 30
    FadeScreen 6, 2, 1, COLOR_BLACK
    ReleaseAll
    End
_09A9:
    Message msg_0062_D22R0101_00099
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0BAB
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0BAB
    GivePokemon SPECIES_TREECKO, 10, 155, VAR_RESULT
    GivePokemon SPECIES_MUDKIP, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0062_D22R0101_00103
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0062_D22R0101_00102
    WaitButton
    CloseMessage
    FadeScreen 6, 2, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 30
    FadeScreen 6, 2, 1, COLOR_BLACK
    ReleaseAll
    End
_0A17:
    Message msg_0062_D22R0101_00099
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 5
    GoToIf 1, _0BAB
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0BAB
    GivePokemon SPECIES_TREECKO, 10, 155, VAR_RESULT
    GivePokemon SPECIES_TORCHIC, 10, 155, VAR_RESULT
    BufferPlayerName 0
    Message msg_0062_D22R0101_00104
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    Message msg_0062_D22R0101_00102
    WaitButton
    CloseMessage
    FadeScreen 6, 2, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 30
    FadeScreen 6, 2, 1, COLOR_BLACK
    ReleaseAll
    End
_0A85:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BUGSY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0BB6
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0BBC
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _0BBC
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _0BBC
    SetFlag FLAG_HGSS_UNK_288
    End
_0AC9:
    ApplyMovement LOCALID_PLAYER, _0C88
    ApplyMovement obj_D22R0101_gsmiddleman1_3, _0BD8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _088B
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0BEC
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 16
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
_0B3A:
    ApplyMovement LOCALID_PLAYER, _0C88
    ApplyMovement obj_D22R0101_gsmiddleman1_4, _0BD8
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _08E8
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0BEC
    WaitMovement
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 17
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
_0BAB:
    Message msg_0062_D22R0101_00100
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0BB6:
    SetFlag FLAG_HGSS_UNK_288
    End
_0BBC:
    ClearFlag FLAG_HGSS_UNK_288
    End
    .balign 4, 0
_0BC2:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0BD8:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0BE2:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0BEC:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0BFA:
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    FaceNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0C5C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C6E:
    WalkNormalSouth
    WalkNormalEast 2
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 2
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0C88:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
