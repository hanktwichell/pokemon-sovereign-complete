#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0533.h"

#define obj_T11R0101_gsleader3 1
#define obj_T11R0101_gsleader13 2
#define obj_T11R0101_gsleader8 3
#define obj_T11R0101_gsleader12 4
#define obj_T11R0101_gsleader11 5
#define obj_T11R0101_gsleader16 6
#define obj_T11R0101_gsleader5 7
#define obj_T11R0101_gsleader14 8
#define obj_T11R0101_gsleader2 9
#define obj_T11R0101_gsleader10 10
#define obj_T11R0101_gsleader1 11
#define obj_T11R0101_gsleader9 12
#define obj_T11R0101_gsleader4 13
#define obj_T11R0101_gsleader6 14
#define obj_T11R0101_gsleader7 15
#define obj_T11R0101_gsleader15 16

    ScriptEntry scr_seq_T11R0101_000
    ScriptEntry scr_seq_T11R0101_001
    ScriptEntry scr_seq_T11R0101_002
    ScriptEntry scr_seq_T11R0101_003
    ScriptEntry scr_seq_T11R0101_004
    ScriptEntry scr_seq_T11R0101_005
    ScriptEntry scr_seq_T11R0101_006
    ScriptEntry scr_seq_T11R0101_007
    ScriptEntry scr_seq_T11R0101_008
    ScriptEntry scr_seq_T11R0101_009
    ScriptEntry scr_seq_T11R0101_010
    ScriptEntry scr_seq_T11R0101_011
    ScriptEntry scr_seq_T11R0101_012
    ScriptEntry scr_seq_T11R0101_013
    ScriptEntry scr_seq_T11R0101_014
    ScriptEntry scr_seq_T11R0101_015
    ScriptEntry scr_seq_T11R0101_016
    ScriptEntry scr_seq_T11R0101_017
    ScriptEntry scr_seq_T11R0101_018
    ScriptEntry scr_seq_T11R0101_019
    ScriptEntry scr_seq_T11R0101_020
    ScriptEntryEnd
scr_seq_T11R0101_003:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_WHITNEY, VAR_TEMP_x4000
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JANINE, VAR_TEMP_x4001
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_CLAIR, VAR_TEMP_x4002
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_ERIKA, VAR_TEMP_x4003
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MISTY, VAR_TEMP_x4004
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BLAINE, VAR_TEMP_x4005
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BLUE, VAR_TEMP_x4006
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_CHUCK, VAR_TEMP_x4007
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BROCK, VAR_TEMP_x4008
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_BUGSY, VAR_TEMP_x4009
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_SABRINA, VAR_TEMP_x400A
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_FALKNER, VAR_TEMP_x400B
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_LT__SURGE, VAR_TEMP_x400C
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_MORTY, VAR_TEMP_x400D
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_JASMINE, VAR_TEMP_x400E
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_PRYCE, VAR_TEMP_x400F
    CompareVar VAR_MAP_LOCAL_0x03, 0
    GoToIf 5, _0958
    SetFlag FLAG_HGSS_UNK_2B8
    GoTo _0973
