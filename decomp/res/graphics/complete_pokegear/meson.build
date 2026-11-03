# Sovereign Complete: HeartGold's Pokégear graphics for the bottom screen's Pokégear
# (src/applications/complete_pokegear/), from tools/complete/import_hgss_pokegear_gfx.py: the app bar, the phone's
# contact list frame, and their palettes (the phone's 0-13 and the app bar's 14-15)

complete_pokegear_ncgr = ncgr_gen.process(
    files(
        'app_bar.png',
        'phone.png',
    ),
    extra_args: ['-version101', '-sopc'],
)

complete_pokegear_nclr = nclr_gen.process(files('pokegear.pal'), extra_args: ['-bitdepth', '4', '-nopad'])

complete_pokegear_copies = copy_gen.process(files(
    'app_bar.NSCR',
    'phone.NSCR',
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
