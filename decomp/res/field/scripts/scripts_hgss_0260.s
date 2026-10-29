#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0407.h"

#define obj_R47_leader3 5

    ScriptEntry scr_seq_R47_000
    ScriptEntry scr_seq_R47_001
    ScriptEntry scr_seq_R47_002
    ScriptEntry scr_seq_R47_003
    ScriptEntry scr_seq_R47_004
    ScriptEntryEnd
scr_seq_R47_000:
    SetVarFromValue VAR_HGSS_UNK_40EB, 1
    SetFlag FLAG_HGSS_UNK_9C9
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _004F
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 389
    SetWarpEventPos 6, 87, 385
    GoTo _0067
_004F:
    SetWarpEventPos 4, 87, 389
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 385
_0067:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 2
    GoToIf 1, _00E6
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 3
    GoToIf 1, _00E6
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoToIf 4, _00EC
    GoToIfUnset FLAG_HGSS_UNK_189, _009F
    ClearFlag FLAG_HGSS_UNK_189
    End
_009F:
    GoToIfSet FLAG_HGSS_GAME_CLEAR, _00B2
    GoTo _00E6
    End
_00B2:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_CHUCK, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00E6
    GetDayOfWeek VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 0
    GoToIf 5, _00E0
    ClearFlag FLAG_HGSS_HIDE_ROUTE_47_CHUCK
    GoTo _00E4
_00E0:
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_CHUCK
_00E4:
    End
_00E6:
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_CHUCK
    End
_00EC:
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 389
    GoTo _00E6
    End
scr_seq_R47_002:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 5
    GoToIf 4, _0162
    GetGameVersion VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _0148
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 389
    SetWarpEventPos 6, 87, 385
    GoTo _0160
_0148:
    SetWarpEventPos 4, 87, 389
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 385
_0160:
    End
_0162:
    SetWarpEventPos 4, 87, 385
    SetWarpEventPos 5, 87, 385
    SetWarpEventPos 6, 87, 389
    End
scr_seq_R47_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_MET_ROUTE_47_EMBEDDED_TOWER_HIKER, _019E
    Message msg_0407_R47_00000
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_MET_ROUTE_47_EMBEDDED_TOWER_HIKER
    ReleaseAll
    End
_019E:
    Message msg_0407_R47_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_R47_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_157, _0210
    Message msg_0407_R47_00002
    ApplyMovement obj_R47_leader3, _022C
    WaitMovement
    Message msg_0407_R47_00003
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01EB
    ApplyMovement obj_R47_leader3, _0234
    GoTo _020E
_01EB:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0206
    ApplyMovement obj_R47_leader3, _023C
    GoTo _020E
_0206:
    ApplyMovement obj_R47_leader3, _0244
_020E:
    WaitMovement
_0210:
    BufferPlayerName 0
    Message msg_0407_R47_00004
    CloseMessage
    ApplyMovement obj_R47_leader3, _022C
    WaitMovement
    SetFlag FLAG_HGSS_UNK_157
    ReleaseAll
    End
    .balign 4, 0
_022C:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0234:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_023C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0244:
    WalkOnSpotNormalEast
    EndMovement
scr_seq_R47_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0407_R47_00005
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02B5
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _02C0
    Message msg_0407_R47_00006
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 91
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0407_R47_00007
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02B5:
    Message msg_0407_R47_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02C0:
    Message msg_0407_R47_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
