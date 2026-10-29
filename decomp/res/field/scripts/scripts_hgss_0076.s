#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0100.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_D32_gsmiddleman1_2 24

    ScriptEntry scr_seq_D32_000
    ScriptEntry scr_seq_D32_001
    ScriptEntry scr_seq_D32_002
    ScriptEntry scr_seq_D32_003
    ScriptEntry scr_seq_D32_004
    ScriptEntry scr_seq_D32_005
    ScriptEntry scr_seq_D32_006
    ScriptEntry scr_seq_D32_007
    ScriptEntry scr_seq_D32_008
    ScriptEntry scr_seq_D32_009
    ScriptEntry scr_seq_D32_010
    ScriptEntry scr_seq_D32_011
    ScriptEntry scr_seq_D32_012
    ScriptEntry scr_seq_D32_013
    ScriptEntry scr_seq_D32_014
    ScriptEntry scr_seq_D32_015
    ScriptEntry scr_seq_D32_016
    ScriptEntry scr_seq_D32_017
    ScriptEntry scr_seq_D32_018
    ScriptEntry scr_seq_D32_019
    ScriptEntry scr_seq_D32_020
    ScriptEntry scr_seq_D32_021
    ScriptEntry scr_seq_D32_022
    ScriptEntry scr_seq_D32_023
    ScriptEntry scr_seq_D32_024
    ScriptEntry scr_seq_D32_025
    ScriptEntry scr_seq_D32_026
    ScriptEntry scr_seq_D32_027
    ScriptEntry scr_seq_D32_028
    ScriptEntry scr_seq_D32_029
    ScriptEntry scr_seq_D32_030
    ScriptEntry scr_seq_D32_031
    ScriptEntry scr_seq_D32_032
    ScriptEntry scr_seq_D32_033
    ScriptEntry scr_seq_D32_034
    ScriptEntry scr_seq_D32_035
    ScriptEntry scr_seq_D32_036
    ScriptEntry scr_seq_D32_037
    ScriptEntry scr_seq_D32_038
    ScriptEntryEnd
scr_seq_D32_037:
    GoToIfUnset FLAG_HGSS_UNK_189, _00AF
    ClearFlag FLAG_HGSS_UNK_189
    End
_00AF:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 3
    GoToIf 1, _00D7
    CompareVar VAR_MAP_LOCAL_0x00, 5
    GoToIf 1, _00D7
    SetFlag FLAG_HGSS_HIDE_CAMERON
    GoTo _00DB
_00D7:
    SetFlag FLAG_HGSS_HIDE_CAMERON
_00DB:
    SetFlag FLAG_HGSS_UNK_234
    End
scr_seq_D32_038:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0209
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _021D
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _015A
    ApplyMovement LOCALID_PLAYER, _0234
    ApplyMovement obj_D32_gsmiddleman1_2, _0280
    GoTo _01A8
_015A:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0175
    ApplyMovement LOCALID_PLAYER, _024C
    GoTo _01A8
_0175:
    CompareVar VAR_RESULT, 3
    GoToIf 5, _0198
    ApplyMovement LOCALID_PLAYER, _026C
    ApplyMovement obj_D32_gsmiddleman1_2, _0280
    GoTo _01A8
_0198:
    ApplyMovement LOCALID_PLAYER, _0258
    ApplyMovement obj_D32_gsmiddleman1_2, _0280
_01A8:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _01CF
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _028C
    WaitMovement
_01CF:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 31
    LockAll
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ClearFlag FLAG_HGSS_UNK_189
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 2
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0209:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_021D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0234:
    WalkNormalEast
    WalkNormalNorth 2
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_024C:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0258:
    WalkNormalNorth
    WalkNormalWest
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_026C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0280:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_028C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_D32_001:
    NPCMessage msg_0100_D32_00000
    End
scr_seq_D32_002:
    NPCMessage msg_0100_D32_00001
    End
scr_seq_D32_003:
    NPCMessage msg_0100_D32_00002
    End
scr_seq_D32_004:
    NPCMessage msg_0100_D32_00003
    End
scr_seq_D32_005:
    NPCMessage msg_0100_D32_00004
    End
scr_seq_D32_006:
    NPCMessage msg_0100_D32_00005
    End
