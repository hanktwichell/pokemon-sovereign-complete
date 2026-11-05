#ifndef POKEPLATINUM_APPLICATIONS_TOWN_MAP_COMPLETE_TOWN_MAP_H
#define POKEPLATINUM_APPLICATIONS_TOWN_MAP_COMPLETE_TOWN_MAP_H

// Sovereign Complete: the three-region Town Map. One map the cursor and the view scroll across: Sinnoh as Platinum
// shows it, and Johto and Kanto (HeartGold's map) to its south-west (tools/complete/import_town_map.py). Hooks in
// main.c and graphics.c call these.

#include "applications/town_map/defs.h"
#include "bg_window.h"

// The top screen's layers: the frame in front (layer 0), Sinnoh's map (2) and Johto and Kanto's on the sea (3), each
// map 512 by 512 with tiles of its own
// The Town Map's heap grows by this much (src/applications/town_map/main.c): its sprite manager holds HeartGold's 30
// Fly points too (sprites.c), and the three regions' map graphics load into it
#define COMPLETE_TOWN_MAP_HEAP_EXTRA 0x4000

void CompleteTownMap_AdjustBgTemplates(BgTemplate *templates);
void CompleteTownMap_LoadGraphics(TownMapAppData *appData);
// The maps' tilemaps and the frame, in place of Platinum's two map layers; TRUE (always) so it copies neither
BOOL CompleteTownMap_DrawMaps(TownMapAppData *appData);
// A hidden place shown on Sinnoh's map (its patch); TRUE so Platinum's top screen copies are left out
BOOL CompleteTownMap_ShowHiddenLocation(TownMapAppData *appData, int location);
// After the sprites are made: the view on the player's region, HeartGold's Fly points
void CompleteTownMap_Start(TownMapAppData *appData);
// The cursor between and in Johto and Kanto; TRUE when it handled the input
BOOL CompleteTownMap_HandleInput(TownMapAppData *appData, int heldKeys);
// Fly: TRUE when it decided (*canFly then says whether the cursor's place is a destination now)
BOOL CompleteTownMap_CanFly(TownMapAppData *appData, BOOL *canFly);
void CompleteTownMap_Free(TownMapAppData *appData);

#endif // POKEPLATINUM_APPLICATIONS_TOWN_MAP_COMPLETE_TOWN_MAP_H
