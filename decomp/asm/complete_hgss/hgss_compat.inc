#pragma once
; Sovereign Complete: Platinum's names for what HeartGold's assembly in this folder calls (included by macros.inc).
; Every engine symbol the files name has a line here, so tools/complete/import_hgss_asm.py can check that nothing
; links by HeartGold's name alone (a function can mean something else in Platinum under the same name: HeartGold's
; Sprite_SetPriority is Platinum's Sprite_SetExplicitPriority, and its Sprite_SetDrawPriority Platinum's
; Sprite_SetPriority). A name on the right is never one on the left (the preprocessor would follow the chain);
; where it would be, a shim takes the name. tools/complete/hgss_asm_symbols.py checks each line against the code of
; both games (--compat).
;
; HgssCompat_* are the shims, in src/applications/complete_pokeathlon/hgss_compat.c: where HeartGold passes its own
; numbers (NARCs, text banks, fonts), where Platinum's function differs, and HeartGold's own functions.

; The same function (its code is Platinum's byte for byte, calls and pointers aside), named Platinum's way
#define AddWindowParameterized                           Window_Add
#define BG_FillCharDataRange                             Bg_FillTilesRange
#define BgClearTilemapBufferAndCommit                    Bg_ClearTilemap
#define BgCommitTilemapBufferToVram                      Bg_CopyTilemapBufferToVRAM
#define BgConfig_Alloc                                   BgConfig_New
#define BufferString                                     StringTemplate_SetString
#define ClearWindowTilemapAndCopyToVram                  Window_ClearAndCopyToVRAM
#define CopyRectToBgTilemapRect                          Bg_CopyRectToTilemapRect
#define CopyU16ArrayToString                             String_CopyChars
#define CopyU16StringArrayN                              CharCode_CopyNumChars
#define CopyWindowToVram                                 Window_CopyToVRAM
#define Create2DGfxResObjMan                             SpriteResourceCollection_New
#define CreateSpriteResourcesHeader                      SpriteResourcesHeader_Init
#define Destroy2DGfxResObjMan                            SpriteResourceCollection_Delete
#define DestroyMsgData                                   MessageLoader_Free
#define DoScheduledBgGpuUpdates                          Bg_RunScheduledUpdates
#define FillWindowPixelBuffer                            Window_FillTilemap
#define FreeBgTilemapBuffer                              Bg_FreeTilemapBuffer
#define G2dRenderer_Init                                 SpriteList_InitRendering
#define G2dRenderer_SetSubSurfaceCoords                  SetSubScreenViewRect
#define GF_AssertFail                                    ErrorHandling_AssertFail
#define GF_RunVramTransferTasks                          VramTransfer_Process
#define GetBoxMonData                                    BoxPokemon_GetValue
#define GetMonData                                       Pokemon_GetValue
#define GetWindowBgConfig                                Window_GetBgConfig
#define GetWindowWidth                                   Window_GetWidth
#define GfGfx_EngineATogglePlanes                        GXLayers_EngineAToggleLayers
#define GfGfx_EngineBTogglePlanes                        GXLayers_EngineBToggleLayers
#define GfGfx_SetBanks                                   GXLayers_SetBanks
#define InitBgFromTemplate                               Bg_InitFromTemplate
#define IsPaletteFadeFinished                            IsScreenFadeDone
#define Main_SetVBlankIntrCB                             SetVBlankCallback
#define MessageFormat_Delete                             StringTemplate_Free
#define MessageFormat_New                                StringTemplate_Default
#define MonIsShiny                                       Pokemon_IsShiny
#define Mon_GetBoxMon                                    Pokemon_GetBoxPokemon
#define NARC_Delete                                      NARC_dtor
#define NewString_ReadMsgData                            MessageLoader_GetNewString
#define OamManager_ApplyAndResetBuffers                  RenderOam_Transfer
#define ObjCharTransfer_ClearBuffers                     CharTransfer_ClearBuffers
#define ObjCharTransfer_Destroy                          CharTransfer_Free
#define ObjCharTransfer_Init                             CharTransfer_Init
#define ObjPlttTransfer_Destroy                          PlttTransfer_Free
#define ObjPlttTransfer_Init                             PlttTransfer_Init
#define ObjPlttTransfer_Reset                            PlttTransfer_Clear
#define OverlayManager_CreateAndGetData                  ApplicationManager_NewData
#define OverlayManager_GetArgs                           ApplicationManager_Args
#define OverlayManager_GetData                           ApplicationManager_Data
#define Party_GetCount                                   Party_GetCurrentCount
#define Party_GetMonByIndex                              Party_GetPokemonBySlotIndex
#define ReadMsgData_ExpandPlaceholders                   MessageUtil_ExpandedString
#define RemoveWindow                                     Window_Remove
#define ResetAllTextPrinters                             Text_ResetAllPrinters
#define ScheduleBgTilemapBufferTransfer                  Bg_ScheduleTilemapTransfer
#define SetBothScreensModesAndDisable                    SetAllGraphicsModes
#define SpriteList_RenderAndAnimateSprites               SpriteList_Update
#define SpriteTransfer_CreateCharTransferTask_AllocAtEnd SpriteTransfer_RequestCharAtEnd
#define SpriteTransfer_CreateExtPlttTransferTask         SpriteTransfer_RequestPlttWholeRange
#define SpriteTransfer_DeleteCharTransferTask            SpriteTransfer_ResetCharTransfer
#define SpriteTransfer_DeletePlttTransferTask            SpriteTransfer_ResetPlttTransfer
#define SpriteTransfer_GetCharProxy                      SpriteTransfer_GetImageProxy
#define Sprite_CreateAffine                              SpriteList_AddAffine
#define Sprite_GetMatrixPtr                              Sprite_GetPosition
#define Sprite_SetAnimActiveFlag                         Sprite_SetAnimateFlag
#define Sprite_SetAnimCtrlSeq                            Sprite_SetAnim
#define Sprite_SetMatrix                                 Sprite_SetPosition
#define Sprite_SetOamMode                                Sprite_SetExplicitOAMMode
#define Sprite_SetPaletteOverride                        Sprite_SetExplicitPalette
#define Sprite_SetPriority                               Sprite_SetExplicitPriority
#define String_Delete                                    String_Free
#define String_New                                       String_Init
#define sub_02074490                                     PokeIconPalettesFileIndex

; The same function under the same name (the NitroSDK's and NitroSystem's, the compiler's, the engine's own)
#define DC_FlushRange                                    DC_FlushRange
#define G2x_SetBlendAlpha_                               G2x_SetBlendAlpha_
#define G2x_SetBlendBrightness_                          G2x_SetBlendBrightness_
#define GXS_LoadOBJ                                      GXS_LoadOBJ
#define GXS_LoadOBJPltt                                  GXS_LoadOBJPltt
#define GX_LoadOBJ                                       GX_LoadOBJ
#define Heap_Alloc                                       Heap_Alloc
#define Heap_AllocAtEnd                                  Heap_AllocAtEnd
#define Heap_Free                                        Heap_Free
#define MI_CpuFill8                                      MI_CpuFill8
#define MIi_CpuCopy16                                    MIi_CpuCopy16
#define MIi_CpuCopyFast                                  MIi_CpuCopyFast
#define NARC_ReadWholeMember                             NARC_ReadWholeMember
#define NNS_G2dGetImageLocation                          NNS_G2dGetImageLocation
#define NNS_G2dGetImagePaletteLocation                   NNS_G2dGetImagePaletteLocation
#define NNS_G2dGetUnpackedBGCharacterData                NNS_G2dGetUnpackedBGCharacterData
#define NNS_G2dGetUnpackedPaletteData                    NNS_G2dGetUnpackedPaletteData
#define NNS_G2dInitOamManagerModule                      NNS_G2dInitOamManagerModule
#define SpriteList_Delete                                SpriteList_Delete
#define SpriteTransfer_GetPaletteProxy                   SpriteTransfer_GetPaletteProxy
#define Sprite_Delete                                    Sprite_Delete
#define Sprite_GetDrawFlag                               Sprite_GetDrawFlag
#define Sprite_SetDrawFlag                               Sprite_SetDrawFlag
#define _s32_div_f                                       _s32_div_f
#define memset                                           memset

; The same function, its code a little different (a constant, a save block's number, a debug check): the same
; arguments and meaning, checked by hand against both decomps
#define BeginNormalPaletteFade                           StartScreenFade
#define BgTilemapRectChangePalette                       Bg_ChangeTilemapRectPalette
#define GetMonIconNaixEx                                 PokeIconSpriteIndex
#define GetMonIconPaletteEx                              PokeIconPaletteIndex
#define GetSpeciesName                                   MessageUtil_SpeciesName
#define GfGfx_SwapDisplay                                GXLayers_SwapDisplay
#define LoadFontPal0                                     Font_LoadTextPalette
#define LoadUserFrameGfx2                                LoadMessageBoxGraphics
#define OamManager_Create                                RenderOam_Init
#define OamManager_Free                                  RenderOam_Free
#define PCStorage_GetBoxName                             PCBoxes_BufferBoxName
#define PCStorage_GetMonByIndexPair                      PCBoxes_GetBoxMonAt
; (the DP sound effects have the same numbers in Complete's archive; HeartGold's own, SEQ_SE_GS_*, will need a shim)
#define PlaySE                                           Sound_PlayEffect
#define SaveArray_PCStorage_Get                         SaveData_GetPCBoxes
#define SaveArray_Party_Get                              SaveData_GetParty
#define TouchscreenHitbox_FindRectAtTouchNew             TouchScreen_CheckRectanglePressed

; Shims: HeartGold's numbers translated (NARCs, text banks, fonts)
#define AddCellOrAnimResObjFromNarc                      HgssCompat_AddCellOrAnimResObjFromNarc
#define AddCharResObjFromNarc                            HgssCompat_AddCharResObjFromNarc
#define AddPlttResObjFromNarc                            HgssCompat_AddPlttResObjFromNarc
#define AddTextPrinterParameterizedWithColor             HgssCompat_AddTextPrinterParameterizedWithColor
#define AllocAndReadWholeNarcMemberByIdPair              HgssCompat_AllocAndReadWholeNarcMemberByIdPair
#define FontID_Alloc                                     HgssCompat_FontID_Alloc
#define FontID_Release                                   HgssCompat_FontID_Release
#define FontID_String_GetCenterAlignmentX                HgssCompat_FontID_String_GetCenterAlignmentX
#define GfGfxLoader_GXLoadPal                            HgssCompat_GfGfxLoader_GXLoadPal
#define GfGfxLoader_GetScrnData                          HgssCompat_GfGfxLoader_GetScrnData
#define GfGfxLoader_LoadCharData                         HgssCompat_GfGfxLoader_LoadCharData
#define GfGfxLoader_LoadScrnData                         HgssCompat_GfGfxLoader_LoadScrnData
#define NARC_New                                         HgssCompat_NARC_New
#define NewMsgDataFromNarc                               HgssCompat_NewMsgDataFromNarc

; Shims: a name Platinum uses for something else, a different layout or behaviour, a function Platinum keeps static,
; or one it has but never calls (the linker leaves it out of the main module, so calling it would grow main memory)
#define BoxMonIsShiny                                    HgssCompat_BoxMonIsShiny
#define GetMonSpriteCharAndPlttNarcIdsEx                 HgssCompat_GetMonSpriteCharAndPlttNarcIdsEx
#define sub_02014540                                     HgssCompat_LoadPokemonSprite
#define Sprite_SetDrawPriority                           HgssCompat_Sprite_SetDrawPriority
#define System_GetTouchHeld                              HgssCompat_System_GetTouchHeld
#define System_GetTouchHeldCoords                        HgssCompat_System_GetTouchHeldCoords
#define System_GetTouchNew                               HgssCompat_System_GetTouchNew
#define YesNoPrompt_Create                               HgssCompat_YesNoPrompt_Create
#define YesNoPrompt_Destroy                              HgssCompat_YesNoPrompt_Destroy
#define YesNoPrompt_HandleInput                          HgssCompat_YesNoPrompt_HandleInput
#define YesNoPrompt_InitFromTemplate                     HgssCompat_YesNoPrompt_InitFromTemplate
#define YesNoPrompt_Reset                                HgssCompat_YesNoPrompt_Reset
#define sub_0203A994                                     HgssCompat_ShowNetworkIcon

; HeartGold's own: its Pokéathlon save, performance and Aprijuice, and a helper of its main module
#define BufferPokeathlonCourseName                       HgssCompat_BufferPokeathlonCourseName
#define CalcBoxMonPokeathlonPerformance                  HgssCompat_CalcBoxMonPokeathlonPerformance
#define CalcBoxmonPokeathlonStars                        HgssCompat_CalcBoxmonPokeathlonStars
#define CalcMonPokeathlonStars                           HgssCompat_CalcMonPokeathlonStars
#define Party_GetMonAprijuiceModifiers                   HgssCompat_Party_GetMonAprijuiceModifiers
#define PokeathlonSave_GetUnkDC_AtIndex                  HgssCompat_PokeathlonSave_GetMedal
#define Save_Pokeathlon_Get                              HgssCompat_Save_Pokeathlon_Get
#define sub_0208B85C                                     HgssCompat_StarsToShow

; Data: gSystem's fields past 0x5C are moved by the import (HeartGold's System has a word more); the IRQ table is
; the NitroSDK's
#define gSystem                                          gSystem
#define OS_IRQTable                                      OS_IRQTable

; Constants the files name (HeartGold's constants/pokemon.h): Platinum's values, the same numbers
#define MON_DATA_SPECIES                                 5
#define MON_DATA_HELD_ITEM                               6
#define MON_DATA_IS_EGG                                  76
#define MON_DATA_FORM                                    112
