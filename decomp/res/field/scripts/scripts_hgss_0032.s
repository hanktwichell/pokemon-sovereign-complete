#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0068.h"

#define obj_D23R0104_rocketw 2
#define obj_D23R0104_kurumi 4
#define obj_D23R0104_tsure_poke_static_meowth 5
#define obj_D23R0104_gsman2 7

    ScriptEntry scr_seq_D23R0104_000
    ScriptEntry scr_seq_D23R0104_001
    ScriptEntry scr_seq_D23R0104_002
    ScriptEntry scr_seq_D23R0104_003
    ScriptEntry scr_seq_D23R0104_004
    ScriptEntry scr_seq_D23R0104_005
    ScriptEntry scr_seq_D23R0104_006
    ScriptEntry scr_seq_D23R0104_007
    ScriptEntry scr_seq_D23R0104_008
    ScriptEntryEnd
scr_seq_D23R0104_000:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0045
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    GoTo _0056
_0045:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    GoToIf 5, _0056
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
_0056:
    End
scr_seq_D23R0104_008:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0089
    SetPosition obj_D23R0104_kurumi, 18, 1, 12, DIR_EAST
    SetPosition obj_D23R0104_tsure_poke_static_meowth, 19, 1, 12, DIR_SOUTH
    SetPosition obj_D23R0104_gsman2, 20, 1, 12, DIR_SOUTH
_0089:
    End
scr_seq_D23R0104_001:
    NPCMessage msg_0068_D23R0104_00008
    End
scr_seq_D23R0104_002:
    NPCMessage msg_0068_D23R0104_00009
    End
scr_seq_D23R0104_003:
    NPCMessage msg_0068_D23R0104_00000
    End
scr_seq_D23R0104_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _00E2
    Message msg_0068_D23R0104_00001
    GoTo _00E8
_00E2:
    GoTo _00F0
_00E8:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F0:
    GoToIfSet FLAG_HGSS_GOT_BRIGHTPOWDER_FROM_MARY, _013D
    Message msg_0068_D23R0104_00002
    SetVar VAR_0x8004, ITEM_BRIGHTPOWDER
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0132
    Common_GiveItemQuantity
    Message msg_0068_D23R0104_00004
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_BRIGHTPOWDER_FROM_MARY
    End
_0132:
    Message msg_0068_D23R0104_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
_013D:
    Message msg_0068_D23R0104_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0104_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_MEOWTH, 0
    Message msg_0068_D23R0104_00007
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0104_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0181
    Message msg_0068_D23R0104_00010
    GoTo _0184
_0181:
    Message msg_0068_D23R0104_00011
_0184:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0104_007:
    GoToIfDefeated TRAINER_NONE, _01F6
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0068_D23R0104_00012
    GetPlayerDir VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 2
    GoToIf 5, _01BF
    ApplyMovement obj_D23R0104_rocketw, _0210
    GoTo _01C7
_01BF:
    ApplyMovement obj_D23R0104_rocketw, _021C
_01C7:
    WaitMovement
    Message msg_0068_D23R0104_00013
    CloseMessage
    @ HGSS: TrainerBattle TRAINER_TEAM_ROCKET_F_GRUNT_4, 0, 0, 0
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0209
    SetTrainerFlag TRAINER_NONE
    Message msg_0068_D23R0104_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01F6:
    NPCMessage msg_0068_D23R0104_00014
    End
_0209:
    BlackOutFromBattle
    ReleaseAll
    End
    .balign 4, 0
_0210:
    EmoteExclamationMark
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_021C:
    EmoteExclamationMark
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