scr_seq_D32_007:
    NPCMessage msg_0100_D32_00006
    End
scr_seq_D32_008:
    NPCMessage msg_0100_D32_00007
    End
scr_seq_D32_009:
    NPCMessage msg_0100_D32_00008
    End
scr_seq_D32_010:
    NPCMessage msg_0100_D32_00009
    End
scr_seq_D32_011:
    NPCMessage msg_0100_D32_00010
    End
scr_seq_D32_012:
    NPCMessage msg_0100_D32_00011
    End
scr_seq_D32_013:
    NPCMessage msg_0100_D32_00012
    End
scr_seq_D32_014:
    NPCMessage msg_0100_D32_00013
    End
scr_seq_D32_015:
    NPCMessage msg_0100_D32_00014
    End
scr_seq_D32_016:
    NPCMessage msg_0100_D32_00015
    End
scr_seq_D32_017:
    NPCMessage msg_0100_D32_00016
    End
scr_seq_D32_018:
    NPCMessage msg_0100_D32_00017
    End
scr_seq_D32_019:
    NPCMessage msg_0100_D32_00018
    End
scr_seq_D32_020:
    NPCMessage msg_0100_D32_00019
    End
scr_seq_D32_021:
    NPCMessage msg_0100_D32_00020
    End
scr_seq_D32_022:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_0x8000, 0
    @ HGSS: ScriptOverlayCmd 3, 0
    @ HGSS: ScrCmd_116 1, 21, 1
    Message msg_0100_D32_00021
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B02
_045C:
    Message msg_0100_D32_00031
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 347, 0
    AddMenuEntry 348, 1
    AddMenuEntry 349, 2
    AddMenuEntry 350, 3
    AddMenuEntry 439, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _04D1
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0630
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0762
    CompareVar VAR_0x8008, 3
    GoToIf 1, _08C1
    GoTo _0B02
_04D1:
    SetVarFromValue VAR_0x8007, 0
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 354, 0
    AddMenuEntry 355, 1
    AddMenuEntry 356, 2
    AddMenuEntry 357, 3
    AddMenuEntry 358, 4
    AddMenuEntry 359, 5
    AddMenuEntry 379, 6
    AddMenuEntry 440, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0588
    CompareVar VAR_0x8008, 1
    GoToIf 1, _05A0
    CompareVar VAR_0x8008, 2
    GoToIf 1, _05B8
    CompareVar VAR_0x8008, 3
    GoToIf 1, _05D0
    CompareVar VAR_0x8008, 4
    GoToIf 1, _05E8
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0600
    CompareVar VAR_0x8008, 6
    GoToIf 1, _0618
    GoTo _045C
_0588:
    SetVarFromValue VAR_0x8004, ITEM_PROTEIN
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 1
    GoTo _09F3
_05A0:
    SetVarFromValue VAR_0x8004, ITEM_CALCIUM
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 1
    GoTo _09F3
_05B8:
    SetVarFromValue VAR_0x8004, ITEM_IRON
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 1
    GoTo _09F3
_05D0:
    SetVarFromValue VAR_0x8004, ITEM_ZINC
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 1
    GoTo _09F3
_05E8:
    SetVarFromValue VAR_0x8004, ITEM_CARBOS
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 1
    GoTo _09F3
_0600:
    SetVarFromValue VAR_0x8004, ITEM_HP_UP
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 1
    GoTo _09F3
_0618:
    SetVarFromValue VAR_0x8004, ITEM_RARE_CANDY
    SetVarFromValue VAR_0x8005, 48
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_0630:
    SetVarFromValue VAR_0x8007, 1
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 360, 0
    AddMenuEntry 361, 1
    AddMenuEntry 362, 2
    AddMenuEntry 363, 3
    AddMenuEntry 364, 4
    AddMenuEntry 365, 5
    AddMenuEntry 440, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _06D2
    CompareVar VAR_0x8008, 1
    GoToIf 1, _06EA
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0702
    CompareVar VAR_0x8008, 3
    GoToIf 1, _071A
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0732
    CompareVar VAR_0x8008, 5
    GoToIf 1, _074A
    GoTo _045C
