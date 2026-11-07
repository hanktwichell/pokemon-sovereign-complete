#include <nitro.h>

#include "constants/graphics.h"
#include "constants/heap.h"
#include "generated/text_banks.h"
#include "generated/vars_flags.h"

#include "applications/complete_pokeathlon/hgss_compat.h"
#include "data/complete_pokeathlon_models.h"
#include "data/complete_pokeathlon_sounds.h"

#include "bg_window.h"
#include "character_sprite.h"
#include "font.h"
#include "heap.h"
#include "message.h"
#include "network_icon.h"
#include "sound.h"
#include "sound_playback.h"
#include "sound_system.h"
#include "sprite.h"
#include "sprite_system.h"
#include "string_gf.h"
#include "string_template.h"
#include "system.h"
#include "trainer_info.h"
#include "vars_flags.h"

// Sovereign Complete: the shims HeartGold's Pokéathlon course calls (its overlay 96 and 98 and its TextOBJ file, in
// decomp/asm/complete_hgss/; hgss_compat.inc names each), beside hgss_compat.c's (the course's choice of Pokémon's, and
// the archives') and hgss_compat_save.c's (the save's): sounds by HeartGold's numbers, its flags, sprites and touch
// functions Platinum keeps static or lacks, its walking Pokémon's models, a sort, and the link play Complete leaves out.

// ---- Sounds: HeartGold's numbers as Complete's (include/data/complete_pokeathlon_sounds.h, by HeartGold's number), 0
// for one Complete's archive lacks, which plays nothing

// (a number with HGSS_SOUND_OURS set is Complete's already: GF_GetCurrentPlayingBGM's for a song HeartGold lacks)
#define HGSS_SOUND_OURS 0x8000

