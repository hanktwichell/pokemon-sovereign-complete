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
    ScriptEntry scr_seq_T03R0101_020
    ScriptEntryEnd
scr_seq_T03R0101_014:
    CompareVar VAR_HGSS_UNK_4083, 5
    GoToIf 4, _0389
    CompareVar VAR_HGSS_UNK_4083, 4
    GoToIf 1, _0389
    CompareVar VAR_HGSS_UNK_4083, 3
    GoToIf 1, _0393
    CompareVar VAR_HGSS_UNK_4083, 2
    GoToIf 1, _0393
    CompareVar VAR_HGSS_UNK_4083, 1
    GoToIf 1, _03A1
    CheckItem ITEM_ENIGMA_STONE, 1, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _03AB
    @ HGSS: ScrCmd_546 0, VAR_TEMP_x4000
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _03AB
    SetVarFromValue VAR_HGSS_UNK_4083, 1
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    End
scr_seq_T03R0101_017:
    End
scr_seq_T03R0101_000:
    NPCMessage msg_0464_T03R0101_00000
    End
scr_seq_T03R0101_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_MAP_LOCAL_0x01, _03B9
    CompareVar VAR_HGSS_UNK_407F, 0
    GoToIf 5, _03C6
    Message msg_0464_T03R0101_00001
    GetFossilCount VAR_0x8000
    CompareVar VAR_0x8000, 0
    GoToIf 5, _03EB
    Message msg_0464_T03R0101_00006
    GoTo _0590
scr_seq_T03R0101_013:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 0
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _059C
    @ HGSS: PhotoAlbumIsFull VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _05B0
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 1
    CloseMessage
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    GetPlayerDir VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 5, _05C4
    ApplyMovement LOCALID_PLAYER, _0D33
    ApplyMovement obj_T03R0101_gsmiddleman1, _0D49
    GoTo _05DF
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
    GoToIf 1, _0640
    CompareVar VAR_HGSS_UNK_4083, 1
    GoToIf 1, _0642
    End
scr_seq_T03R0101_016:
    LockAll
    CheckItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _065E
    @ HGSS: ScrCmd_546 0, VAR_SPECIAL_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _065E
    ApplyMovement obj_T03R0101_daigo, _0D53
    WaitMovement
    Message msg_0464_T03R0101_00014
    CloseMessage
    ApplyMovement obj_T03R0101_daigo, _0D59
    WaitMovement
    Message msg_0464_T03R0101_00015
    Message msg_0464_T03R0101_00016
    CloseMessage
    ApplyMovement obj_T03R0101_daigo, _0D63
    ApplyMovement obj_T03R0101_gsassistantm, _0D71
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _0662
    ApplyMovement LOCALID_PLAYER, _0D77
    GoTo _0761
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
scr_seq_T03R0101_020:
    LockAll
    CheckItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _065E
    Message msg_0464_T03R0101_00014
    CloseMessage
    ApplyMovement 8, _0D59
    WaitMovement
    Message msg_0464_T03R0101_00015
    Message msg_0464_T03R0101_00016
    CloseMessage
    ApplyMovement 8, _0D63
    ApplyMovement obj_T03R0101_gsassistantm, _0D71
    WaitMovement
    GetPlayerMapPos VAR_MAP_LOCAL_0x00, VAR_MAP_LOCAL_0x01
    CompleteFollowerPause 0
    CompleteFollowerWait
    CompleteFollowerSetMovementType MOVEMENT_TYPE_NONE
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 5, _0662
    ApplyMovement LOCALID_PLAYER, _0D77
    GoTo _0761
_0389:
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    GoTo _0858
_0393:
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    GoTo _0858
_03A1:
    ClearFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_AFTER_LATIS
    End
_03AB:
    SetFlag FLAG_HGSS_HIDE_STEVEN_IN_HOUSE_BEFORE_LATIS
    GoTo _0858
_03B9:
    SetFlag FLAG_MAP_LOCAL_0x01
    Message msg_0464_T03R0101_00003
    GoTo _0590
