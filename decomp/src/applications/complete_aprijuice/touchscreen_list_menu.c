// Sovereign Complete: the Apricorn Box's (HeartGold's overlay 59's) touch-screen list menu. It is HeartGold's
// TouchscreenListMenu, as Voltorb Flip's port has it, but that one is in Voltorb Flip's overlay, which isn't loaded
// while the box runs: this is the same file compiled again into the box's overlay under names of its own
// (hgss_compat.inc maps HeartGold's names to these).

#define TouchscreenListMenuSpawner_Create HgssCompat_TouchscreenListMenuSpawner_Create
#define TouchscreenListMenuSpawner_Destroy HgssCompat_TouchscreenListMenuSpawner_Destroy
#define TouchscreenListMenu_Create HgssCompat_TouchscreenListMenu_Create
#define TouchscreenListMenu_CreateWithAlignment HgssCompat_TouchscreenListMenu_CreateWithAlignment
#define TouchscreenListMenu_CreateWithCallback HgssCompat_TouchscreenListMenu_CreateWithCallback
#define TouchscreenListMenu_WasLastInputTouch HgssCompat_TouchscreenListMenu_WasLastInputTouch
#define TouchscreenListMenu_Destroy HgssCompat_TouchscreenListMenu_Destroy
#define TouchscreenListMenu_DestroyButtons HgssCompat_TouchscreenListMenu_DestroyButtons
#define TouchscreenListMenu_HandleInput HgssCompat_TouchscreenListMenu_HandleInput

#include "../complete_voltorb_flip/touchscreen_list_menu.c"
