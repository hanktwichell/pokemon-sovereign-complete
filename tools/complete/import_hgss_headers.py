#!/usr/bin/env python3
"""Bring in HeartGold's map headers and map matrices: every Johto and Kanto map gets a map header in the engine.

Run after tools/complete/import_hgss_maps.py (the land data and areas these name). From the HeartGold source
(.cache/pokeheartgold, HEARTGOLD_COMMIT), docs/MapConversion.md has the field-by-field mapping:

| HeartGold                                 | Engine                                                        |
|-------------------------------------------|---------------------------------------------------------------|
| map MAP_X (ID n, src/data/map_headers.h)  | MAP_HEADER_HGSS_X = MAP_HEADER_HGSS_EVERYWHERE + n            |
| matrix file map_matrix_NNNN_*.bin         | res/field/matrices/map_matrix_hgss_NNNN.json                  |
| events bank zone_event_NNN_*              | res/field/events/events_hgss_NNN.json (empty until converted) |
| location name n >= 126 (msg 279)          | location_names.json entry n (0-125 are Sinnoh's in both games) |
| followMode, region, world map, calls, radio | include/data/hgss_map_info.h (src/complete_map_info.c)      |

Values that differ between the games go through the tables below (weather, map type, cameras, battle backgrounds);
the name popup style and battle backgrounds have the same numbers in both. Until later steps bring them in, the maps
use Platinum's empty scripts, no wild encounters, and music standing in for HeartGold's by kind (STAND_IN_MUSIC).

Each insertion into an engine file sits between "Sovereign Complete: HeartGold map headers" markers, or for the
order files and location names is found by its own names, so a rerun replaces it.

Usage: python3 tools/complete/import_hgss_headers.py
"""
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from hgss_matrix import read_matrix  # noqa: E402
from import_hgss_maps import AREA_BASE, DECOMP, HG, LAND_DATA_BASE  # noqa: E402

MARK = 'Sovereign Complete: HeartGold map headers (tools/complete/import_hgss_headers.py)'
MARK_END = 'Sovereign Complete: end of HeartGold map headers'
SINNOH_LOCATIONS = 126  # location names 0-125 are the same in both games
SOVEREIGN_RENAMES = {55: 'Regional Forms Park'}  # Sovereign's own names for shared locations (HeartGold: Pal Park)

WEATHER = {
    0: 'OVERWORLD_WEATHER_CLEAR',
    1: 'OVERWORLD_WEATHER_RAINING',  # HeartGold's rain: Route 33, Lake of Rage
    5: 'OVERWORLD_WEATHER_SNOWING',  # Mt. Silver's summit, Sinjoh Ruins
    11: 'OVERWORLD_WEATHER_DARK_FLASH',  # caves that need Flash
    13: 'OVERWORLD_WEATHER_30',  # low light: Battle Arcade, as Platinum's Battle Arcade
}
MAP_TYPE = {
    'MAP_TYPE_INVALID': 'MAP_TYPE_NONE',
    'MAP_TYPE_CITY_TOWN': 'MAP_TYPE_TOWN_CITY',
    'MAP_TYPE_ROUTE': 'MAP_TYPE_OUTDOORS',
    'MAP_TYPE_CAVE': 'MAP_TYPE_CAVE',
    'MAP_TYPE_INTERIOR': 'MAP_TYPE_INDOORS',
    'MAP_TYPE_POKEMON_CENTER': 'MAP_TYPE_POKECENTER',
    'MAP_TYPE_UNDERGROUND': 'MAP_TYPE_NONE',  # HeartGold's leftover Underground map; not Platinum's Underground
}
# HeartGold's camera n is CAMERA_TYPE_HGSS_00 + n (include/constants/camera_types.h, src/overlay005/field_camera.c).
CAMERAS = ['DEFAULT', 'VIOLET_GYM', 'GOLDENROD_GYM', 'LIGHTHOUSE_ROOF', 'INTERIOR', 'AZALEA_GYM', 'UNUSED_6',
           'POKEATHLON_DOME', 'BATTLE_FRONTIER', 'VERMILION_GYM', 'WHIRL_ISLANDS_B3F', 'UNUSED_11', 'LUGIA_CAVE',
           'BELL_TOWER_ROOF', 'FUCHSIA_GYM', 'DANCE_THEATER', 'BATTLE_FACILITY']