_03C6:
    BufferSpeciesNameFromVar 0, VAR_HGSS_UNK_407F, 0, 0
    Message msg_0464_T03R0101_00004
    GetPartyCount VAR_RESULT
    CompareVar VAR_RESULT, 6
    GoToIf 5, _0869
    Message msg_0464_T03R0101_00005
    GoTo _0590
_03EB:
    CompareVar VAR_0x8000, 1
    GoToIf 1, _08F0
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
    GoToIf 1, _08F0
    SetVarFromValue VAR_0x8004, ITEM_NONE
    SetVarFromValue VAR_0x8005, 0
    SetVarFromValue VAR_MAP_LOCAL_0x00, 0
    SetVarFromValue VAR_MAP_LOCAL_0x01, 0
    SetVarFromValue VAR_MAP_LOCAL_0x02, 0
    SetVarFromValue VAR_MAP_LOCAL_0x03, 0
    SetVarFromValue VAR_MAP_LOCAL_0x04, 0
    SetVarFromValue VAR_MAP_LOCAL_0x05, 0
    SetVarFromValue VAR_MAP_LOCAL_0x06, 0
    SetVarFromValue VAR_MAP_LOCAL_0x07, 0
    CompleteInitHGSSMenu 1, 1, 0, VAR_0x8000, 1
    CompareVar VAR_0x8005, 0
    CallIf 1, _0929
    CompareVar VAR_0x8005, 1
    CallIf 1, _0939
    CompareVar VAR_0x8005, 2
    CallIf 1, _0949
    CompareVar VAR_0x8005, 3
    CallIf 1, _0959
    CompareVar VAR_0x8005, 4
    CallIf 1, _0969
    CompareVar VAR_0x8005, 5
    CallIf 1, _0979
    CompareVar VAR_0x8005, 6
    CallIf 1, _0989
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0999
    CompareVar VAR_0x8004, 0
    CallIf 1, _09A5
    CompareVar VAR_0x8004, 1
    CallIf 1, _09AD
    CompareVar VAR_0x8004, 2
    CallIf 1, _09B5
    CompareVar VAR_0x8004, 3
    CallIf 1, _09BD
    CompareVar VAR_0x8004, 4
    CallIf 1, _09C5
    CompareVar VAR_0x8004, 5
    CallIf 1, _09CD
    CompareVar VAR_0x8004, 6
    CallIf 1, _09D5
    SetVarFromVar VAR_0x8006, VAR_0x8005
    AddVar VAR_0x8006, 159
    AddMenuEntry VAR_0x8006, VAR_0x8004
    GoTo _09DD
_0590:
    WaitButton
    CloseMessage
    ReleaseAll
    End
_059C:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 5
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05B0:
    SetVarFromValue VAR_RESULT, TEXT_BANK_HGSS_MSG_0030
    MessageFromBank VAR_RESULT, 3
    WaitButton
    CloseMessage
    ReleaseAll
    End
_05C4:
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0AA8
    ApplyMovement LOCALID_PLAYER, _0D81
    GoTo _05DF
_05DF:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0B19
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0D8B
    WaitMovement
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
_0640:
    End
_0642:
    @ HGSS: ScrCmd_344 0, 0
    SetPosition obj_T03R0101_daigo, 26, 0, 7, DIR_SOUTH
    GoTo _0640
_065E:
    ReleaseAll
    End
