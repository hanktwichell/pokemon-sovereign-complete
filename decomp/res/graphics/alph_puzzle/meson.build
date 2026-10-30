# Sovereign Complete: HeartGold's Ruins of Alph puzzle graphics (its files/application/annon/puzzle_gra, built the
# same way), for src/applications/complete_alph_puzzle.c

alph_puzzle_ncgr_clobber = ncgr_gen.process(
    files(
        'puzzle_gra_00000001.png',
        'puzzle_gra_00000004.png',
        'puzzle_gra_00000005.png',
        'puzzle_gra_00000006.png',
        'puzzle_gra_00000007.png',
    ),
    extra_args: ['-clobbersize', '-version101'],
)

alph_puzzle_ncgr_sopc = ncgr_gen.process(
    files('puzzle_gra_00000011.png'),
    extra_args: ['-version101', '-sopc'],
)

alph_puzzle_nclr = nclr_gen.process(
    files(
        'puzzle_gra_00000000.pal',
        'puzzle_gra_00000010.pal',
    ),
    extra_args: ['-bitdepth', '4', '-nopad'], # HeartGold's also has -pcmp, which Platinum's loaders don't unpack
)

alph_puzzle_copies = copy_gen.process(files(
    'puzzle_gra_00000002.NCER',
    'puzzle_gra_00000003.NANR',
    'puzzle_gra_00000008.NCER',
    'puzzle_gra_00000009.NANR',
    'puzzle_gra_00000012.NSCR',
    'puzzle_gra_00000013.NSCR',
    'puzzle_gra_00000014.NSCR',
    'puzzle_gra_00000015.NSCR',
))

alph_puzzle_narc = custom_target('alph_puzzle.narc',
    output: [
        'alph_puzzle.narc',
        'alph_puzzle.naix',
    ],
    input: [
        alph_puzzle_ncgr_clobber,
        alph_puzzle_ncgr_sopc,
        alph_puzzle_nclr,
        alph_puzzle_copies,
    ],
    command: [
        nitroarc_exe,
        '--create',
        '--index',
        '--files-from', files('alph_puzzle.order'),
        '--file', '@OUTPUT0@',
        '@PRIVATE_DIR@',
    ],
)

nitrofs_files += alph_puzzle_narc
naix_headers += alph_puzzle_narc[1]
