#!/usr/bin/env python3
"""Check that Johto and Kanto's new flags and vars survive a save (test build).

Starts a new game on the test build, then through gCompleteTestSaveProbe (src/complete_test.c):
1. sets four of the new flags (the first, 0x0FFF, 0x1000 and the last) and the first and last new vars;
2. saves as the start menu does (FieldSystem_Save);
3. boots again from that battery, CONTINUEs, and reads them back: the four flags are set, a fifth new flag (5000) is
   not, the two vars hold their values, and Sinnoh's last var is still 0.
Step 1 also puts one of every key item and every Ball in the bag, and step 3 looks for each: all must fit (the
Key Items and Poké Balls pockets, include/bag.h) and be there after the reload.

A save that loaded as "no save data" (a layout mismatch) would leave only NEW GAME on the main menu, and CONTINUE would
start a new game instead: the read-back then finds the flags clear.

Usage: python3 tools/complete/test_save.py [ROM]   (defaults to decomp/build_test/pokeplatinum.us.nds)
"""
import glob
import json
import os
import struct
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', 'test'))
sys.path.insert(0, HERE)
os.environ.setdefault('SDL_VIDEODRIVER', 'dummy')
os.environ.setdefault('SDL_AUDIODRIVER', 'dummy')
from drive import Driver  # noqa: E402
from test_follower import Check, settle, symbol  # noqa: E402

NONE, WRITE, SAVE, READ = 0, 1, 2, 3
# CompleteTestSaveProbe: u32 request, done, saveOK; u16 flags[5], vars[3], keyItems, balls
PROBE_FORMAT = '<III5H3H2H'
WANT_FLAGS = (1, 1, 1, 1, 0)
WANT_VARS = (0xC0DE, 0xBEEF, 0)


def pocket_counts():
    """How many items the Key Items and Poké Balls pockets hold, one of each (res/items/data)."""
    pockets = [json.load(open(p, encoding='utf-8')).get('fieldPocket')
               for p in glob.glob(os.path.join(HERE, '..', '..', 'decomp', 'res', 'items', 'data', '*.json'))]
    return pockets.count('POCKET_KEY_ITEMS'), pockets.count('POCKET_BALLS')


def probe(d, addr):
    size = struct.calcsize(PROBE_FORMAT)
    return struct.unpack(PROBE_FORMAT, bytes(d.emu.memory.unsigned[addr:addr + size]))


def ask(d, addr, idle_addr, request, frames=600):
    """Write request, then run until the game reports it done. Returns the probe."""
    settle(d, idle_addr)
    d.emu.memory.write_long(addr, request)
    for _ in range(frames // 30):
        d.run(30)
        values = probe(d, addr)
        if values[1] == request and values[0] == NONE:
            return values
    return None


def main():
    rom = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, '..', '..', 'decomp/build_test/pokeplatinum.us.nds')
    addr = symbol(rom, 'gCompleteTestSaveProbe')
    idle_addr = symbol(rom, 'gSovereignTestIdleFrames')
    check = Check()

    d = Driver(rom)
    for action in ['wait:600', 'A', 'wait:200', 'A', 'wait:200', 'A', 'wait:400'] + ['A', 'wait:60'] * 12 + ['wait:120']:
        d.do(action)
    want_bag = pocket_counts()
    written = ask(d, addr, idle_addr, WRITE)
    check(written is not None, 'the probe flags and vars are set')
    if written:
        check(tuple(written[11:13]) == want_bag, f'key items and Balls put in the bag: {written[11:13]} (want {want_bag})')
    saved = ask(d, addr, idle_addr, SAVE, frames=3600)
    check(saved is not None and saved[2] == 1, f'the game saved (FieldSystem_Save: {saved and saved[2]})')
    d.run(600)
    battery = os.path.join(tempfile.mkdtemp(), 'complete_save_test.sav')
    d.do('export:' + battery)

    # Boot again from that battery in the same emulator (a second emulator in one process crashes py-desmume), then
    # title and CONTINUE (the first entry once a save exists).
    d.emu.backup.import_file(battery)
    d.emu.reset()
    for action in ['wait:600', 'A', 'wait:200', 'A', 'wait:200', 'A', 'wait:600']:
        d.do(action)
    values = ask(d, addr, idle_addr, READ)
    check(values is not None, 'the probe was read back after CONTINUE')
    if values:
        flags, vars_ = values[3:8], values[8:11]
        check(tuple(flags) == WANT_FLAGS, f'flags after the reload: {flags} (want {WANT_FLAGS})')
        check(tuple(vars_) == WANT_VARS, 'vars after the reload: ' + ', '.join(f'0x{v:04X}' for v in vars_)
              + ' (want ' + ', '.join(f'0x{v:04X}' for v in WANT_VARS) + ')')
        check(tuple(values[11:13]) == want_bag, f'key items and Balls in the bag after the reload: {values[11:13]} '
              f'(want {want_bag})')

    print('PASS' if check.failures == 0 else f'FAIL ({check.failures})')
    sys.exit(check.failures != 0)


if __name__ == '__main__':
    main()
