--- lua_add {{{
vim.keymap.set("n", "T", '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
--- }}}

--- lua_post_source {{{
require 'FTerm'.setup({
  border     = 'double',
  dimensions = {
    height = 0.9,
    width = 0.9,
  },
})
--- }}}
