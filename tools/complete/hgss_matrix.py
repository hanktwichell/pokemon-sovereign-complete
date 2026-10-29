#!/usr/bin/env python3
"""Read HeartGold's map matrices (files/fielddata/mapmatrix/map_matrix/*.bin).

The binary is the same layout Platinum builds from its matrix JSON: u8 width, u8 height, u8 has-headers, u8
has-altitudes, u8 name length, the name, then (if present) a u16 map header ID per cell, a u8 altitude per cell, and a
u16 land data ID per cell (0xFFFF for an empty cell), row by row.

    from hgss_matrix import read_matrix
    m = read_matrix(path)   # dict: width, height, name, headers, altitudes, maps (lists, row by row)

Usage: python3 tools/complete/hgss_matrix.py FILE.bin [HEADER_ID]   (prints the cells of that header, or a summary)
"""
import struct
import sys


def read_matrix(path):
    data = open(path, 'rb').read()
    width, height, has_headers, has_altitudes, name_len = data[0], data[1], data[2], data[3], data[4]
    off = 5
    name = data[off:off + name_len].decode('ascii', 'replace')
    off += name_len
    cells = width * height
    headers = list(struct.unpack_from(f'<{cells}H', data, off)) if has_headers else None
    off += 2 * cells if has_headers else 0
    altitudes = list(data[off:off + cells]) if has_altitudes else None
    off += cells if has_altitudes else 0
    maps = list(struct.unpack_from(f'<{cells}H', data, off))
    return {'width': width, 'height': height, 'name': name, 'headers': headers, 'altitudes': altitudes, 'maps': maps}


def main():
    m = read_matrix(sys.argv[1])
    print(f"{m['name']}: {m['width']}x{m['height']}, headers {'yes' if m['headers'] else 'no'}, "
          f"altitudes {'yes' if m['altitudes'] else 'no'}")
    if len(sys.argv) > 2 and m['headers']:
        want = int(sys.argv[2], 0)
        for i, h in enumerate(m['headers']):
            if h == want:
                x, y = i % m['width'], i // m['width']
                alt = m['altitudes'][i] if m['altitudes'] else None
                print(f'  cell ({x}, {y}): land data {m["maps"][i]}, altitude {alt}')


if __name__ == '__main__':
    main()