_0662:
    ApplyMovement LOCALID_PLAYER, _0D99
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_PLAYER, _0DA3
    WaitMovement
    BufferPlayerName 0
    Message msg_0464_T03R0101_00017
    CloseMessage
    ApplyMovement obj_T03R0101_gsassistantm, _0DB5
    WaitMovement
    Message msg_0464_T03R0101_00018
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 30, VAR_RESULT
    ReleaseObject 8
    SetPosition 8, 25, 0, 7, DIR_SOUTH
    WaitTime 10, VAR_RESULT
    LockObject 8
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 1, _0B53
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x09
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 1, _0B53
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0DBB
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_T03R0101_gsassistantm, _0DB5
    WaitMovement
    Message msg_0464_T03R0101_00019
    CloseMessage
    ApplyMovement obj_T03R0101_gsassistantm, _0DC9
    WaitMovement
    RemoveItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    SetVarFromValue VAR_0x8004, ITEM_SOUL_DEW
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    ApplyMovement 8, _0DDF
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0D53
    WaitMovement
    Message msg_0464_T03R0101_00021
    CloseMessage
    ApplyMovement 8, _0DE5
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4083, 2
    RemoveObject 8
    ReleaseAll
    End
_0761:
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    ApplyMovement LOCALID_PLAYER, _0DA3
    WaitMovement
    BufferPlayerName 0
    Message msg_0464_T03R0101_00017
    CloseMessage
    ApplyMovement obj_T03R0101_gsassistantm, _0DB5
    WaitMovement
    Message msg_0464_T03R0101_00018
    CloseMessage
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    WaitTime 30, VAR_RESULT
    ReleaseObject 8
    SetPosition 8, 25, 0, 7, DIR_SOUTH
    WaitTime 10, VAR_RESULT
    LockObject 8
    CompareVar VAR_MAP_LOCAL_0x01, 6
    GoToIf 1, _0B53
    CompleteFollowerCheckActive VAR_MAP_LOCAL_0x09
    CompareVar VAR_MAP_LOCAL_0x09, 0
    GoToIf 1, _0B53
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0DBB
    WaitMovement
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_T03R0101_gsassistantm, _0DB5
    WaitMovement
    Message msg_0464_T03R0101_00019
    CloseMessage
    ApplyMovement obj_T03R0101_gsassistantm, _0DC9
    WaitMovement
    RemoveItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    SetVarFromValue VAR_0x8004, ITEM_SOUL_DEW
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    ApplyMovement 8, _0DDF
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0D53
    WaitMovement
    Message msg_0464_T03R0101_00021
    CloseMessage
    ApplyMovement 8, _0DE5
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4083, 2
    RemoveObject 8
    ReleaseAll
    End
_0858:
    GoToIfUnset FLAG_HGSS_UNK_189, _0BC9
    ClearFlag FLAG_HGSS_UNK_189
    End
_0869:
    BufferSpeciesNameFromVar 1, VAR_HGSS_UNK_407F, 0, 0
    BufferPlayerName 0
    PlayFanfare SEQ_FANFA5_sseq
    Message msg_0464_T03R0101_00008
    WaitFanfare
    GivePokemon VAR_HGSS_UNK_407F, 20, 0, VAR_RESULT
    IncrementGameRecord RECORD_POKEMON_RECEIVED_FROM_FOSSIL_REVIVAL
    SetVarFromValue VAR_HGSS_UNK_407F, 0
    Message msg_0464_T03R0101_00009
    ShowYesNoMenu VAR_RESULT
    CloseMessage
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0BED
    GetPartyCount VAR_MAP_LOCAL_0x00
    SubVar VAR_MAP_LOCAL_0x00, 1
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    OpenPokemonNamingScreen VAR_MAP_LOCAL_0x00, VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0BF5
    IncrementGameRecord RECORD_POKEMON_NICKNAMED
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_08F0:
    FindFossilAtThreshold VAR_0x8002, VAR_0x8004, 1
    BufferItemName 0, VAR_0x8002
    Message msg_0464_T03R0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C09
    GetSpeciesFromFossil VAR_HGSS_UNK_407F, VAR_0x8002
    RemoveItem VAR_0x8002, 1, VAR_RESULT
    GoTo _03B9
_0929:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 103
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0939:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 101
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0949:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 102
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0959:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 99
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0969:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 100
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0979:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 104
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0989:
    SetVarFromValue VAR_MAP_LOCAL_0x00, 105
    CheckItem VAR_MAP_LOCAL_0x00, 1, VAR_RESULT
    Return
