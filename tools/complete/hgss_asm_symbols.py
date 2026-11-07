#!/usr/bin/env python3
"""List what a piece of HeartGold's assembly needs from the engine, and how much of it Platinum already has.

HeartGold's undecompiled overlays (pret's asm/overlay_NN.s) can be assembled as they are and linked into Complete
(decomp/asm/complete_hgss/, docs/Roadmap.md): each engine function they call is then named Platinum's way by
decomp/asm/complete_hgss/hgss_compat.inc. This tool finds those functions and sorts them:

- same code: the function's machine code is byte for byte one of Platinum's, relocated words (calls, pointers) masked
  and each call's target the same code again, one level down: the same Game Freak function under Platinum's name
  (given). Mapping it is a #define. A short one (32 bytes or less: a getter, a one-call wrapper) is marked "(short)":
  its meaning can still differ through the data it reads (a save block's number, a table), so check it. One that's
  static in Platinum is marked "(static)" (BoxPokemon_IsShiny): the link would fail, so it needs a shim. A function
  in Platinum's source that nothing in Complete calls isn't in the build (the linker drops it), so it shows as
  HeartGold only; calling it from an overlay would put it back into the main module, into main memory
  (CharacterSprite_LoadPokemonSprite): a shim in the overlay calls what Complete keeps instead.
- same body: the same bytes, but what it calls differs one level down (Sovereign changed a callee): most often still
  the same function.
- similar: not the same bytes, but a Platinum function calls the same functions (by their code) and is about as long:
  likely the same function with a constant changed (a NARC, a font, a size), so a shim. The best guess is given.
- same name: no code match, but Platinum has a function of that name: compare them.
- HeartGold only: nothing in Platinum by code or name: a port (in C, or HeartGold's own assembly beside it).
- data: a variable the assembly reads or writes (gSystem's fields need Platinum's offsets).

The code comes from both builds: HeartGold's (.cache/pokeheartgold/build/heartgold.us: main.nef's symbols and
relocations, and the .sbin files) and Complete's (decomp/build). With --compat FILE it also says which symbols that
file doesn't map yet.

Usage: python3 tools/complete/hgss_asm_symbols.py ASM_FILE [ASM_FILE ...] [--compat FILE] [--list] [--tsv OUT]
"""
import collections
import hashlib
import os
import re
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def cache_root():
    """The checkout whose .cache holds HeartGold's build: this one, or (from a git worktree) the main checkout."""
    if os.path.isdir(os.path.join(ROOT, '.cache/pokeheartgold')):
        return ROOT
    common = os.popen(f'git -C "{ROOT}" rev-parse --path-format=absolute --git-common-dir').read().strip()
    return os.path.dirname(common) if common else ROOT


HG_BUILD = os.path.join(cache_root(), '.cache/pokeheartgold/build/heartgold.us')
PL_BUILD = os.path.join(ROOT, 'decomp/build')

# the relocations that patch a word: R_ARM_ABS32, R_ARM_THM_CALL (THM_PC22), R_ARM_PC24, R_ARM_CALL, R_ARM_JUMP24,
# R_ARM_THM_JUMP24
RELOCATED = {2, 10, 1, 28, 29, 30}
SHORT = 32


