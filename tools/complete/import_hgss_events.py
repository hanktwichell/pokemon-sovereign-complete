#!/usr/bin/env python3
"""Convert HeartGold's map events (warps, people and things, signs) into the engine's events files.

Run after tools/complete/import_hgss_headers.py, which names the files (events_hgss_NNN.json, one per HeartGold events
bank) and creates them empty. The numbers come from HeartGold's built events archive
(.cache/pokeheartgold/build/heartgold.us/files/fielddata/eventdata/zone_event.narc), whose records have the same layout
as Platinum's, and the names (object IDs, sprites) from its JSON sources. docs/MapConversion.md has the mapping:

- warps: HeartGold map n -> MAP_HEADER_HGSS_* (n + MAP_HEADER_HGSS_EVERYWHERE), same arrival warp; the dynamic
  warp (4095, back where the player came from) is the same in both games;
- objects: the same local IDs (HeartGold's object names become the LOCALID constants for scripts), position, facing
  and range; movement types 0-46 are the same in both games, the rest look south; HeartGold flag f -> flag
  COMPLETE_FLAGS_START + f (named FLAG_HGSS_* in generated/vars_flags.txt), its per-map flags (1-64) stay the same;
  sprites: Platinum's sprite with the same number for HeartGold's first 146 (Diamond and Pearl's list, which both
  games kept), for HeartGold's own ones the Diamond and Pearl sprite of the same kind, Sovereign's overworld Pokémon,
  or a stand-in (SPRITE_STAND_INS) until HeartGold's sprites come in;
- signs and hidden items (bg events): kept, same kind and facing;
- vars: HeartGold's saved vars (0x4030 on) are named VAR_HGSS_* after HeartGold's, as aliases of VAR_COMPLETE_*;
- scripts: Cut trees, Rock Smash rocks and Strength boulders run the same scripts in both games (10000-10002). On maps
  whose scripts are translated (tools/complete/translate_hgss_scripts.py --install), people, signs and step-on
  triggers (coord events) run their own (HeartGold's numbering, 1 on); elsewhere they run Platinum's do-nothing script
  0 and the step-on triggers are left out, since each one starts a scripted scene. Trainers are trainers once
  tools/complete/import_hgss_trainers.py has added them (TRAINER_HGSS_*): the same trainer types and sight ranges,
  the trainer as the script. Item balls and hidden items run their entries in Platinum's item scripts
  (tools/complete/import_hgss_field_items.py), on every map.

With --rom ROM (Sacred Gold's: .cache/sacredgold.nds), the events come from that ROM's events archive (a/0/3/2)
instead, still named from pokeheartgold's sources; a person the ROM added gets the name obj_<MAP>_<local ID>.

Usage: python3 tools/complete/import_hgss_events.py [--rom ROM]
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_headers import edit, hg_headers  # noqa: E402
from import_hgss_field_items import ITEM_BALLS, hidden_item_script, item_ball_script  # noqa: E402
from import_hgss_maps import DECOMP, HG  # noqa: E402
from narc import read_narc  # noqa: E402
import sacred_gold  # noqa: E402

COMPLETE_FLAGS_START = 2912  # decomp/include/vars_flags.h
MARK = 'Sovereign Complete: HeartGold flags (tools/complete/import_hgss_events.py)'
MARK_END = 'Sovereign Complete: end of HeartGold flags'
VAR_MARK = 'Sovereign Complete: HeartGold vars (tools/complete/import_hgss_events.py)'
VAR_MARK_END = 'Sovereign Complete: end of HeartGold vars'
HG_SAVED_VARS_START = 0x4030  # HeartGold's vars from here on are VAR_COMPLETE_000 on
HG_MAP_LOCAL_FLAGS = range(1, 65)
HG_NUM_FLAGS = 2912
ITEM_BALL_SCRIPTS = range(7000, 7000 + ITEM_BALLS)  # HeartGold's (tools/complete/import_hgss_field_items.py)
HIDDEN_ITEM_SCRIPTS = range(8000, 8800)
BG_FACING, BG_HIDDEN_ITEM = 0, 2  # bg event kinds, the same in both games
BG_DIR_ALL = 4
TRAINER_SCRIPTS = range(3000, 7000)  # a trainer's battle: 3000 + trainer - 1, a double's second trainer 5000 + ...
HGSS_HEADER_BASE_NAME = 'MAP_HEADER_HGSS_'
FIELD_MOVE_SCRIPTS = (10000, 10001, 10002)  # Cut, Rock Smash, Strength: the same scripts in both games
DYNAMIC = 4095  # "back where the player came from", the same in both games (MAP_HEADER_DYNAMIC)
SAME_MOVEMENT_TYPES = 47  # MOVEMENT_TYPE_NONE .. MOVEMENT_TYPE_LOOK_WEST_AND_EAST
OTHER_MOVEMENT = 'MOVEMENT_TYPE_LOOK_SOUTH'
SAME_SPRITES = 146  # Diamond and Pearl's list, kept by both games (Platinum adds the berry soil at 100)
SPRITE_STAND_INS = {
    'PCWOMAN1': 'POKECENTER_NURSE', 'PCWOMAN2': 'RECEPTIONIST', 'PCWOMAN3': 'RECEPTIONIST',
    'COUNTERM': 'CASHIER_M', 'STOP': 'BOLLARD', 'GSRIVEL': 'BARRY', 'GSMAMA': 'MOM', 'REDMAMA': 'MOM',
    'OOKIDO': 'PROF_OAK', 'ROCKETM': 'GRUNT_M', 'ROCKETW': 'GRUNT_F', 'RKANBUM': 'SATURN', 'RKANBUM2': 'SATURN',
    'RKANBUM3': 'SATURN', 'RKANBUW': 'MARS', 'SAKAKI': 'CYRUS', 'WATARU': 'CYNTHIA', 'CHAMPION': 'CYNTHIA',
    'GSBIGFOUR1': 'AARON', 'GSBIGFOUR2': 'BERTHA', 'GSBIGFOUR3': 'FLINT', 'GSBIGFOUR4': 'LUCIAN',
    'SUNGLASSES': 'GYM_GUIDE', 'DELIVERY': 'MYSTERY_GIFT_DELIVERYMAN', 'DELIVERY2': 'MYSTERY_GIFT_DELIVERYMAN',
    'GSSWIMMERM': 'SWIMMER_M', 'GSSWIMMERW': 'SWIMMER_F', 'GSDSBOY': 'KID_WITH_NDS', 'BOZU': 'EXPERT_M',
    'ITAKO': 'EXPERT_F', 'DANCER': 'BEAUTY', 'GANG': 'ROUGHNECK', 'MANIA': 'COLLECTOR', 'BOARDER': 'SKIER_M',
    'THIEF': 'ROUGHNECK', 'MINAKI': 'GENTLEMAN', 'SUIT': 'GENTLEMAN', 'JUGGRER': 'CLOWN', 'GANTETSU': 'EXPERT_M',
    'MASAKI': 'SCIENTIST_M', 'CAPTAIN': 'SAILOR', 'INSTRUCTOR': 'GENTLEMAN', 'KURUMI': 'LASS', 'NANAMI': 'BEAUTY',
    'CHOUROU': 'EXPERT_M', 'RAPURASU': 'MAGIKARP', 'THLONOWNER': 'GENTLEMAN', 'BFSM': 'FRONTIER_SINGLE_ATTENDANT',
    'BFSW1': 'FRONTIER_MULTI_ATTENDANT', 'BFSW2': 'FRONTIER_BOOTH_ATTENDANT', 'WIFISM': 'WIFI_PLAZA_ATTENDANT_M',
    'WIFISF': 'WIFI_PLAZA_ATTENDANT_F', 'RED': 'PLAYER_M', 'DAIGO': 'GENTLEMAN', 'KABIGON': 'STRENGTH_BOULDER',
    'YADON': 'PSYDUCK', 'RGYARADOSU': 'MAGIKARP', 'ROTOMF': 'ROTOM_FAN', 'ROTOMS': 'ROTOM_FROST',
    'ROTOMI': 'ROTOM_HEAT', 'ROTOMW': 'ROTOM_WASH', 'ROTOMG': 'ROTOM_MOW', 'ICE': 'ICE_ROCK', 'BONGURI': 'BERRY_SOIL',
    'HOU_OBJ01': 'LEGENDARY_HO_OH', 'LUG_OBJ01': 'LEGENDARY_LUGIA', 'LEAG_DOOR2': 'ELITE_FOUR_ROOM_DOOR',
    'USOKKY': 'CUT_TREE', 'GSWOMAN6': 'BEAUTY', 'MONO_PIP': 'CLEFAIRY', 'JUPETTA': 'DRIFLOON', 'MEDAL': 'POKEBALL',
    'SCROLL': 'BOOK', 'FIRE': 'VENT', 'POKEWALL': 'BOLLARD', 'AJI_PERU': 'MIDDLE_AGED_MAN',
}
SPRITE_BY_KEYWORD = [('LEADER', 'GYM_GUIDE'), ('SIGN', 'SIGNBOARD'), ('TOROPHY', 'POKEBALL'), ('GATE', 'BOLLARD'),
                     ('BABYBOY', 'NINJA_BOY'), ('HERO', 'PLAYER_M')]
SPRITE_FALLBACK = 'MIDDLE_AGED_MAN'


def lines(path):
    return [line.strip() for line in open(os.path.join(DECOMP, path)) if line.strip() and not line.startswith('#')]


def defines(path, prefix):
    values = {}
    for line in open(os.path.join(HG, path)):
        m = re.match(rf'#define ({prefix}\w+)\s+(0x[0-9A-Fa-f]+|\d+)\b', line)
        if m:
            values.setdefault(m.group(1), int(m.group(2), 0))
    return values


class Sprites:
    def __init__(self):
        self.platinum = [n.split(' ')[0] for n in lines('generated/object_events_gfx.txt')]
        self.hg = {}
        for name, n in defines('include/constants/sprites.h', 'SPRITE_').items():
            self.hg.setdefault(n, name[len('SPRITE_'):])
        self.dp_names = {self.hg[n]: n for n in range(SAME_SPRITES) if n in self.hg}
        self.unmatched = set()

    def by_number(self, n):
        return self.platinum[n + 1 if 100 <= n <= 115 else n]  # Platinum's berry soil sits at 100

    def name(self, n):
        if n < SAME_SPRITES:
            return self.by_number(n)
        hg = self.hg.get(n, f'{n}')
        pokemon = re.fullmatch(r'FOLLOWER_MON_STATIC_(\w+?)(_SPIKY)?', hg)
        if pokemon:
            for candidate in (f'LEGENDARY_{pokemon.group(1)}', pokemon.group(1), f'FOLLOWER_{pokemon.group(1)}'):
                if f'OBJ_EVENT_GFX_{candidate}' in self.platinum:
                    return f'OBJ_EVENT_GFX_{candidate}'
            return 'OBJ_EVENT_GFX_POKEBALL'
        leader = re.fullmatch(r'GSLEADER(\d+)', hg)
        if leader:  # Johto's leaders 1-8 and Kanto's 9-16 as Sinnoh's eight
            return self.by_number(self.dp_names[f'LEADER{(int(leader.group(1)) - 1) % 8 + 1}'])
        if hg in SPRITE_STAND_INS:
            return f'OBJ_EVENT_GFX_{SPRITE_STAND_INS[hg]}'
        base = re.sub(r'_\d+$', '', re.sub(r'^GS', '', hg))  # GSWOMAN1 -> WOMAN1, SEAMAN_2 -> SEAMAN
        if base in self.dp_names:
            return self.by_number(self.dp_names[base])
        for keyword, stand_in in SPRITE_BY_KEYWORD:
            if keyword in hg:
                return f'OBJ_EVENT_GFX_{stand_in}'
        self.unmatched.add(hg)
        return f'OBJ_EVENT_GFX_{SPRITE_FALLBACK}'


def flag_names():
    """HeartGold's named flags as FLAG_HGSS_* -> engine flag number, and engine number -> name."""
    names = {}
    for name, n in defines('include/constants/flags.h', 'FLAG_').items():
        if HG_MAP_LOCAL_FLAGS.stop <= n < HG_NUM_FLAGS and not name.endswith('_BASE'):
            names.setdefault(COMPLETE_FLAGS_START + n, 'FLAG_HGSS_' + name[len('FLAG_'):])
    for n in sacred_gold.SG_FLAGS:  # Sacred Gold's own, after HeartGold's (tools/complete/sacred_gold.py)
        names[sacred_gold.engine_flag(n)] = 'FLAG_HGSS_' + sacred_gold.flag_name(n)[len('FLAG_'):]
    return names


