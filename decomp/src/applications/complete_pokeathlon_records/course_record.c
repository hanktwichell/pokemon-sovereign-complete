#include <nitro.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "constants/narc.h"
#include "generated/text_banks.h"

#include "applications/complete_pokeathlon_records/records_common.h"

#include "bg_window.h"
#include "complete_pokeathlon.h"
#include "complete_pokeathlon_records.h"
#include "font.h"
#include "graphics.h"
#include "gx_layers.h"
#include "heap.h"
#include "narc.h"
#include "overlay_manager.h"
#include "screen_fade.h"
#include "sound_playback.h"
#include "sprite.h"
#include "sprite_system.h"
#include "string_template.h"
#include "system.h"
#include "touch_pad.h"
#include "touch_screen.h"

#include "res/sound/pl_sound_data.naix"
#include "res/text/bank/hgss_msg_0314.h"

// Sovereign Complete: HeartGold's Pokéathlon course record screen (include/complete_pokeathlon_records.h), the first
// app of its overlay 99 (PokeathlonCourseRecord_Init to ov99_021E6638, in assembly in pret's HeartGold), written in C on
// Platinum's libraries with its overlay 98's parts (records_common.c). The main engine is on the bottom screen: there,
// the course's medal with the three Pokémon of its best run and the total in big digits, sparkling; on the right, a
// button for each course run (a crown on it from 420 points, another from 450) and Return below them. On the top
// screen, the medal's ribbon, the course's name, the points the Collective Trophy needs (once every course, event and
// medal has been played), the three events' points and the bonus, the total, and the three Pokémon's icons and names.
// A course's page slides in from the right (a later course) or the left as the cursor moves. Input: the D-pad (RIGHT
// or DOWN for the next course, LEFT or UP for the one before, past the fifth to Return; held, it repeats), A on
// Return, B, or touching a course's button or Return. What differs from HeartGold's: the Pokémon's pictures are
// Complete's 96x96 ones; a slot without a Pokémon stays hidden; and the cursor moving off Return onto a course that
// isn't the page shown draws that course (HeartGold only checks it came from Return to the fifth course).

#define HEAP_ID_COURSE_RECORD   HEAP_ID_DIPLOMA // the diploma's, as the other HeartGold screens': they can't run together
#define COURSE_RECORD_HEAP_SIZE 0x30000

#define NUM_COURSES          COMPLETE_POKEATHLON_COURSES
#define NUM_EVENTS           3
#define NUM_MONS             3
#define NUM_DIGITS           3
#define CURSOR_RETURN        NUM_COURSES // the cursor's place on Return
#define PAGE_SLIDE_DISTANCE  256
#define NUM_COURSE_SCHEDULES 10 // HeartGold's table has its link courses' events too

enum {
    STATE_FADE_IN = 0,
    STATE_WAIT_FADE_IN,
    STATE_INPUT,
    STATE_WAIT_FADE_OUT,
    STATE_FREE,
};

// The archive (tools/complete/import_hgss_pokeathlon_records.py: HeartGold's a/1/7/7, member n as member n)
enum {
    GFX_CURSOR_PLTT = 0,
    GFX_CURSOR_CHAR,
    GFX_CURSOR_CELL,
    GFX_CURSOR_ANIM,
    GFX_BUTTONS_PLTT,
    GFX_BUTTONS_CHAR,
    GFX_BUTTONS_CELL,
    GFX_BUTTONS_ANIM,
    GFX_TOTAL_PLTT,
    GFX_TOTAL_CHAR,
    GFX_TOTAL_CELL,
    GFX_TOTAL_ANIM,
    GFX_MEDAL_DIGITS_PLTT = 20,
    GFX_MEDAL_DIGITS_CHAR,
    GFX_MEDAL_DIGITS_CELL,
    GFX_MEDAL_DIGITS_ANIM,
    GFX_BOTTOM_PLTT = 30,
    GFX_BOTTOM_TILES,
    GFX_BOTTOM_TILEMAP,
    GFX_TOP_PLTT,
    GFX_TOP_TILES,
    GFX_TOP_TILEMAP,
    GFX_BOTTOM_PANEL_PLTT,
    GFX_BOTTOM_PANEL_TILES,
    GFX_BOTTOM_PANEL_TILEMAP,
    GFX_TOP_PANEL_PLTT,
    GFX_TOP_PANEL_TILES,
    GFX_TOP_PANEL_TILEMAP,
    GFX_MEDAL_TILES = 62,
    GFX_MEDAL_TILEMAP, // one a course
    GFX_RIBBON_TILES = 68,
    GFX_RIBBON_TILEMAP, // one a course
};

// The sprites (ov99_021E9840), in HeartGold's order
enum {
    SPRITE_CURSOR = 0,
    SPRITE_COURSE_BUTTON, // the courses' buttons, shown for the courses run
    SPRITE_CROWN = SPRITE_COURSE_BUTTON + NUM_COURSES, // a course's crowns, from 420 points
    SPRITE_MON_PIC = SPRITE_CROWN + NUM_COURSES, // the best run's Pokémon, on the medal
    SPRITE_MEDAL_DIGIT = SPRITE_MON_PIC + NUM_MONS, // the total on the medal: ones, tens, hundreds
    SPRITE_SPARKLE = SPRITE_MEDAL_DIGIT + NUM_DIGITS, // the medal's sparkles
    SPRITE_TOTAL_DIGIT = SPRITE_SPARKLE + 3, // the total on the top screen: ones, tens, hundreds
    SPRITE_ICON = SPRITE_TOTAL_DIGIT + NUM_DIGITS, // the Pokémon's icons, by their names
    NUM_SPRITES = SPRITE_ICON + NUM_MONS,
};