scr_seq_T11R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00008
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_WHITNEY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _098A
    Message msg_0533_T11R0101_00009
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 17
    SetFlag FLAG_HGSS_UNK_2B5
    RemoveObject obj_T11R0101_gsleader3
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00030
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_JANINE_JANINE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0990
    Message msg_0533_T11R0101_00031
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 26
    SetFlag FLAG_HGSS_UNK_2B6
    RemoveObject obj_T11R0101_gsleader13
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00018
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_CLAIR_CLAIR_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0996
    Message msg_0533_T11R0101_00019
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 27
    SetFlag FLAG_HGSS_UNK_2B7
    RemoveObject obj_T11R0101_gsleader8
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00024
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_ERIKA_ERIKA_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _099C
    Message msg_0533_T11R0101_00025
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 28
    SetFlag FLAG_HGSS_UNK_2B8
    RemoveObject obj_T11R0101_gsleader12
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00026
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_MISTY_MISTY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09A2
    Message msg_0533_T11R0101_00027
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 29
    SetFlag FLAG_HGSS_UNK_2B9
    RemoveObject obj_T11R0101_gsleader11
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00032
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BLAINE_BLAINE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09A8
    Message msg_0533_T11R0101_00033
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 30
    SetFlag FLAG_HGSS_UNK_2BA
    RemoveObject obj_T11R0101_gsleader15
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00034
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BLUE_BLUE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09AE
    Message msg_0533_T11R0101_00035
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 31
    SetFlag FLAG_HGSS_UNK_2BB
    RemoveObject obj_T11R0101_gsleader16
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00010
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_CHUCK_CHUCK_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09B4
    Message msg_0533_T11R0101_00011
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 32
    SetFlag FLAG_HGSS_UNK_2BC
    RemoveObject obj_T11R0101_gsleader5
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00028
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BROCK_BROCK_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09BA
    Message msg_0533_T11R0101_00029
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 33
    SetFlag FLAG_HGSS_UNK_2BD
    RemoveObject obj_T11R0101_gsleader14
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00006
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_BUGSY_BUGSY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09C0
    Message msg_0533_T11R0101_00007
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 34
    SetFlag FLAG_HGSS_UNK_2BE
    RemoveObject obj_T11R0101_gsleader2
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00022
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_SABRINA_SABRINA_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09C6
    Message msg_0533_T11R0101_00023
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 35
    SetFlag FLAG_HGSS_UNK_2BF
    RemoveObject obj_T11R0101_gsleader10
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00004
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_FALKNER_FALKNER_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09CC
    Message msg_0533_T11R0101_00005
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 18
    SetFlag FLAG_HGSS_UNK_2C0
    RemoveObject obj_T11R0101_gsleader1
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00020
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_LT_SURGE_LT__SURGE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09D2
    Message msg_0533_T11R0101_00021
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 36
    SetFlag FLAG_HGSS_UNK_2C1
    RemoveObject obj_T11R0101_gsleader9
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00014
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_MORTY_MORTY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09D8
    Message msg_0533_T11R0101_00015
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 37
    SetFlag FLAG_HGSS_UNK_2C2
    RemoveObject obj_T11R0101_gsleader4
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00012
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_JASMINE_JASMINE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09DE
    Message msg_0533_T11R0101_00013
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 38
    SetFlag FLAG_HGSS_UNK_2C3
    RemoveObject obj_T11R0101_gsleader6
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00016
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_PRYCE_PRYCE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _09E4
    Message msg_0533_T11R0101_00017
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_462 39
    SetFlag FLAG_HGSS_UNK_2C4
    RemoveObject obj_T11R0101_gsleader7
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_T11R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_KARATE_KING, _09EA
    Message msg_0533_T11R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T11R0101_001:
    NPCMessage msg_0533_T11R0101_00002
    End
scr_seq_T11R0101_002:
    NPCMessage msg_0533_T11R0101_00003
    End
scr_seq_T11R0101_020:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00036
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0A57
    Message msg_0533_T11R0101_00037
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_LEADER_FALKNER_FALKNER_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_JANINE_JANINE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_BUGSY_BUGSY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_BROCK_BROCK_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_MISTY_MISTY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_MICKEY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_WHITNEY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    StartTrainerBattle TRAINER_HGSS_LEADER_MORTY_MORTY_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_LT_SURGE_LT__SURGE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_MICKEY_3, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_CHUCK_CHUCK_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_ERIKA_ERIKA_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_SABRINA_SABRINA_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    StartTrainerBattle TRAINER_HGSS_LEADER_JASMINE_JASMINE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_MICKEY_4, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_PRYCE_PRYCE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_BLAINE_BLAINE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_LEADER_CLAIR_CLAIR_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    SetVarFromVar VAR_RESULT, VAR_HGSS_PLAYER_STARTER
    CompareVar VAR_RESULT, 152
    GoToIf 1, _0A6D
    CompareVar VAR_RESULT, 155
    GoToIf 1, _0A8C
    GoTo _0AAB
_0958:
    ClearFlag FLAG_HGSS_UNK_2B8
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0ACA
    SetFlag FLAG_HGSS_UNK_2B5
    GoTo _0AE5
_0973:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _0ACA
    SetFlag FLAG_HGSS_UNK_2B5
    GoTo _0AE5
_098A:
    BlackOutFromBattle
    ReleaseAll
    End
_0990:
    BlackOutFromBattle
    ReleaseAll
    End
_0996:
    BlackOutFromBattle
    ReleaseAll
    End
