#!/usr/bin/env python3
"""Bring HeartGold's undecompiled assembly into Complete's build as it is (the Pokéathlon's port, docs/Roadmap.md).

pret's HeartGold assembles its asm/*.s with the same assembler (mwasmarm, -gccinc) Complete's build uses, so a file
assembles unchanged once its includes are there. Each NAME (a file stem of .cache/pokeheartgold/asm: overlay_97,
unk_020932E0...) is copied to decomp/asm/complete_hgss/NAME.s with its asm/include/NAME.inc beside it, and only these
changes, each listed in the file's header:

- HeartGold's `#include "constants/..."` lines are dropped: hgss_compat.inc defines the constants the files name,
  with Platinum's values.
- An overlay's ID (SDK_OVERLAY_<name>_ID): Complete's overlay's where OVERLAYS names one, else HeartGold's number
  (the disassembly took some numbers for overlays' IDs).
- gSystem: HeartGold's System has a word Platinum's lacks (simulatedInputs, at 0x5C), so its later fields (the touch
  screen, the screens' order) sit 4 bytes further on. A `.word gSystem + N` with N >= 0x5C becomes N - 4; a field
  read through a register loaded with gSystem + N (N below 0x5C) has its offset moved instead, while the register
  still holds it (to the next label, call, jump or write). simulatedInputs itself stops the import (Complete's is
  gCompleteSimulatedKeys).

The engine functions the files call keep HeartGold's names: decomp/asm/complete_hgss/macros.inc includes
hgss_compat.inc, whose #defines give each one Platinum's name or a shim's (src/applications/complete_pokeathlon/
hgss_compat.c). The import stops if a file calls something hgss_compat.inc doesn't name, so nothing links to a
Platinum function that merely shares HeartGold's name (Sprite_SetPriority means different things in the two).
tools/complete/hgss_asm_symbols.py sorts what's missing (the same code in Platinum, similar, HeartGold only).

The object goes in an overlay through decomp/platinum.us/main.lsf.in (Object asm/complete_hgss/NAME.s).

Usage: python3 tools/complete/import_hgss_asm.py NAME [NAME ...]
"""
import os
import re
import subprocess
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from hgss_asm_symbols import ROOT, cache_root, externals  # noqa: E402

HG = os.path.join(cache_root(), '.cache/pokeheartgold')
OUT = os.path.join(ROOT, 'decomp/asm/complete_hgss')
COMPAT = os.path.join(OUT, 'hgss_compat.inc')
SIMULATED_INPUTS = 0x5C  # HeartGold's System field that Platinum's lacks
# HeartGold's overlays the files really load (FS_OVERLAY_ID), and Complete's overlay for each. Any other
# SDK_OVERLAY_*_ID in a file is a number the disassembly mistook for an overlay's ID (unk_020957B0's 1 is "field"'s):
# it becomes the number again.
OVERLAYS = {'OVY_97': 'complete_pokeathlon_select', 'OVY_98': 'complete_pokeathlon_parts'}
# the macros.inc and global.inc of this folder, and the files' own .inc, are Complete's or copied
OWN_INCLUDES = {'macros.inc', 'global.inc'}

# HeartGold's functions whose body is replaced by a jump to a C function of the same arguments (a shim in
# src/applications/complete_pokeathlon/), where Complete's data differs from HeartGold's: the course's own copy of
# HeartGold's table of each species' first Pokéathlon performance member (494 species) becomes Complete's
REDIRECTS = {
    'overlay_96': {
        'ov96_021E679C': 'HgssCompat_PokeathlonPerformanceMember',
    },
}