enum { // the cursor's and crowns' animations
    ANIM_CROWN_420 = 2, // and 3 for the courses on the right
    ANIM_CROWN_450 = 5, // and 6
    ANIM_CURSOR = 8,
    ANIM_CURSOR_TOUCHED,
    ANIM_CURSOR_RETURN = 12,
};

enum { // the windows (ov99_021E96D8)
    WINDOW_TITLE = 0, // "Course record"
    WINDOW_MEDAL, // the course's medal
    WINDOW_RETURN,
    WINDOW_COURSE, // the top screen's: the course's name
    WINDOW_TROPHY_GOAL, // the points the Collective Trophy needs
    WINDOW_EVENT_NAME, // three: "1:Hurdle Dash"
    WINDOW_EVENT_POINTS = WINDOW_EVENT_NAME + NUM_EVENTS, // three
    WINDOW_BONUS = WINDOW_EVENT_POINTS + NUM_EVENTS,
    WINDOW_BONUS_POINTS,
    WINDOW_POINTS, // "Points", by the total
    WINDOW_MON_NAME, // three
    NUM_WINDOWS = WINDOW_MON_NAME + NUM_MONS,
};

typedef struct CourseRecord {
    CompletePokeathlonSave *pokeathlon; // HeartGold's args' copy: here the Pokéathlon save's
    const CompletePokeathlonCourseRecord *records;
    BOOL trophyGoals;
    BgConfig *bgConfig;
    NARC *narc;
    enum HeapID heapID;
    PokeathlonRecordsText *text;
    PokeathlonRecordsSprites *sprites;
    ManagedSprite *spriteList[NUM_SPRITES];
    s8 cursor;
    BOOL slideFromRight; // the next page comes in from the right (a later course)
    int course; // the page shown
    BOOL sliding;
    BOOL redraw;
} CourseRecord;

static const u8 sBgLayers[] = { // _021E954C
    BG_LAYER_MAIN_0,
    BG_LAYER_MAIN_1,
    BG_LAYER_MAIN_2,
    BG_LAYER_MAIN_3,
    BG_LAYER_SUB_0,
    BG_LAYER_SUB_1,
    BG_LAYER_SUB_2,
    BG_LAYER_SUB_3,
};

// ov99_021E9760: on the bottom screen, the text (0), background (1), medal (2, two screens wide, to slide) and the
// buttons' panel (3); on top, the background (0), ribbon (1, the same), text (2) and panel (3)
static const BgTemplate sBgTemplates[] = {
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x0000, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x0800, GX_BG_CHARBASE_0x08000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 0, 0, 0x1000, 0, BG_SCREEN_SIZE_512x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x1000, GX_BG_CHARBASE_0x0c000, GX_BG_EXTPLTT_01, 2, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0x2000, GX_BG_CHARBASE_0x14000, GX_BG_EXTPLTT_01, 1, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xf800, GX_BG_CHARBASE_0x00000, GX_BG_EXTPLTT_01, 3, 0, FALSE },
    { 256, 0, 0x1000, 0, BG_SCREEN_SIZE_512x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xe800, GX_BG_CHARBASE_0x04000, GX_BG_EXTPLTT_01, 2, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xe000, GX_BG_CHARBASE_0x08000, GX_BG_EXTPLTT_01, 0, 0, FALSE },
    { 0, 0, 0x800, 0, BG_SCREEN_SIZE_256x256, GX_BG_COLORMODE_16, GX_BG_SCRBASE_0xd800, GX_BG_CHARBASE_0x0c000, GX_BG_EXTPLTT_01, 1, 0, FALSE },
};

static const GraphicsModes sGraphicsModes = { GX_DISPMODE_GRAPHICS, GX_BGMODE_0, GX_BGMODE_0, GX_BG0_AS_2D }; // ov99_021E9564

static const WindowTemplate sWindowTemplates[NUM_WINDOWS] = { // ov99_021E96D8
    [WINDOW_TITLE] = { BG_LAYER_MAIN_0, 0, 0, 14, 2, 12, 0x001 },
    [WINDOW_MEDAL] = { BG_LAYER_MAIN_0, 0, 22, 14, 2, 12, 0x01D },
    [WINDOW_RETURN] = { BG_LAYER_MAIN_0, 25, 21, 6, 2, 12, 0x039 },
    [WINDOW_COURSE] = { BG_LAYER_SUB_2, 7, 0, 18, 2, 12, 0x001 },
    [WINDOW_TROPHY_GOAL] = { BG_LAYER_SUB_2, 2, 2, 28, 2, 12, 0x025 },
    [WINDOW_EVENT_NAME] = { BG_LAYER_SUB_2, 3, 6, 14, 2, 12, 0x05D },
    [WINDOW_EVENT_NAME + 1] = { BG_LAYER_SUB_2, 3, 8, 14, 2, 12, 0x079 },
    [WINDOW_EVENT_NAME + 2] = { BG_LAYER_SUB_2, 3, 10, 14, 2, 12, 0x095 },
    [WINDOW_EVENT_POINTS] = { BG_LAYER_SUB_2, 22, 6, 8, 2, 12, 0x0B1 },
    [WINDOW_EVENT_POINTS + 1] = { BG_LAYER_SUB_2, 22, 8, 8, 2, 12, 0x0C1 },
    [WINDOW_EVENT_POINTS + 2] = { BG_LAYER_SUB_2, 22, 10, 8, 2, 12, 0x0D1 },
    [WINDOW_BONUS] = { BG_LAYER_SUB_2, 7, 12, 14, 2, 12, 0x0E1 },
    [WINDOW_BONUS_POINTS] = { BG_LAYER_SUB_2, 22, 12, 8, 2, 12, 0x0FD },
    [WINDOW_POINTS] = { BG_LAYER_SUB_2, 26, 22, 6, 2, 12, 0x10D },
    [WINDOW_MON_NAME] = { BG_LAYER_SUB_2, 4, 16, 12, 2, 12, 0x119 },
    [WINDOW_MON_NAME + 1] = { BG_LAYER_SUB_2, 5, 19, 12, 2, 12, 0x131 },
    [WINDOW_MON_NAME + 2] = { BG_LAYER_SUB_2, 6, 22, 12, 2, 12, 0x149 },
};

