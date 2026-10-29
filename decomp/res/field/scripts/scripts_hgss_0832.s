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
    GoToIf 5, _00C9
    SetFlag FLAG_HGSS_UNK_2B8
    GoTo _00CD
_00C9:
    ClearFlag FLAG_HGSS_UNK_2B8
_00CD:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _00E4
    SetFlag FLAG_HGSS_UNK_2B5
    GoTo _00E8
_00E4:
    ClearFlag FLAG_HGSS_UNK_2B5
_00E8:
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00FF
    SetFlag FLAG_HGSS_UNK_2B6
    GoTo _0103
_00FF:
    ClearFlag FLAG_HGSS_UNK_2B6
_0103:
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _011A
    SetFlag FLAG_HGSS_UNK_2B7
    GoTo _011E
_011A:
    ClearFlag FLAG_HGSS_UNK_2B7
_011E:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    GoToIf 5, _0135
    SetFlag FLAG_HGSS_UNK_2B9
    GoTo _0139
_0135:
    ClearFlag FLAG_HGSS_UNK_2B9
_0139:
    CompareVar VAR_MAP_LOCAL_0x05, 0
    GoToIf 5, _0150
    SetFlag FLAG_HGSS_UNK_2BA
    GoTo _0154
_0150:
    ClearFlag FLAG_HGSS_UNK_2BA
_0154:
    CompareVar VAR_MAP_LOCAL_0x06, 0
    GoToIf 5, _016B
    SetFlag FLAG_HGSS_UNK_2BB
    GoTo _016F
_016B:
    ClearFlag FLAG_HGSS_UNK_2BB
_016F:
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 5, _0186
    SetFlag FLAG_HGSS_UNK_2BC
    GoTo _018A
_0186:
    ClearFlag FLAG_HGSS_UNK_2BC
_018A:
    CompareVar VAR_MAP_LOCAL_0x08, 0
    GoToIf 5, _01A1
    SetFlag FLAG_HGSS_UNK_2BD
    GoTo _01A5
_01A1:
    ClearFlag FLAG_HGSS_UNK_2BD
_01A5:
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 5, _01BC
    SetFlag FLAG_HGSS_UNK_2BE
    GoTo _01C0
_01BC:
    ClearFlag FLAG_HGSS_UNK_2BE
_01C0:
    CompareVar VAR_MAP_LOCAL_0x0A, 0
    GoToIf 5, _01D7
    SetFlag FLAG_HGSS_UNK_2BF
    GoTo _01DB
_01D7:
    ClearFlag FLAG_HGSS_UNK_2BF
_01DB:
    CompareVar VAR_MAP_LOCAL_0x0B, 0
    GoToIf 5, _01F2
    SetFlag FLAG_HGSS_UNK_2C0
    GoTo _01F6
_01F2:
    ClearFlag FLAG_HGSS_UNK_2C0
_01F6:
    CompareVar VAR_MAP_LOCAL_0x0C, 0
    GoToIf 5, _020D
    SetFlag FLAG_HGSS_UNK_2C1
    GoTo _0211
_020D:
    ClearFlag FLAG_HGSS_UNK_2C1
_0211:
    CompareVar VAR_MAP_LOCAL_0x0D, 0
    GoToIf 5, _0228
    SetFlag FLAG_HGSS_UNK_2C2
    GoTo _022C
_0228:
    ClearFlag FLAG_HGSS_UNK_2C2
_022C:
    CompareVar VAR_MAP_LOCAL_0x0E, 0
    GoToIf 5, _0243
    SetFlag FLAG_HGSS_UNK_2C3
    GoTo _0247
_0243:
    ClearFlag FLAG_HGSS_UNK_2C3
_0247:
    CompareVar VAR_MAP_LOCAL_0x0F, 0
    GoToIf 5, _025E
    SetFlag FLAG_HGSS_UNK_2C4
    GoTo _0262
_025E:
    ClearFlag FLAG_HGSS_UNK_2C4
_0262:
    End
scr_seq_T11R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00008
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_WHITNEY_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02C1
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
_02C1:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00030
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_JANINE_JANINE_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0324
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
_0324:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00018
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_CLAIR_CLAIR_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0387
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
_0387:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00024
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_ERIKA_ERIKA_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _03EA
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
_03EA:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00026
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_MISTY_MISTY_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _044D
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
_044D:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00032
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BLAINE_BLAINE_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04B0
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
_04B0:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00034
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BLUE_BLUE_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0513
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
_0513:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00010
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_CHUCK_CHUCK_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0576
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
_0576:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00028
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BROCK_BROCK_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _05D9
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
_05D9:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00006
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_BUGSY_BUGSY_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _063C
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
_063C:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00022
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_SABRINA_SABRINA_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _069F
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
_069F:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00004
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_FALKNER_FALKNER_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0702
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
_0702:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00020
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_LT_SURGE_LT__SURGE_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0765
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
_0765:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_017:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00014
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_MORTY_MORTY_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _07C8
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
_07C8:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_018:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00012
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_JASMINE_JASMINE_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _082B
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
_082B:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0533_T11R0101_00016
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_LEADER_PRYCE_PRYCE_2, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _088E
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
_088E:
    BlackOutFromBattle
    ReleaseAll
    End
scr_seq_T11R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_BEAT_KARATE_KING, _08B2
    Message msg_0533_T11R0101_00000
    WaitButton
    CloseMessage
    ReleaseAll
    End
_08B2:
    Message msg_0533_T11R0101_00001
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
    .balign 4, 0
