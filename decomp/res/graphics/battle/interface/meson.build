battle_sprites += [
  nclr_gen.process(
    files('shared.pal'),
    preserve_path_from: base_directory,
    extra_args: [
      '-nopad', '-invertsize', '-pcmp', '-bitdepth', '4',
      '-num_colors', '112',
    ],
  ),

  nclr_gen.process(
    files(
      'cursor.png',
      'level_up.pal',
      'top_stock.png',
    ),
    preserve_path_from: base_directory,
    extra_args: [ '-nopad', '-invertsize', '-pcmp', '-bitdepth', '4' ],
  ),

  ncgr_cell_lz_gen.process(
    files(
      'stock_enemy.png',
      'stock_player.png',
      'cursor.png',
    ),
    preserve_path_from: base_directory,
    extra_args: [ '-bitdepth', '4', '-clobbersize' ],
  ),

  ncgr_cell_lz_gen.process(
    files('level_up.png', 'top_stock.png'),
    preserve_path_from: base_directory,
    extra_args: [ '-bitdepth', '4', '-clobbersize', '-mappingtype', '64' ],
  ),

  ncer_lz_gen.process(
    files(
      'stock_enemy_cell.json',
      'stock_player_cell.json',
      'cursor_cell.json',
      'level_up_cell.json',
      'top_stock_cell.json',
    ),
    preserve_path_from: base_directory,
  ),

  nanr_lz_gen.process(
    files(
      'stock_anim.json',
      'cursor_anim.json',
      'top_stock_anim.json',
    ),
    preserve_path_from: base_directory,
  ),

  # Sovereign (E8): the move menu's MEGA EVOLUTION button (tools/sprites/make_mega_button.py).
  nclr_gen.process(
    files('mega_button.png'),
    preserve_path_from: base_directory,
    extra_args: [ '-nopad', '-invertsize', '-pcmp', '-bitdepth', '4' ],
  ),

  ncgr_lz_gen.process(
    files('mega_button.png'),
    preserve_path_from: base_directory,
    extra_args: [ '-bitdepth', '4', '-clobbersize' ],
  ),

  ncer_lz_gen.process(
    files('mega_button_cell.json'),
    preserve_path_from: base_directory,
  ),

  nanr_lz_gen.process(
    files('mega_button_anim.json'),
    preserve_path_from: base_directory,
  ),
]

# Sovereign Complete: HeartGold's bug net and Sport Ball over the Bug-Catching Contest's battle menu, and its
# bottom-screen sprite palettes, which the contest's battles load
# (tools/complete/import_hgss_balls.py; src/battle/battle_subscreen.c)
battle_sprites += [
  lz_gen.process(
    files('hgss/contest_net.NCGR', 'hgss/contest_net_cell.NCER', 'hgss/contest_net_anim.NANR'),
    preserve_path_from: base_directory,
  ),
  copy_gen.process(files('hgss/contest_menu.NCLR'), preserve_path_from: base_directory),
]