static u16 HgssCompat_Sound(u16 seqID)
{
    int lo = 0, hi = COMPLETE_POKEATHLON_SOUNDS - 1;

    if (seqID & HGSS_SOUND_OURS) {
        return seqID & ~HGSS_SOUND_OURS;
    }

    while (lo <= hi) {
        int mid = (lo + hi) / 2;

        if (sCompletePokeathlonSounds[mid][0] == seqID) {
            return sCompletePokeathlonSounds[mid][1];
        }

        if (sCompletePokeathlonSounds[mid][0] < seqID) {
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }

    return 0;
}

// HeartGold's sound scenes for the Pokéathlon's songs (24, 25) aren't Platinum's: they play as Platinum's scene 8
// does (the field's effects loaded, the song as a scene's)
static u8 HgssCompat_SoundScene(int scene)
{
    return scene == 24 || scene == 25 ? SOUND_SCENE_8 : scene;
}

BOOL HgssCompat_PlaySE(u16 seqID)
{
    u16 seq = HgssCompat_Sound(seqID);
    return seq != 0 ? Sound_PlayEffect(seq) : FALSE;
}

BOOL HgssCompat_PlaySE_SetPitch(u16 seqID, int pitch)
{
    u16 seq = HgssCompat_Sound(seqID);

    if (seq == 0 || !Sound_PlayEffect(seq)) {
        return FALSE;
    }

    Sound_SetPitchForSequence(seq, 0xFFFF, pitch);
    return TRUE;
}

BOOL HgssCompat_PlaySEOnPlayer(u16 seqID, int playerID)
{
    u16 seq = HgssCompat_Sound(seqID);
    return seq != 0 ? Sound_PlayEffectOnPlayer(seq, playerID) : FALSE;
}

BOOL HgssCompat_PlaySEWithVolume(u16 seqID, int volume)
{
    u16 seq = HgssCompat_Sound(seqID);

    if (seq == 0 || !Sound_PlayEffect(seq)) {
        return FALSE;
    }

    Sound_SetInitialVolumeForSequence(seq, volume);
    return TRUE;
}

void HgssCompat_StopSE(u16 seqID, int fadeOutFrames)
{
    u16 seq = HgssCompat_Sound(seqID);

    if (seq != 0) {
        Sound_StopEffect(seq, fadeOutFrames);
    }
}

BOOL HgssCompat_IsSEPlaying(u16 seqID)
{
    u16 seq = HgssCompat_Sound(seqID);
    return seq != 0 && Sound_IsEffectPlaying(seq);
}

void HgssCompat_SetPitchForSequence(u16 seqID, u16 tracks, int pitch)
{
    u16 seq = HgssCompat_Sound(seqID);

    if (seq != 0) {
        Sound_SetPitchForSequence(seq, tracks, pitch);
    }
}

// HeartGold's sub_02005944: a player's tracks' pitch (its name says pan; HeartGold sets the pitch)
void HgssCompat_SetPanForSequence(int playerID, u16 tracks, int pitch)
{
    Sound_SetPitchForHandle(SoundSystem_GetSoundHandleTypeFromPlayerID(playerID), tracks, pitch);
}

// HeartGold's sub_020061D0: a player's tracks' pan
void HgssCompat_SetPanForPlayer(int playerID, int pan)
{
    Sound_SetPanForHandle(SoundSystem_GetSoundHandleTypeFromPlayerID(playerID), 0xFFFF, pan);
}

// HeartGold's sub_02005B78: a playing sequence's variable, which the course's opening waits on to time its pictures
// to its song (ov96_021EF280). A song Complete's archive lacks plays nothing, so its cues are all reached at once.
BOOL HgssCompat_ReadSequenceVariable(u16 seqID, int variable, s16 *value)
{
    u16 seq = HgssCompat_Sound(seqID);

    GF_ASSERT(variable <= 15);

    if (seq == 0) {
        *value = 0x7FFF;
        return TRUE;
    }

    // NitroSystem's NNS_SndPlayerReadVariable, which Complete doesn't link (calling it would put it and the SDK's
    // SND_GetPlayerLocalVariable in the main module): the variable from the sound driver's work shared with the ARM7
    NNSSndHandle *handle = SoundSystem_GetSoundHandle(SoundSystem_GetSoundHandleTypeFromPlayerID(Sound_GetPlayerForSequence(seq)));

    if (!NNS_SndHandleIsValid(handle)) {
        return FALSE;
    }

    if (!handle->player->startFlag) {
        *value = SND_DEFAULT_VARIABLE;
        return TRUE;
    }

    vs16 *shared = &SNDi_SharedWork->player[handle->player->playerNo].variable[variable];

    DC_InvalidateRange((void *)shared, sizeof(*shared));
    *value = *shared;
    return TRUE;
}

int HgssCompat_CountPlayingOnPlayer(int playerID)
{
    return Sound_GetNumberOfPlayingSequencesForPlayer(playerID);
}

// HeartGold's sub_020053A8: a BGM player paused or let go on (HeartGold's 1 and 7: Platinum's PLAYER_FIELD and
// PLAYER_BGM)
void HgssCompat_SetBGMPlayerPaused(u8 playerID, BOOL paused)
{
    Sound_SetBGMPlayerPaused(playerID, paused);
}

// A song the course started that Complete's archive lacks (HeartGold's number; 0 when the song playing is one it
// has): it stands for the silence that plays instead, so the course can ask for it back (GF_GetCurrentPlayingBGM),
// and its cues, which the course waits on, are all reached at once (HgssCompat_ReadSequenceVariable)
static u16 sMissingBGM;

static void HgssCompat_StartMissingBGM(u16 seqID)
{
    u16 playing = Sound_GetCurrentBGM();

    if (playing != 0) {
        Sound_StopBGM(playing, 0);
    }

    sMissingBGM = seqID;
}

BOOL HgssCompat_PlayBGM(u16 seqID)
{
    u16 seq = HgssCompat_Sound(seqID);

    if (seq == 0) {
        HgssCompat_StartMissingBGM(seqID);
        return FALSE;
    }

    sMissingBGM = 0;
    return Sound_PlayBGM(seq);
}

void HgssCompat_StopBGM(u16 seqID, int fadeOutFrames)
{
    u16 seq = HgssCompat_Sound(seqID);

    if (seqID == sMissingBGM) {
        sMissingBGM = 0;
    }

    if (seq != 0) {
        Sound_StopBGM(seq, fadeOutFrames);
    }
}

// HeartGold's GF_GetCurrentPlayingBGM: the song's number, which the course hands back to StopBGM and
// sub_02005B78: HeartGold's for a song of the table, else Complete's own, marked
u16 HgssCompat_GF_GetCurrentPlayingBGM(void)
{
    u16 seq = Sound_GetCurrentBGM();

    if (sMissingBGM != 0) {
        return sMissingBGM;
    }

    for (int i = 0; i < COMPLETE_POKEATHLON_SOUNDS; i++) {
        if (sCompletePokeathlonSounds[i][1] == seq) {
            return sCompletePokeathlonSounds[i][0];
        }
    }

    return seq | HGSS_SOUND_OURS;
}

void HgssCompat_GF_SndStartFadeOutBGM(int targetVolume, int frames)
{
    Sound_FadeOutBGM(targetVolume, frames);
}

void HgssCompat_Sound_SetScene(int scene)
{
    Sound_SetScene(HgssCompat_SoundScene(scene));
}

BOOL HgssCompat_Sound_SetSceneAndPlayBGM(u8 scene, u16 seqID, int unused)
{
    u16 seq = HgssCompat_Sound(seqID);

    if (seq == 0) {
        HgssCompat_StartMissingBGM(seqID);
        Sound_SetScene(HgssCompat_SoundScene(scene));
        return FALSE;
    }

    sMissingBGM = 0;
    return Sound_SetSceneAndPlayBGM(HgssCompat_SoundScene(scene), seq, unused);
}

BOOL HgssCompat_PlayFanfare(u16 seqID)
{
    u16 seq = HgssCompat_Sound(seqID);
    return seq != 0 ? Sound_PlayFanfare(seq) : FALSE;
}

BOOL HgssCompat_IsFanfarePlaying(void)
{
    return Sound_IsBGMPausedByFanfare();
}

BOOL HgssCompat_PlayCry(u16 species, u8 form)
{
    return Sound_PlayPokemonCry(species, form);
}

// HeartGold's IsCryFinished: despite its name, TRUE while the cry plays (its wave player is busy)
BOOL HgssCompat_IsCryFinished(void)
{
    return Sound_IsPokemonCryPlaying();
}

// ---- Text

// HeartGold's BufferPokeathlonMedalName: a medal's name (msg_0313's 15 to 19) into the template's slot
void HgssCompat_BufferPokeathlonMedalName(StringTemplate *template, u32 idx, u32 medal)
{
    MessageLoader *loader = MessageLoader_Init(MSG_LOADER_LOAD_ON_DEMAND, NARC_INDEX_MSGDATA__PL_MSG, TEXT_BANK_HGSS_MSG_0313, template->heapID);
    String *name = MessageLoader_GetNewString(loader, 15 + medal);

    GF_ASSERT(medal < 5);
    StringTemplate_SetString(template, idx, name, 0, TRUE, GAME_LANGUAGE);
    String_Free(name);
    MessageLoader_Free(loader);
}

u32 HgssCompat_FontID_String_GetWidthMultiline(int font, const String *string, u32 letterSpacing)
{
    return Font_CalcMaxLineWidth(HgssCompat_Font(font), string, letterSpacing);
}

// HeartGold's FillWindowPixelBufferText_AssumeTileSize32: the whole window filled with one colour
void HgssCompat_FillWindowPixelBufferText_AssumeTileSize32(Window *window, u8 fillValue)
{
    u32 fill = fillValue | (fillValue << 4);

    fill |= fill << 8;
    fill |= fill << 16;
    MI_CpuFillFast(window->pixels, fill, 32 * window->width * window->height);
}

// HeartGold's Bg_SetTextDimAndAffineParams: a layer's offset and its affine matrix at once
void HgssCompat_Bg_SetTextDimAndAffineParams(BgConfig *bgConfig, u8 bgLayer, u8 op, int value, MtxFx22 *mtx, int centerX, int centerY)
{
    Bg_SetOffset(bgConfig, bgLayer, op, value);
    Bg_SetAffineParams(bgConfig, bgLayer, mtx, centerX, centerY);
}

// ---- Flags: HeartGold's that the course sets (the Pokéathlon's firsts the reception's scripts check) are Complete's
// FLAG_HGSS_* (the script translation's names)

static u16 HgssCompat_Flag(u16 flag)
{
    switch (flag) {
    case 0xEF:
        return FLAG_HGSS_UNK_0EF;
    case 0xF0:
        return FLAG_HGSS_UNK_0F0;
    case 0xF1:
        return FLAG_HGSS_UNK_0F1;
    }

    GF_ASSERT(FALSE);
    return 0;
}

BOOL HgssCompat_Save_VarsFlags_CheckFlagInArray(VarsFlags *varsFlags, u16 flag)
{
    u16 ours = HgssCompat_Flag(flag);
    return ours != 0 && VarsFlags_CheckFlag(varsFlags, ours);
}

void HgssCompat_Save_VarsFlags_SetFlagInArray(VarsFlags *varsFlags, u16 flag)
{
    u16 ours = HgssCompat_Flag(flag);

    if (ours != 0) {
        VarsFlags_SetFlag(varsFlags, ours);
    }
}

// ---- Sprites and the screen

void HgssCompat_ManagedSprite_ResetSpriteAnimCtrlState(ManagedSprite *managedSprite)
{
    Sprite_RestartAnim(managedSprite->sprite);
}

NNSG2dCellAnimation *HgssCompat_Sprite_GetCellAnim(Sprite *sprite)
{
    GF_ASSERT(sprite->type != CELL_ANIM_TYPE_MULTI_CELL);
    return &((CellAnimationData *)sprite->animData)->anim;
}

void HgssCompat_Sprite_SetPaletteProxy(Sprite *sprite, const NNSG2dImagePaletteProxy *proxy)
{
    sprite->paletteProxy = *proxy;
}

// HeartGold's SpriteSystem_NewSpriteWithYOffset: Platinum's SpriteSystem_NewSprite puts a sub screen sprite 192
// pixels down; this one yOffset down
ManagedSprite *HgssCompat_SpriteSystem_NewSpriteWithYOffset(SpriteSystem *spriteSys, SpriteManager *spriteMan, const SpriteTemplate *template, fx32 yOffset)
{
    ManagedSprite *managedSprite = SpriteSystem_NewSprite(spriteSys, spriteMan, template);

    if (managedSprite != NULL && template->vramType == NNS_G2D_VRAM_TYPE_2DSUB && yOffset != FX32_CONST(192)) {
        VecFx32 position = *Sprite_GetPosition(managedSprite->sprite);

        position.y += yOffset - FX32_CONST(192);
        Sprite_SetPosition(managedSprite->sprite, &position);
    }

    return managedSprite;
}

// HeartGold's TintPalette_GrayScale (Platinum's twin is static to its battle animations)
void HgssCompat_TintPalette_GrayScale(u16 *palette, int count)
{
    for (int i = 0; i < count; i++) {
        u32 y = RGB_TO_GRAYSCALE(palette[i] & 0x1F, (palette[i] >> 5) & 0x1F, (palette[i] >> 10) & 0x1F);
        palette[i] = (u16)((y << 10) | (y << 5) | y);
    }
}

// HeartGold's UpdateMainScreenBrightnessSurface: which layers the main screen's brightness transition takes, which
// Platinum's controller sets with the transition itself (BrightnessController_StartTransition's planeMask, as the
// course's call before it gives): nothing more to do
void HgssCompat_UpdateMainScreenBrightnessSurface(int mask1, int mask2)
{
    (void)mask1;
    (void)mask2;
}

BOOL HgssCompat_System_GetTouchNewCoords(u32 *x, u32 *y)
{
    if (gSystem.touchPressed) {
        *x = gSystem.touchX;
        *y = gSystem.touchY;
        return TRUE;
    }

    return FALSE;
}

// HeartGold's WaitingIcon_New: the turning hourglass in a window, used only while waiting for the other players (link
// play, left out): none
void *HgssCompat_WaitingIcon_New(Window *window, u32 baseTile)
{
    (void)window;
    (void)baseTile;
    GF_ASSERT(FALSE);
    return NULL;
}

// HeartGold's network icon's update and its hide (link play only)
void HgssCompat_UpdateNetworkIcon(void)
{
}

void HgssCompat_HideNetworkIcon(void)
{
}

// ---- A Pokémon's picture: HeartGold's archive numbers translated (a picture's archive from GetMonSpriteCharAnd
// PlttNarcIdsEx is Platinum's already, marked)

void *HgssCompat_LoadPokemonPalette(int narcID, int member, enum HeapID heapID)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    return CharacterSprite_LoadPalette(narc, member, heapID);
}

