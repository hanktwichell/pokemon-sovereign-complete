#ifndef POKEPLATINUM_COMPLETE_PLACED_H
#define POKEPLATINUM_COMPLETE_PLACED_H

#include "field/field_system_decl.h"

#include "map_header_data.h"
#include "script_manager.h"

// Sovereign Complete: Sovereign's Totem trials and legendaries placed on other maps than Sovereign put them (the
// owner's call, Nov 1, 2026: spread over Johto, Kanto and Sinnoh). data/complete/placed.yaml, through
// tools/complete/gen_placed.py, is include/data/complete_placed.h.

enum CompletePlacedKind {
    PLACED_TOTEM = 0, // value: the trial (TOTEM_TRIAL_*)
    PLACED_LEGENDARY, // value: the species, at its level
};

enum CompletePlacedGateType {
    PLACED_GATE_FLAG = 0, // the flag is set
    PLACED_GATE_FLAG_CLEAR, // the flag is clear
    PLACED_GATE_VAR, // the var is at least value
    PLACED_GATE_BADGE, // Sinnoh's badge (BADGE_ID_*)
    PLACED_GATE_HGSS_BADGE, // Johto's or Kanto's badge (BADGE_ID_HGSS_*)
    PLACED_GATE_CAUGHT, // the Pokédex has the species as caught
    PLACED_GATE_ITEM, // the item is in the bag
    PLACED_GATE_PARTY, // the species is in the party
    PLACED_GATE_NIGHT, // it's night
};

#define PLACED_MAX_GATES 4
// Placed objects' local IDs: this plus their index in sCompletePlaced, clear of every map's own
#define PLACED_LOCALID_BASE 0x200
#define SCRIPT_ID_COMPLETE_PLACED SCRIPT_ID(COMMON_SCRIPTS, 74) // CommonScript_CompletePlaced

typedef struct CompletePlacedGate {
    u8 type;
    u16 id;
    u16 value;
} CompletePlacedGate;

typedef struct CompletePlaced {
    u16 mapHeaderID;
    u16 x;
    u16 z;
    u16 graphicsID;
    u16 value;
    u8 kind;
    u8 level;
    u8 dir;
    u8 numGates;
    CompletePlacedGate gates[PLACED_MAX_GATES];
} CompletePlaced;

typedef struct CompletePlacedMoved {
    u16 mapHeaderID;
    u16 localID;
} CompletePlacedMoved;

void CompletePlaced_OnEventsLoaded(FieldSystem *fieldSystem, MapHeaderData *data, int mapHeaderID);
BOOL CompletePlaced_Get(int localID, u16 *kind, u16 *value, u16 *level);
void CompletePlaced_OnLoad(FieldSystem *fieldSystem);
int CompletePlaced_TotemLevelShift(int trial);

#endif // POKEPLATINUM_COMPLETE_PLACED_H
