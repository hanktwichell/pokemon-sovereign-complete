#!/usr/bin/env python3
"""Disassemble HeartGold's compiled field scripts back into its script source (step 4: Sacred Gold's scripts).

Sacred Gold is a binary hack: its scripts exist only in its ROM (a/0/1/2, one file per scr_seq_NNNN). This turns each
compiled file back into the source language of pokeheartgold (files/fielddata/script/scr_seq/*.s), so that
tools/complete/translate_hgss_scripts.py can translate Sacred Gold's version of a map's scripts as it does
HeartGold's.

- Commands come from pokeheartgold's asm/macros/script.inc (opcode, then each argument's size; a label is a word
  relative to the next command). Movement lists, the targets of ApplyMovement, come from asm/macros/movement.inc.
- The file is read straight through from its header (ScrDef ... ScrDefEnd), as the compiler laid it out: movement
  lists where a command points to one, commands elsewhere, so code no command reaches (an End after a GoTo) comes
  out too. Labels are `_XXXX` (the offset), entries scr_seq_<MAP>_NNN, as in pokeheartgold.
- HeartGold's shorthand comes back (GoToIfSet, GoToIfEq, Compare, Switch / Case, GiveItemNoCheck, SimpleNPCMsg...),
  as the sources and the translator use it, unless a label points inside it.
- Map init scripts (the _hdr files: InitScriptEntry_*, frame tables) have their own layout.
- Arguments are named as pokeheartgold's sources name the same argument of the same command: a flag, var, item,
  species, move, message, person, standard script, sound, map or trainer gets its constant's name, a value of 0x4000
  or more where the sources give vars gets the var's name; anything else stays a number.

Checked on HeartGold itself (--check): every file of HeartGold's ROM disassembles, reassembles with pokeheartgold's
own toolchain (tools/scripts/makescript.sh) to the same bytes, and its commands match the source's.

Usage: python3 tools/complete/disasm_hgss_scripts.py ROM OUT_DIR [NNNN ...]   (writes scr_seq_NNNN_<MAP>.s files)
       python3 tools/complete/disasm_hgss_scripts.py --check [--rom ROM] [NNNN ...]
           (on .cache/heartgold.nds unless ROM is given: Sacred Gold's must reassemble to its own bytes too; the
           comparison with pokeheartgold's sources only means something for HeartGold)
"""
import collections
import glob
import os
import re
import struct
import subprocess
import sys
import tempfile

import ndspy.narc
import ndspy.rom

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import HG, ROOT  # noqa: E402
import sacred_gold  # noqa: E402

SCR_SEQ = os.path.join(HG, 'files/fielddata/script/scr_seq')
SCRDEF_END = 0xFD13
OP_END, OP_RETURN, OP_GOTO = 2, 27, 22
OP_APPLY_MOVEMENT = 94
CONDITIONS = ['Lt', 'Eq', 'Gt', 'Le', 'Ge', 'Ne']
INIT_TYPES = {2: 'InitScriptEntry_OnTransition', 3: 'InitScriptEntry_OnResume', 4: 'InitScriptEntry_OnLoad'}


# --- HeartGold's command and movement tables ------------------------------------------------------------------------

def macro_bodies(path):
    text = open(path).read()
    for m in re.finditer(r'^\s*\.macro\s+(\w+)([^\n]*)\n(.*?)^\s*\.endm', text, re.M | re.S):
        params = [p.split('=')[0].strip() for p in re.split(r'[,\s]+', m.group(2).strip()) if p]
        lines = [line.split('//')[0].strip() for line in m.group(3).splitlines()]
        yield m.group(1), params, [line for line in lines if line]


def command_table():
    """{opcode: (name, [(size, param, relative)])} for the plain commands; the few with .if arguments are read in
    read_command."""
    table = {}
    for name, params, lines in macro_bodies(os.path.join(HG, 'asm/macros/script.inc')):
        m = re.fullmatch(r'\.short\s+(\d+)', lines[0]) if lines else None
        if not m:
            continue
        args = []
        for line in lines[1:]:
            d = re.fullmatch(r'\.(byte|short|word)\s+(.*)', line)
            if not d:
                break  # an .if: read_command knows these
            for part in d.group(2).split(','):
                p = re.fullmatch(r'\\(\w+)(\s*-\s*\.\s*-\s*4)?', part.strip())
                size = {'byte': 1, 'short': 2, 'word': 4}[d.group(1)]
                args.append((size, p.group(1) if p else part.strip(), bool(p and p.group(2))))
        table[int(m.group(1))] = (name, args)
    return table