_099C:
    BlackOutFromBattle
    ReleaseAll
    End
_09A2:
    BlackOutFromBattle
    ReleaseAll
    End
_09A8:
    BlackOutFromBattle
    ReleaseAll
    End
_09AE:
    BlackOutFromBattle
    ReleaseAll
    End
_09B4:
    BlackOutFromBattle
    ReleaseAll
    End
_09BA:
    BlackOutFromBattle
    ReleaseAll
    End
_09C0:
    BlackOutFromBattle
    ReleaseAll
    End
_09C6:
    BlackOutFromBattle
    ReleaseAll
    End
_09CC:
    BlackOutFromBattle
    ReleaseAll
    End
_09D2:
    BlackOutFromBattle
    ReleaseAll
    End
_09D8:
    BlackOutFromBattle
    ReleaseAll
    End
_09DE:
    BlackOutFromBattle
    ReleaseAll
    End
_09E4:
    BlackOutFromBattle
    ReleaseAll
    End
_09EA:
    Message msg_0533_T11R0101_00001
    CloseMessage
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: RegisterGearNumber PHONE_CONTACT_WHITNEY
    @ HGSS: RegisterGearNumber PHONE_CONTACT_JANINE
    @ HGSS: RegisterGearNumber PHONE_CONTACT_CLAIR
    @ HGSS: RegisterGearNumber PHONE_CONTACT_ERIKA
    @ HGSS: RegisterGearNumber PHONE_CONTACT_MISTY
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BLAINE
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BLUE
    @ HGSS: RegisterGearNumber PHONE_CONTACT_CHUCK
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BROCK
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BUGSY
    @ HGSS: RegisterGearNumber PHONE_CONTACT_SABRINA
    @ HGSS: RegisterGearNumber PHONE_CONTACT_FALKNER
    @ HGSS: RegisterGearNumber PHONE_CONTACT_LT__SURGE
    @ HGSS: RegisterGearNumber PHONE_CONTACT_MORTY
    @ HGSS: RegisterGearNumber PHONE_CONTACT_JASMINE
    @ HGSS: RegisterGearNumber PHONE_CONTACT_PRYCE
    ReleaseAll
    End
_0A57:
    Message msg_0533_T11R0101_00039
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0A62:
    Message msg_0533_T11R0101_00038
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0A6D:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_20, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    GoTo _0AFC
_0A8C:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_21, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    GoTo _0AFC
_0AAB:
    StartTrainerBattle TRAINER_HGSS_RIVAL_SILVER_19, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    GoTo _0AFC
_0ACA:
    ClearFlag FLAG_HGSS_UNK_2B5
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0C4D
    SetFlag FLAG_HGSS_UNK_2B6
    GoTo _0C68
_0AE5:
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0C4D
    SetFlag FLAG_HGSS_UNK_2B6
    GoTo _0C68
_0AFC:
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_MICKEY_5, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_WILL_WILL_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_KOGA_KOGA_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_BRUNO_BRUNO_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_ELITE_FOUR_KAREN_KAREN_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_SUPER_NERD_MICKEY_6, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    StartTrainerBattle TRAINER_HGSS_LEADER_BLUE_BLUE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    StartTrainerBattle TRAINER_HGSS_CHAMPION_LANCE_2, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    PlayFanfare SEQ_ME_ASA_sseq
    WaitFanfare
    HealParty
    @ HGSS: ScrCmd_436
    ReturnToField
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    StartTrainerBattle TRAINER_HGSS_PKMN_TRAINER_RED_RED, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A62
    ReleaseAll
    End
_0C4D:
    ClearFlag FLAG_HGSS_UNK_2B6
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0C7F
    SetFlag FLAG_HGSS_UNK_2B7
    GoTo _0C9A
_0C68:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _0C7F
    SetFlag FLAG_HGSS_UNK_2B7
    GoTo _0C9A
_0C7F:
    ClearFlag FLAG_HGSS_UNK_2B7
    CompareVar VAR_MAP_LOCAL_0x04, 0
    GoToIf 5, _0CB1
    SetFlag FLAG_HGSS_UNK_2B9
    GoTo _0CCC
_0C9A:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    GoToIf 5, _0CB1
    SetFlag FLAG_HGSS_UNK_2B9
    GoTo _0CCC
