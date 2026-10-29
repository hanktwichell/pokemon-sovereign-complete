#include "macros/scrcmd.inc"
#include "generated/text_banks.h"
#include "res/text/bank/hgss_msg_0464.h"

#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h
#define obj_T03R0101_gsassistantm 0
#define obj_T03R0101_gsmiddleman1 5
#define obj_T03R0101_daigo 6

    ScriptEntry scr_seq_T03R0101_000
    ScriptEntry scr_seq_T03R0101_001
    ScriptEntry scr_seq_T03R0101_002
    ScriptEntry scr_seq_T03R0101_003
    ScriptEntry scr_seq_T03R0101_004
    ScriptEntry scr_seq_T03R0101_005
    ScriptEntry scr_seq_T03R0101_006
    ScriptEntry scr_seq_T03R0101_007
    ScriptEntry scr_seq_T03R0101_008
    ScriptEntry scr_seq_T03R0101_009
    ScriptEntry scr_seq_T03R0101_010
    ScriptEntry scr_seq_T03R0101_011
    ScriptEntry scr_seq_T03R0101_012
    ScriptEntry scr_seq_T03R0101_013
    ScriptEntry scr_seq_T03R0101_014
    ScriptEntry scr_seq_T03R0101_015
    ScriptEntry scr_seq_T03R0101_016
    ScriptEntry scr_seq_T03R0101_017
    ScriptEntry scr_seq_T03R0101_018
    ScriptEntry scr_seq_T03R0101_019
    ScriptEntryEnd
scr_seq_T03R0101_014:
    CompareVar VAR_HGSS_UNK_4083, 5
    GoToIf 4, _00E8
    CompareVar VAR_HGSS_UNK_4083, 4
    GoToIf 1, _00E8
    CompareVar VAR_HGSS_UNK_4083, 3
    GoToIf 1, _00D8
    CompareVar VAR_HGSS_UNK_4083, 2
    GoToIf 1, _00D8
    CompareVar VAR_HGSS_UNK_4083, 1
    GoToIf 1, _00CE
    CheckItem ITEM_ENIGMA_STONE, 1, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _00F4
    @ HGSS: ScrCmd_546 0, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _00F4
    @ HGSS: NopVar490 VAR_TEMP_x4007
    SetVarFromValue VAR_HGSS_UNK_4083, 1
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    End
_00CE:
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    End
_00D8:
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    GoTo _0104
    End
_00E8:
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    GoTo _0104
    End
_00F4:
    @ HGSS: NopVar490 VAR_TEMP_x4006
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    GoTo _0104
    End
_0104:
    GoToIfUnset FLAG_HGSS_UNK_189, _0115
    ClearFlag FLAG_HGSS_UNK_189
    End
_0115:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0139
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0139
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0139:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
scr_seq_T03R0101_017:
    End
_0141:
    @ HGSS: NopVar490 VAR_TEMP_x4006
    End
scr_seq_T03R0101_000:
    NPCMessage msg_0464_T03R0101_00000
    End
scr_seq_T03R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    @ HGSS: ScriptOverlayCmd 2, 0
    GoToIfSet FLAG_MAP_LOCAL_0x01, _0530
    CompareVar VAR_HGSS_UNK_407F, 0
    GoToIf 5, _0550
    Message msg_0464_T03R0101_00001
    @ HGSS: CountFossils VAR_SPECIAL_x8000
    CompareVar VAR_0x8000, 0
    GoToIf 5, _019B
    Message msg_0464_T03R0101_00006
    GoTo _05FC
_019B:
    CompareVar VAR_0x8000, 1
    GoToIf 1, _04F7
    SetVarFromValue VAR_0x8001, 0
    CheckItem ITEM_OLD_AMBER, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_HELIX_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_DOME_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_ROOT_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_CLAW_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_ARMOR_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CheckItem ITEM_SKULL_FOSSIL, 1, VAR_RESULT
    AddVar VAR_0x8001, VAR_RESULT
    CompareVar VAR_0x8001, 1
    GoToIf 1, _04F7
    SetVarFromValue VAR_0x8004, 0
    SetVarFromValue VAR_0x8005, 0
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    SetVarFromValue VAR_MAP_LOCAL_0x05, 0
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    InitGlobalTextMenu 1, 1, 0, VAR_0x8000, 1
_0263:
    CompareVar VAR_0x8005, 0
    CallIf 1, _0417
    CompareVar VAR_0x8005, 1
    CallIf 1, _0427
    CompareVar VAR_0x8005, 2
    CallIf 1, _0437
    CompareVar VAR_0x8005, 3
    CallIf 1, _0447
    CompareVar VAR_0x8005, 4
    CallIf 1, _0457
    CompareVar VAR_0x8005, 5
    CallIf 1, _0467
    CompareVar VAR_0x8005, 6
    CallIf 1, _0477
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0340
    CompareVar VAR_0x8004, 0
    CallIf 1, _0487
    CompareVar VAR_0x8004, 1
    CallIf 1, _048F
    CompareVar VAR_0x8004, 2
    CallIf 1, _0497
    CompareVar VAR_0x8004, 3
    CallIf 1, _049F
    CompareVar VAR_0x8004, 4
    CallIf 1, _04A7
    CompareVar VAR_0x8004, 5
    CallIf 1, _04AF
    CompareVar VAR_0x8004, 6
    CallIf 1, _04B7
    SetVarFromVar VAR_0x8006, VAR_0x8005
    AddVar VAR_0x8006, 159
    AddMenuEntryImm VAR_0x8006, VAR_0x8004
    GoTo _034C