typedef struct HgssSpriteRect {
    int x;
    int y;
    int w;
    int h;
} HgssSpriteRect;

void HgssCompat_LoadPokemonSpriteRect(int narcID, int member, enum HeapID heapID, const HgssSpriteRect *rect, void *dest, u32 personality, BOOL isAnimated, int face, int species)
{
    enum NarcID narc = HgssCompat_NarcMember(narcID, &member);
    CharacterSprite_LoadPokemonSpriteRect(narc, member, heapID, rect->x, rect->y, rect->w, rect->h, dest, personality, isAnimated, face, (enum Species)species);
}

void *HgssCompat_AllocPokemonSprite(int narcID, int member, enum HeapID heapID, u32 personality, BOOL isAnimated, int face, int species)
{
    void *sprite = Heap_Alloc(heapID, 3200);

    HgssCompat_LoadPokemonSprite(narcID, member, heapID, sprite, personality, isAnimated, face, species);
    return sprite;
}

// HeartGold's sub_020145B4: tiles of a texture (texDim tiles wide, 4 bytes a tile row) cut to a rectangle, row by row
void HgssCompat_CopySpriteTiles(const void *texSrc, int texDim, int x, int y, int w, int h, void *dest)
{
    const u8 *src = texSrc;
    u8 *dst = dest;
    int srcBlockSize = texDim * 4;
    int dstOffset = 0;

    for (int i = y; i < y + h; i++) {
        for (int j = x; j < x + w; j++) {
            int srcOffset = j * 4 + i * srcBlockSize * 8;

            for (int k = 0; k < 8; k++) {
                memcpy(dst + dstOffset, src + srcOffset, 4);
                srcOffset += srcBlockSize;
                dstOffset += 4;
            }
        }
    }
}

