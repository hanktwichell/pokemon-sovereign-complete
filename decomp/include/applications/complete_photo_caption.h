#ifndef POKEPLATINUM_APPLICATIONS_COMPLETE_PHOTO_CAPTION_H
#define POKEPLATINUM_APPLICATIONS_COMPLETE_PHOTO_CAPTION_H

#include "field/field_system_decl.h"

#include "bg_window.h"

// Sovereign Complete: HeartGold's photo viewer's bottom screen (src/applications/complete_photo_caption/, an overlay in
// the Pokétch's place), the field's bottom screen while a photo shows (include/complete_photo.h); the field starts and
// ends it as it does the Pokétch (src/overlay005/ov5_021EA714.c)
void CompletePhotoCaption_Create(FieldSystem *fieldSystem, BgConfig *bgConfig);
void CompletePhotoCaption_StartShutdown(void);
BOOL CompletePhotoCaption_IsShutdown(void);

#endif // POKEPLATINUM_APPLICATIONS_COMPLETE_PHOTO_CAPTION_H