static const SpriteResourceCapacities sSpriteCapacities = { 10, 8, 6, 6, 0, 0 }; // ov99_021E95A4

// ov99_021E9840: x, y, z, animation, priority, palette, screen, resources (char, palette, cells, animations), BG
// priority, VRAM transfer
static const SpriteTemplate sSpriteTemplates[NUM_SPRITES] = {
    [SPRITE_CURSOR] = { 208, 16, 0, ANIM_CURSOR, 2, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 1, 1, 1, 1, 0, 0 }, 3, FALSE },
    [SPRITE_COURSE_BUTTON] = { 208, 16, 0, 0, 2, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 2, 2, 2, 2, 0, 0 }, 3, FALSE },
    [SPRITE_COURSE_BUTTON + 1] = { 240, 48, 0, 1, 2, 1, NNS_G2D_VRAM_TYPE_2DMAIN, { 2, 2, 2, 2, 0, 0 }, 3, FALSE },
    [SPRITE_COURSE_BUTTON + 2] = { 208, 80, 0, 2, 2, 2, NNS_G2D_VRAM_TYPE_2DMAIN, { 2, 2, 2, 2, 0, 0 }, 3, FALSE },
    [SPRITE_COURSE_BUTTON + 3] = { 240, 112, 0, 3, 2, 3, NNS_G2D_VRAM_TYPE_2DMAIN, { 2, 2, 2, 2, 0, 0 }, 3, FALSE },
    [SPRITE_COURSE_BUTTON + 4] = { 208, 144, 0, 4, 2, 4, NNS_G2D_VRAM_TYPE_2DMAIN, { 2, 2, 2, 2, 0, 0 }, 3, FALSE },
    [SPRITE_CROWN] = { 208, 16, 0, ANIM_CROWN_420, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 1, 1, 1, 1, 0, 0 }, 3, FALSE },
    [SPRITE_CROWN + 1] = { 240, 48, 0, ANIM_CROWN_420 + 1, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 1, 1, 1, 1, 0, 0 }, 3, FALSE },
    [SPRITE_CROWN + 2] = { 208, 80, 0, ANIM_CROWN_420, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 1, 1, 1, 1, 0, 0 }, 3, FALSE },
    [SPRITE_CROWN + 3] = { 240, 112, 0, ANIM_CROWN_420 + 1, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 1, 1, 1, 1, 0, 0 }, 3, FALSE },
    [SPRITE_CROWN + 4] = { 208, 144, 0, ANIM_CROWN_420, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 1, 1, 1, 1, 0, 0 }, 3, FALSE },
    [SPRITE_MON_PIC] = { 96, 64, 0, 0, 2, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 3, 4, 4, 4, 0, 0 }, 0, FALSE },
    [SPRITE_MON_PIC + 1] = { 56, 104, 0, 0, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 4, 5, 4, 4, 0, 0 }, 0, FALSE },
    [SPRITE_MON_PIC + 2] = { 136, 104, 0, 0, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 5, 6, 4, 4, 0, 0 }, 0, FALSE },
    [SPRITE_MEDAL_DIGIT] = { 120, 152, 0, 0, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_MEDAL_DIGIT + 1] = { 104, 152, 0, 1, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_MEDAL_DIGIT + 2] = { 88, 152, 0, 2, 1, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_SPARKLE] = { 128, 56, 0, 10, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_SPARKLE + 1] = { 40, 96, 0, 11, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_SPARKLE + 2] = { 128, 152, 0, 12, 0, 0, NNS_G2D_VRAM_TYPE_2DMAIN, { 0, 0, 0, 0, 0, 0 }, 0, FALSE },
    [SPRITE_TOTAL_DIGIT] = { 208, 149, 0, 0, 1, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 6, 3, 3, 3, 0, 0 }, 0, FALSE },
    [SPRITE_TOTAL_DIGIT + 1] = { 176, 149, 0, 1, 1, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 6, 3, 3, 3, 0, 0 }, 0, FALSE },
    [SPRITE_TOTAL_DIGIT + 2] = { 144, 149, 0, 2, 1, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 6, 3, 3, 3, 0, 0 }, 0, FALSE },
    [SPRITE_ICON] = { 16, 128, 0, 0, 1, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 7, 7, 5, 5, 0, 0 }, 0, FALSE },
    [SPRITE_ICON + 1] = { 24, 152, 0, 0, 1, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 8, 7, 5, 5, 0, 0 }, 0, FALSE },
    [SPRITE_ICON + 2] = { 32, 176, 0, 0, 1, 0, NNS_G2D_VRAM_TYPE_2DSUB, { 9, 7, 5, 5, 0, 0 }, 0, FALSE },
};

// ov99_021E9650 and ov99_021E9554: the Pokémon pictures' and icons' resources (char, palette, cells, animations; the
// icons' chars from 7 on)
static const int sMonPicResources[NUM_MONS][4] = { { 3, 4, 4, 4 }, { 4, 5, 4, 4 }, { 5, 6, 4, 4 } };
static const int sIconResources[4] = { 7, 7, 5, 5 };