// ---- The walking Pokémon's models (HeartGold's follow_mon.c tables, include/data/complete_pokeathlon_models.h): the
// course draws a Pokémon on the field from its walking sprite, HeartGold's model 297 + its index (+ form or female)

int HgssCompat_SpeciesToOverworldModelIndexOffset(int species)
{
    return species >= 0 && species < (int)NELEMS(sHgssModelIndex) ? sHgssModelIndex[species] : HGSS_FOLLOWER_MON_DITTO;
}

int HgssCompat_OverworldModelLookupFormCount(int species)
{
    return species > 0 && species <= (int)NELEMS(sHgssModelForms) ? sHgssModelForms[species - 1] : 0;
}

BOOL HgssCompat_OverworldModelLookupHasFemaleForm(int species)
{
    return species > 0 && species <= (int)NELEMS(sHgssModelFemale) ? sHgssModelFemale[species - 1] : FALSE;
}

// ---- Geometry (HeartGold's unk_02020E80.c: whether two segments cross, and where)

typedef struct HgssVec2D {
    s32 x;
    s32 y;
} HgssVec2D;

BOOL HgssCompat_IsLeftOfLine(const HgssVec2D *a, const HgssVec2D *b, const HgssVec2D *p)
{
    return p->x * (a->y - b->y) + a->x * (b->y - p->y) + b->x * (p->y - a->y) >= 0;
}

