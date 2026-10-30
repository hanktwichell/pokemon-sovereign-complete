#!/usr/bin/env python3
"""Read Nitro archives (NARC): the packed file lists both games keep much of their data in.

    from narc import read_narc, write_narc
    members = read_narc(path)   # list of bytes, in archive order
    write_narc(path, members)   # a NARC with no file names, each member padded to 4 bytes

Usage: python3 tools/complete/narc.py FILE.narc   (prints the member count and each member's size)
"""
import struct
import sys


def read_narc(path):
    data = open(path, 'rb').read()
    assert data[:4] == b'NARC', f'{path}: not a NARC'
    off = struct.unpack_from('<H', data, 0x0C)[0]  # header size
    blocks = struct.unpack_from('<H', data, 0x0E)[0]
    fat = None
    img = None
    for _ in range(blocks):
        magic, size = data[off:off + 4], struct.unpack_from('<I', data, off + 4)[0]
        if magic == b'BTAF':
            count = struct.unpack_from('<H', data, off + 8)[0]
            fat = [struct.unpack_from('<II', data, off + 12 + 8 * i) for i in range(count)]
        elif magic == b'GMIF':
            img = off + 8
        off += size
    assert fat is not None and img is not None, f'{path}: missing BTAF or GMIF'
    return [data[img + start:img + end] for start, end in fat]


def write_narc(path, members):
    fat, image = [], bytearray()
    for member in members:
        fat.append((len(image), len(image) + len(member)))
        image += member
        image += b'\xFF' * (-len(image) % 4)
    btaf = b'BTAF' + struct.pack('<IHH', 12 + 8 * len(fat), len(fat), 0) + b''.join(struct.pack('<II', *f) for f in fat)
    btnf = b'BTNF' + struct.pack('<IIHH', 16, 4, 0, 1)
    gmif = b'GMIF' + struct.pack('<I', 8 + len(image)) + bytes(image)
    size = 16 + len(btaf) + len(btnf) + len(gmif)
    with open(path, 'wb') as f:
        f.write(b'NARC' + struct.pack('<HHIHH', 0xFFFE, 0x0100, size, 16, 3) + btaf + btnf + gmif)


def main():
    members = read_narc(sys.argv[1])
    print(f'{sys.argv[1]}: {len(members)} members')
    for i, m in enumerate(members):
        print(f'  {i:4d}: {len(m)} bytes')


if __name__ == '__main__':
    main()