_0340:
    AddVar VAR_0x8005, 1
    GoTo _0263
_034C:
    AddVar VAR_0x8004, 1
    AddVar VAR_0x8005, 1
    CompareVar VAR_0x8004, VAR_0x8001
    GoToIf 5, _0263
    AddMenuEntryImm 45, VAR_0x8004
    ShowMenu
    CompareVar VAR_0x8000, 255
    GoToIf 1, _053F
    CompareVar VAR_0x8000, 0
    CallIf 1, _04BF
    CompareVar VAR_0x8000, 1
    CallIf 1, _04C7
    CompareVar VAR_0x8000, 2
    CallIf 1, _04CF
    CompareVar VAR_0x8000, 3
    CallIf 1, _04D7
    CompareVar VAR_0x8000, 4
    CallIf 1, _04DF
    CompareVar VAR_0x8000, 5
    CallIf 1, _04E7
    CompareVar VAR_0x8000, 6
    CallIf 1, _04EF
    @ HGSS: GetFossilPokemon VAR_UNK_407F, VAR_SPECIAL_x8002
    CompareVar VAR_HGSS_UNK_407F, 0
    GoToIf 1, _053F
    BufferItemName 0, VAR_0x8002
    Message msg_0464_T03R0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _053F
    RemoveItem VAR_0x8002, 1, VAR_RESULT
    GoTo _0530
_0417:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 103
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0427:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 101
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0437:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 102
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0447:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 99
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0457:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 100
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0467:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 104
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0477:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 105
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0487:
    SetVarFromVar VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x00
    Return
_048F:
    SetVarFromVar VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x00
    Return
_0497:
    SetVarFromVar VAR_MAP_LOCAL_0x03, VAR_MAP_LOCAL_0x00
    Return
_049F:
    SetVarFromVar VAR_MAP_LOCAL_0x04, VAR_MAP_LOCAL_0x00
    Return
_04A7:
    SetVarFromVar VAR_MAP_LOCAL_0x05, VAR_MAP_LOCAL_0x00
    Return
_04AF:
    SetVarFromVar VAR_MAP_LOCAL_0x06, VAR_MAP_LOCAL_0x00
    Return
_04B7:
    SetVarFromVar VAR_MAP_LOCAL_0x07, VAR_MAP_LOCAL_0x00
    Return
_04BF:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x01
    Return
_04C7:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x02
    Return
_04CF:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x03
    Return
_04D7:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x04
    Return
_04DF:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x05
    Return
_04E7:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x06
    Return
_04EF:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x07
    Return
_04F7:
    @ HGSS: GetFossilMinimumAmount VAR_SPECIAL_x8002, VAR_SPECIAL_x8004, 1
    BufferItemName 0, VAR_0x8002
    Message msg_0464_T03R0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _053F
    @ HGSS: GetFossilPokemon VAR_UNK_407F, VAR_SPECIAL_x8002
    RemoveItem VAR_0x8002, 1, VAR_RESULT
    GoTo _0530
_0530:
    SetFlag FLAG_MAP_LOCAL_0x01
    Message msg_0464_T03R0101_00003
    GoTo _05FC
    End
_053F:
    SetVarFromValue VAR_HGSS_UNK_407F, 0
    Message msg_0464_T03R0101_00002
    GoTo _05FC
    End
_0550:
    BufferSpeciesNameFromVar 0, VAR_HGSS_UNK_407F, 0, 0
    Message msg_0464_T03R0101_00004
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 5, _0575
    Message msg_0464_T03R0101_00005
    GoTo _05FC
_0575:
    BufferSpeciesNameFromVar 1, VAR_HGSS_UNK_407F, 0, 0
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA5_sseq
    Message msg_0464_T03R0101_00008
    WaitFanfare
    @ HGSS: GiveMon VAR_UNK_407F, 20, 0, 0, 0, VAR_SPECIAL_RESULT
    @ HGSS: ScrCmd_420 116
    SetVarFromValue VAR_HGSS_UNK_407F, 0
    Message msg_0464_T03R0101_00009
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0600
    GetPartyCount VAR_MAP_LOCAL_0x00
    SubVar VAR_MAP_LOCAL_0x00, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: NicknameInput VAR_TEMP_x4000, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05E8
    @ HGSS: ScrCmd_420 50
