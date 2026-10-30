#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0549.h"


    ScriptEntry scr_seq_T20R0402_000
    ScriptEntry scr_seq_T20R0402_001
    ScriptEntry scr_seq_T20R0402_002
    ScriptEntry scr_seq_T20R0402_003
    ScriptEntry scr_seq_T20R0402_004
    ScriptEntry scr_seq_T20R0402_005
    ScriptEntryEnd
scr_seq_T20R0402_002:
    GoToIfSet FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND, _00BC
    @ HGSS: GetFriendSprite VAR_OBJ_0
    End
scr_seq_T20R0402_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompleteCheckBadge BADGE_ID_HGSS_ZEPHYR, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00BE
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_GOT_STARTER, _0102
    MessageGendered msg_0549_T20R0402_00000, msg_0549_T20R0402_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0402_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0549_T20R0402_00004
    PlayCry SPECIES_MARILL, 0
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0402_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0549_T20R0402_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0402_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0549_T20R0402_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0402_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_AZUMARILL, 0
    Message msg_0549_T20R0402_00021
    WaitCry
    MessageGendered msg_0549_T20R0402_00019, msg_0549_T20R0402_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00BC:
    End
_00BE:
    GetFirstNonEggInParty VAR_0x8006
    @ HGSS: GetShinyLeafCount VAR_SPECIAL_x8006, VAR_SPECIAL_RESULT
    GoToIfSet FLAG_HGSS_SHOWED_FRIEND_A_SHINY_LEAF, _0113
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0146
    BufferPlayerName 0
    MessageGendered msg_0549_T20R0402_00005, msg_0549_T20R0402_00006
    WaitButton
    CompleteCheckBadge BADGE_ID_HGSS_EARTH, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0159
    CloseMessage
    ReleaseAll
    End
_0102:
    BufferPartyMonSpecies 1, VAR_RESULT
    MessageGendered msg_0549_T20R0402_00002, msg_0549_T20R0402_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0113:
    SetVarFromVar VAR_0x8004, VAR_RESULT
    CompareVar VAR_0x8004, 6
    GoToIf 1, _01AE
    CompareVar VAR_0x8004, 5
    GoToIf 1, _01C6
    CompareVar VAR_0x8004, 1
    GoToIf 4, _0201
    GoTo _021A
_0146:
    SetFlag FLAG_HGSS_SHOWED_FRIEND_A_SHINY_LEAF
    BufferPlayerName 0
    MessageGendered msg_0549_T20R0402_00007, msg_0549_T20R0402_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0159:
    Message msg_0549_T20R0402_00022
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0229
    MessageGendered msg_0549_T20R0402_00024, msg_0549_T20R0402_00023
    CloseMessage
    GetPlayerGender VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0234
    StartTrainerBattle TRAINER_HGSS_TWINS_MICKEY, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025A
    LockAll
    Message msg_0549_T20R0402_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01AE:
    BufferPlayerName 0
    @ HGSS: GetFollowPokePartyIndex VAR_SPECIAL_RESULT
    BufferPartyMonNickname 1, VAR_RESULT
    MessageGendered msg_0549_T20R0402_00015, msg_0549_T20R0402_00016
    CloseMessage
    GoTo _0260
_01C6:
    @ HGSS: TryGiveShinyLeafCrown VAR_SPECIAL_x8006
    SetFlag FLAG_HGSS_UNK_184
    BufferPlayerName 0
    MessageGendered msg_0549_T20R0402_00011, msg_0549_T20R0402_00012
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ShowCertificate 2
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    MessageGendered msg_0549_T20R0402_00013, msg_0549_T20R0402_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0201:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _028A
    SetVarFromValue VAR_0x8005, 4
    GoTo _02A3
_021A:
    BufferPlayerName 0
    MessageGendered msg_0549_T20R0402_00005, msg_0549_T20R0402_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0229:
    Message msg_0549_T20R0402_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0234:
    StartTrainerBattle TRAINER_HGSS_BUG_CATCHER_MICKEY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _025A
    LockAll
    Message msg_0549_T20R0402_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
_025A:
    BlackOutFromBattle
    ReleaseAll
    End
_0260:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ShowCertificate 2
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    MessageGendered msg_0549_T20R0402_00013, msg_0549_T20R0402_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_028A:
    CompareVar VAR_0x8004, 2
    GoToIf 5, _02BC
    SetVarFromValue VAR_0x8005, 3
    GoTo _02A3
_02A3:
    BufferPlayerName 0
    BufferNumber 1, VAR_0x8004
    BufferNumber 2, VAR_0x8005
    MessageGendered msg_0549_T20R0402_00009, msg_0549_T20R0402_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02BC:
    CompareVar VAR_0x8004, 3
    GoToIf 5, _02D5
    SetVarFromValue VAR_0x8005, 2
    GoTo _02A3
_02D5:
    SetVarFromValue VAR_0x8005, 1
    BufferPlayerName 0
    BufferNumber 1, VAR_0x8004
    BufferNumber 2, VAR_0x8005
    MessageGendered msg_0549_T20R0402_00009, msg_0549_T20R0402_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
