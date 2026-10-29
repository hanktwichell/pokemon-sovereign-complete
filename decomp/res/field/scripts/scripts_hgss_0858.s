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
    PokeMartCommon
    ReleaseAll
    End
scr_seq_T22FS0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 17
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T22FS0101_002:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_UNK_06F, _00EB
    BufferPlayerName 0
    MessageGendered msg_0557_T22FS0101_00002, msg_0557_T22FS0101_00003
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0116
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0125
    CompleteGiveTogepiEgg
    SetFlag FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT
    BufferPlayerName 0
    Message msg_0557_T22FS0101_00004
    WaitFanfare
    MessageGendered msg_0557_T22FS0101_00005, msg_0557_T22FS0101_00006
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0134
    ApplyMovement obj_T22FS0101_assistantm, _01D8
    GoTo _0166
scr_seq_T22FS0101_003:
    NPCMessage msg_0557_T22FS0101_00000
    End
scr_seq_T22FS0101_004:
    NPCMessage msg_0557_T22FS0101_00001
    End
_00EB:
    BufferPlayerName 0
    MessageGendered msg_0557_T22FS0101_00009, msg_0557_T22FS0101_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0190
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0116
    End
_0116:
    Message msg_0557_T22FS0101_00008
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_06F
    End
_0125:
    Message msg_0557_T22FS0101_00007
    WaitButton
    CloseMessage
    ReleaseAll
    SetFlag FLAG_HGSS_UNK_06F
    End
_0134:
    ApplyMovement obj_T22FS0101_assistantm, _01E6
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
_0166:
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
_0190:
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 1, _0125
    CompleteGiveTogepiEgg
    SetFlag FLAG_HGSS_GOT_EGG_FROM_ELMS_ASSISTANT
    BufferPlayerName 0
    Message msg_0557_T22FS0101_00004
    WaitFanfare
    MessageGendered msg_0557_T22FS0101_00005, msg_0557_T22FS0101_00006
    CloseMessage
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0134
    ApplyMovement obj_T22FS0101_assistantm, _01D8
    GoTo _0166
    .balign 4, 0
_01D8:
    WalkNormalSouth 2
    WalkNormalWest 2
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_01E6:
    WalkNormalWest 2
    WalkNormalSouth 3
    EndMovement
    .balign 4, 0