# Same numbers in both games; HeartGold's Elite Four rooms use Sinnoh's in the same order until their own come in.
BATTLE_BG = ['PLAIN', 'WATER', 'CITY', 'FOREST', 'MOUNTAIN', 'SNOW', 'INDOORS_1', 'INDOORS_2', 'INDOORS_3', 'CAVE_1',
             'CAVE_2', 'CAVE_3', 'AARON', 'BERTHA', 'FLINT', 'LUCIAN', 'CYNTHIA', 'DISTORTION_WORLD', 'BATTLE_TOWER',
             'BATTLE_FACTORY', 'BATTLE_ARCADE', 'BATTLE_CASTLE', 'BATTLE_HALL']
LABEL_WINDOW = ['NONE', 'CITY', 'TOWN', 'ROUTE', 'CAVE', 'FOREST', 'WATER', 'PARK', 'LAKE', 'INDOORS']

# Platinum music standing in for HeartGold's until its sound archive comes in (step 6): (day, night).
STAND_IN_MUSIC = {
    'SEQ_GS_POKESEN': ('SEQ_PC_01',) * 2,
    'SEQ_GS_FS': ('SEQ_FS',) * 2,
    'SEQ_GS_GYM': ('SEQ_GYM',) * 2,
    'SEQ_GS_BATTLETOWER': ('SEQ_BF_TOWWER',) * 2,
    'SEQ_GS_BATTLETOWER2': ('SEQ_BF_TOWWER',) * 2,
    'SEQ_GS_BF_FACTORY': ('SEQ_PL_BF_FACTORY',) * 2,
    'SEQ_GS_BF_CASTLE': ('SEQ_PL_BF_CASTLE',) * 2,
    'SEQ_GS_BF_ROULETTE': ('SEQ_PL_BF_ROULETTE',) * 2,
    'SEQ_GS_BF_STAGE': ('SEQ_PL_BF_STAGE',) * 2,
    'SEQ_GS_WIFITOWER': ('SEQ_PL_WIFITOWER',) * 2,
    'SEQ_GS_GAME': ('SEQ_BLD_GAME',) * 2,
    'SEQ_GS_UTSUGI_RABO': ('SEQ_KENKYUJO',) * 2,
    'SEQ_GS_D_KOUEN': ('SEQ_D_KOUEN',) * 2,
    'SEQ_GS_D_AJITO': ('SEQ_D_AGITO',) * 2,
    'SEQ_GS_SAFARI_FIELD': ('SEQ_D_SAFARI',) * 2,
    'SEQ_GS_SAFARI_ROAD': ('SEQ_D_SAFARI',) * 2,
    'SEQ_GS_SAFARI_HOUSE': ('SEQ_D_SAFARI',) * 2,
    'SEQ_GS_CHAMPROAD': ('SEQ_D_LEAGUE',) * 2,
    'SEQ_GS_D_CHAMPROAD': ('SEQ_D_LEAGUE',) * 2,
    'SEQ_SILENCE_FIELD': ('SEQ_SILENCE_FIELD',) * 2,
    'SEQ_DUMMY': ('SEQ_DUMMY',) * 2,
}
STAND_IN_BY_PREFIX = [  # HeartGold's naming: C_ city, T_ town, R_ route, D_ dungeon, TO_ tower
    ('SEQ_GS_C_', ('SEQ_CITY01_D', 'SEQ_CITY01_N')),
    ('SEQ_GS_T_', ('SEQ_TOWN01_D', 'SEQ_TOWN01_N')),
    ('SEQ_GS_R_', ('SEQ_ROAD_A_D', 'SEQ_ROAD_A_N')),
    ('SEQ_GS_D_', ('SEQ_D_02',) * 2),
    ('SEQ_GS_TO_', ('SEQ_D_03',) * 2),
]
STAND_IN_BY_MAP_TYPE = {
    'MAP_TYPE_TOWN_CITY': ('SEQ_CITY01_D', 'SEQ_CITY01_N'),
    'MAP_TYPE_OUTDOORS': ('SEQ_ROAD_A_D', 'SEQ_ROAD_A_N'),
    'MAP_TYPE_CAVE': ('SEQ_D_02',) * 2,
}
DEFAULT_MUSIC = ('SEQ_TOWN01_D', 'SEQ_TOWN01_N')
PLACEHOLDER_TEXT_BANK = 'TEXT_BANK_JUBILIFE_CITY'  # Platinum's MAP_HEADER_EVERYWHERE's; the maps' own text is step 3