BOOL HgssCompat_SegmentsCross(const HgssVec2D *a, const HgssVec2D *b, const HgssVec2D *c, const HgssVec2D *d)
{
    return (HgssCompat_IsLeftOfLine(a, b, c) ^ HgssCompat_IsLeftOfLine(a, b, d)) == 1
        && (HgssCompat_IsLeftOfLine(c, d, a) ^ HgssCompat_IsLeftOfLine(c, d, b)) == 1;
}

// HeartGold's sub_02020EF4: the slope and intercept (fx32) of the line through two points (a vertical one's slope 255)
static void HgssCompat_LineThrough(int x0, int y0, int x1, int y1, fx32 *slope, fx32 *intercept)
{
    s16 dy = y1 - y0;
    s16 dx = x1 - x0;

    *slope = dx != 0 ? FX_Div(dy << FX32_SHIFT, dx << FX32_SHIFT) : FX32_CONST(0xFF);
    *intercept = (y0 << FX32_SHIFT) - FX_Mul(*slope, x0 << FX32_SHIFT);
}

// HeartGold's rounding there: the whole part (FX_Modf's), one up from a half
static s32 HgssCompat_RoundFx(fx32 value)
{
    fx32 whole;

    if (FX_Modf(value, &whole) >= FX32_HALF) {
        whole += FX32_ONE;
    }

    return whole >> FX32_SHIFT;
}

