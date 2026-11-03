#!/usr/bin/env python3
"""Check the calls the player places (HeartGold's phone app's outgoing calls, src/overlay006/complete_phone_calls.c)
in the test build, from the bedroom state: the phone book is given the contacts below, then each is called as the
Pokégear would call them (gCompleteTestPhoneCallee: the field makes the call as the player stands still), and the call
is followed in sCall: its call script or handler, and the messages it shows (bank, message) in order. A goes through
each call and picks a menu's first choice, except where a part says otherwise.

From the bedroom (New Bark Town, the player's room, before Elm's lab):

1. **Mom:** not where she is (she's downstairs), before the player gave the officer their rival's name: call script 25.
2. **Elm:** before his panic call: call script 8.
3. **Oak, Johto:** his handler: his greeting, "how's your Pokédex", the menu (EVALUATE JOHTO POKéDEX, EVALUATE
   NATIONAL POKéDEX, QUIT: the test build's new game has the National Pokédex), A: seen and caught, his rating for no
   Johto Pokémon caught (28) with its fanfare, then 21.
4. **Oak, National:** at the menu, DOWN and A: his rating for up to 100 caught (46), then 21.
5. **Oak, quit:** at the menu, B: QUIT, then 21 and no evaluation.
6. **Bill:** his handler: the boxes' room (5 to 7, or 9 for none), then 8.
7. **Day-Care Man:** no Pokémon left with him: 2, 4, 11.
8. **Day-Care Lady:** none left with her: her greeting (3 or 4), then 10.
9. **Kurt:** no Apricorns with him: 2, then 5.
10. **Lyra:** her greeting by the time of day (4 to 6), then her story about New Bark Town, where the player is (13 +
    its place in HeartGold's list, 58: 71).
11. **Falkner:** before all sixteen badges: 2, then 3.
12. **Out of the area:** in Lugia's cave (Whirl Islands), where HeartGold's map header has no signal, Mom: the call
     starts and ends with no message of hers.

Results: a line per part, 'ok' or what went wrong, and a screenshot of each call's last message in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_phone_outgoing.py \\
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
CONTACTS = {name: int(n) for name, n in re.findall(r'#define PHONE_CONTACT_(\w+)\s+(\d+)', open(
    os.path.join(DECOMP, 'include', 'constants', 'hgss_phone.h')).read())}
NONE = 0xFF
BOOK_SIZE = int(re.search(r'#define NUM_PHONE_CONTACTS\s+(\d+)', open(
    os.path.join(DECOMP, 'include', 'constants', 'hgss_phone.h')).read()).group(1))
SAVE_PAGES, SAVE_SECTOR = 33, 0x1000  # SAVE_PAGE_MAX, SAVE_SECTOR_SIZE
OUTGOING_CALL = 2000 + 0x81E - 0x7D0  # SCRIPT_ID(COMMON_SCRIPTS, COMPLETE_PHONE_OUTGOING_CALL)
CAVE, CAVE_TILE, NORTH = 'MAP_HEADER_HGSS_WHIRL_ISLANDS_B3F_LUGIA_CAVE', (16, 38), 1  # its warp in
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'sCall', 'gCompleteTestPhoneCallee'})
# CompletePhoneCall: template, script, predefined, bank, message, contact, kind, handler, step, gender, timeOfDay
CALL = struct.Struct('<IHHHHBBBBBB')
HANDLERS = ['SIMPLE', 'GENERIC', 'GENERIC2', 'BILL', 'MOTHER', 'OAK', 'DAY_CARE_LADY', 'DAY_CARE_MAN', 'BUENA',
            'BUENA2', 'FRIEND', 'FRIEND2', 'KURT', 'GYM_LEADER_OUTGOING', 'GYM_LEADER_INCOMING', 'BAOBA']


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
    phone_entry = save_entry_index('SAVE_TABLE_ENTRY_COMPLETE_PHONE')

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def phone():
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * SAVE_SECTOR + 4 + 8 + 4
        return base + 20 + u32(page_info + phone_entry * 16 + 8)

    def call():
        """(script, bank, message, contact, handler, step, timeOfDay) of the call under way"""
        _, script, _, bank, message, contact, _, handler, step, _, time = CALL.unpack(
            bytes(mem.unsigned[sym['sCall']:sym['sCall'] + CALL.size]))
        return script, bank, message, contact, handler, step, time

    def register(contacts):
        """The phone book (CompletePhoneSave's first field): these contacts, then none"""
        for i in range(BOOK_SIZE):
            mem.write_byte(phone() + i, contacts[i] if i < len(contacts) else NONE)

    def place(contact, menu_keys=None, limit=3000):
        """Calls the contact and follows the call to its end: (script, handler, messages, menu seen)."""
        scripts = sym['gSovereignTestScripts']
        mem.write_short(scripts, 0)
        mem.write_byte(sym['gCompleteTestPhoneCallee'], contact + 1)
        messages, script, handler, started, menu = [], None, None, False, False
        last[0] = None
        frames = 0
        while frames < limit:
            d.run(4)
            frames += 4
            s, bank, message, c, h, step, _ = call()
            if c == contact:
                started = True
                script, handler = s, h
                if step and (not messages or messages[-1] != (bank, message)):
                    messages.append((bank, message))
                    if menu_keys is not None and message == 15:  # Oak's "how's your Pokédex": the menu follows
                        d.run(300)  # the question prints, then the menu opens
                        d.screenshot().save(os.path.join(out, f'oak_menu_{"_".join(menu_keys).lower()}.png'))
                        for key in menu_keys:
                            d.press(key, frames=4, after=30)
                        menu = True
                        frames += 300
                        continue
            elif started:
                break
            if frames % 24 == 0:
                if started:
                    last[0] = d.screenshot()  # the call's last message, before A closes it
                d.press('A', frames=4, after=0)
        count = struct.unpack('<H', bytes(mem.unsigned[scripts:scripts + 2]))[0]
        first = struct.unpack('<H', bytes(mem.unsigned[scripts + 2:scripts + 4]))[0]
        d.run(60)
        return {'script': script, 'handler': HANDLERS[handler] if handler is not None else None,
                'messages': [m for _, m in messages], 'started': started and count > 0 and first == OUTGOING_CALL,
                'ended': call()[3] == NONE, 'menu': menu}

    last = [None]
    d.load_state(state)
    d.run(30)
    register([CONTACTS[n] for n in ('MOTHER', 'PROF__ELM', 'PROF__OAK', 'BILL', 'DAY_C_MAN', 'DAY_C_LADY', 'KURT',
                                    'LYRA', 'FALKNER')])
    d.run(10)

    results = []

    def check(name, result, want):
        problem = ''
        if not result['started']:
            problem = 'the call never started'
        elif not result['ended']:
            problem = 'the call never ended'
        else:
            problem = want(result) or ''
        (last[0] or d.screenshot()).save(os.path.join(out, f'{name.lower().replace(" ", "_").replace(",", "")}.png'))
        results.append(f'{name}: {problem or "ok"}')
        print(f'{name}: {problem or "ok"}  ({result["handler"]}, script {result["script"]}, '
              f'messages {result["messages"]})', flush=True)

    def script_is(n):
        return lambda r: None if r['handler'] == 'SIMPLE' and r['script'] == n else f'not call script {n}'

    def messages_are(handler, *patterns):
        def want(r):
            if r['handler'] != handler:
                return f'handler {r["handler"]}, not {handler}'
            if len(r['messages']) != len(patterns) or not all(m in p for m, p in zip(r['messages'], patterns)):
                return f'messages {r["messages"]}'
        return want

    check('Mom', place(CONTACTS['MOTHER']), script_is(25))
    check('Elm', place(CONTACTS['PROF__ELM']), script_is(8))
    check('Oak, Johto', place(CONTACTS['PROF__OAK'], menu_keys=['A']),
          messages_are('OAK', (13, 14), (15,), (20,), (28,), (21,)))
    check('Oak, National', place(CONTACTS['PROF__OAK'], menu_keys=['DOWN', 'A']),
          messages_are('OAK', (13, 14), (15,), (20,), (46,), (21,)))
    check('Oak, quit', place(CONTACTS['PROF__OAK'], menu_keys=['B']),
          messages_are('OAK', (13, 14), (15,), (21,)))
    check('Bill', place(CONTACTS['BILL']), messages_are('BILL', range(0, 200), (3, 4), (5, 6, 7, 9), (8,)))
    check('Day-Care Man', place(CONTACTS['DAY_C_MAN']), messages_are('DAY_CARE_MAN', (2,), (4,), (11,)))
    check('Day-Care Lady', place(CONTACTS['DAY_C_LADY']), messages_are('DAY_CARE_LADY', (3, 4), (10,)))
    check('Kurt', place(CONTACTS['KURT']), messages_are('KURT', (2,), (5,)))
    check('Lyra', place(CONTACTS['LYRA']), messages_are('FRIEND', (4, 5, 6), (71,)))
    check('Falkner', place(CONTACTS['FALKNER']), messages_are('GYM_LEADER_OUTGOING', (2,), (3,)))

    start_warp(d, sym, names.index(CAVE), *CAVE_TILE, NORTH)
    d.run(400)
    check('Out of the area', place(CONTACTS['MOTHER']), lambda r: f'messages {r["messages"]}' if r['messages'] else None)

    ok = sum(r.endswith(': ok') for r in results)
    print(f'{ok} of {len(results)} parts ok', flush=True)
    sys.exit(0 if ok == len(results) else 1)


if __name__ == '__main__':
    main()
