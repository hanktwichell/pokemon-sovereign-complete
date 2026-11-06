#include "applications/town_map/complete_town_map.h"

#include <nitro.h>
#include <string.h>

#include "constants/field/map.h"
#include "constants/hgss_spawns.h"
#include "constants/narc.h"
#include "generated/map_headers.h"

#include "applications/town_map/defs.h"
#include "applications/town_map/main.h"

#include "bg_window.h"
#include "complete_map_info.h"
#include "font.h"
#include "heap.h"
#include "location.h"
#include "map_header.h"
#include "map_header_util.h"
#include "map_matrix.h"
#include "message.h"
#include "narc.h"
#include "sound_playback.h"
#include "spawn_locations.h"
#include "sprite.h"
#include "sprite_system.h"
#include "string_gf.h"
#include "system.h"
#include "text.h"

#include "data/complete_town_map.h"
#include "res/graphics/sprite_templates/town_map.h"

// Sovereign Complete: the three-region Town Map (include/applications/town_map/complete_town_map.h). The canvas is
// 512 by 512 pixels; the map's window on the top screen is the frame's inside. Scrolled to Sinnoh (SINNOH_SCROLL_*),
// the screen is Platinum's map pixel for pixel, so Platinum's cursor and sprites keep their places there; in Johto
// and Kanto the view follows the cursor, which moves a block (8 pixels, HeartGold's map's cell) a step.

#define VIEW_LEFT        (COMPLETE_TOWN_MAP_VIEW_X * 8)
#define VIEW_RIGHT       ((COMPLETE_TOWN_MAP_VIEW_X + COMPLETE_TOWN_MAP_VIEW_W) * 8)
#define VIEW_BOTTOM      ((COMPLETE_TOWN_MAP_VIEW_Y + COMPLETE_TOWN_MAP_VIEW_H) * 8)
#define SINNOH_SCROLL_X  ((COMPLETE_TOWN_MAP_SINNOH_X - COMPLETE_TOWN_MAP_VIEW_X) * 8)
#define SINNOH_SCROLL_Y  0
#define CANVAS_PIXELS    (COMPLETE_TOWN_MAP_CANVAS * 8)
#define CANVAS_USED      ((COMPLETE_TOWN_MAP_HGSS_Y + 20) * 8) // the canvas's height in use: down to Kanto's south
#define SCROLL_X_MIN     (-VIEW_LEFT)
#define SCROLL_X_MAX     (CANVAS_PIXELS - VIEW_RIGHT)
#define SCROLL_Y_MAX     (CANVAS_USED - VIEW_BOTTOM)
#define HGSS_ROWS_DOWN   2 // HeartGold's map has two rows over the overworld's first
#define OFF_SCREEN_Y     216
#define SINNOH_X_MIN     1 // Platinum's cursor's range (HandleInput)
#define SINNOH_X_MAX     28
#define SINNOH_Z_MIN     6
#define SINNOH_Z_MAX     28
#define REPEAT_FIRST     8
#define REPEAT_NEXT      3
#define MAX_SAVED        (32 + TOWN_MAP_HISTORY_LENGTH + 1)
#define HGSS_START_X     11 // the cursor's first place in Johto and Kanto when the player isn't on the map: Goldenrod
#define HGSS_START_Y     11

enum {
    REGION_SINNOH,
    REGION_HGSS,
};

typedef struct CompleteTownMap {
    u8 region;
    u8 heldFrames;
    s16 hgX, hgY;
    int scrollX, scrollY;
    MapMatrix *matrix; // HeartGold's overworld, for its places
    int flyCount;
    s16 flyX[SPAWN_HGSS_COUNT], flyY[SPAWN_HGSS_COUNT];
    u8 flySpawn[SPAWN_HGSS_COUNT];
    Sprite *flySprites[SPAWN_HGSS_COUNT];
    int savedCount;
    Sprite *saved[MAX_SAVED]; // Sinnoh's sprites, put out of sight while the view is on Johto and Kanto
    VecFx32 savedPos[MAX_SAVED];
} CompleteTownMap;

static CompleteTownMap sMap;

static BOOL HandleInput(TownMapAppData *appData, int heldKeys);
static void NoteView(TownMapAppData *appData);

