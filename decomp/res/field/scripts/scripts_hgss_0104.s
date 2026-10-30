#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0125.h"

#define obj_D40R0107_dancer 0
#define obj_D40R0107_dancer_2 1
#define obj_D40R0107_dancer_3 2
#define obj_D40R0107_dancer_4 3
#define obj_D40R0107_dancer_5 4
#define obj_D40R0107_lug_obj01 5
#define obj_D40R0107_stop 6
#define obj_D40R0107_stop_2 7
#define obj_D40R0107_stop_3 8
#define obj_D40R0107_stop_4 9
#define obj_D40R0107_stop_5 10

    ScriptEntry scr_seq_D40R0107_000
    ScriptEntry scr_seq_D40R0107_001
    ScriptEntry scr_seq_D40R0107_002
    ScriptEntry scr_seq_D40R0107_003
    ScriptEntry scr_seq_D40R0107_004
    ScriptEntry scr_seq_D40R0107_005
    ScriptEntry scr_seq_D40R0107_006
    ScriptEntryEnd
scr_seq_D40R0107_006:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 111
    SetFlag FLAG_HGSS_UNK_105
    End
scr_seq_D40R0107_002:
    SetFlag FLAG_HGSS_UNK_99A
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _003B
    End
_003B:
    SetFlag FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA
    RemoveObject obj_D40R0107_lug_obj01
    RemoveObject obj_D40R0107_stop
    RemoveObject obj_D40R0107_stop_2
    RemoveObject obj_D40R0107_stop_3
    RemoveObject obj_D40R0107_stop_4
    RemoveObject obj_D40R0107_stop_5
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_D40R0107_004:
    GoToIfSet FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA, _007C
    ShowObject obj_D40R0107_stop
    ShowObject obj_D40R0107_stop_2
    ShowObject obj_D40R0107_stop_3
    ShowObject obj_D40R0107_stop_4
    ShowObject obj_D40R0107_stop_5
_007C:
    CompareVar VAR_MAP_LOCAL_0x0B, 123
    GoToIf 5, _0093
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
_0093:
    GoToIfSet FLAG_HGSS_UNK_109, _00FA
    GoToIfUnset FLAG_HGSS_UNK_10B, _00FA
    CompareVar VAR_MAP_LOCAL_0x03, 111
    GoToIf 5, _00FA
    SetPosition obj_D40R0107_dancer_5, 16, 1, 32, DIR_NORTH
    SetPosition obj_D40R0107_dancer_3, 13, 1, 33, DIR_NORTH
    SetPosition obj_D40R0107_dancer_4, 13, 1, 27, DIR_NORTH
    SetPosition obj_D40R0107_dancer, 19, 1, 33, DIR_NORTH
    SetPosition obj_D40R0107_dancer_2, 19, 1, 27, DIR_NORTH
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    End
_00FA:
    End
scr_seq_D40R0107_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 249
    PlayCry VAR_MAP_LOCAL_0x0A, 0
    Message msg_0125_D40R0107_00004
    WaitCry
    CloseMessage
    SetVarFromValue VAR_RESULT, 7
    CompareVar VAR_RESULT, 7
    GoToIf 5, _0134
    SetVarFromValue VAR_0x8004, 70
    GoTo _013A
_0134:
    SetVarFromValue VAR_0x8004, 50
_013A:
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle VAR_MAP_LOCAL_0x0A, VAR_0x8004, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteGetBattleResult VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 1, _019E
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 1, _019E
    CompareVar VAR_MAP_LOCAL_0x05, 4
    CallIf 1, _01A8
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_109
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT, 3
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND_2
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    SetFlag FLAG_HGSS_HIDE_WHIRL_ISLANDS_BOTTOM_KIMONO_GIRLS
    ClearFlag FLAG_HGSS_HIDE_DANCE_STUDIO_KIMONO_GIRLS
    ClearFlag FLAG_HGSS_UNK_241
    End
_019E:
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA
    BlackOutFromBattle
    ReleaseAll
    End
_01A8:
    SetFlag FLAG_HGSS_CAUGHT_LUGIA
    Return