_06D2:
    SetVarFromValue VAR_0x8004, ITEM_POWER_BRACER
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_06EA:
    SetVarFromValue VAR_0x8004, ITEM_POWER_BELT
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_0702:
    SetVarFromValue VAR_0x8004, ITEM_POWER_LENS
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_071A:
    SetVarFromValue VAR_0x8004, ITEM_POWER_BAND
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_0732:
    SetVarFromValue VAR_0x8004, ITEM_POWER_ANKLET
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_074A:
    SetVarFromValue VAR_0x8004, ITEM_POWER_WEIGHT
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_0762:
    SetVarFromValue VAR_0x8007, 2
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 366, 0
    AddMenuEntry 367, 1
    AddMenuEntry 368, 2
    AddMenuEntry 369, 3
    AddMenuEntry 370, 4
    AddMenuEntry 372, 5
    AddMenuEntry 375, 6
    AddMenuEntry 440, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0819
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0831
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0849
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0861
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0879
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0891
    CompareVar VAR_0x8008, 6
    GoToIf 1, _08A9
    GoTo _045C
_0819:
    SetVarFromValue VAR_0x8004, ITEM_TOXIC_ORB
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_0831:
    SetVarFromValue VAR_0x8004, ITEM_FLAME_ORB
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 16
    GoTo _09F3
_0849:
    SetVarFromValue VAR_0x8004, ITEM_WHITE_HERB
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 32
    GoTo _09F3
_0861:
    SetVarFromValue VAR_0x8004, ITEM_POWER_HERB
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 32
    GoTo _09F3
_0879:
    SetVarFromValue VAR_0x8004, ITEM_BRIGHTPOWDER
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_0891:
    SetVarFromValue VAR_0x8004, ITEM_FOCUS_BAND
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_08A9:
    SetVarFromValue VAR_0x8004, ITEM_FOCUS_SASH
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_08C1:
    SetVarFromValue VAR_0x8007, 3
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 371, 0
    AddMenuEntry 376, 1
    AddMenuEntry 373, 2
    AddMenuEntry 374, 3
    AddMenuEntry 377, 4
    AddMenuEntry 378, 5
    AddMenuEntry 440, 7
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0963
    CompareVar VAR_0x8008, 1
    GoToIf 1, _097B
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0993
    CompareVar VAR_0x8008, 3
    GoToIf 1, _09AB
    CompareVar VAR_0x8008, 4
    GoToIf 1, _09C3
    CompareVar VAR_0x8008, 5
    GoToIf 1, _09DB
    GoTo _045C
_0963:
    SetVarFromValue VAR_0x8004, ITEM_CHOICE_BAND
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_097B:
    SetVarFromValue VAR_0x8004, ITEM_CHOICE_SCARF
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_0993:
    SetVarFromValue VAR_0x8004, ITEM_SCOPE_LENS
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_09AB:
    SetVarFromValue VAR_0x8004, ITEM_MUSCLE_BAND
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_09C3:
    SetVarFromValue VAR_0x8004, ITEM_RAZOR_CLAW
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_09DB:
    SetVarFromValue VAR_0x8004, ITEM_RAZOR_FANG
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    GoTo _09F3
_09F3:
    BufferItemName 0, VAR_0x8004
    BufferNumber 1, VAR_0x8006
    Message msg_0100_D32_00023
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A24
    CompareVar VAR_0x8000, 0
    GoToIf 1, _0AB1
    GoTo _0F76
_0A24:
    CheckBattlePoints VAR_0x8006, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A9B
    CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A85
    @ HGSS: ScrCmd_556 VAR_SPECIAL_x8006
    @ HGSS: ScrCmd_118 1
    PlaySE SEQ_SE_DP_REGI_sseq
    BufferItemName 0, VAR_0x8004
    GetItemPocket VAR_0x8004, VAR_RESULT
    BufferPocketName 1, VAR_RESULT
    Message msg_0100_D32_00026
    AddItem VAR_0x8004, 1, VAR_RESULT
    CompareVar VAR_0x8000, 0
    GoToIf 1, _0AB1
    GoTo _0F76
_0A85:
    Message msg_0100_D32_00029
    CompareVar VAR_0x8000, 0
    GoToIf 1, _0AB1
    GoTo _0F76
_0A9B:
    Message msg_0100_D32_00027
    CompareVar VAR_0x8000, 0
    GoToIf 1, _0AB1
    GoTo _0F76
