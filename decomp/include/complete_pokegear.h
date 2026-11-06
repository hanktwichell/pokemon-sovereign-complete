#ifndef POKEPLATINUM_COMPLETE_POKEGEAR_H
#define POKEPLATINUM_COMPLETE_POKEGEAR_H

#include "bg_window.h"
#include "field/field_system_decl.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's Pokégear beside Platinum's Pokétch (the owner's call, Nov 3, 2026: both, with a
// button to switch). The field's bottom screen is one of three: Platinum's "no Pokétch" screen, the Pokétch, or the
// Pokégear (src/applications/complete_pokegear/, an overlay in the Pokétch's place). The Pokégear shows once the
// player has it (FLAG_HGSS_GOT_POKEGEAR) and either has no Pokétch or last switched to the Pokégear (a bit in the
// Pokétch's save); a script hiding the Pokétch hides it too. src/overlay005/ov5_021EA714.c starts and ends the one
// wanted; src/overlay005/complete_bottom_screen.c switches them as the field runs.

enum CompleteBottomScreen {
    COMPLETE_BOTTOM_SCREEN_UNAVAILABLE = 0,
    COMPLETE_BOTTOM_SCREEN_POKETCH,
    COMPLETE_BOTTOM_SCREEN_POKEGEAR,
    COMPLETE_BOTTOM_SCREEN_PHOTO, // a photo from the album shows (include/complete_photo.h)
};

// src/complete_pokegear_state.c (main)
BOOL CompletePokegear_IsOwned(SaveData *saveData);
BOOL CompletePokegear_PoketchAvailable(SaveData *saveData); // the Pokétch to switch to: owned, not hidden
// HeartGold's Pokégear cards (its RegisterPokegearCard): the Map Card, which Cherrygrove City's guide gives after his
// tour (VAR_HGSS_SCENE_CHERRYGROVE_CITY_OW 2 on), and the Radio Card, the Radio Tower's quiz prize
// (FLAG_HGSS_GOT_RADIO_CARD); without one, its app's button is dark, as in HeartGold
enum CompletePokegearCard {
    COMPLETE_POKEGEAR_CARD_MAP = 0,
    COMPLETE_POKEGEAR_CARD_RADIO,
};

BOOL CompletePokegear_HasCard(SaveData *saveData, enum CompletePokegearCard card);
enum CompleteBottomScreen CompleteBottomScreen_Wanted(SaveData *saveData);
enum CompleteBottomScreen CompleteBottomScreen_Active(void);
void CompleteBottomScreen_SetActive(enum CompleteBottomScreen screen);
void CompleteBottomScreen_RequestSwitch(SaveData *saveData); // the switch button: the other of Pokétch and Pokégear
BOOL CompleteBottomScreen_SwitchDue(SaveData *saveData);
u8 CompletePokegear_GetPage(void); // the page the Pokégear was last on, as HeartGold's comes back to its last app
void CompletePokegear_SetPage(u8 page);

// HeartGold's six Pokégear skins (its settings app; all six from the start, as HeartGold has them), saved with the phone
#define COMPLETE_POKEGEAR_SKINS 6
u8 CompletePokegear_GetSkin(SaveData *saveData);
void CompletePokegear_SetSkin(SaveData *saveData, u8 skin);

// Fly over Johto and Kanto on the Pokégear's map (HeartGold's fly map; CompleteScrCmd_FlyMap): the field asks, the
// Pokégear's Map shows the Fly points reached with HeartGold's cursor, and the player picks one (its spawn point) or
// backs out. Kept here, as the field's script waits on it while the Pokégear's overlay runs.
enum CompletePokegearFly {
    COMPLETE_POKEGEAR_FLY_NONE = 0,
    COMPLETE_POKEGEAR_FLY_CHOOSING, // asked: the Pokégear shows the choice
    COMPLETE_POKEGEAR_FLY_CHOSEN,
    COMPLETE_POKEGEAR_FLY_CANCELLED, // backed out, or nowhere to fly yet
};

enum CompletePokegearFly CompletePokegear_GetFly(u16 *spawn);
void CompletePokegear_SetFly(enum CompletePokegearFly state, u16 spawn);

// src/overlay005/complete_bottom_screen.c (the field): starts the switch when one is due
BOOL CompleteBottomScreen_TrySwitch(FieldSystem *fieldSystem);


// src/applications/complete_pokegear/pokegear.c (the complete_pokegear overlay): like the Pokétch's system, the
// Pokégear runs in a task of its own until it's shut down, and the pointer is cleared then
void CompletePokegear_Create(FieldSystem *fieldSystem, BgConfig *bgConfig);
void CompletePokegear_StartShutdown(void);
BOOL CompletePokegear_IsShutdown(void);

#ifdef SOVEREIGN_TEST
extern void *gCompleteTestPokegear;
extern u16 gCompleteTestPokegearMap[8];
#endif

#endif // POKEPLATINUM_COMPLETE_POKEGEAR_H