def movement_table():
    """{code: name} for HeartGold's movements (each is .short code, .short length)."""
    consts = parse_defines([os.path.join(HG, 'include/constants/movements.h')])
    out = {}
    for name, params, lines in macro_bodies(os.path.join(HG, 'asm/macros/movement.inc')):
        code = lines[0].split()[1]
        out.setdefault(int(code, 0) if code[0].isdigit() else consts[code], name)
    return out


# --- HeartGold's constants --------------------------------------------------------------------------------------------

def parse_defines(paths, values=None):
    """{name: value} from #defines whose value is a number or an expression of other names (RGB(r, g, b) too). A name
    defined twice keeps the first definition that evaluates."""
    values = dict(values or {})
    pending = collections.defaultdict(list)
    for path in paths:
        for line in open(path, errors='replace'):
            m = re.match(r'\s*#define\s+(\w+)(?!\()\s+(.+?)\s*(//.*)?$', line)
            if m:
                pending[m.group(1)].append(m.group(2))
    env = {'RGB': lambda r, g, b: r | g << 5 | b << 10, '__builtins__': {}}
    for _ in range(6):
        for name, exprs in list(pending.items()):
            for expr in exprs:
                try:
                    text = re.sub(r'\b(?!RGB\b)([A-Za-z_]\w*)\b', lambda t: str(values[t.group(1)]), expr)
                    values[name] = int(eval(text, env))
                    del pending[name]
                    break
                except Exception:
                    pass
    return values


def script_headers():
    """The headers a script sees when it is assembled (constants/scrcmd.h and the rest that macros/script.inc
    includes, and what they include): only their names can stand in a script."""
    seen, todo = [], ['constants/scrcmd.h', 'constants/script_consts.h', 'constants/movements.h',
                      'constants/init_script_types.h']
    while todo:
        header = todo.pop()
        path = next((p for p in (os.path.join(HG, base, header) for base in ('include', 'asm', 'files'))
                     if os.path.exists(p)), None)
        if path and path not in seen:
            seen.append(path)
            todo += re.findall(r'#include\s+"([^"]+)"', open(path, errors='replace').read())
    return seen


def family(token):
    """What kind of name a source argument is: 'num', 'label', 'msg', 'obj', 'std', 'ev' or its prefix (FLAG_...)."""
    token = token.strip()
    if re.fullmatch(r'-?(0x[0-9A-Fa-f]+|\d+)', token):
        return 'num'
    if token.startswith('_EV_'):
        return 'ev'
    if re.match(r'(_[0-9A-F]{4}$|scr_seq_)', token):
        return 'label'
    for prefix in ('msg', 'obj', 'std'):
        if token.startswith(prefix + '_'):
            return prefix
    m = re.match(r'([A-Z][A-Z0-9]*_)', token)
    return m.group(1) if m else 'lit:' + token


class Names:
    """HeartGold's constants by family, and how its sources name each command's arguments."""

    def __init__(self, items=None):
        self.values = parse_defines(script_headers())
        usage = collections.Counter()
        self.model = collections.defaultdict(collections.Counter)  # (command, position) -> Counter(family)
        for path in glob.glob(os.path.join(SCR_SEQ, 'scr_seq_*.s')):
            for line in open(path, errors='replace'):
                m = re.match(r'\s+([A-Z]\w*)\s+(.*)$', line)
                if not m or m.group(1).startswith('Init'):
                    continue
                for i, arg in enumerate(split_args(m.group(2))):
                    self.model[(m.group(1), i)][family(arg)] += 1
                    usage[arg] += 1
        # value -> name, for each family: the name the sources use most, else the first defined
        self.by_value = collections.defaultdict(dict)
        for name, value in self.values.items():
            fam = family(name)
            best = self.by_value[fam].get(value)
            if best is None or usage[name] > usage[best]:
                self.by_value[fam][value] = name
        # Sacred Gold's flags and vars past HeartGold's (tools/complete/sacred_gold.py)
        for n in sacred_gold.SG_FLAGS:
            self.by_value['FLAG_'].setdefault(n, sacred_gold.flag_name(n))
        for n in sacred_gold.SG_VARS:
            self.by_value['VAR_'].setdefault(n, sacred_gold.var_name(n))
        # and its items in HeartGold's unused numbers (sacred_gold.rom_items)
        self.by_value['ITEM_'].update(items or {})

    def kinds(self, command, position):
        return self.model.get((command, position), collections.Counter())


def split_args(text):
    args, depth, cur = [], 0, ''
    for ch in text:
        depth += ch == '('
        depth -= ch == ')'
        if ch == ',' and depth == 0:
            args.append(cur.strip())
            cur = ''
        else:
            cur += ch
    return args + [cur.strip()] if cur.strip() else args