_0AB1:
    CompareVar VAR_0x8007, 0
    GoToIf 5, _0ACA
    GoTo _04D1
    GoTo _0B02
_0ACA:
    CompareVar VAR_0x8007, 1
    GoToIf 5, _0AE3
    GoTo _0630
    GoTo _0B02
_0AE3:
    CompareVar VAR_0x8007, 2
    GoToIf 5, _0AFC
    GoTo _0762
    GoTo _0B02
_0AFC:
    GoTo _08C1
_0B02:
    @ HGSS: ScrCmd_117
    Message msg_0100_D32_00022
    WaitButton
    CloseMessage
    ReleaseAll
    @ HGSS: ScriptOverlayCmd 3, 1
    End
scr_seq_D32_024:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_0x8000, 1
    @ HGSS: ScriptOverlayCmd 3, 0
    @ HGSS: ScrCmd_116 1, 21, 1
    Message msg_0100_D32_00021
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0B02
_0B44:
    Message msg_0100_D32_00030
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 351, 0
    AddMenuEntry 352, 1
    AddMenuEntry 353, 2
    AddMenuEntry 439, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0BA4
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0CFA
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0DEA
    GoTo _0B02
_0BA4:
    SetVarFromValue VAR_0x8007, 0
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 380, 0
    AddMenuEntry 381, 1
    AddMenuEntry 382, 2
    AddMenuEntry 383, 3
    AddMenuEntry 384, 4
    AddMenuEntry 385, 5
    AddMenuEntry 440, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0C46
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0C64
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0C82
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0CA0
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0CBE
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0CDC
    GoTo _0B44
_0C46:
    SetVarFromValue VAR_0x8004, ITEM_TM40
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 40
    SetVarFromValue VAR_0x8001, 332
    GoTo _0F40
_0C64:
    SetVarFromValue VAR_0x8004, ITEM_TM31
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 40
    SetVarFromValue VAR_0x8001, 280
    GoTo _0F40
_0C82:
    SetVarFromValue VAR_0x8004, ITEM_TM89
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 40
    SetVarFromValue VAR_0x8001, 369
    GoTo _0F40
_0CA0:
    SetVarFromValue VAR_0x8004, ITEM_TM81
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 64
    SetVarFromValue VAR_0x8001, 404
    GoTo _0F40
_0CBE:
    SetVarFromValue VAR_0x8004, ITEM_TM71
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 80
    SetVarFromValue VAR_0x8001, 444
    GoTo _0F40
_0CDC:
    SetVarFromValue VAR_0x8004, ITEM_TM26
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 80
    SetVarFromValue VAR_0x8001, 89
    GoTo _0F40
_0CFA:
    SetVarFromValue VAR_0x8007, 1
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 386, 0
    AddMenuEntry 387, 1
    AddMenuEntry 388, 2
    AddMenuEntry 389, 3
    AddMenuEntry 440, 4
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0D72
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0D90
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0DAE
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0DCC
    GoTo _0B44
_0D72:
    SetVarFromValue VAR_0x8004, ITEM_TM30
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 64
    SetVarFromValue VAR_0x8001, 247
    GoTo _0F40
_0D90:
    SetVarFromValue VAR_0x8004, ITEM_TM53
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 64
    SetVarFromValue VAR_0x8001, 412
    GoTo _0F40
_0DAE:
    SetVarFromValue VAR_0x8004, ITEM_TM36
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 80
    SetVarFromValue VAR_0x8001, 188
    GoTo _0F40
_0DCC:
    SetVarFromValue VAR_0x8004, ITEM_TM59
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 80
    SetVarFromValue VAR_0x8001, 406
    GoTo _0F40
_0DEA:
    SetVarFromValue VAR_0x8007, 2
    CompleteInitHGSSMenu 1, 1, 0, VAR_RESULT, 1
    AddMenuEntry 390, 0
    AddMenuEntry 391, 1
    AddMenuEntry 392, 2
    AddMenuEntry 393, 3
    AddMenuEntry 394, 4
    AddMenuEntry 395, 5
    AddMenuEntry 440, 6
    ShowMenu
    SetVar VAR_0x8008, VAR_RESULT
    CompareVar VAR_0x8008, 0
    GoToIf 1, _0E8C
    CompareVar VAR_0x8008, 1
    GoToIf 1, _0EAA
    CompareVar VAR_0x8008, 2
    GoToIf 1, _0EC8
    CompareVar VAR_0x8008, 3
    GoToIf 1, _0EE6
    CompareVar VAR_0x8008, 4
    GoToIf 1, _0F04
    CompareVar VAR_0x8008, 5
    GoToIf 1, _0F22
    GoTo _0B44