// ov99_021E9690: what slides with the medal, and where it rests
static const struct {
    u32 sprite;
    s16 x;
    s16 y;
} sSlidingSprites[] = {
    { SPRITE_MON_PIC, 96, 64 },
    { SPRITE_MON_PIC + 1, 56, 104 },
    { SPRITE_MON_PIC + 2, 136, 104 },
    { SPRITE_MEDAL_DIGIT, 120, 152 },
    { SPRITE_MEDAL_DIGIT + 1, 104, 152 },
    { SPRITE_MEDAL_DIGIT + 2, 88, 152 },
};

// ov99_021E9574: the cursor on each course's button and on Return
static const struct {
    s16 x;
    s16 y;
} sCursorPositions[] = {
    { 208, 16 },
    { 240, 48 },
    { 208, 80 },
    { 240, 112 },
    { 208, 144 },
    { 224, 176 },
};

// ov99_021E95BC: the courses' round buttons, then Return (its right edge 0: the screen's, as the check wraps)
static const TouchScreenHitTable sHitTable[] = {
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 208, 16, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 240, 48, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 208, 80, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 240, 112, 16 } },
    { .circle = { TOUCHSCREEN_USE_CIRCLE, 208, 144, 16 } },
    { .rect = { 160, 192, 192, 0 } },
    { .rect = { TOUCHSCREEN_TABLE_TERMINATOR, 0, 0, 0 } },
};

// ov99_021E95D8: each course's medal (bottom screen) and ribbon (top)
static const struct {
    u32 medal;
    u32 ribbon;
} sCoursePages[NUM_COURSES] = {
    { GFX_MEDAL_TILEMAP, GFX_RIBBON_TILEMAP },
    { GFX_MEDAL_TILEMAP + 1, GFX_RIBBON_TILEMAP + 1 },
    { GFX_MEDAL_TILEMAP + 2, GFX_RIBBON_TILEMAP + 2 },
    { GFX_MEDAL_TILEMAP + 3, GFX_RIBBON_TILEMAP + 3 },
    { GFX_MEDAL_TILEMAP + 4, GFX_RIBBON_TILEMAP + 4 },
};

// ov99_021E9600: each course's events (bank 313's order: Hurdle Dash, Pennant Capture, Circle Push, Block Smash, Disc
// Catch, Lamp Jump, Relay Run, Ring Drop, Snow Throw, Goal Roll; 10 none), the Speed, Power, Skill, Stamina and Jump
// Courses' then the link courses'
static const u8 sCourseEvents[NUM_COURSE_SCHEDULES][4] = {
    { 0, 1, 6, 10 },
    { 3, 2, 9, 10 },
    { 8, 9, 1, 10 },
    { 7, 6, 3, 10 },
    { 5, 4, 0, 10 },
    { 0, 5, 4, 6 },
    { 5, 4, 1, 8 },
    { 9, 8, 1, 3 },
    { 3, 2, 9, 7 },
    { 6, 7, 0, 2 },
};

static void SetUpBgs(CourseRecord *app);
static void FreeBgs(CourseRecord *app);
static void LoadBgGraphics(CourseRecord *app);
static void LoadSpriteResources(CourseRecord *app);
static void MakeSprites(CourseRecord *app);
static void ShowPageSprites(CourseRecord *app, BOOL show);
static void DrawPageBackground(CourseRecord *app, int course);
static void DrawPageText(CourseRecord *app, int course);
static void DrawPageSprites(CourseRecord *app, int course);
static void DrawFixedText(CourseRecord *app);
static void SlidePage(CourseRecord *app);
static BOOL HandleInput(CourseRecord *app);
static void VBlank(void *data);

// ov99_021E5B90, ov99_021E5BB4, ov99_021E5BD8 (3: the bonus, the total less the events'), ov99_021E5C20
static u16 CourseTotal(const CourseRecord *app, int course)
{
    GF_ASSERT(course < NUM_COURSES);
    return app->records[course].total;
}

static BOOL HasRecord(const CourseRecord *app, int course)
{
    return CourseTotal(app, course) != 0;
}

static u16 CoursePoints(const CourseRecord *app, int course, int event)
{
    const CompletePokeathlonCourseRecord *record = &app->records[course];

    if (event == NUM_EVENTS) {
        return (u16)(record->total - record->eventPoints[0] - record->eventPoints[1] - record->eventPoints[2]);
    }

    return record->eventPoints[event];
}

static u8 CourseEvent(int course, int event)
{
    GF_ASSERT(course < NUM_COURSE_SCHEDULES);
    GF_ASSERT(event < 4);
    return sCourseEvents[course][event];
}

static void NoteForTests(const CourseRecord *app)
{
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 1 + COMPLETE_POKEATHLON_SCREEN_COURSE_RECORD;
    gCompleteTestPokeathlonRecordScreen[1] = 1 + app->course;
    gCompleteTestPokeathlonRecordScreen[2] = app->cursor;
#endif
}

