#!/usr/bin/env python3
"""Decode a 16-colour Nitro texture file (.nsbtx, BTX0) to indexed PNGs.

Writes one vertical strip per palette: the textures top to bottom in frame order (by the number after the last dot of
each texture's name), coloured with that palette. HeartGold's walking sprites have two palettes, normal and shiny.

Usage: python3 tools/complete/nsbtx_to_png.py FILE.nsbtx OUT_PREFIX   (writes OUT_PREFIX.<palette>.png)
"""
import struct
import sys

from PIL import Image

sys.path.insert(0, __file__.rsplit('/', 1)[0])
from nsbtx_info import read_dict  # noqa: E402


def bgr555(value):
    r, g, b = value & 31, (value >> 5) & 31, (value >> 10) & 31
    return (r << 3 | r >> 2, g << 3 | g >> 2, b << 3 | b >> 2)


def decode(path):
    """Return ([(frame name, width, height, 4bpp pixel indices)], {palette name: [16 RGB]})."""
    data = open(path, 'rb').read()
    tex0 = struct.unpack_from('<I', data, 0x10)[0]
    tex_dict = tex0 + struct.unpack_from('<H', data, tex0 + 0x0E)[0]
    tex_data = tex0 + struct.unpack_from('<I', data, tex0 + 0x14)[0]
    pal_dict = tex0 + struct.unpack_from('<I', data, tex0 + 0x34)[0]
    pal_data = tex0 + struct.unpack_from('<I', data, tex0 + 0x38)[0]

    frames = []
    for name, entry in read_dict(data, tex_dict, 8):
        param = struct.unpack_from('<I', entry)[0]
        width, height, fmt = 8 << ((param >> 20) & 7), 8 << ((param >> 23) & 7), (param >> 26) & 7
        assert fmt == 3, f'{path}: {name} is not a 16-colour texture'
        start = tex_data + (param & 0xFFFF) * 8
        raw = data[start:start + width * height // 2]
        pixels = [n for byte in raw for n in (byte & 15, byte >> 4)]
        frames.append((name, width, height, pixels))
    frames.sort(key=lambda f: int(f[0].rsplit('.', 1)[1]))

    palettes = {}
    for name, entry in read_dict(data, pal_dict, 4):
        start = pal_data + struct.unpack_from('<H', entry)[0] * 8
        palettes[name] = [bgr555(v) for v in struct.unpack_from('<16H', data, start)]
    return frames, palettes


def main():
    path, prefix = sys.argv[1], sys.argv[2]
    frames, palettes = decode(path)
    width, height = frames[0][1], frames[0][2]
    for pal_name, colours in palettes.items():
        strip = Image.new('P', (width, height * len(frames)))
        strip.putpalette([c for rgb in colours for c in rgb])
        for i, (_, w, h, pixels) in enumerate(frames):
            frame = Image.new('P', (w, h))
            frame.putdata(pixels)
            strip.paste(frame, (0, i * height))
        out = f'{prefix}.{pal_name}.png'
        strip.save(out, transparency=0)
        print(f'{out}: {len(frames)} frames of {width}x{height}: ' + ', '.join(f[0] for f in frames))


if __name__ == '__main__':
    main()
