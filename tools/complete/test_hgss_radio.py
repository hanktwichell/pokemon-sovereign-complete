#!/usr/bin/env python3
"""Check the Pokégear's Radio page (src/applications/complete_pokegear/radio/, include/complete_radio.h) in the test
build, from the bedroom state, by touches as a player would:

1. **The page:** with the Pokégear (as test_hgss_pokegear.py's first part gets it), a tap on the app bar's Radio shows
   the globe in New Bark Town (Johto's stations), the cursor where HeartGold's new save has it (128, 128): the fourth
   station's outer ring, so a show of its (the Search Party, the drama or Buena's, by the hour) with static.
2. **Pokémon Music:** the first button puts the cursor on the first station's middle: DJ Ben's show, a clear signal,
   and the day's music playing.
3. **Pokémon Talk:** the second button: Oak's show, which runs 1,500 frames through its places (or into the
   commercials after it) with the field still running.
4. **The third station:** the third button: Trainer Profiles or That Town, These People, by the hour.
5. **Off the stations:** dragging the cursor from the third station to (128, 140), between them: no show, and the
   radio's music off.
6. **Leaving the page:** back on the first station, the Map's button turns the radio off; the Radio's button again
   picks the show up where the cursor is.
7. **The Poké Flute:** in Kanto with the power back and the Expansion Card (flags set), on Route 11 by Snorlax: the
   globe has Kanto's stations and the flute's at its top; dragging the cursor there plays the flute.
8. **Snorlax:** talking to it then wakes it: A through its message, its battle starts (the bottom screen ends for
   it).
9. **The Ruins of Alph:** in the hall's entrance, the Unown's broadcast is all there is, in the globe's middle.
10. **Mahogany Town:** before the Rocket Hideout is cleared, the strange signal is all there is.
11. **Sinnoh:** no signal (Twinleaf Town).

Results: a line per part, 'ok' or what went wrong, and screenshots (both screens) in OUT_DIR.

From the repo root, with a test build and a bedroom state from it (tools/test/new_game.sh); TEST_BUILD picks another
test build's folder (decomp/build_test by default):
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/test_hgss_radio.py \\
        decomp/build_test/pokeplatinum.us.nds STATE OUT_DIR
"""
import os
import re
import struct
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import battle_mechanics as bm  # noqa: E402
from talk_to_objects import SYMBOLS as TALK_SYMBOLS, header_names, start_warp, var_ids  # noqa: E402

DECOMP = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'decomp')
CONTACTS = {name: int(n) for name, n in re.findall(r'#define PHONE_CONTACT_(\w+)\s+(\d+)', open(
    os.path.join(DECOMP, 'include', 'constants', 'hgss_phone.h')).read())}
BOOK = ['MOTHER', 'PROF__ELM', 'PROF__OAK']
BOOK_SIZE, NONE = 75, 0xFF
SAVE_PAGES = 33
POKEGEAR = 2  # enum CompleteBottomScreen
NORTH, EAST = 1, 4  # the test warp's facing: enum FaceDirection + 1
RADIO_BUTTON, MAP_BUTTON = (80, 176), (128, 176)  # the app bar's
PRESETS = [(32, 62), (224, 62), (32, 126), (224, 126)]  # the four buttons beside the globe
OFF_STATIONS = (128, 140)
FLUTE = (128, 48)
ALPH_MIDDLE = (128, 92)
# enum RadioStationSelection, enum RadioShowID, enum CompleteRadioMusic
JOHTO, KANTO, KANTO_EXPN, NO_SIGNAL, ALPH, ROCKET, MAHOGANY = range(7)
(MUSIC, TALK, SEARCH_PARTY, DRAMA, BUENA, PROFILES, THAT_TOWN, POKE_FLUTE, UNOWN, TEAM_ROCKET, SIGNAL,
 COMMERCIALS) = range(12)
NO_SHOW = 0xFF
M_NONE, M_MARCH, M_LULLABY, M_HOENN, M_SINNOH, M_FLUTE, M_UNOWN = range(7)
SNORLAX_STAND = ('MAP_HEADER_HGSS_ROUTE_11', (1356, 304), EAST)  # west of its four tiles (1357-1358, 303-304)
SYMBOLS = tuple(set(TALK_SYMBOLS) | {'sSaveDataPtr', 'gCompleteTestPokegear', 'sActiveBottomScreen',
                                     'gCompleteTestPokegearMap', 'gCompleteTestRadio'})


def save_entry_index(name):
    text = open(os.path.join(DECOMP, 'include', 'constants', 'savedata', 'save_table.h')).read()
    body = text[text.index('enum SaveTableEntryID'):]
    return re.findall(r'^\s+(SAVE_TABLE_ENTRY_\w+)', body, re.M).index(name)


