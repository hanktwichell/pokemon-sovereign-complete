#!/usr/bin/env python3
"""Translate HeartGold's map scripts into the engine's script language (step 3; docs/ScriptConversion.md).

Reads HeartGold's script sources (.cache/pokeheartgold/files/fielddata/script/scr_seq/scr_seq_*.s, the map scripts and
the _hdr init scripts) and writes Platinum-style scripts. Each line is one of:
- a label, an alignment, ScrDef / ScrDefEnd (Platinum's ScriptEntry / ScriptEntryEnd), init script entries;
- a command, translated through COMMANDS (tools/complete/hgss_script_table.py) or, when Platinum has a macro of the
  same name taking the same arguments, kept;
- anything else is written as a comment beginning `@ HGSS:` and counted, so the report shows what is left.

Arguments go through the same renaming as the events (tools/complete/import_hgss_events.py): HeartGold flags,
vars, maps, objects, standard scripts and music become the engine's names.

Usage: python3 tools/complete/translate_hgss_scripts.py OUT_DIR [FILE_STEM ...]   (prints a coverage report)
       ... [--from SOURCE_DIR]   translates the sources there instead of pokeheartgold's (the event headers stay
           pokeheartgold's)
       python3 tools/complete/translate_hgss_scripts.py --install [FILE_STEM ...]
           writes the scripts the map headers use into decomp/res/field/scripts as scripts_hgss_NNNN.s and
           scripts_init_hgss_NNNN.s, and registers them
"""
import collections
import glob
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG  # noqa: E402

SCRIPTS = os.path.join(HG, 'files/fielddata/script/scr_seq')
COMPLETE_FLAGS_START = 2912
HG_MAP_LOCAL_FLAGS = range(1, 65)
HG_SAVED_VARS_START = 0x4030  # HeartGold vars from here on are VAR_COMPLETE_000 on
SILENT = 'SILENT'  # a HeartGold sound with no Platinum one yet: the command that plays or waits for it is left out
# HeartGold's battle outcomes have Platinum's numbers under other names
BATTLE_OUTCOMES = {
    'BATTLE_OUTCOME_NONE': '0', 'BATTLE_OUTCOME_WIN': 'BATTLE_RESULT_WIN', 'BATTLE_OUTCOME_LOSE': 'BATTLE_RESULT_LOSE',
    'BATTLE_OUTCOME_DRAW': 'BATTLE_RESULT_DRAW', 'BATTLE_OUTCOME_MON_CAUGHT': 'BATTLE_RESULT_CAPTURED_MON',
    'BATTLE_OUTCOME_PLAYER_FLED': 'BATTLE_RESULT_PLAYER_FLED', 'BATTLE_OUTCOME_FOE_FLED': 'BATTLE_RESULT_ENEMY_FLED',
}
SOUND_COMMANDS = {'PlaySE', 'WaitSE', 'StopSE', 'PlayFanfare', 'WaitFanfare', 'PlayCry', 'PlayMusic', 'PlayBGM'}


def macro_params(path):
    """{macro name: [parameter names]} from an assembler macro file."""
    out = {}
    for m in re.finditer(r'^\s*\.macro\s+(\w+)[ \t]*([^\n]*)', open(path).read(), re.M):
        params = [p.split('=')[0].strip() for p in re.split(r'[,\s]+', m.group(2).strip()) if p and p != '=']
        out[m.group(1)] = [p for p in params if p and not p.startswith('=')]
    return out


def defines(path, prefix=''):
    values = {}
    for line in open(path, errors='replace'):
        m = re.match(rf'#define\s+({prefix}\w+)\s+(0x[0-9A-Fa-f]+|\d+)\b', line)
        if m:
            values.setdefault(m.group(1), int(m.group(2), 0))
    return values


def split_args(text):
    """Split a macro's argument text on top-level commas."""
    args, depth, cur = [], 0, ''
    for ch in text:
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        if ch == ',' and depth == 0:
            args.append(cur.strip())
            cur = ''
        else:
            cur += ch
    if cur.strip():
        args.append(cur.strip())
    return args