void CompleteTownMap_AdjustBgTemplates(BgTemplate *templates)
{
    templates[BG_LAYER_MAIN_0].priority = 1; // the frame, in front of the maps (the windows' layer 1 in front of it)
    templates[BG_LAYER_MAIN_1].priority = 0;

    templates[BG_LAYER_MAIN_2].screenSize = BG_SCREEN_SIZE_512x512;
    templates[BG_LAYER_MAIN_2].bufferSize = 0x2000;
    templates[BG_LAYER_MAIN_2].screenBase = GX_BG_SCRBASE_0x8000;
    templates[BG_LAYER_MAIN_2].charBase = GX_BG_CHARBASE_0x10000;
    templates[BG_LAYER_MAIN_2].priority = 2;

    templates[BG_LAYER_MAIN_3].screenSize = BG_SCREEN_SIZE_512x512;
    templates[BG_LAYER_MAIN_3].bufferSize = 0x2000;
    templates[BG_LAYER_MAIN_3].screenBase = GX_BG_SCRBASE_0xa000;
    templates[BG_LAYER_MAIN_3].charBase = GX_BG_CHARBASE_0x18000;
    templates[BG_LAYER_MAIN_3].priority = 3;
}

static void *LoadMember(NARC *narc, int member, enum HeapID heapID, u32 *size)
{
    *size = NARC_GetMemberSize(narc, member);
    void *data = Heap_AllocAtEnd(heapID, *size);
    NARC_ReadWholeMember(narc, member, data);
    return data;
}

void CompleteTownMap_LoadGraphics(TownMapAppData *appData)
{
    NARC *narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__TOWN_MAP, appData->heapID);
    u32 size;
    void *data;

    data = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_SINNOH_TILES, appData->heapID, &size);
    Bg_LoadTiles(appData->bgConfig, BG_LAYER_MAIN_2, data, size, 0);
    Heap_Free(data);
    data = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_SINNOH_PALETTES, appData->heapID, &size);
    Bg_LoadPalette(BG_LAYER_MAIN_2, data, size, COMPLETE_TOWN_MAP_SINNOH_PALETTE * 32);
    Heap_Free(data);
    data = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_HGSS_TILES, appData->heapID, &size);
    Bg_LoadTiles(appData->bgConfig, BG_LAYER_MAIN_3, data, size, 0);
    Heap_Free(data);
    data = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_HGSS_PALETTES, appData->heapID, &size);
    Bg_LoadPalette(BG_LAYER_MAIN_3, data, size, COMPLETE_TOWN_MAP_HGSS_PALETTE * 32);
    Heap_Free(data);
    NARC_dtor(narc);
}

BOOL CompleteTownMap_DrawMaps(TownMapAppData *appData)
{
    NARC *narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__TOWN_MAP, appData->heapID);
    u32 size;
    void *data;

    data = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_SINNOH_TILEMAP, appData->heapID, &size);
    Bg_LoadTilemapBuffer(appData->bgConfig, BG_LAYER_MAIN_2, data, size);
    Heap_Free(data);
    data = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_HGSS_TILEMAP, appData->heapID, &size);
    Bg_LoadTilemapBuffer(appData->bgConfig, BG_LAYER_MAIN_3, data, size);
    Heap_Free(data);
    data = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_FRAME_TILEMAP, appData->heapID, &size);
    Bg_CopyToTilemapRect(appData->bgConfig, BG_LAYER_MAIN_0, 0, 0, 32, 24, data, 0, 0, 32, 32);

    if (appData->mode != TOWN_MAP_MODE_FLY) { // Platinum's: the arrow between "Fly to where?" and the place, cleared
        Bg_CopyToTilemapRect(appData->bgConfig, BG_LAYER_MAIN_0, 16, 21, 2, 3, data, 0, 21, 32, 32);
    }

    Heap_Free(data);
    NARC_dtor(narc);

    Bg_SetOffset(appData->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_X, SINNOH_SCROLL_X);
    Bg_SetOffset(appData->bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_SET_X, SINNOH_SCROLL_X);
    Bg_SetOffset(appData->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_Y, SINNOH_SCROLL_Y);
    Bg_SetOffset(appData->bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_SET_Y, SINNOH_SCROLL_Y);
    sMap.scrollX = SINNOH_SCROLL_X;
    sMap.scrollY = SINNOH_SCROLL_Y;
    Bg_ScheduleTilemapTransfer(appData->bgConfig, BG_LAYER_MAIN_0);
    return TRUE;
}

