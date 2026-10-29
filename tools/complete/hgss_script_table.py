"""HeartGold script commands -> the engine's (tools/complete/translate_hgss_scripts.py; docs/ScriptConversion.md).

COMMANDS maps a HeartGold macro name to a function from its (already renamed) arguments to the engine's lines.
Commands that Platinum has under the same name with the same arguments need no entry here; the translator keeps them.
"""

# HeartGold's GoToIfLt..GoToIfNe and CallIf* test the last comparison: the condition numbers are Platinum's too.
CONDITIONS = {'Lt': 0, 'Eq': 1, 'Gt': 2, 'Le': 3, 'Ge': 4, 'Ne': 5}
# HeartGold's sounds that Platinum has under another name (the rest of Diamond and Pearl's keep theirs).
SOUNDS = {
    'SEQ_SE_DP_SELECT': 'SE_CONFIRM_sseq_3',
    'SEQ_ME_ITEM': 'SEQ_FANFA4_sseq',
    'SEQ_ME_KEYITEM': 'SEQ_FANFA4_sseq',
    'SEQ_ME_BADGE': 'SEQ_BADGE_sseq',
    'SEQ_ME_ASA': 'SEQ_ASA_sseq',
    'SEQ_ME_LVUP': 'SEQ_FANFA1_sseq',
    'SEQ_ME_POKEGET': 'SEQ_FANFA5_sseq',
    'SEQ_ME_POKEGEAR_REGIST': 'SEQ_FANFA4_sseq',
}
# HeartGold's movement types for the follower in scenes: 48 follows the player (the same number in Platinum); 55 and
# 56 hold it during the scene (until the follower's own scene support, it stands still).
FOLLOWER_MOVEMENT_TYPES = {48: 'MOVEMENT_TYPE_FOLLOW_PLAYER', 55: 'MOVEMENT_TYPE_NONE', 56: 'MOVEMENT_TYPE_NONE'}
STD_MESSAGE_BANKS = ['TEXT_BANK_HGSS_MSG_0752', 'TEXT_BANK_HGSS_MSG_0211', 'TEXT_BANK_HGSS_MSG_0030',
                     'TEXT_BANK_HGSS_MSG_0435']


# HeartGold's standard scripts (include/constants/std_script.h) -> Platinum's common scripts
# (decomp/res/field/scripts/scripts_common.s), by meaning: the numbers differ past 2000. HeartGold's music for
# people Platinum lacks (Eusine, Clair, the Kimono Girls, Pichu) waits for HeartGold's music (step 6): nothing plays.
STD_SCRIPTS = {
    'std_signpost': ['CallCommonScript 0x7D0'],
    'std_nurse_joy': ['SetVarFromVar VAR_0x8007, VAR_LAST_TALKED', 'CallCommonScript 0x7D2'],
    'std_survive_poisoning': ['CallCommonScript 0x7D3'],
    'std_prompt_save': ['Common_SaveGame'],
    'std_receive_accessory': ['Common_GiveAccessory'],
    'std_obtain_item_verbose': ['Common_GiveItemQuantityNoLineFeed'],
    'std_bag_is_full': ['Common_MessageBagIsFull'],
    'std_pokecenter_pc': ['CallCommonScript 0x7E2'],
    'std_mart_intro': ['Common_VendorGreeting'],
    # the common mart (the same stock by badges), and HeartGold's special mart VAR_0x8004
    # (tools/complete/import_hgss_marts.py)
    'std_pokemart': ['PokeMartCommon'],
    'std_special_mart': ['AddVar VAR_0x8004, MART_SPECIALTIES_ID_HGSS_00', 'PokeMartSpecialties VAR_0x8004'],
    'std_whited_out_to_mom': ['CallCommonScript 0x7E4'],
    'std_whited_out_to_pokecenter': ['CallCommonScript 0x7E5'],
    'std_global_terminal_globe': ['CallCommonScript 0x7E9'],
    'std_bike_rack': ['CallCommonScript 0x7EE'],
    'std_hatch_egg': ['CallCommonScript 0x7EF'],
    'std_repel_wore_off': ['CallCommonScript 0x7F0'],
    'std_receive_background': ['Common_ObtainContestBackdrop'],
    'std_play_friend_music': ['Common_SetCounterpartBGM'],
    'std_fade_end_friend_music': ['Common_FadeToDefaultMusic'],
    'std_play_rival_intro_music': ['Common_SetRivalBGM'],
    'std_fade_end_rival_intro_music': ['Common_FadeToDefaultMusic2'],
    'std_play_rival_outro_music': ['Common_SetRivalBGM'],
    'std_fade_end_rival_outro_music': ['Common_FadeToDefaultMusic2'],
    'std_give_item_verbose': ['Common_GiveItemQuantity'],
    'std_play_mom_music': ['Common_SetFollowMeBGM'],
    'std_play_follow_music': ['Common_SetFollowMeBGM'],
    'std_fade_end_mom_music': ['Common_FadeToDefaultMusic3'],
    'std_frontier_gold_prints_check': ['Common_CheckAllFrontierGoldPrintsObtained'],
    'std_bag_is_full_griseous_orb': ['Common_GriseousOrbCouldNotBeRemoved'],
    'std_enter_global_terminal': ['CallCommonScript 0x802'],
    **{f'std_play_{who}_music': [] for who in ('eusine', 'clair', 'kimono_girl', 'pichu')},
    **{f'std_fade_end_{who}_music': ['Common_FadeToDefaultMusic'] for who in ('eusine', 'clair', 'kimono_girl', 'pichu')},
}


