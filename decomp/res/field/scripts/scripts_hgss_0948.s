#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0635.h"


    ScriptEntry scr_seq_T30R0601_000
    ScriptEntry scr_seq_T30R0601_001
    ScriptEntry scr_seq_T30R0601_002
    ScriptEntry scr_seq_T30R0601_003
    ScriptEntry scr_seq_T30R0601_004
    ScriptEntryEnd
scr_seq_T30R0601_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_MAP_LOCAL_0x01, _0036
    Message msg_0635_T30R0601_00000
    SetFlag FLAG_MAP_LOCAL_0x01
    GoTo _0036
_0036:
    Message msg_0635_T30R0601_00001
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _005D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _014A
    End
_005D:
    Message msg_0635_T30R0601_00002
    CloseMessage
    GoTo _0068
_0068:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8002
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8002, 255
    GoToIf 1, _014A
    GetPartyMonSpecies VAR_0x8002, VAR_0x8001
    CompareVar VAR_0x8001, 0
    GoToIf 1, _0134
    GetPartyMonMoveCount VAR_RESULT, VAR_0x8002
    CompareVar VAR_RESULT, 1
    GoToIf 1, _013F
    Message msg_0635_T30R0601_00006
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectPartyMonMove VAR_0x8002
    GetSelectedPartyMonMove VAR_0x8001
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8001, 255
    GoToIf 1, _005D
    BufferPartyMoveName 0, VAR_0x8002, VAR_0x8001
    Message msg_0635_T30R0601_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _011D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _005D
    End
_011D:
    ClearPartyMonMoveSlot VAR_0x8002, VAR_0x8001
    PlayFanfare SEQ_ME_WASURE_sseq
    WaitFanfare
    Message msg_0635_T30R0601_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0134:
    Message msg_0635_T30R0601_00005
    CloseMessage
    GoTo _0068
_013F:
    Message msg_0635_T30R0601_00004
    CloseMessage
    GoTo _0068
_014A:
    Message msg_0635_T30R0601_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30R0601_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfUnset FLAG_HGSS_MET_MOVE_MANIAC, _0238
    CheckItem ITEM_HEART_SCALE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _022D
    Message msg_0635_T30R0601_00010
    Message msg_0635_T30R0601_00012
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8005
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8005, 255
    GoToIf 1, _022D
    GetPartyMonSpecies VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0247
    CheckHasLearnableReminderMoves VAR_RESULT, VAR_0x8005
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0222
    Message msg_0635_T30R0601_00013
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenMoveReminderMenu VAR_0x8005
    CheckLearnedReminderMove VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _022D
    RemoveItem ITEM_HEART_SCALE, 1, VAR_RESULT
    BufferPlayerName 3
    Message msg_0635_T30R0601_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0222:
    Message msg_0635_T30R0601_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_022D:
    Message msg_0635_T30R0601_00011
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0238:
    Message msg_0635_T30R0601_00009
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_MET_MOVE_MANIAC
    End
_0247:
    Message msg_0635_T30R0601_00015
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30R0601_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_186, _0287
    SetFlag FLAG_HGSS_UNK_186
    Message msg_0635_T30R0601_00026
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02A5
    GoTo _02EC
_0287:
    Message msg_0635_T30R0601_00027
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02A5
    GoTo _02EC
_02A5:
    Message msg_0635_T30R0601_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02B0:
    Message msg_0635_T30R0601_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02BB:
    Message msg_0635_T30R0601_00032
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02C6:
    Message msg_0635_T30R0601_00033
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02D1:
    BufferMoveName 0, MOVE_DRACO_METEOR
    Message msg_0635_T30R0601_00034
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02E1:
    Message msg_0635_T30R0601_00031
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02EC:
    GetPartyCount VAR_MAP_LOCAL_0x00
_02F0:
    SubVar VAR_MAP_LOCAL_0x00, 1
    GetPartyMonSpecies VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0346
    GetPartyMonType VAR_0x8004, VAR_0x8005, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8004, 16
    GoToIf 1, _0331
    CompareVar VAR_0x8005, 16
    GoToIf 1, _0331
    GoTo _0346
_0331:
    CheckPartyMonHasMove VAR_RESULT, MOVE_DRACO_METEOR, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0359
_0346:
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 5, _02F0
    GoTo _02B0
_0359:
    Message msg_0635_T30R0601_00030
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _02A5
    GetPartyMonSpecies VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 0
    GoToIf 1, _02C6
    Call _042B
    CompareVar VAR_RESULT, 0
    GoToIf 1, _02BB
    CheckPartyMonHasMove VAR_RESULT, MOVE_DRACO_METEOR, VAR_0x8000
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02D1
    GetPartyMonFriendship VAR_RESULT, VAR_0x8000
    CompareVar VAR_RESULT, 255
    GoToIf 0, _02E1
    BufferPartyMonSpecies 0, VAR_0x8000
    Message msg_0635_T30R0601_00062
    CloseMessage
    SetVarFromValue VAR_0x8003, 434
    GoTo _03EF
