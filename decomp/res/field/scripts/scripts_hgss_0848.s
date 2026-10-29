#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0548.h"


    ScriptEntry scr_seq_T20R0401_000
    ScriptEntryEnd
scr_seq_T20R0401_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    GoToIfSet FLAG_HGSS_HIDE_NEW_BARK_FRIENDS_ROOM_FRIEND, _0035
    CompareVar VAR_HGSS_SCENE_ELMS_LAB, 1
    GoToIf 4, _0044
    BufferPlayerName 0
    MessageGendered msg_0548_T20R0401_00000, msg_0548_T20R0401_00001
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0035:
    BufferPlayerName 0
    MessageGendered msg_0548_T20R0401_00002, msg_0548_T20R0401_00003
    WaitButton
    CloseMessage
    ReleaseAll
    End
_0044:
    BufferPlayerName 0
    MessageGendered msg_0548_T20R0401_00004, msg_0548_T20R0401_00005
    WaitButton
    CloseMessage
    ReleaseAll
    End
    .balign 4, 0
