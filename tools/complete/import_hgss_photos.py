#!/usr/bin/env python3
"""Bring in what HeartGold's photo album needs (Cameron the photographer's photos, the album, the photo viewer;
src/complete_photo.c, src/applications/complete_photo_album/), packed into one archive,
decomp/res/prebuilt/graphic/complete_photo_album/photo_album.narc (NARC_INDEX_GRAPHIC__COMPLETE__PHOTO_ALBUM):

| members | from HeartGold                                                                            |
|---------|-------------------------------------------------------------------------------------------|
| 0-12    | the album's and the viewer's graphics (a/1/7/1, member n is member n), as they are        |
| 13-15   | the camera's viewfinder (graphic/camera_viewfinder: palette, tiles, screen; compressed)   |
| 16      | the photo spots (data/photo_data), 16 bytes each, below                                   |

A photo spot, as HeartGold's PhotoData, with the engine's numbers: u16 map header (MAP_HEADER_HGSS_*), u16 the
album's icon for it, u16 x, u16 z (the map's tiles; Johto's and Kanto's maps keep HeartGold's coordinates), u16 the
person in the photo (an OBJ_EVENT_GFX_* from data/complete/hgss_sprites.json, 0 for a photo of the party), u16 x2 the
building models hidden for the shot (HeartGold's model numbers, moved to the engine's: outdoor 590 + n, indoor
930 + n, as tools/complete/import_hgss_maps.py moves them), u16 0.

The album's text is HeartGold's message bank 0 (tools/complete/import_hgss_text.py brings it in).

Usage, after tools/complete/build_heartgold.sh and a build of decomp (for the map header and graphics IDs):
    python3 tools/complete/import_hgss_photos.py
"""
import json
import os
import re
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, PROP_MODEL_INDOOR_BASE, PROP_MODEL_OUTDOOR_BASE, hg_map_headers, hg_narc  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402

ROOT = os.path.dirname(DECOMP)
ALBUM = 'a/1/7/1'
VIEWFINDER = os.path.join(HG, 'build', 'heartgold.us', 'files', 'graphic', 'camera_viewfinder.narc')
SPOTS = os.path.join(HG, 'files', 'data', 'photo_data.json')
OUT = os.path.join(DECOMP, 'res', 'prebuilt', 'graphic', 'complete_photo_album')
MEMBER_VIEWFINDER, MEMBER_SPOTS = 13, 16


def defines(name):
    """NAME -> value from a generated constants header of the release build (build/generated/NAME.h)."""
    ids = {}
    for line in open(os.path.join(DECOMP, 'build', 'generated', name + '.h'), encoding='utf-8'):
        m = re.match(r'#define (\w+)\s+(\d+)\s*$', line)
        if m:
            ids[m.group(1)] = int(m.group(2))
    return ids


def hg_map_ids():
    ids = {}
    for line in open(os.path.join(HG, 'include', 'constants', 'maps.h')):
        m = re.match(r'#define (MAP_\w+)\s+(\d+)', line)
        if m:
            ids[m.group(1)] = int(m.group(2))
    return ids


def outdoor_maps():
    """HeartGold's map ID -> whether its area is outdoor (its buildings are outdoor models)."""
    areas = [bool(struct.unpack('<3HBB', rec)[3]) for rec in hg_narc('a/0/4/2')]
    return {map_id: areas[area] for map_id, area, _ in hg_map_headers()}


def main():
    headers = defines('map_headers')
    sprites = json.load(open(os.path.join(ROOT, 'data', 'complete', 'hgss_sprites.json')))['sprites']
    gfx = defines('object_events_gfx')
    hg_ids = hg_map_ids()
    outdoor = outdoor_maps()
    spots = json.load(open(SPOTS))['photos']
    table = b''
    for spot in spots:
        header = 'MAP_HEADER_HGSS_' + spot['map'][len('MAP_'):]
        subject = 0
        if spot['subject']:
            name = sprites[spot['subject'][len('SPRITE_'):]]
            subject = gfx[name]
        base = PROP_MODEL_OUTDOOR_BASE if outdoor[hg_ids[spot['map']]] else PROP_MODEL_INDOOR_BASE
        hidden = [base + model if model else 0 for model in spot['param']]
        table += struct.pack('<8H', headers[header], spot['icon'], spot['x'], spot['y'], subject, *hidden, 0)
    members = read_narc(os.path.join(HG, 'files', ALBUM))
    assert len(members) == MEMBER_VIEWFINDER, len(members)
    members += read_narc(VIEWFINDER)
    assert len(members) == MEMBER_SPOTS, len(members)
    members.append(table)
    os.makedirs(OUT, exist_ok=True)
    write_narc(os.path.join(OUT, 'photo_album.narc'), members)
    with open(os.path.join(OUT, 'meson.build'), 'w', encoding='utf-8') as f:
        f.write("# Sovereign Complete: HeartGold's photo album, viewer, viewfinder and photo spots\n"
                "# (tools/complete/import_hgss_photos.py, src/complete_photo.c)\n"
                "nitrofs_files += fs.copyfile('photo_album.narc')\n")
    print(f'photo_album.narc: {len(members)} members, {len(spots)} photo spots')


if __name__ == '__main__':
    main()
