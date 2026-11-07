#!/usr/bin/env python3
"""Check that an overlay's code calls only what is loaded while it runs.

An overlay can call the main module, the overlays it is loaded after (its `After` chain in main.lsf.in), and the
overlays loaded after it (which it loads itself). A call into any other overlay (a sibling, say Voltorb Flip's, which
shares its addresses with the overlay making the call) jumps into whatever code is loaded there, and the game hangs or
crashes. The linker can't tell: every overlay's symbols are global.

For each object of the overlays given (all of Complete's HeartGold assembly, asm/complete_hgss/, by default), this
reads the symbols it uses but doesn't define (arm-none-eabi-nm), finds where the link put each (the build's
main.nef.xMAP) and which overlay that object is in (platinum.us/main.lsf.in), and lists each that is out of reach.

    python3 tools/complete/check_overlay_calls.py [BUILD_DIR] [--overlay NAME ...]

BUILD_DIR is relative to decomp/ (default build). Exits 1 if anything is out of reach.
"""

import argparse
import re
import subprocess
import sys
from pathlib import Path

DECOMP = Path(__file__).resolve().parents[2] / 'decomp'


def read_lsf():
    """Each overlay's objects and the overlay it is loaded after."""
    after, objects, current = {}, {}, None
    for line in (DECOMP / 'platinum.us/main.lsf.in').read_text().splitlines():
        m = re.match(r'^(Overlay|Static|Autoload)\s+(\S+)', line)
        if m:
            current = m.group(2) if m.group(1) == 'Overlay' else None
            if current:
                objects[current] = []
            continue
        if current is None:
            continue
        m = re.match(r'^\s*After\s+(\S+)', line)
        if m:
            after[current] = m.group(1)
        m = re.match(r'^\s*Object\s+(\S+)', line)
        if m:
            objects[current].append(m.group(1))
    return after, objects


def object_name(path):
    # meson's object names: the path's slashes as underscores, then .o
    return path.replace('/', '_') + '.o'


def main():
    parser = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    parser.add_argument('build', nargs='?', default='build')
    parser.add_argument('--overlay', action='append', help='an overlay to check (default: those with HeartGold asm)')
    args = parser.parse_args()
    build = DECOMP / args.build

    after, objects = read_lsf()
    overlay_of = {object_name(o): ov for ov, objs in objects.items() for o in objs}

    def chain(ov):
        out = []
        while ov in after:
            out.append(ov)
            ov = after[ov]
        return out

    overlays = args.overlay or [ov for ov, objs in objects.items() if any('asm/complete_hgss/' in o for o in objs)]

    # Where each symbol was put: "ADDR SIZE .text NAME (OBJECT)"
    defined_in = {}
    xmap = (build / 'main.nef.xMAP').read_text(encoding='utf-8', errors='replace')
    for name, obj in re.findall(r'^\s*[0-9A-F]{8} [0-9A-F]{8} \.\w+\s+(\w+)\s*\(([^)]*)\)', xmap, re.M):
        defined_in.setdefault(name, obj)

    problems = 0
    for ov in overlays:
        ancestors = set(chain(ov))
        descendants = {o for o in objects if ov in chain(o)}
        reach = ancestors | descendants
        for path in objects[ov]:
            obj = build / 'main.nef.p' / object_name(path)
            if not obj.exists():
                print(f'{ov}: {path}: no object in {build.name} (build it first)')
                problems += 1
                continue
            nm = subprocess.run(['arm-none-eabi-nm', '-u', str(obj)], capture_output=True, text=True, check=True)
            for name in sorted({line.split()[-1] for line in nm.stdout.splitlines() if line.strip()}):
                where = defined_in.get(name)
                if where is None:
                    continue  # not placed (an absolute symbol, or the linker's own)
                target = overlay_of.get(where)
                if target is None or target in reach:
                    continue
                print(f'{ov}: {path} uses {name}, which is in the overlay {target} ({where}): not loaded with it')
                problems += 1
    print(f'{len(overlays)} overlays checked; {problems} out of reach')
    return 1 if problems else 0


if __name__ == '__main__':
    sys.exit(main())