BOOL CompletePokeathlonCourseRecord_Init(ApplicationManager *appMan, int *state)
{
    CompletePokeathlonRecordArgs *args = ApplicationManager_Args(appMan);

    GF_ASSERT(args != NULL);
    Heap_Create(HEAP_ID_APPLICATION, HEAP_ID_COURSE_RECORD, COURSE_RECORD_HEAP_SIZE);

    CourseRecord *app = ApplicationManager_NewData(appMan, sizeof(CourseRecord), HEAP_ID_COURSE_RECORD);

    MI_CpuClear8(app, sizeof(CourseRecord));
    app->heapID = HEAP_ID_COURSE_RECORD;
    app->sliding = FALSE;
    app->redraw = TRUE;
    app->slideFromRight = TRUE;
    app->pokeathlon = CompletePokeathlon_Load(args->saveData, app->heapID); // ov99_021E5B54
    app->records = app->pokeathlon->courseRecords;
    app->trophyGoals = args->trophyGoals;
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonCourseRecords = app->pokeathlon->courseRecords;
#endif

    PokeathlonRecords_SetUpScreens();
    SetUpBgs(app);
    LoadBgGraphics(app);
    app->text = PokeathlonRecords_NewText(app->heapID, app->bgConfig, NUM_WINDOWS, sWindowTemplates, TEXT_BANK_HGSS_MSG_0314);
    app->sprites = PokeathlonRecords_NewSprites(app->heapID, &sSpriteCapacities, NUM_SPRITES);
    LoadSpriteResources(app);
    MakeSprites(app);
    ShowPageSprites(app, FALSE);
    DrawPageBackground(app, 0);
    DrawPageText(app, 0);
    DrawPageSprites(app, 0);
    DrawFixedText(app);
    SetAutorepeat(2, 4);
    EnableTouchPad();
    InitializeTouchPad(4);
    ResetVisibleHardwareWindows(DS_SCREEN_MAIN);
    ResetVisibleHardwareWindows(DS_SCREEN_SUB);
    SetVBlankCallback(VBlank, app);
    NoteForTests(app);
    return TRUE;
}

BOOL CompletePokeathlonCourseRecord_Main(ApplicationManager *appMan, int *state)
{
    CourseRecord *app = ApplicationManager_Data(appMan);

    SlidePage(app);

    if (app->redraw == TRUE) {
        DrawPageBackground(app, app->course);
        DrawPageText(app, app->course);
        DrawPageSprites(app, app->course);
        app->redraw = FALSE;
        app->sliding = TRUE;
    }

    switch (*state) {
    case STATE_FADE_IN:
        StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_IN, FADE_TYPE_BRIGHTNESS_IN, COLOR_BLACK, 6, 1, app->heapID);
        *state = STATE_WAIT_FADE_IN;
        break;
    case STATE_WAIT_FADE_IN:
        if (IsScreenFadeDone()) {
            *state = STATE_INPUT;
        }
        break;
    case STATE_INPUT:
        if (HandleInput(app) && !app->sliding) {
            Sound_PlayEffect(SE_CONFIRM_sseq_3); // HeartGold's SEQ_SE_DP_SELECT
            StartScreenFade(FADE_BOTH_SCREENS, FADE_TYPE_BRIGHTNESS_OUT, FADE_TYPE_BRIGHTNESS_OUT, COLOR_BLACK, 6, 1, app->heapID);
            *state = STATE_WAIT_FADE_OUT;
        }
        break;
    case STATE_WAIT_FADE_OUT:
        if (IsScreenFadeDone()) {
            *state = STATE_FREE;
        }
        break;
    case STATE_FREE:
        PokeathlonRecords_FreeText(app->text);
        FreeBgs(app);
        PokeathlonRecords_FreeSprites(app->sprites, app->spriteList, NUM_SPRITES);
        PokeathlonRecords_EndScreens();
        return TRUE;
    }

    PokeathlonRecords_DrawSprites(app->sprites);
    return FALSE;
}

BOOL CompletePokeathlonCourseRecord_Exit(ApplicationManager *appMan, int *state)
{
    CourseRecord *app = ApplicationManager_Data(appMan);

    SetAutorepeat(4, 8);
    DisableTouchPad();
#ifdef SOVEREIGN_TEST
    gCompleteTestPokeathlonRecordScreen[0] = 0;
    gCompleteTestPokeathlonCourseRecords = NULL;
#endif
    Heap_Free(app->pokeathlon);
    ApplicationManager_FreeData(appMan);
    Heap_Destroy(HEAP_ID_COURSE_RECORD);
    return TRUE;
}

// ov99_021E5C88. The bottom screen's panel and the top's (BG 3 on each) are blended over the medal and ribbon.
static void SetUpBgs(CourseRecord *app)
{
    app->bgConfig = BgConfig_New(app->heapID);
    SetAllGraphicsModes(&sGraphicsModes);

    for (int i = 0; i < NELEMS(sBgLayers); i++) {
        Bg_InitFromTemplate(app->bgConfig, sBgLayers[i], &sBgTemplates[i], BG_TYPE_STATIC);
        Bg_ClearTilemap(app->bgConfig, sBgLayers[i]);
        Bg_ClearTilesRange(sBgLayers[i], 32, 0, app->heapID);
    }

    G2_SetBlendAlpha(GX_BLEND_PLANEMASK_BG3, GX_BLEND_PLANEMASK_BG2, 15, 0);
    G2S_SetBlendAlpha(GX_BLEND_PLANEMASK_BG3, GX_BLEND_PLANEMASK_BG1, 15, 0);
    app->narc = NARC_ctor(NARC_INDEX_GRAPHIC__COMPLETE__POKEATHLON_RECORDS, app->heapID);
}

// ov99_021E5D2C. HeartGold leaves the blending to the next screen; the field's map sets its own.
static void FreeBgs(CourseRecord *app)
{
    NARC_dtor(app->narc);

    for (int i = 0; i < NELEMS(sBgLayers); i++) {
        Bg_FreeTilemapBuffer(app->bgConfig, sBgLayers[i]);
    }

    Heap_Free(app->bgConfig);
    G2_BlendNone();
    G2S_BlendNone();
}