BOOL CompleteTownMap_ShowHiddenLocation(TownMapAppData *appData, int location)
{
    NARC *narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__TOWN_MAP, appData->heapID);
    u32 size;
    u8 *patch = LoadMember(narc, COMPLETE_TOWN_MAP_MEMBER_HIDDEN_FULLMOON + location, appData->heapID, &size);
    u16 count = patch[0] | patch[1] << 8;

    for (int i = 0; i < count; i++) {
        u8 *cell = patch + 2 + i * 4;
        u16 entry = cell[2] | cell[3] << 8;
        Bg_FillTilemapRect(appData->bgConfig, BG_LAYER_MAIN_2, entry, cell[0], cell[1], 1, 1, TILEMAP_FILL_VAL_INCLUDES_PALETTE);
    }

    Heap_Free(patch);
    NARC_dtor(narc);
    return TRUE;
}

// A cell's place on the canvas: Platinum's grid in Sinnoh, HeartGold's in Johto and Kanto
static void SinnohCellPos(int x, int z, int *px, int *py)
{
    *px = TOWN_MAP_GRID_X(x) + SINNOH_SCROLL_X;
    *py = TOWN_MAP_GRID_Y(z) + SINNOH_SCROLL_Y;
}

static void HGSSCellPos(int x, int y, int *px, int *py)
{
    *px = COMPLETE_TOWN_MAP_HGSS_X * 8 + x * 8 + 4;
    *py = (COMPLETE_TOWN_MAP_HGSS_Y + HGSS_ROWS_DOWN + y) * 8 + 4;
}

static void ScrollTo(TownMapAppData *appData, int x, int y)
{
    x = x < SCROLL_X_MIN ? SCROLL_X_MIN : x > SCROLL_X_MAX ? SCROLL_X_MAX : x;
    y = y < 0 ? 0 : y > SCROLL_Y_MAX ? SCROLL_Y_MAX : y;
    sMap.scrollX = x;
    sMap.scrollY = y;
    Bg_ScheduleScroll(appData->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_X, x);
    Bg_ScheduleScroll(appData->bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_SET_X, x);
    Bg_ScheduleScroll(appData->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_Y, y);
    Bg_ScheduleScroll(appData->bgConfig, BG_LAYER_MAIN_3, BG_OFFSET_UPDATE_SET_Y, y);
}

// A sprite at a canvas point, out of sight when the point is outside the map's window
static void PlaceSprite(Sprite *sprite, int px, int py)
{
    int x = px - sMap.scrollX, y = py - sMap.scrollY;
    BOOL inView = x >= VIEW_LEFT && x < VIEW_RIGHT && y >= 0 && y < VIEW_BOTTOM;

    Sprite_SetPositionXY(sprite, inView ? x : 0, inView ? y : OFF_SCREEN_Y);
}

static BOOL PlayerOutsideSinnoh(void)
{
    return gCompleteTownMap.playerRegion != COMPLETE_TOWN_MAP_REGION_SINNOH;
}

// In Johto or Kanto, at a place on HeartGold's map
static BOOL PlayerInHGSS(void)
{
    return PlayerOutsideSinnoh() && gCompleteTownMap.playerX != 0xFF;
}

static void PlaceHGSSSprites(TownMapAppData *appData)
{
    TownMapGraphicsManager *graphicsMan = appData->graphicsMan;
    int px, py;

    for (int i = 0; i < sMap.flyCount; i++) {
        HGSSCellPos(sMap.flyX[i], sMap.flyY[i], &px, &py);
        PlaceSprite(sMap.flySprites[i], px, py);
    }

    if (PlayerInHGSS()) {
        HGSSCellPos(gCompleteTownMap.playerX, gCompleteTownMap.playerY, &px, &py);
        PlaceSprite(graphicsMan->playerSprite, px, py);
    }
}

// Sinnoh's sprites (its Fly points, the places last visited, the player there) out of sight, or back
static void SaveSprite(Sprite *sprite)
{
    if (sprite != NULL && sMap.savedCount < MAX_SAVED) {
        sMap.saved[sMap.savedCount] = sprite;
        sMap.savedPos[sMap.savedCount] = *Sprite_GetPosition(sprite);
        sMap.savedCount++;
        Sprite_SetPositionXY(sprite, 0, OFF_SCREEN_Y);
    }
}