def main():
    from drive import Driver
    from test_map_warp import walkable_tile

    rom, state, out = sys.argv[1:4]
    os.makedirs(out, exist_ok=True)
    sym = bm.symbols(SYMBOLS)
    names = header_names()
    variables = var_ids()
    d = Driver(rom, state)
    mem = d.emu.memory

    def u32(addr):
        return struct.unpack('<I', bytes(mem.unsigned[addr:addr + 4]))[0]

    def save_part(name):
        base = u32(sym['sSaveDataPtr'])
        page_info = base + 20 + SAVE_PAGES * 0x1000 + 4 + 8 + 4
        return base + 20 + u32(page_info + save_entry_index(name) * 16 + 8)

    def set_flag(name, on=True):
        addr = save_part('SAVE_TABLE_ENTRY_VARS_FLAGS') + (variables['VARS_END'] - variables['VARS_START']) * 2
        n = variables[name]
        byte = mem.unsigned[addr + n // 8]
        mem.write_byte(addr + n // 8, byte | 1 << n % 8 if on else byte & ~(1 << n % 8))

    def gear():
        return u32(sym['gCompleteTestPokegear']) != 0

    def page():
        return struct.unpack('<H', bytes(mem.unsigned[sym['gCompleteTestPokegearMap']:sym['gCompleteTestPokegearMap'] + 2]))[0]

    def radio():
        """{selection, show, station, signal, x, y, music}"""
        sel, show, tuned, cursor, music = struct.unpack('<5H', bytes(mem.unsigned[sym['gCompleteTestRadio']:sym['gCompleteTestRadio'] + 10]))
        return {'selection': sel, 'show': show, 'station': tuned >> 8, 'signal': tuned & 0xFF, 'x': cursor & 0xFF,
                'y': cursor >> 8, 'music': music}

    def shot(name):
        d.screenshot().save(os.path.join(out, name + '.png'))

    def until(test, frames=600):
        for _ in range(frames // 10):
            if test():
                return True
            d.run(10)
        return test()

    def drag(start, end, steps=12):
        """Picks the cursor up where it is and drags it to end, as a stylus would"""
        x0, y0 = start
        x1, y1 = end
        for i in range(steps + 1):
            d.emu.input.touch_set_pos(round(x0 + (x1 - x0) * i / steps), round(y0 + (y1 - y0) * i / steps))
            d.run(3)
        d.run(6)
        d.emu.input.touch_release()
        d.run(30)

    def go(header, tile, face):
        """A warp there; the Pokégear comes back on the Radio, and the radio retunes for the place"""
        start_warp(d, sym, names.index(header), *tile, face)
        d.run(400)
        until(lambda: gear() and page() == 2, 600)
        d.run(120)

    results = []

    def report(name, problem):
        results.append(f'{name}: {problem or "ok"}')
        print(f'{results[-1]}  ({radio()})', flush=True)

    # 1. The Pokégear, then its Radio
    d.load_state(state)
    d.run(30)
    phone = save_part('SAVE_TABLE_ENTRY_COMPLETE_PHONE')
    for i in range(BOOK_SIZE):
        mem.write_byte(phone + i, CONTACTS[BOOK[i]] if i < len(BOOK) else NONE)
    set_flag('FLAG_HGSS_GOT_POKEGEAR')
    problem = '' if until(lambda: gear() and mem.unsigned[sym['sActiveBottomScreen']] == POKEGEAR) else 'no Pokégear'
    d.run(60)
    if not problem:
        d.touch(*RADIO_BUTTON, frames=6, after=90)
        r = radio()
        if page() != 2:
            problem = f'the page is {page()}'
        elif r['selection'] != JOHTO:
            problem = f'the stations are {r["selection"]}'
        elif (r['x'], r['y']) != (128, 128) or r['station'] != 3 or r['signal'] != 1:
            problem = 'not on the fourth station\'s outer ring'
        elif r['show'] not in (SEARCH_PARTY, DRAMA, BUENA):
            problem = f'the show is {r["show"]}'
    d.run(200)
    shot('radio_page')
    report('the page', problem)

    def preset(n, name, shows, frames=300, music=None):
        if results and not results[-1].endswith('ok'):
            return
        d.touch(*PRESETS[n], frames=6, after=60)
        r = radio()
        problem = ''
        if r['station'] != n or r['signal'] != 2:
            problem = f'tuned to {r["station"]} (signal {r["signal"]})'
        elif r['show'] not in shows:
            problem = f'the show is {r["show"]}'
        elif music is not None and r['music'] not in music:
            problem = f'the music is {r["music"]}'
        idle = u32(sym['gSovereignTestIdleFrames'])
        d.run(frames)
        shot(name.lower().replace(' ', '_').replace('é', 'e'))
        if not problem and u32(sym['gSovereignTestIdleFrames']) - idle < frames // 3:
            problem = 'the field stopped'
        if not problem and radio()['show'] not in shows + (COMMERCIALS,):
            problem = f'the show became {radio()["show"]}'
        report(name, problem)

    # 2-4. The buttons
    preset(0, 'Pokémon Music', (MUSIC,), music=(M_MARCH, M_LULLABY, M_HOENN, M_SINNOH, M_NONE))
    preset(1, 'Pokémon Talk', (TALK,), frames=1500)
    preset(2, 'The third station', (PROFILES, THAT_TOWN))

    # 5. Off the stations
    if results[-1].endswith('ok'):
        drag((96, 108), OFF_STATIONS)
        r = radio()
        problem = '' if r['show'] == NO_SHOW and r['station'] == NO_SHOW and r['music'] == M_NONE else 'still on'
        if not problem and (abs(r['x'] - OFF_STATIONS[0]) > 2 or abs(r['y'] - OFF_STATIONS[1]) > 2):
            problem = f'the cursor is at {r["x"]}, {r["y"]}'  # the emulator's touches land a pixel off
        shot('off_stations')
        report('off the stations', problem)

    # 6. Leaving the page turns it off; coming back turns it on
    if results[-1].endswith('ok'):
        d.touch(*PRESETS[0], frames=6, after=120)
        on = radio()['show'] == MUSIC
        d.touch(*MAP_BUTTON, frames=6, after=60)
        r = radio()
        problem = '' if on else 'the first station never came on'
        if not problem and (page() != 1 or r['show'] != NO_SHOW or r['music'] != M_NONE):
            problem = f'page {page()}, still on'
        d.touch(*RADIO_BUTTON, frames=6, after=90)
        if not problem and radio()['show'] != MUSIC:
            problem = f'back on the Radio, the show is {radio()["show"]}'
        report('leaving the page', problem)

    # 7. The Poké Flute by Snorlax
    set_flag('FLAG_HGSS_RESTORED_POWER')
    set_flag('FLAG_HGSS_GOT_EXPN_CARD')
    header, tile, face = SNORLAX_STAND
    go(header, tile, face)
    r = radio()
    problem = '' if r['selection'] == KANTO_EXPN else f'the stations are {r["selection"]}'
    if not problem:
        drag((r['x'], r['y']), FLUTE)
        r = radio()
        if r['show'] != POKE_FLUTE or r['music'] != M_FLUTE:
            problem = f'the show is {r["show"]}, the music {r["music"]}'
    shot('poke_flute')
    report('the Poké Flute', problem)

    # 8. Snorlax wakes
    if not problem:
        d.press('A', frames=4, after=30)
        d.run(200)
        shot('snorlax')  # its cry and "...!"
        woke = False
        for _ in range(30):  # A through its message, then the battle comes
            if not gear():
                woke = True
                break
            d.press('A', frames=4, after=30)
        report('Snorlax', '' if woke else 'no battle')

    # 9-11. The Ruins, Mahogany, Sinnoh
    for name, header, selection, cursor, show in [
            ('the Ruins of Alph', 'MAP_HEADER_HGSS_RUINS_OF_ALPH_HALL_ENTRANCE', ALPH, ALPH_MIDDLE, UNOWN),
            ('Mahogany Town', 'MAP_HEADER_HGSS_MAHOGANY', MAHOGANY, ALPH_MIDDLE, SIGNAL),
            ('Sinnoh', 'MAP_HEADER_TWINLEAF_TOWN', NO_SIGNAL, None, NO_SHOW)]:
        d.load_state(state)
        d.run(30)
        for i in range(BOOK_SIZE):
            mem.write_byte(save_part('SAVE_TABLE_ENTRY_COMPLETE_PHONE') + i, CONTACTS[BOOK[i]] if i < len(BOOK) else NONE)
        set_flag('FLAG_HGSS_GOT_POKEGEAR')
        until(lambda: gear(), 600)
        d.run(60)
        d.touch(*RADIO_BUTTON, frames=6, after=90)
        go(header, walkable_tile(header), NORTH)
        r = radio()
        problem = '' if r['selection'] == selection else f'the stations are {r["selection"]}'
        if not problem and cursor is not None:
            drag((r['x'], r['y']), cursor)
            r = radio()
            if r['show'] != show:
                problem = f'the show is {r["show"]}'
            elif show == UNOWN and r['music'] != M_UNOWN:
                problem = f'the music is {r["music"]}'
        elif not problem and r['show'] != show:
            problem = f'the show is {r["show"]}'
        d.run(120)
        shot(name.lower().replace(' ', '_'))
        report(name, problem)


if __name__ == '__main__':
    main()