// ov99_021E5D58
static void LoadBgGraphics(CourseRecord *app)
{
    NARC *narc = app->narc;
    BgConfig *bgConfig = app->bgConfig;

    Graphics_LoadPaletteFromOpenNARC(narc, GFX_BOTTOM_PLTT, PAL_LOAD_MAIN_BG, 0, 0, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILES, bgConfig, BG_LAYER_MAIN_1, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_BOTTOM_TILEMAP, bgConfig, BG_LAYER_MAIN_1, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_MEDAL_TILES, bgConfig, BG_LAYER_MAIN_2, 0, 0, TRUE, app->heapID);
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_BOTTOM_PANEL_PLTT, PAL_LOAD_MAIN_BG, PLTT_OFFSET(15), PALETTE_SIZE_BYTES, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_BOTTOM_PANEL_TILES, bgConfig, BG_LAYER_MAIN_3, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_BOTTOM_PANEL_TILEMAP, bgConfig, BG_LAYER_MAIN_3, 0, 0, TRUE, app->heapID);

    Graphics_LoadPaletteFromOpenNARC(narc, GFX_TOP_PLTT, PAL_LOAD_SUB_BG, 0, 0, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_TOP_TILES, bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_TOP_TILEMAP, bgConfig, BG_LAYER_SUB_0, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_RIBBON_TILES, bgConfig, BG_LAYER_SUB_1, 0, 0, TRUE, app->heapID);
    Graphics_LoadPaletteFromOpenNARC(narc, GFX_TOP_PANEL_PLTT, PAL_LOAD_SUB_BG, PLTT_OFFSET(15), PALETTE_SIZE_BYTES, app->heapID);
    Graphics_LoadTilesToBgLayerFromOpenNARC(narc, GFX_TOP_PANEL_TILES, bgConfig, BG_LAYER_SUB_3, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(narc, GFX_TOP_PANEL_TILEMAP, bgConfig, BG_LAYER_SUB_3, 0, 0, TRUE, app->heapID);
}

// ov99_021E6274 and ov99_021E6400: the medal's digits and sparkles (0), the cursor and crowns (1), the courses' buttons
// (2, five palettes), the top screen's digits (char 6, the rest 3), the Pokémon's pictures (chars 3-5, palettes 4-6)
// and icons (chars 7-9 on the top screen)
static void LoadSpriteResources(CourseRecord *app)
{
    SpriteSystem *spriteSys = app->sprites->spriteSystem;
    SpriteManager *spriteMan = app->sprites->spriteManager;
    NARC *narc = app->narc;

    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDAL_DIGITS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDAL_DIGITS_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 0);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDAL_DIGITS_CELL, TRUE, 0);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_MEDAL_DIGITS_ANIM, TRUE, 0);

    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 1);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DMAIN, 1);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_CELL, TRUE, 1);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_CURSOR_ANIM, TRUE, 1);

    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_BUTTONS_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DMAIN, 2);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_BUTTONS_PLTT, FALSE, NUM_COURSES, NNS_G2D_VRAM_TYPE_2DMAIN, 2);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_BUTTONS_CELL, TRUE, 2);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_BUTTONS_ANIM, TRUE, 2);

    SpriteSystem_LoadCharResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_TOTAL_CHAR, TRUE, NNS_G2D_VRAM_TYPE_2DSUB, 6);
    SpriteSystem_LoadPlttResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_TOTAL_PLTT, FALSE, 1, NNS_G2D_VRAM_TYPE_2DSUB, 3);
    SpriteSystem_LoadCellResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_TOTAL_CELL, TRUE, 3);
    SpriteSystem_LoadAnimResObjFromOpenNarc(spriteSys, spriteMan, narc, GFX_TOTAL_ANIM, TRUE, 3);

    for (int i = 0; i < NUM_MONS; i++) {
        PokeathlonRecords_LoadMonPicResources(app->sprites, sMonPicResources[i], NNS_G2D_VRAM_TYPE_2DMAIN);
    }

    PokeathlonRecords_LoadIconResources(app->sprites, sIconResources, NUM_MONS, NNS_G2D_VRAM_TYPE_2DSUB, TRUE);
}

// ov99_021E6438: the sprites; a button for each course run, with its crowns
static void MakeSprites(CourseRecord *app)
{
    for (int i = 0; i < NUM_SPRITES; i++) {
        app->spriteList[i] = PokeathlonRecords_NewSprite(app->sprites, &sSpriteTemplates[i]);
        ManagedSprite_SetAnimateFlag(app->spriteList[i], TRUE);
    }

    for (int course = 0; course < NUM_COURSES; course++) {
        if (!HasRecord(app, course)) {
            ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_COURSE_BUTTON + course], FALSE);
        }

        ManagedSprite *crown = app->spriteList[SPRITE_CROWN + course];

#ifdef SOVEREIGN_TEST
        gCompleteTestPokeathlonCrowns[course] = HasRecord(app, course) ? 1 + PokeathlonRecords_CourseTrophyRank(CourseTotal(app, course)) : 0;
#endif

        switch (PokeathlonRecords_CourseTrophyRank(CourseTotal(app, course))) {
        case 2:
            ManagedSprite_SetAnim(crown, ANIM_CROWN_450 + course % 2);
            break;
        case 1:
            ManagedSprite_SetAnim(crown, ANIM_CROWN_420 + course % 2);
            break;
        default:
            ManagedSprite_SetDrawFlag(crown, FALSE);
            break;
        }
    }
}

// ov99_021E64E0: the medal's Pokémon, digits and sparkles (hidden as the page changes)
static void ShowPageSprites(CourseRecord *app, BOOL show)
{
    for (int i = 0; i < NUM_DIGITS; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_MEDAL_DIGIT + i], show);
    }

    for (int i = 0; i < NUM_MONS; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_MON_PIC + i], show);
    }

    for (int i = 0; i < 3; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_SPARKLE + i], show);
    }
}

