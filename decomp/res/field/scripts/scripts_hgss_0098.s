#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0121.h"


    ScriptEntry scr_seq_D38R0104_000
    ScriptEntry scr_seq_D38R0104_001
    ScriptEntry scr_seq_D38R0104_002
    ScriptEntry scr_seq_D38R0104_003
    ScriptEntryEnd
scr_seq_D38R0104_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_GOT_TYROGUE_FROM_KARATE_KING, _0121
    GoToIfSet FLAG_HGSS_BEAT_KARATE_KING, _0130
    Message msg_0121_D38R0104_00000
    CloseMessage
    StartTrainerBattle TRAINER_HGSS_BLACK_BELT_KIYO, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _014D
    SetFlag FLAG_HGSS_BEAT_KARATE_KING
    Message msg_0121_D38R0104_00001
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _0153
    Message msg_0121_D38R0104_00004
    GoTo _0196
scr_seq_D38R0104_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_REGIROCK, 6
    ReleaseObject 7
    @ HGSS: ScrCmd_523 7, 2, 90, 2, 0
    LockObject 7
    Message msg_0121_D38R0104_00007
    CloseMessage
    WaitCry
    CompleteStartWildBattle SPECIES_REGIROCK, 40, 0
    LockAll
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _014D
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    RemoveObject 7
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _019E
    CompareVar VAR_MAP_LOCAL_0x02, 5
    GoToIf 1, _019E
    ReleaseAll
    End
scr_seq_D38R0104_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0121_D38R0104_00008
    CheckItem ITEM_AZURE_FLUTE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01AD
    Message msg_0121_D38R0104_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D38R0104_003:
    BufferPlayerName 0
    BufferPlayerName 0
    End
_0121:
    SetFlag FLAG_HGSS_GOT_TYROGUE_FROM_KARATE_KING
    Message msg_0121_D38R0104_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0130:
    Message msg_0121_D38R0104_00001
    GetPartyCount VAR_0x8005
    CompareVar VAR_0x8005, 6
    GoToIf 5, _0153
    Message msg_0121_D38R0104_00004
    GoTo _0196
_014D:
    BlackOutFromBattle
    ReleaseAll
    End
_0153:
    BufferPlayerName 0
    Message msg_0121_D38R0104_00002
    PlayFanfare SEQ_FANFA5_sseq
    WaitFanfare
    GivePokemon SPECIES_TYROGUE, 10, ITEM_FIST_PLATE, VAR_RESULT
    Message msg_0121_D38R0104_00005
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 0
    CallIf 1, _028D
    SetFlag FLAG_HGSS_GOT_TYROGUE_FROM_KARATE_KING
    Message msg_0121_D38R0104_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0196:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_019E:
    Message msg_0121_D38R0104_00024
    WaitButton
    CloseMessage
    ClearFlag FLAG_HGSS_SG_3FD7
    ReleaseAll
    End
_01AD:
    Message msg_0121_D38R0104_00011
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02B3
    StopMusic
    PlayMusic SEQ_TOWN01_D_sseq
    BufferPlayerName 0
    BufferPlayerName 0
    Message msg_0121_D38R0104_00010
    CloseMessage
    FadeScreen 6, 10, 0, COLOR_WHITE
    WaitFadeScreen
    FadeScreen 6, 10, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement 8, _0440
    WaitMovement
    FacePlayer
    ApplyMovement 8, _047E
    WaitMovement
    PlayCry SPECIES_JIRACHI, 0
    Message msg_0121_D38R0104_00012
    WaitCry
    CloseMessage
    FacePlayer
    PlayCry SPECIES_JIRACHI, 0
    Message msg_0121_D38R0104_00013
    InitLocalTextMenu 1, 1, 0, VAR_MAP_LOCAL_0x00, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 16, 2
    AddMenuEntry 17, 3
    ShowMenu
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 0
    GoToIf 1, _02B7
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0309
    SetVar VAR_0x8008, VAR_MAP_LOCAL_0x00
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0344
    GoTo _0368
_028D:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_SPECIAL_x8005, VAR_TEMP_x4000
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    Return
_02B3:
    ReleaseAll
    End
_02B7:
    Message msg_0121_D38R0104_00018
    Message msg_0121_D38R0104_00019
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    GiveMoney 30000
    WaitFanfare
    WaitButton
    CloseMessage
    GoTo _03DF
_0309:
    Message msg_0121_D38R0104_00018
    Message msg_0121_D38R0104_00021
    @ HGSS: ScriptOverlayCmd 3, 0
    @ HGSS: ScrCmd_116 0, 20, 2
    AddCoins 10000
    AddCoins 10000
    AddCoins 10000
    AddCoins 10000
    AddCoins 10000
    @ HGSS: ScrCmd_117
    @ HGSS: ScriptOverlayCmd 3, 1
    WaitFanfare
    WaitButton
    CloseMessage
    GoTo _03DF
_0344:
    Message msg_0121_D38R0104_00018
    Message msg_0121_D38R0104_00022
    WaitFanfare
    SetVar VAR_0x8004, ITEM_RARE_CANDY
    SetVar VAR_0x8005, 99
    Common_GiveItemQuantity
    CloseMessage
    GoTo _03DF
_0368:
    Message msg_0121_D38R0104_00018
    PlayCry SPECIES_JIRACHI, 6
    Message msg_0121_D38R0104_00023
    WaitCry
    CloseMessage
    CompleteStartWildBattle SPECIES_JIRACHI, 45, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0412
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 1
    GoToIf 1, _03DF
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _0418
    CompareVar VAR_MAP_LOCAL_0x02, 5
    CallIf 1, _03DF
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_SG_3FB3
    RemoveObject 8
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_03DF:
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    RemoveObject 8
    SetFlag FLAG_HGSS_SG_3FB3
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    Message msg_0121_D38R0104_00020
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0412:
    BlackOutFromBattle
    ReleaseAll
    End
_0418:
    SetFlag FLAG_HGSS_SG_3FAE
    FadeScreen 8, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_SG_3FB3
    RemoveObject 8
    FadeScreen 8, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_0440:
    EmoteExclamationMark
    Delay4
    FaceWest
    Delay4
    WalkOnSpotNormalWest 3
    Delay4
    FaceSouth
    Delay4
    WalkOnSpotNormalSouth 3
    Delay4
    FaceEast
    Delay4
    WalkOnSpotNormalEast 3
    Delay4
    JumpOnSpotFastSouth 3
    EndMovement
    .balign 4, 0
_047E:
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
