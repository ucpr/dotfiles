return {
  'numToStr/FTerm.nvim',
  event = 'BufWinEnter',
  config = function()
    vim.keymap.set("n", "T", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    require 'FTerm'.setup({
      border     = 'double',
      dimensions = {
        height = 0.9,
        width = 0.9,
      },
    })
  end
}
