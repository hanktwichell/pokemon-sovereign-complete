#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0058.h"

#define obj_D17R0110_dancer 0
#define obj_D17R0110_dancer_2 1
#define obj_D17R0110_dancer_3 2
#define obj_D17R0110_dancer_4 3
#define obj_D17R0110_dancer_5 4
#define obj_D17R0110_hou_obj01 5

    ScriptEntry scr_seq_D17R0110_000
    ScriptEntry scr_seq_D17R0110_001
    ScriptEntry scr_seq_D17R0110_002
    ScriptEntry scr_seq_D17R0110_003
    ScriptEntry scr_seq_D17R0110_004
    ScriptEntry scr_seq_D17R0110_005
    ScriptEntry scr_seq_D17R0110_006
    ScriptEntryEnd
scr_seq_D17R0110_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _002B
    End
_002B:
    SetFlag FLAG_HGSS_HIDE_BELL_TOWER_HO_OH
    RemoveObject obj_D17R0110_hou_obj01
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
scr_seq_D17R0110_003:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 111
    SetFlag FLAG_HGSS_UNK_105
    End
scr_seq_D17R0110_005:
    CompareVar VAR_MAP_LOCAL_0x0B, 123
    GoToIf 5, _005C
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 0
_005C:
    GoToIfSet FLAG_HGSS_UNK_108, _00C3
    GoToIfUnset FLAG_HGSS_UNK_10A, _00C3
    CompareVar VAR_MAP_LOCAL_0x03, 111
    GoToIf 5, _00BB
    SetPosition obj_D17R0110_dancer, 16, 1, 18, DIR_NORTH
    SetPosition obj_D17R0110_dancer_2, 12, 1, 18, DIR_NORTH
    SetPosition obj_D17R0110_dancer_3, 12, 1, 12, DIR_SOUTH
    SetPosition obj_D17R0110_dancer_4, 18, 1, 18, DIR_NORTH
    SetPosition obj_D17R0110_dancer_5, 18, 1, 12, DIR_SOUTH
_00BB:
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    End
_00C3:
    End
scr_seq_D17R0110_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_MAP_LOCAL_0x0A, 250
    PlayCry VAR_MAP_LOCAL_0x0A, 0
    Message msg_0058_D17R0110_00004
    WaitCry
    CloseMessage
    GetGameVersion VAR_RESULT
    CompareVar VAR_RESULT, 7
    GoToIf 5, _00FD
    SetVarFromValue VAR_0x8004, 50
    GoTo _0103
_00FD:
    SetVarFromValue VAR_0x8004, 70
_0103:
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle VAR_MAP_LOCAL_0x0A, VAR_0x8004, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteGetBattleResult VAR_MAP_LOCAL_0x05
    CompareVar VAR_MAP_LOCAL_0x05, 2
    GoToIf 1, _0167
    CompareVar VAR_MAP_LOCAL_0x05, 3
    GoToIf 1, _0167
    CompareVar VAR_MAP_LOCAL_0x05, 4
    CallIf 1, _0171
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_108
    SetVarFromValue VAR_HGSS_SCENE_NEW_BARK_EAST_EXIT, 3
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_MARILL
    SetFlag FLAG_HGSS_HIDE_NEW_BARK_FRIEND_2
    ClearFlag FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND
    SetFlag FLAG_HGSS_HIDE_BELL_TOWER_SUMMIT_KIMONO_GIRLS
    ClearFlag FLAG_HGSS_HIDE_DANCE_STUDIO_KIMONO_GIRLS
    ClearFlag FLAG_HGSS_UNK_241
    End
_0167:
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_HO_OH
    BlackOutFromBattle
    ReleaseAll
    End
_0171:
    SetFlag FLAG_HGSS_CAUGHT_HO_OH
    Return