_03EF:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenMoveTutorMenu VAR_0x8000, MOVE_DRACO_METEOR
    CheckLearnedReminderMove VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _02A5
    Message msg_0635_T30R0601_00042
    WaitButton
    CloseMessage
    ReleaseAll
    End
_042B:
    GetPartyMonType VAR_0x8004, VAR_0x8005, VAR_0x8000
    CompareVar VAR_0x8004, 16
    GoToIf 1, _0455
    CompareVar VAR_0x8005, 16
    GoToIf 1, _0455
    SetVarFromValue VAR_RESULT, 0
    Return
_0455:
    SetVarFromValue VAR_RESULT, 1
    Return
scr_seq_T30R0601_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_187, _0490
    SetFlag FLAG_HGSS_UNK_187
    Message msg_0635_T30R0601_00043
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04AC
    GoTo _06EE
_0490:
    Message msg_0635_T30R0601_00044
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _04AC
    GoTo _06EE
_04AC:
    Message msg_0635_T30R0601_00045
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SelectMoveTutorPokemon
    GetSelectedPartySlot VAR_0x8000
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_0x8000, 255
    GoToIf 1, _06EE
    GetPartyMonSpecies VAR_0x8000, VAR_0x8001
    CompareVar VAR_0x8001, 0
    GoToIf 1, _0708
    Call _05F4
    CompareVar VAR_RESULT, 0
    GoToIf 1, _06FB
    SetVarFromVar VAR_0x8002, VAR_RESULT
    Call _06B0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0722
    GetPartyMonFriendship VAR_RESULT, VAR_0x8000
    CompareVar VAR_RESULT, 255
    GoToIf 0, _0715
    BufferPartyMonSpecies 0, VAR_0x8000
    CompareVar VAR_0x8002, 1
    GoToIf 1, _0555
    CompareVar VAR_0x8002, 2
    GoToIf 1, _0577
    GoTo _0599
_0555:
    Message msg_0635_T30R0601_00052
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06EE
    SetVarFromValue VAR_0x8003, 307
    GoTo _05BB
_0577:
    Message msg_0635_T30R0601_00053
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06EE
    SetVarFromValue VAR_0x8003, 308
    GoTo _05BB
_0599:
    Message msg_0635_T30R0601_00054
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _06EE
    SetVarFromValue VAR_0x8003, 338
    GoTo _05BB
_05BB:
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenMoveTutorMenu VAR_0x8000, VAR_0x8003
    CheckLearnedReminderMove VAR_RESULT
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_RESULT, 255
    GoToIf 1, _06EE
    ReleaseAll
    End
_05F4:
    CompareVar VAR_0x8001, 6
    GoToIf 1, _0698
    CompareVar VAR_0x8001, 157
    GoToIf 1, _0698
    CompareVar VAR_0x8001, 257
    GoToIf 1, _0698
    CompareVar VAR_0x8001, 392
    GoToIf 1, _0698
    CompareVar VAR_0x8001, 9
    GoToIf 1, _06A0
    CompareVar VAR_0x8001, 160
    GoToIf 1, _06A0
    CompareVar VAR_0x8001, 260
    GoToIf 1, _06A0
    CompareVar VAR_0x8001, 395
    GoToIf 1, _06A0
    CompareVar VAR_0x8001, 3
    GoToIf 1, _06A8
    CompareVar VAR_0x8001, 154
    GoToIf 1, _06A8
    CompareVar VAR_0x8001, 254
    GoToIf 1, _06A8
    CompareVar VAR_0x8001, 389
    GoToIf 1, _06A8
    SetVarFromValue VAR_RESULT, 0
    Return
_0698:
    SetVarFromValue VAR_RESULT, 1
    Return
_06A0:
    SetVarFromValue VAR_RESULT, 2
    Return
_06A8:
    SetVarFromValue VAR_RESULT, 3
    Return
_06B0:
    CompareVar VAR_0x8002, 1
    GoToIf 1, _06D0
    CompareVar VAR_0x8002, 2
    GoToIf 1, _06DA
    GoTo _06E4
_06D0:
    CheckPartyMonHasMove VAR_RESULT, MOVE_BLAST_BURN, VAR_0x8000
    Return
_06DA:
    CheckPartyMonHasMove VAR_RESULT, MOVE_HYDRO_CANNON, VAR_0x8000
    Return
_06E4:
    CheckPartyMonHasMove VAR_RESULT, MOVE_FRENZY_PLANT, VAR_0x8000
    Return
_06EE:
    Message msg_0635_T30R0601_00046
    WaitButton
    CloseMessage
    ReleaseAll
    End
_06FB:
    Message msg_0635_T30R0601_00048
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0708:
    Message msg_0635_T30R0601_00049
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0715:
    Message msg_0635_T30R0601_00050
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0722:
    Message msg_0635_T30R0601_00051
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T30R0601_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0635_T30R0601_00061
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
