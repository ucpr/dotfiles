return {
  {
    'cohama/lexima.vim',
    event = 'InsertEnter',
  },
  {
    'Shougo/context_filetype.vim',
  },
  {
    'simeji/winresizer',
    event = 'VimEnter',
  },
  {
    'kana/vim-smartword',
    event = 'VimEnter',
    config = function()
      vim.keymap.set("n", "w", "<Plug>(smartword-w)")
    end,
  },
  {
    'markonm/traces.vim',
    event = 'VimEnter',
  },
  {
    'kamykn/spelunker.vim',
    event = 'VimEnter',
    config = function()
      vim.g.enable_spelunker_vim = 1
      vim.g.spelunker_check_type = 2
    end,
  },
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    config = function()
      require('gitlinker').setup()
    end,
  }
}