scr_seq_D17R0110_006:
    LockAll
    @ HGSS: ScrCmd_805
    ApplyMovement obj_D17R0110_dancer, _0790
    WaitMovement
    Message msg_0058_D17R0110_00000
    CloseMessage
    FadeScreen 4, 4, 0, COLOR_WHITE
    WaitFadeScreen
    @ HGSS: LegendCutsceneClearBellAnimBegin
    @ HGSS: LegendCutsceneClearBellRiseFromBag
    FadeScreen 4, 4, 1, COLOR_WHITE
    WaitFadeScreen
    ApplyMovement obj_D17R0110_dancer, _0754
    ApplyMovement obj_D17R0110_dancer_2, _0760
    ApplyMovement obj_D17R0110_dancer_3, _076C
    ApplyMovement obj_D17R0110_dancer_4, _0778
    ApplyMovement obj_D17R0110_dancer_5, _0784
    WaitMovement
    WaitTime 16, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _0790
    ApplyMovement obj_D17R0110_dancer_2, _0790
    ApplyMovement obj_D17R0110_dancer_3, _0790
    ApplyMovement obj_D17R0110_dancer_4, _0790
    ApplyMovement obj_D17R0110_dancer_5, _0790
    WaitMovement
    WaitTime 16, VAR_RESULT
    StopMusic
    @ HGSS: TempBGM SEQ_GS_E_MAIKO_MAI
    WaitTime 18, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _07A0
    ApplyMovement obj_D17R0110_dancer_2, _07A0
    ApplyMovement obj_D17R0110_dancer_3, _07A0
    ApplyMovement obj_D17R0110_dancer_4, _07A0
    ApplyMovement obj_D17R0110_dancer_5, _07A0
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 67, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _07A0
    ApplyMovement obj_D17R0110_dancer_2, _07A0
    ApplyMovement obj_D17R0110_dancer_3, _07A0
    ApplyMovement obj_D17R0110_dancer_4, _07A0
    ApplyMovement obj_D17R0110_dancer_5, _07A0
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    FadeScreen 4, 6, 1, COLOR_WHITE
    @ HGSS: LegendCutsceneWavesOrLeavesEffectBegin
    WaitFadeScreen
    WaitTime 4, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _0914
    ApplyMovement obj_D17R0110_dancer_2, _0904
    ApplyMovement obj_D17R0110_dancer_3, _091C
    ApplyMovement obj_D17R0110_dancer_4, _0914
    ApplyMovement obj_D17R0110_dancer_5, _090C
    WaitMovement
    ApplyMovement obj_D17R0110_dancer, _080C
    ApplyMovement obj_D17R0110_dancer_2, _07C4
    ApplyMovement obj_D17R0110_dancer_3, _0830
    ApplyMovement obj_D17R0110_dancer_4, _080C
    ApplyMovement obj_D17R0110_dancer_5, _07E8
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _0904
    ApplyMovement obj_D17R0110_dancer_2, _0904
    ApplyMovement obj_D17R0110_dancer_3, _091C
    ApplyMovement obj_D17R0110_dancer_4, _0914
    ApplyMovement obj_D17R0110_dancer_5, _090C
    WaitMovement
    ApplyMovement obj_D17R0110_dancer, _07C4
    ApplyMovement obj_D17R0110_dancer_2, _07C4
    ApplyMovement obj_D17R0110_dancer_3, _0830
    ApplyMovement obj_D17R0110_dancer_4, _080C
    ApplyMovement obj_D17R0110_dancer_5, _07E8
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 33, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _0904
    ApplyMovement obj_D17R0110_dancer_2, _0904
    ApplyMovement obj_D17R0110_dancer_3, _091C
    ApplyMovement obj_D17R0110_dancer_4, _0914
    ApplyMovement obj_D17R0110_dancer_5, _090C
    WaitMovement
    ApplyMovement obj_D17R0110_dancer, _07C4
    ApplyMovement obj_D17R0110_dancer_2, _0854
    ApplyMovement obj_D17R0110_dancer_3, _08D8
    ApplyMovement obj_D17R0110_dancer_4, _08AC
    ApplyMovement obj_D17R0110_dancer_5, _0880
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _091C
    ApplyMovement obj_D17R0110_dancer_2, _091C
    ApplyMovement obj_D17R0110_dancer_3, _090C
    ApplyMovement obj_D17R0110_dancer_4, _0904
    ApplyMovement obj_D17R0110_dancer_5, _0914
    WaitMovement
    ApplyMovement obj_D17R0110_dancer, _0830
    ApplyMovement obj_D17R0110_dancer_2, _0830
    ApplyMovement obj_D17R0110_dancer_3, _07E8
    ApplyMovement obj_D17R0110_dancer_4, _07C4
    ApplyMovement obj_D17R0110_dancer_5, _080C
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 1
    WaitMovement
    @ HGSS: LegendCutsceneWavesOrLeavesEffectEnd
    @ HGSS: LegendCutscenePanCameraTo 0
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _091C
    ApplyMovement obj_D17R0110_dancer_2, _091C
    ApplyMovement obj_D17R0110_dancer_3, _090C
    ApplyMovement obj_D17R0110_dancer_4, _0904
    ApplyMovement obj_D17R0110_dancer_5, _0914
    WaitMovement
    ApplyMovement obj_D17R0110_dancer, _0830
    ApplyMovement obj_D17R0110_dancer_2, _0830
    ApplyMovement obj_D17R0110_dancer_3, _07E8
    ApplyMovement obj_D17R0110_dancer_4, _07C4
    ApplyMovement obj_D17R0110_dancer_5, _080C
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 32, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _090C
    ApplyMovement obj_D17R0110_dancer_2, _091C
    ApplyMovement obj_D17R0110_dancer_3, _090C
    ApplyMovement obj_D17R0110_dancer_4, _0904
    ApplyMovement obj_D17R0110_dancer_5, _0914
    WaitMovement
    ApplyMovement obj_D17R0110_dancer, _07E8
    ApplyMovement obj_D17R0110_dancer_2, _0830
    ApplyMovement obj_D17R0110_dancer_3, _07E8
    ApplyMovement obj_D17R0110_dancer_4, _07C4
    ApplyMovement obj_D17R0110_dancer_5, _080C
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 41, VAR_RESULT
    @ HGSS: LegendCutsceneWaitCameraPan
    WaitTime 8, VAR_RESULT
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: LegendCutsceneMoveCameraTo 1
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 20, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    ReleaseObject obj_D17R0110_dancer
    ReleaseObject obj_D17R0110_dancer_2
    ReleaseObject obj_D17R0110_dancer_3
    ReleaseObject obj_D17R0110_dancer_4
    ReleaseObject obj_D17R0110_dancer_5
    SetPosition obj_D17R0110_dancer, 15, 1, 18, DIR_NORTH
    SetPosition obj_D17R0110_dancer_2, 12, 1, 18, DIR_NORTH
    SetPosition obj_D17R0110_dancer_3, 12, 1, 12, DIR_SOUTH
    SetPosition obj_D17R0110_dancer_4, 18, 1, 18, DIR_NORTH
    SetPosition obj_D17R0110_dancer_5, 18, 1, 12, DIR_SOUTH
    WaitTime 86, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitTime 32, VAR_RESULT
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: LegendCutsceneMoveCameraTo 2
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 22, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _07C4
    ApplyMovement obj_D17R0110_dancer_2, _07C4
    ApplyMovement obj_D17R0110_dancer_3, _07E8
    ApplyMovement obj_D17R0110_dancer_4, _07C4
    ApplyMovement obj_D17R0110_dancer_5, _07E8
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 32, VAR_RESULT
    WaitTime 34, VAR_RESULT
    ApplyMovement obj_D17R0110_dancer, _07C4
    ApplyMovement obj_D17R0110_dancer_2, _07C4
    ApplyMovement obj_D17R0110_dancer_3, _07E8
    ApplyMovement obj_D17R0110_dancer_4, _07C4
    ApplyMovement obj_D17R0110_dancer_5, _07E8
    WaitTime 12, VAR_RESULT
    @ HGSS: LegendCutsceneClearBellShimmer 0
    WaitMovement
    WaitTime 60, VAR_RESULT
    @ HGSS: LegendCutscenePanCameraTo 1
    @ HGSS: LegendCutsceneWaitCameraPan
    StopMusic
    @ HGSS: LegendCutsceneClearBellAnimEnd
    SetVarFromValue VAR_MAP_LOCAL_0x0B, 123
    FadeScreen 6, 1, 0, COLOR_WHITE
    WaitFadeScreen
    @ HGSS: Cinematic 0
    ClearFlag FLAG_HGSS_HIDE_BELL_TOWER_HO_OH
    AddObject obj_D17R0110_hou_obj01
    ShowObject obj_D17R0110_hou_obj01
    WaitTime 6, VAR_RESULT
    FadeScreen 6, 1, 1, COLOR_WHITE
    WaitFadeScreen
    WaitTime 20, VAR_RESULT
    @ HGSS: LegendCutsceneBirdFinalApproach
    StopMusic
    ApplyMovement obj_D17R0110_dancer, _0798
    WaitMovement
    @ HGSS: ProcessSoundplate
    BufferPlayerName 0
    Message msg_0058_D17R0110_00002
    CloseMessage
    ApplyMovement obj_D17R0110_dancer, _0790
    WaitMovement
    BufferPlayerName 0
    Message msg_0058_D17R0110_00003
    CloseMessage
    ApplyMovement obj_D17R0110_dancer, _092C
    WaitMovement
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_10A
    SetVarFromValue VAR_HGSS_UNK_40FA, 2
    End
