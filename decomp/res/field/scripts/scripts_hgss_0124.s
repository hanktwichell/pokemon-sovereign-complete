#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0139.h"

#define obj_D49R0102_gsmiddleman1 13

    ScriptEntry scr_seq_D49R0102_000
    ScriptEntry scr_seq_D49R0102_001
    ScriptEntry scr_seq_D49R0102_002
    ScriptEntry scr_seq_D49R0102_003
    ScriptEntry scr_seq_D49R0102_004
    ScriptEntry scr_seq_D49R0102_005
    ScriptEntry scr_seq_D49R0102_006
    ScriptEntry scr_seq_D49R0102_007
    ScriptEntry scr_seq_D49R0102_008
    ScriptEntry scr_seq_D49R0102_009
    ScriptEntry scr_seq_D49R0102_010
    ScriptEntry scr_seq_D49R0102_011
    ScriptEntry scr_seq_D49R0102_012
    ScriptEntry scr_seq_D49R0102_013
    ScriptEntry scr_seq_D49R0102_014
    ScriptEntry scr_seq_D49R0102_015
    ScriptEntry scr_seq_D49R0102_016
    ScriptEntryEnd
scr_seq_D49R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_SetFollowMeBGM
    GoToIfUnset FLAG_HGSS_UNK_0FA, _006A
    Message msg_0139_D49R0102_00001
    GoTo _0071
_006A:
    Message msg_0139_D49R0102_00000
    SetFlag FLAG_HGSS_UNK_0FA
_0071:
    Message msg_0139_D49R0102_00002
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 272, 0
    AddMenuEntry 296, 1
    AddMenuEntry 297, 2
    AddMenuEntry 12, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _03C5
    CompareVar VAR_0x8008, 1
    GoToIf 1, _00D5
    CompareVar VAR_0x8008, 2
    GoToIf 1, _03D0
    GoTo _03DB
    End
_00D5:
    Message msg_0139_D49R0102_00003
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 308, 0
    AddMenuEntry 309, 1
    AddMenuEntry 310, 2
    AddMenuEntry 311, 3
    AddMenuEntry 312, 4
    AddMenuEntry 13, 5
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0071
    Message msg_0139_D49R0102_00004
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0166
    CompareVar VAR_0x8008, 1
    GoToIf 1, _01A0
    CompareVar VAR_0x8008, 2
    GoToIf 1, _01DA
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0214
    GoTo _024E
    End
_0166:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 298, 0
    AddMenuEntry 299, 1
    AddMenuEntry 304, 6
    AddMenuEntry 13, 10
    ShowMenu
    GoTo _0288
    End
_01A0:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 1
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 301, 3
    AddMenuEntry 300, 2
    AddMenuEntry 307, 9
    AddMenuEntry 13, 10
    ShowMenu
    GoTo _0288
    End
_01DA:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 2
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 306, 8
    AddMenuEntry 307, 9
    AddMenuEntry 299, 1
    AddMenuEntry 13, 10
    ShowMenu
    GoTo _0288
    End
_0214:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 3
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 305, 7
    AddMenuEntry 304, 6
    AddMenuEntry 301, 3
    AddMenuEntry 13, 10
    ShowMenu
    GoTo _0288
    End
_024E:
    SetVarFromValue VAR_MAP_LOCAL_0x07, 4
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 303, 5
    AddMenuEntry 302, 4
    AddMenuEntry 298, 0
    AddMenuEntry 13, 10
    ShowMenu
    GoTo _0288
    End
_0288:
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0318
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0323
    CompareVar VAR_0x8008, 2
    GoToIf 1, _032E
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0339
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0344
    CompareVar VAR_0x8008, 5
    GoToIf 1, _034F
    CompareVar VAR_0x8008, 6
    GoToIf 1, _035A
    CompareVar VAR_0x8008, 7
    GoToIf 1, _0365
    CompareVar VAR_0x8008, 8
    GoToIf 1, _0370
    CompareVar VAR_0x8008, 9
    GoToIf 1, _037B
    GoTo _00D5
    End
_0318:
    Message msg_0139_D49R0102_00006
    GoTo _0386
    End
_0323:
    Message msg_0139_D49R0102_00007
    GoTo _0386
    End
_032E:
    Message msg_0139_D49R0102_00008
    GoTo _0386
    End
_0339:
    Message msg_0139_D49R0102_00009
    GoTo _0386
    End
_0344:
    Message msg_0139_D49R0102_00010
    GoTo _0386
    End
_034F:
    Message msg_0139_D49R0102_00011
    GoTo _0386
    End
_035A:
    Message msg_0139_D49R0102_00012
    GoTo _0386
    End
_0365:
    Message msg_0139_D49R0102_00013
    GoTo _0386
    End
_0370:
    Message msg_0139_D49R0102_00014
    GoTo _0386
    End
_037B:
    Message msg_0139_D49R0102_00015
    GoTo _0386
    End
_0386:
    Message msg_0139_D49R0102_00004
    CompareVar VAR_MAP_LOCAL_0x07, 0
    GoToIf 1, _0166
    CompareVar VAR_MAP_LOCAL_0x07, 1
    GoToIf 1, _01A0
    CompareVar VAR_MAP_LOCAL_0x07, 2
    GoToIf 1, _01DA
    CompareVar VAR_MAP_LOCAL_0x07, 3
    GoToIf 1, _0214
    GoTo _024E
    End
