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
    GoToIfUnset FLAG_HGSS_UNK_189, _002F
    ClearFlag FLAG_HGSS_UNK_189
    End
_002F:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _0082
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _005B
    GoTo _00C2
_005B:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 5, _007A
    ClearFlag FLAG_HGSS_UNK_260
    ClearFlag FLAG_HGSS_UNK_2E2
    GoTo _0080
_007A:
    GoTo _00C2
_0080:
    End
_0082:
    @ HGSS: GetPhoneBookRematch PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 0
    GoToIf 5, _00C2
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 5, _00BA
    ClearFlag FLAG_HGSS_UNK_260
    SetFlag FLAG_HGSS_UNK_2E2
    @ HGSS: SetObjectFacing obj_T07R0104_gsleader1, DIR_SOUTH
    GoTo _00C0
_00BA:
    GoTo _00C2
_00C0:
    End
_00C2:
    SetFlag FLAG_HGSS_UNK_260
    SetFlag FLAG_HGSS_UNK_2E2
    End
_00CC:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    ApplyMovement obj_T07R0104_gsleader1, _026C
    WaitMovement
    Message msg_0497_T07R0104_00000
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader13, _0274
    WaitMovement
    Message msg_0497_T07R0104_00001
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader1, _026C
    WaitMovement
    Message msg_0497_T07R0104_00002
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader13, _0274
    WaitMovement
    Message msg_0497_T07R0104_00003
    CloseMessage
    ApplyMovement obj_T07R0104_gsleader1, _027C
    WaitMovement
    Message msg_0497_T07R0104_00004
_011B:
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _013F
    CompareVar VAR_RESULT, 1
    GoToIf 4, _0189
    End
_013F:
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
_0189:
    SetVarFromValue VAR_MAP_LOCAL_0x04, 1
    Message msg_0497_T07R0104_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0104_005:
    @ HGSS: CheckRegisteredPhoneNumber PHONE_CONTACT_FALKNER, VAR_TEMP_x4001
    CompareVar VAR_MAP_LOCAL_0x01, 1
    GoToIf 1, _01CD
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 5, _00CC
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0497_T07R0104_00009
    GoTo _011B
    End
_01CD:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0497_T07R0104_00010
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0236
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0241
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
_0236:
    Message msg_0497_T07R0104_00013
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0241:
    Message msg_0497_T07R0104_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T07R0104_006:
    CompareVar VAR_MAP_LOCAL_0x04, 1
    GoToIf 5, _00CC
    NPCMessage msg_0497_T07R0104_00015
    End
    .balign 4, 0
_026C:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0274:
    WalkOnSpotNormalEast
    EndMovement
    .balign 4, 0
_027C:
    WalkOnSpotNormalSouth
    EndMovement
scr_seq_T07R0104_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Common_VendorGreeting
    CloseMessageWithoutErasing
    SetVarFromValue VAR_0x8004, 21
    @ HGSS: CallStd std_special_mart
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
    .balign 4, 0
