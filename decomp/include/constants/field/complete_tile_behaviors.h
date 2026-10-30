#ifndef POKEPLATINUM_CONSTANTS_FIELD_COMPLETE_TILE_BEHAVIORS_H
#define POKEPLATINUM_CONSTANTS_FIELD_COMPLETE_TILE_BEHAVIORS_H

// Sovereign Complete: the tile behaviours Johto and Kanto's maps bring that Platinum has no name for, at the numbers
// tools/complete/import_hgss_maps.py gives them. Most keep HeartGold's number, which Platinum's maps never use; the
// ladders move, since Platinum's maps use HeartGold's numbers for them (0x3C-0x3E), and so does magma, since Platinum's
// reflective water is HeartGold's magma number (0x2C). Each has HeartGold's behaviour: Headbutt trees, whirlpools
// and the ladders in src/overlay005/field_control.c, magma in src/complete_gyms.c (Blackthorn Gym's lava), and the
// stop tile in src/overlay005/ov5_021E1154.c, with Platinum's slides.
#define TILE_BEHAVIOR_COMPLETE_HEADBUTT     0x06
#define TILE_BEHAVIOR_COMPLETE_LADDER_NORTH 0x0D // HeartGold: 0x3C
#define TILE_BEHAVIOR_COMPLETE_LADDER_SOUTH 0x0E // HeartGold: 0x3D
#define TILE_BEHAVIOR_COMPLETE_LADDER_DOWN  0x0F // HeartGold: 0x3E
#define TILE_BEHAVIOR_COMPLETE_WHIRLPOOL    0x11
#define TILE_BEHAVIOR_COMPLETE_MAGMA        0x2B // HeartGold: 0x2C
#define TILE_BEHAVIOR_COMPLETE_STOP_SLIDING 0x4D

#endif // POKEPLATINUM_CONSTANTS_FIELD_COMPLETE_TILE_BEHAVIORS_H