SIGN_TYPES = ['SIGNPOST_TYPE_MAP', 'SIGNPOST_TYPE_ARROW', 'SIGNPOST_TYPE_LANDMARK', 'SIGNPOST_TYPE_SCROLLING']


def item_vars(a):
    """HeartGold's ItemVars item, count (count 1 if left out): Platinum's SetVar takes a value or a var, as it does."""
    return [f'SetVar VAR_0x8004, {a[0]}', f'SetVar VAR_0x8005, {a[1] if len(a) > 1 else 1}']


def call_std(a):
    if a[0] in STD_SCRIPTS:
        return STD_SCRIPTS[a[0]]
    return [f'@ HGSS: CallStd {a[0]}']


# HeartGold's score events -> Platinum's trainer score events by meaning (numbered differently); the Pokéathlon's have
# none (it is skipped), apricorns count as berries
SCORE_EVENTS = {
    'SCORE_EVENT_BADGE_GET': 'TRAINER_SCORE_EVENT_BADGE_EARNED',
    'SCORE_EVENT_LEAGUE_WIN': 'TRAINER_SCORE_EVENT_HALL_OF_FAME_ENTRY',
    'SCORE_EVENT_REGIONAL_DEX_COMPLETE': 'TRAINER_SCORE_EVENT_LOCAL_DEX_DIPLOMA_RECEIVED',
    'SCORE_EVENT_NATIONAL_DEX_COMPLETE': 'TRAINER_SCORE_EVENT_NATIONAL_DEX_DIPLOMA_RECEIVED',
    'SCORE_EVENT_APRICORN_HARVESTED': 'TRAINER_SCORE_EVENT_BERRY_HARVESTED',
    'SCORE_EVENT_GOT_ALL_GOLD_PRINTS': 'TRAINER_SCORE_EVENT_ALL_BATTLE_FRONTIER_GOLD_PRINTS',
    'SCORE_EVENT_BATTLE_FACTORY_SET_WON': 'TRAINER_SCORE_EVENT_BATTLE_FACTORY_ROUND_COMPLETED',
    'SCORE_EVENT_BATTLE_CASTLE_SET_WON': 'TRAINER_SCORE_EVENT_BATTLE_CASTLE_ROUND_COMPLETED',
    'SCORE_EVENT_BATTLE_HALL_SET_WON': 'TRAINER_SCORE_EVENT_BATTLE_HALL_ROUND_COMPLETED',
    'SCORE_EVENT_BATTLE_ARCADE_SET_WON': 'TRAINER_SCORE_EVENT_BATTLE_ARCADE_ROUND_COMPLETED',
    'SCORE_EVENT_POKEATHLON_WON': None,
    'SCORE_EVENT_POKEATHLON_WON_LINK': None,
}


