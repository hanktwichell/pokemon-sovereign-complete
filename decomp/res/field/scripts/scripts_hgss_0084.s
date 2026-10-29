#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0107.h"


    ScriptEntry scr_seq_D32R0301_000
    ScriptEntry scr_seq_D32R0301_001
    ScriptEntry scr_seq_D32R0301_002
    ScriptEntry scr_seq_D32R0301_003
    ScriptEntry scr_seq_D32R0301_004
    ScriptEntry scr_seq_D32R0301_005
    ScriptEntry scr_seq_D32R0301_006
    ScriptEntry scr_seq_D32R0301_007
    ScriptEntry scr_seq_D32R0301_008
    ScriptEntry scr_seq_D32R0301_009
    ScriptEntry scr_seq_D32R0301_010
    ScriptEntry scr_seq_D32R0301_011
    ScriptEntry scr_seq_D32R0301_012
    ScriptEntry scr_seq_D32R0301_013
    ScriptEntryEnd
scr_seq_D32R0301_013:
    End
scr_seq_D32R0301_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    GoTo _0074
    End
scr_seq_D32R0301_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    GoTo _0074
    End
_0074:
    @ HGSS: ScrCmd_682 0
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _057C
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _0581
    GoTo _009A
    End
_009A:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _0586
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _05A5
    AddMenuEntry 19, 2
    AddMenuEntry 20, 3
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _013F
    CompareVar VAR_RESULT, 1
    GoToIf 1, _014D
    CompareVar VAR_RESULT, 2
    GoToIf 1, _0104
    CompareVar VAR_RESULT, 4
    GoToIf 1, _015B
    GoTo _0126
    End
_0104:
    CompareVar VAR_MAP_LOCAL_0x04, 0
    CallIf 1, _05BC
    CompareVar VAR_MAP_LOCAL_0x04, 1
    CallIf 1, _05C1
    GoTo _009A
    End
_0126:
    GoTo _012E
    End
_012E:
    SetVarFromValue VAR_HGSS_UNK_4142, 0
    Message msg_0107_D32R0301_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013F:
    SetVarFromValue VAR_HGSS_UNK_4143, 0
    GoTo _0169
    End
_014D:
    SetVarFromValue VAR_HGSS_UNK_4143, 1
    GoTo _0169
    End
_015B:
    SetVarFromValue VAR_HGSS_UNK_4143, 2
    GoTo _0169
    End
_0169:
    Message msg_0107_D32R0301_00007
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 21, 0
    AddMenuEntry 22, 1
    AddMenuEntry 23, 2
    ShowMenu
    CompareVar VAR_RESULT, 0
    GoToIf 1, _01B2
    CompareVar VAR_RESULT, 1
    GoToIf 1, _01C0
    GoTo _0126
    End
_01B2:
    SetVarFromValue VAR_HGSS_UNK_4144, 0
    GoTo _01CE
    End
_01C0:
    SetVarFromValue VAR_HGSS_UNK_4144, 1
    GoTo _01CE
    End
_01CE:
    GoTo _01D6
    End
_01D6:
    CompareVar VAR_HGSS_UNK_4143, 0
    CallIf 1, _0399
    CompareVar VAR_HGSS_UNK_4143, 1
    CallIf 1, _0399
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    HealParty
    Common_SaveGame
    SetVarFromVar VAR_RESULT, VAR_MAP_LOCAL_0x00
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0126
    CompareVar VAR_HGSS_UNK_4143, 2
    GoToIf 1, _0226
    GoTo _03A1
    End
_0226:
    Message msg_0107_D32R0301_00024
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 14, 0
    AddMenuEntry 15, 1
    AddMenuEntry 5, 2
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0277
    CompareVar VAR_0x8008, 1
    GoToIf 1, _02F9
    GoTo _0126
    End
_0277:
    Message msg_0107_D32R0301_00025
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0226
    CloseMessage
    CompareVar VAR_HGSS_UNK_4144, 0
    CallIf 1, _02CF
    CompareVar VAR_HGSS_UNK_4144, 1
    CallIf 1, _02DB
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02E7
    CompareVar VAR_RESULT, 3
    GoToIf 1, _02EF
    GoTo _037B
    End