def stand_in_music(seq, map_type, night):
    pair = STAND_IN_MUSIC.get(seq)
    if pair is None:
        pair = next((p for prefix, p in STAND_IN_BY_PREFIX if seq.startswith(prefix)), None)
    if pair is None:
        pair = STAND_IN_BY_MAP_TYPE.get(map_type, DEFAULT_MUSIC)
    return pair[night] + '_sseq'


def defines(path, prefix):
    values = {}
    for line in open(os.path.join(HG, path)):
        m = re.match(rf'#define ({prefix}\w+)\s+(\d+)\b', line)
        if m:
            values[m.group(1)] = int(m.group(2))
    return values


def hg_headers():
    """HeartGold's map headers in map ID order: [(MAP_X, {field: value text})]."""
    ids = defines('include/constants/maps.h', 'MAP_')
    text = open(os.path.join(HG, 'src/data/map_headers.h')).read()
    headers = []
    for m in re.finditer(r'\[(MAP_\w+)\]\s*=\s*\{(.*?)\n\s*\}', text, re.S):
        fields = dict(re.findall(r'\.(\w+)\s*=\s*([^,\n]+),', m.group(2)))
        headers.append((ids[m.group(1)], m.group(1), fields))
    headers.sort()
    assert [i for i, _, _ in headers] == list(range(len(headers))), 'HeartGold map IDs are not 0..n-1'
    return [(name, fields) for _, name, fields in headers]


def camel(name):
    return ''.join(word.capitalize() if not word.isdigit() else word for word in name.lower().split('_'))


def between_markers(text, block, before, comment):
    """Replace the marked block, or insert it at the start of the line holding the last `before`."""
    begin, end = f'{comment} {MARK}\n', f'{comment} {MARK_END}\n'
    indent = re.match(r'\s*', before.lstrip('\n')).group(0)
    begin, end = indent + begin, indent + end
    body = begin + ''.join(f'{line}\n' for line in block) + end
    pattern = re.compile(re.escape(begin) + '.*?' + re.escape(end), re.S)
    if pattern.search(text):
        return pattern.sub(lambda _: body, text, count=1)
    index = text.rindex(before) + (1 if before.startswith('\n') else 0)
    return text[:index] + body + text[index:]


def edit(path, change):
    full = os.path.join(DECOMP, path)
    raw = open(full, newline='').read()
    open(full, 'w', newline='').write(change(raw))


def set_order(path, prefix, names):
    """Drop the order file's earlier `prefix` entries and append names, keeping its line endings."""
    full = os.path.join(DECOMP, path)
    raw = open(full, 'rb').read().decode()
    newline = '\r\n' if '\r\n' in raw else '\n'
    lines = [line for line in raw.splitlines() if line and not line.startswith(prefix)]
    with open(full, 'w', newline='') as f:
        f.write(newline.join(lines + names) + newline)


def set_meson(path, last_original, names):
    """Put names in a meson files() list after its last original entry, between markers."""
    def change(text):
        text = re.sub(rf',?\n    # {re.escape(MARK)}\n.*?    # {re.escape(MARK_END)}', '', text, flags=re.S)
        start = text.index(last_original)
        line_end = text.index('\n', start)
        line = text[start:line_end].rstrip().rstrip(',')
        block = f',\n    # {MARK}\n' + ''.join(f"    '{n}',\n" for n in names) + f'    # {MARK_END}'
        return text[:start] + line + block + text[line_end:]
    edit(path, change)