def map_local_flags():
    """Platinum's per-map flags by number (Sovereign renamed some), from the enum the build generates."""
    generated = open(os.path.join(DECOMP, 'build/generated/vars_flags.py')).read()
    local = {}
    for name, value in re.findall(r'^    (FLAG_MAP_LOCAL_\w+)\s*=\s*(\d+)$', generated, re.M):
        if int(value) in HG_MAP_LOCAL_FLAGS:
            local.setdefault(int(value), name)
    assert sorted(local) == list(HG_MAP_LOCAL_FLAGS), 'Platinum\'s per-map flags are not 1-64'
    return local


def flag(n, names, platinum_local):
    if n == 0:
        return '0'
    if n in HG_MAP_LOCAL_FLAGS:
        return platinum_local[n]
    if n in sacred_gold.SG_FLAGS:
        return names[sacred_gold.engine_flag(n)]
    assert n < HG_NUM_FLAGS, n
    return names.setdefault(COMPLETE_FLAGS_START + n, f'FLAG_HGSS_0x{n:03X}')


def parse(data):
    """HeartGold's built events record: bgs, objects, warps, coords (the same layout as Platinum's)."""
    off, out = 0, {}
    for key, fmt in (('bgs', '<HHIIII'), ('objects', '<14HI'), ('warps', '<HHHHI'), ('coords', '<8H')):
        count = struct.unpack_from('<I', data, off)[0]
        off += 4
        size = struct.calcsize(fmt)
        out[key] = [struct.unpack_from(fmt, data, off + i * size) for i in range(count)]
        off += count * size
    assert off == len(data), 'events record not fully read'
    return out