_0999:
    AddVar VAR_0x8005, 1
    GoTo _0C18
_09A5:
    SetVarFromVar VAR_MAP_LOCAL_0x01, VAR_MAP_LOCAL_0x00
    Return
_09AD:
    SetVarFromVar VAR_MAP_LOCAL_0x02, VAR_MAP_LOCAL_0x00
    Return
_09B5:
    SetVarFromVar VAR_MAP_LOCAL_0x03, VAR_MAP_LOCAL_0x00
    Return
_09BD:
    SetVarFromVar VAR_MAP_LOCAL_0x04, VAR_MAP_LOCAL_0x00
    Return
_09C5:
    SetVarFromVar VAR_MAP_LOCAL_0x05, VAR_MAP_LOCAL_0x00
    Return
_09CD:
    SetVarFromVar VAR_MAP_LOCAL_0x06, VAR_MAP_LOCAL_0x00
    Return
_09D5:
    SetVarFromVar VAR_MAP_LOCAL_0x07, VAR_MAP_LOCAL_0x00
    Return
_09DD:
    AddVar VAR_0x8004, 1
    AddVar VAR_0x8005, 1
    CompareVar VAR_0x8004, VAR_0x8001
    GoToIf 5, _0C18
    AddMenuEntry 45, VAR_0x8004
    ShowMenu
    CompareVar VAR_0x8000, 255
    GoToIf 1, _0C09
    CompareVar VAR_0x8000, 0
    CallIf 1, _0CF5
    CompareVar VAR_0x8000, 1
    CallIf 1, _0CFD
    CompareVar VAR_0x8000, 2
    CallIf 1, _0D05
    CompareVar VAR_0x8000, 3
    CallIf 1, _0D0D
    CompareVar VAR_0x8000, 4
    CallIf 1, _0D15
    CompareVar VAR_0x8000, 5
    CallIf 1, _0D1D
    CompareVar VAR_0x8000, 6
    CallIf 1, _0D25
    GetSpeciesFromFossil VAR_HGSS_UNK_407F, VAR_0x8002
    CompareVar VAR_HGSS_UNK_407F, 0
    GoToIf 1, _0C09
    BufferItemName 0, VAR_0x8002
    Message msg_0464_T03R0101_00007
    ShowYesNoMenu VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 1, _0C09
    RemoveItem VAR_0x8002, 1, VAR_RESULT
    GoTo _03B9
_0AA8:
    ApplyMovement LOCALID_PLAYER, _0DEB
    ApplyMovement obj_T03R0101_gsmiddleman1, _0D49
    WaitMovement
    CompleteFollowerWait
    CompleteFollowerPause 1
    CompleteFollowerSetMovementType MOVEMENT_TYPE_FOLLOW_PLAYER
    CompleteFollowerCheckActive VAR_RESULT
    CompareVar VAR_RESULT, 1
    GoToIf 5, _0B19
    ApplyMovement LOCALID_COMPLETE_FOLLOWER, _0D8B
    WaitMovement
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
_0B19:
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
_0B53:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    WaitTime 10, VAR_RESULT
    ApplyMovement obj_T03R0101_gsassistantm, _0DB5
    WaitMovement
    Message msg_0464_T03R0101_00019
    CloseMessage
    ApplyMovement obj_T03R0101_gsassistantm, _0DC9
    WaitMovement
    RemoveItem ITEM_ENIGMA_STONE, 1, VAR_RESULT
    SetVarFromValue VAR_0x8004, ITEM_SOUL_DEW
    SetVarFromValue VAR_0x8005, 1
    Common_GiveItemQuantityNoLineFeed
    CloseMessage
    ApplyMovement 8, _0DDF
    WaitMovement
    ApplyMovement LOCALID_PLAYER, _0D53
    WaitMovement
    Message msg_0464_T03R0101_00021
    CloseMessage
    ApplyMovement 8, _0DE5
    WaitMovement
    SetVarFromValue VAR_HGSS_UNK_4083, 2
    RemoveObject 8
    ReleaseAll
    End
