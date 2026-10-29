#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0557.h"

#define obj_T22FS0101_assistantm 4

    ScriptEntry scr_seq_T22FS0101_000
    ScriptEntry scr_seq_T22FS0101_001
    ScriptEntry scr_seq_T22FS0101_002
    ScriptEntry scr_seq_T22FS0101_003
    ScriptEntry scr_seq_T22FS0101_004
    ScriptEntryEnd
scr_seq_T22FS0101_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 1
    @ HGSS: CallStd std_pokemart
    ReleaseAll
    End
scr_seq_T22FS0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 1
    @ HGSS: CallStd std_special_mart
    ReleaseAll
    End
scr_seq_T22FS0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_06F, _0115
    BufferPlayerName 0
    MessageGendered msg_0557_T22FS0101_00002, msg_0557_T22FS0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F7
_007D:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0106
    @ HGSS: GiveTogepiEgg
    SetFlag FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT
    BufferPlayerName 0
    Message msg_0557_T22FS0101_00004
    WaitFanfare
    MessageGendered msg_0557_T22FS0101_00005, msg_0557_T22FS0101_00006
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _00C5
    ApplyMovement obj_T22FS0101_assistantm, _014C
    GoTo _00CD
_00C5:
    ApplyMovement obj_T22FS0101_assistantm, _0140
_00CD:
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    RemoveObject obj_T22FS0101_assistantm
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    SetFlag FLAG_HGSS_HIDE_VIOLET_SHOP_LAB_AIDE
    ReleaseAll
    SetVarFromValue VAR_HGSS_SCENE_VIOLET_CITY_OW, 3
    ClearFlag FLAG_HGSS_HIDE_VIOLET_KIMONO_GIRL
    ClearFlag FLAG_HGSS_HIDE_ELMS_LAB_AIDE
    SetVarFromValue VAR_HGSS_SCENE_ELMS_LAB, 7
    End
_00F7:
    Message msg_0557_T22FS0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_06F
    End
_0106:
    Message msg_0557_T22FS0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_06F
    End
_0115:
    BufferPlayerName 0
    MessageGendered msg_0557_T22FS0101_00009, msg_0557_T22FS0101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _007D
    CompareVar VAR_RESULT, 1
    GoToIf 1, _00F7
    End
    .balign 4, 0
_0140:
    WalkNormalWest 2
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
_014C:
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth
    EndMovement
scr_seq_T22FS0101_003:
    NPCMessage msg_0557_T22FS0101_00000
    End
scr_seq_T22FS0101_004:
    NPCMessage msg_0557_T22FS0101_00001
    End
    .balign 4, 0
