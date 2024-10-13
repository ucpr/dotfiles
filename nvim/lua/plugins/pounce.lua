return {
  'rlane/pounce.nvim',
  keys = {
    { "s", ":Pounce<CR>" },
  },
  config = function()
    require 'pounce'.setup {}

    vim.cmd [[
      highlight PounceUnmatched  ctermfg=248 guifg=#777777
    ]]
  end,
}
