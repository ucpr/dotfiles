return {
  'unblevable/quick-scope',
  event = 'VimEnter',
  setup = function()
    vim.cmd [[
      augroup qs_colors
        autocmd!
        autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
        autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
      augroup END
    ]]

    vim.g.qs_hi_priority = 2
    vim.g.qs_max_chars = 80
    vim.g.qs_lazy_highlight = 0
    vim.g.qs_buftype_blacklist = { "terminal", "nofile" }
  end,
}