static void HideSinnohSprites(TownMapAppData *appData)
{
    TownMapGraphicsManager *graphicsMan = appData->graphicsMan;

    sMap.savedCount = 0;

    if (graphicsMan->flyLocations != NULL) {
        for (int i = 0; i < graphicsMan->flyLocations->count; i++) {
            SaveSprite(graphicsMan->flyLocations->flyLocationsList[i].sprite);
        }
    }

    if (appData->mode != TOWN_MAP_MODE_WALL_MAP) {
        for (int i = 0; i < graphicsMan->locationHistory.entryCount; i++) {
            SaveSprite(graphicsMan->locationHistory.entries[i].sprite);
        }
    }

    if (!PlayerOutsideSinnoh()) {
        SaveSprite(graphicsMan->playerSprite);
    }
}

static void ShowSinnohSprites(void)
{
    for (int i = 0; i < sMap.savedCount; i++) {
        Sprite_SetPosition(sMap.saved[i], &sMap.savedPos[i]);
    }

    sMap.savedCount = 0;
}

// HeartGold's Fly points on the map (gCompleteTownMap.flyPoints), with Platinum's markers
static void MakeHGSSFlyPoints(TownMapAppData *appData)
{
    static const SpriteTemplateFromResourceHeader template = {
        .resourceHeaderID = TownMap_Template_FlyDestinationBlocks,
        .x = 0,
        .y = 0,
        .z = 0,
        .animIdx = 0,
        .priority = 10,
        .plttIdx = 5,
        .vramType = NNS_G2D_VRAM_TYPE_2DMAIN,
    };

    sMap.flyCount = 0;

    if (appData->mode == TOWN_MAP_MODE_WALL_MAP) {
        return;
    }

    for (int i = 0; i < SPAWN_HGSS_COUNT; i++) {
        Location location;
        int x, y;

        if (!(gCompleteTownMap.flyPoints & (1 << i))) {
            continue;
        }

        Location_InitFly(SPAWN_HGSS_FIRST + i, &location);

        if (!CompleteMapInfo_HGSSMapCell(location.mapHeaderID, location.x, location.z, &x, &y)) {
            continue;
        }

        Sprite *sprite = SpriteSystem_NewSpriteFromResourceHeader(appData->spriteSystem, appData->spriteMan, &template);

        if (sprite == NULL) { // no room left in the sprite manager (src/applications/town_map/sprites.c)
            break;
        }

        Sprite_SetDrawFlag(sprite, TRUE);
        Sprite_SetExplicitPalette(sprite, 5 + 1);
        Sprite_UpdateAnim(sprite, FX32_CONST(0));
        sMap.flyX[sMap.flyCount] = x;
        sMap.flyY[sMap.flyCount] = y;
        sMap.flySpawn[sMap.flyCount] = SPAWN_HGSS_FIRST + i;
        sMap.flySprites[sMap.flyCount++] = sprite;
    }
}

static int FlyPointAtCursor(void)
{
    for (int i = 0; i < sMap.flyCount; i++) {
        if (sMap.flyX[i] == sMap.hgX && sMap.flyY[i] == sMap.hgY) {
            return i;
        }
    }

    return -1;
}

// The place on a cell of HeartGold's overworld map, or MAP_HEADER_EVERYWHERE for the sea and the edges
static enum MapHeaderID HGSSOverworldPlaceAt(int x, int y)
{
    if (sMap.matrix == NULL || x < 0 || y < 0 || x >= MapMatrix_GetWidth(sMap.matrix) || y >= MapMatrix_GetHeight(sMap.matrix)) {
        return MAP_HEADER_EVERYWHERE;
    }

    enum MapHeaderID header = MapMatrix_GetMapHeaderIDAtCoords(sMap.matrix, x, y);
    return header == MAP_HEADER_HGSS_EVERYWHERE ? MAP_HEADER_EVERYWHERE : header;
}

// The place on a cell of HeartGold's map: the overworld's, else a place off it that HeartGold's map puts there (its
// header's world map position, as the Pokégear's map names it: the Battle Frontier, the Pokéathlon Dome, the Sinjoh
// Ruins, the S.S. Aqua, Victory Road), the first such map, or the Battle Frontier itself
static enum MapHeaderID HGSSPlaceAt(int x, int y)
{
    enum MapHeaderID header = HGSSOverworldPlaceAt(x, y);

    if (header != MAP_HEADER_EVERYWHERE) {
        return header;
    }

