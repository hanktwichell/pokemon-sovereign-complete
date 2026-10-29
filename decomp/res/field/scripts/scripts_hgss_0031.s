#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0067.h"

#define obj_D23R0103_babyboy1_9 7
#define obj_D23R0103_babyboy1_9_2 8

    ScriptEntry scr_seq_D23R0103_000
    ScriptEntry scr_seq_D23R0103_001
    ScriptEntry scr_seq_D23R0103_002
    ScriptEntry scr_seq_D23R0103_003
    ScriptEntry scr_seq_D23R0103_004
    ScriptEntry scr_seq_D23R0103_005
    ScriptEntry scr_seq_D23R0103_006
    ScriptEntry scr_seq_D23R0103_007
    ScriptEntryEnd
scr_seq_D23R0103_000:
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    SetFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0041
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_1
    GoTo _0052
_0041:
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 5
    GoToIf 5, _0052
    ClearFlag FLAG_HGSS_HIDE_ROCKET_TAKEOVER_2
_0052:
    End
scr_seq_D23R0103_001:
    NPCMessage msg_0067_D23R0103_00015
    End
scr_seq_D23R0103_002:
    NPCMessage msg_0067_D23R0103_00016
    End
scr_seq_D23R0103_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _0098
    Message msg_0067_D23R0103_00001
    GoTo _009B
_0098:
    Message msg_0067_D23R0103_00002
_009B:
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0103_004:
    NPCMessage msg_0067_D23R0103_00000
    End
scr_seq_D23R0103_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    CompareVar VAR_HGSS_SCENE_ROCKET_TAKEOVER, 4
    GoToIf 5, _00E7
    GetItemQuantity ITEM_BASEMENT_KEY, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _00F5
    Message msg_0067_D23R0103_00003
    GoTo _00ED
_00E7:
    GoTo _0100
_00ED:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00F5:
    Message msg_0067_D23R0103_00004
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0100:
    GoToIfSet FLAG_HGSS_GOT_TM11_FROM_RADIO_TOWER_WOMAN, _014D
    Message msg_0067_D23R0103_00005
    SetVar VAR_0x8004, ITEM_TM11
    SetVar VAR_0x8005, 1
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    GoToIfEq VAR_RESULT, 0, _0142
    Common_GiveItemQuantity
    Message msg_0067_D23R0103_00007
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_GOT_TM11_FROM_RADIO_TOWER_WOMAN
    End
_0142:
    Message msg_0067_D23R0103_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_014D:
    Message msg_0067_D23R0103_00009
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0103_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GetItemQuantity ITEM_CARD_KEY, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01B4
    Message msg_0067_D23R0103_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D23R0103_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_090, _01E2
    Message msg_0067_D23R0103_00011
    CloseMessage
    GetItemQuantity ITEM_CARD_KEY, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _01B4
    Message msg_0067_D23R0103_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_01B4:
    BufferPlayerName 0
    Message msg_0067_D23R0103_00012
    CloseMessage
    ApplyMovement obj_D23R0103_babyboy1_9, _01F0
    ApplyMovement obj_D23R0103_babyboy1_9_2, _01F8
    WaitMovement
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_1BF
    RemoveObject obj_D23R0103_babyboy1_9
    RemoveObject obj_D23R0103_babyboy1_9_2
    SetFlag FLAG_HGSS_UNK_090
    End
_01E2:
    Message msg_0067_D23R0103_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_01F0:
    WalkNormalWest 2
    EndMovement
    .balign 4, 0
_01F8:
    WalkNormalEast 2
    EndMovement
    .balign 4, 0