def location_names(mapsecs):
    """Append HeartGold's location names after Sinnoh's; return the text ID for every location number."""
    path = os.path.join(DECOMP, 'res/text/location_names.json')
    data = json.load(open(path, encoding='utf-8'))
    hg_names = json.load(open(os.path.join(HG, 'files/msgdata/msg/msg_0279.json'), encoding='utf-8'))['messages']
    by_number = {n: name for name, n in mapsecs.items()}
    ours = [{'id': 'LocationNames_Text_' + camel(by_number[n][len('MAPSEC_'):]), 'en_US': hg_names[n]['en_US']}
            for n in range(SINNOH_LOCATIONS, len(hg_names))]
    ids = {entry['id'] for entry in ours}
    sinnoh = [entry for entry in data['messages'] if entry['id'] not in ids]
    assert len(sinnoh) == SINNOH_LOCATIONS, f'location_names.json has {len(sinnoh)} entries before ours'
    for k in range(SINNOH_LOCATIONS):  # the shared numbers name the same places
        same = lambda a, b: a.replace('’', "'").upper() == b.replace('’', "'").upper()  # noqa: E731
        assert same(sinnoh[k]['en_US'], SOVEREIGN_RENAMES.get(k, hg_names[k]['en_US'])), k
    assert not ids & {entry['id'] for entry in sinnoh}, 'a HeartGold location name ID is already Sinnoh\'s'
    data['messages'] = sinnoh + ours
    with open(path, 'w', encoding='utf-8') as f:
        f.write(json.dumps(data, indent=2, ensure_ascii=False) + '\n')
    return [entry['id'] for entry in data['messages']]


def matrix_json(m, header_names):
    rows = lambda cells: [cells[y * m['width']:(y + 1) * m['width']] for y in range(m['height'])]  # noqa: E731
    return {
        'name': m['name'],
        'headers': rows([header_names[h] for h in m['headers']]) if m['headers'] else [],
        'altitudes': rows(m['altitudes']) if m['altitudes'] else [],
        'maps': rows(['MAP_NONE' if b == 0xFFFF else f'MAP_{LAND_DATA_BASE + b}' for b in m['maps']]),
    }


