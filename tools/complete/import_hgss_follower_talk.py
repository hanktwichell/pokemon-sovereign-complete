#!/usr/bin/env python3
"""Bring in what HeartGold's following Pokémon says and does when talked to (its Task_FollowMonInteract, in overlay 2):
four of its archives, packed into one for src/overlay006/complete_follower_talk.c.

HeartGold's archives (.cache/pokeheartgold/files; Sacred Gold leaves them as they are):
- a/2/2/0, the choices: member 0 holds the 70 that can happen anywhere, member mapsec + 1 the 30 of each place. Each is
  20 bytes: the conditions (the Pokémon's HP, status, mood, friendship, nature, type, held item; the tile it stands on,
  the time, the weather, people and hidden items nearby, the map, a flag; a percent chance) and the interaction it
  starts. HeartGold tries the first 12 general ones, then the place's 30, then the other 58.
- a/2/2/1, the 1,023 interactions, 52 bytes each: up to five steps (a motion, a message of text bank 265, a cry, an
  emote), then a yes or no with the interaction each answer leads to, a change to friendship and to the mood, and an
  accessory or a Shiny Leaf it finds.
- a/2/2/2, the 108 motions, ten 8-byte keyframes each (a facing, frames, a nudge in x, height and z, a cry).
- a/2/3/1, a byte per species (#1-493): the kind of Pokémon, which some choices ask for.
- From a/1/0/3, its field effects: the emote bubbles a step can show over the follower (its ov01_02203AB4): their
  model (member 130), each bubble's two frames (members 2 to 15, 32x32) and the frame sequence they all share (150).

The packed archive (decomp/res/prebuilt/fielddata/complete_follower_talk/follower_talk.narc) keeps HeartGold's layouts,
with what means something else in the engine translated: a choice's map (HeartGold's map n is MAP_HEADER_HGSS_EVERYWHERE
+ n), its flag (HeartGold's flag n is the engine's FLAG_HGSS_ one, 2912 + n) and its tile behaviour
(tools/complete/import_hgss_maps.py's table). Its members, in decomp/include/data/hgss_follower_talk.h: the species' kinds, the general choices, the places'
choices (by HeartGold's mapsec, which is the engine's location number for Johto, Kanto and the places both games share),
the interactions, the motions and the emotes' model, frames and sequence.

Usage: python3 tools/complete/import_hgss_follower_talk.py
"""
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from import_hgss_maps import DECOMP, HG, TRANSLATE as TILE_TRANSLATE  # noqa: E402
from narc import read_narc, write_narc  # noqa: E402
from import_hgss_events import HG_MAP_LOCAL_FLAGS, HG_NUM_FLAGS  # noqa: E402
from sacred_gold import SG_FLAGS, engine_flag  # noqa: E402

OUT = os.path.join(DECOMP, 'res/prebuilt/fielddata/complete_follower_talk/follower_talk.narc')
HEADER = os.path.join(DECOMP, 'include/data/hgss_follower_talk.h')
CHOICE_SIZE, INTERACTION_SIZE, MOTION_SIZE = 20, 52, 80
EMOTE_MODEL, EMOTE_FRAMES, EMOTE_SEQUENCE = 130, range(2, 16), 150  # in a/1/0/3 (HeartGold's ov01_02209544)


def our_flag(n):
    """The engine's number for HeartGold's flag n: FLAG_HGSS_ flags are HG_NUM_FLAGS + n, Sacred Gold's its own."""
    if n in SG_FLAGS:
        return engine_flag(n)
    assert n not in HG_MAP_LOCAL_FLAGS and n < HG_NUM_FLAGS, f'flag {n}'
    return HG_NUM_FLAGS + n


def map_header_base():
    names = [line.strip() for line in open(os.path.join(DECOMP, 'generated/map_headers.txt')) if line.strip()]
    return names.index('MAP_HEADER_HGSS_EVERYWHERE')


def translate_choice(b, base):
    b = bytearray(b)
    hg_map, tile, flag = struct.unpack_from('<HHH', b, 0xC)[0], struct.unpack_from('<H', b, 0xE)[0], \
        struct.unpack_from('<H', b, 0x12)[0]
    if hg_map:  # stored as the map + 1
        struct.pack_into('<H', b, 0xC, base + hg_map)
    if tile:
        struct.pack_into('<H', b, 0xE, TILE_TRANSLATE.get(tile, tile))
    if flag:
        struct.pack_into('<H', b, 0x12, our_flag(flag))
    return bytes(b)