    for (enum MapHeaderID id = MAP_HEADER_HGSS_EVERYWHERE + 1; MapHeader_IsHGSS(id); id++) {
        int mapX, mapY;

        MapHeader_GetWorldMapPos(id, &mapX, &mapY);

        if (mapX == x && mapY == y && (mapX != 0 || mapY != 0) && MapHeader_GetMapMatrixID(id) != MapHeader_GetMapMatrixID(MAP_HEADER_HGSS_NEW_BARK)) {
            int frontierX, frontierY;

            MapHeader_GetWorldMapPos(MAP_HEADER_HGSS_BATTLE_FRONTIER, &frontierX, &frontierY);
            return frontierX == x && frontierY == y ? MAP_HEADER_HGSS_BATTLE_FRONTIER : id;
        }
    }

    return MAP_HEADER_EVERYWHERE;
}

// The place under the cursor in Johto and Kanto, on the top screen's line (as Platinum's PrintLocationName does)
static void PrintHGSSPlace(TownMapAppData *appData)
{
    TownMapGraphicsManager *graphicsMan = appData->graphicsMan;
    Window *window = &graphicsMan->windows[TOWN_MAP_WINDOW_LOCATION_NAME];
    TextColor textColor = TEXT_COLOR(1, 2, 0);
    enum MapHeaderID header = HGSSPlaceAt(sMap.hgX, sMap.hgY);

    String_Clear(appData->hoveredMapName);
    Window_FillTilemap(window, 0);

    if (header != MAP_HEADER_EVERYWHERE) {
        u32 xOffset;

        MapHeader_LoadName(header, appData->heapID, appData->hoveredMapName);

        if (appData->mode == TOWN_MAP_MODE_FLY) {
            xOffset = 15 * 8 + 2;
        } else {
            xOffset = (HW_LCD_WIDTH - 6 * 8 - Font_CalcStringWidth(FONT_SYSTEM, appData->hoveredMapName, 0)) / 2;
        }

        Text_AddPrinterWithParamsAndColor(window, FONT_SYSTEM, appData->hoveredMapName, xOffset, 6, TEXT_SPEED_NO_TRANSFER, textColor, NULL);
    }

    if (appData->mode == TOWN_MAP_MODE_FLY) {
        String *string = MessageLoader_GetNewString(appData->townMapStrings, 0);

        Text_AddPrinterWithParamsAndColor(window, FONT_SYSTEM, string, 0, 6, TEXT_SPEED_NO_TRANSFER, textColor, NULL);
        String_Free(string);
    }

    Window_CopyToVRAM(window);
}

// The view on the cursor in Johto and Kanto, its sprites placed again
static void ShowHGSSCursor(TownMapAppData *appData)
{
    int px, py;

    HGSSCellPos(sMap.hgX, sMap.hgY, &px, &py);
    ScrollTo(appData, px - (VIEW_LEFT + VIEW_RIGHT) / 2, py - VIEW_BOTTOM / 2);
    PlaceSprite(appData->graphicsMan->cursorSprite, px, py);
    PlaceHGSSSprites(appData);
    PrintHGSSPlace(appData);
}

static void EnterHGSS(TownMapAppData *appData, int x, int y)
{
    int width = sMap.matrix ? MapMatrix_GetWidth(sMap.matrix) : 48;
    int height = sMap.matrix ? MapMatrix_GetHeight(sMap.matrix) : 18;

    if (sMap.region == REGION_SINNOH) {
        HideSinnohSprites(appData);
    }

    sMap.region = REGION_HGSS;
    sMap.hgX = x < 0 ? 0 : x >= width ? width - 1 : x;
    sMap.hgY = y < 0 ? 0 : y >= height ? height - 1 : y;
    ShowHGSSCursor(appData);
}

static void EnterSinnoh(TownMapAppData *appData, int x, int z)
{
    TownMapGraphicsManager *graphicsMan = appData->graphicsMan;

    sMap.region = REGION_SINNOH;
    ScrollTo(appData, SINNOH_SCROLL_X, SINNOH_SCROLL_Y);

    for (int i = 0; i < sMap.flyCount; i++) {
        Sprite_SetPositionXY(sMap.flySprites[i], 0, OFF_SCREEN_Y);
    }

    ShowSinnohSprites();

    if (PlayerOutsideSinnoh()) {
        Sprite_SetPositionXY(graphicsMan->playerSprite, 0, OFF_SCREEN_Y);
    }

    // Platinum's movement takes it from here: the cursor's sprite, the place, the zoomed-in map
    graphicsMan->cursorX = x;
    graphicsMan->cursorZ = z;
    graphicsMan->zoomedInMapCoords.x = (x * 16 + 8) - 112;
    graphicsMan->zoomedInMapCoords.y = (z * 16) - 96;
    graphicsMan->zoomedMapMvtStage = 3;
    graphicsMan->queuedMovement = 0x80;
    graphicsMan->zoomedInMapMvtDone = 0;
    graphicsMan->unk_15_0 = 1; // the bottom screen's text follows once the keys are let go
}