_02CF:
    @ HGSS: ScrCmd_226 27, 0, 0, VAR_SPECIAL_RESULT
    Return
_02DB:
    @ HGSS: ScrCmd_226 28, 0, 0, VAR_SPECIAL_RESULT
    Return
_02E7:
    GoTo _0226
    End
_02EF:
    @ HGSS: ScrCmd_283
    GoTo _0226
    End
_02F9:
    Message msg_0107_D32R0301_00025
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0226
    CloseMessage
    CompareVar VAR_HGSS_UNK_4144, 0
    CallIf 1, _0351
    CompareVar VAR_HGSS_UNK_4144, 1
    CallIf 1, _035D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0369
    CompareVar VAR_RESULT, 3
    GoToIf 1, _0371
    GoTo _037B
    End
_0351:
    @ HGSS: ScrCmd_227 27, 0, 0, VAR_SPECIAL_RESULT
    Return
_035D:
    @ HGSS: ScrCmd_227 28, 0, 0, VAR_SPECIAL_RESULT
    Return
_0369:
    GoTo _0226
    End
_0371:
    @ HGSS: ScrCmd_283
    GoTo _0226
    End
_037B:
    Message msg_0107_D32R0301_00026
    CompareVar VAR_HGSS_UNK_4143, 2
    CallIf 1, _0399
    Call _05ED
    GoTo _03A1
    End
_0399:
    SetVarFromValue VAR_HGSS_UNK_4142, 255
    Return
_03A1:
    CompareVar VAR_HGSS_UNK_4143, 0
    CallIf 1, _0439
    CompareVar VAR_HGSS_UNK_4143, 1
    CallIf 1, _0454
    CompareVar VAR_HGSS_UNK_4143, 2
    CallIf 1, _046F
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    GoTo _03D4
    End
_03D4:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_815 0
    CompareVar VAR_HGSS_UNK_4143, 0
    CallIf 1, _0495
    CompareVar VAR_HGSS_UNK_4143, 1
    CallIf 1, _04A9
    CompareVar VAR_HGSS_UNK_4143, 2
    CallIf 1, _04BD
    @ HGSS: ScrCmd_420 59
    @ HGSS: ScrCmd_436
    @ HGSS: ScrCmd_627 3
    CompareVar VAR_HGSS_UNK_4143, 2
    CallIf 1, _0435
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScrCmd_682 1
    End
_0435:
    @ HGSS: ScrCmd_283
    Return
_0439:
    Message msg_0107_D32R0301_00009
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _04D4
    ApplyMovement VAR_LAST_TALKED, _04FC
    WaitMovement
    Return
_0454:
    Message msg_0107_D32R0301_00009
    WaitABPress
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _04D4
    ApplyMovement VAR_LAST_TALKED, _04FC
    WaitMovement
    Return
_046F:
    @ HGSS: NPCMsgVar msg_0107_D32R0301_00009
    WaitTime 15, VAR_RESULT
    ScrCmd_258
    @ HGSS: ScrCmd_257 169
    CloseMessage
    ApplyMovement LOCALID_PLAYER, _04E8
    ApplyMovement VAR_LAST_TALKED, _0510
    WaitMovement
    Return
_0495:
    ApplyMovement LOCALID_PLAYER, _0524
    ApplyMovement VAR_LAST_TALKED, _0554
    WaitMovement
    Return
_04A9:
    ApplyMovement LOCALID_PLAYER, _0524
    ApplyMovement VAR_LAST_TALKED, _0554
    WaitMovement
    Return
_04BD:
    ApplyMovement LOCALID_PLAYER, _053C
    ApplyMovement VAR_LAST_TALKED, _0568
    WaitMovement
    Return
    .balign 4, 0
_04D4:
    WalkNormalNorth 3
    WalkNormalEast
    WalkNormalNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_04E8:
    WalkNormalNorth 3
    WalkNormalWest
    WalkNormalNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_04FC:
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0510:
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 4
    SetInvisible
    EndMovement
    .balign 4, 0
_0524:
    WalkFasterSouth 3
    WalkFasterWest
    WalkFasterSouth 4
    FaceNorth
    SetVisible
    EndMovement
    .balign 4, 0
