#include "macros/scrcmd.inc"
#include "res/text/bank/hgss_msg_0149.h"

#define obj_D52R0102_tsure_poke_static_kyogre 0

    ScriptEntry scr_seq_D52R0102_000
    ScriptEntry scr_seq_D52R0102_001
    ScriptEntry scr_seq_D52R0102_002
    ScriptEntryEnd
scr_seq_D52R0102_001:
    CompareVar VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    GoToIf 4, _00A1
    SetVarFromValue VAR_MAP_LOCAL_0x00, 7
    CompareVar VAR_MAP_LOCAL_0x00, 7
    GoToIf 5, _00A3
    GoTo _00A9
scr_seq_D52R0102_002:
    GoToIfSet FLAG_HGSS_ENGAGING_STATIC_POKEMON, _00CF
    End
scr_seq_D52R0102_000:
    PlaySE SE_CONFIRM_sseq_3
    LockAll
    FacePlayer
    PlayCry SPECIES_KYOGRE, 0
    Message msg_0149_D52R0102_00000
    WaitCry
    CloseMessage
    SetFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CompleteStartWildBattle SPECIES_KYOGRE, 70, 0
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    CheckWonBattle VAR_RESULT
    CompareVar VAR_RESULT, 0
    GoToIf 1, _00DD
    CompleteGetBattleResult VAR_MAP_LOCAL_0x02
    CompareVar VAR_MAP_LOCAL_0x02, 3
    GoToIf 1, _00E3
    CompareVar VAR_MAP_LOCAL_0x02, 4
    GoToIf 1, _00F2
    Message msg_0149_D52R0102_00001
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    ReleaseAll
    End
_00A1:
    End
_00A3:
    GoTo _012E
_00A9:
    GoToIfSet FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE, _00A1
    CheckItem ITEM_BLUE_ORB, 1, VAR_MAP_LOCAL_0x00
    CompareVar VAR_MAP_LOCAL_0x00, 1
    GoToIf 4, _0138
    GoTo _012E
_00CF:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_KYOGRE
    RemoveObject obj_D52R0102_tsure_poke_static_kyogre
    ClearFlag FLAG_HGSS_ENGAGING_STATIC_POKEMON
    End
_00DD:
    BlackOutFromBattle
    ReleaseAll
    End
_00E3:
    Message msg_0149_D52R0102_00001
    WaitButton
    CloseMessage
    SetFlag FLAG_HGSS_BEAT_OR_ESCAPED_FROM_GROUDON_OR_KYOGRE
    ReleaseAll
    End
_00F2:
    Message msg_0149_D52R0102_00005
    Message msg_0149_D52R0102_00006
    RemoveItem ITEM_BLUE_ORB, 1, VAR_RESULT
    SetVar VAR_0x8004, ITEM_JADE_ORB
    SetVar VAR_0x8005, 1
    Common_GiveItemQuantity
    CloseMessage
    SetVarFromValue VAR_HGSS_SCENE_EMBEDDED_TOWER, 4
    SetFlag FLAG_HGSS_CAUGHT_KYOGRE
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_KYOGRE_HIKER
    GoTo _0142
_012E:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_KYOGRE
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_KYOGRE_HIKER
    End
_0138:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_KYOGRE_HIKER
    ClearFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_KYOGRE
    End
_0142:
    SetFlag FLAG_HGSS_HIDE_EMBEDDED_TOWER_KYOGRE_HIKER
    SetFlag FLAG_HGSS_HIDE_ROUTE_47_EMBEDDED_TOWER_HIKER
    ReleaseAll
    End
    .balign 4, 0