_0CB1:
    ClearFlag FLAG_HGSS_UNK_2B9
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0CE3
    SetFlag FLAG_HGSS_UNK_2BA
    GoTo _0CFE
_0CCC:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0CE3
    SetFlag FLAG_HGSS_UNK_2BA
    GoTo _0CFE
_0CE3:
    ClearFlag FLAG_HGSS_UNK_2BA
    CompareVar VAR_MAP_LOCAL_0x06, 0
    GoToIf 5, _0D15
    SetFlag FLAG_HGSS_UNK_2BB
    GoTo _0D30
_0CFE:
    CompareVar VAR_MAP_LOCAL_0x06, 0
    GoToIf 5, _0D15
    SetFlag FLAG_HGSS_UNK_2BB
    GoTo _0D30
_0D15:
    ClearFlag FLAG_HGSS_UNK_2BB
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _0D47
    SetFlag FLAG_HGSS_UNK_2BC
    GoTo _0D62
_0D30:
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _0D47
    SetFlag FLAG_HGSS_UNK_2BC
    GoTo _0D62
_0D47:
    ClearFlag FLAG_HGSS_UNK_2BC
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _0D79
    SetFlag FLAG_HGSS_UNK_2BD
    GoTo _0D94
_0D62:
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _0D79
    SetFlag FLAG_HGSS_UNK_2BD
    GoTo _0D94
_0D79:
    ClearFlag FLAG_HGSS_UNK_2BD
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 5, _0DAB
    SetFlag FLAG_HGSS_UNK_2BE
    GoTo _0DC6
_0D94:
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 5, _0DAB
    SetFlag FLAG_HGSS_UNK_2BE
    GoTo _0DC6
_0DAB:
    ClearFlag FLAG_HGSS_UNK_2BE
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _0DDD
    SetFlag FLAG_HGSS_UNK_2BF
    GoTo _0DF8
_0DC6:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _0DDD
    SetFlag FLAG_HGSS_UNK_2BF
    GoTo _0DF8
_0DDD:
    ClearFlag FLAG_HGSS_UNK_2BF
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0E0F
    SetFlag FLAG_HGSS_UNK_2C0
    GoTo _0E2A
_0DF8:
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _0E0F
    SetFlag FLAG_HGSS_UNK_2C0
    GoTo _0E2A
_0E0F:
    ClearFlag FLAG_HGSS_UNK_2C0
    CompareVar VAR_MAP_LOCAL_0x0C, 0
    GoToIf 5, _0E41
    SetFlag FLAG_HGSS_UNK_2C1
    GoTo _0E5C
_0E2A:
    CompareVar VAR_MAP_LOCAL_0x0C, 0
    GoToIf 5, _0E41
    SetFlag FLAG_HGSS_UNK_2C1
    GoTo _0E5C
_0E41:
    ClearFlag FLAG_HGSS_UNK_2C1
    CompareVar VAR_MAP_LOCAL_0x0D, 0
    GoToIf 5, _0E73
    SetFlag FLAG_HGSS_UNK_2C2
    GoTo _0E8E
_0E5C:
    CompareVar VAR_MAP_LOCAL_0x0D, 0
    GoToIf 5, _0E73
    SetFlag FLAG_HGSS_UNK_2C2
    GoTo _0E8E
_0E73:
    ClearFlag FLAG_HGSS_UNK_2C2
    CompareVar VAR_MAP_LOCAL_0x0E, 0
    GoToIf 5, _0EA5
    SetFlag FLAG_HGSS_UNK_2C3
    GoTo _0EC0
_0E8E:
    CompareVar VAR_MAP_LOCAL_0x0E, 0
    GoToIf 5, _0EA5
    SetFlag FLAG_HGSS_UNK_2C3
    GoTo _0EC0
_0EA5:
    ClearFlag FLAG_HGSS_UNK_2C3
    CompareVar VAR_MAP_LOCAL_0x0F, 0
    GoToIf 5, _0ED7
    SetFlag FLAG_HGSS_UNK_2C4
    GoTo _0EDD
_0EC0:
    CompareVar VAR_MAP_LOCAL_0x0F, 0
    GoToIf 5, _0ED7
    SetFlag FLAG_HGSS_UNK_2C4
    GoTo _0EDD
_0ED7:
    ClearFlag FLAG_HGSS_UNK_2C4
    End
_0EDD:
    End
    .balign 4, 0
