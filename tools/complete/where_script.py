#!/usr/bin/env python3
"""Show where a map's scene stops: the script line running after a while, in the test build (step 3).

Warps into the map as visit_hgss_maps.py does, presses A now and then for FRAMES frames (as its --scene does), then
reads gCompleteTestScriptPos (include/complete_test.h: the last script command run, its offset in its script file,
and what a waiting script waits on) and prints the line of the translated script at that offset, with the lines
before it. The script file is the map's own (map scripts, then init scripts), else the common scripts; each is
assembled with a listing (arm-none-eabi-gcc, as the build does) to find the line.

Usage: SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy python3 tools/complete/where_script.py ROM STATE MAP [FRAMES]
       (MAP as in map_headers.txt, without MAP_HEADER_: HGSS_MOUNT_MOON)
"""
import bisect
import os
import re
import struct
import subprocess
import sys
import tempfile

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'test'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from drive import Driver  # noqa: E402
from import_hgss_maps import DECOMP, ROOT  # noqa: E402
from visit_hgss_maps import header_id, symbol, walkable_tile  # noqa: E402

BUILD = os.path.join(DECOMP, 'build_test')


def text_symbols():
    """[(address, name)] for the code, sorted, to name the function a waiting script waits on."""
    xmap = open(os.path.join(BUILD, 'main.nef.xMAP'), encoding='utf-8', errors='replace').read()
    return sorted((int(a, 16), n) for a, n in re.findall(r'^\s*([0-9A-F]{8}) [0-9A-F]{8} \.text\s+(\w+)', xmap, re.M))


def listing(source):
    """[(offset, listing line)] for a script source, assembled as tools/scripts/make_script_bin.sh does."""
    with tempfile.TemporaryDirectory() as tmp:
        lst = os.path.join(tmp, 'out.lst')
        pre = subprocess.run(['arm-none-eabi-gcc', '-E', '-x', 'assembler-with-cpp', '-I../include', '-I../asm', '-I.',
                              source], cwd=BUILD, capture_output=True, text=True, check=True).stdout
        enum = subprocess.run([os.path.join(BUILD, 'tools/enumproc/enumproc')], input=pre, capture_output=True,
                              text=True, check=True).stdout
        subprocess.run(['arm-none-eabi-gcc', '-x', 'assembler-with-cpp', '-c', f'-Wa,-aln={lst}', '-o',
                        os.path.join(tmp, 'out.o'), '-'], input=enum, cwd=BUILD, capture_output=True, text=True,
                       check=True)
        out, started = [], False
        for line in open(lst, errors='replace'):
            if f'"{source}" 2' in line or f'"{source}"' in line and '# 1 ' in line:
                started = True
            m = re.match(r'\s*\d+ ([0-9a-f]{4}) [0-9A-F]+\s*\t(.*)', line)
            if started and m:
                out.append((int(m.group(1), 16), m.group(2).rstrip()))
        return out


def script_files(map_name):
    """The map's script files (map scripts, init scripts), from include/data/map_headers.h."""
    text = open(os.path.join(DECOMP, 'include/data/map_headers.h')).read()
    m = re.search(rf'\[MAP_HEADER_{map_name}\]\s*=\s*\{{(.*?)\n    \}}', text, re.S)
    return re.findall(r'\.(?:scriptsArchiveID|initScriptsArchiveID)\s*=\s*(\w+)', m.group(1)) if m else []


def main():
    rom, state, map_name = sys.argv[1:4]
    frames_max = int(sys.argv[4]) if len(sys.argv) > 4 else 6000
    os.chdir(ROOT)
    target = symbol('gSovereignTestWarpTarget')
    pos_addr = symbol('gCompleteTestScriptPos')
    d = Driver(rom, state)

    def u32(addr):
        return struct.unpack('<I', bytes(d.emu.memory.unsigned[addr:addr + 4]))[0]

    x, z = walkable_tile(f'MAP_HEADER_{map_name}')
    d.load_state(state)
    d.run(30)
    for offset, value in ((0, header_id(map_name)), (2, x), (4, z), (6, 2)):
        d.emu.memory.write_short(target + offset, value)
    d.press('SELECT+L+R', frames=8, after=0)
    frames = 0
    while frames < frames_max:
        d.run(60)
        frames += 60
        d.press('A', frames=4, after=4)
    out = os.path.join(ROOT, '.cache', f'where-{map_name}.png')
    d.screenshot().save(out)
    scripts, offset, command, waiting = (u32(pos_addr + 4 * i) for i in range(4))
    syms = text_symbols()
    i = bisect.bisect_right([a for a, _ in syms], waiting & ~1) - 1
    print(f'{map_name}: script file at {scripts:#x}, offset {offset:#06x}, command {command}; '
          f'waiting on {syms[i][1] if waiting and i >= 0 else "nothing"}; screenshot {out}')
    candidates = script_files(map_name) + ['scripts_common']
    for name in candidates:
        source = f'../res/field/scripts/{name}.s'
        if not os.path.exists(os.path.join(BUILD, source)):
            continue
        lines = listing(source)
        at = [k for k, (o, _) in enumerate(lines) if o == offset]
        if at:
            print(f'in {name}.s (if this is the file):')
            for o, text in lines[max(0, at[0] - 12):at[0] + 3]:
                print(f'  {o:04x}{" >" if o == offset else "  "} {text}')


if __name__ == '__main__':
    main()
