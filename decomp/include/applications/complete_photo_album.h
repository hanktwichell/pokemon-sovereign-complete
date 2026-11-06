#ifndef POKEPLATINUM_APPLICATIONS_COMPLETE_PHOTO_ALBUM_H
#define POKEPLATINUM_APPLICATIONS_COMPLETE_PHOTO_ALBUM_H

#include "field/field_system_decl.h"
#include "overlay_manager.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's photo album (its overlay 109; src/applications/complete_photo_album/): the album's
// pages of photos, where one is picked to look at, deleted or moved. Its arguments are HeartGold's PhotoAlbumArgs.
typedef struct CompletePhotoAlbumArgs {
    u8 unused0;
    u8 photoWasSelected; // out: a photo to look at
    u8 cursorPos; // in: the photo the album opens on; out: the one picked
    u8 unused3[5];
    int *menuInputState; // touch or buttons, kept as the field's
    SaveData *saveData;
} CompletePhotoAlbumArgs;

BOOL CompletePhotoAlbum_AppInit(ApplicationManager *appMan, int *state);
BOOL CompletePhotoAlbum_AppMain(ApplicationManager *appMan, int *state);
BOOL CompletePhotoAlbum_AppExit(ApplicationManager *appMan, int *state);

// src/complete_photo.c (main): HeartGold's PhotoAlbum_LaunchApp; the arguments are freed by the caller
CompletePhotoAlbumArgs *CompletePhotoAlbum_LaunchApp(FieldSystem *fieldSystem, u8 cursorPos);

#endif // POKEPLATINUM_APPLICATIONS_COMPLETE_PHOTO_ALBUM_H
