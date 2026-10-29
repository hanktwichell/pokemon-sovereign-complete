#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0132.h"

#define obj_D46R0101_gsleader2 0

    ScriptEntry scr_seq_D46R0101_000
    ScriptEntry scr_seq_D46R0101_001
    ScriptEntry scr_seq_D46R0101_002
    ScriptEntry scr_seq_D46R0101_003
    ScriptEntry scr_seq_D46R0101_004
    ScriptEntry scr_seq_D46R0101_005
    ScriptEntry scr_seq_D46R0101_006
    ScriptEntry scr_seq_D46R0101_007
    ScriptEntryEnd
scr_seq_D46R0101_001:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_BUGSY, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01BF
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _01C5
    GoTo _01BF
scr_seq_D46R0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 4, _01DC
    Message msg_0132_D46R0101_00000
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01E5
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0228
    End
scr_seq_D46R0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEW, 0
    Message msg_0132_D46R0101_00005
    WaitCry
    WaitButton
    CloseMessage
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement 12, _0272
    WaitMovement
    RemoveObject 12
    SetPosition 13, 33, 0, 25, DIR_SOUTH
    ApplyMovement 13, _02B8
    ClearFlag FLAG_HGSS_SG_3FC8
    ReleaseAll
    End
scr_seq_D46R0101_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEW, 0
    Message msg_0132_D46R0101_00005
    WaitCry
    WaitButton
    CloseMessage
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement 13, _0272
    WaitMovement
    RemoveObject 13
    SetPosition 14, 41, 0, 62, DIR_SOUTH
    ApplyMovement 14, _02B8
    ReleaseAll
    End
scr_seq_D46R0101_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEW, 0
    Message msg_0132_D46R0101_00005
    WaitCry
    WaitButton
    CloseMessage
    PlaySE SEQ_SE_PL_BOWABOWA_sseq
    ApplyMovement 14, _0272
    WaitMovement
    RemoveObject 14
    SetPosition 15, 26, 0, 41, DIR_EAST
    ApplyMovement 15, _02BE
    ReleaseAll
    End
scr_seq_D46R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEW, 0
    Message msg_0132_D46R0101_00006
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_MEW, 45, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0239
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 15
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _023F
    CompareVar VAR_MAP_LOCAL_0x02, 5
    CallIf 1, _023F
    ReleaseAll
    End
scr_seq_D46R0101_006:
    BufferPlayerName 0
    End
scr_seq_D46R0101_007:
    SetFlag FLAG_HGSS_UNK_263
    End
_01BF:
    SetFlag FLAG_HGSS_UNK_263
    End
_01C5:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 4
    GoToIf 5, _01BF
    ClearFlag FLAG_HGSS_UNK_263
    End
_01DC:
    Message msg_0132_D46R0101_00004
    GoTo _024E
_01E5:
    BufferPlayerName 0
    Message msg_0132_D46R0101_00001
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    @ HGSS: RegisterGearNumber PHONE_CONTACT_BUGSY
    Message msg_0132_D46R0101_00002
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_263
    RemoveObject obj_D46R0101_gsleader2
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0228:
    SetVarFromValue VAR_MAP_LOCAL_0x02, 1
    Message msg_0132_D46R0101_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0239:
    BlackOutFromBattle
    ReleaseAll
    End
_023F:
    Message msg_0132_D46R0101_00007
    ClearFlag FLAG_HGSS_SG_3FC8
    WaitButton
    CloseMessage
    ReleaseAll
    End
_024E:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01E5
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0228
    End
    .balign 4, 0
_0272:
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast 2
    FaceSouth 2
    FaceWest 2
    FaceNorth 2
    FaceEast
    SetInvisible 0
    EndMovement
    .balign 4, 0
_02B8:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_02BE:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