_0E8C:
    SetVarFromValue VAR_0x8004, ITEM_TM06
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 32
    SetVarFromValue VAR_0x8001, 92
    GoTo _0F40
_0EAA:
    SetVarFromValue VAR_0x8004, ITEM_TM73
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 32
    SetVarFromValue VAR_0x8001, 86
    GoTo _0F40
_0EC8:
    SetVarFromValue VAR_0x8004, ITEM_TM61
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 32
    SetVarFromValue VAR_0x8001, 261
    GoTo _0F40
_0EE6:
    SetVarFromValue VAR_0x8004, ITEM_TM45
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 32
    SetVarFromValue VAR_0x8001, 213
    GoTo _0F40
_0F04:
    SetVarFromValue VAR_0x8004, ITEM_TM08
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    SetVarFromValue VAR_0x8001, 339
    GoTo _0F40
_0F22:
    SetVarFromValue VAR_0x8004, ITEM_TM04
    SetVarFromValue VAR_0x8005, 1
    SetVarFromValue VAR_0x8006, 48
    SetVarFromValue VAR_0x8001, 347
    GoTo _0F40
_0F40:
    BufferItemName 0, VAR_0x8004
    BufferMoveName 1, VAR_0x8001
    BufferNumber 2, VAR_0x8006
    Message msg_0100_D32_00024
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0A24
    CompareVar VAR_0x8000, 0
    GoToIf 1, _0AB1
    GoTo _0F76
_0F76:
    CompareVar VAR_0x8007, 0
    GoToIf 5, _0F8F
    GoTo _0BA4
    GoTo scr_seq_D32_023
_0F8F:
    CompareVar VAR_0x8007, 1
    GoToIf 5, _0FA8
    GoTo _0CFA
    GoTo scr_seq_D32_023
_0FA8:
    GoTo _0DEA
scr_seq_D32_023:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScratchOffCard
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
scr_seq_D32_025:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0100_D32_00034, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D32_026:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0100_D32_00035, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D32_027:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0100_D32_00036, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D32_028:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0100_D32_00037, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D32_029:
    DrawSignpostTextBox SIGNPOST_TYPE_SCROLLING
    SetSignpostCommand SIGNPOST_CMD_SCROLL_IN
    WaitForSignpostDone
    DrawSignpostScrollingMessage msg_0100_D32_00038, VAR_RESULT
    Common_HandleSignpostInput
    End
scr_seq_D32_030:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0100_D32_00039
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32_031:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0100_D32_00040
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32_032:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0100_D32_00041
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_D32_033:
    LockAll
    @ HGSS: ScrCmd_600
    ApplyMovement LOCALID_PLAYER, _10B0
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_HALL, 25, 9, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_10B0:
    WalkFastWest 5
    EndMovement
scr_seq_D32_034:
    LockAll
    @ HGSS: ScrCmd_600
    ApplyMovement LOCALID_PLAYER, _10F4
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_CASTLE, 21, 9, DIR_WEST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_10F4:
    WalkFastWest 6
    EndMovement
scr_seq_D32_035:
    LockAll
    @ HGSS: ScrCmd_600
    ApplyMovement LOCALID_PLAYER, _1138
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_ARCADE, 1, 6, DIR_EAST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_1138:
    WalkFastEast 5
    EndMovement
scr_seq_D32_036:
    LockAll
    @ HGSS: ScrCmd_600
    ApplyMovement LOCALID_PLAYER, _117C
    WaitMovement
    PlaySE SEQ_SE_DP_KAIDAN2_sseq
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    Warp MAP_HEADER_HGSS_BATTLE_FRONTIER_BATTLE_FACTORY, 1, 7, DIR_EAST
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
    .balign 4, 0
_117C:
    WalkFastEast 6
    EndMovement
scr_seq_D32_000:
    End
    .balign 4, 0