# Lines changed inside a function (its name, the text as it is, what it becomes, how many times), where Complete's
# layout differs from HeartGold's: a species in the Pokéathlon's records has 11 bits in Complete's save, not
# HeartGold's 9 (a course record's Pokémon: species, form, gender, shiny) or 10 (an event record's: the form above
# it; include/complete_pokeathlon.h); and the checks that stop at HeartGold's 493 species where Complete has more
SPECIES_BITS = 'Complete\'s records keep a species in 11 bits'
PATCHES = {
    'overlay_96': [
        # ov96_021E786C writes the course record's three Pokémon (CompletePokeathlonRecordMon: species 0-10, form 11-15,
        # gender 16-17, shiny 18; HeartGold's species 0-8, form 9-13, gender 14-15, shiny 16)
        ('ov96_021E786C', '_021E7924: .word 0xFFFEFFFF', '_021E7924: .word 0xFFFBFFFF', 1, SPECIES_BITS + ' (shiny: bit 18)'),
        ('ov96_021E786C', '_021E7928: .word 0xFFFFFE00', '_021E7928: .word 0xFFFFF800', 1, SPECIES_BITS),
        ('ov96_021E786C', '_021E792C: .word 0x000001FF', '_021E792C: .word 0x000007FF', 1, SPECIES_BITS),
        ('ov96_021E786C', '_021E7930: .word 0xFFFFC1FF', '_021E7930: .word 0xFFFF07FF', 1, SPECIES_BITS + ' (form: bits 11-15)'),
        ('ov96_021E786C', '_021E7934: .word 0xFFFF3FFF', '_021E7934: .word 0xFFFCFFFF', 1, SPECIES_BITS + ' (gender: bits 16-17)'),
        ('ov96_021E786C', '\tlsl r6, r6, #0x1b\n\tlsr r6, r6, #0x12', '\tlsl r6, r6, #0x1b\n\tlsr r6, r6, #0x10', 1,
         SPECIES_BITS + ' (the form from bit 11)'),
        ('ov96_021E786C', '\tlsl r6, r6, #0x1e\n\tlsr r6, r6, #0x10', '\tlsl r6, r6, #0x1e\n\tlsr r6, r6, #0xe', 1,
         SPECIES_BITS + ' (the gender from bit 16)'),
        ('ov96_021E786C', '\tlsl r6, r6, #0x1f\n\tlsr r6, r6, #0xf', '\tlsl r6, r6, #0x1f\n\tlsr r6, r6, #0xd', 1,
         SPECIES_BITS + ' (shiny at bit 18)'),
        # ov96_021E7938 and ov96_021E7A2C write an event record's Pokémon: species + (form << 10) in HeartGold,
        # species + (form << 11) here (CompletePokeathlonEventMon)
        ('ov96_021E7938', '\tlsl r4, r4, #0xa', '\tlsl r4, r4, #0xb', 1, SPECIES_BITS + ' (the form from bit 11)'),
        ('ov96_021E7A2C', '\tlsl r3, r3, #0xa', '\tlsl r3, r3, #0xb', 1, SPECIES_BITS + ' (the form from bit 11)'),
    ],
    'overlay_98': [
        # ov98_0221E7E8 draws a course record's Pokémon (HeartGold's overlay 99 calls it; Complete's record screens are
        # its own C): Complete's layout, as above
        ('ov98_0221E7E8', '\tlsl r1, r2, #0x17\n\tadd r6, r3, #0\n\tlsr r1, r1, #0x17',
         '\tlsl r1, r2, #0x15\n\tadd r6, r3, #0\n\tlsr r1, r1, #0x15', 1, SPECIES_BITS),
        ('ov98_0221E7E8', '\tlsl r0, r2, #0xf\n\tlsr r0, r0, #0x1f', '\tlsl r0, r2, #0xd\n\tlsr r0, r0, #0x1f', 1,
         SPECIES_BITS + ' (shiny: bit 18)'),
        ('ov98_0221E7E8', '\tlsl r0, r0, #0x12\n\tlsr r0, r0, #0x1b', '\tlsl r0, r0, #0x10\n\tlsr r0, r0, #0x1b', 1,
         SPECIES_BITS + ' (form: bits 11-15)'),
        ('ov98_0221E7E8', '\tlsl r2, r2, #0x10\n\tlsr r2, r2, #0x1e', '\tlsl r2, r2, #0xe\n\tlsr r2, r2, #0x1e', 1,
         SPECIES_BITS + ' (gender: bits 16-17)'),
        ('ov98_0221E7E8', '\tlsl r0, r0, #0x17\n\tlsr r0, r0, #0x17', '\tlsl r0, r0, #0x15\n\tlsr r0, r0, #0x15', 1,
         SPECIES_BITS),
        # a species' name (from Complete's species names, all of them) and the count of species with all five medals
        ('ov98_0221EE28', '_0221EE7C: .word 0x000001ED', '_0221EE7C: .word COMPLETE_NATIONAL_DEX_COUNT', 1,
         'Complete has more species than HeartGold\'s 493'),
        ('ov98_0221F024', '_0221F054: .word 0x000001ED', '_0221F054: .word COMPLETE_NATIONAL_DEX_COUNT', 1,
         'Complete has more species than HeartGold\'s 493'),
    ],
}


def compat_names():
    """The names hgss_compat.inc defines; stops on a chain (a name on the right that's also one on the left, and not
    itself: the preprocessor would follow it to a third name)."""
    mapping = {}
    for line in open(COMPAT, encoding='utf-8'):
        m = re.match(r'\s*#define\s+(\w+)\s+(\S+)', line)
        if m:
            mapping[m.group(1)] = m.group(2)
    chains = [f'{k} -> {v} -> {mapping[v]}' for k, v in mapping.items() if v in mapping and v != k]
    if chains:
        sys.exit('hgss_compat.inc maps to a name it maps again: ' + ', '.join(chains))
    return set(mapping)