class Names:
    """HeartGold's names for flags, vars, maps, objects and so on, and what they become in the engine."""

    def __init__(self):
        self.hg_flags = defines(os.path.join(HG, 'include/constants/flags.h'), 'FLAG_')
        self.hg_vars = defines(os.path.join(HG, 'include/constants/vars.h'), 'VAR_')
        self.hg_maps = defines(os.path.join(HG, 'include/constants/maps.h'), 'MAP_')
        self.hg_std = defines(os.path.join(HG, 'include/constants/std_script.h'), 'std_')
        platinum = open(os.path.join(DECOMP, 'build/generated/vars_flags.py')).read()
        self.pl_varflags = dict((n, int(v)) for n, v in re.findall(r'^    (\w+)\s*=\s*(\d+)$', platinum, re.M))
        self.pl_local_flags = {}
        for name, value in self.pl_varflags.items():
            if name.startswith('FLAG_MAP_LOCAL_') and value in HG_MAP_LOCAL_FLAGS:
                self.pl_local_flags.setdefault(value, name)
        # Items, species and moves: Sovereign's name for HeartGold's, by name (ignoring underscores: HeartGold's
        # ITEM_S_S__TICKET). HeartGold's own items aren't in Sovereign yet (docs/ScriptConversion.md): ITEM_NONE.
        self.shared, self.missing = {}, collections.Counter()
        norm = lambda name: re.sub(r'_', '', name)  # noqa: E731
        for kind, hg_header, generated in (('ITEM_', 'items.h', 'items.txt'), ('SPECIES_', 'species.h', 'species.txt'),
                                           ('MOVE_', 'moves.h', 'moves.txt')):
            ours = {norm(line.split()[0]): line.split()[0] for line in open(os.path.join(DECOMP, 'generated', generated))
                    if line.strip()}
            for name in defines(os.path.join(HG, 'include/constants', hg_header), kind):
                self.shared[name] = ours.get(norm(name), kind + 'NONE')
        # HeartGold's aliases for items (TM_EXPLOSION is ITEM_TM64)
        for alias, item in re.findall(r'#define\s+(TM_\w+|HM_\w+)\s+(ITEM_\w+)',
                                      open(os.path.join(HG, 'include/constants/items.h')).read()):
            self.shared[alias] = self.shared.get(item, 'ITEM_NONE')
        # HeartGold's trainers are TRAINER_HGSS_* (tools/complete/import_hgss_trainers.py); before that, TRAINER_NONE
        # (some of HeartGold's names are also Sinnoh trainers' in Sovereign, so they must not be kept as they are)
        self.hg_trainers = set(defines(os.path.join(HG, 'include/constants/trainers.h'), 'TRAINER_'))
        self.our_trainers = {line.strip() for line in open(os.path.join(DECOMP, 'generated/trainers.txt'))}
        self.hg_mapsecs = defines(os.path.join(HG, 'include/constants/map_sections.h'), '')
        naix = open(os.path.join(DECOMP, 'build/res/sound/pl_sound_data.naix')).read()
        self.pl_sounds = set(re.findall(r'\b(SEQ_\w+|SE_\w+)\b', naix))
        self.unknown = collections.Counter()

    def flag(self, name):
        if name.startswith('FLAG_SG_'):  # Sacred Gold's own (tools/complete/sacred_gold.py)
            return 'FLAG_HGSS_SG_' + name[len('FLAG_SG_'):]
        n = self.hg_flags.get(name)
        if n is None:
            return None
        if n == 0:
            return '0'
        if n in HG_MAP_LOCAL_FLAGS:
            return self.pl_local_flags[n]
        return 'FLAG_HGSS_' + name[len('FLAG_'):]

    def var(self, name):
        if name.startswith('VAR_SG_'):
            return 'VAR_HGSS_SG_' + name[len('VAR_SG_'):]
        n = self.hg_vars.get(name)
        if n is None:
            return None
        if n >= 0x8000:
            return {0x800C: 'VAR_RESULT', 0x800D: 'VAR_LAST_TALKED'}.get(n, f'VAR_0x{n:04X}')
        if n < 0x4020:
            return f'VAR_MAP_LOCAL_0x{n - 0x4000:02X}'
        if n < HG_SAVED_VARS_START:
            return f'VAR_OBJ_GFX_ID_{n - 0x4020:X}'
        return 'VAR_HGSS_' + name[len('VAR_'):]

    def sound(self, name):
        """Platinum's sound for one of HeartGold's, or SILENT: the same name for the sounds both games took from
        Diamond and Pearl, SOUNDS for the ones Platinum calls something else, and the music stand-ins for HeartGold's
        music. HeartGold's own sound effects wait for its sound archive (step 6)."""
        from hgss_script_table import SOUNDS
        from import_hgss_headers import stand_in_music
        if name in SOUNDS:
            return SOUNDS[name]
        if name + '_sseq' in self.pl_sounds:
            return name + '_sseq'
        if name.startswith('SEQ_GS_') and not name.startswith('SEQ_GS_SE'):
            return stand_in_music(name, None, 0)
        return SILENT

    def token(self, tok):
        """The engine's name for one HeartGold identifier, or the identifier itself if it needs no change."""
        if tok.startswith('FLAG_'):
            out = self.flag(tok)
        elif tok.startswith('VAR_'):
            out = self.var(tok)
        elif tok.startswith('MAP_') and tok in self.hg_maps:
            out = 'MAP_HEADER_HGSS_' + tok[len('MAP_'):]
        elif tok.startswith('SEQ_'):
            out = self.sound(tok)
        elif tok in BATTLE_OUTCOMES:
            out = BATTLE_OUTCOMES[tok]
        elif tok.startswith(('ITEM_', 'SPECIES_', 'MOVE_', 'TM_', 'HM_')) and tok in self.shared:
            out = self.shared[tok]
            if out.endswith('_NONE') and not tok.endswith('_NONE'):
                self.missing[tok] += 1
        elif tok in self.hg_trainers:
            out = 'TRAINER_HGSS_' + tok[len('TRAINER_'):]
            out = out if out in self.our_trainers else 'TRAINER_NONE'
        elif tok.startswith('RGB_'):
            out = 'COLOR_' + tok[len('RGB_'):]
        elif tok == 'obj_partner_poke':
            out = 'LOCALID_COMPLETE_FOLLOWER'
        elif tok == 'obj_player':
            out = 'LOCALID_PLAYER'
        else:
            return tok
        if out is None:
            self.unknown[tok] += 1
            return tok
        return out

    def arg(self, text):
        # HeartGold's MAPLOC(sec) is sec % 1000 (include/constants/map_sections.h)
        text = re.sub(r'MAPLOC\((\w+)\)', lambda m: str(self.hg_mapsecs.get(m.group(1), 0) % 1000), text)
        return re.sub(r'\b[A-Za-z_]\w*\b', lambda m: self.token(m.group(0)), text)