def main():
    headers = hg_headers()
    header_names = [HGSS_HEADER_BASE_NAME + name[len('MAP_'):] for name, _ in headers]
    movement_types = lines('generated/movement_types.txt')
    trainer_types = lines('generated/trainer_types.txt')
    hg_trainers = {n: name for name, n in defines('include/constants/trainers.h', 'TRAINER_').items()}
    our_trainers = set(lines('generated/trainers.txt'))

    def trainer(script):
        """A trainer's script (3000 + trainer - 1, or 5000 + for a double battle's second) as the engine names it."""
        name = 'TRAINER_HGSS_' + hg_trainers[script % 2000 - 1000 + 1][len('TRAINER_'):]
        return name if name in our_trainers else None
    bg_dirs = lines('generated/bg_event_dirs.txt')
    platinum_local = map_local_flags()
    names = flag_names()
    sprites = Sprites()
    if '--rom' in sys.argv:
        import ndspy.narc
        import ndspy.rom
        rom = ndspy.rom.NintendoDSRom.fromFile(sys.argv[sys.argv.index('--rom') + 1])
        archive = [bytes(f) for f in ndspy.narc.NARC(rom.getFileByName('a/0/3/2')).files]
    else:
        archive = read_narc(os.path.join(HG, 'build/heartgold.us/files/fielddata/eventdata/zone_event.narc'))
    sources = {int(f[:3]): f for f in os.listdir(os.path.join(HG, 'files/fielddata/eventdata/zone_event'))
               if f.endswith('.json')}

    banks = sorted({int(re.fullmatch(r'NARC_zone_event_(\d{3})\w*_bin', f['eventsBank']).group(1)) for _, f in headers})
    # The events banks whose map's scripts are translated (tools/complete/translate_hgss_scripts.py --install): they
    # run their own scripts, by number from 1 up to the file's count; the rest run script 0 until then.
    scripted = {}
    for _, f in headers:
        path = os.path.join(DECOMP, 'res/field/scripts/scripts_hgss_{}.s'.format(
            re.match(r'scr_seq_(\d{4})', f['scriptsBank']).group(1)))
        if os.path.exists(path):
            bank = int(re.fullmatch(r'NARC_zone_event_(\d{3})\w*_bin', f['eventsBank']).group(1))
            count = len(re.findall(r'^\s+ScriptEntry ', open(path).read(), re.M))
            scripted[bank] = min(count, scripted.get(bank, count))
    hg_vars = defines('include/constants/vars.h', 'VAR_')
    var_names = {}
    for name, n in sorted(hg_vars.items(), key=lambda item: item[1]):
        var_names.setdefault(n, name)

    def var(n):
        if n == 0:  # no var: a step-on trigger that always runs (Sacred Gold has one)
            return '0'
        if n >= 0x8000:
            return {0x800C: 'VAR_RESULT', 0x800D: 'VAR_LAST_TALKED'}.get(n, f'VAR_0x{n:04X}')
        if n < 0x4020:
            return f'VAR_MAP_LOCAL_0x{n - 0x4000:02X}'
        if n < HG_SAVED_VARS_START:
            return f'VAR_OBJ_GFX_ID_{n - 0x4020:X}'
        if n in sacred_gold.SG_VARS:
            return 'VAR_HGSS_' + sacred_gold.var_name(n)[len('VAR_'):]
        return 'VAR_HGSS_' + var_names[n][len('VAR_'):]

    totals = {'bg_events': 0, 'object_events': 0, 'warp_events': 0, 'coord_events': 0, 'coords left out': 0}
    for bank in banks:
        events = parse(archive[bank])
        own_scripts = scripted.get(bank, 0)
        def script_of(n):
            if n in ITEM_BALL_SCRIPTS:
                return item_ball_script(n - ITEM_BALL_SCRIPTS.start)
            if n in HIDDEN_ITEM_SCRIPTS:
                return hidden_item_script(n - HIDDEN_ITEM_SCRIPTS.start)
            if n in FIELD_MOVE_SCRIPTS or 0 < n <= own_scripts:
                return n
            if own_scripts and 0 < n < 2000:  # a script the map's file lacks would run past its end
                print(f'{sources[bank]}: script {n} past the map\'s {own_scripts}: script 0')
            return 0

        source = json.load(open(os.path.join(HG, 'files/fielddata/eventdata/zone_event', sources[bank])))
        source_objects = source.get('objects', [])
        map_code = re.sub(r'^\d{3}_|\.json$', '', sources[bank])
        # people a ROM's version added (Sacred Gold's) are named by their local ID
        source_objects += [{'id': f'obj_{map_code}_{i}'} for i in range(len(source_objects), len(events['objects']))]

        # A hidden item is one by its script: Sacred Gold gives one of its hidden items (Route 47's second DeepSeaTooth)
        # a sign's kind, and two scripts of its own a hidden item's, whose flag the engine would work out from the
        # script number (from any side, as a hidden item is found)
        bg_events = [{'script': script_of(script),
                      'type': BG_HIDDEN_ITEM if script in HIDDEN_ITEM_SCRIPTS else
                      BG_FACING if kind == BG_HIDDEN_ITEM else kind,
                      'x': x, 'z': z, 'y': y,
                      'player_facing_dir': bg_dirs[BG_DIR_ALL if kind == BG_HIDDEN_ITEM else direction]}
                     for script, kind, x, z, y, direction in events['bgs']]
        object_events, seen_ids = [], set()
        for i, (record, named) in enumerate(zip(events['objects'], source_objects)):
            local_id, sprite, movement, kind, hidden, script, facing, p0, p1, p2, range_x, range_z, x, z, y = record
            obj = {}
            if local_id == i and named['id'] not in seen_ids:
                obj['id'] = named['id']
                seen_ids.add(named['id'])
            else:
                obj['clone_id'] = local_id
            assert y % 0x10000 == 0, (bank, y)
            # trainers: the same trainer types by number, the trainer's script (its sight range is data[0], as in
            # HeartGold); people with a trainer type and another script stay plain people
            trainer_name = trainer(script) if TRAINER_SCRIPTS.start <= script < TRAINER_SCRIPTS.stop else None
            obj.update({
                'graphics_id': sprites.name(sprite),
                'movement_type': movement_types[movement] if movement < SAME_MOVEMENT_TYPES else OTHER_MOVEMENT,
                'trainer_type': trainer_types[kind] if trainer_name and kind else 'TRAINER_TYPE_NONE',
                'hidden_flag': flag(hidden, names, platinum_local),
                'script': trainer_name or script_of(script),
                'initial_dir': facing,
                'data': [p0, p1, p2],
                'movement_range_x': range_x,
                'movement_range_z': range_z,
                'x': x,
                'z': z,
                'y': y // 0x10000,
            })
            if trainer_name and script >= 5000:
                obj['double_battle_id'] = 2
            object_events.append(obj)
        warp_events = [{'x': x, 'z': z, 'dest_header_id': header_names[header] if header != DYNAMIC else 'MAP_HEADER_DYNAMIC',
                        'dest_warp_id': anchor}
                       for x, z, header, anchor, _ in events['warps']]
        # Step-on triggers start scripted scenes: only where the map's scripts are translated.
        coord_events = [{'script': script, 'x': x, 'z': z, 'width': width, 'length': length, 'y': y, 'value': value,
                         'var': var(var_id)}
                        for script, x, z, width, length, y, value, var_id in events['coords']] if own_scripts else []
        with open(os.path.join(DECOMP, f'res/field/events/events_hgss_{bank:03d}.json'), 'w') as out:
            json.dump({'bg_events': bg_events, 'object_events': object_events, 'warp_events': warp_events,
                       'coord_events': coord_events}, out, indent=4)
            out.write('\n')
        totals['bg_events'] += len(bg_events)
        totals['object_events'] += len(object_events)
        totals['warp_events'] += len(warp_events)
        totals['coord_events'] += len(coord_events)
        totals['coords left out'] += len(events['coords']) - len(coord_events)

    # HeartGold's flags by name, before VARS_START (which sets its own value, so the numbering after it holds).
    block = [f'{name} = {number}' for number, name in sorted(names.items())]
    def change(text):
        text = re.sub(rf'# {re.escape(MARK)}\n.*?# {re.escape(MARK_END)}\n', '', text, flags=re.S)
        body = f'# {MARK}\n' + ''.join(f'{line}\n' for line in block) + f'# {MARK_END}\n'
        assert '\nVARS_START = 16384\n' in text
        return text.replace('\nVARS_START = 16384\n', '\n' + body + 'VARS_START = 16384\n', 1)
    edit('generated/vars_flags.txt', change)

    # HeartGold's saved vars by name (0x4030 on are VAR_COMPLETE_000 on), between VARS_END and
    # SCRIPT_LOCAL_VARS_START, which sets its own value: aliases there leave every number around them as it was.
    hg_vars = defines('include/constants/vars.h', 'VAR_')
    var_block = [f'VAR_HGSS_{name[len("VAR_"):]} = VAR_COMPLETE_{n - HG_SAVED_VARS_START:03X}'
                 for name, n in sorted(hg_vars.items(), key=lambda item: item[1])
                 if HG_SAVED_VARS_START <= n < HG_SAVED_VARS_START + 0x200]
    var_block += [f'VAR_HGSS_{sacred_gold.var_name(n)[len("VAR_"):]} = VAR_COMPLETE_{sacred_gold.engine_var_slot(n):03X}'
                  for n in sacred_gold.SG_VARS]  # Sacred Gold's own, after HeartGold's

    def change_vars(text):
        text = re.sub(rf'# {re.escape(VAR_MARK)}\n.*?# {re.escape(VAR_MARK_END)}\n', '', text, flags=re.S)
        body = f'# {VAR_MARK}\n' + ''.join(f'{line}\n' for line in var_block) + f'# {VAR_MARK_END}\n'
        assert '\nVARS_END\nSCRIPT_LOCAL_VARS_START = 32768\n' in text
        return text.replace('\nVARS_END\n', '\nVARS_END\n' + body, 1)
    edit('generated/vars_flags.txt', change_vars)

    print(f'{len(banks)} events files: ' + ', '.join(f'{v} {k}' for k, v in totals.items()) +
          f'; {len(block)} flag names, {len(var_block)} var names')
    if sprites.unmatched:
        print(f'sprites with the fallback stand-in ({SPRITE_FALLBACK}): ' + ' '.join(sorted(sprites.unmatched)))


if __name__ == '__main__':
    main()
