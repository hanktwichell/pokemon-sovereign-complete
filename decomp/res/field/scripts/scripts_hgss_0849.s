#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0549.h"


    ScriptEntry scr_seq_T20R0402_000
    ScriptEntry scr_seq_T20R0402_001
    ScriptEntry scr_seq_T20R0402_002
    ScriptEntry scr_seq_T20R0402_003
    ScriptEntry scr_seq_T20R0402_004
    ScriptEntryEnd
scr_seq_T20R0402_002:
    GoToIfSet FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND, _0025
    @ HGSS: GetFriendSprite VAR_OBJ_0
_0025:
    End
scr_seq_T20R0402_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    SetVarFromValue VAR_RESULT, 0
    CompareVar VAR_RESULT, 1
    GoToIf 1, _006D
    BufferPlayerName 0
    GoToIfSet FLAG_HGSS_GOT_STARTER, _005C
    MessageGendered msg_0549_T20R0402_00000, msg_0549_T20R0402_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_005C:
    BufferPartyMonSpecies 1, VAR_RESULT
    MessageGendered msg_0549_T20R0402_00002, msg_0549_T20R0402_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_006D:
    GetFirstNonEggInParty VAR_0x8006
    @ HGSS: GetShinyLeafCount VAR_SPECIAL_x8006, VAR_SPECIAL_RESULT
    GoToIfSet FLAG_HGSS_SHOWED_FRIEND_A_SHINY_LEAF, _00B1
    CompareVar VAR_RESULT, 1
    GoToIf 4, _009E
_008F:
    BufferPlayerName 0
    MessageGendered msg_0549_T20R0402_00005, msg_0549_T20R0402_00006
    WaitButton
    CloseMessage
    ReleaseAll
    End
_009E:
    SetFlag FLAG_HGSS_SHOWED_FRIEND_A_SHINY_LEAF
    BufferPlayerName 0
    MessageGendered msg_0549_T20R0402_00007, msg_0549_T20R0402_00008
    WaitButton
    CloseMessage
    ReleaseAll
    End
_00B1:
    SetVarFromVar VAR_0x8004, VAR_RESULT
    CompareVar VAR_0x8004, 6
    GoToIf 1, _00E4
    CompareVar VAR_0x8004, 5
    GoToIf 1, _00FC
    CompareVar VAR_0x8004, 1
    GoToIf 4, _0137
    GoTo _008F
_00E4:
    BufferPlayerName 0
    @ HGSS: GetFollowPokePartyIndex VAR_SPECIAL_RESULT
    BufferPartyMonNickname 1, VAR_RESULT
    MessageGendered msg_0549_T20R0402_00015, msg_0549_T20R0402_00016
    CloseMessage
    GoTo _010D
_00FC:
    @ HGSS: TryGiveShinyLeafCrown VAR_SPECIAL_x8006
    SetFlag FLAG_HGSS_UNK_184
    BufferPlayerName 0
    MessageGendered msg_0549_T20R0402_00011, msg_0549_T20R0402_00012
    CloseMessage
_010D:
    FadeScreen 6, 1, 0, COLOR_BLACK
    WaitFadeScreen
    @ HGSS: ShowCertificate 2
    ReturnToField
    FadeScreen 6, 1, 1, COLOR_BLACK
    WaitFadeScreen
    MessageGendered msg_0549_T20R0402_00013, msg_0549_T20R0402_00014
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0137:
    CompareVar VAR_0x8004, 1
    GoToIf 5, _0150
    SetVarFromValue VAR_0x8005, 4
    GoTo _0188
_0150:
    CompareVar VAR_0x8004, 2
    GoToIf 5, _0169
    SetVarFromValue VAR_0x8005, 3
    GoTo _0188
_0169:
    CompareVar VAR_0x8004, 3
    GoToIf 5, _0182
    SetVarFromValue VAR_0x8005, 2
    GoTo _0188
_0182:
    SetVarFromValue VAR_0x8005, 1
_0188:
    BufferPlayerName 0
    BufferNumber 1, VAR_0x8004
    BufferNumber 2, VAR_0x8005
    MessageGendered msg_0549_T20R0402_00009, msg_0549_T20R0402_00010
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0402_001:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    Message msg_0549_T20R0402_00004
    PlayCry SPECIES_MARILL, 0
    WaitCry
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0402_003:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0549_T20R0402_00017
    WaitButton
    CloseMessage
    ReleaseAll
    End
scr_seq_T20R0402_004:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    Message msg_0549_T20R0402_00018
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