def hg_overlay_ids():
    """{HeartGold's overlay name: its ID} from its build's symbols (SDK_OVERLAY_<name>_ID)."""
    out = subprocess.run(['arm-none-eabi-nm', os.path.join(HG, 'build/heartgold.us/main.nef')],
                         capture_output=True, text=True, check=True).stdout
    return {m.group(2): int(m.group(1), 16) for m in re.finditer(r'^([0-9a-f]+) \w SDK_OVERLAY_(\w+)_ID$', out, re.M)}


def functions(text):
    """{name: (start, end)} of each function's text (thumb_func_start NAME to its thumb_func_end NAME)."""
    found = {}
    for m in re.finditer(r'^\t(?:non_word_aligned_)?thumb_func_start (\w+)\n(.*?)^\tthumb_func_end \1\n', text, re.M | re.S):
        found[m.group(1)] = (m.start(2), m.end(2))
    return found


def patch(name, src):
    """REDIRECTS and PATCHES on HeartGold's text, and the notes saying what they changed."""
    notes = []
    for func, (old, new, count, why) in [(p[0], p[1:]) for p in PATCHES.get(name, [])]:
        start, end = functions(src)[func]
        body = src[start:end]
        if body.count(old) != count:
            sys.exit(f'{name}.s {func}: {old!r} found {body.count(old)} times, not {count}')
        src = src[:start] + body.replace(old, new) + src[end:]
        notes.append(f'{func}: {old.strip()!r} -> {new.strip()!r} ({why})')
    for func, target in REDIRECTS.get(name, {}).items():
        start, end = functions(src)[func]
        body = (f'{func}: ; Sovereign Complete: HeartGold\'s body replaced by a jump to {target}\n'
                f'\tldr r3, _{func}_target\n\tbx r3\n\t.balign 4, 0\n_{func}_target: .word {target}\n')
        src = src[:start] + body + src[end:]
        notes.append(f'{func}: a jump to {target} (Complete\'s data for it)')
    return src, notes


def convert(name, overlay_ids):
    src = open(os.path.join(HG, f'asm/{name}.s'), encoding='utf-8').read()
    src, notes = patch(name, src)
    lines = []
    pointer_regs = {}  # register: lines left in which it may still hold =gSystem
    for lineno, line in enumerate(src.split('\n'), 1):
        if re.match(r'#include\s+"constants/', line):
            notes.append(f'line {lineno}: dropped {line.strip()}')
            continue

        def overlay(m):
            if m.group(1) in OVERLAYS:
                notes.append(f'line {lineno}: HeartGold\'s overlay {m.group(1)} is {OVERLAYS[m.group(1)]}')
                return f'SDK_OVERLAY_{OVERLAYS[m.group(1)]}_ID'
            notes.append(f'line {lineno}: SDK_OVERLAY_{m.group(1)}_ID -> {overlay_ids[m.group(1)]} (a number the '
                         'disassembly took for that overlay\'s ID)')
            return str(overlay_ids[m.group(1)])
        line = re.sub(r'\bSDK_OVERLAY_(\w+)_ID\b', overlay, line)

        def move(m):
            offset = int(m.group(2), 0)
            if offset < SIMULATED_INPUTS:
                return m.group(0)
            if offset < SIMULATED_INPUTS + 4:
                sys.exit(f'{name}.s:{lineno}: HeartGold\'s gSystem.simulatedInputs, which Platinum lacks '
                         '(Complete\'s is gCompleteSimulatedKeys): port it by hand')
            notes.append(f'line {lineno}: gSystem + {m.group(2)} -> gSystem + {offset - 4:#x}')
            return f'{m.group(1)}{offset - 4:#x}'
        line = re.sub(r'(gSystem \+ )(0x[0-9A-Fa-f]+|\d+)', move, line)

        # a field read through a register holding gSystem + N (N below the moved fields): its offset moves instead
        m = re.match(r'\s*ldr (r\d), _\w+ ; =gSystem(?: \+ (0x[0-9A-Fa-f]+|\d+))?\s*$', line)
        if m:
            base = int(m.group(2), 0) if m.group(2) else 0
            if base < SIMULATED_INPUTS:
                pointer_regs[m.group(1)] = base
            else:
                pointer_regs.pop(m.group(1), None)
        elif pointer_regs:
            def field(f):
                reg, offset = f.group(2), int(f.group(3), 0)
                if reg not in pointer_regs or pointer_regs[reg] + offset < SIMULATED_INPUTS:
                    return f.group(0)
                if pointer_regs[reg] + offset < SIMULATED_INPUTS + 4:
                    sys.exit(f'{name}.s:{lineno}: HeartGold\'s gSystem.simulatedInputs through {reg}: port it by hand')
                notes.append(f'line {lineno}: gSystem + {pointer_regs[reg]:#x} + {f.group(3)} -> + {offset - 4:#x}')
                return f'{f.group(1)}{offset - 4:#x}]'
            line = re.sub(r'(\b(?:ldr|str)(?:s?[bh])?\s+\w+, \[(r\d), #)(0x[0-9A-Fa-f]+|\d+)\]', field, line)
            # where the register stops holding it: a label (a jump can land there with anything in it), a call (r0-r3),
            # a jump or return, an instruction that writes it
            if re.match(r'^\w+:', line) or re.match(r'\s*(?:b|bx|pop)\b', line):
                pointer_regs.clear()
            elif re.match(r'\s*blx?\b', line):
                for reg in ('r0', 'r1', 'r2', 'r3'):
                    pointer_regs.pop(reg, None)
            else:
                w = re.match(r'\s*(\w+)\s+(r\d+)\s*,', line)
                if w and not re.match(r'(str|cmp|cmn|tst|stm)', w.group(1)):
                    pointer_regs.pop(w.group(2), None)
                if re.match(r'\s*ldm', line):
                    pointer_regs.clear()
        lines.append(line)
    header = [f'; Sovereign Complete: HeartGold\'s asm/{name}.s (pret\'s pokeheartgold), assembled as it is through',
              '; tools/complete/import_hgss_asm.py, which changed only these (line numbers: HeartGold\'s file\'s, after the',
              '; patches and redirects, which come first):'] + \
             [f';   {n}' for n in notes or ['(none)']]
    return '\n'.join(header + lines)


