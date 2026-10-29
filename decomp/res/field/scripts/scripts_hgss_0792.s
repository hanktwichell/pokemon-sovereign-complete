#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0497.h"

#define obj_T07R0104_gsleader1 3
#define obj_T07R0104_gsleader13 4

    ScriptEntry scr_seq_T07R0104_000
    ScriptEntry scr_seq_T07R0104_001
    ScriptEntry scr_seq_T07R0104_002
    ScriptEntry scr_seq_T07R0104_003
    ScriptEntry scr_seq_T07R0104_004
    ScriptEntry scr_seq_T07R0104_005
    ScriptEntry scr_seq_T07R0104_006
    ScriptEntryEnd
scr_seq_T07R0104_004:
    GoToIfUnset FLAG_HGSS_UNK_189, _00D3
    ClearFlag FLAG_HGSS_UNK_189
    End
scr_seq_T07R0104_005:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _00FF
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 5, _0168
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0497_T07R0104_00009
    GoTo _01DB
scr_seq_T07R0104_006:
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 5, _0168
    NPCMessage msg_0497_T07R0104_00015
    End
scr_seq_T07R0104_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 21
    AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00
    PokeMartSpecialties VAR_0x8004
    ReleaseAll
    End
scr_seq_T07R0104_001:
    NPCMessage msg_0497_T07R0104_00016
    End
scr_seq_T07R0104_002:
    NPCMessage msg_0497_T07R0104_00017
    End
scr_seq_T07R0104_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0497_T07R0104_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00D3:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01FF
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0237
    GoTo _0256
_00FF:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0497_T07R0104_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0260
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _026B
    Message msg_0497_T07R0104_00011
    CloseMessage
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 2
    FacePlayer
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    Message msg_0497_T07R0104_00012
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0168:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    ApplyMovement obj_T07R0104_gsleader1, _02E1
    WaitMovement
    Message msg_0497_T07R0104_00000
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader13, _02E7
    WaitMovement
    Message msg_0497_T07R0104_00001
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader1, _02E1
    WaitMovement
    Message msg_0497_T07R0104_00002
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader13, _02E7
    WaitMovement
    Message msg_0497_T07R0104_00003
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader1, _02ED
    WaitMovement
    Message msg_0497_T07R0104_00004
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0276
    CompareVar VAR_RESULT, 1
    GoToIf 4, _02C0
    End
_01DB:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0276
    CompareVar VAR_RESULT, 1
    GoToIf 4, _02C0
    End
_01FF:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _0256
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _02D1
    ClearFlag FLAG_HGSS_UNK_260
    SetFlag FLAG_HGSS_UNK_2E2
    SetObjectEventDir obj_T07R0104_gsleader1, DIR_SOUTH
    GoTo _02D7
_0237:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _02D9
    ClearFlag FLAG_HGSS_UNK_260
    ClearFlag FLAG_HGSS_UNK_2E2
    GoTo _02DF
_0256:
    SetFlag FLAG_HGSS_UNK_260
    SetFlag FLAG_HGSS_UNK_2E2
    End
_0260:
    Message msg_0497_T07R0104_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_026B:
    Message msg_0497_T07R0104_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0276:
    Message msg_0497_T07R0104_00005
    @ HGSS: RegisterGearNumber PHONE_CONTACT_FALKNER
    BufferPlayerName 0
    Message msg_0497_T07R0104_00006
    PlayFanfare SEQ_FANFA4_sseq
    WaitFanfare
    Message msg_0497_T07R0104_00007
    WaitButton
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    SetFlag FLAG_HGSS_UNK_260
    RemoveObject obj_T07R0104_gsleader1
    RemoveObject obj_T07R0104_gsleader13
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    WaitSE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_02C0:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0497_T07R0104_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_02D1:
    GoTo _0256
_02D7:
    End
_02D9:
    GoTo _0256
_02DF:
    End
    .balign 4, 0
_02E1:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_02E7:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_02ED:
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
