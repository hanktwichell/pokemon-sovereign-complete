#ifndef POKEPLATINUM_COMPLETE_UNOWN_REPORT_H
#define POKEPLATINUM_COMPLETE_UNOWN_REPORT_H

#include "field/field_system_decl.h"

#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Unown Report, the key item the researchers give in the Ruins of Alph's inner chamber.
// Its screen (HeartGold's overlay 113, written in C from its assembly: src/applications/complete_unown_report/) is a
// book over both screens: a cover with the number of Unown kinds, pages of the Unown (their icons and their words),
// then the research reports, one more page each time the researchers find something (VAR_HGSS_UNOWN_REPORT_LEVEL,
// which the Ruins' scripts raise). HeartGold lists the Unown caught; Platinum's Pokédex keeps the forms seen, which the report
// lists, as the Ruins' scripts count them (GetUnownFormsSeenCount).

typedef struct CompleteUnownReportArgs {
    int *menuInputState; // the touch screen or the buttons, last used (HeartGold's MenuInputStateMgr)
    SaveData *saveData;
} CompleteUnownReportArgs;

// src/complete_unown_report.c (main)
#ifdef SOVEREIGN_TEST
extern u8 gCompleteTestUnownReportPage; // test build: the page shown, from 1 (tools/complete/test_unown_report.py)
#endif
void CompleteUnownReport_Launch(FieldSystem *fieldSystem); // the screen as the field's application
void *CompleteUnownReport_LaunchRegistered(void *fieldSystem); // the same, for the registered item (Y)

// src/applications/complete_unown_report/ (overlay complete_unown_report)
BOOL CompleteUnownReport_Init(ApplicationManager *appMan, int *state);
BOOL CompleteUnownReport_Main(ApplicationManager *appMan, int *state);
BOOL CompleteUnownReport_Exit(ApplicationManager *appMan, int *state);

#endif // POKEPLATINUM_COMPLETE_UNOWN_REPORT_H