# --- one file ---------------------------------------------------------------------------------------------------------

class FileContext:
    """What one file's names depend on: its map code, people and script IDs (event_<MAP>.h), message bank."""

    def __init__(self, number, names):
        source = glob.glob(os.path.join(SCR_SEQ, f'scr_seq_{number:04}*.s'))
        assert len(source) == 1, number
        self.source = source[0]
        self.stem = os.path.splitext(os.path.basename(self.source))[0]
        text = open(self.source, errors='replace').read()
        self.includes = re.findall(r'#include "([^"]+)"', text)
        m = re.search(r'^\s+ScrDef\s+(\w+)_\d{3}\s*$', text, re.M)
        self.prefix = m.group(1) if m else re.sub(r'^scr_seq_(\d{4})_(\w+?)(_hdr)?$', r'scr_seq_\2', self.stem)
        if self.stem.endswith('_hdr'):
            m = re.search(r'#include "fielddata/script/scr_seq/event_(\w+)\.h"', text)
            self.prefix = f'scr_seq_{m.group(1)}' if m else self.prefix
        self.event = {}
        for inc in self.includes:
            if inc.startswith('fielddata/script/scr_seq/event_'):
                self.event.update(parse_defines([os.path.join(HG, 'files', inc)], names.values))
        self.obj_names = {}
        for name, value in self.event.items():
            if name.startswith('obj_'):
                self.obj_names.setdefault(value, name)
        self.ev_names = {v: n for n, v in self.event.items() if n.startswith('_EV_')}
        self.msg_banks = [m for m in (re.match(r'msgdata/msg/(msg_\d{4}\w*)\.h', i) for i in self.includes) if m]
        self.msg_prefix = self.msg_banks[0].group(1) if self.msg_banks else None