// HeartGold's sub_02020F4C: whether two segments cross, and where (out: 0xFFFF, 0xFFFF when they don't)
BOOL HgssCompat_SegmentsIntersection(const HgssVec2D *a, const HgssVec2D *b, const HgssVec2D *c, const HgssVec2D *d, HgssVec2D *out)
{
    fx32 slope0, intercept0, slope1, intercept1;
    HgssVec2D max0, min0, max1, min1;

    if (out != NULL) {
        out->x = 0xFFFF;
        out->y = 0xFFFF;
    }

    if (!HgssCompat_SegmentsCross(a, b, c, d)) {
        return FALSE;
    }

    HgssCompat_LineThrough(a->x, a->y, b->x, b->y, &slope0, &intercept0);
    HgssCompat_LineThrough(c->x, c->y, d->x, d->y, &slope1, &intercept1);

    if (slope0 == slope1) {
        return FALSE;
    }

    fx32 x = FX_Div(intercept1 - intercept0, slope0 - slope1);
    fx32 y = FX_Mul(slope1, x) + intercept1;

    out->x = HgssCompat_RoundFx(x);
    out->y = HgssCompat_RoundFx(y);

    max0.x = a->x >= b->x ? a->x : b->x;
    min0.x = a->x >= b->x ? b->x : a->x;
    max0.y = a->y >= b->y ? a->y : b->y;
    min0.y = a->y >= b->y ? b->y : a->y;
    max1.x = c->x >= d->x ? c->x : d->x;
    min1.x = c->x >= d->x ? d->x : c->x;
    max1.y = c->y >= d->y ? c->y : d->y;
    min1.y = c->y >= d->y ? d->y : c->y;

    return max0.x >= out->x && min0.x <= out->x && max0.y >= out->y && min0.y <= out->y
        && max1.x >= out->x && min1.x <= out->x && max1.y >= out->y && min1.y <= out->y;
}

// ---- MATH_QSort (the NitroSDK's, which Complete doesn't link: calling it would put it in the main module): HeartGold's
// calls sort a few results (at most twelve, of 12 bytes at most), so an insertion sort with the same arguments (the
// array, its count, one's size, the comparison, the SDK's work stack). Unlike the SDK's quicksort it keeps equal
// elements in their order; where results tie, their order may differ from HeartGold's.

typedef s32 (*HgssCompareFunc)(void *a, void *b);

void HgssCompat_MATH_QSort(void *head, u32 num, u32 width, HgssCompareFunc compare, void *stackBuf)
{
    u8 temp[32];
    u8 *items = head;

    (void)stackBuf; // the NitroSDK's sort's own stack, which this one doesn't need
    GF_ASSERT(width <= sizeof(temp));

    for (u32 i = 1; i < num; i++) {
        u32 j = i;

        MI_CpuCopy8(items + i * width, temp, width);

        while (j > 0 && compare(items + (j - 1) * width, temp) > 0) {
            MI_CpuCopy8(items + (j - 1) * width, items + j * width, width);
            j--;
        }

        MI_CpuCopy8(temp, items + j * width, width);
    }
}

// ---- Link play (left out of Complete, docs/Roadmap.md): the course calls these only with its arguments' mode 1

int HgssCompat_LinkPlayerCount(void)
{
    GF_ASSERT(FALSE);
    return 1;
}

TrainerInfo *HgssCompat_LinkPlayerProfile(int netID)
{
    (void)netID;
    GF_ASSERT(FALSE);
    return NULL;
}

void HgssCompat_LinkSyncStart(u8 type)
{
    (void)type;
}

BOOL HgssCompat_LinkSyncDone(u8 type)
{
    (void)type;
    return TRUE;
}

void HgssCompat_LinkCommandsInit(const void *table, int count, void *arg)
{
    (void)table;
    (void)count;
    (void)arg;
    GF_ASSERT(FALSE);
}

u32 HgssCompat_LinkPacketSizeVariable(void)
{
    return 0xFFFF;
}

BOOL HgssCompat_LinkSendFrom(int cmd, const void *data, int size)
{
    (void)cmd;
    (void)data;
    (void)size;
    GF_ASSERT(FALSE);
    return FALSE;
}

BOOL HgssCompat_LinkSend(int cmd, const void *data, int size)
{
    (void)cmd;
    (void)data;
    (void)size;
    GF_ASSERT(FALSE);
    return FALSE;
}

u16 HgssCompat_LinkMyID(void)
{
    return 0;
}