_03C5:
    Message msg_0139_D49R0102_00005
    GoTo _0071
    End
_03D0:
    Message msg_0139_D49R0102_00017
    GoTo _0071
    End
_03DB:
    Message msg_0139_D49R0102_00016
    WaitButton
    CloseMessage
    StopMusic
    PlayDefaultMusic
    @ HGSS: ProcessSoundplate
    ReleaseAll
    End
scr_seq_D49R0102_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 500
    GoToIf 0, _0417
    BufferPlayerName 0
    Message msg_0139_D49R0102_00025
    GoTo _041A
_0417:
    Message msg_0139_D49R0102_00024
_041A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 51
    GoToIf 0, _0449
    BufferPlayerName 0
    Message msg_0139_D49R0102_00027
    GoTo _044C
_0449:
    Message msg_0139_D49R0102_00026
_044C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 150
    GoToIf 0, _047B
    BufferPlayerName 0
    Message msg_0139_D49R0102_00029
    GoTo _047E
_047B:
    Message msg_0139_D49R0102_00028
_047E:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 1000
    GoToIf 0, _04AD
    BufferPlayerName 0
    Message msg_0139_D49R0102_00031
    GoTo _04B0
_04AD:
    Message msg_0139_D49R0102_00030
_04B0:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 10001
    GoToIf 0, _04DF
    BufferPlayerName 0
    Message msg_0139_D49R0102_00033
    GoTo _04E2
_04DF:
    Message msg_0139_D49R0102_00032
_04E2:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 75
    GoToIf 0, _0511
    BufferPlayerName 0
    Message msg_0139_D49R0102_00035
    GoTo _0514
_0511:
    Message msg_0139_D49R0102_00034
_0514:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 26
    GoToIf 0, _0544
    BufferPlayerName 0
    MessageGendered msg_0139_D49R0102_00037, msg_0139_D49R0102_00038
    GoTo _0547
_0544:
    Message msg_0139_D49R0102_00036
_0547:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 20001
    GoToIf 0, _0576
    BufferPlayerName 0
    Message msg_0139_D49R0102_00040
    GoTo _0579
_0576:
    Message msg_0139_D49R0102_00039
_0579:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 800
    GoToIf 0, _05A5
    Message msg_0139_D49R0102_00043
    GoTo _05A8
_05A5:
    Message msg_0139_D49R0102_00041
_05A8:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 800
    GoToIf 0, _05D7
    BufferPlayerName 0
    Message msg_0139_D49R0102_00046
    GoTo _05DA
_05D7:
    Message msg_0139_D49R0102_00045
_05DA:
    CloseMessage
    ApplyMovement obj_D49R0102_gsmiddleman1, _0610
    WaitMovement
    CompareVar VAR_MAP_LOCAL_0x00, 800
    GoToIf 0, _05FC
    Message msg_0139_D49R0102_00044
    GoTo _05FF
_05FC:
    Message msg_0139_D49R0102_00042
_05FF:
    CloseMessage
    ApplyMovement obj_D49R0102_gsmiddleman1, _0618
    WaitMovement
    ReleaseAll
    End
    .balign 4, 0
_0610:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_0618:
    WalkOnSpotNormalNorth
    EndMovement
scr_seq_D49R0102_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 201
    GoToIf 0, _0647
    BufferPlayerName 0
    Message msg_0139_D49R0102_00048
    GoTo _064A
_0647:
    Message msg_0139_D49R0102_00047
_064A:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 250
    GoToIf 0, _0679
    BufferPlayerName 0
    Message msg_0139_D49R0102_00050
    GoTo _067C
_0679:
    Message msg_0139_D49R0102_00049
_067C:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 101
    GoToIf 0, _06AB
    BufferPlayerName 0
    Message msg_0139_D49R0102_00052
    GoTo _06AE
_06AB:
    Message msg_0139_D49R0102_00051
_06AE:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_014:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    PlayCry SPECIES_RATTATA, 0
    CompareVar VAR_MAP_LOCAL_0x00, 15000
    GoToIf 0, _06E3
    BufferPlayerName 0
    Message msg_0139_D49R0102_00019
    GoTo _06E6
_06E3:
    Message msg_0139_D49R0102_00018
_06E6:
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_015:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    PlayCry SPECIES_MACHOP, 0
    CompareVar VAR_MAP_LOCAL_0x00, 15000
    GoToIf 0, _071D
    BufferPlayerName 0
    Message msg_0139_D49R0102_00021
    GoTo _0720
_071D:
    Message msg_0139_D49R0102_00020
_0720:
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D49R0102_016:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScrCmd_724 11, VAR_TEMP_x4000
    PlayCry SPECIES_BUTTERFREE, 0
    CompareVar VAR_MAP_LOCAL_0x00, 15000
    GoToIf 0, _0757
    BufferPlayerName 0
    Message msg_0139_D49R0102_00023
    GoTo _075A
_0757:
    Message msg_0139_D49R0102_00022
_075A:
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