// ov99_021E5EB4: a course's medal and ribbon, set a screen's width to one side (and the medal's sprites with them), to
// slide in
static void LoadCoursePage(CourseRecord *app, int course, BOOL fromRight)
{
    int x = fromRight ? -PAGE_SLIDE_DISTANCE : PAGE_SLIDE_DISTANCE;

    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG2, FALSE);
    GXLayers_EngineBToggleLayers(GX_PLANEMASK_BG1, FALSE);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(app->narc, sCoursePages[course].medal, app->bgConfig, BG_LAYER_MAIN_2, 0, 0, TRUE, app->heapID);
    Graphics_LoadTilemapToBgLayerFromOpenNARC(app->narc, sCoursePages[course].ribbon, app->bgConfig, BG_LAYER_SUB_1, 0, 0, TRUE, app->heapID);
    Bg_SetOffset(app->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_X, x);
    Bg_SetOffset(app->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, x);
    GXLayers_EngineAToggleLayers(GX_PLANEMASK_BG2, TRUE);
    GXLayers_EngineBToggleLayers(GX_PLANEMASK_BG1, TRUE);

    for (int i = 0; i < NELEMS(sSlidingSprites); i++) {
        ManagedSprite_OffsetPositionXY(app->spriteList[sSlidingSprites[i].sprite], -x, 0);
    }
}

// ov99_021E5FE8: a course run has its medal and ribbon; one not run, none
static void DrawPageBackground(CourseRecord *app, int course)
{
    if (HasRecord(app, course)) {
        LoadCoursePage(app, course, app->slideFromRight);
        return;
    }

    Bg_ClearTilemap(app->bgConfig, BG_LAYER_MAIN_2);
    Bg_ClearTilemap(app->bgConfig, BG_LAYER_SUB_1);
}

// ov99_021E5F74: the page slides a quarter of the way left each frame, the medal's sprites with it
static void SlidePage(CourseRecord *app)
{
    if (!app->sliding) {
        return;
    }

    int x = Bg_GetXOffset(app->bgConfig, BG_LAYER_MAIN_2);
    int next = x >> 2;

    if (x == next) {
        next = 0;
    }

    Bg_ScheduleScroll(app->bgConfig, BG_LAYER_MAIN_2, BG_OFFSET_UPDATE_SET_X, next);
    Bg_ScheduleScroll(app->bgConfig, BG_LAYER_SUB_1, BG_OFFSET_UPDATE_SET_X, next);

    for (int i = 0; i < NELEMS(sSlidingSprites); i++) {
        ManagedSprite_SetPositionXY(app->spriteList[sSlidingSprites[i].sprite], sSlidingSprites[i].x - next, sSlidingSprites[i].y);
    }

    if (next == 0) {
        app->sliding = FALSE;
    }
}

// ov99_021E6188: the medal's name, the course's name and, once every record's been played, the points its Collective
// Trophy needs
static void DrawTitles(CourseRecord *app, int course)
{
    PokeathlonRecordsText *text = app->text;

    PokeathlonRecords_SetMedalName(text->template, 0, course);
    PokeathlonRecords_PrintMessageAt(text, WINDOW_MEDAL, msg_0314_00004, 1, 0);
    PokeathlonRecords_SetCourseName(text->template, 0, course);
    PokeathlonRecords_PrintMessage(text, WINDOW_COURSE, msg_0314_00003, TRUE);

    if (!app->trophyGoals) {
        return;
    }

    switch (PokeathlonRecords_CourseTrophyRank(CourseTotal(app, course))) {
    case 0:
        PokeathlonRecords_PrintMessage(text, WINDOW_TROPHY_GOAL, msg_0314_00005, TRUE); // "420 Points for a Collective Trophy"
        break;
    case 1:
        PokeathlonRecords_PrintMessage(text, WINDOW_TROPHY_GOAL, msg_0314_00006, TRUE); // "450 Points..."
        break;
    default:
        PokeathlonRecords_ClearWindow(text, WINDOW_TROPHY_GOAL);
        break;
    }
}

// ov99_021E607C: "1:Hurdle Dash" and its points ("--- Points" for a course not run), then the bonus's
static void DrawEvents(CourseRecord *app, int course)
{
    PokeathlonRecordsText *text = app->text;

    for (int i = 0; i < NUM_EVENTS; i++) {
        PokeathlonRecords_SetEventName(text->template, 1, CourseEvent(course, i));
        PokeathlonRecords_PrintNumberMessage(text, WINDOW_EVENT_NAME + i, msg_0314_00010, i + 1, 1, 0);

        if (HasRecord(app, course)) {
            PokeathlonRecords_PrintNumberMessage(text, WINDOW_EVENT_POINTS + i, msg_0314_00008, CoursePoints(app, course, i), 3, 0);
        } else {
            PokeathlonRecords_PrintMessage(text, WINDOW_EVENT_POINTS + i, msg_0314_00009, FALSE);
        }
    }

    if (HasRecord(app, course)) {
        PokeathlonRecords_PrintNumberMessage(text, WINDOW_BONUS_POINTS, msg_0314_00008, CoursePoints(app, course, NUM_EVENTS), 3, 0);
    } else {
        PokeathlonRecords_PrintMessage(text, WINDOW_BONUS_POINTS, msg_0314_00009, FALSE);
    }
}

// ov99_021E6144 and ov99_021E6218: the Pokémon's names and "Points" by the total, for a course run
static void DrawNames(CourseRecord *app, int course)
{
    PokeathlonRecordsText *text = app->text;
    BOOL hasRecord = HasRecord(app, course);

    for (int i = 0; i < NUM_MONS; i++) {
        if (hasRecord) {
            PokeathlonRecords_PrintSpeciesName(text, WINDOW_MON_NAME + i, app->records[course].mons[i].species);
        } else {
            PokeathlonRecords_ClearWindow(text, WINDOW_MON_NAME + i);
        }
    }

    if (hasRecord) {
        PokeathlonRecords_PrintMessage(text, WINDOW_POINTS, msg_0314_00001, FALSE);
    } else {
        PokeathlonRecords_ClearWindow(text, WINDOW_POINTS);
    }
}

