#!/usr/bin/env python3
"""The Totems standing at the Totem trials, drawn as overworld Pokémon (the owner, Nov 6, 2026: like the game's
other overworld Pokémon, Dialga, Palkia or Uxie, not shrunk battle sprites, and still large to show their size).

Sovereign's tools/sprites/make_totem_overworld.py shrinks each Totem form's battle sprite into one 64x64 frame. Here
each is the species' overworld sprite from pokeemerald-expansion (graphics/pokemon/<species>/overworld.png, its
follower sprites, drawn in the DS games' overworld style; the Alolan forms' from alola/), its first frame (facing
down), doubled to 64x64 so the Totem stands twice a Pokémon's size, standing on the bottom edge, with Sovereign's
one-pixel orange outline for the Totem aura. Same file format as Sovereign's: one 64x64 frame, 4-bit, index 0 the
transparent colour (Regigigas's), index 1 the aura, then the art's colours. It overwrites Sovereign's files,
decomp/res/graphics/field_sprites/pokemon/totem_<species>.png; rerun it if a sync brings Sovereign's back.

The sprites are fetched once into .cache/expansion_overworld/.

Usage: python3 tools/complete/make_totem_overworld.py [--preview OUT.png]
"""
import io
import os
import sys
import urllib.request

from PIL import Image, ImageFilter

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
OUT_DIR = os.path.join(ROOT, 'decomp', 'res', 'graphics', 'field_sprites', 'pokemon')
CACHE = os.path.join(ROOT, '.cache', 'expansion_overworld')
URL = 'https://raw.githubusercontent.com/rh-hideout/pokeemerald-expansion/master/graphics/pokemon/{}/overworld.png'
SIZE = 64
SCALE = 2
TRANSPARENT = (66, 107, 165)  # Regigigas's transparent colour, as Sovereign's
AURA = (255, 140, 40)
ART_COLOURS = 14  # + the aura and the transparent colour = 16

# Each Totem (Sovereign's TOTEMS) and its overworld sprite in pokeemerald-expansion
TOTEMS = {
    'gumshoos': 'gumshoos',
    'ribombee': 'ribombee',
    'vikavolt': 'vikavolt',
    'mimikyu': 'mimikyu',  # its disguise, the Totem's form
    'marowak': 'marowak/alola',
    'raticate': 'raticate/alola',
    'lurantis': 'lurantis',
    'araquanid': 'araquanid',
    'salazzle': 'salazzle',
    'kommo_o': 'kommo_o',
    'togedemaru': 'togedemaru',
}


def load(path):
    local = os.path.join(CACHE, path.replace('/', '_') + '.png')
    if not os.path.exists(local):
        os.makedirs(CACHE, exist_ok=True)
        with urllib.request.urlopen(URL.format(path), timeout=30) as response:
            open(local, 'wb').write(response.read())
    return Image.open(local)


def first_frame(sheet):
    """The sheet's first frame (frames are square, as tall as the sheet), as RGBA with its transparent colour clear."""
    size = sheet.height
    frame = sheet.crop((0, 0, size, size))
    if frame.mode == 'P':
        transparent = frame.info.get('transparency', 0)
        rgba = frame.convert('RGBA')
        alpha = Image.new('L', frame.size, 0)
        for y in range(size):
            for x in range(size):
                if frame.getpixel((x, y)) != transparent:
                    alpha.putpixel((x, y), 255)
        rgba.putalpha(alpha)
        return rgba
    return frame.convert('RGBA')


def totem(sheet):
    art = first_frame(sheet)
    art = art.crop(art.getbbox())
    art = art.resize((art.width * SCALE, art.height * SCALE), Image.NEAREST)
    if art.width > SIZE - 2 or art.height > SIZE - 1:  # room for the aura on the sides and top
        scale = min((SIZE - 2) / art.width, (SIZE - 1) / art.height)
        art = art.resize((int(art.width * scale), int(art.height * scale)), Image.NEAREST)
    canvas = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    canvas.paste(art, ((SIZE - art.width) // 2, SIZE - art.height), art)

    opaque = canvas.getchannel('A').point(lambda a: 255 if a >= 128 else 0)
    outline = opaque.filter(ImageFilter.MaxFilter(3))
    rgb = Image.new('RGB', (SIZE, SIZE), TRANSPARENT)
    rgb.paste(canvas.convert('RGB'), (0, 0), opaque)
    colours = sorted({rgb.getpixel((x, y)) for y in range(SIZE) for x in range(SIZE) if opaque.getpixel((x, y))})
    if len(colours) > ART_COLOURS:  # the expansion's 15 colours: two merged, nearest first
        quantized = rgb.quantize(colors=ART_COLOURS + 1, method=Image.MEDIANCUT, dither=Image.NONE).convert('RGB')
        rgb = quantized
    out = Image.new('P', (SIZE, SIZE), 0)
    palette = list(TRANSPARENT) + list(AURA)
    index = {}
    for y in range(SIZE):
        for x in range(SIZE):
            if opaque.getpixel((x, y)):
                c = rgb.getpixel((x, y))
                if c not in index:
                    index[c] = 2 + len(index)
                    palette += list(c)
                out.putpixel((x, y), index[c])
            elif outline.getpixel((x, y)):
                out.putpixel((x, y), 1)
    if len(index) > ART_COLOURS:
        sys.exit(f'{len(index)} colours after the quantization')
    palette += [0, 0, 0] * (16 - len(palette) // 3)
    out.putpalette(palette)
    return out


def main():
    preview = sys.argv[sys.argv.index('--preview') + 1] if '--preview' in sys.argv else None
    made = []
    for species, path in TOTEMS.items():
        out = totem(load(path))
        out.save(os.path.join(OUT_DIR, f'totem_{species}.png'), bits=4)
        made.append((species, out))
    print(f'wrote {len(made)} Totem overworld sprites to {OUT_DIR}')
    if preview:  # each Totem beside Dialga, three times the size, on grass green
        dialga = Image.open(os.path.join(OUT_DIR, 'dialga.png')).convert('RGBA').crop((0, 0, 64, 64))
        tiles = [('dialga', dialga)] + [(s, o.convert('RGBA')) for s, o in made]
        sheet = Image.new('RGBA', (len(tiles) * 3 * (SIZE + 4), 3 * SIZE), (96, 160, 80, 255))
        for i, (_, im) in enumerate(tiles):
            data = im.getdata()
            im = im.copy()
            im.putdata([(0, 0, 0, 0) if p[:3] == TRANSPARENT else p for p in data])
            big = im.resize((3 * SIZE, 3 * SIZE), Image.NEAREST)
            sheet.paste(big, (i * 3 * (SIZE + 4), 0), big)
        sheet.save(preview)


if __name__ == '__main__':
    main()