def check_dex_count():
    """hgss_compat.inc's COMPLETE_NATIONAL_DEX_COUNT (the patches' species count) is Complete's NATIONAL_DEX_COUNT."""
    species = [line.strip() for line in open(os.path.join(ROOT, 'decomp/generated/species.txt')) if line.strip()]
    dex = species.index('SPECIES_BAD_EGG') - 2
    m = re.search(r'#define\s+COMPLETE_NATIONAL_DEX_COUNT\s+(\d+)', open(COMPAT, encoding='utf-8').read())
    if not m or int(m.group(1)) != dex:
        sys.exit(f'hgss_compat.inc: COMPLETE_NATIONAL_DEX_COUNT should be {dex} (decomp/generated/species.txt)')


def main():
    names = sys.argv[1:]
    if not names:
        sys.exit(__doc__)
    check_dex_count()
    paths, overlay_ids = [], hg_overlay_ids()
    for name in names:
        out = os.path.join(OUT, f'{name}.s')
        open(out, 'w', encoding='utf-8').write(convert(name, overlay_ids))
        inc = open(os.path.join(HG, f'asm/include/{name}.inc'), encoding='utf-8').read()
        # the overlays' IDs as the file now names them, and the shims a redirect jumps to, declared
        inc = re.sub(r'\bSDK_OVERLAY_(\w+)_ID\b', lambda m: f'SDK_OVERLAY_{OVERLAYS[m.group(1)]}_ID'
                     if m.group(1) in OVERLAYS else m.group(0), inc)
        inc += ''.join(f'.public {target}\n' for target in REDIRECTS.get(name, {}).values())
        converted = open(out, encoding='utf-8').read()
        inc += ''.join(f'.public SDK_OVERLAY_{o}_ID\n' for o in sorted(set(OVERLAYS.values()))
                       if f'SDK_OVERLAY_{o}_ID' in converted)
        open(os.path.join(OUT, f'{name}.inc'), 'w', encoding='utf-8').write(inc)
        for included in re.findall(r'\.include "([^"]+)"', open(out, encoding='utf-8').read()):
            if included not in OWN_INCLUDES and included != f'{name}.inc':
                sys.exit(f'{name}.s includes {included}, which this folder lacks')
        paths.append(out)
    # every file in the folder, so a symbol one file defines for another counts
    everything = [os.path.join(OUT, f) for f in sorted(os.listdir(OUT)) if f.endswith('.s')]
    ext, _ = externals(everything)
    defined = set()
    for path in everything:
        defined |= set(re.findall(r'^(\w+):', open(path, encoding='utf-8').read(), re.M))
    for path in everything:  # what the .inc files declare (.public), used or not
        inc = path[:-2] + '.inc'
        if os.path.exists(inc):
            for s in re.findall(r'^\.public (\w+)', open(inc, encoding='utf-8').read(), re.M):
                if s not in defined:
                    ext.setdefault(s, 0)
    missing = sorted(s for s in ext if s not in compat_names())
    if missing:
        sys.exit(f'not named by hgss_compat.inc ({len(missing)}): {" ".join(missing)}')
    print(f'{len(names)} files into decomp/asm/complete_hgss; {len(ext)} engine symbols, all named by hgss_compat.inc')


if __name__ == '__main__':
    main()