_053C:
    WalkFasterSouth 3
    WalkFasterEast
    WalkFasterSouth 4
    FaceNorth
    SetVisible
    EndMovement
    .balign 4, 0
_0554:
    WalkFasterSouth 2
    WalkFasterWest
    WalkFasterSouth 4
    SetVisible
    EndMovement
    .balign 4, 0
_0568:
    WalkFasterSouth 2
    WalkFasterEast
    WalkFasterSouth 4
    SetVisible
    EndMovement
_057C:
    Message msg_0107_D32R0301_00000
    Return
_0581:
    Message msg_0107_D32R0301_00003
    Return
_0586:
    Message msg_0107_D32R0301_00001
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 16, 0
    AddMenuEntry 17, 1
    Return
_05A5:
    Message msg_0107_D32R0301_00004
    InitLocalTextMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 18, 4
    Return
_05BC:
    Message msg_0107_D32R0301_00002
    Return
_05C1:
    Message msg_0107_D32R0301_00005
    Return
scr_seq_D32R0301_001:
    @ HGSS: ScrCmd_682 0
    SetVarFromValue VAR_MAP_LOCAL_0x03, 1
    SetVarFromValue VAR_HGSS_UNK_4142, 0
    Message msg_0107_D32R0301_00011
    Call _0399
    Call _05ED
    GoTo _03A1
    End
_05ED:
    ShowSavingIcon
    TrySaveGame VAR_RESULT
    HideSavingIcon
    PlaySE SEQ_SE_DP_SAVE_sseq
    WaitSE SEQ_SE_DP_SAVE_sseq
    Return
scr_seq_D32R0301_002:
    LockAll
    FacePlayer
    Message msg_0107_D32R0301_00012
    @ HGSS: ScrCmd_628 VAR_UNK_4143, VAR_UNK_4144
    CompareVar VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 1
    CallIf 1, _062E
    CompareVar VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 3
    CallIf 1, _0636
    GoTo _0126
    End
_062E:
    SetVarFromValue VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 0
    Return
_0636:
    SetVarFromValue VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 2
    Return
scr_seq_D32R0301_003:
    CompareVar VAR_HGSS_UNK_4143, 0
    CallIf 1, _067A
    CompareVar VAR_HGSS_UNK_4143, 1
    CallIf 1, _067A
    CompareVar VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 1
    CallIf 1, _0680
    CompareVar VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 3
    CallIf 1, _0697
    GoTo _0126
    End
_067A:
    IncrementTrainerScore TRAINER_SCORE_EVENT_BATTLE_FACTORY_ROUND_COMPLETED
    Return
_0680:
    Message msg_0107_D32R0301_00013
    BufferPlayerName 0
    Message msg_0107_D32R0301_00015
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 2
    Return
_0697:
    Message msg_0107_D32R0301_00013
    BufferPlayerName 0
    Message msg_0107_D32R0301_00014
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    SetVarFromValue VAR_HGSS_BATTLE_FACTORY_PRINT_PROGRESS, 4
    Common_CheckAllFrontierGoldPrintsObtained
    Return
scr_seq_D32R0301_004:
    GoTo _0126
    .balign 4, 0
    FaceWest 0
    WalkNormalNorth 2
    Delay8
    WalkNormalNorth
    EndMovement
    .balign 4, 0
    WalkNormalNorth 2
    Delay8
    WalkNormalNorth
    EndMovement
scr_seq_D32R0301_006:
    NPCMessage msg_0107_D32R0301_00027
    End
scr_seq_D32R0301_007:
    NPCMessage msg_0107_D32R0301_00028
    End
scr_seq_D32R0301_008:
    NPCMessage msg_0107_D32R0301_00029
    End
scr_seq_D32R0301_009:
    NPCMessage msg_0107_D32R0301_00030
    End
scr_seq_D32R0301_010:
    NPCMessage msg_0107_D32R0301_00031
    End
scr_seq_D32R0301_011:
    NPCMessage msg_0107_D32R0301_00032
    End
scr_seq_D32R0301_012:
    NPCMessage msg_0107_D32R0301_00033
    End
    .balign 4, 0
