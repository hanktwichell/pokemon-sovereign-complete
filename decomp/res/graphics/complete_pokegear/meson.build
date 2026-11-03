# Sovereign Complete: HeartGold's Pokégear graphics for the bottom screen's Pokégear
# (src/applications/complete_pokegear/), from tools/complete/import_hgss_pokegear_gfx.py, in HeartGold's six skins (each
# graphic's six in a row, the skin added to the first's index): the app bar, the phone's contact list frame, and their
# palettes (the phone's 0-13 and the app bar's 14-15); the map of Johto and Kanto, made 16-colour, with its tilemap and
# each skin's palettes; the player markers and the radio's cursor, and their palettes; the radio's screen and palettes;
# the settings' skins to choose from, its frame around the one chosen, and palettes

complete_pokegear_ncgr = ncgr_gen.process(
    files(
        'app_bar_0.png',
        'app_bar_1.png',
        'app_bar_2.png',
        'app_bar_3.png',
        'app_bar_4.png',
        'app_bar_5.png',
        'phone_0.png',
        'phone_1.png',
        'phone_2.png',
        'phone_3.png',
        'phone_4.png',
        'phone_5.png',
        'map.png',
        'marker.png',
        'radio_0.png',
        'radio_1.png',
        'radio_2.png',
        'radio_3.png',
        'radio_4.png',
        'radio_5.png',
        'config_0.png',
        'config_1.png',
        'config_2.png',
        'config_3.png',
        'config_4.png',
        'config_5.png',
    ),
    extra_args: ['-version101', '-sopc'],
)

complete_pokegear_nclr = nclr_gen.process(files(
    'pokegear_0.pal',
    'pokegear_1.pal',
    'pokegear_2.pal',
    'pokegear_3.pal',
    'pokegear_4.pal',
    'pokegear_5.pal',
    'map_0.pal',
    'map_1.pal',
    'map_2.pal',
    'map_3.pal',
    'map_4.pal',
    'map_5.pal',
    'marker.pal',
    'radio_0.pal',
    'radio_1.pal',
    'radio_2.pal',
    'radio_3.pal',
    'radio_4.pal',
    'radio_5.pal',
    'config_0.pal',
    'config_1.pal',
    'config_2.pal',
    'config_3.pal',
    'config_4.pal',
    'config_5.pal',
), extra_args: ['-bitdepth', '4', '-nopad'])

complete_pokegear_copies = copy_gen.process(files(
    'app_bar_0.NSCR',
    'app_bar_1.NSCR',
    'app_bar_2.NSCR',
    'app_bar_3.NSCR',
    'app_bar_4.NSCR',
    'app_bar_5.NSCR',
    'phone_0.NSCR',
    'phone_1.NSCR',
    'phone_2.NSCR',
    'phone_3.NSCR',
    'phone_4.NSCR',
    'phone_5.NSCR',
    'map_tilemap.bin',
    'radio_0.NSCR',
    'radio_1.NSCR',
    'radio_2.NSCR',
    'radio_3.NSCR',
    'radio_4.NSCR',
    'radio_5.NSCR',
    'config_0.NSCR',
    'config_1.NSCR',
    'config_2.NSCR',
    'config_3.NSCR',
    'config_4.NSCR',
    'config_5.NSCR',
    'config_frame_0.NSCR',
    'config_frame_1.NSCR',
    'config_frame_2.NSCR',
    'config_frame_3.NSCR',
    'config_frame_4.NSCR',
    'config_frame_5.NSCR',
))

complete_pokegear_narc = custom_target('complete_pokegear.narc',
    output: [
        'complete_pokegear.narc',
        'complete_pokegear.naix',
    ],
    input: [
        complete_pokegear_ncgr,
        complete_pokegear_nclr,
        complete_pokegear_copies,
    ],
    command: [
        nitroarc_exe,
        '--create',
        '--index',
        '--files-from', files('complete_pokegear.order'),
        '--file', '@OUTPUT0@',
        '@PRIVATE_DIR@',
    ],
)

nitrofs_files += complete_pokegear_narc
naix_headers += complete_pokegear_narc[1]