def main():
    headers = hg_headers()
    battle_h = open(os.path.join(HG, 'include/constants/battle.h')).read()
    hg_battle_bgs = re.findall(r'\b(BATTLE_BG_\w+),', battle_h[battle_h.index('typedef enum BattleBg'):])
    assert len(hg_battle_bgs) == len(BATTLE_BG), hg_battle_bgs
    header_names = [f'MAP_HEADER_HGSS_{name[len("MAP_"):]}' for name, _ in headers]
    mapsecs = defines('include/constants/map_sections.h', 'MAPSEC_')
    label_ids = location_names(mapsecs)

    # Matrices and events files, one per HeartGold file that a header uses.
    matrix_dir = os.path.join(HG, 'files/fielddata/mapmatrix/map_matrix')
    matrices, events = {}, {}
    for _, f in headers:
        hg_matrix = re.fullmatch(r'NARC_map_matrix_(map_matrix_(\d{4})\w*)_bin', f['matrixId'])
        matrices[hg_matrix.group(1) + '.bin'] = f'map_matrix_hgss_{hg_matrix.group(2)}'
        hg_events = re.fullmatch(r'NARC_zone_event_(\d{3})\w*_bin', f['eventsBank'])
        events[f['eventsBank']] = f'events_hgss_{hg_events.group(1)}'
    for hg_file, name in sorted(matrices.items(), key=lambda item: item[1]):
        m = read_matrix(os.path.join(matrix_dir, hg_file))
        assert m['width'] * m['height'] <= 900 and len(m['name']) <= 16, hg_file  # MAP_MATRIX_MAX_SIZE, name length
        with open(os.path.join(DECOMP, f'res/field/matrices/{name}.json'), 'w') as out:
            json.dump(matrix_json(m, header_names), out, indent=4)
            out.write('\n')
    matrix_names = sorted(set(matrices.values()))
    set_order('res/field/matrices/map_matrices.order', 'map_matrix_hgss_', matrix_names)
    set_meson('res/field/matrices/meson.build', "'map_matrix_288.json'", [n + '.json' for n in matrix_names])
    event_names = sorted(set(events.values()))
    for name in event_names:  # empty until the events converter fills them; never overwrite a converted one
        path = os.path.join(DECOMP, f'res/field/events/{name}.json')
        if not os.path.exists(path):
            with open(path, 'w') as out:
                json.dump({'bg_events': [], 'object_events': [], 'warp_events': [], 'coord_events': []}, out, indent=4)
                out.write('\n')
    set_order('res/field/events/zone_event.order', 'events_hgss_', event_names)
    set_meson('res/field/events/meson.build', "'events_rock_peak_ruins.json'", [n + '.json' for n in event_names])

    # Header IDs, before MAP_HEADER_COUNT, in HeartGold's order.
    edit('generated/map_headers.txt', lambda t: between_markers(t, header_names, '\nMAP_HEADER_COUNT\n', '#'))

    entries, info = [], []
    for (name, f), header in zip(headers, header_names):
        map_type = MAP_TYPE[f['mapType']]
        matrix = matrices[re.fullmatch(r'NARC_map_matrix_(\w+)_bin', f['matrixId']).group(1) + '.bin']
        entries += [
            f'    [{header}] = {{',
            f'        .areaDataArchiveID = area_data_{AREA_BASE + int(f["areaDataBank"]):03d},',
            '        .preloadedMapObjectsArchiveID = 0x0,',
            f'        .mapMatrixID = {matrix},',
            '        .scriptsArchiveID = scripts_empty,',
            '        .initScriptsArchiveID = scripts_init_empty,',
            f'        .msgArchiveID = {PLACEHOLDER_TEXT_BANK},',
            f'        .dayMusicID = {stand_in_music(f["dayMusicId"], map_type, 0)},',
            f'        .nightMusicID = {stand_in_music(f["nightMusicId"], map_type, 1)},',
            '        .wildEncountersArchiveID = ENCOUNTERS_NONE,',
            f'        .eventsArchiveID = {events[f["eventsBank"]]},',
            f'        .mapLabelTextID = {label_ids[mapsecs[f["mapsec"]]]},',
            f'        .mapLabelWindowID = MAP_LABEL_WINDOW_{LABEL_WINDOW[int(f["areaIcon"])]},',
            f'        .weather = {WEATHER[int(f["weather"])]},',
            f'        .cameraType = CAMERA_TYPE_HGSS_{CAMERAS[int(f["cameraType"])]},',
            f'        .mapType = {map_type},',
            f'        .battleBG = BACKGROUND_{BATTLE_BG[hg_battle_bgs.index(f["battleBg"])]},',
            f'        .isBikeAllowed = {f["bikeAllowed"]},',
            f'        .isRunningAllowed = {f["runningAllowed_Unused"]},',
            f'        .isEscapeRopeAllowed = {f["escapeRopeAllowed"]},',
            f'        .isFlyAllowed = {f["flyAllowed"]},',
            '    },',
        ]
        follow = f['followMode'].replace('MAP_FOLLOWMODE_', 'FOLLOW_MODE_')
        region = 'MAP_REGION_' + f['regionNo'].split('_')[-1]
        info.append(f'    [{header} - MAP_HEADER_HGSS_FIRST] = {{ {follow}, {region}, {f["worldMapX"]}, '
                    f'{f["worldMapY"]}, {f["momCallIntroParam"]}, {f["outgoingCalls"]}, {f["incomingCalls"]}, '
                    f'{f["radioSignal"]} }},')
    edit('include/data/map_headers.h', lambda t: between_markers(t, entries, '\n};', '    //'))

    with open(os.path.join(DECOMP, 'include/data/hgss_map_info.h'), 'w') as out:
        out.write('// Generated by tools/complete/import_hgss_headers.py from HeartGold\'s map headers; do not edit.\n')
        out.write('// followMode, region, worldMapX, worldMapY, momCallIntroParam, outgoingCalls, incomingCalls, '
                  'radioSignal\n')
        out.write('static const HGSSMapInfo sHGSSMapInfo[] = {\n' + '\n'.join(info) + '\n};\n')

    print(f'{len(headers)} map headers (MAP_HEADER_HGSS_*), {len(matrix_names)} matrices, {len(event_names)} events '
          f'files, {len(label_ids) - SINNOH_LOCATIONS} location names')



if __name__ == '__main__':
    main()
