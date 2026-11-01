#ifndef POKEPLATINUM_COMPLETE_SINNOH_H
#define POKEPLATINUM_COMPLETE_SINNOH_H

#include <nitro.h>

// Sovereign Complete: Sinnoh as the third region, after Johto and Kanto (data/complete/sinnoh.yaml,
// include/data/complete_sinnoh.h; docs/Features.md, "Sinnoh, the third region").

void CompleteSinnoh_OnMapLoaded(int mapHeaderID);
int CompleteSinnoh_Level(int level);
int CompleteSinnoh_EvolvedSpecies(int species, int level);
void CompleteSinnoh_ScaleParty(int trainerID, void *party, int monDataType, int count);
u8 CompleteSinnoh_WildLevel(u8 level);

#endif // POKEPLATINUM_COMPLETE_SINNOH_H