def score(a):
    event = SCORE_EVENTS.get(a[0], '')
    if event is None:
        return []
    return [f'IncrementTrainerScore {event}'] if event else [f'@ HGSS: AddSpecialGameStat {a[0]}']


# HeartGold's points box (its 116 shows it, 117 hides it, 118 updates it): coins (type 0) and Battle Points (1) are
# Platinum's windows, which share one slot and one hide; the Pokéathlon's points (2) are skipped with it. The last type
# shown decides the hide (a box is shown before it is hidden in each file).
POINTS_BOX = {'shown': None}


def points_box_show(a):
    POINTS_BOX['shown'] = a[0]
    if a[0] == '0':
        return [f'ShowCoins {a[1]}, {a[2]}']
    if a[0] == '1':
        return [f'ShowBattlePoints {a[1]}, {a[2]}']
    return [f'@ HGSS: ScrCmd_116 {", ".join(a)}']


def points_box_hide(a):
    return ['HideCoins'] if POINTS_BOX['shown'] in ('0', '1') else ['@ HGSS: ScrCmd_117']


def points_box_update(a):
    return {'0': ['UpdateCoinDisplay'], '1': ['UpdateBPDisplay']}.get(a[0], [f'@ HGSS: ScrCmd_118 {a[0]}'])


def trade(a):
    """LoadNPCTrade n: HeartGold's nth trade, as tools/complete/import_hgss_trades.py names it."""
    from import_hgss_trades import trade_names
    return [f'InitNPCTrade {trade_names()[int(a[0], 0)]}']


def one(template):
    """An entry that becomes one line: template uses {0}, {1}... for the arguments."""
    return lambda a: [template.format(*a)]