_0BC9:
    GetDayOfWeek VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 1, _0D2D
    CompareVar VAR_MAP_LOCAL_0x00, 0
    GoToIf 1, _0D2D
    SetFlag FLAG_HGSS_HIDE_CAMERON
    End
_0BED:
    ReleaseAll
    End
_0BF5:
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    ReleaseAll
    End
_0C09:
    SetVarFromValue VAR_HGSS_UNK_407F, 0
    Message msg_0464_T03R0101_00002
    GoTo _0590
_0C18:
    CompareVar VAR_0x8005, 0
    CallIf 1, _0929
    CompareVar VAR_0x8005, 1
    CallIf 1, _0939
    CompareVar VAR_0x8005, 2
    CallIf 1, _0949
    CompareVar VAR_0x8005, 3
    CallIf 1, _0959
    CompareVar VAR_0x8005, 4
    CallIf 1, _0969
    CompareVar VAR_0x8005, 5
    CallIf 1, _0979
    CompareVar VAR_0x8005, 6
    CallIf 1, _0989
    CompareVar VAR_RESULT, 0
    GoToIf 1, _0999
    CompareVar VAR_0x8004, 0
    CallIf 1, _09A5
    CompareVar VAR_0x8004, 1
    CallIf 1, _09AD
    CompareVar VAR_0x8004, 2
    CallIf 1, _09B5
    CompareVar VAR_0x8004, 3
    CallIf 1, _09BD
    CompareVar VAR_0x8004, 4
    CallIf 1, _09C5
    CompareVar VAR_0x8004, 5
    CallIf 1, _09CD
    CompareVar VAR_0x8004, 6
    CallIf 1, _09D5
    SetVarFromVar VAR_0x8006, VAR_0x8005
    AddVar VAR_0x8006, 159
    AddMenuEntry VAR_0x8006, VAR_0x8004
    GoTo _09DD
_0CF5:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x01
    Return
_0CFD:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x02
    Return
_0D05:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x03
    Return
_0D0D:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x04
    Return
_0D15:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x05
    Return
_0D1D:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x06
    Return
_0D25:
    SetVarFromVar VAR_0x8002, VAR_MAP_LOCAL_0x07
    Return
_0D2D:
    ClearFlag FLAG_HGSS_HIDE_CAMERON
    End
    .balign 4, 0
_0D33:
    WalkNormalWest
    WalkNormalNorth 2
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0D49:
    Delay8
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0D53:
    WalkOnSpotNormalWest
    EndMovement
    .balign 4, 0
_0D59:
    Delay8
    EmoteExclamationMark
    EndMovement
    .balign 4, 0
_0D63:
    LockDir
    WalkNormalEast
    UnlockDir
    EndMovement
    .balign 4, 0
_0D71:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0D77:
    WalkNormalEast
    WalkNormalSouth
    EndMovement
    .balign 4, 0
_0D81:
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
_0D8B:
    WalkNormalEast
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0D99:
    WalkNormalEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0DA3:
    WalkNormalSouth
    Delay8
    WalkNormalNorth
    FaceSouth
    EndMovement
    .balign 4, 0
_0DB5:
    WalkOnSpotNormalNorth
    EndMovement
    .balign 4, 0
_0DBB:
    WalkFasterNorth
    WalkFasterEast
    FaceSouth
    EndMovement
    .balign 4, 0
_0DC9:
    WalkNormalNorth
    WalkOnSpotNormalNorth
    LockDir
    WalkNormalSouth
    UnlockDir
    EndMovement
    .balign 4, 0
_0DDF:
    FaceEast
    EndMovement
    .balign 4, 0
_0DE5:
    WalkNormalWest 8
    EndMovement
    .balign 4, 0
_0DEB:
    WalkNormalNorth
    WalkNormalEast
    WalkNormalNorth 3
    WalkOnSpotNormalSouth
    EndMovement
    .balign 4, 0