_05E8:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ScriptOverlayCmd 2, 1
    ReleaseAll
    End
_05FC:
    WaitButton
    CloseMessage
_0600:
    @ HGSS: ScriptOverlayCmd 2, 1
    ReleaseAll
    End
scr_seq_T03R0101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _070D
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0721
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _0681
    ApplyMovement LOCALID_PLAYER, _0738
    ApplyMovement obj_T03R0101_gsmiddleman1, _0770
    GoTo _06AC
_0681:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _069C
    ApplyMovement LOCALID_PLAYER, _0750
    GoTo _06AC
_069C:
    ApplyMovement LOCALID_PLAYER, _075C
    ApplyMovement obj_T03R0101_gsmiddleman1, _0770
_06AC:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _06D3
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _077C
    WaitMovement
_06D3:
    SetFlag FLAG_HGSS_UNK_189
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: CameronPhoto 65
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
_070D:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0721:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
_0738:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0750:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_075C:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0770:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_077C:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
scr_seq_T03R0101_019:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00013
    WaitButton
    CloseMessage
    SetVarFromValue VAR_HGSS_UNK_4130, 5
    ReleaseAll
    End
scr_seq_T03R0101_015:
    End
scr_seq_T03R0101_018:
    CompareVar VAR_HGSS_UNK_4083, 0
    GoToIf 1, _07BF
    CompareVar VAR_HGSS_UNK_4083, 1
    GoToIf 1, _07C1
_07BF:
    End
_07C1:
    @ HGSS: NopVar490 VAR_UNK_4083
    @ HGSS: ScrCmd_344 0, 0
    SetPosition obj_T03R0101_daigo, 26, 0, 7, DIR_SOUTH
    GoTo _07BF
    End
scr_seq_T03R0101_016:
    LockAll
    CheckItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0963
    @ HGSS: ScrCmd_546 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0963
    ApplyMovement obj_T03R0101_daigo, _0968
    WaitMovement
    Message msg_0464_T03R0101_00014
    CloseMessage
    ApplyMovement obj_T03R0101_daigo, _0970
    WaitMovement
    Message msg_0464_T03R0101_00015
    Message msg_0464_T03R0101_00016
    CloseMessage
    ApplyMovement obj_T03R0101_daigo, _097C
    ApplyMovement obj_T03R0101_gsassistantm, _09C8
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _0868
    ApplyMovement LOCALID_PLAYER, _0998
    GoTo _0870
_0868:
    ApplyMovement LOCALID_PLAYER, _098C
_0870:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_PLAYER, _09A4
    WaitMovement
    BufferPlayerName 0
    Message msg_0464_T03R0101_00017
    CloseMessage
    ApplyMovement obj_T03R0101_gsassistantm, _09D0
    WaitMovement
    Message msg_0464_T03R0101_00018
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 30, VAR_RESULT
    ReleaseObject obj_T03R0101_daigo
    SetPosition obj_T03R0101_daigo, 25, 0, 7, DIR_SOUTH
    WaitTime 10, VAR_RESULT
    LockObject obj_T03R0101_daigo
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 1, _08F1
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x09
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 1, _08F1
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _09F0
    WaitMovement
_08F1:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_T03R0101_gsassistantm, _09D0
    WaitMovement
    Message msg_0464_T03R0101_00019
    CloseMessage
    ApplyMovement obj_T03R0101_gsassistantm, _09D8
    WaitMovement
    RemoveItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    SetVarFromValue VAR_0x8004, 225
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    ApplyMovement obj_T03R0101_daigo, _09B8
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0968
    WaitMovement
    Message msg_0464_T03R0101_00021
    CloseMessage
    ApplyMovement obj_T03R0101_daigo, _09C0
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4083, 2
    RemoveObject obj_T03R0101_daigo
_0963:
    ReleaseAll
    End
    .balign 4, 0
_0968:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0970:
    Delay8
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_097C:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_098C:
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0998:
    WalkNormalEast
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_09A4:
    WalkNormalSouth
    Delay8
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_09B8:
    FaceEast
    EndMovement
    .balign 4, 0
_09C0:
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_09C8:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_09D0:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_09D8:
    WalkNormalNorth
    WalkOnSpotNormalNorth
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_09F0:
    WalkFasterNorth
    WalkFasterEast
    FaceSouth
    EndMovement
scr_seq_T03R0101_002:
    NPCMessage msg_0464_T03R0101_00010
    End
scr_seq_T03R0101_003:
    NPCMessage msg_0464_T03R0101_00011
    End
scr_seq_T03R0101_004:
    NPCMessage msg_0464_T03R0101_00012
    End
scr_seq_T03R0101_005:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00022
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0101_006:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00023
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0101_007:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00024
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0101_008:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00025
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0101_009:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00026
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0101_010:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00027
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0101_011:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00028
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T03R0101_012:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0464_T03R0101_00029
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