def read_command(data, pos, table):
    """(opcode, name, [(size, param, relative, value)], next position) or None if it isn't a command."""
    if pos + 2 > len(data):
        return None
    op = struct.unpack_from('<H', data, pos)[0]
    if op not in table:
        return None
    name, layout = table[op]
    p = pos + 2
    args = []

    def take(size, param, relative=False):
        nonlocal p
        if p + size > len(data):
            raise IndexError
        value = int.from_bytes(data[p:p + size], 'little', signed=relative)
        p += size
        if relative:
            value = p + value  # relative to the end of the word: the target's offset
        args.append((size, param, relative, value))
        return value

    try:
        if op in (400, 401, 402):  # StrengthFlagAction, FlashAction, DefogAction
            if take(1, 'action') == 2:
                take(2, 'var')
        elif op == 465:
            arg0 = take(2, 'arg0')
            if arg0 <= 3:
                take(2, 'arg1')
                take(2, 'arg2')
            elif arg0 != 6:
                take(2, 'arg1')
        elif op == 489:  # MysteryGift
            arg0 = take(2, 'arg0')
            if 1 <= arg0 <= 3:
                take(2, 'arg1')
            elif arg0 in (5, 6):
                take(2, 'arg1')
                take(2, 'arg2')
        elif op == 378:  # ViewRankings scope, page, record: .short scope * 3 + page
            v = take(2, 'scope3page')
            args[-1] = (2, 'scope', False, v // 3)
            args.append((0, 'page', False, v % 3))
            take(2, 'record')
        else:
            for size, param, relative in layout:
                take(size, param, relative)
    except IndexError:
        return None
    return op, name, args, p


def scan(data, entries, table):
    """Offsets of code (reached from the entries) and of movement lists, found by following the code."""
    code, movements, todo = set(), set(), list(entries)
    while todo:
        pos = todo.pop()
        while pos not in code and pos < len(data):
            cmd = read_command(data, pos, table)
            if cmd is None:
                break
            code.add(pos)
            op, _, args, nxt = cmd
            for _, _, relative, value in args:
                if relative:
                    (movements if op == OP_APPLY_MOVEMENT else code).add(value) if op == OP_APPLY_MOVEMENT \
                        else todo.append(value)
            if op in (OP_END, OP_RETURN, OP_GOTO):
                break
            pos = nxt
    return code, movements


class Disassembler:
    def __init__(self, items=None):
        self.table = command_table()
        self.movements = movement_table()
        self.names = Names(items)

    # naming
    def name(self, ctx, command, position, value, size):
        kinds = self.names.kinds(command, position)
        by_value = self.names.by_value
        if kinds['VAR_'] and value >= 0x4000 and value in by_value['VAR_']:
            return by_value['VAR_'][value]
        if kinds['TRAINER_'] and value and value in by_value['TRAINER_']:  # 0 is no trainer
            return by_value['TRAINER_'][value]
        symbolic = [(n, f) for f, n in kinds.items() if f not in ('num', 'VAR_', 'label')]
        if symbolic:
            count, fam = max(symbolic)
            # where the sources mostly give numbers, a big value is still a name of the kind they sometimes give
            # (StopBGM SEQ_GS_GYM)
            if count < kinds['num'] and value >= 256 and value in by_value.get(fam, {}):
                return by_value[fam][value]
            if count >= kinds['num']:
                if fam == 'msg' and ctx.msg_prefix:
                    return f'{ctx.msg_prefix}_{value:05}'
                if fam == 'obj' and value in ctx.obj_names:
                    return ctx.obj_names[value]
                if fam == 'obj' and value in by_value['obj']:
                    return by_value['obj'][value]
                if fam == 'ev' and value - 1 in ctx.ev_names:
                    return f'{ctx.ev_names[value - 1]} + 1'
                if fam.startswith('lit:') and fam in ('lit:TRUE', 'lit:FALSE'):
                    return {0: 'FALSE', 1: 'TRUE'}.get(value, str(value))
                if value in by_value.get(fam, {}):
                    return by_value[fam][value]
        if size == 4 and value >= 0x80000000:
            return str(value - (1 << 32))
        return str(value)

    def label(self, labels, offset):
        return labels.get(offset, f'_{offset:04X}')

    def disassemble(self, data, number):
        ctx = FileContext(number, self.names)
        if ctx.stem.endswith('_hdr'):
            return ctx, self.init_script(data, ctx)
        entries, pos = [], 0
        while struct.unpack_from('<H', data, pos)[0] != SCRDEF_END:
            entries.append(pos + 4 + struct.unpack_from('<i', data, pos)[0])
            pos += 4
        header_end = pos + 2
        code, movements = scan(data, entries, self.table)
        labels, entry_names = {}, collections.defaultdict(list)
        for i, e in enumerate(entries):
            labels.setdefault(e, f'{ctx.prefix}_{i:03}')
            entry_names[e].append(f'{ctx.prefix}_{i:03}')
        starts = code | set(entries)
        while True:
            items, targets = self.sweep(data, header_end, movements, starts)
            found = {value for kind, _, cmd in (i for i in items if i[0] == 'cmd') if cmd[0] == OP_APPLY_MOVEMENT
                     for _, _, relative, value in cmd[2] if relative} - movements
            # a jump into the middle of what was read (raw bytes, or commands read out of step): code starts there
            begins = {item[1] for item in items}
            inside = {t for t in targets - begins - found - movements - starts if 0 <= t < len(data)}
            if not found and not inside:
                break
            movements |= found
            starts |= inside
        lines = [f'\tScrDef {ctx.prefix}_{i:03}' for i in range(len(entries))] + ['\tScrDefEnd', '']
        cmds = items
        return self.emit(ctx, cmds, lines, targets, labels, entry_names)

    def sweep(self, data, header_end, movements, starts=()):
        """The file read straight through from the header: [(kind, offset, what)] and every command's targets. No
        command may run over a movement list or a known start of code (starts): what does is data, or a movement
        list no command points to."""
        items, pos, targets = [], header_end, set(movements)
        bounds = sorted(set(movements) | set(starts))
        while pos < len(data):
            if pos in movements:
                start, moves = pos, self.read_movement(data, pos, movements | set(starts))
                pos += self.movement_size(moves)
                items.append(('movement', start, moves))
                continue
            nxt = next((b for b in bounds if b > pos), len(data))
            after_end = not items or items[-1][0] != 'cmd' or items[-1][2][0] in (OP_END, OP_RETURN, OP_GOTO)
            if after_end and pos not in starts:
                # after a script's end, where no code goes: a movement list no command points to (vanilla keeps a
                # few), after its .balign 4
                aligned = (pos + 3) & ~3
                moves = self.movement_at(data, aligned, nxt) if all(b == 0 for b in data[pos:aligned]) else None
                if moves:
                    if aligned != pos:
                        items.append(('align', pos, aligned))
                    items.append(('movement', aligned, moves))
                    pos = aligned + 4 * len(moves)
                    continue
            cmd = read_command(data, pos, self.table)
            if all(b == 0 for b in data[pos:nxt]) and nxt - pos < 4 and nxt % 4 == 0:
                items.append(('align', pos, nxt))  # .balign 4, 0 (it would read as Noop)
                pos = nxt
                continue
            if cmd is not None and any(rel and not 0 <= v < len(data) for _, _, rel, v in cmd[2]):
                cmd = None  # a jump out of the file: data, not a command
            if cmd is not None and cmd[3] <= nxt:
                items.append(('cmd', pos, cmd))
                targets |= {value for _, _, relative, value in cmd[2] if relative}
                pos = cmd[3]
                continue
            aligned = (pos + 3) & ~3
            if pos % 4 and aligned <= nxt and all(b == 0 for b in data[pos:aligned]):
                items.append(('align', pos, aligned))
                pos = aligned
                continue
            moves = self.movement_at(data, pos, nxt)  # a movement list no command points to
            if moves:
                items.append(('movement', pos, moves))
                pos += 4 * len(moves)
                continue
            end = nxt if cmd is None else min(nxt, pos + 1)
            items.append(('data', pos, data[pos:end]))
            pos = end
        return items, targets

    @staticmethod
    def read_movement(data, pos, starts):
        """The movement list at pos: [(movement, length)], ending (0xFE, 0), or (0xFE, None) where it ends with only
        the 2-byte end code (Sacred Gold packs its lists so: the next list or code starts right after)."""
        moves = []
        while pos + 2 <= len(data):
            code_ = struct.unpack_from('<H', data, pos)[0]
            if code_ == 0xFE:
                length = struct.unpack_from('<H', data, pos + 2)[0] if pos + 4 <= len(data) else None
                moves.append((0xFE, 0 if length == 0 and pos + 2 not in starts else None))
                break
            if pos + 4 > len(data):
                break
            moves.append(struct.unpack_from('<HH', data, pos))
            pos += 4
        return moves

    @staticmethod
    def movement_size(moves):
        return 4 * len(moves) - (2 if moves and moves[-1] == (0xFE, None) else 0)

    def movement_at(self, data, pos, end):
        """The movement list at pos (4-aligned, known movements, ending with EndMovement before end), or None."""
        moves, q = [], pos
        while pos % 4 == 0 and q + 4 <= end:
            moves.append(struct.unpack_from('<HH', data, q))
            q += 4
            if moves[-1][0] == 0xFE or moves[-1][0] not in self.movements:
                break
        ok = moves and moves[-1] == (0xFE, 0) and all(m[0] in self.movements for m in moves)
        return moves if ok else None

    def emit(self, ctx, cmds, lines, targets, labels, entry_names):
        k = 0
        while k < len(cmds):
            kind, pos = cmds[k][0], cmds[k][1]
            if kind == 'align' and k + 1 < len(cmds) and cmds[k + 1][0] == 'movement':
                k += 1  # the movement list's own .balign below
                continue
            if kind == 'movement' and pos % 4 == 0:  # as the sources have it; Sacred Gold has some unaligned
                lines.append('\t.balign 4, 0')
            if pos in entry_names:
                lines += [f'{name}:' for name in entry_names[pos]]
            elif pos in targets:
                lines.append(f'{self.label(labels, pos)}:')
            if kind == 'movement':
                for code_, length in cmds[k][2]:
                    name = self.movements.get(code_, f'MovementCommand_{code_}')
                    if code_ == 0xFE:
                        lines.append({0: '\tEndMovement', None: '\t.short 254  @ EndMovement, only its code'}.get(
                            length, f'\t.short {code_}, {length}'))
                    else:
                        lines.append(f'\t{name}' + (f' {length}' if length != 1 else ''))
                lines.append('')
                k += 1
                continue
            if kind == 'align':
                lines.append('\t.balign 4, 0')
                k += 1
                continue
            if kind == 'data':
                lines.append('\t.byte ' + ', '.join(str(b) for b in cmds[k][2]))
                k += 1
                continue
            used, text = self.shorthand(cmds, k, targets, labels, ctx)
            lines += [f'\t{t}' for t in text]
            if cmds[k + used - 1][2][0] in (OP_END, OP_RETURN, OP_GOTO):
                lines.append('')
            k += used
        if lines[-1].strip() != '.balign 4, 0':
            lines += ['', '\t.balign 4, 0']
        return ctx, '\n'.join(lines).rstrip() + '\n'

    def args_text(self, ctx, name, args, labels, skip=()):
        out = []
        for i, (size, param, relative, value) in enumerate(args):
            if i in skip:
                continue
            out.append(self.label(labels, value) if relative else self.name(ctx, name, len(out), value, size))
        return out

    def shorthand(self, cmds, k, targets, labels, ctx):
        """(commands used, lines) for the commands at k: HeartGold's shorthand macro where they make one."""
        def cmd(j):
            if k + j >= len(cmds) or cmds[k + j][0] != 'cmd' or (j and cmds[k + j][1] in targets):
                return None
            return cmds[k + j][2]

        def val(c, i):
            return c[2][i][3]

        def is_name(c, name):
            return c is not None and c[1] == name

        def lab(c, i):
            return self.label(labels, val(c, i))

        def n(macro, pos, value, size=2):
            return self.name(ctx, macro, pos, value, size)

        c0, c1 = cmd(0), cmd(1)
        # SimpleNPCMsg: PlaySE SEQ_SE_DP_SELECT, LockAll, FacePlayer, NPCMsg, WaitButton, CloseMsg, ReleaseAll
        seq = [cmd(j) for j in range(7)]
        if all(seq) and [c[1] for c in seq] == ['PlaySE', 'LockAll', 'FacePlayer', 'NPCMsg', 'WaitButton',
                                                 'CloseMsg', 'ReleaseAll'] \
                and val(seq[0], 0) == self.names.values.get('SEQ_SE_DP_SELECT'):
            return 7, [f'SimpleNPCMsg {n("SimpleNPCMsg", 0, val(seq[3], 0))}']
        # ItemVars-based: SetVar/CopyVar 0x8004, item; SetVar/CopyVar 0x8005, quantity; then the use
        if c0 and c1 and c0[1] in ('SetVar', 'CopyVar') and c1[1] in ('SetVar', 'CopyVar') \
                and val(c0, 0) == 0x8004 and val(c1, 0) == 0x8005:
            item = n('GiveItemNoCheck', 0, val(c0, 1)) if c0[1] == 'SetVar' else n('Compare', 0, val(c0, 1))
            qty = str(val(c1, 1)) if c1[1] == 'SetVar' else n('Compare', 0, val(c1, 1))
            c2 = cmd(2)
            if is_name(c2, 'CallStd') and val(c2, 0) == self.names.values.get('std_give_item_verbose'):
                return 3, [f'GiveItemNoCheck {item}, {qty}']
            if is_name(c2, 'TakeItem') and [val(c2, i) for i in range(3)] == [0x8004, 0x8005, 0x800C]:
                return 3, [f'TakeItemNoCheck {item}, {qty}']
            c3, c4 = cmd(3), cmd(4)
            if is_name(c2, 'HasSpaceForItem') and [val(c2, i) for i in range(3)] == [0x8004, 0x8005, 0x800C] \
                    and is_name(c3, 'CompareVarToValue') and val(c3, 0) == 0x800C and is_name(c4, 'GoToIf'):
                if val(c3, 1) == 0 and val(c4, 0) == 1:
                    return 5, [f'GoToIfNoItemSpace {item}, {qty}, {lab(c4, 1)}']
                if val(c3, 1) == 1 and val(c4, 0) == 5:
                    return 5, [f'GoToIfNoItemSpace2 {item}, {qty}, {lab(c4, 1)}']
        # PhoneCall: SetVar 0x8004..0x8006, CallStd std_phone_call
        seq = [cmd(j) for j in range(4)]
        if all(seq) and [c[1] for c in seq] == ['SetVar', 'SetVar', 'SetVar', 'CallStd'] \
                and [val(c, 0) for c in seq[:3]] == [0x8004, 0x8005, 0x8006] \
                and val(seq[3], 0) == self.names.values.get('std_phone_call'):
            return 4, [f'PhoneCall {n("PhoneCall", 0, val(seq[0], 1))}, {val(seq[1], 1)}, {val(seq[2], 1)}']
        # flag and trainer checks
        if c0 and c0[1] in ('CheckFlag', 'CheckTrainerFlag') and c1 and c1[1] in ('GoToIf', 'CallIf') \
                and val(c1, 0) in (0, 1):
            jump = c1[1][:-2]  # GoTo / Call
            if c0[1] == 'CheckFlag':
                macro = f'{jump}If{"Set" if val(c1, 0) else "Unset"}'
            else:
                macro = f'{jump}If{"Defeated" if val(c1, 0) else "NotDefeated"}'
            return 2, [f'{macro} {n(macro, 0, val(c0, 0))}, {lab(c1, 1)}']
        # an item for a give-item script: SetVar 0x8004, item, then SetVar 0x8005, quantity (not a mart's number)
        c2 = cmd(2)
        if is_name(c0, 'SetVar') and val(c0, 0) == 0x8004 and val(c0, 1) < 0x4000 and is_name(c1, 'SetVar') \
                and val(c1, 0) == 0x8005 and not (is_name(c2, 'CallStd') and self.names.by_value['std'].get(
                    val(c2, 0), '').endswith(('mart', 'accessory'))):
            item = self.names.by_value['ITEM_'].get(val(c0, 1), str(val(c0, 1)))
            return 1, [f'SetVar VAR_SPECIAL_x8004, {item}']
        # Switch and Case
        if is_name(c0, 'CopyVar') and val(c0, 0) == 0x8008:
            return 1, [f'Switch {n("Switch", 0, val(c0, 1))}']
        if is_name(c0, 'CompareVarToValue') and val(c0, 0) == 0x8008 and is_name(c1, 'GoToIf') and val(c1, 0) == 1:
            return 2, [f'Case {n("Case", 0, val(c0, 1))}, {lab(c1, 1)}']
        # Compare
        if c0 and c0[1] in ('CompareVarToValue', 'CompareVarToVar'):
            return 1, [f'Compare {n("Compare", 0, val(c0, 0))}, {n("Compare", 1, val(c0, 1))}']
        if c0 and c0[1] in ('GoToIf', 'CallIf') and val(c0, 0) < len(CONDITIONS):
            return 1, [f'{c0[1]}{CONDITIONS[val(c0, 0)]} {lab(c0, 1)}']
        # signs: TrainerTipsEx type, message and DirectionSignpostEx type, map, message
        seq = [cmd(j) for j in range(5)]
        std_signpost = self.names.values.get('std_signpost')
        if all(seq) and [c[1] for c in seq] == ['SetSignpostMap', 'SetSignpostAction', 'WaitSignpostAction',
                                                 'TrainerTips', 'CallStd'] \
                and val(seq[0], 1) == 0 and val(seq[3], 1) == 0x800C and val(seq[4], 0) == std_signpost:
            return 5, [f'TrainerTipsEx {val(seq[0], 0)}, {n("TrainerTipsEx", 1, val(seq[3], 0))}']
        if all(seq) and [c[1] for c in seq] == ['DirectionSignpost', 'SetSignpostAction', 'WaitSignpostAction',
                                                 'WaitSignpost', 'CallStd'] \
                and val(seq[0], 3) == 0x800C and val(seq[3], 0) == 0x800C and val(seq[4], 0) == std_signpost:
            message, kind, map_ = (val(seq[0], i) for i in range(3))
            return 5, [f'DirectionSignpostEx {kind}, {n("DirectionSignpostEx", 1, map_)}, '
                       f'{n("DirectionSignpostEx", 2, message)}']
        op, name, args, _ = c0
        text = ', '.join(self.args_text(ctx, name, args, labels))
        return 1, [f'{name} {text}'.rstrip()]

    def init_script(self, data, ctx):
        lines, pos, tables = [], 0, []
        while data[pos] != 0:
            kind = data[pos]
            if kind == 1:
                target = pos + 5 + struct.unpack_from('<i', data, pos + 1)[0]
                label = f'{ctx.prefix}_map_scripts_{len(tables) + 2}'
                tables.append((target, label))
                lines.append(f'\tInitScriptEntry_OnFrameTable {label}')
                pos += 5
            else:
                script = struct.unpack_from('<H', data, pos + 1)[0]
                lines.append(f'\t{INIT_TYPES.get(kind, f"InitScriptEntry_Fixed {kind},")} '
                             f'{self.script_id(ctx, script)}')
                pos += 5
        lines += ['\tInitScriptEntryEnd', '']
        pos += 1
        for target, label in tables:
            assert target == pos, (ctx.stem, target, pos)
            lines.append(f'{label}:')
            while struct.unpack_from('<H', data, pos)[0] != 0:
                var, value, script = struct.unpack_from('<HHH', data, pos)
                lines.append(f'\tInitScriptGoToIfEqual {self.names.by_value["VAR_"].get(var, var)}, '
                             f'{value}, {self.script_id(ctx, script)}')
                pos += 6
            lines += ['\tInitScriptFrameTableEnd', '']
            pos += 2
        lines.append('\tInitScriptEnd')
        return '\n'.join(lines) + '\n'

    def script_id(self, ctx, script):
        if script - 1 in ctx.ev_names:
            return f'{ctx.ev_names[script - 1]} + 1'
        std = self.names.by_value['std'].get(script)
        return std or str(script)

    def file_text(self, ctx, body):
        head = [f'#include "{inc}"' for inc in ctx.includes]
        return '\n'.join(head) + '\n\n\n' + body


# --- reading ROMs, checking ---------------------------------------------------------------------------------------------

def rom_scripts(path):
    rom = ndspy.rom.NintendoDSRom.fromFile(path)
    return [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName('a/0/1/2')).files]