def main():
    files = os.path.join(HG, 'files')
    choices = read_narc(os.path.join(files, 'a/2/2/0'))
    interactions = read_narc(os.path.join(files, 'a/2/2/1'))
    motions = read_narc(os.path.join(files, 'a/2/2/2'))
    kinds = read_narc(os.path.join(files, 'a/2/3/1'))[0]
    effects = read_narc(os.path.join(files, 'a/1/0/3'))
    emotes = [effects[EMOTE_MODEL]] + [effects[i] for i in EMOTE_FRAMES] + [effects[EMOTE_SEQUENCE]]
    assert all(effects[i] == effects[EMOTE_SEQUENCE] for i in range(EMOTE_SEQUENCE, EMOTE_SEQUENCE + len(EMOTE_FRAMES)))
    assert len(choices[0]) == 70 * CHOICE_SIZE and all(len(m) == 30 * CHOICE_SIZE for m in choices[1:])
    assert all(len(m) == INTERACTION_SIZE for m in interactions) and all(len(m) == MOTION_SIZE for m in motions)

    base = map_header_base()
    choices = [b''.join(translate_choice(m[i:i + CHOICE_SIZE], base) for i in range(0, len(m), CHOICE_SIZE))
               for m in choices]
    members = [kinds] + choices + interactions + motions + emotes
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    write_narc(OUT, members)

    places = len(choices) - 1
    lines = [
        '#ifndef POKEPLATINUM_DATA_HGSS_FOLLOWER_TALK_H',
        '#define POKEPLATINUM_DATA_HGSS_FOLLOWER_TALK_H',
        '',
        '// Generated by tools/complete/import_hgss_follower_talk.py: the members of',
        '// res/prebuilt/fielddata/complete_follower_talk/follower_talk.narc (NARC_INDEX_FIELDDATA__COMPLETE__FOLLOWER_TALK)',
        '',
        '#define FOLLOWER_TALK_MEMBER_KINDS        0',
        '#define FOLLOWER_TALK_MEMBER_GENERAL      1',
        '#define FOLLOWER_TALK_MEMBER_PLACES       2 // + HeartGold\'s mapsec',
        f'#define FOLLOWER_TALK_PLACES              {places}',
        f'#define FOLLOWER_TALK_MEMBER_INTERACTIONS {2 + places} // + the interaction - 1',
        f'#define FOLLOWER_TALK_INTERACTIONS        {len(interactions)}',
        f'#define FOLLOWER_TALK_MEMBER_MOTIONS      {2 + places + len(interactions)} // + the motion - 1',
        f'#define FOLLOWER_TALK_MOTIONS             {len(motions)}',
        f'#define FOLLOWER_TALK_MEMBER_EMOTE_MODEL  {2 + places + len(interactions) + len(motions)}',
        f'#define FOLLOWER_TALK_MEMBER_EMOTE_FRAMES {3 + places + len(interactions) + len(motions)} // + the emote - 1',
        f'#define FOLLOWER_TALK_EMOTES              {len(EMOTE_FRAMES)}',
        f'#define FOLLOWER_TALK_MEMBER_EMOTE_SEQUENCE {3 + places + len(interactions) + len(motions) + len(EMOTE_FRAMES)}',
        f'#define FOLLOWER_TALK_KINDS               {len(kinds)} // species #1 on',
        '',
        '#define FOLLOWER_TALK_GENERAL_CHOICES     70',
        '#define FOLLOWER_TALK_GENERAL_FIRST       12 // tried before the place\'s',
        '#define FOLLOWER_TALK_PLACE_CHOICES       30',
        '',
        '#endif // POKEPLATINUM_DATA_HGSS_FOLLOWER_TALK_H',
        '',
    ]
    open(HEADER, 'w').write('\n'.join(lines))
    print(f'{len(members)} members ({os.path.getsize(OUT)} bytes): {places} places, {len(interactions)} interactions, '
          f'{len(motions)} motions, {len(EMOTE_FRAMES)} emotes')


if __name__ == '__main__':
    main()