// The nearest cell of the other region to a canvas point: in Johto and Kanto, the nearest with a place
static void NearestHGSSCell(int px, int py, int *x, int *y)
{
    int width = sMap.matrix ? MapMatrix_GetWidth(sMap.matrix) : 48, height = sMap.matrix ? MapMatrix_GetHeight(sMap.matrix) : 18;
    int best = -1;

    *x = HGSS_START_X;
    *y = HGSS_START_Y;

    for (int j = 0; j < height; j++) {
        for (int i = 0; i < width; i++) {
            if (HGSSOverworldPlaceAt(i, j) == MAP_HEADER_EVERYWHERE) {
                continue;
            }

            int cx, cy;
            HGSSCellPos(i, j, &cx, &cy);
            int d = (cx - px) * (cx - px) + (cy - py) * (cy - py);

            if (best < 0 || d < best) {
                best = d;
                *x = i;
                *y = j;
            }
        }
    }
}

static void NearestSinnohCell(int px, int py, int *x, int *z)
{
    int best = -1;

    for (int j = SINNOH_Z_MIN; j <= SINNOH_Z_MAX; j++) {
        for (int i = SINNOH_X_MIN; i <= SINNOH_X_MAX; i++) {
            int cx, cy;
            SinnohCellPos(i, j, &cx, &cy);
            int d = (cx - px) * (cx - px) + (cy - py) * (cy - py);

            if (best < 0 || d < best) {
                best = d;
                *x = i;
                *z = j;
            }
        }
    }
}

void CompleteTownMap_Start(TownMapAppData *appData)
{
    memset(&sMap, 0, sizeof(sMap));
    sMap.scrollX = SINNOH_SCROLL_X;
    sMap.matrix = MapMatrix_NewWithHeapID(appData->heapID);
    MapMatrix_Load(MAP_HEADER_HGSS_NEW_BARK, sMap.matrix);
    MakeHGSSFlyPoints(appData);

    for (int i = 0; i < sMap.flyCount; i++) {
        Sprite_SetPositionXY(sMap.flySprites[i], 0, OFF_SCREEN_Y);
    }

    if (PlayerInHGSS()) {
        EnterHGSS(appData, gCompleteTownMap.playerX, gCompleteTownMap.playerY);
    } else if (PlayerOutsideSinnoh()) {
        EnterHGSS(appData, HGSS_START_X, HGSS_START_Y);
    }

    NoteView(appData);
}

static void NoteView(TownMapAppData *appData)
{
    gCompleteTownMap.viewRegion = sMap.region;
    gCompleteTownMap.viewX = sMap.region == REGION_SINNOH ? appData->graphicsMan->cursorX : sMap.hgX;
    gCompleteTownMap.viewY = sMap.region == REGION_SINNOH ? appData->graphicsMan->cursorZ : sMap.hgY;
}

BOOL CompleteTownMap_HandleInput(TownMapAppData *appData, int heldKeys)
{
    BOOL handled = HandleInput(appData, heldKeys);

    NoteView(appData);
    return handled;
}