def reassemble(source_text, stem):
    """Assemble a source as pokeheartgold's build does, from its build directory; the bytes, or the error."""
    build = os.path.join(HG, 'build/heartgold.us')
    with tempfile.TemporaryDirectory() as tmp:
        src = os.path.join(tmp, f'{stem}.s')
        open(src, 'w').write(source_text)
        incs = ['../../subprojects/NitroSDK-4.2.30001/include', '../../subprojects/NitroSDK-4.2.30001/include/nitro',
                '../../subprojects/NitroSystem-071126.1/include', '../../include', '../../files',
                os.path.join(build, 'files'), '../../asm/include', '../../asm', '../..']
        cmd = [os.path.join(HG, 'tools/scripts/makescript.sh'), '--out-dir', tmp, '-a', 'arm-none-eabi-gcc']
        for inc in incs:
            cmd += ['-i', inc]
        r = subprocess.run(cmd + [src], cwd=build, capture_output=True, text=True)
        out = os.path.join(tmp, f'{stem}.bin')
        return (open(out, 'rb').read(), None) if r.returncode == 0 and os.path.exists(out) else (None, r.stderr[-800:])


def source_commands(text):
    """The command lines of a source, normalised for comparing: labels and blank lines dropped."""
    out = []
    for line in text.splitlines():
        s = line.split('//')[0].strip()
        if not s or s.startswith(('#', '.')) or s.endswith(':'):
            continue
        out.append(re.sub(r'\s+', ' ', re.sub(r'\s*,\s*', ', ', s)))
    return out