def translate_file(path, names, table, platinum_params, hg_params, report):
    out = []
    text = open(path, errors='replace').read()
    # movement lists start aligned in the engine's scripts too (Sacred Gold packs some unaligned, which its commands'
    # sizes allowed; the engine's commands have other sizes)
    movements = set(re.findall(r'^\s*ApplyMovement\s+[^,]+,\s*(\w+)', text, re.M))
    for raw in text.splitlines():
        line = raw.strip()
        if not line or line.startswith('#include') or line.startswith('//'):
            continue
        if line.endswith(':') and line[:-1] in movements and out[-1:] != ['    .balign 4, 0']:
            out.append('    .balign 4, 0')
        if line.endswith(':') or line.startswith('#'):  # labels and the file's own #defines
            out.append(names.arg(line) if line.startswith('#define') else line)
            continue
        if line.startswith('.short 254') and '@ EndMovement' in line:  # Sacred Gold's 2-byte end of a movement list
            out.append('    EndMovement')
            continue
        if line.startswith(('.byte', '.short', '.word')):  # bytes no script reaches (disasm_hgss_scripts.py)
            out.append(f'    @ HGSS data: {line}')
            continue
        if line.startswith('.'):
            out.append('    ' + line)
            continue
        m = re.match(r'(\w+)\s*(.*)$', line)
        name, rest = m.group(1), m.group(2)
        args = [names.arg(a) for a in split_args(rest)]
        report['lines'] += 1
        if any(re.search(r'\bstd_\w+', a) for a in args) and name not in table:
            out.append(f'    @ HGSS (a standard script with no equivalent yet): {line}')
            report['left'] += 1
            report['left_by_name'][name] += 1
            continue
        if SILENT in args and name in SOUND_COMMANDS:
            report['table'] += 1
            continue
        if name in table:
            out += ['    ' + x for x in table[name](args)]
            report['table'] += 1
        elif name in platinum_params and len(args) <= len(platinum_params[name]) \
                and len(hg_params.get(name, args)) == len(platinum_params[name]):
            out.append('    ' + (name + ' ' + ', '.join(args)).rstrip())
            report['same'] += 1
        else:
            out.append(f'    @ HGSS: {line}')
            report['left'] += 1
            report['left_by_name'][name] += 1
    return out


def file_header(path, text):
    """The engine's includes and defines for one translated file: the macros, the text banks its messages come from,
    and HeartGold's numbers for the people and script IDs it names (from its own event_*.h)."""
    lines = ['#include "macros/scrcmd.inc"']
    if 'TEXT_BANK_' in text:
        lines.append('#include "generated/text_banks.h"')
    if 'NPC_TRADE_' in text:
        lines.append('#include "constants/npc_trades.h"')
    if 'RIBBON_' in text:
        lines.append('#include "generated/ribbons.h"')
    for bank in sorted(set(re.findall(r'\bmsg_(\d{4})\w*?_\d{5}\b', text))):
        lines.append(f'#include "res/text/bank/hgss_msg_{bank}.h"')
    lines.append('')
    if 'LOCALID_COMPLETE_FOLLOWER' in text:
        lines.append('#define LOCALID_COMPLETE_FOLLOWER 0xF0  // include/complete_follower.h')
    used = set(re.findall(r'\b\w+\b', text))
    for event_h in re.findall(r'#include "fielddata/script/scr_seq/(event_\w+\.h)"', open(path, errors='replace').read()):
        for name, value in defines(os.path.join(SCRIPTS, event_h)).items():
            if name in used:
                lines.append(f'#define {name} {value}')
    return lines