class Image:
    """A linked nef's functions, relocations and code (from the .sbin files beside it)."""

    def __init__(self, build):
        data = open(os.path.join(build, 'main.nef'), 'rb').read()
        shoff, = struct.unpack_from('<I', data, 0x20)
        shentsize, shnum, shstrndx = struct.unpack_from('<HHH', data, 0x2E)
        sections = [struct.unpack_from('<IIIIIIIIII', data, shoff + i * shentsize) for i in range(shnum)]

        def name(off, table):
            start = table[4] + off
            return data[start:data.index(b'\0', start)].decode()

        self.sections = [(name(s[0], sections[shstrndx]), s) for s in sections]
        # each section name's code: its .sbin, loaded at the address of the name's first section
        self.code = {}
        for sname, s in self.sections:
            if s[1] == 1 and s[2] & 4 and sname not in self.code:
                path = os.path.join(build, f'{sname}.sbin')
                if os.path.exists(path):
                    self.code[sname] = (s[3], open(path, 'rb').read())
        symtab = next(s for _, s in self.sections if s[1] == 2)
        strtab = self.sections[symtab[6]][1]
        self.symbol_names = []  # by symbol index
        self.symbols = {}  # name: (address, size, section name, is_function)
        self.static = set()  # functions and objects only their own file sees
        self.all_names = set()  # every defined name, untyped ones too (the compiler's runtime, the linker's)
        for i, off in enumerate(range(symtab[4], symtab[4] + symtab[5], 16)):
            st_name, value, size, info, _, shndx = struct.unpack_from('<IIIBBH', data, off)
            n = name(st_name, strtab) if st_name else ''
            self.symbol_names.append(n)
            kind = info & 0xF
            if n and shndx != 0:
                self.all_names.add(n)
            if not n or shndx == 0 or shndx >= len(self.sections) or kind not in (1, 2):
                continue
            if n not in self.symbols or (info >> 4) == 1:
                self.symbols[n] = (value & ~1, size, self.sections[shndx][0], kind == 2)
                if info >> 4 == 0:
                    self.static.add(n)
                else:
                    self.static.discard(n)
        self.relocs = collections.defaultdict(dict)  # section name: {address: target symbol}
        for sname, s in self.sections:
            if s[1] == 4:  # RELA
                target = self.sections[s[7]][0]
                for off in range(s[4], s[4] + s[5], 12):
                    r_offset, r_info, _ = struct.unpack_from('<IIi', data, off)
                    if r_info & 0xFF in RELOCATED:
                        self.relocs[target][r_offset] = self.symbol_names[r_info >> 8]
        self._prints = {}

    def body(self, symbol):
        """(masked code, [call and pointer targets]) of a function, or None."""
        info = self.symbols.get(symbol)
        if not info or not info[3] or info[1] == 0 or info[2] not in self.code:
            return None
        address, size, sname, _ = info
        base, blob = self.code[sname]
        start = address - base
        if start < 0 or start + size > len(blob):
            return None
        code, targets = bytearray(blob[start:start + size]), []
        relocs = self.relocs.get(sname, {})
        for i in range(size):
            if address + i in relocs:
                targets.append(relocs[address + i])
                code[i:i + 4] = b'\0\0\0\0'
        return bytes(code[:size]), targets

    def fingerprint(self, symbol, depth=1):
        """A hash of the function's masked code and, depth levels down, of its targets' (a target that isn't a
        function counts by its kind only), or None."""
        key = (symbol, depth)
        if key not in self._prints:
            b = self.body(symbol)
            if b is None:
                self._prints[key] = None
            else:
                parts = [b[0]]
                for t in b[1]:
                    if depth == 0:
                        continue
                    info = self.symbols.get(t)
                    if info and info[3]:
                        parts.append((self.fingerprint(t, depth - 1) or 'fn').encode())
                    else:
                        parts.append(b'data')
                self._prints[key] = hashlib.sha1(b'|'.join(parts)).hexdigest()
        return self._prints[key]

    def callees(self, symbol):
        """The level-0 fingerprints of the functions a function calls."""
        b = self.body(symbol)
        if b is None:
            return None
        return collections.Counter(self.fingerprint(t, 0) for t in b[1]
                                   if t in self.symbols and self.symbols[t][3])


def externals(paths):
    """{symbol: uses} the files reference but don't define, and {symbol: [.word lines]}."""
    defined, uses, lines = set(), collections.Counter(), collections.defaultdict(list)
    texts = [open(p, errors='replace').read() for p in paths]
    for text in texts:
        defined |= set(re.findall(r'^(\w+):', text, re.M))
    for text in texts:
        for m in re.finditer(r'^\s*(?:bl|blx|b)\s+(\w+)\s*(?:;.*)?$', text, re.M):
            uses[m.group(1)] += 1
        for m in re.finditer(r'\.word\s+(\w+)(\s*[+-]\s*(?:0x[0-9A-Fa-f]+|\d+))?', text):
            uses[m.group(1)] += 1
            lines[m.group(1)].append(m.group(0))
    registers = re.compile(r'^(r\d+|sp|lr|pc|ip|sb|sl|fp)$')
    return {s: n for s, n in uses.items()
            if s not in defined and not re.match(r'^(0x|\d)', s) and not registers.match(s)}, lines


def compat_map(path):
    """{HeartGold name: what hgss_compat.inc names it} from its #define lines."""
    names = {}
    if path and os.path.exists(path):
        for line in open(path):
            m = re.match(r'\s*#define\s+(\w+)\s+(\w+)', line)
            if m:
                names[m.group(1)] = m.group(2)
    return names


TIERS = ('same code', 'same body', 'similar', 'same name', 'HeartGold only', 'data')


