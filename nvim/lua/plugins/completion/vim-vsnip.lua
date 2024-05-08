--- lua_source {{{
vim.g.vsnip_snippet_dir = "$XDG_CONFIG_HOME/nvim/snippets"
--- }}}

--- lua_post_source {{{
vim.cmd [[
  autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
  autocmd BufWritePre <buffer> lua vim.lsp.buf.format({}, 10000)
]]
--- }}}
