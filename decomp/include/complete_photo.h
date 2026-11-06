#ifndef POKEPLATINUM_COMPLETE_PHOTO_H
#define POKEPLATINUM_COMPLETE_PHOTO_H

#include <nitro/rtc.h>

#include "constants/heap.h"
#include "constants/pokemon.h"
#include "constants/string.h"

#include "field/field_system_decl.h"
#include "savedata.h"

// Sovereign Complete: HeartGold's photo album. Cameron the photographer takes the player's photo at HeartGold's photo
// spots (its CameronPhoto: the map loads again at the spot with no one else on it, the party around the player, the
// viewfinder and the shutter); the photos go in an album of 36 that the Pokémon Center's PC opens, where a photo
// shows again as it was taken (the map at the spot, the hour it was taken). src/complete_photo.c (main: the save, the
// field's tasks, which run while the map is gone), src/applications/complete_photo_album/ (the album, HeartGold's
// overlay 109) and src/applications/complete_photo_caption/ (the bottom screen while a photo shows, HeartGold's
// view_photo.c). Its data is HeartGold's (tools/complete/import_hgss_photos.py).

#define COMPLETE_PHOTO_ALBUM_MAX 36
#define COMPLETE_PHOTO_ALBUM_MAGIC 0x50484F54 // "PHOT": an album this game wrote

// HeartGold's PhotoMon
typedef struct CompletePhotoMon {
    u16 species;
    u8 form;
    u8 shiny : 1;
    u8 gender : 2;
    u8 padding : 5;
} CompletePhotoMon;

// HeartGold's Photo, with the photo spot's number for what HeartGold copied out of it
typedef struct CompletePhoto {
    u8 spot; // 1 + the photo spot (0: an empty page)
    u8 icon; // the album's picture for the place
    u8 numMons; // in the photo (1 with a person: they and the lead)
    u8 playerState : 4; // walking, cycling, surfing... (PlayerData's playerState)
    u8 gender : 1; // the player's
    u8 padding : 3;
    u16 mapHeaderID;
    u16 x;
    u16 z;
    u16 subjectGfx; // the person in it (OBJ_EVENT_GFX_*), 0 for the party
    u8 hour;
    u8 minute;
    u32 date; // year << 24 | month << 16 | day << 8 | weekday, as HeartGold's
    u16 leadMonNick[MON_NAME_LEN + 1];
    CompletePhotoMon party[MAX_PARTY_SIZE];
} CompletePhoto;

typedef struct CompletePhotoAlbum {
    u32 magic;
    CompletePhoto photos[COMPLETE_PHOTO_ALBUM_MAX];
} CompletePhotoAlbum;

// A photo spot (the archive's member 16), HeartGold's PhotoData in the engine's numbers
typedef struct CompletePhotoSpot {
    u16 mapHeaderID;
    u16 icon;
    u16 x;
    u16 z;
    u16 subjectGfx;
    u16 hiddenProps[2]; // building models taken out of the shot
    u16 padding;
} CompletePhotoSpot;

#define COMPLETE_PHOTO_NARC_SPOTS 16 // the photo album archive's members (tools/complete/import_hgss_photos.py)
#define COMPLETE_PHOTO_NARC_VIEWFINDER_PALETTE 13
#define COMPLETE_PHOTO_NARC_VIEWFINDER_TILES 14
#define COMPLETE_PHOTO_NARC_VIEWFINDER_SCREEN 15

// The album is in its own sector after the battle videos (EXTRA_SAVE_TABLE_ENTRY_COMPLETE_PHOTO_ALBUM), so the save's
// blocks keep their sizes and earlier saves load (theirs reads as an empty album); a new game clears it
int CompletePhotoAlbum_SaveSize(void);
void CompletePhotoAlbum_Init(CompletePhotoAlbum *album);
CompletePhotoAlbum *CompletePhotoAlbum_Load(SaveData *saveData, enum HeapID heapID); // allocated; free with Heap_Free
void CompletePhotoAlbum_Save(SaveData *saveData, CompletePhotoAlbum *album);
u8 CompletePhotoAlbum_Count(const CompletePhotoAlbum *album);
u8 CompletePhotoAlbum_CountSaved(SaveData *saveData); // CountSavedPhotos
void CompletePhotoAlbum_Delete(CompletePhotoAlbum *album, u8 index); // the photos after it move up
void CompletePhotoAlbum_Swap(CompletePhotoAlbum *album, u8 a, u8 b);

// The map loads as a photo (HeartGold's fieldSystem->unkAC): no one but the player, no map scripts
BOOL CompletePhoto_IsPhotoMode(void);
// The clock as a photo shows it (the hour it was taken): the RTC's reads are kept at it
void CompletePhoto_ApplyFrozenTime(RTCTime *time);

// The scripts' commands (src/complete_scrcmd.c)
void CompletePhoto_StartTakePhoto(FieldSystem *fieldSystem, u16 spot); // CameronPhoto
void CompletePhoto_StartViewAlbum(FieldSystem *fieldSystem); // OpenPhotoAlbum, with the field map ended

// The photo the bottom screen describes as it shows (src/applications/complete_photo_caption/)
typedef struct CompletePhotoShowing {
    CompletePhoto photo;
    u8 index; // in the album
    u8 count; // the album's photos
    u8 input; // the player's answer (enum CompletePhotoInput)
} CompletePhotoShowing;

enum CompletePhotoInput {
    COMPLETE_PHOTO_INPUT_NONE = 0,
    COMPLETE_PHOTO_INPUT_EXIT,
    COMPLETE_PHOTO_INPUT_PREV,
    COMPLETE_PHOTO_INPUT_NEXT,
};

CompletePhotoShowing *CompletePhoto_Showing(void); // NULL when no photo shows

#endif // POKEPLATINUM_COMPLETE_PHOTO_H
