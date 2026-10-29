#!/usr/bin/env python3
"""List the textures and palettes in Nitro texture files (.nsbtx, BTX0).

Overworld sprites in both Platinum and HeartGold are BTX0 files: one texture per animation frame and one palette.
This prints each file's textures (name, size, colour format) and palettes, so a HeartGold sprite can be checked
against the layout Platinum's billboard models expect before it's added to field_sprites.

Usage: python3 tools/complete/nsbtx_info.py FILE.nsbtx [...]
"""
import struct
import sys

FORMATS = {1: 'A3I5', 2: '4-colour', 3: '16-colour', 4: '256-colour', 5: '4x4 compressed', 6: 'A5I3', 7: 'direct'}


def read_dict(data, off, entry_size):
    """A Nitro name dictionary: a 12-byte header and 4 bytes of search tree per entry, then the entry size, the
    entries, and 16-byte names."""
    count = data[off + 1]
    size_unit = struct.unpack_from('<H', data, off + 0x0C + count * 4)[0]
    assert size_unit == entry_size, 'unexpected dictionary entry size'
    entries_off = off + 0x10 + count * 4
    names_off = entries_off + count * entry_size
    out = []
    for i in range(count):
        entry = data[entries_off + i * entry_size:entries_off + (i + 1) * entry_size]
        name = data[names_off + i * 16:names_off + (i + 1) * 16].rstrip(b'\0').decode('ascii', 'replace')
        out.append((name, entry))
    return out


def info(path):
    data = open(path, 'rb').read()
    assert data[:4] == b'BTX0', f'{path}: not a BTX0 file'
    tex0 = struct.unpack_from('<I', data, 0x10)[0]
    assert data[tex0:tex0 + 4] == b'TEX0', f'{path}: no TEX0 block'
    tex_dict = tex0 + struct.unpack_from('<H', data, tex0 + 0x0E)[0]
    pal_dict = tex0 + struct.unpack_from('<I', data, tex0 + 0x34)[0]
    textures = []
    for name, entry in read_dict(data, tex_dict, 8):
        param = struct.unpack_from('<I', entry)[0]
        width = 8 << ((param >> 20) & 7)
        height = 8 << ((param >> 23) & 7)
        textures.append((name, width, height, FORMATS.get((param >> 26) & 7, '?')))
    palettes = [name for name, _ in read_dict(data, pal_dict, 4)]
    return textures, palettes


def main():
    for path in sys.argv[1:]:
        textures, palettes = info(path)
        sizes = sorted({(w, h, f) for _, w, h, f in textures})
        print(f'{path}: {len(textures)} textures, {len(palettes)} palettes')
        for w, h, f in sizes:
            print(f'  {w}x{h} {f}')
        print('  textures: ' + ', '.join(name for name, *_ in textures))
        print('  palettes: ' + ', '.join(palettes))


if __name__ == '__main__':
    main()
