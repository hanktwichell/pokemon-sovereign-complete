#!/usr/bin/env python3
"""Make a standalone test map from a HeartGold map, to check that its converted assets load and walk in the engine.

The map gets its own matrix (the HeartGold cells that belong to it, as land data 666 + block from
tools/complete/import_hgss_maps.py), its area (075 + HeartGold's area), an empty events file, Platinum's empty scripts,
no wild encounters, and a map header MAP_HEADER_COMPLETE_<NAME>. Music, the map label and the text bank are borrowed
from Twinleaf Town until Johto's own come in. Reach it with the test build's warp target (gSovereignTestWarpTarget;
tools/complete/test_map_warp.py).

Every insertion sits between "Sovereign Complete: test map <NAME>" markers, so a rerun replaces it.

Usage: python3 tools/complete/hgss_test_map.py HGSS_MAP ENGINE_NAME   (e.g. MAP_OLIVINE OLIVINE_CITY)
"""
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from hgss_matrix import read_matrix  # noqa: E402
from import_hgss_maps import AREA_BASE, HG, LAND_DATA_BASE, hg_map_headers  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
DECOMP = os.path.join(ROOT, 'decomp')


def hg_map_id(name):
    for line in open(os.path.join(HG, 'include/constants/maps.h')):
        m = re.match(rf'#define {name}\s+(\d+)', line)
        if m:
            return int(m.group(1))
    sys.exit(f'{name} is not a HeartGold map')


def edit(path, change):
    full = os.path.join(DECOMP, path)
    text = open(full).read()
    open(full, 'w').write(change(text))


def marked(text, block, before, mark, comment, indent=''):
    """Replace the block between this map's markers, or insert it before the last occurrence of `before`."""
    begin, end = f'{indent}{comment} Sovereign Complete: test map {mark}\n', f'{indent}{comment} end of test map {mark}\n'
    body = begin + ''.join(f'{indent}{line}\n' for line in block) + end
    pattern = re.compile(re.escape(begin) + '.*?' + re.escape(end), re.S)
    if pattern.search(text):
        return pattern.sub(lambda _: body, text, count=1)
    index = text.rfind(before)
    # A `before` starting with a newline marks the start of its own line: insert right there, after that newline.
    index = index + 1 if before.startswith('\n') else text.rfind('\n', 0, index) + 1
    return text[:index] + body + text[index:]


def after_last_entry(text, last, block, mark):
    """Insert block lines into a meson files() list after its last original entry (adding that entry's comma)."""
    begin, end = f'    # Sovereign Complete: test map {mark}\n', f'    # end of test map {mark}\n'
    text = re.sub(re.escape(begin) + '.*?' + re.escape(end), '', text, flags=re.S)
    start = text.index(last)
    line_end = text.index('\n', start)
    line = text[start:line_end].rstrip()
    line = line if line.endswith(',') else line + ','
    return text[:start] + line + '\n' + begin + ''.join(f"    '{b}',\n" for b in block) + end.rstrip('\n') + \
        text[line_end:]


def append_order(path, name):
    """Append name to an order file once, keeping the file's own line endings (some are CRLF)."""
    full = os.path.join(DECOMP, path)
    raw = open(full, 'rb').read().decode()
    newline = '\r\n' if '\r\n' in raw else '\n'
    lines = [line for line in raw.splitlines() if line and line != name]
    with open(full, 'w', newline='') as f:
        f.write(newline.join(lines + [name]) + newline)


def main():
    hg_name, name = sys.argv[1], sys.argv[2].upper()
    lower = name.lower()
    map_id = hg_map_id(hg_name)
    area, matrix_file = next((a, m) for i, a, m in hg_map_headers() if i == map_id)
    m = read_matrix(os.path.join(HG, 'files/fielddata/mapmatrix/map_matrix', matrix_file))
    cells = [i for i in range(m['width'] * m['height'])
             if m['maps'][i] != 0xFFFF and (not m['headers'] or m['headers'][i] == map_id)]
    xs, ys = [i % m['width'] for i in cells], [i // m['width'] for i in cells]
    rows = []
    for y in range(min(ys), max(ys) + 1):
        row = []
        for x in range(min(xs), max(xs) + 1):
            i = y * m['width'] + x
            row.append(f'MAP_{LAND_DATA_BASE + m["maps"][i]}' if i in cells else 'MAP_NONE')
        rows.append(row)

    matrix = f'map_matrix_complete_{lower}'
    events = f'events_complete_{lower}'
    header = f'MAP_HEADER_COMPLETE_{name}'
    with open(os.path.join(DECOMP, f'res/field/matrices/{matrix}.json'), 'w') as f:
        json.dump({'name': lower[:16], 'headers': [], 'altitudes': [], 'maps': rows}, f, indent=4)
        f.write('\n')
    with open(os.path.join(DECOMP, f'res/field/events/{events}.json'), 'w') as f:
        json.dump({'bg_events': [], 'object_events': [], 'warp_events': [], 'coord_events': []}, f, indent=4)
        f.write('\n')

    append_order('res/field/matrices/map_matrices.order', matrix)
    edit('res/field/matrices/meson.build', lambda t: after_last_entry(t, "'map_matrix_288.json'", [matrix + '.json'], name))
    append_order('res/field/events/zone_event.order', events)
    edit('res/field/events/meson.build', lambda t: after_last_entry(t, "'events_rock_peak_ruins.json'", [events + '.json'], name))
    edit('generated/map_headers.txt', lambda t: marked(t, [header], '\nMAP_HEADER_COUNT\n', name, '#'))
    entry = [
        f'[{header}] = {{',
        f'    .areaDataArchiveID = area_data_{AREA_BASE + area:03d},',
        '    .preloadedMapObjectsArchiveID = 0x0,',
        f'    .mapMatrixID = {matrix},',
        '    .scriptsArchiveID = scripts_empty,',
        '    .initScriptsArchiveID = scripts_init_empty,',
        '    .msgArchiveID = TEXT_BANK_TWINLEAF_TOWN,',
        '    .dayMusicID = SEQ_TOWN01_D_sseq,',
        '    .nightMusicID = SEQ_TOWN01_N_sseq,',
        '    .wildEncountersArchiveID = ENCOUNTERS_NONE,',
        f'    .eventsArchiveID = {events},',
        '    .mapLabelTextID = LocationNames_Text_TwinleafTown,',
        '    .mapLabelWindowID = MAP_LABEL_WINDOW_TOWN,',
        '    .weather = OVERWORLD_WEATHER_CLEAR,',
        '    .cameraType = CAMERA_TYPE_DEFAULT,',
        '    .mapType = MAP_TYPE_TOWN_CITY,',
        '    .battleBG = BACKGROUND_CITY,',
        '    .isBikeAllowed = TRUE,',
        '    .isRunningAllowed = TRUE,',
        '    .isEscapeRopeAllowed = FALSE,',
        '    .isFlyAllowed = TRUE,',
        '},',
    ]
    edit('include/data/map_headers.h', lambda t: marked(t, entry, '\n};', name, '//', indent='    '))
    print(f'{header}: {len(rows[0])}x{len(rows)} cells from {matrix_file} ({len(cells)} blocks), area_data_{AREA_BASE + area:03d}')


if __name__ == '__main__':
    main()