// ov99_021E6050
static void DrawPageText(CourseRecord *app, int course)
{
    DrawTitles(app, course);
    DrawEvents(app, course);
    DrawNames(app, course);
}

// ov99_021E6530: the total's digits on both screens, the Pokémon's pictures and icons, and the sparkles, for a course
// run
static void DrawPageSprites(CourseRecord *app, int course)
{
    BOOL hasRecord = HasRecord(app, course);
    u16 total = CourseTotal(app, course);

    for (int i = 0; i < NUM_DIGITS; i++) {
        if (hasRecord) {
            u16 digit = PokeathlonRecords_Digit(total, i + 1);

            ManagedSprite_SetAnim(app->spriteList[SPRITE_TOTAL_DIGIT + i], digit);
            ManagedSprite_SetAnim(app->spriteList[SPRITE_MEDAL_DIGIT + i], digit); // ov99_021E9628: the digit's animation
        }

        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_MEDAL_DIGIT + i], hasRecord);
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_TOTAL_DIGIT + i], hasRecord);
    }

    for (int i = 0; i < NUM_MONS; i++) {
        const CompletePokeathlonRecordMon *mon = &app->records[course].mons[i];

        if (hasRecord) {
            PokeathlonRecords_DrawMonPic(app->spriteList[SPRITE_MON_PIC + i], mon, NNS_G2D_VRAM_TYPE_2DMAIN, app->heapID);
            PokeathlonRecords_DrawIcon(app->sprites, app->spriteList[SPRITE_ICON + i], mon, TRUE);
            ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_ICON + i], TRUE);
        } else {
            ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_ICON + i], FALSE);
        }
    }

    for (int i = 0; i < 3; i++) {
        ManagedSprite_SetDrawFlag(app->spriteList[SPRITE_SPARKLE + i], hasRecord);
    }

    app->course = course;
    NoteForTests(app);
}

// ov99_021E6018: "Course record", Return (in the subscreen font) and "Bonus Points"
static void DrawFixedText(CourseRecord *app)
{
    PokeathlonRecords_PrintMessageAt(app->text, WINDOW_TITLE, msg_0314_00002, 1, 0);
    PokeathlonRecords_PrintMessageInFont(app->text, WINDOW_RETURN, msg_0314_00000, TRUE, 0, FONT_SUBSCREEN);
    PokeathlonRecords_PrintMessage(app->text, WINDOW_BONUS, msg_0314_00007, FALSE);
}

// ov99_021E6638: TRUE to leave (B, A on Return, or Return touched). A touch on a course's button moves the cursor there;
// held, the D-pad repeats. A new course's page is drawn the next frame and slides in.
static BOOL HandleInput(CourseRecord *app)
{
    BOOL leave = FALSE;
    s8 previous = app->cursor;

    if (JOY_NEW(PAD_BUTTON_B)) {
        return TRUE;
    }

    if (TouchScreen_Tapped()) {
        int touched = TouchScreen_CheckPressedHitTableID(sHitTable);

        if (touched != TOUCHSCREEN_INPUT_NONE) {
            if (touched == CURSOR_RETURN) {
                leave = TRUE;
            } else {
                app->slideFromRight = app->cursor < touched;
                ManagedSprite_SetAnim(app->spriteList[SPRITE_CURSOR], ANIM_CURSOR_TOUCHED);
                ManagedSprite_SetAnimateFlag(app->spriteList[SPRITE_CURSOR], TRUE);
                Sound_PlayEffect(SE_CONFIRM_sseq_3);
            }

            app->cursor = touched;
        }
    } else if (JOY_REPEAT(PAD_KEY_RIGHT | PAD_KEY_DOWN)) {
        if (previous < CURSOR_RETURN) {
            app->cursor++;
            app->slideFromRight = TRUE;
            Sound_PlayEffect(SE_CONFIRM_sseq_3);
        }
    } else if (JOY_REPEAT(PAD_KEY_LEFT | PAD_KEY_UP)) {
        if (previous > 0) {
            app->cursor--;
            app->slideFromRight = FALSE;
            Sound_PlayEffect(SE_CONFIRM_sseq_3);
        }
    } else if (JOY_NEW(PAD_BUTTON_A)) {
        if (previous == CURSOR_RETURN) {
            return TRUE;
        }
    }

    if (app->cursor > CURSOR_RETURN) {
        app->cursor = CURSOR_RETURN;
    } else if (app->cursor < 0) {
        app->cursor = 0;
    }

    if (app->cursor != previous) {
        ManagedSprite *cursor = app->spriteList[SPRITE_CURSOR];

        ManagedSprite_SetPositionXY(cursor, sCursorPositions[app->cursor].x, sCursorPositions[app->cursor].y);

        if (app->cursor == CURSOR_RETURN) {
            ManagedSprite_SetAnim(cursor, ANIM_CURSOR_RETURN);
        } else {
            if (ManagedSprite_GetActiveAnim(cursor) != ANIM_CURSOR_TOUCHED) {
                ManagedSprite_SetAnim(cursor, ANIM_CURSOR);
            }

            if (app->cursor != app->course) { // HeartGold: unless it came from Return to the fifth course
                ShowPageSprites(app, FALSE);
                app->course = app->cursor;
                app->redraw = TRUE;
            }
        }

        NoteForTests(app);
    }

    return leave;
}

// ov99_021E6250
static void VBlank(void *data)
{
    CourseRecord *app = data;

    SpriteSystem_TransferOam();
    Bg_RunScheduledUpdates(app->bgConfig);
    OS_SetIrqCheckFlag(OS_IE_V_BLANK);
}
