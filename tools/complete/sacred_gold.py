"""Where Sacred Gold's own flags and vars go in the engine's save (docs/ScriptConversion.md, "Sacred Gold's versions").

Sacred Gold sets flags and vars past HeartGold's (its flags 0x3F54-0x3FFF, vars 0x612E-0x61A9, used by its scripts,
its people's hide flags and its step-on triggers). HeartGold doesn't check the range in its release build, so they
land in save space HeartGold leaves unused. Here they get real places after HeartGold's: flags from
SG_FLAGS_ENGINE_START (HeartGold's flag f is 2912 + f, up to 5823) and vars from VAR_COMPLETE_140 (HeartGold's saved
vars are VAR_COMPLETE_000-13F). The tools name them FLAG_SG_3F54 and VAR_SG_612E in HeartGold's language, and
FLAG_HGSS_SG_3F54 and VAR_HGSS_SG_612E in the engine's.
"""

SG_FLAGS = range(0x3F00, 0x4000)
SG_FLAGS_ENGINE_START = 2912 + 2912  # after HeartGold's flags (COMPLETE_FLAGS_START + f), within NUM_FLAGS 7008
SG_VARS = range(0x6100, 0x61C0)
SG_VARS_COMPLETE_START = 0x140  # after HeartGold's saved vars (0x4030-0x416F are VAR_COMPLETE_000-13F); to 1FF


def flag_name(n):
    """Sacred Gold's flag n in HeartGold's language."""
    return f'FLAG_SG_{n:04X}'


def var_name(n):
    return f'VAR_SG_{n:04X}'


def engine_flag(n):
    return SG_FLAGS_ENGINE_START + n - SG_FLAGS.start


def engine_var_slot(n):
    """The VAR_COMPLETE_ slot (0x140-0x1FF) for Sacred Gold's var n."""
    return SG_VARS_COMPLETE_START + n - SG_VARS.start


# Sacred Gold's own items, in the numbers of HeartGold items it doesn't use (the Journal, Seal Bag, Works Key, Old
# Charm, Member Card and Secret Key): evolution items, used like a stone (tools/complete/import_hgss_items.py)
SG_ITEMS = {433: 'ITEM_WOODLAND_ORE', 436: 'ITEM_SERENADE_ORB', 438: 'ITEM_AUBADE_ORB', 439: 'ITEM_CHILLED_ORE',
            454: 'ITEM_VOLTAIC_ORE', 467: 'ITEM_COVENANT_ORB'}
COVENANT_ORB_DATA = 444  # its item data file (a/0/1/7), HeartGold's Secret Key's
USE_EVO_STONE = 20  # HeartGold's field use for evolution stones


def rom_items(rom_path):
    """SG_ITEMS if the ROM is Sacred Gold's (its Covenant Orb is used like a stone), else {}: the names to give those
    item numbers in its scripts."""
    import ndspy.narc
    import ndspy.rom
    data = ndspy.narc.NARC(ndspy.rom.NintendoDSRom.fromFile(rom_path).getFileByName('a/0/1/7')).files
    return dict(SG_ITEMS) if data[COVENANT_ORB_DATA][10] == USE_EVO_STONE else {}