scr_seq_D40R0107_005:
    LockAll
    ApplyMovement LOCALID_PLAYER, _0964
    WaitMovement
    @ HGSS: ScrCmd_805
    ApplyMovement obj_D40R0107_dancer_5, _09A8
    WaitMovement
    Message msg_0125_D40R0107_00000
    CloseMessage
    FadeScreen 4, 4, 0, COLOR_WHITE
    WaitFadeScreen
    @ HGSS: LegendCutsceneClearBellAnimBegin
    @ HGSS: LegendCutsceneClearBellRiseFromBag
    FadeScreen 4, 4, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement obj_D40R0107_dancer_5, _096C
    ApplyMovement obj_D40R0107_dancer_3, _0978
    ApplyMovement obj_D40R0107_dancer_4, _0984
    ApplyMovement obj_D40R0107_dancer, _0990
    ApplyMovement obj_D40R0107_dancer_2, _099C
    WaitMovement
    WaitTime 16, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _09A8
    ApplyMovement obj_D40R0107_dancer_3, _09A8
    ApplyMovement obj_D40R0107_dancer_4, _09A8
    ApplyMovement obj_D40R0107_dancer, _09A8
    ApplyMovement obj_D40R0107_dancer_2, _09A8
    WaitMovement
    WaitTime 16, VAR_RESULT
    StopMusic
    SetBGM SEQ_GS_E_MAIKO_MAI_sseq
    WaitTime 18, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _09B8
    ApplyMovement obj_D40R0107_dancer_3, _09B8
    ApplyMovement obj_D40R0107_dancer_4, _09B8
    ApplyMovement obj_D40R0107_dancer, _09B8
    ApplyMovement obj_D40R0107_dancer_2, _09B8
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 67, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _09B8
    ApplyMovement obj_D40R0107_dancer_3, _09B8
    ApplyMovement obj_D40R0107_dancer_4, _09B8
    ApplyMovement obj_D40R0107_dancer, _09B8
    ApplyMovement obj_D40R0107_dancer_2, _09B8
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    FadeScreen 4, 6, 1, COLOR_WHITE
    @ HGSS: LegendCutsceneWavesOrLeavesEffectBegin
    WaitFadeScreen
    WaitTime 6, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B34
    ApplyMovement obj_D40R0107_dancer_3, _0B34
    ApplyMovement obj_D40R0107_dancer_4, _0B24
    ApplyMovement obj_D40R0107_dancer, _0B1C
    ApplyMovement obj_D40R0107_dancer_2, _0B2C
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A48
    ApplyMovement obj_D40R0107_dancer_3, _0A48
    ApplyMovement obj_D40R0107_dancer_4, _0A00
    ApplyMovement obj_D40R0107_dancer, _09DC
    ApplyMovement obj_D40R0107_dancer_2, _0A24
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B1C
    ApplyMovement obj_D40R0107_dancer_3, _0B34
    ApplyMovement obj_D40R0107_dancer_4, _0B24
    ApplyMovement obj_D40R0107_dancer, _0B1C
    ApplyMovement obj_D40R0107_dancer_2, _0B2C
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _09DC
    ApplyMovement obj_D40R0107_dancer_3, _0A48
    ApplyMovement obj_D40R0107_dancer_4, _0A00
    ApplyMovement obj_D40R0107_dancer, _09DC
    ApplyMovement obj_D40R0107_dancer_2, _0A24
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 33, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B1C
    ApplyMovement obj_D40R0107_dancer_3, _0B34
    ApplyMovement obj_D40R0107_dancer_4, _0B24
    ApplyMovement obj_D40R0107_dancer, _0B1C
    ApplyMovement obj_D40R0107_dancer_2, _0B2C
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _09DC
    ApplyMovement obj_D40R0107_dancer_3, _0AF0
    ApplyMovement obj_D40R0107_dancer_4, _0A98
    ApplyMovement obj_D40R0107_dancer, _0A6C
    ApplyMovement obj_D40R0107_dancer_2, _0AC4
    WaitTime 15, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B2C
    ApplyMovement obj_D40R0107_dancer_3, _0B1C
    ApplyMovement obj_D40R0107_dancer_4, _0B34
    ApplyMovement obj_D40R0107_dancer, _0B2C
    ApplyMovement obj_D40R0107_dancer_2, _0B24
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A24
    ApplyMovement obj_D40R0107_dancer_3, _09DC
    ApplyMovement obj_D40R0107_dancer_4, _0A48
    ApplyMovement obj_D40R0107_dancer, _0A24
    ApplyMovement obj_D40R0107_dancer_2, _0A00
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    @ HGSS: LegendCutsceneWavesOrLeavesEffectEnd
    @ HGSS: LegendCutscenePanCameraTo 0
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B2C
    ApplyMovement obj_D40R0107_dancer_3, _0B1C
    ApplyMovement obj_D40R0107_dancer_4, _0B34
    ApplyMovement obj_D40R0107_dancer, _0B2C
    ApplyMovement obj_D40R0107_dancer_2, _0B24
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A24
    ApplyMovement obj_D40R0107_dancer_3, _09DC
    ApplyMovement obj_D40R0107_dancer_4, _0A48
    ApplyMovement obj_D40R0107_dancer, _0A24
    ApplyMovement obj_D40R0107_dancer_2, _0A00
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 29, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B24
    ApplyMovement obj_D40R0107_dancer_3, _0B1C
    ApplyMovement obj_D40R0107_dancer_4, _0B34
    ApplyMovement obj_D40R0107_dancer, _0B2C
    ApplyMovement obj_D40R0107_dancer_2, _0B24
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A00
    ApplyMovement obj_D40R0107_dancer_3, _0A6C
    ApplyMovement obj_D40R0107_dancer_4, _0AF0
    ApplyMovement obj_D40R0107_dancer, _0AC4
    ApplyMovement obj_D40R0107_dancer_2, _0A98
    WaitTime 15, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 41, VAR_RESULT
    @ HGSS: LegendCutsceneWaitCameraPan
    WaitTime 16, VAR_RESULT
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: LegendCutsceneMoveCameraTo 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ApplyMovement obj_D40R0107_dancer_5, _0A00
    ApplyMovement obj_D40R0107_dancer_3, _0A24
    ApplyMovement obj_D40R0107_dancer_4, _09DC
    ApplyMovement obj_D40R0107_dancer, _0A00
    ApplyMovement obj_D40R0107_dancer_2, _0A48
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B24
    ApplyMovement obj_D40R0107_dancer_3, _0B2C
    ApplyMovement obj_D40R0107_dancer_4, _0B1C
    ApplyMovement obj_D40R0107_dancer, _0B24
    ApplyMovement obj_D40R0107_dancer_2, _0B34
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A00
    ApplyMovement obj_D40R0107_dancer_3, _0A24
    ApplyMovement obj_D40R0107_dancer_4, _09DC
    ApplyMovement obj_D40R0107_dancer, _0A00
    ApplyMovement obj_D40R0107_dancer_2, _0A48
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 29, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B34
    ApplyMovement obj_D40R0107_dancer_3, _0B2C
    ApplyMovement obj_D40R0107_dancer_4, _0B1C
    ApplyMovement obj_D40R0107_dancer, _0B24
    ApplyMovement obj_D40R0107_dancer_2, _0B34
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: LegendCutsceneMoveCameraTo 2
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A48
    ApplyMovement obj_D40R0107_dancer_3, _0A24
    ApplyMovement obj_D40R0107_dancer_4, _09DC
    ApplyMovement obj_D40R0107_dancer, _0A00
    ApplyMovement obj_D40R0107_dancer_2, _0A48
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B34
    ApplyMovement obj_D40R0107_dancer_3, _0B2C
    ApplyMovement obj_D40R0107_dancer_4, _0B1C
    ApplyMovement obj_D40R0107_dancer, _0B24
    ApplyMovement obj_D40R0107_dancer_2, _0B34
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A48
    ApplyMovement obj_D40R0107_dancer_3, _0A24
    ApplyMovement obj_D40R0107_dancer_4, _09DC
    ApplyMovement obj_D40R0107_dancer, _0A00
    ApplyMovement obj_D40R0107_dancer_2, _0A48
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 38, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B1C
    ApplyMovement obj_D40R0107_dancer_3, _0B24
    ApplyMovement obj_D40R0107_dancer_4, _0B2C
    ApplyMovement obj_D40R0107_dancer, _0B34
    ApplyMovement obj_D40R0107_dancer_2, _0B1C
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _09DC
    ApplyMovement obj_D40R0107_dancer_3, _0A00
    ApplyMovement obj_D40R0107_dancer_4, _0A24
    ApplyMovement obj_D40R0107_dancer, _0A48
    ApplyMovement obj_D40R0107_dancer_2, _09DC
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    @ HGSS: LegendCutscenePanCameraTo 1
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B1C
    ApplyMovement obj_D40R0107_dancer_3, _0B24
    ApplyMovement obj_D40R0107_dancer_4, _0B2C
    ApplyMovement obj_D40R0107_dancer, _0B34
    ApplyMovement obj_D40R0107_dancer_2, _0B1C
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _09DC
    ApplyMovement obj_D40R0107_dancer_3, _0A00
    ApplyMovement obj_D40R0107_dancer_4, _0A24
    ApplyMovement obj_D40R0107_dancer, _0A48
    ApplyMovement obj_D40R0107_dancer_2, _09DC
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    FadeOutBGM 0, 100
    StopMusic
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D40R0107_dancer_5, _0B2C
    ApplyMovement obj_D40R0107_dancer_3, _0B24
    ApplyMovement obj_D40R0107_dancer_4, _0B2C
    ApplyMovement obj_D40R0107_dancer, _0B34
    ApplyMovement obj_D40R0107_dancer_2, _0B1C
    WaitMovement
    ApplyMovement obj_D40R0107_dancer_5, _0A24
    ApplyMovement obj_D40R0107_dancer_3, _0A00
    ApplyMovement obj_D40R0107_dancer_4, _0A24
    ApplyMovement obj_D40R0107_dancer, _0A48
    ApplyMovement obj_D40R0107_dancer_2, _09DC
    WaitTime 12, VAR_RESULT
    WaitMovement
    @ HGSS: LegendCutsceneWaitCameraPan
    WaitTime 32, VAR_RESULT
    SetBGM SEQ_GS_E_LUGIA_sseq
    WaitTime 48, VAR_RESULT
    CompleteScreenShake 3, 3, 15, 5
    WaitTime 10, VAR_RESULT
    WaitTime 70, VAR_RESULT
    @ HGSS: LegendCutsceneLugiaEyeGlimmerEffect
    WaitTime 26, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellAnimEnd
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 123
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_HIDE_WHIRL_ISLAND_LUGIA
    AddObject obj_D40R0107_lug_obj01
    ShowObject obj_D40R0107_lug_obj01
    AddObject obj_D40R0107_stop
    AddObject obj_D40R0107_stop_2
    AddObject obj_D40R0107_stop_3
    AddObject obj_D40R0107_stop_4
    AddObject obj_D40R0107_stop_5
    ReleaseObject obj_D40R0107_dancer_5
    ReleaseObject obj_D40R0107_dancer_3
    ReleaseObject obj_D40R0107_dancer_4
    ReleaseObject obj_D40R0107_dancer
    ReleaseObject obj_D40R0107_dancer_2
    SetPosition obj_D40R0107_dancer_5, 16, 1, 33, DIR_NORTH
    SetPosition obj_D40R0107_dancer_3, 13, 1, 33, DIR_NORTH
    SetPosition obj_D40R0107_dancer_4, 13, 1, 27, DIR_NORTH
    SetPosition obj_D40R0107_dancer, 19, 1, 33, DIR_NORTH
    SetPosition obj_D40R0107_dancer_2, 19, 1, 27, DIR_NORTH
    @ HGSS: Cinematic 1
    @ HGSS: LegendCutsceneLugiaArrivesEffectBegin
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 59, VAR_RESULT
    @ HGSS: LegendCutsceneBirdFinalApproach
    StopMusic
    @ HGSS: LegendCutsceneLugiaArrivesEffectCameraPan
    @ HGSS: LegendCutsceneLugiaArrivesEffectEnd
    WaitTime 16, VAR_RESULT
    @ HGSS: ProcessSoundplate
    ApplyMovement obj_D40R0107_dancer_5, _0B3C
    WaitMovement
    BufferPlayerName 0
    Message msg_0125_D40R0107_00002
    CloseMessage
    ApplyMovement obj_D40R0107_dancer_5, _09A8
    WaitMovement
    BufferPlayerName 0
    Message msg_0125_D40R0107_00003
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_10B
    SetVarFromValue VAR_HGSS_UNK_40FA, 2
    End
    .balign 4, 0