scr_seq_D17R0110_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _0704
    Message msg_0058_D17R0110_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0704:
    CompareVar VAR_MAP_LOCAL_0x05, 5
    GoToIf 5, _071A
    Message msg_0058_D17R0110_00008
    GoTo _0749
_071A:
    CompareVar VAR_MAP_LOCAL_0x05, 6
    GoToIf 5, _0730
    Message msg_0058_D17R0110_00008
    GoTo _0749
_0730:
    CompareVar VAR_MAP_LOCAL_0x05, 4
    GoToIf 5, _0746
    Message msg_0058_D17R0110_00006
    GoTo _0749
_0746:
    Message msg_0058_D17R0110_00007
_0749:
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0754:
    Delay8 6
    WalkNormalNorth
    EndMovement
    .balign 4, 0
_0760:
    Delay8 5
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_076C:
    WalkNormalWest
    WalkNormalNorth 6
    EndMovement
    .balign 4, 0
_0778:
    Delay8 5
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
_0784:
    WalkNormalEast
    WalkNormalNorth 6
    EndMovement
    .balign 4, 0
_0790:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0798:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_07A0:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_07C4:
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    EndMovement
    .balign 4, 0
_07E8:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_080C:
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    EndMovement
    .balign 4, 0
_0830:
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    EndMovement
    .balign 4, 0
_0854:
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    EndMovement
    .balign 4, 0
_0880:
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    EndMovement
    .balign 4, 0
_08AC:
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    EndMovement
    .balign 4, 0
_08D8:
    FaceSouth
    Delay2
    FaceWest
    Delay2
    FaceNorth
    Delay2
    FaceEast
    Delay2
    FaceSouth
    Delay2
    EndMovement
    .balign 4, 0
_0904:
    WalkSlowNorth 2
    EndMovement
    .balign 4, 0
_090C:
    WalkSlowSouth 2
    EndMovement
    .balign 4, 0
_0914:
    WalkSlowWest 2
    EndMovement
    .balign 4, 0
_091C:
    WalkSlowEast 2
    EndMovement
    .balign 4, 0
    WalkSlowSouth
    EndMovement
    .balign 4, 0
_092C:
    FaceWest
    LockDir
    WalkSlowEast
    UnlockDir
    EndMovement
scr_seq_D17R0110_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_108, _095E
    Message msg_0058_D17R0110_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_095E:
    Message msg_0058_D17R0110_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