COMMANDS = {
    # Trainers (TRAINER_HGSS_*): HeartGold's extra bytes (a battle the player may lose without blacking out, and an
    # unused one) have no Platinum argument yet
    'TrainerBattle': one('StartTrainerBattle {0}, {1}'),
    'MultiBattle': one('StartTagBattle {0}, {1}, {2}'),
    'TrainerMessage': one('PrintTrainerDialogue {0}, {1}'),
    # Gifts and static encounters: no gift in Sacred Gold sets a form or an ability; a static encounter may be shiny
    'GiveMon': one('GivePokemon {0}, {1}, {2}, {5}'),
    'WildBattle': lambda a: [f'CompleteStartWildBattle {a[0]}, {a[1]}, {a[2] if len(a) > 2 else 0}'],
    'GetStaticEncounterOutcome': one('CompleteGetBattleResult {0}'),
    # Script structure
    'ScrDef': one('ScriptEntry {0}'),
    'ScrDefEnd': lambda a: ['ScriptEntryEnd'],
    'CallStd': call_std,
    # Comparisons and branches: Compare then GoToIfXx / CallIfXx, as two commands in both games
    'Compare': one('CompareVar {0}, {1}'),
    'Switch': one('SetVar VAR_0x8008, {0}'),
    'Case': lambda a: [f'CompareVar VAR_0x8008, {a[0]}', f'GoToIf 1, {a[1]}'],
    **{f'GoToIf{c}': (lambda n: lambda a: [f'GoToIf {n}, {a[0]}'])(n) for c, n in CONDITIONS.items()},
    **{f'CallIf{c}': (lambda n: lambda a: [f'CallIf {n}, {a[0]}'])(n) for c, n in CONDITIONS.items()},
    # Vars
    'SetVar': one('SetVarFromValue {0}, {1}'),
    'CopyVar': one('SetVarFromVar {0}, {1}'),
    # Messages
    'NPCMsg': one('Message {0}'),
    'CloseMsg': lambda a: ['CloseMessage'],
    'OpenMsg': lambda a: ['OpenMessage'],
    'HoldMsg': lambda a: ['CloseMessageWithoutErasing'],
    'SimpleNPCMsg': one('NPCMessage {0}'),
    'BufferPlayersName': one('BufferPlayerName {0}'),
    'BufferRivalsName': one('BufferRivalName {0}'),
    # People
    'HidePerson': one('RemoveObject {0}'),
    'ShowPerson': one('AddObject {0}'),
    'Lock': one('LockObject {0}'),
    'Release': one('ReleaseObject {0}'),
    # Time and the screen
    'Wait': one('WaitTime {0}, {1}'),
    'WaitFade': lambda a: ['WaitFadeScreen'],
    'GetWeekday': one('GetDayOfWeek {0}'),
    # Items
    'HasItem': one('CheckItem {0}, {1}, {2}'),
    # The player and people
    'GetPlayerCoords': one('GetPlayerMapPos {0}, {1}'),
    'GetPlayerFacing': one('GetPlayerDir {0}'),
    'MovePersonFacing': one('SetPosition {0}, {1}, {2}, {3}, {4}'),
    'GetPersonCoords': lambda a: ['.short SCRCMD_UNUSED_06A', f'.short {a[0]}', f'.short {a[1]}', f'.short {a[2]}'],
    'MoveWarp': one('SetWarpEventPos {0}, {1}, {2}'),
    'GetPartyLeadAlive': one('GetFirstNonEggInParty {0}'),
    # Buffers
    'BufferInt': one('BufferNumber {0}, {1}'),
    'BufferMonSpeciesName': one('BufferPartyMonSpecies {0}, {1}'),
    'BufferPartyMonNick': one('BufferPartyMonNickname {0}, {1}'),
    # Waiting, battles, leaving the field
    'WaitButtonOrDpad': lambda a: ['WaitABPadPress'],
    'CheckBattleWon': one('CheckWonBattle {0}'),
    'WhiteOut': lambda a: ['BlackOutFromBattle'],
    'RestoreOverworld': lambda a: ['ReturnToField'],
    # Party menus: HeartGold's for a trade and for choosing a Pokémon are Platinum's of the same kinds, and its
    # GetPartySelection reads and frees either one as Platinum's GetSelectedPartySlot does
    'ScrCmd_566': lambda a: ['OpenPartyMenuForTrade'],
    'PartySelectUI': lambda a: ['SelectMoveTutorPokemon'],
    'GetPartySelection': one('GetSelectedPartySlot {0}'),
    'SetMonMove': one('ResetPartyMonMoveSlot_Unused {0}, {1}, {2}'),
    # Trades (tools/complete/import_hgss_trades.py): the same commands in the same order
    'LoadNPCTrade': trade,
    'NPCTradeGetReqSpecies': one('GetNPCTradeRequestedSpecies {0}'),
    'NPCTradeExec': one('StartNPCTrade {0}'),
    'NPCTradeEnd': lambda a: ['FinishNPCTrade'],
    # Items: HeartGold's ItemVars puts the item and count in VAR_0x8004 and VAR_0x8005, as Platinum's item scripts expect
    'ItemVars': item_vars,
    'GiveItemNoCheck': lambda a: item_vars(a) + ['Common_GiveItemQuantity'],
    'GoToIfNoItemSpace': lambda a: item_vars(a[:2]) + ['CanFitItem VAR_0x8004, VAR_0x8005, VAR_RESULT',
                                                        f'GoToIfEq VAR_RESULT, 0, {a[2]}'],
    'TakeItemNoCheck': lambda a: item_vars(a) + ['RemoveItem VAR_0x8004, VAR_0x8005, VAR_RESULT'],
    'GiveItem': one('AddItem {0}, {1}, {2}'),
    'TakeItem': one('RemoveItem {0}, {1}, {2}'),
    'HasSpaceForItem': one('CanFitItem {0}, {1}, {2}'),
    # Signs: HeartGold's types are Platinum's (map, arrow, landmark, scrolling). A direction sign's third argument picks
    # HeartGold's sign picture, which isn't in yet (Platinum's default).
    'TrainerTipsEx': lambda a: [f'DrawSignpostTextBox {SIGN_TYPES[int(a[0])]}', 'SetSignpostCommand SIGNPOST_CMD_SCROLL_IN',
                                'WaitForSignpostDone', f'DrawSignpostScrollingMessage {a[1]}, VAR_RESULT',
                                'Common_HandleSignpostInput'],
    'DirectionSignpostEx': lambda a: [f'DrawSignpostInstantMessage {a[2]}, {SIGN_TYPES[int(a[0])]}',
                                      'SetSignpostCommand SIGNPOST_CMD_SCROLL_IN', 'WaitForSignpostDone',
                                      'GetSignpostInput VAR_RESULT', 'Common_HandleSignpostInput'],
    # More messages and the money box
    'NonNPCMsgVar': one('MessageVar {0}'),
    'NonNPCMsg': one('MessageInstant {0}'),  # both print the whole message at once
    # Elevators: the dynamic warp is Platinum's special location, the floor window and animation are the same;
    # HeartGold's floor numbers and names (its 6F) come from src/complete_scrcmd.c
    'SetDynamicWarp': one('SetSpecialLocation {0}, {1}, {2}, {3}, {4}'),
    'GetDynamicWarpFloorNo': one('CompleteGetElevatorFloor {0}'),
    'BufferDeptStoreFloorNo': one('CompleteBufferFloorName {0}, {1}'),
    'ElevatorCurFloorBox': one('ShowCurrentFloor {0}, {1}, {2}'),
    'ElevatorAnim': one('PlayElevatorAnimation {0}, {1}'),
    # The naming screen for a party Pokémon (HeartGold's slot 255 is the Bug-Catching Contest's catch: step 5)
    'NicknameInput': lambda a: ([f'OpenPokemonNamingScreen {a[0]}, {a[1]}'] if a[0] != '255'
                                else [f'@ HGSS: NicknameInput {", ".join(a)}']),
    'GiveTogepiEgg': lambda a: ['CompleteGiveTogepiEgg'],
    # after a static battle: its form 0 reads the battle just fought (form 1 reads a var HeartGold's engine sets)
    'StaticWildWonOrCaughtCheck': lambda a: ([f'CompleteCheckStaticNotBeaten {a[0]}'] if a[1] == '0'
                                             else [f'@ HGSS: StaticWildWonOrCaughtCheck {", ".join(a)}']),
    'HideMoneyBox': lambda a: ['HideMoney'],
    # Money, coins, the party, the saving icon: Platinum's commands of the same arguments and code (ribbons are
    # numbered the same in both games)
    'ShowMoneyBox': one('ShowMoney {0}, {1}'),
    'UpdateMoneyBox': lambda a: ['UpdateMoneyDisplay'],
    'AddMoney': one('GiveMoney {0}'),
    'SubMoneyVar': one('RemoveMoney2 {0}'),
    'HasEnoughMoneyVar': one('CheckMoney2 {0}, {1}'),
    'GiveCoins': one('AddCoins {0}'),
    'CheckGiveCoins': one('CheckCanAddCoins {0}, {1}'),
    'CheckCoinsImmediate': one('HasCoinsFromValue {0}, {1}'),
    'MonHasMove': one('CheckPartyMonHasMove {0}, {1}, {2}'),
    'MonGetFriendship': one('GetPartyMonFriendship {0}, {1}'),
    'MonAddFriendship': one('IncreasePartyMonFriendship {0}, {1}'),
    'GiveRibbon': one('SetPartyMonRibbon {0}, {1}'),
    'MonHasRibbon': one('GetPartyMonRibbon {0}, {1}, {2}'),
    'CountMonMoves': one('GetPartyMonMoveCount {0}, {1}'),
    'PartyCountNotEgg': one('CountPartyNonEggs {0}'),
    'PartyCountEgg': one('CountPartyEggs {0}'),
    'PlayerHasSpecies': one('CheckPartyHasSpecies {0}, {1}'),
    'Random': one('GetRandom {0}, {1}'),
    'SetOrCopyVar': one('SetVar {0}, {1}'),
    'AddWaitingIcon': lambda a: ['ShowSavingIcon'],
    'ResetBGM': lambda a: ['PlayDefaultMusic'],
    'PlayerOnBikeCheck': one('CheckPlayerOnBike {0}'),
    'MovePerson': one('SetObjectEventPos {0}, {1}, {2}'),
    'SaveGameNormal': one('TrySaveGame {0}'),
    'WaitButtonOrDelay': one('WaitABPressTime {0}'),
    'CountPCEmptySpace': one('GetPCBoxesFreeSlotCount {0}'),
    'AddSpecialGameStat': score,
    'AddSpecialGameStat2': score,
    'CallIfNotDefeated': lambda a: [f'CheckTrainerFlag {a[0]}', f'CallIf 0, {a[1]}'],
    # The starter (Platinum's starter var until the opening is decided), the National Dex, moves, fossils
    'GetStarterChoice': one('GetPlayerStarterSpecies {0}'),
    'NatDexFlagAction': one('GetSetNationalDexEnabled {0}, {1}'),
    'CheckNationalDexComplete': one('CheckNationalDexCompleted {0}'),
    'MonGetMove': one('GetPartyMonMove {0}, {1}, {2}'),
    'MonForgetMove': one('ClearPartyMonMoveSlot {0}, {1}'),
    'CountFossils': one('GetFossilCount {0}'),
    'GetFossilPokemon': one('GetSpeciesFromFossil {0}, {1}'),
    'GetFossilMinimumAmount': one('FindFossilAtThreshold {0}, {1}, {2}'),
    # HeartGold's unnamed commands that are Platinum's: a Pokémon's picture in a window and taking it away, the hour,
    # and one that does nothing (it reads a message slot and a value)
    'ScrCmd_452': one('DrawPokemonPreview {0}, {1}'),
    'ScrCmd_453': lambda a: ['RemovePokemonPreview'],
    'ScrCmd_522': one('GetHour {0}'),
    'ScrCmd_208': lambda a: [],
    'NopVar490': lambda a: [],  # does nothing in HeartGold either
    # The follower back in its ball (HeartGold's 600) and out again beside the player (606)
    'ScrCmd_600': lambda a: ['CompleteFollowerPutAway'],
    # Ball seals, numbered alike in both games
    'GetSealQuantity': one('CountSealOccurence {0}, {1}'),
    'BufferSealName': one('BufferBallSealName {0}, {1}'),
    'BufferSealNamePlural': one('BufferBallSealNamePlural {0}, {1}'),
    'GetUniqueSealsQuantity': one('CountUniqueSealsInSealCase {0}'),
    'ScrCmd_116': points_box_show,
    'ScrCmd_117': points_box_hide,
    'ScrCmd_118': points_box_update,
    'ScrCmd_606': lambda a: ['CompleteFollowerReturn'],
    'ScriptOverlayCmd': lambda a: [],  # loads or frees HeartGold's own code overlays
    # Objects' saved place, facing and movement; text buffers; the party; the daycare; the summary screen for learning
    # a move (HeartGold's form 1, read back by GetMoveSelection 1)
    'SetObjectFacing': one('SetObjectEventDir {0}, {1}'),
    'SetObjectMovementType': one('SetObjectEventMovementType {0}, {1}'),
    'BufferSpeciesNameIndef': one('BufferSpeciesNameWithArticle {0}, {1}'),
    'BufferTrainerClassNameIndef': one('BufferTrainerClassNameWithArticle {0}, {1}'),
    'Capitalize': one('CapitalizeFirstLetter {0}'),
    'BufferBoxMonNick': one('BufferMonNicknameFromPC {0}, {1}'),
    'CountAliveMons': lambda a: [f'CountAliveMonsExcept {a[0]}, {a[1] if len(a) > 1 else 6}'],
    'GetPartySlotWithSpecies': one('FindPartySlotWithSpecies {0}, {1}'),
    'MonGetGender': one('GetPartyMonGender_Unused {0}, {1}'),
    'CheckDaycareEgg': one('CheckDaycareHasEgg {0}'),
    'PokemonSummaryScreen': lambda a: ([f'OpenSummaryScreenTeachMove {a[1]}, {a[2]}'] if a[0] == '1'
                                       else [f'@ HGSS: PokemonSummaryScreen {", ".join(a)}']),
    'GetMoveSelection': lambda a: ([f'GetSummarySelectedMoveSlot {a[1]}'] if a[0] == '1'
                                   else [f'@ HGSS: GetMoveSelection {", ".join(a)}']),
    'RemoveWaitingIcon': lambda a: ['HideSavingIcon'],
    'MakeObjectVisible': one('ShowObject {0}'),
    'Warp': lambda a: [f'Warp {a[0]}, {a[2]}, {a[3]}, {a[4]}'],
    'ScrCmd_066': one('AddMenuEntryImm {0}, {1}'),
    # HeartGold calls opcode 21 RestartCurrentScript; it is Platinum's ReturnCommonScript, which does the same
    'RestartCurrentScript': lambda a: ['ReturnCommonScript'],
    # Money, coins, music
    'HasEnoughMoneyImmediate': one('CheckMoney {0}, {1}'),
    'SubMoneyImmediate': one('RemoveMoney {0}'),
    'GetCoinAmount': one('GetCoinsAmount {0}'),
    'TakeCoins': one('SubtractCoinsFromValue {0}'),
    'PlayBGM': one('PlayMusic {0}'),
    'StopBGM': lambda a: ['StopMusic'],
    'BufferSpeciesName': one('BufferSpeciesNameFromVar {0}, {1}, {2}, {3}'),
    # Johto and Kanto's 16 badges aren't in the save yet (step 7): none counts as won.
    'CheckBadge': one('SetVarFromValue {1}, 0'),
    'GiveBadge': lambda a: [],  # (Platinum's GiveBadge would give a Sinnoh badge)
    # Menus. HeartGold's take x, y, cursor, can-cancel, result var; Platinum's macros list the var before can-cancel
    # (the bytes are in the same order). An entry's middle argument is its help text (255: none), which Platinum's
    # menus don't have. HeartGold's yes/no is the touchscreen's buttons (GetMenuChoice between TouchscreenMenuHide
    # and TouchscreenMenuShow); Platinum's is a menu.
    # HeartGold's standard menu takes its strings from its own bank (191), not Platinum's; entries are 16-bit
    'MenuInitStdGmm': one('CompleteInitHGSSMenu {0}, {1}, {2}, {4}, {3}'),
    'MenuInit': one('InitLocalTextMenu {0}, {1}, {2}, {4}, {3}'),
    'MenuItemAdd': one('AddMenuEntry {0}, {2}'),
    'MenuExec': lambda a: ['ShowMenu'],
    'GetMenuChoice': one('ShowYesNoMenu {0}'),
    'TouchscreenMenuHide': lambda a: [],
    'TouchscreenMenuShow': lambda a: [],
    # Messages from another bank. GetStdMsgNaix picks one of four of HeartGold's shared banks (its ov01_022067C8:
    # the weekday siblings, field moves, Cameron the photographer, shops), which come in as text banks.
    'GetStdMsgNaix': lambda a: [f'SetVarFromValue {a[1]}, {STD_MESSAGE_BANKS[int(a[0], 0)]}'],
    'MsgBoxExtern': one('MessageFromBank {0}, {1}'),
    'NonNPCMsgExtern': one('MessageFromBankInstant {0}, {1}'),
    # The following Pokémon in scenes: HeartGold pauses or resumes its movement, waits for it, or gives it a movement
    # (step 5 adds these commands to the engine's follower).
    'ToggleFollowingPokemonMovement': one('CompleteFollowerPause {0}'),
    'WaitFollowingPokemonMovement': lambda a: ['CompleteFollowerWait'],
    'FollowingPokemonMovement': lambda a: [f'CompleteFollowerSetMovementType {FOLLOWER_MOVEMENT_TYPES[int(a[0])]}'],
    'ScrCmd_729': one('CompleteFollowerCheckActive {0}'),
    'ScrCmd_609': lambda a: [],  # resets the follower's movement after a scene; the engine's follower needs none yet
    'GenderMsgBox': one('MessageGendered {0}, {1}'),
}