_0964:
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
_096C:
    Delay8 6
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0978:
    Delay8 5
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_0984:
    WalkNormalWest
    WalkNormalNorth 6
    EndMovement
    .balign 4, 0
_0990:
    Delay8 5
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_099C:
    WalkNormalEast
    WalkNormalNorth 6
    EndMovement
    .balign 4, 0
_09A8:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_09B8:
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_09DC:
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    Delay2
    EndMovement
    .balign 4, 0
_0A00:
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_0A24:
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    EndMovement
    .balign 4, 0
_0A48:
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    EndMovement
    .balign 4, 0
_0A6C:
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    EndMovement
    .balign 4, 0
_0A98:
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    EndMovement
    .balign 4, 0
_0AC4:
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_0AF0:
    FaceNorth
    Delay2
    FaceWest
    Delay2
    FaceSouth
    Delay2
    FaceEast
    Delay2
    FaceNorth
    Delay2
    EndMovement
    .balign 4, 0
_0B1C:
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
_0B24:
    WalkSlowSouth 2
    EndMovement
    .balign 4, 0
_0B2C:
    WalkSlowWest 2
    EndMovement
    .balign 4, 0
_0B34:
    WalkSlowEast 2
    EndMovement
    .balign 4, 0
_0B3C:
    WalkSlowNorth
    EndMovement
scr_seq_D40R0107_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_109, _0B62
    Message msg_0125_D40R0107_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0B62:
    CompareVar VAR_MAP_LOCAL_0x05, 5
    GoToIf 5, _0B78
    Message msg_0125_D40R0107_00008
    GoTo _0BA7
_0B78:
    CompareVar VAR_MAP_LOCAL_0x05, 6
    GoToIf 5, _0B8E
    Message msg_0125_D40R0107_00008
    GoTo _0BA7
_0B8E:
    CompareVar VAR_MAP_LOCAL_0x05, 4
    GoToIf 5, _0BA4
    Message msg_0125_D40R0107_00006
    GoTo _0BA7
_0BA4:
    Message msg_0125_D40R0107_00007
_0BA7:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D40R0107_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_109, _0BCD
    Message msg_0125_D40R0107_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0BCD:
    Message msg_0125_D40R0107_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
