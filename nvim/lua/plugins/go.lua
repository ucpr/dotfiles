return {
  {
    'kyoh86/vim-go-coverage',
    ft = {'go'},
  },
  {
    'mattn/vim-goaddtags',
    ft = {'go'},
  },
  {
    'mattn/vim-goimpl',
    ft = {'go'},
  },
  {
    'mattn/vim-gomod',
    ft = {'go'},
  },
  {
    'mattn/vim-goimports',
    ft = {'go'},
    config = function()
      vim.g.goimports = 1
    end,
  },
}