def check(numbers, rom):
    items = sacred_gold.rom_items(rom)
    dis = Disassembler(items)
    files = rom_scripts(rom)
    same_bytes = same_text = 0
    diffs = collections.Counter()
    for number in numbers:
        ctx, body = dis.disassemble(files[number], number)
        text = dis.file_text(ctx, body)
        # messages Sacred Gold added aren't in pokeheartgold's headers: define them for the check
        defined = set()
        for inc in ctx.includes:
            header = os.path.join(HG, 'build/heartgold.us/files', inc)
            if inc.startswith('msgdata/') and os.path.exists(header):
                defined |= set(re.findall(r'#define\s+(msg_\w+)', open(header).read()))
        extra = sorted(set(re.findall(r'\b(msg_\d{4}\w*_(\d{5}))\b', body)) - {(d, d[-5:]) for d in defined})
        sg_names = sorted(set(re.findall(r'\b((?:FLAG|VAR)_SG_([0-9A-F]{4}))\b', body)))
        text = text.replace('#include "macros/script.inc"', '#include "macros/script.inc"\n' + ''.join(
            f'#define {name} {int(index)}\n' for name, index in extra if name not in defined) + ''.join(
            f'#define {name} 0x{value}\n' for name, value in sg_names) + ''.join(
            f'#define {name} {value}\n' for value, name in items.items() if re.search(rf'\b{name}\b', body)))
        got, err = reassemble(text, ctx.stem)
        if got is None:
            print(f'{ctx.stem}: does not assemble: {err}')
        elif got.rstrip(b'\0') != files[number].rstrip(b'\0'):
            print(f'{ctx.stem}: different bytes ({len(got)} vs {len(files[number])})')
        else:
            same_bytes += 1
        data_lines = sum(1 for line in body.splitlines() if line.strip().startswith('.byte'))
        if data_lines:
            print(f'{ctx.stem}: {data_lines} lines of raw data')
        mine, theirs = source_commands(body), source_commands(open(ctx.source, errors='replace').read())
        if mine == theirs:
            same_text += 1
        else:
            for a, b in zip(mine, theirs):
                if a != b:
                    diffs[(b.split()[0], a.split()[0])] += 1
                    if len(sys.argv) > 2 and '-v' in sys.argv:
                        print(f'  {ctx.stem}: ours {a!r} / theirs {b!r}')
                    break
            if len(mine) != len(theirs):
                diffs[('length', '')] += 1
    print(f'{len(numbers)} files: {same_bytes} reassemble to the same bytes, {same_text} have the same commands')
    for (theirs, mine), count in diffs.most_common(25):
        print(f'  first difference {theirs} / ours {mine}: {count}')


def main():
    args = [a for a in sys.argv[1:] if a != '-v']
    if args and args[0] == '--check':
        rom = os.path.join(ROOT, '.cache/heartgold.nds')
        if len(args) > 2 and args[1] == '--rom':
            rom = args[2]
            del args[1:3]
        numbers = [int(a) for a in args[1:]] or list(range(len(rom_scripts(rom))))
        check(numbers, rom)
        return
    rom, out = args[:2]
    files = rom_scripts(rom)
    numbers = [int(a) for a in args[2:]] or range(len(files))
    dis = Disassembler(sacred_gold.rom_items(rom))
    os.makedirs(out, exist_ok=True)
    for number in numbers:
        ctx, body = dis.disassemble(files[number], number)
        open(os.path.join(out, f'{ctx.stem}.s'), 'w').write(dis.file_text(ctx, body))
    print(f'{len(numbers)} files written to {out}')


if __name__ == '__main__':
    main()