def classify(files, hint=None):
    """[(symbol, tier, Platinum's name and notes, uses)]. hint: {HeartGold name: Platinum name} to pick among
    candidates of equal code (a short function often has many)."""
    hint = hint or {}
    hg, pl = Image(HG_BUILD), Image(PL_BUILD)
    pl_functions = [n for n, info in pl.symbols.items() if info[3]]
    by_print, by_body = collections.defaultdict(list), collections.defaultdict(list)
    by_callees = collections.defaultdict(list)  # by the multiset of what they call (two or more different functions)
    for n in pl_functions:
        h = pl.fingerprint(n)
        if h:
            by_print[h].append(n)
            by_body[pl.fingerprint(n, 0)].append(n)
        c = pl.callees(n)
        if c and len(c) >= 2:
            by_callees[frozenset(c.items())].append(n)
    ext, lines = externals(files)

    def pick(symbol, candidates, short):
        if symbol in candidates:
            name = symbol
        elif hint.get(symbol) in candidates:
            name = hint[symbol]
        else:
            name = sorted(candidates, key=lambda n: (n in pl.static, n))[0]
            if len(candidates) > 1:
                name += f' (or {len(candidates) - 1} more)'
            name += ' (short)' if short else ''
        return name + (' (static)' if name.split()[0] in pl.static else '')

    rows = []
    for symbol in sorted(ext):
        info = hg.symbols.get(symbol)
        if info and not info[3]:
            rows.append((symbol, 'data', ' '.join(sorted(set(lines[symbol])))[:90], ext[symbol]))
            continue
        h = hg.fingerprint(symbol)
        short = bool(info) and info[1] <= SHORT
        if h and by_print.get(h):
            rows.append((symbol, 'same code', pick(symbol, by_print[h], short), ext[symbol]))
            continue
        h0 = hg.fingerprint(symbol, 0)
        if h0 and by_body.get(h0) and (not short or symbol in by_body[h0] or hint.get(symbol) in by_body[h0]):
            rows.append((symbol, 'same body', pick(symbol, by_body[h0], short), ext[symbol]))
            continue
        c = hg.callees(symbol)
        near = []
        if c and len(c) >= 2:
            size = info[1]
            near = [n for n in by_callees.get(frozenset(c.items()), [])
                    if abs(pl.symbols[n][1] - size) <= max(8, size // 5)]
        if near:
            rows.append((symbol, 'similar', pick(symbol, near, False), ext[symbol]))
        elif symbol in pl.all_names:
            rows.append((symbol, 'same name', symbol, ext[symbol]))
        else:
            rows.append((symbol, 'HeartGold only', '' if info else '(not in HeartGold\'s symbols)', ext[symbol]))
    return rows


def main():
    args = sys.argv[1:]
    compat = args[args.index('--compat') + 1] if '--compat' in args else None
    tsv = args[args.index('--tsv') + 1] if '--tsv' in args else None
    files = [a for i, a in enumerate(args) if not a.startswith('--') and (i == 0 or args[i - 1] not in ('--compat', '--tsv'))]
    mapped = compat_map(compat)
    rows = classify(files, mapped)
    counts = collections.Counter(r[1] for r in rows)
    print(f'{len(rows)} external symbols in {", ".join(os.path.basename(f) for f in files)}:',
          ', '.join(f'{counts[k]} {k}' for k in TIERS))
    same = [r for r in rows if r[1] in ('same code', 'same body')]
    print(f'  same code or body: {sum(1 for r in same if r[2].split()[0] == r[0])} under the same name, '
          f'{sum(1 for r in same if r[2].split()[0] != r[0])} renamed, '
          f'{sum(1 for r in same if "(short)" in r[2])} short and unsure (several candidates)')
    print(f'  calls and references in all: {sum(r[3] for r in rows)}')
    if compat:
        missing = [r[0] for r in rows if r[0] not in mapped and not (r[1] == 'same code' and r[2].split()[0] == r[0])]
        print(f'  not mapped by {os.path.basename(compat)}: {len(missing)}', ' '.join(missing))
        # a mapping to a name that isn't one of the code's matches: a shim, or a mistake
        for r in rows:
            target = mapped.get(r[0])
            if target and not target.startswith('HgssCompat_') and r[1] in ('same code', 'same body') \
                    and target != r[2].split()[0]:
                print(f'  {r[0]} -> {target}: the code matches {r[2]} instead')
    if '--list' in args:
        for r in rows:
            print(f'  {r[0]:48} {r[1]:15} {r[2]:56} {r[3]}')
    if tsv:
        with open(tsv, 'w') as f:
            for r in rows:
                f.write('\t'.join(str(x) for x in r) + '\n')


if __name__ == '__main__':
    main()
