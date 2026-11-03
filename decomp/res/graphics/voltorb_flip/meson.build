# Sovereign Complete: HeartGold's Voltorb Flip graphics (its files/application/voltorb_flip, built the same way but
# uncompressed), for src/applications/complete_voltorb_flip/. Its first two palettes were compressed (PMCP), which
# Platinum's loaders don't unpack; they're the same colours as plain palettes here.

voltorb_flip_ncgr_sopc = ncgr_gen.process(
    files(
        'voltorb_flip_00000002.png',
        'voltorb_flip_00000003.png',
    ),
    extra_args: ['-version101', '-sopc'],
)

voltorb_flip_ncgr_clobber = ncgr_gen.process(
    files(
        'voltorb_flip_00000011.png',
        'voltorb_flip_00000015.png',
    ),
    extra_args: ['-clobbersize', '-version101'],
)

voltorb_flip_nclr = nclr_gen.process(
    files(
        'voltorb_flip_00000000.pal',
        'voltorb_flip_00000001.pal',
    ),
    extra_args: ['-bitdepth', '4', '-nopad'],
)

# HeartGold's select-box buttons (its data/sbox_gra), for the touch list menus
# (src/applications/complete_voltorb_flip/touchscreen_list_menu.c)
voltorb_flip_sbox_ncgr = ncgr_gen.process(files('sbox_gra.png'), extra_args: ['-version101', '-sopc'])
voltorb_flip_sbox_nclr = nclr_gen.process(files('sbox_gra.png'), extra_args: ['-bitdepth', '4', '-nopad'])

voltorb_flip_copies = copy_gen.process(files(
    'voltorb_flip_00000004.NSCR',
    'voltorb_flip_00000005.NSCR',
    'voltorb_flip_00000006.NSCR',
    'voltorb_flip_00000007.NSCR',
    'voltorb_flip_00000008.NSCR',
    'voltorb_flip_00000009.NSCR',
    'voltorb_flip_00000010.NCLR',
    'voltorb_flip_00000012.NCER',
    'voltorb_flip_00000013.NANR',
    'voltorb_flip_00000014.NCLR',
    'voltorb_flip_00000016.NCER',
    'voltorb_flip_00000017.NANR',
))

voltorb_flip_narc = custom_target('voltorb_flip.narc',
    output: [
        'voltorb_flip.narc',
        'voltorb_flip.naix',
    ],
    input: [
        voltorb_flip_ncgr_sopc,
        voltorb_flip_ncgr_clobber,
        voltorb_flip_nclr,
        voltorb_flip_sbox_ncgr,
        voltorb_flip_sbox_nclr,
        voltorb_flip_copies,
    ],
    command: [
        nitroarc_exe,
        '--create',
        '--index',
        '--files-from', files('voltorb_flip.order'),
        '--file', '@OUTPUT0@',
        '@PRIVATE_DIR@',
    ],
)

nitrofs_files += voltorb_flip_narc
naix_headers += voltorb_flip_narc[1]