def engine_name(stem):
    """scr_seq_0911_T26 -> scripts_hgss_0911; scr_seq_0684_T26_hdr -> scripts_init_hgss_0684."""
    number = re.match(r'scr_seq_(\d{4})', stem).group(1)
    return f'scripts_init_hgss_{number}' if stem.endswith('_hdr') else f'scripts_hgss_{number}'


def install(files, names, table, platinum_params, hg_params, report):
    """Write the translated scripts into the engine and register them (scripts.order, meson.build)."""
    from import_hgss_headers import set_meson, set_order
    out_names = []
    for path in files:
        stem = os.path.splitext(os.path.basename(path))[0]
        body = translate_file(path, names, table, platinum_params, hg_params, report)
        text = '\n'.join(body)
        name = engine_name(stem)
        with open(os.path.join(DECOMP, f'res/field/scripts/{name}.s'), 'w') as f:
            f.write('\n'.join(file_header(path, text)) + '\n\n' + text + '\n')
        out_names.append(name)
    set_order('res/field/scripts/scripts.order', 'scripts_hgss_', [])
    set_order('res/field/scripts/scripts.order', 'scripts_init_hgss_', out_names)
    set_meson('res/field/scripts/meson.build', "'scripts_init_route_220.s'", [n + '.s' for n in out_names])
    return out_names


def main():
    from hgss_script_table import COMMANDS
    from import_hgss_headers import hg_headers

    args = sys.argv[1:]
    install_mode = '--install' in args
    args = [a for a in args if a != '--install']
    source_dir = SCRIPTS
    if '--from' in args:  # another copy of the sources: Sacred Gold's (tools/complete/disasm_hgss_scripts.py)
        at = args.index('--from')
        source_dir = args[at + 1]
        del args[at:at + 2]
    out_dir = None if install_mode else args[0]
    stems = args[0 if install_mode else 1:]
    if out_dir:
        os.makedirs(out_dir, exist_ok=True)
    names = Names()
    platinum_params = {}
    for f in ('scrcmd.inc', 'movement.inc'):
        platinum_params.update(macro_params(os.path.join(DECOMP, 'asm/macros', f)))
    hg_params = {}
    for f in ('script.inc', 'movement.inc'):
        hg_params.update(macro_params(os.path.join(HG, 'asm/macros', f)))
    report = {'lines': 0, 'table': 0, 'same': 0, 'left': 0, 'left_by_name': collections.Counter()}
    files = sorted(glob.glob(os.path.join(source_dir, 'scr_seq_*.s')))
    if stems:
        files = [f for f in files if any(s in os.path.basename(f) for s in stems)]
    if install_mode:  # the files the map headers use
        used = set()
        for _, f in hg_headers():
            for key in ('scriptsBank', 'scriptHeaderBank'):
                used.add(re.sub(r'_bin$', '', f[key]))
        files = [f for f in files if os.path.splitext(os.path.basename(f))[0] in used]
        install(files, names, COMMANDS, platinum_params, hg_params, report)
    else:
        for path in files:
            lines = translate_file(path, names, COMMANDS, platinum_params, hg_params, report)
            with open(os.path.join(out_dir, os.path.basename(path)), 'w') as f:
                f.write('\n'.join(file_header(path, '\n'.join(lines))) + '\n\n' + '\n'.join(lines) + '\n')
    total = report['lines'] or 1
    print(f"{len(files)} files, {report['lines']} command lines: {report['table']} by table "
          f"({report['table'] / total:.1%}), {report['same']} same name ({report['same'] / total:.1%}), "
          f"{report['left']} left ({report['left'] / total:.1%})")
    print('most common left:', ', '.join(f'{k} {v}' for k, v in report['left_by_name'].most_common(40)))
    if names.missing:
        print('not in Sovereign yet (_NONE for now):', ', '.join(f'{k} {v}' for k, v in names.missing.most_common(20)))
    if names.unknown:
        print('unknown names:', ', '.join(f'{k} {v}' for k, v in names.unknown.most_common(20)))


if __name__ == '__main__':
    main()