static BOOL HandleInput(TownMapAppData *appData, int heldKeys)
{
    TownMapGraphicsManager *graphicsMan = appData->graphicsMan;
    int px, py, x, y;

    if (sMap.region == REGION_SINNOH) {
        // L, or a fresh press of the D-pad off Sinnoh's west or south edge (not a held one running into it), goes over
        // to Johto and Kanto
        int pressed = gSystem.pressedKeys;
        BOOL off = ((pressed & PAD_KEY_LEFT) && graphicsMan->cursorX <= SINNOH_X_MIN)
            || ((pressed & PAD_KEY_DOWN) && graphicsMan->cursorZ >= SINNOH_Z_MAX);

        if (pressed & PAD_BUTTON_L) {
            x = PlayerInHGSS() ? gCompleteTownMap.playerX : HGSS_START_X;
            y = PlayerInHGSS() ? gCompleteTownMap.playerY : HGSS_START_Y;
        } else if (off) {
            SinnohCellPos(graphicsMan->cursorX, graphicsMan->cursorZ, &px, &py);
            NearestHGSSCell(px - ((pressed & PAD_KEY_LEFT) ? 24 : 0), py + ((pressed & PAD_KEY_DOWN) ? 24 : 0), &x, &y);
        } else {
            return FALSE;
        }

        Sound_PlayEffect(SEQ_SE_DP_MEKURU_sseq);
        EnterHGSS(appData, x, y);
        sMap.heldFrames = 1;
        graphicsMan->unk_15_0 = 0;
        return TRUE;
    }

    if (gSystem.pressedKeys & PAD_BUTTON_R) {
        Sound_PlayEffect(SEQ_SE_DP_MEKURU_sseq);
        EnterSinnoh(appData, appData->initialCursorX, appData->initialCursorZ);
        return TRUE;
    }

    if (!(heldKeys & (PAD_KEY_UP | PAD_KEY_DOWN | PAD_KEY_LEFT | PAD_KEY_RIGHT))) {
        sMap.heldFrames = 0;
        return TRUE;
    }

    // held: a step at once, then one every few frames
    if (sMap.heldFrames != 0 && sMap.heldFrames < REPEAT_FIRST) {
        sMap.heldFrames++;
        return TRUE;
    }

    if (sMap.heldFrames >= REPEAT_FIRST) {
        if ((sMap.heldFrames - REPEAT_FIRST) % REPEAT_NEXT != 0) {
            sMap.heldFrames++;
            return TRUE;
        }
    }

    sMap.heldFrames++;

    int width = sMap.matrix ? MapMatrix_GetWidth(sMap.matrix) : 48;
    x = sMap.hgX + ((heldKeys & PAD_KEY_RIGHT) ? 1 : 0) - ((heldKeys & PAD_KEY_LEFT) ? 1 : 0);
    y = sMap.hgY + ((heldKeys & PAD_KEY_DOWN) ? 1 : 0) - ((heldKeys & PAD_KEY_UP) ? 1 : 0);

    // a fresh press off the map's north or east edge, towards Sinnoh: over to it
    if ((y < 0 || x >= width) && sMap.heldFrames == 1) {
        HGSSCellPos(sMap.hgX, sMap.hgY, &px, &py);
        NearestSinnohCell(px + (x >= width ? 24 : 0), py - (y < 0 ? 24 : 0), &x, &y);
        Sound_PlayEffect(SEQ_SE_DP_MEKURU_sseq);
        EnterSinnoh(appData, x, y);
        return TRUE;
    }

    EnterHGSS(appData, x, y);
    return TRUE;
}

BOOL CompleteTownMap_CanFly(TownMapAppData *appData, BOOL *canFly)
{
    if (sMap.region == REGION_SINNOH) {
        if (gCompleteTownMap.playerRegion == COMPLETE_TOWN_MAP_REGION_SINNOH || gCompleteTownMap.fromSinjoh) {
            return FALSE; // Platinum's own check: in Sinnoh, or from the Sinjoh Ruins
        }

        *canFly = FALSE; // from Johto or Kanto, not to Sinnoh
        return TRUE;
    }

    int i = FlyPointAtCursor();

    if (i < 0) {
        *canFly = FALSE;
        return TRUE;
    }

    Location location;
    Location_InitFly(sMap.flySpawn[i], &location);

    // Platinum's Fly takes the spawn point on this map's block (GetSpawnIdByMapAndCoords), so its tile is where it lands
    appData->context->flyLocationSelected = TRUE;
    appData->context->flyLocationX = location.x / MAP_TILES_COUNT_X;
    appData->context->flyLocationZ = location.z / MAP_TILES_COUNT_Z;
    appData->context->flyLocationMapHeader = location.mapHeaderID;
    *canFly = TRUE;
    return TRUE;
}

void CompleteTownMap_Free(TownMapAppData *appData)
{
    for (int i = 0; i < sMap.flyCount; i++) {
        Sprite_Delete2(sMap.flySprites[i]);
    }

    sMap.flyCount = 0;

    if (sMap.matrix != NULL) {
        MapMatrix_Free(sMap.matrix);
        sMap.matrix = NULL;
    }
}
