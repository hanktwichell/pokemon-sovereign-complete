#!/usr/bin/env python3
"""Check Voltorb Flip (src/applications/complete_voltorb_flip, HeartGold's code; CompleteScrCmd_VoltorbFlip) at the
Goldenrod Game Corner in the test build, from the bedroom state:

1. **Opens:** with a Coin Case in the bag (the test puts one there), the player reads Goldenrod's Voltorb Flip table
   (HeartGold's T25SP0101 script 0) and A goes through the man's line. Passes when the game opens (its board is made)
   and the field has stopped.
2. **Wins:** Play, then the test reads the board (gCompleteTestVoltorbFlipGame, the test build's) and flips every
   2 and 3, as a player who knew the board would: each is touched. Passes
   when the round is won, the menu is back, and the player's coins went up by the round's payout (the product of the
   cards flipped).
3. **Quits a round:** Play again, flip the first card that isn't a Voltorb with the buttons (the cursor walks to it,
   A flips it), then B and A: the Quit question, answered Yes with the A button (HeartGold's prompt takes the buttons; Platinum's touch one is drawn). Passes when the menu is
   back and the coins went up by that card.
4. **Leaves:** Quit on the menu (touched). Passes when the game closes and the player is back in the Game Corner, the
   field running.

Results: a line per part, 'ok' or what went wrong, and screenshots (the menu, the board, the round's end, the field
after) in OUT_DIR.

VFLIP_TRACE=1 prints the app's functions as they first run, from the script command on (to find where it stops).

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_voltorb_flip.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
GAME_CORNER = 'MAP_HEADER_HGSS_GOLDENROD_GAME_CORNER'  # HeartGold's T25SP0101
MACHINE, NORTH = (7, 8), 1  # south of the table's sign (7, 7), which runs the Voltorb Flip script; facing north
ITEM_COIN_CASE = 444
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
ITEM_POCKET_SIZE = 165  # include/bag.h: the key items pocket follows the items pocket
COINS_OFFSET = 36  # PlayerSave: Options, SovereignOptions, TrainerInfo (32 bytes), then the coins
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'gCompleteTestVoltorbFlipGame'})
CARD_SIZE, VOLTORB = 12, 4  # struct Card (type, memo, flipped); CARD_TYPE_VOLTORB
MENU_QUIT, TEAL = (195, 128), (120, 192, 176)  # the menu's Quit button on the touch screen, and its colour
MENU_PROBE = (150, 128)  # a point of the Quit button away from its letters
YES_PROBE, RED = (225, 95), (248, 88, 88)  # the question's Yes button on the touch screen, and its colour
CARD_CENTER = lambda row, col: (20 + 32 * col, 20 + 32 * row)  # noqa: E731  a card on the touch screen


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def main():
    from drive import Driver

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    d = Driver(rom, state)
    mem = d.emu.memory

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def u16(addr):
        return struct.unpack('<H', bytes(mem.unsigned[addr:addr + 2]))[0]

    def save_entry(name):
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        return base + 20 + u32(page_info + save_entry_index(name) * 16 + 8)

    def coins():
        return u16(save_entry('SAVE_TABLE_ENTRY_PLAYER') + COINS_OFFSET)

    def give_coin_case():
        key_items = save_entry('SAVE_TABLE_ENTRY_BAG') + ITEM_POCKET_SIZE * 4
        for i in range(100):
            if u16(key_items + i * 4) in (0, ITEM_COIN_CASE):
                mem.write_short(key_items + i * 4, ITEM_COIN_CASE)
                mem.write_short(key_items + i * 4 + 2, 1)
                return

    def idle_frames():
        return u32(sym['gSovereignTestIdleFrames'])

    def settle(limit=3000):
        """Run until the field has been idle a while."""
        frames, idle = 0, 0
        while frames < limit:
            before = idle_frames()
            d.run(20)
            frames += 20
            idle = idle + 1 if idle_frames() - before >= 9 else 0
            if idle >= 6:
                return True
        return False

    def here():
        return names[u32(sym['gSovereignTestIdleMapHeaderID'])]

    def field_running(frames=60):
        before = idle_frames()
        d.run(frames)
        return idle_frames() - before > frames // 3

    shot_no = [0]

    def shot(name):
        shot_no[0] += 1
        d.screenshot().save(os.path.join(out, f'{shot_no[0]:02d}_{name}.png'))

    results = []
    d.load_state(state)
    d.run(30)
    give_coin_case()
    start_warp(d, sym, names.index(GAME_CORNER), *MACHINE, NORTH)
    problem = '' if settle() else 'the Game Corner never settled'
    coins_before = coins()

    trace = []
    if os.environ.get('VFLIP_TRACE'):  # log each of the app's functions as it runs (debugging)
        xmap = open(os.path.join(DECOMP, os.environ.get('TEST_BUILD', 'build_test'), 'main.nef.xMAP'),
                    errors='replace').read()
        for m in re.finditer(r'^\s*([0-9A-F]{8}) ([0-9A-F]{8}) \.text\s+(\w+)\s+\((src_applications_complete_voltorb_'
                             r'flip[\w.]+|src_complete_scrcmd[\w.]+|src_overlay_manager[\w.]+)', xmap, re.M):
            if m.group(3) != '$t' and int(m.group(2), 16) > 0:
                mem.register_exec(int(m.group(1), 16), lambda addr, size, name=m.group(3): trace.append(name) or 0)

    # 1. Open the machine: A through the man's line until the field stops (the fade, then the game)
    if not problem:
        shot('game_corner')
        d.press('A', frames=4, after=0)
        for _ in range(30):  # the game's board is made as it opens
            d.run(40)
            if u32(sym['gCompleteTestVoltorbFlipGame']):
                break
            d.press('A', frames=4, after=0)
        d.run(200)  # the game opening
        shot('menu')
        if trace:
            start = trace.index('CompleteScrCmd_VoltorbFlip') if 'CompleteScrCmd_VoltorbFlip' in trace else 0
            print(' '.join(trace[start:start + 400]))
        if not u32(sym['gCompleteTestVoltorbFlipGame']):
            problem = 'the game never opened'
        elif field_running():
            problem = 'the field is still running'
    results.append(f'opens: {problem or "ok"}')
    print(results[-1], flush=True)

    cursor = [0, 0]  # the board cursor's row and column (each round starts it at the top left)

    def board():
        """The cards: [(type, flipped)] by card number (row * 5 + column), or None outside a game."""
        game = u32(sym['gCompleteTestVoltorbFlipGame'])
        if not game:
            return None
        return [(u32(game + n * CARD_SIZE), u32(game + n * CARD_SIZE + 8)) for n in range(25)]

    def menu_shown():
        return d.screenshot().convert('RGB').getpixel((MENU_PROBE[0], 192 + MENU_PROBE[1])) == TEAL

    def touch(x, y):
        d.emu.input.touch_set_pos(x, y)
        d.run(4)
        d.emu.input.touch_release()
        d.run(30)

    def flip(n, buttons=False):
        """Flip card n: touched, or with the buttons (the cursor walks to it from where it is, then A). Keys pressed
        while a card's coins are counted are dropped, so the buttons are for a first flip."""
        row, col = divmod(n, 5)
        if buttons:
            while cursor[0] != row:
                d.press('DOWN' if row > cursor[0] else 'UP', frames=4, after=20)
                cursor[0] += 1 if row > cursor[0] else -1
            while cursor[1] != col:
                d.press('RIGHT' if col > cursor[1] else 'LEFT', frames=4, after=20)
                cursor[1] += 1 if col > cursor[1] else -1
            d.press('A', frames=4, after=0)
            d.run(180)  # the card turns, and its coins are counted
            return
        for _ in range(3):  # the touch after a flip closes that flip's message instead
            touch(*CARD_CENTER(row, col))
            d.run(180)
            if board()[n][1]:
                return

    def play():
        """Play, from the menu: the board comes up."""
        d.press('A', frames=4, after=200)
        cursor[:] = [0, 0]

    def back_to_menu(limit=40):
        """A through the round's end (its messages, the payout, the board shown) until the menu is back."""
        for _ in range(limit):
            if menu_shown():
                return True
            d.press('A', frames=4, after=60)
        return menu_shown()

    # 2. Win a round
    if not problem:
        d.run(60)
        if not menu_shown():
            problem = 'no menu'
    if not problem:
        play()
        shot('board')
        cards = board()
        if cards is None:
            problem = 'no game running'
    if not problem:
        payout, coins_start = 1, coins()
        for n, (kind, flipped) in enumerate(cards):
            if kind in (2, 3) and not flipped:
                flip(n)
                payout *= kind
                if n == next(i for i, c in enumerate(cards) if c[0] in (2, 3)):
                    shot('flipped')
        left = [n for n, (kind, flipped) in enumerate(board() or []) if kind in (2, 3) and not flipped]
        if left:
            problem = f'cards {left} were never flipped'
            shot('stuck')
        elif not back_to_menu():
            problem = 'the menu never came back'
            shot('stuck')
        elif coins() - coins_start != payout:
            problem = f'the coins went from {coins_start} to {coins()}, not up by {payout}'
        shot('won')
    results.append(f'wins: {problem or "ok"} (coins {coins_before} -> {coins()})')
    print(results[-1], flush=True)

    # 3. Quit a round with the buttons
    if not problem:
        play()
        cards = board()
        coins_start = coins()
        safe = next(n for n, (kind, flipped) in enumerate(cards) if kind != VOLTORB)
        flip(safe, buttons=True)
        if not board()[safe][1]:
            problem = f'card {safe} was never flipped'
    if not problem:
        def asked():
            return d.screenshot().convert('RGB').getpixel((YES_PROBE[0], 192 + YES_PROBE[1])) == RED

        # B asks whether to quit, after a line saying what the player would get, which A moves on from (a B just
        # after a flip closes that flip's message instead; A on the flipped card under the cursor does nothing)
        for _ in range(3):
            d.press('B', frames=4, after=90)
            if asked():
                break
            d.press('A', frames=4, after=90)
            if asked():
                break
        else:
            problem = 'the question never came'
        shot('quit_question')
    if not problem:
        d.press('A', frames=4, after=60)  # Yes
        if not back_to_menu():
            problem = 'the menu never came back'
            shot('stuck')
        elif coins() - coins_start != cards[safe][0]:
            problem = f'the coins went from {coins_start} to {coins()}, not up by {cards[safe][0]}'
    results.append(f'quits a round: {problem or "ok"} (coins {coins()})')
    print(results[-1], flush=True)

    # 4. Leave from the menu
    if not problem:
        touch(*MENU_QUIT)
        for _ in range(20):
            if field_running(30):
                break
            d.press('A', frames=4, after=30)
        settle()
        shot('field_after')
        if not field_running():
            problem = 'the field never came back'
        elif here() != GAME_CORNER:
            problem = f'the player is on {here()}'
    results.append(f'leaves: {problem or "ok"}')
    print(results[-1], flush=True)

if __name__ == '__main__':
    main()
